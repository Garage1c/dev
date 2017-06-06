﻿
Процедура ПередЗаписью(Отказ)
	
	Наименование = Проход + "." + Секция + "." + Ярус + "." + Поддон;
	
	// Проверим что нет такого же с такими же данными
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ ИСТИНА ИЗ Справочник.Ячейки 
		|ГДЕ &Ссылка <> Ссылка И Владелец = &Владелец
		|И Секция = """ + Секция + """ 
		|И Проход = """ + Проход + """ 
		
		|И Ярус = """ + Ярус + """ 
		|И Поддон = """ + Поддон + """
		|");
	
	Запрос.УстановитьПараметр("Владелец", 	Владелец);
	Запрос.УстановитьПараметр("Ссылка", 	Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Отказ = Истина;
		ОбщиеФункции.СообщитьТекст("Ячейка с такимиже данными уже существует");	КонецЕсли;
	
	// Установим сортировку
	
	Если Не Отказ И ПустаяСтрока(Сортировка) Тогда
		Сортировка = Прав("000" + Проход, 3) + Прав("000" + Секция, 3)+ Прав("000" + Ярус, 3) + Прав("000" + Поддон, 3); КонецЕсли;
	
КонецПроцедуры

