﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Текст.УстановитьHTML(Параметры.Текст, Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда)
	
	Перем новТекст, новКартинки;
	
	Текст.ПолучитьHTML(новТекст, новКартинки);
	ОповеститьОВыборе(новТекст); //КонецЕсли;
	
КонецПроцедуры
