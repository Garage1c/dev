﻿&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;

&НаКлиенте
Процедура ОбщиеРеквизиты(Команда)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизиты(ЭтаФорма);
	
КонецПроцедуры

// ПРЕДОПРЕДЕЛЕННЫЕ ПРОЦЕДУРЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Рассчитаем динамические колонки
	
	ФункцииФормДокументов.РассчитатьДинамическиеКолонки(
					Объект.Товары,
					ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары));
КонецПроцедуры
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Получим структуру колонок
	
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары);
	
КонецПроцедуры

// ОБРАБОТКИ ТАБЛИЧНОЙ ЧАСТИ

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент, КонкретнаяСтрока = Неопределено)

	ФункцииФормДокументов.НоменклатураПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары,
				КонкретнаяСтрока);

КонецПроцедуры
