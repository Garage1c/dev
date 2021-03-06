﻿// ПРЕДОПРЕДЕЛЕННЫЕ ФУНКЦИИ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	
	// Проведение
	
	ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	
	// Запись
	
	Движения.Записать();

	//ПерезаполнитьДолги = ?(РасшифровкаСуммы.Количество(), 
	//				Заказы.ПерезаполнитьДолги(Таблица,, РасшифровкаСуммы[0].Заказ, РасшифровкаСуммы[0].ДокументОтгрузки),
	//				Заказы.ПерезаполнитьДолги(Таблица));
	//				
	//Если НЕ ПерезаполнитьДолги Тогда
	//	Отказ = Истина;
	//	Возврат;
	//КонецЕсли;
	
	// Контроль
	
	//Для Каждого Оплата ИЗ РасшифровкаСуммы Цикл
	//	КонтрольПроведения.ПроверитьПодтверждениеОплатПоБК(Оплата.ДокументОтгрузки, Отказ, Заголовок = "");
	//КонецЦикла;
	
	// Установим статус оплаты
	
	Если 	Не Отказ Тогда
		
		Для Каждого Строка Из РасшифровкаСуммы Цикл
			Если ЗначениеЗаполнено(Строка.Заказ) Тогда
		
				Если Не Заказы.ПроверитьИУстановитьСтатусОплатыЗаказа(Строка.Заказ) Тогда
					Отказ = Истина;
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипОсн = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипОсн = Тип("БизнесПроцессСсылка.ЗаявкаПокупателя") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения.Заказ);
		
		Номер 	= "";
		Дата 	= '00010101';
		//ДокументОснование = ДанныеЗаполнения.Заказ;
		
		Запрос = Новый Запрос("ВЫБРАТЬ СуммаПриход Сумма ИЗ РегистрНакопления.ДолгиПоЗаказам.Обороты(,,,Заказ = &Заказ)");
		Запрос.УстановитьПараметр("Заказ", ДанныеЗаполнения.Заказ);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Сумма = Выборка.Сумма;
		КонецЕсли;
		
		ВидОперации=Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя;
		СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателя; //Оплата покупателя
		СтатьяДДСБух = СтатьяДвиженияДенежныхСредств.СтатьяДДСБух;
		
		РасшифровкаСуммы.Очистить();
		НовСтрока = РасшифровкаСуммы.Добавить();
		НовСтрока.Заказ = ДанныеЗаполнения.Заказ;
		НовСтрока.Сумма = Сумма;
		
		//Заказы.ЗаполнитьТаблицуДокументаОплаты(ЭтотОбъект, Сумма, ДанныеЗаполнения.Заказ);
		
	ИначеЕсли ТипОсн = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Номер 	= "";
		Дата 	= '00010101';
		//ДокументОснование = ДанныеЗаполнения;
		
		Запрос = Новый Запрос("ВЫБРАТЬ СуммаПриход Сумма ИЗ РегистрНакопления.ДолгиПоЗаказам.Обороты(,,,Заказ = &Заказ)");
		Запрос.УстановитьПараметр("Заказ", ДанныеЗаполнения);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Сумма = Выборка.Сумма;
		КонецЕсли;
		
		ВидОперации=Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя;
		СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателя; //Оплата покупателя
		СтатьяДДСБух = СтатьяДвиженияДенежныхСредств.СтатьяДДСБух;
		
		РасшифровкаСуммы.Очистить();
		НовСтрока = РасшифровкаСуммы.Добавить();
		НовСтрока.Заказ = ДанныеЗаполнения;
		НовСтрока.Сумма = Сумма;
		//Заказы.ЗаполнитьТаблицуДокументаОплаты(ЭтотОбъект, Сумма, ДанныеЗаполнения);
		
	ИначеЕсли ТипОсн = Тип("ДокументСсылка.РеализацияТоваров") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Номер 	= "";
		Дата 	= '00010101';
		//ДокументОснование = ДанныеЗаполнения;
		Сумма = ДанныеЗаполнения.Сумма;
		
		ВидОперации=Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя;
		СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателя; //Оплата покупателя
		СтатьяДДСБух = СтатьяДвиженияДенежныхСредств.СтатьяДДСБух;
		
		РасшифровкаСуммы.Очистить();
		НовСтрока = РасшифровкаСуммы.Добавить();
		НовСтрока.Заказ = ДанныеЗаполнения.Заказ;
		//НовСтрока.ДокументОтгрузки = ДанныеЗаполнения;
		НовСтрока.Сумма = Сумма;
		//Заказы.ЗаполнитьТаблицуДокументаОплаты(ЭтотОбъект, Сумма, ,ДанныеЗаполнения);		
		
	ИначеЕсли ТипОсн = Тип("ДокументСсылка.ЗаказНаряд") Тогда 
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, , "Ссылка, Проведен, Дата, Номер, ПометкаУдаления");
		
		Номер 	= "";
		Дата 	= '00010101';
		
		Сумма = ДанныеЗаполнения.Сумма;
		
		ВидОперации=Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя;
		СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателя; //Оплата покупателя
		СтатьяДДСБух = СтатьяДвиженияДенежныхСредств.СтатьяДДСБух;
		
		РасшифровкаСуммы.Очистить();
		НовСтрока = РасшифровкаСуммы.Добавить();
		НовСтрока.Заказ = ДанныеЗаполнения;
		НовСтрока.Сумма = Сумма;

	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ОбменДанными.Загрузка Тогда
		
		Если 	Сумма И
			РасшифровкаСуммы.Количество() И 
			РасшифровкаСуммы.Итог("Сумма") <> Сумма И 
			ВидОперации <> Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПоБанковскойКарте Тогда
			
			ОбщиеФункции.СообщитьТекст("Сумма документа не совпадает с суммой расшифровки по документам отгрузки!");
			Отказ = Истина;
			
		КонецЕсли;
		
		ИндТипаЦен = ПроверяемыеРеквизиты.Найти("ТипЦен");
		Если ИндТипаЦен <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(ИндТипаЦен);
		КонецЕсли;
		
	Иначе
		ПроверяемыеРеквизиты.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	РасшифровкаСуммы.Очистить();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	СуммаВзаиморасчетов = ?(СуммаВзаиморасчетов = 0, Сумма, СуммаВзаиморасчетов);
	РасшифровкаЗаполнена = РасшифровкаСуммы.Количество();
	Для Каждого Строка ИЗ РасшифровкаСуммы Цикл Если ТипЗнч(Строка.Заказ) = Тип("ДокументСсылка.ЗаказНаряд") Тогда ДополнительныеСвойства.Вставить("ОплатаПоЗаказНаряду", Истина); Прервать; КонецЕсли; КонецЦикла;
	
	// Проставим отдел или подразделение
	//ДенежныеСредства.ПроверитьИПроставитьПодразделениеИОтдел(ЭтотОбъект);
	
	Для Каждого Стр Из РасшифровкаСуммы Цикл
		
		Если Не ЗначениеЗаполнено(Стр.Заказ) и Не Стр.Заказ = Неопределено Тогда
			Стр.Заказ=Неопределено;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Стр.ДокументОтгрузки) и Не Стр.ДокументОтгрузки = Неопределено Тогда
			Стр.ДокументОтгрузки=Неопределено;
		КонецЕсли;
		
	КонецЦикла;		
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// Отправим оповестителю о том что заказ отгружен
	
	Если Не ОбменДанными.Загрузка И Не ПараметрыСеанса.КонтрольОстатковВСеансеОтключен И Проведен Тогда
		
		// Вытащим заказы
		
		ТаблЗаказы = РасшифровкаСуммы.Выгрузить(,"Заказ, Сумма");
		ТаблЗаказы.Свернуть("Заказ", "Сумма");
		Для Каждого Строка Из ТаблЗаказы Цикл
			Если ЗначениеЗаполнено(Строка.Заказ) Тогда
				
				// Оповестим
				
				События.ЗарегистрироватьСобытие("ЗаказОплачен",
					Новый Структура("Ссылка, Инициатор, Название, КраткоеОписание, Параметры", 
						Строка.Заказ, 
						Ссылка,
						"Оплата заказа",
						"Оплачен заказ " + Строка.Заказ.Номер + " (" + Строка.Заказ.Контрагент + ") на сумму " + Строка.Сумма + " " + Валюта),
						ЭтотОбъект); КонецЕсли; КонецЦикла; КонецЕсли;
КонецПроцедуры
