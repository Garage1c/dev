﻿&НаКлиенте
Перем Изменения;
&НаКлиенте
Процедура ЗаполнитьАванс(Команда)
	ЗаполнитьДокументыОплатыНаСервере();
КонецПроцедуры
&НаСервере
Функция ЗаполнитьДокументыОплатыНаСервере()
	
	ДокФантом = Документы.РеализацияТоваров.СоздатьДокумент();
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
	Изменения = Новый Структура;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ВладелецФормы.Объект);
	ДокументыОплаты.ЗагрузитьЗначения(ВладелецФормы.ДокументыОплаты.ВыгрузитьЗначения());
	Ссылка = ВладелецФормы.Объект.Ссылка;
	Элементы.ДанныеПечати.Видимость = НачалоДня(ТекущаяДата()) = НачалоДня(ВладелецФормы.Объект.Дата);
	
	Грузоотправитель = ВладелецФормы.Объект.Грузоотправитель;
	Грузополучатель  = ВладелецФормы.Объект.Грузополучатель;
	
	БанковскийСчетГрузоотправителя = ВладелецФормы.Объект.БанковскийСчетГрузоотправителя;
	БанковскийСчетГрузополучателя  = ВладелецФормы.Объект.БанковскийСчетГрузополучателя;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
		// данные записаны корректно, закрываем форму
	Если Модифицированность И СохранитьИзменения(Изменения) Тогда
		ВладелецФормы.Прочитать();
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СохранитьИзменения(Изменения = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	// пишем в реализацию
	
    Источник = Ссылка.ПолучитьОбъект();
	Источник.ПлатежныеДокументы.Очистить();
	КонвертацияТипов.ЗагрузитьСписокЗначенийВТаблицу(Источник.ПлатежныеДокументы, ДокументыОплаты, "ДокументОплаты");
	
	Если Изменения <> Неопределено Тогда
		Для Каждого Строка ИЗ Изменения Цикл
			Попытка
				Источник[Строка.Ключ] = Строка.Значение.НовоеЗначение;
			Исключение 
				Продолжить; КонецПопытки; КонецЦикла;	
	КонецЕсли;
	
	Попытка
		Источник.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Сообщить("Ошибка сохранения данных");
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;	
КонецФункции

&НаСервере
Функция ПолучитьОписаниеТиповДокументОплат()
	
	Возврат Метаданные.Документы.РеализацияТоваров.ТабличныеЧасти.ПлатежныеДокументы.Реквизиты.ДокументОплаты.Тип;
	
КонецФункции

&НаКлиенте
Процедура ДокументыОплатыОткрытие(Элемент, СтандартнаяОбработка)
	Перем ВыбЗначение;
	
	СтандартнаяОбработка = Ложь;
	
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ОбработкаВыбораДокаОплаты", ЭтаФорма), ВыбЗначение, "Выбор типа документа", ПолучитьОписаниеТиповДокументОплат());

КонецПроцедуры

Процедура ОбработкаВыбораДокаОплаты(Результат, Параметры) Экспорт							
	Если ДокументыОплаты.НайтиПоЗначению(Результат) = Неопределено Тогда
		ДокументыОплаты.Добавить(Результат);
		Модифицированность = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ГрузоотправительПриИзмененииНаСервере()
	Возврат ФункцииФормДокументов.ГрузоотправительПриИзменении(ЭтаФорма);
КонецФункции
&НаСервере
Функция ГрузополучательПриИзмененииНаСервере()
	Возврат ФункцииФормДокументов.ГрузополучательПриИзменении(ЭтаФорма);
КонецФункции

&НаКлиенте
Процедура ГрузоотправительПриИзменении(Элемент)
	СтруктураРеквизитов = ГрузоотправительПриИзмененииНаСервере();
	ЭлементПриИзменении(Элемент.Имя);
	
	Для Каждого Строка ИЗ СтруктураРеквизитов Цикл
		ЭлементПриИзменении(Строка.Ключ);
	КонецЦикла;

КонецПроцедуры
&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	СтруктураРеквизитов = ГрузополучательПриИзмененииНаСервере();
	ЭлементПриИзменении(Элемент.Имя);

	Для Каждого Строка ИЗ СтруктураРеквизитов Цикл
		ЭлементПриИзменении(Строка.Ключ);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетПартнераПриИзменении(Элемент)
	ЭлементПриИзменении(Элемент.Имя);
КонецПроцедуры
&НаКлиенте
Процедура БанковскийСчетГрузоотправителяПриИзменении(Элемент)
	ЭлементПриИзменении(Элемент.Имя);
КонецПроцедуры
&НаКлиенте
Процедура БанковскийСчетГрузополучателяПриИзменении(Элемент)
	ЭлементПриИзменении(Элемент.Имя);
КонецПроцедуры
&НаКлиенте
Процедура ЭлементПриИзменении(Имя)
	
	Источник = ВладелецФормы.Объект;
	
	Попытка
		Значение = Источник[Имя];
		НовоеЗначение = ЭтаФорма[Имя];
	Исключение
		Возврат;
	КонецПопытки;

	Если Значение <> НовоеЗначение Тогда
		Изменения.Вставить(Имя, Новый Структура("Значение, НовоеЗначение, Ответственный", Значение, НовоеЗначение, ОтветственныйЗаИзменения));
	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Грузоотправитель"));
	Элементы.БанковскийСчетГрузоотправителя.СвязиПараметровВыбора = Новый ФиксированныйМассив(НовыйМассив);
	
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Грузополучатель"));
	Элементы.БанковскийСчетГрузополучателя.СвязиПараметровВыбора = Новый ФиксированныйМассив(НовыйМассив);

	
КонецПроцедуры
