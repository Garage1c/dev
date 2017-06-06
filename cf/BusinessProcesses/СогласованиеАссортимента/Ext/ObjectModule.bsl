﻿
Процедура ПисьмоОтправленоПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = НЕ Письмо.Пустая();
КонецПроцедуры

Процедура ОтправитьПисьмоОбработка(ТочкаМаршрутаБизнесПроцесса)
	// запишем письмо в регистр
//	Менеджер = РегистрыСведений.ЗапросНаСогласованиеТовара;
	//Для Каждого Строка Из Партнеры Цикл
	//	Для Каждого Товар ИЗ Товары Цикл
	//		НаборЗаписей = Менеджер.СоздатьНаборЗаписей();
	//		НаборЗаписей.Отбор.Партнер.Установить(Строка.Партнер);
	//		НаборЗаписей.Отбор.Номенклатура.Установить(Товар.Номенклатура);
	//		НаборЗаписей.Прочитать();
	//		Если НаборЗаписей.Выбран() Тогда
	//			Для Каждого Запись Из НаборЗаписей Цикл
	//				Запись.Письмо = Письмо;
	//				Запись.Статус = 2; КонецЦикла;  //отправлено на рассмотрение
	//				НаборЗаписей.Записать();
	//		КонецЕсли;
	//	КонецЦикла;
	//КонецЦикла;
	
КонецПроцедуры

Процедура ПисьмоРассмотрениеОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	// всем пользователям подавшим заявку на согласование шлем письма, что их товар ушел на рассмотрение
	
	Менеджер = РегистрыСведений.ЗапросНаСогласованиеТовара;

	Запрос = Новый Запрос("ВЫБРАТЬ Номенклатура, Номенклатура.Артикул Артикул, Партнер, Пользователь, ID, Период, Оповещение 
	| 
	|ИЗ	РегистрСведений.ЗапросНаСогласованиеТовара 
	| 
	|ГДЕ Номенклатура В (&Номенклатура) И Партнер В(&Партнеры) И Статус = 1
	|
	|ИТОГИ ПО Пользователь");
	
	Запрос.УстановитьПараметр("Номенклатура", Товары.ВыгрузитьКолонку("Номенклатура"));
	Запрос.УстановитьПараметр("Партнеры", Контрагенты.ВыгрузитьКолонку("Партнер"));
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаПолучатель = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	URLИнтернетМагазин = Константы.ПутьИнтернетМагазин.Получить();
			
	Пока ВыборкаПолучатель.Следующий() Цикл
		
		НачатьТранзакцию();
		
		ТекстПисьмаТело = "<table>";
		
		Получатель = ВыборкаПолучатель.Пользователь;
		
		Если ТипЗнч(Получатель) = Тип("СправочникСсылка.ПользователиИнтернет") Тогда
			
			Кому = Получатель.ЭлектроннаяПочта;
			ТекстПисьмаЗаголовок = "Уважаемый(ая) " + Получатель + "!" + "<BR><BR> Запрос по согласованию перечисленных ниже позиций был отправлен на согласование в коммерческую службу. После того как запрос будет рассмотрен, мы пришлем Вам уведомление.:<BR>";	
			
		КонецЕсли;		
	 
		ВыборкаТовары = ВыборкаПолучатель.Выбрать();               
		 
		Пока ВыборкаТовары.Следующий() Цикл 
			
			////////ЗАПИСЬ В РЕГИСТР////////
			Запись =  Менеджер.СоздатьМенеджерЗаписи(); 
			ЗаполнитьЗначенияСвойств(Запись, ВыборкаТовары);  
			Запись.Статус = 2; 
			Запись.Письмо = Письмо;
			
			Попытка
				Запись.Записать(Истина);
			Исключение
				ЗаписьЖурналаРегистрации("Данные.Запись", УровеньЖурналаРегистрации.Ошибка, , , 
				ОписаниеОшибки());
				ОтменитьТранзакцию();
				Возврат;
			КонецПопытки;
			///////////////////////////////
			
			Товар = ВыборкаТовары.Номенклатура;
			ТекстПисьмаТело = ТекстПисьмаТело + "<tr><td>" + Товар.Артикул + "</td><td><A style=""COLOR: rgb(0,0,204)"" href='http://" + URLИнтернетМагазин + "/tovar/" + НРег(Товар.alies) + "'>"+ Товар +"</A></td></tr>";
		КонецЦикла;

	   	ТемаПисьма = "Заявка на согласование товара поступила на рассмотрение в коммерческую службу"; 

		ТекстПисьма = ТекстПисьмаЗаголовок + ТекстПисьмаТело + "</table>" + КэшируемыеФункции.ПолучитьПодвалПисьма();
				
		ПисьмоПользователю = ОбщиеФункции.ОповеститьПоПочте(Кому, ТемаПисьма, ТекстПисьма, Ложь, Перечисления.ТипыТекстовЭлектронныхПисем.HTML);
		
		Если ПисьмоПользователю = Неопределено Тогда
			ЗаписьЖурналаРегистрации("Данные.Запись", УровеньЖурналаРегистрации.Ошибка, , , 
				ОписаниеОшибки() + "
				|получатель = " + Получатель + "
				|товар = " + Товар);
				ОтменитьТранзакцию();
			
			Возврат; 
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;

КонецПроцедуры

Процедура ПисьмоРезультатОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	// ищем все открытые заявки (статус 1), или заявки ожидающие ответа (статус 2)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ Тов.Номенклатура КАК Номенклатура, Тов.ДатаНачала КАК ДатаНачала, Тов.Согласовано Согласовано ПОМЕСТИТЬ Товары ИЗ &Номенклатура КАК Тов
	|;
	|
	|ВЫБРАТЬ Пользователь, Номенклатура, Номенклатура.Артикул Артикул, ИСТИНА Согласовано, ID, Партнер, Период, Оповещение, Письмо 
	|ИЗ РегистрСведений.ЗапросНаСогласованиеТовара 
	|ГДЕ Номенклатура В (ВЫБРАТЬ Номенклатура ИЗ Товары ГДЕ Согласовано) И Партнер В (&Партнеры) И (Статус = 1 ИЛИ Статус = 2) 
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ Пользователь, Номенклатура, Номенклатура.Артикул Артикул, ЛОЖЬ Согласовано, ID, Партнер, Период, Оповещение, Письмо  
	|ИЗ РегистрСведений.ЗапросНаСогласованиеТовара 
	|ГДЕ Номенклатура В (ВЫБРАТЬ Номенклатура ИЗ Товары ГДЕ НЕ Согласовано) И Партнер В (&Партнеры) И (Статус = 1 ИЛИ Статус = 2) 
	|
	|ИТОГИ ПО Пользователь, Согласовано");
	
	Запрос.УстановитьПараметр("Номенклатура", Товары.Выгрузить());
	Запрос.УстановитьПараметр("Партнеры", Контрагенты.Выгрузить().ВыгрузитьКолонку("Партнер"));

	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаПолучатель = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	URLИнтернетМагазин = Константы.ПутьИнтернетМагазин.Получить();
	Менеджер = РегистрыСведений.ЗапросНаСогласованиеТовара;
	
	
	Пока ВыборкаПолучатель.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Получатель = ВыборкаПолучатель.Пользователь;
		
		Если ТипЗнч(Получатель) = Тип("СправочникСсылка.ПользователиИнтернет") Тогда
			
			Кому = Получатель.ЭлектроннаяПочта;
			ТекстПисьмаЗаголовок = "Уважаемый(ая) " + Получатель + "!" + "<BR><BR> Мы получили ответ от Вашей коммерческой службы по запрашиваемыми позициям и сообщаем Вам о результате.<BR>";	
		
		КонецЕсли;
		ТекстПисьмаТело = "";
		ВыборкаСогласовано = ВыборкаПолучатель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		Пока ВыборкаСогласовано.Следующий() Цикл
			
			ВыборкаТовары = ВыборкаСогласовано.Выбрать();               
			ТекстПисьмаТело = ТекстПисьмаТело + ?(ВыборкаТовары.Количество(), ?(ВыборкаСогласовано.Согласовано, "<BR> Следующие позиции были согласованы: <BR>","<BR> Следующие позиции были отклонены: <BR>"),"")  +"<table>";
			
			Пока ВыборкаТовары.Следующий() Цикл Товар = ВыборкаТовары.Номенклатура;
				
				
				//////////////ЗАПИСЬ В РЕГИСТР//////////////
				Запись = Менеджер.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(Запись, ВыборкаТовары);
				Запись.ДокументСогласования = ?(ВыборкаСогласовано.Согласовано, ДокументСогласование, Неопределено);
				Запись.Статус = ?(ВыборкаСогласовано.Согласовано, 3, 4); 
				Попытка
					Запись.Записать();
				Исключение
					ЗаписьЖурналаРегистрации("Данные.Запись", УровеньЖурналаРегистрации.Ошибка, , , 
					ОписаниеОшибки());
					ОтменитьТранзакцию();
					Возврат;
				КонецПопытки;
				/////////////////////////////////////////////	
				
				ТекстПисьмаТело = ТекстПисьмаТело + "<tr><td>" + Товар.Артикул + "</td><td><A style=""COLOR: rgb(0,0,204)"" href='http://" + URLИнтернетМагазин + "/tovar/" + НРег(Товар.alies) + "'>"+ Товар +"</A></td></tr>";
			КонецЦикла;
		
			ТекстПисьмаТело = ТекстПисьмаТело + "</table>"; 
		КонецЦикла;
		
	   	ТемаПисьма = "Заявка на согласование товара рассмотрена коммерческой службой"; 

		ТекстПисьма = ТекстПисьмаЗаголовок + ТекстПисьмаТело + КэшируемыеФункции.ПолучитьПодвалПисьма();
		
		ПисьмоПользователю = ОбщиеФункции.ОповеститьПоПочте(Кому, ТемаПисьма, ТекстПисьма, Ложь, Перечисления.ТипыТекстовЭлектронныхПисем.HTML);
		
		Если ПисьмоПользователю = Неопределено Тогда
			ЗаписьЖурналаРегистрации("Данные.Запись", УровеньЖурналаРегистрации.Ошибка, , , 
				ОписаниеОшибки() + "
				|получатель = " + Получатель + "
				|товар = " + Товар);
			ОтменитьТранзакцию();
			Возврат; 
		КонецЕсли;
			
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;

КонецПроцедуры


Процедура ПодтвердитьСогласованиеПередВыполнением(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)

	Для Каждого Строка ИЗ Товары Цикл
		
		Если Строка.ДатаНачала = '00010101' Тогда
			Отказ = Истина;
			Сообщить("Значенеи поля ""ДатаНачала"" не должно быть пустым");
			Возврат;
		КонецЕсли;
		
	КонецЦикла
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ)
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ Пользователь, Номенклатура ИЗ РегистрСведений.ЗапросНаСогласованиеТовара ГДЕ Номенклатура В (&Номенклатура) И Партнер В (&Партнеры) И (Статус = 1 ИЛИ (Статус = 2 И Письмо = &Письмо)) ИТОГИ ПО Номенклатура");
	Запрос.УстановитьПараметр("Письмо", Письмо);
	Запрос.УстановитьПараметр("Номенклатура", Товары.ВыгрузитьКолонку("Номенклатура"));
	Запрос.УстановитьПараметр("Партнеры", Контрагенты.ВыгрузитьКолонку("Партнер"));
	ВыборкаТовары = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Пока ВыборкаТовары.Следующий() Цикл стрИнициаторы = "";
		
		СтрокиТовара = Товары.НайтиСтроки(Новый Структура("Номенклатура", ВыборкаТовары.Номенклатура));
		Выборка = ВыборкаТовары.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			стрИнициаторы  = стрИнициаторы + ", " + Выборка.Пользователь;
		КонецЦикла;
		
		Для Каждого Строка ИЗ СтрокиТовара Цикл
			Строка.СписокИнициаторов = Сред(стрИнициаторы, 2);
		КонецЦикла;
		
	КонецЦикла;
КонецПроцедуры


Процедура ОформитьЗаявкуНаСогласованиеПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
КонецПроцедуры

