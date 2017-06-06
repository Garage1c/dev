﻿&НаКлиенте
Процедура ПересчитатьКоэфициенты()
	
	C = 100 - B - A;
	
КонецПроцедуры

&НаКлиенте
Процедура AПриИзменении(Элемент)
	ПересчитатьКоэфициенты()
КонецПроцедуры

&НаКлиенте
Процедура BПриИзменении(Элемент)
	ПересчитатьКоэфициенты()
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	A = 80;
	B = 15;
	C = 5;
	//Схема =  РеквизитФормыВЗначение("Отчет").ПолучитьМакет("СхемаПодбора");
	//НастройкиСхемы = Схема.НастройкиПоУмолчанию;
	//КомпановщикПодбора.ЗагрузитьНастройки(НастройкиСхемы);
	
	
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Отчет");
	Схема = ВнешняяОбработкаОбъект.ПолучитьМакет("СхемаПодбора");
	
	ИсточникДоступныхНастроекКомпоновкиДанных = Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(Схема,УникальныйИдентификатор));
	КомпановщикПодбора.Инициализировать(ИсточникДоступныхНастроекКомпоновкиДанных);
	КомпановщикПодбора.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеВидимостью()
	
	Элементы.ПараметрыПарето.Видимость =  СпособРасчетаABC = ПредопределенноеЗначение("Перечисление.СпособРасчетаABC.ПоПарето");
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаблокироватьРезультат()
	
	Элементы.Результат.ОтображениеСостояния.Видимость = Истина;
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеВидимостью()
КонецПроцедуры

&НаКлиенте
Процедура РасчтитатьЗановоПриИзменении(Элемент)
	УправлениеВидимостью()
КонецПроцедуры

&НаКлиенте
Процедура СпособРасчетаABCПриИзменении(Элемент)
	УправлениеВидимостью()
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчет()
    УстановитьПривилегированныйРежим(Истина);
	СтандартнаяОбработка = Ложь;
	Если Период.ДатаОкончания = Дата(1,1,1) Тогда
		ДатаОкончания = ТекущаяДата();
	Иначе
		ДатаОкончания = Период.ДатаОкончания;
	КонецЕсли;
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	
	Таблица = ПолучитьПредварительнуюТаблицу();
	
	ABCXYZАнализ.ОпределитьКатегорииABC(Таблица,Перечисления.КлассификацияАнализа.КоличествоПродаж, СпособРасчетаABC, A, B);
	ABCXYZАнализ.ОпределитьКатегорииABC(Таблица,Перечисления.КлассификацияАнализа.ОстаткиСебестоимость, СпособРасчетаABC, A, B);
	ABCXYZАнализ.ОпределитьКатегорииABC(Таблица,Перечисления.КлассификацияАнализа.ОстаткиШт, СпособРасчетаABC, A, B);
	ABCXYZАнализ.ОпределитьКатегорииABC(Таблица,Перечисления.КлассификацияАнализа.Прибыль, СпособРасчетаABC, A, B);
	ABCXYZАнализ.ОпределитьКатегорииABC(Таблица,Перечисления.КлассификацияАнализа.ПродажиСебестоимость, СпособРасчетаABC, A, B);
	ABCXYZАнализ.ОпределитьКатегорииABC(Таблица,Перечисления.КлассификацияАнализа.ПродажиСумма, СпособРасчетаABC, A, B);
	ABCXYZАнализ.ОпределитьКатегорииABC(Таблица,Перечисления.КлассификацияАнализа.ПродажиШт, СпособРасчетаABC, A, B);
	
	
	Схема = ОтчетОбъект.ПолучитьМакет("СхемаВывода");

	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТаблицаНабораДанных", Таблица);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ДанныеРасшифровкиКомпоновкиДанныхВ = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	Параметр = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Параметр.Значение = Период;
	Параметр.Использование = Истина;
	Параметр = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СпособРасчета"));
	Параметр.Значение = СпособРасчетаABC;
	Параметр.Использование = Истина;

	Параметр = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Склады"));
	Параметр.Значение = Склады;
	Параметр.Использование = Истина;


	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Отчет.КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровкиКомпоновкиДанныхВ);	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровкиКомпоновкиДанныхВ);
	
	Результат.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
 	ДанныеРасшифровки = ПоместитьВоВременноеХранилище(ДанныеРасшифровкиКомпоновкиДанныхВ, ЭтаФорма.УникальныйИдентификатор);

КонецПроцедуры

&НаСервере
Функция ПолучитьПредварительнуюТаблицу()
	
	ЗаполнитьПарамерты();

	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	
	Схема = ОтчетОбъект.ПолучитьМакет("СхемаПодбора");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаЗначений = Новый ТаблицаЗначений;
		
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(Схема, КомпановщикПодбора.ПолучитьНастройки(), , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	ПроцессорВывода.УстановитьОбъект(ТаблицаЗначений);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат ТаблицаЗначений;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПарамерты()
	
	Настройки = КомпановщикПодбора.Настройки;
	
	Параметр = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПериодРасчета"));
	Параметр.Значение = Период;
	Параметр.Использование = Истина;
	
	Параметр = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТипЦен"));
	Параметр.Значение = Справочники.ТипыЦен.НайтиПоНаименованию("Себестоимость");
	Параметр.Использование = Истина;

	Параметр = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТипЦен1"));
	Параметр.Значение = Справочники.ТипыЦен.НайтиПоНаименованию("Закупочная руб");
	Параметр.Использование = Истина;
	
	Параметр = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Склады"));
	
	Параметр.Значение = Склады;
	
	Если Склады.Количество() Тогда
		Параметр.Использование = Истина;
	Иначе
		Параметр.Использование = Ложь;
	КонецЕсли;


КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьОтчет();
	Элементы.Результат.ОтображениеСостояния.Видимость = Ложь;
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поле =  ПолучитьЗначение(Расшифровка);
	
	Если Поле <> Null Тогда
		ОткрытьЗначение(Поле);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЗначение(Расшифровка)
    
    ДанныеРасш = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
    Возврат ДанныеРасш.Элементы[Расшифровка].ПолучитьПоля()[0].Значение;
    
КонецФункции

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
КонецПроцедуры

&НаКлиенте
Процедура КлассификацииПриИзменении(Элемент)
	ЗаблокироватьРезультат();
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	ЗаблокироватьРезультат();
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	ЗаблокироватьРезультат();
КонецПроцедуры

&НаКлиенте
Процедура КомпановщикПодбораНастройкиОтборПриИзменении(Элемент)
	ЗаблокироватьРезультат();
КонецПроцедуры
