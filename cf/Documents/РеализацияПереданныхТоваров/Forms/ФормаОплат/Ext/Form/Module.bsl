﻿
&НаКлиенте
Процедура ЗаполнитьАванс(Команда)
	ЗаполнитьДокументыОплатыНаСервере();
КонецПроцедуры
&НаСервере
Функция ЗаполнитьДокументыОплатыНаСервере()
	
	ДокФантом = Документы.РеализацияПереданныхТоваров.СоздатьДокумент();
	ЗаполнитьЗначенияСвойств(ДокФантом, Ссылка);
	ДокФантом.ЗаполнитьДокументыОплаты(Ссылка);
	
	ДокументыОплаты.ЗагрузитьЗначения(ДокФантом.ПлатежныеДокументы.Выгрузить().ВыгрузитьКолонку("ДокументОплаты"));
	Модифицированность = Истина;
	
КонецФункции

&НаКлиенте
Процедура ДокументыОплатыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбПлатежка = ОткрытьФорму("Документ.ПлатежноеПоручениеВходящее.ФормаВыбора",Новый Структура("Организация, Контрагент",Организация, Контрагент),ЭтаФорма,,,,Новый ОписаниеОповещения("_ОбработкаВыбораДокаОплаты",ЭтаФорма,),);				
КонецПроцедуры

&НаКлиенте
Процедура _ОбработкаВыбораДокаОплаты(Результат, Параметры) Экспорт
	Если ДокументыОплаты.НайтиПоЗначению(Результат) = Неопределено Тогда
		ДокументыОплаты.Добавить(Результат);
		Модифицированность = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ВладелецФормы.Объект);
	ДокументыОплаты.ЗагрузитьЗначения(ВладелецФормы.ДокументыОплаты.ВыгрузитьЗначения());
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
		// данные записаны корректно, закрываем форму
	Если Модифицированность И СохранитьИзменения() Тогда
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СохранитьИзменения()
	
	УстановитьПривилегированныйРежим(Истина);
	
	// пишем в реализацию
	
    Источник = Ссылка.ПолучитьОбъект();
	Источник.ПлатежныеДокументы.Очистить();
	КонвертацияТипов.ЗагрузитьСписокЗначенийВТаблицу(Источник.ПлатежныеДокументы, ДокументыОплаты, "ДокументОплаты");
	
	Попытка
		Источник.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Сообщить("Ошибка сохранения данных");
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;	
КонецФункции


