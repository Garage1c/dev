﻿

&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;

&НаКлиенте
перем мКолонкиТовары;

&НаКлиенте
Перем ОрганизацияПоДокументу, КонтрагентПоДокументу;

&НаКлиенте
Перем МассивКомментариев Экспорт;

&НаКлиенте
Перем мСтСтрокаРедактирования;


// ДОПОЛНИТЕЛЬНО
&НаСервере
Функция КонтрагентРаботаетСОрганизацией()
	Возврат Справочники.Контрагенты.КонтрагентРаботаетСОрганизацией(Контрагент, Организация);
КонецФункции

// ОБНОВЛЕНИЕ

&НаСервере
Процедура ПроверитьУстановитьАвтораНаСервере()
	
	Если Автор.Пустая() Тогда
		
		Автор = ПараметрыСеанса.ТекущийПользователь;
		
	КонецЕсли;
	
КонецПроцедуры
&Наклиенте
Процедура ПроверитьУстановитьАвтора()
	
	ПроверитьУстановитьАвтораНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок()
	
	Заголовок = ФункцииБизнесПроцессов.ПолучитьЗаголовокБП(Объект.Ссылка);
	
КонецПроцедуры
&НаСервере
Функция ТребуетПеремещения()
	
	Возврат Товары.НайтиСтроки(Новый Структура("Размещение", Справочники.Склады.ПустаяСсылка())).Количество() +
			Товары.НайтиСтроки(Новый Структура("Размещение", Склад)).Количество() <> Товары.Количество();
	
КонецФункции
&НаСервере
Процедура УправлениеВидимостьюДоступностью() Экспорт
	
	РазрешеноРедактировать 	= 	Не Объект.Стартован ИЛИ
								(	Объект.Стартован И 
									ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(
											Объект.Ссылка, 
											БизнесПроцессы.ЗаявкаПокупателя.ТочкиМаршрута.ФормированиеЗаказа
															)
									);
	ТребуетПеремещения 	= ТребуетПеремещения();
	ЕстьРазмещение 		= Не Товары.НайтиСтроки(Новый Структура("Размещение", Справочники.Склады.ПустаяСсылка())).Количество() = Товары.Количество();
	ЕстьОтгруженные 	= Булево(Товары.НайтиСтроки(Новый Структура("Отгружено", Истина)).Количество());
			
	// ВИДИМОСТЬ РЕКВИЗИТОВ ШАПКИ
	
	Элементы.Заказ.Видимость 		= Не Объект.Стартован;
	Элементы.Автор.ТолькоПросмотр 	= Не (РольДоступна("ПолныеПрава") ИЛИ РольДоступна("ПолныеПраваВОбласти")) И Не Автор.Пустая() И Автор <> ПараметрыСеанса.ТекущийПользователь;
	
	Элементы.Организация.	ТолькоПросмотр = Не РазрешеноРедактировать;
	Элементы.Контрагент.	ТолькоПросмотр = Не РазрешеноРедактировать;
	Элементы.Склад.			ТолькоПросмотр = Не РазрешеноРедактировать;
	Элементы.ТипЦен.		ТолькоПросмотр = Не РазрешеноРедактировать;   
	Элементы.Валюта.		ТолькоПросмотр = Не РазрешеноРедактировать;
	Элементы.СуммаВключаетНДС.	ТолькоПросмотр = Не РазрешеноРедактировать;
	Элементы.УчитыватьНДС.		ТолькоПросмотр = Не РазрешеноРедактировать;
	Элементы.Грузоотправитель.	ТолькоПросмотр = Не РазрешеноРедактировать;
	Элементы.Грузополучатель.	ТолькоПросмотр = Не РазрешеноРедактировать;
	Элементы.Плательщик.		ТолькоПросмотр = Не РазрешеноРедактировать;
	Элементы.ДисконтнаяКарта.	ТолькоПросмотр = Не РазрешеноРедактировать;
	Элементы.БанковскийСчетОрганизации.	ТолькоПросмотр = Не РазрешеноРедактировать;
	Элементы.БанковскийСчетПартнера.	ТолькоПросмотр = Не РазрешеноРедактировать;
	
	// ВИДИМОСТЬ ТАБЛИЧНОЙ ЧАСТИ
	
	Элементы.Товары.ТолькоПросмотр 		= Не РазрешеноРедактировать;

	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтатусОплатыЗаказа()
	
	Процент = Заказы.ПолучитьПроцентОплатыЗаказа(Объект.Заказ);
	ЕстьОтгруженные 	= Булево(Товары.НайтиСтроки(Новый Структура("Отгружено", Истина)).Количество());

	Если Не Процент Тогда
		Элементы.ДекорацияНадписьОплаты.Заголовок = "не оплачен";
		Элементы.ДекорацияНадписьОплаты.ЦветТекста = Новый Цвет(?(ЕстьОтгруженные,255,0),0,0);
	ИначеЕсли Процент = 100 Тогда
		Элементы.ДекорацияНадписьОплаты.Заголовок = "оплачен";
		Элементы.ДекорацияНадписьОплаты.ЦветТекста = Новый Цвет(0,157,0);
	ИначеЕсли Процент > 100 Тогда
		Элементы.ДекорацияНадписьОплаты.Заголовок = "Переплачен";
		Элементы.ДекорацияНадписьОплаты.ЦветТекста = Новый Цвет(113,0,0);
	Иначе
		Элементы.ДекорацияНадписьОплаты.Заголовок = "оплата " + Формат(Процент,"ЧГ=") + " %";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРеквизиты()
	
	ФункцииБизнесПроцессов.ЗаполнитьДанные(ЭтаФорма, Объект.Ссылка);
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

// ТИПОВЫЕ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		
		Если Не Параметры.Контрагент.Пустая() Тогда
			
			Контрагент = Параметры.Контрагент;
			КонтрагентПриИзмененииНаСервере();
			
		КонецЕсли;
		
	КонецЕсли;
	

	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	// комментарии
	ФункцииБизнесПроцессов.ДобавитьРаботуСКомментариями(ЭтаФорма);
	
	// установим параметр
	
	ЗадачиПроцесса.Параметры.УстановитьЗначениеПараметра("Ссылка", 		Объект.Ссылка);
	ДокументыПроцесса.Параметры.УстановитьЗначениеПараметра("Ссылка", 	Объект.Ссылка);
	ДокументыПроцесса.Параметры.УстановитьЗначениеПараметра("Заказ", 	Объект.Заказ);
	
	// Прочитаем товары
	
	ПрочитатьРеквизиты();
	ФункцииФормДокументов.РассчитатьДинамическиеКолонки(
					Товары,
					ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, СуммаВключаетНДС, ТипЦен, , , Валюта, УчитыватьНДС, Валюта, СуммаВключаетНДС,,УчитыватьНДС,,Контрагент));
		
	ДолгПарнера = ?(Объект.Ссылка.Пустая(), 0, ДенежныеСредства.ПолучитьДолгКонтрагента(Контрагент));
	УстановитьСтатусОплатыЗаказа();	

	// Управление видимостью доступностью
	
	УправлениеВидимостьюДоступностью();
	
	// Обновим заголовок
	
	УстановитьЗаголовок();
	
	// ФИЛЬТРЫ
	
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Организация"));
	Элементы.БанковскийСчетОрганизации.СвязиПараметровВыбора  = Новый ФиксированныйМассив(НовыйМассив);
	
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Контрагент"));
	Элементы.БанковскийСчетПартнера.СвязиПараметровВыбора = Новый ФиксированныйМассив(НовыйМассив);
	

	ФункцииФормДокументовСервер.УстановитьСвязиГрузополучателя(Объект,Элементы,Новый Структура("Грузополучатель, БанковскийСчетГрузополучателя, Грузоотправитель, БанковскийСчетГрузоотправителя","Контрагент","Грузополучатель","Организация","Грузоотправитель"));
	ПустойПартнераКонтрагент = Справочники[?(ПолучитьФункциональнуюОпцию("НемецкийУчет"), "Контрагенты", "Грузополучатели")].ПустаяСсылка();
	Если НЕ ЗначениеЗаполнено(Грузоотправитель) Тогда Грузоотправитель	= ПустойПартнераКонтрагент КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Грузополучатель)  Тогда Грузополучатель	= ПустойПартнераКонтрагент КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьКолонкиТоваров()
	
	текКолонки = Новый Массив;
	
	Колонки = Товары.Выгрузить().Колонки;
	Для Каждого Колонка Из Колонки Цикл текКолонки.Добавить(Колонка.Имя); КонецЦикла;
	
	Возврат текКолонки;
	
КонецФункции
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	
	СтруктураКолонокТовары 	= ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, СуммаВключаетНДС, ТипЦен, , , Валюта, УчитыватьНДС, Валюта, СуммаВключаетНДС,,УчитыватьНДС,,Контрагент);
	мКолонкиТовары 			= ПолучитьКолонкиТоваров();
	
	ФункцииФормДокументов.УстановитьДоступностьКолонокТоваров(Элементы.Товары, СтруктураКолонокТовары);

	// комментарии
	ФункцииБизнесПроцессовКлиент.ПолучитьМассивКомментариев(ЭтаФорма, Объект.Ссылка);
	
	// Пересчитаем строки если заказ был добавлен
	
	//ФункцииФормДокументов.РассчитатьДинамическиеКолонки(Товары, СтруктураКолонокТовары);
	//ФункцииФормДокументов.ОбновитьПодвал(ЭтаФорма, Элементы, Всего, СтруктураКолонокТовары,,  "ВсегоНДС", ВсегоНДС);
	//ФункцииФормДокументов.ОбновитьПодвал(ЭтаФорма, Элементы, ВсегоБыло, СтруктураКолонокТовары,,  "ВсегоНДС", ВсегоНДС);
	
	ОрганизацияПоДокументу = Организация;
	КонтрагентПоДокументу = Контрагент;
   // ОбновитьЗаголовки();
   
	
