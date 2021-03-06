﻿
&НаСервере
Функция ПолучитьПользователейИнтрнет(ФизЛица)
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.ПользователиИнтернет ГДЕ ФизЛицо В(&ФизЛица)");
	Запрос.УстановитьПараметр("ФизЛица", ФизЛица);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");

КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПользователиИнтернет = ПолучитьПользователейИнтрнет(ПараметрКоманды);
	Если ПользователиИнтернет.Количество() Тогда
	
		ОткрытьФорму("Справочник.СообщенияПользователям.ФормаОбъекта", 
			Новый Структура("Основание", ПоместитьВоВременноеХранилище(ПользователиИнтернет)), 
			ПараметрыВыполненияКоманды.Источник, 
			ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, 
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	Иначе
		ПоказатьОповещениеПользователя("Не кому послать сообщения",,"Выбранные пользователи не относятся к интрнет пользователям", БиблиотекаКартинок.Олень); КонецЕсли;
	
КонецПроцедуры
