﻿
Функция ПолучитьТаблицуТоваров(СсылкаПроцесс, СсылкаЗадача)
	
	Если ТипЗнч(СсылкаПроцесс) = Тип("БизнесПроцессСсылка.ПеремещениеТоваров") Тогда ЭтоПеремещение = Истина;
		
		ТабТов = БизнесПроцессы.ПеремещениеТоваров.ПолучитьСостояниеТоваровПоЗаказчику(СсылкаПроцесс);
		
		ЭтоВнутрЗаказ 	= БизнесПроцессы.ПеремещениеТоваров.ЭтоСборкаВнутреннегоЗаказа(СсылкаПроцесс);
		
		// Удалим состояние левые
		
		СостояниеОтправитьТовар 	= Перечисления.СостояниеСборкиЗаказа.ОжидаетПеремещения;
		СостояниеСобранТовар 		= Перечисления.СостояниеСборкиЗаказа.Собрано;
		
		Инд 		= -1;
		КолСтрок 	= ТабТов.Количество();
		
		Для Ном = 1 По КолСтрок Цикл Инд = КолСтрок - Ном;
			
			Строка = ТабТов[Инд];
			
			Если 	(НЕ ЭтоВнутрЗаказ И Строка.Состояние <> СостояниеОтправитьТовар) Или
					(ЭтоВнутрЗаказ И СостояниеСобранТовар <> СостояниеСобранТовар) Тогда
					
				ТабТов.Удалить(Инд);
				
			КонецЕсли;
		КонецЦикла;
		
		СостояниеОтборДляЯчеек = СостояниеОтправитьТовар; 		
		
	Иначе
		
		ТабТов = Заказы.ПолучитьСостояниеТоваров(СсылкаПроцесс);
		СостояниеОтборДляЯчеек =  Перечисления.СостояниеСборкиЗаказа.Собирается;
		
	КонецЕсли;
	
	//Круглов: поскольку фунция возвращает всегда разные колонки с дублями из за размещения в разных ячейках - делаем вот такое вот извращение
				
	КолонкиСтрока = КонвертацияТипов.ПолучитьСтрокуИзКолонокТаблицыЗначений(ТабТов, "Количество");
	
	ТабТов.Свернуть(КолонкиСтрока, "Количество");	
	
	//Круглов
	
	// Добавим ячейки из буфера
	
	Если СсылкаЗадача.Склад.Ячеестый Тогда
		ТабТов.Колонки.Добавить("Ячейка", Новый ОписаниеТипов("СправочникСсылка.Ячейки"));
		ТабТов.Колонки.Добавить("Сборщик", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
		
		ФункцииФормДокументов.ЗаполнитьСохраненныеЯчейкиЗадачи2(СсылкаЗадача, ТабТов, СостояниеОтборДляЯчеек);
			
	КонецЕсли;
		
	Возврат  ТабТов;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивЗадач = ?(Объект.Ссылка.Пустая(), Параметры.МассивЗадач, Справочники.ОбъедененнаяСборка.ПолучитьМассивЗадач(Объект.Ссылка));
	
	СостояниеСобирается = Перечисления.СостояниеСборкиЗаказа.Собирается; 
	
	НоваяТаблица = Товары.Выгрузить();
		
	Для Каждого СсылкаЗадача ИЗ МассивЗадач Цикл  
		
		ТабТов = ПолучитьТаблицуТоваров(СсылкаЗадача.БизнесПроцесс, СсылкаЗадача);
		
		// добавляем таблицу к итоговой таблице
		Для Каждого Строка Из ТабТов Цикл  
			
			новСтрока = НоваяТаблица.Добавить(); 
			ЗаполнитьЗначенияСвойств(новСтрока, Строка);
			
			Если НЕ ЭтоПеремещение И новСтрока.Состояние = СостояниеСобирается Тогда новСтрока.Собрано = Истина; КонецЕсли;
			
			// проставляем недостающие данные
			новСтрока.МаксимальноеКоличество = Строка.Количество;
			новСтрока.Задача 	= СсылкаЗадача;
			новСтрока.Заказ 	= СсылкаЗадача.Заказ;  КонецЦикла;		
		
		
	КонецЦикла;
	
	Товары.Загрузить(НоваяТаблица);
	
	Объект.Склад = МассивЗадач[0].Склад;
	Объект.ВидЗадач = МассивЗадач[0].ТочкаМаршрута;
	
	//Если ЭтоПеремещение Тогда
	//	
	//	Объект.СкладПолучатель = МассивЗадач[0].БизнесПроцесс.СкладПолучатель;
	//
	//	Если Объект.Склад.Код = "СК2" И Объект.СкладПолучатель.Код = "СКЛ" Тогда ОтправитьВСборку = Истина; КонецЕсли;
	//	
	//	//Если ЯчейкаПолучатель.Пустая() И Объект.СкладПолучатель.Ячеестый Тогда
	//	//	Объект.ЯчейкаПолучатель = ОБъект.СкладПолучатель.ЯчейкаПеремещенияПоУмолчанию;
	//	//КонецЕсли;		
	//КонецЕсли;
	
	
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	// Видимости
	Элементы.КнопкаСобратьИЗакрыть.Видимость 	= Объект.ВидЗадач = БизнесПроцессы.СборкаЗаказа.ТочкиМаршрута.СобратьЗаказ ИЛИ Объект.ВидЗадач = БизнесПроцессы.СборкаЗаказа.ТочкиМаршрута.СобратьЗаказ1;
	
	//Элементы.ФормаОтправитьТовар.Видимость 		= Объект.ВидЗадач = БизнесПроцессы.ПеремещениеТоваров.ТочкиМаршрута.ОтправитьТовар;
	//
	//Элементы.ГруппаРеквизитыПеремещения.Видимость = ЭтоПеремещение; 
	//Элементы.ЯчейкаПолучатель.Видимость			  = БыстроеПеремещение И Объект.СкладПолучатель.Ячеестый;
	//Элементы.БыстроеПеремещение.Доступность 	  = Справочники.Склады.РазрешеноБыстроеПеремещение(Объект.Склад, Объект.СкладПолучатель);

	//Элементы.ФормаОтправитьТовар.Заголовок = ?(БыстроеПеремещение, 
	//		"Отправить и принять товар", "Отправить товар");
	
КонецПроцедуры



&НаСервере
Процедура ЗаполнитьЯчейкиНаСервере()
	
	ТаблицаТовары = Товары.Выгрузить();
	ТаблицаТовары.Индексы.Добавить("Задача");
	
	НоваяТаблица = ТаблицаТовары.СкопироватьКолонки();
		
	ТаблицаЗадачи = ТаблицаТовары.Скопировать(,"Задача");
	ТаблицаЗадачи.Свернуть("Задача");
	
	Для Каждого Строка ИЗ ТаблицаЗадачи Цикл
		
		ТаблицаОднойЗадачи = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(ТаблицаТовары, Новый Структура("Задача", Строка.Задача)); 
	
		ФункцииФормДокументов.ЗаполнитьЯчейки(ТаблицаОднойЗадачи,,,Объект.Склад,,,,Истина, Строка.Задача, ?(ЭтоПеремещение, Неопределено, Новый Структура("Собрано", Истина)));
		
		КонвертацияТипов.ДобавитьТаблицуКДругойТаблице(НоваяТаблица, ТаблицаОднойЗадачи);
	КонецЦикла;	
	
	Товары.Загрузить(НоваяТаблица);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЯчейки(Команда)
	ЗаполнитьЯчейкиНаСервере();
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Функция ПеречислениеСостояниеСобирается()
	
	Возврат Перечисления.СостояниеСборкиЗаказа.Собирается;
	
КонецФункции

&НаКлиенте
Процедура УстановитьЗначениеДляВсех(Значение, ИмяКолонки, ТолькоСобранные = Ложь)
	
	Если ЭтоПеремещение Тогда 
		Для Каждого Строка Из Товары Цикл Строка[ИмяКолонки] = Значение; КонецЦикла;
	Иначе
		
		Строки = Товары.НайтиСтроки(Новый Структура("Состояние", ПеречислениеСостояниеСобирается())); 
		Для Каждого Строка Из Строки Цикл Если Не ТолькоСобранные Или Строка.Собрано Тогда Строка[ИмяКолонки] = Значение; КонецЕсли; КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокСборщиков()
	
	Возврат ДиалогиСПользователем.ПолучитьСписокСборщиков();
	
КонецФункции
&НаКлиенте
Процедура ВыбратьСборщика(Команда)
	
	Список 		= ПолучитьСписокСборщиков();
	ВЫбЭлемент 	= ВыбратьИзМеню(Список, Элементы.ТоварыВыбратьСборщика);
	
	Если ВЫбЭлемент <> Неопределено Тогда
		
		//ВыбратьЭлементДляВсех("Справочник.ФизическиеЛица.ФормаВыбора", "Сборщик");
		УстановитьЗначениеДляВсех(ВЫбЭлемент.Значение, "Сборщик", НЕ ЭтоПеремещение);
		Модифицированность = Истина;
	КонецЕсли;
		
КонецПроцедуры
&НаКлиенте
Процедура ВсеСобрано(Команда)
	
	УстановитьЗначениеДляВсех(Истина, "Собрано");
	
КонецПроцедуры
&НаКлиенте
Процедура НичегоНеСобрано(Команда)
	
	УстановитьЗначениеДляВсех(Ложь, "Собрано");
	
КонецПроцедуры
&НаКлиенте
Процедура ПоказатьДвижение(Команда)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекДанные <> Неопределено Тогда
	
		ПараметрыФормы = Новый Структура("Отбор, КлючНазначенияИспользования, СформироватьПриОткрытии", 
	 							Новый Структура("Номенклатура", 
											ТекДанные.Номенклатура),,
								Истина);
								
		ОткрытьФорму("Отчет.ВедомостьОдногоТовара.ФормаОбъекта", ПараметрыФормы);

		
	КонецЕсли;
					
КонецПроцедуры
&НаКлиенте
Процедура ПоказатьЯчейки(Команда)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекДанные <> Неопределено Тогда
	
		ПараметрыФормы = Новый Структура("Отбор, КлючНазначенияИспользования, СформироватьПриОткрытии", 
	 							Новый Структура("Номенклатура", 
											ТекДанные.Номенклатура),,
								Истина);
								
		ОткрытьФорму("Отчет.ДвижениеЯчеек.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

// ПЕЧАТЬ СБОРОЧНОГО ЛИСТА


&НаСервере
Функция ПолучитьТабличныйДокумент(ПоЗаказам = Ложь, ВыводитьПомеченные = Ложь, Сортировка = "Ячейка")
	
	ТабДокумент 	= Новый ТабличныйДокумент;
	Макет 			= ПолучитьОбщийМакет("СборочныйЛист");

	ОбластьШапка 			= Макет.ПолучитьОбласть("Шапка");
	ОбластьКомментарий		= Макет.ПолучитьОбласть("Комментарий");
	ОбластьКомментарийЗаказ	= Макет.ПолучитьОбласть("КомментарийЗаказ");

	ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьИтого 			= Макет.ПолучитьОбласть("Итого");
	ОбластьСтрока 			= Макет.ПолучитьОбласть("Строка");
	ОбластьЗаказ			= Макет.ПолучитьОбласть("СтрокаЗаказ");
	
	//// Шапка
	//
		
	ОбластьШапка.Параметры.Номер 			= Объект.Код;
	ОбластьШапка.Параметры.Дата 			= ТекущаяДата();
	ОбластьШапка.Параметры.Объедененный		= "ОБЪЕДЕНЕННЫЙ";
	ОбластьШапка.Параметры.СинонимДокумента = "Объедененный сборочный лист";
	ОбластьШапка.Параметры.Склад			= Объект.Склад;
	
	// Установим штрих код
	
	//мШтрихКоды = ШтрихКоды.ПолучитьШтрихКодыОбъекта(Заказ); Если мШтрихКоды.Количество() Тогда
	//	ШтрихКоды.УстановитьШтрихКодВМакете(ОбластьШапка, мШтрихКоды[мШтрихКоды.ВГраница()]);КонецЕсли;
	
	//Попытка
	//	ОбластьЗаголовокТаблицы.Параметры.ТипЦен 	= Строка(Объект.БизнесПроцесс.Заказ.ТипЦен);
	//	ОбластьЗаголовокТаблицы.Параметры.Цена 		= "Цена, " + Строка(Объект.БизнесПроцесс.Заказ.Валюта);
	//Исключение
		ОбластьЗаголовокТаблицы.Параметры.ТипЦен 	= "";
		ОбластьЗаголовокТаблицы.Параметры.Цена 		= "Цена";
	//КонецПопытки;
	
	ТабДокумент.Вывести(ОбластьШапка);
	
	// Сформируем комментарий
	
	ТаблицаЗадачи = ПолучитьЗадачиИзТоваров();
	Если НЕ ПоЗаказам Тогда
		Для Каждого Строка ИЗ ТаблицаЗадачи Цикл
			
			Представление = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Строка.Задача.Заказ.Контрагент, ТекущаяДата()), "ПолноеНаименование,ЮридическийАдрес",,Символы.ПС);
			ОбластьКомментарийЗаказ.Параметры.Контрагент = Представление;
			
			ОбластьКомментарийЗаказ.Параметры.Заказ = Строка.Задача.Заказ;
			
			Если ЭтоПеремещение Тогда
				Комменты = БизнесПроцессы.ПеремещениеТоваров.ПолучитьМассивКомментариев(Строка.Задача.БизнесПроцесс);
			Иначе
			    Комменты = БизнесПроцессы.СборкаЗаказа.ПолучитьМассивКомментариев(Строка.Задача.БизнесПроцесс);
			КонецЕсли;
			
			ТабДокумент.Вывести(ОбластьКомментарийЗаказ);
			
			Для Каждого Коммент Из Комменты Цикл
				ОбластьКомментарий.Параметры.Заполнить(Коммент);
				Если Коммент.Исполнитель.Пустая() Тогда
				ОбластьКомментарий.Параметры.Исполнитель = Коммент.Заголовок; //"Последний комментарий:";
				Иначе
				ОбластьКомментарий.Параметры.Исполнитель = Строка(Коммент.Исполнитель) + " (" + Формат(Коммент.ДатаВыполнения,"ДЛФ=DDT") + "):";
			КонецЕсли;
			ТабДокумент.Вывести(ОбластьКомментарий);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	
	ТаблицаТовары = Товары.Выгрузить();
	// пустаястрока для обхода
	Если НЕ ПоЗаказам Тогда
		ТаблицаЗадачи = ТаблицаТовары.СкопироватьКолонки("Задача");
		новСтрока = ТаблицаЗадачи.Добавить();
	КонецЕсли;
	
	Для Каждого СтрокаЗадача ИЗ ТаблицаЗадачи Цикл
		
		Если ПоЗаказам Тогда
			Представление = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(СтрокаЗадача.Задача.Заказ.Контрагент, ТекущаяДата()), "ПолноеНаименование,ЮридическийАдрес",,Символы.ПС);
			ОбластьКомментарийЗаказ.Параметры.Контрагент = Представление;
			
			ОбластьКомментарийЗаказ.Параметры.Заказ = СтрокаЗадача.Задача.Заказ;
			
			Если ЭтоПеремещение Тогда
				Комменты = БизнесПроцессы.ПеремещениеТоваров.ПолучитьМассивКомментариев(СтрокаЗадача.Задача.БизнесПроцесс);
			Иначе
			    Комменты = БизнесПроцессы.СборкаЗаказа.ПолучитьМассивКомментариев(СтрокаЗадача.Задача.БизнесПроцесс);
			КонецЕсли;
			
			ТабДокумент.Вывести(ОбластьКомментарийЗаказ);
			
			Для Каждого Коммент Из Комменты Цикл
				ОбластьКомментарий.Параметры.Заполнить(Коммент);
				Если Коммент.Исполнитель.Пустая() Тогда
				ОбластьКомментарий.Параметры.Исполнитель = Коммент.Заголовок; //"Последний комментарий:";
				Иначе
				ОбластьКомментарий.Параметры.Исполнитель = Строка(Коммент.Исполнитель) + " (" + Формат(Коммент.ДатаВыполнения,"ДЛФ=DDT") + "):";
			КонецЕсли;
			ТабДокумент.Вывести(ОбластьКомментарий);
			КонецЦикла;
		
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьЗаголовокТаблицы);
		
		// Отсортируем чтобы бегали быстрее	
		Если ПоЗаказам Тогда
			
			ТаблВывода = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(ТаблицаТовары, Новый Структура("Задача", СтрокаЗадача.Задача));  
			
		Иначе
			ТаблВывода = ТаблицаТовары.Скопировать();
			ТаблВывода.Свернуть(КонвертацияТипов.ПолучитьСтрокуИзКолонокТаблицыЗначений(ТаблицаТовары, "Количество, Заказ, Задача"), "Количество"); 	
		КонецЕсли;
	
		ТаблВывода.Сортировать(Сортировка);
	
		/////////CUSTOM SHOP СОРТИРОВКА ДЛЯ АНДРЕИЧА////////////////////////////////////////////////                                                                                            
		                                                  
		//нет размещения - 1                                                                        
		//магазин софийский - 2                                                                     
		//магазин Пискаревский - 3                                                                  
		//сервис - 4                                                                                
		//склад 2 - 5                                                                               
		//Новый склад - 6                                                                           
		//все остальное - 7
		ТаблВывода.Колонки.Добавить("Сортировка");
		ТаблВывода.Колонки.Добавить("СортировкаПоУмолчанию", Новый ОписаниеТипов("Строка"));

		СортировкаПоСкладам = Новый СписокЗначений;
		///магазины
		СортировкаПоСкладам.Добавить(Справочники.Склады.НайтиПоКоду("СОФ"), "2");                   
		СортировкаПоСкладам.Добавить(Справочники.Склады.НайтиПоКоду("ПСК"), "3");
		СортировкаПоСкладам.Добавить(Справочники.Склады.НайтиПоКоду("ММ1"), "4");
		///сервис
		СортировкаПоСкладам.Добавить(Справочники.Склады.НайтиПоКоду("СРВ"), "5");                   
		///склад 2
		СортировкаПоСкладам.Добавить(Справочники.Склады.НайтиПоКоду("СК2"), "1");                   
		///
		СортировкаПоСкладам.Добавить(Справочники.Склады.НайтиПоКоду("СКЛ"), "7");                   
		                                                                                            
		Для Каждого Строка Из ТаблВывода Цикл                                                                                    
			Если ЗначениеЗаполнено(Строка.СкладЯчейка) Тогда                                                              
				тмп = СортировкаПоСкладам.НайтиПоЗначению(Строка.СкладЯчейка);                                             
			    Строка.Сортировка = ?(тмп = Неопределено, 8, Число(тмп.Представление));             
			Иначе                                                                                   
				Строка.Сортировка = 9;
				Строка.СортировкаПоУмолчанию = Строка.Ячейка.Сортировка;
			КонецЕсли;		                                                                        
		КонецЦикла;
		ТаблВывода.Сортировать("Сортировка ВОЗР, СортировкаПоУмолчанию, " + Сортировка);
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	Если ВыводитьПомеченные Тогда
		СтрокиВывода = ТаблВывода.НайтиСтроки(Новый Структура("Собрано", Истина));
	Иначе
		СтрокиВывода = ТаблВывода;
	КонецЕсли;
	// Выводим в таблицу
	СтруктураКолонок = КонвертацияТипов.ПолучитьПустуюСтруктуруИзКолонокТаблицыЗначений(ТаблицаТовары.Колонки);
	СтруктураКолонок.Удалить("Количество");
	СтруктураКолонок.Удалить("Задача");
	СтруктураКолонок.Удалить("Заказ");
	
	Ном = 0;
	ПустаяУпаковка = Справочники.УпаковкиНоменклатуры.ПустаяСсылка();
	Для каждого Строка Из СтрокиВывода Цикл Ном = Ном + 1;
		
		ОбластьСтрока.Параметры.Заполнить(Строка);
		ОбластьСтрока.Параметры.Номер 		= Ном;
		ОбластьСтрока.Параметры.Артикул 	= Строка.Номенклатура.Артикул;
		
		ЕдИзм =  ?(Строка.Упаковка  = ПустаяУпаковка, Строка.Номенклатура.ЕдиницаИзмерения, Строка.Упаковка);
		ОбластьСтрока.Параметры.ЕдиницаИзмерения = ЕдИзм;
		
		ОбластьСтрока.Параметры.Ячейка = Строка.Ячейка;

		Если Строка.Ячейка.Пустая() Тогда 
			ОбластьСтрока.Параметры.Ячейка = ?(ЗначениеЗаполнено(Строка.СкладЯчейка), Строка.СкладЯчейка ,Строка.Размещение); КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьСтрока); 
		
		ЗаполнитьЗначенияСвойств(СтруктураКолонок, Строка); 
		СтрокиТаблицы = ТаблицаТовары.НайтиСтроки(СтруктураКолонок);
		КоличествоЗаказов = СтрокиТаблицы.Количество();
		
		Если НЕ ПоЗаказам Тогда
			Для Каждого СтрокаЗаказа Из СтрокиТаблицы Цикл
				
				ОбластьЗаказ.Параметры.Количество = ?(КоличествоЗаказов > 1, СтрокаЗаказа.Количество, "");
				
				ОбластьЗаказ.Параметры.НомерЗаказа = "[" + ФормированиеПечатныхФорм.ПолучитьНомерНаПечать(СтрокаЗаказа.Заказ.Номер) + "] ";
				ОбластьЗаказ.Параметры.Заказ = Строка(СтрокаЗаказа.Заказ.Контрагент) + " /" + Формат(СтрокаЗаказа.Заказ.Дата, "ДФ=dd.MM.yy; ДЛФ=") + "/";
				
				ТабДокумент.Вывести(ОбластьЗаказ);
				
			КонецЦикла ;
		КонецЕсли;
		
	КонецЦикла; 
	
	ОбластьИтого.Параметры.ДатаФормирования = Формат(ТекущаяДата(),"ДЛФ=DDT");
	ТабДокумент.Вывести(ОбластьИтого);
	
	КонецЦикла;
	// Настрим просмотры
	
	ТабДокумент.ТолькоПросмотр 	= Истина;
	ТабДокумент.ОтображатьСетку = Ложь;
	
	Возврат ТабДокумент;
	
