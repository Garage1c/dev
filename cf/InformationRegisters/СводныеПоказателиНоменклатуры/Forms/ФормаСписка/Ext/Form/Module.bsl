﻿&НаСервере
Процедура ЗаполнитьРегистр(Дата)
	 текДата = НачалоМесяца(Дата);
	 
	 
	 
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Дата = ТекущаяДата();
	
	Если ВвестиДату(Дата, "День месяца", ЧастиДаты.Дата) Тогда
		
		ЗаполнитьРегистр(Дата);
		
	КонецЕсли;
КонецПроцедуры
