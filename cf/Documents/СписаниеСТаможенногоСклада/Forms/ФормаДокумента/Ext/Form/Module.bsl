﻿&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;

&НаКлиенте
Процедура ОбщиеРеквизиты(Команда)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизиты(ЭтаФорма);
	
КонецПроцедуры


&НаСервере
Процедура ПересчитатьСуммыТабличныхЧастей(СтруктураКолонокТовары) Экспорт
	
	ФункцииФормДокументов.ПересчитатьСуммыТабличныхЧастей(Объект.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеВидимостьюДоступностью() Экспорт
	
	// Установим доступность кнопок
	
	ДостОтправителя = Элементы.ТоварыЯчейкаОтправитель.Видимость;
	ДостПолучателя 	= Элементы.ТоварыЯчейкаПолучатель.Видимость;
	
	Элементы.ТоварыЗаполнитьЯчейкиОтправителя.Доступность 			= ДостОтправителя;
	Элементы.ТоварыЗаполнитьВыбранныеЯчейкиОтправителя.Доступность 	= ДостОтправителя;
	Элементы.ТоварыОчиститьЯчейкиОтправителя.Доступность 			= ДостОтправителя;
	
	Элементы.ТоварыЗаполнитьЯчейкиПолучателя.Доступность 			= ДостПолучателя;
	Элементы.ТоварыЗаполнитьВыбранныеЯчейкиПолучателя.Доступность 	= ДостПолучателя;
	Элементы.ТоварыОчиститьЯчейкиПолучателя.Доступность 			= ДостПолучателя;
	
	Элементы.ТоварыИнвертироватьЯчейки.Доступность = ДостОтправителя И ДостПолучателя;
	
КонецПроцедуры
&НаСервере
Процедура УстановитьВидимостьПооперации()
	
	ВидимостьПартнера = Объект.Операция = Перечисления.ОперацияТаможенногоСписания.ЭтоПродажа;
	
	Элементы.Организация.Видимость 				= ВидимостьПартнера;
	Элементы.ГруппаДополнительно.Доступность 	= ВидимостьПартнера;
	Элементы.Контрагент.Видимость 					= ВидимостьПартнера;
	Элементы.СкладПолучатель.Видимость 			= Не ВидимостьПартнера;
	Элементы.ДисконтнаяКарта.Видимость 			= ВидимостьПартнера;
	
	Элементы.Реквизиты.Группировка 				= ГруппировкаПодчиненныхЭлементовФормы[?(ВидимостьПартнера, "Горизонтальная", "Вертикальная")];
	Элементы.РеквизитыШапкиПравые.Группировка 	= ГруппировкаПодчиненныхЭлементовФормы[?(ВидимостьПартнера, "Вертикальная", "Горизонтальная")];
	
КонецПроцедуры

// ПРЕДОПРЕДЕЛЕННЫЕ ПРОЦЕДУРЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	
	// Значения по умолчанию
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ФункцииФормДокументов.ЗаполнитьЗначенияПоУмолчанию(Объект, Метаданные.Документы.РеализацияТоваров.Реквизиты);
		Объект.СуммаВключаетНДС = Истина; КонецЕсли;
	
	// информация о товаре
	
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	// Рассчитаем динамические колонки
	
	ФункцииФормДокументов.РассчитатьДинамическиеКолонки(
					Объект.Товары,
					ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Объект.СуммаВключаетНДС, Объект.ТипЦен));
					
	// Вилимость
	
	УстановитьВидимостьПооперации();
						
	ФункцииФормДокументовСервер.УстановитьСвязиГрузополучателя(Объект,Элементы,Новый Структура("Грузополучатель, БанковскийСчетГрузополучателя, Грузоотправитель, БанковскийСчетГрузоотправителя","Объект.Контрагент","Объект.Грузополучатель","Объект.Организация","Объект.Грузоотправитель"));
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	 
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Объект.СуммаВключаетНДС, Объект.ТипЦен, , , Объект.Валюта, Объект.УчитыватьНДС, Объект.Валюта, Объект.СуммаВключаетНДС,,Объект.УчитыватьНДС,,Объект.Контрагент);
	
	// 	Обновим подвал
	
	ФункцииФормДокументов.ОбновитьПодвал(Объект, Элементы, Сумма, СтруктураКолонокТовары);
	
	// Видимость ячеек
	
	Элементы.ТоварыЯчейкаОтправитель.Видимость 	= СкладЯчеестый(Объект.СкладОтправитель);
	Элементы.ТоварыЯчейкаПолучатель.Видимость 	= СкладЯчеестый(Объект.СкладПолучатель);
	
	// Управление видимостью доступностью
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

&НаСервере
Функция СкладЯчеестый(СкладСсылка)
	
	Возврат СкладСсылка.Ячеестый;
	
КонецФункции

#Область Шапка

&НаКлиенте
Процедура СкладОтправительПриИзменении(Элемент)
	
	Элементы.ТоварыЯчейкаОтправитель.Видимость = СкладЯчеестый(Объект.СкладОтправитель);
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПолучательПриИзменении(Элемент)
	
	Элементы.ТоварыЯчейкаПолучатель.Видимость = СкладЯчеестый(Объект.СкладПолучатель);
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

#КонецОбласти

#Область Заполнение_ячеек

&НаСервере
Процедура ЗаполнитьКолонкуНаСервере(Имя, Значение)
	
	Таблица = Объект.Товары.Выгрузить();
	Таблица.ЗаполнитьЗначения(Значение, Имя);
	Объект.Товары.Загрузить(Таблица);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаполненияКолонокНаСервере(Результат, Параметры) Экспорт
	Если Результат <> Неопределено Тогда
		ЗаполнитьКолонкуНаСервере(Параметры.ИмяКолонки, Результат);	
	КонецЕсли;	
конецПроцедуры	

&НаСервере
Функция РасспределитьЯчейкиНаСервере()
	
	// Подготовим таблицу для передачи
	
	//Таблица = Объект.Товары.Выгрузить();
	ФункцииФормДокументов.ЗаполнитьЯчейки(Объект.Товары,,,Объект.СкладОтправитель,, "ЯчейкаОтправитель");
	
	//	// Загрузим измененную таблицу обратно
	//	
	//	Объект.Товары.Загрузить(Таблица);
	//	Возврат Истина;
	//	
	//Иначе
	//	
	//	Возврат Ложь;
	//	
	//КонецЕсли;
	
КонецФункции
&НаКлиенте
Процедура ЗаполнитьЯчейки(Команда)
	
	РасспределитьЯчейкиНаСервере();
	
КонецПроцедуры
&НаКлиенте
Процедура ЗаполнитьОднойЯчейкойОтправителя(Команда)
	
	ВыбрЯчейка = ОткрытьФорму("Справочник.Ячейки.ФормаВыбора", Новый Структура("Склад", Объект.СкладПолучатель),,,,,Новый ОписаниеОповещения("ОбработкаЯчеек",ЭтаФорма,Новый Структура("ИмяКолонки", "ЯчейкаОтправитель")));

КонецПроцедуры


&НаСервере
Процедура УстановитьЯчейкуДляВсехНаСервере(Ячейка, ИмяКолонки = "ЯчейкаПолучатель")
	
	Табл = Объект.Товары.Выгрузить();
	Табл.ЗаполнитьЗначения(Ячейка, ИмяКолонки);
	Объект.Товары.Загрузить(Табл);
			
КонецПроцедуры
&НаКлиенте
Процедура ЗаполнитьЯчейкиПолучателя(Команда)
	
	ОткрытьФорму("Справочник.Ячейки.ФормаВыбора", Новый Структура("Склад", Объект.СкладПолучатель),,,,,Новый ОписаниеОповещения("ОбработкаЯчеек",ЭтаФорма,Новый Структура("ИмяКолонки", "ЯчейкаПолучатель")));
	
КонецПроцедуры
&НаКлиенте
Процедура ОбработкаЯчеек(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда УстановитьЯчейкуДляВсехНаСервере(Результат, Параметры.ИмяКолонки) КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвертироватьЯчейки(Команда)
	
	Для Каждого Строка Из Объект.Товары Цикл
		
		стЯчейка = Строка.ЯчейкаОтправитель;
		Строка.ЯчейкаОтправитель 	= Строка.ЯчейкаПолучатель;
		Строка.ЯчейкаПолучатель 	= стЯчейка;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЯчейкиОтправителя(Команда)
	
	УстановитьЯчейкуДляВсехНаСервере(Неопределено, "ЯчейкаОтправитель")
	
КонецПроцедуры
&НаКлиенте
Процедура ОчиститьЯчейкиПолучателя(Команда)
	
	УстановитьЯчейкуДляВсехНаСервере(Неопределено, "ЯчейкаПолучатель")
	
КонецПроцедуры


#КонецОбласти

#Область Обработка_табличной_части

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

#КонецОбласти

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
	
	Возврат МодульКорзины.ПоложитьТоварВКорзину(Объект.Товары, ВыделенныеИндексы, ИмяКомпа, КолВКорзине);
	
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
Процедура ДисконтнаяКартаПриИзменении(Элемент)
	
	ДисконтнаяКартаПриИзмененииНаСервере(СтруктураКолонокТовары);
	         
КонецПроцедуры

&НаСервере
Процедура ДисконтнаяКартаПриИзмененииНаСервере(СтруктураКолонокТовары = Неопределено)
	
	Если СтруктураКолонокТовары <> Неопределено Тогда
		СтруктураКолонокТовары.ДисконтнаяКарта = Объект.ДисконтнаяКарта;
	КонецЕсли;
	
	Для Каждого Строка Из Объект.Товары Цикл
				
		Строка.ПроцентАвтоматическойСкидки = РаботаСНоменклатурой.ПолучитьПроцентАвтоматическойСкидки(Строка.Номенклатура, Объект.Контрагент, Объект.ДисконтнаяКарта, Строка.Акция);
		ФункцииФормДокументов.ПроцентАвтоматическойСкидкиПриИзменении(Элементы.Товары, СтруктураКолонокТовары, Строка);
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьТаблицу()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Товары.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ВесОбъем(Команда)
	
	// пока так
	
	ОткрытьФорму("Документ.ИнтернетЗаказПокупателя.Форма.ФормаВеса", Новый Структура("АдресХранилища", ПодготовитьТаблицу()));
	
КонецПроцедуры

// КОМАНДЫ

&НаКлиенте
Процедура ЗаполнитьРучСкидку(Команда)
	
	ДиалогиСПользователем.ЗаполнитьРучСкидку(Объект.Товары, СтруктураКолонокТовары);
		
КонецПроцедуры
&НаКлиенте
Процедура ЗаполнитьСтавкуНДС(Команда)
	
	ДиалогиСПользователем.ЗаполнитьСтавкуНДС(Объект.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры

#Область Информация_о_товаре


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


#КонецОбласти


&НаКлиенте
Процедура ИзменитьРеквизитыДокумента(Команда)
	
	ФункцииФормДокументов.ИзменитьРеквизиты(ЭтаФорма);

КонецПроцедуры
&НаКлиенте
Процедура ОбработатьИзмененияРеквизитов(ЗакрытьФорму, Параметры) Экспорт
	
	Если ЗакрытьФорму = Истина Тогда Закрыть() КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияПриИзменении(Элемент)
	
	УстановитьВидимостьПооперации();
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

#Область Партия_Таможни

&НаСервере
Процедура ЗаполнитьПартииНаСервере()
	
	// Расспределим по методу фифо
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ 	Номенклатура, Партия ПартияТаможни, Упаковка, КоличествоОстаток Количество, СуммаОстаток / КоличествоОстаток Цена,
	|   		СуммаОстаток * (ЕСТЬNULL(ВалЦен.Курс, 1) * ЕСТЬNULL(ВалУпр.Кратность, 1)) / (ЕСТЬNULL(ВалУпр.Курс, 1) * ЕСТЬNULL(ВалЦен.Кратность, 1)) Сумма
	|ИЗ 	РегистрНакопления.ТоварыНаТаможне.Остатки(&Дата, Склад = &Склад И Номенклатура В(&Номенклатура)) Рег
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ 	РегистрСведений.КурсыВалют.СрезПоследних(, ) ВалЦен
	|ПО 				Рег.Валюта = ВалЦен.Валюта
	|ЛЕВОЕ СОЕДИНЕНИЕ 	РегистрСведений.КурсыВалют.СрезПоследних(, Валюта В (ВЫБРАТЬ Значение ИЗ Константа.ВалютаУправленческогоУчета)) ВалУпр ПО ИСТИНА
	|
	|ГДЕ	КоличествоОстаток > 0
	|УПОРЯДОЧИТЬ ПО Партия.Дата
	|");
	
	Запрос.УстановитьПараметр("Дата", 			Объект.Дата);
	Запрос.УстановитьПараметр("Склад", 			Объект.СкладОтправитель);
	Запрос.УстановитьПараметр("Номенклатура", 	Объект.Товары.Выгрузить(,"Номенклатура").ВыгрузитьКолонку("Номенклатура"));
	Остатки = Запрос.Выполнить().Выгрузить();
	
	ТаблТоваров = Объект.Товары.Выгрузить();
	Объект.Товары.Очистить();
	
	Для Каждого Строка ИЗ ТаблТоваров Цикл
		
		Нужно 		= Строка.Количество;
		НовСтрока 	= Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
		
		// Спишем уже выбранную партию
		
		Если ЗначениеЗаполнено(Строка.ПартияТаможни) Тогда 
			
			СтрокиПартий 	= Остатки.НайтиСтроки(Новый Структура("Номенклатура, ПартияТаможни, Упаковка", Строка.Номенклатура, Строка.ПартияТаможни, Строка.Упаковка));
			Списываем 		= 0;
			
			Для Каждого СтрокаПартии Из СтрокиПартий Цикл
				Если Нужно Тогда
					
					текСписываем 	= Мин(СтрокаПартии.Количество, Нужно);
					СтрокаПартии.Количество = СтрокаПартии.Количество - текСписываем;
					Нужно 			= Нужно - текСписываем; 
					Списываем 		= Списываем + текСписываем; КонецЕсли; КонецЦикла;
			
			НеХватилоПартии 	= НовСтрока.Количество - Списываем;
			НовСтрока.Количество= ?(Списываем, Списываем, НеХватилоПартии);
			
			// Если указанной партии не хватило, значит строку нужно разбивать
			
			Если НеХватилоПартии И Не Списываем Тогда
				НовСтрока.ПартияТаможни = Неопределено; 
				НовСтрока.ЦенаПартии	= 0;КонецЕсли;
				
			Если НеХватилоПартии И Списываем Тогда
				НовСтрока = Объект.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
				НовСтрока.ПартияТаможни	= Неопределено;
				НовСтрока.ЦенаПартии	= 0;
				НовСтрока.Количество 	= НеХватилоПартии; КонецЕсли; КонецЕсли;
		
		// Найдем партию для списания в остатах
		
		Если Нужно Тогда
			
			СтрокиОстатка 	= Остатки.НайтиСтроки(Новый Структура("Номенклатура", Строка.Номенклатура));
			Списываем		= 0;
		
			Для Каждого СтрокаОстатка Из СтрокиОстатка Цикл
				
				текСписываем = Мин(СтрокаОстатка.Количество, Нужно);
				Если текСписываем Тогда СтрокаОстатка.Количество = СтрокаОстатка.Количество - текСписываем;
				
					Нужно 		= Нужно - текСписываем; 
					Списываем 	= Списываем + текСписываем;
					
					НовСтрока.Количество  	= текСписываем;
					НовСтрока.ЦенаПартии 	= СтрокаОстатка.Цена;
					НовСтрока.ПартияТаможни = СтрокаОстатка.ПартияТаможни;
					
					Если Нужно И текСписываем Тогда // Добавляем что не списали
						
						НовСтрока = Объект.Товары.Добавить();
						ЗаполнитьЗначенияСвойств(НовСтрока, Строка); 
						НовСтрока.Количество = НовСтрока.Количество - Списываем; КонецЕсли; КонецЕсли; КонецЦикла; КонецЕсли; КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Процедура ЗаполнитьПартии(Команда)
	
	ЗаполнитьПартииНаСервере();
	
КонецПроцедуры
&НаКлиенте
Процедура ОчиститьПартии(Команда)
	
	Для Каждого Строка Из Объект.Товары Цикл Строка.ПартияТаможни = Неопределено КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Выбор_партий

&НаСервере
Функция ПолучитьСписокПартийНаСервере(Номенклатура)
	
	Возврат МодульПартий.ПолучитьСписокПартийДляВыбора(Номенклатура, Объект.СкладОтправитель, ?(Объект.Дата = '00010101' Или НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата));
	
КонецФункции
&НаКлиенте
Процедура ТоварыПартияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка 	= Ложь;
	ТекДанные 				= Элементы.Товары.ТекущиеДанные;
	
	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ВыборПартииТовары", ЭтаФорма, Элементы.Товары.ТекущаяСтрока), ПолучитьСписокПартийНаСервере(ТекДанные.Номенклатура), Элементы.ТоварыПартия);
	
КонецПроцедуры
&НаКлиенте
Процедура ВыборПартииТовары(ВыбранныйЭлемент, ИдентификаторСтрокиТоваров) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда Структура = ВыбранныйЭлемент.Значение;
		
		Строка = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтрокиТоваров);
		Строка.Партия 		= Структура.Партия;
		Строка.СуммаПартии 	= ?(Строка.Количество = Структура.Количество, Структура.Сумма, ?(Структура.Количество = 0, 0, Структура.Сумма / Структура.Количество * Строка.Количество)); КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьПартииНаСервере(СтруктураКолонокТовары)
	
	// Очистим партию
	
	ТовТмп = Объект.Товары.Выгрузить();
	ТовТмп.ЗаполнитьЗначения(Неопределено, "Партия");
	Объект.Товары.Загрузить(ТовТмп);
	
	// Проставим
	
	МодульПартий.РазнестиПартииВТаблицеМетодомFIFO(Объект.Товары, Объект.СкладОтправитель, СтруктураКолонокТовары, Объект.Дата);
	
КонецПроцедуры
&НаКлиенте
Процедура ПерезаполнитьПартии(Команда)
	
	ПерезаполнитьПартииНаСервере(СтруктураКолонокТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Объект.СуммаВключаетНДС, Объект.ТипЦен, , , Объект.Валюта, Объект.УчитыватьНДС, Объект.Валюта, Объект.СуммаВключаетНДС,,Объект.УчитыватьНДС,,Объект.Контрагент);
	
	Объект.Грузополучатель = ФункцииФормДокументовСервер.ГрузополучательПриИзмененииРеквизита(Объект.Контрагент);
	Объект.БанковскийСчетГрузополучателя = ФункцииФормДокументовСервер.БанковскийСчетПриИзмененииРеквизита(Объект.Грузополучатель);
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	Объект.БанковскийСчетГрузополучателя = ФункцииФормДокументовСервер.БанковскийСчетПриИзмененииРеквизита(Объект.Грузополучатель);
КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительПриИзменении(Элемент)
	Объект.БанковскийСчетГрузоотправителя = ФункцииФормДокументовСервер.БанковскийСчетПриИзмененииРеквизита(Объект.Грузоотправитель);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Объект.Грузоотправитель = ФункцииФормДокументовСервер.ГрузополучательПриИзмененииРеквизита(Объект.Организация);
	Объект.БанковскийСчетГрузоотправителя = ФункцииФормДокументовСервер.БанковскийСчетПриИзмененииРеквизита(Объект.Грузоотправитель);
КонецПроцедуры



#КонецОбласти
