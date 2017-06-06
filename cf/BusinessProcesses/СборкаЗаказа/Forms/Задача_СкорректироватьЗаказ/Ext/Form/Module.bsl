﻿
&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;

&НаКлиенте
Перем МассивКомментариев Экспорт;
&НаКлиенте
Перем 	мСостояниеНеСобран,
		мСостояниеСобирается,
		мСостояниеСобрано,
		мСостояниеОжидаетПеремещения;

#Область Формирование_документов

&НаСервере
Функция СформироватьИПровестиСборкуИперемещения()
	
	//Отказ=Ложь;
	СкладПолучатель = ?(ТипЗнч(Заказ) = Тип("ДокументСсылка.ВнутреннийЗаказ"), Заказ.Заказчик, Заказ.Склад);
	
	//// Получим что отправляют в сборки
	//
	Таблица = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(
							Товары.Выгрузить(),
							Новый Структура("Состояние", Перечисления.СостояниеСборкиЗаказа.НеСобрано));
							
	//// разобъем их по складам
	//						
	//ТаблРазмещений = КонвертацияТипов.ПолучитьНесколькоТаблицПоПолюРазделителю(Таблица, "Размещение", "ЗначениеЗаполнено(Строка.Размещение)");
	//
	//НачатьТранзакцию();
	//
	//Если ТаблРазмещений.Количество() Тогда
	//
	//	// Создадим таблицу по строкам размещениям строкам
	//	
	//	Для Каждого ТабРазмещения Из ТаблРазмещений Цикл
	//		
	//		СкладРазмещения = ТабРазмещения[0].Размещение;
	//		Если ЗначениеЗаполнено(СкладРазмещения) Тогда
	//			
	//			Если Не БизнесПроцессы.СборкаЗаказа.СоздатьСборку(
	//						Новый Структура("Шапка, Товары, ТоварыАлгоритм", 
	//							Новый Структура("Заказ, Склад", Заказ, СкладРазмещения), 
	//							ТабРазмещения, 
	//							"НовСтрока.ВСборке = Строка.Количество"),
	//						СкладПолучатель = СкладРазмещения) Тогда
	//				ОтменитьТранзакцию();
	//				Возврат Ложь; КонецЕсли; КонецЕсли; КонецЦикла;
	//			
	//	//создадим перемещеиня по маршрутам
	//	
	//	Справочники.Маршруты.СоздатьПеремещенияПоПервымЭтапамМаршрутов(таблРазмещений,СкладПолучатель,Заказ,Объект.БизнесПроцесс,Отказ);
	//	Если Отказ Тогда
	//		ОтменитьТранзакцию();
	//		Возврат Ложь; КонецЕсли; КонецЕсли;
	
	НачатьТранзакцию();
	
	Если Не БизнесПроцессы.СборкаЗаказа.СформироватьИПровестиСборкуИперемещения(Заказ, Объект.БизнесПроцесс, СкладПолучатель, Таблица) Тогда
		ОтменитьТранзакцию();
		Возврат Ложь; КонецЕсли;
	
	// Установим признак параллельности чтобы следующий БП сбросил
	
	ПараметрыСеанса.УстановитьПараллельныйПризнак = Истина;
	
	// Выполним текущую задачу и установим статус заказа.
	
	Если 	Заказы.УстановитьСостояниеЗаказа(Заказ, Перечисления.СостоянияЗаказа.ВОчередиНаСборку) И 
			Не Записать(Новый Структура("ВыполнитьЗадачу", Истина)) Тогда
		ОтменитьТранзакцию();
		Возврат Ложь; КонецЕсли;
		
	// Все закругляемся
	
	ЗафиксироватьТранзакцию();

	Возврат Истина;
	
КонецФункции
&НаСервере
Функция СоздатьИПровестиРеализацию(ТолькоВыделенные)
	
	//ТаблицаОтгрузки = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(//Товары.Выгрузить(), 
	//						Заказы.ПолучитьТаблицуТоваровПоЗаказуСРаставленнымСостоянием(Объект.БизнесПроцесс, Заказ,, ТипЗнч(Заказ) <> Тип("ДокументСсылка.ВнутреннийЗаказ")),
	//						Новый Структура("Состояние", 
	//							Перечисления.СостояниеСборкиЗаказа.Собрано));
	//							
	//Если ТолькоВыделенные Тогда // Удалим лишнии строки
	//	
	//	
	//	
	//КонецЕсли;
									
	
	ТаблицаОтгрузки = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(//Товары.Выгрузить(), 
							Заказы.ПолучитьТаблицуТоваровПоЗаказуСРаставленнымСостоянием(Объект.БизнесПроцесс, Заказ,, ТипЗнч(Заказ) <> Тип("ДокументСсылка.ВнутреннийЗаказ")),
							Новый Структура("Состояние", 
								Перечисления.СостояниеСборкиЗаказа.Собрано));
						
	Если ТаблицаОтгрузки.Количество() Тогда
		
		// Определим источник
		
		ЭтоПередача = Объект.Склад.ПередачаТовараМВЗ ИЛИ НЕ Заказ.МВЗ.Пустая() ИЛИ Заказ.ПередачаТовара;
		Если ЭтоПередача Тогда
			НовРеализация = Документы.ПередачаТовара.СоздатьДокумент();
			НовРеализация.МВЗ = Заказ.МВЗ;
			НовРеализация.ОтветственноеЛицо = Заказ.ОтветственноеЛицо;
			
		Иначе
			// Определим источник
	
			НовРеализация = Документы.РеализацияТоваров.СоздатьДокумент(); КонецЕсли;

	    НовРеализация.СниматьРезервИзШапки = Заказ.СпособРазмещенияБезЗаказа; 
		НовРеализация.Дата	= ТекущаяДата();
		
		// Забъем реквизиты по запросу
		
		СтруктураШапки = Заказы.ПолучитьРеквизитыЗаказаДляЗаполненияШапкиДокумента(Заказ);
		ЗаполнитьЗначенияСвойств(НовРеализация, СтруктураШапки);
		
		// Загрузим таблицу для закрытия сборки
		
		НовРеализация.СобранныеТовары.Загрузить(Заказы.ПолучитьТаблицуСобранныхТоваров(Заказ, СтруктураШапки.Склад));
				
		// Если Розничная заявка
		
		//Если  Заказ.РозничнаяЗаявка И ПараметрыРозница <> Неопределено Тогда
		//	Для Каждого Парам ИЗ ПараметрыРозница Цикл
		//		НовСтрока = НовРеализация.ПлатежныеДокументы.Добавить();
		//		НовСтрока.ДокументОплаты = Парам.ДокументОплаты;
		//		НовСтрока.Сумма = Парам.Сумма;
		//	КонецЦикла;
		//КонецЕсли;
		
		// Вытащим товары
		
		ТипыЗаказа = Новый Массив;
		ТипыЗаказа.Добавить(ТипЗнч(Заказ));
		ТаблицаОтгрузки.Колонки.Добавить("Заказ", Новый ОписаниеТипов(ТипыЗаказа));
		ТаблицаОтгрузки.ЗаполнитьЗначения(Заказ, "Заказ");
		
		ТаблицаОтгрузки.Колонки.Добавить("НомерГТД", Новый ОписаниеТипов("СправочникСсылка.НомераГТД"));
		Заказы.ПроставитьНомерГТД(ТаблицаОтгрузки);
		
		//ТаблицаОтгрузки.Колонки.Склад.Имя = "Размещение";
		
		НовРеализация.Товары.Загрузить(ТаблицаОтгрузки);
						
		Если Не НовРеализация.ПроверитьЗаполнение() Тогда
			Отказ = Истина;
			Возврат Ложь; КонецЕсли;
		
		НовРеализация.ДополнительныеСвойства.Вставить("ОперативныйЗаказ", Заказ);
		
		// Запишем чтобы ссылку получить
		
		Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(НовРеализация, РежимЗаписиДокумента.Запись,,Истина) Тогда
			Возврат Ложь; КонецЕсли;
		
		новРеализацияСсылка = НовРеализация.Ссылка;
		
		// Заполним оплаты
		Если НЕ ЭтоПередача И НЕ Заказ.РозничнаяЗаявка Тогда
			НовРеализация.ЗаполнитьДокументыОплаты(НовРеализация.Ссылка); КонецЕсли;
		
		// Установим заказ который еще не может быть прочитан
		Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(НовРеализация, РежимЗаписиДокумента.Проведение,,Истина) Тогда
			Возврат Ложь; КонецЕсли;
			
		Если Не БизнесПроцессы.ДоставкаЗаказа.СоздатьНовыйБП(Заказ,НовРеализация.Ссылка) Тогда Возврат Ложь КонецЕсли;
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь; КонецЕсли;
	
КонецФункции
&НаСервере
Функция СоздатьПровестиЧастичноеПеремещениеИОтправитьЕгоВСборку()
	
	ТаблицаОтгрузки = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(
							Товары.Выгрузить(), 
							Новый Структура("Состояние", 
								Перечисления.СостояниеСборкиЗаказа.Собрано));
					
	ТипыЗаказа = Новый Массив;
	ТипыЗаказа.Добавить(ТипЗнч(Заказ));
	ТаблицаОтгрузки.Колонки.Добавить("ДокументРезерва", Новый ОписаниеТипов(ТипыЗаказа));
	ТаблицаОтгрузки.ЗаполнитьЗначения(Заказ, "ДокументРезерва");
					
								
	Если ТаблицаОтгрузки.Количество() Тогда
		
		Маршруты = Товары.Выгрузить().Свернуть("Маршрут,Размещение");
		
		НачатьТранзакцию();
		
		//цикл по маршрутам
		Для Каждого Маршрут из Маршруты Цикл
			
			Этапы = Справочники.Маршруты.ПолучитьТабЭтапов(Маршрут.Размещение,Заказ.Заказчик,Маршрут.Маршрут);			
			
			//цикл по этапам маршрута
			Для Каждого Этап из Этапы Цикл
				
				// Создадим процесс
				
				НовПроцесс = БизнесПроцессы.ПеремещениеТоваров.СоздатьБизнесПроцесс();
				НовПроцесс.Дата = ТекущаяДата();
				НовПроцесс.СкладОтправитель = Этап.СкладОтправитель;
				НовПроцесс.СкладПолучатель 	= Этап.СкладПолучатель;
				НовПроцесс.Маршрут			= Маршрут;
				НовПроцесс.Заказчик 		= Объект.БизнесПроцесс;
				НовПроцесс.ЗаказСобран 		= Истина;
				НовПроцесс.Стартован		= ИСтина;
				
				Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(НовПроцесс) Тогда
					ОтменитьТранзакцию();
					Возврат Ложь;
				КонецЕсли;
				
				// Создадим задачу приема
				
				Задача = Задачи.ЗадачаПользователю.СоздатьЗадачу();
				Задача.Наименование		= "Принять товар по внутреннему заказу №" + Заказ.Номер + " от " + Формат(Заказ.Дата,"ДФ=dd.MM.yyyy");
				Задача.Дата 			= ТекущаяДата();
				Задача.БизнесПроцесс 	= НовПроцесс.Ссылка;
				Задача.ТочкаМаршрута 	= БизнесПроцессы.ПеремещениеТоваров.ТочкиМаршрута.ПринятьТовар;
				Задача.Склад 			= Заказ.Заказчик;
				Задача.Роль 			= Справочники.Роли.Кладовщик;
				
				Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Задача) Тогда
					ОтменитьТранзакцию();
					Возврат Ложь;
				КонецЕсли;
				
				// Создадим документ отгрузки					
				
				НовДок = Документы.ОтгрузкаТоваров.СоздатьДокумент();
				НовДок.Дата				= ТекущаяДата();
				НовДок.Процесс 			= НовПроцесс.Ссылка;
				НовДок.СкладОтправитель = Этап.СкладОтправитель;
				НовДок.СкладПолучатель 	= Этап.СкладПолучатель;
				НовДок.Маршрут			= Маршрут;
				
				// Забъем реквизиты по запросу
				
				СтруктураШапки = Заказы.ПолучитьРеквизитыЗаказаДляЗаполненияШапкиДокумента(Заказ);
				ЗаполнитьЗначенияСвойств(НовДок, СтруктураШапки);
				
				// Вытащим товары
				// с фильтром по размещению
                Отбор = Новый Структура("Размещение",Маршрут.Размещение);
				СтрокиПоРазмещению = ТаблицаОтгрузки.НайтиСтроки(Отбор);
				Для Каждого Стр из СтрокиПоРазмещению Цикл
					НовСтр=НовДок.Товары.Добавить();
					ЗаполнитьЗначенияСвойств(НовСтр,Стр);
				КонецЦикла;	
				
				
				Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(НовДок, РежимЗаписиДокумента.Проведение) Тогда
					ОтменитьТранзакцию();
					Возврат Ложь; 
				КонецЕсли;
				
				
				//конец цикла по этапам маршрута
			КонецЦикла;
			
			//конец цикла по маршрутам
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		Возврат Истина;
		
	Иначе
		
		ОбщиеФункции.СообщитьТекст("Нет товара для отгрузки");
		Возврат Ложь; 
	КонецЕсли;
	
КонецФункции
&НаСервере
Процедура ДополнитьТаблицуКорректировки(ТаблицаКорректировки, ТаблицаОсновная, ТаблицаСравнения, Коэфф, СтруктураПоиска)
	
	Для Каждого Строка Из ТаблицаОсновная Цикл ЗаполнитьЗначенияСвойств(СтруктураПоиска, Строка); Если Не ТаблицаСравнения.НайтиСтроки(СтруктураПоиска).Количество() Тогда СтрокаКорректировки = ТаблицаКорректировки.Добавить(); ЗаполнитьЗначенияСвойств(СтрокаКорректировки, Строка); СтрокаКорректировки.Количество = Строка.Количество * Коэфф; КонецЕсли; КонецЦикла;
	
КонецПроцедуры

