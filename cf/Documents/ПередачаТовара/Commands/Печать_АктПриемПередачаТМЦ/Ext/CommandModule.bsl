﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("Документ.ПередачаТовара.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ТабДок = Новый ТабличныйДокумент;
	//ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
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
		
		Документы.ПередачаТовара.Печать_АктПриемПередачаТМЦ(ТабДок, Ссылка);
			
	КонецЦикла;
	
КонецПроцедуры
