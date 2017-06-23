﻿
Процедура ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства) Экспорт
	
	
	ИменаРегистров = Новый Массив;
	ПоВсем=Ложь;
	Если Не ДополнительныеСвойства.Свойство("ИменаРегистров",ИменаРегистров) Тогда
		ПоВсем=Истина;
		ИменаРегистров = Новый Массив;
	КонецЕсли;	
	
	
	
	ТекстЗапроса=КэшируемыеФункции.ТектЗапросаПолученияПараметровСистемы() +Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+

		"ВЫБРАТЬ
		|	Склад, ПользовательИнтернет
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя
		|ГДЕ
		|	Ссылка = &Ссылка"
		;
		
	Нтаб=Новый Структура;
	ТекНомер=1;	
		
	Если ИменаРегистров.Найти("ИнтернетЗаказПокупателя")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("ИнтернетЗаказПокупателя",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+

		"ВЫБРАТЬ
		|	&Период				КАК Период,
		|	&ВидДвиженияПриход	КАК ВидДвижения,
		|	Ссылка				КАК ИнтернетЗаказ,
		|	Номенклатура,
		|	Цена,
		|	Акция,
		|	Упаковка,
		|	Размещение,
		|	ПроцентРучнойСкидки,
		|	ПроцентАвтоматическойСкидки,
		|	СтавкаНДС,
		|	СУММА(Количество)	КАК Количество,
		|	СУММА(Сумма)		КАК Сумма
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя.Товары
		|
		|ГДЕ
		|	Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	Ссылка,
		|	Номенклатура,
		|	Цена,
		|	Акция,
		|	Упаковка,
		|	Размещение,
		|	ПроцентРучнойСкидки,
		|	ПроцентАвтоматическойСкидки,
		|	СтавкаНДС"
	КонецЕсли;	
	
	
	Если ИменаРегистров.Найти("ТоварыВРезерве")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("ТоварыВРезерве",ТекНомер);
		
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
		"ВЫБРАТЬ
		|	&Период				КАК Период,
		|	&ВидДвиженияПриход	КАК ВидДвижения,
		|	Размещение,
		|	&Ссылка				КАК ДокументРезерва,
		|	Номенклатура,
		|	ВЫБОР КОГДА Упаковка = &ПустаяУпаковка ТОГДА
		|		СУММА(Количество)
		|	ИНАЧЕ
		|		СУММА(Количество*Упаковка.Коэффициент)
		|	КОНЕЦ				КАК Количество
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя.Товары
		|
		|ГДЕ
		|	Ссылка = &Ссылка И Размещение ССЫЛКА Справочник.Склады И
		|	ЕСТЬNULL(Размещение, &ПустойСклад) <> &ПустойСклад
		|
		|СГРУППИРОВАТЬ ПО
		|	Размещение,
		|	Номенклатура,
		|	Упаковка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&Период				КАК Период,
		|	&ВидДвиженияПриход	КАК ВидДвижения,
		|	Размещение,
		|	&Ссылка				КАК ДокументРезерва,
		|	Номенклатура,
		|	СУММА(Количество)	КАК Количество
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя.РазмещениеТоваров	
		|
		|ГДЕ
		|	Ссылка = &Ссылка И
		|	Размещение ССЫЛКА Справочник.Склады
		|
		|СГРУППИРОВАТЬ ПО
		|	Размещение, Номенклатура"
	КонецЕсли;	
	
	
	Если ИменаРегистров.Найти("РазмещениеЗаказов")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("РазмещениеЗаказов",ТекНомер);
		
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
		"ВЫБРАТЬ
		|	&Период				КАК Период,
		|	&ВидДвиженияПриход	КАК ВидДвижения,
		|	Размещение 			Очередь,
		|	&Ссылка				КАК Заказ,
		|	Номенклатура,
		|	Упаковка,
		|	СУММА(Количество)	Количество
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя.Товары
		|
		|ГДЕ
		|	Ссылка = &Ссылка И
		|	Ссылка = &Ссылка И ТИПЗНАЧЕНИЯ(Размещение) = ТИП(ЧИСЛО)
		//|	НЕ Размещение ССЫЛКА Справочник.Склады И Размещение <> Неопределено И ЕСТЬNULL(Размещение, 0) <> 0
		|
		|СГРУППИРОВАТЬ ПО
		|	Размещение,
		|	Номенклатура,
		|	Упаковка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&Период				КАК Период,
		|	&ВидДвиженияПриход	КАК ВидДвижения,
		|	Размещение 			Очередь,
		|	&Ссылка				КАК Заказ,
		|	Номенклатура,
		|	&ПустаяУпаковка,
		|	СУММА(Количество) Количество
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя.РазмещениеТоваров
		|
		|ГДЕ
		|	Ссылка = &Ссылка И
		|	Ссылка = &Ссылка И ТИПЗНАЧЕНИЯ(Размещение) = ТИП(ЧИСЛО)
		//|	НЕ Размещение ССЫЛКА Справочник.Склады И Размещение <> Неопределено И ЕСТЬNULL(Размещение, 0) <> 0
		|
		|СГРУППИРОВАТЬ ПО
		|	Размещение, Номенклатура"
	КонецЕсли;	
	
	
	Если ИменаРегистров.Найти("ДолгиПоЗаказам")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("ДолгиПоЗаказам",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
		"ВЫБРАТЬ
		|	&Период КАК Период,
		|	&ВидДвиженияПриход КАК ВидДвижения,
		|	ЗаказПокупателя.Организация,
		|	ЗаказПокупателя.Контрагент,
		|	&Ссылка КАК Заказ,
		|	&СуммаЗаказа КАК Сумма
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя КАК ЗаказПокупателя
		|ГДЕ
		|	ЗаказПокупателя.Ссылка = &Ссылка и &СуммаЗаказа<>0 и (Склад.ПередачаТовараМВЗ=Ложь И МВЗ=Значение(Справочник.МВЗ.ПустаяСсылка) И ПередачаТовара=Ложь)"
	КонецЕсли;	
	
	
	Если ИменаРегистров.Найти("ОтгруженныеЗаказы")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("ОтгруженныеЗаказы",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
		"ВЫБРАТЬ
		|	&Период	Период,
		|	Ссылка 	Заказ,
		|	СУММА(Номенклатура.Вес * ВЫБОР КОГДА Упаковка = &ПустаяУпаковка ТОГДА Количество ИНАЧЕ Количество * Упаковка.Коэффициент КОНЕЦ) 	ВесЗаказа,
		|	СУММА(Номенклатура.Объем * ВЫБОР КОГДА Упаковка = &ПустаяУпаковка ТОГДА Количество ИНАЧЕ Количество * Упаковка.Коэффициент КОНЕЦ) 	ОбъемЗаказа
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя.Товары
		|ГДЕ
		|	Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	Ссылка"
		
	КонецЕсли;	
	
	Если ИменаРегистров.Найти("Лимиты")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("Лимиты",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
		"ВЫБРАТЬ
		|   &Период,
		|	&ВидДвиженияРасход					ВидДвижения,
		|	Ссылка.ОтветственноеЛицо	Инициатор,
		|	СУММА(Сумма) 						Сумма
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя.Товары
		|ГДЕ
		|   Ссылка = &Ссылка И Ссылка.ОтветственноеЛицо <> &ПустойИнициатор
		|СГРУППИРОВАТЬ ПО Ссылка"
	КонецЕсли;	
	
	Если ИменаРегистров.Найти("РазмещениеЗаказовВПути")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+3;
		Нтаб.Вставить("РазмещениеЗаказовВПути",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
		"ВЫБРАТЬ
		|	ЗаказПокупателяРазмещениеТоваров.Номенклатура
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя.РазмещениеТоваров КАК ЗаказПокупателяРазмещениеТоваров
		|ГДЕ
		|	ЗаказПокупателяРазмещениеТоваров.Ссылка = &Ссылка
		|	И ЗаказПокупателяРазмещениеТоваров.Размещение ССЫЛКА Документ.ЗаказПоставщику
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РазмещениеЗаказовВПутиОстатки.Номенклатура,
		|	МАКСИМУМ(РазмещениеЗаказовВПутиОстатки.Очередь) КАК Очередь
		|ПОМЕСТИТЬ ТаблОчереди
		|ИЗ
		|	РегистрНакопления.РазмещениеЗаказовВПути.Остатки(
		|			&ПериодОчереди,
		|			Номенклатура В
		|				(ВЫБРАТЬ
		|					Товары.Номенклатура
		|				ИЗ
		|					Товары)) КАК РазмещениеЗаказовВПутиОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	РазмещениеЗаказовВПутиОстатки.Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	&Период КАК Период,
		|	&ВидДвиженияПриход КАК ВидДвижения,
		|	ЕСТЬNULL(Оч.Очередь, 1) КАК Очередь,
		|	Док.Ссылка КАК Размещение,
		|	Док.Номенклатура КАК Номенклатура,
		|	Док.Размещение КАК ЗаказПоставщику,
		|	СУММА(Док.Количество) КАК Количество
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя.РазмещениеТоваров КАК Док
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблОчереди КАК Оч
		|		ПО Док.Номенклатура = Оч.Номенклатура
		|ГДЕ
		|	Док.Ссылка = &Ссылка
		|	И Док.Размещение ССЫЛКА Документ.ЗаказПоставщику
		|
		|СГРУППИРОВАТЬ ПО
		|	Док.Ссылка,
		|	ЕСТЬNULL(Оч.Очередь, 1),
		|	Док.Размещение,
		|	Док.Номенклатура"
	КонецЕсли;	
	
		
	Запрос=Новый Запрос;
	Запрос.Текст=ТекстЗапроса;
	
	//Запрос.УстановитьПараметр("Область", 			ПараметрыСеанса.ТекущаяОбласть);
	Запрос.УстановитьПараметр("Организация", 		Ссылка.Организация);
	Запрос.УстановитьПараметр("Контрагент", 		Ссылка.Контрагент);
	Запрос.УстановитьПараметр("СуммаЗаказа", 		Ссылка.Сумма);

	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.УстановитьПараметр("Период", 			Ссылка.Дата);
	Запрос.УстановитьПараметр("ПериодОчереди", 		?(НачалоДня(Ссылка.Дата) = НачалоДня(ТекущаяДата()), НачалоДня(ТекущаяДата()), Ссылка.Дата));
	Запрос.УстановитьПараметр("ВидДвиженияПриход", 	ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("ВидДвиженияРасход", 	ВидДвиженияНакопления.Расход);
	Запрос.УстановитьПараметр("ПустойСклад", 		Справочники.Склады.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяУпаковка", 	Справочники.УпаковкиНоменклатуры.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустойИнициатор", 	Справочники.ФизическиеЛица.ПустаяСсылка());
	
	Пакет = Запрос.ВыполнитьПакет();
	ПараметрыСистемы = КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[0].Выгрузить());
	                    
	ДополнительныеСвойства.Вставить("ПараметрыСистемы", ПараметрыСистемы);
	ДополнительныеСвойства.Вставить("Шапка", 			КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[1].Выгрузить()));
	
	//ДополнительныеСвойства.Вставить("ИнтернетЗаказПокупателя", 	Пакет[2].Выгрузить());
	//ДополнительныеСвойства.Вставить("ТоварыВРезерве", 	Пакет[3].Выгрузить()); 
	//
	//ДополнительныеСвойства.Вставить("ДолгиПоЗаказам", 	 Пакет[4].Выгрузить());
	//ДополнительныеСвойства.Вставить("РазмещениеЗаказов", Пакет[5].Выгрузить());
	//ДополнительныеСвойства.Вставить("ОтгруженныеЗаказы", Пакет[6].Выгрузить());
	//ДополнительныеСвойства.Вставить("Лимиты", 			 Пакет[7].Выгрузить()); 
	//ДополнительныеСвойства.Вставить("РазмещениеЗаказовВПути", 	Пакет[9].Выгрузить());
	
	Для Каждого Элем Из Нтаб Цикл
		ДополнительныеСвойства.Вставить(Элем.Ключ,Пакет[Элем.Значение].Выгрузить());
	КонецЦикла;	
	
	ДополнительныеСвойства.Вставить("ДолгиПоОтгрузкам", 	Новый ТаблицаЗначений);//необходимо очищать старые наборы движений
	
КонецПроцедуры


Процедура Печать(ТабДок, Ссылка) Экспорт
	
	//Макет 	= Документы.ПоступлениеТоваров.ПолучитьМакет("Печать");
	//Запрос 	= Новый Запрос;
	//Запрос.Текст =
	//"ВЫБРАТЬ
	//|	Валюта,
	//|	Дата,
	//|	Комментарий,
	//|	Контрагент,
	//|	Склад КАК МестоХранения,
	//|	Номер,
	//|	Ответственный,
	//|	Товары.(
	//|		НомерСтроки,
	//|		Номенклатура,
	//|		Количество,
	//|		Цена,
	//|		Сумма
	//|			)
	//|ИЗ
	//|	Документ.ПоступлениеТоваров
	//|ГДЕ
	//|	Ссылка В (&Ссылка)";
	//
	//Запрос.Параметры.Вставить("Ссылка", Ссылка);
	//Выборка = Запрос.Выполнить().Выбрать();

	//ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	//Шапка = Макет.ПолучитьОбласть("Шапка");
	//ОбластьТоварыШапка = Макет.ПолучитьОбласть("ТоварыШапка");
	//ОбластьТовары = Макет.ПолучитьОбласть("Товары");
	//ОбластьТовары1Шапка = Макет.ПолучитьОбласть("Товары1Шапка");
	//ОбластьТовары1 = Макет.ПолучитьОбласть("Товары1");
	//ОбластьТовары2Шапка = Макет.ПолучитьОбласть("Товары2Шапка");
	//ОбластьТовары2 = Макет.ПолучитьОбласть("Товары2");
	//Подвал = Макет.ПолучитьОбласть("Подвал");

	//ТабДок.Очистить();

	//ВставлятьРазделительСтраниц = Ложь;
	//Пока Выборка.Следующий() Цикл
	//	
	//	Если ВставлятьРазделительСтраниц Тогда
	//		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	//	КонецЕсли;

	//	ТабДок.Вывести(ОбластьЗаголовок);

	//	Шапка.Параметры.Заполнить(Выборка);
	//	ТабДок.Вывести(Шапка, Выборка.Уровень());

	//	ТабДок.Вывести(ОбластьТоварыШапка);
	//	ВыборкаТовары = Выборка.Товары.Выбрать();
	//	Пока ВыборкаТовары.Следующий() Цикл
	//		ОбластьТовары.Параметры.Заполнить(ВыборкаТовары);
	//		ТабДок.Вывести(ОбластьТовары, ВыборкаТовары.Уровень());
	//	КонецЦикла;

	//	Подвал.Параметры.Заполнить(Выборка);
	//	ТабДок.Вывести(Подвал);

	//	ВставлятьРазделительСтраниц = Истина;
	//	
	//КонецЦикла;
	
КонецПроцедуры

Функция СинхронизироватьЗаказВ81(Ссылка, РезервироватьТовар, стрОшибки = "") Экспорт
	
	Connector = КэшируемыеФункции.ИницилизироватьCOMConnector81(, стрОшибки);
	
	Если Connector = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Номенклатура,
	|	Цена,
	|	Размещение,
	|	СУММА(Количество)	КАК Количество,
	|	СУММА(Сумма)		КАК Сумма
	|ИЗ
	|	Документ.ИнтернетЗаказПокупателя.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Номенклатура,
	|	Цена,
	|	Размещение
	|");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	
	НовДок = Connector.Документы.ЗаказПокупателя.СоздатьДокумент();
	НовДок.Дата = Ссылка.Дата;
	НовДок.ИнициализироватьНовыйДокумент(Неопределено, Неопределено);
	НовДок.УстановитьСсылкуНового(Connector.Документы.ЗаказПокупателя.ПолучитьСсылку(Connector.NewObject("UUID", Строка(Ссылка.УникальныйИдентификатор()))));
	//НовДок.ДополнительныеСвойства.Вставить("Источник82", Истина);
	НовДок.ЭтоИнтернетЗаказ = Истина;
	
	// Заполним шапку
	
	//Определим контрагента
	
	// Заполним товары

	//СпособСписанияСоСклада = Connector.Перечисмления.
	МенеджерНоменклатуры 	= Connector.Справочники.Номенклатура;
	МенеджерСклада			= Connector.Справочники.Склады;
	СтавкаНДС				= Connector.Перечисления.СтавкиНДС.НДС18;
	
	Пока Выборка.Следующий() ЦИкл
		
		НовСтрока = НовДок.Товары.Добавить();
		НовСтрока.Номенклатура 		= МенеджерНоменклатуры.ПолучитьСсылку(Connector.NewObject("UUID", Строка(Выборка.Номенклатура.УникальныйИдентификатор())));
		НовСтрока.ЕдиницаИзмерения 	= НовСтрока.Номенклатура.ЕдиницаХраненияОстатков;
		НовСтрока.Цена 				= Выборка.Цена;
		НовСтрока.Сумма		 		= Выборка.Сумма;
		НовСтрока.СтавкаНДС 		= СтавкаНДС;
		НовСтрока.Количество	 	= Выборка.Количество;
		НовСтрока.Коэффициент 		= 1;
		
		Если Не Выборка.Размещение.Пустая() И РезервироватьТовар Тогда
			НовСтрока.Размещение = МенеджерСклада.ПолучитьСсылку(Connector.NewObject("UUID", Строка(Выборка.Размещение.УникальныйИдентификатор())));
		КонецЕсли;	
		
		Connector.ОбработкаТабличныхЧастей.РассчитатьСуммуТабЧасти(НовСтрока, НовДок);
		Connector.ОбработкаТабличныхЧастей.РассчитатьСуммуНДСТабЧасти(НовСтрока, НовДок);
		
	КонецЦикла;
	
	
	
	Попытка
		НовДок.Записать();
	Исключение
		стрОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция СформироватьПечатнуюФорму_уд(ТабличныйДокумент, Ссылка, Тип, Дата=Неопределено, ИмяДопИмениОбластей = "", СоСрокомДоставки = Ложь)	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Дата<>Неопределено Тогда
		ДатаВыполнения = Дата
	Иначе
		ДатаВыполнения = ТекущаяДата();
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Дата", Ссылка.Дата);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Ссылка.Организация);
	Запрос.УстановитьПараметр("ДатаВыполнения", ДатаВыполнения);
    Запрос.УстановитьПараметр("СтавкаНДС", Перечисления.СтавкиНДС.НДС18);
	Запрос.УстановитьПараметр("БанковскийСчетПоУмолчанию", Справочники.БанковскиеСчета.ПолучитьБанковскийСчетПоУмолчанию(Ссылка.Организация));
	
		
		Запрос.Текст = 
		"
		|///////////////////////////////////
		|///ШАПКА
		|
		|ВЫБРАТЬ 
		|	Док.Ссылка                                            КАК Ссылка,
		|	Док.Номер                                             КАК Номер,
		|	Док.Дата                                              КАК Дата,
		|	Док.Организация                                       КАК Организация,
		|	Док.Склад												Склад,
		|" + ?(СоСрокомДоставки, "ПРЕДСТАВЛЕНИЕ(Док.МВЗ) 	МВЗ,
		|	Док.ОтветственноеЛицо 							ОтветственноеЛицо,", "") + "
		|	ЕСТЬNULL(Рук.ФизическоеЛицо.Наименование, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))           КАК Руководитель,
		|	ЕСТЬNULL(Бух.ФизическоеЛицо.Наименование, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))           КАК ГлавныйБухгалтер,
		|	ИСТИНА                                     КАК УчитыватьНДС,
		|	Док.Контрагент                                   	 КАК Контрагент,
		|	ВЫБОР КОГДА Док.Грузоотправитель В (Неопределено,ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка),ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),Значение(Справочник.Грузополучатели.ПустаяСсылка))
		|	      ТОГДА Док.Организация
		|	      ИНАЧЕ Док.Грузоотправитель КОНЕЦ КАК Грузоотправитель,
		|	ВЫБОР КОГДА Док.Грузополучатель В (Неопределено,ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка),ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),Значение(Справочник.Грузополучатели.ПустаяСсылка))
		|	      ТОГДА Док.Контрагент
		|	      ИНАЧЕ Док.Грузополучатель КОНЕЦ КАК Грузополучатель,
		|	ВЫБОР КОГДА БанковскийСчетОрганизации = ЗНАЧЕНИЕ(Справочник.БанковскиеСчета.ПустаяСсылка) ТОГДА
		|		&БанковскийСчетПоУмолчанию
		|	ИНАЧЕ
		|		БанковскийСчетОрганизации
		|	КОНЕЦ КАК БанковскийСчет,
		|	БанковскийСчетПартнера.ТекстКорреспондента           КАК БанковскийСчетТекстКорреспондента,
		|	Док.СуммаВключаетНДС                             КАК ЦенаВключаетНДС,
		|	Док.Валюта                                       КАК Валюта,
		|	Док.Ответственный.Наименование         			 КАК Менеджер,
		|	Док.Ответственный.Организация					 КАК ОрганизацияМенеджер,
		|	""""						                     КАК ДополнительнаяИнформация
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя Док
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		РегистрСведений.ОтветственныеЛицаОрганизации.СрезПоследних(&Дата, Организация = &Организация И ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизации.ГлавныйБухгалтер)) Бух
		|	ПО ИСТИНА
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		РегистрСведений.ОтветственныеЛицаОрганизации.СрезПоследних(&Дата, Организация = &Организация И ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизации.Руководитель)) Рук
		|	ПО ИСТИНА
		|ГДЕ
		|	Ссылка = &Ссылка
        |;
		|ВЫБРАТЬ Номенклатура, Позиция ПОМЕСТИТЬ ПорядокСтрок ИЗ РегистрСведений.ПорядокСтрокНоменклатуры ГДЕ Объект = &Ссылка
		|;	
		|//////////////////////////////////////////////
		|///ТОВАРЫ
		|
		|ВЫБРАТЬ
		|	Док.НомерСтроки             			КАК НомерСтроки,
		|	Док.Номенклатура                        КАК Номенклатура,
		|	Док.Номенклатура.Код                    КАК Код,
		|	Док.Номенклатура.Артикул                КАК Артикул,
		|	Док.Номенклатура.НаименованиеПолное     КАК НаименованиеПолное,
		|	ВЫБОР
		|		КОГДА Док.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
		|			ТОГДА ПРЕДСТАВЛЕНИЕ(Док.Номенклатура.ЕдиницаИзмерения)
		|		ИНАЧЕ ПРЕДСТАВЛЕНИЕ(Док.Упаковка)
		|	КОНЕЦ                                   КАК ЕдиницаИзмерения,
		|	Док.Цена 								КАК Цена,
		|	Док.СтавкаНДС			        		КАК СтавкаНДС,
		|	Док.Количество					КАК Количество,
		|	Док.Сумма							КАК Сумма,
		|	(Док.Цена * Док.Количество - ЕСТЬNULL(Таб.Доставка, 0)) * Док.ПроцентРучнойСкидки * 0.01 + (Док.Цена * Док.Количество - ЕСТЬNULL(Таб.Доставка, 0)) * Док.ПроцентАвтоматическойСкидки * 0.01  КАК СуммаСкидки,
		|	Док.Цена * Док.Количество 		КАК СуммаБезСкидки,
		|" + Заказы.ПолучитьСуммуНДСВЗапросе("Док","","Ссылка") + " КАК СуммаНДС,  
		|	ДАТАВРЕМЯ(1,1,1,0,0,0)                  КАК ДатаОтгрузки,
		|	ЛОЖЬ	                                КАК Отменено
		|ПОМЕСТИТЬ СписокТоваров	
		|ИЗ
		//|	РегистрНакопления.ИнтернетЗаказПокупателя.ОстаткиИОбороты(,&ДатаВыполнения,,,ИнтернетЗаказ = &Ссылка) Док
		|	Документ.ИнтернетЗаказПокупателя.Товары Док
		//|	ЛЕВОЕ СОЕДИНЕНИЕ 
		//|		ПорядокСтрок НомСтрок ПО Док.Номенклатура = НомСтрок.Номенклатура
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|	Документ.ИнтернетЗаказПокупателя.Доставка Таб
		|		ПО Док.Ссылка = Таб.Ссылка И Док.Номенклатура = Таб.Номенклатура И Док.Упаковка = Таб.Упаковка 
		|   ГДЕ Док.Ссылка = &Ссылка
		|;
		|	ВЫБРАТЬ 
		|		Номенклатура,
		|	    МАКСИМУМ(Размещение) Размещение,
		|		МАКСИМУМ(ВЫБОР КОГДА ЕСТЬNULL(Размещение, Неопределено) ССЫЛКА Справочник.Склады ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) ЕстьНаСкладе
		|	ПОМЕСТИТЬ РазмещениеТоваров
		|	ИЗ	
		|	РегистрНакопления.ТоварыВрезерве.Остатки(, Номенклатура В(ВЫБРАТЬ Номенклатура ИЗ СписокТоваров) И ДокументРезерва = &Ссылка)
		|СГРУППИРОВАТЬ ПО Номенклатура
		|;
		|ВЫБРАТЬ
		|	Тов.НомерСтроки,
		|	Тов.Номенклатура,
		|	Тов.Код,
		|	Тов.Артикул,
		|	Тов.НаименованиеПолное,
		|	Тов.ЕдиницаИзмерения,
		|   Тов.Цена,
		|   Тов.СтавкаНДС,
		//|" + ?(СоСрокомДоставки," 
		//|		ЕСТЬNULL(Рез.Размещение, Неопределено) Размещение,
		//|		ВЫБОР КОГДА ЕСТЬNULL(Рез.Размещение, Неопределено) ССЫЛКА Справочник.Склады ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ ЕстьНаСкладе,", "") + "			
		|  	Тов.Количество,
		|  	Тов.Сумма,
		|  	Тов.СуммаСкидки,
		|  	Тов.СуммаБезСкидки,
		|  	Тов.СуммаНДС,
		| 	Тов.ДатаОтгрузки,
		|   Тов.Отменено
		|ИЗ
		|	СписокТоваров Тов
		//|	ЛЕВОЕ СОЕДИНЕНИЕ
		//|		РазмещениеТоваров Рез 
		//|		ПО Тов.Номенклатура = Рез.Номенклатура
		|УПОРЯДОЧИТЬ ПО НомерСтроки
		| 
		|";
		
		
	Рез = Запрос.Выполнить().Выбрать();	
	//Документы.ЗаказПокупателя.ЗаполнитьТабличныйДокументСчетЗаказ(ТабличныйДокумент, Запрос, , Тип,,1);
Если Тип = "Квитанция" Тогда
	Документы.ЗаказПокупателя.ЗаполнитьТабличныйДокументКвитанция(ТабличныйДокумент, Запрос, , Тип,,4);
Иначе
	Документы.ЗаказПокупателя.ЗаполнитьТабличныйДокументСчетЗаказ(ТабличныйДокумент, Запрос, , Тип,,4, ИмяДопИмениОбластей, СоСрокомДоставки);
КонецЕсли;	

	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецФункции // СформироватьПечатнуюФорму()

Функция СформироватьПечатнуюФормуСРезервами_уд(ТабличныйДокумент, Ссылка, Тип, Дата=Неопределено, ИмяДопИмениОбластей = "", СоСрокомДоставки = Ложь)	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Дата<>Неопределено Тогда
		ДатаВыполнения = Дата
	Иначе
		ДатаВыполнения = ТекущаяДата();
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Дата", Ссылка.Дата);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Ссылка.Организация);
	Запрос.УстановитьПараметр("ДатаВыполнения", ДатаВыполнения);
    Запрос.УстановитьПараметр("СтавкаНДС", Перечисления.СтавкиНДС.НДС18);
	Запрос.УстановитьПараметр("БанковскийСчетПоУмолчанию", Справочники.БанковскиеСчета.ПолучитьБанковскийСчетПоУмолчанию(Ссылка.Организация));
	
		Запрос.Текст = 
		"
		//|ВЫБРАТЬ
		//|	
		//|	Номенклатура				Номенклатура,
		//|	Цена						Цена,
		//|	Упаковка					Упаковка,
		//|	Размещение					Размещение,
		//|	СУММА(Сумма)				Сумма,
		//|	СУММА(Количество)			Количество,
		//|	СУММА(СуммаНДС)				СуммаНДС,
		//|	МАКСИМУМ(СтавкаНДС)         СтавкаНДС
		//|ПОМЕСТИТЬ ТаблицаКорректировок
		//|		
		//|ИЗ
		//|	Документ.КорректировкаЗаказаПокупателя.Товары
		//|ГДЕ
		//|	Ссылка.Заказ = &Ссылка
		//|СГРУППИРОВАТЬ ПО 
		//|	Номенклатура, Цена, Упаковка, Размещение
		//|;
		|///////////////////////////////////
		|///ШАПКА
		|
		|ВЫБРАТЬ 
		|	Док.Ссылка                                            КАК Ссылка,
		|	Док.Номер                                             КАК Номер,
		|	Док.Дата                                              КАК Дата,
		|	Док.Организация                                       КАК Организация,
		|	Док.Склад												Склад,
		|" + ?(СоСрокомДоставки, "ПРЕДСТАВЛЕНИЕ(Док.МВЗ) 	МВЗ,
		|	Док.ОтветственноеЛицо 							ОтветственноеЛицо,", "") + "
		|	ЕСТЬNULL(Рук.ФизическоеЛицо.Наименование, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))           КАК Руководитель,
		|	ЕСТЬNULL(Бух.ФизическоеЛицо.Наименование, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))           КАК ГлавныйБухгалтер,
		|	ИСТИНА                                     КАК УчитыватьНДС,
		|	Док.Контрагент                                   	 КАК Контрагент,
		|	ВЫБОР КОГДА Док.Грузоотправитель В (Неопределено,ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка),ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),Значение(Справочник.Грузополучатели.ПустаяСсылка))
		|	      ТОГДА Док.Организация
		|	      ИНАЧЕ Док.Грузоотправитель КОНЕЦ КАК Грузоотправитель,
		|	ВЫБОР КОГДА Док.Грузополучатель В (Неопределено,ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка),ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),Значение(Справочник.Грузополучатели.ПустаяСсылка))
		|	      ТОГДА Док.Контрагент
		|	      ИНАЧЕ Док.Грузополучатель КОНЕЦ КАК Грузополучатель,
		|	ВЫБОР КОГДА БанковскийСчетОрганизации = ЗНАЧЕНИЕ(Справочник.БанковскиеСчета.ПустаяСсылка) ТОГДА
		|		&БанковскийСчетПоУмолчанию
		|	ИНАЧЕ
		|		БанковскийСчетОрганизации
		|	КОНЕЦ КАК БанковскийСчет,
		|	БанковскийСчетПартнера.ТекстКорреспондента           КАК БанковскийСчетТекстКорреспондента,
		|	Док.СуммаВключаетНДС                             КАК ЦенаВключаетНДС,
		|	Док.Валюта                                       КАК Валюта,
		|	Док.Ответственный.Наименование         			 КАК Менеджер,
		|	Док.Ответственный.Организация					 КАК ОрганизацияМенеджер,
		|	""""						                     КАК ДополнительнаяИнформация
		|ИЗ
		|	Документ.ИнтернетЗаказПокупателя Док
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		РегистрСведений.ОтветственныеЛицаОрганизации.СрезПоследних(&Дата, Организация = &Организация И ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизации.ГлавныйБухгалтер)) Бух
		|	ПО ИСТИНА
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		РегистрСведений.ОтветственныеЛицаОрганизации.СрезПоследних(&Дата, Организация = &Организация И ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизации.Руководитель)) Рук
		|	ПО ИСТИНА
		|ГДЕ
		|	Ссылка = &Ссылка
		|;
		|ВЫБРАТЬ Номенклатура, Позиция ПОМЕСТИТЬ ПорядокСтрок ИЗ РегистрСведений.ПорядокСтрокНоменклатуры ГДЕ Объект = &Ссылка
		|;	
		|//////////////////////////////////////////////
		|///ТОВАРЫ
		|
		|ВЫБРАТЬ
		|	ЕСТЬNULL(НомСтрок.Позиция, 0)			КАК НомерСтроки,
		|	Док.Номенклатура                        КАК Номенклатура,
		|	Док.Номенклатура.Код                    КАК Код,
		|	Док.Номенклатура.Артикул                КАК Артикул,
		|	Док.Номенклатура.НаименованиеПолное     КАК НаименованиеПолное,
		|	ВЫБОР
		|		КОГДА Док.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
		|			ТОГДА ПРЕДСТАВЛЕНИЕ(Док.Номенклатура.ЕдиницаИзмерения)
		|		ИНАЧЕ ПРЕДСТАВЛЕНИЕ(Док.Упаковка)
		|	КОНЕЦ                                   КАК ЕдиницаИзмерения,
		//|	ВЫБОР КОГДА Док.СуммаПриход = 0 ТОГДА 0 ИНАЧЕ Док.СуммаПриход/Док.КоличествоПриход КОНЕЦ Цена,
		|	Док.Цена 								КАК Цена,
		|	Док.СтавкаНДС			        		КАК СтавкаНДС,
		|	Док.КоличествоПриход					КАК Количество,
		|	Док.СуммаПриход							КАК Сумма,
		|	(Док.Цена * Док.КоличествоПриход - ЕСТЬNULL(Таб.Доставка, 0)) * Док.ПроцентРучнойСкидки * 0.01 + (Док.Цена * Док.КоличествоПриход - ЕСТЬNULL(Таб.Доставка, 0)) * Док.ПроцентАвтоматическойСкидки * 0.01  КАК СуммаСкидки,
		//|	(Док.Цена * Док.КоличествоПриход) * Док.ПроцентРучнойСкидки * 0.01 + (Док.Цена * Док.КоличествоПриход) * Док.ПроцентАвтоматическойСкидки * 0.01  КАК СуммаСкидки,
		|	Док.Цена * Док.КоличествоПриход 		КАК СуммаБезСкидки,
		|" + Заказы.ПолучитьСуммуНДСВЗапросе("Док",,"ИнтернетЗаказ") + " КАК СуммаНДС,  
		|	ДАТАВРЕМЯ(1,1,1,0,0,0)                  КАК ДатаОтгрузки,
		|	ЛОЖЬ	                                КАК Отменено
		|ПОМЕСТИТЬ СписокТоваров	
		|ИЗ
		|	РегистрНакопления.ИнтернетЗаказПокупателя.ОстаткиИОбороты(,&ДатаВыполнения,,,ИнтернетЗаказ = &Ссылка) Док
		|	ЛЕВОЕ СОЕДИНЕНИЕ 
		|		ПорядокСтрок НомСтрок ПО Док.Номенклатура = НомСтрок.Номенклатура
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|	Документ.ИнтернетЗаказПокупателя.Доставка Таб
		|		ПО Док.ИнтернетЗаказ = Таб.Ссылка И Док.Номенклатура = Таб.Номенклатура И Док.Упаковка = Таб.Упаковка 
		//|	ЛЕВОЕ СОЕДИНЕНИЕ
		//|	(ВЫБРАТЬ Номенклатура, Цена, Упаковка, ПроцентРучнойСкидки, ПроцентАвтоматическойСкидки, СтавкаНДС, СУММА(Доставка) ИЗ Документ.ИнтернетЗаказПокупателя.Доставка ГДЕ Ссылка = &Ссылка СГРУППИРОВАТЬ ПО Номенклатура, Цена, Упаковка, ПроцентРучнойСкидки, ПроцентАвтоматическойСкидки, СтавкаНДС) Тов
		//|	ПО 	Тов.Номенклатура = Док.Номенклатура И Тов.Цена = Док.Цена И Тов.Упаковка = Док.Упаковка И 
		//|		Тов.ПроцентРучнойСкидки = Док.ПроцентРучнойСкидки И Тов.ПроцентАвтоматическойСкидки = Док.ПроцентАвтоматическойСкидки И Тов.СтавкаНДС = Док.СтавкаНДС 
		|;
		|	ВЫБРАТЬ 
		|		Номенклатура,
		|	    МАКСИМУМ(Размещение) Размещение,
		|		МАКСИМУМ(ВЫБОР КОГДА ЕСТЬNULL(Размещение, Неопределено) ССЫЛКА Справочник.Склады ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) ЕстьНаСкладе
		|	ПОМЕСТИТЬ РазмещениеТоваров
		|	ИЗ	
		|	РегистрНакопления.ТоварыВрезерве.Остатки(, Номенклатура В(ВЫБРАТЬ Номенклатура ИЗ СписокТоваров) И ДокументРезерва = &Ссылка)
		|СГРУППИРОВАТЬ ПО Номенклатура
		|;
		|ВЫБРАТЬ
		|	Тов.НомерСтроки,
		|	Тов.Номенклатура,
		|	Тов.Код,
		|	Тов.Артикул,
		|	Тов.НаименованиеПолное,
		|	Тов.ЕдиницаИзмерения,
		|   Тов.Цена,
		|   Тов.СтавкаНДС,
		|" + ?(СоСрокомДоставки," 
		|		ЕСТЬNULL(Рез.Размещение, Неопределено) Размещение,
		|		ВЫБОР КОГДА ЕСТЬNULL(Рез.Размещение, Неопределено) ССЫЛКА Справочник.Склады ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ ЕстьНаСкладе,", "") + "			
		|  	Тов.Количество,
		|  	Тов.Сумма,
		|  	Тов.СуммаСкидки,
		|  	Тов.СуммаБезСкидки,
		|  	Тов.СуммаНДС,
		| 	Тов.ДатаОтгрузки,
		|   Тов.Отменено
		|ИЗ
		|	СписокТоваров Тов
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		РазмещениеТоваров Рез 
		|		ПО Тов.Номенклатура = Рез.Номенклатура
		|УПОРЯДОЧИТЬ ПО НомерСтроки
		| 
		|";
		
		
		
		
	Рез = Запрос.Выполнить().Выбрать();	
	//Документы.ЗаказПокупателя.ЗаполнитьТабличныйДокументСчетЗаказ(ТабличныйДокумент, Запрос, , Тип,,1);
Если Тип = "Квитанция" Тогда
	Документы.ЗаказПокупателя.ЗаполнитьТабличныйДокументКвитанция(ТабличныйДокумент, Запрос, , Тип,,4);
Иначе
	Документы.ЗаказПокупателя.ЗаполнитьТабличныйДокументСчетЗаказ(ТабличныйДокумент, Запрос, , Тип,,4, ИмяДопИмениОбластей, СоСрокомДоставки);
КонецЕсли;	

	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецФункции // СформироватьПечатнуюФорму()


Процедура Печать_СчетЗаказ(ТабДок, Ссылка, Тип, ИмяДопИмениОбластей = "", СоСрокомДоставки = Ложь) Экспорт
	
	//Если СоСрокомДоставки Тогда
	//	СформироватьПечатнуюФормуСРезервами_уд(ТабДок, Ссылка, Тип,,ИмяДопИмениОбластей, СоСрокомДоставки)
	//Иначе
	//	СформироватьПечатнуюФорму_уд(ТабДок, Ссылка, Тип,,ИмяДопИмениОбластей, СоСрокомДоставки)
	//КонецЕсли;
	
	
	Документы.ЗаказПокупателя.Печать_СчетЗаказ(ТабДок, Ссылка, Тип, , ИмяДопИмениОбластей,,СоСрокомДоставки, "ИнтернетЗаказПокупателя");
	
КонецПроцедуры
Процедура Печать_Квитанция(ТабДок, Ссылка, Тип, ИмяДопИмениОбластей = "", СоСрокомДоставки = Ложь) Экспорт
	
	Документы.ЗаказПокупателя.Печать_СчетЗаказ(ТабДок, Ссылка, "Квитанция",,,,,"ИнтернетЗаказПокупателя");  

	//СформироватьПечатнуюФорму_уд(ТабДок, Ссылка, Тип,,ИмяДопИмениОбластей, СоСрокомДоставки)
	
КонецПроцедуры

