﻿
&НаКлиенте
Процедура УправлениеВидимостьюДоступностью()
	
	текДанные = Элементы.ВордДокументы.ТекущиеДанные;
	ДоступностьКнопок = текДанные <> Неопределено И текДанные.Картинка;
	
	Элементы.КнопкаОткрыть.Доступность 	= ДоступностьКнопок;
	Элементы.КнопкаПечать.Доступность 	= ДоступностьКнопок;
	
КонецПроцедуры


&НаСервере
Процедура УдалитьОдинокиеСтроки(Строка)
	
	// Обработаем по иерархии
	
	Удалить = Истина;
	Для Каждого ВложСтрока Из Строка.Строки Цикл УдалитьОдинокиеСтроки(ВложСтрока) КонецЦикла;
	
	// Удалим если строка одинока
	// или если удалил и теперь он единственный тогда сносим и себя
	
	Если	Не Строка.Строки.Количество() И 
			Строка.Родитель <> Неопределено И 
			Строка.Родитель.Строки.Количество() = 1 Тогда 
			
		Строка.Родитель.Строки.Удалить(Строка);КонецЕсли;
		
КонецПроцедуры
&НаСервере
Функция ПолучитьСамуюНизкуюСтроку(Строка)
	
	Возврат ?(Строка.Строки.Количество(), ПолучитьСамуюНизкуюСтроку(Строка.Строки[0]), Строка);
	
