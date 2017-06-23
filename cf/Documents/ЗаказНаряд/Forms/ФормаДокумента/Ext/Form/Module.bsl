﻿
&НаКлиенте
Перем текИндексСтроки;

&НаКлиенте
Перем СтруктураКолонокЗапчасти Экспорт;
&НаКлиенте
Перем СтруктураКолонокРаботы Экспорт;
&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;


// РАБОТА С ТАБЛИЦАМИ

&НаСервере
Процедура ПрочитатьТаблицы(ИндексСтрокиНоменклатуры)
	
	// Получим из формы
	
	ТаблицаЗапчасти = ДанныеФормыВЗначение(Запчасти, Тип("ТаблицаЗначений"));
	ТаблицаРаботы 	= ДанныеФормыВЗначение(Работы, Тип("ТаблицаЗначений"));
	
	// Прочитаем запчасти
	
	ТаблицаЗапчасти.Очистить();
	
	КонвертацияТипов.ДобавитьТаблицуКДругойТаблице(
					ТаблицаЗапчасти,
					Объект.Запчасти.НайтиСтроки(Новый Структура("ИндексСтрокиНоменклатуры", ИндексСтрокиНоменклатуры))
													);
	// Прочитаем работы
	
	ТаблицаРаботы.Очистить();
	
	КонвертацияТипов.ДобавитьТаблицуКДругойТаблице(
					ТаблицаРаботы,
					Объект.Работы.НайтиСтроки(Новый Структура("ИндексСтрокиНоменклатуры", ИндексСтрокиНоменклатуры))
													);
	
	// Перешлем в форму
													
	ЗначениеВДанныеФормы(ТаблицаЗапчасти, 	Запчасти);
	ЗначениеВДанныеФормы(ТаблицаРаботы, 	Работы);
	
КонецПроцедуры
&НаСервере
Процедура ЗапомнитьТаблицу(Таблица, ТаблицаОбъекта, ИндексСтрокиНоменклатуры)
	
	// Удалим из объекта все записи таблицы
	
	СтрокиВОбъекте = ТаблицаОбъекта.НайтиСтроки(Новый Структура("ИндексСтрокиНоменклатуры", ИндексСтрокиНоменклатуры));
	КолУдСтрок = СтрокиВОбъекте.Количество();
	Для ном = 1 По КолУдСтрок Цикл
		ТаблицаОбъекта.Удалить(СтрокиВОбъекте[КолУдСтрок - Ном]);
	КонецЦикла;
	
	// Добавим записи в таблицу
	
	Для Каждого Строка Из Таблица Цикл
		новСтрока = ТаблицаОбъекта.Добавить();
		ЗаполнитьЗначенияСвойств(новСтрока, Строка);
		новСтрока.ИндексСтрокиНоменклатуры = ИндексСтрокиНоменклатуры;
	КонецЦикла;
						
КонецПроцедуры
&НаСервере
Процедура ЗапомнитьТаблицы(ИндексСтрокиНоменклатуры)
	
	Если ИндексСтрокиНоменклатуры <> Неопределено Тогда
		
		// Получим из формы
	
		ТаблицаЗапчасти = ДанныеФормыВЗначение(Запчасти, Тип("ТаблицаЗначений"));
		ТаблицаРаботы 	= ДанныеФормыВЗначение(Работы, Тип("ТаблицаЗначений"));
		
		// Сохраним запчасти
		
		ЗапомнитьТаблицу(ТаблицаЗапчасти, Объект.Запчасти, ИндексСтрокиНоменклатуры);
		
		// Сохраним работы
		
		ЗапомнитьТаблицу(ТаблицаРаботы, Объект.Работы, ИндексСтрокиНоменклатуры);
			
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура СместитьИндексыТаблицНаОднуВниз(ИндексСтрокиНоменклатуры, Таблица)
	
	Для Каждого Строка Из Таблица Цикл
		
		Если Строка.ИндексСтрокиНоменклатуры > ИндексСтрокиНоменклатуры Тогда
			Строка.ИндексСтрокиНоменклатуры = Строка.ИндексСтрокиНоменклатуры - 1;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСтрокуТовара()
	
	Если текИндексСтроки <> Неопределено Тогда
		
		СтрокаТовара = Объект.Товары[текИндексСтроки];
		
		//СтрокаТовара.СуммаБезСкидки	= Запчасти.Итог("Всего") + Работы.Итог("Сумма");
		СтрокаТовара.Сумма 		= Запчасти.Итог("Всего") + Работы.Итог("Сумма");
		СтрокаТовара.Выработка 	= СтрокаТовара.Сумма - Запчасти.Итог("СуммаСебестоимости");
		
		СтрокаТовара.СуммаАвтоматическойСкидки = ?(СтрокаТовара.Гарантия, СтрокаТовара.Сумма, 0);
		
		ФункцииФормДокументов.РассчитатьСуммыТабличныхЧастей(СтрокаТовара, СтруктураКолонокТовары);
		//ФункцииФормДокументов.РассчитатьСуммыСтрокиОтЦены(СтрокаТовара, СтруктураКолонокТовары, Ложь);
		
		//СтрокаТовара.Выработка 	= СтрокаТовара.Сумма - Запчасти.Итог("СуммаСебестоимости");
		
		ОбновитьИнформационныеНадписи();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновитьтаблицы()
	
	новИндекс = Объект.Товары.Индекс(Элементы.Товары.ТекущиеДанные);
	
	Если новИндекс <> текИндексСтроки Тогда
		
		стМодифицированность = Модифицированность;
		
		// Запомним старые
		ЗапомнитьТаблицы(текИндексСтроки);
	
		// Прочитаем новые
		текИндексСтроки = новИндекс;
	
		ПрочитатьТаблицы(текИндексСтроки);
		
		Модифицированность = стМодифицированность;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РазрешенаЗапись()
	
	Возврат ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(БизнесПроцесс, БизнесПроцессы.РемонтИнструмента.ТочкиМаршрута.ПроизвестиДефектовку) ИЛИ РольДоступна("ПолныеПрава") ИЛИ РольДоступна("ПолныеПраваВОбласти");
	
КонецФункции
&НаСервере
Функция РазрешеноПроведение()
	
	Возврат ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(БизнесПроцесс, БизнесПроцессы.РемонтИнструмента.ТочкиМаршрута.СогласованиеСКлиентом) ИЛИ РольДоступна("ПолныеПрава") ИЛИ РольДоступна("ПолныеПраваВОбласти");
	
КонецФункции
&НаСервере
Процедура ВидимостьДоступность()
	
	Элементы.ПерейтиНаБизнесПроцесс.Доступность = Не БизнесПроцесс.Пустая();
	
	Если Не БизнесПроцесс.Пустая() Тогда
		
		РазрешенаЗапись 	= РазрешенаЗапись();
		РазрешеноПроведение = РазрешеноПроведение();
		
		// Установим доступность кнопок
		
		Если Элементы.Найти("КнопкаПровестиИЗакрыть") <> Неопределено Тогда
			Элементы.КнопкаПровестиИЗакрыть.Доступность = РазрешеноПроведение;
		КонецЕсли;
		Если Элементы.Найти("КнопкаПровести") <> Неопределено Тогда
			Элементы.КнопкаПровести.Доступность = РазрешеноПроведение;
		КонецЕсли;
		Элементы.КнопкаЗаписать.Доступность 		= РазрешенаЗапись;
		Элементы.КнопкаЗаписатьИЗакрыть.Доступность	= РазрешенаЗапись;
		
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ОбновитьИнформационныеНадписи()
	
	СуммаЗапчастей 			= Объект.Запчасти.Итог("Всего");
	СебестоимостьЗапчастей 	= Объект.Запчасти.Итог("СуммаСебестоимости");
	СуммаРабот 				= Объект.Работы.Итог("Сумма");
	
КонецПроцедуры


