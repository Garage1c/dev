﻿
&НаСервере
Процедура ДобавитьСтрокуРеквизитов(НовСтрокаРеквизита, Имя, Синоним = "")
	
	НовСтрокаРеквизита.ИмяРеквизита 	= Имя;
	НовСтрокаРеквизита.Представление	= ?(Синоним = "", Имя, Синоним);
				
	СтрокаОбъекта = Объект.Реквизиты.НайтиСтроки(Новый Структура("ИмяРеквизита", Имя));
	Если СтрокаОбъекта.Количество() Тогда
						
		НовСтрокаРеквизита.ИмяРеквизитаИсточника 	= СтрокаОбъекта[0].ИмяРеквизитаИсточника;
		НовСтрокаРеквизита.ЭтоОбъектПоиска 			= СтрокаОбъекта[0].ЭтоОбъектПоиска;
		НовСтрокаРеквизита.Источник 				= СтрокаОбъекта[0].Источник;
						
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоОбъекта()
	
	Дерево = ДанныеФормыВЗначение(МетаДерево, Тип("ДеревоЗначений"));
	
	Дерево.Строки.Очистить();
	
	Если Не ПустаяСтрока(Объект.ИмяОбъекта) Тогда
		
		МетаОбъект = КэшируемыеФункции.ПолучитьМетаОбъектИзСтроки(Объект.ИмяОбъекта);
		Если МетаОбъект <> Неопределено Тогда
			
			Если 	Метаданные.Справочники.Содержит(МетаОбъект) Или
					Метаданные.Документы.Содержит(МетаОбъект) Тогда
					
				// Добавим системные поля
					
				Если Метаданные.Справочники.Содержит(МетаОбъект) Тогда
					
					Если МетаОбъект.ДлинаКода Тогда
						ДобавитьСтрокуРеквизитов(Дерево.Строки.Добавить(), "Код");
					КонецЕсли;
					
					Если МетаОбъект.ДлинаНаименования Тогда
						ДобавитьСтрокуРеквизитов(Дерево.Строки.Добавить(), "Наименование");
					КонецЕсли;
					
					Если МетаОбъект.Иерархический Тогда
						ДобавитьСтрокуРеквизитов(Дерево.Строки.Добавить(), "ЭтоГруппа", "Это группа");
					КонецЕсли;
					
				ИначеЕсли Метаданные.Документы.Содержит(МетаОбъект) Тогда
					
					ДобавитьСтрокуРеквизитов(Дерево.Строки.Добавить(), "Номер");
					
				КонецЕсли;
					
				// Добавим реквизиты
					
				Для Каждого Реквизит Из МетаОбъект.Реквизиты Цикл
					
					ДобавитьСтрокуРеквизитов(Дерево.Строки.Добавить(), Реквизит.Имя, Реквизит.Синоним);
					
				КонецЦикла;
				
				// Добавим табличные части
				
				Для Каждого ТабличнаяЧасть Из МетаОбъект.ТабличныеЧасти Цикл
					
					НовСтрокаТабицы = Дерево.Строки.Добавить();
					НовСтрокаТабицы.ИмяРеквизита 	= ТабличнаяЧасть.Имя;
					НовСтрокаТабицы.Представление 	= ТабличнаяЧасть.Синоним;
					
					Для Каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл
					
						НовСтрока = НовСтрокаТабицы.Строки.Добавить();
						НовСтрока.ИмяРеквизита 	= Реквизит.Имя;
						НовСтрока.ИмяТаблицы 	= ТабличнаяЧасть.Имя;
						НовСтрока.Представление = Реквизит.Синоним;
					
						СтрокаОбъекта = Объект.ТабличныеЧасти.НайтиСтроки(Новый Структура("ИмяТаблицы, ИмяРеквизита", ТабличнаяЧасть.Имя, Реквизит.Имя));
						Если СтрокаОбъекта.Количество() Тогда
							
							НовСтрока.ИмяРеквизитаИсточника = СтрокаОбъекта.ИмяРеквизитаИсточника;
							НовСтрока.ЭтоОбъектПоиска 		= СтрокаОбъекта.ЭтоОбъектПоиска;
							НовСтрока.Источник 				= СтрокаОбъекта.Источник;
							
						КонецЕсли;
					КонецЦикла;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	ЗначениеВДанныеФормы(Дерево, МетаДерево);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СформироватьДеревоОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяОбъектаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОтборМетаданных = Новый СписокЗначений;
	ОтборМетаданных.Добавить("Справочники");
	ОтборМетаданных.Добавить("Документы");
	ОтборМетаданных.Добавить("РегистрыСведений");
	
	ОткрытьФорму("ОбщаяФорма.ВыборОбъектовМетаданных", 
	                  Новый Структура("ВыбранныеМетаданные, УникальныйИдентификаторИсточник", ОтборМетаданных , УникальныйИдентификатор), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяОбъектаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка 	= Ложь;
	Объект.ИмяОбъекта 		= ВыбранноеЗначение;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекПараметрыСтроки(Источник)
	
	// Запомним то что было
	
	ТаблицаТекОбъекта 	= ДанныеФормыВЗначение(ПараметрыТекИсточника, 	Тип("ТаблицаЗначений"));
	ТаблицаОбъекта 		= Объект.ПараметрыИсточника.Выгрузить();
	КолСтрок 			= ТаблицаОбъекта.Количество();
	
	// Снесем все строки
	
	Если ТаблицаТекОбъекта.Количество() Тогда
		
		Источник = ТаблицаТекОбъекта[0].Источник;
		//Объект.ПараметрыИсточника
		
		Для Ном = 1 По КолСтрок Цикл текИнд = КолСтрок - Ном;
			
			Если ТаблицаОбъекта[текИнд].Источник = Источник Тогда
				ТаблицаОбъекта.Удалить(текИнд);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Добавим старые
	
	КонвертацияТипов.ДобавитьТаблицуКДругойТаблице(ТаблицаОбъекта, ТаблицаТекОбъекта);
	
	// Прочитаем новое
	
	ТаблицаТекОбъекта.Очистить();
	КонвертацияТипов.ДобавитьТаблицуКДругойТаблице(ТаблицаТекОбъекта, ТаблицаОбъекта.НайтиСтроки(Новый Структура("Источник", Источник)));
	
	// Вернем на форму
	
	ЗначениеВДанныеФормы(ТаблицаТекОбъекта, ПараметрыТекИсточника);
	Объект.ПараметрыИсточника.Загрузить(ТаблицаОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникиПриАктивизацииСтроки(Элемент)
	
	ТекДанные = Элементы.Источники.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		
		ЗаполнитьТекПараметрыСтроки(Элементы.Источники.ТекущиеДанные.Источник);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыТекИсточникаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элементы.ПараметрыТекИсточника.ТекущиеДанные.Источник = Элементы.Источники.ТекущиеДанные.Источник;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыТекИсточникаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Элементы.Источники.ТекущиеДанные = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ЗаписатьДанные()
	
	Дерево = ДанныеФормыВЗначение(МетаДерево, Тип("ДеревоЗначений"));
	
	Объект.Реквизиты.Очистить();
	Объект.ТабличныеЧасти.Очистить();
	
	Для Каждого Строка Из Дерево.Строки Цикл
		
		ЭтоТаблица 		= Строка.Строки.Количество();
		ТаблицаОбъекта 	= ?(ЭтоТаблица, Объект.ТабличныеЧасти, Объект.Реквизиты);
		
		// Реквизиты
		
		НовСтрока = ТаблицаОбъекта.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
		
		// Таблица
		
		Для Каждого Строка Из Дерево.Строки Цикл
			
			НовСтрока = ТаблицаОбъекта.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
				
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ЗаписатьДанные();
	
КонецПроцедуры
