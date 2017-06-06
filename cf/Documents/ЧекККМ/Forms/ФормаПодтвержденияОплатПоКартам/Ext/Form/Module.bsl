﻿ 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьСписок();
КонецПроцедуры

Процедура ЗаполнитьСписок(Фильтр = Неопределено)
	
	Запрос = Новый Запрос();
	
	стрУсловия = "";
	Если Фильтр <> Неопределено Тогда
		Для Каждого Элемент Из Фильтр Цикл Параметр =  Элемент.Ключ;

			стрУсловия = стрУсловия + ?(стрУсловия = ""," ГДЕ "," И ") + Параметр + " = &" + Параметр;
			Запрос.УстановитьПараметр(Параметр, Элемент.Значение);

		КонецЦикла;
	КонецЕсли;

	Запрос.Текст = "ВЫБРАТЬ
		|  	ДокументОплаты 			ДокументОтгрузки,
		|	ДокументОплаты.Касса 	Касса,
		|	ДокументОплаты.Дата		Дата,
		|	ВЫБОР КОГДА ВидОперации = &Возврат ТОГДА -СуммаОстаток ИНАЧЕ СуммаОстаток КОНЕЦ Сумма
		|
		|ИЗ
		|	РегистрНакопления.ОплатыПоБанковскимКартам.Остатки(&Дата)" + стрУсловия + "
		|УПОРЯДОЧИТЬ ПО ДокументОплаты.Дата";
	Запрос.УстановитьПараметр("Дата", Параметры.ДатаВыборки);
	Запрос.УстановитьПараметр("Возврат", Перечисления.ВидыОперацийЧекККМ.Возврат);
	Список.Загрузить(Запрос.Выполнить().Выгрузить());
	         
КонецПроцедуры

Функция ПолучитьВыбранныеЧеки()
	
	НовТабл = Список.Выгрузить();
	НовТабл.Очистить();
	
	Строки = Список.НайтиСтроки(Новый Структура("Подтвердить", Истина));
	
	Для Каждого Строка Из Строки Цикл
		ЗаполнитьЗначенияСвойств(НовТабл.Добавить(), Строка);
	КонецЦикла;
	
	Если НовТабл.Количество() Тогда
		Возврат ЗначениеВСтрокуВнутр(НовТабл);
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции	

&НаКлиенте
Процедура Подвердить(Команда)
	Закрыть(ПолучитьВыбранныеЧеки());
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	     
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		ТекущиеДанные.Подтвердить = Истина;
		Закрыть(ПолучитьВыбранныеЧеки());
		Возврат;
	КонецЕсли;
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СуммаОплаты = ВладелецФормы.Объект.Сумма;
КонецПроцедуры

&НаСервере
Процедура РасчитатьСуммуПодтверженных()
	
	ВремТаблица = Список.Выгрузить(, "Подтвердить, Сумма");
	ВремТаблица.Свернуть("Подтвердить", "Сумма");
	Строки = ВремТаблица.НайтиСтроки(Новый Структура("Подтвердить", Истина));
	ПодтвержденоНаСумму = ?(Строки.Количество(), Строки[0].Сумма, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПодвердитьПриИзменении(Элемент)
	РасчитатьСуммуПодтверженных();
КонецПроцедуры
