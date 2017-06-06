﻿
&НаСервере
Функция ПолучитьПользователеяИнтрнет(ФизЛицо)
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.ПользователиИнтернет ГДЕ ФизЛицо = &ФизЛицо");
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда Возврат Выборка.Ссылка; КонецЕсли;

КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПользовательИнтернет = ПолучитьПользователеяИнтрнет(ПараметрКоманды);
	Если ПользовательИнтернет <> Неопределено Тогда
	
		ОткрытьФорму("Справочник.СообщенияПользователям.ФормаСписка", 
		Новый Структура("ОтборАдресата", ПользовательИнтернет), 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
	Иначе
		ПоказатьОповещениеПользователя("Нет сообщений",,"Этот человек не имеет аккаунта на сайте", БиблиотекаКартинок.Олень); КонецЕсли;
	
КонецПроцедуры
