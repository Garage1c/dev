﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипОсн = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипОсн = Тип("БизнесПроцессСсылка.ЗаявкаПокупателя") Тогда 
		
		ЗаказПокупателя = ДанныеЗаполнения.Заказ;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗаказПокупателя,, "Ссылка, Проведен, Дата, Номер, ПометкаУдаления");
		//ДокументОснование = ЗаказПокупателя;
		
		Запрос = Новый Запрос("ВЫБРАТЬ СуммаПриход Сумма ИЗ РегистрНакопления.ДолгиПоЗаказам.Обороты(,,,Заказ = &Заказ)");
		Запрос.УстановитьПараметр("Заказ", ЗаказПокупателя);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Сумма = Выборка.Сумма;
		КонецЕсли;
		
		СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателя; //Оплата покупателя
		СтатьяДДСБух = СтатьяДДС.СтатьяДДСБух;
		НовСтрока = РасшифровкаСуммы.Добавить();
		НовСтрока.Заказ = ЗаказПокупателя;
		НовСтрока.Сумма = Сумма;
		
		ВидОперации = Перечисления.ВидыОперацийЧекККМ.Продажа;

	ИначеЕсли 
		ТипОсн = Тип("БизнесПроцессСсылка.ИнтернетЗаявка") Тогда
		  
		ЗаказПокупателя = ДанныеЗаполнения.Заказ;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗаказПокупателя,, "Ссылка, Проведен, Дата, Номер, ПометкаУдаления");
		//ДокументОснование = ЗаказПокупателя;
		
		Запрос = Новый Запрос("ВЫБРАТЬ СуммаПриход Сумма ИЗ РегистрНакопления.ДолгиПоЗаказам.Обороты(,,,Заказ = &Заказ)");
		Запрос.УстановитьПараметр("Заказ", ЗаказПокупателя);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Сумма = Выборка.Сумма;
		КонецЕсли;
		
		СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателя; //Оплата покупателя
		СтатьяДДСБух = СтатьяДДС.СтатьяДДСБух;
		НовСтрока = РасшифровкаСуммы.Добавить();
		НовСтрока.Заказ = ЗаказПокупателя;
		НовСтрока.Сумма = Сумма;
		
		ВидОперации = Перечисления.ВидыОперацийЧекККМ.Продажа;

	ИначеЕсли
		ТипОсн = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		
		ЗаказПокупателя = ДанныеЗаполнения;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗаказПокупателя,, "Ссылка, Проведен, Дата, Номер, ПометкаУдаления");
		//ДокументОснование = ДанныеЗаполнения;
		
		Запрос = Новый Запрос("ВЫБРАТЬ СуммаПриход Сумма ИЗ РегистрНакопления.ДолгиПоЗаказам.Обороты(,,,Заказ = &Заказ)");
		Запрос.УстановитьПараметр("Заказ", ДанныеЗаполнения);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Сумма = Выборка.Сумма;
		КонецЕсли;
		
		СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателя; //Оплата покупателя
		СтатьяДДСБух = СтатьяДДС.СтатьяДДСБух;
		НовСтрока = РасшифровкаСуммы.Добавить();
		НовСтрока.Заказ = ЗаказПокупателя;
		НовСтрока.Сумма = Сумма;
		
		ВидОперации = Перечисления.ВидыОперацийЧекККМ.Продажа;

	ИначеЕсли
		ТипОсн = Тип("ДокументСсылка.ИнтернетЗаказПокупателя") Тогда
		ЗаказПокупателя = ДанныеЗаполнения;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,, "Ссылка, Проведен, Дата, Номер, ПометкаУдаления");
		//ДокументОснование = ДанныеЗаполнения;
		
		Запрос = Новый Запрос("ВЫБРАТЬ СуммаПриход Сумма ИЗ РегистрНакопления.ДолгиПоЗаказам.Обороты(,,,Заказ = &Заказ)");
		Запрос.УстановитьПараметр("Заказ", ДанныеЗаполнения);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Сумма = Выборка.Сумма;
		КонецЕсли;
		
		СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателя; //Оплата покупателя
		СтатьяДДСБух = СтатьяДДС.СтатьяДДСБух;
		НовСтрока = РасшифровкаСуммы.Добавить();
		НовСтрока.Заказ = ЗаказПокупателя;
		НовСтрока.Сумма = Сумма;
		
		ВидОперации = Перечисления.ВидыОперацийЧекККМ.Продажа;

	ИначеЕсли ТипОсн = Тип("ДокументСсылка.РеализацияТоваров") Тогда
		
		ЗаказПокупателя =  ДанныеЗаполнения.Заказ;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, , "Ссылка, Проведен, Дата, Номер, ПометкаУдаления");
		
		ДокументОснование = ДанныеЗаполнения;
		Сумма = ДанныеЗаполнения.Сумма;
		
		
		СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаОтПокупателя; //Оплата покупателя
		СтатьяДДСБух = СтатьяДДС.СтатьяДДСБух;
		НовСтрока = РасшифровкаСуммы.Добавить();
		НовСтрока.Заказ = ЗаказПокупателя;
		//23.05.2017 Андриянов Включено по требованию Радюхина для магазинов
		НовСтрока.ДокументОтгрузки = ДанныеЗаполнения;
		НовСтрока.Сумма = Сумма;
		
		ВидОперации = Перечисления.ВидыОперацийЧекККМ.Продажа;
		
	ИначеЕсли ТипОсн = Тип("ДокументСсылка.ЗаказНаряд") Тогда 
		
		ЗаказПокупателя =  ДанныеЗаполнения;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, , "Ссылка, Проведен, Дата, Номер, ПометкаУдаления");
		
		Касса = ОбщиеФункции.НастройкаПользователя("ПоУмолчанию_Касса");
		
		//ДокументОснование = ДанныеЗаполнения;
		Сумма = ДанныеЗаполнения.Сумма;
		СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("000000019");
		СтатьяДДСБух = СтатьяДДС.СтатьяДДСБух;
		НовСтрока = РасшифровкаСуммы.Добавить();
		НовСтрока.Заказ = ЗаказПокупателя;
		НовСтрока.Сумма = Сумма;
		
		ВидОперации = Перечисления.ВидыОперацийЧекККМ.Продажа;

	ИначеЕсли  ТипОсн = Тип("ДокументСсылка.ОплатаБанковскойКартой") И ДанныеЗаполнения.Проведен Тогда
		
		//ТекущаяСмена = БизнесПроцессы.ПродажаВРозницу.ПолучитьТекущуюСмену(ДанныеЗаполнения.Касса);
		//Если ТекущаяСмена = Неопределено Тогда Возврат КонецЕсли;
		//Процесс = ТекущаяСмена;
		
		ВидОперации = Перечисления.ВидыОперацийЧекККМ.Возврат;
		Основание	= ДанныеЗаполнения;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Дата, Номер, Ссылка, ПометкаУдаления, Проведен, Автор, Ответственный, ВидОперации, Основание, Процесс, ПроведеноПоККТ");
		РасшифровкаСуммы.Загрузить(ДанныеЗаполнения.РасшифровкаСуммы.Выгрузить());
		
		СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("000000014"); 
		СтатьяДДСБух = СтатьяДДС.СтатьяДДСБух;
		
	ИначеЕсли  ТипОсн = Тип("ДокументСсылка.ВозвратОтПокупателя") И ДанныеЗаполнения.Проведен Тогда
		
		ВидОперации = Перечисления.ВидыОперацийЧекККМ.Возврат;
		Основание	= ДанныеЗаполнения;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Дата, Номер, Ссылка, ПометкаУдаления, Проведен, Автор, Ответственный");
		
		СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("000000014"); 
		СтатьяДДСБух = СтатьяДДС.СтатьяДДСБух;
		
		ДокументОтгрузки=ДанныеЗаполнения.ДокументОтгрузки;
		Если ЗначениеЗаполнено(ДокументОтгрузки) тогда
			Заказ=ДокументОтгрузки.Заказ;
		Иначе
			Заказ=Неопределено;
		КонецЕсли;	
		
		НовСтрока = РасшифровкаСуммы.Добавить();
		НовСтрока.Заказ = Заказ;
		//23.05.2017 Андриянов Включено по требованию Радюхина для магазинов
		НовСтрока.ДокументОтгрузки = ДокументОтгрузки;
		НовСтрока.Сумма = Сумма;
		
		
	КонецЕсли;
	Касса = ОбщиеФункции.НастройкаПользователя("ПоУмолчанию_Касса");

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Проведение
	
	ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	
	// Запись
	
	Движения.Записать();

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