КонецПроцедуры
&НаКлиенте
Процедура ОбщиеРеквизитыНажатие(Элемент)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизитыБП(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если 	Не Модифицированность И
			(	ИмяСобытия = СобытияСистемы.Событие_ЗаписанаЗадача() ИЛИ
				ИмяСобытия = СобытияСистемы.Событие_ЗаписанБизнесПроцесс()
			) Тогда
		
		ПрочитатьРеквизиты();
   	ИначеЕсли
		ИмяСобытия = СобытияСистемы.Событие_ЗаписанКонтрагент() Тогда
		
		КонтрагентПриИзмененииНаСервере(СтруктураКолонокТовары);
		
		ОрганизацияПоДокументу = Организация;
		КонтрагентПоДокументу = Контрагент;
		   
	КонецЕсли;

КонецПроцедуры
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	СобытияСистемы.ОповеститьОЗаписиБизнесПроцесса(Объект.Ссылка, ЭтаФорма);
КонецПроцедуры
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УстановитьСтатусОплатыЗаказа();
КонецПроцедуры
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если 	ПараметрыЗаписи.Свойство("Старт") И 
			ПараметрыЗаписи.Старт И
			Не СоздатьРедактированиеОтгруженногоЗаказа() Тогда
			
		Отказ = Истина; КонецЕсли;
	
КонецПроцедуры

// СОБЫТИЯ ЭЛЕМЕНТОВ

&НаКлиенте
Процедура ДокументыПроцессаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекДанные = Элемент.ТекущиеДанные;
	
	Если ТекДанные.ВидДокумента = "ЗаказПокупателя" Тогда
		
		ОткрытьФорму("Документ.ЗаказПокупателя.ФормаОбъекта", Новый Структура("Ключ, НеОткрыватьДругуюФорму", ТекДанные.Документ, Истина), ЭтаФорма);
		
	Иначе
		
		ОткрытьФорму("Документ." + ТекДанные.ВидДокумента + ".ФормаОбъекта", Новый Структура("Ключ", ТекДанные.Документ), ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры


// ЗАПИСЬ ЗАКАЗА

&НаСервере
Функция ЕстьРазмещение()
	
	Возврат Товары.НайтиСтроки(
				Новый Структура(
						"Размещение", 
						Справочники.Склады.ПустаяСсылка()
								)).Количество() < Товары.Количество();
КонецФункции

&НаСервере
Функция СоздатьРедактированиеОтгруженногоЗаказа()
	
	ТаблицаИзменений = КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(Товары.Выгрузить(), Новый Структура("Изменено", Истина));
	Если Не ТаблицаИзменений.Количество() Тогда ОбщиеФункции.СообщитьТекст("Нет ничего для изменения"); Возврат Ложь; КонецЕсли;
	
	НовДок = Документы.РедактированиеОтгруженногоЗаказа.СоздатьДокумент();
	
	НовДок.Заказ 	= Объект.Заказ;
	НовДок.Дата 	= ТекущаяДата();
		
	// Таблица
		
	НовДок.Товары.Загрузить(ТаблицаИзменений);
		
	// Проведение
	
	Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(НовДок, РежимЗаписиДокумента.Проведение);
		
КонецФункции

&НаКлиенте
Процедура ПровестиЗаказИЗакрыть(Команда)
	
	Если Записать(Новый Структура("Старт", Истина)) Тогда
		Закрыть(); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Функция ПроверитьРазмещениеВсегоТовара()
	
	Отказ = Ложь;
	
	Инд = -1;
	Для Каждого Строка Из Товары Цикл Инд = Инд + 1;
		Если Не ЗначениеЗаполнено(Строка.Размещение) Тогда
			
			Отказ = Истина;
			ОбщиеФункции.СообщитьТекст("Нет размещения", "Товары[" + Инд + "].Размещение", Объект);
				
		КонецЕсли;
	КонецЦикла;
	
	Возврат Не Отказ;
	
КонецФункции
&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПроверитьУстановитьАвтора();
	
	Если Записать() Тогда
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура БыстраяПродажа(Команда)
	
	Если 	Вопрос("Отгрузить товар контрагенту?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да И
			Записать(Новый Структура("БыстраяПродажа, ВыполнитьЗадачу", Истина, Истина)) Тогда
			
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры


// ОБРАБОТКИ ТАБЛИЧНОЙ ЧАСТИ

&НаКлиенте
Функция ЭтаКолонкаПредЗначения(ИмяКолонки)
	
	Возврат Врег(Прав(ИмяКолонки,4)) = Врег("Было");
	
КонецФункции
&НаКлиенте
Функция ИмяНастЗначенияКолонки(ИмяСтКолонки)
	
	Возврат Сред(ИмяСтКолонки, 1, СтрДлина(ИмяСтКолонки) - 4);
	
КонецФункции
&НаКлиенте
Функция ЭтоНоваяСтрока(Строка)
	
	Возврат Строка.НоменклатураБыло.Пустая();
	
КонецФункции

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)

	ФункцииФормДокументов.НоменклатураПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары);

КонецПроцедуры
&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	ФункцииФормДокументов.КоличествоПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура ЦенаПриИзменении(Элемент)
	
	ФункцииФормДокументов.ЦенаПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	
	ФункцииФормДокументов.СуммаПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)
	
	ФункцииФормДокументов.СтавкаНДСПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура УпаковкаПриИзменении(Элемент)
	
	ФункцииФормДокументов.УпаковкаПриИзменении(
			Элементы.Товары, 
			СтруктураКолонокТовары);
			
КонецПроцедуры
&НаКлиенте
Процедура СуммаНДСПриИзменении(Элемент)
	
	ФункцииФормДокументов.СуммаНДСПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцентРучнойСкидкиПриИзменении(Элемент)
	
	ФункцииФормДокументов.ПроцентРучнойСкидкиПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура ПроцентАвтоматическойСкидкиПриИзменении(Элемент)
	ФункцииФормДокументов.ПроцентАвтоматическойСкидкиПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
КонецПроцедуры

