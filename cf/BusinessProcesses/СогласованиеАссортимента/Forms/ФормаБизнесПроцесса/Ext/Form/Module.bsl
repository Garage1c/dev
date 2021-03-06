﻿&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;

&НаСервере
Процедура ЗаполнитьПоЗаявкамНаСервере()
	
	//Запрос = Новый Запрос("ВЫБРАТЬ Номенклатура, КОЛИЧЕСТВО(Пользователь) КоличествоЗаявок ИЗ РегистрСведений.ЗапросНаСогласованиеТовара.СрезПоследних() ГДЕ Письмо = ЗНАЧЕНИЕ(Документ.Письмо.ПустаяСсылка) СГРУППИРОВАТЬ ПО Номенклатура");
	//Объект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());	
	
	Запрос = Новый Запрос("ВЫБРАТЬ Номенклатура, Контрагент, &Дата ДатаНачала ПОМЕСТИТЬ Заявки ИЗ РегистрСведений.ЗапросНаСогласованиеТовара.СрезПоследних(, " + ?(Контрагенты.Количество(), "Контрагент В (&Контрагенты)", "") +") ГДЕ Статус = 1 СГРУППИРОВАТЬ ПО Номенклатура, Контрагент;
	|ВЫБРАТЬ Различные Контрагент ИЗ Заявки ГДЕ Контрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка);
	|ВЫБРАТЬ Различные Номенклатура ИЗ Заявки");
	Запрос.УстановитьПараметр("Контрагенты", Контрагенты);
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	
	Рез = Запрос.ВыполнитьПакет();
	Объект.Товары.Загрузить(Рез[2].Выгрузить());
	
	Если НЕ Контрагенты.Количество() Тогда
	Контрагенты.ЗагрузитьЗначения(Рез[1].Выгрузить().ВыгрузитьКолонку("Контрагент"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоЗаявкам(Команда)
	ЗаполнитьПоЗаявкамНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеВидимостью();
	Контрагенты.ЗагрузитьЗначения(Объект.Контрагенты.Выгрузить().ВыгрузитьКолонку("Контрагент"));
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	Если Объект.Ссылка.Пустая() Тогда
		Валюта = ОбщиеФункции.НастройкаПользователя("ПоУмолчанию_Валюта", ПараметрыСеанса.ТекущийПользователь);
		ТипЦен = ОбщиеФункции.НастройкаПользователя("ПоУмолчанию_ТипЦен", ПараметрыСеанса.ТекущийПользователь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура УправлениеВидимостью()
	
	Если Объект.Завершен Тогда 
		ТолькоПросмотр = Истина; КонецЕсли;
	
	НаСогласовании = НЕ Объект.Завершен И ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(Объект.Ссылка, БизнесПроцессы.СогласованиеАссортимента.ТочкиМаршрута.ПодтвердитьСогласование, "СогласованиеАссортимента");
	
	ВРаботе = НЕ Объект.Завершен И ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(Объект.Ссылка, БизнесПроцессы.СогласованиеАссортимента.ТочкиМаршрута.ОформитьЗаявкуНаСогласование, "СогласованиеАссортимента");
	
	Элементы.Согласовано.Видимость = НаСогласовании;
	Элементы.ТоварыСогласовано.Видимость = НаСогласовании;
	
	Элементы.ТоварыОтметка.Видимость =  ВРаботе ИЛИ НЕ Объект.Стартован;
	
	Элементы.ОтправитьНаСогласование.Видимость = НЕ НаСогласовании;
	Элементы.Записать.Доступность = НЕ Объект.Завершен;
	Элементы.Отменить.Доступность = НЕ Объект.Завершен;
	
	Элементы.ТоварыЗаполнитьПоЗаявкам.Доступность = НЕ НаСогласовании;
	Элементы.ТоварыЗаполнитьДатуНачала.Доступность = НЕ Объект.Завершен;
	
	Элементы.ТоварыНоменклатура.ТолькоПросмотр = НаСогласовании;
	
	Элементы.СписокЗаявителей.Видимость = Ложь;
	
	Элементы.ТоварыУдалитьИзсогласованияСУведомлением.Видимость = ВРаботе ИЛИ НЕ Объект.Стартован;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьНаСервере()
	Объект.Завершен = Истина;
	Записать();
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	ОтменитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтправитьНаСогласованиеНаСервере()
	текЗадача = ФункцииБизнесПроцессов.ТекущаяЗадача(Объект.Ссылка, БизнесПроцессы.СогласованиеАссортимента.ТочкиМаршрута.ОформитьЗаявкуНаСогласование);
	Если текЗадача <> Неопределено Тогда задОбъект = текЗадача.ПолучитьОбъект();
	задОбъект.ВыполнитьЗадачу();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНаСогласование(Команда)
	Записать();
	ОтправитьПисьмо();	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПисьмо()
	
	ТабДок = Новый ТабличныйДокумент;
	Печать(ТабДок, Объект.Ссылка);

	ФункцииФормДокументов.УстановитьНастройкиТабличногоДокумента(ТабДок);
//	
//	ТабДок.ДвусторонняяПечать = ТипДвустороннейПечати.ПереворотВлево;

	СтрНомера = "";
	ДополнительныеПараметры = ПолучитьПараметрыДляТабличногоДокумента();
	ОткрытьФорму("ОбщаяФорма.ТабличныйДокумент", Новый Структура("ТабличныйДокумент, ИмяФайла, ДополнительныеПараметры", ТабДок, Объект.Номер, ДополнительныеПараметры), ЭтаФорма);
	
КонецПроцедуры


&НаСервере
Функция Печать(ТабДок, Ссылка)
	
	БизнесПроцессы.СогласованиеАссортимента.Печать(ТабДок, Ссылка);
	
КонецФункции
//&НаСервере
//Функция Печать(ТабДок)
//		
//	Макет = БизнесПроцессы.СогласованиеАссортимента.ПолучитьМакет("СогласованиеАссортимента");
//	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
//	ОБластьШапка.Параметры.Заголовок = ФормированиеПечатныхФорм.СформироватьЗаголовокДокумента(Новый Структура("Номер, Дата", Объект.Номер, Объект.Дата), "Согласование ассортимента");
//	ОбластьШапка.Параметры.Заказчик = Строка(Контрагенты);
//	ТабДок.Вывести(ОбластьШапка);
//	
//	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
//	ТабДок.Вывести(ОбластьШапкаТаблицы);
//	ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
//	ном = 0;
//	Для Каждого Строка ИЗ Объект.Товары Цикл ном = ном + 1;
//		ОбластьСтрокаТаблицы.Параметры.Номер			= ном; 
//		ОбластьСтрокаТаблицы.Параметры.Наименование 	= Строка.Номенклатура;
//		ОбластьСтрокаТаблицы.Параметры.Артикул 			= Строка.Номенклатура.Артикул;
//		ОбластьСтрокаТаблицы.Параметры.Производитель 	= Строка.Номенклатура.Производитель;
//		ОбластьСтрокаТаблицы.Параметры.ЕдИзм			= Строка.Номенклатура.ЕдиницаИзмерения;
//		ОбластьСтрокаТаблицы.Параметры.Цена 			= Строка.ЦенаСогласования;

//	//	ЗаполнитьЗначенияСвойств(ОбластьСтрокаТаблицы, Строка);
//		ТабДок.Вывести(ОбластьСтрокаТаблицы);
//	КонецЦикла;
//	
//КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыДляТабличногоДокумента()
	
	//Ссылки 		- массив внутри ссылки на заказы или БП заказов
	//СтрНомера 	- в нее будет свормированы номера всех заказов которые были обработаны
	
	Массив = Новый Массив;

	Структура = Новый Структура("Контрагент", Объект.Контрагенты[0].Контрагент); 
		
	Структура.Вставить("Почта", ""); 
	
	Массив.Добавить(Структура); 

	Возврат Массив;
	
КонецФункции

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Контрагенты.Очистить();

	Для каждого Строка Из Контрагенты цикл
		новСтрока = ТекущийОбъект.Контрагенты.Добавить();
		новСтрока.Контрагент = Строка.Значение;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = СобытияСистемы.Событие_ПисьмоОтправлено() И Источник = ЭтаФорма Тогда
		Объект.Письмо = Параметр.Ссылка; 

		Записать();
		ОтправитьНаСогласованиеНаСервере();
		
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьСогласованиеАссортимента()
	
	НачатьТранзакцию();
	
	новДок = Документы.СогласованиеАссортимента.СоздатьДокумент();
	новДок.Дата = ТекущаяДата();
	Для Каждого Строка ИЗ Объект.Товары Цикл
		Если Строка.Согласовано Тогда
			новСтрока = новДок.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(новСтрока, Строка);
		КонецЕсли;
	КонецЦикла;
	//новДок.Товары.Загрузить(Объект.Товары.Выгрузить());

	Для каждого Строка Из Контрагенты цикл
		новСтрока = новДок.Контрагенты.Добавить();
		новСтрока.Контрагент = Строка.Значение;
	КонецЦикла;
	
//	новДок.Контрагенты.Загрузить(Объект.Контрагенты.Выгрузить());
//	новДок.ОбменДанными.Загрузка = Истина;
	Попытка
		новДок.Записать(РежимЗаписиДокумента.Проведение);
		Объект.ДокументСогласование = новДок.Ссылка;
	Исключение
		Сообщить(ОписаниеОшибки());
		ОтменитьТранзакцию();
		Возврат Ложь;
	КонецПопытки;
	
	// Установка цен
	
	новДок = Документы.УстановкаЦенНоменклатуры.СоздатьДокумент();
	новДок.Дата = ТекущаяДата();
	
	ТипыЦен = Новый Массив;
	Для Каждого Элемент Из Контрагенты Цикл
		Если ТипыЦен.Найти(Элемент.Значение.ТипЦен) = Неопределено Тогда ТипыЦен.Добавить(Элемент.Значение.ТипЦен); КонецЕсли; КонецЦикла;
	
	Для Каждого Строка ИЗ Объект.Товары Цикл
		Если Строка.Согласовано Тогда
			Для Каждого Элемент ИЗ ТипыЦен Цикл
				новСтрока = новДок.Товары.Добавить();
				новСтрока.Номенклатура = Строка.Номенклатура;
				новСтрока.ДатаНачала = Строка.ДатаНачала;
				новСтрока.Цена = Строка.ЦенаСогласования;
				новСтрока.Валюта = Объект.Валюта;
				новСтрока.ТипЦен = Элемент;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
//	новДок.ОбменДанными.Загрузка = Истина;
	Попытка
		новДок.Записать(РежимЗаписиДокумента.Проведение);
		Объект.УстановкаЦен = новДок.Ссылка;
	Исключение
		Сообщить(ОписаниеОшибки());
		ОтменитьТранзакцию();
		Возврат Ложь;
	КонецПопытки;	
	
	ЗафиксироватьТранзакцию();
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция ПроверитьДатыНачала()
	
	Для Каждого Строка Из Объект.Товары Цикл
		Если Строка.ДатаНачала = '00010101' Тогда
					
	 	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Одно или несколько полей ""ДатаНачала"" не заполнены.'"),
					Объект,
					"Объект.Товары[0].ДатаНачала");
		Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОтветаНаВопросОПроверкеОтметок(Результат, Параметры) Экспорт
	Если Результат <> Неопределено Тогда
		
		Если Результат = КодВозвратаДиалога.Да Тогда
			
			Если СоздатьСогласованиеАссортимента() Тогда
				Записать();
				ВыполнитьЗадачу();
				Если Вопрос("Закрыть форму заявки?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда Закрыть(); Иначе ОбновитьОтображениеДанных(); КонецЕсли;	
			КонецЕсли;
	
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ВыполнитьЗадачу()
	
	текЗадача = ФункцииБизнесПроцессов.ТекущаяЗадача(Объект.Ссылка, БизнесПроцессы.СогласованиеАссортимента.ТочкиМаршрута.ПодтвердитьСогласование);
	Если текЗадача <> Неопределено Тогда задОбъект = текЗадача.ПолучитьОбъект();
	задОбъект.ВыполнитьЗадачу();
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура Согласовано(Команда)
	
	Если ПроверитьДатыНачала() Тогда 
		
	Отметки = Объект.Товары.НайтиСтроки(Новый Структура("Согласовано", Ложь));
	Если Отметки.Количество() = Объект.Товары.Количество() Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбработкаОтветаНаВопросОПроверкеОтметок", ЭтаФорма), "В списке нет ни одной согласованной позиции. Продолжить?", РежимДиалогаВопрос.ДаНетОтмена); 
		
	Иначе
		
		Если СоздатьСогласованиеАссортимента() Тогда
			Записать();
			ВыполнитьЗадачу();
			Если Вопрос("Закрыть форму заявки?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда Закрыть(); Иначе ОбновитьОтображениеДанных(); КонецЕсли;	
		КонецЕсли;
			
		
	КонецЕсли;

	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДатуНачала(Команда)
	
	текДата = ТекущаяДата();
	
	ВвестиДату(текДата, "Дата начала", ЧастиДаты.Дата);
	Для Каждого Строка ИЗ Объект.Товары Цикл
		Строка.ДатаНачала = ТекДата;
	КонецЦикла;

КонецПроцедуры

// ИНФОРМАЦИЯ О ТОВАРЕ
#Область Информация // о товаре

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
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре();
	Если ПоказатьСписокЗаявителей И Элементы.Товары.ТекущиеДанные <> Неопределено Тогда
		СписокЗаявителей = СписокЗаявителейНТМЛ(Элементы.Товары.ТекущиеДанные.Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьСсылкаHTML(ID = Неопределено, Значение, Подсказка = "", Цвет = "#333333", href = "./0")
	
	Возврат "<a style=""color:" + Цвет + ";"" " + ?(ЗначениеЗаполнено(Подсказка), " title= """ + Подсказка + """", "") + " href='" + href + "'>" + Строка(Значение) + "</a>";
	
КонецФункции

&НаСервере
Функция СписокЗаявителейНТМЛ(Ссылка)
		
	Текст = "<html><head></head><body><table>";
	Запрос = Новый Запрос("ВЫБРАТЬ Пользователь, Пользователь.ФизЛицо Физлицо, Пользователь.ЭлектроннаяПочта Почта, Пользователь.ФизЛицо.Контрагент Контрагент, ЛимитыОбороты.СуммаПриход - ЛимитыОбороты.СуммаРасход ТекущийЛимит
	|ИЗ 
	|РегистрСведений.ЗапросНаСогласованиеТовара.СрезПоследних(," + ?(Контрагенты.Количество(), "Контрагент В (&Контрагенты) И ", "") + " Номенклатура = &Номенклатура) Запр
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.Лимиты.Обороты() КАК ЛимитыОбороты
	|ПО  Запр.Пользователь.ФизЛицо = ЛимитыОбороты.Инициатор");
	
	Запрос.УстановитьПараметр("Контрагент", Контрагенты.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("Номенклатура", Ссылка);
	
	Попытка
		Выборка = Запрос.Выполнить().Выбрать();
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат "";
	КонецПопытки;
	Пока Выборка.Следующий() Цикл
		
		КодПолученияТовара = "HTMLОбработкаСервер.ПолучитьОбъектПоГуидСтроке(""Справочники.ПользователиИнтернет"",""" + XMLСтрока(Выборка.Пользователь) + """)";
 		ТекстОткрытьТовар =  "V8:ВЫПОЛНИТЬ КОД:
			|ПоказатьЗначение(, " + КодПолученияТовара + ");";
		
		Текст = Текст + "<tr style=""font-family: Verdana,Geneva,sans-serif;border-bottom:1px solid #CCC085;padding:3px 5px;font-size:12px;""><td>" + СформироватьСсылкаHTML(,СокрЛП(Выборка.ФизЛицо), "Открыть карточку пользователя", , ТекстОткрытьТовар) + "</td><td>" + Выборка.Контрагент + "</td><td>" + Выборка.ТекущийЛимит + " руб.</td><td>" + "" + "</td></tr>"; 	
		
		
	КонецЦикла;
	Возврат Текст + "</table></body></html>";	
КонецФункции
#КонецОбласти

&НаКлиенте
Процедура ТипЦенПриИзменении(Элемент)
	
	Если ФункцииФормДокументов.ДиалогПриИзмененииТипаЦен(Объект.Товары.Количество(),СтруктураКолонокТовары, Объект.ТипЦен) Тогда
		 ТипЦенПриИзмененииНаСервере(СтруктураКолонокТовары);
	КонецЕсли;
	
	СтруктураКолонокТовары.стТипЦен = Объект.ТипЦен;

КонецПроцедуры
&НаСервере
Процедура ТипЦенПриИзмененииНаСервере(СтруктураКолонокТовары)
	
	СтруктураКолонокТовары.ТипЦен = Объект.ТипЦен;
	СтруктураКолонокТовары.Валюта = Объект.Валюта;
//	ФункцииФормДокументов.ПересчитатьСуммыТабличныхЧастей(Объект.Товары, СтруктураКолонокТовары);
	Для Каждого Строка Из Объект.Товары Цикл
		Акция = Неопределено;
		Цена = РаботаСНоменклатурой.ПолучитьЦену(	Строка.Номенклатура, 
														СтруктураКолонокТовары.ТипЦен,
														СтруктураКолонокТовары.Валюта,
														?(СтруктураКолонокТовары.ЕстьУпаковка, Строка.Упаковка, Неопределено), 
														СтруктураКолонокТовары.Контрагент, 
														СтруктураКолонокТовары.ЕстьАкция, 
														Акция,
														СтруктураКолонокТовары.ЕстьЦенаПоАкции,,,,,, 
														ложь);
														
		Строка.Цена = РаботаСНоменклатурой.ПолучитьЦенуСУчетомНДС(Цена, Строка.Номенклатура.СтавкаНДС, , Ложь, СтруктураКолонокТовары.ТипЦен.ЦенаВключаетНДС);												
		Строка.ЦенаСогласования = 	Строка.Цена - Строка.Цена  / 100 * Строка.ПроцентРучнойСкидки; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СтруктураКолонокТовары = ПолучитьСтуктуруКолнокТовары();

КонецПроцедуры

&НаСервере 
Функция ПолучитьСтуктуруКолнокТовары()
	Возврат ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Истина, Объект.ТипЦен, "Товары", , КэшируемыеФункции.ВалютаУправленческогоУчета(), Истина);	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьРучСкидку(Команда)
	
	ПроцентСкидки = 0;
	ВвестиЧисло(ПроцентСкидки, "Процент ручной скидки:", 5, 2);

	Для Каждого Строка Из Объект.Товары Цикл
		
		Строка.ПроцентРучнойСкидки = ПроцентСкидки;
		Строка.ЦенаСогласования = 	Строка.Цена - Строка.Цена  / 100 * ПроцентСкидки; 

	КонецЦикла;		

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПроцентРучнойСкидкиПриИзменении(Элемент)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ТекДанные.ЦенаСогласования = 	ТекДанные.Цена - ТекДанные.Цена  / 100 * ТекДанные.ПроцентРучнойСкидки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	Если ФункцииФормДокументов.ДиалогПриИзмененииВалюты(Объект.Товары.Количество(), СтруктураКолонокТовары, Объект.Валюта) Тогда
		ТипЦенПриИзмененииНаСервере(СтруктураКолонокТовары);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоЗаявокОткрытие(Элемент, СтандартнаяОбработка)
	
	//ТекДанные = Элементы.Товары.ТекущиеДанные;
	//Если ТекДанные <> Неопределено Тогда
	//	ОткрытьФорму("БизнесПроцесс.СогласованиеАссортимента.Форма.ФормаЗаявители", Новый Структура("Номенклатура, Контрагенты", ТекДанные.Номенклатура, Контрагенты), ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	//КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ТоварыКоличествоЗаявокОткрытиеНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗаявителей(Команда)
	ПоказатьСписокЗаявителей = НЕ ПоказатьСписокЗаявителей; 
	Элементы.СписокЗаявителей.Видимость = ПоказатьСписокЗаявителей;
КонецПроцедуры

&НаКлиенте
Процедура ПоставитьОтметки(Команда)
	Согласовано = ЭтоЭтапСогласования();
	Если Согласовано Тогда
		Для Каждого Строка ИЗ Объект.Товары Цикл
			Строка.Согласовано = Истина;
		КонецЦикла;
	Иначе
		Для Каждого Строка ИЗ Объект.Товары Цикл
			Строка.Отметка = Истина;
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ЭтоЭтапСогласования()
	Возврат ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(Объект.Ссылка, БизнесПроцессы.СогласованиеАссортимента.ТочкиМаршрута.ПодтвердитьСогласование, "СогласованиеАссортимента");
КонецФункции

&НаКлиенте
Процедура УбратьОтметки(Команда)
	Согласовано = ЭтоЭтапСогласования();
	Если Согласовано Тогда
		Для Каждого Строка ИЗ Объект.Товары Цикл
			Строка.Согласовано = Ложь;
		КонецЦикла;
	Иначе
		Для Каждого Строка ИЗ Объект.Товары Цикл
			Строка.Отметка = Ложь;
		КонецЦикла;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура СписокЗаявителейПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	HTMLОбработкаКлиент.ТекстHTMLПриНажатии(ДанныеСобытия, СтандартнаяОбработка, ЭтаФорма);		

КонецПроцедуры

&НаСервере
Процедура УдалитьИзсогласованияСУведомлениемНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзсогласованияСУведомлением(Команда)
	
	Перем ПричинаОтказа;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПричинаОтказаЗавершениеВыбора", ЭтаФорма);
	ПоказатьВводЗначения(ОповещениеОЗакрытии, ПричинаОтказа,"Причина отказа", Тип("СправочникСсылка.ПричиныОтказаСогласованияАссортимента"));
			
КонецПроцедуры
&НаСервере
Процедура ЗафиксироватьПричинуОтказа(ПричинаОтказа)
	
	Для Каждого Строка ИЗ Объект.Товары Цикл
		Если Строка.Отметка Тогда
			Строка.ПричинаОтказа = ПричинаОтказа;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
&НаСервере
Функция ПисьмоОбОтказеВСогласовании(ПричинаОтказа)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ Тов.Номенклатура КАК Номенклатура, Тов.Отметка КАК Отметка ПОМЕСТИТЬ Товары ИЗ &Номенклатура КАК Тов
	|;
	|
	|ВЫБРАТЬ Пользователь, Номенклатура, Номенклатура.Артикул Артикул, ID, Контрагент, Период, Оповещение, Письмо 
	|ИЗ РегистрСведений.ЗапросНаСогласованиеТовара
	|ГДЕ Номенклатура В (ВЫБРАТЬ Номенклатура ИЗ Товары ГДЕ Отметка) И Контрагент В (&Контрагенты) И (Статус = 1 ИЛИ Статус = 2) 
	|
	|ИТОГИ ПО Пользователь");
	
	Запрос.УстановитьПараметр("Номенклатура", Объект.Товары.Выгрузить());
	Запрос.УстановитьПараметр("Контрагенты", Контрагенты.ВыгрузитьЗначения());

	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаПолучатель = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	URLИнтернетМагазин = Константы.ПутьИнтернетМагазин.Получить();
	Менеджер = РегистрыСведений.ЗапросНаСогласованиеТовара;
	
	
	Пока ВыборкаПолучатель.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Получатель = ВыборкаПолучатель.Пользователь;
		
		Если ТипЗнч(Получатель) = Тип("СправочникСсылка.ПользователиИнтернет") Тогда
			
			Кому = Получатель.ЭлектроннаяПочта;
			ТекстПисьмаЗаголовок = "Уважаемый(ая) " + Получатель + "!" + "<BR>";	
		
		КонецЕсли;
		ТекстПисьмаТело = "";
	//	ВыборкаПричина = ВыборкаПолучатель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	//	Пока ВыборкаПричина.Следующий() Цикл
			
			//ВыборкаТовары = ВыборкаПричина.Выбрать(); 
			ВыборкаТовары = ВыборкаПолучатель.Выбрать();
			ТекстПисьмаТело = ТекстПисьмаТело + ?(ВыборкаТовары.Количество(), "<BR> Запрашиваемый Вами товар: <BR>" ,"")  +"<table>";
			
			Пока ВыборкаТовары.Следующий() Цикл Товар = ВыборкаТовары.Номенклатура;
				
				
				//////////////ЗАПИСЬ В РЕГИСТР//////////////
				Запись = Менеджер.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(Запись, ВыборкаТовары);
				Запись.ДокументСогласования = Неопределено;
				Запись.Статус = 4; 
				Попытка
					Запись.Записать();
				Исключение
					ЗаписьЖурналаРегистрации("Данные.Запись", УровеньЖурналаРегистрации.Ошибка, , , 
					ОписаниеОшибки());
					ОтменитьТранзакцию();
					Возврат Ложь;
				КонецПопытки;
				/////////////////////////////////////////////	
				
				ТекстПисьмаТело = ТекстПисьмаТело + "<tr><td>" + Товар.Артикул + "</td><td><A style=""COLOR: rgb(0,0,204)"" href='http://" + URLИнтернетМагазин + "/tovar/" + НРег(Товар.alies) + "'>"+ Товар +"</A></td></tr>";
						//Заголовок = "<a href='http://www.garagetools.ru/shop/" + Товар.alies + "' target=""_blank""><b>" + СокрЛП(Товар.Артикул) + "</b> " + Товар.Наименование + ":</a>";
	
			КонецЦикла;
			
			ТекстПисьмаТело = ТекстПисьмаТело + "</table><BR> к согласованию не принят, так как " + ПричинаОтказа.Описание + ""; 
	//	КонецЦикла;
		
	   	ТемаПисьма = "Заявка на согласование товара к согласованию не принята"; 

		ТекстПисьма = ТекстПисьмаЗаголовок + ТекстПисьмаТело + КэшируемыеФункции.ПолучитьПодвалПисьма();
		
		ПисьмоПользователю = ОбщиеФункции.ОповеститьПоПочте(Кому, ТемаПисьма, ТекстПисьма, Ложь, Перечисления.ТипыТекстовЭлектронныхПисем.HTML);
		
		Если ПисьмоПользователю = Неопределено Тогда
			ЗаписьЖурналаРегистрации("Данные.Запись", УровеньЖурналаРегистрации.Ошибка, , , 
				ОписаниеОшибки() + "
				|получатель = " + Получатель + "
				|товар = " + Товар);
			ОтменитьТранзакцию();
			Возврат Ложь; 
		КонецЕсли;
			
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;
	Возврат Истина;	
КонецФункции

Процедура УдалитьОтмеченныеСтроки()
	
	УдалитьСтроки = Объект.Товары.НайтиСтроки(Новый Структура("Отметка", Истина));
	
	Для Каждого Строка ИЗ УдалитьСтроки Цикл
		Объект.Товары.Удалить(Строка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПричинаОтказаЗавершениеВыбора(ПричинаОтказа, Параметры) Экспорт
	
	Если ПричинаОтказа <> Неопределено Тогда
		//ЗафиксироватьПричинуОтказа(ПричинаОтказа);
		
		Если ПисьмоОбОтказеВСогласовании(ПричинаОтказа) Тогда
			УдалитьОтмеченныеСтроки();
		КонецЕсли;
		
		Записать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если НЕ Объект.Стартован Тогда
		ПараметрыЗаписи.Вставить("Старт", Истина); КонецЕсли;
КонецПроцедуры



