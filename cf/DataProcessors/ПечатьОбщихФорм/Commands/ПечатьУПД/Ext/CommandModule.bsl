﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Новый ТабличныйДокумент;
	стрНомера = "";
	ДополнительныеПараметры = Новый Массив;
	Печать(ТабДок, ПараметрКоманды, ДополнительныеПараметры, стрНомера);
	ФункцииФормДокументов.УстановитьНастройкиТабличногоДокумента(ТабДок);
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ДвусторонняяПечать = ТипДвустороннейПечати.ПереворотВверх;
	ОткрытьФорму("ОбщаяФорма.ТабличныйДокумент", Новый Структура("ТабличныйДокумент, ИмяФайла, ДополнительныеПараметры", ТабДок, СтрНомера, ДополнительныеПараметры),ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды, ДополнительныеПараметры, стрНомера)
	
	Инд = -1;
	Для Каждого Ссылка Из ПараметрКоманды Цикл 
		Инд = Инд + 1; 
		Если Инд Тогда 
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц(); 
		КонецЕсли;
		
		Если ТипЗнч(Ссылка) = Тип("БизнесПроцессСсылка.СборкаЗаказа") Тогда
				СсылкаДок = Ссылка.РеализацияТоваров;
		Иначе 	СсылкаДок = Ссылка; 
		КонецЕсли;
		
		СтрНомера = СтрНомера + ?(СтрНомера = "","","_") + СсылкаДок.Номер;
		Попытка
			ДополнительныеПараметры.Добавить(Новый Структура("Партнер", Ссылка.Партнер));
		Исключение
			ДополнительныеПараметры.Добавить(Новый Структура("Партнер", Справочники.Партнеры.ПустаяСсылка()));
		КонецПопытки;
		
		Обработки.ПечатьОбщихФорм.Печать_УПД(ТабДок, Ссылка); 
	КонецЦикла;
		
КонецПроцедуры


