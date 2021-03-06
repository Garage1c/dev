﻿
Функция ПолучитьТекстВыполнитьКод(ВыполняемыйКод) Экспорт
	
	Возврат "V8:ВЫПОЛНИТЬ КОД:" + ВыполняемыйКод;
	
КонецФункции

Функция ТекстHTMLПриНажатии(ДанныеСобытия, СтандартнаяОбработка, ЭтаФорма = Неопределено) Экспорт
	
	// Обрабаотывает нажатие HTML
	// Возвращает:
	//		ИСТИНА если нужно обновлять страницу (страница изменилась)
	//		ЛОЖЬ если не нужно обновлять страницу (страница не изменилась)
	
	ИмяЭлемента				= "";
	СтандартнаяОбработка 	= Ложь;
	
	// Проверим на ссылку
	
	Если ДанныеСобытия.Href <> Неопределено И
			ТипЗнч(ДанныеСобытия.Href) = Тип("Строка") И
			Не ПустаяСтрока(ДанныеСобытия.Href) Тогда
			
		Если ВРЕГ(Лев(ДанныеСобытия.Href,3)) = "V8:" Тогда
			ИмяЭлемента = ДанныеСобытия.Href;			// это имя нам пригодится дальше
		ИначеЕсли ВРЕГ(Лев(ДанныеСобытия.Href,4)) = "E1C:" Тогда
			Возврат Ложь; 								// другой пусть обрабатывает
		Иначе
			СтандартнаяОбработка = Истина;
			//ЗапуститьПриложение(ДанныеСобытия.Href); 	// обычную ссылку пущай обрабатывает браузер
			Возврат Ложь; КонецЕсли; КонецЕсли;
	
	// Попробуем считать кнопку
	
	Попытка 
		ДанныеСобытия.Button.type = "button";
		ИмяЭлемента = ДанныеСобытия.Button.Name; Исключение КонецПопытки;
	
	// Определим элемент нажатия по имени
	
	Если ПустаяСтрока(ИмяЭлемента) Тогда
		
		Попытка
			ИмяЭлемента = ДанныеСобытия.Element.name;
		Исключение
			Возврат Ложь; КонецПопытки; КонецЕсли;
	
	Если ВРЕГ(Лев(ИмяЭлемента,3)) = "V8:" Тогда // Это наш объект
		
		// Разложим объект на состовляющие
		Определение = КонвертацияТипов.ПолучитьМассивИзСтроки(ИмяЭлемента, ":",, Ложь);
		
		Если ВРЕГ(Определение[1]) = "КНОПКА" Тогда // Это кнопка
			
			Если 	ВРЕГ(Определение[2]) = "ОТКЛЮЧИТЬ НОВОСТЬ" Тогда
				
				// Пример ссылки   v8:Кнопка:Отключить новость:5c7d2d64-5bc7-11e2-afaf-0015175303fd
				
				Если HTMLОбработкаСервер.ИзменитьСпособОтображенияьНовости(Определение[3], Истина, Определение[4]) Тогда
					Возврат Истина;
				Иначе
					ПоказатьПредупреждение(,"Ошибка отключения новости",,); 
				КонецЕсли; 
				
			КонецЕсли; 
			
			Если 	ВРЕГ(Определение[2]) = "ПОКАЗЫВАТЬ НОВОСТЬ" Тогда
				
				Если HTMLОбработкаСервер.ИзменитьСпособОтображенияьНовости(Определение[3], Ложь, Определение[4]) Тогда
					Возврат Истина;
				Иначе
					ПоказатьПредупреждение(,"Ошибка подключения новости",,); 
				КонецЕсли; 
			КонецЕсли; 
			
		ИначеЕсли ВРЕГ(Определение[1]) = "ВЫПОЛНИТЬ КОД" Тогда 
			   
			Если мПоследняяДатаВыполнения = Неопределено Или мПоследняяДатаВыполнения <> ТекущаяДата() Тогда
				
				Выполнить(Определение[2]);
				мПоследняяДатаВыполнения = ТекущаяДата(); 
				Возврат Истина; КонецЕсли;
	
	//	ИначеЕсли ВРЕГ(Определение[1]) = "ОТКРЫТЬ ОТЧЕТ" Тогда 
	//
	//	// Пример ссылки   v8:Открыть отчет:СборкаЗаказа:Склад=ссылка5c7d2d64-5bc7-11e2-afaf-0015175303fd;Номенклатура=ссылка5c7d2d64-5bc7-11e2-afaf-0015175303fd;Цена=число103;ОткрытьСразу=булевоИстина;Наименование=строка идет как по умолчанию
	//	
	//		ИмяОтчета = Определение[2];
	//		ПараметрыОтчета = КонвертацияТипов.ПолучитьМассивИзСтроки(Определение[3], ";");
	//		Для Ид = 0 По ПараметрыОтчета.Количество() - 1 Цикл
	//			
	//			стр = ПараметрыОтчета[Ид];
	//			Если Не ПустаяСтрока(Ид) Тогда
	//				
	//				ИмяПараметра = лев(стр, Найти(стр, "=") - 1);
	//				Значение = Сред(стр, Найти(стр, "=") + 1);
	//				
	//				Если Значение.
	//				
	//			КонецЕсли;
	//			
	//		КонецЦикла;
			
		
		КонецЕсли; 
	Иначе
		СтандартнаяОбработка = Истина;КонецЕсли;
			
	
	Возврат Ложь;
	
КонецФункции
