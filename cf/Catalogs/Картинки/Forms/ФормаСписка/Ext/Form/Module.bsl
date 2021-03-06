﻿
&НаКлиенте
Перем стРодитель;

// ТЭГОУПРАВЛЕНИЕ

&НаСервере
Процедура ТекстДобавить(Текст, доБекст, ПереводитьСтроку = Истина)
	
	Текст = Текст + доБекст + ?(ПереводитьСтроку, Символы.ПС, "");
	
КонецПроцедуры
&НаСервере
Процедура ТэгДобавить(Текст, Тэг, ПереводитьСтроку = Истина)
	
	Текст = Текст + "<" + Тэг + ">" + ?(ПереводитьСтроку, Символы.ПС, "");
	
КонецПроцедуры
&НаСервере
Процедура ТэгЗакрыть(Текст, Тэг, ПереводитьСтроку = Истина)
	
	Текст = Текст + "</" + Тэг + ">" + ?(ПереводитьСтроку, Символы.ПС, "");
	
КонецПроцедуры

// ОТОБРАЖЕНИЕ

&НаСервере
Процедура ОбновитьГалерею()
	
	РазмерКартинкиX			= 120;
	РазмерКартинкиY			= 100;
	ОтображатьНаСтроке 		= 5; // по 5 картинок на строке
	ОтображатьНаСтранице 	= 6; // по 5 строк картинок
	НаСтраницеПомещаются	= ОтображатьНаСтроке * ОтображатьНаСтранице; // стоко картинок
	
	Текст = "";
	
	Запрос = Новый Запрос("ВЫБРАТЬ Код, Наименование, Ссылка ИЗ Справочник.Картинки ГДЕ НЕ ЭтоГруппа И НЕ ПометкаУдаления И Код >= &КодНачала И Код <= &КодОкончание И Родитель = &Родитель");
	
	Запрос.УстановитьПараметр("Родитель",		текРодитель);
	Запрос.УстановитьПараметр("КодНачала", 		Цел(текКодКартинки / (НаСтраницеПомещаются + 1)) + 1);
	Запрос.УстановитьПараметр("КодОкончание", 	Цел(текКодКартинки / НаСтраницеПомещаются + 1) + НаСтраницеПомещаются);
	
	// Получим отбор из динамического списка
	
	//Для Каждого Отбор Из Список.Отбор.Элементы Цикл
	//	
	//КонецЦикла;
	
	ДлинаНименованияКартинок 	= Метаданные.Справочники.Картинки.ДлинаНаименования;
	СсылкаКартинкаОткрыть 		= ПолучитьНавигационнуюСсылку(БиблиотекаКартинок.ИнформацияОТоваре);
	
	// начнем строить таблицу
	
	ТэгДобавить(Текст, "table");
	
	Выборка = Запрос.Выполнить().Выбрать(); Ном = 0;
	Пока Выборка.Следующий() Цикл 
		
		// Сначала закроем предыдущую строку
		Если Ном > ОтображатьНаСтроке Тогда Ном = 0; ТэгЗакрыть(Текст, "tr"); КонецЕсли;
		
		// Увеличим счетчик
		Ном = Ном + 1;
		
		// Щатем откроем новую строку
		Если Ном = 1 Тогда ТэгДобавить(Текст, "tr"); КонецЕсли;
		
		// Новая ячейка
		ТэгДобавить(Текст, "td");
		ТэгДобавить(Текст, "p");
			//ТэгДобавить(Текст, "img onload=""javascript:autosize(this," + Формат(РазмерКартинкиX,"ЧГ=") + "," + Формат(РазмерКартинкиY,"ЧГ=") + ")"" src='" + ПолучитьНавигационнуюСсылку(Выборка.Ссылка, "Картинка") + "'");
			ТэгДобавить(Текст, "img src='" + ПолучитьНавигационнуюСсылку(Выборка.Ссылка, "Картинка") + "' width='" + Формат(РазмерКартинкиX,"ЧГ=") + "' height='" + Формат(РазмерКартинкиY,"ЧГ=") + "'");
		ТэгЗакрыть(Текст, "p");
		//ТэгДобавить(Текст,"br");
		
		ТэгДобавить(Текст, "p");
			ТекстДобавить(Текст,"<a id=""save-" + XMLСтрока(Выборка.Ссылка) + """ href="""" title=""Изменить наименование"">" + ?(ПустаяСтрока(Выборка.Наименование), "без названия", Выборка.Наименование) + "</a><br>");
			ТекстДобавить(Текст, Строка(Выборка.Код) + ":");
			//ТекстДобавить(Текст,"<button><img src=" + СсылкаКартинкаОткрыть + " style=""vertical-align: middle""> ссылка </button><br>");
			ТекстДобавить(Текст,"<button id=""open-" + XMLСтрока(Выборка.Ссылка) + """ title=""Получить ссылку для вставки в тексты html""> ссылка </button>");
			ТекстДобавить(Текст,"<button id=""move-" + XMLСтрока(Выборка.Ссылка) + """ title=""Перенести в другую группу"">п</button>");
			ТекстДобавить(Текст,"<button id=""remv-" + XMLСтрока(Выборка.Ссылка) + """ title=""Удалить картинку"">d</button>");
		ТэгЗакрыть(Текст, "p");
		
		//ТекстДобавить(Текст, "<input id=""name-" + XMLСтрока(Выборка.Ссылка) + """ type=""text"" value=""" + Выборка.Наименование + """ maxlength=""" + ДлинаНименованияКартинок + """ size=""12""/>");
		//ТекстДобавить(Текст,"<button id=""save-" + XMLСтрока(Выборка.Ссылка) + """ title=""Записать наименование"">s</button>");
		
		ТэгЗакрыть(Текст, "td");
		
	КонецЦикла;
	
	// Закремся
	
	Если Ном Тогда ТэгЗакрыть(Текст, "tr"); КонецЕсли; ТэгЗакрыть(Текст, "table");
	
	ТекстHTML = "
	|<HTML><HEAD>
	|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
	|<META name=GENERATOR content=""MSHTML 9.00.8112.16457""></HEAD>
	|<body style=""background-color:#FCFAEB;"">
	|<BODY>" + Текст + "
	//|function auto_size (img,max_width,max_height)
	//|{
	//| if (img.width>maxwidth) 
	//| {
	//|  width = img.width; height = img.height;
	//|  img.width = maxwidth;
	//|  img.height = (maxwidth*height)/width;
	//| }
	//| 
	//| if (img.height>maxheight) 
	//| {
	//|  width = img.width; height = img.height;
	//|  img.height = maxheight;
	//|  img.width = (maxheight*width)/height;
	//| }
	//|}
	|</BODY></HTML>";
	
КонецПроцедуры
&НаКлиенте
Процедура ОбновитьГалереюНаКлиенте()
	
	текРодитель = Элементы.Дерево.ТекущаяСтрока;
	
	Если стРодитель = Неопределено Или стРодитель <> текРодитель Тогда
		стРодитель = текРодитель; ОбновитьГалерею(); КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриАктивизацииСтроки(Элемент)
	
	ОбновитьГалереюНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТиповойСписок(Команда)
	
	ОткрытьФорму("Справочник.Картинки.Форма.ФормаСпискаТиповая");
	
КонецПроцедуры
&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьГалерею();
	
КонецПроцедуры

// ТИПОВЫЕ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ОбновитьГалерею();
	
КонецПроцедуры

// ДОБАВЛЕНИЕ

&НаСервере
Функция ДобавитьКартинкуНаСервере(Наименование, Родитель, Адрес)

	СправочникОбъект = Справочники.Картинки.СоздатьЭлемент();
	СправочникОбъект.Наименование 	= Наименование;
	СправочникОбъект.Родитель 		= Родитель;
	СправочникОбъект.Картинка 		= Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Адрес));
	
	Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(СправочникОбъект);
	
КонецФункции

&НаКлиенте
Процедура Добавить(Команда)
	
	// Выберем картинку
	
	ДВ = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	Если ДВ.Выбрать() Тогда 
		
		стрОшибки 	= "";
		ИмяФайла 	= Сред(ДВ.ПолноеИмяФайла, СтрДлина(ДВ.Каталог) + 1);
		
		Файл = Новый Файл(ДВ.ПолноеИмяФайла);
		
		Если ДобавитьКартинкуНаСервере(Файл.Имя, текРодитель, ПоместитьВоВременноеХранилище(Новый Картинка(ДВ.ПолноеИмяФайла))) Тогда
			
			ОбновитьГалерею();
			
		Иначе ПоказатьПредупреждение(,"Ошибка получения картинки",,"Предупреждение"); КонецЕсли;КонецЕсли;
	
КонецПроцедуры

// УПРАВЛЕНИЕ HTML

&НаСервере
Функция ПолучитьНавигационнуюСсылкуНаСервере(гуид)
	
	Возврат ПолучитьНавигационнуюСсылку(Справочники.Картинки.ПолучитьСсылку(Новый УникальныйИдентификатор(гуид)), "Картинка");
	
КонецФункции
&НаСервере
Функция ЗаписатьРеквизитСправочника(гуид, ИмяРеквизита, Значение)
	
	СправочникОбъект = Справочники.Картинки.ПолучитьСсылку(Новый УникальныйИдентификатор(гуид)).ПолучитьОбъект();
	СправочникОбъект[ИмяРеквизита] 	= Значение;
	
	Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(СправочникОбъект);
	
КонецФункции
&НаКлиенте
Процедура ТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	id = ДанныеСобытия.Element.id;
	
	Если Лев(id, 4) = "open" Тогда
		
		ВвестиСтроку(ПолучитьНавигационнуюСсылкуНаСервере(Сред(id, 6)), "Ссылка на картинку в базе:"); 
		
	ИначеЕсли Лев(id, 4) = "save" Тогда
		
		Название = ДанныеСобытия.Element.textContent;
		Если ВвестиСтроку(Название, "Новое название") И ЗаписатьРеквизитСправочника(Сред(id, 6), "Наименование", Название) Тогда
			ОбновитьГалерею(); КонецЕсли;
		
	
		//ЗаписатьРеквизитСправочника(Сред(id, 6), "Наименование", ДанныеСобытия.Element.value);
		//ЗаписатьНовоеНазваниеСправочника(Сред(id, 6), ДанныеСобытия.Element.value); ОбновитьГалерею(); 
		
	ИначеЕсли Лев(id, 4) = "remv" Тогда
		
		Если ЗаписатьРеквизитСправочника(Сред(id, 6), "ПометкаУдаления", Истина) Тогда
			ОбновитьГалерею(); КонецЕсли;
		
	ИначеЕсли Лев(id, 4) = "move" Тогда
		
		ВыбРодитель = ОткрытьФорму("Справочник.Картинки.Форма.ФормаВыбораРодителя",,ЭтаФорма,,,,Новый ОписаниеОповещения("ОбработкаВыбораРодителя",ЭтаФорма,Новый Структура("id", id)));
		//Если ВыбРодитель <> Неопределено И ЗаписатьРеквизитСправочника(Сред(id, 6), "Родитель", ВыбРодитель) Тогда
		//	ОбновитьГалерею(); КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораРодителя(Результат, Парамтеры) Экспорт
	Если Результат <> Неопределено И ЗаписатьРеквизитСправочника(Сред(Параметры.id, 6), "Родитель", Результат) Тогда
			ОбновитьГалерею(); КонецЕсли; 	
КонецПроцедуры


