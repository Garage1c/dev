﻿
Процедура ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос(
	
	// ПАРАМЕТРЫ СИСТЕМЫ
	
	КэшируемыеФункции.ТектЗапросаПолученияПараметровСистемы() + "
	|;
	
	// ШАПКА
	
	|ВЫБРАТЬ
	|	Склад
	|ИЗ
	|	Документ.СборочныйЛист
	|ГДЕ
	|	Ссылка = &Ссылка
	|;
	
	// ТОВАРЫ В ЯЧЕЙКАХ
	
	|ВЫБРАТЬ
	|	&Период Период, &ВидДвиженияРасход ВидДвижения,
	|	Номенклатура, Ячейка, Сборщик,
	|	ВЫБОР КОГДА Упаковка = &ПустаяУпаковка ТОГДА СУММА(Количество + НеНайдено)
	|	ИНАЧЕ СУММА((Количество + НеНайдено) * Упаковка.Коэффициент) КОНЕЦ Количество
	|ИЗ
	|	Документ.СборочныйЛист.Товары
	|
	|ГДЕ	Ссылка = &Ссылка И
	|		Ячейка <> &ПустаяЯчейка
	|		И Ссылка.ТипСборочногоЛиста <> Значение(Перечисление.ТипыСборочныхЛистов.ФиксацияЯчеек)
	|
	|СГРУППИРОВАТЬ ПО Номенклатура, Ячейка, Упаковка, Сборщик
	|ИМЕЮЩИЕ СУММА(Количество + НеНайдено) > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период, &ВидДвиженияПриход,
	|	Номенклатура, &ЯчейкаНеНайдено, Сборщик,
	|	ВЫБОР КОГДА Упаковка = &ПустаяУпаковка ТОГДА СУММА(НеНайдено)
	|	ИНАЧЕ СУММА(НеНайдено * Упаковка.Коэффициент) КОНЕЦ
	|ИЗ
	|	Документ.СборочныйЛист.Товары
	|
	|ГДЕ	Ссылка = &Ссылка 
	|		И Ячейка <> &ПустаяЯчейка 
	|		И Ссылка.ТипСборочногоЛиста <> Значение(Перечисление.ТипыСборочныхЛистов.ФиксацияЯчеек)
	|
	|СГРУППИРОВАТЬ ПО Номенклатура, Ячейка, Упаковка, Сборщик
	|ИМЕЮЩИЕ СУММА(НеНайдено) > 0
	|;
	
	// СБОРЩИК ТОВАРА
	
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Ссылка.ДатаСборки = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА &Период
	|		ИНАЧЕ Ссылка.ДатаСборки
	|	КОНЕЦ 				КАК Период,
	|	Сборщик				КАК Сборщик,
	|	Заказ,
	|	Ссылка				СборочныйЛист,
	|	Номенклатура		КАК Номенклатура,
	|	Упаковка			КАК Упаковка,
	|	Ссылка.Склад		КАК Склад,
	|   Ячейка,		
	|	СУММА(ВЫБОР КОГДА Количество + НеНайдено > 0 ТОГДА 1 ИНАЧЕ 0 КОНЕЦ)	КАК Количество
	|ИЗ
	|	Документ.СборочныйЛист.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка 
	|		И Ссылка.ТипСборочногоЛиста <> Значение(Перечисление.ТипыСборочныхЛистов.ФиксацияЯчеек)
	|
	|СГРУППИРОВАТЬ ПО
	|	Ссылка,
	|	Сборщик,
	|	Заказ,
	|	Номенклатура,
	|	Упаковка,
	|	Ячейка
	|ИМЕЮЩИЕ СУММА(ВЫБОР КОГДА Количество + НеНайдено > 0 ТОГДА 1 ИНАЧЕ 0 КОНЕЦ) > 0
	|;
	
	// ТОВАРЫ В СБОРКЕ
	
	|ВЫБРАТЬ
	|	&Период				КАК Период,
	|	&ВидДвиженияРасход	КАК ВидДвижения,
	|	Ссылка.Склад 		КАК Склад,
	|	Заказ,
	|	Номенклатура	    КАК Номенклатура,
	|	Упаковка			КАК Упаковка,
	|	СУММА(Собрать)   	КАК Количество
	|ИЗ
	|	Документ.СборочныйЛист.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка 
	|		И Ссылка.ТипСборочногоЛиста <> Значение(Перечисление.ТипыСборочныхЛистов.ФиксацияЯчеек)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР КОГДА Ячейка = &ПустаяЯчейка ТОГДА Ссылка.Склад ИНАЧЕ Ячейка КОНЕЦ,
	|	Ссылка,
	|	Заказ,
	|	Номенклатура,
	|	Упаковка,
	|	Сборщик
	|;

	// ТОВАРЫ СОБРАННЫЕ
	
	|ВЫБРАТЬ
	|	&Период				КАК Период,
	|	&ВидДвиженияПриход	КАК ВидДвижения,
	|	Ссылка				КАК СборочныйЛист,
	|	Ссылка.Склад		КАК Склад,
	|	Заказ,
	|	Номенклатура	    КАК Номенклатура,
	|	Упаковка			КАК Упаковка,
	|	Сборщик,
	|	СУММА(Количество) Количество
	|ИЗ
	|	Документ.СборочныйЛист.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка И Количество > 0 
	|		И Ссылка.ТипСборочногоЛиста <> Значение(Перечисление.ТипыСборочныхЛистов.ФиксацияЯчеек)
	|
	|СГРУППИРОВАТЬ ПО
	|	Ссылка,
	|	Заказ,
	|	Номенклатура,
	|	Упаковка,
	|	Сборщик
	|;
	
	// РЕЗЕРВ ТОВАРОВ
	
	|ВЫБРАТЬ
	|	&Период				КАК Период,
	|	&ВидДвиженияРасход	КАК ВидДвижения,
	|	Ссылка.Склад		КАК Размещение,
	|	Заказ КАК ДокументРезерва,
	|	Номенклатура	    КАК Номенклатура,
	|	СУММА(НеНайдено) Количество
	|ИЗ
	|	Документ.СборочныйЛист.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка И НеНайдено > 0
	|		И Ссылка.ТипСборочногоЛиста <> Значение(Перечисление.ТипыСборочныхЛистов.ФиксацияЯчеек)
	|
	|СГРУППИРОВАТЬ ПО
	|	Заказ, Ссылка, Номенклатура
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период				КАК Период,
	|	&ВидДвиженияПриход	КАК ВидДвижения,
	|	Ссылка.Склад		КАК Размещение,
	|	&ЗаказПотеряшек		КАК ДокументРезерва,
	|	Номенклатура	    КАК Номенклатура,
	|	СУММА(НеНайдено) Количество
	|ИЗ
	|	Документ.СборочныйЛист.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка И НеНайдено > 0 
	|		И Ссылка.ТипСборочногоЛиста <> Значение(Перечисление.ТипыСборочныхЛистов.ФиксацияЯчеек)
	|
	|СГРУППИРОВАТЬ ПО
	|	Ссылка, Номенклатура
	|;
	
	// РезервыВЯчейках
	
	|ВЫБРАТЬ
	|	&Период				КАК Период,
	|	&ВидДвиженияПриход	КАК ВидДвижения,
	|	Ссылка				КАК СборочныйЛист,
	|	Заказ,
	|	Номенклатура	    КАК Номенклатура,
	|	Ячейка			    КАК Ячейка,
	|	Собрать				КАК Количество
	|ИЗ
	|	Документ.СборочныйЛист.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка И Количество > 0 
	|		И Ссылка.ТипСборочногоЛиста = Значение(Перечисление.ТипыСборочныхЛистов.ФиксацияЯчеек)
	|		И Ячейка <> Значение(Справочник.Ячейки.ПустаяСсылка)
	|");
	
	//Запрос.УстановитьПараметр("Область", 			ПараметрыСеанса.ТекущаяОбласть);
	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.УстановитьПараметр("Период", 			Ссылка.Дата);
	Запрос.УстановитьПараметр("ВидДвиженияПриход", 	ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("ВидДвиженияРасход", 	ВидДвиженияНакопления.Расход);
	Запрос.УстановитьПараметр("ПустаяЯчейка", 		Справочники.Ячейки.ПустаяСсылка());
	Запрос.УстановитьПараметр("ЯчейкаНеНайдено", 	Ссылка.Склад.ЯчейкаНеНайдено);
	Запрос.УстановитьПараметр("ПустаяУпаковка", 	Справочники.УпаковкиНоменклатуры.ПустаяСсылка());
	Запрос.УстановитьПараметр("ЗаказПотеряшек", 	Константы.ЗаказРезервПотеряшек.Получить());
	
	Пакет = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.Вставить("ПараметрыСистемы", КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[0].Выгрузить()));
	ДополнительныеСвойства.Вставить("Шапка", 			КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[1].Выгрузить()));
	ДополнительныеСвойства.Вставить("ТоварыВЯчейках", 	Пакет[2].Выгрузить());
	ДополнительныеСвойства.Вставить("СборщикЗаказа", 	Пакет[3].Выгрузить());
	ДополнительныеСвойства.Вставить("ТоварыВСборке", 	Пакет[4].Выгрузить());
	ДополнительныеСвойства.Вставить("ТоварыСобранные", 	Пакет[5].Выгрузить());
	ДополнительныеСвойства.Вставить("ТоварыВРезерве", 	Пакет[6].Выгрузить());
	ДополнительныеСвойства.Вставить("РезервыВЯчейках", 	Пакет[7].Выгрузить());
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	//Представление = "Сборочный лист " + ?(Данные.Ссылка.ТипСборочногоЛиста = ПредопределенноеЗначение("Перечисление.ТипыСборочныхЛистов.ФиксацияЯчеек"),"(фиксация ячеек)","") + " " + Данные.Номер + " от " + Данные.Дата ;
	Представление = "Сборочный лист " + ?(Данные.ТипСборочногоЛиста = ПредопределенноеЗначение("Перечисление.ТипыСборочныхЛистов.ФиксацияЯчеек"),"(фиксация ячеек)","") + " " + Данные.Номер + " от " + Данные.Дата;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
	Поля.Добавить("ТипСборочногоЛиста");
	
КонецПроцедуры
