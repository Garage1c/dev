﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Новый ТабличныйДокумент;
	Печать(ТабДок, ПараметрКоманды);

	ФункцииФормДокументов.УстановитьНастройкиТабличногоДокумента(ТабДок);
	
	ТабДок.АвтоМасштаб = Истина;
	
	ТабДок.Показать();
	
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды)
	
	Инд = -1;
	Для Каждого Ссылка Из ПараметрКоманды Цикл Инд = Инд + 1;
		
		Если Инд Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		Документы.ЧекККМ.Печать_ТоварныйЧек(ТабДок, Ссылка);
		
		//Если ТипЗнч(Ссылка) = Тип("БизнесПроцессСсылка.СборкаЗаказа") Тогда
		//	Документы.РеализацияТоваров.Печать_ТоварныйЧек(ТабДок, Ссылка.РеализацияТоваров);
		//ИначеЕсли
		//	ТипЗнч(Ссылка) = Тип("ДокументСсылка.РеализацияТоваров") Тогда
		//	Документы.РеализацияТоваров.Печать_ТоварныйЧек(ТабДок, Ссылка);
		//КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
