﻿
Процедура ПриЗаписи(Отказ, Замещение)
	// Отправим сайту инфу о том что товар нужно бы обновить
	
	Если 	Количество() И
			Константы.ИнтеграцияССайтом.Получить() И
			Не HTTP.ЗаписатьВсюНоменклатуруДляПередачиНаСайтИзНабора(ЭтотОбъект) Тогда
			
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

