﻿Функция ПолучитьМассивВыделенныхТоваров_cn(Форма, ТоварыЭлемент = "Товары", Товары = "Товары") Экспорт
	
	Строки = Форма.Элементы[ТоварыЭлемент].ВыделенныеСтроки;
	Массив = Новый Массив;
	
	Если Строки.Количество() Тогда
					
		Для Каждого Идентификатор Из Строки Цикл
				//Строка = ?(ТоварыЭлемент = "Список", Идентификатор, Вычислить("Форма.Объект." + Товары).НайтиПоИдентификатору(Идентификатор));
				СТрока = ?(ТоварыЭлемент = "Список", Идентификатор, РеквизитФормыИлиРеквизитОбъекта(Форма, Идентификатор, Товары));
				Если Строка <> Неопределено Тогда
					Массив.Добавить( ?(ТоварыЭлемент = "Список", Строка, Строка.Номенклатура));
				КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
		
	Возврат Массив;
	
КонецФункции
//Антон
///Реквизит формы или рекивиз объекта
///массив выделенных товаров получают из документов или бизнес - процессов
///и товары могут быть реквизитом формы или реквизитом объекта. Это тут и будем выяснять
Функция РеквизитФормыИлиРеквизитОбъекта(Форма, Идентификатор, Товары)
	Попытка
		Возврат Вычислить("Форма."+Товары).НайтиПоИдентификатору(Идентификатор);
	Исключение
		Возврат Вычислить("Форма.Объект."+Товары).НайтиПоИдентификатору(Идентификатор);
	КонецПопытки;	
КонецФункции

