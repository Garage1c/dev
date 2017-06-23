﻿
Функция ЭтоВнутреннийЗаказ()
	
	Возврат ТипЗнч(Заказчик.Заказ) = Тип("ДокументСсылка.ВнутреннийЗаказ");
	
КонецФункции
Функция КонечныйСклад()
	
	Возврат ?(ЭтоВнутреннийЗаказ(), Заказчик.Заказ.Заказчик, Заказчик.Заказ.Склад);
	
КонецФункции


Функция ПредставлениеЗадачи(Задача)
	
	Если ТипЗнч(Заказчик) = Тип("БизнесПроцессСсылка.СборкаЗаказа") Тогда
		
		Заказ 			= Заказчик.Заказ;
		ЭтоВнутренний	= ТипЗнч(Заказ) = Тип("ДокументСсылка.ВнутреннийЗаказ");
		ЭтоИнтернет 	= ТипЗнч(Заказ) = Тип("ДокументСсылка.ИнтернетЗаказПокупателя");
		
		НомерЗаказа   = СокрЛП(Заказ.Номер);
		Пока Лев(НомерЗаказа, 1)="0" Цикл   			  // удаление ведущих нулей
			НомерЗаказа = Сред(НомерЗаказа, 2);
		КонецЦикла;
		
		Наименование = 
				Задача.Наименование + " для " + 
				?(ЭтоИнтернет,	"интернет ",
								?(ЭтоВнутренний,
										"внутреннего ","")) + 
				"заказа № "  + ОбщиеФункции.ПолучитьСтрокуБезНулейСлева(Заказ.Номер) + 
				?(ЭтоВнутренний,	"",
									" (" + Формат(Заказ.Сумма, "Ч15.2,") + ") ") + 
				?(ЭтоИнтернет, 
									Заказ.ПользовательИнтернет, 
									?(ЭтоВнутренний, 
											?(ТипЗнч(Заказ.Заказчик) = Тип("БизнесПроцессВыборка.СборкаЗаказа"),""," (" + Заказ.Склад + "->" + Заказ.Заказчик + ") "),
											?(Заказ.ОтветственноеЛицо.Пустая(), Заказ.Партнер, Заказ.ОтветственноеЛицо)));
		
	Иначе
		
		Наименование = Задача.Наименование + " для " + Заказчик;
		
	КонецЕсли;
	
	
    Возврат Наименование + " (БП" + ОбщиеФункции.ПолучитьСтрокуБезНулейСлева(Номер) + ")";
	
КонецФункции  

// ПО СХЕМЕ


Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	Заказ = БизнесПроцессы.ПеремещениеТоваров.ПолучитьЗаказ(Ссылка);
	
	Если ЗначениеЗаполнено(Заказ) Тогда
	
		Заказы.УстановитьСостояниеЗаказа(Заказ, Перечисления.СостоянияЗаказа.ОжидаетПеремещения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтправитьТоварПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	// спрячем задачи, ожидающие перемещения товаров с других складов
	ПараллельнаяЗадача = Ложь;
	Если ДополнительныеСвойства.Свойство("ПараллельнаяЗадача") Тогда
		ПараллельнаяЗадача = ДополнительныеСвойства.ПараллельнаяЗадача;	КонецЕсли;
	
	Для Каждого Задача Из ФормируемыеЗадачи Цикл
		
		Задача.Склад 		= СкладОтправитель;
		Задача.Наименование = ПредставлениеЗадачи(Задача);
		Задача.Параллельная = ПараллельнаяЗадача; КонецЦикла;
	
КонецПроцедуры

Процедура ПринятьТоварПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	Для Каждого Задача Из ФормируемыеЗадачи Цикл
		
		Задача.Склад 		= СкладПолучатель;
		Задача.Наименование = ПредставлениеЗадачи(Задача);
		
	КонецЦикла;
	
КонецПроцедуры


Процедура ТребуетсяПеремещатьДалееПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Заказ = Заказчик.Заказ;
	КонечныйСклад = ?(ТипЗнч(Заказ)=Тип("ДокументСсылка.ВнутреннийЗаказ"),Заказ.Заказчик,Заказ.Склад);
	
	Если Не СкладПолучатель = КонечныйСклад Тогда
		
		//проверим все ли товары пришли
		//это подразумевает что есть либо незакрытые заказы на перемещение либо товары в пути
		//поскольку перемещения создаются в системе последовательно по маршрутам, то любой остаток будет означать незакрытое перемещние прошлого этапа
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Заказ",Заказ);
		Запрос.УстановитьПараметр("Заказчик",Заказчик);
		Запрос.Текст="Выбрать Номенклатура из РегистрНакопления.ЗаказыНаПеремещения.Остатки(,Заказ = &Заказ)
		|Объединить все
		|Выбрать Номенклатура из РегистрНакопления.ТоварыВПути.Остатки(,Заказчик = &Заказчик)
		|";
		
		Рез=Запрос.Выполнить();
		Если Рез.Пустой() Тогда
			Результат = Истина;
		Иначе
			Результат = Ложь;
		КонецЕсли;	
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура СоздатьЕщеПеремещениеОбработка(ТочкаМаршрутаБизнесПроцесса)

	Отказ=Ложь;
	
	Заказ = Заказчик.Заказ;
	КонечныйСклад = КонечныйСклад();
	
	Товары = Заказы.ПолучитьСостояниеТоваров(Ссылка);
	
	//товары на этом складе в статусе "не собрано"
	Товары = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(
							Товары,
							//Новый Структура("Размещение,Состояние",СкладПолучатель, Перечисления.СостояниеСборкиЗаказа.НеСобрано));
							Новый Структура("Размещение,Состояние",СкладПолучатель, Перечисления.СостояниеСборкиЗаказа.СобираетсяИзЯчеек));
	
	НачатьТранзакцию();
	
	//создаем документ СборкаЗаказа
		//СкладРазмещения = СкладПолучатель;
		//
		//Сборка = Документы.СборкаЗаказа.СоздатьДокумент();
		//Сборка.Заполнить(Новый Структура("Шапка, Товары, ТоварыАлгоритм", Новый Структура("Заказ, Склад", Заказ, СкладПолучатель), Товары, "НовСтрока.ВСборке = Строка.Количество"));
		//
		//Если Не Сборка.ПроверитьЗаполнение() Или Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Сборка, РежимЗаписиДокумента.Проведение) Тогда 
		//	ОтменитьТранзакцию(); 
		//	Возврат; 
		//КонецЕсли; 
	
	массивТабл = Новый Массив;
	массивТабл.Добавить(Товары);
	//создаем БП Перемещение и Заказ на перемещение. Внутри БП Перемещение создастся БП СборкаТовара
	Справочники.Маршруты.СоздатьПеремещенияПоПервымЭтапамМаршрутов(массивТабл, КонечныйСклад, Заказ, Заказчик, Отказ);
	Если Отказ Тогда
		ОтменитьТранзакцию();
		Возврат; 
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры



	
// #ВЗООПАРК
Процедура ДобавитьВладельцаОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	// Найдем процесс родитель
	
	ПроцессРодитель = БизнесПроцессы.ПеремещениеТоваров.ПолучитьПроцессРодитель(Ссылка);
	
	Если ПроцессРодитель <> Неопределено Тогда
		
		СкладРодителя = ПроцессРодитель.СкладОтправитель;
		
		// шапка
			
		внЗаказ = Документы.ВнутреннийЗаказ.СоздатьДокумент();
		внЗаказ.Дата 		= ТекущаяДата();
		внЗаказ.Склад 		= СкладРодителя;
		внЗаказ.Заказчик 	= Ссылка.Заказчик;
			
		// таблица, возмем те товары которые не собраны но лежат на складе родителя
		
		Заказ 				= БизнесПроцессы.ПеремещениеТоваров.ПолучитьЗаказ(Ссылка);
		ТаблицаПеремещений 	= Заказы.ПолучитьТоварыПоСтатусу(Ссылка.Заказчик,,Перечисления.СостояниеСборкиЗаказа.НеСобрано);
		
		
		Для Каждого Строка Из ТаблицаПеремещений Цикл 
			Если Строка.Размещение = СкладРодителя Тогда 
				НовСтрока = внЗаказ.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
				// Снимим чтобы не делался резерв
				НовСтрока.Размещение = Неопределено;
			КонецЕсли; 
		КонецЦикла;
		//Если Заказ.СпособРазмещенияБезЗаказа Тогда // это по новому
		//	Для Каждого Строка Из ТаблицаПеремещений Цикл 
		//		Если Строка.Размещение = СкладРодителя Тогда 
		//			НовСтрока = внЗаказ.Товары.Добавить();
		//			ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
		//			// Снимим чтобы не делался резерв
		//			НовСтрока.Размещение = Неопределено;
		//		КонецЕсли; 
		//	КонецЦикла;
		//Иначе // а эт по старому
		//	Для Каждого Строка Из ТаблицаПеремещений Цикл 
		//		Если Строка.СкладЯчейка = СкладРодителя Тогда 
		//			ЗаполнитьЗначенияСвойств(внЗаказ.Товары.Добавить(), Строка); 
		//		КонецЕсли;
		//	КонецЦикла;
		//КонецЕсли;
		
		// Запишем если есть что перемещать
			
		Если 	внЗаказ.Товары.Количество() И
				Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(внЗаказ, РежимЗаписиДокумента.Проведение) Тогда
				
			ВызватьИсключение "Ошибка при записи внутреннего заказа для товара который следует через транзитный склад";
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры
// #ВЗООПАРК


Процедура ЗакрытьБПОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	//Если 	ВедущаяЗадача.Пустая() И
	Если 	НЕ ЗначениеЗаполнено(ВедущаяЗадача) И
			ТипЗнч(Заказчик) = Тип("БизнесПроцессСсылка.СборкаЗаказа") И
			Заказы.ЗаказОтработал(Заказчик.Заказ) Тогда
			
		// Найдем все процессы и закроем их
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ 	Ссылка ИЗ Задача.ЗадачаПользователю 
		|ГДЕ 	БизнесПроцесс ССЫЛКА БизнесПроцесс.СборкаЗаказа И 
		|		БизнесПроцесс.Заказ = &Заказ И 
		|		Не Выполнена И Не ПометкаУдаления");
		
		Запрос.УстановитьПараметр("Заказ", Заказчик.Заказ);
		Выборка = Запрос.Выполнить().Выбрать();
		
		// Выполним все задачи
		
		Пока Выборка.Следующий() Цикл 
			Если Не Выборка.Ссылка.Выполнена Тогда
				ВыполняемаяЗадача = Выборка.Ссылка.ПолучитьОбъект();
				ВыполняемаяЗадача.ДополнительныеСвойства.Вставить("КонтрольАдресации", Ложь);
				ВыполняемаяЗадача.ВыполнитьЗадачу() КонецЕсли; КонецЦикла; КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьБеспризорныйБПСборкиТоваров()
	
	// Возвращает не к кому не привязанный БП сборки по жанному складу отправителя
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ БизнесПроцесс.СборкаТовара ГДЕ НЕ Завершен И Стартован И Склад = &Склад И Заказ = &Заказ И ВедущаяЗадача = &ПустаяЗадача");
	Запрос.УстановитьПараметр("Склад", 			СкладОтправитель);
	Запрос.УстановитьПараметр("Заказ", 			Заказчик.Заказ);
	Запрос.УстановитьПараметр("ПустаяЗадача", 	Задачи.ЗадачаПользователю.ПустаяСсылка()); 
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции


Процедура СобратьТоварПередСозданиемВложенныхБизнесПроцессов(ТочкаМаршрутаБизнесПроцесса, ФормируемыеБизнесПроцессы, Отказ)
	
	БеспризорникСсылка = ПолучитьБеспризорныйБПСборкиТоваров();
	ФормируемыеБизнесПроцессы.Добавить(?(БеспризорникСсылка = Неопределено, ФункцииБизнесПроцессов.ПолучитьНовыйБПСборкиТоваров(Заказчик.Заказ, СкладОтправитель), БеспризорникСсылка.ПолучитьОбъект()));
	
КонецПроцедуры

// ВОЗВРАТ

Функция ВернутьТоварКоторыйВПути_Ст()
	
	НовДок = Документы.ПриемТоваров.СоздатьДокумент();
	НовДок.Дата = ТекущаяДата();
	НовДок.Процесс 					= Ссылка;
	НовДок.СкладПолучатель 			= СкладОтправитель;
	НовДок.СкладОтправитель			= СкладПолучатель;
	НовДок.ЭтоВозвратПеремещения 	= Истина;
	
	// Получим запрос
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Ост.Номенклатура,
	|	Ост.Упаковка,
	|	Ост.КоличествоОстаток Количество
	|ИЗ
	|	РегистрНакопления.ТоварыВПути.Остатки(,
	|								Заказчик 			= &Заказчик И 
	|								СкладОтправитель 	= &СкладОтправитель И
	|								СкладПолучатель 	= &СкладПолучатель
	|											) Ост
	|;
	|ВЫБРАТЬ
	|	Док.Ячейка,
	|	Док.Номенклатура,
	|	Док.Упаковка,
	|	Док.Количество
	|ИЗ 		
	|	Документ.ОтгрузкаТоваров.Товары Док
	|ГДЕ
	|	Ссылка.Процесс = &Процесс И
	|	Ссылка.Проведен = Истина
	|");
	
	Запрос.УстановитьПараметр("Процесс", 	Ссылка);
	Запрос.УстановитьПараметр("Заказчик", 	Заказчик);
	Запрос.УстановитьПараметр("СкладОтправитель", 	СкладОтправитель);
	Запрос.УстановитьПараметр("СкладПолучатель", 	СкладПолучатель);

	
	Пакет = Запрос.ВыполнитьПакет();
	Выборка 	= Пакет[0].Выбрать();
	//Документ 	= Пакет[1].Выгрузить();
	
	Документ = БизнесПроцессы.ПеремещениеТоваров.ПолучитьСостояниеТоваровПоЗаказчику(Ссылка);
	
	// Заполним товары
	
	Пока Выборка.Следующий() Цикл
		
		Нужно 	= Выборка.Количество;
		Строки 	= Документ.НайтиСТроки(Новый Структура("Номенклатура, Упаковка", Выборка.Номенклатура, Выборка.Упаковка));
		
		Для КАждого Строка Из Строки Цикл
			
			Отдаем = Мин(Строка.Количество, Выборка.Количество);
			
			НовСтрока = НовДок.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
			НовСтрока.Количество 	= -Отдаем;
			НовСтрока.Сумма 		= Строка.Цена * НовСтрока.Количество;
			НовСтрока.СтавкаНДС 	= Перечисления.СтавкиНДС.НДС18;
			
			Если Не Отдаем Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
	// Запишем документ
	
	Если НовДок.Товары.Количество() Тогда
	
		Попытка
			НовДок.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Возврат Ложь;
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Истина;

КонецФункции
Процедура ВернутьТоварКоторыйВПути()
	
	// Таблица
	
	Таблица = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(
				БизнесПроцессы.ПеремещениеТоваров.ПолучитьСостояниеТоваровПоЗаказчику(Ссылка),
				Новый Структура("Состояние", Перечисления.СостояниеСборкиЗаказа.Перемещается));
				
	// если это возврат непринятого товара (после итоговой отгрузки) по Внутренней заявке
	
	Если ТипЗнч(Заказчик.Заказ) = Тип("ДокументСсылка.ВнутреннийЗаказ") И Ссылка.ЗаказСобран Тогда
		
		// вернем товар в ячейки, из которых он был списан
		Если СкладОтправитель.Ячеестый Тогда
		
			Запрос = Новый Запрос("
			|ВЫБРАТЬ 	Номенклатура, СкладЯчейка Ячейка, Собрано Количество
			|ИЗ			РегистрНакопления.СборкаЗаказа
			|ГДЕ
			|	ВидДвижения = &ВидДвиженияРасход И
			|	Регистратор В(
			|		ВЫБРАТЬ Ссылка 
			|		ИЗ 		Документ.ОтгрузкаТоваров 
			|		ГДЕ 	Проведен И 
			|				Процесс = &Процесс
			|					)
			|");
			
			Запрос.УстановитьПараметр("ВидДвиженияРасход", 	ВидДвиженияНакопления.Расход);
			Запрос.УстановитьПараметр("Процесс", 			Ссылка);
			
			Таблица = КонвертацияТипов.РазнестиТаблицуПоТаблицеОстатков(
								Таблица,
								Запрос.Выполнить().Выгрузить(),
								); КонецЕсли;
							
	Иначе // Обычный возврат непринятого товара в рамках какой-либо заявки (покупателя, интернет, внутренней)
		
		
		// вернем товар в ячейки, из которых он был списан
		Если СкладОтправитель.Ячеестый Тогда
				
			Запрос = Новый Запрос("
			|ВЫБРАТЬ 	Номенклатура, Ячейка, Количество
			|ИЗ			РегистрНакопления.ТоварыВЯчейках
			|ГДЕ
			|	ВидДвижения = &ВидДвиженияРасход И
			|	Регистратор В(
			|		ВЫБРАТЬ Ссылка 
			|		ИЗ 		Документ.ОтгрузкаТоваров 
			|		ГДЕ 	Проведен И 
			|				Процесс 			= &Процесс И
			|				СкладОтправитель 	= &СкладОтправитель И
			|				СкладПолучатель 	= &СкладПолучатель
			|					)
			|");
			
			Запрос.УстановитьПараметр("ВидДвиженияРасход", 	ВидДвиженияНакопления.Расход);
			Запрос.УстановитьПараметр("Процесс", 			Ссылка);
			Запрос.УстановитьПараметр("СкладОтправитель", 	СкладОтправитель);
			Запрос.УстановитьПараметр("СкладПолучатель", 	СкладПолучатель);
			
			Таблица = КонвертацияТипов.РазнестиТаблицуПоТаблицеОстатков(
								Таблица,
								Запрос.Выполнить().Выгрузить(),
								); КонецЕсли;КонецЕсли;
				
	// Шапка
	
	Если Таблица.Количество() Тогда
	
		НовДок = Документы.ПриемТоваров.СоздатьДокумент();
		НовДок.Дата = ТекущаяДата();
		НовДок.Процесс 					= Ссылка;
		НовДок.Маршрут 					= Таблица[0].Маршрут;
		НовДок.СкладПолучатель 			= СкладОтправитель;   // меняем склады задом наперед
		НовДок.СкладОтправитель			= СкладПолучатель;
		НовДок.ЭтоВозвратПеремещения 	= Истина;
		НовДок.НеСписыватьЗаказы 		= Истина; // возможно это нужно оставить только для внутренних заказов
		НовДок.ЗакрытьЗаказ				= Истина;
		Если Ссылка.ЗаказСобран Тогда
			НовДок.ПоставитьВРезерв = Истина; КонецЕсли;
		
		НовДок.Товары.Загрузить(Таблица);
	 	НовДок.Записать(РежимЗаписиДокумента.Проведение); 
		
		// Для внутреннего заказа надо создать еще и сборку, т.к. он собирался и его состояние должно стать собранным

		Если ТипЗнч(Заказчик.Заказ) = Тип("ДокументСсылка.ВнутреннийЗаказ") И Ссылка.ЗаказСобран Тогда
		
			ТаблицаКопия = Таблица.Скопировать();
			ТаблицаКопия.ЗагрузитьКолонку(Таблица.ВыгрузитьКолонку("Ячейка"),"СкладЯчейка");
			
			// Первая сборка это типа пошли собирать
			
			СборкаДок = Документы.СборкаЗаказа.СоздатьДокумент();
			СборкаДок.Дата 	= ТекущаяДата();
			СборкаДок.Склад	= СкладОтправитель;
			СборкаДок.Заказ = Заказчик.Заказ;
			
			ТаблицаКопия.Колонки.Количество.Имя = "ВСборке";
			СборкаДок.Товары.Загрузить(ТаблицаКопия);
			
			Если СборкаДок.Товары.Количество() Тогда
				СборкаДок.Записать(РежимЗаписиДокумента.Проведение);КонецЕсли;
			
			// Вторая сборка это типа собирали
			
			СборкаДок = Документы.СборкаЗаказа.СоздатьДокумент();
			СборкаДок.Дата 	= ТекущаяДата();
			СборкаДок.Склад	= СкладОтправитель;
			СборкаДок.Заказ = Заказчик.Заказ;
			
			ТаблицаКопия.Колонки.ВСборке.Имя = "Собрано";
			СборкаДок.Товары.Загрузить(ТаблицаКопия);
			
			Если СборкаДок.Товары.Количество() Тогда
				СборкаДок.Записать(РежимЗаписиДокумента.Проведение);КонецЕсли;
		
		КонецЕсли;			
		
	КонецЕсли;
	
КонецПроцедуры
Процедура ВернутьТоварКоторыйВоВнутреннемЗаказе()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ВнутреннийЗаказ Заказ,
	|	Номенклатура,
	|	Упаковка,
	|	Размещение,
	|	-КоличествоОстаток Количество
	|ИЗ
	|	РегистрНакопления.ВнутренниеЗаказы.Остатки(,
	|					Заказчик В(
	|						ВЫБРАТЬ Заказчик 
	|						ИЗ 		БизнесПроцесс.ПеремещениеТоваров 
	|						ГДЕ 	Ссылка = &БППеремещение) И
	|					ВнутреннийЗаказ.Склад = &СкладОтправитель)
	|ИТОГИ ПО
	|	Заказ
	|");
	
	Запрос.УстановитьПараметр("БППеремещение", 		Ссылка);
	Запрос.УстановитьПараметр("СкладОтправитель", 	Ссылка.СкладОтправитель);
	
	ВыборкаЗаказов = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Пока ВыборкаЗаказов.Следующий() Цикл
		
		НовДок = Документы.КорректировкаВнутреннегоЗаказа.СоздатьДокумент();
		НовДок.Дата 	= ТекущаяДата();
		НовДок.Заказ 	= ВыборкаЗаказов.Заказ;
		
		КонвертацияТипов.ЗагрузитьВыборкуВТаблицу(ВыборкаЗаказов.Выбрать(), НовДок.Товары);
	
		Если НовДок.Товары.Количество() Тогда НовДок.Записать(РежимЗаписиДокумента.Проведение); КонецЕсли; КонецЦикла;
		
КонецПроцедуры

// УСЛОВИЯ

Функция ЕстьНаОстаткахПеремещения()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1 Заказчик ИЗ РегистрНакопления.ТоварыВПути.Остатки(,Заказчик = &Заказчик)
	|ОБЪЕДИНИТЬ
	|ВЫБРАТЬ ПЕРВЫЕ 1 Заказчик ИЗ РегистрНакопления.ВнутренниеЗаказы.Остатки(,Заказчик = &Заказчик И ВнутреннийЗаказ.Склад = &Склад)
	|");
	
	Запрос.УстановитьПараметр("Заказчик", 	Заказчик);
	Запрос.УстановитьПараметр("Склад", 		СкладОтправитель);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Процедура УсловиеВСеПриехалоПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = Не ЕстьНаОстаткахПеремещения();
	
КонецПроцедуры
Процедура ТребуетсяОтслеживатьПеремещениеМеждуСкладамиПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = Не БыстроеПеремещение;
	
КонецПроцедуры


Процедура ЕстьЧтоПриниматьПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Заказчик ИЗ РегистрНакопления.ТоварыВПути.Остатки(,Заказчик = &Заказчик)");
	Запрос.УстановитьПараметр("Заказчик", 	Заказчик);
	
	Результат = Не Запрос.Выполнить().Пустой();
	
КонецПроцедуры

Процедура ПринятьТоварПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	ПоказатьСпрятанныеПеремещения();
	
КонецПроцедуры

Процедура ПоказатьСпрятанныеПеремещения()
	
	// Найдем спрятанные задачи, ожидающие выполнения этой задачи и сделаем их видимыми
	Запрос = Новый Запрос("ВЫБРАТЬ Зад.Ссылка ИЗ Задача.ЗадачаПользователю Зад ГДЕ БизнесПроцесс В (ВЫБРАТЬ Ссылка ИЗ БизнесПроцесс.ПеремещениеТоваров.ОжидающиеПеремещения ГДЕ Процесс = &Ссылка) И НЕ Выполнена И Параллельная");	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗадачаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Если ЗадачаОбъект <> Неопределено Тогда
			ЗадачаОбъект.ОбменДанными.Загрузка = Истина;
			ЗадачаОбъект.Параллельная = Ложь;
			Попытка
				ЗадачаОбъект.Записать();
			Исключение
				Сообщить("Не удалось записать объект " + " """ + ЗадачаОбъект + """!
				         |" + ОписаниеОшибки());
				Отказ = Истина;
			КонецПопытки; КонецЕсли; КонецЦикла;
	
КонецПроцедуры


Процедура ОтправитьТоварПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	Если БыстроеПеремещение Тогда
		ПоказатьСпрятанныеПеремещения();
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипЗнч = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипЗнч = Тип("Структура") Тогда
		
		КонвертацияТипов.ЗаполнитьОбъектПоСтруктуреОснованию(ЭтотОбъект, ДанныеЗаполнения); КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьПоследнююЗадачуСкорректироватьЗаказ()
	
	Запрос = Новый Запрос("
	
	// Получим все задачи по заказу
	
	|ВЫБРАТЬ 	Зад.Ссылка 
	|ПОМЕСТИТЬ 	ЗадачиЗаказа
	|ИЗ Задача.ЗадачаПользователю Зад
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ	БизнесПроцесс.ПеремещениеТоваров БП
	|ПО					БП.Ссылка = Зад.БизнесПроцесс
	|
	|ГДЕ 	НЕ Зад.ПометкаУДаления И НЕ Зад.Выполнена И 
	|		БП.Ссылка ЕСТЬ NULL И
	|		(БизнесПроцесс.Заказ = &Заказ ИЛИ БизнесПроцесс.Заказчик.Заказ = &Заказ);
	
	// Посчитаем их количество
	
	|ВЫБРАТЬ КОЛИЧЕСТВО(Ссылка) Задач ПОМЕСТИТЬ КоличествоЗадач ИЗ ЗадачиЗаказа;
	
	// Вытащим паралельную задачу чтобы закрыть ее
	
	|ВЫБРАТЬ Ссылка ИЗ ЗадачиЗаказа ГДЕ Ссылка.Параллельная И Ссылка.ТочкаМаршрута = &ТочкаСкорректировать И 2 В (ВЫБРАТЬ Задач ИЗ КоличествоЗадач)
	|");
	
	Запрос.УстановитьПараметр("Заказ", 					Заказчик.Заказ);
	Запрос.УстановитьПараметр("ТочкаСкорректировать", 	БизнесПроцессы.СборкаЗаказа.ТочкиМаршрута.СкорректироватьЗаказ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда Возврат Выборка.Ссылка КонецЕсли;
	
КонецФункции

Процедура ЕслиСорректироватьЗадача1ТогдаУбратьПараллельностьОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	ЗадачаСкорректировать = ПолучитьПоследнююЗадачуСкорректироватьЗаказ();
	
	Если ЗадачаСкорректировать <> Неопределено Тогда
		ЗадОб = ЗадачаСкорректировать.ПолучитьОбъект();
		ЗадОб.Параллельная = Ложь;
		ЗадОб.Записать(); КонецЕсли;
	
КонецПроцедуры

Процедура Условие1ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = Истина;
	
КонецПроцедуры

Процедура ЕслиСкоррекировать1ВыполнитьЗадачуОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	// Выполним задачу за логиста если она одна
	
	ЗадСкорректировать = ПолучитьПоследнююЗадачуСкорректироватьЗаказ();
	
	Если ЗадСкорректировать <> Неопределено Тогда
		
		ЗадОб = ЗадСкорректировать.ПолучитьОбъект();
		ЗадОб.ДополнительныеСвойства.Вставить("КонтрольАдресации", Ложь);
		ЗадОб.ВыполнитьЗадачу(); КонецЕсли;
	
КонецПроцедуры

Процедура ОтправитьВСборкуМинуяЛогистаОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	// Отправим дальше в сборку или в перемещение чтобы миновать задачу скорректировать у логиста
	
	КонечныйСклад = КонечныйСклад();
	Если Не (ЭтоВнутреннийЗаказ() И КонечныйСклад = СкладПолучатель) Тогда
		
		Сборка = Документы.СборочныйЛист.СоздатьДокумент();
		Сборка.УстановитьСсылкуНового(Документы.СборочныйЛист.ПолучитьСсылку(Новый УникальныйИдентификатор));
		
		Шапка 	= Новый Структура("Заказ, Склад, СборочныйЛист, ТипСборочногоЛиста", Заказчик.Заказ, СкладПолучатель, Сборка.ПолучитьСсылкуНового(), Перечисления.ТипыСборочныхЛистов.ФиксацияЯчеек);
		Товары 	= КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(Заказы.ПолучитьСостояниеТоваров(Заказчик.Заказ), Новый Структура("Размещение", СкладПолучатель));
		
		Если КонечныйСклад = СкладПолучатель Тогда   
			Если Не БизнесПроцессы.СборкаЗаказа.СоздатьСборку(Новый Структура("Шапка, Товары, ТоварыУсловие, ТоварыАлгоритм", 
						Шапка, 
						Товары, 
						"Строка.Состояние = Перечисления.СостояниеСборкиЗаказа.НеСобрано",
						"НовСтрока.ВСборке = Строка.Количество")) Тогда
						
				ВызватьИсключение "Ошибка при создании сборки минуя логиста "; КонецЕсли;
			
			Сборка.Заполнить(Новый Структура("Шапка, Товары, ТоварыУсловие, ТоварыАлгоритм", 
				Шапка,
				Товары,
				"Строка.Состояние = Перечисления.СостояниеСборкиЗаказа.НеСобрано И Строка.Количество > 0",
				"НовСтрока.Собрать = Строка.Количество"));
			Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Сборка, РежимЗаписиДокумента.Проведение) Тогда
				ВызватьИсключение "Ошибка при создании сборочного листа минуя логиста "; КонецЕсли;
		Иначе
			
			Если Справочники.Маршруты.ДобавитьПеремещение("Шапка, Товары, ТоварыУсловие", 
						Шапка, 
						Товары,
						"Строка.Состояние = Перечисления.СостояниеСборкиЗаказа.НеСобрано") Тогда
						
				ВызватьИсключение "Ошибка при создании пермещения минуя логиста "; КонецЕсли; КонецЕсли; КонецЕсли;
	
КонецПроцедуры

Процедура ЕстьЧтоОтправитьПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	// Если есть собранные товары на складе отправителе значит заказ можно будет переместить
	
	Результат = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(
					Заказы.ПолучитьСостояниеТоваров(Ссылка),
					Новый Структура("Размещение, Состояние", 
						СкладОтправитель, Перечисления.СостояниеСборкиЗаказа.ОжидаетПеремещения)).Количество();
КонецПроцедуры