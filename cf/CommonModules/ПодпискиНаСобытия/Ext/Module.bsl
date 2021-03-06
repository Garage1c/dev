﻿

Процедура ПриУстановкеНовогоНомераДокументаПриУстановкеНовогоНомера(Источник, СтандартнаяОбработка, Префикс) Экспорт
	
	МетаДок 	= Источник.Метаданные();
	Реквизиты 	= МетаДок.Реквизиты;
	
	Если Источник.ЭтоНовый() Тогда
		
		Начало = "ПоУмолчанию_";
		
		// Тип цен
		
		Если 	Реквизиты.Найти("ТипЦен") <> Неопределено И 
				Источник.ТипЦен.Пустая() Тогда
				
			Источник.ТипЦен = ОбщиеФункции.НастройкаПользователя(Начало + "ТипЦен"); КонецЕсли;
			   
		// Валюта
			
		Если 	Реквизиты.Найти("Валюта") <> Неопределено И 
				Источник.Валюта.Пустая() Тогда
				
			Источник.Валюта = ОбщиеФункции.НастройкаПользователя(Начало + "Валюта"); КонецЕсли; КонецЕсли;
		
	// Получим организацию
	
	//Если 	ТипЗнч(Источник) = Тип("ДокументОбъект.РеализацияТоваров") Или
	
	// Заполним реквизитами по умолчанию если это новый
	
	//Если Не ПустаяСтрока(ПараметрыСеанса.ТекущаяОбласть.Префикс) Тогда
	//	
	//	Префикс = ПараметрыСеанса.ТекущаяОбласть.Префикс;
	//	
	//Иначе
	
		Если 	Метаданные.ОбщиеРеквизиты.Организация.Состав.Найти(МетаДок).Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать И
				Не Источник.Организация.Пустая() Тогда
			
			Префикс = Источник.Организация.Префикс; КонецЕсли;// КонецЕсли;
	
КонецПроцедуры