Процедура ОбработкаУдаленияПроведения(Отказ)
		
	// Подготовка

	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриОтменеПроведенияДокумента(Ссылка);
	
	// Запись
	
	Движения.ДолгиПоОтгрузкам.Очистить();
	Движения.Записать();
	
	// Установим статус оплаты
	
	Если Не Отказ Тогда
		
		Для Каждого Строка Из РасшифровкаСуммы Цикл
			Если ЗначениеЗаполнено(Строка.Заказ) Тогда
		
				Если Не Заказы.ПроверитьИУстановитьСтатусОплатыЗаказа(Строка.Заказ) Тогда
					Отказ = Истина;
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Организация <> Касса.Организация Тогда
		ОбщиеФункции.СообщитьТекст("Выбранная касса не принадлежит организации, указанной в документе");
		Отказ = Истина;
	КонецЕсли;
	

	Для Каждого Стр Из РасшифровкаСуммы Цикл
		
		Если Не ЗначениеЗаполнено(Стр.Заказ) и Не Стр.Заказ = Неопределено Тогда
			Стр.Заказ=Неопределено;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Стр.ДокументОтгрузки) и Не Стр.ДокументОтгрузки = Неопределено Тогда
			Стр.ДокументОтгрузки=Неопределено;
		КонецЕсли;
		
	КонецЦикла;		
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ОбменДанными.Загрузка Тогда
		
		ПроверяемыеРеквизиты.Добавить("Касса");
		ПроверяемыеРеквизиты.Добавить("Контрагент");
		
		Если 	РасшифровкаСуммы.Итог("Сумма") <> Сумма Тогда
			
			ОбщиеФункции.СообщитьТекст("Сумма документа не совпадает с суммой расшифровки по документам!");
			Отказ = Истина;
			
		КонецЕсли;
		
	Иначе
		ПроверяемыеРеквизиты.Очистить();
		
	КонецЕсли;
	
	
КонецПроцедуры
