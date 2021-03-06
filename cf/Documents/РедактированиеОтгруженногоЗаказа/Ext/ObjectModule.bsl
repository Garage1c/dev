﻿Функция ПолучитьТекстЗапросаПолученияСпискаТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура
	|ИЗ
	|	Документ.РедактированиеОтгруженногоЗаказа.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НоменклатураБыло
	|ИЗ
	|	Документ.РедактированиеОтгруженногоЗаказа.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка
	|";
	
КонецФункции


// ПРЕДОПРЕДЕЛЕННЫЕ ФУНКЦИИ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Последовательности
	
	//avdonin {{12.09.2010#
	//
	ПроведенияДокументов.ПоследовательностьОстаткиТоваров(ДополнительныеСвойства, ПринадлежностьПоследовательностям, Отказ);
	//}}avdonin
	
	// Проведение
	
	ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	
	// Запись
	
	Движения.Записать();
	
		
	//avdonin {{21.09.2010#
	//
	Если НЕ РежимПроведения = РежимПроведенияДокумента.Оперативный Тогда
		КонтрольПроведения.ПроверитьТоварыНаСкладахНЕОперативно(ЭтотОбъект, Отказ, Заголовок);
	КонецЕсли;
	//}}avdonin
		
	//КонецЕсли;
		
КонецПроцедуры
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка

	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриОтменеПроведенияДокумента(Ссылка);
	
	//avdonin {{12.09.2010#
	// надо опять инициализировать доп. свойства для контроля остатка (чтобы тянуть информацию только по тем остаткам, которые изменялись)
	// в контроле по идее имеет смысл указывать, что это отмена проведения или передавать движения
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	//}}avdonin
	
	// Последовательности
	
	//avdonin {{12.09.2010#
	// последний параметр - признак отмены проведения
	ПроведенияДокументов.ПоследовательностьОстаткиТоваров(ДополнительныеСвойства, ПринадлежностьПоследовательностям, Отказ, Истина);
	//}}avdonin
	
	// Запись
	
	Движения.ТоварыНаСкладах.Очистить();
	Движения.Записать();
	
	// Контроль
	
		
КонецПроцедуры

