﻿
// ПРЕДОПРЕДЕЛЕННЫЕ ФУНКЦИИ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Проведение
	
	ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	
	// Запись
	
	Движения.Записать();
	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипЗнч = ТипЗнч(ДанныеЗаполнения);
	
	Если 	ТипЗнч = Тип("ДокументСсылка.УстановкаЦенНоменклатуры") Или 
			ТипЗнч = Тип("ДокументСсылка.УстановкаЦенНоменклатурыКонкурентов") Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗЛИЧНЫЕ Номенклатура
		|ИЗ 	Документ." + ДанныеЗаполнения.Метаданные().Имя + ".Товары
		|ГДЕ	Ссылка = &Ссылка
		|");
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		Товары.Загрузить(Запрос.Выполнить().Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры
