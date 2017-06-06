﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Ссылка") Тогда
		СсылкаPostman = Параметры.Ссылка;
		Заголовок = "Отчет: " + СсылкаPostman.Наименование;
		Если Параметры.Свойство("АдресНастроек") Тогда
			Справочники.ОтчетыПользователей.СформироватьНаСервере(СсылкаPostman.Отчет,Параметры.АдресНастроек,Результат);
		Иначе	
		    Справочники.ОтчетыПользователей.СформироватьНаСервере(СсылкаPostman.Отчет,СсылкаPostman.НастройкиОтчета.Получить(),Результат);
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры
