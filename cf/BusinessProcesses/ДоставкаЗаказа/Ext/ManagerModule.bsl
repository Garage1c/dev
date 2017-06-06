﻿
Процедура ЗаполнитьФормуПоБП(Форма, СсылкаПроцесс, СсылкаЗадача = Неопределено) Экспорт
	ЗаполнитьЗначенияСвойств(Форма,СсылкаПроцесс,"Заказ,ДокументОтгрузки");
	Если ЗначениеЗаполнено(СсылкаПроцесс.ДокументОтгрузки) Тогда
		Форма.Товары.Загрузить(СсылкаПроцесс.ДокументОтгрузки.Товары.Выгрузить());
	КонецЕсли;
	
	Форма.СкладЯчеестый = СсылкаПроцесс.Склад.Ячеестый;
КонецПроцедуры

Функция ПолучитьЗаголовокБП(СсылкаПроцесс) Экспорт
	
	Если СсылкаПроцесс.Пустая() Тогда
		
		Возврат "Создание";
		
	Иначе
		
		Если СсылкаПроцесс.Заказ.Пустая() Тогда
			
			Возврат Строка(СсылкаПроцесс);
			
		Иначе
			
			расшЗаказа = "";
			Если ТипЗнч(СсылкаПроцесс.Заказ) = Тип("ДокументСсылка.ИнтернетЗаказПокупателя") Тогда
				расшЗаказа = "интернет ";
			ИначеЕсли ТипЗнч(СсылкаПроцесс.Заказ) = Тип("ДокументСсылка.ВнутреннийЗаказ") Тогда
				расшЗаказа = "внутреннего ";
			КонецЕсли;
			
			Возврат "Доставка " + расшЗаказа + "заказа № " + СсылкаПроцесс.Заказ.Номер + " от " + СсылкаПроцесс.Заказ.Дата + " БП(" + СсылкаПроцесс.Номер + ")";
				
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция СоздатьНовыйБП(Заказ,ДокументОтгрузки) Экспорт
	НовБП = БизнесПроцессы.ДоставкаЗаказа.СоздатьБизнесПроцесс();
	НовБП.Дата = ТекущаяДата();
	НовБП.Заказ = Заказ;
	НовБП.Склад = Заказ.Склад;
	НовБП.ДокументОтгрузки = ДокументОтгрузки;
	Если НЕ ОбщиеФункции.СтартоватьБПИСообщитьЕслиОшибка(НовБП) Тогда
		Возврат Ложь;
	КонецЕсли;
	Если НЕ Заказы.УстановитьСостояниеДокументаОтгрузки(ДокументОтгрузки,"Отгружен") Тогда
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции