﻿//////////////////////////////////////////////////////////////////////////////////////////
// Обработчики событий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОтборЖурналаРегистрации = Новый Структура;
	Если Параметры.Пользователь <> Неопределено Тогда
		ИмяПользователя = Параметры.Пользователь;
		ОтборПоПользователю = Новый СписокЗначений;
		ПоПользователю = ОтборПоПользователю.Добавить(ИмяПользователя);
		Если ПустаяСтрока(ИмяПользователя) Тогда
			ПоПользователю.Представление = "<Пользователь по умолчанию>";
		Иначе
			ПоПользователю.Представление = ИмяПользователя;
		КонецЕсли;
		
		ОтборЖурналаРегистрации.Вставить("Пользователь", ОтборПоПользователю);
	КонецЕсли;
	
	КоличествоПоказываемыхСобытий = 200;
	
	ПрочитатьЖурнал(ОтборЖурналаРегистрации);
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрТекущегоСобытияВОтдельномОкне()
	Данные = Элементы.Журнал.ТекущиеДанные;
	Если Данные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ФормаСобытия = ПолучитьФорму("Обработка.ЖурналРегистрации.Форма.ФормаСобытия");
	ФормаСобытия.ДатаВремя    = Данные.Дата;
	ФормаСобытия.Пользователь = Данные.ИмяПользователя;
	ФормаСобытия.Приложение   = Данные.ПредставлениеПриложения;
	ФормаСобытия.Компьютер    = Данные.Компьютер;
	ФормаСобытия.Событие      = Данные.ПредставлениеСобытия;
	ФормаСобытия.Комментарий  = Данные.Комментарий;
	ФормаСобытия.Метаданные   = Данные.ПредставлениеМетаданных;
	ФормаСобытия.Данные       = Данные.Данные;
	ФормаСобытия.ПредставлениеДанных        = Данные.ПредставлениеДанных;
	ФормаСобытия.ИдентификаторТранзакции    = Данные.Транзакция;
	ФормаСобытия.СтатусЗавершенияТранзакции = Данные.СтатусТранзакции;
	ФормаСобытия.Сеанс         = Данные.Сеанс;
	ФормаСобытия.РабочийСервер = Данные.РабочийСервер;
	ФормаСобытия.ОсновнойIPПорт        = Данные.ОсновнойIPПорт;
	ФормаСобытия.ВспомогательныйIPПорт = Данные.ВспомогательныйIPПорт;
	ФормаСобытия.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДанныеДляПросмотра()
	ТекущиеДанные = Элементы.Журнал.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Или ТекущиеДанные.Данные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ОткрытьЗначение(ТекущиеДанные.Данные);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалДатДляПросмотра()
	Диалог = Новый ДиалогРедактированияСтандартногоПериода;
	ДатаНачала    = Неопределено;
	ДатаОкончания = Неопределено;
	ОтборЖурналаРегистрации.Свойство("ДатаНачала", ДатаНачала);
	ОтборЖурналаРегистрации.Свойство("ДатаОкончания", ДатаОкончания);
	ДатаНачала    = ?(ТипЗнч(ДатаНачала)    = Тип("Дата"), ДатаНачала, '00010101000000');
	ДатаОкончания = ?(ТипЗнч(ДатаОкончания) = Тип("Дата"), ДатаОкончания, '00010101000000');
	Если ИнтервалДат.ДатаНачала <> ДатаНачала Тогда
		ИнтервалДат.ДатаНачала = ДатаНачала;
	КонецЕсли;
	Если ИнтервалДат.ДатаОкончания <> ДатаОкончания Тогда
		ИнтервалДат.ДатаОкончания = ДатаОкончания;
	КонецЕсли;
	Диалог.Период = ИнтервалДат;
	Если Диалог.Редактировать() Тогда
		ИнтервалДат = Диалог.Период;
		Если ИнтервалДат.ДатаНачала = '00010101000000' Тогда
			ОтборЖурналаРегистрации.Удалить("ДатаНачала");
		Иначе
			ОтборЖурналаРегистрации.Вставить("ДатаНачала", ИнтервалДат.ДатаНачала);
		КонецЕсли;
		Если ИнтервалДат.ДатаОкончания = '00010101000000' Тогда
			ОтборЖурналаРегистрации.Удалить("ДатаОкончания");
		Иначе
			ОтборЖурналаРегистрации.Вставить("ДатаОкончания", ИнтервалДат.ДатаОкончания);
		КонецЕсли;
		ОбновитьТекущийСписок();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьУстановитьОтбор()
	ПараметрФормы = Новый Структура("Отбор", ОтборЖурналаРегистрации);
	ФормаОтбора   = ПолучитьФорму("Обработка.ЖурналРегистрации.Форма.ОтборЖурналаРегистрации", ПараметрФормы);
	
	Если ФормаОтбора.ОткрытьМодально() = КодВозвратаДиалога.ОК Тогда
		ОтборЖурналаРегистрации = ФормаОтбора.Параметры.Отбор;
		ОбновитьТекущийСписок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьУстановитьОтборПоЗначениюВТекущейКолонке()
	Данные = Элементы.Журнал.ТекущиеДанные;
	Если Данные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИмяКолонкиПредставления = Элементы.Журнал.ТекущийЭлемент.Имя;
	Если ИмяКолонкиПредставления = "Дата" Тогда
		Возврат;
	КонецЕсли;
	ЗначениеОтбора = Данные[ИмяКолонкиПредставления];
	Представление  = Данные[ИмяКолонкиПредставления];
	
	ИмяЭлементаОтбора = ИмяКолонкиПредставления;
	Если ИмяКолонкиПредставления = "ИмяПользователя" Тогда 
		ИмяЭлементаОтбора = "Пользователь";
		ЗначениеОтбора = Данные["Пользователь"];
	ИначеЕсли ИмяКолонкиПредставления = "ПредставлениеПриложения" Тогда
		ИмяЭлементаОтбора = "ИмяПриложения";
		ЗначениеОтбора = Данные["ИмяПриложения"];
	ИначеЕсли ИмяКолонкиПредставления = "ПредставлениеСобытия" Тогда
		ИмяЭлементаОтбора = "Событие";
		ЗначениеОтбора = Данные["Событие"];
	КонецЕсли;
	
	// По пустым строкам не отбираем
	Если ТипЗнч(ЗначениеОтбора) = Тип("Строка") И ПустаяСтрока(ЗначениеОтбора) Тогда
		// Для пользователя по умолчанию имя пустое, разрешаем отбирать
		Если ИмяКолонкиПредставления <> "ИмяПользователя" Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ТекущееЗначение = Неопределено;
	Если ОтборЖурналаРегистрации.Свойство(ИмяЭлементаОтбора, ТекущееЗначение) Тогда
		// Уже установлен отбор
		ОтборЖурналаРегистрации.Удалить(ИмяЭлементаОтбора);
	Иначе
		Если ИмяЭлементаОтбора = "Данные" Или          // не списочные отборы, только 1 значение
			 ИмяЭлементаОтбора = "Комментарий" Или
			 ИмяЭлементаОтбора = "Транзакция" Или
			 ИмяЭлементаОтбора = "ПредставлениеДанных" Тогда 
			ОтборЖурналаРегистрации.Вставить(ИмяЭлементаОтбора, ЗначениеОтбора);
		Иначе
			СписокОтбора = Новый СписокЗначений;
			СписокОтбора.Добавить(ЗначениеОтбора, Представление);
			ОтборЖурналаРегистрации.Вставить(ИмяЭлементаОтбора, СписокОтбора);
		КонецЕсли;
	КонецЕсли;
	ОбновитьТекущийСписок();
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтбор()
	ОтборЖурналаРегистрации.Очистить();
	ОбновитьТекущийСписок();
