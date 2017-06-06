﻿
&НаСервере
Процедура ПрочитатьКорзину(ИмяКомпа)

	Запрос = Новый Запрос("ВЫБРАТЬ * ИЗ РегистрСведений.Корзина ГДЕ ИмяКомпа = """ + ИмяКомпа + """ И Пользователь = &Пользователь УПОРЯДОЧИТЬ ПО Позиция");
	Запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.ТекущийПользователь);
	
	Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

// ТИПОВЫЕ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		ПрочитатьКорзину(ИмяПользователя());
	#Иначе
		ПрочитатьКорзину(ИмяКомпьютера());
	#КонецЕсли
	
КонецПроцедуры
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре();
	
КонецПроцедуры

// ИНФОРМАЦИЯ О ТОВАРЕ

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


&НаКлиенте
Процедура ДобавитьИзЗапроса(Команда)
	
	ОткрытьФорму("РегистрСведений.Корзина.Форма.ФормаЗапроса",,ЭтаФорма,,,,Новый ОписаниеОповещения("ПринятьЗапрос", ЭтаФорма));
	
КонецПроцедуры
&НаСервере
Процедура ПринятьЗапросНаСервере(АдресКТоварам)
	
	Товары.Загрузить(ПолучитьИзВременногоХранилища(АдресКТоварам));
	
КонецПроцедуры
&НаКлиенте
Процедура ПринятьЗапрос(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЭтоАдресВременногоХранилища(Результат) Тогда
		ПринятьЗапросНаСервере(Результат); КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗапистьТоварКорзины(ИмяКомпа)

	Набор = РегистрыСведений.Корзина.СоздатьНаборЗаписей();
	Набор.Отбор.Пользователь.Установить(ПараметрыСеанса.ТекущийПользователь);
	Набор.Отбор.ИмяКомпа.Установить(ИмяКомпа);
	
	Таблица = Товары.Выгрузить();
	Таблица.Колонки.Добавить("Пользователь", 	Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	Таблица.Колонки.Добавить("ИмяКомпа", 		Новый ОписаниеТипов("Строка"));
	Таблица.ЗаполнитьЗначения(ПараметрыСеанса.ТекущийПользователь, "Пользователь");
	Таблица.ЗаполнитьЗначения(ИмяКомпа, 							"ИмяКомпа");
	
	// Пронумеруем
	Ном = 0;
	Для Каждого Строка Из Таблица Цикл Ном = Ном + 1; Строка.Позиция = Ном; КонецЦикла;
	
	Набор.Загрузить(Таблица);
	
	ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Набор);
			
КонецПроцедуры
&НаКлиенте
Процедура ПриЗакрытии()
	
	#Если Не ВебКлиент Тогда
		ЗапистьТоварКорзины(ИмяКомпьютера());
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьКартинкиНаДиск(Команда)
	
	Ссылки = Новый Массив;
	Для Каждого Строка Из Товары Цикл Ссылки.Добавить(Строка.Номенклатура) КонецЦикла;
	
	ДиалогиСПользователем.ВыгрузитьКартинкиНоменклатурыНаДиск(Ссылки);
	
КонецПроцедуры
