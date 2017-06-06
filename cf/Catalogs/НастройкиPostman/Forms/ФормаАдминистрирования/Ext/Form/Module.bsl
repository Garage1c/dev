﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УчетнаяЗаписьЭлектроннойПочты = РегистрыСведений.НастройкиPostman.Получить(Новый Структура("Ключ","УчетнаяЗаписьЭлектроннойПочты")).Значение;
	EmailАдминистратора = РегистрыСведений.НастройкиPostman.Получить(Новый Структура("Ключ","EmailАдминистратора")).Значение;
КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	ЗаполнитьТаблицуОтчетов();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЛог(Команда)
	ОткрытьФорму("РегистрСведений.ЛогPostman.ФормаСписка");
КонецПроцедуры

//Таблица
#Область Таблица 

&НаКлиенте
Процедура ОбновитьТаблицу(Команда)
	ЗаполнитьТаблицуОтчетов()
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуОтчетов()
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкиPostmanПолучатели.Ссылка КАК Отчет
	|ИЗ
	|	Справочник.НастройкиPostman.Получатели КАК НастройкиPostmanПолучатели
	|ГДЕ
	|	НастройкиPostmanПолучатели.Получатель = &Пользователь
	|
	|УПОРЯДОЧИТЬ ПО
	|	Отчет
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Таблица.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура УбратьПользователяИзРассылки(Команда)
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("УбратьПользователяИзРассылкиПослеЗакрытияВопроса", ЭтаФорма, Параметры);
	ПоказатьВопрос(Оповещение, "Продолжить выполнение операции?", Режим);
КонецПроцедуры

&НаКлиенте
Процедура УбратьПользователяИзРассылкиПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	Если Не Результат = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	Попытка
	   КоличествоУдаленных = УбратьПользователяИзРассылкиНаСервере(Пользователь);
	   Если КоличествоУдаленных = 0 Тогда
	   
		  ПоказатьОповещениеПользователя(,," Не выбрано ни одного элемента"); 
		   
	   Иначе
		  ПоказатьОповещениеПользователя(,," Пользователь " + Пользователь + " исключен из " + КоличествоУдаленных + " элементов" );
	   КонецЕсли;
	    
	Исключение
	    Сообщить(ОписаниеОшибки());
	КонецПопытки;
	ЗаполнитьТаблицуОтчетов()
	
КонецПроцедуры


&НаСервере
Функция УбратьПользователяИзРассылкиНаСервере(Пользователь)
	Сч = 0;
	Для каждого Строка Из Таблица Цикл
	    Если Не Строка.Флаг Тогда
			Продолжить;
		КонецЕсли;
		Спр = Строка.Отчет.ПолучитьОбъект();
		МассивНайденных = Спр.Получатели.НайтиСтроки(Новый Структура("Получатель",Пользователь));
		
		Для каждого Эл Из МассивНайденных Цикл
		    Сч = Сч + 1;
			Спр.Получатели.Удалить(Эл);
		
		КонецЦикла;
		Спр.Записать();
	КонецЦикла;
    Возврат Сч
КонецФункции

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	Для каждого Эл Из Таблица Цикл
		Эл.Флаг = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Для каждого Эл Из Таблица Цикл
		Эл.Флаг = Ложь;
	КонецЦикла;
КонецПроцедуры
#КонецОбласти

//Применить Закрыть
#Область Применить_Закрыть
&НаКлиенте
Процедура Применить(Команда)
	ПрименитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПрименитьНаСервере()
	НЗ = РегистрыСведений.НастройкиPostman.СоздатьНаборЗаписей();
	Запись = НЗ.Добавить();
	Запись.Ключ = "УчетнаяЗаписьЭлектроннойПочты";
	Запись.Значение = УчетнаяЗаписьЭлектроннойПочты;
	
	Запись = НЗ.Добавить();
	Запись.Ключ = "EmailАдминистратора";
	Запись.Значение = EmailАдминистратора;
	НЗ.Записать();	
	Модифицированность = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Модифицированность Тогда
		Отказ = Истина;
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемПослеЗакрытияВопроса", ЭтаФорма, Параметры);
		ПоказатьВопрос(Оповещение, "Данные были изменены. Сохранить?", Режим);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПрименитьНаСервере();
	КонецЕсли;
	Модифицированность = Ложь;
	Закрыть();
КонецПроцедуры

#КонецОбласти

