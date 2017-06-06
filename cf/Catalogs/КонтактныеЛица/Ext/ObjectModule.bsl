﻿
Процедура ПередЗаписью(Отказ)
	
	УправлениеКонтактнойИнформацией.ПередЗаписью(Ссылка, НЕ Ссылка.ПометкаУдаления И ПометкаУдаления, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	// если это новый, проверим на тип, и откажем если партнер
	Если ЭтоНовый() Тогда
		Если ТипЗнч(Владелец)= Тип("СправочникСсылка.Партнеры") Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "В качестве владельца контактного лица должен быть указан контрагент, а не партнер.";
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
