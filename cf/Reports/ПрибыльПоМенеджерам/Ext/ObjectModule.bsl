﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	УстановитьПривилегированныйРежим(Истина);

	Настройки = КомпоновщикНастроек.ПолучитьНастройки();

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,Настройки,ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);

	ДокументРезультат.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	ПроцессорВывода.НачатьВывод();

	ЭлементРезультата = ПроцессорКомпоновки.Следующий();
	Пока ЭлементРезультата <> Неопределено Цикл
		ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();
	КонецЦикла;
	ПроцессорВывода.ЗакончитьВывод();
	
	//
	//Схема = СхемаКомпоновкиДанных.ВложенныеСхемыКомпоновкиДанных.Найти("АвансыИВозвраты");
	//СхемаКомпоновкиДанных.ВложенныеСхемыКомпоновкиДанных.Удалить(Схема);
	//
	//Макет компоновки 
	//КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	//
	//Параметры = КомпоновщикНастроек.Настройки.ПараметрыДанных;
	//ЗначениеПараметра = Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВозвратПокупателя"));
	//Если НЕ ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда
	//   	Параметры.УстановитьЗначениеПараметра("ВозвратПокупателя", 		Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("000000014"));
	//КонецЕсли;
	//ЗначениеПараметра = Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТипЦенСебестоимость"));
	//Если НЕ ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда
	//   	Параметры.УстановитьЗначениеПараметра("ТипЦенСебестоимость", Константы.ТипЦенСебестоимостьДляРасчетаЗП.Получить());
	//КонецЕсли;
	//ЗначениеПараметра = Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТипЦенЗакупка"));
	//Если НЕ ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда
	//    Параметры.УстановитьЗначениеПараметра("ТипЦенЗакупка", 			Константы.ТипЦенЗакупочныйРуб.Получить());
	//КонецЕсли;
	//
	//Параметры.УстановитьЗначениеПараметра("ПоОсновномуМенеджеру", Ложь);
	//Параметры.УстановитьЗначениеПараметра("ПоМенеджеруОплаты", Ложь);
	//
	//ПользПараметры = КомпоновщикНастроек.ПользовательскиеНастройки;
	//Для Каждого Элемент ИЗ ПользПараметры.Элементы Цикл
	//	
	//	Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И Элемент.Параметр = Новый ПараметрКомпоновкиДанных("Менеджер") И Элемент.Использование Тогда
	//		

	//		Параметры.УстановитьЗначениеПараметра("ПоОсновномуМенеджеру", Истина);
	//		Параметры.УстановитьЗначениеПараметра("МенеджерДляВО", Элемент.Значение);

	//		 
	//		//Настройки = СхемаКомпоновкиДанных.ВложенныеСхемыКомпоновкиДанных.Найти("АвансыИВозвраты").Схема.Параметры;
	//		//Настройки.Менеджер.Значение = Элемент.Значение;
	//		//Настройки.Менеджер.ОграничениеИспользования = Ложь;
	//		
	//	КонецЕсли;
	//	
	//	Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И Элемент.Параметр = Новый ПараметрКомпоновкиДанных("МенеджерОплаты") И Элемент.Использование Тогда
	//		
	//		Параметры.УстановитьЗначениеПараметра("ПоМенеджеруОплаты", Истина);
	//		Параметры.УстановитьЗначениеПараметра("МенеджерДляВО", Элемент.Значение);
	//		
	//		
	//		//Настройки = СхемаКомпоновкиДанных.ВложенныеСхемыКомпоновкиДанных.Найти("АвансыИВозвраты").Настройки;
	//		//Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("МенеджерОплаты", Элемент.Значение);
	//		//Настройки.ПараметрыДанных.Элементы.Найти("Менеджер").Использование = Ложь;
	//		//
	//	КонецЕсли;	
	//КонецЦикла;	

	//МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);

	////Компоновка данных 
	//ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	//ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);

	////Вывод результата 
	//ДокументРезультат.Очистить();
	//ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	//ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	//ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры
