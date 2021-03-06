﻿
Функция ПолучитьЗаказ(Задача)
	
	Заказ = Задача.БизнесПроцесс.Заказ;
	
	Если Заказ = Неопределено Тогда
		Заказ = Задача.БизнесПроцесс.ВедущаяЗадача.Заказ;
	КонецЕсли;
	
	Возврат Заказ;
	
КонецФункции

Процедура УстановитьЗадачеРеквизитыПоУмолчанию(ФормируемыеЗадачи)
	
	Для Каждого Задача Из ФормируемыеЗадачи Цикл
		
		Задача.Наименование = ПредставлениеЗадачи(Задача);
		Задача.Склад 		= Ссылка.Склад;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанных = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанных = Тип("Структура") Тогда
		
		КонвертацияТипов.ЗаполнитьОбъектПоСтруктуреОснованию(ЭтотОбъект, ДанныеЗаполнения);
		
	ИначеЕсли ТипДанных = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		
		Заказ 	= ДанныеЗаполнения;
		Склад 	= ДанныеЗаполнения.Склад;
		
	ИначеЕсли ТипДанных = Тип("ДокументСсылка.ВнутреннийЗаказ") Тогда
		
		Заказ = ДанныеЗаполнения;
		Склад = ДанныеЗаполнения.Склад;
		
	КонецЕсли; 
	
КонецПроцедуры

 
// СТАНДАРТНЫЙ ИНТЕРФЕЙС

Процедура ЗавершениеПриЗавершенииПлохо(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	Если Не Заказы.УстановитьСостояниеЗаказа(Заказ, Перечисления.СостоянияЗаказа.ВРаботе) Тогда Отказ = Истина КонецЕсли;
	
	// Установим время передачи заказа менеджеру для корректировки
	
	Запись = РегистрыСведений.ОчередьСборкиПриПередачеЛогисту.СоздатьМенеджерЗаписи();
	Запись.Заказ = Заказ;
	Запись.Прочитать();
	
	Запись.Заказ 					= Заказ;
	Запись.ДатаВозвратуМенеджеру 	= ТекущаяДата();

	Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Запись) Тогда Отказ = Истина КонецЕсли;
	
КонецПроцедуры
Процедура ЗавершениеПриЗавершенииХорошо(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	Если ТипЗнч(Заказ) = Тип("ДокументСсылка.ВнутреннийЗаказ") Тогда
		
		Заказы.УстановитьСостояниеЗаказа(Заказ, Перечисления.СостоянияЗаказа.Отгружен);
		
	КонецЕсли;
	
КонецПроцедуры

// ВСПОМОГАТЕЛЬНЫЕ

Функция ПредставлениеЗадачи(Задача)
	
	Возврат ФункцииБизнесПроцессов.ПредставлениеЗадачиПоЗаказу(Задача, Заказ);
	
КонецФункции  

// КОРРЕКТИРОВКА

Процедура СкорректироватьЗаказПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	Если ТипЗнч(ВедущаяЗадача.БизнесПроцесс) <> Тип("БизнесПроцессСсылка.СборкаЗаказа") Или ВедущаяЗадача.БизнесПроцесс.Завершен Тогда
		
		//+Андриянов 11.05.2017 меняем проверку Заказы.ЗаказЧастичноСобран на новую Заказы.ЗаказБылВСборке, так как ЧастичноСобран отвечает на другой вопрос
		Заказы.УстановитьСостояниеЗаказа(Заказ, Перечисления.СостоянияЗаказа[?(Заказы.ЗаказБылВСборке(Ссылка),"ВОчередиНаСкладПовторно","ВОчередиНаСклад")]); КонецЕсли;
	 УстановитьЗадачеРеквизитыПоУмолчанию(ФормируемыеЗадачи);
	 
	 // Установим параллельность
	 
	 Если ПараметрыСеанса.УстановитьПараллельныйПризнак Тогда
	 	Для Каждого Задача Из ФормируемыеЗадачи Цикл Задача.Параллельная = Истина КонецЦикла;
	 	ПараметрыСеанса.УстановитьПараллельныйПризнак = Ложь; КонецЕсли;
	
	// Установим время последнего отчета // отключим ожидание заказа
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Истина ИЗ РегистрСведений.ОчередьСборкиПриПередачеЛогисту ГДЕ Заказ = &Заказ"); Запрос.УстановитьПараметр("Заказ", Заказ);
	Если Запрос.Выполнить().Пустой() Тогда
		
		// Запишем регистр
				
		Запись = РегистрыСведений.ОчередьСборкиПриПередачеЛогисту.СоздатьМенеджерЗаписи();
		Запись.Заказ 		= Заказ;
		Запись.ДатаОтсчета 	= ТекущаяДата();
			
		Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Запись) Тогда
			Отказ = Истина; КонецЕсли;КонецЕсли;
		
КонецПроцедуры
Процедура СкорректироватьЗаказОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	// Проверим есть ли неразмещенные товары
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Представление(Номенклатура) Номенклатура
	|ИЗ
	|	РегистрНакопления.ЗаказыПокупателей.Остатки(,ЗаказПокупателя = &Заказ)
	|ГДЕ
	|	Размещение = &ПустойСклад
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Представление(Номенклатура) Номенклатура
	|ИЗ
	|	РегистрНакопления.ИнтернетЗаказПокупателя.Остатки(,ИнтернетЗаказ = &Заказ)
	|ГДЕ
	|	Размещение = &ПустойСклад
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Представление(Номенклатура) Номенклатура
	|ИЗ
	|	РегистрНакопления.ВнутренниеЗаказы.Остатки(,ВнутреннийЗаказ = &Заказ)
	|ГДЕ
	|	Размещение = &ПустойСклад
	|");
	
	Запрос.УстановитьПараметр("Заказ", 			Заказ);
	Запрос.УстановитьПараметр("ПустойСклад", 	Справочники.Склады.ПустаяСсылка());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Результат = Ложь;
		ОбщиеФункции.СообщитьТекст("Не размещен """ + Выборка.Номенклатура + """");
		
	КонецЦикла;
	
КонецПроцедуры


// РЕАЛИЗАЦИЯ

Функция СоздатьИПровестиРеализацию(Задача)
	
	Если Заказ.СпособРазмещенияБезЗаказа Тогда // По новому
			
			ТоварыЗаказа 	= Заказы.ПолучитьТаблицуТоваровПоЗаказуСРаставленнымСостоянием(Ссылка,Заказ,,ТипЗнч(Заказ) <> Тип("ДокументСсылка.ВнутреннийЗаказ"));
			Товары 			= КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(ТоварыЗаказа, Новый Структура("Состояние", Перечисления.СостояниеСборкиЗаказа.Собрано));
			
	Иначе // По старому
	
		Товары = Заказы.ПолучитьТоварыПоСтатусу(
						Задача.БизнесПроцесс, 
						ТекущаяДата(), 
						Перечисления.СостояниеСборкиЗаказа.Собрано); КонецЕсли;
						
	Если Товары.Количество() Тогда
		
		// Убираем временно контроль оплаты, они там не могут разобраться нужен он или нет
					
		//Если Заказ.РозничнаяЗаявка Тогда
		//	
		//	ПараметрыРозница = Новый Массив;
		//	Если НЕ Заказы.ЗаказОплачен(Заказ, ПараметрыРозница, Товары.Итог("Сумма")) Тогда
		//		ОбщиеФункции.СообщитьТекст("Заказ не оплачен, поэтому не может быть отгружен");	Возврат Ложь; КонецЕсли;КонецЕсли; 	
	

		// Определим источник
	
		Заказ = ПолучитьЗаказ(Задача);
		
		ЭтоПередача = Склад.ПередачаТовараМВЗ ИЛИ НЕ Заказ.МВЗ.Пустая() ИЛИ Заказ.ПередачаТовара;
		Если ЭтоПередача Тогда
			
			Реализация = Документы.ПередачаТовара.СоздатьДокумент();
			Реализация.ОтветственноеЛицо = Заказ.ОтветственноеЛицо;
			Реализация.МВЗ = Заказ.МВЗ;
			
		Иначе
			
			// Определим источник
	
			Реализация = Документы.РеализацияТоваров.СоздатьДокумент();КонецЕсли;
		
	    Реализация.СниматьРезервИзШапки = Заказ.СпособРазмещенияБезЗаказа; 
		Реализация.Дата	= ТекущаяДата();
		
		// Забъем реквизиты по запросу
		
		СтруктураШапки = Заказы.ПолучитьРеквизитыЗаказаДляЗаполненияШапкиДокумента(Заказ);
		ЗаполнитьЗначенияСвойств(Реализация, СтруктураШапки);
		
		// Загрузим таблицу для закрытия сборки
		
		Реализация.СобранныеТовары.Загрузить(Заказы.ПолучитьТаблицуСобранныхТоваров(Заказ, СтруктураШапки.Склад));
		
		// Если Розничная заявка
		
		//Если Заказ.РозничнаяЗаявка И ПараметрыРозница <> Неопределено Тогда
		//	Для Каждого Парам ИЗ ПараметрыРозница Цикл
		//		НовСтрока = Реализация.ПлатежныеДокументы.Добавить();
		//		НовСтрока.ДокументОплаты = Парам.ДокументОплаты;
		//		НовСтрока.Сумма = Парам.Сумма;
		//	КонецЦикла;
		//КонецЕсли;
	
		
		// Вытащим товары
		
		ТипыЗаказа = Новый Массив;
		ТипыЗаказа.Добавить(ТипЗнч(Заказ));
		Товары.Колонки.Добавить("Заказ", Новый ОписаниеТипов(ТипыЗаказа));
		Товары.ЗаполнитьЗначения(Заказ, "Заказ");
		
		Товары.Колонки.Добавить("НомерГТД", Новый ОписаниеТипов("СправочникСсылка.НомераГТД"));
		Заказы.ПроставитьНомерГТД(Товары);

		//Товары.Колонки.СкладЯчейка.Имя = "Размещение";
		Если Не Заказ.СпособРазмещенияБезЗаказа Тогда
			Товары.Колонки.Склад.Имя = "Размещение";
			Товары.Колонки.СкладЯчейка.Имя = "СкладЯчейкаСборки";
			Товары.ЗаполнитьЗначения(Справочники.Ячейки.ПустаяСсылка(), "Ячейка"); КонецЕсли;
			Реализация.Товары.Загрузить(Товары);
		
		// Установим заказ который еще не может быть прочитан
		
		Реализация.ДополнительныеСвойства.Вставить("ОперативныйЗаказ", Заказ);
		
		// Запишем чтобы ссылку получить
		
		Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Реализация, РежимЗаписиДокумента.Запись) Тогда
			Возврат Ложь; КонецЕсли;
		
		// Заполним оплаты
		
		Реализация.ДополнительныеСвойства.Вставить("НеРазноситьПартии", Истина); // ПередЗаписью партии разнеслись, запомним это
		
		Если НЕ ЭтоПередача И НЕ Заказ.РозничнаяЗаявка Тогда
			Реализация.ЗаполнитьДокументыОплаты(Реализация.Ссылка); КонецЕсли;
	
		Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Реализация, РежимЗаписиДокумента.Проведение) Тогда
			Возврат Ложь; КонецЕсли;
		
		Если Не БизнесПроцессы.ДоставкаЗаказа.СоздатьНовыйБП(Заказ,Реализация.Ссылка) Тогда Возврат Ложь КонецЕсли;

		// УСтановим ию в текущий процесс
	
		РеализацияТоваров = Реализация.Ссылка; КонецЕсли;
	
	Возврат Истина;
	
КонецФункции
Процедура ОтгрузитьЗаказПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	текСостояние = Заказы.ПолучитьСостояниеЗаказа(Задача.БизнесПроцесс.Заказ);
	Если текСостояние <> Перечисления.СостоянияЗаказа.ВОчередиНаСклад Тогда
		Если Не СоздатьИПровестиРеализацию(Задача) Тогда Отказ = Истина КонецЕсли КонецЕсли;
		
	// Если отработала тогда запишем текущий процесс и его реализацию
	
	Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(ЭтотОбъект) Тогда
		Отказ = Истина; КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры
Процедура ОтгрузитьЗаказПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	Если 	Не Отказ И 
			Не Заказы.УстановитьСостояниеЗаказа(
							Заказ, 
							Перечисления.СостоянияЗаказа[
								?(Заказы.ЗаказЧастичноСобран(Ссылка),
													"СобранЧастично",
													"Собран")]) Тогда Отказ = Истина; Возврат; КонецЕсли;
	
	УстановитьЗадачеРеквизитыПоУмолчанию(ФормируемыеЗадачи);

КонецПроцедуры


// УСЛОВИЯ

Процедура ВернутьМенеджеруПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = Заказы.ПолучитьСостояниеЗаказа(Заказ) = Перечисления.СостоянияЗаказа.ВРаботе;
	
КонецПроцедуры
Функция ЗаказОтгруженПолностью()
	
	// Если нет товаров значит все собрали
	
	СостоянияТоваров = Заказы.ПолучитьСостояниеТоваров(Ссылка,,,Ложь);
	Возврат 
		СостоянияТоваров.НайтиСтроки(Новый Структура("Состояние", Перечисления.СостояниеСборкиЗаказа.Отгружен )).Количество() +
		СостоянияТоваров.НайтиСтроки(Новый Структура("Состояние", Перечисления.СостояниеСборкиЗаказа.Отправлен)).Количество() +
		СостоянияТоваров.НайтиСтроки(Новый Структура("Состояние", Перечисления.СостояниеСборкиЗаказа.Доставлен)).Количество() = СостоянияТоваров.Количество();
	
КонецФункции
Процедура Условие_ЗаказСобранПолностьюПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	// Только в состоянии "собран" может быть передан на отгрузку
	
	РазрешенноеСостояние 	= Перечисления.СостояниеСборкиЗаказа.Собрано;
	Товары 					= Заказы.ПолучитьСостояниеТоваров(Ссылка,,, Ложь);
	Результат 				= Истина;
	
	Для Каждого Строка Из Товары Цикл Если Строка.Состояние <> РазрешенноеСостояние Тогда Результат = Ложь; Возврат; КонецЕсли; КонецЦикла;
	
КонецПроцедуры

Процедура ЛогистрПередумалПриОтгрузке(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = Заказы.ПолучитьСостояниеЗаказа(Заказ) = Перечисления.СостоянияЗаказа.ВОчередиНаСклад;
	
КонецПроцедуры

// КОРРЕКТИРОВКА ЛОГИСТОВ

Процедура ЗафиксироватьВремяСборкиОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	// Установим время продажи
	
	Запись = РегистрыСведений.ОчередьСборкиПриПередачеЛогисту.СоздатьМенеджерЗаписи();
	Запись.Заказ = Заказ;
	Запись.Прочитать();
	
	// Запишем
	
	Если ЗначениеЗаполнено(Запись.Заказ) Тогда
		Запись.ДатаСборки = ТекущаяДата();
		ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Запись); КонецЕсли;
	
КонецПроцедуры
Процедура ОтменитьВремяСборкиОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	// Установим время продажи
	
	Запись = РегистрыСведений.ОчередьСборкиПриПередачеЛогисту.СоздатьМенеджерЗаписи();
	Запись.Заказ = Заказ;
	Запись.Прочитать();
	
	// Запишем
	
	Если ЗначениеЗаполнено(Запись.Заказ) Тогда
		Запись.ДатаСборки = '00010101';
		ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Запись); КонецЕсли;
	
КонецПроцедуры


Процедура УстановитьСтатусОтгруженОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	Заказы.УстановитьСостояниеЗаказа(Заказ, Перечисления.СостоянияЗаказа.Отгружен);
	
КонецПроцедуры
Процедура УстановитьСтатусВОчередиНаСборкуОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	Заказы.УстановитьСостояниеЗаказа(Заказ, Перечисления.СостоянияЗаказа.ВОчередиНаСборку);
	
КонецПроцедуры


Процедура ЗаказОтгруженУсловие(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = ЗаказОтгруженПолностью();
	
КонецПроцедуры

Процедура МимоЛогистаПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Рузультат = Истина;
	
КонецПроцедуры

Процедура СоздатьСборкуОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	ТабТов = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(
				Заказы.ПолучитьСостояниеТоваров(Заказ),
				Новый Структура("Состояние", Перечисления.СостояниеСборкиЗаказа.НеСобрано));
				
	СкладПолучатель = ?(ТипЗнч(Заказ) = Тип("ДокументСсылка.ВнутреннийЗаказ"), Заказ.Заказчик, Склад);
	Если Не БизнесПроцессы.СборкаЗаказа.СформироватьИПровестиСборкуИперемещения(Заказ, Ссылка, СкладПолучатель, ТабТов) Тогда
		ВызватьИсключение "Ошибка при создании сборки минуя логиста "; КонецЕсли;	
	
	// Установим признак параллельности чтобы следующий БП сбросил
	
	ПараметрыСеанса.УстановитьПараллельныйПризнак = Истина;

КонецПроцедуры
