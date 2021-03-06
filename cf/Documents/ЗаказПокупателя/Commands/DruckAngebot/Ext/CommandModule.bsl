﻿
&НаСервере
Функция ПолучитьПараметрыДляТабличногоДокумента(Ссылки, СтрНомер)
	
	Возврат Заказы.ПолучитьПараметрыДляТабличногоДокумента(Ссылки, СтрНомер);
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Новый ТабличныйДокумент;
	Печать(ТабДок, ПараметрКоманды);

	ФункцииФормДокументов.УстановитьНастройкиТабличногоДокумента(ТабДок);
	
	ТабДок.ДвусторонняяПечать = ТипДвустороннейПечати.ПереворотВлево;
	//ТабДок.АвтоМасштаб = Истина;
	
	СтрНомера = "";
	ДополнительныеПараметры = ПолучитьПараметрыДляТабличногоДокумента(ПараметрКоманды, СтрНомера);
	ОткрытьФорму("ОбщаяФорма.ТабличныйДокумент", Новый Структура("ТабличныйДокумент, ИмяФайла, ДополнительныеПараметры", ТабДок, СтрНомера, ДополнительныеПараметры),ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды)
	
	Макет 		= Документы.ЗаказПокупателя.ПолучитьМакет("НовыйЗаказНем");
	Структура 	= Новый Структура("Шапка, ШапкаТаблицы, Строка_1, Строка_2, ПодвалСтроки, ПодвалТаблицы, НадписьВПодвале",
							Макет.ПолучитьОбласть("Шапка_Angebot"),
							Макет.ПолучитьОбласть("ШапкаТаблицы"),
							Макет.получитьОбласть("Строка_1"),
							Макет.Получитьобласть("Строка_2"),
							Макет.ПолучитьОбласть("ПодвалСтроки"),
							Макет.ПолучитьОбласть("ПодвалТаблицы"),
							Макет.ПолучитьОбласть("НадписьВПодвале_Angebot"));
	Инд = -1;
	Для Каждого Ссылка Из ПараметрКоманды Цикл Инд = Инд + 1; Если Инд Тогда ТабДок.ВывестиГоризонтальныйРазделительСтраниц(); КонецЕсли;
		
		// Определим данные
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЧекККМ") Тогда
			
			ДанныеДляПечати = ПечатьНаСервере.ПолучитьДанныеДляНемецкогоЗаказаВЧеке(Ссылка);
			ПечатьНаСервере.Печатать_СчетЗаказНаНемецком(ТабДок, ДанныеДляПечати, Структура,  "A");
			
		Иначе
			
			ДанныеДляПечати = ПечатьНаСервере.ПолучитьДанныеДляНемецкогоЗаказаВЗаказе(?(ТипЗнч(Ссылка) = Тип("БизнесПроцессСсылка.ЗаявкаПокупателя"), Ссылка.Заказ, Ссылка));
			ПечатьНаСервере.Печатать_СчетЗаказНаНемецком(ТабДок, ДанныеДляПечати, Структура,  "A"); КонецЕсли; КонецЦикла;
		
			
		//	Если ТипЗнч(Ссылка) = Тип("БизнесПроцессСсылка.ЗаявкаПокупателя") Тогда
		//	
		//	
		//	//ПечатьНаСервере.Печатать_СчетЗаказНаНемецком(ТабДок, Ссылка.Заказ, Структура,  "A");
		//	ПечатьНаСервере.Печатать_СчетЗаказНаНемецком(ТабДок, Ссылка.Заказ, Структура,  "A");
		//ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		//	ПечатьНаСервере.Печатать_СчетЗаказНаНемецком(ТабДок, Ссылка, Структура, "A");КонецЕсли; КонецЦикла;
		
КонецПроцедуры