﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("Документ.РеализацияПереданныхТоваров.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ТабДок = Новый ТабличныйДокумент;
	стрНомера = "";
	ДополнительныеПараметры = Новый Массив;
	Печать(ТабДок, ПараметрКоманды, ДополнительныеПараметры, стрНомера);
	ФункцииФормДокументов.УстановитьНастройкиТабличногоДокумента(ТабДок);
	табДок.АвтоМасштаб = истина;
	ТабДок.ДвусторонняяПечать = ТипДвустороннейПечати.ПереворотВверх;
	ОткрытьФорму("ОбщаяФорма.ТабличныйДокумент", Новый Структура("ТабличныйДокумент, ИмяФайла, ДополнительныеПараметры", ТабДок, СтрНомера, ДополнительныеПараметры),ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
&НаСервере

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды, ДополнительныеПараметры, стрНомера)	
	Инд = -1;
	Для Каждого Ссылка Из ПараметрКоманды Цикл 
		Инд = Инд + 1; 
		Если Инд Тогда 
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц(); 
		КонецЕсли;		
		СтрНомера = СтрНомера + ?(СтрНомера = "","","_") + Ссылка.Номер;
		Документы.РеализацияПереданныхТоваров.Печать_АктПриемаПередачиКСчетФактуре(ТабДок, Ссылка); 
	КонецЦикла;
	
КонецПроцедуры

