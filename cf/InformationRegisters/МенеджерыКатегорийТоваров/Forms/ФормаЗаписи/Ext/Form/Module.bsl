﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Контрагент.Пустая() Тогда
		Запись.Контрагент = Параметры.Контрагент; КонецЕсли;
	
	Если Не Параметры.Категория.Пустая() Тогда
		Запись.Категория = Параметры.Категория; КонецЕсли;
	

КонецПроцедуры
