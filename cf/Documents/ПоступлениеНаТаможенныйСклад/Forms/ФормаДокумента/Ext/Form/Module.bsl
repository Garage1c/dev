﻿&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;

&НаКлиенте
Процедура ОбщиеРеквизиты(Команда)
	
	 ФункцииФормДокументов.ОткрытьОбщиеРеквизиты(ЭтаФорма);
	 
	 УправлениеВидимостьюДоступностью();
	 
КонецПроцедуры
&НаСервере
Процедура ПересчитатьСуммыТабличныхЧастей(СтруктураКолонокТовары) Экспорт
	
	ФункцииФормДокументов.ПересчитатьСуммыТабличныхЧастей(Объект.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеВидимостьюДоступностью()
	
	ДостОтправителя = Элементы.ТоварыЯчейкаОтправитель.Видимость;
	ДостПолучателя 	= Элементы.ТоварыЯчейкаПолучатель.Видимость;
	
	Элементы.ТоварыЗаполнитьЯчейкиОтправителя.Доступность 			= ДостОтправителя;
	Элементы.ТоварыЗаполнитьВыбранныеЯчейкиОтправителя.Доступность 	= ДостОтправителя;
	
	Элементы.ТоварыЗаполнитьЯчейкиПолучателя.Доступность 			= ДостПолучателя;
	Элементы.ТоварыЗаполнитьВыбранныеЯчейкиПолучателя.Доступность 	= ДостПолучателя;
	
	Элементы.ТоварыИнвертироватьЯчейки.Доступность = ДостОтправителя И ДостПолучателя;
	
КонецПроцедуры

&НаСервере
Функция СкладЯчеестый(СкладСсылка)
	
	Возврат СкладСсылка.Ячеестый;
	
КонецФункции

// ПРЕДОПРЕДЕЛЕННЫЕ ПРОЦЕДУРЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	// Рассчитаем динамические колонки
	
	ФункцииФормДокументов.РассчитатьДинамическиеКолонки(
					Объект.Товары,
					ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Ложь,,,,Объект.Валюта,Ложь));
					
КонецПроцедуры
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Ложь,,,, Объект.Валюта, Ложь);
	
	// Видимость ячеек
	
	Элементы.ТоварыЯчейкаОтправитель.Видимость 	= СкладЯчеестый(Объект.СкладОтправитель);
	Элементы.ТоварыЯчейкаПолучатель.Видимость 	= СкладЯчеестый(Объект.СкладПолучатель);
	
	
	// Управление видимостью доступностью
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

#Область Подбор

&НаСервере
Функция ПоместитьТоварыВХранилище() 
	
	Возврат ПоместитьВоВременноеХранилище(
					Объект.Товары.Выгрузить(), 
					УникальныйИдентификатор);
КонецФункции
&НаКлиенте
Процедура ПодборВыполнить()
	
	ИмяТабличнойЧасти = "Товары";
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	ПараметрыПодбора = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	
	ПараметрыПодбора.Вставить("СтруктураКолонокТовары", СтруктураКолонокТовары);
	//ПараметрыПодбора.Вставить("ВидЗапроса", 			"СписокНоменклатуры");
	//ПараметрыПодбора.Вставить("ВидыЗапросов", 			"СписокНоменклатуры");
	ПараметрыПодбора.Вставить("Склад", 					Объект.СкладОтправитель);
	ПараметрыПодбора.Вставить("ТипЦен", 				КэшируемыеФункции.ПолучитьТипЦенРозница());
	ПараметрыПодбора.Вставить("Валюта", 				Объект.Валюта);
	ПараметрыПодбора.Вставить("ЗаполнитьУпаковкуПоставщика", Истина);

	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", ПараметрыПодбора, Элементы.Товары);
	
КонецПроцедуры
&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресТоваровВХранилище)
	
	Объект.Товары.Загрузить(ПолучитьИзВременногоХранилища(АдресТоваровВХранилище));
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение <> Неопределено Тогда		
		
		ПолучитьТоварыИзХранилища(ВыбранноеЗначение);		// получаем
		УдалитьИзВременногоХранилища(ВыбранноеЗначение); 	// заметаем следы
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

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

#Область Обработка_табличной_части

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент, КонкретнаяСтрока = Неопределено)

	ФункцииФормДокументов.НоменклатураПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары,
				КонкретнаяСтрока,,, Истина);
			
КонецПроцедуры
&НаКлиенте
Процедура КоличествоПриИзменении(Элемент, КонкретнаяСтрока = Неопределено)
	
	ФункцииФормДокументов.КоличествоПриИзменении(Элементы.Товары, СтруктураКолонокТовары, КонкретнаяСтрока);
	
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
	
	//ФункцииФормДокументов.СуммаНДСПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	
КонецПроцедуры

&НаСервере
Процедура РаздатьРезервНаСервере(СтруктураКолонокТовары)
	
	ТЗТоваров = Объект.Товары.Выгрузить();
	
	Заказы.ПроставитьЗаказыВПорядкеОчереди(ТЗТоваров, Объект.Резервы, Объект.СкладПолучатель, СтруктураКолонокТовары, ?(Объект.Ссылка.Проведен, Объект.Дата, Неопределено));
				
	//Объект.Резервы.Загрузить(ТЗТоваров);
	
КонецПроцедуры
&НаКлиенте
Процедура РаздатьРезерв(Команда)
	
	СтруктураКолонокРезервов = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Резервы, Объект.СуммаВключаетНДС, Объект.ТипЦен, "Резервы",, Объект.Валюта, Объект.УчитыватьНДС);

	РаздатьРезервНаСервере(СтруктураКолонокРезервов);
	
КонецПроцедуры

#КонецОбласти

#Область Сортировка_Артикула

&НаСервере
Процедура СортироватьАртикул(Направление)
	
	врТЗ = Объект.Товары.Выгрузить();
	врТЗ.Колонки.Добавить("Артикул", Новый ОписаниеТипов("Строка"));
	КонвертацияТипов.ВыполнитьВыражениеВКаждойСтрокеТаблицы(врТЗ, "Строка.Артикул = Строка.Номенклатура.Артикул");
	врТЗ.Сортировать("Артикул" + Направление);
	
	Объект.Товары.Загрузить(врТЗ);
	
КонецПроцедуры
&НаКлиенте
Процедура СортироватьАртикулПоВозрастанию(Команда)
	
	СортироватьАртикул(" Возр")
	
КонецПроцедуры
&НаКлиенте
Процедура СортироватьАртикулПоУбыванию(Команда)
	
	СортироватьАртикул(" Убыв")
	
КонецПроцедуры

#КонецОбласти
 
#Область При_изменении_реквизитов_шапки

&НаСервере
Функция ОрганизацияПриИзмененииНаСервере()
	Возврат ФункцииФормДокументов.ОрганизацияПриИзменении(Объект);
КонецФункции

&НаСервере
Функция ПартнерПриИзмененииНаСервере()
	Возврат ФункцииФормДокументов.ПартнерПриИзменении(Объект);
КонецФункции

&НаКлиенте
Процедура ОбновитьСтруктуруКолонокТовары()
	
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Объект.СуммаВключаетНДС, Объект.ТипЦен,,, Объект.Валюта, Объект.УчитыватьНДС);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	ОбновитьСтруктуруКолонокТовары();	
	ПересчитатьСуммыТабличныхЧастей(СтруктураКолонокТовары);
	
	ДолгПартнера = ДенежныеСредства.ПолучитьДолгПартнера(Объект.Партнер);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитаВлияющегоНаТабличнуюЧасть(СтруктураКолонокТовары)
	
	ФункцииФормДокументов.ПересчитатьСуммыТабличныхЧастей(Объект.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры    

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	ДолгПартнера = ДенежныеСредства.ПолучитьДолгПартнера(Объект.Партнер);
	ПартнерПриИзмененииНаСервере();
	
	СтруктураКолонокТовары.ТипЦен = Объект.ТипЦен;
	СтруктураКолонокТовары.УчитыватьНДС = Объект.УчитыватьНДС;
	
	ПриИзмененииРеквизитаВлияющегоНаТабличнуюЧасть(СтруктураКолонокТовары);
	
	СтруктураКолонокТовары.стТипЦен = СтруктураКолонокТовары.ТипЦен;
	СтруктураКолонокТовары.стУчитыватьНДС = СтруктураКолонокТовары.УчитыватьНДС;
	
КонецПроцедуры

#КонецОбласти

#Область Информация_о_товаре

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

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре();
	
КонецПроцедуры

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

&НаСервере
Функция ПолучитьПодобнуюЯчейку(Склад, Ячейка)
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.Ячейки ГДЕ Владелец = &Склад И Проход = """ + Ячейка.Проход + """ И Секция = """ + Ячейка.Секция + """ И Ярус = """ + Ячейка.Ярус + """ И Поддон = """ + Ячейка.Поддон + """");
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции
&НаСервере
Процедура ИнвертироватьЯчейкиНаСервере()
	
	Для Каждого Строка Из Объект.Товары Цикл
		
		стЯчейка = Строка.ЯчейкаОтправитель;
		Строка.ЯчейкаОтправитель 	= ПолучитьПодобнуюЯчейку(Объект.СкладОтправитель, 	Строка.ЯчейкаПолучатель);
		Строка.ЯчейкаПолучатель 	= ПолучитьПодобнуюЯчейку(Объект.СкладПолучатель, 	стЯчейка); КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Процедура ИнвертироватьЯчейки(Команда)
	
	ИнвертироватьЯчейкиНаСервере();
	
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

&НаСервере
Процедура ЗаполнитьОстаткамиПоИнвойсуНаСервере()
	
	//Запрос = Новый Запрос("ВЫБРАТЬ ");
	
	
	
КонецПроцедуры
&НаКлиенте
Процедура ЗаполнитьОстаткамиПоИнвойсу(Команда)
	
	ЗаполнитьОстаткамиПоИнвойсуНаСервере();
	
КонецПроцедуры

#Область Партии

&НаСервере
Процедура ЗаполнитьПартииНаСервере(СтруктураКолонокТовары)
	
	МодульПартий.РазнестиПартииВТаблицеМетодомFIFO(Объект.Товары, Объект.СкладОтправитель, СтруктураКолонокТовары, ?(Объект.Проведен, Объект.Дата, Неопределено));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПартии(Команда)
	
	ЗаполнитьПартииНаСервере(СтруктураКолонокТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИЗаполнитьПартии(Команда)
	
	Для Каждого Строка Из Объект.Товары Цикл Строка.Партия = Неопределено КонецЦикла;
	ЗаполнитьПартииНаСервере(СтруктураКолонокТовары);
	
КонецПроцедуры

#КонецОбласти