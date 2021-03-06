﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ 	Все.Ссылка Пользователь, 1 Картинка, Все.Наименование, ЕСТЬNULL(Пометка, ЛОЖЬ) Пометка
	|ИЗ 		Справочник.ГруппыПользователей Все
	|ЛЕВОЕ СОЕДИНЕНИЕ 	(ВЫБРАТЬ Ссылка, Истина Пометка ИЗ Справочник.ГруппыПользователей ГДЕ НЕ ПометкаУдаления И Ссылка В (&МассивОтмеченных)) Отмеченные
	|ПО 				Все.Ссылка = Отмеченные.Ссылка
	|ГДЕ 		НЕ Все.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ 	Все.Ссылка Пользователь, 0 Картинка, Все.Наименование, ЕСТЬNULL(Пометка, ЛОЖЬ) Пометка
	|ИЗ 		Справочник.Пользователи Все
	|ЛЕВОЕ СОЕДИНЕНИЕ 	(ВЫБРАТЬ Ссылка, Истина Пометка ИЗ Справочник.Пользователи ГДЕ НЕ ПометкаУдаления И ФизЛицо.Родитель = &Родитель И Ссылка В (&МассивОтмеченных)) Отмеченные
	|ПО 				Все.Ссылка = Отмеченные.Ссылка
	|ГДЕ 		НЕ Все.ПометкаУдаления И ФизЛицо.Родитель = &Родитель
	|
	|УПОРЯДОЧИТЬ По Картинка Убыв, Наименование
	|");
	
	Запрос.УстановитьПараметр("Родитель", 			Справочники.ФизическиеЛица.НайтиПоНаименованию("Сотрудники", Истина));
	Запрос.УстановитьПараметр("МассивОтмеченных", 	Параметры.СписокОтмеченных);
	Пользователи.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Массив = Новый Массив;
	
	Строки = Пользователи.НайтиСтроки(Новый Структура("Пометка", Истина));
	Для Каждого Строка Из Строки Цикл Массив.Добавить(Строка.Пользователь) КонецЦикла;
		
	Закрыть(Массив);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсехНажатие(Элемент)
	
	Массив = Новый Массив;
	Массив.Добавить(Неопределено);
	Закрыть(Массив);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсехНажатие(Элемент)
	
	Закрыть(Новый Массив);
	
КонецПроцедуры