// ПРЕДОПРЕДЕЛЕННЫЕ ПРОЦЕДУРЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		//ФункцииФормДокументов.ЗаполнитьРеквизитыДокументаПоУмолчанию(Объект);
		ФункцииФормДокументов.ЗаполнитьЗначенияПоУмолчанию(Объект, ФункцииФормДокументов.ПолучитьРеквизитыДокумента(Документы.ЗаказНаряд.ПустаяСсылка()));
		
		Если 	Объект.Контрагент.Пустая() И
				Не Параметры.Контрагент.Пустая() Тогда
			
			Объект.Контрагент = Параметры.Контрагент;
            ФункцииФормДокументов.КонтрагентПриИзменении(Объект);
			
		КонецЕсли;
		Если НЕ Параметры.Организация.Пустая() Тогда
			
			Объект.Организация = Параметры.Организация;
			ФункцииФормДокументов.ОрганизацияПриИзменении(Объект);
			
		КонецЕсли;
	
		Если 	БизнесПроцесс.Пустая() И
				Не Параметры.БизнесПроцесс.Пустая() Тогда
			
			БизнесПроцесс = Параметры.БизнесПроцесс;
			
			ЗаполнитьЗначенияСвойств(Объект, БизнесПроцесс, "Склад");
			
		КонецЕсли;
		
		
		Если 	Не ПустаяСтрока(Параметры.Товары) И
				Не Объект.Товары.Количество() Тогда
				
			Объект.Товары.Загрузить(ЗначениеИзСтрокиВнутр(Параметры.Товары));
	
		КонецЕсли;
 	
		Объект.СуммаВключаетНДС = Истина;
		Объект.Услуга = Константы.УслугаРемонтПоУмолч.Получить();
		
	Иначе
		
		// Считаем бизнес процесс если есть
		
		БизнесПроцесс = Документы.ЗаказНаряд.БизнесПроцесс(Объект.Ссылка);
		
		// Проверим возможность редактирования заказа в зависимости от положения БП
		
		Если Не БизнесПроцесс.пустая() Тогда
			
			Если БизнесПроцесс.Завершен И НЕ (РольДоступна("ПолныеПрава") ИЛИ РольДоступна("ПолныеПраваВОбласти")) Тогда
				
				ТолькоПросмотр = Истина;
				
			ИначеЕсли Не (ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(БизнесПроцесс, БизнесПроцессы.РемонтИнструмента.ТочкиМаршрута.ПроизвестиДефектовку)) И НЕ РольДоступна("ПолныеПрава") И НЕ РольДоступна("ПолныеПраваВОбласти") Тогда
				
				Элементы.Товары.ТолькоПросмотр 			= Истина;
				Элементы.Работы.ТолькоПросмотр 			= Истина;
				Элементы.Запчасти.ТолькоПросмотр 		= Истина;
				Элементы.ВыездныеРаботы.ТолькоПросмотр 	= Истина;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	//ФункцииФормДокументов.ПересчитатьСуммыТабличныхЧастей(Объект.Товары, ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Объект.СуммаВключаетНДС, Объект.ТипЦен, "Товары",, Объект.Валюта, Объект.УчитыватьНДС));

	// Рассчитаем динамические колонки
	
	ФункцииФормДокументов.РассчитатьДинамическиеКолонки(
					Объект.Товары,
					ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Объект.СуммаВключаетНДС, Объект.ТипЦен, "Товары"));
					
	ФункцииФормДокументов.РассчитатьДинамическиеКолонки(
					Объект.Запчасти,
					ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Запчасти, Объект.СуммаВключаетНДС, Объект.ТипЦен, "ТаблицаЗапчасти"));
					
	ФункцииФормДокументов.РассчитатьДинамическиеКолонки(
					Объект.Работы,
					ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Работы, Объект.СуммаВключаетНДС, Объект.ТипЦен, "ТаблицаРаботы"));
					
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
					
	// Обновим информацию
					
	ОбновитьИнформационныеНадписи();
	ВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтруктураКолонокЗапчасти 	= ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Запчасти, 	Объект.СуммаВключаетНДС, Объект.ТипЦен, "ТаблицаЗапчасти");
	СтруктураКолонокРаботы 		= ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Работы, 	Объект.СуммаВключаетНДС, Объект.ТипЦен, "ТаблицаРаботы");
	СтруктураКолонокТовары		= ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, 	Объект.СуммаВключаетНДС, Объект.ТипЦен, "Товары",, Объект.Валюта, Объект.УчитыватьНДС);
	
КонецПроцедуры
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ЗапомнитьТаблицы(текИндексСтроки);
	
	ПроверитьУслугиИЗапчасти(Отказ);
	ПроверитьРемонтируемыйТовар(Отказ);
	
КонецПроцедуры
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
//	ТекущийОбъект.Сумма = Объект.Товары.Итог("Всего");
//	ТекущийОбъект.Скидка = Объект.Товары.Итог("СуммаАвтоматическойСкидки");
	
