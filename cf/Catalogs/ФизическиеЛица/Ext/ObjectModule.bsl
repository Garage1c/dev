﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
	   И ДанныеЗаполнения.Свойство("Наименование") Тогда
		Наименование = ДанныеЗаполнения.Наименование;
	КонецЕсли;

	// Выполним заполнение контактной информации
	//УправлениеКонтактнойИнформацией.ОбработкаЗаполненияКИ(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если Не ЭтоГруппа И Не ЭтоНовый() Тогда
		УправлениеКонтактнойИнформацией.ПередЗаписью(Ссылка, НЕ Ссылка.ПометкаУдаления И ПометкаУдаления, Отказ); КонецЕсли;
	
КонецПроцедуры
