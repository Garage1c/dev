﻿&НаКлиенте
Перем МассивКомментариев Экспорт;
&НаКлиенте
Перем ЗакрытьФорму;
&НаКлиенте
Перем мСтСтрокаРедактирования;

&НаКлиенте
Перем мВремяОткрытияФормы;

&НаСервере
Процедура ОбновитьИнформационнуюНадпись()
	
	Текст = "";
	
	Если СтруктураКолонокТовары.ЕстьСуммаНДС Тогда
		Текст = Текст + ?(Текст = "","","   ")
		+ НСтр("ru='НДС'; de='Mwst'") + ":" + Товары.Итог("СуммаНДС");
	КонецЕсли;
	
	Если 	СтруктураКолонокТовары.ЕстьСуммаРучнойСкидки Или
			СтруктураКолонокТовары.ЕстьСуммаАвтоматическойСкидки Тогда
			
		Скидка = ?(СтруктураКолонокТовары.ЕстьСуммаРучнойСкидки, Товары.Итог("СуммаРучнойСкидки"),0) +
					?(СтруктураКолонокТовары.ЕстьСуммаАвтоматическойСкидки, Товары.Итог("СуммаАвтоматическойСкидки"),0);
			
		Текст = Текст + ?(Текст = "","","   ")
		+ НСтр("ru='Скидка'; de='Rabatt'") + ": " + Скидка;
		
	КонецЕсли;
	
	Если СтруктураКолонокТовары.ЕстьВсего Тогда
		Текст = Текст + ?(Текст = "","","   ")
		+ НСтр("ru='Всего'; de='Betrag'") + ": " + Товары.Итог("Всего");
	ИначеЕсли СтруктураКолонокТовары.ЕстьСумма Тогда
		Текст = Текст + ?(Текст = "","","   ")
		+ НСтр("ru='Сумма'; de='Summe'") + ": " + Товары.Итог("Сумма");
	КонецЕсли;
	
	Информация = Текст;
	
КонецПроцедуры
&НаСервере
Процедура УправлениеВидимостьюДоступностью() Экспорт
		
	// Обновим информационную надпись
	
	ОбновитьИнформационнуюНадпись();
	
КонецПроцедуры
&НаСервере
Процедура УстановитьЗаголовок()
	
	Заголовок = НСтр("ru='Остатки по заказу поставщика'; de='Bleibt beauftragte Lieferant'");
	
КонецПроцедуры
&НаСервере
Функция ЭтоГруппа(Номенклатура)
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 ИСТИНА ИЗ Справочник.Номенклатура ГДЕ ЭтоГруппа = Ложь И Ссылка = &Номенклатура");
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

#Область Запросы

Процедура ОбновитьДинамическийСписок()
	                                   
	Список.Параметры.УстановитьЗначениеПараметра("Поставщик", 	Контрагент);
	Список.Параметры.УстановитьЗначениеПараметра("ФильтрПоЗаказу", 	ЗначениеЗаполнено(НомерЗаказа));
	Список.Параметры.УстановитьЗначениеПараметра("НомерЗаказ", 		"%" + НомерЗаказа + "%");
	Список.Параметры.УстановитьЗначениеПараметра("ФильтрАртикул", 	ЗначениеЗаполнено(ФильтрАртикул));
	Список.Параметры.УстановитьЗначениеПараметра("Артикул", 		"%" + ФильтрАртикул + "%");
	
КонецПроцедуры

#КонецОбласти

#Область Типовые

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Если валюта установлена документом тогда берем валюту документа
	//
	//Если Не Валюта.Пустая() Тогда
	//	Настройки.Удалить("Валюта");
	//КонецЕсли;
	
	// начальные настройки
	//Если Настройки["ЦенаВключаетНДС"] = Неопределено Тогда
	//	ЦенаВключаетНДС = Истина;
	//КонецЕсли;
	
	// Установим склад
	//Если Склады.НайтиПоЗначению(Параметры.Склад) = Неопределено Тогда
	//	Склады.Добавить(Параметры.Склад);
	//КонецЕсли;
	
	//Если ВидЗапроса <> ВидЗапросаНовый И ВидЗапросаНовый = "ОстаткиПоЗаказамПоставщику" Тогда
	//	ВидЗапроса = ВидЗапросаНовый;
	//	
	//КонецЕсли;
	
//	ОбновитьТекстЗаголовкаHTML();
	
КонецПроцедуры
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);	
	
	СтруктураКолонокТовары	= Параметры.СтруктураКолонокТовары;
	Контрагент					= Параметры.Контрагент;
	
	Товары.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТоваровВХранилище));
	УдалитьИзВременногоХранилища(Параметры.АдресТоваровВХранилище); // сразу очистим память чтобы не засрать
		
	УстановитьЗаголовок();
	ОбновитьИнформационнуюНадпись();
	
	// Для рассчетов пригодится
	
	//СтруктураКолонокТовары.ТипЦен 	= ТипЦен;
	//СтруктураКолонокТовары.Валюта 	= Валюта;
	
	// Автосохранение
	
	АвтосохранениеДампСтрока 	= ?(ЗначениеЗаполнено(Параметры.АвтосохранениеДамп), ЗначениеВСтрокуВнутр(Параметры.АвтосохранениеДамп), "");
	ДокументСсылка 				= Параметры.ДокументСсылка;
	ИмяФормыДокумента			= Параметры.ИмяФормы;
	
	Если Не ПустаяСтрока(Параметры.МассивТоваровСтрокой) Тогда
		
		Массив = ЗначениеИзСтрокиВнутр(Параметры.МассивТоваровСтрокой);
		
		Товары.Очистить();
		Для Каждого Строка Из Массив Цикл ЗаполнитьЗначенияСвойств(Товары.Добавить(), Строка) КонецЦикла; КонецЕсли;
		
			//		НовоеПоле = Элементы.Добавить("ЗаказПоставщику", Тип("ПолеФормы"), Элементы.Список);
			//НовоеПоле.ПутьКДанным = "Список.ЗаказПоставщику";

		//	ПолеГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		//	ПолеГруппировки.Использование = истина;
		//	ПолеГруппировки.Поле = Новый  ПолеКомпоновкиДанных("ЗаказПоставщику");
		//	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		//
	ОбновитьДинамическийСписок();	
		