КонецФункции
&НаСервере
Процедура УбратьПромежутки(Дерево, Строка)
	
	// Выбрались на самый верх
	
	Если Строка.Родитель = Неопределено Тогда Возврат; КонецЕсли;
	
	// Поднимаемся выше
	
	Если Строка.Родитель.Строки.Количество() > 1 Тогда УбратьПромежутки(Дерево, Строка.Родитель); КонецЕсли;
	
	// Детей и отдаем родителям а сами ликвидируемся
	
	Попытка
		Если Строка.Родитель.Строки.Количество() = 1 Тогда Для Каждого ВложСтрока Из Строка.Строки Цикл 
			КонвертацияТипов.ПеренестиРодителяВДереве(Дерево, Строка.Родитель, ВложСтрока); КонецЦикла; КонецЕсли; Исключение КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьПредставлениеСтрок(Строка)
	
	Если Строка.Строки.Количество() Тогда
		
		Если ЗначениеЗаполнено(Строка.ДокументВордПредставление) Тогда
			Строка.Представление = Строка.ДокументВордПредставление;
		
		ИначеЕсли ЗначениеЗаполнено(Строка.Организация) Тогда
			Строка.Представление = Строка.Организация;
			
		ИначеЕсли ЗначениеЗаполнено(Строка.Контрагент) Тогда
			Строка.Представление = "Контрагент: " + Строка.Контрагент;
			
		ИначеЕсли ЗначениеЗаполнено(Строка.Партнер) Тогда
			Строка.Представление = "Партнер: " + Строка.Партнер; КонецЕсли;
		
		Для Каждого вложСтрока Из Строка.Строки Цикл ИзменитьПредставлениеСтрок(вложСтрока); КонецЦикла; 
		
	Иначе
		
		КоличествоКартинок = КоличествоКартинок + 1;
		Строка.Картинка = ?(ЗначениеЗаполнено(Строка.Замена), 2, 1); КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	0 Картинка,
	|	Договор.Ссылка          	Договор,
	|	Договор.ЗначениеПоУмолчанию 	ПоУмолчанию,
	|	Договор.Организация			Организация,
	|	Договор.Организация			ОрганизацияЗначение,
	|	Договор.Владелец.Партнер		Партнер,
	|	Договор.Владелец 				Контрагент,
	|	Договор.Владелец 				КонтрагентЗначение,
	|	Док.Замена					Замена,
	|	Док.Ссылка					ДокументВорд,
	|	Представление(Док.Ссылка)	ДокументВордПредставление,
	|	Док.НомерСтроки - 1 		ИндексДокумента,
	|	Док.ИмяФайла				ИмяФайла,
	|	Док.ИмяФайла + "" к договору №"" + Договор.Наименование + "" от ("" + Договор.Организация.Наименование + "")"" Представление
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов Договор
	|
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Справочник.ДокументыWord.ДвоичныеДанные Док
	|ПО
	|	Договор.ДокументВорд = Док.Ссылка
	|
	|ГДЕ ИСТИНА
	|" + ?(Параметры.Договор.Пустая(), 	"", "И Договор.Ссылка = &Договор") + "
	|" + ?(Параметры.Партнер.Пустая(), 		"", "И Договор.Владелец.Партнер = &Партнер") + "
	|" + ?(Параметры.Контрагент.Пустая(), 	"", "И Договор.Владелец 		= &Контрагент") + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	Контрагент, Организация, ДокументВорд, ИмяФайла
	|");
	
	Запрос.УстановитьПараметр("Договор", 		Параметры.Договор);
	Запрос.УстановитьПараметр("Партнер", 			Параметры.Партнер);
	Запрос.УстановитьПараметр("Контрагент", 		Параметры.Контрагент);
	//Запрос.УстановитьПараметр("ДокументВорд", 		ДокументВорд);
	//Запрос.УстановитьПараметр("ИндексДокумента", 	ИндексДокумента);
	
	// Загрузим
	ВордДокументы.Загрузить(Запрос.Выполнить().Выгрузить());
	
	
	
	//Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	//
	//// Уберем одиноких
	//
	//Для Каждого Строка Из Дерево.Строки Цикл УдалитьОдинокиеСтроки(Строка); КонецЦикла;
	//
	//// Удадим промежуточные одинокие строки
	//
	////Для Каждого Строка Из Дерево.Строки Цикл УбратьПромежутки(Дерево, ПолучитьСамуюНизкуюСтроку(Строка)); КонецЦикла;
	//
	//// Меняем представления строк
	//Для Каждого Строка Из Дерево.Строки Цикл ИзменитьПредставлениеСтрок(Строка); КонецЦикла;
	//
	//// Положим на форму
	//
	//КонвертацияТипов.ЗагрузитьДеревоВДанныеФормыДерево(Дерево, ВордДокументы);
	
	
	//Запрос = Новый Запрос("
	//|ВЫБРАТЬ РАЗЛИЧНЫЕ
	//|	0 Картинка,
	//|	Контр.ЗначениеПоУмолчанию 	ПоУмолчанию,
	//|	Контр.Организация			Организация,
	//|	Контр.Организация			ОрганизацияЗначение,
	//|	Контр.Ссылка.Партнер		Партнер,
	//|	Контр.Ссылка 				Контрагент,
	//|	Контр.Ссылка 				КонтрагентЗначение,
	//|	Док.Замена					Замена,
	//|	Док.Ссылка					ДокументВорд,
	//|	Представление(Док.Ссылка)	ДокументВордПредставление,
	//|	Док.НомерСтроки - 1 		ИндексДокумента,
	//|	Док.ИмяФайла				ИмяФайла,
	//|	Док.ИмяФайла + "" к договору №"" + Контр.НомерДоговора + "" от ("" + Контр.Организация.Наименование + "")"" Представление
	//|ИЗ
	//|	Справочник.Контрагенты.Организации Контр
	//|
	//|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	//|	Справочник.ДокументыWord.ДвоичныеДанные Док
	//|ПО
	//|	Контр.ДокументВорд = Док.Ссылка
	//|
	//|ГДЕ ИСТИНА
	//|" + ?(Параметры.Организация.Пустая(), 	"", "И Контр.Организация 	= &Организация") + "
	//|" + ?(Параметры.Партнер.Пустая(), 		"", "И Контр.Ссылка.Партнер = &Партнер") + "
	//|" + ?(Параметры.Контрагент.Пустая(), 	"", "И Контр.Ссылка 		= &Контрагент") + "
	////|" + ?(Параметры.ДокументВорд 	= Неопределено, "", "И Док.ДокументВорд 	= &ДокументВорд") + "
	////|" + ?(ИндексДокумента 	= Неопределено, "", "И Док.НомерСтроки - 1 	= &ИндексДокумента") + "
	//|
	//|УПОРЯДОЧИТЬ ПО
	//|	Партнер, Контрагент, Организация, ДокументВорд, ИмяФайла
	//|
	//|ИТОГИ МАКСИМУМ(Представление), МАКСИМУМ(ПоУмолчанию), МАКСИМУМ(ДокументВорд), МАКСИМУМ(Замена) , МАКСИМУМ(КонтрагентЗначение), МАКСИМУМ(ОрганизацияЗначение) ПО
	//|	Партнер, Контрагент, Организация, ДокументВорд
	//|");
	//
	//Запрос.УстановитьПараметр("Организация", 		Параметры.Организация);
	//Запрос.УстановитьПараметр("Партнер", 			Параметры.Партнер);
	//Запрос.УстановитьПараметр("Контрагент", 		Параметры.Контрагент);
	////Запрос.УстановитьПараметр("ДокументВорд", 		ДокументВорд);
	////Запрос.УстановитьПараметр("ИндексДокумента", 	ИндексДокумента);
	//
	//// Загрузим
	//
	//Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	//
	//// Уберем одиноких
	//
	//Для Каждого Строка Из Дерево.Строки Цикл УдалитьОдинокиеСтроки(Строка); КонецЦикла;
	//
	//// Удадим промежуточные одинокие строки
	//
	////Для Каждого Строка Из Дерево.Строки Цикл УбратьПромежутки(Дерево, ПолучитьСамуюНизкуюСтроку(Строка)); КонецЦикла;
	//
	//// Меняем представления строк
	//Для Каждого Строка Из Дерево.Строки Цикл ИзменитьПредставлениеСтрок(Строка); КонецЦикла;
	//
	//// Положим на форму
	//
	//КонвертацияТипов.ЗагрузитьДеревоВДанныеФормыДерево(Дерево, ВордДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура ВордДокументыПриАктивизацииСтроки(Элемент)
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКнопка(Команда)
	
	текДанные = Элементы.ВордДокументы.ТекущиеДанные;
	ДиалогиСПользователем.ОткрытьДокументВордДляПросмотра(текДанные.ДокументВорд, текДанные.ИндексДокумента, Новый Структура("Организация, Контрагент, Партнер, ИндексДоговора", текДанные.ОрганизацияЗначение, текДанные.КонтрагентЗначение, текДанные.Партнер, текДанные.ИндексДокумента));
	