//Процедура УстановитьОбластиИсточника(Источник)
//	
//	МетаИсточник 	= Источник.Метаданные();
//	Использовать 	= Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать;
//		
//	СоставНастройкиОбластей = Метаданные.ОбщиеРеквизиты.НастройкаОбластей.Состав.Найти(МетаИсточник);
//	СоставОбласть			= Метаданные.ОбщиеРеквизиты.Область.Состав.Найти(МетаИсточник);
//		
//	Если 	СоставНастройкиОбластей <> Неопределено И
//			СоставНастройкиОбластей.Использование = Использовать Или
//			СоставНастройкиОбластей.Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Авто Тогда
//		Источник.НастройкаОбластей = МодульОбластей.ПолучитьНастройкуНовогоОбъекта(); КонецЕсли;
//		
//	Если 	СоставОбласть <> Неопределено И
//			СоставНастройкиОбластей.Использование = Использовать Тогда
//		Источник.Область = ПараметрыСеанса.ТекущаяОбласть; КонецЕсли;
//	
//КонецПроцедуры
Процедура ПередЗаписьюДокументаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ЭтоНовый = Источник.ЭтоНовый();
	Источник.ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый);
	Источник.ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	// Установим автора
	
	Если ЭтоНовый Тогда Источник.Автор = ПараметрыСеанса.ТекущийПользователь; КонецЕсли;
	
	Если Не Источник.ОбменДанными.Загрузка Тогда
	
		// Ответвенный
		
		Если 	Источник.Ответственный.Пустая() Или 
				Не ПараметрыСеанса.КонтрольОстатковВСеансеОтключен Тогда 
			Источник.Ответственный = ПараметрыСеанса.ТекущийПользователь КонецЕсли;
		
		// Установим организацию и подразделение по правилам
		
		Если ТипЗнч(Источник) <> Тип("ДокументОбъект.ЧекККМ") 
		И ТипЗнч(Источник) <> Тип("ДокументОбъект.ПлатежноеПоручениеВходящее") тогда
			ДенежныеСредства.ПроверитьИПроставитьПодразделениеИОтдел(Источник);
		КонецЕсли;	
		
		// Проверим изменились ли реквизиты или нет
		///Установка id строки
		УстановитьИдентификаторыСтрок(Источник); КонецЕсли;
	
	Если 	Источник.ОбменДанными.Загрузка = Ложь И
			ПараметрыСеанса.СканированиеИзмененийОтключено <> Истина Тогда
		
		Если Не ЭтоНовый И Метаданные.ОпределяемыеТипы.СлежениеИзмененийОбъектовПользователями.Тип.СодержитТип(ТипЗнч(Источник.Ссылка)) Тогда
			
			ИзмененныеРеквизиты = ПротоколИзменений.ПолучитьИзмененияРеквизитов(Источник);
			Если ИзмененныеРеквизиты.Количество() Тогда
			
				Источник.ДополнительныеСвойства.Вставить("ИзмененныеРеквизиты", ИзмененныеРеквизиты); КонецЕсли; КонецЕсли; КонецЕсли;
	
	//Если ТипЗнч(Источник) = Тип("ДокументОбъект.Бюджет") тогда
	//	ОтделыПользователя=ПараметрыСеанса.Отделы;
	//	//Отказ=Истина;
	//	Если ОтделыПользователя.Найти(Источник.Отдел)<>Неопределено Тогда
	//		
	//		Запрос = Новый Запрос;
	//		Запрос.Текст = 
	//		"ВЫБРАТЬ РАЗЛИЧНЫЕ
	//		|	НастройкиДоступаБюджетирование.ОбъектДоступа
	//		|ИЗ
	//		|	РегистрСведений.НастройкиДоступаБюджетирование КАК НастройкиДоступаБюджетирование
	//		|ГДЕ
	//		|	НастройкиДоступаБюджетирование.Запись = ИСТИНА
	//		|	И НастройкиДоступаБюджетирование.ВидОбъектаДоступа = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовДоступа.Пользователи)
	//		|;
	//		|
	//		|////////////////////////////////////////////////////////////////////////////////
	//		|ВЫБРАТЬ РАЗЛИЧНЫЕ
	//		|	Отделы.Ссылка КАК ОбъектДоступа
	//		|ИЗ
	//		|	Справочник.Отделы КАК Отделы
	//		|ГДЕ
	//		|	Отделы.Ссылка В ИЕРАРХИИ
	//		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	//		|				НастройкиДоступаБюджетирование.ОбъектДоступа
	//		|			ИЗ
	//		|				РегистрСведений.НастройкиДоступаБюджетирование КАК НастройкиДоступаБюджетирование
	//		|			ГДЕ
	//		|				НастройкиДоступаБюджетирование.ВидОбъектаДоступа = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовДоступа.Отделы)
	//		|				И НастройкиДоступаБюджетирование.Запись = ИСТИНА)
	//		|;
	//		|
	//		|////////////////////////////////////////////////////////////////////////////////
	//		|ВЫБРАТЬ РАЗЛИЧНЫЕ
	//		|	НастройкиДоступаБюджетирование.ОбъектДоступа
	//		|ИЗ
	//		|	РегистрСведений.НастройкиДоступаБюджетирование КАК НастройкиДоступаБюджетирование
	//		|ГДЕ
	//		|	НастройкиДоступаБюджетирование.ВидОбъектаДоступа = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовДоступа.СтатьиБюджета)
	//		|	И НастройкиДоступаБюджетирование.Запись = ИСТИНА";
	//		
	//		МассивРезультатов = Запрос.ВыполнитьПакет();
	//		
	//		ДоступныеПользователиБюджетирование=МассивРезультатов[0].Выгрузить().ВыгрузитьКолонку("ОбъектДоступа");
	//		ДоступныеОтделыБюджетирование=МассивРезультатов[1].Выгрузить().ВыгрузитьКолонку("ОбъектДоступа");
	//		ДоступныеСтатьиБюджетаБюджетирование=МассивРезультатов[2].Выгрузить().ВыгрузитьКолонку("ОбъектДоступа");
	//		
	//		Если  ДоступныеПользователиБюджетирование.Количество()=0 Тогда
	//			Сообщить("Документ недоступен к редактрованию");
	//			Отказ=Истина;
	//			Возврат;
	//		КонецЕсли;
	//		
	//		Если  ДоступныеПользователиБюджетирование.Найти(ПараметрыСеанса.ТекущийПользователь)=Неопределено Тогда 
	//			
	//			Отказ=Истина;
	//			
	//			Список = новый СписокЗначений;
	//			Список.ЗагрузитьЗначения(ДоступныеПользователиБюджетирование);
	//			
	//			//ОтделыПользователя=ПараметрыСеанса.Отделы;
	//			
	//			// проверка на доступность отдела для записи
	//			Для Каждого ОтделПользователя Из  ОтделыПользователя Цикл
	//				Если ДоступныеОтделыБюджетирование.Найти(ОтделПользователя)<>Неопределено  Тогда
	//					Отказ=Ложь;
	//					Прервать;	
	//				КонецЕсли;
	//			Конеццикла;
	//			
	//			Если Отказ Тогда
	//				Сообщить("У пользователя нет отдела, входящего в список доступных для записи документа. Обратитесь к "+ Список);
	//			КонецЕсли;
	//			
	//			Если Не Отказ Тогда
	//				// проверка на доступность статей бюджета для записи
	//				СтатьиДок= Источник.Показатели.Выгрузить();
	//				СтатьиДок.Свернуть("СтатьяБюджета");
	//				
	//				Для каждого Строка из СтатьиДок Цикл
	//					Если ДоступныеСтатьиБюджетаБюджетирование.Найти(Строка.СтатьяБюджета)=Неопределено  Тогда
	//						Отказ=Истина;
	//						Сообщить("Статья "+Строка.СтатьяБюджета+ " недоступна для записи");
	//					КонецЕсли;
	//				КонецЦикла;	
	//			КонецЕсли;
	//			
	//			Если Отказ Тогда
	//				Сообщить("Нет прав для записи документа. Обратитесь к " + Список);
	//			КонецЕсли;
	//		КонецЕсли;
	//		
	//	Иначе
	//	    Отказ=Истина;
	//		Сообщить("Указанный  отдел не входит в список доступных. Документ не записан.");
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры
Процедура ПередЗаписьюСправочникаПередЗаписью(Источник, Отказ) Экспорт
		
	ЭтоНовый = Источник.ЭтоНовый();
	Источник.ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый);
	
	// Зададим область нового объекта в базе
	
	Если ЭтоНовый Тогда                      
	
		МетаИсточник = Источник.Метаданные();
		
		// Зададим область нового объекта в базе
		
		//УстановитьОбластиИсточника(Источник); 
	КонецЕсли;
	
	// Проверим изменились ли реквизиты или нет
	
	///Установка id строки
	УстановитьИдентификаторыСтрок(Источник);
	///
	Если 	Источник.ОбменДанными.Загрузка = Ложь И
			ПараметрыСеанса.СканированиеИзмененийОтключено <> Истина Тогда
		
		Если Не ЭтоНовый И Метаданные.ОпределяемыеТипы.СлежениеИзмененийОбъектовПользователями.Тип.СодержитТип(ТипЗнч(Источник.Ссылка)) Тогда
			
			ИзмененныеРеквизиты = ПротоколИзменений.ПолучитьИзмененияРеквизитов(Источник);
			Если ИзмененныеРеквизиты.Количество() Тогда
			
				Источник.ДополнительныеСвойства.Вставить("ИзмененныеРеквизиты", ИзмененныеРеквизиты); КонецЕсли; КонецЕсли; КонецЕсли;

КонецПроцедуры
Процедура ПередЗаписьюБППередЗаписью(Источник, Отказ) Экспорт
	
	// Установим область
	
	//УстановитьОбластиИсточника(Источник)
	
КонецПроцедуры


Процедура ПриЗаписиОбъектаПриЗаписи(Источник, Отказ) Экспорт
	
	Перем ИзмененныеРеквизиты, РежимЗаписи;
	
	ТипИсточника = ТипЗнч(Источник.Ссылка);
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	// Естьт изменения в объекте
	
	Если 	Источник.ДополнительныеСвойства.Свойство("ИзмененныеРеквизиты", ИзмененныеРеквизиты) И
			ИзмененныеРеквизиты.Количество() Тогда
			
		// Запишем изменения в регистр
		
		Если 	Метаданные.ОпределяемыеТипы.СлежениеИзмененийОбъектовПользователями.Тип.СодержитТип(ТипИсточника) И
				Не РегистрыСведений.ИсторияОбъектов.ЗаписатьИзменение(Источник.Ссылка, ИзмененныеРеквизиты) Тогда
			Отказ = Истина; КонецЕсли;
		
		// Проверим изменился ли реквизит для бумажных доках бухгалтерии
		
		Если Метаданные.ОпределяемыеТипы.РегистрацияБумажныхДокументов.Тип.СодержитТип(ТипИсточника) Тогда
			
			// Считаем его состояние
			
			Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 * ИЗ РегистрСведений.БумажныеДокументы ГДЕ Документ = &Источник И НЕ БылаКорректировка И ПервичныйДокумент");
			Запрос.УстановитьПараметр("Источник", Источник.Ссылка);
			Выполнение = Запрос.Выполнить();
			Если Не Выполнение.Пустой() Тогда
				
				Выборка = Выполнение.Выбрать();
				Выборка.Следующий();
				
				Запись = РегистрыСведений.БумажныеДокументы.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(Запись, Выборка);
				
				Запись.ДатаКорректировки 			= ТекущаяДата();
				Запись.БылаКорректировка 			= Истина;
				Запись.ПервичныйПослеКорректировки 	= Ложь;
				Запись.Ответственный 				= ПараметрыСеанса.ТекущийПользователь; 
				
			Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Запись) Тогда Отказ = Истина КонецЕсли; КонецЕсли;КонецЕсли;КонецЕсли;
			
	// Обновим кэш номенклатуры при отмене проведения
			
	Если Не Отказ И Источник.ДополнительныеСвойства.Свойство("РежимЗаписи", РежимЗаписи) Тогда
	
		Если 	РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения И
				Метаданные.ОпределяемыеТипы.ОбъектыПриЗаписиКэшируютНоменклатуру.Тип.СодержитТип(ТипИсточника) И
				Не РаботаСНоменклатурой.ОбновитьКэш(,Источник.ПолучитьТекстЗапросаПолученияСпискаТоваров(), Новый Структура("ДокументСсылка", Источник.Ссылка)) Тогда
			
			Отказ = Истина; КонецЕсли; КонецЕсли;
					
	
КонецПроцедуры
Процедура ОбработкаПроведенияОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	
	ТипИсточника = ТипЗнч(Источник.Ссылка);
	
	// Обновим кэш номенклатуры при проведения
	
	Если 	Не Отказ И
			Метаданные.ОпределяемыеТипы.ОбъектыПриЗаписиКэшируютНоменклатуру.Тип.СодержитТип(ТипИсточника) И
			Не РаботаСНоменклатурой.ОбновитьКэш(,Источник.ПолучитьТекстЗапросаПолученияСпискаТоваров(), Новый Структура("ДокументСсылка", Источник.Ссылка)) Тогда
			
		Отказ = Истина; КонецЕсли;
	
КонецПроцедуры


//Антон
Процедура УстановитьИдентификаторыСтрок(Источник)
	МетаданныеОбъекта = Источник.Метаданные();
	Отбор = Новый Структура("idстроки", "");
	Для каждого ТаблЧасть из МетаданныеОбъекта.ТабличныеЧасти Цикл
		Если ТаблЧасть.Реквизиты.Найти("idстроки") <> Неопределено Тогда
			//	
			НайденныеСтроки = Источник[ТаблЧасть.имя].найтиСтроки(Отбор);
			Для каждого Стр Из Источник[ТаблЧасть.Имя] Цикл
				Если НЕ ЗначениеЗаполнено(Стр.idстроки)Тогда 
					Стр.idстроки = Строка(Новый УникальныйИдентификатор)
				КонецЕсли; 
			КонецЦикла;
			//
		КонецЕсли;
	КонецЦИкла;
КонецПроцедуры
//Антон

// ПО САЙТУ

Функция ЭтоНовость(Источник)
	
	Если источник.ЭтоНовый() Тогда
		
		Возврат Источник.Родитель.ЭтоНовости;
		
	Иначе
		
		СсылкаСтатьи = Источник.Ссылка;
	
		Запрос = Новый Запрос("ВЫБРАТЬ ЕСТЬNULL(Родитель.ЭтоНовости, ЛОЖЬ) КАК ЭтоНовость ИЗ Справочник.ИнтернетСтатьи ГДЕ Ссылка = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", СсылкаСтатьи);
		
		Выполнение = Запрос.Выполнить();
		Если Выполнение.Пустой() Тогда
			
			Возврат Ложь;
			
		Иначе
			
			Выборка = Выполнение.Выбрать();
			Выборка.Следующий();
			Возврат Выборка.ЭтоНовость;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции


Процедура HTTP_ПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	#Если Не ВнешнееСоединение Тогда	
	ПинатьСайт = Истина;
	Если Источник.ДополнительныеСвойства.Свойство("Обновление") Тогда
		ПинатьСайт = Источник.ДополнительныеСвойства.Обновление;
	КонецЕсли;
	Если НЕ ПинатьСайт Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Источник.ОбменДанными.Загрузка Тогда
	
		ТипОбъекта 		= ТипЗнч(Источник);
		СсылкаДокумент 	= Источник.Ссылка;
		
		// Отправим в API2
		
		API2.ПередЗаписьюСправочника(Источник, ТипОбъекта, СсылкаДокумент, Отказ);
		
		Возврат; // далее не актуально
		
		// Пинаем сайт
			
		Если ТипОбъекта = Тип("ДокументОбъект.ИнтернетЗаказПокупателя") Тогда
			
			ПинатьСайт = Истина;
			Если Источник.ДополнительныеСвойства.Свойство("Обновление") Тогда
				ПинатьСайт = Источник.ДополнительныеСвойства.Обновление;
			КонецЕсли;
			
			Если НЕ ПинатьСайт Тогда
				Возврат;
			КонецЕсли;
			
			HTTP_метод = HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/orders", Истина);
			
			// ВСТАВКА КОГДА 1С ШЛЕТ НА САЙТ {
			HTTP_метод.ДобавитьТелоЗапросаОбъекта = "ПолучитьИнтернетЗаказПараметрамиHTML";
			// } ВСТАВКА КОГДА 1С ШЛЕТ НА САЙТ
            			
		ИначеЕсли 	ТипОбъекта = Тип("ДокументОбъект.ПоступлениеТоваров") Или
					ТипОбъекта = Тип("ДокументОбъект.РеализацияТоваров") Или
					ТипОбъекта = Тип("ДокументОбъект.ЧекККМ") Или
					
					ТипОбъекта = Тип("ДокументОбъект.ВозвратОтПокупателя") Или
					ТипОбъекта = Тип("ДокументОбъект.ВозвратПоставщику") Или
					ТипОбъекта = Тип("ДокументОбъект.ЗаказНаряд") Или
					ТипОбъекта = Тип("ДокументОбъект.ПлатежноеПоручениеВходящее") Или
					
					ТипОбъекта = Тип("ДокументОбъект.ОплатаЭлектроннымиДеньгами") Тогда
					
			HTTP_метод = HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/billings", Истина);
			
			// ВСТАВКА КОГДА 1С ШЛЕТ НА САЙТ {
			
			//HTTP_метод.ДобавитьТелоЗапросаОбъекта = "ПолучитьДокументВзаиморасчетовПараметрамиHTML";
			// } ВСТАВКА КОГДА 1С ШЛЕТ НА САЙТ			
			
		ИначеЕсли ТипОбъекта = Тип("ДокументОбъект.ЗаказНаряд") Тогда
					
			HTTP_метод = HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/order_services", Истина);
			
			// ВСТАВКА КОГДА 1С ШЛЕТ НА САЙТ {
			HTTP_метод.ДобавитьТелоЗапросаОбъекта = "ПолучитьЗаказНарядПараметрамиHTML";
			// } ВСТАВКА КОГДА 1С ШЛЕТ НА САЙТ			
			
		ИначеЕсли ТипОбъекта = Тип("ДокументОбъект.РедактированиеРегистра") Тогда
			
			//HTTP_метод 	= HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/products");
			//HTTP_метод.Команда = Перечисления.КомандыHTTP.PUT;
			
			Возврат;
			
		Иначе
			
			Возврат;
			
		КонецЕсли;
		
		// Добавим остальные свойства
		
		Если 	(Источник.ЭтоНовый() И Источник.Проведен ) Или          
				(Не СсылкаДокумент.Проведен И Источник.Проведен) Тогда
				                                                        
			// Новый документ
				
			HTTP_метод.Команда = Перечисления.КомандыHTTP.POST;
			
		ИначеЕсли (СсылкаДокумент.Проведен И Не Источник.Проведен) Или
					(СсылкаДокумент.Проведен И Не СсылкаДокумент.ПометкаУдаления И Источник.ПометкаУдаления) Тогда
						
			// Убился
						
			HTTP_метод.Команда = Перечисления.КомандыHTTP.DELETE;
			HTTP_метод.ДобавитьТелоЗапросаОбъекта = "";
				
		ИначеЕсли Источник.Проведен Тогда
				
			// обновление

			HTTP_метод.Команда = Перечисления.КомандыHTTP.PUT;
			
		Иначе
			
			Возврат;
				
		КонецЕсли;
		
		Источник.ДополнительныеСвойства.Вставить("HTTP_метод", HTTP_метод);
		
	КонецЕсли;
#КонецЕсли	
КонецПроцедуры

