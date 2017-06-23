﻿
Процедура ПриЗаписи(Отказ)
	Для Каждого Стр Из Отделы Цикл 
		//Свойство=Стр.свойство;
		//Значение=Стр.значение;
        ОбновитьСвойство(Сценарий, Пользователь,Стр.Отдел);
	КонецЦикла;
	
	Для Каждого Стр Из СтатьиБюджета Цикл 
		//Свойство=Стр.свойство;
		//Значение=Стр.значение;
        ОбновитьСвойство(Сценарий, Пользователь,Стр.СтатьяБюджета);
    КонецЦикла;
КонецПроцедуры


//&НаСервере
//Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
//    Для Каждого Стр Из Объект.Свойства Цикл 
//        Свойство=Стр.свойство;
//        Значение=Стр.значение;
//        ОбновитьСвойство(Объект, Свойство,Значение);
//    КонецЦикла;
//КонецПроцедуры

&НаСервере
Процедура ОбновитьСвойство(Сценарий, Свойство, ОбъектДоступа);
    Запись = РегистрыСведений.НастройкиДоступаБюджетированиеСоздатьМенеджерЗаписи();
    Запись.Сценарий = Сценарий;
    Запись.Пользователь = Пользователь;
    Запись.ОбъектДоступа = ОбъектДоступа;
    Запись.Записать();
 КонецПроцедуры