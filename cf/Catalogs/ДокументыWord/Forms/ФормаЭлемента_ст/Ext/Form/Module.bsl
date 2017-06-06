﻿
Функция ПолучитьАдресМакетаССервера(ИндСтрокиМакетаВБазе)
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Ссылка.ДвоичныеДанные[ИндСтрокиМакетаВБазе].Макет.Получить());
	
КонецФункции

// ТИПОВЫЕ

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПомещаемыеФайлы = Новый Соответствие;
	
	// Проверим чтобы не было пустых строк
	
	Инд = -1;
	Для Каждого Строка Из Макеты Цикл Инд = Инд + 1;
		Если 	Не Строка.НомСтрокиМакетаВБазе И 		// это новая строка
				Не Строка.ПоместитьФайлНаСервер Тогда	// и нет команды на помещение
				
			ОбщиеФункции.СообщитьТекст("Пустой файл", "Макеты[" + Формат(Инд, "ЧГ=") + "].ИмяФайла"); Отказ = Истина; КонецЕсли;
		
		// Добавим данные для записи
		
		Если Строка.ПоместитьФайлНаСервер Тогда
			Адрес = "";
			ПоместитьФайл(Адрес, Строка.ПолноеИмяФайла,,Ложь);
			ПомещаемыеФайлы.Вставить(Строка.ПолноеИмяФайла, Адрес); КонецЕсли; КонецЦикла;
	
	ПараметрыЗаписи.Вставить("ПомещаемыеФайлы", ПомещаемыеФайлы);
	
КонецПроцедуры
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Сперва сделаем таблицу такой которой она стала
	
	стТаблица = ТекущийОбъект.ДвоичныеДанные.Выгрузить();
	
	ТекущийОбъект.ДвоичныеДанные.Очистить();
	Для Каждого Строка Из Макеты Цикл
		
		НовСтрока = ТекущийОбъект.ДвоичныеДанные.Добавить();
		НовСтрока.ИмяФайла 	= Строка.ИмяФайла;
		НовСтрока.Замена 	= Строка.Замена;
		
		// Если этот макет не менялся тогда получим его из старого объекта
		
		Если 	Строка.НомСтрокиМакетаВБазе И
				Не Строка.ПоместитьФайлНаСервер Тогда
			НовСтрока.Макет = стТаблица[Строка.НомСтрокиМакетаВБазе - 1].Макет; КонецЕсли;
		
		// Если новый то подгрузим
		
		Если Строка.ПоместитьФайлНаСервер Тогда
			НовСтрока.Макет = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(ПараметрыЗаписи.ПомещаемыеФайлы[Строка.ПолноеИмяФайла]));КонецЕсли; КонецЦикла;
	
КонецПроцедуры
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Считаем данные в таблицу
	
	Ном = 0;
	Для Каждого Строка Из Объект.ДвоичныеДанные Цикл Ном = Ном + 1;
		
		НовСтрока = Макеты.Добавить();
		НовСтрока.ИмяФайла 				= Строка.ИмяФайла;
		НовСтрока.Замена 				= Строка.Замена;
		НовСтрока.НомСтрокиМакетаВБазе 	= Ном; КонецЦикла;
	
КонецПроцедуры

// ИНТЕРФЕЙС

