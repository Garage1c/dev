﻿Функция ПолучитьСкладСписания() Экспорт Возврат Склад КонецФункции

Функция ПолучитьТекстЗапросаПолученияСпискаТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура
	|ИЗ
	|	Документ.ОприходованиеТоваров.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка
	|";
	
КонецФункции


// ПРЕДОПРЕДЕЛЕННЫЕ ФУНКЦИИ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Последовательности
	
	//avdonin {{12.09.2010#
	//
	ПроведенияДокументов.ПоследовательностьОстаткиТоваров(ДополнительныеСвойства, ПринадлежностьПоследовательностям, Отказ);
	//}}avdonin
	
	// Проведение
	
	ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	
	// Запись
	
	Движения.Записать();
	
	// Контроль
	
	КонтрольПроведения.ПроверитьПоВсемРегистрам(ЭтотОбъект, Отказ, Заголовок);
	
	//avdonin {{21.09.2010#
	//
	//Если РежимПроведения = РежимПроведенияДокумента.Оперативный Тогда
	//	КонтрольПроведения.ПроверитьТоварыНаСкладах(ЭтотОбъект, Склад, Отказ, Заголовок);
	//Иначе
	//	КонтрольПроведения.ПроверитьТоварыНаСкладахНЕОперативно(ЭтотОбъект, Отказ, Заголовок);
	//КонецЕсли;
	////}}avdonin
	//
	//КонтрольПроведения.ПроверитьПартииТоваров(ЭтотОбъект, Склад, Отказ, Заголовок);
	
	// Обновим кэш
	Если 	Не Отказ И
			Не РаботаСНоменклатурой.ОбновитьКэш(,ПолучитьТекстЗапросаПолученияСпискаТоваров(), Новый Структура("ДокументСсылка", Ссылка)) Тогда
			
		Отказ = Истина; КонецЕсли;
	
КонецПроцедуры
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка

	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриОтменеПроведенияДокумента(Ссылка);
	
	//avdonin {{12.09.2010#
	// надо опять инициализировать доп. свойства для контроля остатка (чтобы тянуть информацию только по тем остаткам, которые изменялись)
	// в контроле по идее имеет смысл указывать, что это отмена проведения или передавать движения
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	//}}avdonin
	
	// Последовательности
	
	//avdonin {{12.09.2010#
	// последний параметр - признак отмены проведения
	ПроведенияДокументов.ПоследовательностьОстаткиТоваров(ДополнительныеСвойства, ПринадлежностьПоследовательностям, Отказ, Истина);
	//}}avdonin
	
	//КонтрольПроведения.ПроверитьПартииТоваров(ЭтотОбъект, Склад, Отказ, Заголовок);
	
	// Запись
	
	Движения.ТоварыНаСкладах.Очистить();
	Движения.Записать();
	
	// Контроль
	
	КонтрольПроведения.ПроверитьПоВсемРегистрам(ЭтотОбъект, Отказ, Заголовок);
	
	//КонтрольПроведения.ПроверитьТоварыНаСкладах(ЭтотОбъект, Склад, Отказ, Заголовок);
	//
	////avdonin {{22.09.2010#
	//// выше правда делается оперативный контроль
	//КонтрольПроведения.ПроверитьТоварыНаСкладахНЕОперативно(ЭтотОбъект, Отказ, Заголовок, Истина);
	////}}avdonin
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипЗнч = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипЗнч = Тип("БизнесПроцессСсылка.ЯчеестаяИнвентаризация") Тогда
		
		Процесс = ДанныеЗаполнения;
		Склад 	= ДанныеЗаполнения.Склад;
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ	Ячейка, Номенклатура, СУММА(КоличествоФакт - КоличествоУчет) Количество
		|ИЗ 		БизнесПроцесс.ЯчеестаяИнвентаризация.Товары
		|ГДЕ		Ссылка = &Ссылка
		|СГРУППИРОВАТЬ ПО Ячейка, Номенклатура
		|ИМЕЮЩИЕ СУММА(КоличествоФакт - КоличествоУчет) > 0
		|");
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		Товары.Загрузить(Запрос.Выполнить().Выгрузить());
		
	ИначеЕсли ТипЗнч = Тип("ДокументСсылка.Инвентаризация") Тогда
		
		Инвентаризация 	= ДанныеЗаполнения;
		Склад 			= ДанныеЗаполнения.Склад;
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ	Номенклатура, Ячейка, СУММА(Количество - КоличествоУчет) Количество
		|ИЗ 		Документ.Инвентаризация.Товары
		|ГДЕ		Ссылка = &Ссылка
		|СГРУППИРОВАТЬ ПО Номенклатура, Ячейка
		|ИМЕЮЩИЕ СУММА(Количество - КоличествоУчет) > 0
		|");
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		Товары.Загрузить(Запрос.Выполнить().Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Склад.Ячеестый Тогда ПроверяемыеРеквизиты.Добавить("Товары.Ячейка") КонецЕсли;
	
КонецПроцедуры


