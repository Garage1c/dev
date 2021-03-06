﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Проведение
	
	Если Не Отказ Тогда
		ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;
	
	// Запись
	
	Движения.Записать();
	
	// Контроль
	// ...

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если 	Сумма И
			РасшифровкаСуммы.Количество() И 
			(РасшифровкаСуммы.Итог("Сумма") <> Сумма ИЛИ РасшифровкаСуммы.Итог("СуммаУпр") <> СуммаУпр) Тогда
			
		ОбщиеФункции.СообщитьТекст("Сумма документа не совпадает с суммой расшифровки по документам!");
		Отказ = Истина;
			
	КонецЕсли;
	Если 	СуммаДопрасходов И
			РасшифровкаСуммы.Количество() И 
			РасшифровкаСуммы.Итог("СуммаДопрасхода") <> СуммаДопрасходов Тогда
			
		ОбщиеФункции.СообщитьТекст("Сумма допрасходов документа не совпадает с суммой расшифровки допрасходов по документам!");
		Отказ = Истина;
			
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
		
КонецПроцедуры
