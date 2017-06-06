﻿
Функция ПолучитьТекстЗапросаПолученияСпискаТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура
	|ИЗ
	|	Документ.СборочныйЛист.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка
	|";
	
КонецФункции

Функция ПолучитьТекстЗапросаПолученияСпискаРезервируемыхТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура
	|ИЗ
	|	Документ.СборочныйЛист.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка
	|";
	
КонецФункции


// ПРЕДОПРЕДЕЛЕННЫЕ ФУНКЦИИ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Проведение
	
	ПроведенияДокументов.ПровестиПоВсемРегистрам(
									Метаданные().Движения, 
									ДополнительныеСвойства, 
									Движения, 
									Отказ);
	// Запись
	
	Движения.Записать();
	
	// Контроль
	
	//КонтрольПроведения.ПроверитьТоварыНаСкладах(ЭтотОбъект,, Отказ, Заголовок, Заказ);
	
	КонтрольПроведения.ПроверитьТоварыВРезерве(ЭтотОбъект,, Отказ, Заголовок, Заказ);
	
	КонтрольПроведения.ПроверитьТоварыВРезервеМинусСобрано(ЭтотОбъект, Заказ, Отказ, Заголовок);
	
	КонтрольПроведения.ПроверитьСборкуЗаказа(
			ЭтотОбъект, 
			Отказ,
			Заголовок,
			Заказ);
	
	Если Склад.Ячеестый Тогда
		
		КонтрольПроведения.ПроверитьТоварыВЯчейках(
			ЭтотОбъект, 
			Склад,
			Отказ,
			Заголовок);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанных = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанных = Тип("Структура") Тогда
		КонвертацияТипов.ЗаполнитьОбъектПоСтруктуреОснованию(ЭтотОбъект, ДанныеЗаполнения); КонецЕсли;
	
КонецПроцедуры



