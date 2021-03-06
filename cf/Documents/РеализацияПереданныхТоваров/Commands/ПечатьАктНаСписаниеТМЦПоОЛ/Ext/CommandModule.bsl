﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ТабДок 					= Новый ТабличныйДокумент;
	СтрНомера 				= "";
	ДополнительныеПараметры = Новый Массив;
	Печать(ТабДок, ПараметрКоманды, ДополнительныеПараметры, СтрНомера);

	ФункцииФормДокументов.УстановитьНастройкиТабличногоДокумента(ТабДок);
	
	ТабДок.АвтоМасштаб = Истина;
	
	Если ТабДок.Области.Количество() Тогда
		ОткрытьФорму("ОбщаяФорма.ТабличныйДокумент", Новый Структура("ТабличныйДокумент, ИмяФайла, ДополнительныеПараметры", ТабДок, СтрНомера, ДополнительныеПараметры),ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно) КонецЕсли;	
КонецПроцедуры


&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды, ДополнительныеПараметры, стрНомера)
	
	Инд = -1;
	Для Каждого Ссылка Из ПараметрКоманды Цикл Инд = Инд + 1; Если Инд Тогда ТабДок.ВывестиГоризонтальныйРазделительСтраниц(); КонецЕсли;
		
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.РеализацияПереданныхТоваров") Тогда СсылкаДок = Ссылка; Иначе 
			Продолжить 
		КонецЕсли;
		
		СтрНомера = СтрНомера + ?(СтрНомера = "","","_") + СсылкаДок.Номер;
		ДополнительныеПараметры.Добавить(Новый Структура("Контрагент", Ссылка.Контрагент));
		
		Документы.РеализацияПереданныхТоваров.ПечатьАктСписанияТМЦпоОЛ(ТабДок, Ссылка); КонецЦикла;
	
КонецПроцедуры