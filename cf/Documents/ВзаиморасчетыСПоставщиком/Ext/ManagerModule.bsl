﻿
Процедура ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос(
	
	// ПАРАМЕТРЫ СИСТЕМЫ
	
	КэшируемыеФункции.ТектЗапросаПолученияПараметровСистемы() + "
	|;
	
	// Курсы валют
	
	|" + РаботаСКурсамиВалют.ПолучитьТекстЗапросаКурсыВалют() + "
	|;
	
	// ВЗАИМОРАСЧЕТЫ
	
	|ВЫБРАТЬ
	|	Дата				Период,
	|	&ВидДвижения		ВидДвижения,
	|	Организация			Организация,
	|	Контрагент			Контрагент,
	|   &ФормаОтношений 	ФормаОтношений,
	|   Сумма,
	|" + РаботаСКурсамиВалют.ПолучитьСуммуУпрВЗапросе("Сумма") + " СуммаУпр
	|ИЗ
	|	Документ.ВзаиморасчетыСПоставщиком
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ 
	|	КурсыВалют ПО ИСТИНА
	|ГДЕ
	|	Ссылка = &Ссылка
	|;
	
	//// ДОЛГИ КОНТРАГЕНТОВ
	//
	//|ВЫБРАТЬ 
	//|	&ВидОперации ВидОперации, &ФормаОтношений ФормаОтношений, Док.Организация, Док.Контрагент, Ссылка Документ, Док.Дата Дата, Док.Дата Период,
	//|	ЕСТЬNULL(СуммаУпрОстаток, 0) - " + РаботаСКурсамиВалют.ПолучитьСуммуУпрВЗапросе("Сумма") + " Сумма
	//|ИЗ
	//|	РегистрНакопления.Взаиморасчеты.Остатки(&Период, Организация = &Организация И Контрагент = &Контрагент)
	//|
	//|ПРАВОЕ СОЕДИНЕНИЕ
	//|	(	ВЫБРАТЬ Дата, Организация, Контрагент, Ссылка, Сумма ИЗ Документ.ВзаиморасчетыСПоставщиком ГДЕ Ссылка = &Ссылка
	//|		И Контрагент <> &ПустойКонтрагент) Док
	//|ПО ИСТИНА
	//|
	//|ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют ПО ИСТИНА
	|");
	
	Запрос.УстановитьПараметр("Период", 			Ссылка.Дата);
	Запрос.УстановитьПараметр("Валюта", 			Ссылка.Валюта);
	Запрос.УстановитьПараметр("ВидОперации",		Перечисления.ВидыОперацийВзаиморасчетов.Корректировка);
	Запрос.УстановитьПараметр("ФормаОтношений",		Перечисления.ФормаОтношений.Поставщик);
	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.УстановитьПараметр("ВидДвижения", 		ВидДвиженияНакопления.Расход);
	Запрос.УстановитьПараметр("ПустойКонтрагент",	Справочники.Контрагенты.ПустаяСсылка());
	Запрос.УстановитьПараметр("Организация",		Ссылка.Организация);
	Запрос.УстановитьПараметр("Контрагент",			Ссылка.Контрагент);
	
	Пакет = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.Вставить("Взаиморасчеты", 	Пакет[2].Выгрузить());
	//ДополнительныеСвойства.Вставить("ДолгиКонтрагентов",Пакет[3].Выгрузить());
	
КонецПроцедуры
