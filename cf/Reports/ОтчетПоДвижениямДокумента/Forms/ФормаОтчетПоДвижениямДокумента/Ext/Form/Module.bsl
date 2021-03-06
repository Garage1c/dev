﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
// Функция возвращает непустые движения документа.
//
Функция ОпределитьНаличиеДвиженийПоРегистратору() 

	ДвиженияДокумента = Отчет.Документ.Метаданные().Движения;
	
	Если ДвиженияДокумента.Количество() = 0 Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;

	ТекстЗапроса = "";
	Для Каждого Движение ИЗ ДвиженияДокумента Цикл
		
		ТекстЗапроса = ТекстЗапроса + "
		|" + ?(ТекстЗапроса = "", "", "ОБЪЕДИНИТЬ ВСЕ ") + "
		|ВЫБРАТЬ ПЕРВЫЕ 1 ВЫРАЗИТЬ(""" + Движение.ПолноеИмя() 
		+  """ КАК Строка(200)) КАК Имя ИЗ " + Движение.ПолноеИмя() 
		+ " ГДЕ Регистратор = &Регистратор";
		
	КонецЦикла;

	Запрос = Новый Запрос(ТекстЗапроса);
	ЗАпрос.УстановитьПараметр("Регистратор", Отчет.Документ);

	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	ТаблицаЗапроса.Индексы.Добавить("Имя");

	Для Каждого СтрокаТаблицыДвижений Из ТаблицаЗапроса Цикл		
		СтрокаТаблицыДвижений.Имя = Врег(СокрЛП(СтрокаТаблицыДвижений.Имя));
	КонецЦикла;

	Возврат ТаблицаЗапроса;

КонецФункции

&НаСервере
// Функция возвращает вид регистра.
//
Функция ОпределитьВидРегистра(МетаданныеРегистра)

	Результат = "";
	Если Метаданные.РегистрыНакопления.Индекс(МетаданныеРегистра) >= 0 Тогда

		Результат = "Накопления";

	ИначеЕсли Метаданные.РегистрыСведений.Индекс(МетаданныеРегистра) >= 0 Тогда

		Результат = "Сведений";	

	ИначеЕсли Метаданные.РегистрыБухгалтерии.Индекс(МетаданныеРегистра) >= 0 Тогда

		Результат = "Бухгалтерии";

	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаСервере
// Процедура формирует список полей для запроса.
//
Процедура СформироватьСписокПолей(МетаданныеРесурса, ТаблицаПолей, СписокПолей)

	Для Каждого Ресурс Из МетаданныеРесурса Цикл

		СписокПолей = СписокПолей + ", "+ Ресурс.Имя;
		ТаблицаПолей.Колонки.Добавить(Ресурс.Имя, , Ресурс.Синоним);

	КонецЦикла;

КонецПроцедуры

&НаСервере
// Процедура добавляет период в список полей для запроса.
//
Процедура ДобавитьПериодВСписокПолей(ТаблицаПолей, СписокПолей)
	
	СписокПолей = СписокПолей + ", Период";
	ТаблицаПолей.Колонки.Добавить("Период", , "Период");
	
КонецПроцедуры

