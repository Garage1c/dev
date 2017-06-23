﻿Функция ПолучитьСкладСписания() Экспорт Возврат Склад КонецФункции
Функция ПолучитьТекстЗапросаПолученияСпискаТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура
	|ИЗ
	|	Документ.РеализацияТоваров.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка
	|";
	
КонецФункции
Функция ПолучитьТекстЗапросаПолученияСпискаТоваровВЯчейках() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура
	|ИЗ
	|	Документ.РеализацияТоваров.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка И
	|	Ячейка <> &ПустаяЯчейка
	|";
	
КонецФункции
Функция ПолучитьТекстЗапросаПолученияСпискаРезервируемыхТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура
	|ИЗ
	|	Документ.РеализацияТоваров.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка И
	//|	Размещение.Наименование <> """" И   //кто и зачем сделал это условие ???
	|	Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|";
	
КонецФункции

Функция ПолучитьТекстЗапросаПолученияСпискаЗаказов() Экспорт
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Заказ
	|ИЗ
	|	Документ.РеализацияТоваров.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка
	|";
	
КонецФункции

// ПРЕДОПРЕДЕЛЕННЫЕ ФУНКЦИИ

Процедура ПриЗаписи(Отказ)
	
	// Отправим оповестителю о том что заказ отгружен
	
	Если Не ОбменДанными.Загрузка И Не ПараметрыСеанса.КонтрольОстатковВСеансеОтключен И  ЗначениеЗаполнено(Заказ) И Проведен Тогда
		
		События.ЗарегистрироватьСобытие("ОтгруженЗаказКлиенту",
			Новый Структура("Ссылка, Инициатор, Место, Название, КраткоеОписание, Параметры", 
					Заказ, 
					Ссылка,
					Строка(Склад),
					"Отгрузка заказа",
					"Отгружен заказ " + Заказ.Номер + " (" + Контрагент + ") на сумму " + Сумма + " " + Валюта),
					ЭтотОбъект); КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	// Если отгрузка запрещена тогда проводить не будет если это оперативное проведение
	
	Если 	РежимПроведения = РежимПроведенияДокумента.Оперативный И
			//Не CRM.КлиентуРазрешенаОтгрузка(Контрагент, Организация) Тогда
			Не CRM.ПартнеруРазрешенаОтгрузка(Контрагент) Тогда
		ОбщиеФункции.СообщитьТекст("Отгрузка клиенту запрещена!");
		
		Если Не (РольДоступна("ПолныеПрава") ИЛИ РольДоступна("ПолныеПраваВОбласти")) Тогда 
			Отказ = Истина; 
			Возврат; КонецЕсли; КонецЕсли;
	
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Последовательности
	
	//avdonin {{12.09.2010#
	ПроведенияДокументов.ПоследовательностьОстаткиТоваров(ДополнительныеСвойства, ПринадлежностьПоследовательностям, Отказ);
	//}}avdonin
	
	// Проведение
	
	ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	                                     
	// Запись
	Движения.ТоварыВРезерве.ДополнительныеСвойства.Вставить("НеРегистрироватьДляВыгрузкиНаСайт",Истина);
	
	Движения.Записать();
	
	// Контроль
	
	КонтрольПроведения.ПроверитьПоВсемРегистрам(ЭтотОбъект, Отказ, Заголовок);
	
	//Если Не РольДоступна("ПолныеПрава") Тогда
	
	//НеКонтролироватьПроведение = Ложь;
	//ДополнительныеСвойства.Свойство("НеКонтролироватьПроведение", НеКонтролироватьПроведение);
	//Если НеКонтролироватьПроведение <> ИСТИНА Тогда
	//	
	//	КонтрольПроведения.ПроверитьТоварыВИнтернетЗаказе(ЭтотОбъект, Отказ, Заголовок);
	//		
	//	//avdonin {{21.09.2010#
	//	//
	//	
	//	Если РежимПроведения = РежимПроведенияДокумента.Оперативный Тогда
	//		КонтрольПроведения.ПроверитьТоварыНаСкладах(ЭтотОбъект, Склад, Отказ, Заголовок, Заказ);
	//	Иначе
	//		КонтрольПроведения.ПроверитьТоварыНаСкладахНЕОперативно(ЭтотОбъект, Отказ, Заголовок);
	//	КонецЕсли;
	//
	//	//}}avdonin
	//	
	//	Если Не Отказ Тогда
	//		КонтрольПроведения.ПроверитьТоварыВЯчейках(ЭтотОбъект, Склад, Отказ, Заголовок);
	//	КонецЕсли;
	//		
	//КонецЕсли;
	////КонецЕсли;
	//
	//// Проверим партии
	//КонтрольПроведения.ПроверитьПартииТоваров(ЭтотОбъект, Склад, Отказ, Заголовок);
	
	// Установим статус оплаты заказа
	
	Если 	Не Отказ И
			Не Заказы.ПроверитьИУстановитьСтатусОплатыЗаказа(Заказ) Тогда
			
		Отказ = Истина;
			
	КонецЕсли;
	
	// в очередь на отправку
	 
	Запись = РегистрыСведений.ОтправкаЗаказов.СоздатьМенеджерЗаписи();
		
	Запись.Заказ 			= Заказ;
	Запись.Отправлен 		= Ложь;
	
	Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Запись) Тогда Отказ = Истина КонецЕсли;
		
	// Обновим журнал заказа
	
	Если Не Заказы.ОбновитьРеквизитыЖурнала(Заказ) Тогда Отказ = Истина КонецЕсли;
		
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка

	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриОтменеПроведенияДокумента(Ссылка);
	
	//avdonin {{12.09.2010#
	// надо опять инициализировать доп. свойства для контроля остатка (чтобы тянуть информацию только по тем остаткам, которые изменялись)
	// в контроле по идее имеет смысл указывать, что это отмена проведения или передавать движения
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	//}}avdonin
	
	// Последовательности
	
	//avdonin {{12.09.2010#
	// последний параметр - признак отмены проведения
	ПроведенияДокументов.ПоследовательностьОстаткиТоваров(ДополнительныеСвойства, ПринадлежностьПоследовательностям, Отказ, Истина);
	//}}avdonin
	
	// Запись
	
	Движения.ТоварыНаСкладах.Очистить();
	Движения.Записать();
	
	// Контроль
	
	КонтрольПроведения.ПроверитьПоВсемРегистрам(ЭтотОбъект, Отказ, Заголовок);
	
	//КонтрольПроведения.ПроверитьТоварыНаСкладах(ЭтотОбъект, Склад, Отказ, Заголовок);
	//
	////avdonin {{22.09.2010#
	//// выше правда делается оперативный контроль
	//КонтрольПроведения.ПроверитьТоварыНаСкладахНЕОперативно(ЭтотОбъект, Отказ, Заголовок, Истина);
	////}}avdonin
	
	// удалить из очереди отправку
	 
	Запись = РегистрыСведений.ОтправкаЗаказов.СоздатьМенеджерЗаписи();
	Запись.Заказ = Заказ;
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		
		Попытка
			Запись.Удалить();
		Исключение
				
			ОпОшибки = ОписаниеОшибки();
			ОбщиеФункции.СообщитьТекст("Ошибка при записи состояния заказа
								|" + ОпОшибки);
			Отказ = Истина;
				
		КонецПопытки;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Сумма = Товары.Итог("Сумма") + ?(СуммаВключаетНДС,0,Товары.Итог("СуммаНДС"));
	СуммаАванса = ПлатежныеДокументы.Итог("Сумма");
	                 
	// Установим подразделение
	
	Если Подразделение.Пустая() Тогда
		
		Если 	Не Контрагент.ОсновнойМенеджер.Пустая() И
				Не Контрагент.ОсновнойМенеджер.Подразделение.Пустая() Тогда
				
			Подразделение = Контрагент.ОсновнойМенеджер.Подразделение;
			
		ИначеЕсли Не Склад.Подразделение.Пустая() Тогда
			
		Подразделение = Склад.Подразделение; КонецЕсли; КонецЕсли;
	                               
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанных = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанных = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ 
		|	Ссылка Заказ, Контрагент, Склад, ТипЦен, Валюта, СуммаВключаетНДС,
		|   Товары.(
		|		Номенклатура,
		|		Упаковка,
		|		Количество,
		|		Цена,
		|		Сумма,
		|		ПроцентРучнойСкидки,
		|		СуммаРучнойСкидки,
		|		СтавкаНДС,
		|		СуммаНДС,
		|		&Заказ КАК Заказ)
		|ИЗ
		|	Документ.ЗаказПокупателя
		|ГДЕ
		|	Ссылка = &Заказ
		|");
		
		Запрос.УстановитьПараметр("Заказ", ДанныеЗаполнения);
		ВыборкаШапки = Запрос.Выполнить().Выбрать();
		Если ВыборкаШапки.Следующий() Тогда
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапки);
			Товары.Загрузить(ВыборкаШапки.Товары.Выгрузить());
			
		КонецЕсли;
		
	ИначеЕсли ТипДанных = Тип("ДокументСсылка.ЗаказНаряд") Тогда
		
		// пока будем проверять, может уже есть реализация для этого З-Н
		
		Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Документ.РеализацияТоваров ГДЕ Заказ = &ЗаказНаряд");
		Запрос.УстановитьПараметр("ЗаказНаряд", ДанныеЗаполнения);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЭтотОбъект.Комментарий = "Отказаться от записи. Для """ + Строка(ДанныеЗаполнения) + """ уже создана """ + Строка(Выборка.Ссылка) + """";
            Возврат;
		КонецЕсли;
			
		Запрос = Новый Запрос("
		|ВЫБРАТЬ 	НомерСтроки - 1 ИндексСтрокиНоменклатуры, СтавкаНДС, ЦенаЗаЧас, Гарантия
		|ПОМЕСТИТЬ 	ТабНДС
		|ИЗ 		Документ.ЗаказНаряд.Товары
		|ГДЕ 		Ссылка = &Заказ
		|;
		|ВЫБРАТЬ 
		|	Ссылка Заказ,
		|	Контрагент, 
		|	Склад, 
		|	ТипЦен, 
		|	Валюта, 
		|	СуммаВключаетНДС, 
		|	УчитыватьНДС, 
		|	БанковскийСчетОрганизации,
		|	БанковскийСчетПартнера,
		|	Организация,
		|	Плательщик,
		|	Подразделение
		|ИЗ
		|	Документ.ЗаказНаряд
		|ГДЕ
		|	Ссылка = &Заказ
		|;
		|ВЫБРАТЬ
		|	Номенклатура,
		|	СУММА(Количество) 	Количество,
		|	Цена,
		|	СУММА(Сумма)		Сумма,
		|	Зап.Ссылка 			Заказ,
		|	ВЫБОР КОГДА НЕ Зап.Ссылка.БезРезерва ТОГДА Зап.Ссылка.Склад ИНАЧЕ NULL КОНЕЦ Размещение,
		|	СтавкаНДС 			СтавкаНДС
		|ИЗ
		|	Документ.ЗаказНаряд.Запчасти Зап
		|
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	(ВЫБРАТЬ ИндексСтрокиНоменклатуры, СтавкаНДС, Гарантия ИЗ ТабНДС) НДС
		|ПО
		|	Зап.ИндексСтрокиНоменклатуры = НДС.ИндексСтрокиНоменклатуры
		|
		|ГДЕ
		|	Ссылка = &Заказ И НЕ НДС.Гарантия
		|
		|СГРУППИРОВАТЬ ПО
		|	Зап.Ссылка,
		|	Зап.Ссылка.Склад,
		|	Номенклатура,
		|	Цена,
		|	СтавкаНДС
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|
		//|ВЫБРАТЬ
		//|	Номенклатура,
		//|	СУММА(Количество) Количество,
		//|	ЦенаЗаЧас,
		//|	СУММА(Сумма) Сумма,
		//|	NULL,
		//|	NULL,
		//|	СтавкаНДС СтавкаНДС
		//|ИЗ
		//|	Документ.ЗаказНаряд.Работы Зап
		//|
		//|ЛЕВОЕ СОЕДИНЕНИЕ
		//|	(ВЫБРАТЬ ИндексСтрокиНоменклатуры, СтавкаНДС, ЦенаЗаЧас, Гарантия ИЗ ТабНДС) НДС
		//|ПО
		//|	Зап.ИндексСтрокиНоменклатуры = НДС.ИндексСтрокиНоменклатуры
		//|
		//|ГДЕ
		//|	Ссылка = &Заказ И НЕ НДС.Гарантия
		//|
		//|СГРУППИРОВАТЬ ПО
		//|	Номенклатура,
		//|	ЦенаЗаЧас,
		//|	СтавкаНДС
		|ВЫБРАТЬ
		|	Ссылка.Услуга 		Номенклатура, 
		|	СУММА(Количество) 	Количество,
		|	ВЫБОР КОГДА СУММА(Количество) > 0 ТОГДА
		|		СУММА(Сумма)/СУММА(Количество)
		|	ИНАЧЕ
		|		0
		|	КОНЕЦ 				Цена,
		|	СУММА(Сумма) 		Сумма,
		|	Зап.Ссылка 			Заказ,
		|	NULL,
		|	СтавкаНДС 			СтавкаНДС
		|ИЗ
		|	Документ.ЗаказНаряд.Работы Зап
		|
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	(ВЫБРАТЬ ИндексСтрокиНоменклатуры, СтавкаНДС, ЦенаЗаЧас, Гарантия ИЗ ТабНДС) НДС
		|ПО
		|	Зап.ИндексСтрокиНоменклатуры = НДС.ИндексСтрокиНоменклатуры
		|
		|ГДЕ
		|	Ссылка = &Заказ И НЕ НДС.Гарантия
		|
		|СГРУППИРОВАТЬ ПО
		|	Ссылка,
		//|	Номенклатура,
		//|	ЦенаЗаЧас,
		|	СтавкаНДС
		|");
		
		Запрос.УстановитьПараметр("Заказ", ДанныеЗаполнения);
		Пакет = Запрос.ВыполнитьПакет();
		
		ВыборкаШапки = Пакет[1].Выбрать();
		Если ВыборкаШапки.Следующий() Тогда
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапки);
			
		КонецЕсли;
		
		// Загрузим товары
		
		СтруктураКолонокТовары = Новый Структура("ЕстьПроцентРучнойСкидки, ЕстьПроцентАвтоматическойСкидки, ТипЦен, Валюта, Контрагент, ЕстьАкция, ЕстьЦенаПоАкции, ЕстьУпаковка, ЕстьКоличество, ЕстьЦена, ЕстьСуммаБезСкидки, ЕстьСумма, ЕстьСуммаАвтоматическойСкидки, ЕстьСуммаРучнойСкидки, ЕстьСтавкаНДС, ЕстьСуммаНДС, СуммаВключаетНДС, ЕстьВсего",
												 Истина, Истина, ТипЦен, Валюта, Контрагент, Истина, Ложь, Истина, Истина, Истина, Истина, Истина, Истина, Истина, Истина, Истина, Истина, Ложь);
		Товары.Загрузить(Пакет[2].Выгрузить());
		
		Для Каждого Строка Из Товары Цикл ФункцииФормДокументов.РассчитатьСуммыСтрокиОтЦены(Строка, СтруктураКолонокТовары, Ложь) КонецЦикла;
			
			//ФункцииФормДокументов.РассчитатьСуммыТабличныхЧастей(Строка, СтруктураКолонокТовары);
			
		//КонецЦикла;
		
	ИначеЕсли ТипДанных = Тип("БизнесПроцессСсылка.РемонтИнструмента") Тогда
		
		ОбработкаЗаполнения(ДанныеЗаполнения.ЗаказНаряд, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//Если 	Сумма И
	//		ПлатежныеДокументы.Количество() И 
	//		ПлатежныеДокументы.Итог("Сумма") > Сумма Тогда
	//		
	//	ОбщиеФункции.СообщитьТекст("Сумма аванса превышает сумму документа!");
	//	Отказ = Истина;
	//		
	//КонецЕсли;
	                                           
	ПроверяемыеРеквизиты.Добавить("Контрагент");
	
	//Если 	Склад.Ячеестый И
	//		Документы.РеализацияТоваров.БизнесПроцесс(Ссылка).Пустая() И
	//		Не РольДоступна("ПолныеПрава") Тогда
	//	
	//	ПроверяемыеРеквизиты.Добавить("Товары.Ячейка");
	//		
	//КонецЕсли;
	
	Если  РаботаСНоменклатурой.ПроверитьНомерГТД(?(этоНовый(),ТекущаяДата(),Ссылка.Дата),Товары) Тогда
		
		ОбщиеФункции.СообщитьТекст("Номер ГТД, указанный в документе, не соответствует дате отгрузки товаров. Проверьте номера ГТД!");
		Отказ = Истина;
			
	КонецЕсли;

	
КонецПроцедуры

// ОПЛАТА

Процедура ЗаполнитьДокументыОплаты(СсылкаРеализации = Неопределено) Экспорт
	
	//это дополнительный механизм привязки ПП к реализациям. Предназначен исключительнео для графы "К платежно расчетному документу " в счете-фактуре
	//больше ни для чего не используется. Предоставляет примерные данные и может не совпадать с данными регистра "Долги по отгрузкам"
	
	//выбираем не привязанные оплаты по заказу или привязанные к данной отгрузке, которые прошли раньше отгрузки
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДолгиПоОтгрузкам.Регистратор КАК ДокументОплаты,
		|	ДолгиПоОтгрузкам.Период КАК Дата,
		|	ДолгиПоОтгрузкам.Сумма
		|ИЗ
		|	РегистрНакопления.ДолгиПоОтгрузкам КАК ДолгиПоОтгрузкам
		|ГДЕ
		|	ДолгиПоОтгрузкам.Контрагент = &Контрагент
		|	И ДолгиПоОтгрузкам.Заказ = &Заказ
		|	И ДолгиПоОтгрузкам.ДокументОтгрузки = НЕОПРЕДЕЛЕНО
		|	И ДолгиПоОтгрузкам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|	И ДолгиПоОтгрузкам.Период <=&ДатаДок
		|
		|объединить все
		|
		|ВЫБРАТЬ
		|	ДолгиПоОтгрузкам.Регистратор КАК ДокументОплаты,
		|	ДолгиПоОтгрузкам.Период КАК Дата,
		|	ДолгиПоОтгрузкам.Сумма
		|ИЗ
		|	РегистрНакопления.ДолгиПоОтгрузкам КАК ДолгиПоОтгрузкам
		|ГДЕ
		|	ДолгиПоОтгрузкам.Контрагент = &Контрагент
		|	И ДолгиПоОтгрузкам.Заказ = &Заказ
		|	И ДолгиПоОтгрузкам.ДокументОтгрузки = &Реализация
		|	И ДолгиПоОтгрузкам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|	И ДолгиПоОтгрузкам.Период <=&ДатаДок"
		);

	Запрос.УстановитьПараметр("ДатаДок", 		Дата);
	Запрос.УстановитьПараметр("Контрагент", 		Контрагент);
	Запрос.УстановитьПараметр("Заказ", 		Заказ);
	Запрос.УстановитьПараметр("Реализация", 		?(СсылкаРеализации=Неопределено,Ссылка, СсылкаРеализации));
	
	УстановитьПривилегированныйРежим(Истина);
	Нужно = Сумма;
	ПлатежныеДокументы.Очистить();
	ДобавитьВОплаты(Запрос.Выполнить().Выбрать(), Нужно);
	УстановитьПривилегированныйРежим(Ложь);
	
	
КонецПроцедуры
Процедура ДобавитьВОплаты(Выборка, Нужно)
	
	Пока Выборка.Следующий() Цикл
		
		Берем = Мин(Нужно, Выборка.Сумма);
		Если Берем Тогда
			ЗаполнитьЗначенияСвойств(ПлатежныеДокументы.Добавить(), Выборка);
		КонецЕсли;
		
		Нужно = Нужно - берем;
		
	КонецЦикла;
	
КонецПроцедуры