Процедура ИнфТовараТекстHTMLПриНажатии(Форма, Элемент, ДанныеСобытия, СтандартнаяОбработка, Товары = "Товары", ТоварСсылка = Неопределено, ТоварыФорма = "Товары") Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	// Если типовая обработка не подойдет то обработаем по новому
	
	Если Не HTMLОбработкаКлиент.ТекстHTMLПриНажатии(ДанныеСобытия, СтандартнаяОбработка, Форма) Тогда
		
		// Возможно нужно выполнить типовое
		
		//Если Не СтандартнаяОбработка Тогда
		
		Если ТоварСсылка = Неопределено Тогда
			ТекущиеДанные = ?(Товары = "Список", Форма.Элементы[Товары].ТекущаяСтрока, Форма.Элементы[Товары].ТекущиеДанные);
			Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
			
			ТоварСсылка = ?(Товары = "Список", ТекущиеДанные, ТекущиеДанные.Номенклатура); КонецЕсли;
		
		Если ДанныеСобытия.Element.id = "CheckStock" Тогда
			
			Массив = ПолучитьМассивВыделенныхТоваров(Форма, Товары, ТоварыФорма);
			Если Массив.Количество() Тогда
				
				Остатки =  Элемент.Документ.getElementByID("Checkstock");
				РаботаСНоменклатурой.ОбновитьНастройкиОперативнойИнфоОТоваре(Новый Структура("Остатки", Остатки.Checked));
				Форма.ОбработатьОтображениеИнформацииОТоваре();КонецЕсли;
			
		ИначеЕсли ДанныеСобытия.Element.id = "CheckPrice" Тогда
			
			Массив = ПолучитьМассивВыделенныхТоваров(Форма, Товары, ТоварыФорма);
			Если Массив.Количество() Тогда
				
				Цены =  Элемент.Документ.getElementByID("CheckPrice");  
				РаботаСНоменклатурой.ОбновитьНастройкиОперативнойИнфоОТоваре(Новый Структура("Цены", Цены.Checked));
				Форма.ОбработатьОтображениеИнформацииОТоваре(); КонецЕсли;
			
		ИначеЕсли ДанныеСобытия.Element.id = "CheckLoader" Тогда
			
			Массив = ПолучитьМассивВыделенныхТоваров(Форма, Товары, ТоварыФорма);
			Если Массив.Количество() Тогда
				
				Сборка =  Элемент.Документ.getElementByID("CheckLoader");  
				РаботаСНоменклатурой.ОбновитьНастройкиОперативнойИнфоОТоваре(Новый Структура("Сборка", Сборка.Checked));
				Форма.ОбработатьОтображениеИнформацииОТоваре();КонецЕсли; 
			
			
		ИначеЕсли ДанныеСобытия.Element.id = "CheckExtra" Тогда     //CheckPurchase
			
			Массив = ПолучитьМассивВыделенныхТоваров(Форма, Товары, ТоварыФорма);
			Если Массив.Количество() Тогда
				
				Дополнительно =  Элемент.Документ.getElementByID("CheckExtra");  
				РаботаСНоменклатурой.ОбновитьНастройкиОперативнойИнфоОТоваре(Новый Структура("Дополнительно", Дополнительно.Checked));
				Форма.ОбработатьОтображениеИнформацииОТоваре(); КонецЕсли;

			
		ИначеЕсли ДанныеСобытия.Element.id = "Сurrency" Тогда
			
			ГУИДВалюты = Новый УникальныйИдентификатор(Элемент.Документ.getElementByID("Сurrency").value);
			СсылкаНаВалюту = КонвертацияТипов.ПолучитьСсылкуПоГуиду(ГУИДВалюты, "Валюты");
			Настройки = РаботаСНоменклатурой.ПолучитьНастройкиОперативнойИнфоОТоваре();
			Если Настройки.Валюта <> СсылкаНаВалюту Тогда
				РаботаСНоменклатурой.ОбновитьНастройкиОперативнойИнфоОТоваре(Новый Структура("Валюта", СсылкаНаВалюту));
				Форма.ОбработатьОтображениеИнформацииОТоваре();
			КонецЕсли;
			
		ИначеЕсли ДанныеСобытия.Element.id = "UserSales" Тогда
			
			текЗнач = Элемент.Документ.getElementByID("UserSales").value;
			
			Настройки = РаботаСНоменклатурой.ПолучитьНастройкиОперативнойИнфоОТоваре();
			
			Если текЗнач = "ВыборПартнера" Тогда
				
				ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", Новый Структура("Ключ", Настройки.Контрагент), Форма,,,, 
					Новый ОписаниеОповещения("ВыбранПартнерДляОперИнформации", РаботаСНоменклатуройКлиент, Новый Структура("Форма", Форма)));
			Иначе
				
				Контрагент = ?(текЗнач = "ВсеУчастники", Неопределено, КонвертацияТипов.ПолучитьСсылкуПоГуиду(текЗнач, "Контрагенты"));
				Если Настройки.Контрагент <> Контрагент Тогда
					НастройкиПользователя.СохранитьЭлементПовторногоВвода("Контрагент", Контрагент);
					РаботаСНоменклатурой.ОбновитьНастройкиОперативнойИнфоОТоваре(Новый Структура("Контрагент", Контрагент));
					Форма.ОбработатьОтображениеИнформацииОТоваре(); КонецЕсли; КонецЕсли;
			
		ИначеЕсли ДанныеСобытия.Element.id = "CheckInOrder" Тогда
		
			Массив = ПолучитьМассивВыделенныхТоваров(Форма, Товары, ТоварыФорма);
			Если Массив.Количество() Тогда
				
				ВнЗаказы = Элемент.Документ.getElementByID("CheckInOrder");  
				РаботаСНоменклатурой.ОбновитьНастройкиОперативнойИнфоОТоваре(Новый Структура("ВнутренниеЗаказы", ВнЗаказы.Checked));
				Форма.ОбработатьОтображениеИнформацииОТоваре();КонецЕсли;  КонецЕсли; КонецЕсли;
	
КонецПроцедуры

Процедура ВыбранПартнерДляОперИнформации(ВыбКонтрагент, ДополнительныеПараметры) Экспорт
	
	Если ВыбКонтрагент <> Неопределено Тогда 
		НастройкиПользователя.СохранитьЭлементПовторногоВвода("Контрагент", ВыбКонтрагент); КонецЕсли;
		
	РаботаСНоменклатурой.ОбновитьНастройкиОперативнойИнфоОТоваре(Новый Структура("Контрагент", ВыбКонтрагент));
	ДополнительныеПараметры.Форма.ОбработатьОтображениеИнформацииОТоваре();
	
КонецПроцедуры

Процедура ИнфТовараЗаголовокHTMLПриНажатии(Форма, Элемент, ДанныеСобытия, СтандартнаяОбработка, Товары = "Товары", ТоварыФорма = "Товары") Экспорт
	
	//////Товары = ?(ПустаяСтрока(Товары), "Товары", Товары);
	////
	////ТекущиеДанные = ?(Товары = "Список", Форма.Элементы[Товары].ТекущаяСтрока, Форма.Элементы[Товары].ТекущиеДанные);
	////Если ТекущиеДанные = Неопределено Тогда
	////	Возврат;
	////КонецЕсли;
	////
	////ТоварСсылка = ?(Товары = "Список", ТекущиеДанные, ТекущиеДанные.Номенклатура);
	////СкладСсылка = Неопределено;
	//ЭлементВалюта = Форма.Элементы.Найти("Валюта");
	//Валюта = ?(ЭлементВалюта <> Неопределено,  Вычислить("Форма." + ЭлементВалюта.ПутьКДанным), КэшируемыеФункции.ВалютаУправленческогоУчета());
	//
	//Если ДанныеСобытия.Element.id = "CheckStock" Тогда
	//	
	//	Массив = ПолучитьМассивВыделенныхТоваров(Форма, Товары, ТоварыФорма);
	//	Если Массив.Количество() Тогда
	//	
	//		Остатки =  Элемент.Документ.getElementByID("Checkstock");
	//					
	//		РаботаСНоменклатурой.ОбновитьНастройкиОперативнойИнфоОТоваре(Новый Структура("Остатки", Остатки.Checked));
	//		
	//		ИнфОТоваре =  РаботаСНоменклатурой.ПолучитьТекстHTMLОТоваре(Массив, Валюта);
	//		Форма.ИнфТовараТекстHTML = ИнфОТоваре;
	//		
	//	КонецЕсли;

	//ИначеЕсли ДанныеСобытия.Element.id = "CheckPrice" Тогда
	//	
	//	Массив = ПолучитьМассивВыделенныхТоваров(Форма, Товары, ТоварыФорма);
	//	Если Массив.Количество() Тогда
	//		
	//		Цены =  Элемент.Документ.getElementByID("CheckPrice");  
	//		
	//		РаботаСНоменклатурой.ОбновитьНастройкиОперативнойИнфоОТоваре(Новый Структура("Цены", Цены.Checked));
	//		
	//		ИнфОТоваре =  РаботаСНоменклатурой.ПолучитьТекстHTMLОТоваре(Массив, Валюта);
	//		Форма.ИнфТовараТекстHTML = ИнфОТоваре;

	//	КонецЕсли;
	//	
	//// silber {
	//
	//ИначеЕсли ДанныеСобытия.Element.id = "CheckLoader" Тогда
	//	
	//	Массив = ПолучитьМассивВыделенныхТоваров(Форма, Товары, ТоварыФорма);
	//	Если Массив.Количество() Тогда
	//		
	//		Сборка =  Элемент.Документ.getElementByID("CheckLoader");  
	//		
	//		РаботаСНоменклатурой.ОбновитьНастройкиОперативнойИнфоОТоваре(Новый Структура("Сборка", Сборка.Checked));
	//		
	//		ИнфОТоваре =  РаботаСНоменклатурой.ПолучитьТекстHTMLОТоваре(Массив, Валюта);
	//		Форма.ИнфТовараТекстHTML = ИнфОТоваре;

	//	КонецЕсли;
	//	
	//// } silber
	//	
	//КонецЕсли;
	//
КонецПроцедуры


Процедура НажатаКнопкаОтчетыТовара(ТоварСсылка, Форма, Кнопка)
	
	// Зададим параметры
	
	ПараметрыФормы = Новый Структура("Номенклатура", ТоварСсылка);
	ПараметрыФормы = Новый Структура("Номенклатура, Отбор, КлючНазначенияИспользования, СформироватьПриОткрытии", ТоварСсылка, ПараметрыФормы,,Истина);
	
	// Подготовим список
	
	СписокОтчетов = Новый СписокЗначений;
	СписокОтчетов.Добавить("Справочник.Номенклатура.Форма.ПоказатьАналоги", "Показать аналоги");
	СписокОтчетов.Добавить("Отчет.ВедомостьОдногоТовара.ФормаОбъекта", 		"Движение по складам");
	СписокОтчетов.Добавить("Отчет.ДвижениеЯчеек.ФормаОбъекта", 				"Движение по ячейкам");
	СписокОтчетов.Добавить("Отчет.ПродажиТовараКлиенту.ФормаОбъекта", 		"Продажи клиентам");
	//СписокОтчетов.Добавить("Отчет.ТоварыВРезерве.ФормаОбъекта", 			"Резерв по заказам");
	//СписокОтчетов.Добавить("Отчет.СборкаЗаказов.ФормаОбъекта", 				"Сборки по заказам");
	
	// Выберем и откроем отчет
	
	Выбор = Форма.ВыбратьИзменю(СписокОтчетов, Кнопка);
	Если Выбор <> Неопределено Тогда
		ОткрытьФорму(Выбор.Значение, ПараметрыФормы, Форма); КонецЕсли;
	
КонецПроцедуры

// Аналоги

Процедура ИнфАналогиТекстHTMLПриНажатии(Форма, Элемент, ДанныеСобытия, СтандартнаяОбработка, Товары = "Товары", ТоварСсылка = Неопределено, ТоварыФорма = "Товары") Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ HTMLОбработкаКлиент.ТекстHTMLПриНажатии(ДанныеСобытия, СтандартнаяОбработка, Форма) Тогда
		
		Если ДанныеСобытия.Element.id = "UserSales" Тогда
			
			текЗнач = Элемент.Документ.getElementByID("UserSales").value;
			Контрагент = КонвертацияТипов.ПолучитьСсылкуПоГуиду(текЗнач, "Контрагенты");
			Массив = ПолучитьМассивВыделенныхТоваров(Форма, Товары, ТоварыФорма);
			//РаботаСНоменклатурой.ПолучитьИнформациюHTMLАналоговТовара(Массив,  Партнер);
			Форма.ОбработатьОтображениеАналоговТовара(Контрагент); КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработатьОтображениеАналоговТовара(Форма, ТоварыЭлементы = "Товары", ТоварыФорма = "Товары", Массив = Неопределено, КолонкаТовара = "Номенклатура", Контрагент = Неопределено) Экспорт
	
	ИнфАналогиОтображать = Форма.ИнфАналогиОтображать;
		
	Форма.Элементы.ИнфАналогиТекстHTML.Видимость = ИнфАналогиОтображать;
		
	Если ИнфАналогиОтображать Тогда
			
		Если Массив = Неопределено Тогда
			Массив = ПолучитьМассивВыделенныхТоваров(Форма, ТоварыЭлементы, ТоварыФорма, КолонкаТовара); КонецЕсли;
			
		Если Массив.Количество() Тогда
			Если Контрагент = Неопределено Тогда ЭлементКонтрагент = Форма.Элементы.Найти("Контрагент");
				Контрагент =  ?(ЭлементКонтрагент <> Неопределено, Вычислить("Форма." + ЭлементКонтрагент.ПутьКДанным), ОбщиеФункции.НастройкаПользователя("ПоУмолчанию_Контрагент", глТекущийПользователь)); КонецЕсли;
			
			ИнфАналоги = РаботаСНоменклатурой.ПолучитьИнформациюHTMLАналоговТовара(Массив, Контрагент);
			Форма.ИнфАналогиТекстHTML = ИнфАналоги; КонецЕсли; КонецЕсли;

КонецПроцедуры

Процедура ПоказатьСкрытьАналогиТовара(Форма) Экспорт
	
	Форма.ИнфАналогиОтображать 					= Не Форма.ИнфАналогиОтображать;
	Форма.Элементы.АналогиТовараКнопка.Пометка 	= Форма.ИнфАналогиОтображать;
	
	Форма.ОбработатьОтображениеАналоговТовара();

КонецПроцедуры

// Инф о товаре

Процедура ПоказатьСкрытьИнфОТоваре(Форма) Экспорт
	
	ИдентификаторВремени = ДиалогиСПользователем.НачалоЗамераВремени("ИнформацияОТоваре.Открытие");
	
	Форма.ИнфТовраОтображать 					= Не Форма.ИнфТовраОтображать;
	Форма.Элементы.ИнфТовараКнопка.Пометка 		= Форма.ИнфТовраОтображать;
	
	Форма.ОбработатьОтображениеИнформацииОТоваре();

	Если Форма.ИнфТовраОтображать Тогда
			Слежение.Записать("Информация. О товаре открытие", "Справочник.Номенклатура");
	Иначе	Слежение.Записать("Информация. О товаре закрытие", "Справочник.Номенклатура"); КонецЕсли;

	ДиалогиСПользователем.ОкончаниеЗамераВремени(ИдентификаторВремени);
	
