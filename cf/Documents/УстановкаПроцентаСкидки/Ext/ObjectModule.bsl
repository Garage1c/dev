﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
										 
	// Проведение
	
	ПроведенияДокументов.СкидкиПоЦеновымГруппам(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись
	
	Движения.Записать();

КонецПроцедуры
