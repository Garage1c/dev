﻿
&НаСервере
Процедура ЗагрузитьСписокРегионов()
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ Регион ИЗ Справочник.АдресаДоставкиИнтернет УПОРЯДОЧИТЬ ПО Регион");
	ИнтернетРегионы.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регион"));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Подключим языки
	//Список.Параметры.УстановитьЗначениеПараметра("ТекущийЯзык", ПараметрыСеанса.ТекущийЯзык);
	
	ЗагрузитьСписокРегионов();
	
КонецПроцедуры


&НаСервере
Процедура УстановитьПометкиПоСкладу(СкладСсылка)
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ Регион ИЗ РегистрСведений.ПривязкаИнтернетРегионовКСкладам ГДЕ Склад = &Склад");
	Запрос.УстановитьПараметр("Склад", СкладСсылка);
	ТаблСкладов = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Элемент Из ИнтернетРегионы Цикл Элемент.Пометка = ТаблСкладов.Найти(Элемент.Значение, "Регион") <> Неопределено; КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	текСклад = Элементы.Список.ТекущаяСтрока;
	Если текСклад <> Неопределено Тогда
		УстановитьПометкиПоСкладу(текСклад); КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСнять(СкладСсылка, Регион, Пометка)
	
	Запись = РегистрыСведений.ПривязкаИнтернетРегионовКСкладам.СоздатьМенеджерЗаписи();
	Запись.Склад 	= СкладСсылка;
	Запись.Регион 	= Регион;
		
	Если Пометка Тогда Запись.Записать();
	Иначе Запись.Удалить();КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ПометкаПриИзменении(Элемент)
	
	текСклад 	= Элементы.Список.ТекущаяСтрока;
	текДанные 	= Элементы.ИнтернетРегионы.ТекущиеДанные;
	
	Если текСклад <> Неопределено Тогда
		УстановитьСнять(текСклад, текДанные.Значение, текДанные.Пометка); КонецЕсли;
	
КонецПроцедуры
