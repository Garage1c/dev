﻿
Процедура ПередЗаписью(Отказ)
	
	Если Автор.Пустая() Тогда
		Автор = ПараметрыСеанса.ТекущийПользователь; КонецЕсли;
	
	Если ДатаСоздания = '00010101' Тогда
		ДатаСоздания = ТекущаяДата(); КонецЕсли;
	
	ДатаМодификации = ТекущаяДата();
		
КонецПроцедуры