КонецПроцедуры
&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗакрытьФорму <> Истина И Модифицированность И Вопрос(Нстр("ru='Закрыть форму?'; de='Formular schließen?'") + "
		|" + Нстр("ru='все изменения будут отменены'; de='Änderungen gehen verloren'"), РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
&НаСервере
Функция ПоместитьТоварыВХранилище() 
	
	Возврат ПоместитьВоВременноеХранилище(
					Товары.Выгрузить(), 
					УникальныйИдентификатор);
КонецФункции
&НаКлиенте
Процедура Выбрать(Команда)
	
	Модифицированность 	= Ложь;
	ЗакрытьФорму 		= Истина;
	ОповеститьОВыборе(ПоместитьТоварыВХранилище());
	
КонецПроцедуры
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	мВремяОткрытияФормы = ТекущаяДата();
	Слежение.Записать("Открытие. Подбор номенклатуры", "Справочник.Номенклатура", "ФормаПодбора");
	
	// Автосохранение
	
	Если Не ПустаяСтрока(АвтосохранениеДампСтрока) Тогда
		
		Интервал = АвтосохранениеСервер.ПолучитьИнтервал();
		Если Интервал Тогда ПодключитьОбработчикОжидания("Автосохранение", Интервал) КонецЕсли; КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ПриЗакрытии()
	
	// Автосохранение
	Если Не ПустаяСтрока(АвтосохранениеДампСтрока) Тогда
		АвтосохранениеКлиент.ЗакрытПодбор(ПолучитьФормуВладельца(ВладелецФормы)) КонецЕсли;
	
	//Слежение.Записать("Закрытие. Подбор номенклатуры", "Справочник.Номенклатура", "ФормаПодбора",,"Время работы подбора " + Строка(ТекущаяДата() - мВремяОткрытияФормы) + " сек.");
	
КонецПроцедуры

#КонецОбласти

#Область Автосохранение

&НаСервере
Функция АвтосохранениеСервер(ЕстьДамп)
	
	Дамп = ЗначениеИзСтрокиВнутр(АвтосохранениеДампСтрока);
	Дамп.Вставить("Подбор", КонвертацияТипов.ПолучитьМассивИзТаблицыЗначений(Товары.Выгрузить()));
	
	ЕстьДамп = АвтосохранениеСервер.ЕстьДамп(ДокументСсылка, ИмяФормыДокумента);
	
	Возврат АвтосохранениеСервер.СохранитьДамп(ДокументСсылка, ИмяФормыДокумента, Дамп);
	
КонецФункции
&НаКлиенте
Процедура Автосохранение()
	
	Перем ЕстьДамп;
	
	Сохранилось = АвтосохранениеСервер(ЕстьДамп);
	
	АвтосохранениеКлиент.ПроизошлоАвтосохранение(Сохранилось, ЕстьДамп, ДокументСсылка);
	
КонецПроцедуры
&НаКлиенте
Функция ПолучитьФормуВладельца(Родитель)
	
	Возврат ?(ТипЗнч(Родитель) = Тип("УправляемаяФорма"), Родитель, ПолучитьФормуВладельца(Родитель.Родитель));
	
КонецФункции

#КонецОбласти

// РАБОТА СО СПИСКОМ
////Изм//////
&НаКлиенте
Процедура ОбработкаВыбораСтроки(ВыбраннаяСтрока, Знач ЗапрашиватьЦену, Знач ЗапрашиватьКоличество)
	
	// Определим начальное значение количества
		
	Количество 	= 1;
	Упаковка = Неопределено;
	Цена = 0;
	
	// если в Таблице есть поле Цена, займемся ценами
	
	Если Элементы.Список.ТекущиеДанные.Свойство("Цена") Тогда
		
		// заполним упаковку поставщика
		
		Если СтруктураКолонокТовары.ЕстьУпаковка Тогда
				                                                                            
			Упаковка = РаботаСНоменклатурой.ПолучитьУпаковкуПоставщика(ВыбраннаяСтрока);
			Если НЕ Упаковка.Пустая() Тогда
				Цена  = РаботаСНоменклатурой.ПолучитьЦену(ВыбраннаяСтрока, СтруктураКолонокТовары.ТипЦен, СтруктураКолонокТовары.Валюта, Упаковка);
				Цена  = РаботаСНоменклатурой.ПолучитьЦенуСУчетомНДС(Цена, РаботаСНоменклатурой.ПолучитьСтавкуНДСНоменклатуры(ВыбраннаяСтрока), , СтруктураКолонокТовары.СуммаВключаетНДС); 
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ Цена Тогда
			
			// берем цену из текущих данных
			
			Цена  = Элементы.Список.ТекущиеДанные.Цена;
			
		КонецЕсли;

		Если ЗапрашиватьЦену И ЗапрашиватьКоличество Тогда
			///
			Флаг = Ложь;
			///
			ВозврЗначение = ОткрытьФорму("Документ.Инвойс.Форма.ФормаВводаКоличестваЦены", 
						Новый Структура("Количество, Цена, ЗапрашиватьКоличество, ЗапрашиватьЦена", 
										Количество, Цена, Истина, Истина),ЭтаФорма,,,,Новый ОписаниеОповещения("ОбработкаВводаКоличестваИЦены",ЭтаФорма,Новый Структура("ВыбраннаяСтрока, Упаковка", ВыбраннаяСтрока, Упаковка)),);
			Возврат;
						
		ИначеЕсли ЗапрашиватьЦену Тогда
			
			Если Не ВвестиЧисло(Цена, НСтр("ru='Цена:'; de='Preis:'"),15,2) Тогда
				Возврат;
			КонецЕсли;
			
		ИначеЕсли ЗапрашиватьКоличество Тогда
			
			Если Не ВвестиЧисло(Количество, НСтр("ru='Количество:'; de='Quantität:'"),15,3) Тогда
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	ОбработкаСтрокиТовары(Количество, Цена, ВыбраннаяСТрока, Упаковка);	
	
	КонецЕсли;
	
	
КонецПроцедуры
&НаКлиенте
Процедура ОбработкаВводаКоличестваИЦены(Результат, Параметры) Экспорт
	Если Результат <> Неопределено Тогда
				
				//Цена 		= Результат.Цена;
				//Количество 	= Результат.Количество;
				//Параметры.Флаг = Истина;
				ОбработкаСтрокиТовары(Результат.Количество, Результат.Цена, Параметры.ВыбраннаяСтрока, Параметры.Упаковка);
			Иначе
				
				Возврат;
				//Параметры.Флаг = Ложь;
			КонецЕсли;

КонецПроцедуры
///
&НаКлиенте
Процедура ОбработкаСтрокиТовары(Количество, Цена, ВыбраннаяСТрока, Упаковка)
	
	// Поищем
	ЗаказПоставщику = Элементы.Список.ТекущиеДанные.ЗаказПоставщику;
	Строки = Товары.НайтиСтроки(Новый Структура("Номенклатура, ЗаказПоставщику", ВыбраннаяСтрока, ЗаказПоставщику));
	
	// Отработаем новую строку
	
	Если Не Строки.Количество() Тогда
		
		НовСтрока = Товары.Добавить();
		НовСтрока.Номенклатура 	= ВыбраннаяСтрока;
		Если Цена > 0 Тогда  НовСтрока.Цена = Цена;	КонецЕсли;
		НовСтрока.Упаковка		= Упаковка;
		
		НовСтрока.ЗаказПоставщику = ЗаказПоставщику;
		
		ФункцииФормДокументов.НоменклатураПриИзменении(НовСтрока, СтруктураКолонокТовары, НовСтрока,, Ложь,,,Ложь);
		
		Строки.Добавить(НовСтрока);
		
	КонецЕсли;
	
	// Обработаем
	
	Для Каждого Строка Из Строки Цикл
		
		Строка.Количество = Строка.Количество + Количество;
		//ФункцииФормДокументов.РассчитатьСуммыТабличныхЧастей(Строка, СтруктураКолонокТовары);
		ФункцииФормДокументов.РассчитатьСуммыСтрокиОтЦены(Строка, СтруктураКолонокТовары, Ложь);
		
	КонецЦикла;			
	
	ОбновитьИнформационнуюНадпись();
	Элементы.Товары.ТекущаяСтрока = Товары.Индекс(Строка);
	
КонецПроцедуры

/////Изм//////////
&НаКлиенте
Процедура ОбработкаВыбораМассиваСтрок(МассивСтрок)
	
		Для Каждого ВыбраннаяСтрока ИЗ МассивСтрок Цикл
			Если Не ЭтоГруппа(ВыбраннаяСтрока) Тогда
				
				ОбработкаВыбораСтроки(ВыбраннаяСтрока, Ложь, Ложь);
				
			КонецЕсли;
 		КонецЦикла;
	
        ОбновитьИнформационнуюНадпись();

КонецПроцедуры


&НаКлиенте                                          
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	
	Если Элемент.ВыделенныеСтроки.Количество() > 1 Тогда
		
		СтандартнаяОбработка = Ложь;
	
		МассивСтрок = Элемент.ВыделенныеСтроки;
		
		ОбработкаВыбораМассиваСтрок(МассивСтрок);
		
	ИначеЕсли ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		ОткрытьФорму("Документ.ЗаказПоставщику.ФормаОбъекта", Новый Структура("Ключ", ВыбраннаяСтрока.Ключ));

	ИначеЕсли Не ЭтоГруппа(ВыбраннаяСтрока) Тогда
	   	СтандартнаяОбработка = Ложь;

		
		ОбработкаВыбораСтроки(ВыбраннаяСтрока, ЗапрашиватьЦену, ЗапрашиватьКоличество);

	КонецЕсли;
		
КонецПроцедуры   	

// ПЕРЕДАЧА

&НаСервере
Процедура ЗаписатьПодборВХранилище() 
	
	ПоместитьВоВременноеХранилище(Товары.Выгрузить(), Параметры.АдресТоваровВХранилище);
	
КонецПроцедуры

#Область Информация // о товаре

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		ОбработатьОтображениеИнформацииОТоваре();
	КонецЕсли;
	 	
КонецПроцедуры
&НаСервере
Процедура ОбработатьОтображениеИнформацииОТоваре() Экспорт
	РаботаСНоменклатурой.ОбработатьОтображениеИнформацииОТоваре(ЭтаФорма, "Список");
КонецПроцедуры

&НаКлиенте
Процедура ИнфТовараТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка, "Список");
КонецПроцедуры
&НаКлиенте
Процедура ИнфТовараЗаголовокHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараЗаголовокHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка, "Список");
КонецПроцедуры

 &НаКлиенте
