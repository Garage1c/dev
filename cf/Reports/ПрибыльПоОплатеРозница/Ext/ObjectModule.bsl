﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	//
	//Схема = СхемаКомпоновкиДанных.ВложенныеСхемыКомпоновкиДанных.Найти("АвансыИВозвраты");
	//СхемаКомпоновкиДанных.ВложенныеСхемыКомпоновкиДанных.Удалить(Схема);
	//
	//Макет компоновки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Параметры = КомпоновщикНастроек.Настройки.ПараметрыДанных;
	ЗначениеПараметра = Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВозвратПокупателя"));
	Если НЕ ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда
   		Параметры.УстановитьЗначениеПараметра("ВозвратПокупателя", 		Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("000000014"));
	КонецЕсли;
	ЗначениеПараметра = Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТипЦенСебестоимость"));
	Если НЕ ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда
   		Параметры.УстановитьЗначениеПараметра("ТипЦенСебестоимость", Константы.ТипЦенСебестоимостьДляРасчетаЗП.Получить());
	КонецЕсли;
	
	ЗначениеПараметра = Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТипЦенЗакупка"));
	Если НЕ ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда
        Параметры.УстановитьЗначениеПараметра("ТипЦенЗакупка", 			Константы.ТипЦенЗакупочныйРуб.Получить());
	КонецЕсли;
		
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);

	//Компоновка данных 
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);

	//Вывод результата 
	ДокументРезультат.Очистить();
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры
