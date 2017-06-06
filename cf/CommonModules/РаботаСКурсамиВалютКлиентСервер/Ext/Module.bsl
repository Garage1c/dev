﻿// Процедура для загрузки курсов валюты.
// Параметры
// Валюты          - соответствие - ключ - числовой код валюты
//                                  значение - ссылка на валюту
// НачалоПериодаЗагрузки - Дата - начало периода загрузки курсов
// ОкончаниеПериодаЗагрузки - Дата - окончание периода загрузки курсов
// СообщениеОбОшибке - 
//
// Возвращаемое значение:
// Истина - валюты успешно загружены
// Ложь   -
//
Функция ЗагрузитьКурсыВалютПоПараметрам(знач Валюты,
                                        знач НачалоПериодаЗагрузки,
                                        знач ОкончаниеПериодаЗагрузки,
                                        ПоясняющееСообщение = "") Экспорт
	
	СтатусОперации = Истина;
	
	СерверИсточник = "cbrates.rbc.ru";
	Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
		Адрес = "tsv/";
		ТМП   = "/"+Формат(Год(ОкончаниеПериодаЗагрузки),"ЧРГ=; ЧГ=0")+"/"+Формат(Месяц(ОкончаниеПериодаЗагрузки),"ЧЦ=2;ЧДЦ=0;ЧВН=")+"/"+Формат(День(ОкончаниеПериодаЗагрузки),"ЧЦ=2;ЧДЦ=0;ЧВН=");
	Иначе
		Адрес = "tsv/cb/";
		ТМП   = "";
	КонецЕсли;
	
	Для Каждого Валюта из Валюты Цикл
		ФайлНаВебСервере = "http://" + СерверИсточник + "/" + Адрес + Прав(Валюта.КодВалюты, 3) + ТМП + ".tsv";
		
		#Если НаКлиенте Тогда
		Результат = ПолучениеФайловИзИнтернетКлиент.СкачатьФайлНаКлиенте(ФайлНаВебСервере);
		#Иначе
		Результат = ПолучениеФайловИзИнтернет.СкачатьФайлНаСервере(ФайлНаВебСервере);
		#КонецЕсли
		
		Если Результат.Статус Тогда
			#Если НаКлиенте Тогда
			ДвоичныеДанные = Новый ДвоичныеДанные (Результат.Путь);
			АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
			ПоясняющееСообщение = ПоясняющееСообщение + РаботаСКурсамиВалют.ЗагрузитьКурсВалютыИзФайла(Валюта.Валюта, АдресВоВременномХранилище, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки) + Символы.ПС;
			#Иначе
			ПоясняющееСообщение = ПоясняющееСообщение + РаботаСКурсамиВалют.ЗагрузитьКурсВалютыИзФайла(Валюта.Валюта, Результат.Путь, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки) + Символы.ПС;
			#КонецЕсли
			УдалитьФайлы(Результат.Путь);
		Иначе
			СтатусОперации = Ложь;
			ПоясняющееСообщение= НСтр("ru = 'Не возможно получить файл данных с курсами валюты (%1 - %2):'")
					+ Символы.ПС + "%3" + Символы.ПС
					+ НСтр("ru = 'Возможно, нет доступа к веб сайту с курсами валют, либо указана несуществующая валюта.'");
			ПоясняющееСообщение = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								ПоясняющееСообщение,
								Валюта.КодВалюты,
								Валюта.Валюта,
								Результат.СообщениеОбОшибке,
								Лев(Строка(НачалоПериодаЗагрузки), 10),
								Лев(Строка(ОкончаниеПериодаЗагрузки), 10));
		КонецЕсли;
	КонецЦикла;
	
	Если СтатусОперации Тогда
		ПоясняющееСообщение = Лев(ПоясняющееСообщение, СтрДлина(ПоясняющееСообщение) - 2);
	КонецЕсли;
	
	Возврат СтатусОперации;
	
КонецФункции

