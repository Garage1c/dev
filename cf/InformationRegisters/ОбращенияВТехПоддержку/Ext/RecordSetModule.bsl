﻿
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Для каждого Эл Из ЭтотОбъект Цикл
		Если Эл.ОтправленоДляИзменения Тогда
	        ПроверяемыеРеквизиты.Добавить("ТипЗаявки");
			Если Эл.Выполнено Тогда
				ПроверяемыеРеквизиты.Добавить("Комментарий");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
