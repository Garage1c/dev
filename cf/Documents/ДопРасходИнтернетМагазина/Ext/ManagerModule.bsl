﻿Процедура ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства) Экспорт
	
	
	Запрос = Новый Запрос(
			 
	КэшируемыеФункции.ТектЗапросаПолученияПараметровСистемы() + "
	|;
		
	// ОПЛАТА ПО ИМПОРТУ
		
	|ВЫБРАТЬ
	|	&Период				Период,
	|	Отдел				Отдел,	
	|	Статья 				СтатьяРасхода,
	|	Валюта 				Валюта,
	|   Сумма
	|ИЗ
	|	Документ.ДопРасходИнтернетМагазина.Расходы
	|ГДЕ
	|	Ссылка = &Ссылка
	//|;
	//|ВЫБРАТЬ
	//|	&Период								КАК Период,
	////|	Док.БанковскийСчетОрганизации	КАК КассаСчет,
	//|	Статья							КАК СтатьяДДС,
	//|	Отдел,
	//|	- Сумма						  	КАК	Сумма 
	//|                          
	//|ИЗ
	//|	Документ.ДопРасходИнтернетМагазина.Расходы 
	//|ГДЕ
	//|	Ссылка = &Ссылка
	|");
	
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Ссылка.Дата);
	
	Пакет = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.Вставить("ПараметрыСистемы", КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[0].Выгрузить()));
	ДополнительныеСвойства.Вставить("ДопРасходыИнтернетМагазина", 	Пакет[1].Выгрузить());
	
	Если Ссылка.Периодический Тогда
		текДата = Ссылка.Дата;
		ДатаОкончания = Ссылка.ДатаОкончания; Если Не ЗначениеЗаполнено(ДатаОкончания) Тогда ДатаОкончания = ДобавитьМесяц(текДата, 240) КонецЕсли;
		Период = Ссылка.Период;
		
		ПакетПериодический = Пакет[1].Выгрузить();
		
		Пока текДата < ДатаОкончания Цикл
			// 0 - Месяц
			// 1 - Год
			// 2 - Неделя
			// 3 - День
			Если Период = 0 Тогда
				текДата = ДобавитьМесяц(текДата, 1);
			ИначеЕсли Период = 1 Тогда
				текДата = ДобавитьМесяц(текДата, 12);
			ИначеЕсли Период = 2 Тогда
				текДата = текДата + 604800;
			ИначеЕсли Период = 3 Тогда
				текДата = текДата + 86400;
			КонецЕсли;
			Для каждого лСтрока Из ПакетПериодический Цикл
				новСтрока = ДополнительныеСвойства.ДопРасходыИнтернетМагазина.Добавить();
				ЗаполнитьЗначенияСвойств(новСтрока, лСтрока);
				новСтрока.Период = текДата;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
                     
КонецПроцедуры
