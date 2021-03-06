﻿
Функция ПолучитьИзмененияРеквизитов(Объект) Экспорт
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Функция возвращает структуру в которой показывается какие реквизиты изменились
	//
	//	Структура имеет сл формат
	//		Ключ 		- имя реквизита
	//		Значение 	- значение реквизита до записи (как было)
	//
	//	если ключ это имя таблицы тогда в значении будет массив в элементы которого будет структура сл. формата
	//		Ключ 		- имя реквизита таблицы
	//		Значение 	- значение реквизита таблицы до записи (как было)
	//
	//	в структуры попадают только те значения которые были изменены, если реквизит не изменен тогда его не будет в структуре
	//	в массив строк попадают только те строки которые были ищменены если в строке ничего не было измененно тогда такой записи не будет
	//	искать какие именно строки можно по номерам строк (это реквизит таблицы)
	//	если изменилось количество строк тогда сравнения по строкам не будет (массива), а будет помещено число (количество строк до записи)
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	СтруктураИзменений 	= Новый Структура;
	МетаОбъект 			= Объект.Метаданные();
	
	ТекстРеквизитов = "";
	ТекстТаблиц		= "";
	
	ЭтоСправочник 	= Метаданные.Справочники.Содержит(МетаОбъект);
	ЭтоДокумент 	= ?(ЭтоСправочник, Ложь, Метаданные.Документы.Содержит(МетаОбъект));
	ЭтоГруппа		= ЭтоСправочник И Объект.ЭтоГруппа;
	
	Если ЭтоСправочник Тогда
		ИспользованиеДляЭлемента 	= Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляЭлемента;
		ИспользованиеДляГруппы 		= Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляГруппы;
	КонецЕсли;
	
	// Добавим предопределенные реквизиты
	
	Если ЭтоСправочник Тогда
		
		Если МетаОбъект.ДлинаНаименования Тогда
			ТекстРеквизитов = ТекстРеквизитов + ?(ТекстРеквизитов = "","",",") + "
			|Наименование"; 
		КонецЕсли;
		
		Если МетаОбъект.ДлинаКода Тогда
			ТекстРеквизитов = ТекстРеквизитов + ?(ТекстРеквизитов = "","",",") + "
			|Код"; 
		КонецЕсли; 
	КонецЕсли;
	
	Если ЭтоДокумент Тогда
		
		ТекстРеквизитов = ТекстРеквизитов + ?(ТекстРеквизитов = "","",",") + "
		|Номер";
		
		ТекстРеквизитов = ТекстРеквизитов + ?(ТекстРеквизитов = "","",",") + "
		|Дата"; 
	КонецЕсли;
	
	// Установим реквизиты
	
	Для Каждого Реквизит Из МетаОбъект.Реквизиты Цикл 
		Если Реквизит.Тип <> Новый ОписаниеТипов("ХранилищеЗначения") Тогда
			
			Если ЭтоСправочник Тогда
				
				Если 	(	ЭтоГруппа И
					Реквизит.Использование <> ИспользованиеДляЭлемента
					) ИЛИ
					(
					Не ЭтоГруппа И
					Реквизит.Использование <> ИспользованиеДляГруппы
					) Тогда
					
					ТекстРеквизитов = ТекстРеквизитов + ",
					|" + Реквизит.Имя;
					
				КонецЕсли;
			Иначе
				
				ТекстРеквизитов = ТекстРеквизитов + ",
				|" + Реквизит.Имя; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	
	// Получим из общих реквизитов
	Если ЭтоДокумент Тогда
		СвойствоИспользовать = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать;
		   
		Для Каждого ОбщийРеквизит ИЗ Метаданные.ОбщиеРеквизиты Цикл Элемент = ОбщийРеквизит.Состав.Найти(МетаОбъект);
			
			Если Элемент.Использование = СвойствоИспользовать Тогда ТекстРеквизитов = ТекстРеквизитов + ",
					|" + ОбщийРеквизит.Имя; КонецЕсли; 	КонецЦикла;
	КонецЕсли;
	
	
	// Установим табличные части
	
	Для Каждого ТабличнаяЧасть Из МетаОбъект.ТабличныеЧасти Цикл 
		ТекстСтРеквизитовТаблицы = "";
		ТекстРеквизитовТаблицы = ""; 
		Для Каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл 
			Если Реквизит.Тип <> Тип("ХранилищеЗначения") Тогда
				ТекстРеквизитовТаблицы = ТекстРеквизитовТаблицы + ?(ТекстРеквизитовТаблицы = "","",",") + Символы.ПС + Реквизит.Имя; 
			КонецЕсли; 
		КонецЦикла;
		/// стандартыне реквизиты
		Для Каждого СтРеквизит Из ТабличнаяЧасть.СтандартныеРеквизиты Цикл
			ТекстСтРеквизитовТаблицы = ТекстСтРеквизитовТаблицы + ?(ТекстСтРеквизитовТаблицы = "", "", ",") + Символы.ПС + СтРеквизит.Имя;
		КонецЦикла;
		ТекстТаблиц = ТекстТаблиц + ?(ТекстТаблиц = "","",",") + Символы.ПС + ТабличнаяЧасть.Имя + ".(" + ТекстРеквизитовТаблицы +","+ТекстСтРеквизитовТаблицы +") " + ТабличнаяЧасть.Имя; 
	КонецЦикла;
	
	// Выберем
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ " + ТекстРеквизитов + ?(ТекстТаблиц = "","","," + ТекстТаблиц) + "
	|ИЗ " + ?(ЭтоСправочник, "Справочник","Документ") + "." + МетаОбъект.Имя + " 
	|ГДЕ Ссылка = &Ссылка
	|");
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	ТаблицаВБазе = Запрос.Выполнить().Выгрузить();
	/////
	ВидОпераций = Новый СписокЗначений;
	ВидОпераций.Добавить("Удаление");
	ВидОпераций.Добавить("Изменение");
	ВидОпераций.Добавить("Добавление");
	/////
	Для Каждого Строка Из ТаблицаВБазе Цикл
		
		//// silber { Антон мать его
		//Если ТаблицаВБазе.Колонки.Найти("idстроки") = Неопределено Тогда Продолжить КонецЕсли;
		//// } silber
			
		Для Каждого Колонка Из ТаблицаВБазе.Колонки Цикл
			///// начало ТабЧасть
			Если Колонка.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) Тогда
				
				ТабЧастьВБазе = Строка[Колонка.Имя];
				ТабЧастьВОбъекте = Объект[Колонка.Имя].Выгрузить();
				
		// silber {... //mac перенесла условие 
		Если ТабЧастьВБазе.Колонки.Найти("idстроки") = Неопределено Тогда Продолжить КонецЕсли;
		// } silber

				МассивИзменений = Новый Массив;
				Отбор = Новый Структура;
				///
				Если НЕ ЗначениеЗаполнено(ТабЧастьВБазе) И НЕ ЗначениеЗаполнено(ТабЧастьВОбъекте) Тогда
					Продолжить;
				КонецЕсли;
				
				Если ТабЧастьВБазе.Количество() > ТабЧастьВОбъекте.Количество() Тогда
					Табл_1 = ТабЧастьВБазе;
					Табл_2 = ТабЧастьВОбъекте;
					База = истина;
				ИначеЕсли ТабЧастьВБазе.Количество() < ТабЧастьВОбъекте.Количество() Тогда
					Табл_1 = ТабЧастьВОбъекте;
					Табл_2 = ТабЧастьВБазе;
					База = Ложь;
				ИначеЕсли ТабЧастьВБазе.Количество() = ТабЧастьВОбъекте.Количество() Тогда
					Табл_1 = ТабЧастьВБазе;
					Табл_2 = ТабЧастьВОбъекте;
					База = Истина;
				КонецЕсли;
								
				Для Каждого СтрТабл_1 Из Табл_1 Цикл
					Если База И СтрТабл_1["idстроки"] = "" Тогда
						Продолжить;
					КонецЕсли;
					///
					СтруктураИзмененийКолонки = Новый Структура;
					Отбор.Очистить();
					///
					Если Колонка.Имя = "ДополнительныеРеквизитыНоменклатуры" Тогда 
					Отбор.Вставить("Значение", СтрТабл_1["Значение"]);
					Отбор.Вставить("Свойство", СтрТабл_1["Свойство"]);
					Иначе
					Отбор.Вставить("idстроки", СтрТабл_1["idстроки"]);
				    КонецЕсли;
				
					НайденныеСтроки = Табл_2.НайтиСтроки(Отбор);
					Если НайденныеСтроки.Количество() <> 0 Тогда
						СтрТабл_2 = НайденныеСтроки[0];
						Для Каждого КолонкаСтр Из Табл_1.Колонки Цикл
							Если (СтрТабл_2[КолонкаСтр.Имя] <> СтрТабл_1[КолонкаСтр.Имя]) И (КолонкаСтр.Имя <> "idстроки") Тогда
								Если База Тогда
									СтруктураИзмененийКолонки.Вставить(Строка(КолонкаСтр.Имя), СтрТабл_1[КолонкаСтр.Имя]);
								Иначе
									СтруктураИзмененийКолонки.Вставить(Строка(КолонкаСтр.Имя),СтрТабл_2[КолонкаСтр.Имя]);
								КонецЕсли;
							КонецЕсли;	
						КонецЦикла;
					Иначе
						//На случай если элемент был создан до введения idстроки
						Отбор.Очистить();
						Для каждого КолонкаСтр Из Табл_1.Колонки Цикл
							Если КолонкаСтр.Имя <> "idстроки" Тогда
								Отбор.Вставить(Строка(КолонкаСтр.Имя), СтрТабл_1[КолонкаСтр.Имя]);
							КонецЕсли;
						КонецЦикла;
						НайденныеСтроки =Табл_2.НайтиСтроки(Отбор);
						Если НайденныеСтроки.Количество() <> 0 Тогда
							Продолжить;
						КонецЕсли;
						/////////
						Для Каждого КолонкаСтр Из Табл_1.Колонки Цикл
							Если База Тогда
								СтруктураИзмененийКолонки.Вставить(СТрока(КолонкаСтр.Имя), СтрТабл_1[КолонкаСтр.Имя]);	
							Иначе
								СтруктураИзмененийКолонки.Вставить(Строка(КолонкаСтр.Имя), Неопределено);
							КонецЕсли;
						КонецЦикла;
					Конецесли;
					
					Если СтруктураИзмененийКолонки.Количество()>0 Тогда
						СтруктураИзмененийКолонки.Вставить("idстроки", СтрТабл_1["idстроки"]);
						МассивИзменений.Добавить(СтруктураИзмененийКолонки); 
					КонецЕсли;
					///
					Если МассивИзменений.Количество() <> 0 Тогда
						СтруктураИзменений.Вставить(Строка(Колонка.Имя),МассивИзменений);
					КонецЕсли;
					
				КонецЦикла;				
			Иначе
			//////реквизит начало
				Если Строка[Колонка.Имя] <> Объект[Колонка.Имя] Тогда
					СтруктураИзменений.Вставить(Колонка.Имя, Строка[Колонка.Имя]); 
				КонецЕсли;
			/////реквизит конец
			КонецЕсли;	
		КонецЦикла; 
	КонецЦикла;
	Возврат СтруктураИзменений;		
КонецФункции
