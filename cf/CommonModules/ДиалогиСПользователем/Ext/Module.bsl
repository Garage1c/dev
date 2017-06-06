﻿
// СПИСКИ ДОКОВ

&НаСервере
Функция ПолучитьСуммуВыделеныхСтрок(МассивВыделенныхСсылок, ПутьКТаблице, ИмяПоляСуммы = "Сумма") Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ 	СУММА(" + ИмяПоляСуммы + ") КАК Сумма 
	|ИЗ 		" + ПутьКТаблице + "
	|ГДЕ		Ссылка В(&МассивСсылок)
	|");
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивВыделенныхСсылок);
	Выполнение = Запрос.Выполнить();
	
	Если Выполнение.Пустой() Тогда
		
		Возврат 0;
		
	Иначе
		
		Выборка = Выполнение.Выбрать();
		Если Выборка.Следующий() Тогда
			
			Возврат Выборка.Сумма;
			
		Иначе
			
			Возврат 0;
			
		КонецЕсли;
	КонецЕсли;
	
КонецФункции


// HTML

&НаКлиенте
Функция СформироватьТекстHTML(ТекстHTML) Экспорт

	Возврат "<HTML><HEAD>
	|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
	|<META name=GENERATOR content=""MSHTML 8.00.7600.16588""></HEAD>
	|<BODY>
	|" + ТекстHTML + "
	|</BODY>";
	
КонецФункции
&НаСервере
Функция СформироватьТекстHTML(ТекстHTML) Экспорт

	Возврат "<HTML><HEAD>
	|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
	|<META name=GENERATOR content=""MSHTML 8.00.7600.16588""></HEAD>
	|<BODY>
	|" + ТекстHTML + "
	|</BODY>";
	
КонецФункции

// ФОРМАТИРОВАННЫЙ ДОКУМЕНТ

&НаСервере
Функция ПолучитьТелоHTML(ТекстHTML)
	
	Возврат КонвертацияТипов.ПолучитьТекстHTMLВнутри_Body(ТекстHTML);
	
КонецФункции
&НаКлиенте
Функция ПолучитьТелоHTML(ТекстHTML) Экспорт
	
	Возврат КонвертацияТипов.ПолучитьТекстHTMLВнутри_Body(ТекстHTML);
	
