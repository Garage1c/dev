﻿
Процедура ПередЗаписью(Отказ)
	// временно до помещения роли пользователь в хранилище
	Если Не РольДоступна("ПолныеПрава") ТОгда
		ОбщиеФункции.СообщитьТекст("Изменение объекта возможно только при полных правах");
		Отказ=Истина;
	КонецЕСли;	
КонецПроцедуры


