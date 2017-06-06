﻿
&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;

&НаКлиенте
Процедура ОбщиеРеквизиты(Команда)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизиты(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	Элементы.ЯчейкаОтправитель.Видимость 	= Объект.СкладОтправитель.Ячеестый;
	Элементы.ЯчейкаПолучатель.Видимость 	= Объект.СкладПолучатель.Ячеестый;
	
	Элементы.ТоварыЗаполнитьЯчейки.Видимость 			= Не Объект.Проведен И Объект.СкладОтправитель.Ячеестый;
	Элементы.ТоварыЗаполнитьЯчейкиПолучателя.Видимость 	= Не Объект.Проведен И Объект.СкладПолучатель.Ячеестый;
	Элементы.ТоварыЗаполнитьОднойЯчейкойОтправителя.Видимость = Не Объект.Проведен И Объект.СкладОтправитель.Ячеестый;
	Элементы.ТоварыИнвертироватьЯчейки.Видимость		= Объект.СкладОтправитель.Ячеестый И Объект.СкладПолучатель.Ячеестый;
	
	Элементы.Кнопка.Видимость = Не Объект.Проведен;
	
	Элементы.ТоварыЗаполнитьВыбранныеЯчейкиОтправителя.Видимость 	= Не Объект.Проведен И Объект.СкладОтправитель.Ячеестый;
	Элементы.ТоварыЗаполнитьВыбранныеЯчейкиПолучателя.Видимость 	= Не Объект.Проведен И Объект.СкладПолучатель.Ячеестый;
	
КонецПроцедуры

&НаКлиенте
Процедура СкладОтправительПриИзменении(Элемент)
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры
&НаКлиенте
Процедура СкладПолучательПриИзменении(Элемент)
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры


#Область Пердопределенные_процедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПроведенияДокументов.РазрешеноПерепроводитьДокумент(Объект.Ссылка) Тогда
		Сообщить("Данный заказ закрыт. Редактирование документа запрещено.");
		ТолькоПросмотр = Истина;
	КонецЕсли;	
	
	// Проверм откудо он
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Если Не Параметры.СкладОтправитель.Пустая() Тогда	Объект.СкладОтправитель = Параметры.СкладОтправитель; КонецЕсли;
		Если Не Параметры.СкладПолучатель.Пустая() Тогда 	Объект.СкладПолучатель 	= Параметры.СкладПолучатель; КонецЕсли;
		Если ЗначениеЗаполнено(Параметры.Процесс) Тогда 	Объект.Процесс 			= Параметры.Процесс; КонецЕсли;
		
		Если Не ПустаяСтрока(Параметры.ТоварыСтрокой) Тогда
			КонвертацияТипов.ДобавитьТаблицуКДругойТаблице(Объект.Товары, ЗначениеИзСтрокиВнутр(Параметры.ТоварыСтрокой)); КонецЕсли;
	Иначе
		Если ТипЗнч(Объект.Основание) = Тип("БизнесПроцессСсылка.ПеремещениеТоваров") Тогда
			Попытка Заказ = Объект.Основание.Заказчик.Заказ; Исключение КонецПопытки; КонецЕсли; КонецЕсли;
	
	УправлениеВидимостьюДоступностью();
	
	// информация о товаре
	
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
КонецПроцедуры

Функция ПолучитьСтуктуруКолнокТовары()
	Возврат ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары,,,"Товары");	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Если это по старому тогда откроем форму по старому
	//Если Не Объект.СпособРазмещенияБезЗаказа Тогда
	//	Отказ = Истина;
	//	ОткрытьФорму("Документ.ПеремещениеТоваров.Форма.ФормаДокумента_СЗаказом",  Новый Структура("Ключ", Параметры.Ключ), ВладелецФормы, Окно,, ОписаниеОповещенияОЗакрытии);
	//	Возврат; КонецЕсли;
	
	// Получим структуру колонок
	
	СтруктураКолонокТовары = ПолучитьСтуктуруКолнокТовары();	
	
	// Автосохранение
	
	Если Не ТолькоПросмотр Тогда 
		Если АвтосохранениеКлиент.ИницилизироватьСохранение(ЭтаФорма) Тогда
			
			ДанныеДляПодбора = "";
			ЗагрузитьДанныеАвтосохранения(ДанныеДляПодбора); 
			Модифицированность = Истина; 
			
			Если Не ПустаяСтрока(ДанныеДляПодбора) Тогда ПодборВыполнить(,Новый Структура("МассивТоваровСтрокой", ДанныеДляПодбора)) КонецЕсли; КонецЕсли; КонецЕсли;

	
КонецПроцедуры
&НаКлиенте
Процедура ПриЗакрытии()
	
	// Автосохранение
	АвтосохранениеСервер.УдалитьАвтоСохранение(ИмяФормы, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Автосохранение
	Если Не Отказ И Объект.Ссылка.Пустая() Тогда АвтосохранениеСервер.УдалитьАвтоСохранение(ИмяФормы, Объект.Ссылка) КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОЗаписиНового(Объект.Ссылка);
	
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


#Область Подбор

&НаСервере
Функция ПоместитьТоварыВХранилище() 
	
	Возврат ПоместитьВоВременноеХранилище(
					Объект.Товары.Выгрузить(), 
					УникальныйИдентификатор);
КонецФункции
&НаКлиенте
Процедура ПодборВыполнить(Кнопка = Неопределено, ДополнительныеПараметрыПодбора = Неопределено)
	
	ИмяТабличнойЧасти = "Товары";
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	ПараметрыПодбора = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	
	ПараметрыПодбора.Вставить("СтруктураКолонокТовары", СтруктураКолонокТовары);
	//ПараметрыПодбора.Вставить("ВидЗапроса", 			"ОстаткиНоменклатуры");
	//ПараметрыПодбора.Вставить("ВидыЗапросов", 			"СписокНоменклатуры, ОстаткиНоменклатуры");
	ПараметрыПодбора.Вставить("Склад", 					Объект.СкладОтправитель);
	
	// Автосохранение
	АвтосохранениеКлиент.ОткрываетсяПодбор(ПараметрыПодбора, Объект.Ссылка, ЭтаФорма, ПолучитьДамп());
	Если ДополнительныеПараметрыПодбора <> Неопределено Тогда
		КонвертацияТипов.ДобавитьВСтруктуруСтруктуру(ПараметрыПодбора, ДополнительныеПараметрыПодбора) КонецЕсли;
	
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

#Область Ячейки

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
Процедура ЗаполнитьСкладыИзШапки()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ДокументОбъект.ЗаполнитьСкладИзШапки("СкладОтправитель");
	ДокументОбъект.ЗаполнитьСкладИзШапки("СкладПолучатель");
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
		
КонецПроцедуры
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	//ЗаполнитьСкладыИзШапки();
	
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

//&НаСервере
//Процедура ПерезаполнитьПартииНаСервере(СтруктураКолонокТовары)
//	
//	//старая методика, сейчас не используется
//	
//	//// Очистим партию
//	//
//	//ТовТмп = Объект.Товары.Выгрузить();
//	//ТовТмп.ЗаполнитьЗначения(Неопределено, "Партия");
//	//Объект.Товары.Загрузить(ТовТмп);
//	//
//	//// Проставим
//	//
//	//МодульПартий.РазнестиПартииВТаблицеМетодомFIFO(Объект.Товары, Объект.СкладОтправитель, СтруктураКолонокТовары, Объект.Дата);
//	
//КонецПроцедуры
//&НаКлиенте
//Процедура ПерезаполнитьПартии(Команда)
//	
//	//ПерезаполнитьПартииНаСервере(СтруктураКолонокТовары);
//	
//КонецПроцедуры

&НаКлиенте
Процедура ИнвертироватьЯчейки(Команда)
	
	Для Каждого Строка Из Объект.Товары Цикл
		
		стЯчейка = Строка.ЯчейкаОтправитель;
		Строка.ЯчейкаОтправитель 	= Строка.ЯчейкаПолучатель;
		Строка.ЯчейкаПолучатель 	= стЯчейка;
		
	КонецЦикла;
	
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

#Область Информация // о товаре

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

Процедура ОкончанияВыбораЯчейки(Результат, Параметры)
	Если Результат <> Неопределено Тогда
		Строки = Элементы.Товары.ВыделенныеСтроки;
		Для Каждого Ид Из Строки Цикл
			Строка = Объект.Товары.НайтиПоИдентификатору(Ид);
			Строка[Параметры.ИмяКолонки] = Результат;
		КонецЦикла
	КонецЕсли;
	КонецПроцедуры	

&НаКлиенте
Процедура ЗаполнитьВыбранныеЯчейкиОтправителя(Команда)
	
	ВыбрЯчейка = ОткрытьФорму("Справочник.Ячейки.ФормаВыбора", Новый Структура("Склад", Объект.СкладОтправитель),,,,,Новый ОписаниеОповещения("ОкончанияВыбораЯчейки",ЭтаФорма, Новый Структура("ИмяКолонки", "ЯчейкаОтправитель")));

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВыбранныеЯчейкиПолучателя(Команда)
	
	ВыбрЯчейка = ОткрытьФорму("Справочник.Ячейки.ФормаВыбора", Новый Структура("Склад", Объект.СкладПолучатель),,,,,Новый ОписаниеОповещения("ОкончанияВыбораЯчейки",ЭтаФорма, Новый Структура("ИмяКолонки", "ЯчейкаПолучатель")));

КонецПроцедуры

#КонецОбласти