КонецПроцедуры
Процедура НастройкаИнфОТоваре(Форма, ТоварыЭлемент = "Товары", ТоварыФорма = "Товары", ТоварСсылка = Неопределено, ИмяКолонкиТовара = "Номенклатура") Экспорт
	
	// silber {
	Если Форма.ТекущийЭлемент.Имя = "ИнфТовараКнопкаОтчетыТовара" Тогда 
		
		// Определим ссылку товара
		
		Если ТоварСсылка = Неопределено Тогда
			ТекущиеДанные = ?(ТоварыЭлемент = "Список", Форма.Элементы[ТоварыЭлемент].ТекущаяСтрока, Форма.Элементы[ТоварыЭлемент].ТекущиеДанные);
			Если ТекущиеДанные = Неопределено Тогда
				Возврат; КонецЕсли;
		
			ТоварСсылка = ?(ТоварыЭлемент = "Список", ТекущиеДанные, ТекущиеДанные[ИмяКолонкиТовара]); КонецЕсли;
		
		// Отправим к отчетам
		
		НажатаКнопкаОтчетыТовара(ТоварСсылка, Форма, Форма.ТекущийЭлемент); 
		
	Иначе
	
	// } silber
	
	ОткрытьФорму("ОбщаяФорма.НастройкаОперативнойИнформацииОТоваре", Новый Структура("ТоварыЭлемент, ТоварыФорма", ТоварыЭлемент, ТоварыФорма) , Форма); КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьМассивВыделенныхТоваров(Форма, ТоварыЭлементы = "Товары", ТоварыФорма = "Товары", КолонкаТовара = "Номенклатура") Экспорт
	
	Строки 		= Форма.Элементы[ТоварыЭлементы].ВыделенныеСтроки;
	Массив 		= Новый Массив;
	ТипТовар	= Тип("СправочникСсылка.Номенклатура");
	
	Если Строки.Количество() Тогда
		Для Каждого Идентификатор Из Строки Цикл
			
			Строка = ?(ТоварыЭлементы = "Список", Идентификатор, Вычислить("Форма." + ТоварыФорма).НайтиПоИдентификатору(Идентификатор));
			Если Строка <> Неопределено Тогда 
				
				текТовар = ?(ТоварыЭлементы = "Список", Строка, Строка[КолонкаТовара]);
				Если ТипЗнч(текТовар) =  ТипТовар Тогда
					Массив.Добавить(текТовар); КонецЕсли; КонецЕсли; КонецЦикла; КонецЕсли;
		
	Возврат Массив;
	
КонецФункции
Процедура ОбработатьОтображениеИнформацииОТоваре(Форма, ТоварыЭлементы = "Товары", ТоварыФорма = "Товары", Массив = Неопределено, КолонкаТовара = "Номенклатура", ПутьКВалюте = "Валюта") Экспорт
	
	ИнфТовраОтображать = Форма.ИнфТовраОтображать;
	
	Если ИнфТовраОтображать <> Форма.Элементы.ИнфТовараТекстHTML.Видимость Тогда // Только если изменилось то только тогда  есть смысл подавать сигнал на обновление
		
		Форма.Элементы.ИнфТовараТекстHTML.Видимость 		= ИнфТовраОтображать;
		Форма.Элементы.ИнфТовараКнопкаНастройки.Видимость	= ИнфТовраОтображать;
		Форма.Элементы.ИнфТовараКнопкаОтчетыТовара.Видимость= ИнфТовраОтображать; КонецЕсли;
			
	Если ИнфТовраОтображать Тогда
			
		Если Массив = Неопределено Тогда
			Массив = ПолучитьМассивВыделенныхТоваров(Форма, ТоварыЭлементы, ТоварыФорма, КолонкаТовара); КонецЕсли;
			
		Если Массив.Количество() Тогда
			ЕстьВалютаУОбъекта = Форма.Элементы.Найти(ПутьКВалюте) <> Неопределено; 
			//ИнфОТоваре = РаботаСНоменклатурой.ПолучитьИнформациюHTMLОТовареВсюВHTML(Массив, ?(ЭлементВалюта <> Неопределено, Вычислить("Форма." + ЭлементВалюта.ПутьКДанным), КэшируемыеФункции.ВалютаУправленческогоУчета()));
			ИнфОТоваре = РаботаСНоменклатурой.ПолучитьИнформациюHTMLОТовареВсюВHTML(Массив, ?(ЕстьВалютаУОбъекта, Вычислить("Форма." + ПутьКВалюте), Неопределено));
			//ИнфОТоваре = РаботаСНоменклатурой.ПолучитьИнформациюHTMLОТовареВсюВHTML(Массив, ?(ЕстьВалютаУОбъекта, Форма[ПутьКВалюте], Неопределено));
							
			Форма.ИнфТовараТекстHTML = ИнфОТоваре; КонецЕсли; КонецЕсли;

