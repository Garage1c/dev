﻿
&НаСервере
Функция Установить(Строка, Ссылки)
	
	Возврат РегистрыСведений.БумажныеДокументы.УстановитьГалки(Ссылки,,,Строка);
	
КонецФункции
&НаСервере
Функция ВозможноеПримечание(Ссылки)
	
	Запрос = Новый Запрос("ВЫБРАТЬ МАКСИМУМ(Примечание) Примечание ИЗ РегистрСведений.БумажныеДокументы ГДЕ Документ В(&Ссылки)");
	Запрос.УстановитьПараметр("Ссылки", Ссылки);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		Возврат Выборка.Примечание;
		
	Иначе
		
		Возврат "" КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВводПримечания(Строка, Параметры) Экспорт
	
	Если Строка <> Неопределено Тогда 
		Если Установить(Строка, Параметры.Ссылки) Тогда
			
			Если Параметры.Источник.Элементы.Найти("Список") <> Неопределено Тогда
				Параметры.Источник.Элементы.Список.Обновить() КонецЕсли;
			
			ИхМного = Параметры.Ссылки.Количество() > 1;
			ПоказатьОповещениеПользователя("Отметка документов",,"Установлен" + ?(ИхМного, "ы","о") + " примечани" + ?(ИхМного, "и","е"), БиблиотекаКартинок.Бухгалтерия) КонецЕсли; КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПоказатьВводСтроки(
			Новый ОписаниеОповещения("ВводПримечания", ЭтотОбъект, 
				Новый Структура("Источник, Ссылки", ПараметрыВыполненияКоманды.Источник, ПараметрКоманды)), 
			ВозможноеПримечание(ПараметрКоманды), 
			"Примечание", 128);
	
КонецПроцедуры
