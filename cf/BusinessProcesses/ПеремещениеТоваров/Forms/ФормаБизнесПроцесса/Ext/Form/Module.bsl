﻿
&НаКлиенте
Перем МассивКомментариев Экспорт;


// ОБНОВЛЕНИЕ

&НаСервере
Процедура УстановитьЗаголовок()
	
	Заголовок = ФункцииБизнесПроцессов.ПолучитьЗаголовокБП(Объект.Ссылка);
	
КонецПроцедуры
&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	ЭтоНовый 	= Объект.Ссылка.Пустая();
	Стартован 	= Объект.Стартован;
			
	Элементы.ЗадачиПроцесса.Видимость 	= Стартован;
	
	Элементы.ДокументыПроцесса.Видимость = Не ЭтоНовый;
	
	
КонецПроцедуры
&НаСервере
Процедура ПрочитатьРеквизиты()
	
	ФункцииБизнесПроцессов.ЗаполнитьДанные(ЭтаФорма, Объект.Ссылка);
	
	Элементы.ЗадачиПроцесса.Обновить();
	Элементы.ДокументыПроцесса.Обновить();
	
	УправлениеВидимостьюДоступностью();
	
	УстановитьЗаголовок();
	
КонецПроцедуры

// ТИПОВЫЕ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// комментарии
	ФункцииБизнесПроцессовКлиент.ПолучитьМассивКомментариев(ЭтаФорма, Объект.Ссылка);
	
	
КонецПроцедуры
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	// комментарии
	ФункцииБизнесПроцессов.ДобавитьРаботуСКомментариями(ЭтаФорма);

	ЗадачиПроцесса.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
	ДокументыПроцесса.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
	
	ПрочитатьРеквизиты();
		
КонецПроцедуры
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СобытияСистемы.ОповеститьОЗаписиБизнесПроцесса(Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = СобытияСистемы.Событие_ЗаписанаЗадача() Тогда
		
		БизнесПроцессЗадачи = Неопределено;
		Если Параметр.Свойство("БизнесПроцесс", БизнесПроцессЗадачи) Тогда
			
			Если БизнесПроцессЗадачи = Объект.Ссылка Тогда
				
				Элементы.ЗадачиПроцесса.Обновить();
				Элементы.ДокументыПроцесса.Обновить();
				
			КонецЕсли;
		КонецЕсли;
				
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ОбщиеРеквизитыНажатие(Элемент)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизитыБП(ЭтаФорма);
	
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


