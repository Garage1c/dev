﻿
&НаКлиенте
Процедура УстановитьЗначениеПользовательскойНастройки(Настройки, Имя, Значение, Использование = Истина)
	
	Для Каждого Элемент Из Настройки.Элементы Цикл
        Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если Строка(Элемент.Параметр) = Имя Тогда
				Элемент.Значение = Значение;
                Элемент.Использование = Использование;
            КонецЕсли;
        КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЗначениеПользовательскойНастройки(Настройки, Имя, Значение, Использование = Истина)
	
	Для Каждого Элемент Из Настройки.Элементы Цикл
        Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если Строка(Элемент.Параметр) = Имя  И  Элемент.Использование Тогда
				Возврат Элемент.Значение;
            КонецЕсли;
        КонецЕсли;
	КонецЦикла;
	Возврат '00010101';
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПараметрыОтчета = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки;
	
	ПериодОтчета.ДатаНачала = ПолучитьЗначениеПользовательскойНастройки(ПараметрыОтчета,	"НачалоПериода", ПериодОтчета.ДатаНачала);		

	ПериодОтчета.ДатаОкончания = ПолучитьЗначениеПользовательскойНастройки(ПараметрыОтчета,	"КонецПериода",	 ПериодОтчета.ДатаОкончания);	

КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаПриИзменении(Элемент)
	ПараметрыОтчета = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки;
	
	УстановитьЗначениеПользовательскойНастройки(ПараметрыОтчета,	"НачалоПериода", ПериодОтчета.ДатаНачала);		

	УстановитьЗначениеПользовательскойНастройки(ПараметрыОтчета,	"КонецПериода",	 ПериодОтчета.ДатаОкончания);		

КонецПроцедуры
