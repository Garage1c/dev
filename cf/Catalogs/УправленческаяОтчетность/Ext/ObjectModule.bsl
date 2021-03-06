﻿
Процедура ПередЗаписью(Отказ)
	
	// Обнулив все начальные даты периода если это остатки
	
	Если Не ЭтоГруппа И ЭтоОстатки Тогда 
		ДатаНачала = '00010101';
		Для Каждого Строка Из ПредыдущиеПериоды Цикл Строка.ДатаНачала = '00010101' КонецЦикла; КонецЕсли;
		
	// Зполним параметр для копирования записей
		
	Если Не СсылкаКопирования.Пустая() Тогда
		ДополнительныеСвойства.Вставить("СсылкаКопирования", СсылкаКопирования); 
		СсылкаКопирования = Справочники.УправленческаяОтчетность.ПустаяСсылка(); КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	// Чтобы скопировать строки
	СсылкаКопирования = ОбъектКопирования.Ссылка;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ДополнительныеСвойства.Свойство("СсылкаКопирования") Тогда
		
		Клоны = Новый Соответствие;
		
		// Сделаем точно такие же строки как у объекта копиррования (если это копирование)
		
		Исключения 		= СтрРазделить("Результат,АвтоРезультат",",");	// То что заполнять не нужно
		Строки 			= Новый Массив;
		МетаРеквизиты 	= Метаданные.Справочники.ЗаписиУО.Реквизиты;
		Для КАждого МетаРекв Из МетаРеквизиты Цикл Если Исключения.Найти(МетаРекв.Имя) = Неопределено Тогда Строки.Добавить(МетаРекв.Имя) КонецЕсли; КонецЦикла;
		
		Запрос = Новый Запрос("ВЫБРАТЬ Ссылка, Код, Родитель, " + СтрСоединить(Строки, ",") + " ИЗ Справочник.ЗаписиУО ГДЕ Владелец = &Владелец И Не ПометкаУдаления УПОРЯДОЧИТЬ ПО Ссылка Иерархия");
		Запрос.УстановитьПараметр("Владелец", ДополнительныеСвойства.СсылкаКопирования);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НовСпр = Справочники.ЗаписиУО.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(НовСпр, Выборка);
			НовСпр.Владелец = Ссылка;
			НовСпр.Родитель = Клоны[Выборка.Родитель];
			
			Если ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(НовСпр) Тогда
				Клоны.Вставить(Выборка.Ссылка, НовСпр.Ссылка);
			Иначе
				Отказ = Истина;
				Прервать; КонецЕсли; КонецЦикла; КонецЕсли;
	
КонецПроцедуры
