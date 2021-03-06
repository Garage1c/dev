﻿
Функция ПользовательМожетИзменятьОчередьЗадачи(Задача1, Задача2 = Неопределено) Экспорт
	
	Если Не ОграничиватьПоЗаказчику() Тогда Возврат Истина КонецЕсли;
	
	Запрос = Новый Запрос(?(Задача2 = Неопределено, 
			"ВЫБРАТЬ ПЕРВЫЕ 1 ИСТИНА ИЗ РегистрСведений.ПраваНаЗадачи ГДЕ Пользователь = &ТекущийПользователь И Заказчик = &Заказчик1 ",
			"ВЫБРАТЬ ПЕРВЫЕ 1 ИСТИНА ИЗ РегистрСведений.ПраваНаЗадачи ГДЕ Пользователь = &ТекущийПользователь И (Заказчик = &Заказчик1 ИЛИ Заказчик = &Заказчик2)"));
			
										Запрос.УстановитьПараметр("ТекущийПользователь", 	ПараметрыСеанса.ТекущийПользователь);
										Запрос.УстановитьПараметр("Заказчик1", 				Задача1.Заказчик);
	Если Задача2 <> Неопределено Тогда 	Запрос.УстановитьПараметр("Заказчик2", 				Задача2.Заказчик) КонецЕсли;
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ОграничиватьПоЗаказчику()
	
	Возврат Не РольДоступна("ПолныеПрава");
	
КонецФункции
Функция ТекстУсловияПоЗаказчику()
	
	Возврат "
	|Задача.Заказчик = &ПустойЗаказчик Или Задача.Заказчик В(
	|	ВЫБРАТЬ Заказчик ИЗ РегистрСведений.ПраваНаЗадачи
	|	ГДЕ Пользователь = &ТекущийПользователь)";
	
КонецФункции

Функция ЗадачаМожетБытьВОчереди(Задача, Сообщать = Ложь) Экспорт
	
	Если Задача.Статус <> Перечисления.СтатусыЗадач.ВОчереди Тогда
		Если Сообщать Тогда
			ОбщиеФункции.СообщитьТекст("В очередь могут попадать только задачи со статусом ""В очереде"""); КонецЕсли;
		Возврат Ложь;
		
	Иначе Возврат Истина КонецЕсли;
	
