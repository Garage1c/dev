﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Проверим появление новых категорий
	Если НЕ Объект.Ссылка.Пустая() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ 
		|	ТегиНоменклатуры.Номенклатура.Родитель КАК Категория 
		|Поместить ТегиКатегории
		|ИЗ 
		|	РегистрСведений.ТегиНоменклатуры КАК ТегиНоменклатуры
		|ГДЕ
		|	ТегиНоменклатуры.Тег = &ТекущийТег
		|СГРУППИРОВАТЬ ПО
		|	ТегиНоменклатуры.Номенклатура.Родитель
		|;
		|ВЫБРАТЬ 
		|	ТегиКатегории.Категория КАК Категория 
		|ИЗ 
		|	ТегиКатегории КАК ТегиКатегории
		|ЛЕВОЕ СОЕДИНЕНИЕ 
		|	Справочник.Теги.Описание КАК ТекущиеКатегории
		|ПО
		|	ТекущиеКатегории.Категория = ТегиКатегории.Категория И ТекущиеКатегории.Ссылка = &ТекущийТег
		|ГДЕ
		|	ТекущиеКатегории.Ссылка Есть NULL
		|";
		
		Запрос.УстановитьПараметр("ТекущийТег", Объект.Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			новСтрока = Объект.Описание.Добавить();
			новСтрока.Категория = Выборка.Категория;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
