﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	РаботаСКонтрагентами.УстановитьСтатусСпецификации(ПараметрКоманды, 
														ПредопределенноеЗначение("Перечисление.СтатусыСпецификаций.Закрыта"));
														
	Оповестить("ИзмененСтатус", , ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры
