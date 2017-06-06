﻿
Процедура ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос(
	
	КэшируемыеФункции.ТектЗапросаПолученияПараметровСистемы() + "
	
	|;
	
	// ШАПКА
	
	|ВЫБРАТЬ
	|	Склад, Контрагент
	|ИЗ
	|	Документ.ВозвратПоставщику
	|ГДЕ
	|	Ссылка = &Ссылка
	|;
	
	// ТОВАРЫ НА СКЛАДАХ
	
	|ВЫБРАТЬ
	|	&Период				КАК Период,
	|	&ВидДвиженияРасход	КАК ВидДвижения,
	|	Ссылка.Склад		КАК Склад,
	|	Номенклатура,
	|	Цена,
	|	ВЫБОР 
	|		КОГДА Упаковка = &ПустаяУпаковка 
	|		ТОГДА СУММА(Количество)
	|		ИНАЧЕ СУММА(Количество*Упаковка.Коэффициент) КОНЕЦ	Количество,
    |	СУММА(Сумма)		КАК Сумма
	|ИЗ
	|	Документ.ВозвратПоставщику.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Ссылка,
	|	Номенклатура,
	|	Упаковка,
	|	Цена
	|;
	
	// ВЗАИМОРАСЧЕТЫ
	
	|ВЫБРАТЬ
	|	&Период				КАК Период,
	|	&ВидДвиженияРасход	КАК ВидДвижения,
	|	Ссылка.Партнер		КАК Партнер,
	|	Ссылка.Контрагент	КАК Контрагент,
	|	Ссылка.Организация 	КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ФормаОтношений.Поставщик) 	ФормаОтношений,		
	|	-СУММА(Сумма)		КАК Сумма,
	|   -СУММА(Сумма)		КАК СуммаУпр
	|ИЗ
	|	Документ.ВозвратПоставщику.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Ссылка
	|;
	
	// ЯЧЕЙКИ
	
	|ВЫБРАТЬ
	|	&Период				КАК Период,
	|	&ВидДвиженияРасход	КАК ВидДвижения,
	|	Ячейка				КАК Ячейка,
	|	Номенклатура,
	|	ВЫБОР КОГДА Упаковка = &ПустаяУпаковка ТОГДА
	|		СУММА(Количество)
	|	ИНАЧЕ
	|		СУММА(Количество*Упаковка.Коэффициент)
	|	КОНЕЦ				КАК Количество
    |ИЗ
	|	Документ.ВозвратПоставщику.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка И
	|	Ячейка <> &ПустаяЯчейка
	|
	|СГРУППИРОВАТЬ ПО
	|	Ячейка,
	|	Номенклатура,
	|	Упаковка
	|;
	
	// ДОЛГИ КОНТРАГЕНТОВ
	
	//|ВЫБРАТЬ 
	//|	&ВидОперацииОплата ВидОперации, &ФормаОтношений ФормаОтношений, Док.Организация, Док.Контрагент, Ссылка Документ, Док.Дата Дата, Док.Дата Период,
	//|	ЕСТЬNULL(СуммаУпрОстаток, 0) - Док.Сумма * (ЕСТЬNULL(ВалЦен.Курс, 1) * ЕСТЬNULL(ВалУпр.Кратность, 1)) / (ЕСТЬNULL(ВалУпр.Курс, 1) * ЕСТЬNULL(ВалЦен.Кратность, 1)) КАК Сумма
	//|ИЗ
	//|	РегистрНакопления.Взаиморасчеты.Остатки(&Период, Организация = &Организация И Контрагент = &Контрагент)
	//|
	//|ПРАВОЕ СОЕДИНЕНИЕ
	//|	(ВЫБРАТЬ Дата, Организация, Контрагент, Ссылка, Сумма ИЗ Документ.ВозвратПоставщику ГДЕ Ссылка = &Ссылка) Док
	//|ПО ИСТИНА
	//|
	//|ЛЕВОЕ СОЕДИНЕНИЕ 
	//|	РегистрСведений.КурсыВалют.СрезПоследних(, ) ВалЦен
	//|	ПО	Ссылка.Валюта = ВалЦен.Валюта
	//|ЛЕВОЕ СОЕДИНЕНИЕ 
	//|	РегистрСведений.КурсыВалют.СрезПоследних(, Валюта В (ВЫБРАТЬ Значение ИЗ Константа.ВалютаУправленческогоУчета)) ВалУпр
	//|	ПО	ИСТИНА;
	
	// ПАРТИИ ТОВАРОВ
	|ВЫБРАТЬ неопределено ГДЕ Истина=Ложь
	//|ВЫБРАТЬ
	//|	&Период				КАК Период,
	//|	&ВидДвиженияРасход	КАК ВидДвижения,
	//|	Ссылка.Склад Склад, Партия, Номенклатура,
	//|	ВЫБОР КОГДА Упаковка = &ПустаяУпаковка ТОГДА
	//|		СУММА(Количество)
	//|	ИНАЧЕ
	//|		СУММА(Количество*Упаковка.Коэффициент)
	//|	КОНЕЦ				КАК Количество,
	//|	СУММА(СуммаПартии) 	КАК Сумма
	//|ИЗ
	//|	Документ.ВозвратПоставщику.Товары
	//|
	//|ГДЕ
	//|	Ссылка = &Ссылка И СуммаПартии <> 0
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	Ссылка, Партия, Номенклатура, Упаковка
	|");
	
	//Запрос.УстановитьПараметр("Область", 			ПараметрыСеанса.ТекущаяОбласть);
	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.УстановитьПараметр("Период", 			Ссылка.Дата);
	Запрос.УстановитьПараметр("ВидДвиженияПриход", 	ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("ВидДвиженияРасход", 	ВидДвиженияНакопления.Расход);
	Запрос.УстановитьПараметр("ПустаяЯчейка", 		Справочники.Ячейки.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяУпаковка", 	Справочники.УпаковкиНоменклатуры.ПустаяСсылка());

	Запрос.УстановитьПараметр("Организация", 		Ссылка.Организация);
	Запрос.УстановитьПараметр("Контрагент", 		Ссылка.Контрагент);
	Запрос.УстановитьПараметр("ВидОперацииОплата", 	Перечисления.ВидыОперацийВзаиморасчетов.Отгрузка);
	Запрос.УстановитьПараметр("ФормаОтношений", 	Перечисления.ФормаОтношений.Поставщик);
	
	Пакет = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.Вставить("ПараметрыСистемы", КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[0].Выгрузить()));
	ДополнительныеСвойства.Вставить("Шапка", 			КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[1].Выгрузить()));
	ДополнительныеСвойства.Вставить("ТоварыНаСкладах", 	Пакет[2].Выгрузить());
	ДополнительныеСвойства.Вставить("Взаиморасчеты", 	Пакет[3].Выгрузить());
	ДополнительныеСвойства.Вставить("ТоварыВЯчейках", 	Пакет[4].Выгрузить());
	//ДополнительныеСвойства.Вставить("ДолгиКонтрагентов",Пакет[5].Выгрузить());
	//ДополнительныеСвойства.Вставить("ПартииТоваров",Пакет[6].Выгрузить());
	
КонецПроцедуры

Функция ПолучитьТаблицуКурсовВалют(МассивДокументов)
	
	ВалютаРегламентированногоУчета = ОбщиеФункции.ПолучитьЗначениеКонстантыВОбласти("ВалютаУправленческогоУчета");
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НАЧАЛОПЕРИОДА(Док.Дата, ДЕНЬ) КАК Дата,
		|	Док.Валюта КАК Валюта
		|ИЗ
		|	Документ.ВозвратПоставщику КАК Док
		|ГДЕ
		|	Док.Ссылка В(&МассивДокументов)
		|	И Док.Валюта <> &ВалютаРегламентированногоУчета
		|
		|УПОРЯДОЧИТЬ ПО
		|	Валюта,
		|	Дата
		|");
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета);
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	ТаблицаКурсовВалют = Новый ТаблицаЗначений;
	ТаблицаКурсовВалют.Колонки.Добавить("Валюта",    Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	ТаблицаКурсовВалют.Колонки.Добавить("Дата",      Новый ОписаниеТипов("Дата"));
	ТаблицаКурсовВалют.Колонки.Добавить("Курс",      Новый ОписаниеТипов("Число"));
	ТаблицаКурсовВалют.Колонки.Добавить("Кратность", Новый ОписаниеТипов("Число"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТаблицаКурсовВалют.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		КурсыВалюты = ОбщиеФункции.ПолучитьКурсВалюты(Выборка.Валюта, Выборка.Дата);
		НоваяСтрока.Курс = КурсыВалюты.Курс;
		НоваяСтрока.Кратность = КурсыВалюты.Кратность;
		
	КонецЦикла;
	
	Возврат ТаблицаКурсовВалют;
	
КонецФункции // ПолучитьТаблицуКурсовВалют()
Функция ПолучитьДанныеДляТОРГ12(ТабличныйДокумент, Ссылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КолонкаКодов = "Артикул";
	
	Запрос = Новый Запрос("
	|////////////////////////////////////////////////////////////////////////////
	|// ВРЕМЕННАЯ ТАБЛИЦА НоменклатураДокументов
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	МАКСИМУМ(
	|		ВЫБОР КОГДА Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга) ТОГДА
	|			Истина
	|		ИНАЧЕ
	|			Ложь
	|		КОНЕЦ
	|	) КАК ЕстьУслуги,
	|	МАКСИМУМ(
	|		ВЫБОР КОГДА Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга) ТОГДА
	|			Истина
	|		ИНАЧЕ
	|			Ложь
	|		КОНЕЦ
	|	)КАК ЕстьТовары
	|
	|ПОМЕСТИТЬ НоменклатураДокументов
	|ИЗ
	|	Документ.ВозвратПоставщику.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	
	|СГРУППИРОВАТЬ ПО
	|	Товары.Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////
	|// ЗАПРОС ПО ШАПКЕ
	|
	|ВЫБРАТЬ
	|   ЕСТЬNULL(НоменклатураДокументов.ЕстьУслуги, Ложь)						   КАК ЕстьУслуги,
	|    ЕСТЬNULL(НоменклатураДокументов.ЕстьТовары, Ложь)						   КАК ЕстьТовары,
	|	Док.Ссылка                                              КАК Ссылка,   
	|	Док.Номер                                               КАК Номер,
	|	Док.Дата                                                КАК Дата,
	|	Док.Партнер                                             КАК Партнер,
	|	Док.Контрагент                                          КАК Контрагент,
	|	Док.Организация                                         КАК Организация,
	|	""Поступление""                                         КАК ТипОснования,
	|	Док.ДокументПоступления								  	КАК Основание,
	|	ЕСТЬNULL(Рук.ФизическоеЛицо.Наименование, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))           КАК Руководитель,
	|	ЕСТЬNULL(Рук.Должность, """")                                                                         КАК ДолжностьРуководителя,
	|	ЕСТЬNULL(Бух.ФизическоеЛицо.Наименование, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))           КАК ГлавныйБухгалтер,
	|	ЕСТЬNULL(Рук.ФизическоеЛицо.Наименование, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))           КАК Кладовщик,
	|	ЕСТЬNULL(Рук.Должность, """")                                      									  КАК ДолжностьКладовщика,   
	|
	|	ВЫБОР КОГДА Док.Грузополучатель В (Неопределено,ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка),ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),Значение(Справочник.Грузополучатели.ПустаяСсылка))
	|	ТОГДА	Док.Контрагент
	|	ИНАЧЕ 	Док.Грузополучатель
	|	КОНЕЦ	Грузополучатель,
	|
	|	ВЫБОР КОГДА Док.Грузоотправитель В (Неопределено,ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка),ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),Значение(Справочник.Грузополучатели.ПустаяСсылка))
	|	ТОГДА	Док.Организация
	|	ИНАЧЕ	Док.Грузоотправитель
	|	КОНЕЦ	Грузоотправитель,
	|
	|	Док.БанковскийСчетОрганизации                             КАК БанковскийСчетОрганизации,
	|	Док.БанковскийСчетПартнера                            	  КАК БанковскийСчетКонтрагента,
	|	Док.БанковскийСчетГрузоотправителя                        КАК БанковскийСчетГрузоотправителя,
	|	Док.БанковскийСчетГрузополучателя                         КАК БанковскийСчетГрузополучателя,
	|	Док.Валюта         						                  КАК Валюта,
	|	Док.СуммаВключаетНДС                                      КАК ЦенаВключаетНДС,
	|	Неопределено                                              КАК Подразделение,
	|	""""								                      КАК АдресДоставки,
	|	""""                                     				  КАК ДоверенностьНомер,
	|	ДАТАВРЕМЯ(1,1,1,0,0,0)                                    КАК ДоверенностьДата,
	|	""""                                   					  КАК ДоверенностьВыдана,
	|	""""                                     				  КАК ДоверенностьЛицо,
	|	ВЫБОР КОГДА НЕ Док.Плательщик = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	ТОГДА Док.Плательщик		
	|	ИНАЧЕ 	ВЫБОР КОГДА Док.Грузополучатель В (Неопределено,ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка),ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),Значение(Справочник.Грузополучатели.ПустаяСсылка))
	|	            ТОГДА	Док.Контрагент
	|	            ИНАЧЕ 	Док.Грузополучатель
	|	КОНЕЦ КОНЕЦ	                                               Плательщик
	|ИЗ
	|	Документ.ВозвратПоставщику КАК Док
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтветственныеЛицаОрганизации.СрезПоследних(&Дата, ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизации.ГлавныйБухгалтер)) Бух
	|	ПО Док.Организация = Бух.Организация
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтветственныеЛицаОрганизации.СрезПоследних(&Дата, ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизации.Руководитель)) Рук
	|	ПО Док.Организация = Рук.Организация
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		НоменклатураДокументов КАК НоменклатураДокументов
	|	ПО
	|		Док.Ссылка = НоменклатураДокументов.Ссылка
	|ГДЕ
	|	Док.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////
	|// ЗАПРОС ПО ТАБЛИЧНЫМ ЧАСТЯМ
	|
	|ВЫБРАТЬ
	|	Товары.Ссылка                                                     КАК Ссылка,
	|	Товары.Номенклатура                                               КАК Номенклатура,
	|	Товары.Номенклатура.НаименованиеПолное                            КАК ТоварНаименование,
	|	Товары.Номенклатура." + КолонкаКодов + "                          КАК ТоварКод,
	|	ВЫБОР КОГДА Товары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) ТОГДА
	|		Товары.Номенклатура.ЕдиницаИзмерения.Наименование    
	|	ИНАЧЕ
	|		ПРЕДСТАВЛЕНИЕ(Товары.Упаковка)
	|	КОНЕЦ  														  	  КАК БазоваяЕдиницаНаименование,
	|	ВЫБОР КОГДА Товары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) ТОГДА
	|		Товары.Номенклатура.ЕдиницаИзмерения.Код    
	|	ИНАЧЕ
	|		""""
	|	КОНЕЦ 														  	  КАК БазоваяЕдиницаКодПоОКЕИ, 														 
	|	""""												              КАК ВидУпаковки,
	|	Товары.НомерСтроки                                                КАК НомерСтроки,
	|	Товары.Цена                                                       КАК Цена,																	   
	|	Товары.Количество                                                 КАК Количество,
	|	Товары.СтавкаНДС          										  КАК СтавкаНДС,
	|	Товары.Сумма                									  КАК Сумма,
	|	Товары.СуммаНДС          										  КАК СуммаНДС,
	|   0                                                                 КАК КоличествоВОдномМесте,
	|	0                                								  КАК КоличествоМест,
	|	0							                                      КАК МассаБрутто,
	|	Ложь                                                              КАК ЭтоВозвратнаяТара
	|ИЗ
	|		Документ.ВозвратПоставщику.Товары КАК Товары
	|	ГДЕ
	|		Товары.Ссылка  = &Ссылка И Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|");                                 
		
	
	Запрос.УстановитьПараметр("Дата", 			Ссылка.Дата);
	Запрос.УстановитьПараметр("Ссылка", 		Ссылка);
	Запрос.УстановитьПараметр("Коэф", 			0.01);
//	Запрос.УстановитьПараметр("Организация", 	Ссылка.Организация);

	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Ссылка);
	ТаблицаКурсовВалют = ПолучитьТаблицуКурсовВалют(МассивОбъектов);
	
	МассивРезультатов 			= Запрос.ВыполнитьПакет();
	// МассивРезультатов[0] - временная таблица "Таблица корректировок"
	РезультатПоШапке			= МассивРезультатов[1];
	РезультатПоТабличнойЧасти 	= МассивРезультатов[2];
	
	СтруктураДанныхДляПечати 	= Новый Структура("РезультатПоШапке, РезультатПоТабличнойЧасти, ТаблицаКурсовВалют",
												   РезультатПоШапке, РезультатПоТабличнойЧасти, ТаблицаКурсовВалют);
												   
	Если ПривилегированныйРежим() Тогда
	    УстановитьПривилегированныйРежим(Ложь);	
	КонецЕсли;
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции
Функция ПолучитьДанныеДляСчетФактура(Ссылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|////////////////////////////////////////////////////////////////////////////
	|// ВРЕМЕННАЯ ТАБЛИЦА НоменклатураДокументов
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	МАКСИМУМ(
	|		ВЫБОР КОГДА Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга) ТОГДА
	|			Истина
	|		ИНАЧЕ
	|			Ложь
	|		КОНЕЦ
	|	) КАК ЕстьУслуги,
	|	МАКСИМУМ(
	|		ВЫБОР КОГДА Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга) ТОГДА
	|			Истина
	|		ИНАЧЕ
	|			Ложь
	|		КОНЕЦ
	|	)КАК ЕстьТовары
	|
	|ПОМЕСТИТЬ НоменклатураДокументов
	|ИЗ
	|	Документ.ВозвратПоставщику.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	
	|СГРУППИРОВАТЬ ПО
	|	Товары.Ссылка
	|;
	//|////////////////////////////////////////////////////////////////////////////
	//|// ВРЕМЕННАЯ ТАБЛИЦА ВТ_ТаблицаКорректировок
	//|ВЫБРАТЬ
	//|	*
	//|ПОМЕСТИТЬ ВТ_ТаблицаКорректировок
	//|ИЗ 
	//|	&ТаблицаВВалютеРегл КАК ТаблицаВВалютеРегл
	//|;
	//|
	|////////////////////////////////////////////////////////////////////////////
	|// ЗАПРОС ПО ШАПКЕ
	|
	|ВЫБРАТЬ
	|	Док.Ссылка                                      КАК Ссылка,
	|	Док.Номер   		                          	КАК Номер,
	|	Док.Дата	        	                      	КАК Дата,
	//|	Док.Товары.(	
	//|		ДокументОплаты.Дата							Дата,
	//|       ДокументОплаты.НомерВходящегоДокумента  	Номер
	//|		)											РасчетныеДокументы,
	|	Док.Партнер                                     КАК Партнер,
	|	Док.Контрагент                                  КАК Контрагент,
	|	Док.Организация                                 КАК Организация,
	|	"""" КАК Кладовщик,
	|	"""" КАК ДолжностьКладовщика,
	|	ЕСТЬNULL(Рук.ФизическоеЛицо.Наименование, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))           КАК Руководитель,
	|	ЕСТЬNULL(Рук.Должность, """")                                                                         КАК ДолжностьРуководителя,
	|	ЕСТЬNULL(Бух.ФизическоеЛицо.Наименование, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))           КАК ГлавныйБухгалтер,
	|
	|	ВЫБОР КОГДА Док.Грузополучатель В (Неопределено,ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка),ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),Значение(Справочник.Грузополучатели.ПустаяСсылка)) ТОГДА
	|		Док.Контрагент
	|	ИНАЧЕ
	|		Док.Грузополучатель
	|	КОНЕЦ КАК Грузополучатель,
	|
	|	ВЫБОР КОГДА Док.Грузоотправитель В (Неопределено,ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка),ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),Значение(Справочник.Грузополучатели.ПустаяСсылка)) ТОГДА
	|		Док.Организация
	|	ИНАЧЕ
	|		Док.Грузоотправитель
	|	КОНЕЦ КАК Грузоотправитель,
	|
	|	"""" КАК АдресДоставки,
	|   Док.Валюта					  КАК Валюта,
	|	Док.Валюта.НаименованиеПолное КАК ВалютаНаименованиеПолное,
	|	Док.Валюта.Код				  КАК ВалютаКод,
	|
	|	Док.СуммаВключаетНДС КАК ЦенаВключаетНДС,
	|
	|	НоменклатураДокументов.ЕстьУслуги КАК ЕстьУслуги,
	|
	|	ВЫБОР КОГДА НоменклатураДокументов.ЕстьУслуги
	|		И Не НоменклатураДокументов.ЕстьТовары
	|	ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК ТолькоУслуги
	|ИЗ
	|	Документ.ВозвратПоставщику КАК Док
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтветственныеЛицаОрганизации.СрезПоследних(&Дата, Организация = &Организация И ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизации.ГлавныйБухгалтер)) Бух
	|	ПО ИСТИНА
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтветственныеЛицаОрганизации.СрезПоследних(&Дата, Организация = &Организация И ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизации.Руководитель)) Рук
	|	ПО ИСТИНА
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		НоменклатураДокументов КАК НоменклатураДокументов
	|	ПО
	|		Док.Ссылка = НоменклатураДокументов.Ссылка
	|
	//|		И Док.Организация = СчетФактура.Организация
	|
	|ГДЕ
	|	Док.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////
	|// ЗАПРОС ПО ТАБЛИЧНЫМ ЧАСТЯМ
	|
	|ВЫБРАТЬ
	|	Товары.Ссылка                                                     КАК Ссылка,
	|	Товары.Номенклатура                                               КАК Номенклатура,
	|	Товары.Номенклатура.НаименованиеПолное                            КАК ТоварНаименование,
	|	ВЫБОР КОГДА Товары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) ТОГДА
	|		Товары.Номенклатура.ЕдиницаИзмерения.Наименование    
	|	ИНАЧЕ
	|		ПРЕДСТАВЛЕНИЕ(Товары.Упаковка)
	|	КОНЕЦ  														  	  КАК БазоваяЕдиницаНаименование,
	|	ВЫБОР КОГДА Товары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) ТОГДА
	|		Товары.Номенклатура.ЕдиницаИзмерения.Код    
	|	ИНАЧЕ
	|		""""
	|	КОНЕЦ 														  	  КАК ЕдиницаИзмеренияКод, 														 
	|	ВЫБОР КОГДА Товары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) ТОГДА
	|		Товары.Номенклатура.ЕдиницаИзмерения    
	|	ИНАЧЕ
	|		ПРЕДСТАВЛЕНИЕ(Товары.Упаковка)
	|	КОНЕЦ  														  	  КАК ЕдиницаИзмерения,
	|	Товары.Номенклатура.НомерГТД 									  КАК НомерГТД,
	|	Товары.Номенклатура.СтранаПроисхождения 						  КАК СтранаПроисхождения,
	|	Товары.Цена                                                       КАК Цена,																	   
	|	Товары.Количество                                                 КАК Количество,
	|	0                                								  КАК КоличествоМест,
	|	Товары.СтавкаНДС          										  КАК СтавкаНДС,
	|	Товары.Сумма                									  КАК Сумма,
	|	Товары.СуммаНДС          										  КАК СуммаНДС,
	|	Товары.НомерСтроки                                                КАК НомерСтроки,
	|	ВЫБОР КОГДА Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга) ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ                                                             КАК ЭтоУслуга,
	|	Ложь                                                              КАК ЭтоВозвратнаяТара
	|ИЗ
	|		Документ.ВозвратПоставщику.Товары КАК Товары
	|	ГДЕ
	|		Товары.Ссылка  = &Ссылка //И Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|");
	
	//Если НЕ ПараметрыПечати.ПечатьВВалюте Тогда
	//	ТаблицаВВалютеРегл = ПолучитьТабличнуюЧастьВВалютеРеглУчета(МассивОбъектов, Истина);
	//Иначе
	//	ТаблицаВВалютеРегл = ИнициализироватьТаблицуКорректировок();
	//КонецЕсли;
	//МассивДокументовВВалютеРегл = ТаблицаВВалютеРегл.ВыгрузитьКолонку("ДокументСсылка");
	//ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	Запрос.УстановитьПараметр("Дата", Ссылка.Дата);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Ссылка.Организация);
	//Запрос.УстановитьПараметр("ТаблицаВВалютеРегл",				ТаблицаВВалютеРегл);
	//Запрос.УстановитьПараметр("МассивДокументовВВалютеРегл", 	МассивДокументовВВалютеРегл);
	//Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета);
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Ссылка);
	ТаблицаКурсовВалют = ПолучитьТаблицуКурсовВалют(МассивОбъектов);
	
	МассивРезультатов 			= Запрос.ВыполнитьПакет();
	// МассивРезультатов[0] - временная таблица "Номенклатура документов"
	// МассивРезультатов[1] - временная таблица "Таблица корректировок"
	РезультатПоШапке			= МассивРезультатов[1];
	РезультатПоТабличнойЧасти 	= МассивРезультатов[2];
	
	СтруктураДанныхДляПечати 	= Новый Структура("РезультатПоШапке, РезультатПоТабличнойЧасти, ТаблицаКурсовВалют",
												   РезультатПоШапке, РезультатПоТабличнойЧасти, ТаблицаКурсовВалют);
												   
	Если ПривилегированныйРежим() Тогда
	    УстановитьПривилегированныйРежим(Ложь);	
	КонецЕсли;
												   
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции // СформироватьПечатнуюФормуСчетФактура()
