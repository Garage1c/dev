﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	Если Данные.Ссылка <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		Представление = "МВЗ " + Данные.Код;
	КонецЕсли;

КонецПроцедуры
&НаСервере
Функция ПолучитьСписокОтветственных(Инициатор) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ ОтветственноеЛицо Из РегистрСведений.ОтветственныеЛица ГДЕ МВЗ = &Инициатор Упорядочить по ОтветственноеЛицо.Наименование");
	Запрос.УстановитьПараметр("Инициатор", Инициатор);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ОтветственноеЛицо");
	
КонецФункции