&НаСервере
// Процедура выводит движения по регистрам сведений и накопления.
//
Процедура ОбработатьВыводДанныхПоМассиву(СписокПолей, ТаблицаРесурсов, ТаблицаИзмерений, ТаблицаРеквизитов, ТаблицаВидДвижений = Неопределено, Знач ИмяРегистра, СинонимРегистра)
	
	Если Не ЗначениеЗаполнено(СписокПолей) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ " + СписокПолей +"
		|{ВЫБРАТЬ " + СписокПолей +"}
		|ИЗ " + ИмяРегистра + " КАК Рег
		|ГДЕ Рег.Регистратор = &ДокументОтчета";
		
	Запрос.УстановитьПараметр("ДокументОтчета", Отчет.Документ);

	ТаблицаРезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаРезультата Из ТаблицаРезультатЗапроса Цикл

		Если ТаблицаВидДвижений <> Неопределено Тогда
			НоваяСтрока = ТаблицаВидДвижений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРезультата);
		КонецЕсли;

		ЗаполнитьЗначенияСвойств(ТаблицаРесурсов.Добавить(), СтрокаРезультата);
		ЗаполнитьЗначенияСвойств(ТаблицаИзмерений.Добавить(), СтрокаРезультата);
		ЗаполнитьЗначенияСвойств(ТаблицаРеквизитов.Добавить(), СтрокаРезультата);

	КонецЦикла;
	
	Макет = Отчеты.ОтчетПоДвижениямДокумента.ПолучитьМакет("Макет");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("ЗаголовокОтчета");
		
	ОбластьЗаголовок.Параметры.СинонимРегистра = Строка(СинонимРегистра);
	ТабличныйДокумент.Вывести(ОбластьЗаголовок);
	ТабличныйДокумент.НачатьГруппуСтрок();
	КоличествоСтрокРезультата = ТаблицаРезультатЗапроса.Количество();	

	Если Отчет.СпособВыводаОтчета = Перечисления.СпособВыводаОтчета.ПоГоризонтали Тогда
	
		// Вывод в строку
		
		ОбластьЗаголовокЯчейки	 		= Макет.ПолучитьОбласть("ЗаголовокЯчейки");
		ОбластьЯчейка			 		= Макет.ПолучитьОбласть("Ячейка");
		ОбластьОтступ 					= Макет.ПолучитьОбласть("Отступ1");
		
		ТабличныйДокумент.Вывести(ОбластьОтступ);
		Если ТаблицаВидДвижений <> Неопределено Тогда
			ОбластьЗаголовокЯчейки.Параметры.ЗаголовокКолонки = "Вид движения";
			ТабличныйДокумент.Присоединить(ОбластьЗаголовокЯчейки);
		КонецЕсли;

		Для Каждого Колонка Из ТаблицаИзмерений.Колонки Цикл
			ОбластьЗаголовокЯчейки.Параметры.ЗаголовокКолонки = Колонка.Заголовок;
			ТабличныйДокумент.Присоединить(ОбластьЗаголовокЯчейки);
		КонецЦикла; 

		Для Каждого Колонка Из ТаблицаРесурсов.Колонки Цикл
			ОбластьЗаголовокЯчейки.Параметры.ЗаголовокКолонки = Колонка.Заголовок;
			ТабличныйДокумент.Присоединить(ОбластьЗаголовокЯчейки);
		КонецЦикла;
		
		Для Каждого Колонка Из ТаблицаРеквизитов.Колонки Цикл
			ОбластьЗаголовокЯчейки.Параметры.ЗаголовокКолонки = Колонка.Заголовок;
			ТабличныйДокумент.Присоединить(ОбластьЗаголовокЯчейки);
		КонецЦикла;
		
		Для НомерСтроки = 1 По КоличествоСтрокРезультата Цикл

			ТабличныйДокумент.Вывести(ОбластьОтступ);
			Если ТаблицаВидДвижений <> Неопределено Тогда

				ОбластьЯчейка.Параметры.Значение = ТаблицаВидДвижений[НомерСтроки-1].ВидДвижения;
				ТабличныйДокумент.Присоединить(ОбластьЯчейка);

				Если ТаблицаВидДвижений[НомерСтроки-1].ВидДвижения = ВидДвиженияНакопления.Расход Тогда
					Область = ТабличныйДокумент.Область("Ячейка");
					Область.ЦветТекста = Новый Цвет(255, 0, 0);
				Иначе
					Область = ТабличныйДокумент.Область("Ячейка");
					Область.ЦветТекста = Новый Цвет(0, 0, 255);
				КонецЕсли;

			КонецЕсли;

			Для Каждого Колонка Из ТаблицаИзмерений.Колонки Цикл

				ОбластьЯчейка.Параметры.Значение = ТаблицаИзмерений[НомерСтроки-1][Колонка.Имя];
				ТабличныйДокумент.Присоединить(ОбластьЯчейка);

			КонецЦикла;

			Для Каждого Колонка Из ТаблицаРесурсов.Колонки Цикл

				ОбластьЯчейка.Параметры.Значение = ТаблицаРесурсов[НомерСтроки-1][Колонка.Имя];
				ТабличныйДокумент.Присоединить(ОбластьЯчейка);

			КонецЦикла;

			Для Каждого Колонка Из ТаблицаРеквизитов.Колонки Цикл

				ОбластьЯчейка.Параметры.Значение = ТаблицаРеквизитов[НомерСтроки-1][Колонка.Имя];
				ТабличныйДокумент.Присоединить(ОбластьЯчейка);

			КонецЦикла;
			
		КонецЦикла; 
		
	Иначе
	
		// Вывод таблицы
		
		Если ТаблицаВидДвижений <> Неопределено Тогда

			ОбластьШапки 					= Макет.ПолучитьОбласть("ШапкаТаблицы");
			ОбластьДеталиШапки 				= Макет.ПолучитьОбласть("ДеталиШапки");
			ОбластьДетали 					= Макет.ПолучитьОбласть("Детали");
			ОбластьШапкиВидДвижения 		= Макет.ПолучитьОбласть("ШапкаТаблицыВидДвижения");
			ОбластьДеталиШапкиВидДвижения 	= Макет.ПолучитьОбласть("ДеталиШапкиВидДвижения");
			ОбластьДеталиВидДвижения 		= Макет.ПолучитьОбласть("ДеталиВидДвижения");
			ОбластьОтступ 					= Макет.ПолучитьОбласть("Отступ");

		Иначе

			ОбластьШапки 					= Макет.ПолучитьОбласть("ШапкаТаблицы1");
			ОбластьДеталиШапки 				= Макет.ПолучитьОбласть("ДеталиШапки1");
			ОбластьДетали 					= Макет.ПолучитьОбласть("Детали1");
			ОбластьОтступ 					= Макет.ПолучитьОбласть("Отступ2");
		КонецЕсли;

		ТабличныйДокумент.Вывести(ОбластьОтступ);

		Если ТаблицаВидДвижений <> Неопределено Тогда
			ТабличныйДокумент.Присоединить(ОбластьШапкиВидДвижения);
		КонецЕсли;

		ТабличныйДокумент.Присоединить(ОбластьШапки);

		КоличествоСтрокШапки = Макс(ТаблицаРесурсов.Колонки.Количество(), ТаблицаИзмерений.Колонки.Количество(), ТаблицаРеквизитов.Колонки.Количество());
		ТолстаяЛиния = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная,2);
		ТонкаяЛиния  = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная,1);
		
		Для НомерСтроки = 1 По КоличествоСтрокШапки Цикл
			
			ОбластьДеталиШапки.Параметры.Ресурсы = "";
			ОбластьДеталиШапки.Параметры.Измерения = "";
			ОбластьДеталиШапки.Параметры.Реквизиты = "";
			
			Если ТаблицаРесурсов.Колонки.Количество() >= НомерСтроки Тогда
				ОбластьДеталиШапки.Параметры.Ресурсы = ТаблицаРесурсов.Колонки[НомерСтроки-1].Заголовок;
			КонецЕсли;

			Если ТаблицаИзмерений.Колонки.Количество() >= НомерСтроки Тогда
				ОбластьДеталиШапки.Параметры.Измерения = ТаблицаИзмерений.Колонки[НомерСтроки-1].Заголовок;
			КонецЕсли;

			Если ТаблицаРеквизитов.Колонки.Количество() >= НомерСтроки Тогда
				ОбластьДеталиШапки.Параметры.Реквизиты = ТаблицаРеквизитов.Колонки[НомерСтроки-1].Заголовок;
			КонецЕсли;

			ТабличныйДокумент.Вывести(ОбластьОтступ);
			Если ТаблицаВидДвижений <> Неопределено Тогда
				ТабличныйДокумент.Присоединить(ОбластьДеталиШапкиВидДвижения);	
			КонецЕсли;

			ТабличныйДокумент.Присоединить(ОбластьДеталиШапки);	

			Если НомерСтроки = КоличествоСтрокШапки Тогда
			    Если ТаблицаВидДвижений <> Неопределено Тогда
					Область = ТабличныйДокумент.Область("ДеталиШапкиВидДвижения");
					Область.Обвести(ТолстаяЛиния, , ТолстаяЛиния, ТолстаяЛиния);
					Область = ТабличныйДокумент.Область("ДеталиШапки");
					Область.Обвести(ТолстаяЛиния, , ТолстаяЛиния, ТолстаяЛиния);
				Иначе	
					Область = ТабличныйДокумент.Область("ДеталиШапки1");
					Область.Обвести(ТолстаяЛиния, , ТолстаяЛиния, ТолстаяЛиния);
				КонецЕсли;
				
			КонецЕсли; 
			
		КонецЦикла; 
		
		Для НомерСтроки = 1 По КоличествоСтрокРезультата Цикл
			
			ФлагВыведенВидДвижения = Ложь;
			
			Для НомерКолонки = 1 По КоличествоСтрокШапки Цикл
			
				ОбластьДетали.Параметры.Ресурсы = "";
				ОбластьДетали.Параметры.Измерения = "";
				ОбластьДетали.Параметры.Реквизиты = "";
				
				Если ТаблицаРесурсов.Колонки.Количество() >= НомерКолонки Тогда
					ИмяКолонки = ТаблицаРесурсов.Колонки[НомерКолонки-1].Имя;
					ОбластьДетали.Параметры.Ресурсы = ТаблицаРесурсов[НомерСтроки-1][ИмяКолонки];
				КонецЕсли;

				Если ТаблицаИзмерений.Колонки.Количество() >= НомерКолонки Тогда
					ИмяКолонки = ТаблицаИзмерений.Колонки[НомерКолонки-1].Имя;
					ОбластьДетали.Параметры.Измерения = ТаблицаИзмерений[НомерСтроки-1][ИмяКолонки];
				КонецЕсли;

				Если ТаблицаРеквизитов.Колонки.Количество() >= НомерКолонки Тогда
					ИмяКолонки = ТаблицаРеквизитов.Колонки[НомерКолонки-1].Имя;
					ОбластьДетали.Параметры.Реквизиты = ТаблицаРеквизитов[НомерСтроки-1][ИмяКолонки];
				КонецЕсли;

				ТабличныйДокумент.Вывести(ОбластьОтступ);
				
				Если ТаблицаВидДвижений <> Неопределено Тогда

					Если ФлагВыведенВидДвижения Тогда
						ЗначениеПараметра = "";
					Иначе
						ЗначениеПараметра = ТаблицаВидДвижений[НомерСтроки-1]["ВидДвижения"];
						ФлагВыведенВидДвижения = Истина;
					КонецЕсли;

					ОбластьДеталиВидДвижения.Параметры.ВидДвижения = ЗначениеПараметра;
					ТабличныйДокумент.Присоединить(ОбластьДеталиВидДвижения);

					Если ЗначениеПараметра = ВидДвиженияНакопления.Расход Тогда
						Область = ТабличныйДокумент.Область("ДеталиВидДвижения");
						Область.ЦветТекста = Новый Цвет(255, 0, 0);
					ИначеЕсли ЗначениеПараметра = ВидДвиженияНакопления.Приход Тогда
						Область = ТабличныйДокумент.Область("ДеталиВидДвижения");
						Область.ЦветТекста = Новый Цвет(0, 0, 255);
					КонецЕсли;
				КонецЕсли;
				
				ТабличныйДокумент.Присоединить(ОбластьДетали);
				
				Если НомерКолонки = КоличествоСтрокШапки Тогда

					Если ТаблицаВидДвижений <> Неопределено Тогда
						Область = ТабличныйДокумент.Область("ДеталиВидДвижения");
						Область.Обвести(ТонкаяЛиния, , ТонкаяЛиния, ТонкаяЛиния);
						Область = ТабличныйДокумент.Область("Детали");
						Область.Обвести(ТонкаяЛиния, , ТонкаяЛиния, ТонкаяЛиния);
					Иначе
						Область = ТабличныйДокумент.Область("Детали1");
						Область.Обвести(ТонкаяЛиния, , ТонкаяЛиния, ТонкаяЛиния);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;

	ТабличныйДокумент.ЗакончитьГруппуСтрок();

