﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик механизма "Контактная информация"
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, Объект.Ссылка);
	
	//установить признаки создаваемого партнера по параметрам
	Если Параметры.Ключ = Справочники.Партнеры.ПустаяСсылка() Тогда
		Если Параметры.Свойство("НовыйКлиент") Тогда
			Объект.Клиент = Истина;
		КонецЕсли;
		Если Параметры.Свойство("НовыйПоставщик") Тогда
			Объект.Поставщик = Истина;
		КонецЕсли;
		Если Параметры.Свойство("НовыйКонкурент") Тогда
			Объект.Конкурент = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Установим контрагентов
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Контрагенты, "Партнер", Объект.Ссылка, Истина);
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ПользователиИнтернет, "Партнер", Объект.Ссылка, Истина);
	
	КонтактныеЛица.Параметры.УстановитьЗначениеПараметра("Владелец", Объект.Ссылка);
	
	Контрагенты.Параметры.УстановитьЗначениеПараметра("Партнер", Объект.Ссылка);
	ДокументыПартнера.Параметры.УстановитьЗначениеПараметра("Партнер", Объект.Ссылка);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	// Обработчик механизма "Контактная информация"
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект.Ссылка, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// КОНТАКТНЫЕ ЛИЦА

&НаКлиенте
Процедура КонтактныеЛицаПриАктивизацииСтроки(Элемент)
	
	//КонтактныеЛицаИнформация.Параметры.УстановитьЗначениеПараметра("Ссылка", Элементы.КонтактныеЛица.ТекущаяСтрока);
	
	Если Элементы.КонтактныеЛица.ТекущаяСтрока <> Неопределено Тогда
		КарточкаКЛ = УправлениеКонтактнойИнформацией.ПолучитьКарточкуКонтактаHTML(Элементы.КонтактныеЛица.ТекущаяСтрока, "КонтактныеЛица");
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура КонтактныеЛицаПриИзменении(Элемент)
	КарточкаКЛ = УправлениеКонтактнойИнформацией.ПолучитьКарточкуКонтактаHTML(Элементы.КонтактныеЛица.ТекущаяСтрока, "КонтактныеЛица");
КонецПроцедуры

&НаКлиенте
Процедура КонтактныеЛицаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Объект.Ссылка.Пустая() Тогда
	
	Ответ = Вопрос("Данные еще не записаны" + Символы.ПС + 
					"Переход к заполнению Контактных Лиц возможен только после записи данных" + Символы.ПС +
					"Данные будут записаны", РежимДиалогаВопрос.ОКОтмена, 0);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаписатьЭтотОбъект() Тогда
		Возврат;
	КонецЕсли;

	КонецЕсли;
	
	СтруктураПараметров = Новый Структура ("Владелец", Объект.Ссылка);	
	Форма = ПолучитьФорму("Справочник.КонтактныеЛица.Форма.ФормаЭлемента", СтруктураПараметров);
	Форма.Открыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// КОНТАКТНАЯ ИНФОРМАЦИЯ

&НаКлиенте
Процедура КонтактнаяИнформацияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	УправлениеКонтактнойИнформациейКлиент.ПриНачалеРедактирования(ЭтаФорма, Объект.Ссылка, НоваяСтрока, Копирование);

КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеНачалоВыбора(ЭтаФорма, Объект.Ссылка, Модифицированность, СтандартнаяОбработка);
	
КонецПроцедуры

Функция ЗаписатьЭтотОбъект() Экспорт
	
	Попытка
		Рез = Записать();
	Исключение
		Сообщить("Ошибка сохранения данных: " + ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;

	Возврат Рез;
	
КонецФункции
 
&НаКлиенте
Процедура КонтактнаяИнформацияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Объект.Ссылка.Пустая() Тогда
	
	Ответ = Вопрос("Данные еще не записаны" + Символы.ПС + 
					"Переход к заполнению Контактной Информации возможен только после записи данных" + Символы.ПС +
					"Данные будут записаны", РежимДиалогаВопрос.ОКОтмена, 0);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
	   Отказ = Истина; 
	   Возврат;
	КонецЕсли;
	
	Если НЕ ЗаписатьЭтотОбъект() Тогда
		Возврат;
	КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// КОНТРАГЕНТЫ

&НаКлиенте
Процедура КонтрагентыПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Контрагенты.ТекущаяСтрока <> Неопределено Тогда
		КарточкаКонтрагента = УправлениеКонтактнойИнформацией.ПолучитьКарточкуКонтактаHTML(Элементы.Контрагенты.ТекущаяСтрока, "Контрагенты");
	КонецЕсли;

КонецПроцедуры
&НаКлиенте
Процедура КонтрагентыПриИзменении(Элемент)
	КарточкаКонтрагента = УправлениеКонтактнойИнформацией.ПолучитьКарточкуКонтактаHTML(Элементы.Контрагенты.ТекущаяСтрока, "Контрагенты");
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;

	Если Объект.Ссылка.Пустая() Тогда
	
	Ответ = Вопрос("Данные еще не записаны" + Символы.ПС + 
					"Переход к заполнению Контрагентов возможен только после записи данных" + Символы.ПС +
					"Данные будут записаны", РежимДиалогаВопрос.ОКОтмена, 0);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаписатьЭтотОбъект() Тогда
		Возврат;
	КонецЕсли;
	
	КонецЕсли;

	СтруктураПараметров = Новый Структура ("Партнер", Объект.Ссылка);	
	Форма = ПолучитьФорму("Справочник.Контрагенты.Форма.ФормаЭлемента", СтруктураПараметров);
	Форма.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияПередУдалением(Элемент, Отказ)
	УправлениеКонтактнойИнформациейКлиент.ПередУдалением(ЭтаФорма, Объект.Ссылка, Отказ);
КонецПроцедуры




