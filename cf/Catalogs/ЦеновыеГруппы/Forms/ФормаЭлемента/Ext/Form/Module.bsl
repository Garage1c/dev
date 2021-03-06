﻿
&НаСервере
Процедура ЗаполнитьТаблицуТовары()
	
	Запрос = Новый Запрос("	ВЫБРАТЬ
							//|	ЦеноваяГруппа,
							|	Номенклатура
							|ИЗ 
							|	РегистрСведений.ЦеноваяГруппаТовара
							|ГДЕ
							|	ЦеноваяГруппа = &Ссылка");
							
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Выполнение = Запрос.Выполнить();
	
	Если НЕ Выполнение.Пустой() Тогда
		
		Товары.Загрузить(Выполнение.Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Скидки.Параметры.УстановитьЗначениеПараметра("Дата1", ТекущаяДата());
	Скидки.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
	
	Производители.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
	
	ЗаполнитьТаблицуТовары();

КонецПроцедуры


&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПоказатьПредупреждение(,"Перед добавлением товаров запишите объект", , "Внимание");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КонтрольУникальность()
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
    
    Запрос = Новый Запрос("	ВЫБРАТЬ
    						|	Товары.Номенклатура
    						|ПОМЕСТИТЬ
    						|	ТоварыЦеновойГруппы
    						|ИЗ
    						|	&ВыбТаблица КАК Товары");
    
    Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
    
    ВремТаблица = Товары.Выгрузить();
    ВремТаблица.Свернуть("Номенклатура");
    
    Запрос.УстановитьПараметр("ВыбТаблица", ВремТаблица);

    Запрос.Выполнить();
    
    Запрос.Текст = "ВЫБРАТЬ
					|	Тов.Номенклатура	Номенклатура,
					|	Рег.ЦеноваяГруппа	ЦеноваяГруппа
    				|ИЗ
    				|	ТоварыЦеновойГруппы Тов
    				|	ЛЕВОЕ СОЕДИНЕНИЕ
    				|		РегистрСведений.ЦеноваяГруппаТовара Рег
    				|	ПО 
    				|		Тов.Номенклатура = Рег.Номенклатура
    				|
    				|	ГДЕ
    				|		Рег.ЦеноваяГруппа <> &ЦеноваяГруппа И НЕ Рег.Номенклатура ЕСТЬ NULL";
    			
	Запрос.УстановитьПараметр("ЦеноваяГруппа", Объект.Ссылка);				
	Выполнение = Запрос.Выполнить();

	Если НЕ Выполнение.Пустой() Тогда
		Выборка = Выполнение.Выбрать();
		Пока Выборка.Следующий() Цикл
			Сообщить("Для товара уже определена ценовая группа: " + Выборка.Номенклатура + "(" + Выборка.ЦеноваяГруппа + ")");
		КонецЦикла;
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаСервере
Процедура СохранитьТаблицуТовары(Отказ)
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
    
    Запрос = Новый Запрос("	ВЫБРАТЬ
    						|	Товары.Номенклатура
    						|ПОМЕСТИТЬ
    						|	ТоварыЦеновойГруппы
    						|ИЗ
    						|	&ВыбТаблица КАК Товары");
    
    Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
    
    ВремТаблица = Товары.Выгрузить();
    ВремТаблица.Свернуть("Номенклатура");
    
    Запрос.УстановитьПараметр("ВыбТаблица", ВремТаблица);

    Запрос.Выполнить();
    
    Запрос.Текст = "ВЫБРАТЬ
					|	Тов.Номенклатура	Номенклатура,
					|	&ЦеноваяГруппа		ЦеноваяГруппа
    				|ИЗ
    				|	ТоварыЦеновойГруппы Тов
    				|	ЛЕВОЕ СОЕДИНЕНИЕ 
					|		РегистрСведений.ЦеноваяГруппаТовара  Рег
    				|	ПО	
					|		Тов.Номенклатура = Рег.Номенклатура И Рег.ЦеноваяГруппа= &ЦеноваяГруппа
    				|
    				|	ГДЕ
    				|		Рег.Номенклатура ЕСТЬ NULL
					|;
					|ВЫБРАТЬ
					|	Рег.Номенклатура	Номенклатура,
					|	&ЦеноваяГруппа		ЦеноваяГруппа
    				|ИЗ
    				|	РегистрСведений.ЦеноваяГруппаТовара Рег
    				|	ЛЕВОЕ СОЕДИНЕНИЕ
    				|		ТоварыЦеновойГруппы Тов
    				|	ПО 
    				|		Тов.Номенклатура = Рег.Номенклатура
    				|
    				|	ГДЕ
    				|		Рег.ЦеноваяГруппа = &ЦеноваяГруппа И Тов.Номенклатура ЕСТЬ NULL";
    			
	Запрос.УстановитьПараметр("ЦеноваяГруппа", Объект.Ссылка);				
	ПакетРез = Запрос.ВыполнитьПакет();

	РегМенеджер = РегистрыСведений.ЦеноваяГруппаТовара;
	
	Выборка = ПакетРез[0].Выбрать();
		
	НачатьТранзакцию();
	Пока Выборка.Следующий() Цикл
		Запись = РегМенеджер.СоздатьМенеджерЗаписи();				
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
		Попытка
			Запись.Записать();
		Исключение
			Сообщить("Ошибка записи ценовой группы для товара: " + ОписаниеОшибки());
			Отказ = Истина;
			ОтменитьТранзакцию();
			Перейти ~ВыходВОбходФиксацииТранзакции;
		КонецПопытки;
	КонецЦикла;
		
	Выборка = ПакетРез[1].Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Запись = РегМенеджер.СоздатьМенеджерЗаписи();				
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
        Запись.Прочитать();
		Попытка
			Запись.Удалить();
		Исключение
			Сообщить("Ошибка записи ценовой группы для товара: " + ОписаниеОшибки());
			Отказ = Истина;
			ОтменитьТранзакцию();
			Перейти ~ВыходВОбходФиксацииТранзакции;
		КонецПопытки;
	КонецЦикла;

	ЗафиксироватьТранзакцию();
	     
    ~ВыходВОбходФиксацииТранзакции:
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ Объект.Ссылка.Пустая() И Товары.Количество() > 0 Тогда
		
		Если НЕ КонтрольУникальность() Тогда
			Ответ = Вопрос("Выполнить запись?", РежимДиалогаВопрос.ДаНет);
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Отказ = Истина;
				Возврат;	
			КонецЕсли;
		КонецЕсли;
		
        СохранитьТаблицуТовары(Отказ);
		
	КонецЕсли;
КонецПроцедуры

// ПОДБОР

&НаСервере
Функция ПоместитьТоварыВХранилище() 
	
	Возврат ПоместитьВоВременноеХранилище(
					Товары.Выгрузить(), 
					УникальныйИдентификатор);
					
КонецФункции

&НаКлиенте
Процедура Подбор(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПоказатьПредупреждение(,"Перед добавлением товаров запишите объект", , "Внимание");
		Возврат;
	КонецЕсли;
	
	ИмяТабличнойЧасти = "Товары";
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	ПараметрыПодбора = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары);

	ПараметрыПодбора.Вставить("СтруктураКолонокТовары", СтруктураКолонокТовары);
//	ПараметрыПодбора.Вставить("ВидЗапроса", "СписокНоменклатуры");
		
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", ПараметрыПодбора, Элементы.Товары);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение <> Неопределено Тогда		
		
		ПолучитьТоварыИзХранилища(ВыбранноеЗначение);		// получаем
		УдалитьИзВременногоХранилища(ВыбранноеЗначение); 	// заметаем следы
		
	КонецЕсли;
	
КонецПроцедуры

 &НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресТоваровВХранилище)
	
	Товары.Загрузить(ПолучитьИзВременногоХранилища(АдресТоваровВХранилище));
				
КонецПроцедуры

Функция СформироватьСписокВыбора()
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.Производители ГДЕ НЕ ПометкаУдаления");
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции

&НаКлиенте
Процедура Заполнить(Команда)
	Список = Новый СписокЗначений;
	Список.ЗагрузитьЗначения(СформироватьСписокВыбора());

	Оповещение = Новый ОписаниеОповещения("ПослеВыбораЭлемента", ЭтаФорма);
	Список.ПоказатьВыборЭлемента(Оповещение, "Выберите производителя");
	//...

КонецПроцедуры



&НаКлиенте
Процедура ПослеВыбораЭлемента(ВыбЭлемент, Параметры) Экспорт
    Если ВыбЭлемент = Неопределено Тогда
        Сообщить("Не выбран производитель");
	Иначе
		ВыбЗначение = ВыбЭлемент.Значение;
		Оповещение = Новый ОписаниеОповещения("ОповещениеЗавершено", ЭтаФорма, ВыбЗначение);
		ПоказатьВопрос(Оповещение, "Все товары данного производителя буду добавлены в ценовую группу. Продолжить?", РежимДиалогаВопрос.ДаНет) 
    КонецЕсли;
КонецПроцедуры 

&НаКлиенте
Процедура ОповещениеЗавершено(Результат, Производитель) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ЗаполнитьПоПроизводителю(Производитель);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПроизводителю(Ссылка)
	
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Таб.Номенклатура 	Номенклатура
		|ПОМЕСТИТЬ
		|	Товары
		|ИЗ
		|	&Товары КАК Таб
		|");
			
		МенеджерВременныхТаблиц 		= Новый МенеджерВременныхТаблиц;
		Запрос.МенеджерВременныхТаблиц 	= МенеджерВременныхТаблиц;
		
		Запрос.УстановитьПараметр("Товары", Товары.Выгрузить());
		Запрос.Выполнить();
	
	
	Запрос.Текст = "ВЫБРАТЬ Тов.Номенклатура ИЗ Товары Тов ГДЕ Тов.Номенклатура.Производитель <> &Ссылка ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ Ссылка ИЗ Справочник.Номенклатура ГДЕ НЕ ПометкаУдаления И Производитель = &Ссылка И ТипНоменклатуры = &Товар"; 
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Товар", Перечисления.ТипыНоменклатуры.Товар);

	Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры;