КонецПроцедуры

&НаСервере                                              
// Процедура формирует отчет на сервере.
//
Процедура СформироватьОтчет()
	
	Если Не ЗначениеЗаполнено(Отчет.Документ) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбран документ!'"), Отчет);
		Возврат;
	КонецЕсли;

	ТабличныйДокумент.Очистить();
	Макет = Отчеты.ОтчетПоДвижениямДокумента.ПолучитьМакет("Макет");
	ДвиженияДокумента = Отчет.Документ.Метаданные().Движения;
		
	// Вывод заголовка
	ОбластьЗаголовок = Макет.ПолучитьОбласть("ГлавныйЗаголовок");
	ОбластьЗаголовок.Параметры.Документ = Строка(Отчет.Документ);
	ТабличныйДокумент.Вывести(ОбластьЗаголовок);

	// Поиск регистров, по которым есть движения
	ТаблицаДвижений = ОпределитьНаличиеДвиженийПоРегистратору();
	
	// Перебор движений
	Для Каждого СвойстваОбъекта Из ДвиженияДокумента Цикл
		
		// Проверка, есть ли движения по регистру
		СтрокаВТаблицеРегистров = ТаблицаДвижений.Найти(Врег(СвойстваОбъекта.ПолноеИмя()), "Имя");
		
		Если СтрокаВТаблицеРегистров = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ВидРегистра    = ОпределитьВидРегистра(СвойстваОбъекта);
		ИмяРегистра     = "Регистр" + ВидРегистра + "." + СвойстваОбъекта.Имя;
		СинонимРегистра = "Регистр " + НРег(ВидРегистра) + " """ + СвойстваОбъекта.Синоним + """";
		
		Если ВидРегистра = "Сведений" ИЛИ ВидРегистра = "Накопления" Тогда
			
			СписокПолей       = "";
			ТаблицаРесурсов   = Новый ТаблицаЗначений;
			ТаблицаИзмерений  = Новый ТаблицаЗначений;
			ТаблицаРеквизитов = Новый ТаблицаЗначений;
			
			Если Не (ВидРегистра = "Сведений"
					И СвойстваОбъекта.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический) Тогда

				ДобавитьПериодВСписокПолей(ТаблицаИзмерений, СписокПолей);
			КонецЕсли;

			СформироватьСписокПолей(СвойстваОбъекта.Ресурсы, ТаблицаРесурсов, СписокПолей);
			СформироватьСписокПолей(СвойстваОбъекта.Измерения, ТаблицаИзмерений, СписокПолей);
			СформироватьСписокПолей(СвойстваОбъекта.Реквизиты, ТаблицаРеквизитов, СписокПолей);
			СписокПолей = Прав(СписокПолей, СтрДлина(СписокПолей)-2);
			
			Если (ВидРегистра = "Накопления") И (СвойстваОбъекта.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки) Тогда

				СписокПолей = СписокПолей + ", ВидДвижения";
				ТаблицаВидДвижений = Новый ТаблицаЗначений;
				ТаблицаВидДвижений.Колонки.Добавить("ВидДвижения", , "Вид движения");
				ОбработатьВыводДанныхПоМассиву(СписокПолей, ТаблицаРесурсов, ТаблицаИзмерений, ТаблицаРеквизитов, ТаблицаВидДвижений, ИмяРегистра, СинонимРегистра);

			Иначе

				ОбработатьВыводДанныхПоМассиву(СписокПолей, ТаблицаРесурсов, ТаблицаИзмерений, ТаблицаРеквизитов, , ИмяРегистра, СинонимРегистра);

			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("Документ", Отчет.Документ);
	Отчет.СпособВыводаОтчета = Перечисления.СпособВыводаОтчета.ПоГоризонтали;
	СформироватьОтчет();
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик нажатия на кнопку "Сформировать".
//
Процедура СформироватьВыполнить()

	СформироватьОтчет();

КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()

	СформироватьОтчет();

КонецПроцедуры

