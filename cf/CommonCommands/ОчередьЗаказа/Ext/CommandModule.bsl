﻿
&НаСервере
Функция ПолучитьЗаказ(Ссылка)
	
	Если Метаданные.БизнесПроцессы.Содержит(Ссылка.Метаданные()) Тогда
		
		Возврат Ссылка.Заказ;
		
	Иначе
		
		Возврат Ссылка;
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("ОбщаяФорма.ОчередьЗаказа", 
		Новый Структура("Заказ", ПолучитьЗаказ(ПараметрКоманды)),
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