Процедура HTTP_ПередЗаписьюСправочника(Источник, Отказ) Экспорт
#Если Не ВнешнееСоединение Тогда	
	ПинатьСайт = Истина;
	Если Источник.ДополнительныеСвойства.Свойство("Обновление") Тогда
		ПинатьСайт = Источник.ДополнительныеСвойства.Обновление;
	КонецЕсли;
	Если НЕ ПинатьСайт Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Источник.ОбменДанными.Загрузка Тогда
	
		ТипОбъекта 			= ТипЗнч(Источник);
		СсылкаСправочник 	= Источник.Ссылка;
		
		// Отправим в API2
		
		API2.ПередЗаписьюСправочника(Источник, ТипОбъекта, СсылкаСправочник, Отказ);
		
		Возврат; // далее не актуально
		
		// Пинаем сайт
		
		Если ТипОбъекта = Тип("СправочникОбъект.Номенклатура") Тогда
			
			// ТОВАРЫ
			
			Если Источник.ЭтоГруппа Тогда
				//ВОЗВРАТ; // АПИ по категориям нет
				HTTP_метод 	= HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/categories");
			Иначе
				HTTP_метод 	= HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/products");
			КонецЕсли;
			
		ИначеЕсли ТипОбъекта = Тип("СправочникОбъект.ПользователиИнтернет") Тогда
			
			// ПОЛЬЗОВАТЕЛИ
			
			HTTP_метод = HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/users", Истина);
			HTTP_метод.ДобавитьТелоЗапросаОбъекта = "ПолучитьИнтернетПользователяПараметрамиHTML";
			
		ИначеЕсли ТипОбъекта = Тип("СправочникОбъект.ИнтернетСтатьи") Тогда
			
			// СТАТЬИ
			
			ЭтоНовость = ЭтоНовость(Источник);
			
			Если Источник.ЭтоГруппа И Не ЭтоНовость Тогда
				//HTTP_метод 	= HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/rubrics");
				HTTP_метод 	= HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/articles");
			ИначеЕсли ЭтоНовость Тогда
				//HTTP_метод = HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/new_items", Не Источник.ЭтоНовый(),,, Истина);
				HTTP_метод = HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/new_items",,,, Истина);
			//ИначеЕсли Источник.ВБлог Тогда
			//	HTTP_метод = HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/blog_articles",,,, Истина);
			Иначе
				HTTP_метод 	= HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/articles");
			КонецЕсли; 
			            
			// ВСТАВКА КОГДА 1С ШЛЕТ НА САЙТ {
			HTTP_метод.ДобавитьТелоЗапросаОбъекта = "ПолучитьЛюбойОбъектПараметрамиHTML";
			// } ВСТАВКА КОГДА 1С ШЛЕТ НА САЙТ			
			
		ИначеЕсли ТипОбъекта = Тип("СправочникОбъект.ИнтернетКонтакты") Тогда
			
			// КОНТАКТЫ
			
			HTTP_метод = HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/contacts");
			
			// ВСТАВКА КОГДА 1С ШЛЕТ НА САЙТ {
			HTTP_метод.ДобавитьТелоЗапросаОбъекта = "ПолучитьЛюбойОбъектПараметрамиHTML";
			// } ВСТАВКА КОГДА 1С ШЛЕТ НА САЙТ			
			
		ИначеЕсли ТипОбъекта = Тип("СправочникОбъект.Комментарии") Тогда
			
			Статья = Источник.Владелец;
			
			HTTP_метод = HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/blog/" + Строка(Статья.УникальныйИдентификатор()) + "/comment", Истина);
			HTTP_метод.ДобавитьТелоЗапросаОбъекта = "ПолучитьКомментарийПараметрамиHTML";
			  
		ИначеЕсли ТипОбъекта = Тип("СправочникОбъект.ОтзывыОТоваре") Тогда
			
			Номенклатура = Источник.Владелец;
			
			Если Не Номенклатура.Пустая() Тогда
				
				HTTP_метод = HTTP.ПолучитьСтруктуруHTTP_метода(,"/api/products/" + XMLСтрока(Номенклатура) + "/commets", Истина);
				HTTP_метод.ДобавитьТелоЗапросаОбъекта = "ПолучитьОтзывОТовареПараметрамиHTML";
				
			КонецЕсли;
			
					
		Иначе
			
			// Не извесный справочник
			
			Возврат;
			
		КонецЕсли;
		
		// Добавим остальные свойства
		
		ЕстьВыгружатьНаСайт = Источник.метаданные().Реквизиты.найти("ВыгружатьНаСайт") <> Неопределено;
		
		Если (ЕстьВыгружатьНаСайт И	Источник.ВыгружатьНаСайт И 
				(	Источник.ЭтоНовый() Или
					(ЕстьВыгружатьНаСайт И Не СсылкаСправочник.ВыгружатьНаСайт И Источник.ВыгружатьНаСайт) Или
					(СсылкаСправочник.ПометкаУдаления И Не Источник.ПометкаУдаления)
				))
				
			ИЛИ
			(Не ЕстьВыгружатьНаСайт И Источник.ЭтоНовый() Или
					(СсылкаСправочник.ПометкаУдаления И Не Источник.ПометкаУдаления)
			)Тогда
				
			// Новый справочник
				
			HTTP_метод.Команда = Перечисления.КомандыHTTP.POST;
			
		ИначеЕсли 	(ЕстьВыгружатьНаСайт И (
						(СсылкаСправочник.ВыгружатьНаСайт И Не СсылкаСправочник.ПометкаУдаления И Источник.ПометкаУдаления) Или
						(СсылкаСправочник.ВыгружатьНаСайт И не Источник.ВыгружатьНаСайт)
											)
					)
					ИЛИ 
					( Не ЕстьВыгружатьНаСайт И Не СсылкаСправочник.ПометкаУдаления И Источник.ПометкаУдаления)
						
					Тогда
						
			// Убился
						
			HTTP_метод.Команда = Перечисления.КомандыHTTP.DELETE;
				
		ИначеЕсли Не ЕстьВыгружатьНаСайт Или Источник.ВыгружатьНаСайт Тогда
				
			// обновление

			HTTP_метод.Команда = Перечисления.КомандыHTTP.PUT;
			
		Иначе
			
			Возврат;
				
		КонецЕсли;
			
		Источник.ДополнительныеСвойства.Вставить("HTTP_метод", HTTP_метод);
		
	КонецЕсли;
#КонецЕсли	
КонецПроцедуры

Процедура HTTP_ПриЗаписиОбъекта(Источник, Отказ) Экспорт
	
	#Если Не ВнешнееСоединение Тогда	  
		
	Перем HTTP_метод, API2_ЗаписатьВБуфер, APILICOTA_ЗаписатьВБуфер;
	
	//Если Источник.ДополнительныеСвойства.Свойство("HTTP_метод", HTTP_метод) Тогда
	//	
	//	СтрокаАдреса = HTTP_метод.АдресРесурса + ?(HTTP_метод.ДобавлятьГуидВАдрес, "/" + XMLСтрока(Источник.ссылка),"");
	//	СтрокаАдреса = СтрокаАдреса + ?(HTTP_метод.ЭтоТригер, ?(Прав(СтрокаАдреса,1) = "/", "","/") + "trigger","") + ".json";
	//	
	//	Если не HTTP.ДатьЗаданиеНаИзменениеСайту(
	//						Источник.Ссылка, 
	//						HTTP_метод.Команда, 
	//						СтрокаАдреса,
	//						?(HTTP_метод.ДобавитьТелоЗапросаОбъекта = "", 
	//								HTTP_метод.ТелоЗапроса, 
	//								Вычислить("HTTP." + HTTP_метод.ДобавитьТелоЗапросаОбъекта + "(Источник.Ссылка)")),//?(ТипЗнч(Источник) = Тип("ДокументОбъект.ИнтернетЗаказПокупателя"),"(Источник)", "(Источник.Ссылка)"))),
	//						HTTP_метод.ЭтоТригер)
	//						Тогда Отказ = Истина; КонецЕсли; КонецЕсли;
	// Запишем по API2
	
	
	//процедуры перенесены в фоновое задание
	
	//Если Не Отказ И Не Источник.ОбменДанными.Загрузка И Источник.ДополнительныеСвойства.Свойство("API2_ЗаписатьВБуфер", API2_ЗаписатьВБуфер) Тогда
	//	API2.ЗаписатьОбъектВБуферОтправки(Источник.Ссылка, API2_ЗаписатьВБуфер, Отказ) 
	//КонецЕсли;
	
	//Если Не Отказ И Не Источник.ОбменДанными.Загрузка И Источник.ДополнительныеСвойства.Свойство("APILICOTA_ЗаписатьВБуфер", APILICOTA_ЗаписатьВБуфер) Тогда
	//	ApiLicota.ЗаписатьОбъектВБуферОтправки(Источник.Ссылка, APILICOTA_ЗаписатьВБуфер, Отказ); 
	//КонецЕсли;
	
	
	//регистрация для обмена в фоновом задании (длительный процесс)
	Если Не Отказ И Не Источник.ОбменДанными.Загрузка Тогда
		
		
		ПараметрыФоновогоЗадания = Новый Массив;
		ПараметрыФоновогоЗадания.Добавить(Источник.Ссылка);
		ПараметрыФоновогоЗадания.Добавить(Источник.ДополнительныеСвойства);
		
		ФоновыеЗадания.Выполнить("API2.ЗаписатьНаборТоваровВБуфер_ФоновымЗаданием",
		ПараметрыФоновогоЗадания, Новый УникальныйИдентификатор, 
		"Регистрация объекта для отправки на сайт");
		
	КонецЕсли;
	
	#КонецЕсли	

