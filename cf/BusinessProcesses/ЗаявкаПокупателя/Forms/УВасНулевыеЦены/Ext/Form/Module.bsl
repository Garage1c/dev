﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого Строка Из Параметры.Товары Цикл
		
		НовСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
		
		НовСтрока.Артикул 			= НовСтрока.Товар.Артикул;
		НовСтрока.МенеджерЗакупок  	= НовСтрока.Товар.МенеджерЗакупок ;КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Продолжитьь(Команда) 
	
	Закрыть(Истина) 
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(Товары.НайтиПоИдентификатору(ВыбраннаяСтрока).Товар);
	
КонецПроцедуры
