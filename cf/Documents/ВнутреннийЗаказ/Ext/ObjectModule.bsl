﻿Функция ПолучитьТекстЗапросаПолученияСпискаТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура
	|ИЗ
	|	Документ.ВнутреннийЗаказ.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка
	|";
	
КонецФункции
Функция ПолучитьТекстЗапросаПолученияСпискаРезервируемыхТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура
	|ИЗ
	|	Документ.ВнутреннийЗаказ.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка И
	|	ЕСТЬNULL(Размещение, &ПустойСклад) <> &ПустойСклад
	|";
	
КонецФункции
Функция ПолучитьСкладСписания() Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// ПРЕДОПРЕДЕЛЕННЫЕ ФУНКЦИИ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Проведение
	
	ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	
	// Запись
	
	Движения.Записать();
	
	// Контроль
	
	КонтрольПроведения.ПроверитьТоварыНаСкладах(ЭтотОбъект,, Отказ, Заголовок);
	//КонтрольПроведения.ПроверитьВнутреннииЗаказы(ЭтотОбъект, Отказ, Заголовок);
	КонтрольПроведения.ПроверитьПоВсемРегистрам(ЭтотОбъект, Отказ, Заголовок);

КонецПроцедуры
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка

	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриОтменеПроведенияДокумента(Ссылка);
	
	// Запись
	
	Движения.ТоварыВРезерве.Очистить();
	Движения.Записать();
	
	// Контроль
	
	КонтрольПроведения.ПроверитьТоварыВРезерве(ЭтотОбъект, , Отказ, Заголовок);
	КонтрольПроведения.ПроверитьВнутреннииЗаказы(ЭтотОбъект, Отказ, Заголовок);
		
КонецПроцедуры


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Инд = ПроверяемыеРеквизиты.Найти("Организация");
	
	Если Инд Тогда
		ПроверяемыеРеквизиты.Удалить(Инд);
	КонецЕсли;
	
	Если Не ОснованиеВыдачиИнструмента.Пустая() Тогда
		ПроверяемыеРеквизиты.Добавить("Статус");
	КонецЕсли;
КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипЗнч = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипЗнч = Тип("ДокументСсылка.ПоступлениеТоваров") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Номер 	= "";
		Дата 	= '00010101';
		
		Товары.Загрузить(ДанныеЗаполнения.Товары.Выгрузить());
		
	ИначеЕсли ТипЗнч = Тип("Структура") Тогда
		
		КонвертацияТипов.ЗаполнитьОбъектПоСтруктуреОснованию(ЭтотОбъект, ДанныеЗаполнения); КонецЕсли;
	
КонецПроцедуры


Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	стрОшибки = "";
	Если ТипЗнч(Заказчик) = Тип("СправочникСсылка.Склады") И Заказчик.ПередачаТовараМВЗ Тогда
		
		Контрагент = Заказчик.Контрагент;
		Если НЕ Заказы.ТоварыРазрешеныКПередаче(Ссылка, "ВнутреннийЗаказ", стрОшибки, , Контрагент) Тогда
			Отказ = Истина;
			ОбщиеФункции.СообщитьТекст(стрОшибки);
		КонецЕсли;
	КонецЕсли;

	
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	Если ЗакупитьНедостающее <> Ссылка.ЗакупитьНедостающее Тогда
		
		Если НЕ ЗакупитьНедостающее Тогда ДатаОтправкиВЗакупку = '00010101'; 
		Иначе ДатаОтправкиВЗакупку = ТекущаяДата() КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

