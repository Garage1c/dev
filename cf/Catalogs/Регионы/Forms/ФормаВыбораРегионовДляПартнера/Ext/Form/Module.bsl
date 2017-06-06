﻿
// ЗАПИСЬ

&НаСервере
Функция СохранитьВРегистре(Элемент)
	
	Запись = РегистрыСведений.РегионыПартнера.СоздатьМенеджерЗаписи();
	Запись.Партнер 	= Партнер;
	Запись.Регион 	= Элемент.Регион;
	
	Попытка
		
		Если Элемент.Использует Тогда 
			Запись.Записать();
		Иначе
			Запись.Удалить();
		КонецЕсли;
		
	Исключение
		стрОшибки = ОписаниеОшибки();
		ОбщиеФункции.СообщитьТекст("Ошибка при записи связи регионов с партнерами
		|" + стрОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции
&НаСервере
Функция СохранитьРегион(Элемент)
	
	СпрОбъект = ?(Элемент.Регион.Пустая(), Справочники.Регионы.СоздатьЭлемент(), Элемент.Регион.ПолучитьОбъект());
	
	СпрОбъект.Наименование 	= Элемент.РегионПредставление;
	СпрОбъект.Родитель 		= Элемент.текРодитель;
	
	Попытка
		СпрОбъект.Записать();
	Исключение
		стрОшибки = ОписаниеОшибки();
		ОбщиеФункции.СообщитьТекст("Ошибка при записи справочник регионы
		|" + стрОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Элемент.Регион = СпрОбъект.Ссылка;
	
	Возврат Истина;
	
КонецФункции
&НаСервере
Функция СохранитьРегионыПредставление()
	
	Запись = РегистрыСведений.РегионыПартнераПредставление.СоздатьМенеджерЗаписи();
	Запись.Партнер 	= Партнер;
	Запись.Регионы 	= РегионыПредставление;
	
	Попытка
		
		Если ПустаяСтрока(РегионыПредставление) Тогда 
			Запись.Удалить();
		Иначе
			Запись.Записать();
		КонецЕсли;
		
	Исключение
		стрОшибки = ОписаниеОшибки();
		ОбщиеФункции.СообщитьТекст("Ошибка при записи представления регионов партнера
		|" + стрОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции
&НаСервере
Функция СохранитьРегионы(ЭлементРодитель)
	
	текЭлементы = ЭлементРодитель.ПолучитьЭлементы();
	Для Каждого Элемент Из текЭлементы Цикл
		
		// Проверим регион
		
		Если Элемент.РегионПредставление <> Элемент.Наименование И Не СохранитьРегион(Элемент) Тогда
			Возврат Ложь; КонецЕсли;
		
		// Проверим регистр
		
		Если Элемент.Использует <> Элемент.ИспользуетВРегистре И Не СохранитьВРегистре(Элемент) Тогда
			Возврат Ложь; КонецЕсли;
	
		// Проверим подчиненные
		
		Если Не СохранитьРегионы(Элемент) Тогда
			Возврат Ложь; КонецЕсли;КонецЦикла;
	
	// Вернем что все круть
	
	Возврат Истина;
	
КонецФункции
&НаСервере
Функция СохранитьВФорме()
	
	НачатьТранзакцию();
	
	Если 	СохранитьРегионы(Список) И
			(РегионыПредставление = РегионыПредставлениеВРегистре Или СохранитьРегионыПредставление()) Тогда
		
		ЗафиксироватьТранзакцию();
		Возврат Истина;
		
	Иначе
		
		ОтменитьТранзакцию();
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// ЧТЕНИЕ

&НаСервере
Функция ПолучитьФлагИспользует(Строка)
	
	Строки = Строка.Строки;
	
	Если Строки.Количество() Тогда
		Возврат ПолучитьФлагИспользует(Строки[0]);
	Иначе
		Возврат Строка.Использует;
	КонецЕсли;
	
КонецФункции
&НаСервере
Процедура ЗагрузитьДеревоВДанныеФормыДерево(Дерево, ДанныеФормы) Экспорт

	// Загружает в дерево выборку запроса
	
	текЭлементы = ДанныеФормы.ПолучитьЭлементы();
	
	Для Каждого Строка Из Дерево.Строки Цикл 
		
		// Проверим случай с затроеннием и т.д. с чем я не разобрался и устал
		Если ТипЗнч(Дерево) <> Тип("ДеревоЗначений") И Строка.Регион = Строка.Родитель.Регион Тогда 
			
			Использует = ПолучитьФлагИспользует(Строка);
			Если Использует Тогда
				ДанныеФормы.Использует 			= Использует;
				ДанныеФормы.ИспользуетВРегистре = Использует; КонецЕсли; Продолжить;КонецЕсли;
		
		// Добавим
		
		НовСтрока = текЭлементы.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, Строка); 
		
		// Рекурсия
		
		ЗагрузитьДеревоВДанныеФормыДерево(Строка, НовСтрока);КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписок()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ 
	|	Спр.Ссылка Регион, Спр.Наименование Наименование, Спр.Наименование РегионПредставление, Спр.Родитель текРодитель,
	|	ЕСТЬNULL(Рег.Использует, ЛОЖЬ) Использует,
	|	ЕСТЬNULL(Рег.Использует, ЛОЖЬ) ИспользуетВрегистре
	|ИЗ
	|	Справочник.Регионы Спр
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	(ВЫБРАТЬ Регион, ИСТИНА Использует ИЗ РегистрСведений.РегионыПартнера ГДЕ Партнер = &Партнер) Рег
	|ПО
	|	Спр.Ссылка = Рег.Регион
	|
	|ГДЕ НЕ	Спр.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО РегионПредставление
	|
	|ИТОГИ ПО Регион ИЕРАРХИЯ
	|");
	
	Запрос.УстановитьПараметр("Партнер", Партнер);
	//КонвертацияТипов.ЗагрузитьДеревоВДанныеФормыДерево(Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией), Список);
	ЗагрузитьДеревоВДанныеФормыДерево(Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией), Список);
	
КонецПроцедуры

&НаСервере
Процедура СобратьСтрокуПредставления(текЭлементы, Стр)
	
	Для Каждого Элемент Из текЭлементы Цикл
		
		Если Элемент.Использует Тогда
			
			Стр = Стр + ?(Стр = "","",", ") + Элемент.РегионПредставление;
			
		КонецЕсли;
		
		СобратьСтрокуПредставления(Элемент.ПолучитьЭлементы(), Стр);
		
	КонецЦикла;
	
КонецПроцедуры
&НаСервере
Процедура ОбновитьПредставление()
	
	Стр = "";
	СобратьСтрокуПредставления(Список.ПолучитьЭлементы(), Стр);
	
	РегионыПредставление = Стр;
	
КонецПроцедуры

// ТИПОВОЕ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Партнер = Параметры.Партнер;
//	Список.Параметры.УстановитьЗначениеПараметра("Партнер", Партнер);
	
	Заголовок = "Регионы " + Партнер;
	
	ОбновитьСписок();
	ОбновитьПредставление();
	
	РегионыПредставлениеВРегистре = РегионыПредставление;
	
КонецПроцедуры
&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность И Не СохранитьВФорме() Тогда
		
		Отказ = Истина;КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьПредставление();
	
КонецПроцедуры