//Функция ЕстьОткрытыйБПСборкиТовара()
//	
//	// Определяет есть или нет БП сборки товара по текущим реквизитам (Заказ, Склад)
//	
//	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 ИСТИНА ИЗ БизнесПроцесс.СборкаТовара ГДЕ Заказ = &Заказ И Склад = &Склад И НЕ Завершен");
//	Запрос.УстановитьПараметр("Заказ", Заказ);
//	Запрос.УстановитьПараметр("Склад", Объект.Склад);
//	
//	Возврат Не Запрос.Выполнить().Пустой();
//	
//КонецФункции

#КонецОбласти

#Область Вспомогательные

Функция ПолучитьСписокДоступныхСкладовПоНоменклатуре(Номенклатура)
	
	Возврат РаботаСНоменклатурой.ПолучитьОстаткиПоСкладам(Номенклатура).ВыгрузитьКолонку("Склад");
	
КонецФункции

&НаСервере
Функция УстановитьСостояниеИВыполнитьЗадачу(ИмяСостояния, Отгрузить = Ложь, ТолькоВыделенные = Ложь)
	
	Если Заказы.УстановитьСостояниеЗаказа(Заказ, Перечисления.СостоянияЗаказа[ИмяСостояния]) Тогда
			Возврат Записать(Новый Структура("ВыполнитьЗадачу, Отгрузить, ТолькоВыделенные", Истина, Отгрузить, ТолькоВыделенные));
	Иначе	Возврат Ложь; КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область Типовые

&НаКлиенте
Процедура ДекорацияДобавитьКомментарийНажатие(Элемент)
	
	Элементы.ГруппаДобавитьКомментарий.Видимость 		= Ложь;
	Элементы.ГруппаРедактированиеКомментария.Видимость 	= Истина;
	
КонецПроцедуры
&НаКлиенте
Процедура ПоказатьСкрытьАдресацию(Команда)
	
	// Реверснем
	
	Элемент = Элементы.Найти("ПоказатьСкрытьАдресацию");
	Элемент.Пометка = Не Элемент.Пометка;
	
	// Обновим видимость
	
	ФункцииФормЗадач.ВидимостьАдресации(ЭтаФорма);
	
КонецПроцедуры
&НаСервере
Процедура ПрочитатьРеквизиты()
	
	ФункцииБизнесПроцессов.ЗаполнитьДанные(ЭтаФорма, Объект.Ссылка.БизнесПроцесс, Объект.Ссылка);
	
	// Скопируем старинные склад ячейка в склад
	
	//КонвертацияТипов.ВыполнитьВыражениеВКаждойСтрокеТаблицы(Товары, "Строка.Склад = Строка.СкладЯчейка");
	
КонецПроцедуры
&НаСервере
Процедура ОбновитьВидимостьОчереди(ОбновитьВидимость = Ложь)

	стРазрешение = ОчередьСборкиРазрешаетСборку;
	ОчередьСборкиРазрешаетСборку = Истина;
	
	Элементы.ДекорацияИнфоОчередь.Видимость = Ложь;
	Элементы.ДекорацияИнфоТребаОчередь.Видимость = Ложь;
	
	Если Заказ.Склад.ОбязательноПриоритетыСборки Тогда
		
		ИнфОбОчереди = Заказы.ИнформацияОбОчереди(Заказ);
		Если ЗначениеЗаполнено(ИнфОбОчереди.ОчередьСборки) Тогда
			Элементы.ДекорацияИнфоОчередь.Видимость = Истина;
			Элементы.ДекорацияИнфоОчередь.Заголовок = ИнфОбОчереди.ТекстОчередь1Строка;
		Иначе
			ОчередьСборкиРазрешаетСборку = Ложь;
			Если Не Объект.Выполнена Тогда
				Элементы.ДекорацияИнфоТребаОчередь.Видимость = Истина; КонецЕсли; КонецЕсли; КонецЕсли;
	
	Если ОбновитьВидимость И стРазрешение <> ОчередьСборкиРазрешаетСборку Тогда
		УправлениеВидимостьюДоступностью(); КонецЕсли;
	
