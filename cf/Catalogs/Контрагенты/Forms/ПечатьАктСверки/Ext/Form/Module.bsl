﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Контрагент = Параметры.Контрагент;
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	//ТабличныйДокумент = Новый ТабличныйДокумент;
	//Печать_АктСверки(ТабличныйДокумент);
	//ТабличныйДокумент.Показать();
	
КонецПроцедуры

&НаСервере
Процедура Печать_АктСверки(ТабличныйДокумент)
		
	Справочники.Контрагенты.Печать_АктСверки(ТабличныйДокумент, Новый Структура("Контрагент, Организация, НачалоПериода, КонецПериода", Контрагент, Организация, НачалоПериода, КонецПериода));	
	
КонецПроцедуры