КонецПроцедуры
&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Сохраним привязку к бизнес процессу
	
	Если 	Не БизнесПроцесс.Пустая() И
			БизнесПроцесс.ЗаказНаряд.Пустая() Тогда
			
		Процесс = БизнесПроцесс.ПолучитьОбъект();
		Процесс.ЗаказНаряд = ТекущийОбъект.Ссылка;
		
		Попытка
			Процесс.Записать();
		Исключение
			стрОшибки = ОписаниеОшибки();
			ОбщиеФункции.СообщитьТекст("Ошибка при записи связи заказ наряда к бизнес процессу ремонта
							|" + стрОшибки);
			Отказ = Истина;
		КонецПопытки;
		
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПроверитьУслугиИЗапчасти(Отказ)
	
	Для Каждого СтрокаТовары из Объект.Товары Цикл
		Отбор = Новый Структура();
		Отбор.Вставить("УслугаСЗапчастями", Истина);
		Отбор.Вставить("ИндексСтрокиНоменклатуры", СтрокаТовары.НомерСтроки-1);
		СтрокиРабота = Объект.Работы.НайтиСтроки(Отбор);
		Если СтрокиРабота.Количество() > 1 Тогда
			Сообщить("У ремонтируемого товара: " + СтрокаТовары.Номенклатура +  " в строке:" + СтрокаТовары.НомерСтроки + ", выбрано больше одной услуги с признаком ""Услуга с запчастями""");
			Отказ = Истина;
		КонецЕсли;
		
		Отбор = Новый Структура();
		Отбор.Вставить("ИндексСтрокиНоменклатуры", СтрокаТовары.НомерСтроки-1);
		СтрокиЗапчасти = Объект.Запчасти.НайтиСтроки(Отбор);
		Если СтрокиЗапчасти.Количество() > 0 И СтрокиРабота.Количество() = 0 Тогда
			Сообщить("У ремонтируемого товара: " + СтрокаТовары.Номенклатура +  " в строке:" + СтрокаТовары.НомерСтроки + ", для запчастей не выбрана услуга с признаком ""Услуга с запчастями""");
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьРемонтируемыйТовар(Отказ)
	
	ТаблицаТовары =	Объект.Товары.Выгрузить();
	ТаблицаТовары.Свернуть("Номенклатура, Неисправность, Гарантия");  
	
	Если ТаблицаТовары.Количество() <> Объект.Товары.Количество() Тогда
		Сообщить("В таблице ремонтируемых товаров есть одинаковые товары с одинаковыми значениями неисправность и гарантия");
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	ОбновитьТаблицы();
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	ОбновитьТаблицы();
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	Запчасти.Очистить();
	Работы.Очистить();
	
	ЗапомнитьТаблицы(текИндексСтроки);
	
	// Нужно сместить все индексы таблиц на одну единицу
	СместитьИндексыТаблицНаОднуВниз(текИндексСтроки, Объект.Запчасти);
	СместитьИндексыТаблицНаОднуВниз(текИндексСтроки, Объект.Работы);
	
	// Прочитаем новые значения
	ПрочитатьТаблицы(текИндексСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщиеРеквизиты(Команда)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизиты(ЭтаФорма);
	
КонецПроцедуры
&НаСервере
Процедура ПересчитатьСуммыТабличныхЧастей(СтруктураКолонокТовары) Экспорт
	
	СтруктураКолонокЗапчасти  = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Запчасти, 	Объект.СуммаВключаетНДС, Объект.ТипЦен, "ТаблицаЗапчасти");
	
	Для Каждого Строка Из Объект.Товары Цикл
		
		текИндекс = Объект.Товары.Индекс(Строка);
		ПрочитатьТаблицы(текИндекс);
		
		Для Каждого СтрокаЗапчасти Из Запчасти Цикл
			ФункцииФормДокументов.РассчитатьСуммыСтрокиОтЦены(
			СтрокаЗапчасти, 
			СтруктураКолонокЗапчасти);
		КонецЦикла;
		
		Для Каждого СтрокаРабота Из Работы Цикл
			
			СтрокаРабота.Сумма = СтрокаРабота.Количество * Строка.ЦенаЗаЧас;
		КонецЦикла;
		
		
		ЗапомнитьТаблицы(текИндекс);
		
		// при изменении строк запчастей пересчитываем строку товара		
		Если текИндекс <> Неопределено Тогда
			
			СтрокаТовара = Объект.Товары[текИндекс];
			
			СтрокаТовара.Сумма 		= Запчасти.Итог("Всего") + Работы.Итог("Сумма");
			СтрокаТовара.Выработка 	= СтрокаТовара.Сумма - Запчасти.Итог("СуммаСебестоимости");
			
			СтрокаТовара.СуммаАвтоматическойСкидки = ?(СтрокаТовара.Гарантия, СтрокаТовара.Сумма, 0);
			
			ФункцииФормДокументов.РассчитатьСуммыТабличныхЧастей(СтрокаТовара, СтруктураКолонокТовары);
			
			ОбновитьИнформационныеНадписи();
			
		КонецЕсли;
		
		
	КонецЦикла;

	
КонецПроцедуры
&НаКлиенте
Процедура ПерейтиНаБизнесПроцесс(Команда)
	
	Если Не БизнесПроцесс.Пустая() Тогда
		
		ОткрытьФорму("БизнесПроцесс.РемонтИнструмента.ФормаОбъекта", Новый Структура("Ключ", БизнесПроцесс));
		
	КонецЕсли;
	
КонецПроцедуры


// РЕДАКТИРОВАНИЕ ТАБЛИЦ


&НаКлиенте
Процедура ТаблицаЗапчастиНоменклатураПриИзменении(Элемент)
	
	// Переопределим тип ыены, т.к. она изменяется только в товарах
	
	СтруктураКолонокЗапчасти.ТипЦен = СтруктураКолонокТовары.ТипЦен;
	СтруктураКолонокЗапчасти.Валюта = СтруктураКолонокТовары.Валюта;	
	// Установим количество
	
	текСтрока = Элементы.Запчасти.ТекущиеДанные;
	
	Если Не текСтрока.Количество Тогда
		текСтрока.Количество = 1;
	КонецЕсли;
	
	// Пошлем на обработку
	
	ФункцииФормДокументов.НоменклатураПриИзменении(
				Элементы.Запчасти, 
				СтруктураКолонокЗапчасти);
				
	// Пересчитаем строку
				
	ПересчитатьСтрокуТовара();
				
КонецПроцедуры
&НаКлиенте
Процедура ТаблицаЗапчастиЦенаПриИзменении(Элемент)
	
	ФункцииФормДокументов.ЦенаПриИзменении(
				Элементы.Запчасти, 
				СтруктураКолонокЗапчасти);
				
	ПересчитатьСтрокуТовара();
	
КонецПроцедуры
&НаКлиенте
Процедура ТаблицаЗапчастиКоличествоПриИзменении(Элемент)
	
	ФункцииФормДокументов.КоличествоПриИзменении(
				Элементы.Запчасти, 
				СтруктураКолонокЗапчасти);
				
	ПересчитатьСтрокуТовара();
	
КонецПроцедуры
&НаКлиенте
Процедура ТаблицаЗапчастиСуммаПриИзменении(Элемент)
	
	ФункцииФормДокументов.СуммаПриИзменении(
				Элементы.Запчасти, 
				СтруктураКолонокЗапчасти);
				
	ПересчитатьСтрокуТовара();
	
КонецПроцедуры
&НаКлиенте
Процедура ТаблицаЗапчастиСуммаСебестоимостиПриИзменении(Элемент)
	
	ПересчитатьСтрокуТовара();
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
	
		ТекДанные = Элементы.Товары.ТекущиеДанные;
		Если ТекДанные <> Неопределено Тогда
			
			Элемент.ТекущиеДанные.Цена = ТекДанные.ЦенаЗаЧас;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ТаблицаРаботыНоменклатураПриИзменении(Элемент)
	
	ФункцииФормДокументов.НоменклатураПриИзменении(
				Элементы.Работы, 
				СтруктураКолонокРаботы);
				
	ПересчитатьСтрокуТовара();
	
КонецПроцедуры
&НаКлиенте
Процедура ТаблицаРаботыКоличествоПриИзменении(Элемент)
	
	//ФункцииФормДокументов.КоличествоПриИзменении(
	//			Элементы.Работы, 
	//			СтруктураКолонокРаботы);
	
	ТекДанные = Элементы.Работы.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		
		ТекДанные.Сумма = ТекДанные.Количество * Объект.Товары[текИндексСтроки].ЦенаЗаЧас;
			
	КонецЕсли;
	
	ПересчитатьСтрокуТовара();
				
КонецПроцедуры
&НаКлиенте
Процедура ТаблицаРаботыЦенаПриИзменении(Элемент)
	
	ФункцииФормДокументов.ЦенаПриИзменении(
				Элементы.Работы, 
				СтруктураКолонокРаботы);
				
	ПересчитатьСтрокуТовара();
	
КонецПроцедуры
&НаКлиенте
Процедура ТаблицаРаботыСуммаПриИзменении(Элемент)
	
	ФункцииФормДокументов.СуммаПриИзменении(
				Элементы.Работы, 
				СтруктураКолонокРаботы);
				
	ПересчитатьСтрокуТовара();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаЗаЧасПриИзменении(Элемент)
	
	// Изменим цену у всех работ
	
	ЭлементЦены = Элементы.Работы.ПодчиненныеЭлементы.ТаблицаРаботыЦена;
	
	ТекДанные 	= Элементы.Товары.ТекущиеДанные;
	Индекс 		= Объект.Товары.Индекс(ТекДанные);
	ЦенаЗаЧас = ТекДанные.ЦенаЗаЧас;
	
	//СтрокиРабот = Работы.НайтиСтроки(Новый Структура("ИндексСтрокиНоменклатуры", Индекс));
	Для Каждого Строка Из Работы Цикл
		Строка.Цена = ЦенаЗаЧас;
		//ФункцииФормДокументов.РассчитатьСуммыТабличныхЧастей(Строка, СтруктураКолонокРаботы);
		ФункцииФормДокументов.РассчитатьСуммыСтрокиОтЦены(Строка, СтруктураКолонокРаботы, Ложь);
	КонецЦикла;
	
	// пересчитаем изменившиюся сумму
	
	ПересчитатьСтрокуТовара();
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыСтавкаНДСПриИзменении(Элемент)
	
	ФункцииФормДокументов.СтавкаНДСПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);
				
