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
	ТабДок.АвтоМасштаб = Истина;

	СтрНомера = "";
	ДополнительныеПараметры = ПолучитьПараметрыДляТабличногоДокумента(ПараметрКоманды, СтрНомера);
	ОткрытьФорму("ОбщаяФорма.ТабличныйДокумент", Новый Структура("ТабличныйДокумент, ИмяФайла, ДополнительныеПараметры", ТабДок, СтрНомера, ДополнительныеПараметры),ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды)
	
	//Макет 		= Документы.ЗаказПокупателя.ПолучитьМакет("НовыйЗаказНем");
	
	Макет		= Документы.ЗаказПокупателя.ПолучитьМакет("НовыйЗаказНем");
	Структура 	= Новый Структура("Шапка, ШапкаТаблицы, Строка_1, Строка_2, ПодвалСтроки, ПодвалТаблицы, НадписьВПодвале",
							Макет.ПолучитьОбласть("Шапка_Rechnung"),
							Макет.ПолучитьОбласть("ШапкаТаблицы"),
							Макет.ПолучитьОбласть("Строка_1"),
							Макет.ПолучитьОбласть("Строка_2"),
							Макет.ПолучитьОбласть("ПодвалСтроки"),
							Макет.ПолучитьОбласть("ПодвалТаблицы"),
							Макет.ПолучитьОбласть("НадписьВПодвале_Lieferschein_Rechnung"));
	Инд = -1;
	Для Каждого Ссылка Из ПараметрКоманды Цикл Инд = Инд + 1; Если Инд Тогда ТабДок.ВывестиГоризонтальныйРазделительСтраниц(); КонецЕсли;
		
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.РеализацияТоваров") Тогда
			
			ДанныеДляПечати = ПечатьНаСервере.ПолучитьДанныеДляНемецкойНакладнойИзРеализации(Ссылка);
			ПечатьНаСервере.Печатать_НакладнойНаНемецком(ТабДок, ДанныеДляПечати, Структура, "R");
		
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЧекККМ") Тогда
			
			ДанныеДляПечати = ПечатьНаСервере.ПолучитьДанныеДляНемецкойНакладнойИзЧека(Ссылка);
			ПечатьНаСервере.Печатать_НакладнойНаНемецком(ТабДок, ДанныеДляПечати, Структура, "R"); КонецЕсли; КонецЦикла;
		
КонецПроцедуры