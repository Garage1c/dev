﻿#Область Информация_о_товаре

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре()	
	 	
КонецПроцедуры
&НаКлиенте
Процедура ОбновитьИнформациюПоТовару() Экспорт
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре();
	ОбновитьОтображениеДанных();
	 	
КонецПроцедуры
&НаСервере
Процедура ОбработатьОтображениеИнформацииОТоваре() Экспорт 
//Процедура ОбработатьОтображениеИнформацииОТоваре(РезультатЗакрытия = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт 
	РаботаСНоменклатурой.ОбработатьОтображениеИнформацииОТоваре(ЭтаФорма, "Новинки", "Новинки");
КонецПроцедуры

&НаКлиенте
Процедура ИнфТовараТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка, "Новинки",, "Новинки");
КонецПроцедуры

 &НаКлиенте
Процедура ПоказатьСкрытьИнфОТоваре(Команда)
	РаботаСНоменклатуройКлиент.ПоказатьСкрытьИнфОТоваре(ЭтаФорма);
КонецПроцедуры
&НаКлиенте
Процедура НастройкаИнфОТоваре(Команда) 
	РаботаСНоменклатуройКлиент.НастройкаИнфОТоваре(ЭтаФорма, "Новинки", "Новинки");
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Новинка <> Справочники.Новинки.ПустаяСсылка() ТОгда
		Объект.Новинка = Параметры.Новинка;
		ЗагрузитьНовинки();
		Для Каждого Строка Из Объект.Новинки Цикл
			Строка.Пометка = Истина;
		КонецЦикла;
	КонецЕсли;
		
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция СформироватьТабличныйДокумент()
	
	МассивНовинок = Новый Массив();
	
	Для Каждого СтрокаТовара Из Объект.Новинки Цикл 
		Если СтрокаТовара.Пометка Тогда
			МассивНовинок.Добавить(СтрокаТовара.Номенклатура);
		КонецЕсли;
	КонецЦикла;
	

	
	
	ТабличныйДокумент = Новый ТабличныйДокумент();
	Макет = РеквизитФормыВЗначение("Объект").ПолучитьМакет("Макет");

	ПараметрыЗаполнения = ПолучитьИнформациюПоНовинкам(МассивНовинок);
	
	//Вывести верхний колонтитул
	
	Область = Макет.ПолучитьОбласть("ВерхнийКолонтитул");
	//Область.Параметры.Заполнить(ПараметрыЗаполнения.Шапка);
	Область.Параметры.НаименованиеНовинки = Объект.Новинка.Наименование;
	
	//Область.Параметры.ДатаНачала = Формат(ПараметрыЗаполнения.Шапка.ДатаНачала,"ДФ=dd.MM.yyyy");
	//Область.Параметры.ДатаОкончания = Формат(ПараметрыЗаполнения.Шапка.ДатаОкончания,"ДФ=dd.MM.yyyy");
	Область.Параметры.Ответственный = ПараметрыСеанса.ТекущийПользователь; 
	
	СтруктураОтветвенного = ПолучитьИнфуПоОтветвенному(ПараметрыСеанса.ТекущийПользователь);
	Область.Параметры.КонтактОтветвенного = "тел.: " + ?(СтруктураОтветвенного.Свойство("Телефон"), СтруктураОтветвенного.Телефон, "8 (812) 458-46-64") + 
	?(СтруктураОтветвенного.Свойство("Почта"), "; e-mail: " + СтруктураОтветвенного.Почта, "");
	ТабличныйДокумент.Вывести(Область);
	
	//Вывести комментарий
	
	//Область = Макет.ПолучитьОбласть("Комментарий");
	//Если Акция.Валюта <> КэшируемыеФункции.ВалютаУправленческогоУчета() Тогда
	//	
	//	Отбор = Новый Структура();
	//	Отбор.Вставить("Валюта",Акция.Валюта);
	//	
	//	Курс = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ТекущаяДата(),Отбор);
	//	Если Курс<> Неопределено Тогда
	//		Область.Параметры.Курс = " по курсу " + Акция.Валюта + " = " + Формат(Курс.Курс,"ЧДЦ=2");
	//	КонецЕсли;
	//	
	//КонецЕсли; 
	//
	//Область.Параметры.ДатаКурса = Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy");
	//ТабличныйДокумент.Вывести(Область);
	
	//Если Объект.Комментарий <> "" Тогда
	//	Область = Макет.ПолучитьОбласть("Комментарий1");
	//	Область.Параметры.Комментарий = Объект.Комментарий;
	//	ТабличныйДокумент.Вывести(Область);
	//КонецЕсли;
	
	
	//Вывести шапку таблицы
	
	//ВыводитьСопутствАкцию = НЕ СопутствующаяАкция = Документы.Акция.ПустаяСсылка() И Объект.ВыводитьНаценку;
	
	Если Объект.ВыводитьНаценку Тогда
		Область = Макет.ПолучитьОбласть("ШапкаТаблицыРозн");
		ТабличныйДокумент.Вывести(Область); 
	Иначе
		Область = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;
	
	//Вывести строки таблицы
	
	НомерСтроки = 0;
	
	Для Каждого Строка Из ПараметрыЗаполнения Цикл
		Область = ?(Объект.ВыводитьНаценку,Макет.ПолучитьОбласть("СтрокаРозн"),Макет.ПолучитьОбласть("Строка"));
		НомерСтроки = НомерСтроки + 1;
		
		Область.Параметры.НомерСтроки = НомерСтроки;
		//Область.Параметры.Заполнить(Строка);
		Область.Параметры.Номенклатура = Строка.Номенклатура;
		Область.Параметры.Артикул = Строка.Номенклатура.Артикул;
		Область.Параметры.Производитель = Строка.Номенклатура.Производитель;
		Область.Параметры.ЦенаДилера = Строка.ЦенаДилера;
		
		Область.Параметры.ВалютаДилера = ?(Объект.ВалютаДилера = Справочники.Валюты.ПустаяСсылка() ИЛИ НЕ Объект.ВыводитьНаценку, 
										   КэшируемыеФункции.ВалютаУправленческогоУчета(),
										   Объект.ВалютаДилера);
		
		// Картинка
		
		СсылкаКартинки = Картинки.ПолучитьСсылкуОсновногоИзображения(Строка.Номенклатура);  
				
		Если СсылкаКартинки <> Неопределено Тогда
			//Область.Область("R1C2").Картинка = ?(СсылкаКартинки.КопияКартинки.Пустая(), СсылкаКартинки.Аватар.Получить(), СсылкаКартинки.КопияКартинки.Аватар.Получить());
			Область.Область("R1C2").Картинка = 
			?(СсылкаКартинки.КопияКартинки.Пустая(), 
			?(СсылкаКартинки.Аватар.Получить()=Неопределено, СсылкаКартинки.Картинка.Получить(), СсылкаКартинки.Аватар.Получить()),
			?(СсылкаКартинки.КопияКартинки.Аватар.Получить()=Неопределено, СсылкаКартинки.КопияКартинки.Картинка.Получить(),СсылкаКартинки.КопияКартинки.Аватар.Получить()) );
			//СсылкаКартинки.КопияКартинки.Аватар.Получить());
		КонецЕсли;
		
		//Розничные цены
				
		Если Объект.ВыводитьНаценку Тогда
			
			Область.Параметры.ЦенаРозница = Строка.ЦенаРозн;
			
			Область.Параметры.ВалютаРозница = ?(Объект.ВалютаРозницы = Справочники.Валюты.ПустаяСсылка() ИЛИ НЕ Объект.ВыводитьНаценку,
												КэшируемыеФункции.ВалютаУправленческогоУчета(), 
												Объект.ВалютаРозницы);
			
			Область.Параметры.Наценка = Формат(Строка.Наценка,"ЧДЦ=2; ЧС=-2");
			
		КонецЕсли;
		
		Если НЕ ТабличныйДокумент.ПроверитьВывод(Область) Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			//Вывести колонтитул и шапку на новой странице
			
			ОбластьКолонтитул = Макет.ПолучитьОбласть("ВерхнийКолонтитул2");
			//ОбластьКолонтитул.Параметры.НаименованиеАкции = Акция.Наименование;
			ТабличныйДокумент.Вывести(ОбластьКолонтитул);
			
		КонецЕсли;
		ТабличныйДокумент.Вывести(Область);
		
	КонецЦикла;
	
	//Комментарий
	
	Область = Макет.получитьОбласть("Комментарий1");
	Область.Параметры.Комментарий = Объект.Комментарий;
	ТабличныйДокумент.Вывести(Область);

	
	//Вывести подпись
	
	Область = Макет.получитьОбласть("Подпись");
	Область.Параметры.КонтактОтветвенного = "тел.: " + ?(СтруктураОтветвенного.Свойство("Телефон"), СтруктураОтветвенного.Телефон, "8 (812) 458-46-64") + 
	?(СтруктураОтветвенного.Свойство("Почта"), "; e-mail: " + СтруктураОтветвенного.Почта, "");
	Область.Параметры.Ответственный = ПараметрыСеанса.ТекущийПользователь; 
	
	ТабличныйДокумент.Вывести(Область);
	
	ТабличныйДокумент.НижнийКолонтитул.ТекстСправа = "Страница [&НомерСтраницы] Из [&СтраницВсего]";
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.Защита = Ложь;
	
	Возврат ТабличныйДокумент;
	
	
	
КонецФункции

&НаСервере
Функция ПолучитьИнформациюПоНовинкам(Товары)
	
	//ПолучитьКурсыТребуемхВалют
	КурсКоэфДил = 1;
	КурсКоэфРоз = 1;
	КурсыВалют = РегистрыСведений.КурсыВалют.СрезПоследних();
	ВалДилера = ?(Объект.ВалютаДилера = Справочники.Валюты.ПустаяСсылка() ИЛИ НЕ Объект.ВыводитьНаценку, 
				  КэшируемыеФункции.ВалютаУправленческогоУчета(),
				  Объект.ВалютаДилера);

	КоэфДилер =  КурсыВалют.Найти(ВалДилера,"Валюта");
	КурсКоэфДил = КоэфДилер.Курс/КоэфДилер.Кратность;
	
	ВалРозн = ?(Объект.ВалютаРозницы = Справочники.Валюты.ПустаяСсылка() ИЛИ НЕ Объект.ВыводитьНаценку, 
				КэшируемыеФункции.ВалютаУправленческогоУчета(),
				Объект.ВалютаРозницы);
	Если Объект.ВыводитьНаценку Тогда
		КоэфРозниц =  КурсыВалют.Найти(ВалРозн,"Валюта");
		КурсКоэфРоз = КоэфРозниц.Курс/КоэфРозниц.Кратность;
	КонецЕсли;

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Курсы.Валюта,
		|	Курсы.Курс,
		|	Курсы.Кратность
		|ПОМЕСТИТЬ Курсы
		|ИЗ
		|	РегистрСведений.КурсыВалют.СрезПоследних(, ) КАК Курсы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Номенклатура.Ссылка КАК Номенклатура
		|ПОМЕСТИТЬ ТаблТовары
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Ссылка В(&Товары)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблТовары.Номенклатура КАК Номенклатура,
		|	ЕСТЬNULL(ЦеныДил.Цена * КурсыДил.Курс / ЕСТЬNULL(КурсыДил.Кратность, 1) / &КурсКоэфДил, 0) КАК ЦенаДилера "+ ?(НЕ Объект.ВыводитьНаценку,"",",
		|   ЕСТЬNULL(ЦеныРоз.Цена * КурсыРоз.Курс / ЕСТЬNULL(КурсыРоз.Кратность, 1) / &КурсКоэфРоз, 0) КАК ЦенаРозн,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ЦеныДил.Цена * КурсыДил.Курс / ЕСТЬNULL(КурсыДил.Кратность, 1), 0) = 0
		|			ТОГДА 0
		|		ИНАЧЕ ЕСТЬNULL(ЦеныРоз.Цена * КурсыРоз.Курс / ЕСТЬNULL(КурсыРоз.Кратность, 1), 0) / (ЦеныДил.Цена * КурсыДил.Курс / ЕСТЬNULL(КурсыДил.Кратность, 1) )-1
		|	КОНЕЦ КАК Наценка ")+
		" ИЗ
		|	ТаблТовары КАК ТаблТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
		|				,
		|				Номенклатура В (&Товары)
		|					И ТипЦен = &ТипЦенДил) КАК ЦеныДил
		|			ЛЕВОЕ СОЕДИНЕНИЕ Курсы КАК КурсыДил
		|			ПО ЦеныДил.Валюта = КурсыДил.Валюта
		|		ПО ТаблТовары.Номенклатура = ЦеныДил.Номенклатура "+ ?(НЕ Объект.ВыводитьНаценку,"","
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
		|				,
		|				Номенклатура В (&Товары)
		|					И ТипЦен = &ТипЦенРоз) КАК ЦеныРоз
		|			ЛЕВОЕ СОЕДИНЕНИЕ Курсы КАК КурсыРоз
		|			ПО ЦеныРоз.Валюта = КурсыРоз.Валюта 
		| 		ПО ТаблТовары.Номенклатура = ЦеныРоз.Номенклатура");
	
	Запрос.УстановитьПараметр("КурсКоэфДил", КурсКоэфДил);
	Запрос.УстановитьПараметр("КурсКоэфРоз", КурсКоэфРоз);
	Запрос.УстановитьПараметр("ТипЦенДил", ?(Объект.ВыводитьНаценку,Объект.ТипЦенДилера, КэшируемыеФункции.ПолучитьТипЦенРозница()));
	Запрос.УстановитьПараметр("ТипЦенРоз", КэшируемыеФункции.ПолучитьТипЦенРозница());
	Запрос.УстановитьПараметр("Товары", Товары);
	
	Выборка = Запрос.Выполнить().Выгрузить();
	Возврат Выборка;
	
КонецФункции

&НаСервере
Функция ПолучитьИнфуПоОтветвенному(Ответственный)
	
	Структура 	= Новый Структура;
	ФизЛицо 	= Ответственный.ФизЛицо;
	
	Если Не ФизЛицо.Пустая() Тогда
	
		// Вытащим телефон
		
		Телефон = ПерваяИнфаКонтактнойИнформации(ФизЛицо, Справочники.ВидыКонтактнойИнформации.Телефон);
		Если Телефон <> Неопределено Тогда Структура.Вставить("Телефон", Телефон) КонецЕсли;
		
		// Вытащим почту
		
		Почта = ПерваяИнфаКонтактнойИнформации(ФизЛицо, Справочники.ВидыКонтактнойИнформации.АдресЭлектроннойПочты);
		Если Почта <> Неопределено Тогда Структура.Вставить("Почта", Почта) КонецЕсли; КонецЕсли;
	
	Возврат Структура;
	
КонецФункции

&НаСервере
Функция ПерваяИнфаКонтактнойИнформации(Ссылка, Вид)
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Представление ИЗ РегистрСведений.ПредставлениеКонтактнойИнформации ГДЕ Объект = &Ссылка И Вид В ИЕРАРХИИ(&Вид) УПОРЯДОЧИТЬ ПО ЗначениеПоУмолчанию УБЫВ");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Вид", 	Вид);
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда Возврат Выборка.Представление КонецЕсли;
	
КонецФункции


&НаКлиенте
Процедура Сформировать(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат
	КОнецЕсли;
	
	Контрагент = Неопределено; Номер = Неопределено;
	ДопПараметры = Новый Массив;
	ДопПараметры.Добавить(Новый Структура("Контрагент", Контрагент));
		
	ОткрытьФорму("ОбщаяФорма.ТабличныйДокумент", 
					Новый Структура("ТабличныйДокумент, ИмяФайла, ДополнительныеПараметры", 
							СформироватьТабличныйДокумент(),
							"Новинки", 
							ДопПараметры), ЭтаФорма);
КонецПроцедуры


&НаКлиенте
Процедура НовинкиПометкаПриИзменении(Элемент)
	
	текДанные = Элемент.Родитель.ТекущиеДанные;
	
	Если текДанные.Номенклатура.Пустая() Тогда
		
		Строки = текДанные.ПолучитьЭлементы();
		Для Каждого Строка Из Строки Цикл Строка.Пометка = текДанные.Пометка КонецЦикла; КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НовинкаПриИзменении(Элемент)
	
	Если Объект.Новинка = ПредопределенноеЗначение("Справочник.Новинки.ПустаяСсылка") Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьНовинки();
	ВыбратьВсе();
		
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНовинки()
	
	Объект.Новинки.Очистить();
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	НовинкиТовары.Номенклатура КАК Ссылка,
	|	НовинкиТовары.Ссылка КАК Новинка,
	|	НовинкиТовары.Номенклатура,
	|	НовинкиТовары.Номенклатура.Артикул КАК Артикул,
	//|	НовинкиТовары.ДатаНовинки КАК ДатаНовинки,
	|	НовинкиТовары.Номенклатура.Наименование КАК Представление
	|ИЗ
	|	Справочник.Новинки.Товары КАК НовинкиТовары
	|ГДЕ
	|	НовинкиТовары.Готовность
	|	И НовинкиТовары.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка",Объект.Новинка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	КонвертацияТипов.ЗагрузитьВыборкуВТаблицу(Выборка,Объект.Новинки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе()
	Для Каждого Строка Из Объект.Новинки Цикл
		Строка.Пометка = Истина;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура УбратьВсё(Команда)
	Для Каждого Строка Из Объект.Новинки Цикл
		Строка.Пометка = Ложь;
	КонецЦикла;	

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьНаценкуПриИзменении()
	
	 Элементы.ВалютаДилера.Доступность = Объект.ВыводитьНаценку;
	 Элементы.ВалютаРозницы.Доступность = Объект.ВыводитьНаценку;
	 Элементы.ТипЦенДилера.Доступность = Объект.ВыводитьНаценку;
	 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВыводитьНаценкуПриИзменении();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ВыводитьНаценку Тогда
		
		Если Объект.ТипЦенДилера = Справочники.ТипыЦен.ПустаяСсылка() Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Поле ""Тип цены дилера"" не заполнено!";
			Сообщение.Поле  = "ЦенаДилераТипЦены";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
		Если Объект.ВалютаДилера = Справочники.Валюты.ПустаяСсылка() Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Поле ""Валюта цены дилера"" не заполнено!";
			Сообщение.Поле  = "ЦенаДилераВалюта";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
		Если Объект.ВалютаРозницы = Справочники.Валюты.ПустаяСсылка() Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Поле ""Валюта розничной цены"" не заполнено!";
			Сообщение.Поле  = "РозницаВалюта";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры



