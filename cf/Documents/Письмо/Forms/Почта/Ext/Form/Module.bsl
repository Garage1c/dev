﻿
&НаКлиенте
Процедура УстановитьФильтр()
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Ответственный", Пользователь, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Пользователь = ПараметрыСеанса.ТекущийПользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьФильтр();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Документ.Письмо.Форма.Письмо2", Новый Структура("Ключ", ВыбраннаяСтрока), ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	
	УстановитьФильтр();
	
КонецПроцедуры