Процедура ПоказатьСкрытьИнфОТоваре(Команда)
	РаботаСНоменклатуройКлиент.ПоказатьСкрытьИнфОТоваре(ЭтаФорма);
КонецПроцедуры
&НаКлиенте
Процедура НастройкаИнфОТоваре(Команда) 
	РаботаСНоменклатуройКлиент.НастройкаИнфОТоваре(ЭтаФорма, "Список");
КонецПроцедуры

#КонецОбласти

#Область Кнопки

&НаКлиенте
Процедура ОтменитьВвод(Команда)
	
	ЗакрытьФорму = Истина;
	Закрыть();
	
КонецПроцедуры
&НаКлиенте
Процедура РедактироватьСвойства(Команда)
	
	//ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбораПараметровПодбора", 
	//	Новый Структура("ТипЦен, Валюта, ЗапрашиватьКоличество, ЗапрашиватьЦену, ЦенаВключаетНДС, Склады", ТипЦен, Валюта, ЗапрашиватьКоличество, ЗапрашиватьЦену, ЦенаВключаетНДС, Склады), 
	//	ЭтаФорма,,,, 
	//	Новый ОписаниеОповещения("ОкончаниеРедактированияСвойств", ЭтаФорма, Новый Структура("Валюта, ТипЦен, ЦенаВключаетНДС", Валюта, ТипЦен, ЦенаВключаетНДС)),
	//	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 
		
