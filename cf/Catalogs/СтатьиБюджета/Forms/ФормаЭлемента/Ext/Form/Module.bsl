﻿
&НаКлиенте
Процедура ЗначенияАналитики1(Команда)
	ОткрытьАналитику(Объект.ТипАналитики1)
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияАналитики2(Команда)
	ОткрытьАналитику(Объект.ТипАналитики2)
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияАналитики3(Команда)
	ОткрытьАналитику(Объект.ТипАналитики3)
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАналитику(ТипАналитики)
	Если Не ЗначениеЗаполнено(ТипАналитики) тогда
		Возврат;
	КонецЕсли;
	
	ИмяАналитики = ПолучитьИмяАналитикиНаСервере(ТипАналитики);
	
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Владелец",ТипАналитики));
	ОткрытьФорму(ИмяАналитики+".ФормаСписка",ПараметрыФормы);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИмяАналитикиНаСервере(Аналитика) Экспорт
	ТекТип = Аналитика.ТипЗначения.Типы()[0];
	ИмяАналитики = Метаданные.НайтиПоТипу(ТекТип).ПолноеИмя();
	Возврат ИмяАналитики;
КонецФункции	


&НаСервереБезКонтекста
Процедура ПроверитьВыполнениеЗапросаНаСервере(Знач ТекстЗапроса,СтатьяБюджета,ДатаНачала,ДатаОкончания)
	ТекстЗапроса=СтрЗаменить(ТекстЗапроса,"Выбрать","Выбрать Первые 100");
	Запрос=Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СтатьяБюджета",СтатьяБюджета);
	Запрос.УстановитьПараметр("ДатаНачала",ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания",ДатаОкончания);
	Попытка
		Рез=Запрос.Выполнить();
		Сообщить("Все путем!");
	Исключение
		Сообщить("Увы, ваш запрос крив! "+ОписаниеОшибки());
	КонецПопытки;	
КонецПроцедуры


&НаКлиенте
Процедура ПроверитьВыполнениеЗапроса(Команда)
	
	Если 		Элементы.группа4.ТекущаяСтраница = Элементы.Факт 	Тогда	ТЗ = Объект.ЗапросФакт;
	ИначеЕсли 	Элементы.группа4.ТекущаяСтраница = Элементы.Факт1 	Тогда	ТЗ = Объект.ЗапросФактРасшифровка;
	Иначе 		Возврат;
	КонецЕсли;
	
	ПроверитьВыполнениеЗапросаНаСервере(ТЗ,Объект.Ссылка,ДобавитьМесяц(ТекущаяДата(),-1),ТекущаяДата());
	
КонецПроцедуры




&НаКлиенте
Процедура КонструкторЗапроса(Команда)
	
	Если 		Элементы.группа4.ТекущаяСтраница = Элементы.Факт 	Тогда	ТЗ = Объект.ЗапросФакт;
	ИначеЕсли 	Элементы.группа4.ТекущаяСтраница = Элементы.Факт1 	Тогда	ТЗ = Объект.ЗапросФактРасшифровка;
	Иначе 		Возврат;
	КонецЕсли;

	Если ПустаяСтрока(ТЗ) 
	Тогда	КонструкторЗапроса = Новый КонструкторЗапроса();
	Иначе 	КонструкторЗапроса = Новый КонструкторЗапроса(ТЗ);
	КонецЕсли;
	
	КонструкторЗапроса.Показать(Новый ОписаниеОповещения("ВыполнитьПослеЗакрытияКонструктора", ЭтаФорма));		
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеЗакрытияКонструктора(Текст,ДополнительныеПараметры) Экспорт
	
	Если Текст = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Объект.ЗапросФакт=Текст;
	
	Модифицированность=Истина;
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// временно до помещения роли пользователь в хранилище
	Если Не РольДоступна("ПолныеПрава") ТОгда
		ОбщиеФункции.СообщитьТекст("Изменение объекта возможно только при полных правах");
		Отказ=Истина;
	КонецЕСли;	
КонецПроцедуры

	
