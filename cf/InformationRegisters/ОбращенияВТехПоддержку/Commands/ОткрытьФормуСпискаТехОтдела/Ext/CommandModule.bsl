﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	
	//ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("РегистрСведений.ОбращенияВТехПоддержку.Форма.ФормаСписка", Новый Структура("Отбор, ФильтрДата", Новый Структура("ОтправленоДляИзменения", Истина), Истина), ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
КонецПроцедуры