&НаКлиенте
Процедура МакетыИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка 	= Ложь;
	текДанные 				= Элементы.Макеты.ТекущиеДанные;
	
	ДВ = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДВ.Фильтр =  "Документ ворд(*.doc)|*.doc";
	
	Если ДВ.Выбрать() Тогда
		
		Файл = Новый Файл(ДВ.ПолноеИмяФайла);
		Если Не Файл.Существует() Тогда
			ПоказатьПредупреждение(,"Не могу найти файл " + Файл.ПолноеИмя,,"Предупреждение"); Возврат; КонецЕсли;
		
		текДанные.ПоместитьФайлНаСервер = Истина;
		текДанные.ПолноеИмяФайла 		= Файл.ПолноеИмя;
		текДанные.ИмяФайла 				= Файл.ИмяБезРасширения; КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученКаталогВременныхФайлов(ИмяКаталогаВременныхФайлов, ДополнительныеПараметры) Экспорт
	
	//Если ЗначениеЗаполнено(ИмяКаталогаВременныхФайлов) Тогда
	//	
	//	текДанные = Макеты.НайтиПоИдентификатору(ДополнительныеПараметры.ИдСтроки);
	//	
	//	Если Не текДанные.НомСтрокиМакетаВБазе Тогда
	//		ПоказатьПредупреждение(,"Файла не существует,
	//					|прикрепите необходимый файл через кнопку выбора (F4)",,"Предупреждение"); Возврат; КонецЕсли;
	//	
	//	текДанные.ПолноеИмяФайла = ИмяКаталогаВременныхФайлов + текДанные.ИмяФайла + ".doc";
	//	
	//	// Если такое имя существует тогда дадим этому файлу другое имя чтобы не пересечся
	//	Если ОбщиеФункции.ФайлСуществует(текДанные.ПолноеИмяФайла) Тогда 
	//		текДанные.ПолноеИмяФайла = ПолучитьИмяВременногоФайла("doc"); КонецЕсли;
	//	
	//	// Достанем сам файл
	//	ОписФайла = Новый ОписаниеПередаваемогоФайла(текДанные.ИмяФайла, );
	//	
	//	НачатьПолучениеФайлов(,
	//	ПолучитьФайл(ПолучитьАдресМакетаССервера(текДанные.НомСтрокиМакетаВБазе - 1), текДанные.ПолноеИмяФайла, Ложь); КонецЕсли;

	//	
	//Иначе
	//	ПоказатьПредупреждение(,"не удалось определить каталог временных файлов"); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура МакетыИмяФайлаОткрытие_нов(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка 	= Ложь;
	текДанные 				= Элементы.Макеты.ТекущиеДанные;
	
		
КонецПроцедуры
&НаКлиенте
Процедура МакетыИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	
	//СтандартнаяОбработка 	= Ложь;
	//текДанные 				= Элементы.Макеты.ТекущиеДанные;
	//
	//// Вытащим файл с сервака если он оттуда еще не добывался
	//
	//Если ПустаяСтрока(текДанные.ПолноеИмяФайла) Тогда
	//	
	//	// Если он свежий и в базе нет тогда пользователю нечего показывать
	//	
	//	Если Не текДанные.НомСтрокиМакетаВБазе Тогда
	//		ПоказатьПредупреждение(,"Файла не существует,
	//					|прикрепите необходимый файл через кнопку выбора (F4)",,"Предупреждение"); Возврат; КонецЕсли;
	//	
	//	текДанные.ПолноеИмяФайла = КаталогВременныхФайлов() + текДанные.ИмяФайла + ".doc";
	//	
	//	// Если такое имя существует тогда дадим этому файлу другое имя чтобы не пересечся
	//	Если ОбщиеФункции.ФайлСуществует(текДанные.ПолноеИмяФайла) Тогда текДанные.ПолноеИмяФайла = ПолучитьИмяВременногоФайла("doc"); КонецЕсли;
	//	
	//	// Достанем сам файл
	//	ПолучитьФайл(ПолучитьАдресМакетаССервера(текДанные.НомСтрокиМакетаВБазе - 1), текДанные.ПолноеИмяФайла, Ложь); КонецЕсли;
	//
	//
	//// Запустим, пусть резвятся
	//
	//ЗапуститьПриложение(текДанные.ПолноеИмяФайла);
	//
	//ОткрытьФорму("Справочник.ДокументыWord.Форма.ОжиданиеРедактированияФайла", Новый Структура("ИмяФайлаОжидания", текДанные.ПолноеИмяФайла),,,,,Новый ОписаниеОповещения("СохранитьДокументВБазу", ЭтаФорма, Новый Структура("Индекс", Макеты.Индекс(текДанные))));
	//	
	//	//текДанные.ПоместитьФайлНаСервер = Истина;
	//	//Модифицированность 				= текДанные.ПоместитьФайлНаСервер; КонецЕсли;
	
КонецПроцедуры

Процедура СохранитьДокументВБазу(Результат, Параметры)
	
	Если Результат = Истина Тогда
		
		Макеты[Параметры.Индекс].ПоместитьФайлНаСервер = Истина;
		Модифицированность = Макеты[Параметры.Индекс].ПоместитьФайлНаСервер; КонецЕсли;
	
КонецПроцедуры
