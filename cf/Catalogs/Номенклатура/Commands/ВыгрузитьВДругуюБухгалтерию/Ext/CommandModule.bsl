﻿
&НаСервере
Функция ПолучитьСсылкиНоменклатуры(Ссылки);
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ Ссылка ИЗ Справочник.Номенклатура ГДЕ Ссылка В ИЕРАРХИИ(&Ссылки) И НЕ ПометкаУдаления");
	Запрос.УстановитьПараметр("Ссылки", Ссылки);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИнтеграцияСБухгалтерией.ВыгрузитьОбъектыВДругуюБухгалтерию(ПолучитьСсылкиНоменклатуры(ПараметрКоманды));
	
КонецПроцедуры
