﻿
&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда) Если Записать() Тогда Закрыть() КонецЕсли КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ЗаписатьИЗакрыть.Видимость = 
			КэшируемыеФункции.ЭтоПолныеПрава() Или
			РольДоступна("ВыполнятьЛюбуюЗадачу") Или
			ФункцииБизнесПроцессов.РазрешенаЗадачаКВыполнению(Объект.Ссылка);
	
КонецПроцедуры
