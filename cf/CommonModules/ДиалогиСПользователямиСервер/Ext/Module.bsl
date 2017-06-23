﻿
Функция ПоместитьДокументВордВХранилище(ДокумнтВорд, Индекс = 0, ИмяФайла = "", Замена = Неопределено) Экспорт
	
	Строка 		= ДокумнтВорд.ДвоичныеДанные[Индекс];
	ИмяФайла 	= Строка.ИмяФайла;
	Замена 		= Строка.Замена;
	
	Возврат ПоместитьВоВременноеХранилище(Строка.Макет.Получить());
	
КонецФункции

Функция ПолучитьСоответствиеОбязательныхЗамен(ДокумнтВорд, Замена) Экспорт
	
	Соотв = Новый Соответствие;
	Для Каждого СтрокаОб Из ДокумнтВорд.ОбязательныеЗамены Цикл
		
		СтрокиЗам = Замена.Замены.НайтиСтроки(Новый Структура("ЧтоЗаменять", СтрокаОб.ТекстЗамены));
		
		Если Не СтрокиЗам.Количество() Тогда
			ВызватьИсключение "Не найдена обязательная замена в заменах: " + СтрокаОб.ТекстЗамены; КонецЕсли;
		
		Соотв.Вставить(СтрокаОб.ТекстЗамены, СтрокиЗам[0].НаЧтоЗаменять); КонецЦикла;
	
	Возврат Соотв;

КонецФункции
Функция ПолучитьСоответствиеЗамен(Замена) Экспорт
	
	Соотв = Новый Соответствие;
	СоотвВК = Новый Соответствие;  //верх колонтитул
	СоотвНК = Новый Соответствие;  //нижн колонтитул
	
	Для Каждого Строка Из Замена.Замены Цикл 
		Соотв.Вставить(Строка.ЧтоЗаменять, Строка.НаЧтоЗаменять); 
		
		Если Строка.ВерхнийКолонтитул Тогда
			СоотвВК.Вставить(Строка.ЧтоЗаменять, Строка.НаЧтоЗаменять); 
		КонецЕсли;	
		
		Если Строка.НижнийКолонтитул Тогда
			СоотвНК.Вставить(Строка.ЧтоЗаменять, Строка.НаЧтоЗаменять); 
		КонецЕсли;	
	КонецЦикла;
	
	Струк=Новый Структура("Соотв,СоотвВК,СоотвНК",Соотв,СоотвВК,СоотвНК);
	
	Возврат Струк;
	
КонецФункции

Функция ПолучитьТерриториюПартнераСтр(Контрагент) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ Регион.Представление Регион ИЗ РегистрСведений.РегионыПартнера ГДЕ Контрагент = &Контрагент");
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Выборка = Запрос.Выполнить().Выбрать();
	
	стр = "";
	Пока Выборка.Следующий() Цикл стр = стр + ?(стр = "", "", "; ") + Выборка.Регион КонецЦикла;
	Возврат Стр;
	
КонецФункции

Функция ПолучитьСтруктуруДоговора(Контрагент, ИндексДоговора) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ * ИЗ Справочник.Контрагенты.Организации ГДЕ Ссылка = &Контрагент И НомерСтроки = " + Формат(ИндексДоговора + 1, "ЧГ="));
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Возврат КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Запрос.Выполнить().Выгрузить());
	
КонецФункции