КонецПроцедуры

&НаКлиенте
Процедура СписокАктивныхПользователей()
	ОткрытьФорму("Обработка.СписокАктивныхПользователей.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущийСписок() Экспорт
	ПрочитатьЖурнал(ОтборЖурналаРегистрации);
	// Позиционирование в конец списка
	Если Журнал.Количество() Тогда
		Элементы.Журнал.ТекущаяСтрока = Журнал[Журнал.Количество() - 1].ПолучитьИдентификатор();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПоказываемыхСобытийПриИзменении(Элемент)
	ОбновитьТекущийСписок();
КонецПроцедуры

&НаКлиенте
Процедура ЖурналВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.Журнал.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Поле.Имя = "Данные" Или Поле.Имя = "ПредставлениеДанных" Тогда
		Если ТекущиеДанные.Данные <> Неопределено И (Не ТекущиеДанные.Данные.Пустая()) Тогда
			ОткрытьДанныеДляПросмотра();
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ПросмотрТекущегоСобытияВОтдельномОкне();
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры

&НаСервере
Процедура ПрочитатьЖурнал(Знач ОтборЖурналаНаКлиенте)
	// Выгрузка ототборованных событий в таблицу
	Отбор = Новый Структура;
	Для Каждого ЭлементОтбора Из ОтборЖурналаНаКлиенте Цикл
		Отбор.Вставить(ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
	КонецЦикла;
	ТЗ_События = Новый ТаблицаЗначений;
	ПреобразованиеОтбора(Отбор);
	ВыгрузитьЖурналРегистрации(ТЗ_События, Отбор, , , КоличествоПоказываемыхСобытий);
	ТЗ_События.Колонки.Добавить("НомерРисунка", Новый ОписаниеТипов("Число"));
	Для Каждого Стр_ТЗ Из ТЗ_События Цикл
		Стр_ТЗ.НомерРисунка = -1;
		Если Стр_ТЗ.Уровень = УровеньЖурналаРегистрации.Информация Тогда
			Стр_ТЗ.НомерРисунка = 0;
		ИначеЕсли Стр_ТЗ.Уровень = УровеньЖурналаРегистрации.Предупреждение Тогда
			Стр_ТЗ.НомерРисунка = 1;
		ИначеЕсли Стр_ТЗ.Уровень = УровеньЖурналаРегистрации.Ошибка Тогда
			Стр_ТЗ.НомерРисунка = 2;
		КонецЕсли;
		Стр_ТЗ.Пользователь = Стр_ТЗ.ИмяПользователя;
		Если Стр_ТЗ.ИмяПользователя = "" Тогда
			Стр_ТЗ.ИмяПользователя = "<Пользователь по умолчанию>";
		КонецЕсли;
	КонецЦикла;
	
	// Преобразование в универсальный объект
	ЗначениеВРеквизитФормы(ТЗ_События, "Журнал");
	// Показать параметры отбора
	СформироватьПредставлениеОтбора();
	
КонецПроцедуры

&НаСервере
Процедура ПреобразованиеОтбора(Отбор)
	Для Каждого ЭлементОтбора Из Отбор Цикл
		Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
			ПреобразованиеЭлементаОтбора(Отбор, ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПреобразованиеЭлементаОтбора(Отбор, ЭлементОтбора)
	// Эта процедура вызывается, если элемент отбора является списком значений,
	// в отборе же должен быть массив значений. Преобразуем список в массив
	НовоеЗначение = Новый Массив;
	
	Для Каждого ЗначениеИзСписка Из ЭлементОтбора.Значение Цикл
		Если ЭлементОтбора.Ключ = "Уровень" Тогда
			// Уровни сообщений представлены строкой, требуется преобразование в значение перечисления
			Обработка = РеквизитФормыВЗначение("Объект");
			НовоеЗначение.Добавить(Обработка.УровеньЖурналаРегистрацииЗначениеПоИмени(ЗначениеИзСписка.Значение));
		ИначеЕсли ЭлементОтбора.Ключ = "СтатусТранзакции" Тогда
			// Статусы транзакций представлены строкой, требуется преобразование в значение перечисления
			Обработка = РеквизитФормыВЗначение("Объект");
			НовоеЗначение.Добавить(Обработка.СтатусТранзакцииЗаписиЖурналаРегистрацииЗначениеПоИмени(ЗначениеИзСписка.Значение));
		Иначе
			НовоеЗначение.Добавить(ЗначениеИзСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Отбор.Вставить(ЭлементОтбора.Ключ, НовоеЗначение);
КонецПроцедуры
	
&НаСервере
Процедура СформироватьПредставлениеОтбора()
	ПредставлениеОтбора = "";
	// Интервал
	ДатаНачалаИнтервала    = Неопределено;
	ДатаОкончанияИнтервала = Неопределено;
	Если Не ОтборЖурналаРегистрации.Свойство("ДатаНачала", ДатаНачалаИнтервала) Или
		 ДатаНачалаИнтервала = Неопределено Тогда 
		ДатаНачалаИнтервала    = '00010101000000';
	КонецЕсли;
	Если Не ОтборЖурналаРегистрации.Свойство("ДатаОкончания", ДатаОкончанияИнтервала) Или
		 ДатаОкончанияИнтервала = Неопределено Тогда 
		ДатаОкончанияИнтервала = '00010101000000';
	КонецЕсли;
	Если Не (ДатаНачалаИнтервала = '00010101000000' И ДатаОкончанияИнтервала = '00010101000000') Тогда
		ПредставлениеОтбора = "Интервал (";
		ПредставлениеОтбора = ПредставлениеОтбора + Формат(ДатаНачалаИнтервала,    "ДЛФ=DT; ДП='без ограничений'") + " - ";
		ПредставлениеОтбора = ПредставлениеОтбора + Формат(ДатаОкончанияИнтервала, "ДЛФ=DT; ДП='без ограничений'") + ")";
	КонецЕсли;
	
	// Остальные ограничения указываем просто по представлением, без указания значений ограничения
	Для Каждого ЭлементОтбора Из ОтборЖурналаРегистрации Цикл
		ИмяОграничения = ЭлементОтбора.Ключ;
		Если ИмяОграничения = "ДатаНачала" Или ИмяОграничения = "ДатаОкончания" Тогда
			Продолжить; // Интервал уже выводили
		КонецЕсли;
		
		// Для некоторых ограничений меняем представление
		Если ИмяОграничения = "ИмяПриложения" Тогда
			ИмяОграничения = "Приложение";
		ИначеЕсли ИмяОграничения = "СтатусТранзакции" Тогда
			ИмяОграничения = "Статус транзакции";
		ИначеЕсли ИмяОграничения = "ПредставлениеДанных" Тогда
			ИмяОграничения = "Представление данных";
		ИначеЕсли ИмяОграничения = "РабочийСервер" Тогда
			ИмяОграничения = "Рабочий сервер";
		ИначеЕсли ИмяОграничения = "ОсновнойIPПорт" Тогда
			ИмяОграничения = "Основной IP порт";
		ИначеЕсли ИмяОграничения = "ВспомогательныйIPПорт" Тогда
			ИмяОграничения = "Вспомогательный IP порт";
		КонецЕсли;
		
		Если Не ПустаяСтрока(ПредставлениеОтбора) Тогда 
			ПредставлениеОтбора = ПредставлениеОтбора + "; ";
		КонецЕсли;
		ПредставлениеОтбора = ПредставлениеОтбора + ИмяОграничения;
	КонецЦикла;
КонецПроцедуры
