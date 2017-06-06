﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ТабДок = Новый ТабличныйДокумент;
	

	Печать(ТабДок, ПараметрКоманды);

	ФункцииФормДокументов.УстановитьНастройкиТабличногоДокумента(ТабДок);
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
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
		
		Документы.ПередачаТовара.Печать_М11(ТабДок, Ссылка);
			
	КонецЦикла;
	
КонецПроцедуры