КонецПроцедуры

// Матрицы

Процедура ОбработкаУправленияМатрицей(ВыбЭлемент, ДопПараметры) Экспорт
	
	Если ВыбЭлемент <> Неопределено И ВыбЭлемент.Значение <> Неопределено Тогда
		
		Если ВыбЭлемент.Значение = "ВыбратьВсе" Тогда
			
			ДопПараметры.Форма.УстановитьЗначениеВсехМатриц(Истина);
			
		ИначеЕсли ВыбЭлемент.Значение = "ОтменитьВсе" Тогда
			
			ДопПараметры.Форма.УстановитьЗначениеВсехМатриц(Ложь);
			
		ИначеЕсли СтрНачинаетсяС(ВыбЭлемент.Значение, "Установить") Тогда
			
			ИмяМатрицы = Сред(ВыбЭлемент.Значение, 11);
			Ссылки 	= ДопПараметры.Форма.Элементы.Список.ВыделенныеСтроки;
			Кол 	= Ссылки.Количество();
			Ном 	= 0;
			
			// вначеле проверим всех
			
			Если РаботаСНоменклатурой.МожноУстановитьМатрицу(ИмяМатрицы, Ссылки) Тогда
				
				// Потом установим каждого чтобы выводить завараживающий прогресс бар
				
				Для Каждого Ссылка Из Ссылки Цикл Ном = Ном + 1; ОбработкаПрерыванияПользователя();
					Если Не РаботаСНоменклатурой.УстановитьМатрицуНаТовар(Ссылка, ИмяМатрицы, Ложь) Тогда
						Возврат; КонецЕсли; 
					Если Кол > 3 Тогда Состояние("Установка матрицы " + ИмяМатрицы, Ном / Кол * 100, Ссылка, ВыбЭлемент.Картинка); КонецЕсли; КонецЦикла;
			
				ПоказатьОповещениеПользователя("Матрицы установлены",,ИмяМатрицы, ВыбЭлемент.Картинка);
				ДопПараметры.Форма.Элементы.Список.Обновить(); КонецЕсли;
			
		ИначеЕсли СтрНачинаетсяС(ВыбЭлемент.Значение, "Снять") Тогда
			
			ИмяМатрицы = Сред(ВыбЭлемент.Значение, 6);
			Ссылки 	= ДопПараметры.Форма.Элементы.Список.ВыделенныеСтроки;
			Кол 	= Ссылки.Количество();
			Ном 	= 0;
			
			Для Каждого Ссылка Из Ссылки Цикл Ном = Ном + 1; ОбработкаПрерыванияПользователя();
				Если Не РаботаСНоменклатурой.СнятьМатрицуСТовара(Ссылка, ИмяМатрицы) Тогда
					Возврат; КонецЕсли; 
				Если Кол > 3 Тогда	Состояние("Отмена матрицы " + ИмяМатрицы, Ном / Кол * 100, Ссылка, ВыбЭлемент.Картинка); КонецЕсли; КонецЦикла;
			
			ПоказатьОповещениеПользователя("Матрицы сняты",,ИмяМатрицы, ВыбЭлемент.Картинка); 
			ДопПараметры.Форма.Элементы.Список.Обновить(); КонецЕсли; КонецЕсли;
	
КонецПроцедуры

Функция ЕстьСтопПродажи(Товары) Экспорт
	
	масТоваров = Новый Массив;
	Для Каждого Строка Из Товары Цикл масТоваров.Добавить(Строка.Номенклатура) КонецЦикла;
	
	Возврат РаботаСНоменклатурой.ЕстьСтопПродажи(масТоваров);
	
КонецФункции
