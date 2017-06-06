﻿
&НаСервере
Процедура УстановитьТипЦен();
	
	ТипЦенПараметр = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ТипЦен1");
	ТипЦенПараметр.Значение 		= ТипЦен1;
	ТипЦенПараметр.Использование 	= Истина;
	
	ТипЦенПараметр = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ТипЦен2");
	ТипЦенПараметр.Значение 		= ТипЦен2;
	ТипЦенПараметр.Использование 	= Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЦенПриИзменении(Элемент)
	
	УстановитьТипЦен();
	
КонецПроцедуры
&НаКлиенте
Процедура ТипЦен2ПриИзменении(Элемент)
	
	УстановитьТипЦен();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьТипЦен();
	
КонецПроцедуры