КонецПроцедуры
&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	Процесс = Объект.БизнесПроцесс;
	
	ЭтоПараллелльная	= Объект.Параллельная;
	ЭтоТекущаяЗадача 	= Не Объект.Выполнена;
	ЭтоВложеннаяСборка 	= ЗначениеЗаполнено(Процесс.ВедущаяЗадача) И
							ТипЗнч(Процесс.ВедущаяЗадача.БизнесПроцесс) = ТипЗнч(Процесс);
	
	ЕстьСобрать 		= Ложь;
	ЕстьПереместить 	= Ложь;
	ЕстьСобран			= Ложь;
	ЕстьСобирается		= Ложь;
	ЕстьНичегоНеДелать 	= Ложь;
	ЕстьОтгружен		= Ложь;
	
	СостояниеСобран			= Перечисления.СостояниеСборкиЗаказа.Собрано;
	СостояниеСобирается		= Перечисления.СостояниеСборкиЗаказа.Собирается;
	СостояниеНеСобран		= Перечисления.СостояниеСборкиЗаказа.НеСобрано;
	СостояниеОтгружен		= Перечисления.СостояниеСборкиЗаказа.Отгружен;
	СостояниеОжидаетПеремещения		= Перечисления.СостояниеСборкиЗаказа.ОжидаетПеремещения;
	
	Для Каждого Строка Из Товары Цикл
		Если Строка.Состояние = СостояниеСобран Тогда
			ЕстьСобран = Истина;
		ИначеЕсли Строка.Состояние = СостояниеСобирается Тогда
			ЕстьСобирается = Истина;
		Иначе
			Если Строка.Состояние = СостояниеНеСобран И ЗначениеЗаполнено(Строка.Размещение) Тогда 	ЕстьСобрать = Истина;
			ИначеЕсли Строка.Состояние = СостояниеОтгружен Тогда 	ЕстьОтгружен 		= Истина;
			Иначе 													ЕстьНичегоНеДелать 	= Истина;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	
	ЕстьОтгружать = Не ТолькоПросмотр И ЭтоТекущаяЗадача И ЕстьСобран И (ЕстьСобрать Или ЕстьПереместить Или ЕстьНичегоНеДелать);
	
	Элементы.Группа_ЧастичноОтгрузить.Видимость			= ЕстьОтгружать;
	Элементы.ГруппаПакетнаяПечать.Видимость				= ЕстьОтгружать;
	Элементы.Кнопка_ВернутьМенеджеру.Видимость			= ЭтоТекущаяЗадача И Не ЭтоПараллелльная И Не ЕстьСобирается;
	Элементы.Группа_ПереместитьИСобратьЗаказ.Видимость 	= ЭтоТекущаяЗадача И (ЕстьСобрать Или ЕстьПереместить) и ОчередьСборкиРазрешаетСборку;
	Элементы.Кнопка_Отгрузить.Видимость 				= Не ТолькоПросмотр И ЭтоТекущаяЗадача И ЕстьСобран И Не ЕстьПереместить И Не ЕстьСобрать И Не ЕстьНичегоНеДелать;
	
	Элементы.Кнопка_ПереместитьИСобратьЗаказ.Видимость = ЕстьСобрать;
		
КонецПроцедуры
&НаСервере
Функция ПринятьЗадачуНаСервере()
	
	Процесс =  Объект.БизнесПроцесс;
	
	ГлавныйПроцесс = Процесс.ВедущаяЗадача.БизнесПроцесс.ПолучитьОбъект();
		
	Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(ГлавныйПроцесс,, "Ошибка при записи бизнес процесса " + ОписаниеОшибки());
	
КонецФункции

#КонецОбласти

#Область События_формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// прикрепленные файлы
	ОбновитьВидимостьПрикрепленныхФайловНаСервере();
	
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	// комментарии
	ФункцииБизнесПроцессов.ДобавитьРаботуСКомментариями(ЭтаФорма);
	
	ПрочитатьРеквизиты();
	
	// Проверим разрешение отгрузки
	
	//Если ТипЗнч(Заказ) <> Тип("ДокументСсылка.ВнутреннийЗаказ") И Не CRM.КлиентуРазрешенаОтгрузка(Заказ.Контрагент, Заказ.Организация) Тогда
	Если ТипЗнч(Заказ) <> Тип("ДокументСсылка.ВнутреннийЗаказ") И Не CRM.ПартнеруРазрешенаОтгрузка(Заказ.Контрагент) Тогда
		
		Элементы.НадписьОтгрузкаЗапрещена.Видимость = Истина;
		
		Если Не РольДоступна("ПолныеПрава") Тогда
			ТолькоПросмотр = Истина; КонецЕсли; КонецЕсли;
	
	ОбновитьВидимостьОчереди();
	УправлениеВидимостьюДоступностью();
	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеЗаказНаСервере(Заказ)
		
	Возврат Новый Структура("СпособРазмещенияБезЗаказа,ИмяДокумента", Заказ.СпособРазмещенияБезЗаказа,Заказ.Метаданные().Имя);
	
КонецФункции