КонецПроцедуры
&НаКлиенте
Процедура ОкончаниеРедактированияСвойств(Результат, Параметры) Экспорт
	
	//Если Результат <> Неопределено Тогда 	
	//	
	//	СтруктураКолонокТовары.ТипЦен 	= ТипЦен;
	//	СтруктураКолонокТовары.Валюта 	= Валюта;
	//
	//Если (	Параметры.ТипЦен <> ТипЦен Или
	//	 	Параметры.Валюта <> Валюта 
	//	) И Вопрос(НСтр("ru='Изменилась валюта или тип цен'; de='Ändern Sie die Währung oder der Preis Typ'") + "
	//				|" + НСтр("ru='Пересчитать таблицу по новым ценам?'; de='Berechnen Sie die Tabelle zu den neuen Preisen?'"), РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
	//				
	//	Обновить = Истина;
	//	ПересчитатьЦенаНаСервере();
	//				
	//КонецЕсли;
	//
	//ОбновитьДинамическийСписок();
	//УстановитьЗаголовок();

	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьЦенаНаСервере(СУчетомНДС = Ложь)
	
	Для Каждого Строка Из Товары Цикл
		Акция = Неопределено;	
		Цена = РаботаСНоменклатурой.ПолучитьЦену(	Строка.Номенклатура, 
															СтруктураКолонокТовары.ТипЦен,
															СтруктураКолонокТовары.Валюта,
															?(СтруктураКолонокТовары.ЕстьУпаковка, Строка.Упаковка, Неопределено), 
															СтруктураКолонокТовары.Контрагент, 
															СтруктураКолонокТовары.ЕстьАкция, 
															Акция,
															СтруктураКолонокТовары.ЕстьЦенаПоАкции);
		Если СтруктураКолонокТовары.ЕстьЦенаПоАкции Тогда
			Строка.Цена 			= Цена.Цена;
			Строка.ЦенаПоАкции		= Цена.ЦенаПоАкции;
		Иначе
			Строка.Цена 			= Цена;
		КонецЕсли;
		
		Если СтруктураКолонокТовары.ЕстьАкция Тогда
			Строка.Акция = Акция; 
			Строка.ВариантРасчета = Заказы.ПолучитьВариантРасчетаЦеныПоАкции(Акция); 
			Если ФункцииФормДокументов.СкидкаТолькоПоАкции(Строка, Строка.ВариантРасчета) Тогда
				Если СтруктураКолонокТовары.ЕстьПроцентАвтоматическойСкидки Тогда Строка.ПроцентАвтоматическойСкидки = 0; КонецЕсли;
				Если СтруктураКолонокТовары.ЕстьПроцентРучнойСкидки Тогда Строка.ПроцентРучнойСкидки = 0; КонецЕсли;
			КонецЕсли;			
			
		КонецЕсли;
		
		ФункцииФормДокументов.ЦенаПриИзменении(Товары, СтруктураКолонокТовары, Строка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРучСкидку(Команда)
	
	ДиалогиСПользователем.ЗаполнитьРучСкидку(Товары, СтруктураКолонокТовары);
	ОбновитьИнформационнуюНадпись();
		
КонецПроцедуры
&НаКлиенте
Процедура ЗаполнитьСтавкуНДС(Команда)
	
	ДиалогиСПользователем.ЗаполнитьСтавкуНДС(Товары, СтруктураКолонокТовары);
	ОбновитьИнформационнуюНадпись();
	
КонецПроцедуры

#КонецОбласти

#Область Товары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ФункцииФормДокументов.НоменклатураПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ФункцииФормДокументов.КоличествоПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	ФункцииФормДокументов.ЦенаПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	ФункцииФормДокументов.СуммаПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ФункцииФормДокументов.УпаковкаПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыПроцентРучнойСкидкиПриИзменении(Элемент)
	
	ФункцииФормДокументов.ПроцентРучнойСкидкиПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыСуммаРучнойСкидкиПриИзменении(Элемент)
	
	ФункцииФормДокументов.СуммаРучнойСкидкиПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);
				
КонецПроцедуры
&НаКлиенте
Процедура ТоварыСтавкаНДСПриИзменении(Элемент)
	
	ФункцииФормДокументов.СтавкаНДСПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыСуммаНДСПриИзменении(Элемент)
	
	ФункцииФормДокументов.СуммаНДСПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);
				
КонецПроцедуры
&НаКлиенте
Процедура ТоварыСуммаБезСкидкиПриИзменении(Элемент)
	
	ФункцииФормДокументов.СуммаРучнойСкидкиПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьДоступностьРедактированияСТроки(текДанные, Отказ)
	
	Если текДанные.Отгружено Тогда
		
		Отказ = Истина;
		ОбщиеФункции.СообщитьТекст(НСтр("ru='Товар уже отгружен, изменять его запрещено'; de='Dieses Produkt wurde bereits versandt wurde, ist es verboten, Veränderungen'"));
		
	ИначеЕсли текДанные.Собрано Тогда
		
		ИмяЭлемента = Элементы.Товары.ТекущийЭлемент.Имя;
		
		Если 	ИмяЭлемента = "ТоварыКоличество" Или 
				ИмяЭлемента = "ТоварыНоменклатура" Или
				ИмяЭлемента = "ТоварыРазмещение" Или
				ИмяЭлемента = "ТоварыУпаковка" Или
				ИмяЭлемента = "ТоварыВес" Или
				ИмяЭлемента = "ТоварыОбъем" Или
				ИмяЭлемента = "ТоварыЗаказПоставщику" Тогда
		
			Отказ = Истина;
			ОбщиеФункции.СообщитьТекст(НСтр("ru='Товар уже собран, изменять его запрещено'; de='Dieses Produkt eingebaut wird, wird es in Wechsel verboten'"));
			
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыПередНачаломИзменения(Элемент, Отказ)
	
	текДанные = Элемент.ТекущиеДанные;
	
	// запомним текущую строку
	
	мСтСтрокаРедактирования = Новый Структура("Номенклатура, Упаковка, Размещение, Количество",
										текДанные.Номенклатура, текДанные.Упаковка, текДанные.Размещение, текДанные.Количество);
	
	// Проверим
	
	ПроверитьДоступностьРедактированияСтроки(Элемент.ТекущиеДанные, Отказ);
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	текДанные = Элемент.ТекущиеДанные;
	
	// Проверим если изменили че низя тогда им кердык
	
	Если Не НоваяСтрока И текДанные.Собрано Тогда
	
		Для Каждого Элемент Из мСтСтрокаРедактирования Цикл
			Если Элемент.Значение <> текДанные[Элемент.Ключ] Тогда
				
				Предупреждение(НСтр("ru='Изменились реквизиты которые изменять запрещено'; de='Details haben sich geändert, die nicht geändert werden dürfen'"));
				
				//Если Вопрос("Изменились реквизиты которые изменять запрещено
				//	|вернуть как было?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
					
					ОтменаРедактирования = Истина;
					Для Каждого Элемент Из мСтСтрокаРедактирования Цикл текДанные[Элемент.Ключ] = Элемент.Значение; КонецЦикла;
					ФункцииФормДокументов.РассчитатьСуммыТабличныхЧастей(ТекДанные, СтруктураКолонокТовары);
				//	
				//Иначе Отказ = Истина; КонецЕсли; 
				Прервать;
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ОбновитьИнформационнуюНадпись();
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	ПроверитьДоступностьРедактированияСтроки(Элемент.ТекущиеДанные, Отказ);
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	ОбновитьИнформационнуюНадпись()
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура НомерЗаказаПриИзменении(Элемент)
	ОбновитьДинамическийСписок();
КонецПроцедуры
&НаКлиенте
Процедура ФильтрАртикулПриИзменении(Элемент)
	
	ОбновитьДинамическийСписок();
	
КонецПроцедуры
&НаКлиенте
Процедура ФильтрАртикулОчистка(Элемент, СтандартнаяОбработка)
	
	ОбновитьДинамическийСписок();
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПолученШтрихкод" Тогда
		
		СсылкаНаТовар = ШтрихКоды.ПолучитьОбъектПоШтрихКоду(Параметр);
		Если ТипЗнч(СсылкаНаТовар) = Тип("СправочникСсылка.Номенклатура") Тогда
			
			Элементы.Список.ТекущаяСтрока = СсылкаНаТовар;КонецЕсли;КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомерЗаказаОчистка(Элемент, СтандартнаяОбработка)
	ОбновитьДинамическийСписок();

КонецПроцедуры




