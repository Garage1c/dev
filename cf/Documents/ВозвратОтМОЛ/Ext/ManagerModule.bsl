﻿Процедура ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства) Экспорт
	ИменаРегистров = Новый Массив;
	ПоВсем=Ложь;
	Если Не ДополнительныеСвойства.Свойство("ИменаРегистров",ИменаРегистров) Тогда
		ПоВсем=Истина;
		ИменаРегистров = Новый Массив;
	КонецЕсли;	
	
	
	ТекстЗапроса=КэшируемыеФункции.ТектЗапросаПолученияПараметровСистемы() +Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
	
	"ВЫБРАТЬ
	|	Склад, МОЛ
	|ИЗ
	|	Документ.ВозвратОтМОЛ
	|ГДЕ
	|	Ссылка = &Ссылка";
	
	
	Нтаб=Новый Структура;
	ТекНомер=1;	
	
	Если ИменаРегистров.Найти("ТоварыНаСкладах")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("ТоварыНаСкладах",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
	
		
		// ТОВАРЫ НА СКЛАДАХ
		
		"ВЫБРАТЬ
		|	&Период КАК Период,
		|	&ВидДвиженияПриход КАК ВидДвижения,
		|	ВозвратОтМОЛТовары.Ссылка.Склад КАК Склад,
		|	ВозвратОтМОЛТовары.Номенклатура,
		|	ВЫБОР
		|		КОГДА ВозвратОтМОЛТовары.Упаковка = &ПустаяУпаковка
		|			ТОГДА СУММА(ВозвратОтМОЛТовары.Количество)
		|		ИНАЧЕ СУММА(ВозвратОтМОЛТовары.Количество * ВозвратОтМОЛТовары.Упаковка.Коэффициент)
		|	КОНЕЦ КАК Количество
		|ИЗ
		|	Документ.ВозвратОтМОЛ.Товары КАК ВозвратОтМОЛТовары
		|ГДЕ
		|	ВозвратОтМОЛТовары.Ссылка = &Ссылка
		|	И НЕ ВозвратОтМОЛТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВозвратОтМОЛТовары.Ссылка,
		|	ВозвратОтМОЛТовары.Номенклатура,
		|	ВозвратОтМОЛТовары.Упаковка,
		|	ВозвратОтМОЛТовары.Ссылка.Склад"
		
	КонецЕсли;
	
	Если ИменаРегистров.Найти("ТоварыМОЛ")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("ТоварыМОЛ",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
	
		
		// ТОВАРЫ Материально ответственных лиц
		
		"ВЫБРАТЬ
		|	&Период КАК Период,
		|	&ВидДвиженияРасход КАК ВидДвижения,
		|	ВозвратОтМОЛТовары.Ссылка.МОЛ КАК МОЛ,
		|	ВозвратОтМОЛТовары.Номенклатура,
		|	ВЫБОР
		|		КОГДА ВозвратОтМОЛТовары.Упаковка = &ПустаяУпаковка
		|			ТОГДА СУММА(ВозвратОтМОЛТовары.Количество)
		|		ИНАЧЕ СУММА(ВозвратОтМОЛТовары.Количество * ВозвратОтМОЛТовары.Упаковка.Коэффициент)
		|	КОНЕЦ КАК Количество
		|ИЗ
		|	Документ.ВозвратОтМОЛ.Товары КАК ВозвратОтМОЛТовары
		|ГДЕ
		|	ВозвратОтМОЛТовары.Ссылка = &Ссылка
		|	И НЕ ВозвратОтМОЛТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВозвратОтМОЛТовары.Ссылка,
		|	ВозвратОтМОЛТовары.Номенклатура,
		|	ВозвратОтМОЛТовары.Упаковка,
		|	ВозвратОтМОЛТовары.Ссылка.Склад"
		
	КонецЕсли;

	
	Запрос=Новый Запрос;
	Запрос.Текст=ТекстЗапроса;
	
	//Запрос.УстановитьПараметр("Область", 			ПараметрыСеанса.ТекущаяОбласть);
	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.УстановитьПараметр("Период", 			Ссылка.Дата);
	//Запрос.УстановитьПараметр("ПустаяЯчейка", 		Справочники.Ячейки.ПустаяСсылка());
	Запрос.УстановитьПараметр("ВидДвиженияПриход", 	ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("ВидДвиженияРасход", 	ВидДвиженияНакопления.Расход);
	Запрос.УстановитьПараметр("ПустаяУпаковка", 	Справочники.УпаковкиНоменклатуры.ПустаяСсылка());
	
	Запрос.УстановитьПараметр("Организация", 		Ссылка.Организация);
	//Запрос.УстановитьПараметр("Контрагент", 		Ссылка.Контрагент);
	//Запрос.УстановитьПараметр("ВидОперацииОплата", 	Перечисления.ВидыОперацийВзаиморасчетов.Отгрузка);
	//Запрос.УстановитьПараметр("ФормаОтношений", 	Перечисления.ФормаОтношений.Поставщик);
	//Запрос.УстановитьПараметр("ПустойЗаказПоставщику", Документы.ЗаказПоставщику.ПустаяСсылка());
	
	
	Пакет = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.Вставить("ПараметрыСистемы", КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[0].Выгрузить()));
	ДополнительныеСвойства.Вставить("Шапка", 			КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[1].Выгрузить()));
	
	Для Каждого Элем Из Нтаб Цикл
		ДополнительныеСвойства.Вставить(Элем.Ключ,Пакет[Элем.Значение].Выгрузить());
	КонецЦикла;	
	

КонецПроцедуры

Процедура Печать_М11(ТабДок, Ссылка) Экспорт
	Макет = Документы.ВыдачаНаМОЛ.ПолучитьМакет("М11");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПРЕДСТАВЛЕНИЕ(ВозвратОтМОЛ.Организация) КАК Организация,
		|	ПРЕДСТАВЛЕНИЕ(ВозвратОтМОЛ.МОЛ) КАК Отправитель,
		|	ПРЕДСТАВЛЕНИЕ(ВозвратОтМОЛ.Склад) КАК Получатель,
		|	ВозвратОтМОЛ.Дата КАК ДатаСоставления
		|ИЗ
		|	Документ.ВозвратОтМОЛ КАК ВозвратОтМОЛ
		|ГДЕ
		|	ВозвратОтМОЛ.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПРЕДСТАВЛЕНИЕ(ВозвратОтМОЛТовары.Номенклатура) КАК Номенклатура,
		|	ВЫБОР
		|		КОГДА ВозвратОтМОЛТовары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
		|			ТОГДА ПРЕДСТАВЛЕНИЕ(ВозвратОтМОЛТовары.Номенклатура.ЕдиницаИзмерения)
		|		ИНАЧЕ ПРЕДСТАВЛЕНИЕ(ВозвратОтМОЛТовары.Упаковка)
		|	КОНЕЦ КАК ЕдиницаИзмерения,
		|	ВЫБОР
		|		КОГДА ВозвратОтМОЛТовары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
		|			ТОГДА ВозвратОтМОЛТовары.Номенклатура.ЕдиницаИзмерения.Код
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК ЕдиницаИзмеренияКод,
		|	ВозвратОтМОЛТовары.Количество КАК Количество,
		|	ВозвратОтМОЛТовары.Цена,
		|	ВозвратОтМОЛТовары.Сумма,
		|	ВозвратОтМОЛТовары.Номенклатура.Артикул КАК Артикул
		|ИЗ
		|	Документ.ВозвратОтМОЛ.Товары КАК ВозвратОтМОЛТовары
		|ГДЕ
		|	ВозвратОтМОЛТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Пакет = Запрос.ВыполнитьПакет();
	Выборка = Пакет[0].Выбрать();
	Выборка.Следующий();
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.Заполнить(Выборка);
	
	ТабДок.Вывести(ОбластьШапка);
	
	Выборка = Пакет[1].Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		ОбластьСтрока.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(ОбластьСтрока);
	КонецЦикла;
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ТабДок.Вывести(ОбластьПодвал);
КонецПроцедуры	