КонецФункции
&НаСервере
Функция ЗаписатьОтформатированныйДокументНаСервере(
						Объект,
						ИмяСправочникаНастроек,
						ОтформатированныйДокумент,
						ИмяРеквизитаТекстаHTML,
						Суффикс = "i"
						) Экспорт
						
	// Подготавливает к загрузки приложения 
	// и устанавливает реквизит в объектк
	//
	// функция нужно вызывать перед записью на сервере
	
	
	Перем ТекстHTML;
	Перем ВложенияHTML;
	
	// Проверим настройки
	
	Настройки = КэшируемыеФункции.ПолучитьНастройкиВложений(ИмяСправочникаНастроек);
	ПутьКHTMLВложениям 	= Настройки.ПутьHTML;
	ПутьККартинкам 		= Настройки.ПутьДляСервера;
	ИмяРегистра 		= Настройки.ИмяХранимогоРегистра;
	
	Если 	Не ЗначениеЗаполнено(ПутьКHTMLВложениям) Или
			Не ЗначениеЗаполнено(ПутьККартинкам) Или
			Не ЗначениеЗаполнено(ИмяРегистра) Тогда
			
		ОбщиеФункции.СообщитьТекст("не задана настройка вложений для справочника,
						|Проверте настройки: Справочник -> НастройкиПутейДляВложений");
		Возврат Ложь;				
	КонецЕсли;
	
	// Получим HTML	
	
	ОтформатированныйДокумент.ПолучитьHTML(ТекстHTML, ВложенияHTML);
	ТекстHTML = ПолучитьТелоHTML(ТекстHTML);
	
	// Определим ссылку
	
	СсылкаНазначена = Ложь;
	Объект.ДополнительныеСвойства.Свойство("СсылкаНазначена", СсылкаНазначена);
	
	Если Объект.ЭтоНовый() Тогда
		
		Если СсылкаНазначена <> Истина Тогда
			
			// Определим менеджер объекта
			
			МетаОб = Объект.Метаданные();
			Если Метаданные.Справочники.Содержит(МетаОб) Тогда
				
				Менеджер = Справочники[МетаОб.Имя];
				
			ИначеЕсли Метаданные.БизнесПроцессы.Содержит(МетаОб) Тогда
				
				Менеджер = БизнесПроцессы[МетаОб.Имя];
				
			Иначе
				
				ОбщиеФункции.СообщитьТекст("нет обработчика для данного вида объекта
								|для настройки обработчика отредактируйте процедуру 
								|Общие модули -> Диалоги с пользователем -> Подготовить отформатированный документ на сервере");
				Возврат Ложь;				
			КонецЕсли;

			
			Объект.УстановитьСсылкуНового(Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор));
			Объект.ДополнительныеСвойства.Вставить("СсылкаНазначена", Истина);
			
		КонецЕсли;
		
		Ссылка = Объект.ПолучитьСсылкуНового();
		
	Иначе
		
		Ссылка = Объект.Ссылка;
		
	КонецЕсли;
	
	// получим существующие вложения
	
	Запрос = Новый Запрос("ВЫБРАТЬ Имя,ИмяВДокументе ИЗ РегистрСведений." + ИмяРегистра + " ГДЕ Объект = &Ссылка И ПОДСТРОКА(ИмяВДокументе, 1, 1) = """ + Суффикс + """");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	ТаблицаСуществующих = Запрос.Выполнить().Выгрузить();
	ТаблицаСуществующих.Колонки.Добавить("Отработал", Новый ОписаниеТипов("Булево"));
	ТаблицаСуществующих.Индексы.Добавить("ИмяВДокументе");
	
	// Загрузим вложения
	
	Для Каждого Вложение Из ВложенияHTML Цикл
		
		Картинка 		= Вложение.Значение;
		ФормКартинки 	= Картинка.Формат();
		
		Если ФормКартинки = ФорматКартинки.НеизвестныйФормат Тогда
			ОбщиеФункции.СообщитьТекст("не известный формат картинки! " + Вложение.Ключ);
			Возврат Ложь;
		КонецЕсли;
		
		ФорматСтр 	= Строка(ФормКартинки);
		НовоеИмя 	= Суффикс + СтрЗаменить(Строка(Новый УникальныйИдентификатор()),"-","_");	
		
		// Поищем, может оно уже раньше было записано
		СтрокаСуществующего = ТаблицаСуществующих.Найти(Вложение.Ключ, "ИмяВДокументе");
		Если СтрокаСуществующего <> Неопределено Тогда
			
			СтрокаСуществующего.Отработал = Истина;
			НовоеИмя = СтрокаСуществующего.Имя;
			
		КонецЕсли;
		
		// Преобразуем имя вложения
		
		ТекстHTML = СтрЗаменить(ТекстHTML, Вложение.Ключ, ПутьКHTMLВложениям + НовоеИмя + "." + ФорматСтр);
		
		// Запишем на диск
		
		Попытка
			Картинка.Записать(ПутьККартинкам + НовоеИмя + "." + ФорматСтр);
		Исключение
			опОшибки = ОписаниеОшибки();
			ОбщиеФункции.СообщитьТекст("Ошибка при записи картинки в веб ресурс: " + НовоеИмя + "." + ФорматСтр + "
					|" + опОшибки);
			Возврат Ложь;
		КонецПопытки;
			
		// Запишем в базу
		
		МенЗаписи = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
		
		МенЗаписи.Объект 		= Ссылка;
		МенЗаписи.Имя 			= НовоеИмя;
		МенЗаписи.ИмяВДокументе = Суффикс + Вложение.Ключ;
		МенЗаписи.Вложение 		= Новый ХранилищеЗначения(Картинка.ПолучитьДвоичныеДанные());
		МенЗаписи.Формат		= ФорматСтр;
		
		Попытка
			МенЗаписи.Записать();
		Исключение
			опОшибки 	= ОписаниеОшибки();
			ОбщиеФункции.СообщитьТекст("Ошибка при записи картинки в базу: " + НовоеИмя + "
					|" + опОшибки);
			Возврат Ложь;
		КонецПопытки;

	КонецЦикла;
	
	// Удалим те записи которых уже нет
	
	СтрокиУдаляемых = ТаблицаСуществующих.НайтиСтроки(Новый Структура("Отработал", Ложь));	
	Для Каждого Строка Из СтрокиУдаляемых Цикл
		
		// Удалим с диска
		
		Попытка
			УдалитьФайлы(ПутьККартинкам + Строка.Имя);
		Исключение
			// Тут не будем вызывать исключение, если не нашел то и х. сним
		КонецПопытки;

		// Удалим с базы
		
		МенЗаписи = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
		
		МенЗаписи.Объект 	= Ссылка;
		МенЗаписи.Имя 		= Строка.Имя;
		
		Попытка
			МенЗаписи.Удалить();
		Исключение
			ОбщиеФункции.СообщитьТекст("Ошибка при удалении картинки из базы: " + Строка.Имя + "
					|" + опОшибки);
			Возврат Ложь;
		КонецПопытки;

	КонецЦикла;
	
	Объект[ИмяРеквизитаТекстаHTML] = ТекстHTML;
	
	Возврат Истина;
	
КонецФункции
&НаСервере
Функция ЗагрузитьДанныеВФорматированныйДокумент(
							Объект,
							ОтформатированныйДокумент,
							ИмяСправочникаНастроек,
							ИмяРеквизитаТекстаHTML
							) Экспорт
							
	// Проверим настройки
							
	Настройки = КэшируемыеФункции.ПолучитьНастройкиВложений(ИмяСправочникаНастроек);
	ИмяРегистра 		= Настройки.ИмяХранимогоРегистра;
	ПутьКHTMLВложениям 	= Настройки.ПутьHTML;
	
	Если	Не ЗначениеЗаполнено(ПутьКHTMLВложениям) Или
			Не ЗначениеЗаполнено(ИмяРегистра) Тогда

		
		ОбщиеФункции.СообщитьТекст("не задана настройка вложений для справочника,
						|Проверте настройки: Справочник -> НастройкиПутейДляВложений");
		Возврат Ложь;				
	КонецЕсли;
	
	ТекстHTML = Объект[ИмяРеквизитаТекстаHTML];
	
	СтруктураВложений = Новый Структура;
	
	// Запросим вложения
	
	Запрос = Новый Запрос("ВЫБРАТЬ Имя, ИмяВДокументе, Формат, Вложение ИЗ РегистрСведений." + ИмяРегистра + " ГДЕ Объект = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстHTML = СтрЗаменить(ТекстHTML, ПутьКHTMLВложениям + Выборка.Имя + "." + Выборка.Формат, Выборка.ИмяВДокументе);
		СтруктураВложений.Вставить(Выборка.ИмяВДокументе, Новый Картинка(Выборка.Вложение.Получить()));
		
	КонецЦикла;
	
	// Установим вложения
	ОтформатированныйДокумент.УстановитьHTML(ТекстHTML, СтруктураВложений);

КонецФункции

// ЗАПОЛНЕНИЕ ФОРМ

&НаКлиенте
Процедура ЗаполнитьРучСкидку(Таблица, СтруктураКолонокТовары = Неопределено, ВыражениеФильтра = "Истина") Экспорт
	
	ПроцентСкидки = 0;
	ВвестиЧисло(ПроцентСкидки, "Процент ручной скидки:", 5, 2);

	Для Каждого Строка Из Таблица Цикл
		Если Вычислить(ВыражениеФильтра) Тогда
		
			Строка.ПроцентРучнойСкидки = ПроцентСкидки;
			
			Если СтруктураКолонокТовары <> Неопределено Тогда
										
				ФункцииФормДокументов.ПроцентРучнойСкидкиПриИзменении(
						Таблица, 
						СтруктураКолонокТовары, 
						Строка);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры
&НаКлиенте
Процедура ЗаполнитьСтавкуНДС(Таблица, СтруктураКолонокТовары = Неопределено, ВыражениеФильтра = "Истина") Экспорт	
	ВыбСтавка = ОткрытьФорму("Перечисление.СтавкиНДС.ФормаВыбора",,,,,,Новый ОписаниеОповещения("ОбработатьВыборСтавкиНДС",ДиалогиСПользователем, Новый Структура("Таблица, СтруктураКолонокТовары, ВыражениеФильтра",Таблица, СтруктураКолонокТовары, ВыражениеФильтра)));
КонецПроцедуры

Процедура ОбработатьВыборСтавкиНДС(Результат, Параметры)   Экспорт 
		Если Результат <> Неопределено Тогда
		Для Каждого Строка Из Параметры.Таблица Цикл
			Если Вычислить(Параметры.ВыражениеФильтра) Тогда
				
				Строка.СтавкаНДС = Результат;
			
				Если Параметры.СтруктураКолонокТовары <> Неопределено Тогда
					
					ФункцииФормДокументов.СтавкаНДСПриИзменении(
							Параметры.Таблица, 
							Параметры.СтруктураКолонокТовары, 
							Строка);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры
///////Возможно не используется
&НаКлиенте
Процедура ЗаполнитьРазмещение(Таблица, СтруктураКолонокТовары = Неопределено) Экспорт
	ВыбСклад = ОткрытьФорму("Справочник.Склады.ФормаВыбора",,,,,,Новый ОписаниеОповещения("ОбработкаЗаполненияРазмещения", ДиалогиСПользователем, Новый Структура("Таблица, СтруктураКолонокТовары", Таблица, СтруктураКолонокТовары)));
КонецПроцедуры

Процедура ОбработкаЗаполненияРазмещения(Результат, Параметры) Экспорт
		Если Результат <> Неопределено Тогда
		Для Каждого Строка Из Параметры.Таблица Цикл
			
			Строка.Размещение = Результат;
			
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры
//////Конец

#Область Размещение

Процедура ОчиститьРазмещениеВСтроке(текДанные, РазмещениеТоваров, СтандартнаяОбработка) Экспорт
	
	//Если текДанные.КоличествоМинимум Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Строки 		= РазмещениеТоваров.НайтиСтроки(Новый Структура("Номенклатура", ТекДанные.Номенклатура));
		КолСтрок 	= Строки.Количество();
		Для Ном = 1 По КолСтрок Цикл Строка = Строки[КолСтрок - Ном]; Если Строка.КоличествоМинимум Тогда Строка.Количество = Строка.КоличествоМинимум Иначе РазмещениеТоваров.Удалить(Строка); КонецЕсли; КонецЦикла; 
		
		
		текДанные.Размещение = ПолучитьПредставлениеРазмещения(текДанные.Количество, РазмещениеТоваров.НайтиСтроки(Новый Структура("Номенклатура", текДанные.Номенклатура)),, текДанные.КоличествоОтгружено); //КонецЕсли;
	
	
	//// Удаляет из строк все размещение которое возможно (кроме отгруженных и собранных)
	//
	//Строки 		= РазмещениеТоваров.НайтиСтроки(Новый Структура("Номенклатура", ТекДанные.Номенклатура));
	//КолСтрок 	= Строки.Количество();
	//Количество 	= 0;
	//
	//Для Ном = 1 По КолСтрок Цикл 
	//	
	//	Строка 				= Строки[КолСтрок - Ном];
	//	Количество 			= Количество + Строка.КоличествоМинимум;
	//	Строка.Количество 	= Строка.КоличествоМинимум; 
	//	
	//	Если Не Строка.Количество Тогда РазмещениеТоваров.Удалить(Строка); КонецЕсли; КонецЦикла;
	//
	//Если Количество Тогда
	//	СтандартнаяОбработка = Ложь;
	//	Строка.Размещение = ПолучитьПредставлениеРазмещения(Количество, РазмещениеТоваров.НайтиСтроки(Новый Структура("Номенклатура", ТекДанные.Номенклатура)),, текДанные.КоличествоОтгружено); КонецЕсли;
	
КонецПроцедуры
Функция ПолучитьПредставлениеРазмещения_Ст(Знач ВсегоКол, СтрокиРазмещения, СимволРазделения = ";", Знач КолОтгружено = 0, КоличествоСДублями=Неопределено, КолОтменено=0, ВПутиМежСкладами = Неопределено) Экспорт
	
	// Формируем строковое представление размещения
	
	//ВозможностьДублейСтрок. Получаем общее количество с дублями
	Если Не КоличествоСДублями=Неопределено Тогда
		ВсегоКол=КоличествоСДублями;
	КонецЕсли;	
	
	//Если СимволРазделения = Неопределено Тогда СимволРазделения = "" КонецЕсли;
	
	стр = ""; 
	ЕстьВПутиМежСкладами = ВПутиМежСкладами = Неопределено;
	Если ЕстьВПутиМежСкладами Тогда ВПутиМежСкладами = 0 КонецЕсли;
	
	ВОчереди = 0; ВПути = 0; ТипЧисло = Тип("Число"); ТипЗаказПоставщику = Тип("ДокументСсылка.ЗаказПоставщику");
	Для Каждого СТрокаРазм Из СтрокиРазмещения Цикл 
			
		ВсегоКол = ВсегоКол - СТрокаРазм.Количество;
		стр = стр + ?(стр = "","",СимволРазделения + " "); 
			
		Если ТипЗнч(СтрокаРазм.Размещение) = ТипЧисло Тогда 				ВОчереди 			= ВОчереди + СТрокаРазм.Количество;
		ИначеЕсли ТипЗнч(СтрокаРазм.Размещение) = ТипЗаказПоставщику Тогда	ВПути 				= ВПути + СТрокаРазм.Количество;
			
		//временно закоментил, а то работать как то надо, а творца не дождаться	
		ИначеЕсли ЕстьВПутиМежСкладами И СТрокаРазм.КоличествоВПути Тогда	ВПутиМежСкладами 	= ВПутиМежСкладами + СТрокаРазм.КоличествоВПути;
		ИначеЕсли ЕстьВПутиМежСкладами  Тогда	ВПутиМежСкладами 	= ВПутиМежСкладами ;
		//	
			
		ИначеЕсли СТрокаРазм.Количество Тогда								
			стр = стр + ?(СТрокаРазм.Размещение = Неопределено, 
				Строка(СТрокаРазм.Количество) + "?", Строка(СТрокаРазм.Размещение) + " ∑ " + СТрокаРазм.Количество); КонецЕсли; КонецЦикла;
	
	Если ВОчереди Тогда стр = стр + ?(стр = "","",СимволРазделения + " ") + "в очереди ∑ " + ВОчереди; КонецЕсли; 
	Если ВПути Тогда стр = стр + ?(стр = "","",СимволРазделения + " ") + "заказано " + ВПути; КонецЕсли; 
	Если ВПутиМежСкладами Тогда стр = стр + ?(стр = "","",СимволРазделения + " ") + "пер. " + ВПутиМежСкладами; КонецЕсли; 
		
	// Вернем
	
	Если Не КолОтгружено И Не ВсегоКол И СтрокиРазмещения.Количество() = 1 Тогда // если одна запись занчит все количество размещается и нет смысла выводить числа
			Возврат ?(ТипЗнч(СТрокаРазм.Размещение) = ТипЧисло, "в очереди", ?(ТипЗнч(СТрокаРазм.Размещение) = ТипЗаказПоставщику, "заказано", Строка(СТрокаРазм.Размещение)));
	Иначе	
		
		//Стр = ?(стр = "", "", ?(ВсегоКол - КолОтгружено > 0, Строка(ВсегоКол - КолОтгружено) + "?" + ?(стр = "","",СимволРазделения + " "), "") + стр);
		//Стр = ?(стр = "", "", ?(ВсегоКол > 0, Строка(ВсегоКол) + "?" + ?(стр = "","",СимволРазделения + " "), "") + стр);
		
		ВсегоКол = ВсегоКол - КолОтгружено - КолОтменено - ВПутиМежСкладами;
		//Стр = ?(ВсегоКол - КолОтгружено > 0, Строка(ВсегоКол) + "?" + ?(стр = "","",СимволРазделения + " "), "") + Стр;
		Стр = ?(ВсегоКол > 0, Строка(ВсегоКол) + "?" + ?(стр = "","",СимволРазделения + " "), "") + Стр;
		Если КолОтгружено Тогда Стр = Стр + " отгр. " + Строка(КолОтгружено); КонецЕсли;
		
	Если КолОтменено Тогда
		Стр=Стр+" отм. "+КолОтменено;
	КонецЕсли;	
			
	// Проверим все остальное
		
	Если ВсегоКол < 0 Тогда стр = "перебор " + Строка(ВсегоКол * -1) + "!!  " + стр; КонецЕсли;	
	Возврат Стр ; КонецЕсли;
	
КонецФункции
Функция СтрокаКлИлиСерв(Объект, РеквСервера)
	
	#Если Сервер Тогда
		Возврат Строка(Объект[РеквСервера]);
	#Иначе
		Возврат Строка(Объект);
	#КонецЕсли
	
КонецФункции
Функция ПолучитьПредставлениеРазмещения(Знач ВсегоКол, СтрокиРазмещения, СимволРазделения = "; ", Знач КолОтгружено = 0, КоличествоСДублями=Неопределено, КолОтменено=0, ВПутиМежСкладами = Неопределено) Экспорт
	
	// Формируем строковое представление размещения
	
	Если КоличествоСДублями <> Неопределено Тогда ВсегоКол = КоличествоСДублями КонецЕсли;	
	
	Строки = Новый Массив;
	Для Каждого СТрокаРазм Из СтрокиРазмещения Цикл
		Если СТрокаРазм.Количество Тогда ВсегоКол = ВсегоКол - СТрокаРазм.Количество;
		
			Если ТипЗнч(СТрокаРазм.Размещение) = Тип("СправочникСсылка.Склады") Тогда
				Строки.Добавить(СтрокаКлИлиСерв(СТрокаРазм.Размещение, "Код") + ":" + СТрокаРазм.Количество);
			ИначеЕсли ТипЗнч(СТрокаРазм.Размещение) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
				Строки.Добавить("{" + СтрокаКлИлиСерв(СТрокаРазм.Размещение, "Номер") + "}:" + СТрокаРазм.Количество);
			ИначеЕсли ТипЗнч(СТрокаРазм.Размещение) = Тип("Число") Тогда
				Строки.Добавить("оч." + СТрокаРазм.Количество);
			Иначе
				Строки.Добавить(Строка(СТрокаРазм.Размещение) + СТрокаРазм.Количество); КонецЕсли; КонецЕсли; КонецЦикла;
			
	ВсегоКол = ВсегоКол - КолОтгружено - КолОтменено;
	
	Если КолОтменено Тогда Строки.Вставить(0, "отмен." + КолОтменено) КонецЕсли;
	Если КолОтгружено Тогда Строки.Вставить(0, "отгр." + КолОтгружено) КонецЕсли;
	
	Если ВсегоКол > 0 Тогда Строки.Вставить(0, "? " + ВсегоКол) КонецЕсли;
	Если ВсегоКол < 0 Тогда Строки.Вставить(0, "перебор " + Строка(ВсегоКол * -1) + "!!  ") КонецЕсли;
	
	Возврат СтрСоединить(Строки, СимволРазделения);
	
КонецФункции


Функция ПолучитьКоличествоСДублями(Таб,Номенклатура) Экспорт
	Струк = Новый Структура("Номенклатура",Номенклатура);
	СтрокиДубли = Таб.НайтиСтроки(Струк);
	КоличествоВместеСДублями=0;
	Для Каждого СтрокаДубль Из СтрокиДубли Цикл
		КоличествоВместеСДублями=КоличествоВместеСДублями+СтрокаДубль.Количество;
	КонецЦикла;	
	Возврат КоличествоВместеСДублями;
КонецФункции	

&НаКлиенте
Процедура НачалоВыбораРазмещения(Форма, Элемент, Заказ, Склад, СтандартнаяОбработка, ИмяТаблицыТовары = "Товары") Экспорт
	
	СтандартнаяОбработка = Ложь;

	ТекДанные = Элемент.Родитель.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		
		// Сконвертируем размещение товаров
		
		РазмещениеТоваров = ПолучитьмассивРазмещенийТоваров(Форма.РазмещениеТоваров, ТекДанные.Номенклатура);
		//Для Каждого Строка Из Форма.РазмещениеТоваров Цикл Если ТекДанные.Номенклатура = Строка.Номенклатура Тогда РазмещениеТоваров.Добавить(Новый Структура("Номенклатура, Размещение, Количество", Строка.Номенклатура, Строка.Размещение, Строка.Количество)) КонецЕсли; КонецЦикла;
		
		// Откроем форму
		
		
		//ВозможностьДублейСтрок. Передаем в диалог количество с учетом дублей
		
		//ОткрытьФорму("ОбщаяФорма.ДиалогРазмещенияОдногоТовара", 
		//	Новый Структура("Заказ, Склад, Номенклатура, Количество, КоличествоМинимум, текРезервы", Заказ, Склад, ТекДанные.Номенклатура, ТекДанные.Количество - ТекДанные.КоличествоОтгружено, ТекДанные.КоличествоМинимум - ТекДанные.КоличествоОтгружено, РазмещениеТоваров), 
		//	Форма,,,,
		//	Новый ОписаниеОповещения("ПользовательВыбратьРазмещение", ДиалогиСПользователем, 
		//		Новый Структура("Индекс, Форма, ИмяТаблицыТовары", Форма.Товары.Индекс(ТекДанные), Форма, ИмяТаблицыТовары))); КонецЕсли;
		ОткрытьФорму("ОбщаяФорма.ДиалогРазмещенияОдногоТовара", 
			Новый Структура("Заказ, Склад, Номенклатура, Количество, КоличествоМинимум, текРезервы", Заказ, Склад, ТекДанные.Номенклатура, ПолучитьКоличествоСДублями(Форма.Товары,ТекДанные.Номенклатура) - ТекДанные.КоличествоОтгружено, ТекДанные.КоличествоМинимум - ТекДанные.КоличествоОтгружено, РазмещениеТоваров), 
			Форма,,,,
			Новый ОписаниеОповещения("ПользовательВыбратьРазмещение", ДиалогиСПользователем, 
				Новый Структура("Индекс, Форма, ИмяТаблицыТовары", Форма.Товары.Индекс(ТекДанные), Форма, ИмяТаблицыТовары))); КонецЕсли;
			
			
			
КонецПроцедуры
&НаКлиенте
Функция ПолучитьмассивРазмещенийТоваров(Таблица, Номенклатура) Экспорт
	
	РазмещениеТоваров = Новый Массив;
	Для Каждого Строка Из Таблица Цикл 
		Если Номенклатура = Строка.Номенклатура Тогда 
			РазмещениеТоваров.Добавить(Новый Структура(
						"Номенклатура, Размещение, Количество, КоличествоМинимум", 
						Строка.Номенклатура, Строка.Размещение, Строка.Количество, Строка.КоличествоМинимум)) КонецЕсли; КонецЦикла;
				
	Возврат РазмещениеТоваров;
				
КонецФункции



&НаКлиенте
Процедура ПользовательВыбратьРазмещение(СтрокиРазмещения, ДополнительныеПараметры) Экспорт
	
	Если СтрокиРазмещения <> Неопределено Тогда
		
		ДополнительныеПараметры.Форма.Модифицированность = Истина;
		ТекДанные 		= ДополнительныеПараметры.Форма[ДополнительныеПараметры.ИмяТаблицыТовары][ДополнительныеПараметры.Индекс];
		ТекНомерОчереди = 1;
		ТипЧисло		= Тип("Число");
		
		// Удалим все строки связанные с номенклатурой
		
		РазмещениеТоваров = ДополнительныеПараметры.Форма.РазмещениеТоваров;
		Всего = РазмещениеТоваров.Количество(); Инд = Всего;
		Для Ном = 1 По Всего Цикл Инд = Инд - 1; 
			
			Строка = РазмещениеТоваров[Инд]; 
			Если Строка.Номенклатура = ТекДанные.Номенклатура Тогда 
				Если ТипЗнч(Строка.Размещение) = ТипЧисло Тогда ТекНомерОчереди = Строка.Размещение КонецЕсли;
				РазмещениеТоваров.Удалить(Инд) КонецЕсли; КонецЦикла;
		
		// Добавим строки от того что пришло
		
		Для Каждого Строка Из СтрокиРазмещения Цикл 
			Если Строка.Количество Тогда
				НовСтрока = РазмещениеТоваров.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
				НовСтрока.Номенклатура = ТекДанные.Номенклатура; 
				
				Если ТипЗнч(Строка.Размещение) = ТипЧисло Тогда НовСтрока.Размещение = ТекНомерОчереди КонецЕсли; КонецЕсли; КонецЦикла; 
		
		// Сформируем представление
		
		
		//ВозможностьДублейСтрок. добавлен 5-й параметр
		//ТекДанные.Размещение = ПолучитьПредставлениеРазмещения(ТекДанные.Количество, ПолучитьмассивРазмещенийТоваров(РазмещениеТоваров, ТекДанные.Номенклатура),,ТекДанные.КоличествоОтгружено); КонецЕсли; //СтрокиРазмещения); КонецЕсли;
		ТекДанные.Размещение = ПолучитьПредставлениеРазмещения(ТекДанные.Количество, ПолучитьмассивРазмещенийТоваров(РазмещениеТоваров, ТекДанные.Номенклатура),,ТекДанные.КоличествоОтгружено, ПолучитьКоличествоСДублями(ДополнительныеПараметры.Форма[ДополнительныеПараметры.ИмяТаблицыТовары],ТекДанные.Номенклатура));
	КонецЕсли; 	
КонецПроцедуры


		
&НаКлиенте
Процедура ПроверитьРазмещенияПередЗаписью(Объект, Товары, РазмещениеТоваров, Отказ) Экспорт
	
	// Проверяет чтобы количество в товарах была не меньше чем сумма количеств в размещении товаров или чтобы ее там вобще не было
	
	Инд = -1;
	Для Каждого Строка Из Товары Цикл Инд = Инд + 1;
		
		Если КонвертацияТипов.ПолучитьСуммуКолонкиПоУсловию(РазмещениеТоваров, "Количество", Новый Структура("Номенклатура", Строка.Номенклатура)) > Строка.Количество Тогда
			Отказ = Истина;
			ОбщиеФункции.СообщитьТекст("Размещено больше чем заказано", "Товары[" + Формат(Инд, "ЧГ=") + "].Размещение", Объект); КонецЕсли; КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьНеактуальноеРазмещение(Товары, РазмещениеТоваров) Экспорт
	
	// Удалим из размещения строки которых не будет
	
	КолСтрок = РазмещениеТоваров.Количество(); Инд = КолСтрок;
	Для Ном = 1 По КолСтрок Цикл Инд = Инд - 1; Если Не Товары.НайтиСтроки(Новый Структура("Номенклатура", РазмещениеТоваров[Инд].Номенклатура)).Количество() Тогда РазмещениеТоваров.Удалить(Инд); КонецЕсли; КонецЦикла;
	
КонецПроцедуры
//Процедура ПроставитьПредставленияРазмещений(Товары, РазмещениеТоваров, ЕстьКоличествоОтгружено) Экспорт
//	
//	ОчиститьНеактуальноеРазмещение(Товары, РазмещениеТоваров);
//		
//	// Проставим представления
//	
//	Для Каждого Строка Из Товары Цикл Строка.Размещение = ПолучитьПредставлениеРазмещения(Строка.Количество, РазмещениеТоваров.НайтиСтроки(Новый Структура("Номенклатура", Строка.Номенклатура)),,?(ЕстьКоличествоОтгружено, Строка.КоличествоОтгружено,0)) КонецЦикла;
//	
//КонецПроцедуры

#КонецОбласти

// ИЗМЕНЕНИЕ ОРГАНИЗАЦИИ И КОНТРАГЕНТА (СВЯЗЬ)

 &НаКлиенте
Функция ПроверитьНаСоответствиеОсновнойОрганизации(Контрагент, Организация, ЭтоОрганизацияПоУмолчанию) Экспорт
	
	// если контрагент не заполнен, организацию можно менять сколько хочешь и наборот
	Если Контрагент.Пустая() ИЛИ Организация.Пустая() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ЭтоОрганизацияПоУмолчанию = Неопределено Тогда
		
		ПоказатьПредупреждение(,"Контрагент не работает с """ + Организация + """",,"Сообщение!");
		Возврат Ложь;
		
	ИначеЕсли ЭтоОрганизацияПоУмолчанию = Ложь Тогда
		
		Если Вопрос("Основная организация контрагента отличается от организации в документе,
				|Поменять организацию?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

 &НаКлиенте
Функция ПроверитьНаСоответствиеПартнеру(Партнер, Контрагент, ЭтоКонтрагентПоУмолчанию) Экспорт
	
	// если партнер не заполнен, контрагента можно менять сколько хочешь
	Если Партнер.Пустая() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ЭтоКонтрагентПоУмолчанию = Неопределено Тогда
		
		ПоказатьПредупреждение(,"Контрагент не относится к партнеру """ + Партнер + """",,"Сообщение!");
		Возврат Ложь;
		
	ИначеЕсли ЭтоКонтрагентПоУмолчанию = Ложь Тогда
		
		Если Вопрос("Контрагент не является основным для партнера,
				|Поменять контрагента?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// СБОРКА

&НаСервере
Функция ПолучитьСписокСборщиков(Дата = Неопределено) Экспорт
	
	Список = Новый СписокЗначений;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ Пользователь.ФизЛицо ФизЛицо Из РегистрСведений.РолиПользователей ГДЕ Роль = &РольСборщик Упорядочить по Пользователь.ФизЛицо.Наименование");
	Запрос.УстановитьПараметр("РольСборщик", Справочники.Роли.Сборщик);
	
	ФизЛица = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизЛицо");
	СПарсекаСчитал = Истина;
	
	Попытка		ТаблВходВыход = Parsec.ПолучитьТаблицуВходовВыходовЗаДеньПоСотрудникам(?(Дата = Неопределено, ТекущаяДата(), Дата), ФизЛица, Истина);
	Исключение
		стрОшибки = ОписаниеОшибки();
		СПарсекаСчитал = Ложь;
		ОбщиеФункции.СообщитьТекст("Ошибка при получении времени посещений
												|" + ОписаниеОшибки()); КонецПопытки;
	Если СПарсекаСчитал Тогда
		Для Каждого ФизЛицо Из ФизЛица Цикл
			СтрокаПришел = ТаблВходВыход.Найти(ФизЛицо, "ФизЛицо");
			Список.Добавить(ФизЛицо, Лев(ФизЛицо, СтрНайти(ФизЛицо, " ")) + ?(СтрокаПришел = Неопределено, " [нет на работе]", " " + Формат(СтрокаПришел.Вход,"ДФ=HH:mm")), СтрокаПришел <> Неопределено); КонецЦикла;
	Иначе
		Список.ЗагрузитьЗначения(ФизЛица); КонецЕсли;
	
	Возврат Список;
	
КонецФункции


#Область ОТКРЫТИЕ // ВОРДОВСКИХ ФАЙЛОВ

// Функция преобразует Windows имя файла в URL OpenOffice                      
&НаКлиенте
Функция ПреобразоватьВURL(ИмяФайла)
	Возврат "file:///" + СтрЗаменить(ИмяФайла, "\", "/"); 	
КонецФункции

&НаКлиенте
Функция ВычислитьНаСервере(Код1с, Организация = Неопределено, Партнер = Неопределено, Контрагент = Неопределено, ИндексДоговора = 0)
	
	Возврат ДиалогиСПользователямиСервер.ВычислитьНаСервере(Код1с, Организация, Партнер, Контрагент, ИндексДоговора);
	
КонецФункции
&НаКлиенте
Функция ВычислитьКодЗамены(Код1с, Организация, Партнер, Контрагент, ИндексДоговора = 0, СтруктураПеременных)
	
	Попытка
		Результат = Вычислить(Код1с);
	Исключение
		стрОшибки = ОписаниеОшибки();
		ОбщиеФункции.СообщитьТекст("Ошибка при вычислении выражения на клиенте:
										|" + код1с + "
										|" + стрОшибки); 
		Возврат "!Ошибка в вычислении кода!"; КонецПопытки;
									
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ВыполнитьЗаменуВордДокумента_OOoWriter(ИмяФайла, СтрукЗамен = Неопределено, СтруктураПеременных = Неопределено)
	
	СоответствиеЗамен=СтрукЗамен.Соотв;
	СоответствиеЗаменВК=СтрукЗамен.СоотвВК;
	СоответствиеЗаменНК=СтрукЗамен.СоотвНК;
	
	// Открыть OpenOffice 
	
	Попытка
		
		ServiceManager 	= Новый COMОбъект("com.sun.star.ServiceManager");
		Desktop 		= ServiceManager.createInstance("com.sun.star.frame.Desktop");
		
	Исключение
		
		ПоказатьПредупреждение(,"OpenOffice не установлен, или нет возможности получить доступ",,"Сообщение!");
		Возврат Ложь; КонецПопытки;
	
	Scr = Новый COMОбъект("MSScriptControl.ScriptControl");
	Scr.Language="javascript";
	Scr.Eval("Args=new Array()");
	
	Args = Scr.Eval("Args"); 
	Scr.AddObject("ServiceManager", ServiceManager);
	
	// Откроем шаблон
	
	ТекстовыйПроцессор = Desktop.LoadComponentFromURL(ПреобразоватьВURL(ИмяФайла), "_blank", 0, Args); 
	
	// Заменяем ключевые поля на нужные значения
	
	Если СоответствиеЗамен <> Неопределено Тогда
	
		Replace = ТекстовыйПроцессор.CreateReplaceDescriptor();
		Для Каждого Замена Из СоответствиеЗамен Цикл 
			Replace.SearchString  = Замена.Ключ; 
			Replace.ReplaceString = Строка(ВычислитьКодЗамены(Замена.Значение, СтруктураПеременных.Организация, СтруктураПеременных.Партнер, СтруктураПеременных.Контрагент, , СтруктураПеременных));
			ТекстовыйПроцессор.ReplaceAll(Replace); КонецЦикла; КонецЕсли;
	
	ТекстовыйПроцессор.getCurrentController().getFrame().getContainerWindow().setFocus();
	
	//ПоказатьОповещениеПользователя("Открыт документ, сверните 1с чтобы увидеть",,ИмяФайла);
	
	Возврат ТекстовыйПроцессор;
	
КонецФункции

&НаКлиенте
Функция ВыполнитьЗаменуВордДокумента_Word(ИмяФайла, СтрукЗамен = Неопределено, СтруктураПеременных = Неопределено)
	
	СоответствиеЗамен=СтрукЗамен.Соотв;
	СоответствиеЗаменВК=СтрукЗамен.СоотвВК;
	СоответствиеЗаменНК=СтрукЗамен.СоотвНК;
	
	// Открываем MS Office Word
		
	Попытка
		ТекстовыйПроцессор = Новый COMОбъект("Word.Application"); 
	Исключение 			
		Сообщить("Не удалось создать объект Microsoft Office Word!"); Возврат Неопределено; КонецПопытки;        
		                                                                                                                    
	// Открываем шаблон
		
	ТекстовыйПроцессор.Visible = 0; 
	ТекстовыйПроцессор.Documents.Open(ИмяФайла,,);
	АктДок = ТекстовыйПроцессор.ActiveDocument;
	         
	
	//Fnd.ClearFormatting();
	//Fnd.Forward = -1;  
	
	//Fnd = ТекстовыйПроцессор.ActiveDocument.Sections(1).Headers(1).Range().Find;
	//Fnd.Execute("<Что_меняем>",,,,,,,,,"На_что_меняем", 2);
	
	//метод почему то не работает...
	//АктДок.UnProtect("123654");	
	
	МассивЗамен = Новый Массив;
	
	Попытка    // водр пишет что слишком большая строка замены. Попробуем вывести в случае ошибки все сообщим пользователю для анализа.
	
		Fnd = АктДок.Range().Find;
		Если СоответствиеЗамен <> Неопределено Тогда
			// Заменяем ключевые поля на нужные значения
			Для Каждого Замена Из СоответствиеЗамен Цикл 
				СтрЗамены= Строка(ВычислитьКодЗамены(Замена.Значение, СтруктураПеременных.Организация, СтруктураПеременных.Партнер, СтруктураПеременных.Контрагент, , СтруктураПеременных));
				Fnd.Execute(Замена.Ключ,,,,,,,,,СтрЗамены , 2); 
				МассивЗамен.Добавить(Замена.Ключ + ":	" + СтрЗамены);
			КонецЦикла; 
		КонецЕсли;
		
		
		//поиск по колонтитула происходит очень медленно. Поэтому обрабатываем только необходимый перечень
		ВерхнКолонтитул = АктДок.Sections(1).Headers(1).Range().Find;
		Если СоответствиеЗаменВК <> Неопределено Тогда
			Для Каждого Замена Из СоответствиеЗаменВК Цикл 
				СтрЗамены= Строка(ВычислитьКодЗамены(Замена.Значение, СтруктураПеременных.Организация, СтруктураПеременных.Партнер, СтруктураПеременных.Контрагент, , СтруктураПеременных));
				ВерхнКолонтитул.Execute(Замена.Ключ,,,,,,,,, СтрЗамены, 2); 
				МассивЗамен.Добавить(Замена.Ключ + ":	" + СтрЗамены);
			КонецЦикла; 
		КонецЕсли;
		
		НижнКолонтитул 	= АктДок.Sections(1).Footers(1).Range().Find;
		Если СоответствиеЗаменНК <> Неопределено Тогда
			Для Каждого Замена Из СоответствиеЗаменНК Цикл 
				СтрЗамены= Строка(ВычислитьКодЗамены(Замена.Значение, СтруктураПеременных.Организация, СтруктураПеременных.Партнер, СтруктураПеременных.Контрагент, , СтруктураПеременных));
				НижнКолонтитул.Execute(Замена.Ключ,,,,,,,,, СтрЗамены, 2); 
				МассивЗамен.Добавить(Замена.Ключ + ":	" + СтрЗамены);
			КонецЦикла; 
		КонецЕсли;
		
		Если Не СтруктураПеременных.ПечататьБезЗащиты Тогда
			//2 = WdProtectionType = WdAllowOnlyFormFields
			//3 = WdProtectionType = WdAllowOnlyReading
			АктДок.Protect(3, False, "123654", False, False); 
		КонецЕсли;	
		
	Исключение
		
		ТекстДокОш = Новый ТекстовыйДокумент;
		ТекстДокОш.УстановитьТекст("Не шмогла создать порядочный договор из-за ошибки ворда:
		|" + СтрСоединить(МассивЗамен, Символы.ПС));
		ТекстДокОш.Показать("Ошибка формирования word2"); КонецПопытки;
	
	ТекстовыйПроцессор.Visible = -1;    
	ТекстовыйПроцессор.Activate(); 
		
	Возврат ТекстовыйПроцессор;
	
КонецФункции

&НаКлиенте
Функция ВыполнитьЗаменуВордДокумента(ИмяФайла, Замена = Неопределено, СтруктураПеременных = Неопределено)
	
	СтрукЗамен= ДиалогиСПользователямиСервер.ПолучитьСоответствиеЗамен(Замена);
	
	Если глНастройкаМашины.УстановленВорд = Истина Тогда
		
		Возврат ВыполнитьЗаменуВордДокумента_Word(ИмяФайла, ?(Замена = Неопределено, Неопределено, СтрукЗамен), СтруктураПеременных);
		
	ИначеЕсли глНастройкаМашины.УстановленОпенОфис = Истина Тогда
			
		Возврат ВыполнитьЗаменуВордДокумента_OOoWriter(ИмяФайла, ?(Замена = Неопределено, Неопределено, СтрукЗамен), СтруктураПеременных);
		
	Иначе
		
		ПоказатьПредупреждение(,"В настройках не указано что установлен OpenOffice или Word.
		|Нужно указать, после чего повторить попытку");
		Возврат Ложь; КонецЕсли;
	
КонецФункции
	
	
&НаКлиенте
Процедура ОткрытьДокументВордДляПросмотра(ДокументВорд, Индекс = 0, СтруктураПеременных = Неопределено) Экспорт
	
	// Открывает документ ворда для просмотра
	// если есть замены то заменяет их
	//
	// 	ДокументВорд - ссылка на справочник контейнер документов
	//	Индекс - если документов несколько тогда его индекс
	
	// Вначале вытащим документ
	
	Перем ИмяФайла, Замена;
	
	Адрес 			= ДиалогиСПользователямиСервер.ПоместитьДокументВордВХранилище(ДокументВорд, Индекс, ИмяФайла, Замена);
	//ПолноеИмяФайла 	= КаталогВременныхФайлов() + ИмяФайла + ".doc";
	ПолноеИмяФайла 	= КаталогВременныхФайлов() + ИмяФайла;
	
	Если ПолучитьФайл(Адрес, ПолноеИмяФайла, Ложь) = Истина Тогда
		
		// Проверим чтобы обязательные замены были заменены
		
		Ошибка = Ложь; стрОшибки = "";
		СоответствиеЗамен = ДиалогиСПользователямиСервер.ПолучитьСоответствиеОбязательныхЗамен(ДокументВорд, Замена);
		Для Каждого текЗамена Из СоответствиеЗамен Цикл 
			
			стрЗамена = текЗамена.Значение;
			Если ПустаяСтрока(Строка(ВычислитьКодЗамены(текЗамена.Значение, СтруктураПеременных.Организация, СтруктураПеременных.Партнер, СтруктураПеременных.Контрагент,, СтруктураПеременных))) Тогда
				Ошибка = Истина;
				стрОшибки = стрОшибки + ?(стрОшибки = "", "","; ") + СтрЗаменить(СтрЗаменить(текЗамена.Ключ, "[", ""), "]",""); 
			КонецЕсли; 
		КонецЦикла;
		
		Если Ошибка Тогда
			ОбщиеФункции.СообщитьТекст("Не указаны поля: " + стрОшибки);
			Возврат; 
		КонецЕсли;
		
		// Если нужно обрабатывать по заменам то обработаем
		
		Если Замена.Пустая() Тогда
			
			ТекстовыйПроцессор = ВыполнитьЗаменуВордДокумента(ПолноеИмяФайла);
			
		Иначе
			
			Если СтруктураПеременных = Неопределено Тогда 
				ВызватьИсключение "Ошибка вызова процедуры ""ОткрытьДокументВордДляПросмотра(ДокументВорд, Индекс, <?>)"", нехватает внутренних переменных для замены"; 
			КонецЕсли;
			ТекстовыйПроцессор = ВыполнитьЗаменуВордДокумента(ПолноеИмяФайла, Замена, СтруктураПеременных); 
			Возврат;  
		КонецЕсли;
	КонецЕсли;
		
		// Открываем файл
		
		//ЗапуститьПриложение(ПолноеИмяФайла); КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Расширенный // табличный документ

//&НаСервере
//Функция РазобратьМассивНаСтрТаблицуЗначений(Массив)
//	
//	ДополнительныеПараметры = Новый ТаблицаЗначений;
//	ДополнительныеПараметры.Колонки.Добавить("Партнер", Новый ОписаниеТипов("СправочникСсылка.Партнеры"));
//	ДополнительныеПараметры.Колонки.Добавить("Заказ");
//		
//	Для Каждого Элемент Из Массив Цикл ЗаполнитьЗначенияСвойств(ДополнительныеПараметры.Добавить(), Элемент) КонецЦикла;
//	
//	Возврат ЗначениеВСтрокуВнутр(ДополнительныеПараметры);
//	
//КонецФункции
&НаКлиенте
Процедура ПоказатьТабличныйДокумент(ТабличныйДокумент, Параметры = Неопределено, ВладелецФормы = Неопределено) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область Замер_времени

&НаКлиенте
Функция НачалоЗамераВремени(Описание, СвязаннаяСсылка = Неопределено) Экспорт
	
	Гуид = Новый УникальныйИдентификатор;
	глЗамерВремени.Вставить(Гуид, Новый Структура("ДатаНачала, Описание, СвязаннаяСсылка", 
													ТекущаяДата(), Описание, СвязаннаяСсылка));
	Возврат Гуид;
	
КонецФункции
&НаКлиенте
Функция ОкончаниеЗамераВремени(Гуид, ЗаписыватьБолее = 3, Описание = Неопределено) Экспорт
	
	// ЗаписыватьБолее - все что по секундам этой цифры записываться в регистр не будет
	
	прошлДанные = глЗамерВремени[Гуид];
	Если прошлДанные <> Неопределено Тогда
		
		Продолжительность = ТекущаяДата() - прошлДанные.ДатаНачала;
		Если Продолжительность > ЗаписыватьБолее Тогда
			
			#Если Не ВебКлиент Тогда
				прошлДанные.Вставить("ИмяКомпьютера", 	ИмяКомпьютера());
			#КонецЕсли
			прошлДанные.Вставить("Продолжительность", 	Продолжительность);
			Если Описание <> Неопределено Тогда прошлДанные.Вставить("Описание", Описание) КонецЕсли;
			
			ДиалогиСПользователямиСервер.ЗаписатьВремяНаСервере(Гуид, прошлДанные); КонецЕсли; КонецЕсли;
	
КонецФункции


#КонецОбласти

//&НаКлиенте
//Процедура ОбработкаОтветаОЗакрытииПриложения(Результат, Параметры) Экспорт
//	
//	Если Результат = КодВозвратаДиалога.Да Тогда
//		
//		глПользовательХочетЗакрыть = Истина;
//		ЗавершитьРаботу(); КонецЕсли;
//	
//КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНовыйПарольПользователя(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда 
		ПрекратитьРаботуСистемы();
	Иначе
		ДиалогиСПользователямиСервер.УстановитьПароль(Результат) КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьКартинкиНоменклатурыНаДиск(Ссылки) Экспорт
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
	
		МассивФайлов 	= Новый Массив;
		текКартинки 	= ДиалогиСПользователямиСервер.ПолучитьСсылкиНаКартинкиИзБазыДляВыгрузкиНаДиск(Ссылки);
		Для КАждого Картинка Из текКартинки Цикл МассивФайлов.Добавить(Новый ОписаниеПередаваемогоФайла(Картинка.Наименование, ПолучитьНавигационнуюСсылку(Картинка.Ссылка, "Картинка"))); КонецЦикла;
		
		Если МассивФайлов.Количество() Тогда
		
			// Выгрузим
			
			Если ПолучитьФайлы(МассивФайлов,,, Истина) Тогда ПоказатьПредупреждение(,НСтр("ru = 'Выбранные картинки выгруженны!'; de='Bilder gespeichert!';")); КонецЕсли;
			
		Иначе ПоказатьПредупреждение(,НСтр("ru = 'Картинок не обнаружено'; de = 'Bilder nicht gefunden';")) КонецЕсли; КонецЕсли;
	
КонецПроцедуры