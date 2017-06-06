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
	
	ПараметрПечати = Новый Структура("ИмяМакета, СкидкаВТаблице, СтрокаУсловиеПоставки, ОриентацияСтраницы", 
									"КоммерческоеИПРПервичное", Ложь, Ложь, ОриентацияСтраницы.Ландшафт);
	
	ПараметрПечати.Вставить("_1ЛистТолькоКогдаДо", 	6);
	ПараметрПечати.Вставить("НаПервомНеБолее", 		8);
	ПараметрПечати.Вставить("НаВторомНеБолее", 		9);
	ПараметрПечати.Вставить("ВКонцеНеБолее",		8);
	
	Макет 		= Документы.ЗаказПокупателя.ПолучитьМакет("КоммерческоеИПРПервичное");
	Инд = -1;
	Для Каждого Ссылка Из ПараметрКоманды Цикл Инд = Инд + 1; Если Инд Тогда ТабДок.ВывестиГоризонтальныйРазделительСтраниц(); КонецЕсли;
		
		//ПечатьНаСервере.ЗаполнитьТабличныйДокумент_КомерческоеПредложение(
		//		ТабДок, 
		//		ПечатьНаСервере.ПолучитьДанныеДляЗаказаВЗаказе(?(ТипЗнч(Ссылка) = Тип("БизнесПроцессСсылка.ЗаявкаПокупателя"), Ссылка.Заказ, Ссылка)), ПараметрПечати, Истина, Ложь); 
		Если ТипЗнч(Ссылка) = Тип("БизнесПроцессСсылка.ЗаявкаПокупателя") или ТипЗнч(Ссылка) = Тип("БизнесПроцессСсылка.ИнтернетЗаявка") Тогда
			ПечатьНаСервере.ЗаполнитьТабличныйДокумент_КомерческоеПредложение(ТабДок,ПечатьНаСервере.ПолучитьДанныеДляЗаказаВЗаказе(Ссылка.Заказ), ПараметрПечати, Истина, Ложь); 
		ИначеЕсли
			ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаказПокупателя") или ТипЗнч(Ссылка) = Тип("ДокументСсылка.ИнтернетЗаказПокупателя") Тогда
			ПечатьНаСервере.ЗаполнитьТабличныйДокумент_КомерческоеПредложение(ТабДок,ПечатьНаСервере.ПолучитьДанныеДляЗаказаВЗаказе(Ссылка), ПараметрПечати, Истина, Ложь);	
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.КоммерческоеПредложение") Тогда
			ПечатьНаСервере.ЗаполнитьТабличныйДокумент_КомерческоеПредложение(ТабДок,  ПечатьНаСервере.ПолучитьДанныеДляЗаказаВКоммПредложении(Ссылка), ПараметрПечати);КонецЕсли;КонецЦикла;
		
КонецПроцедуры