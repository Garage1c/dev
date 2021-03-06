﻿
&НаКлиенте
Перем мВремяОткрытия;

// ИНФОРМАЦИЯ О ТОВАРЕ

&НаСервере
Процедура ОбработатьОтображениеИнфОПартнере() Экспорт
	ОперативнаяИнформация.ОбработатьОтображениеИнфОПартнере(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ИнфТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	ОперативнаяИнформацияКлиент.ИнфТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры
//&НаКлиенте
//Процедура ИнфТовараЗаголовокHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
//	РаботаСНоменклатуройКлиент.ИнфТовараЗаголовокHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка, "Список");
//	
//КонецПроцедуры

 &НаКлиенте
Процедура ПоказатьСкрытьИнформацию(Команда)
	ОперативнаяИнформацияКлиент.ПоказатьСкрытьИнформацию(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныВсеПартнеры", 	ПараметрыСеанса.ДоступныВсеПартнеры);
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныеПользователи", 	ПараметрыСеанса.ДоступныеПользователи);
	Список.Параметры.УстановитьЗначениеПараметра("ЭлектроннаяПочта", 		Справочники.ВидыКонтактнойИнформации.АдресЭлектроннойПочты);
	
	ОперативнаяИнформация.ДобавитьОперативнуюИнформациюОПартнере(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ОбработатьОтображениеИнфОПартнере();

КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ---
	мВремяОткрытия = ТекущаяДата();
	Слежение.Записать("Открытие. Список партнеров", "Справочник.Партнеры","ФормаСписка");

КонецПроцедуры
&НаКлиенте
Процедура ПриЗакрытии()
	
	// ---
	//Слежение.Записать("Закрытие. Список партнеров", "Справочник.Партнеры","ФормаСписка",,"Время работы " + Строка(ТекущаяДата() - мВремяОткрытия) + " сек.");

КонецПроцедуры

// Очистка кода клиента

&НаСервере
Процедура ОчиститьКодКлиентаНаСервере(Ссылки)
	
	Для Каждого Ссылка Из Ссылки Цикл
		Если Ссылка.НомерКлиента Тогда
			
			СпрОбъект = Ссылка.ПолучитьОбъект();
			СпрОбъект.НомерКлиента = 0;
			
			ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(СпрОбъект); КонецЕсли; КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Процедура ОчиститьКодКлиента(Команда)
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ОчиститьКодОтвет", ЭтаФорма), НСтр("ru='Очитить номера клиентов?'; de='Klar Kundenkonto?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры
&НаКлиенте
Процедура ОчиститьКодОтвет(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Ссылки = Новый Массив;
		Для Каждого Элемент Из Элементы.Список.ВыделенныеСтроки Цикл Ссылки.Добавить(Элемент) КонецЦикла;
		ОчиститьКодКлиентаНаСервере(Ссылки) КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры
