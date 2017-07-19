﻿
Функция ПолучитьТекстЗапросаПолученияСпискаТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура 
	|ИЗ
	|	Документ.Инвойс.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка
	|";
	
КонецФункции

Функция ПолучитьТекстЗапросаПолученияСпискаТоваровПакинг() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура 
	|ИЗ
	|	Документ.Инвойс.ТоварыПакинг
	|ГДЕ
	|	Ссылка = &ДокументСсылка
	|";
	
КонецФункции


Процедура СохранитьДанныеПоТаможне()
	
	Менеджер = РегистрыСведений.НоменклатураДляТаможни; 	
	
	// удалим записи регистра сведений с пустой упаковкой для текущего перечня товаров
 
	Запрос = Новый Запрос("	ВЫБРАТЬ
							|	Рег.Номенклатура,
							|	Рег.Упаковка,
							|	Рег.НоменклатураДляТаможни
							|ИЗ
							|	(ВЫБРАТЬ
							|		Номенклатура,
							|		Упаковка,
							|		НоменклатураДляТаможни
							|	ИЗ
							|		Документ.Инвойс.ТоварыПакинг
							|	ГДЕ
							|		Ссылка = &ДокументСсылка
							|		И Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) 
							|	) Пак
							|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
							|		(ВЫБРАТЬ
							|	    	Номенклатура,
							|			Упаковка,
							|			НоменклатураДляТаможни
							|		ИЗ
							|			РегистрСведений.НоменклатураДляТаможни
							|		ГДЕ
							|			Номенклатура В (" + ПолучитьТекстЗапросаПолученияСпискаТоваровПакинг() + ")
							|			И Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
							|		) Рег
							|	ПО Пак.Номенклатура = Рег.Номенклатура
							|");

	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);						
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Набор = Менеджер.СоздатьНаборЗаписей();
			Набор.Отбор.Номенклатура.Установить(Выборка.Номенклатура);
			Набор.Отбор.Упаковка.Установить(Выборка.Упаковка);
            Набор.Записать();
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого Строка Из ТоварыПакинг Цикл
		МенеджерЗаписи = Менеджер.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Строка);
		МенеджерЗаписи.Записать();
	КонецЦикла;
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Сумма		 	= Товары.Итог("Сумма") + ?(СуммаВключаетНДС,0,Товары.Итог("СуммаНДС"));
	ИтогоБрутто		= ТоварыПакинг.Итог("ВесБрутто");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	СохранитьДанныеПоТаможне();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Проведение
	                                     
//	ПроведенияДокументов.ЗаказыПоставщикам(ДополнительныеСвойства, Движения, Отказ);
//	ПроведенияДокументов.ТоварыПоставщиковВПути(ДополнительныеСвойства, Движения, Отказ);

	Если Не Отказ Тогда
		ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;
	
	// Запись
	
	Движения.Записать();
    КонтрольПроведения.ПроверитьЗаказыПоставщикам(ЭтотОбъект, Отказ, Заголовок);
	КонтрольПроведения.ПроверитьТоварыПоставщиковВПути(ЭтотОбъект, Отказ, Заголовок);
	
	// Установим статусы заказов
	
	Если 	Не Отказ И
			Не Заказы.УстановитьСостояниеЗаказовПоставщикуПриПроведении(Товары, "ЗаказПоставщику") Тогда
		Отказ = Истина; КонецЕсли;
                          
КонецПроцедуры
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка

	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриОтменеПроведенияДокумента(Ссылка);
	
	// Запись
	
	Движения.ТоварыПоставщиковВПути.Очистить();
	Движения.Записать();
	
	КонтрольПроведения.ПроверитьЗаказыПоставщикам(ЭтотОбъект, Отказ, Заголовок);
    КонтрольПроведения.ПроверитьТоварыПоставщиковВПути(ЭтотОбъект, Отказ, Заголовок);
	
	// Установим статусы заказов
	
	Если 	Не Отказ И
			Не Заказы.УстановитьСостояниеЗаказовПоставщикуПриПроведении(Товары, "ЗаказПоставщику") Тогда
		Отказ = Истина; КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда	
		Запрос = Новый Запрос("
			|ВЫБРАТЬ 
			|	Организация, Контрагент, Склад, ТипЦен, Валюта, УчитыватьНДС, СуммаВключаетНДС, ДатаПоступления
			|ИЗ
			|	Документ.ЗаказПоставщику
			|ГДЕ
			|	Ссылка = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		ВыборкаШапки = Запрос.Выполнить().Выбрать();
		Если ВыборкаШапки.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапки);
		КонецЕсли;
					
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Номенклатура,
		|	ЗаказПоставщику,
		|	Упаковка,
		|	Цена,
		|   СтавкаНДС,
		|	КоличествоОстаток	Количество,
		|	СуммаОстаток		Сумма	
		|ИЗ
		|	РегистрНакопления.ЗаказыПоставщикам.Остатки(, ЗаказПоставщику = &Ссылка)");
		Запрос.Параметры.Вставить("Ссылка", ДанныеЗаполнения);
		РезультатЗапроса = Запрос.Выполнить(); 
		Если НЕ РезультатЗапроса.Пустой() Тогда
			ЭтотОбъект.Товары.Загрузить(РезультатЗапроса.Выгрузить());
		КонецЕсли;
		
		ЭтотОбъект.РасчетВеса =  Перечисления.ВидыРасчетаВеса.ПоУпаковкам;
	КонецЕсли;
	
КонецПроцедуры

