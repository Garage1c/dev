﻿
Процедура СообщитьОшибку(Текст, Поле = Неопределено, КлючДанныхОбъект = Неопределено) Экспорт

	Сообщение = Новый СообщениеПользователю;
	
	Если Поле <> Неопределено Тогда
		Сообщение.Поле = Поле; КонецЕсли;
	
	Сообщение.Текст = Текст;
	
	Если КлючДанныхОбъект <> Неопределено Тогда
		Сообщение.УстановитьДанные(КлючДанныхОбъект); КонецЕсли;
		
	Сообщение.Сообщить();
	
	ЗаписьЖурналаРегистрации("Ошибка резервного копирования", УровеньЖурналаРегистрации.Ошибка,,КлючДанныхОбъект,Текст);
		
КонецПроцедуры

Функция ПолучитьСписокФайловДляКопирования(Задание) Экспорт
	
	стрФайлов = Новый Массив;
	массФайлов = НайтиФайлы(Задание.ПутьИсточник, Задание.Маска, Задание.ВключатьПодкаталоги);
	Для Каждого Файл Из массФайлов Цикл стрФайлов.Добавить(Новый Структура("ПолноеИмя, ЭтоКаталог", Файл.ПолноеИмя, Файл.ЭтоКаталог())); КонецЦикла;
	
	Возврат стрФайлов;
	
