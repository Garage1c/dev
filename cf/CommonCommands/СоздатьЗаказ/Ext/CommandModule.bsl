﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
		
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		Структура = Новый Структура("Контрагент", ПараметрКоманды);
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
		
	ОткрытьФорму("БизнесПроцесс.ЗаявкаПокупателя.ФормаОбъекта", Структура, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