&НаСервере
Процедура ИницилизироватьПеременныеНаСервере(мСостояниеНеСобран, мСостояниеСобирается, мСостояниеОжидаетПеремещения, мСостояниеСобрано)
	
	мСостояниеНеСобран 				= Перечисления.СостояниеСборкиЗаказа.НеСобрано;
	мСостояниеСобирается			= Перечисления.СостояниеСборкиЗаказа.Собирается;
	мСостояниеСобрано				= Перечисления.СостояниеСборкиЗаказа.Собрано;
	мСостояниеОжидаетПеремещения 	= Перечисления.СостояниеСборкиЗаказа.ОжидаетПеремещения;
	
КонецПроцедуры

 &НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДанныеЗаказа = ПолучитьДанныеЗаказНаСервере(Заказ);
	
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Ложь, , "Товары");
	
	ИницилизироватьПеременныеНаСервере(мСостояниеНеСобран, мСостояниеСобирается, мСостояниеОжидаетПеремещения, мСостояниеСобрано);
	
	// Пакетная печать
	
	ПечатьНаКлиенте.ИницилизироватьПакетнуюПечать(Элементы, СтрокаУправленияПакетнойПечати, ПараметрыПакетнойПечати, ЭтаФорма, глПараметрыПакетнойПечати, 
				"ПриЧастичнойОтгрузкиТовара", 		// Место
				Новый Структура("Заказ", Заказ));   // Для запроса
				
	// комментарии
	ФункцииБизнесПроцессовКлиент.ПолучитьМассивКомментариев(ЭтаФорма, Объект.БизнесПроцесс);
	
	ФункцииФормЗадач.ПриОткрытии(Объект, ЭтаФорма, Отказ);
	
КонецПроцедуры
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = СобытияСистемы.СобытиеИзмениласьОчередьСборкиЗаказа() Тогда
		ОбновитьВидимостьОчереди(Истина) КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ФункцииФормЗадач.ПослеЗаписи(Объект, ЭтаФорма, ПараметрыЗаписи);
	
	УправлениеВидимостьюДоступностью();	
	
КонецПроцедуры
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Перем ВыполнитьЗадачу, Отгрузить, ТолькоВыделенные, Параллельная;
	
	ПараметрыЗаписи.Свойство("ВыполнитьЗадачу", 	ВыполнитьЗадачу);
	ПараметрыЗаписи.Свойство("Отгрузить", 			Отгрузить);
	ПараметрыЗаписи.Свойство("ТолькоВыделенные", 	ТолькоВыделенные);
	
	Если ВыполнитьЗадачу = Истина И Отгрузить = Истина Тогда
			
		Если ТипЗнч(Заказ) = Тип("ДокументСсылка.ВнутреннийЗаказ") Тогда
			
			Если Не СоздатьПровестиЧастичноеПеремещениеИОтправитьЕгоВСборку() Тогда Отказ = Истина; КонецЕсли;
			
		ИначеЕсли 
			
			Не СоздатьИПровестиРеализацию(ТолькоВыделенные = Истина) Тогда Отказ = Истина;КонецЕсли;КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ВыбратьЭлементДляВсех(ПутьКОбъекту, ИмяКолонки)
	
	ВыбранныйЭлемент = ОткрытьФорму(ПутьКОбъекту,,ЭтаФорма,,,,Новый ОписаниеОповещения("ОбработкаОткрытияФормы",ЭтаФорма,Новый Структура("ИмяКолонки", ИмяКолонки)));
	
КонецПроцедуры
&НаКлиенте
Процедура ОбработкаОткрытияФормы(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Для Каждого Строка Из Товары Цикл Строка[Параметры.ИмяКолонки] = Результат КонецЦикла; КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область Действий_над_задачей

&НаКлиенте
Процедура ВернутьМенеджеру(Команда)
	
	Если УстановитьСостояниеИВыполнитьЗадачу("ВРаботе") Тогда
		
		ОтправитьОповещениеПоЕмейл();
			
		Закрыть(); КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьОповещениеПоЕмейл()
	Если ТипЗнч(Объект.Заказ) <> Тип("ДокументСсылка.ВнутреннийЗаказ") Тогда 
		Емейл1=Объект.Заказ.Контрагент.ОсновнойМенеджер.Почта;
		Емейл2=Объект.Заказ.Автор.Почта;
		
		Кому=Емейл1+"; "+Емейл2;
		
		ТемаПисьма = "Заказ возвращен менеджеру"; 
		
		ТекстПисьма = "Заказ № "+Объект.Заказ.Номер+" вернулся для корректировки менеджером, необходимо внести изменения и повторно отправить в сборку."+символы.ПС+" При возникновении вопросов обращаться к логисту "+ПараметрыСеанса.ТекущийПользователь.Наименование+".";
		
		Письмо = ОбщиеФункции.ОповеститьПоПочте(Кому, ТемаПисьма, ТекстПисьма, Ложь, Перечисления.ТипыТекстовЭлектронныхПисем.ПростойТекст);
	КонецЕсли;
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПроверитьПереходныйЭтапОбъединениеСкладовНаСервере(Заказ)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Заказ",Заказ);
	Запрос.Текст = "ВЫБРАТЬ ссылка, БизнесПроцесс.СкладОтправитель Склад из задача.задачаПользователю 
	|где 
	|Заказ = &Заказ 
	|и БизнесПроцесс ссылка БизнесПроцесс.ПеремещениеТоваров
	|и БизнесПроцесс.СкладОтправитель = БизнесПроцесс.СкладПолучатель
	|";
	
	Рез = Запрос.Выполнить();
	Возврат Рез.Пустой();
КонецФункции

&НаКлиенте
Процедура ПроверитьПереходныйЭтапОбъединениеСкладов()
	Если Не ПроверитьПереходныйЭтапОбъединениеСкладовНаСервере(Заказ) Тогда
		ПоказатьПредупреждение(,"Внимание! Данный заказ был оформлен в период объединения складов. "+Символы.ПС+"Позиции уже могли быть собраны или частично отгружены. Необходимо свериться со складской таблицей.");
	КонецЕсли;	
КонецПроцедуры	


&НаКлиенте
Процедура ПереместитьИСобратьЗаказ(Команда, ТолькоВыделенные = Ложь)
	
	ПроверитьПереходныйЭтапОбъединениеСкладов();
	
	// Установим действия для всех нуждающихся
	
	Если СформироватьИПровестиСборкуИперемещения() Тогда
		Закрыть(); КонецЕсли;
	
КонецПроцедуры
	
	
&НаКлиенте
Процедура ЧастичноОтгрузить(Команда, ТолькоВыделенные = Ложь)
	
	ПроверитьПереходныйЭтапОбъединениеСкладов();
	
	новРеализацияСсылка = Неопределено;
	
	Если Записать(Новый Структура("ВыполнитьЗадачу, Отгрузить, ТолькоВыделенные", Истина, Истина, ТолькоВыделенные)) Тогда
			
		Если 	новРеализацияСсылка <> Неопределено И Не новРеализацияСсылка.Пустая() И
				Не ПараметрыПакетнойПечати.СпособПечати = "НаПринтер" Тогда // Откроем только если не было пакетной печати и печать была сразу на принтер
					ОткрытьФорму(Заказы.ПолучитьИмяФормы(новРеализацияСсылка), Новый Структура("Ключ", новРеализацияСсылка));КонецЕсли;
			
		// Пакетная печать
		
		ПараметрыПакетнойПечати.Вставить("ДанныеДляПечати", Новый Структура("Заказ, Реализация", Заказ, новРеализацияСсылка));
		ПечатьНаКлиенте.ВыполнитьПакетнуюПечать(ПараметрыПакетнойПечати);
			
		Закрыть(); КонецЕсли;
	
	КонецПроцедуры
	
&НаКлиенте
Процедура ЧастичноОтгурзитьТолькоВыделенные(Команда)
	
	ЧастичноОтгрузить(Команда, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отгрузить(Команда)
	
	//+Андриянов 21.04.2017 - всегда собран когда отгрузить - это неправильно, меняем
	//Если УстановитьСостояниеИВыполнитьЗадачу("Собран", Истина) Тогда
	//	Закрыть(); КонецЕсли;
	Если УстановитьСостояниеИВыполнитьЗадачу(?(Заказы.ЗаказЧастичноСобран(Объект.БизнесПроцесс), "СобранЧастично","Собран"), Истина) Тогда
		Закрыть(); КонецЕсли;
	//-Андриянов
	
КонецПроцедуры

#КонецОбласти

#Область Информация_о_товаре

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	
	ОбработатьОтображениеИнформацииОТоваре()	
	 	
КонецПроцедуры

&НаСервере
Процедура ОбработатьОтображениеИнформацииОТоваре() Экспорт
	РаботаСНоменклатурой.ОбработатьОтображениеИнформацииОТоваре(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ИнфТовараТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ИнфТовараЗаголовокHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараЗаголовокHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры

 &НаКлиенте
Процедура ПоказатьСкрытьИнфОТоваре(Команда)
	РаботаСНоменклатуройКлиент.ПоказатьСкрытьИнфОТоваре(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИнфОТоваре(Команда) 
	РаботаСНоменклатуройКлиент.НастройкаИнфОТоваре(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область Комментарии

&НаКлиенте
Процедура КомандаПоказатьКомментарий(Команда)
	ФункцииБизнесПроцессовКлиент.КомандаПоказатьКомментарий(ЭтаФорма);
КонецПроцедуры


#КонецОбласти

#Область Пакетная_печать

&НаКлиенте
Процедура СтрокаУправленияПакетнойПечатиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ПечатьНаКлиенте.ОбработатьНавигационнуюСсылку(ЭтаФорма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, СтрокаУправленияПакетнойПечати, ПараметрыПакетнойПечати);
	
КонецПроцедуры

&НаКлиенте
Процедура КартинкаПринтераНажатие(Элемент)
	
	ПечатьНаКлиенте.НажатиеНаКартинкуПринтераВПакете(Элемент, ЭтаФорма);
	
КонецПроцедуры

// Поток

&НаСервере
Функция ПакетПоУмолчаниюПолучен()
	
	СтруктураВозврата = ПолучитьИзВременногоХранилища(АдресПоискаПакетеПечати);
	Если СтруктураВозврата = Неопределено Тогда
		Возврат Ложь;
		
	Иначе
		
		Если СтруктураВозврата.Состояние = Поток.СостояниеОшибка() Тогда
			ВызватьИсключение СтруктураВозврата.стрОшибки; КонецЕсли;
		
		ПараметрыПакетнойПечати.Вставить("Пакет", СтруктураВозврата.Результат);
		Возврат Истина; КонецЕсли;
	
КонецФункции
&НаКлиенте
Процедура ПолучитьПакетПоУмолчаниюПостоянно()
	
	Если ПакетПоУмолчаниюПолучен() Тогда
		ПечатьНаКлиенте.ОбновитьСтрокуСостоянияПакетнойПечати(СтрокаУправленияПакетнойПечати, ПараметрыПакетнойПечати);
		ОтключитьОбработчикОжидания("ПолучитьПакетПоУмолчаниюПостоянно"); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ПолучитьПакетПоУмолчанию()
	
	Если ПакетПоУмолчаниюПолучен() Тогда
		ПечатьНаКлиенте.ОбновитьСтрокуСостоянияПакетнойПечати(СтрокаУправленияПакетнойПечати, ПараметрыПакетнойПечати);
	Иначе
		ПодключитьОбработчикОжидания("ПолучитьПакетПоУмолчаниюПостоянно", 1) КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ЗапуститьПоискПакетаДляПечати() Экспорт
	
	АдресПоискаПакетеПечати = Поток.ЗапуститьПоискПакетаДляПечати(ПараметрыПакетнойПечати, глПараметрыПакетнойПечати, УникальныйИдентификатор);
	ПодключитьОбработчикОжидания("ПолучитьПакетПоУмолчанию", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаСервере
Функция ПолучитьПроцессЗаказа(ИмяПроцесса = "")
	
	Возврат Заказы.ПолучитьПроцесс(Объект.Заказ, ИмяПроцесса);
	
КонецФункции
&НаКлиенте
Процедура ЗаказОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИмяПроцесса 	= "";
	ПроцессЗаказ 	= ПолучитьПроцессЗаказа(ИмяПроцесса);
	
	ОткрытьФорму("БизнесПроцесс." + ИмяПроцесса + ".ФормаОбъекта", Новый Структура("Ключ", ПроцессЗаказ));
	
КонецПроцедуры

#КонецОбласти

#Область Прикрепленные_файлы

&НаКлиенте
Процедура УдалитьПрикрепленныеФайлыНажатие(Элемент)
	
	ПрикрепленныеФайлыКлиент.УдалитьНажатие(Объект.Заказ, ЭтаФорма, Элемент);
	
КонецПроцедуры
&НаКлиенте
Процедура ПрикрепленныеФайлыНажатиеСкрепка(Элемент)
	
	ПрикрепленныеФайлыКлиент.НажатиеСкрепка(Объект.Заказ, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПрикрепленныйФайл(Элемент)
	
	ПрикрепленныеФайлыКлиент.ОткрытьПрикрепленныйФайл(Элемент.Имя);
	
КонецПроцедуры
&НаКлиенте
Процедура ПоказатьПрикрееленныеФайлы(Элемент)
	
	ПрикрепленныеФайлыКлиент.ПоказатьПрикрепленныеФайлы(Объект.Заказ, ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьПрикрепленныхФайловНаСервере()
	
	ПрикрепленныеФайлы.Иницилизировать(Объект.Заказ, ЭтаФорма);
	
КонецПроцедуры
&НаКлиенте
Процедура ОбновитьВидимостьПрикрепленныхФайлов() Экспорт
	
	ОбновитьВидимостьПрикрепленныхФайловНаСервере();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПоказатьСборщиков(Команда)
	
	ОткрытьФорму("Отчет.ОтчетПоСборщикамЗаказов.ФормаОбъекта", 
			Новый Структура("Отбор,  КлючВарианта, СформироватьПриОткрытии", 
	 					Новый Структура("Заказ", Заказ), "ПоЗаказу", Истина));
	
КонецПроцедуры



мКорректировкаПроведена = Ложь;