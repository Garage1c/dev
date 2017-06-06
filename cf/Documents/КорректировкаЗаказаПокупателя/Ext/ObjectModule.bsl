﻿
Функция ПолучитьТекстЗапросаПолученияСпискаТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ	Номенклатура
	|ИЗ		Документ.КорректировкаЗаказаПокупателя.Товары
	|ГДЕ	Ссылка = &ДокументСсылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ	Номенклатура
	|ИЗ		Документ.КорректировкаЗаказаПокупателя.РазмещениеТоваров
	|ГДЕ	Ссылка = &ДокументСсылка
	|";
	
КонецФункции
Функция ПолучитьТекстЗапросаПолученияСпискаРезервируемыхТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура
	|ИЗ
	|	Документ.КорректировкаЗаказаПокупателя.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка И
	|	ЕСТЬNULL(Размещение, &ПустойСклад) <> &ПустойСклад
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ	Номенклатура
	|ИЗ		Документ.КорректировкаЗаказаПокупателя.РазмещениеТоваров
	|ГДЕ	Ссылка = &ДокументСсылка И
	|		ЕСТЬNULL(Размещение, &ПустойСклад) <> &ПустойСклад
	|";
	
КонецФункции
Функция ПолучитьТекстЗапросаПолученияТаблицыРезервируемыхТоваров() Экспорт
	
	// Запрос для соединения должен содержать поля (Товар, Размещение, Количество)
	
	Возврат "
	|ВЫБРАТЬ
	|	Номенклатура, Размещение, СУММА(Количество) КАК Количество
	|ИЗ
	|	Документ.КорректировкаЗаказаПокупателя.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка И
	|	ЕСТЬNULL(Размещение, &ПустойСклад) <> &ПустойСклад
	|
	|СГРУППИРОВАТЬ ПО Номенклатура, Размещение
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ Номенклатура, Размещение, СУММА(Количество)
	|ИЗ		Документ.КорректировкаЗаказаПокупателя.РазмещениеТоваров
	|ГДЕ	Ссылка = &ДокументСсылка И
	|		ЕСТЬNULL(Размещение, &ПустойСклад) <> &ПустойСклад
	|
	|СГРУППИРОВАТЬ ПО Номенклатура, Размещение
	|";
	
КонецФункции



Процедура ОбработкаПроведения(Отказ, Режим)
   
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Проведение
	                                     
	ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	
	// Запись
	
	Движения.Записать();
	
	// Контроль
	
	КонтрольПроведения.ПроверитьПоВсемРегистрам(ЭтотОбъект, Отказ, Заголовок);
	КонтрольПроведения.ПроверитьТоварыНаСкладах(ЭтотОбъект,, Отказ, Заголовок);
	//КонтрольПроведения.ПроверитьЛимиты(ЭтотОбъект, Заказ.ОтветственноеЛицо, Отказ, Заголовок);

	// Установим статус оплаты
	
	Если 	Не Отказ И
			Не Заказы.ПроверитьИУстановитьСтатусОплатыЗаказа(Заказ) Тогда
			
		Отказ = Истина; КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Сумма = Товары.Итог("Сумма") + ?(Заказ.СуммаВключаетНДС,0,Товары.Итог("СуммаНДС"));
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	ПроведенияДокументов.ОчиститьДвиженияДокумента(Метаданные().Движения, Движения);
	
	// Контроль
	
	КонтрольПроведения.ПроверитьПоВсемРегистрам(ЭтотОбъект, Отказ, Заголовок);
	КонтрольПроведения.ПроверитьТоварыНаСкладах(ЭтотОбъект,, Отказ, Заголовок, );
	

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипЗнч = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипЗнч = Тип("Структура") Тогда
		
		КонвертацияТипов.ЗаполнитьОбъектПоСтруктуреОснованию(ЭтотОбъект, ДанныеЗаполнения); КонецЕсли;
	
КонецПроцедуры
