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
	
	Макет 		= Документы.ЗаказПокупателя.ПолучитьМакет("Квитанция");

	Инд = -1;
	Для Каждого Ссылка Из ПараметрКоманды Цикл Инд = Инд + 1; Если Инд Тогда ТабДок.ВывестиГоризонтальныйРазделительСтраниц(); КонецЕсли;
		
		Если ТипЗнч(Ссылка) = Тип("БизнесПроцессСсылка.ЗаявкаПокупателя") Тогда
			Документы.ЗаказПокупателя.Печать_СчетЗаказ(ТабДок, Ссылка.Заказ, "Квитанция");  
		ИначеЕсли
			ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			Документы.ЗаказПокупателя.Печать_СчетЗаказ(ТабДок, Ссылка, "Квитанция");
		ИначеЕсли
			ТипЗнч(Ссылка) = Тип("ДокументСсылка.ИнтернетЗаказПокупателя") Тогда
			Документы.ЗаказПокупателя.Печать_СчетЗаказ(ТабДок, Ссылка, "Квитанция",,,,,"ИнтернетЗаказПокупателя");  
		ИначеЕсли
			ТипЗнч(Ссылка) = Тип("БизнесПроцессСсылка.ИнтернетЗаявка") Тогда
			Документы.ЗаказПокупателя.Печать_СчетЗаказ(ТабДок, Ссылка.Заказ, "Квитанция",,,,,"ИнтернетЗаказПокупателя"); 
		КонецЕсли; КонецЦикла;
		
КонецПроцедуры