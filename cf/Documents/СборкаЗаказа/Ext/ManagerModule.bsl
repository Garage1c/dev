﻿
Процедура ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства) Экспорт
	
	Если НЕ ПроведенияДокументов.РазрешеноПерепроводитьДокумент(Ссылка) Тогда
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос(
	
	// ПАРАМЕТРЫ СИСТЕМЫ
	
	КэшируемыеФункции.ТектЗапросаПолученияПараметровСистемы() + "
	|;
	
	// ШАПКА
	
	|ВЫБРАТЬ
	|	Заказ, Склад
	|ИЗ
	|	Документ.СборкаЗаказа
	|ГДЕ
	|	Ссылка = &Ссылка
	|;
	
	
	// ТОВАРЫ В СБОРКЕ
	
	|ВЫБРАТЬ
	|	&Период				КАК Период,
	|	&ВидДвиженияПриход	КАК ВидДвижения,
	|	Ссылка.Склад			Склад,
	
	|	Ссылка.Заказ		КАК Заказ,
	|	Номенклатура	    КАК Номенклатура,
	|	Упаковка			КАК Упаковка,
	|	СУММА(ВСборке)		КАК Количество
	|ИЗ
	|	Документ.СборкаЗаказа.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР КОГДА СкладЯчейка ССЫЛКА Справочник.Ячейки ТОГДА СкладЯчейка.Владелец ИНАЧЕ СкладЯчейка КОНЕЦ,
	|	Ссылка,
	|	Номенклатура,
	|	Упаковка
	|ИМЕЮЩИЕ СУММА(ВСборке) <> 0
	|;");
	
	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.УстановитьПараметр("Заказ", 				Ссылка.Заказ);
	Запрос.УстановитьПараметр("Период", 			Ссылка.Дата);
	Запрос.УстановитьПараметр("ВидДвиженияПриход", 	ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("ВидДвиженияРасход", 	ВидДвиженияНакопления.Расход);
	Запрос.УстановитьПараметр("ПустойСборщик", 		Справочники.ФизическиеЛица.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяЯчейка", 		Справочники.Ячейки.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяУпаковка", 	Справочники.УпаковкиНоменклатуры.ПустаяСсылка());	
	
	Пакет = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.Вставить("ПараметрыСистемы", 		КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[0].Выгрузить()));
	ДополнительныеСвойства.Вставить("Шапка", 					КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[1].Выгрузить()));
	ДополнительныеСвойства.Вставить("ТоварыВСборке", 			Пакет[2].Выгрузить());
	
КонецПроцедуры

//Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
//	СтандартнаяОбработка = Ложь;
//	Представление = ?(Данные.Ссылка.ТипЗаказаНаСборку = ПредопределенноеЗначение("Перечисление.ТипыЗаказовНаСборку.ЗаказНаРазборку"),"Заказ на разборку","Заказ на сборку") + " " + Данные.Номер + " от " + Данные.Дата ;
//КонецПроцедуры
