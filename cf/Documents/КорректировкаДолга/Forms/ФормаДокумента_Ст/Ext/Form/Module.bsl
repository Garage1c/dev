﻿
&НаКлиенте
Процедура ОбщиеРеквизиты(Команда)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизиты(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	Элементы.СтраницаВручную.Видимость 	= Не ПоПартнеруСписком;
	Элементы.СтраницаСписком.Видимость 	= ПоПартнеруСписком;
	Элементы.ГруппаПартнера.Видимость 	= ПоПартнеруСписком;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИтоги()
	
	Сумма 			= ВзаиморасчетыПартнера.Итог("Сумма");	
	СуммаУпр	 	= ВзаиморасчетыПартнера.Итог("СуммаУпр");	
	Результат 		= ВзаиморасчетыПартнера.Итог("Результат");	
	РезультатУпр 	= ВзаиморасчетыПартнера.Итог("РезультатУпр");	
	
КонецПроцедуры 

#Область Типовые

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Заполним по умолчанию
	
	Если Объект.Ссылка.Пустая() Тогда ФункцииФормДокументов.ЗаполнитьЗначенияПоУмолчанию(ЭтаФорма, ЭтаФорма.Элементы) КонецЕсли;
	
	ПоПартнеруСписком = Объект.ПоПартнеруСписком;
	ВзаиморасчетыПартнера.Загрузить(Объект.ПоПартнеру.Выгрузить());
	ОбновитьВзаиморасчетыПартнера();
	
	// Видимость
	
	УправлениеВидимостьюДоступностью();
					
КонецПроцедуры
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Запустим в фоне определения долга
	
	ОбновитьИтоги();
	ОбновитьИнформациюОДолге();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ПоПартнеруСписком = ПоПартнеруСписком;
	
	ТекущийОбъект.ПоПартнеру.Очистить();
	Если ПоПартнеруСписком Тогда
		Для Каждого Строка ИЗ ВзаиморасчетыПартнера Цикл ЗаполнитьЗначенияСвойств(ТекущийОбъект.ПоПартнеру.Добавить(), Строка) КонецЦикла;КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область Поток

&НаСервере
Функция ИнформацияПоДолгуПолучена()
	
	СтруктураДолга = ПолучитьИзВременногоХранилища(АдресИнфДолга);
	Если СтруктураДолга = Неопределено Тогда
		Возврат Ложь;
		
	Иначе
		
		Если СтруктураДолга.Состояние = Поток.СостояниеВыполнено() Тогда
			
			ИнфСтр1 = СтруктураДолга.Результат.Инф1;
			ИнфСтр2 = СтруктураДолга.Результат.Инф2;
			ИнфСтр3 = СтруктураДолга.Результат.Инф3; 
			
			// Заполним предыдущий долг конрагента пока документ не будет проведен
			Если Не Объект.Проведен Тогда Объект.ДолгДоКорректировки = СтруктураДолга.Результат.Сумма КонецЕсли;
			
			Элементы.ГруппаИнфоТовара.Видимость = Истина;
			
		ИначеЕсли СтруктураДолга.Состояние = Поток.СостояниеОшибка() Тогда
			
			ОбщиеФункции.СообщитьТекст(СтруктураДолга.стрОшибки); КонецЕсли;
		
		Возврат Истина; КонецЕсли;
	
КонецФункции
&НаКлиенте
Процедура ПолучитьИнфОДолгеПостоянно()
	
	Если ИнформацияПоДолгуПолучена() Тогда
		ОтключитьОбработчикОжидания("ПолучитьИнфОДолгеПостоянно"); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ПолучитьИнфОДолге()
	
	Если Не ИнформацияПоДолгуПолучена() Тогда
		ПодключитьОбработчикОжидания("ПолучитьИнфОДолгеПостоянно", 1) КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ОбновитьИнформациюОДолге()
	
	CRMКлиент.ИнформацияОДолгеНачало(ИнфСтр1, ИнфСтр2, ИнфСтр3);
	
	АдресИнфДолга = Поток.СобратьИнформациюОДолгеВФоне(Объект.Организация, Объект.Контрагент, УникальныйИдентификатор, Объект.ФормаОтношений);
	ПодключитьОбработчикОжидания("ПолучитьИнфОДолге", 0.1, Истина);
	
КонецПроцедуры
&НаКлиенте
Процедура ИнфСтрОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	CRMКлиент.ОбработатьНавигационнуюСсылку(НавигационнаяСсылка, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Реквизиты

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере() Экспорт
	
	ФункцииФормДокументов.ОрганизацияПриИзменении(Объект);

КонецПроцедуры
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	
	ОрганизацияПриИзмененииНаСервере();
	ОбновитьИнформациюОДолге();
	
КонецПроцедуры
&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
	
	ФункцииФормДокументов.КонтрагентПриИзменении(Объект);
	
КонецПроцедуры
&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПриИзмененииНаСервере();
	ОбновитьИнформациюОДолге();
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаОтношенийПриИзменении(Элемент)
	
	ОбновитьИнформациюОДолге();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПартнеруСпискомПриИзменении(Элемент)
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры



#КонецОбласти

#Область Работа_со_списком

&НаСервере
Процедура ОбновитьВзаиморасчетыПартнера()
	
	// Соединяем что в таблице с остаткми в базе и выводим результат
	
	Запрос = Новый Запрос(СтрШаблон("
	|ВЫБРАТЬ Табл.Контрагент, Табл.Организация, Табл.ФормаОтношений, Табл.Сумма, Табл.СуммаУпр ПОМЕСТИТЬ ТаблДока ИЗ &ТаблицаДока КАК Табл;
	|ВЫБРАТЬ 
	|	ЕСТЬNULL(Док.Контрагент, 		Рег.Контрагент) 	Контрагент, 
	|	ЕСТЬNULL(Док.Организация, 		Рег.Организация) 	Организация,
	|	ЕСТЬNULL(Док.ФормаОтношений, 	Рег.ФормаОтношений) ФормаОтношений, 
	|	ЕСТЬNULL(СуммаОстаток, 0) 		Остаток, 
	|	ЕСТЬNULL(СуммаУпрОстаток, 0) 	ОстатокУпр,
	|	ЕСТЬNULL(Док.Сумма, 0) 			Сумма, 
	|	ЕСТЬNULL(Док.СуммаУпр, 0),		СуммаУпр,
	|	ЕСТЬNULL(СуммаОстаток, 0) + ЕСТЬNULL(Док.Сумма, 0) 			Результат,
	|	ЕСТЬNULL(СуммаУпрОстаток, 0) + ЕСТЬNULL(Док.СуммаУпр, 0) 	РезультатУпр
	|ИЗ 
	|	РегистрНакопления.Взаиморасчеты.Остатки(%1, Партнер = &Партнер) Рег
	|
	|ПОЛНОЕ СОЕДИНЕНИЕ
	|	ТаблДока Док
	|ПО
	|	Док.Контрагент 		= Рег.Контрагент И
	|	Док.Организация 	= Рег.Организация И
	|	Док.ФормаОтношений 	= Рег.ФормаОтношений
	|", ?(Объект.Ссылка.Пустая(), "", "&ДатаДок")));
	
	Запрос.УстановитьПараметр("ДатаДок", 		Объект.Дата);
	Запрос.УстановитьПараметр("Партнер", 		Объект.Партнер);
	Запрос.УстановитьПараметр("ТаблицаДока", 	ВзаиморасчетыПартнера.Выгрузить());
	
	
	ВзаиморасчетыПартнера.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	ВзаиморасчетыПартнера.Очистить();
	ОбновитьВзаиморасчетыПартнера();
	
КонецПроцедуры

&НаКлиенте
Процедура ВзаиморасчетыПартнераСуммаПриИзменении(Элемент)
	
	текДанные = Элементы.ВзаиморасчетыПартнера.ТекущиеДанные;
	Если текДанные <> Неопределено Тогда
		текДанные.Результат = текДанные.Остаток + текДанные.Сумма;
		ОбновитьИтоги(); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ВзаиморасчетыПартнераРезультатСуммаПриИзменении(Элемент)
	
	текДанные = Элементы.ВзаиморасчетыПартнера.ТекущиеДанные;
	Если текДанные <> Неопределено Тогда
		текДанные.Сумма = текДанные.Результат - текДанные.Остаток;
		ОбновитьИтоги(); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ВзаиморасчетыПартнераСуммаУпрПриИзменении(Элемент)
	
	текДанные = Элементы.ВзаиморасчетыПартнера.ТекущиеДанные;
	Если текДанные <> Неопределено Тогда
		текДанные.РезультатУпр = текДанные.ОстатокУпр + текДанные.СуммаУпр;
		ОбновитьИтоги(); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ВзаиморасчетыПартнераРезультатСуммаУпрПриИзменении(Элемент)
	
	текДанные = Элементы.ВзаиморасчетыПартнера.ТекущиеДанные;
	Если текДанные <> Неопределено Тогда
		текДанные.СуммаУпр = текДанные.РезультатУпр - текДанные.ОстатокУпр; 
		ОбновитьИтоги(); КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Взаиморасчеты(Команда)
	
	ОткрытьФорму("Отчет.Взаиморасчеты.ФормаОбъекта", Новый Структура("СформироватьПриОткрытии, Отбор", Истина, Новый Структура("Партнер", Объект.Партнер)), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Обнулить(Команда)
	
	Для Каждого Строка ИЗ ВзаиморасчетыПартнера Цикл 
		Строка.Результат = 0; 		Строка.Сумма = Строка.Остаток * -1;
		Строка.РезультатУпр = 0; 	Строка.СуммаУпр = Строка.ОстатокУпр * -1; КонецЦикла;
	
	ОбновитьИтоги();
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьВзаиморасчетыПартнера();
	ОбновитьИтоги();
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ОбновитьВзаиморасчетыПартнера();
	ОбновитьИтоги();
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти