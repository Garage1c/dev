﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВестиЛог = Константы.обм_ВестиЛогЗапросов.Получить();
	
КонецПроцедуры

&НаСервере
Процедура ВестиЛогПриИзмененииНаСервере()
	
	Константы.обм_ВестиЛогЗапросов.Установить(ВестиЛог);
	
КонецПроцедуры
&НаКлиенте
Процедура ВестиЛогПриИзменении(Элемент)
	
	ВестиЛогПриИзмененииНаСервере();
	
КонецПроцедуры
