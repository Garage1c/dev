﻿
&НаКлиенте
Процедура Проверка(Команда)
	ПроверкаНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПроверкаНаСервере()
	Справочники.УсловияКонтроляЗаказа.ПроверитьУсловияКонтроляЗаказа(СсылкаНаЗаказ);
КонецПроцедуры
