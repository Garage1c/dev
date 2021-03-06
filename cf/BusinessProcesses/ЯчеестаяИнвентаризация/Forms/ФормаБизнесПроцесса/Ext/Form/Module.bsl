﻿
&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;

&НаКлиенте
Процедура УправлениеВидимостьюДоступностью()
	
	Заголовок = "По секции " + Объект.Секция + " " + ?(ПустаяСтрока(Объект.Номер),"создание","№" + Объект.Номер + " от " + Формат(Объект.Дата,"ДЛФ=DDT"));
	
	ЕстьРасхождения 	= Ложь;
	ЕстьКоличество 		= Ложь;
	ЕстьВыравнивание 	= Ложь;
	ЕстьПеремещение 	= Ложь;
	ЕстьПеремещениеЯчейка	= Ложь;
	
	Для Каждого Строка Из Объект.Товары Цикл 
		
		ЕстьКоличество = Истина; 
		Если Строка.ВыравнитьКоличество Тогда ЕстьВыравнивание = Истина КонецЕсли;
		Если Строка.КоличествоРезервЯчейка Тогда ЕстьПеремещениеЯчейка = Истина КонецЕсли;
		Если Строка.КоличествоКПеремещению Тогда ЕстьПеремещение = Истина КонецЕсли;
		Если Строка.ОбщееКоличествоВЯчейках <> Строка.ОбщееКоличествоНаСкладе Тогда ЕстьРасхождения = Истина;КонецЕсли;
		
	КонецЦикла;
	
	ПроцессВРаботе 		= Объект.Стартован И Не Объект.Завершен; 
	ЭтоНовый			= Объект.Ссылка.Пустая();
	
	Элементы.ТоварыКоличествоФакт.ТолькоПросмотр = Не ПроцессВРаботе;
	
	//Элементы.ГруппаШапка.Видимость 				= ЭтоНовый Или Не ПроцессВРаботе И Не Объект.Завершен;
	Элементы.КнопкаОбновитьТаблицу.Видимость 	= ЭтоНовый Или Не ПроцессВРаботе И Не Объект.Завершен;
	Элементы.ГруппаКнопокОтметить.Видимость 	= ЭтоНовый Или Не ПроцессВРаботе И Не Объект.Завершен;
	
	//Элементы.КнопкаСделатьКакВЯчейках.Видимость 	= ЕстьВыравнивание;
//	Элементы.КнопкаСделатьКакПоОстаткам.Видимость 	= ЕстьВыравнивание;
	//Элементы.КНопкаПереместить.Видимость 			= ЕстьПеремещение;
	
	Элементы.КнопкаЗапуститьИнвентаризацию.Видимость 	= ЕстьКоличество И Не Объект.Стартован;
	//Элементы.КнопкаПроверитьЗапуск.Видимость 			= ЕстьКоличество И Не Объект.Стартован;
	Элементы.КнопкаЗавершитьИнвентаризацию.Видимость 	= ЕстьКоличество И ПроцессВРаботе;
	Элементы.КнопкаОтменитьИнвентаризацию.Видимость 	= ЕстьКоличество И ПроцессВРаботе;
	
	Элементы.НадписьПередЗапуском.Видимость = Не Объект.Стартован;
	
	//Элементы.ТоварыГруппаРезерв.Видимость 			= ЕстьПеремещение Или ЕстьПеремещениеЯчейка;
	Элементы.ТаблицаШаблонОбщееКоличество.Видимость = ЕстьРасхождения;
	
КонецПроцедуры


// ТИПОВЫЕ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		ФункцииФормДокументов.ЗаполнитьЗначенияПоУмолчанию(ЭтаФорма, ЭтаФорма.Элементы);
	КонецЕсли;
	
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	ЗаполнитьДинамическийКолонки()
	
КонецПроцедуры
&НаСервере
Процедура ЗаполнитьДинамическийКолонки()
	
	Для Каждого Строка Из Объект.Товары Цикл Строка.Артикул = Строка.Номенклатура.Артикул; КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьСтуктуруКолнокТовары()
	Возврат ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары,,,"Товары");	
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	 // Автосохранение
	
	Если АвтосохранениеКлиент.ИницилизироватьСохранение(ЭтаФорма) Тогда
			
		ЗагрузитьДанныеАвтосохранения(""); 
		Модифицированность = Истина; КонецЕсли;
	
	УправлениеВидимостьюДоступностью();
	
	СтруктураКолонокТовары = ПолучитьСтуктуруКолнокТовары();
	
КонецПроцедуры
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УправлениеВидимостьюДоступностью()
	
КонецПроцедуры
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Перем Завершить;
	
	ПараметрыЗаписи.Свойство("Завершить", Завершить);
	
	ТекущийОбъект.ИнвентаризацияПринята = Завершить = Истина;
	
	// Автосохранение
	Если Не Отказ И Объект.Ссылка.Пустая() Тогда АвтосохранениеСервер.УдалитьАвтоСохранение(ИмяФормы, Объект.Ссылка) КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	// Автосохранение
	АвтосохранениеСервер.УдалитьАвтоСохранение(ИмяФормы, Объект.Ссылка);
	
КонецПроцедуры


// СЕКЦИЯ

&НаСервере
Функция СекцияСоответствуетСкладу()
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 ИСТИНА ИЗ Справочник.Ячейки ГДЕ Владелец = &Склад И Проход + ""."" + Секция = """ + Объект.Секция + """");
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции
&НаСервере
Процедура ЗаполнитьЗначенияПоСекции()
	
	// Разложим секцию
	Массив = КонвертацияТипов.ПолучитьМассивИзСтроки(Объект.Секция,".");
	
	Если Массив.Количество() <> 2 Тогда
		ОбщиеФункции.СообщитьТекст("Не могу определить секцию");
		Возврат; КонецЕсли;
	
	Запрос = Новый Запрос("
	|Выбрать ссылка Поместить Ячейки из Справочник.Ячейки ГДЕ Владелец = &Склад
	|;
	|
	|ВЫБРАТЬ
	|	Яч.Номенклатура Номенклатура,
	|	Яч.Номенклатура.Артикул Артикул,
	|	Яч.Ячейка Ячейка,
	//|	Яч.КоличествоОстаток + ЕСТЬNULL(Сбор.СобраноОстаток,0) Количество
	|	Яч.КоличествоОстаток Количество
	|ПОМЕСТИТЬ
	|	ТаблицаТовара
	|ИЗ
	|	РегистрНакопления.ТоварыВЯчейках.Остатки(,Ячейка.Владелец = &Склад И Ячейка.Секция = """ + Массив[1] + """ И Ячейка.Проход = """ + Массив[0] + """) Яч
	//|ЛЕВОЕ СОЕДИНЕНИЕ
	//|	РегистрНакопления.СборкаЗаказа.Остатки(,СкладЯчейка.Владелец = &Склад И СкладЯчейка.Секция = """ + Массив[1] + """ И СкладЯчейка.Проход = """ + Массив[0] + """) Сбор
	//|ПО
	//|	Яч.Ячейка 		= Сбор.СкладЯчейка И
	//|	Яч.Номенклатура = Сбор.Номенклатура
	|
	|;
	|ВЫБРАТЬ
	|	Таб.Номенклатура,
	|	Таб.Артикул,
	|	ЕСТЬNULL(РезЯч.Ячейка, Таб.Ячейка) Ячейка,
	|	ЯчОбщ.Количество		ОбщееКоличествоВЯчейках,
	|	ЕСТЬNULL(Собр.КоличествоОстаток, 0)	Собрано,
	|	Ост.КоличествоОстаток 	ОбщееКоличествоНаСкладе,
	|	ЕСТЬNULL(Рез.КоличествоОстаток, 0)	КоличествоРезервСклад,
	|	ЕСТЬNULL(РезЯч.КоличествоОстаток, 0)		КоличествоРезервЯчейка,
	|	Таб.Количество			КоличествоУчет,
	|	-Таб.Количество			КоличествоРасхождение,
	|
	|	ВЫБОР КОГДА Ост.КоличествоОстаток = ЯчОбщ.Количество 
	|			ТОГДА ВЫБОР КОГДА Рез.КоличествоОстаток - Ост.КоличествоОстаток + Таб.Количество > 0 ТОГДА Рез.КоличествоОстаток - Ост.КоличествоОстаток + Таб.Количество ИНАЧЕ 0 КОНЕЦ
	|			ИНАЧЕ 0
	|	КОНЕЦ КоличествоКПеремещению,
	|	ВЫБОР КОГДА Ост.КоличествоОстаток = ЯчОбщ.Количество 
	|			ТОГДА ВЫБОР КОГДА Рез.КоличествоОстаток - Ост.КоличествоОстаток + Таб.Количество > 0 ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ
	|			ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ НужноПереместить
	|ИЗ
	|	ТаблицаТовара Таб
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	(
	
	//|		ВЫБРАТЬ 
	//|			Яч.Номенклатура, Яч.КоличествоОстаток + ЕСТЬNULL(Сбор.СобраноОстаток,0) Количество
	//|		ИЗ 
	//|			РегистрНакопления.ТоварыВЯчейках.Остатки(,Ячейка.Владелец = &Склад И Номенклатура В(ВЫБРАТЬ Номенклатура ИЗ ТаблицаТовара)) Яч
	//|		ЛЕВОЕ СОЕДИНЕНИЕ 
	//|			РегистрНакопления.СборкаЗаказа.Остатки(,СкладЯчейка ССЫЛКА Справочник.Ячейки И СкладЯчейка.Владелец = &Склад И Номенклатура В(ВЫБРАТЬ Номенклатура ИЗ ТаблицаТовара)) Сбор
	//|		ПО 
	//|			Яч.Номенклатура = Сбор.Номенклатура
	
	|		ВЫБРАТЬ 
	|			Яч.Номенклатура, Яч.КоличествоОстаток  Количество
	|		ИЗ 
	|			РегистрНакопления.ТоварыВЯчейках.Остатки(,Ячейка в (Выбрать ссылка из Ячейки) И Номенклатура В(ВЫБРАТЬ Номенклатура ИЗ ТаблицаТовара)) Яч
	
	
	|	) ЯчОбщ
	|ПО
	|	ЯчОбщ.Номенклатура = Таб.Номенклатура
	
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|РегистрНакопления.ТоварыСобранные.Остатки(,Склад = &Склад)  Собр
	|по  Собр.Номенклатура = Таб.Номенклатура
	
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(,Склад = &Склад И Номенклатура В(ВЫБРАТЬ Номенклатура ИЗ ТаблицаТовара)) Ост
	|ПО
	|	Таб.Номенклатура = Ост.Номенклатура
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыВРезерве.Остатки(,
	|								ВЫБОР КОГДА ДокументРезерва ССЫЛКА Документ.Инвентаризация И ДокументРезерва.Процесс = &Ссылка ТОГДА ЛОЖЬ ИНАЧЕ ИСТИНА КОНЕЦ И 
	|								Размещение = &Склад И 
	|								Номенклатура В(ВЫБРАТЬ Номенклатура ИЗ ТаблицаТовара)) Рез
	|ПО
	|	Таб.Номенклатура = Рез.Номенклатура
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	
	
	//|	(	ВЫБРАТЬ Номенклатура, Ячейка, СУММА(Количество) Количество
	//|		ИЗ 		РегистрСведений.ЯчейкиПоЗаказу 
	//|		ГДЕ 	Задача.Выполнена 		= Ложь И 
	//|				Задача.ПометкаУдаления 	= Ложь И 
	//|				Ячейка.Владелец 		= &Склад И 
	//|				Задача.БизнесПроцесс 	<> &Ссылка И
	//|				Номенклатура В(ВЫБРАТЬ Номенклатура ИЗ ТаблицаТовара)
	//|
	//|		СГРУППИРОВАТЬ ПО 
	//|				Номенклатура, Ячейка
	//|	) РезЯч
	
	|РегистрНакопления.РезервыВЯчейках.Остатки(, Номенклатура в (Выбрать Номенклатура из ТаблицаТовара) и Ячейка в (Выбрать ссылка из Ячейки) и СборочныйЛист <>&ТекущийДокИнвентаризация) РезЯч
	
	|ПО
	|	РезЯч.Ячейка 		= Таб.Ячейка И
	|	РезЯч.Номенклатура 	= Таб.Номенклатура
	|
	|");
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Склад", 	Объект.Склад);
	Запрос.УстановитьПараметр("ТекущийДокИнвентаризация", 	Объект.ДокИнвентаризация);
	
	Товары = Запрос.Выполнить().Выгрузить();
	
	// Проверим ячейки которые не правильно определеили резерв
	
	Для Каждого Строка Из Товары Цикл
		
		Отбор = Новый Структура("Номенклатура", Строка.Номенклатура);
		СуммаПоЭтимЯчейкам = КонвертацияТипов.ПолучитьСуммуКолонкиПоУсловию(Товары, "КоличествоУчет", Отбор);
		Если СуммаПоЭтимЯчейкам <> Строка.КоличествоУчет Тогда // косяк может быть когда товара несколько
			
			НужноПереместить = Строка.КоличествоРезервСклад - (Строка.ОбщееКоличествоВЯчейках - СуммаПоЭтимЯчейкам) - КонвертацияТипов.ПолучитьСуммуКолонкиПоУсловию(Товары, "КоличествоКПеремещению", Отбор);
			
			Если НужноПереместить Тогда
			
				СтрокиТовара = Товары.НайтиСтроки(Отбор);
				Для Каждого СтрокаТовара Из СтрокиТовара Цикл
					
					Перемещаем = Мин(НужноПереместить, СтрокаТовара.КоличествоУчет - СтрокаТовара.КоличествоКПеремещению);
					Если Перемещаем Тогда
						
						СтрокаТовара.КоличествоКПеремещению = СтрокаТовара.КоличествоКПеремещению + Перемещаем;
						НужноПереместить = НужноПереместить - Перемещаем; КонецЕсли; КонецЦикла; КонецЕсли; КонецЕсли; КонецЦикла;
	
	Объект.Товары.Загрузить(Товары);
	
КонецПроцедуры

&НаКлиенте
Процедура СекцияПриИзменении(Элемент)
	
	Если Не СекцияСоответствуетСкладу() Тогда
		
		Предупреждение("Секции " + Строка(Объект.секция) + " не существует");
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(Объект.Секция) Тогда
		
		ЗаполнитьЗначенияПоСекции();
		Модифицированность = Истина;
		УправлениеВидимостьюДоступностью();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокСекций()
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ Проход + ""."" + Секция КАК Секция ИЗ Справочник.Ячейки ГДЕ Ссылка.Владелец = &Склад УПОРЯДОЧИТЬ ПО Секция");
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	
	Список = Новый СписокЗначений;
	Список.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Секция"));
	
	Возврат Список;
	
КонецФункции
&НаКлиенте
Процедура СекцияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Список = ПолучитьСписокСекций();
	
	ВыбЭлемент = Список.ВыбратьЭлемент();
	
	Если ВыбЭлемент <> Неопределено Тогда
		
		Объект.Секция = ВыбЭлемент.Значение;
		ЗаполнитьЗначенияПоСекции();
		Модифицированность = Истина;
		УправлениеВидимостьюДоступностью();
		
	КонецЕсли;
	
КонецПроцедуры

// СКЛАД

&НаСервере
Процедура ПриИзмененииСкладаНаСервере()
	
	Если Не СекцияСоответствуетСкладу() Тогда
		Объект.Секция = "";
		Объект.Товары.Очистить();
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	ПриИзмененииСкладаНаСервере();
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

// ТАБЛИЧНАЯ ЧАСТЬ

&НаКлиенте
Процедура ТоварыКоличествоФактПриИзменении(Элемент)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	//
	//Если ТекДанные.ОбщееКоличествоНаСкладе <> ТекДанные.ОбщееКоличествоВЯчейках Тогда
	//	
	//	ОбщиеФункции.СообщитьТекст("Общее количество не совпадает с общим количеством по ячейкам.
	//										|Сперва необходимо выравнить общее количество");
	//	ТекДанные.КоличествоФакт = 0;
	//	
	//КонецЕсли;
	
	//Расхождение = ТекДанные.КоличествоФакт - ТекДанные.КоличествоУчет;
	//ВПоиск = 0;
	//
	//// Если нужно что-то списать, а оно требеует перемещения
	//Если Расхождение < 0 И ТекДанные.НужноПереместить Тогда
	//	НадоСписать = - Расхождение;
	//	МогуСписать = ТекДанные.КоличествоУчет - ТекДанные.КоличествоКПеремещению;
	//	Расхождение = ?( НадоСписать > МогуСписать, - МогуСписать, - НадоСписать);
	//	ВПоиск = ?( НадоСписать > МогуСписать, НадоСписать - МогуСписать, 0);
	//КонецЕсли;
    //ТекДанные.ВПоиске = ВПоиск;

	ТекДанные.КоличествоРасхождение =  ТекДанные.КоличествоФакт - ТекДанные.КоличествоУчет; 
		
КонецПроцедуры

&НаКлиенте
Процедура ТоварыРеквизитВыравнитьПриИзменении(Элемент)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекДанные.ОбщееКоличествоНаСкладе = ТекДанные.ОбщееКоличествоВЯчейках Тогда
		ТекДанные.ВыравнитьКоличество = Ложь;
	КонецЕсли;
	
	// Снимим галки у одинаковых товаров, чтобы точно понимать в какую ячейку точно оприходывать 
	
	текЗнач = ТекДанные.ВыравнитьКоличество;
	
	СтрокиТоваров = Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура", ТекДанные.Номенклатура));
	Для КАждого Строка Из СтрокиТоваров Цикл
		Строка.ВыравнитьКоличество = Ложь;
	КонецЦикла;
	
	ТекДанные.ВыравнитьКоличество = текЗнач;
	
	// Покажим кнопочки
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыНужноПереместитьПриИзменении(Элемент)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	
	Если 	ТекДанные.ОбщееКоличествоВЯчейках <> ТекДанные.ОбщееКоличествоНаСкладе Или
			Не ТекДанные.КоличествоКПеремещению Тогда
		
		ТекДанные.НужноПереместить = Ложь;
		
	КонецЕсли;
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьТаблицу(Команда)
	
	ЗаполнитьЗначенияПоСекции();
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры


// ВЫРАВНИВАНИЕ

&НаСервере
Функция ПолучитьДокументРедактирования()
	
	Док = Документы.РедактированиеРегистра.СоздатьДокумент();
	Док.Дата 	= ТекущаяДата();
	Док.Процесс = Объект.Ссылка;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		Док.Записать();
	Исключение
		
		стрОшибки = ОписаниеОшибки();
		УстановитьПривилегированныйРежим(Ложь);
		ОбщиеФункции.СообщитьТекст("Ошибка при записи редактирования регистра
										|" + стрОшибки);
		Возврат Неопределено;
		
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Док.Ссылка;
	
КонецФункции
&НаСервере
Функция ВыравнитьЯчейки()
	
	Товары = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(Объект.Товары.Выгрузить(), Новый Структура("ВыравнитьКоличество", Истина));
	
	Если Товары.Количество() Тогда
		
		НачатьТранзакцию();
		
		ДокРедактирование = ПолучитьДокументРедактирования();
		
		Если ДокРедактирование = Неопределено Тогда
			ОтменитьТранзакцию();
			Возврат Ложь;
		КонецЕсли;
	
		Набор = РегистрыНакопления.ТоварыВЯчейках.СоздатьНаборЗаписей();
		Набор.Отбор.Регистратор.Установить(ДокРедактирование);
		
		Для Каждого Строка Из Товары Цикл
			
			НовСтрока = Набор.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
			
			НовСтрока.Регистратор	= ДокРедактирование;
			НовСтрока.Период 		= ДокРедактирование.Дата;
			НовСтрока.Количество 	= Строка.ОбщееКоличествоНаСкладе - Строка.ОбщееКоличествоВЯчейках;
			
		КонецЦикла;
		
		Попытка
			Набор.Записать();
		Исключение
			стрОшибки = ОписаниеОшибки();
			ОтменитьТранзакцию();
			ОбщиеФункции.СообщитьТекст("Ошибка при записи набора регистра
										|" + стрОшибки);
			Возврат Неопределено;
		КонецПопытки;
		
		ЗафиксироватьТранзакцию();
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции
&НаСервере
Функция ВыравнитьОстатки()
	
	Товары = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(Объект.Товары.Выгрузить(), Новый Структура("ВыравнитьКоличество", Истина));
	Товары.Свернуть("Номенклатура, ОбщееКоличествоВЯчейках, ОбщееКоличествоНаСкладе");
	
	Если Товары.Количество() Тогда
		
		НачатьТранзакцию();
		
		ДокРедактирование = ПолучитьДокументРедактирования();
		
		Если ДокРедактирование = Неопределено Тогда
			ОтменитьТранзакцию();
			Возврат Ложь;
		КонецЕсли;
	
		Набор = РегистрыНакопления.ТоварыНаСкладах.СоздатьНаборЗаписей();
		Набор.Отбор.Регистратор.Установить(ДокРедактирование);
		
		Для Каждого Строка Из Товары Цикл
			
			НовСтрока = Набор.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
			
			НовСтрока.Регистратор	= ДокРедактирование;
			НовСтрока.Склад			= Объект.Склад;
			НовСтрока.Период 		= ДокРедактирование.Дата;
			НовСтрока.Количество 	= Строка.ОбщееКоличествоВЯчейках - Строка.ОбщееКоличествоНаСкладе;
			
		КонецЦикла;
		
		Попытка
			Набор.Записать();
		Исключение
			стрОшибки = ОписаниеОшибки();
			ОтменитьТранзакцию();
			ОбщиеФункции.СообщитьТекст("Ошибка при записи набора регистра
										|" + стрОшибки);
			Возврат Неопределено;
		КонецПопытки;
		
		ЗафиксироватьТранзакцию();
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура СделатьКакВЯчейках(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		Записать();
	КонецЕсли;
	
	Если ВыравнитьОстатки() Тогда
		
		ЗаполнитьЗначенияПоСекции();
		Записать();
		УправлениеВидимостьюДоступностью();
		
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура СделатьКакПоОстаткам(Команда)
	
	// не делать как по остаткам на складе. ей не пользуются + когда есть расхождения, а одинаковый товар в разных ячейках, непонятно в какую ячейку корректировать
	
	Возврат;
	
	Если Объект.Ссылка.Пустая() Тогда
		Записать();
	КонецЕсли;
	
	Если ВыравнитьЯчейки() Тогда
		
		ЗаполнитьЗначенияПоСекции();
		Записать();
		УправлениеВидимостьюДоступностью();
		
	КонецЕсли;
	
КонецПроцедуры

// ЗАПУСК

&НаСервере
Функция ПроверитьВозможностьЗапускаИнвентаризации()
	
	Отказ 	= Ложь;
	Инд 	= -1;
	
	Для Каждого Строка Из Объект.Товары Цикл Инд = Инд + 1;
		
		Поле = "Объект.Товары[" + Формат(Инд,"ЧГ=") +"]";
		
		//Если Строка.ОбщееКоличествоВЯчейках <> Строка.ОбщееКоличествоНаСкладе Тогда
		//	Отказ = Истина;
		//	ОбщиеФункции.СообщитьТекст("Общее количество на складе не совпадает с количеством в ячейках!", Поле + ".ОбщееКоличествоВЯчейках");
		//КонецЕсли;
		
		Если Строка.КоличествоРезервЯчейка Тогда
			Отказ = Истина;
			ОбщиеФункции.СообщитьТекст("Существует резерв по ячейке!", Поле + ".КоличествоРезервЯчейка");
		КонецЕсли;
		
		
		//Если Строка.ВПоиске < 0 Тогда
		//	Отказ = Истина;
		//	ОбщиеФункции.СообщитьТекст("Количество товара в поиске не может быть отрицательным!", Поле + ".ВПоиске");
		//КонецЕсли;
		
		//Если Строка.КоличествоКПеремещению Тогда
		//	Отказ = Истина;
		//	ОбщиеФункции.СообщитьТекст("Нужно переместить зарезервированный товар с ячеек", Поле + ".КоличествоКПеремещению");
		//КонецЕсли;
		
	КонецЦикла;
	
	Возврат Не Отказ;
	
КонецФункции
&НаКлиенте
Процедура ПроверитьЗапуск(Команда)
	
	Если ПроверитьВозможностьЗапускаИнвентаризации() Тогда
		
		ПоказатьПредупреждение(,"Проверка прошла успешно.
					|Инвентаризацию можно запустить.",,"Сообщенние");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗапуститьИнвентаризациюНаСервере()
	
	НачатьТранзакцию();
	
	// Стартанем процесс
	
	Если Записать(Новый Структура("Старт", Истина)) Тогда
		
		// Найдем появившиюся задачу и привяжем ее к регистру резерва
		
		ЗадачаОбъект = ФункцииБизнесПроцессов.ТекущаяЗадача(Объект.Ссылка).ПолучитьОбъект();
		Если ЗадачаОбъект = Неопределено Тогда
			
			ОбщиеФункции.СообщитьТекст("Не найдена задача при запуске процесса!");
			ОтменитьТранзакцию();
			Возврат Ложь;
			
		КонецЕсли;
		
		Товары = Объект.Товары.Выгрузить();
		Товары.Колонки.Добавить("Задача", Новый ОписаниеТипов("ЗадачаСсылка.ЗадачаПользователю"));
		Товары.ЗаполнитьЗначения(ЗадачаОбъект.Ссылка, "Задача");
		Товары.Колонки.КоличествоУчет.Имя = "Количество";
		
		// Удалим записи где количество отрицательное (такое тоже бывает)
		
		//КолСтрок = Товары.Количество(); Инд = КолСтрок;
		//Для Ном = 1 По КолСтрок Цикл Инд = Инд - 1;
		//	Если Товары[Инд].Количество < 0 Тогда
		//		Товары.Удалить(Инд);
		//	КонецЕсли;
		//КонецЦикла;
		
		//Набор = РегистрыСведений.ЯчейкиПоЗаказу.СоздатьНаборЗаписей();
		//Набор.Отбор.Задача.Установить(ЗадачаОбъект.Ссылка);
		//Набор.Загрузить(Товары);
		//
		//Попытка
		//	Набор.Записать();
		//Исключение
		//	стрОшибки = ОписаниеОшибки();
		//	ОтменитьТранзакцию();
		//	ОбщиеФункции.СообщитьТекст("Ошибка при записи резерва по задаче
		//							|" + стрОшибки);
		//	Возврат Ложь;
		//КонецПопытки;
		
		// Создадим документ инвентаризации
		
		НовДок = Документы.Инвентаризация.СоздатьДокумент();
		НовДок.Дата 	= ТекущаяДата();
		НовДок.Процесс 	= Объект.Ссылка;
		НовДок.Склад	= Объект.Склад;
		НовДок.Ревизор  = Объект.Ревизор;
		
		НовДок.УстановитьСсылкуНового(Документы.Инвентаризация.ПолучитьСсылку(Новый УникальныйИдентификатор));
		НовТовары = Объект.Товары.Выгрузить();
		НовТовары.Колонки.Добавить("ДокументРезерва");
		НовТовары.ЗаполнитьЗначения(НовДок.ПолучитьСсылкуНового(),"ДокументРезерва");
		
		//КонвертацияТипов.ВыполнитьВыражениеВКаждойСтрокеТаблицы(НовТовары,
		//"Строка.КоличествоУчет = Строка.КоличествоУчет - Строка.КоличествоКПеремещению");
		
		НовДок.Товары.Загрузить(НовТовары);
		
		Попытка
			НовДок.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			стрОшибки = ОписаниеОшибки();
			ОтменитьТранзакцию();
			ОбщиеФункции.СообщитьТекст("Ошибка при документа инвентаризация товаров
									|" + стрОшибки);
			Возврат Ложь;
		КонецПопытки;
		
		Объект.ДокИнвентаризация = НовДок.Ссылка;
		Записать();
		
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
	
КонецФункции


&НаКлиенте
Процедура ЗапуститьИнвентаризацию(Команда)

	Если 	ПроверитьВозможностьЗапускаИнвентаризации() И 
			ЗапуститьИнвентаризациюНаСервере() Тогда
			
		ЗаполнитьЗначенияПоСекции();
		УправлениеВидимостьюДоступностью();
			
		ПоказатьПредупреждение(,"Инвентаризация запущена,
						|весь товар в секции зарезервирован под инвентаризацию.
						|После окончания инвентаризации резерв будет снят",,"Сообщение!");
	КонецЕсли;
	
КонецПроцедуры


// ПЕРЕМЕЩЕНИЕ

Функция ТоварыБуфераДляПеремещенияСтрокой()
	
	Ячейки = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(Объект.Товары.Выгрузить(), Новый Структура("НужноПереместить", Истина));
	Ячейки.Колонки.Ячейка.Имя 					= "ЯчейкаОтправитель";
	Ячейки.Колонки.КоличествоКПеремещению.Имя 	= "Количество";
	
	НовТабл = Ячейки.Скопировать().СкопироватьКолонки();
	НовТабл.Колонки.Добавить("ДокументРезерва");
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Номенклатура,
	|	ДокументРезерва,
	|	КоличествоОстаток Количество
	|ИЗ
	|	РегистрНакопления.ТоварыВРезерве.Остатки(,Размещение = &Склад И Номенклатура В(&Номенклатура))
	|
	|");
	
	Запрос.УстановитьПараметр("Склад", 			Объект.Склад);
	Запрос.УстановитьПараметр("Номенклатура", 	Ячейки.ВыгрузитьКолонку("Номенклатура"));
	
	Резервы = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаЯчейки Из Ячейки Цикл
		
		Нужно 			= СтрокаЯчейки.Количество;
		СтрокиРезрва 	= Резервы.НайтиСтроки(Новый Структура("Номенклатура", СтрокаЯчейки.Номенклатура));
		
		Для Каждого СтрокаРезерва Из СтрокиРезрва Цикл
			
			Списываем = Мин(СтрокаРезерва.Количество, Нужно);
			
			Если Списываем Тогда
				
				НовСтрока = НовТабл.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтрока, СтрокаРезерва);
				ЗаполнитьЗначенияСвойств(НовСтрока, СтрокаЯчейки);
				
				НовСтрока.Количество = Списываем;
				
				СтрокаРезерва.Количество = СтрокаРезерва.Количество - Списываем;
				Нужно = Нужно - Списываем;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ЗначениеВСтрокуВнутр(НовТабл);
	
КонецФункции


&НаКлиенте
Процедура Переместить(Команда)
	
	// Проверим что нет местных резервов
	
	Отказ 	= Ложь;
	Инд 	= -1;
	
	Для Каждого Строка Из Объект.Товары Цикл Инд = Инд + 1;
		
		Поле = "Объект.Товары[" + Формат(Инд,"ЧГ=") +"]";
		
		Если Строка.КоличествоРезервЯчейка Тогда
			Отказ = Истина;
			ОбщиеФункции.СообщитьТекст("Существует резерв по ячейке!", Поле + ".КоличествоРезервЯчейка");
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не Отказ Тогда
		
		Если Объект.Ссылка.Пустая() Тогда
			Записать();
		КонецЕсли;
		
		ОткрытьФорму("Документ.ПеремещениеТоваров.ФормаОбъекта", 
					Новый Структура("Процесс, СкладОтправитель, СкладПолучатель, ТоварыСтрокой", 
								Объект.Ссылка, Объект.Склад, Объект.Склад, ТоварыБуфераДляПеремещенияСтрокой()),
					ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияПоСекции();
	Записать();
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

// ОТМЕТКИ


&НаКлиенте
Процедура Отметить(УсловиеПроверки, ИмяУстановки)
	
	ЕстьИзменения = Ложь;
	
	Для Каждого Строка Из Объект.Товары Цикл
		Если Вычислить(УсловиеПроверки) Тогда
			
			Строка[ИмяУстановки] = Не Строка[ИмяУстановки];
			ЕстьИзменения = Истина;
			
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьИзменения Тогда
		УправлениеВидимостьюДоступностью();
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ОтметитьВсеПроблемные(Команда)
	
	Отметить("Строка.ОбщееКоличествоНаСкладе <> Строка.ОбщееКоличествоВЯчейках", "ВыравнитьКоличество");
		
КонецПроцедуры
&НаКлиенте
Процедура ОтметитьВсеПеремещаемые(Команда)
	
	Отметить("Строка.КоличествоКПеремещению", "НужноПереместить");
	
КонецПроцедуры


// ЗАВЕРШЕНИЕ

&НаСервере
Функция ВыполнитьЗадачу()
	
	ЗадачаОбъект = ФункцииБизнесПроцессов.ТекущаяЗадача(Объект.Ссылка).ПолучитьОбъект();
	Если ЗадачаОбъект = Неопределено Тогда
			
		ОбщиеФункции.СообщитьТекст("Не найдена задача!");
		Возврат Ложь;
			
	КонецЕсли;
	
	Попытка
		ЗадачаОбъект.ВыполнитьЗадачу();
	Исключение
		
		стрОшибки = ОписаниеОшибки();
		ОбщиеФункции.СообщитьТекст("Ошибка выполнения задачи
								|" + стрОшибки);
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ЗавершитьИнвентаризацию(Команда)
	
	// Проверим на пустые
	
	Если Объект.Товары.НайтиСтроки(Новый Структура("КоличествоФакт",0)).Количество() И
		Вопрос("Не во всех позициях проставлено фактическое количество,
		|такие товар будут списаны,
		|Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Если Вопрос("Завершить инвентаризацию?
		|будет товара столько, сколько в колонке ""факт""", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		
		
		////временный костыль	
		//ТекстСообщения="";
		//Для Каждого Стр Из Объект.Товары Цикл
		//	Если Стр.КоличествоРасхождение > 0 Тогда
		//		ТекстСообщения = ТекстСообщения + Стр.Артикул + "  "+Стр.Номенклатура + "   "+Стр.КоличествоРасхождение+Символы.ПС;
		//	КонецЕсли;
		//КонецЦикла;
		//Если ТекстСообщения<>"" Тогда
		//	ТекстСообщения = "Излишки необходимо обработать вручную"+Символы.ПС+ТекстСообщения;
		//	Текст = Новый ТекстовыйДокумент;
		//	Текст.ДобавитьСтроку(ТекстСообщения);
		//	Текст.Показать("attention");
		//КонецЕсли;	
		////временный костыль	
		
		
		Если 	Записать(Новый Структура("Завершить", Истина)) И
			ВыполнитьЗадачу() Тогда
			
			Предупреждение("Инвентаризация секции завершена!");
			Закрыть();
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИнвентаризацию(Команда)
	
	Если 	Вопрос("Отменить инвентаризацию?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да И
			Записать(Новый Структура("Завершить", ЛОЖЬ)) И
			ВыполнитьЗадачу() Тогда
					
		Предупреждение("Инвентаризация отменена!");
		Закрыть();
			
	КонецЕсли;
	
КонецПроцедуры


// ИНФОРМАЦИЯ О ТОВАРЕ

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре()	
	 	
КонецПроцедуры
&НаСервере
Процедура ОбработатьОтображениеИнформацииОТоваре() Экспорт
	
	РаботаСНоменклатурой.ОбработатьОтображениеИнформацииОТоваре(ЭтаФорма, "Товары", "Объект.Товары");
	
КонецПроцедуры

&НаКлиенте
Процедура ИнфТовараТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиент.ИнфТовараТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
	
КонецПроцедуры
&НаКлиенте
Процедура ИнфТовараЗаголовокHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиент.ИнфТовараЗаголовокHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка, "Товары", "Объект.Товары");
	
КонецПроцедуры

 &НаКлиенте
Процедура ПоказатьСкрытьИнфОТоваре(Команда)
	
	РаботаСНоменклатуройКлиент.ПоказатьСкрытьИнфОТоваре(ЭтаФорма);
	
КонецПроцедуры
&НаКлиенте
Процедура НастройкаИнфОТоваре(Команда) 
	
	РаботаСНоменклатуройКлиент.НастройкаИнфОТоваре(ЭтаФорма, "Товары", "Объект.Товары");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФактКакУчет(Команда)
	
	Если Вопрос("Заполнить факт как учет?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
	
		Для Каждого Строка Из Объект.Товары Цикл
			
			Строка.КоличествоФакт 			= Строка.КоличествоУчет;
			Строка.КоличествоРасхождение 	= 0;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры


#Область Автосохранение

&НаСервере
Процедура ЗагрузитьДанныеАвтосохранения(ДанныеДляПодбора)
	
	АвтосохранениеСервер.СчитатьДанныеФормыИУдалитьСохранение(ЭтаФорма, ДанныеДляПодбора)
	
КонецПроцедуры
&НаСервере
Функция АвтосохранениеСервер(ЕстьДамп)
	
	Возврат АвтосохранениеСервер.СохранитьДампФормы(ЭтаФорма, ЕстьДамп);
	
КонецФункции
&НаКлиенте
Процедура Автосохранение()
	
	Перем ЕстьДамп;
	
	Сохранилось = АвтосохранениеСервер(ЕстьДамп);
	
	АвтосохранениеКлиент.ПроизошлоАвтосохранение(Сохранилось, ЕстьДамп, Объект.Ссылка);
	
КонецПроцедуры
&НаСервере
Функция ПолучитьДамп()
	
	Возврат АвтосохранениеСервер.ПолучитьДамп(ЭтаФорма);

КонецФункции

#КонецОбласти


&НаСервере
Функция ПоместитьТоварыВХранилище() 
	
	ПустаяТаблица = Новый ТаблицаЗначений;
	Возврат ПоместитьВоВременноеХранилище(ПустаяТаблица,  УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура Подбор(Команда)
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	ПараметрыПодбора = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары);
	СтруктураКолонокТовары.ЕстьКоличество = Истина;
	ПараметрыПодбора.Вставить("СтруктураКолонокТовары", СтруктураКолонокТовары);
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", ПараметрыПодбора, Элементы.Товары);

КонецПроцедуры
&НаКлиенте
Процедура ТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение <> Неопределено Тогда		
		СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары);
			
		ПолучитьТоварыИзХранилища(ВыбранноеЗначение, СтруктураКолонокТовары);		// получаем
		УдалитьИзВременногоХранилища(ВыбранноеЗначение); 	// заметаем следы

		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры
&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресТоваровВХранилище, СтруктураКолонокТовары)
	
	Таблица = Объект.Товары.Выгрузить();
	ТаблицаНовая =  ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	ТаблицаНовая.Колонки.Добавить("КоличествоФакт", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(10,3)));
	МассивКоличеств = ТаблицаНовая.ВыгрузитьКолонку("Количество");
	ТаблицаНовая.ЗагрузитьКолонку(МассивКоличеств, "КоличествоФакт"); 
	КонвертацияТипов.ДобавитьТаблицуКДругойТаблице(Таблица, ТаблицаНовая);
	Объект.Товары.Загрузить(Таблица);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	ТекДанные.Артикул = ПолучитьАртикулТовара(ТекДанные.Номенклатура);
КонецПроцедуры

&НаСервере
Функция ПолучитьАртикулТовара(Ссылка)
	Возврат Ссылка.Артикул;
КонецФункции

#Область Корзина

#Если Не ВебКлиент Тогда
&НаСервере
Процедура ДобавитьИзКорзиныНаСервере(ИмяКомпа, СтруктураКолонокТовары, КолСтрок)
	
	МодульКорзины.ПолучитьТоварИзКорзины(Элементы.Товары, Объект.Товары, СтруктураКолонокТовары, ИмяКомпа, КолСтрок);
	
КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура ВставитьИзКорзины(Команда)
	
	КолСтрок = 0;
	ДобавитьИзКорзиныНаСервере(ИмяКомпьютера(), СтруктураКолонокТовары, КолСтрок);
	
	Если КолСтрок Тогда
		
		МодульКорзины.ОповеститьОВставкеТовараВДокумент(КолСтрок, Объект.Товары.Количество());
		
	Иначе
		
		МодульКорзины.ОповеститьЧтоНечегоДобавлять();
		
	КонецЕсли;
	

КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаСервере
Функция ПоложитьВКорзинуНаСервере(ВыделенныеИндексы, ИмяКомпа, КолВКорзине)
		
	Возврат МодульКорзины.ПоложитьТоварВКорзину(Объект.Товары, ВыделенныеИндексы, ИмяКомпа, КолВКорзине, "КоличествоФакт");
	
КонецФункции
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура ДобавитьВКорзину(Команда)
	
	ВыделенныеИндексы 	= МодульКорзины.ПолучитьВыделенныеСтрокиТоваров(Элементы.Товары, Объект.Товары);
	КолВКорзине 		= 0;
	КолТовара			= ВыделенныеИндексы.Количество();
	
	
	Если КолТовара Тогда
		
		Если ПоложитьВКорзинуНаСервере(ВыделенныеИндексы, ИмяКомпьютера(), КолВКорзине) Тогда
			МодульКорзины.ОповеститьОПомещенииТовара(КолТовара, КолВКорзине);
		КонецЕсли;
		
	Иначе
		
		МодульКорзины.ОповеститьЧтоНечегоДобавлять();
				
	КонецЕсли;

КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура РедактироватьТоварВКорзине(Команда)
	
	ОткрытьФорму("РегистрСведений.Корзина.Форма.Форма");
	
КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаСервере
Функция ОчиститьНаСервере(ИмяКомпа)
	
	Возврат МодульКорзины.ОчиститьКорзину(ИмяКомпа);
	
КонецФункции
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура ОчиститьКорзину(Команда)
	
	Если ОчиститьНаСервере(ИмяКомпьютера()) Тогда
		
		МодульКорзины.ОповеститьЧтоКорзинаОчищена();
		
	КонецЕсли;

КонецПроцедуры
#КонецЕсли

#КонецОбласти






