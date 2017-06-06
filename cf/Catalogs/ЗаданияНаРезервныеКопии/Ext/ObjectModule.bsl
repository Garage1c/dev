﻿
Процедура ПередЗаписью(Отказ)
	
	Если Не ПометкаУдаления Тогда
	
		// Проверим чтобы пути существовал
		
		Каталог = Новый Файл(ПутьИсточник);
		Если Не Каталог.Существует() Тогда 
			Отказ = Истина; 
			МодульРезевногоКопирования.СообщитьОшибку("Не существует путь источник
															|" + ПутьИсточник, "ПутьИсточник", ЭтотОбъект); КонецЕсли;
		Каталог = Новый Файл(ПутьПриемник);
		Если Не Каталог.Существует() Тогда 
			Отказ = Истина; 
			МодульРезевногоКопирования.СообщитьОшибку("Не существует путь приемник
															|" + ПутьПриемник , "ПутьПриемник", ЭтотОбъект); КонецЕсли;
		Если Не Отказ И ПутьПриемник = ПутьИсточник Тогда
			Отказ = Истина; 
			МодульРезевногоКопирования.СообщитьОшибку("Путь источника не должен быть равен пути приемнику"); КонецЕсли;КонецЕсли;
	
	Если Не Отказ И Не ПустаяСтрока(Расписание) Тогда
		стрРасписание = Строка(ЗначениеИзСтрокиВнутр(Расписание)) КонецЕсли;
	
КонецПроцедуры
