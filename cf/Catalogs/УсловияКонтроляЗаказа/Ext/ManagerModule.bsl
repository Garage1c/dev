﻿Функция ПроверитьУсловияКонтроляЗаказа(СсылкаНаЗаказ) Экспорт
	
	ПроверитьКонтролеромОбъект = Справочники.УсловияКонтроляЗаказа.ПроверитьКонтролером.ПолучитьОбъект();  
	СКД = ПроверитьКонтролеромОбъект.ПолучитьМакет("Макет");
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД));
	
	НастройкиКомпоновки = ПроверитьКонтролеромОбъект.НастройкиКомпоновщика.Получить();
	Если НЕ ЗначениеЗаполнено(НастройкиКомпоновки) Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновки);
		КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	КонецЕсли;
	
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СсылкаНаЗаказ", СсылкаНаЗаказ);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, КомпоновщикНастроек.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТЗ = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТЗ);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Если ТЗ.Количество() > 0 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции	