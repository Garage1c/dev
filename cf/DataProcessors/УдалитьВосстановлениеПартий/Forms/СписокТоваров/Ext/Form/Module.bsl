﻿
&НаСервере
Процедура ЗаполнитьТоварамиБезСебестоимости()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	Ссылка Номенклатура, Артикул
	|ИЗ
	|	Справочник.Номенклатура Спр
	|
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыНаСкладах Ост
	|ПО
	|	Спр.Ссылка = Ост.Номенклатура
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ЦеныНоменклатуры Рег
	|ПО
	|	Спр.Ссылка = Рег.Номенклатура
	|
	|ГДЕ
	|	Рег.Номенклатура ЕСТЬ NULL И
	|	ТипНоменклатуры = &ТипТовар
	|
	|УПОРЯДОЧИТЬ ПО Наименование
	|");
	
	Запрос.УстановитьПараметр("ТипТовар", Перечисления.ТипыНоменклатуры.Товар);
	Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	Если Параметры.ОткрытьСТоварамиБезСебестоимости Тогда
		ЗаполнитьТоварамиБезСебестоимости(); КонецЕсли;
	
КонецПроцедуры

#Область Информация // о товаре

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре()	
	 	
КонецПроцедуры
&НаСервере
Процедура ОбработатьОтображениеИнформацииОТоваре() Экспорт 
	РаботаСНоменклатурой.ОбработатьОтображениеИнформацииОТоваре(ЭтаФорма, "Товары", "Товары");
КонецПроцедуры

&НаКлиенте
Процедура ИнфТовараТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура ИнфТовараЗаголовокHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараЗаголовокHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка, "Товары", "Товары");
КонецПроцедуры

 &НаКлиенте
Процедура ПоказатьСкрытьИнфОТоваре(Команда)
	РаботаСНоменклатуройКлиент.ПоказатьСкрытьИнфОТоваре(ЭтаФорма);
КонецПроцедуры
&НаКлиенте
Процедура НастройкаИнфОТоваре(Команда) 
	РаботаСНоменклатуройКлиент.НастройкаИнфОТоваре(ЭтаФорма, "Товары", "Товары");
КонецПроцедуры

#КонецОбласти


&НаКлиенте
Процедура УстановитьВсемЦенЗакончить(ВыбЗнач, Параметры) Экспорт
	
	Если ВыбЗнач <> Неопределено Тогда
		Для Каждого Строка Из Товары Цикл Строка.Цена = ВыбЗнач КонецЦикла; КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура УстановитьВсемЦену(Команда)
	
	ПоказатьВводЗначения(Новый ОписаниеОповещения("УстановитьВсемЦенЗакончить", ЭтаФорма),,"Цена", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(10,2,ДопустимыйЗнак.Неотрицательный)));
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресТоваров()
	
	Возврат ПоместитьВоВременноеХранилище(Товары.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции
&НаСервере
Функция ПолучитьТипЦенЗакупочный()

	Возврат Константы.ТипЦенЗакупочныйРуб.Получить();
	
КонецФункции
&НаКлиенте
Процедура СоздатьУстановкуЦен(Команда)
	
	ОткрытьФорму("Документ.УстановкаЦенНоменклатуры.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", новый Структура("Товары, ТипЦен", ПолучитьАдресТоваров(), ПолучитьТипЦенЗакупочный())), ЭтаФорма);
	
КонецПроцедуры