КонецФункции
Функция ЗадачаЕстьПраваНаИзменения(Ссылка, Сообщать = Истина) Экспорт
	
	Если ОграничиватьПоЗаказчику() И Не Ссылка.Заказчик.Пустая() Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 ИСТИНА ИЗ РегистрСведений.ПраваНаЗадачи ГДЕ Пользователь = &ТекущийПользователь И Заказчик = &Заказчик");
		Запрос.УстановитьПараметр("Заказчик", 				Ссылка.Заказчик);
		Запрос.УстановитьПараметр("ТекущийПользователь", 	ПараметрыСеанса.ТекущийПользователь);
		
		Пустой = Запрос.Выполнить().Пустой();
		Если Пустой И Сообщать Тогда
			ОбщиеФункции.СообщитьТекст("У вас нет прав на изменение очереди ticket_" + Ссылка.Код + " """ + Ссылка + """"); КонецЕсли;
		
			Возврат Не Пустой;
	Иначе	Возврат Истина КонецЕсли;
	
КонецФункции

Функция ЗаписатьОчередьЗадачи(ЗаписьОчереди)
	
	// Проверим что только со статусом в очереди, можно записывать задачу
	
	Если Не ЗадачаМожетБытьВОчереди(ЗаписьОчереди.Задача) Тогда Возврат Ложь;
	Иначе														Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(ЗаписьОчереди); КонецЕсли;
	
КонецФункции

Функция ПолучитьОчередь(Ссылка) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Номер ИЗ  РегистрСведений.ОчередностьЗадач ГДЕ Задача = &Задача");
	Запрос.УстановитьПараметр("Задача", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Номер;
	Иначе
		Возврат 0 КонецЕсли;
	
КонецФункции

Функция ПолучитьПоследнийНомерЗадачи() Экспорт
	
	// Возвращает номер последей задачи
	
	Запрос = Новый Запрос("ВЫБРАТЬ МАКСИМУМ(Номер) Номер ИЗ РегистрСведений.ОчередностьЗадач");
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
			текНомер = ?(Выборка.Номер = null, 1, Выборка.Номер);
	Иначе 	текНомер = 0; КонецЕсли;
		
	Возврат текНомер;	
	
КонецФункции
Функция ПолучитьНомерПервойЗадачи(Закреплённая) Экспорт
	
	// Возвращает номер последей задачи
	
	Если ОграничиватьПоЗаказчику() Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ МИНИМУМ(Номер) Номер ИЗ РегистрСведений.ОчередностьЗадач ГДЕ " + ТекстУсловияПоЗаказчику() + " И Задача.Закреплённая = " + ?(Закреплённая, "ИСТИНА", "ЛОЖЬ"));
		Запрос.УстановитьПараметр("ТекущийПользователь", 	ПараметрыСеанса.ТекущийПользователь); 
		Запрос.УстановитьПараметр("ПустойЗаказчик", 		Справочники.ЗаказчикиЗадач.ПустаяСсылка());
	Иначе
		Запрос = Новый Запрос("ВЫБРАТЬ МИНИМУМ(Номер) Номер ИЗ РегистрСведений.ОчередностьЗадач ГДЕ Задача.Закреплённая = " + ?(Закреплённая, "ИСТИНА", "ЛОЖЬ"));КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
			текНомер = ?(Выборка.Номер = null, ПолучитьПоследнийНомерЗадачи(), Выборка.Номер);
	Иначе 	текНомер = ПолучитьПоследнийНомерЗадачи(); КонецЕсли;
		
	Возврат текНомер;
	
КонецФункции

Функция ПоставитьВОчередь(Ссылка, НомерИлиЗадачаПосле = Неопределено) Экспорт
	
	// НомерИлиЗадачаПосле - число номер порядковый номер задачи или ссылка на справочник задач перед
	//					которой нужно установить очередь
	//					если передать тогда все задачи увеличат свой номер, а текущая задача
	//					станет первой в очереди
	//
	//				если в ПередЗадачей вернуть пустую ссылку тогда
	//				текущая задача будет номер 1 и все задачи скатятся вниз (увеличат +1)
	//
	//				если в ПередЗадачей передать неопределено, тогда текущая задача встанет последней в очередь
	//
	//				если передать число тогда задача будет иметь этот номер и все задачи ниже увеличат свой номер
	//
	//
	//				нумерация идет от 1, нуля быть не должно
	
	// Определим номер
	
	Перем текНомер;
	
	Если Не ЗадачаМожетБытьВОчереди(Ссылка) Тогда Возврат Ложь КонецЕсли;
		
	
	Если ТипЗнч(НомерИлиЗадачаПосле) = Тип("СправочникСсылка.Задачи") Тогда
		
		Если НомерИлиЗадачаПосле.Пустая() Тогда
			текНомер = ПолучитьНомерПервойЗадачи(Ссылка.Закреплённая);
		Иначе
			текНомер = ПолучитьОчередь(НомерИлиЗадачаПосле); 
			//Если текНомер = 1 Тогда текНомер = Неопределено КонецЕсли; 
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(НомерИлиЗадачаПосле) = Тип("Число") Тогда
			
		текНомер = НомерИлиЗадачаПосле; 
			
	Иначе	// поставим в конец очереди
		
		текНомер = ПолучитьПоследнийНомерЗадачи() + 1; КонецЕсли;
		
	// Увеличим всем на + 1
	
	Набор = РегистрыСведений.ОчередностьЗадач.СоздатьНаборЗаписей();
	Набор.Прочитать();
	Выгрузка 	= Набор.Выгрузить();
	Для Каждого Строка Из Выгрузка Цикл Если Строка.Номер >= текНомер Тогда Строка.Номер = Строка.Номер + 1; КонецЕсли; КонецЦикла;
	
	// Установим текую задачу
	
	текСтрока 		= Выгрузка.Найти(Ссылка, "Задача");
	Если текСтрока 	= Неопределено Тогда текСтрока = Выгрузка.Добавить(); текСтрока.Задача = Ссылка; КонецЕсли;
	текСтрока.Номер = текНомер;
	
	// Запишем	
	
	Набор.Загрузить(Выгрузка);
	Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Набор);
	
КонецФункции

Функция ПодвинутьВперед(Ссылка) Экспорт
	
	// Ищет задачу впереди и меняется с ней местами
	
	Перем МенЗадача;
	
	Если Не ЗадачаМожетБытьВОчереди(Ссылка) Тогда Возврат Ложь КонецЕсли;
	Если Не ЗадачаЕстьПраваНаИзменения(Ссылка) Тогда Возврат Ложь КонецЕсли;
	
	МенНомер = 1;
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Номер, Задача ИЗ РегистрСведений.ОчередностьЗадач ГДЕ Номер < " + Формат(ПолучитьОчередь(Ссылка), "ЧН=0; ЧГ=") + 
				?(ОграничиватьПоЗаказчику(), " И (" + ТекстУсловияПоЗаказчику() + ")", "") + 
				" И Задача.Закреплённая = " + ?(Ссылка.Закреплённая, "ИСТИНА", "ЛОЖЬ") + " УПОРЯДОЧИТЬ ПО Номер Убыв");
	Запрос.УстановитьПараметр("ПустойЗаказчик", 		Справочники.ЗаказчикиЗадач.ПустаяСсылка());
	Запрос.УстановитьПараметр("ТекущийПользователь", 	ПараметрыСеанса.ТекущийПользователь);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда МенЗадача = Выборка.Задача; МенНомер = Выборка.Номер; КонецЕсли;
	
	текНомер = ПолучитьОчередь(Ссылка);
	
	Если МенЗадача = Неопределено Тогда Возврат Истина КонецЕсли; // это самый первый, значит ничего менять не нужно
	
	Возврат ПоменятьНомераЗадач(МенЗадача, текНомер, Ссылка, МенНомер);
	
КонецФункции
Функция ПодвинутьНазад(Ссылка) Экспорт
	
	// Ищет задачу позади и меняется с ней местами
	
	Перем МенЗадача;
	
	Если Не ЗадачаМожетБытьВОчереди(Ссылка) Тогда Возврат Ложь КонецЕсли;
	Если Не ЗадачаЕстьПраваНаИзменения(Ссылка) Тогда Возврат Ложь КонецЕсли;
	
	МенНомер = 1;
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Номер, Задача ИЗ РегистрСведений.ОчередностьЗадач ГДЕ Номер > " + Формат(ПолучитьОчередь(Ссылка), "ЧН=0; ЧГ=") +
				?(ОграничиватьПоЗаказчику(), " И (" + ТекстУсловияПоЗаказчику() + ")", "") + 
				" И Задача.Закреплённая = " + ?(Ссылка.Закреплённая, "ИСТИНА", "ЛОЖЬ") + " УПОРЯДОЧИТЬ ПО Номер");
	Запрос.УстановитьПараметр("ПустойЗаказчик", 		Справочники.ЗаказчикиЗадач.ПустаяСсылка());
	Запрос.УстановитьПараметр("ТекущийПользователь", 	ПараметрыСеанса.ТекущийПользователь);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда МенЗадача = Выборка.Задача; МенНомер = Выборка.Номер; КонецЕсли;
	
	текНомер = ПолучитьОчередь(Ссылка);
	
	Если МенЗадача = Неопределено Тогда Возврат Истина КонецЕсли; // это самый последний, значит ничего менять не нужно
	
	Возврат ПоменятьНомераЗадач(МенЗадача, текНомер, Ссылка, МенНомер);
	
КонецФункции
Функция ПоменятьНомераЗадач(Задача1, Номер1, Задача2, Номер2) Экспорт
	
	Если Задача1.Закреплённая <> Задача2.Закреплённая Тогда
		ОбщиеФункции.СообщитьТекст("Закреплённую задач с не закреплённой менять местами запрещено!");
		Возврат Ложь; КонецЕсли;
	
	НачатьТранзакцию();
	
	Если Задача1 <> Неопределено Тогда
		
		Запись1 = РегистрыСведений.ОчередностьЗадач.СоздатьМенеджерЗаписи();
		Запись1.Задача 	= Задача1;
		Запись1.Номер 	= Номер1; 
		
		Если Не ЗаписатьОчередьЗадачи(Запись1) Тогда
			ОтменитьТранзакцию(); Возврат Ложь; КонецЕсли; КонецЕсли;
	
	Если Задача2 <> Неопределено Тогда
		Запись2 = РегистрыСведений.ОчередностьЗадач.СоздатьМенеджерЗаписи();
		Запись2.Задача 	= Задача2;
		Запись2.Номер 	= Номер2;
	
		Если Не ЗаписатьОчередьЗадачи(Запись2) Тогда
			ОтменитьТранзакцию(); Возврат Ложь; КонецЕсли; КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
	
КонецФункции


Функция ОтсортироватьПоОтделам() Экспорт
	
	
	// Сортирует задачи так чтобы отделы шли последовательно в общей очереди
	
	НовНабор 	= РегистрыСведений.ОчередностьЗадач.СоздатьНаборЗаписей();
	ТЗНабор 	= НовНабор.ВыгрузитьКолонки();
	текНомер 	= 1;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ Ссылка Задача, Заказчик, Номер
	|ПОМЕСТИТЬ	СписокЗадач
	|ИЗ			Справочник.Задачи Спр
	|
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ	РегистрСведений.ОчередностьЗадач Рег
	|ПО	Спр.Ссылка = Рег.Задача
	|
	|ГДЕ Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗадач.ВОчереди);
	
	|ВЫБРАТЬ Заказчик, МАКСИМУМ(ЕСТЬNULL(Заказчик.РешатьЗадачЗаРаз, 0)) ЗаРаз, МИНИМУМ(Номер) Номер
	|ИЗ СписокЗадач
	|СГРУППИРОВАТЬ ПО Заказчик
	|УПОРЯДОЧИТЬ ПО Номер;
	
	|ВЫБРАТЬ * ИЗ СписокЗадач
	|УПОРЯДОЧИТЬ ПО Номер");
	
	Пакет = Запрос.ВыполнитьПакет();
	//ПорядокЗаказчиков 	= Пакет[1].Выгрузить().ВыгрузитьКолонку("Заказчик");
	ПорядокЗаказчиков 	= Пакет[1].Выгрузить();
	текЗадачи 			= Пакет[2].Выгрузить();
	текЗадачи.Индексы.Добавить("Заказчик");
	
	// Супер зациленоуцикленый кусок кода, лень делать быстро
	
	БылоДобавление = Истина;
	Пока БылоДобавление Цикл // в бесконечность
		БылоДобавление = Ложь; // а если не было тогда проверили всех
		
		Для Каждого СтрокаЗаказчик ИЗ ПорядокЗаказчиков Цикл
			Заказчик = СтрокаЗаказчик.Заказчик;
			
			Для Ном = 1 По СтрокаЗаказчик.ЗаРаз Цикл
			
				ЗадачиЗаказчика = текЗадачи.НайтиСтроки(Новый Структура("Заказчик", Заказчик));
				Для Каждого Строка Из ЗадачиЗаказчика Цикл
					Если ТЗНабор.Найти(Строка.Задача, "Задача") = Неопределено Тогда
						
						БылоДобавление = Истина;
						
						НовЗапись = ТЗНабор.Добавить();
						НовЗапись.Задача 	= Строка.Задача;
						НовЗапись.Номер 	= текНомер;
						
						текНомер = текНомер + 1;
						Прервать; КонецЕсли; КонецЦикла; КонецЦикла; КонецЦикла; КонецЦикла;
	
	// Теперь подготовленную таблицу в набор
	
	НовНабор.Загрузить(ТЗНабор);
	
	Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(НовНабор);
	
КонецФункции

Функция ПолучитьСреднееЧислоОбращений() Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Задачи.ДатаСоздания,
	                      |	КОЛИЧЕСТВО(Задачи.Ссылка) КАК КоличествоЗадач
	                      |ПОМЕСТИТЬ КоличествоЗадачВДень
	                      |ИЗ
	                      |	Справочник.Задачи КАК Задачи
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Задачи.ДатаСоздания
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СРЕДНЕЕ(КоличествоЗадачВДень.КоличествоЗадач) КАК КоличествоЗадач
	                      |ИЗ
	                      |	КоличествоЗадачВДень КАК КоличествоЗадачВДень");
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КоличествоЗадач; КонецЕсли;
	Возврат 0;
			
КонецФункции

Процедура ПроверитьНаблюдателейПоУмолчаниюИНазначитьЕслиИхНет(ЗадачаСсылка) Экспорт
	
	// Смотрит если наблюдатель не назначен то назначает из настроек заказчика
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ Наблюдатель ИЗ Справочник.ЗаказчикиЗадач.Наблюдатели Спр
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ	РегистрСведений.ОтслеживаниеЗадач Рег
	|ПО					Спр.Ссылка = Рег.Пользователь
	|
	|ГДЕ Ссылка = &Заказчик И Рег.Пользователь ЕСТЬ NULL
	|");
	
	Запрос.УстановитьПараметр("Заказчик", ЗадачаСсылка.Заказчик);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() Тогда
		
		Набор = РегистрыСведений.ОтслеживаниеЗадач.СоздатьНаборЗаписей();
		Набор.Отбор.Задача.Установить(ЗадачаСсылка);
		//Набор.Прочитать();
		
		Пока Выборка.Следующий() Цикл 
		
			Запись = Набор.Добавить();
			Запись.Задача 		= ЗадачаСсылка;
			Запись.Пользователь = Выборка.Наблюдатель; КонецЦикла;
		
		ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Набор); КонецЕсли;
	
КонецПроцедуры