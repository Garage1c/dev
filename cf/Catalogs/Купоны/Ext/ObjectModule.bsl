﻿
Процедура ПередЗаписью(Отказ)
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	Таблица = НайтиПоСсылкам(МассивСсылок);
	
	Если Таблица.Количество() Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Вносить изменения в купон запрещено, т.к. в информационной базе на данный объект ссылаются другие объекты";
		Сообщение.Сообщить();
	КонецЕсли;

КонецПроцедуры