КонецФункции

#Область ИнвормацияОТоваре

// ИНФОРМАЦИЯ О ТОВАРЕ

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре()	
	 	
КонецПроцедуры
&НаСервере
Процедура ОбработатьОтображениеИнформацииОТоваре() Экспорт
	РаботаСНоменклатурой.ОбработатьОтображениеИнформацииОТоваре(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ИнфТовараТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура ИнфТовараЗаголовокHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараЗаголовокHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры

 &НаКлиенте
Процедура ПоказатьСкрытьИнфОТоваре(Команда)
	РаботаСНоменклатуройКлиент.ПоказатьСкрытьИнфОТоваре(ЭтаФорма);
КонецПроцедуры
&НаКлиенте
Процедура НастройкаИнфОТоваре(Команда) 
	РаботаСНоменклатуройКлиент.НастройкаИнфОТоваре(ЭтаФорма);
КонецПроцедуры


#КонецОбласти 

&НаСервере
Функция ПолучитьЗадачиИзТоваров()
	
	ТаблицаЗадачи = Товары.Выгрузить().Скопировать(,"Задача");
	ТаблицаЗадачи.Свернуть("Задача");
	
	Возврат ТаблицаЗадачи;
	
КонецФункции

&НаСервере
Функция ЗаписатьЯчейкиНаСервере()
	
	ТаблицаТовары = Товары.Выгрузить();
	ТаблицаТовары.Индексы.Добавить("Задача");	
	
	ТаблицаЗадачи = ТаблицаТовары.Скопировать(,"Задача");
	ТаблицаЗадачи.Свернуть("Задача");
	
	Для Каждого Строка ИЗ ТаблицаЗадачи Цикл
		
		ТаблицаОднойЗадачи = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(ТаблицаТовары, Новый Структура("Задача", Строка.Задача)); 
	
		Если НЕ ФункцииФормДокументов.ЗапомнитьЯчейкиВЗадаче(Строка.Задача, ТаблицаОднойЗадачи) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;	
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьЯчейки(Команда)
	ЗаписатьЯчейкиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПечатьСборочногоЛистаПоЗаказам(Команда)
	Если Модифицированность Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ПодтверждениеПечатиСборочного", ЭтаФорма), "Для печати сборочного листа необходимо сохранить данные. Выполнить сохранение?", РежимДиалогаВопрос.ОКОтмена);
	Иначе
		ПолучитьТабличныйДокумент(Истина).Показать();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПечатьСборочногоЛиста(Команда)
	
	Если Модифицированность Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ПодтверждениеПечатиСборочного", ЭтаФорма), "Для печати сборочного листа необходимо сохранить данные. Выполнить сохранение?", РежимДиалогаВопрос.ОКОтмена);
	Иначе
		ПолучитьТабличныйДокумент().Показать();
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ПодтверждениеПечатиСборочного(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено И Результат = КодВозвратаДиалога.ОК Тогда
		Записать();
		ПолучитьТабличныйДокумент().Показать();
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция ПроверитьСборщиков()
	
	Отказ = Ложь;
	
	Если НЕ Объект.Склад.УчетПоСбощикамЗаказов Тогда
		Возврат Не Отказ;
	КонецЕсли;
	
	Инд = -1;
	Для Каждого Строка Из Товары Цикл Инд = Инд + 1;
		Если 	Строка.Собрано = Истина И
				Строка.Сборщик.Пустая() Тогда
					
			Отказ = Истина;
			ОбщиеФункции.СообщитьТекст("Не выбран сборщик позиции!","Товары[" + Формат(Инд,"ЧГ=") + "].Сборщик");
					
		КонецЕсли;
	КонецЦикла;
	
	Возврат Не Отказ;
	
КонецФункции
&НаСервере
Функция ПроверитьЯчейки()
	
	Отказ = Ложь;
	
	Если Объект.Склад.Ячеестый Тогда
	
		Инд = -1;
		Для Каждого Строка Из Товары Цикл Инд = Инд + 1;
			Если 	Строка.Собрано = Истина И
					Строка.Ячейка.Пустая() Тогда
					
				Отказ = Истина;
				ОбщиеФункции.СообщитьТекст("Не заполнена ячейка","Товары[" + Формат(Инд,"ЧГ=") + "].Ячейка");
					
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

&НаКлиенте
Процедура СобратьИЗакрыть(Команда)
	
	Отказ = Ложь;
	
	// Проверим что ячейки заполнены
	
	Если Не ПроверитьЯчейки() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Проверим что ячейки заполнены
	
	Если Не ПроверитьСборщиков() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Записать(Новый Структура("ВыполнениеЗадачи",Истина));
	
	// Создадим сборку и проведем ее
	
	Состояние("Идет процесс сохранения данных и выполнение выбранных задач");
	Если Не СформироватьПровестиСборкуИВыполнитьЗадачу() Тогда
		Состояние("Выполнение завершено с ошибкой",,,БиблиотекаКартинок.Отмена);
		Отказ = Истина;
	КонецЕсли;
	
	Если Не Отказ Тогда                                                         
		Состояние("Выполнение успешно завершено",,,БиблиотекаКартинок.Ок);

		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьПровестиСборкуИВыполнитьЗадачу()
	
	СостояниеСобрано = Перечисления.СостояниеСборкиЗаказа.Собрано;
	ТаблицаЗадачи = ПолучитьЗадачиИзТоваров();
	НачатьТранзакцию();

	Для Каждого СтрокаЗадача ИЗ  ТаблицаЗадачи Цикл
		
		Задача = СтрокаЗадача.Задача;
		Заказ = Задача.Заказ;
		Процесс = Задача.БизнесПроцесс;
		
		Сборка = Документы.СборочныйЛист.СоздатьДокумент();
		Сборка.Заполнить(Новый Структура("Шапка, Товары, ТоварыУсловие", 
				Новый Структура("Заказ, Склад", Заказ, Заказ.Склад), 
				Товары.НайтиСтроки(Новый Структура("Задача", Задача))),
				"Строка.Собрано И Строка.Состояние <> Перечисления.СостояниеСборкиЗаказа.Собрано");
		
	//	Сборка = Документы.СборкаЗаказа.СоздатьДокумент();
	//	Сборка.Дата = ТекущаяДата();
	//	Сборка.Заказ = Заказ;
	//	Сборка.Склад = Заказ.Склад;
	//
	////СпособРазмещенияБезЗаказа = Заказ.СпособРазмещенияБезЗаказа;
	//
	//	СтрокиТоваров = Товары.НайтиСтроки(Новый Структура("Задача", Задача));
	//
	//	Для Каждого Строка Из СтрокиТоваров Цикл
	//		Если 	Строка.Собрано И
	//				Строка.Состояние <> СостояниеСобрано Тогда
	//		
	//			НовСтрока = Сборка.Товары.Добавить();
	//			НовСтрока.Номенклатура 	= Строка.Номенклатура;
	//			НовСтрока.СкладЯчейка	= Строка.Ячейка;
	//			НовСтрока.Упаковка 		= Строка.Упаковка;
	//			НовСтрока.Сборщик 		= Строка.Сборщик;
	//			НовСтрока.Собрано 		= Строка.Количество; КонецЕсли; КонецЦикла;
	
	
		// Запишем процесс если флаг изменили
	
		Если Процесс.ПродолжатьСобирать <> ПродолжатьСобирать Тогда
		
			ПроцессОбъект = Процесс.ПолучитьОбъект();
			ПроцессОбъект.ПродолжатьСобирать = ПродолжатьСобирать;
			
			Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(ПроцессОбъект) Тогда
				ОтменитьТранзакцию();
				Возврат Ложь; КонецЕсли;КонецЕсли;
	
		// Запишем документ
		
		Если 	Сборка.Товары.Количество() И
				Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Сборка, РежимЗаписиДокумента.Проведение) Тогда
					ОтменитьТранзакцию();
					Возврат Ложь; КонецЕсли;
	
		// Запишем задачу
		ЗадачаОбъект = Задача.ПолучитьОбъект(); 
		ЕстьОшибка = Ложь;
		
		Попытка
			ЗадачаОбъект.ВыполнитьЗадачу();
		Исключение  
			ЕстьОшибка = Истина;
			ОбщиеФункции.СообщитьТекст("Ошибка при записи " + Строка(ЗадачаОбъект) + "
							|" + ОписаниеОшибки());
		КонецПопытки; 
		
		Если ЕстьОшибка Тогда
			
			ОтменитьТранзакцию();
			Возврат Ложь; КонецЕсли;
	
		
		// Установим статус
	
		Заказы.УстановитьСостояниеЗаказа(Заказ, Перечисления.СостоянияЗаказа[
				?(Сборка.Товары.Количество(),
						?(Заказы.ЗаказЧастичноСобран(Процесс), "СобранЧастично","Собран"),
						"ВОчередиНаСкладПовторно")]); 
						
		КонецЦикла;				
		ЗафиксироватьТранзакцию();
		
		Возврат Истина;
	
КонецФункции
//&НаСервере
//Функция СформироватьИПровестиОтправкуТовараИПроверитьБП()
//	
//	
//	ТаблицаЗадачи = ПолучитьЗадачиИзТоваров();
//	НачатьТранзакцию();

//	Для Каждого СтрокаЗадача ИЗ  ТаблицаЗадачи Цикл
//		Задача = СтрокаЗадача.Задача;
//		Заказ = Задача.Заказ;
//		Процесс = Задача.БизнесПроцесс;
//		ЗаказСобран = Процесс.ЗаказСобран;
//	
//	
//	// Запишем галку процесса если изменилась
//	
//	Если 	БыстроеПеремещение И
//			БыстроеПеремещение <> Процесс.БыстроеПеремещение Тогда
//			
//		Процесс = Процесс.ПолучитьОбъект();
//		Процесс.БыстроеПеремещение = БыстроеПеремещение;
//		
//		Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Процесс) Тогда 
//			ОтменитьТранзакцию(); Возврат Ложь; КонецЕсли; КонецЕсли;
//	
//	// Теперь документ
//	
//	Если Товары.Количество() Тогда
//		
//		// Вытащим товары

//			// Заполним документы по разному
//		
//		Если БыстроеПеремещение Тогда
//			
//			НовДок = Документы.ПеремещениеТоваров.СоздатьДокумент();
//			НовДок.Основание 		= Процесс;
//			НовДок.ОтправитьВСборку = ?(БизнесПроцессы.ПеремещениеТоваров.ПолучитьПроцессРодитель(Процесс) = Неопределено, ОтправитьВСборку, Ложь);
//			НовДок.СпособРазмещенияБезЗаказа = БизнесПроцессы.ПеремещениеТоваров.ПолучитьЗаказ(Процесс).СпособРазмещенияБезЗаказа;
//						
//		Иначе
//			
//			НовДок = Документы.ОтгрузкаТоваров.СоздатьДокумент();
//			НовДок.Процесс 	= Процесс;
//			НовДок.Маршрут 	= Процесс.Маршрут;
//			
//		КонецЕсли;
//		
//		// подготовим документы по общему
//		
//		НовДок.Дата 			= ТекущаяДата();
//		НовДок.СкладОтправитель = Объект.Склад;
//		НовДок.СкладПолучатель 	= Объект.СкладПолучатель;
//		
//		
//		СтрокиТоваров = Товары.НайтиСтроки(Новый Структура("Задача", Задача));
//		
//		Для Каждого Строка ИЗ СтрокиТоваров Цикл Если Строка.Количество = 0 Тогда Продолжить; КонецЕсли;
//			
//			// если это последнее перемещение внутреннего заказатогда очистим ячейки чтобы по ним не делались движения, 
//			//	так как по ним уже сделало движение сборка, в других случаях ячейку заполним
//			
//			новСтрока = НовДок.Товары.Добавить();
//			ЗаполнитьЗначенияСвойств(новСтрока, Строка);
//			
//			Если Не ЗаказСобран Тогда
//				
//				новСтрока.СкладЯчейкаСборки = ?(Строка.Ячейка.Пустая(), Объект.СкладОтправитель, Строка.Ячейка);
//				
//				Если БыстроеПеремещение Тогда
//					новСтрока.ЯчейкаОтправитель = Строка.Ячейка;
//					новСтрока.ЯчейкаПолучатель 	= ЯчейкаПолучатель; КонецЕсли;
//				
//			ИначеЕсли Не БыстроеПеремещение И ЗаказСобран Тогда
//				
//				новСтрока.Ячейка = Справочники.Ячейки.ПустаяСсылка();
//			КонецЕсли;
//		КонецЦикла;
//		
//			// Запишем с проведением
//			
//		Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(НовДок, РежимЗаписиДокумента.Проведение) Тогда 
//			ОтменитьТранзакцию(); Возврат Ложь КонецЕсли; КонецЕсли;

//	КонецЦикла;
//	ЗафиксироватьТранзакцию();
//	
//	Возврат Истина;
//	
//КонецФункции

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТаблицаЗадачи = ПолучитьЗадачиИзТоваров();
	
	Для Каждого Элемент ИЗ ТаблицаЗадачи Цикл
		Запись = РегистрыСведений.СборочныеЛисты.СоздатьМенеджерЗаписи();
		Запись.Код = ТекущийОбъект.Код;
		Запись.ОбъедененнаяСборка = ТекущийОбъект.Ссылка;
		Запись.Задача = Элемент.Задача;
		Запись.Использование = Истина;
		
		Попытка
			Запись.Записать();
		Исключение
			Сообщить(ОписаниеОшибки());
			Отказ = Истина;
		КонецПопытки;	
		
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Модифицированность Тогда

		Если НЕ ЗаписатьЯчейкиНаСервере() Тогда
			Отказ = Истина;
		КонецЕсли;
	
	КонецЕсли;
	
	ПредставлениеЗадач = "";
	
	ТаблицаЗадачи = Товары.Выгрузить().Скопировать(,"Задача");
	ТаблицаЗадачи.Свернуть("Задача");
	
	Для Каждого Строка Из ТаблицаЗадачи Цикл
			
		Если 	НЕ ПараметрыЗаписи.ВыполнениеЗадачи И
				НЕ Заказы.УстановитьСостояниеЗаказа(Строка.Задача.Заказ, Перечисления.СостоянияЗаказа.Собирается) Тогда Отказ = Истина; КонецЕсли;

		ПредставлениеЗадач = ПредставлениеЗадач + Строка.Задача + "; "; 
	
	КонецЦикла;
			
	ТекущийОбъект.ПредставлениеЗадач = ПредставлениеЗадач; 
	ТекущийОбъект.ВидЗадач = ТаблицаЗадачи[0].Задача.ТочкаМаршрута;
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если НЕ ПараметрыЗаписи.Свойство("ВыполнениеЗадачи") Тогда
		ПараметрыЗаписи.Вставить("ВыполнениеЗадачи", Ложь); КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломИзменения(Элемент, Отказ)
		
	// Определим колонку и строку
	
	ТекКолонка 		= Элементы.Товары.ТекущийЭлемент.Имя;
	ТекДанные 		= Элементы.Товары.ТекущиеДанные;
	
	ФильтрНЕСобрано =  НЕ ТекДанные.Собрано И НЕ ЭтоПеремещение;
	
	// Дадим доступ если не собрано
	
	Если 	(
				ТекКолонка = "ТоварыСобрано" И
				Не ТекущаяСтрокаСобирается(ТекДанные.Состояние)
				
			) ИЛИ
			
			(
				ТекКолонка = "ТоварыСборщик" И
				ФильтрНЕСобрано
			)
			Тогда
			
		Отказ = Истина;
		Возврат;
		
	КонецЕсли; 	
	
	// Не дадим писать больше чем в заказе
	
	Элементы.ТоварыКоличество.МаксимальноеЗначение = ТекДанные.МаксимальноеКоличество;
	
	Если ТекКолонка = "ТоварыКоличество" И ФильтрНЕСобрано Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

КонецПроцедуры
&НаСервере
Функция ТекущаяСтрокаСобирается(ТекущееСостояние)
	
	Возврат ТекущееСостояние = Перечисления.СостояниеСборкиЗаказа.Собирается;
	
КонецФункции



