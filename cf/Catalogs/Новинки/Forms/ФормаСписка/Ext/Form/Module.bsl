﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ (РольДоступна("ПолныеПрава") ИЛИ РольДоступна("РедактированиеНоменклатуры") ИЛИ РольДоступна("УправлениеНовинками")) Тогда
		Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Готовность");
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Отбор.Использование = Истина;
		Отбор.ПравоеЗначение = Истина;
	КонецЕсли
	
КонецПроцедуры