КонецПроцедуры

Процедура ОбработкаПровденияПлатежногоПорученияВходящееОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ОбработкаПроведенияПлатежногоПорученияВходящееОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	
	//Если Источник.ДополнительныеСвойства.Свойство("ОплатаПоЗаказНаряду") И Источник.ДполнительныеСвойства.ОплатаПоЗаказНаряду Тогда
		
		//НомерЗаказа =  Заказ.Номер;
		//
		//НомерЗаказа   = СокрЛП(НомерЗаказа);
		//Пока Лев(НомерЗаказа, 1)="0" Цикл   	
		//	НомерЗаказа = Сред(НомерЗаказа, 2);
		//КонецЦикла;
		//
		//ТемаПисьма = Строка(Действие) +  " #" + НомерЗаказа;	
		//
		//Пользователь = Заказ.ПользовательИнтернет;
		//
		//ЗаголовокПисьма = "Здравствуйте, уважаемый(ая) " + Пользователь + "!<BR><BR>";
		//
		//ОбщиеФункции.ОповеститьПоПочте(Пользователь.ЭлектроннаяПочта, ТемаПисьма, 	ЗаголовокПисьма + 
		//																			ТелоПисьма + 
		//																			БизнесПроцессы.ИнтернетЗаявка.ПолучитьДеталиЗаказа(Заказ) + 
		//																			ПолучитьСсылкуНаСчет(Заказ) +
		//												 							КэшируемыеФункции.ПолучитьПодвалПисьма(), Ложь, Перечисления.ТипыТекстовЭлектронныхПисем.HTML);
		//
	//КонецЕсли;
	
КонецПроцедуры

Процедура ПриУстановкеНомераРеализацииПриУстановкеНовогоНомера(Источник, СтандартнаяОбработка, Префикс) Экспорт
	
	Если Источник.Организация.ЗаимствоватьНумерациюИзБухгалтерии Тогда
		
		Структура = Новый Структура("Дата, Организация");
		Структура.Дата = Источник.Дата;
		Структура.Организация 	= Новый Структура("Ссылка, Наименование", Источник.Организация, Источник.Организация.Наименование);

		Источник.Номер = HTTPсервисы.ПолучитьНомерИзБухгатерии(Структура);
		Если 	НЕ ПустаяСтрока(Источник.Номер) Тогда  СтандартнаяОбработка = Ложь;	КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписиРеализацииПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ЭтоНовый() И 
		 Источник.Организация.ЗаимствоватьНумерациюИзБухгалтерии Тогда
	
	// Подготовим документ
		
		Структура 	= Новый Структура("Представление, Ссылка, Дата, Номер, Организация, Контрагент, ПометкаУдаления, Проведен");
		
		ЗаполнитьЗначенияСвойств(Структура, Источник);
		
		Структура.Организация 	= Новый Структура("Ссылка, Наименование", Источник.Организация, Источник.Организация.Наименование);
		Структура.Контрагент 	= Новый Структура("Ссылка, Наименование", Источник.Контрагент, 	Источник.Контрагент.Наименование);
	//	Структура.Валюта 		= Новый Структура("Ссылка, Наименование", Источник.Валюта, 		Источник.Валюта.Наименование);
	
	 	HTTPсервисы.ПеренестиРеализациюВБухгалтерию(Структура);
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписьюДенежногоДокументаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ДенежныеСредства.ПроверитьИПроставитьПодразделениеИОтдел(Источник);
	
КонецПроцедуры

Процедура ПослатьСообщенияОбИзмененииЛимитов() Экспорт
	
	Справочники.СообщенияПользователям.СформироватьСообщенияОбИзмененияхЛимитов();
	
КонецПроцедуры

Процедура обм_ПередЗаписьюРегистраСведенийПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	Если ЗначениеЗаполнено(Источник.отбор.объект.значение) Тогда
	
		ОбъектИсточник = Источник.отбор.объект.значение.ПолучитьОбъект();
		Если ОбъектИсточник <> Неопределено Тогда обм_Обмен.обм_ПриЗаписиОбъектаПриЗаписи(ОбъектИсточник,Отказ); КонецЕсли;
	
	КонецЕсли;

КонецПроцедуры








