﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	GUID = Объект.Ссылка.УникальныйИдентификатор();
	УправлениеВидимостью();
КонецПроцедуры
&НаСервере
Процедура УправлениеВидимостью()
	Элементы.ФизЛицо.Видимость = (Объект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо) ИЛИ (Объект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицоНеРезидент);	
	
	Элементы.ТипЦен.Видимость = Объект.Контрагент.Пустая();
	Если НЕ Объект.Контрагент.Пустая() Тогда
		Элементы.ТипЦенПартнера.Заголовок = "Тип цен: " + Объект.Контрагент.ТипЦен + " (из Контрагента)";
	КонецЕсли;
	Элементы.ТипЦенПартнера.Видимость = НЕ Объект.Партнер.Пустая();
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоПриИзменении(Элемент)
	УправлениеВидимостью();
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	УправлениеВидимостью();
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	УправлениеВидимостью();
КонецПроцедуры

&НаСервере
Функция НайтиПользователяПоEmail()
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.ПользователиИнтернет ГДЕ ЭлектроннаяПочта = &Почта И Ссылка <> &Ссылка");
	Запрос.УстановитьПараметр("Почта", Объект.ЭлектроннаяПочта);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат Выборка.Следующий();
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ФлагЗаписи") И ПараметрыЗаписи.ФлагЗаписи Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() И НайтиПользователяПоEmail() Тогда
		
		ОП = Новый ОписаниеОповещения("ЗавершениеДиалогаЗаписи", ЭтаФорма, Отказ);
		
		ПоказатьВопрос(ОП, "Пользователь с таким E-mail уже существует, выполнить запись?", РежимДиалогаВопрос.ДаНет);
		
		Отказ = Истина;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеДиалогаЗаписи(Результат, Отказ) Экспорт
    Если Результат = КодВозвратаДиалога.Да Тогда
		Записать(Новый Структура("ФлагЗаписи", Истина));
	КонецЕсли;
КонецПроцедуры



