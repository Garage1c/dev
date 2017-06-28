﻿
&НаСервере
Функция ПолучитьПараметры(ПараметрКоманды)
	
	Имя = ПараметрКоманды.Метаданные().Имя;
	
	Если Имя = "Контрагенты" Тогда
		
		Возврат Новый Структура("Контрагент", ПараметрКоманды);
		
	ИначеЕсли Имя = "ЗаявкаПокупателя" Или Имя = "ИнтернетЗаявка" Тогда
		
		Возврат Новый Структура("Организация, Контрагент", ПараметрКоманды.Заказ.Организация, ПараметрКоманды.Заказ.Контрагент);
		
	Иначе
		
		Возврат Новый Структура("Организация, Контрагент", ПараметрКоманды.Организация, ПараметрКоманды.Контрагент);
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = ПолучитьПараметры(ПараметрКоманды);
	
	ОткрытьФорму(	"Обработка.ДолгиПоОплате_Управление.Форма.Управление", 
					ПараметрыФормы, 
					ПараметрыВыполненияКоманды.Источник, 
					ПараметрыВыполненияКоманды.Уникальность, 
					ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
