﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Список.Параметры.УстановитьЗначениеПараметра("Склады", Параметры.Склады);
	Список.Параметры.УстановитьЗначениеПараметра("Номенклатура", Параметры.Номенклатура);
	Список.Параметры.УстановитьЗначениеПараметра("Контрагент", Параметры.Контрагент);
	Список.Параметры.УстановитьЗначениеПараметра("Цена", Параметры.Цена);
	Список.Параметры.УстановитьЗначениеПараметра("текДата", ТекущаяДата());

КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	Закрыть(Элементы.Список.ТекущиеДанные);
КонецПроцедуры
