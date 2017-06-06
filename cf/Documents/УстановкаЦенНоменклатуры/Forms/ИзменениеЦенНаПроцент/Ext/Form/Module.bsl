﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ТипЦенОснование.СписокВыбора.ЗагрузитьЗначения(Параметры.ТипыЦен.ВыгрузитьЗначения());
	
	Для Каждого Строка из Параметры.ТипыЦен Цикл
		НоваяСтрока = Таблица.Добавить();
		НоваяСтрока.ТипЦен 				= Строка.Значение;
		НоваяСтрока.ТипЦенОснование 	= НоваяСтрока.ТипЦен;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	Для Каждого Строка Из Таблица Цикл
		Строка.Пометка = Истина;
	КонецЦикла;

КонецПроцедуры
&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Для Каждого Строка Из Таблица Цикл
		Строка.Пометка = Ложь;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	Адрес =  ПоместитьТаблицуВоВременноеХранилище(ВладелецФормы.УникальныйИдентификатор);
	
	ЭтаФорма.Закрыть(Адрес);
	
КонецПроцедуры
Функция ПоместитьТаблицуВоВременноеХранилище(ИД)
	
	Возврат ПоместитьВоВременноеХранилище(Таблица.Выгрузить(), ИД);
	
КонецФункции

&НаКлиенте
Процедура ПроцентПриИзменении(Элемент)
	Если Элементы.Таблица.ТекущиеДанные <> Неопределено Тогда
		Элементы.Таблица.ТекущиеДанные.Пометка = Истина;
	КонецЕсли;
КонецПроцедуры
