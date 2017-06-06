﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СИСТЕМНЫХ СОБЫТИЙ
//

// Обработчик события ПриНачалеРаботыСистемы вызывается
// для выполнения действий, требуемых для подсистемы РегламентныеЗадания.
//
Процедура ПриНачалеРаботыСистемы() Экспорт

	Если Найти(ПараметрЗапуска, "DoScheduledJobs") <> 0 Тогда
		Предупреждать  = (Найти(ПараметрЗапуска, "SkipMessageBox") =  0);
		ОтдельныйСеанс = (Найти(ПараметрЗапуска, "AloneIBSession") <> 0);
		#Если ВебКлиент Тогда
			ЗавершитьРаботуСистемы(Ложь);
		#КонецЕсли
		Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
			ЗаданияОбрабатываютсяНормально = Неопределено;
			ОписаниеОшибки = "";
			Если РегламентныеЗаданияПолныеПрава.ТекущийСеансОбрабатываетЗадания(ЗаданияОбрабатываютсяНормально, Истина, ОписаниеОшибки) Тогда
				УстановитьЗаголовокПриложения(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Обработка регламентных заданий: %1'"),
				                                                                                      ПолучитьЗаголовокПриложения() ));
				Если ОтдельныйСеанс Тогда
					// Обрабатывать в отдельном сеансе.
					ОткрытьФорму("Обработка.КонсольРегламентныхЗаданий.Форма.РабочийСтолОтдельногоСеансаОбработкиРегламентныхЗаданий",,,, ПолучитьОкна()[0] );
					ОткрытьФормуМодально("Обработка.КонсольРегламентныхЗаданий.Форма.ОбработкаРегламентныхЗаданий");
					ЗавершитьРаботуСистемы(Ложь);
				Иначе
					// Обрабатывать в этом сеансе.
					ПодключитьОбработчикОжидания("ОбработкаРегламентныхЗаданийВОсновномСеансе", 1, Истина);
				КонецЕсли;
			Иначе
				Если Предупреждать Тогда
					Если ЗаданияОбрабатываютсяНормально Тогда
						Предупреждение(НСтр("ru = 'Сеанс, обрабатывающий регламентные задания, уже открыт!'"));
					Иначе
						Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сеанс, обрабатывающий регламентные задания, уже открыт!
						                                                                                  | 
						                                                                                  |%1'"), ОписаниеОшибки ));
					КонецЕсли;
				КонецЕсли;
				Если ОтдельныйСеанс Тогда
					ЗавершитьРаботуСистемы(Ложь);
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если Предупреждать Тогда
				Предупреждение(НСтр("ru = 'Регламентные задания обрабатываются на сервере!'"));
			КонецЕсли;
			Если ОтдельныйСеанс Тогда
				ЗавершитьРаботуСистемы(Ложь);
			КонецЕсли;
		КонецЕсли;
	Иначе
		
		Параметры = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПараметрыОткрытияСеансаОбработкиРегламентныхЗаданий;
		
		Если НЕ Параметры.Отказ И Параметры.ТребуетсяОткрытьОтдельныйСеанс Тогда
			ПопыткаОткрытьОтдельныйСеансОбработкиРегламентныхЗаданий(Параметры);
		КонецЕсли;
		
		Если Параметры.Отказ Тогда
			ПриОшибкеОбработкиРегламентныхЗаданий(Параметры.ОписаниеОшибки);
		КонецЕсли;

		Если Параметры.ВыполненаПопыткаОткрытия Тогда
			// Вернем окну приложения активность.
			Окна = ПолучитьОкна();
			Для каждого Окно Из Окна Цикл
				Если Окно.Основное Тогда
					Окно.Активизировать();
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если Параметры.УведомлятьОНекорректномСостоянииОбработки Тогда
			ПодключитьОбработчикОжидания("УведомлятьОНекорректномСостоянииОбработкиРегламентныхЗаданий", Параметры.ПериодУведомления * 60, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПриНачалеРаботыСистемы()


////////////////////////////////////////////////////////////////////////////////
// МЕТОДЫ РАСШИРЕНИЯ МЕНЕДЖЕРА РЕГЛАМЕНТНЫХ ЗАДАНИЙ
//

// Функция ОткрытьОтдельныйСеансОбработкиРегламентныхЗаданий() запускает новый сеанс,
// обрабатывающий регламентные задания.
//  Только для тонкого и обычного клиентов (Web не поддерживается).
//
// Возвращаемое значение:
//  Структура
//    Отказ             - Булево.
//    ОписаниеОшибки    - Строка.
// 
Функция ОткрытьОтдельныйСеансОбработкиРегламентныхЗаданий() Экспорт
                                                          
	Параметры = РегламентныеЗаданияПолныеПрава.ПараметрыОткрытияСеансаОбработкиРегламентныхЗаданий(Ложь);
	
	Если НЕ Параметры.Отказ И Параметры.ТребуетсяОткрытьОтдельныйСеанс Тогда
		ПопыткаОткрытьОтдельныйСеансОбработкиРегламентныхЗаданий(Параметры);
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции // ОткрытьОтдельныйСеансОбработкиРегламентныхЗаданий()

// Процедура ПопыткаОткрытьОтдельныйСеансОбработкиРегламентныхЗаданий()
// делает попытку открытия нового сеанса, обрабатывающего регламентные задания.
//
// Параметры:
//  Параметры    - Структура, используемые свойства:
//                   СтрокаЗапуска            - Строка.
//                   Отказ                    - Булево, выходной параметр.
//                   ОписаниеОшибки           - Строка, выходной параметр.
// 
// Возвращаемое значение:
//  Булево - равно НЕ Отказ.
//
Процедура ПопыткаОткрытьОтдельныйСеансОбработкиРегламентныхЗаданий(Знач Параметры)
	
	#Если НЕ ВебКлиент Тогда
		Попытка
			Параметры.ВыполненаПопыткаОткрытия = Истина;
			ЗапуститьПриложение(Параметры.СтрокаЗапуска, КаталогПрограммы());
		Исключение
			Параметры.ОписаниеОшибки = ОписаниеОшибки();
			Параметры.Отказ = Истина;
		КонецПопытки;
	#Иначе
		Параметры.Отказ = Истина;
		ОписаниеОшибки = НСтр("ru = 'Обработка регламентных заданий в
									|отдельном сеансе веб-клиента невозможна!
									|
									|Для обработки регламентных заданий, необходимо,
									|чтобы администратор настроил запуск обычного
									|или тонкого клиента на веб-сервере!'");
	#КонецЕсли
	ОписаниеОшибки = ?(ПустаяСтрока(Параметры.ОписаниеОшибки),
					   "",
					   СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ошибка открытия сеанса обработки регламентных заданий:
																						  |
																						  |%1'"), Параметры.ОписаниеОшибки));
	
КонецПроцедуры // ПопыткаОткрытьОтдельныйСеансОбработкиРегламентныхЗаданий()

////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ
//

// Процедура ПриОшибкеОбработкиРегламентныхЗаданий вызывается
// из процедуры РегламентныеЗаданияГлобальный.УведомлятьОНекорректномСостоянииОбработкиРегламентныхЗаданий()
// и РегламентныеЗаданияКлиент.ПриНачалеРаботыСистемы().
//  Вызов происходит, если обнаружено, что что-то не так в обработке регламентных заданий:
// нет сеанса обработки, "висит" сеанс, сеанс долго "не работает".
//
Процедура ПриОшибкеОбработкиРегламентныхЗаданий(ОписаниеОшибки) Экспорт
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Не обрабатываются регламентные задания!'"),
	                               ,
	                               ОписаниеОшибки,
	                               БиблиотекаКартинок.ОшибкаОбработкиРегламентныхЗаданий);
	
КонецПроцедуры

// Процедура ПодключитьГлобальныйОбработчикОжидания() применяется
// из экранных форм, т.к. в модуле формы метод переопределен.
//
Процедура ПодключитьГлобальныйОбработчикОжидания(ИмяПроцедуры, Интервал, Однократно = Ложь) Экспорт

	ПодключитьОбработчикОжидания(ИмяПроцедуры, Интервал, Однократно);
	
КонецПроцедуры

// Процедура ОтключитьГлобальныйОбработчикОжидания() применяется
// из экранных форм, т.к. в модуле формы метод переопределен.
//
Процедура ОтключитьГлобальныйОбработчикОжидания(ИмяПроцедуры) Экспорт
	
	ОтключитьОбработчикОжидания(ИмяПроцедуры);

КонецПроцедуры
