﻿
Функция ВернутьОшибку(Ответ, стрОшибки)
	
	Ответ.КодСостояния = 500;
	Ответ.УстановитьТелоИзСтроки(стрОшибки);
	
	Возврат Ответ;
	
КонецФункции

Функция ПолучитьСсылкуСправочника(Менеджер, Структура, стрОшибки = "")
	
	Ссылка = Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(Структура.Ссылка));
	Если Ссылка.ПолучитьОбъект() = Неопределено Тогда
		
		СпрОбъект = Менеджер.СоздатьЭлемент();
		СпрОбъект.Наименование = Структура.Наименование;
		Если ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(СпрОбъект,,стрОшибки, Ложь) Тогда
			Возврат СпрОбъект.Ссылка КонецЕсли;
		
	Иначе
		
		Возврат Ссылка; КонецЕсли;
	
КонецФункции

Функция ПринятьПоступлениеОтИнструментаPOST(Запрос)
	
	стрОшибки = "";
	
	Ответ = Новый HTTPСервисОтвет(200);
	ДокСтр = Запрос.ПолучитьТелоКакСтроку();
	
	Если ПустаяСтрока(ДокСтр) Тогда Возврат ВернутьОшибку(Ответ, "Нет данных документа в json формате") КонецЕсли;
	
	СтруктураДок = w1_Json.UnJSON(ДокСтр);
	Если ТипЗнч(СтруктураДок) <> Тип("Структура") Тогда Возврат ВернутьОшибку(Ответ, "Не верный тип (должно быть структура)") КонецЕсли;
	
	докМенеджер 	= Документы.ВзаиморасчетыСПоставщиком;	
	ВнешняяСсылка 	= докМенеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(СтруктураДок.Ссылка));
	НовыйОбъект 	= ВнешняяСсылка.ПолучитьОбъект();
	
	Если НовыйОбъект = Неопределено Тогда
		
		// Поищем в поступлениях, вдруг перепроводится поступление, перенесенное из Garage
			
		ВнешняяСсылкаПоступление = Документы.ПоступлениеТоваров.ПолучитьСсылку(Новый УникальныйИдентификатор(СтруктураДок.Ссылка));
		НовыйОбъект = ВнешняяСсылкаПоступление.ПолучитьОбъект();
		
		Если НовыйОбъект <> Неопределено Тогда 
			Ответ.УстановитьТелоИзСтроки("Такой документ уже есть " + ВнешняяСсылка);
			Возврат Ответ КонецЕсли;
		
		// Если это не старый документ ВзаиморасчетыСПоставщиком и не старое ПоступлениеТоваров создаем новый документ
		
		НовыйОбъект = докМенеджер.СоздатьДокумент();
		НовыйОбъект.УстановитьСсылкуНового(ВнешняяСсылка); КонецЕсли;
	
	ПереданныеОбъекты = Новый Соответствие;
	ЗаполнитьЗначенияСвойств(НовыйОбъект, СтруктураДок);
	НовыйОбъект.Дата 			= XMLЗначение(Тип("Дата"), СтруктураДок.Дата);
	
	НовыйОбъект.Организация 	= ПолучитьСсылкуСправочника(Справочники.Организации, СтруктураДок.Организация, стрОшибки);
	НовыйОбъект.Валюта 			= ПолучитьСсылкуСправочника(Справочники.Валюты, СтруктураДок.Валюта, стрОшибки);
	
	НовыйОбъект.Контрагент 		=  ПолучитьСсылкуСправочника(Справочники.Контрагенты, СтруктураДок.Контрагент, стрОшибки);
	НовыйОбъект.Партнер 		=  ?(НовыйОбъект.Контрагент = Неопределено, Неопределено, НовыйОбъект.Контрагент.Партнер);
	
	НовыйОбъект.Комментарий 	= "согласно " + СтруктураДок.Представление;
	
	РежимЗаписи = ?(НовыйОбъект.Проведен И НЕ СтруктураДок.Проведен, РежимЗаписиДокумента.ОтменаПроведения,
								?(НЕ НовыйОбъект.Проведен И НЕ СтруктураДок.Проведен, РежимЗаписиДокумента.Запись, РежимЗаписиДокумента.Проведение));
	
	Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(НовыйОбъект, РежимЗаписи, стрОшибки, Ложь) Тогда
		Возврат ВернутьОшибку(Ответ, стрОшибки) КонецЕсли;
	
	Ответ.УстановитьТелоИзСтроки("Обновлен документ " + НовыйОбъект.Ссылка);
	Возврат Ответ;
	
КонецФункции