КонецФункции
Функция ПолучитьПутиКАрхивам(Задание, ИмяНовогоZIP)
	
	Файлы 	= Новый Массив;
	Инд 	= 0;
	
	ФайлИсточник 	= Новый Файл(Задание.ПутьИсточник);
	ИмяZIP			= Задание.ПутьПриемник + ?(Прав(Задание.ПутьПриемник,1) = "\", "", "\") + ФайлИсточник.ИмяБезРасширения;
	ИмяНовогоZIP	= ИмяZIP + ".zip";
	ФайлПриемник 	= Новый Файл(ИмяНовогоZIP);
	
	Пока ФайлПриемник.Существует() Цикл Инд = Инд + 1; Файлы.Добавить(ФайлПриемник.ПолноеИмя);
		
		ИмяНовогоZIP = ИмяZIP + Формат(Инд, "ЧГ=") + ".zip";
		ФайлПриемник = Новый Файл(ИмяНовогоZIP); КонецЦикла;
	
	Возврат Файлы;
	
КонецФункции
Функция ПолучитьЭлементZIP(ИмяФайла, МассивАрхивов)
	
	// Ищем файл задом наперед, т.к. последний он и в африке послежний
	
	Кол = МассивАрхивов.Количество();
	Для Ном = 1 По Кол Цикл
		
		ЧтениеZIP = Новый ЧтениеZipФайла(МассивАрхивов[Кол - Ном]);
		Элемент = ЧтениеZIP.Элементы.Найти(ИмяФайла);
		
		Если Элемент <> Неопределено Тогда
			Возврат Элемент; КонецЕсли; КонецЦикла;
	
	
КонецФункции

Функция ФайлУстарел(ФайлИлиПуть, КолДней)
	
	текФайл = ?(ТипЗнч(ФайлИлиПуть) = Тип("Строка"), Новый Файл(ФайлИлиПуть), ФайлИлиПуть);
	Возврат ?(КолДней, (ТекущаяДата() - текФайл.ПолучитьВремяИзменения()) / 86400 > КолДней, Ложь);
	
КонецФункции

Функция СкопироватьФайлЕслиИзменен(ПутьКФайлу, ЭтоКаталог, Задание, МассивАрхивов, ЗаписьZIP, ФайлыСкопированы) Экспорт
	
	// Каталоги для архивов обрабатывает архиватр сам поэтому мы с ними не работаем
	
	Если 	(ЭтоКаталог И Задание.Сжимать) ИЛИ 
			(Не ЭтоКаталог И ФайлУстарел(ПутьКФайлу, Задание.УдалятьФайлыСтарше)) Тогда Возврат Истина КонецЕсли;
	
	ВремяПриемника = '00010101';
	
	// Определимся кто где
	
	ПутьПриемник		= Задание.ПутьПриемник;
	ФайлИсточник 		= Новый Файл(ПутьКФайлу);
	
	ФайлПриемник 		= Новый Файл(ПутьПриемник + ?(Прав(ПутьПриемник, 1) = "\", "", "\") + ФайлИсточник.Имя);
	ИсточникСуществует	= ФайлПриемник.Существует();
	
	// Узнаем время изменения файла
	
	Если Задание.Сжимать Тогда // Получим в архиве
		
		Элемент = ПолучитьЭлементZIP(ФайлИсточник.Имя,  МассивАрхивов);
		Если Элемент <> Неопределено Тогда
			
			ИсточникСуществует 	= Истина;
			ВремяПриемника 		= Элемент.ВремяИзменения; КонецЕсли;
		
	ИначеЕсли ИсточникСуществует Тогда
		
		ВремяПриемника = ФайлПриемник.ПолучитьВремяИзменения() КонецЕсли;
		
	// Проверм есть смысл копировать или нет
	
	Если ИсточникСуществует И 
			(	ЭтоКаталог Или
				ВремяПриемника >= ФайлИсточник.ПолучитьВремяИзменения()) Тогда
			
		Возврат Истина; КонецЕсли;
	
	// Скопируем
	
	Если ЭтоКаталог Тогда
		
		Попытка СоздатьКаталог(ФайлПриемник.ПолноеИмя);
		Исключение 	СообщитьОшибку("Ошибка создания каталога """ + ФайлИсточник.ПолноеИмя + """ " + ОписаниеОшибки()); Возврат Ложь; КонецПопытки;
		
		//  Установим время точно такое же как и источнике
		
		ФайлПриемник.УстановитьВремяИзменения(ФайлИсточник.ПолучитьВремяИзменения());
		
	Иначе
		
		ФайлыСкопированы = Истина;
		
		Если Задание.Сжимать Тогда
			
			ЗаписьZIP.Добавить(ФайлИсточник.ПолноеИмя, РежимСохраненияПутейZIP.СохранятьПолныеПути);
			
		Иначе
			ЗаписьЖурналаРегистрации("Копируем файл", УровеньЖурналаРегистрации.Информация,,Задание,"Из: " + ФайлИсточник.ПолноеИмя + "
																									|В: " + ФайлПриемник.ПолноеИмя);
			Попытка 	КопироватьФайл(ФайлИсточник.ПолноеИмя, ФайлПриемник.ПолноеИмя);	
			Исключение 	СообщитьОшибку("Ошибка копирования файла """ + ФайлИсточник.ПолноеИмя + """ " + ОписаниеОшибки()); Возврат Ложь; КонецПопытки; 
			
		//  Установим время точно такое же как и источнике
		
		ФайлПриемник.УстановитьВремяИзменения(ФайлИсточник.ПолучитьВремяИзменения()); КонецЕсли;КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура УдалитьУстарелыеФайлы(Задание)
	
	// Удалим файлы количество дней которых превысило
	
	КолДней = Задание.УдалятьФайлыСтарше;
	
	Если КолДней Тогда
		
		массФайлов = НайтиФайлы(Задание.ПутьПриемник, Задание.Маска, Задание.ВключатьПодкаталоги);
		
		Для Каждого Файл Из массФайлов Цикл Если ФайлУстарел(Файл, КолДней) Тогда УдалитьФайлы(Файл.ПолноеИмя); КонецЕсли; КонецЦикла; КонецЕсли;
	
КонецПроцедуры

Процедура КопированиеФайловВРезерв(Задание) Экспорт
	
	Перем ЗаписьZIP;
	
	ВремяСтарта = ТекущаяДата();
	ПутиКФайлам = ПолучитьСписокФайловДляКопирования(Задание);
	
	// Удалим файлы которые устарели
	
	УдалитьУстарелыеФайлы(Задание);
	
	// Проверим чего делать
	
	Если Не ПутиКФайлам.Количество() Тогда
		ЗаписьЖурналаРегистрации("Нет файлов для копирования", УровеньЖурналаРегистрации.Предупреждение,,Задание,"При выполнении копирования не найден ни один файл для копирования
																														|Путь источник = " + Задание.ПутьИсточник); КонецЕсли;
	// Подготовим архив
	
	Если Задание.Сжимать Тогда 
		
		ИмяНовогоZIP 	= "";
		МассивАрхивов 	= ПолучитьПутиКАрхивам(Задание, ИмяНовогоZIP);
		ЗаписьZIP 		= Новый ЗаписьZipФайла(ИмяНовогоZIP); КонецЕсли;
	
	// Сообщим
	
	ЗаписьЖурналаРегистрации("Запущено задание копирования файлов", УровеньЖурналаРегистрации.Информация,,Задание,"Задание запущено
																														|Путь источник = " + Задание.ПутьИсточник + "
																														|Путь приемник = " + Задание.ПутьПриемник);
	// Скопируем
	
	ФайлыСкопированы = Ложь;
	
	Для Каждого ПутьКФайлу Из ПутиКФайлам Цикл
		
		Если Не СкопироватьФайлЕслиИзменен(ПутьКФайлу.ПолноеИмя, ПутьКФайлу.ЭтоКаталог, Задание, МассивАрхивов, ЗаписьZIP, ФайлыСкопированы) Тогда 
			Возврат; КонецЕсли; КонецЦикла;
	
	// Создадим архив
	
	Если ФайлыСкопированы И Задание.Сжимать Тогда
		Попытка 	ЗаписьZIP.Записать();
		Исключение 	СообщитьОшибку("Ошибка создания zip файла """ + ИмяНовогоZIP + """ " + ОписаниеОшибки()); КонецПопытки; КонецЕсли;
		
	// Удалим
	
	Если Задание.Перемещать Тогда
		Для Каждого ПутьКФайлу Из ПутиКФайлам Цикл УдалитьФайлы(ПутьКФайлу) КонецЦикла; КонецЕсли;
		
	// Сообщим
		
	ЗаписьЖурналаРегистрации("Заершено задание копирования файлов", УровеньЖурналаРегистрации.Информация,,Задание,"Задание успешно завершилось, время работы " + Строка(ТекущаяДата() - ВремяСтарта) + "сек.
																														|Путь источник = " + Задание.ПутьИсточник + "
																														|Путь приемник = " + Задание.ПутьПриемник);
КонецПроцедуры