КонецПроцедуры
&НаКлиенте
Процедура ПечатьКнопка(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ВордДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка 	= Ложь;
	текДанные 				= Элементы.ВордДокументы.ТекущиеДанные;
	
	Если текДанные.Картинка Тогда
		
		ДиалогиСПользователем.ОткрытьДокументВордДляПросмотра(текДанные.ДокументВорд, текДанные.ИндексДокумента, Новый Структура("Организация, Контрагент, Партнер, ИндексДоговора", текДанные.ОрганизацияЗначение, текДанные.КонтрагентЗначение, текДанные.Партнер, текДанные.ИндексДокумента));
		
	ИначеЕсли Не ПустаяСтрока(текДанные.ДокументВордПредставление) Тогда
		
		ОткрытьФорму("Справочник.ДокументыWord.ФормаОбъекта", Новый Структура("Ключ", текДанные.ДокументВорд));
		
	ИначеЕсли Не ПустаяСтрока(текДанные.Организация) Тогда
		
		ОткрытьФорму("Справочник.Организации.ФормаОбъекта", Новый Структура("Ключ", текДанные.Организация));
		
	ИначеЕсли Не ПустаяСтрока(текДанные.Контрагент) Тогда
		
		ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", Новый Структура("Ключ", текДанные.Контрагент));
		
	ИначеЕсли Не ПустаяСтрока(текДанные.Партнер) Тогда
		
		ОткрытьФорму("Справочник.Партнеры.ФормаОбъекта", Новый Структура("Ключ", текДанные.Партнер));
		
	Иначе СтандартнаяОбработка = Истина; КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отказ=Истина;
	
	Если ВордДокументы.Количество()=0  Тогда
		
		ПоказатьПредупреждение(,"Нет прикрепленных договоров к контрагенту!",,"Сообщить!");
		
	Иначе
		
		Для Каждого ТекДанные из ВордДокументы Цикл
			структураПеременных = ПолучитьСтруктуруПеременныхДляДоговора(ТекДанные.Договор);
			ДиалогиСПользователем.ОткрытьДокументВордДляПросмотра(текДанные.ДокументВорд, текДанные.ИндексДокумента, структураПеременных); 
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруПеременныхДляДоговора(Договор)
	
	//Получим все необходимые данные для договора
	
	Контрагент=Договор.Владелец;
	Партнер=Договор.Владелец.Партнер;
	Организация=Договор.Организация;
	
	
	Струк = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Контрагент, ТекущаяДата());
	Струк.Вставить("Банк",Строка(Струк.Банк));
	
	Струк.Вставить("Организация",Организация);
	Струк.Вставить("Партнер",Партнер);
	Струк.Вставить("Контрагент",Контрагент);
	
	Струк.Вставить("ТекущаяДата",ТекущаяДата());
	Струк.Вставить("НомерДоговора",Договор.Наименование);
	Струк.Вставить("ДатаНачала",Формат(Договор.ДатаНачала,"ДЛФ=DD"));
	Струк.Вставить("ПолноеНаименованиеОрганизации",Организация.НаименованиеПолное);
	Струк.Вставить("ПолноеНаименованиеКонтрагента",Контрагент.НаименованиеПолное);
	
	Струк.Вставить("ВЛице",Контрагент.ВЛице);
	Струк.Вставить("НаОсновании",Контрагент.НаОсновании);
	Струк.Вставить("Подпись",Контрагент.Подпись);
	Струк.Вставить("Должность",Контрагент.ПодписьДолжность);
	
	Струк.Вставить("Телефон",ФормированиеПечатныхФорм.ПолучитьТелефонОрганизацииКонтрагента(Контрагент));
	Струк.Вставить("ТелефонОрганизации",ФормированиеПечатныхФорм.ПолучитьТелефонОрганизацииКонтрагента(Организация));
	
	Струк.Вставить("ДатаОкончания",Формат(Договор.ДатаОкончания,"ДЛФ=DD"));
	
	Струк.Вставить("СокрНаименование",Контрагент.СокрНаименование);
	Струк.Вставить("Город",Контрагент.Город.Наименование);
	Струк.Вставить("ГородДоставки",Договор.ГородДоставки.НаименованиеВДательномПадеже);
	
	Струк.Вставить("ОтсрочкаБанковскихДней",КонвертацияТипов.ПолучитьКоличествоДнейПрописью(Контрагент.ДнейОтсрочки,"банковского дня, банковских дней", Истина));
	Струк.Вставить("ДнейОтсрочки",Контрагент.ДнейОтсрочки);
	
	Струк.Вставить("НаименованиеОрганизации",Организация.Наименование);
	
	
	Струк2 = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Организация, ТекущаяДата());
	Струк.Вставить("ИННОрганизации",Струк2.ИНН);
	Струк.Вставить("КППОрганизации",Струк2.КПП);
	Струк.Вставить("НомерСчетаОрганизации",Струк2.НомерСчета);
	Струк.Вставить("КоррСчетОрганизации",Струк2.КоррСчет);
	Струк.Вставить("БИКОрганизации",Струк2.БИК);
	Струк.Вставить("БанкОрганизации",Строка(Струк2.Банк));
	Струк.Вставить("ЮридическийАдресОрганизации",Струк2.ЮридическийАдрес);
	Струк.Вставить("ФактическийАдресОрганизации",Струк2.ФактическийАдрес);
	
	
	Струк.Вставить("СуммаВМесяц",Контрагент.ОтгрузкаНеМенее);
	//Струк.Вставить("Территория",ДиалогиСПользователямиСервер.ПолучитьТерриториюПартнераСтр(Контрагент));
	Струк.Вставить("Территория", Контрагент.ОсновнойРегион.Наименование);
	Струк.Вставить("Преамбула",?(Найти(Строка(Организация), "Кукушкина"),
"в лице  Кукушкиной Ольги Валентиновны, действующей на основании Свидетельства о государственной регистрации серия 78 № 003446763 от 22.12.2004г",
"в лице  Генерального директора Кукушкиной Ольги Валентиновны, действующего на основании Устава"));

	Струк.Вставить("ПечататьБезЗащиты",Договор.ПечататьБезЗащиты);

	Струк.Вставить("ЭлПочтаКонтрагента",Струк.ЭлПочта);
	Струк.Вставить("ЭлПочтаОрганизации",Струк2.ЭлПочта);
   Возврат Струк;
КонецФункции	
