﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Пользователь.Пустая() Тогда
		Запись.Пользователь = Параметры.Пользователь; КонецЕсли;
	

КонецПроцедуры
