﻿&НаСервере
Функция	СформироватьПредставление(Группа, ЗначенияПолей, ЕстьСокращение) Экспорт
	
	Если Группа = Справочники.ВидыКонтактнойИнформации.Телефон Тогда
		
		Если ТипЗнч(ЗначенияПолей) = Тип("Соответствие") Тогда
			Возврат СформироватьПредставлениеТелефонИзСоответствия(ЗначенияПолей);
		Иначе
			Возврат СформироватьПредставлениеТелефон(ЗначенияПолей);
		КонецЕсли;
	КонецЕсли;
	
	Возврат УправлениеКонтактнойИнформацией.ПолучитьСтроковоеПредставлениеАдреса(ЗначенияПолей, "Ключ", ЕстьСокращение);
	
КонецФункции

&НаСервере
Функция ЗначениеПоПолю(Поле, ЗначенияПолей)
	
	Строки = ЗначенияПолей.НайтиСтроки(Новый Структура("Поле", ПланыВидовХарактеристик.СоставКонтактнойИнформации[Поле]));
	
	Если Строки.Количество() Тогда
		ЗначениеПоля = Формат(Строки[0].Значение,"ЧГ=");
		Возврат ?(ПустаяСтрока(ЗначениеПоля), "", Строки[0].Сокращение +ЗначениеПоля);
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаСервере
Функция	СформироватьПредставлениеТелефон(ЗначенияПолей)
	
	НовоеПредставление = "";
	
	КодСтраны	= ЗначениеПоПолю("КодСтраны", ЗначенияПолей);
	КодГорода 	= ЗначениеПоПолю("КодГорода", ЗначенияПолей);
	Добавочный	= ЗначениеПоПолю("Внутренний", ЗначенияПолей);
	
	НовоеПредставление = ПредставлениеТелефон(КодСтраны, КодГорода, ЗначениеПоПолю("НомерТелефона", ЗначенияПолей), Добавочный); 	
		
	Возврат СокрЛП(НовоеПредставление);
	
КонецФункции

Функция ПредставлениеТелефон(КодСтраны, КодГорода, Номер, Добавочный)
	Если стрДлина(Номер) = 6 Тогда
		Номер = Лев(Номер,2)+"-"+Сред(Номер,3,2)+"-"+Прав(Номер,2);
	ИначеЕсли стрДлина(Номер) = 7 Тогда
		Номер = Лев(Номер,3)+"-"+Сред(Номер,4,2)+"-"+Прав(Номер,2);
	КонецЕсли;
	
	Возврат ?(ПустаяСтрока(КодСтраны), "", "+" + КодСтраны)+ ?(ПустаяСтрока(КодГорода), "", " (" + КодГорода + ") ") + Номер + ?(ПустаяСтрока(Добавочный), "", "," + Добавочный);
	
КонецФункции


&НаСервере
Функция	СформироватьПредставлениеТелефонИзСоответствия(ЗначенияПолей)
	
	НовоеПредставление = "";
	
	КодСтраны	= ЗначенияПолей.Получить(ПланыВидовХарактеристик.СоставКонтактнойИнформации["КодСтраны"]);
	КодГорода 	= ЗначенияПолей.Получить(ПланыВидовХарактеристик.СоставКонтактнойИнформации["КодГорода"]);
	Добавочный	= ЗначенияПолей.Получить(ПланыВидовХарактеристик.СоставКонтактнойИнформации["Внутренний"]);
	НомерТелефона = ЗначенияПолей.Получить(ПланыВидовХарактеристик.СоставКонтактнойИнформации["НомерТелефона"]);
	
	НовоеПредставление = ПредставлениеТелефон(КодСтраны, КодГорода, НомерТелефона, Добавочный); 	
		
	Возврат СокрЛП(НовоеПредставление);
	
КонецФункции

