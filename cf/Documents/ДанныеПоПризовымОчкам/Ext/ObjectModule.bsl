﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
		
	
	ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	
	// Запись
	
	Движения.Записать();
	
	//КонтрольПроведения.ПроверитьПоВсемРегистрам(ЭтотОбъект, Отказ, Заголовок);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Подразделение = Автор.Подразделение;
	Отдел = Автор.Отдел;
КонецПроцедуры
