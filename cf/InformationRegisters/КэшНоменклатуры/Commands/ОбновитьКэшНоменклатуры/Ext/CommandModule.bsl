﻿&НаСервере
Процедура ВыполнитьРегистрацию()

	РаботаСНоменклатурой.ОбновитьКэш();
	Возврат;
	
	Запрос = Новый Запрос("
		
	// Список товаров по всем акциям
	
	|ВЫБРАТЬ	Акц.Номенклатура, Акц.Акция, Акц.ТипЦен, МАКСИМУМ(Акц.НоваяЦена) ЦенаПоАкции, Уч.Участник
	|ПОМЕСТИТЬ	ТоварыПоАкции
	|ИЗ			РегистрСведений.Акция.СрезПоследних(&текДата) Акц
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ	РегистрСведений.УчастникиАкции.СрезПоследних(&текДата) Уч
	|ПО					Акц.Акция = Уч.Акция И Акц.Номенклатура = Уч.Номенклатура
	|
	|ГДЕ	Акц.Акция <> &ПустаяАкция И (Уч.Акция <> &ПустаяАкция ИЛИ Уч.Акция ЕСТЬ NULL) И ВариантСкидки = &ВариантСкидкиЦена
	|
	|СГРУППИРОВАТЬ ПО Акц.Номенклатура, Акц.Акция, Акц.ТипЦен, Уч.Участник
	|
	|ИНДЕКСИРОВАТЬ ПО Акц.Номенклатура, Акц.ТипЦен
	|;
	
	
	// Основной запрос
	
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Спр.Ссылка		 								Номенклатура,
	
	|	Цены.ТипЦен 									ТипЦен,
	|	Акции.Акция 									Акция,
	|	Акции.Участник 									Участник,
	|	МАКСИМУМ(ЕСТЬNULL(Акции.ЦенаПоАкции, Цены.Цена))	Цена,
	|	МАКСИМУМ(Цены.Цена)								ЦенаБезАкции,
	
	|	Ост.Склад										Склад,
	|	МАКСИМУМ(ЕСТЬNULL(Ост.КоличествоОстаток, 0))	Остаток,
	|	МАКСИМУМ(ЕСТЬNULL(Рез.КоличествоОстаток, 0))	Резерв	
	|ИЗ
	|	Справочник.Номенклатура Спр
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ	РегистрНакопления.ТоварыНаСкладах.Остатки(&текДата) КАК Ост
	|ПО					Спр.Ссылка = Ост.Номенклатура
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ	РегистрНакопления.ТоварыВРезерве.Остатки(&текДата) КАК Рез
	|ПО					Ост.Номенклатура = Рез.Номенклатура И Ост.Склад = Рез.Размещение
	|		
	|ЛЕВОЕ СОЕДИНЕНИЕ	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&текДата, Упаковка = &ПустаяУпаковка) КАК Цены
	|ПО					Спр.Ссылка = Цены.Номенклатура
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ	ТоварыПоАкции Акции
	|ПО 				Цены.Номенклатура = Акции.Номенклатура И Цены.ТипЦен = Акции.ТипЦен
	
	|ГДЕ Не Спр.ЭтоГруппа
	|
	|СГРУППИРОВАТЬ ПО Спр.Ссылка, Цены.ТипЦен, Акции.Акция, Акции.Участник, Ост.Склад
	|");   
	
	Запрос.УстановитьПараметр("ВариантСкидкиЦена", 	Перечисления.ВариантСкидки.Цена);
	Запрос.УстановитьПараметр("ПустаяАкция", 		Документы.Акция.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяУпаковка", 	Справочники.УпаковкиНоменклатуры.ПустаяСсылка());
	Запрос.УстановитьПараметр("текДата", 			ТекущаяДата());
		
	НаборВесьРегистр = РегистрыСведений.КэшНоменклатуры.СоздатьНаборЗаписей();
	НаборВесьРегистр.Загрузить(Запрос.Выполнить().Выгрузить());
	
	НаборВесьРегистр.Записать();

КонецПроцедуры
			
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	текВремя = ТекущаяДата();
	ПоказатьОповещениеПользователя("Обновление кэша",,"Запущена медленная процедура обновление всего кэша");
	ВыполнитьРегистрацию();
	
	ПоказатьОповещениеПользователя("Обновление кэша",,"Выполнено! за " + Строка(ТекущаяДата() - текВремя) + " сек.");
	
КонецПроцедуры
