﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок 					= Новый ТабличныйДокумент;
	СтрНомера 				= "";
	ДополнительныеПараметры = Новый Массив;
	Печать(ТабДок, ПараметрКоманды, ДополнительныеПараметры, СтрНомера);

	ФункцииФормДокументов.УстановитьНастройкиТабличногоДокумента(ТабДок);
	
	ТабДок.АвтоМасштаб = Истина;
	
	ОткрытьФорму("ОбщаяФорма.ТабличныйДокумент", Новый Структура("ТабличныйДокумент, ИмяФайла, ДополнительныеПараметры", ТабДок, СтрНомера, ДополнительныеПараметры),ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды, ДополнительныеПараметры, стрНомера)
	
	Инд = -1;
	Для Каждого Ссылка Из ПараметрКоманды Цикл Инд = Инд + 1; Если Инд Тогда ТабДок.ВывестиГоризонтальныйРазделительСтраниц(); КонецЕсли;
		
		Если ТипЗнч(Ссылка) = Тип("БизнесПроцессСсылка.СборкаЗаказа") Тогда СсылкаДок = Ссылка.РеализацияТоваров;
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.РеализацияТоваров") Тогда СсылкаДок = Ссылка; Иначе Продолжить КонецЕсли;
		
		СтрНомера = СтрНомера + ?(СтрНомера = "","","_") + СсылкаДок.Номер;
		ДополнительныеПараметры.Добавить(Новый Структура("Партнер", Ссылка.Партнер));
			
		Документы.РеализацияПереданныхТоваров.Печать_РеализацияТоваров(ТабДок, Ссылка); КонецЦикла;
	
КонецПроцедуры