&НаКлиенте
Процедура СуммаРучнойСкидкиПриИзменении(Элемент)
	
	ФункцииФормДокументов.СуммаРучнойСкидкиПриИзменении(Элементы.Товары, СтруктураКолонокТовары);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	текДанные = Элементы.Товары.ТекущиеДанные;
	
	Если текДанные <> Неопределено Тогда 
		
		// Проверим может это наша новая строка
		
		Если Не ЭтоНоваяСтрока(текДанные) Тогда
			
			Отказ = Истина;
			Для Каждого Колонка Из мКолонкиТовары Цикл Если Не ЭтаКолонкаПредЗначения(Колонка) Тогда текДанные[Колонка] = Неопределено; КонецЕсли; КонецЦикла; 
			
			// Скажем что это измененная строка
			
			текДанные.Изменено = Истина; КонецЕсли;КонецЕсли;
		
КонецПроцедуры
&НаКлиенте
Процедура ТоварыПередНачаломИзменения(Элемент, Отказ)
	
	текДанные = Элемент.ТекущиеДанные;
	
	// запомним текущую строку
	
	мСтСтрокаРедактирования = Новый Структура("Номенклатура, Упаковка, Размещение, Количество",
										текДанные.Номенклатура, текДанные.Упаковка, текДанные.Размещение, текДанные.Количество);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	// Очистим что было перед копированием
	
	стр 		= Врег("Было");
	текДанные 	= Элемент.ТекущиеДанные;
	
	Если Копирование Тогда
		Для Каждого Колонка Из мКолонкиТовары Цикл Если Прав(Врег(Колонка), стрДлина(стр)) = стр Тогда текДанные[Колонка] = Неопределено КонецЕсли; КонецЦикла; КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Изменено 	= Ложь;
	текДанные 	= Элемент.ТекущиеДанные;
	
	Для Каждого Колонка Из мКолонкиТовары Цикл 
		Если 	ЭтаКолонкаПредЗначения(Колонка) И
				текДанные[Колонка] <> текДанные[ИмяНастЗначенияКолонки(Колонка)] Тогда
				
			Изменено = Истина;
			Прервать; КонецЕсли; КонецЦикла;
	
	текДанные.Изменено = Изменено;
	
	// Проверим есть изменения или нет
	
			//УстановитьФлагИзменено(текДанные.ПолучитьИдентификатор());
	
	// Проверим если изменили че низя тогда им кердык
	
	//Если Не НоваяСтрока И текДанные.Собрано Тогда
	//
	//	Для Каждого Элемент Из мСтСтрокаРедактирования Цикл
	//		Если Элемент.Значение <> текДанные[Элемент.Ключ] Тогда
	//			
	//			Если Вопрос("Изменились реквизиты которые изменять запрещено
	//				|вернуть как было?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
	//				
	//				ОтменаРедактирования = Истина;
	//				Для Каждого Элемент Из мСтСтрокаРедактирования Цикл текДанные[Элемент.Ключ] = Элемент.Значение; КонецЦикла;
	//				ФункцииФормДокументов.РассчитатьСуммыТабличныхЧастей(ТекДанные, СтруктураКолонокТовары);
	//				
	//			Иначе Отказ = Истина; КонецЕсли; Прервать;
	//			
	//		КонецЕсли;
	//	КонецЦикла;
	//КонецЕсли;
	
КонецПроцедуры
 

// ИНФОРМАЦИЯ О ТОВАРЕ

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

// КОММЕНТАРИИ

&НаКлиенте
Процедура КомандаПоказатьКомментарий(Команда)
	ФункцииБизнесПроцессовКлиент.КомандаПоказатьКомментарий(ЭтаФорма);
КонецПроцедуры

 // РЕКВИЗИТЫ ШАПКИ

&НаКлиенте
Процедура СохранитьТекущиеЗначенияПараметров()
	
	// сохраняем текущие значения параметров
	
	СтруктураКолонокТовары.стТипЦен = ТипЦен;
	СтруктураКолонокТовары.стУчитыватьНДС = УчитыватьНДС;
	СтруктураКолонокТовары.стСуммаВключаетНДС = СтруктураКолонокТовары.СуммаВключаетНДС;
	СтруктураКолонокТовары.стВалюта = СтруктураКолонокТовары.Валюта;
	
	ОрганизацияПоДокументу = Организация;
	КонтрагентПоДокументу = Контрагент;
КонецПроцедуры
&НаСервере
Процедура ОбновитьСтруктуруКолонокТовары(СтруктураКолонокТовары)
	
	
	СтруктураКолонокТовары.Контрагент = Контрагент;
	
	СтруктураКолонокТовары.Валюта = Валюта;
	СтруктураКолонокТовары.ТипЦен = ТипЦен;
	СтруктураКолонокТовары.УчитыватьНДС = УчитыватьНДС;
	СтруктураКолонокТовары.СуммаВключаетНДС = СуммаВключаетНДС;

	СтруктураКолонокТовары.ДисконтнаяКарта = ДисконтнаяКарта;

КонецПроцедуры
&НаСервере
Процедура ПриИзмененииРеквизитаВлияющегоНаТабличнуюЧасть(СтруктураКолонокТовары, ОбновитьСтруктуру = Истина)
	
	//ОбновитьЗаголовки();
	
	Если ОбновитьСтруктуру Тогда
		ФункцииФормДокументов.ОбновитьСтруктуруКолонокТовары(
				ЭтаФорма, 
				СтруктураКолонокТовары, 
				КэшируемыеФункции.ПолучитьРеквизитыДокумента("ЗаказПокупателя"));
	КонецЕсли;
	
	ФункцииФормДокументов.ПересчитатьСуммыТабличныхЧастей(Товары, СтруктураКолонокТовары);
	
	ФункцииФормДокументов.ОбновитьПодвал(ЭтаФорма, Элементы, Всего, СтруктураКолонокТовары,,  "ВсегоНДС", ВсегоНДС);
	
КонецПроцедуры 

&НаСервере
Процедура ОбновитьИтоги(СтруктураКолонокТовары)
	
	ФункцииФормДокументов.ОбновитьПодвал(ЭтаФорма, Элементы, Всего, СтруктураКолонокТовары,,  "ВсегоНДС", ВсегоНДС);

КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовки()
	
	//Элементы.ВсегоНДС.Заголовок = ?(СуммаВключаетНДС, "В т.ч. НДС", "Сумма НДС");
	//Элементы.ВсегоНДС.Заголовок = ?(НЕ УчитыватьНДС, "Без налога (НДС)", "");

КонецПроцедуры

// ОСНОВНЫЕ РЕКВИЗИТЫ ШАПКИ

&НаСервере
Процедура ЗаполнитьПроцентАвтоматическойСкидки()
	
	Для Каждого Строка Из Товары Цикл
		Строка.ПроцентАвтоматическойСкидки = РаботаСНоменклатурой.ПолучитьПроцентАвтоматическойСкидки(Строка.Номенклатура, Контрагент, ДисконтнаяКарта, Строка.Акция);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере(СтруктураКолонокТовары = Неопределено)
	
	// заполним зависимые реквизиты
	ФункцииФормДокументов.КонтрагентПриИзменении(ЭтаФорма);
	ЗаполнитьПроцентАвтоматическойСкидки();
	
	// обновим табличную часть
	Если СтруктураКолонокТовары <> Неопределено Тогда
	   	ПриИзмененииРеквизитаВлияющегоНаТабличнуюЧасть(СтруктураКолонокТовары);
	КонецЕсли;

	
КонецПроцедуры
&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере(СтруктураКолонокТовары)
	
	// проставим зависимые реквизиты
	ФункцииФормДокументов.ОрганизацияПриИзменении(ЭтаФорма);
	
	// обновим табличную часть
	//ОбновитьСтруктуруКолонокТовары(СтруктураКолонокТовары);
	ПриИзмененииРеквизитаВлияющегоНаТабличнуюЧасть(СтруктураКолонокТовары);
	
КонецПроцедуры


&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
			
	КонтрагентПриИзмененииНаСервере(СтруктураКолонокТовары);
	СохранитьТекущиеЗначенияПараметров();
	
	Грузополучатель = ФункцииФормДокументовСервер.ГрузополучательПриИзмененииРеквизита(Контрагент);
	БанковскийСчетГрузополучателя = ФункцииФормДокументовСервер.БанковскийСчетПриИзмененииРеквизита(Грузополучатель);
КонецПроцедуры
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если НЕ ДиалогиСПользователем.ПроверитьНаСоответствиеОсновнойОрганизации(
				Контрагент, 
				Организация, 
				КонтрагентРаботаетСОрганизацией()) Тогда
		
		Организация = ОрганизацияПоДокументу;
	
	КонецЕсли;
	
	ОрганизацияПриИзмененииНаСервере(СтруктураКолонокТовары);
	СохранитьТекущиеЗначенияПараметров();
	
	Грузоотправитель = ФункцииФормДокументовСервер.ГрузополучательПриИзмененииРеквизита(Организация);
	БанковскийСчетГрузоотправителя = ФункцииФормДокументовСервер.БанковскийСчетПриИзмененииРеквизита(Грузоотправитель);
КонецПроцедуры


// ПРОСТЫЕ РЕКВИЗИТЫ ШАПКИ

&НаКлиенте
Процедура ТипЦенПриИзменении(Элемент)
		
	Если ФункцииФормДокументов.ДиалогПриИзмененииТипаЦен(Товары.Количество()) Тогда
		
		ПриИзмененииРеквизитаВлияющегоНаТабличнуюЧасть(СтруктураКолонокТовары);
		
	КонецЕсли;
	
	СохранитьТекущиеЗначенияПараметров();
	
КонецПроцедуры
&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	Если ФункцииФормДокументов.ДиалогПриИзмененииВалюты(Товары.Количество()) Тогда
		ПриИзмененииРеквизитаВлияющегоНаТабличнуюЧасть(СтруктураКолонокТовары);
	КонецЕсли;

	СохранитьТекущиеЗначенияПараметров();

КонецПроцедуры
&НаКлиенте
Процедура УчитыватьНДСПриИзменении(Элемент)
	
	//Элементы.ВсегоНДС.Заголовок = ?(НЕ УчитыватьНДС, "Без налога (НДС)", "");
	
	Если ФункцииФормДокументов.ДиалогПриИзмененииУчитыватьНДС(УчитыватьНДС, Товары.Количество()) Тогда
		ПриИзмененииРеквизитаВлияющегоНаТабличнуюЧасть(СтруктураКолонокТовары);
	КонецЕсли;
	
	СохранитьТекущиеЗначенияПараметров();

КонецПроцедуры
&НаКлиенте
Процедура СуммаВключаетНДСПриИзменении(Элемент)
	
	//Элементы.ВсегоНДС.Заголовок = ?(СуммаВключаетНДС, "В т.ч. НДС", "Сумма НДС");
	
	Если ФункцииФормДокументов.ДиалогПриИзмененииСуммаВключаетНДС(СуммаВключаетНДС, Товары.Количество()) Тогда
		ПриИзмененииРеквизитаВлияющегоНаТабличнуюЧасть(СтруктураКолонокТовары);
	КонецЕсли;

	СохранитьТекущиеЗначенияПараметров();	

КонецПроцедуры
&НаКлиенте
Процедура ДисконтнаяКартаПриИзменении(Элемент)
	
	// вставить проверку на владельца
	ЗаполнитьПроцентАвтоматическойСкидки();
    ПриИзмененииРеквизитаВлияющегоНаТабличнуюЧасть(СтруктураКолонокТовары);//ДисконтнаяКартаПриИзмененииНаСервере(СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

// РЕКВИЗИТЫ ПЕЧАТИ
 
&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	БанковскийСчетГрузополучателя = ФункцииФормДокументовСервер.БанковскийСчетПриИзмененииРеквизита(Грузополучатель);
КонецПроцедуры
&НаКлиенте

Процедура ГрузоотправительПриИзменении(Элемент)
	БанковскийСчетГрузоотправителя = ФункцииФормДокументовСервер.БанковскийСчетПриИзмененииРеквизита(Грузоотправитель);
 КонецПроцедуры

// МЕНЮ - "ИЗМЕНИТЬ"

&НаКлиенте
Процедура ЗаполнитьРучСкидку(Команда)
	
	//ДиалогиСПользователем.ЗаполнитьРучСкидку(Товары, СтруктураКолонокТовары,"Не Строка.Отгружено И Не Строка.Собрано");
	ДиалогиСПользователем.ЗаполнитьРучСкидку(Товары, СтруктураКолонокТовары,"Не Строка.Отгружено");
	//УправлениеВидимостьюДоступностью();
	ФункцииФормДокументов.ОбновитьПодвал(ЭтаФорма, Элементы, Всего, СтруктураКолонокТовары,,  "ВсегоНДС", ВсегоНДС);
	
КонецПроцедуры
&НаКлиенте
Процедура ЗаполнитьСтавкуНДС(Команда)
	
	//ДиалогиСПользователем.ЗаполнитьСтавкуНДС(Товары, СтруктураКолонокТовары, "Не Строка.Отгружено И Не Строка.Собрано");
	ДиалогиСПользователем.ЗаполнитьСтавкуНДС(Товары, СтруктураКолонокТовары, "Не Строка.Отгружено");
	//УправлениеВидимостьюДоступностью();
	ФункцииФормДокументов.ОбновитьПодвал(ЭтаФорма, Элементы, Всего, СтруктураКолонокТовары,,  "ВсегоНДС", ВсегоНДС);
КонецПроцедуры

&НаКлиенте
Процедура ДолгПарнераНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	
	ПараметрыФормы = Новый Структура("Отбор, КлючНазначенияИспользования, СформироватьПриОткрытии", 
	 							Новый Структура("Контрагент", 
											Контрагент),,
								Истина);
								
	ОткрытьФорму("Отчет.ВзаиморасчетыПоПартнеру.ФормаОбъекта", ПараметрыФормы); 

КонецПроцедуры

 //?
&НаКлиенте
Процедура ОткрытьНастройкуОИТ(Команда)
	ОткрытьФорму("ОбщаяФорма.НастройкаОперативнойИнформацииОТоваре", , ЭтаФорма);
КонецПроцедуры

&НаСервере 
Функция ПолучитьПользовательскиеНастройкиОтчета(ПользовательскиеНастроки, НастройкиОтбора) 
	
	Отчет = Отчеты.ВзаиморасчетыСПартнером.Создать();
	ПользовательскиеНастроки = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки; 
	НастройкиОтбора = Отчет.КомпоновщикНастроек.Настройки.Отбор;
	
КонецФункции 

&НаСервереБезКонтекста 
Процедура УстановитьЗначениеПользовательскойНастройки(Настройки, НастройкиОтбора, Имя, Значение, Использование = Истина)
		Для Каждого Элемент ИЗ НастройкиОтбора.Элементы Цикл
			
			Если	Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Имя) Тогда
					настройкаИД = Элемент.ИдентификаторПользовательскойНастройки;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Элемент Из Настройки.Элементы Цикл
			Если ТипЗнч(Элемент) = Тип("ЭлементОтбораКомпоновкиДанных") И Элемент.ИдентификаторПользовательскойНастройки = настройкаИД Тогда
				
					Элемент.ПравоеЗначение 	= Значение;
					Элемент.Использование 	= Использование;
			КонецЕсли
		КонецЦикла;

КонецПроцедуры 

// МЕНЮ - "ВЕС И ОБЪЕМ"

&НаСервере
Функция ПодготовитьТаблицу()
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Товары.Выгрузить(), УникальныйИдентификатор);
	
	Возврат АдресХранилища;
	
КонецФункции
&НаКлиенте
Процедура ВесОбъем(Команда)
	
	// пока так
	
	АдресХранилища = ПодготовитьТаблицу();
	                                                                                                               
	ОткрытьФорму("Документ.ИнтернетЗаказПокупателя.Форма.ФормаВеса", Новый Структура("АдресХранилища", АдресХранилища));

КонецПроцедуры