КонецПроцедуры
&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	// Установим цену за час
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	ТекДанные.ЦенаЗаЧас = РаботаСНоменклатурой.ПолучитьЦенуЗаЧасРемонтаИнструмента(ТекДанные.Номенклатура);
	
	// Устаовим количество
	
	Если Не ТекДанные.Количество Тогда
		ТекДанные.Количество = 1;
	КонецЕсли;
	
	// пересичтаем строку
	
	ФункцииФормДокументов.НоменклатураПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыПослеУдаления(Элемент)
	
	ПересчитатьСтрокуТовара();
	
КонецПроцедуры
&НаКлиенте
Процедура ЗапчастиПослеУдаления(Элемент)
	
	ПересчитатьСтрокуТовара();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СобытияСистемы.ОповеститьОЗаписиЗаказНаряда(Объект, ЭтаФорма);
	
КонецПроцедуры
&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Попытка
		Записать();
	Исключение
		Возврат;
	КонецПопытки;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНеисправностьОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ФункцииФормДокументов.ОкончанияВводаТекстаНеисправности(ЭтаФорма, Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Комментарий товара

&НаКлиенте
Процедура ТоварыКомментарийОткрытие(Элемент, СтандартнаяОбработка)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекДанные <> Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
	
		Форма = ПолучитьФорму("ОбщаяФорма.РедактированияВыражения", 
	                  Новый Структура("Выражение, ТекстПомощи", 
					  	 ТекДанные.Комментарий, 
						 "Комментарий для товара"), 
					Элемент);
					
		Форма.Заголовок = ТекДанные.Номенклатура;
		
		Форма.ОткрытьМодально();
		
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыКомментарийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		
		Элементы.Товары.ТекущиеДанные.Комментарий = ВыбранноеЗначение;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УслугаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Форма = ПолучитьФорму("Справочник.Номенклатура.Форма.ФормаВыбора");
	
	ЭлементОтбора = Форма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипНоменклатуры");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.ПравоеЗначение = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Услуга");
	
	Форма.Элементы.Список.Отображение = ОтображениеТаблицы.Список;			
	
	ТекЗнач = Форма.ОткрытьМодально();
    Если ТекЗнач <> Неопределено Тогда
        Объект.Услуга = ТекЗнач; 
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗапчастиПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре();
	
КонецПроцедуры

// ИНФОРМАЦИЯ О ТОВАРЕ

&НаСервере
Процедура ОбработатьОтображениеИнформацииОТоваре() Экспорт
	
	РаботаСНоменклатурой.ОбработатьОтображениеИнформацииОТоваре(ЭтаФорма, "Запчасти", "Запчасти");
	
КонецПроцедуры

&НаКлиенте
Процедура ИнфТовараТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиент.ИнфТовараТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка, "Запчасти");
	
КонецПроцедуры
&НаКлиенте
Процедура ИнфТовараЗаголовокHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиент.ИнфТовараЗаголовокHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка, "Запчасти", "Запчасти");
	
КонецПроцедуры

 &НаКлиенте
Процедура ПоказатьСкрытьИнфОТоваре(Команда)
	
	РаботаСНоменклатуройКлиент.ПоказатьСкрытьИнфОТоваре(ЭтаФорма);
	
КонецПроцедуры
&НаКлиенте
Процедура НастройкаИнфОТоваре(Команда) 
	
	РаботаСНоменклатуройКлиент.НастройкаИнфОТоваре(ЭтаФорма, "Запчасти", "Объект.Запчасти");
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыГарантияПриИзменении(Элемент)
	
	ПересчитатьСтрокуТовара();
		
КонецПроцедуры

#Область ТехЗаключение

&НаСервере
Функция ПолучитьтехЗаключение(Идентификатор, ИдСтроки)
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Документ.ТехЗаключение ГДЕ ЗаказНаряд = &Ссылка И ИдСтроки = " + Формат(Объект.Товары.Индекс(Объект.Товары.НайтиПоИдентификатору(Идентификатор)), "ЧН=0; ЧГ="));
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Документы.ТехЗаключение.ПустаяСсылка(); КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ТехЗаключение(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		ПоказатьПредупреждение(,"Нужно сперва записать заказ наряд");
	Иначе
		
		ИдСтроки 		= 0;
		текДанные 		= Элементы.Товары.ТекущиеДанные;
		ТехЗаключение 	= ПолучитьтехЗаключение(Элементы.Товары.ТекущаяСтрока, ИдСтроки);
		
		Если 	текДанные <> Неопределено И
				ЗначениеЗаполнено(текДанные.Номенклатура) Тогда
				
			ОткрытьФорму("Документ.ТехЗаключение.ФормаОбъекта", Новый Структура("Ключ, ЗаказНаряд, Номенклатура, ИдСтроки", 
																		ТехЗаключение, Объект.Ссылка, текДанные.Номенклатура, ИдСтроки), ЭтаФорма); КонецЕсли; КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПересчитатьСуммыТаблицыТоваров(СтруктураКолонокТовары, СтруктураКолонокЗапчасти, СтруктураКолонокРаботы);
	
	Для Каждого Строка Из Объект.Товары Цикл
		
		текИндекс = Объект.Товары.Индекс(Строка);
		ПрочитатьТаблицы(текИндекс);
			
		Для Каждого СтрокаЗапчасти Из Запчасти Цикл
				
			ФункцииФормДокументов.РассчитатьСуммыСтрокиОтЦены(
					СтрокаЗапчасти, 
					СтруктураКолонокЗапчасти);
		КонецЦикла;
		
		Для Каждого СтрокаРабота Из Работы Цикл
			
			СтрокаРабота.Сумма = СтрокаРабота.Количество * Строка.ЦенаЗаЧас;
		КонецЦикла;
		
		
		ЗапомнитьТаблицы(текИндекс);
		 					
	КонецЦикла;
		
КонецПроцедуры


&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	КонтрагентПриИзмененииНаСервере();
	
    Если ФункцииФормДокументов.ДиалогПриИзмененииТипаЦен(Объект.Товары.Количество(),СтруктураКолонокТовары,Объект.ТипЦен) Тогда
		СтруктураКолонокЗапчасти.ТипЦен = Объект.ТипЦен;
		СтруктураКолонокРаботы.ТипЦен   = Объект.ТипЦен;
		ПересчитатьСуммыТаблицыТоваров(СтруктураКолонокТовары,СтруктураКолонокЗапчасти, СтруктураКолонокРаботы);
		
	КонецЕсли;
	// при изменении строк запчастей пересчитываем строку товара		
	ПересчитатьСтрокуТовара();
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
	ФункцииФормДокументов.КонтрагентПриИзменении(Объект);
КонецПроцедуры

#КонецОбласти