Функция ВычислитьНаСервере(Код1с, Организация = Неопределено, Контрагент = Неопределено, ИндексДоговора = 0) Экспорт
	
	Попытка
		Результат = Вычислить(Код1с);
	Исключение
		стрОшибки = ОписаниеОшибки();
		ОбщиеФункции.СообщитьТекст("Ошибка при вычислении выражения на сервере:
										|" + код1с + "
										|" + стрОшибки); 
		Возврат "!Ошибка в вычислении кода!"; КонецПопытки;
									
	Возврат Результат;
	
КонецФункции


Функция ПолучитьРазрешенныеСкладыПользователя(Склад)
	
	Склады = Новый Массив;
	Склады.Добавить(Склад);
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ Склад ИЗ Справочник.Склады.ПорядокРазмещения ГДЕ Ссылка = &Склад");
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл Склады.Добавить(Выборка.Склад) КонецЦикла;
	
	Возврат Склады;
	
КонецФункции
Функция РазрешеноДанноеРазмещениеПользователю(Склад, Таблица) Экспорт
	
	Разрешено = Истина;
	
	Если ПараметрыСеанса.ТекущийПользователь.ЗапретЧужихРазмещений Тогда
	
		Склады = ПолучитьРазрешенныеСкладыПользователя(Склад);
		
		Инд = -1; ТипСклад = Тип("СправочникСсылка.Склады");
		Для Каждого Строка Из Таблица Цикл Инд = Инд + 1;
			Если Не Строка.Собрано И Не Строка.Отгружено И ТипЗнч(Строка.Размещение) = ТипСклад И Склады.Найти(Строка.Размещение) = Неопределено Тогда Разрешено = Ложь;
				ОбщиеФункции.СообщитьТекст("Вам запрещено размещать на данном складе!", "Товары[" + Формат(Инд, "ЧГ=") + "].Размещение"); КонецЕсли; КонецЦикла; КонецЕсли;

    Возврат Разрешено;
	
КонецФункции

#Область Пароль

Функция ПользователюНужноСменитьПароль() Экспорт
	
	Возврат ПараметрыСеанса.ТекущийПользователь.УстановитьНовыйПарольПриВходе;
	
КонецФункции
Процедура УстановитьПароль(Пароль) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Установим пароль
	
	//ДлинаИмени = СтрДлина(ИмяПользователя());
	
	ПользовательСистемы = ПользователиИнформационнойБазы.ТекущийПользователь();
	//ПользовательСистемы = ПользователиИнформационнойБазы.НайтиПоИмени(Лев(ПараметрыСеанса.ТекущийПользователь.Код, ДлинаИмени));
	ПользовательСистемы.Пароль = Пароль;
	ПользовательСистемы.Записать();
	
	// Сменим требование установить пароль
	
	Спр = ПараметрыСеанса.ТекущийПользователь.ПолучитьОбъект();
	Спр.УстановитьНовыйПарольПриВходе = Ложь;
	Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Спр) Тогда
		ВызватьИсключение "Ошибка сброса пароля"; КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ПолучитьСсылкиНаКартинкиИзБазыДляВыгрузкиНаДиск(Ссылки) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ ВЫБОР КОГДА КопияКартинки = &ПустаяКартинка ТОГДА Ссылка ИНАЧЕ КопияКартинки КОНЕЦ КАК Ссылка, Наименование, РасширениеКартинка Расширение, Картинка ИЗ Справочник.КартинкиНоменклатуры ГДЕ Владелец В(&Ссылки) И КопияКартинки = &ПустаяКартинка И Не ПометкаУдаления");
	
	Запрос.УстановитьПараметр("Ссылки", 		Ссылки);
	Запрос.УстановитьПараметр("ПустаяКартинка", Справочники.КартинкиНоменклатуры.ПустаяСсылка());
	
	Массив 	= Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Картинка.Получить() <> Неопределено Тогда
			
			Имя 			= Выборка.Наименование;
			стрДлинаРасш 	= СтрДлина(Выборка.Расширение);
			
			Если стрДлинаРасш И Врег(Прав(Выборка.Наименование, стрДлинаРасш)) <> Врег(Выборка.Расширение) Тогда
				Имя = Имя + "." + Выборка.Расширение; КонецЕсли;
				
			Массив.Добавить(Новый Структура("Ссылка, Наименование", Выборка.Ссылка, Имя)); КонецЕсли; КонецЦикла;
	
	Возврат Массив;
	
КонецФункции


Процедура ЗаписатьВремяНаСервере(Гуид, Структура) Экспорт
	
	Запись = РегистрыСведений.ЗамерыВремени.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, Структура);
	Запись.ГуидСобытия 	= Гуид;
	Запись.Пользователь = ПараметрыСеанса.ТекущийПользователь;
	ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Запись,,,Ложь);
	
КонецПроцедуры

//Процедура УдалитьОдинокиеСтроки(Строка)
//	
//	// Обработаем по иерархии
//	
//	НетСтрок = Истина;
//	Для Каждого ВложСтрока Из Строка.Строки Цикл НетСтрок = Ложь; УдалитьОдинокиеСтроки(ВложСтрока); КонецЦикла;
//	
//	// Удалим если строка одинока
//	
//	Если НетСтрок И Строка.Уровень() Тогда
//		Строка.Родитель.Удалить(Строка);КонецЕсли;
//		
//КонецПроцедуры
