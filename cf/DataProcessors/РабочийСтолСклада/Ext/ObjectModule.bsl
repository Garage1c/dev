﻿                                                                                       
Процедура ЗаполнитьДеревоЯчеистого(Дерево)

	МаксимумАртикуловВСтроке = 5;
	
	Для каждого СтрокаПрохода Из Дерево.Строки Цикл
		
		СтрокаПрохода.Представление = "Проход (" + СтрокаПрохода.Проход + ")";
		
		Для каждого СтрокаСекции Из СтрокаПрохода.Строки Цикл
			
			СтрокаСекции.Представление = "Секция (" + СтрокаПрохода.Проход + "." + СтрокаСекции.Секция + ")";
			
			текПозЯруса = МаксимумАртикуловВСтроке;
			Для каждого СтрокаЯруса Из СтрокаСекции.Строки Цикл
				
				СтрокаЯруса.Представление = "Ярус (" + СтрокаПрохода.Проход + "." + СтрокаСекции.Секция + "." + СтрокаЯруса.Ярус + ")";
				
				текПозПоддона = МаксимумАртикуловВСтроке;
				Для каждого СтрокаПоддона Из СтрокаЯруса.Строки Цикл
				
					СтрокаПоддона.Представление = "Поддон (" + СтрокаПрохода.Проход + "." + СтрокаСекции.Секция + "." + СтрокаЯруса.Ярус + "." + СтрокаПоддона.Поддон + ")";
					
					текПозНоменклатуры = МаксимумАртикуловВСтроке;
					Для каждого СтрокаНоменклатуры Из СтрокаПоддона.Строки Цикл
				
						СтрокаНоменклатуры.Представление = СтрокаНоменклатуры.Артикул + " - " + СтрокаНоменклатуры.Номенклатура;
						
						//Если СтрокаНоменклатуры.Строки.Количество() = 1 Тогда
						//	СтрокаНоменклатуры.Строки.Очистить();
						//Иначе
							
							Для каждого СтрокаЗаказа Из СтрокаНоменклатуры.Строки Цикл
								СтрокаЗаказа.Представление = СтрокаЗаказа.Заказ;
							КонецЦикла;
							
						//КонецЕсли;
						
						// Добавим номенклатуры в поддон
						
						Если текПозНоменклатуры Тогда
							СтрокаПоддона.Представление = СтрокаПоддона.Представление + "; " + СокрЛП(СтрокаНоменклатуры.Артикул);
						ИначеЕсли текПозНоменклатуры = 0 Тогда
							СтрокаПоддона.Представление = СтрокаПоддона.Представление + "...";
						КонецЕсли; 
						
						текПозНоменклатуры = текПозНоменклатуры - 1;
						
					КонецЦикла;
					
					// Добавим в ярус
					
					Если текПозПоддона Тогда
						СтрокаЯруса.Представление = ДобавитьРазличныеСтроки(СтрокаЯруса.Представление, СтрокаПоддона.Представление);
					ИначеЕсли текПозНоменклатуры = 0 Тогда
						СтрокаЯруса.Представление = СтрокаЯруса.Представление + "...";
					КонецЕсли; 
						
					текПозПоддона = текПозПоддона - 1;
										
				КонецЦикла;
				
				// Добавим в секцию
					
				Если текПозЯруса Тогда
					СтрокаСекции.Представление = ДобавитьРазличныеСтроки(СтрокаСекции.Представление, СтрокаЯруса.Представление);
				ИначеЕсли текПозНоменклатуры = 0 Тогда
					СтрокаСекции.Представление = СтрокаСекции.Представление + "...";
				КонецЕсли; 
					
				текПозЯруса = текПозЯруса - 1;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры
Функция СоздатьДеревоПростого(Запрос)

	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("Представление", 	Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Номенклатура", 	Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Дерево.Колонки.Добавить("Артикул",		 	Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Ячейка", 			Новый ОписаниеТипов("СправочникСсылка.Ячейки"));
	Дерево.Колонки.Добавить("Заказ");
	Дерево.Колонки.Добавить("Пометка",			Новый ОписаниеТипов("Число"));
	Дерево.Колонки.Добавить("ПростоПоле",		Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Остаток",			Новый ОписаниеТипов("Число"));
	Дерево.Колонки.Добавить("Резерв",			Новый ОписаниеТипов("Число"));
	
	Дерево.Колонки.Добавить("Проход",			Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Секция",			Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Ярус",				Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Поддон",			Новый ОписаниеТипов("Строка"));
	
	НовСтрокаСклад = Дерево.Строки.Добавить();
	НовСтрокаСклад.Представление = Склад;
	
	ВыборкаПрохода = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	Пока ВыборкаПрохода.Следующий() Цикл
		
		ВыборкаСекции = ВыборкаПрохода.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		Пока ВыборкаСекции.Следующий() Цикл
			
			ВыборкаЯруса = ВыборкаСекции.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
			Пока ВыборкаЯруса.Следующий() Цикл
				
				ВыборкаПоддона = ВыборкаЯруса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
				Пока ВыборкаПоддона.Следующий() Цикл
					
					ВыборкаНоменклатуры = ВыборкаПоддона.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
					Пока ВыборкаНоменклатуры.Следующий() Цикл
						
						НовСтрокаНоменклатура = НовСтрокаСклад.Строки.Добавить();
						ЗаполнитьЗначенияСвойств(НовСтрокаНоменклатура, ВыборкаНоменклатуры);
						НовСтрокаНоменклатура.Представление = ВыборкаНоменклатуры.Артикул + " - " + ВыборкаНоменклатуры.Номенклатура;
						
						ВыборкаЗаказов = ВыборкаНоменклатуры.Выбрать();
						//Если ВыборкаЗаказов.Количество() > 1 Тогда
							
							Если ВыборкаНоменклатуры.Остаток <> ВыборкаНоменклатуры.Резерв Тогда
							
								НовСтрокаЗаказ = НовСтрокаНоменклатура.Строки.Добавить();
								ЗаполнитьЗначенияСвойств(НовСтрокаЗаказ, ВыборкаНоменклатуры);
								НовСтрокаЗаказ.Резерв 	= 0;
								НовСтрокаЗаказ.Остаток 	= ВыборкаНоменклатуры.Остаток - ВыборкаНоменклатуры.Резерв;
							
							КонецЕсли; 
							
							Пока ВыборкаЗаказов.Следующий() Цикл
								
								НовСтрокаЗаказ = НовСтрокаНоменклатура.Строки.Добавить();
								ЗаполнитьЗначенияСвойств(НовСтрокаЗаказ, ВыборкаЗаказов);
								НовСтрокаЗаказ.Представление 	= ВыборкаЗаказов.Заказ;
								НовСтрокаЗаказ.Остаток			= ВыборкаЗаказов.Резерв;
								
							КонецЦикла;
							
						//КонецЕсли;
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Дерево;

КонецФункции
Функция ПолучитьДерево() Экспорт
	
	Запрос = Построитель.ПолучитьЗапрос();
	
	Запрос.УстановитьПараметр("ПустаяЯчейка", 		Справочники.Ячейки.ПустаяСсылка());
	Запрос.УстановитьПараметр("Склад", 				Склад);
	Запрос.УстановитьПараметр("ИспользоватьЯчейки", Склад.Ячеистый);
	
	Если Склад.Ячеистый Тогда
		
		Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		ЗаполнитьДеревоЯчеистого(Дерево);
		
	Иначе
		
		Дерево = СоздатьДеревоПростого(Запрос);
	
	КонецЕсли; 
		
	Возврат Дерево;
	
КонецФункции
Функция ДобавитьРазличныеСтроки(Строка1, Строка2)
	
	НовСтрока = Строка1;
	
	РазлСтр2 	= СтрЗаменить(Строка2, ";", Символы.ПС);
	числоСтрок 	= СтрЧислоСтрок(РазлСтр2);
	Для Ном = 2 По числоСтрок Цикл
		
		ПодСтр2 = СтрПолучитьСтроку(РазлСтр2, Ном);
		
		Если Не Найти(Строка1, ПодСтр2) Тогда
		
			НовСтрока = НовСтрока + ";" + ПодСтр2;
		
		КонецЕсли;  
			
	КонецЦикла; 
	
	Возврат НовСтрока;
	
КонецФункции

Функция ПопытатьсяУстановитьОдинковыеЯчейкиВЗаказеИРеализации(Заказ, стрИнформации = "") Экспорт
	
	// Найдем строки заказа
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Реал.Ссылка	Реализация,
	|	Реал.НомерСтроки,
	|	Зак.Ячейка
	|ИЗ
	|	Документ.ВнутреннийЗаказ.Товары,
	|	Документ.ЗаказПокупателя.Товары Зак
	|
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	(	ВЫБРАТЬ Ссылка, НомерСтроки, Номенклатура, Ячейка 
	|		ИЗ 		Документ.РеализацияТоваровУслуг.Товары
	|		ГДЕ		Ссылка.Проведен = ИСТИНА И ЗаказПокупателя = &Заказ
	|	) Реал
	|ПО
	|	Реал.Номенклатура 	= Зак.Номенклатура И
	|	Реал.Ячейка 		<> Зак.Ячейка
	|
	|ГДЕ
	|	Зак.Ссылка = &Заказ
	|
	|ИТОГИ ПО
	|	Реализация
	|");
	
	Запрос.УстановитьПараметр("Заказ", Заказ);
	
	ЕстьДокументы 		= Ложь;
	ВыборкаРеализаций 	= Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Пока ВыборкаРеализаций.Следующий() Цикл
		
		ЕстьДокументы = Истина;
		стрИнформации = стрИнформации + "
							|Обнаружен объект " + ВыборкаРеализаций.Реализация;
		
		ДокОбъект = ВыборкаРеализаций.Реализация.ПолучитьОбъект();
		
		Выборка = ВыборкаРеализаций.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Строка = ДокОбъект.Товары[Выборка.НомерСтроки - 1];
			
			стрИнформации = стрИнформации + "
							|Номер строки " + Выборка.НомерСтроки + " - " + Строка.Номенклатура + "
							|Ячейка до " + Строка.Ячейка + ", Ячейка после = " + Выборка.Ячейка;
			
			Строка.Ячейка = Выборка.Ячейка;
			
		КонецЦикла;
		
		Попытка
			ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			стрОшибки = ОписаниеОшибки();
			стрИнформации = стрИнформации + "
							|Ошибка при записи реализации: 
							|" + стрОшибки;
			Возврат Ложь;
		КонецПопытки;
		
		стрИнформации = стрИнформации + "
							|Документ успешно записан";
	
	КонецЦикла; 
	
	Если Не ЕстьДокументы Тогда
		стрИнформации = "Не обнаружены реализации";
	КонецЕсли; 
						
	Возврат Истина;					
	
КонецФункции

Функция ПолучитьПакингЛист(МассивСтрок) Экспорт

// Подготовим печатную форму
	
	ТабДокумент 	= Новый ТабличныйДокумент;
	Макет 			= Документы.ЗаказПокупателя.ПолучитьМакет("Пакинг");
	
	ОбластьШапка 			= Макет.ПолучитьОбласть("Шапка");
	ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьСтрока 			= Макет.ПолучитьОбласть("Строка");
	ОбластьИтого 			= Макет.ПолучитьОбласть("Итого");
	
	// Выполним запрос
	
	ОтрПроход 	= Новый Соответствие;
	ОтрСекция 	= Новый Соответствие;
	ОтрЯрус 	= Новый Соответствие;
	ОтрПоддон 	= Новый Соответствие;
	
	//ОбластьШапка.Параметры.Номер 	= Номер;
	//ОбластьШапка.Параметры.Дата 	= Дата;
	ТабДокумент.Вывести(ОбластьШапка);
	ТабДокумент.Вывести(ОбластьЗаголовокТаблицы);
		
	// Переменые
	
	Ном = 0;
	ИтогПроход 	= 0;
	ИтогСекция 	= 0;
	ИтогЯрус 	= 0;
	ИтогПоддон 	= 0;
	
	ВсегоКол 	= 0;
	ИтСумма 	= 0;
	
	Для каждого Строка Из МассивСтрок Цикл Ном = Ном + 1;
		Если 	ЗначениеЗаполнено(Строка.Номенклатура) И 
				Не ЗначениеЗаполнено(Строка.Родитель.Номенклатура) Тогда
	
			ОбластьСтрока.Параметры.Заполнить(Строка);
			ОбластьСтрока.Параметры.Номер 		= Ном;
			ОбластьСтрока.Параметры.Количество 	= Строка.Остаток;
			ТабДокумент.Вывести(ОбластьСтрока);
			
			// Подсчитаем итоги
			
			ИтогПроход 	= ИтогПроход + ПодсчитатьИтогЯчейки(ОтрПроход, Строка.Проход);
			ИтогСекция 	= ИтогСекция + ПодсчитатьИтогЯчейки(ОтрСекция, Строка.Проход + "." + Строка.Секция);
			ИтогЯрус 	= ИтогЯрус + ПодсчитатьИтогЯчейки(ОтрЯрус, Строка.Проход + "." + Строка.Секция + "." + Строка.Ярус);
			ИтогПоддон 	= ИтогПоддон + ПодсчитатьИтогЯчейки(ОтрПоддон, Строка.Проход + "." + Строка.Секция + "." + Строка.Ярус + "." + Строка.Поддон);
			
			ВсегоКол 	= ВсегоКол + Строка.Остаток;
			//ИтСумма 	= ИтСумма + Строка.Сумма;
			
		КонецЕсли;
	КонецЦикла; 
		
	// Подвал
	
	ОбластьИтого.Параметры.ДатаФормирования = Формат(ТекущаяДата(),"ДЛФ=DDT");
	ОбластьИтого.Параметры.КолЯчеек		 	= Строка(ИтогПроход) + "." + Строка(ИтогСекция) + "." + Строка(ИтогЯрус) + "." + Строка(ИтогПоддон);
	ОбластьИтого.Параметры.КолНоменклатура 	= ВсегоКол;
	ОбластьИтого.Параметры.Сумма 			= ИтСумма;
	ТабДокумент.Вывести(ОбластьИтого);
	
	Возврат ТабДокумент;
	
КонецФункции
Функция ПодсчитатьИтогЯчейки(ОтрСоответствие, КлючПоиска)
	
	Если ОтрСоответствие[КлючПоиска] <> ИСТИНА Тогда
		ОтрСоответствие.Вставить(КлючПоиска, Истина);
		Возврат 1;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

Процедура ИницилизироватьПостроитель()
	
	Построитель.Текст = "
	|ВЫБРАТЬ 	
	|	ВЫРАЗИТЬ("""" КАК Строка(255)) Представление,
	|	0				Пометка,
	|	Ячейка,
	|	Ячейка.Проход 	Проход,
	|	Ячейка.Секция 	Секция,
	|	Ячейка.Ярус 	Ярус,
	|	Ячейка.Поддон 	Поддон,
	|	Номенклатура,
	|	Номенклатура.Наименование 	НоменклатураНаименование,
	|	Номенклатура.Артикул 		Артикул,
	|	Заказ,
	|	КоличествоОстаток 	Остаток,
	|	РезервОстаток 		Резерв,
	|	ИСТИНА				ПростоПоле
	|ИЗ 
	|	РегистрНакопления.ОстаткиЯчеек.Остатки(,&ИспользоватьЯчейки = ИСТИНА {Номенклатура.* Номенклатура, Заказ.* Заказ, Ячейка.* Ячейка})
	|{
	|ГДЕ
	|	Ячейка.Проход 	Проход,
	|	Ячейка.Секция 	Секция,
	|	Ячейка.Ярус 	Ярус,
	|	Ячейка.Поддон 	Поддон,
	|	КоличествоОстаток 	Остаток,
	|	РезервОстаток 		Резерв
	|}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ("""" КАК Строка(255)) Представление,
	|	0		Пометка,
	|	&ПустаяЯчейка,
	|	""0"" 	Проход,
	|	""0"" 	Секция,
	|	""0"" 	Ярус,
	|	""0"" 	Поддон,
	|	ЕСТЬNULL(Ост.Номенклатура, Рез.Номенклатура),
	|	ЕСТЬNULL(Ост.Номенклатура.Наименование, Рез.Номенклатура.Наименование),
	|	ЕСТЬNULL(Ост.Номенклатура.Артикул, Рез.Номенклатура.Артикул),
	|	Рез.ДокументРезерва,
	|	ЕСТЬNULL(Ост.КоличествоОстаток,0) 	Остаток,
	|	ЕСТЬNULL(Рез.КоличествоОстаток,0)	Резерв,
	|	ИСТИНА					ПростоПоле
	|ИЗ                      
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(,&ИспользоватьЯчейки = ЛОЖЬ И Склад = &Склад {Номенклатура.* Номенклатура}) Ост
	|
	|ПОЛНОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыВРезервеНаСкладах.Остатки(,&ИспользоватьЯчейки = ЛОЖЬ И Склад = &Склад {Номенклатура.* Номенклатура, ДокументРезерва.* Заказ}) Рез
	|ПО
	|	Ост.Номенклатура = Рез.Номенклатура
	|{
	|ГДЕ
	|	Ост.КоличествоОстаток 	Остаток,
	|	Рез.КоличествоОстаток 	Резерв
	|}
	|                                                                                       	
	|УПОРЯДОЧИТЬ ПО
	|	Проход, Секция, Ярус, Поддон, Артикул
	|
	|ИТОГИ 
	|	СУММА(Остаток),
	|	СУММА(Резерв),
	|	МАКСИМУМ(Артикул),
	|	МАКСИМУМ(Ячейка),
	|	МАКСИМУМ(ПростоПоле)
	|ПО
	|	Проход, Секция, Ярус, Поддон, Номенклатура
	|";
	
КонецПроцедуры

// ИницилизироватьПостроитель();
