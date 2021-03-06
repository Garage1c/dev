﻿
// ОТОБРАЖЕНИЕ

&НаСервере
Процедура ОбновитьСостоПроцеяние()

	Список.Параметры.УстановитьЗначениеПараметра("ВыбраноСостояние", 	Не Состояние.Пустая());
	Список.Параметры.УстановитьЗначениеПараметра("Состояние", 			Состояние);
	
КонецПроцедуры

// ТИПОВЫЕ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("СостояниеЧерновик", Перечисления.СостоянияЗаказа.Черновик);
	
	ОбновитьСостоПроцеяние();
	
КонецПроцедуры

// ЭЛЕМЕНТЫ

&НаКлиенте
Процедура СостояниеФильтрПриИзменении(Элемент)
	
	ОбновитьСостоПроцеяние();
	
КонецПроцедуры
&НаКлиенте
Процедура СостояниеФильтрОчистка(Элемент, СтандартнаяОбработка)
	
	ОбновитьСостоПроцеяние();
	
КонецПроцедуры
&НаКлиенте
Процедура ТолькоМоиПриИзменении(Элемент)
	
	ОбновитьСостоПроцеяние();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = СобытияСистемы.Событие_ЗаписанаЗадача() Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Если Элементы.Найти("ФормаДокументВыдачаНаМОЛСоздатьНаОсновании") = Неопределено Тогда
		Возврат
	КонецЕсли;
	ТД = Элементы.Список.ТекущиеДанные;
	Элементы.ФормаДокументВыдачаНаМОЛСоздатьНаОсновании.Доступность = ПолучитьДоступностьДляЭлементовВводаНаОсновании(ТД.Заказ, ТД.Состояние);
КонецПроцедуры

&НаСервереБезКонтекста
Функция  ПолучитьДоступностьДляЭлементовВводаНаОсновании(Заказ,Состояние)
	Если Заказ.Статус = Перечисления.СтатусыВнутреннегоЗаказа.Согласовано И НЕ Заказ.ОснованиеВыдачиИнструмента.Пустая() 
		И Состояние = Перечисления.СостоянияЗаказа.Отгружен Тогда
		ФлагДоступность = Истина;
	Иначе
		ФлагДоступность = Ложь;
	КонецЕсли;
	 Возврат ФлагДоступность;
КонецФункции
