﻿

&НаКлиенте
Процедура ПоказателиСтатьяБюджетаПриИзменении(Элемент)
	ТекДанные=Элементы.Показатели.ТекущиеДанные;
	Струк=ПолучитьТипАналитики(ТекДанные.СтатьяБюджета);
	ТекДанные.ТипАналитики1=Струк.ТипАналитики1;
	ТекДанные.типАналитики2=Струк.ТипАналитики2;
	ТекДанные.типАналитики3=Струк.ТипАналитики3;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТипАналитики(Статья)
	Возврат Новый Структура("ТипАналитики1,ТипАналитики2,ТипАналитики3",Статья.ТипАналитики1,Статья.ТипАналитики2,Статья.ТипАналитики3);
КонецФункции

&НаСервере
Процедура УправлениеВидимостью()
	 КолАналитик=Объект.КоличествоАналитик;
	 Для Н=1 По 3 Цикл
		Использование=?(Н<=КолАналитик, Истина, Ложь);
		Элементы.Показатели.ПодчиненныеЭлементы["ПоказателиАналитика"+Н].Видимость=Использование;
		Элементы.Показатели.ПодчиненныеЭлементы["ПоказателиТипАналитики"+Н].Видимость=Использование;
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УправлениеВидимостью();
КонецПроцедуры


&НаКлиенте
Процедура КоличествоАналитикПриИзменении(Элемент)
	УправлениеВидимостью();
КонецПроцедуры

