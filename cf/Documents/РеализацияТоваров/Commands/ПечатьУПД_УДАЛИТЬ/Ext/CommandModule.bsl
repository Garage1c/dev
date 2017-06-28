﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("Документ.РеализацияТоваров.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ТабДок = Новый ТабличныйДокумент;
	стрНомера = "";
	ДополнительныеПараметры = Новый Массив;
	Печать(ТабДок, ПараметрКоманды, ДополнительныеПараметры, стрНомера);
	ФункцииФормДокументов.УстановитьНастройкиТабличногоДокумента(ТабДок);
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ДвусторонняяПечать = ТипДвустороннейПечати.ПереворотВверх;
	ОткрытьФорму("ОбщаяФорма.ТабличныйДокумент", Новый Структура("ТабличныйДокумент, ИмяФайла, ДополнительныеПараметры", ТабДок, СтрНомера, ДополнительныеПараметры),ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды, ДополнительныеПараметры, стрНомера)
	
	Инд = -1;
	Для Каждого Ссылка Из ПараметрКоманды Цикл 
		Инд = Инд + 1; 
		Если Инд Тогда 
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц(); 
		КонецЕсли;
		
		Если ТипЗнч(Ссылка) = Тип("БизнесПроцессСсылка.СборкаЗаказа") Тогда
			СсылкаДок = Ссылка.РеализацияТоваров;
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.РеализацияТоваров") Тогда 
			СсылкаДок = Ссылка; 
		Иначе 
			Продолжить 
		КонецЕсли;
		
		СтрНомера = СтрНомера + ?(СтрНомера = "","","_") + СсылкаДок.Номер;
		ДополнительныеПараметры.Добавить(Новый Структура("Контрагент", Ссылка.Контрагент));
		
		Печать_УПД(ТабДок, Ссылка); 
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
 Процедура Печать_УПД(ТабличныйДокумент, Ссылка, Номер = "", Дата = Неопределено) Экспорт
	Основание = "Заказ";
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.РеализацияТоваров") Тогда
		ДанныеДляПечати = Документы.РеализацияТоваров.ПолучитьДанныеДляУПД(Ссылка);
	//ИначеЕсли
	//	ТипЗнч(Ссылка) = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
	//	ДанныеДляПечати = Документы.СчетФактураВыданный.ПолучитьДанныеДляСчетФактура(Ссылка);
	ИначеЕсли	
		ТипЗнч(Ссылка) = Тип("БизнесПроцессСсылка.СборкаЗаказа") Тогда
		ДанныеДляПечати = Документы.РеализацияТоваров.ПолучитьДанныеДляУПД(Ссылка.РеализацияТоваров);
	ИначеЕсли	
		ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПоступлениеТоваров") Тогда
		ДанныеДляПечати = Документы.ПоступлениеТоваров.ПолучитьДанныеДляСчетФактура(Ссылка);
	ИначеЕсли	
		ТипЗнч(Ссылка) = Тип("ДокументСсылка.ВозвратПоставщику") Тогда
		ДанныеДляПечати = Документы.ВозвратПоставщику.ПолучитьДанныеДляСчетФактура(Ссылка);
		Основание = "Поступление";
    КонецЕсли;

	ЗаполнитьТабличныйДокументУПД(ТабличныйДокумент, ДанныеДляПечати, Ссылка, Номер, Дата,,,Основание);
	
 КонецПроцедуры
&НаСервере 
 Процедура ЗаполнитьТабличныйДокументУПД(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, Номер, Дата, ЭтоСчетФактураНаАванс = Ложь, ПечатьВВалюте = Ложь,Основание = "") Экспорт
	
	ВалютаРегламентированногоУчета = ОбщиеФункции.ПолучитьЗначениеКонстантыВОбласти("ВалютаУправленческогоУчета");
	
	
	//ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
	Макет = Обработки.ПечатьОбщихФорм.ПолучитьМакет("УПД");

	ДанныеПечати      	= ДанныеДляПечати.РезультатПоШапке.Выбрать();
	//ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ТаблицаКурсовВалют  = ДанныеДляПечати.ТаблицаКурсовВалют;
	
	//ПервыйДокумент = Истина;
	Пока ДанныеПечати.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(ДанныеПечати.Номер) И Номер = "" Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для документа %1 не введен счет-фактура'"),
				ДанныеПечати.Ссылка
				);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка,
				?(ДанныеПечати.Номер = Неопределено, "ТекстСчетФактура", "ПредъявленСчетФактура")
			);
			
		ИначеЕсли ПечатьВВалюте И ДанныеПечати.Валюта = ВалютаРегламентированногоУчета Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для документа %1 не требуется печатать счет-фактуру в валюте'"),
				ДанныеПечати.Ссылка
				);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка
			);
			
		Иначе
	
			//Если Не ПервыйДокумент Тогда
			//	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			//КонецЕсли;
			
			//ПервыйДокумент = Ложь;
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			// Выводим общие реквизиты шапки
			СведенияОбОрганизации = Новый Структура;
			ЗаполнитьРеквизитыШапкиУПД(ДанныеПечати, СведенияОбОрганизации, Макет, ТабличныйДокумент, Номер, Дата, ПечатьВВалюте, ЭтоСчетФактураНаАванс);
			//ЗаголовокТаблицы.Параметры.Валюта = ?(ПечатьВВалюте, ДанныеПечати.Валюта, ВалютаРегламентированногоУчета);
			
			// Выводим заголовок таблицы
			ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
			ТабличныйДокумент.Вывести(ЗаголовокТаблицы);
			
			НомерСтраницы   = 1;
			
			// Инициализация итогов в документе
			ИтоговыеСуммы = СтруктураИтоговыеСуммы();
			
			Если ПечатьВВалюте Тогда
				КоэффициентПересчета = 1;
			Иначе
				КоэффициентПересчета = КоэффициентПересчетаВалюты(ДанныеПечати, ТаблицаКурсовВалют, ВалютаРегламентированногоУчета, Дата);
			КонецЕсли;
			ДанныеСтроки = СтруктураДанныеСтроки(КоэффициентПересчета);
			
			// Создаем массив для проверки вывода
			МассивВыводимыхОбластей = Новый Массив;
			
			// Выводим многострочную часть документа
			ОбластьМакета  = Макет.ПолучитьОбласть("Строка");
			ОбластьИтого = Макет.ПолучитьОбласть("Итого");
			ОбластьПодвала = Макет.ПолучитьОбласть("Подвал");
			///Антон
			ОбластьНумерацияЛистов = Макет.ПолучитьОбласть("НумерацияЛистов");
			ОбластьПодвалНакладной = Макет.ПолучитьОбласть("ПодвалНакладной");
			///Антон
			
			//Не уверен я что это нужно
			//ОбластьПодвалаНакладной = Макет.ПолучитьОбласть("ПодвалНакладной");
			//Конец неуверенности
			
			//СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
			//ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска);
			//ВыборкаПоДокументам.Следующий();
			
			ТаблицаТовары = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выгрузить();
			
			//Документы.РеализацияТоваров.УдалитьЛишниеКопейкиВТабличнойЧасти(ДанныеПечати.Ссылка, ТаблицаТовары); 
			
			Если НЕ ДанныеПечати.ЕстьУслуги ИЛИ ДанныеПечати.ТолькоУслуги Тогда
				КоличествоСтрок = ТаблицаТовары.Количество();
				НомерСтрокиПравильный = 0;
				Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
				
					ДанныеСтроки.Номер = ДанныеСтроки.Номер + 1;
					
					МассивВыводимыхОбластей.Очистить();
					МассивВыводимыхОбластей.Добавить(ОбластьМакета);
					
					Если ДанныеСтроки.Номер = КоличествоСтрок Тогда
						МассивВыводимыхОбластей.Добавить(ОбластьИтого);
						МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
						МассивВыводимыхОбластей.Добавить(ОбластьПодвалНакладной);
						///
						//МассивВыводимыхОбластей.Добавить(Область
					КонецЕсли;
					
					Если НЕ ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
						НомерСтраницы = НомерСтраницы + 1;
						ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
						///
						ОбластьНумерацияЛистов.Параметры.Номер = "Универсальный передаточный документ № "+ФормированиеПечатныхФорм.ПолучитьНомерНаПечать(ДанныеПечати.Номер, Истина)+" от "+Формат(ДанныеПечати.Дата, "ДФ='дд ММММ гггг'")+" г.";
						ОбластьНумерацияЛистов.Параметры.НомерЛиста = НомерСтраницы;
						ТабличныйДокумент.Вывести(ОбластьНумерацияЛистов);
						///
						ТабличныйДокумент.Вывести(ЗаголовокТаблицы);
					КонецЕсли;
					
					ЗаполнитьРеквизитыСтрокиТовара(ДанныеПечати, СтрокаТовары, ДанныеСтроки, ОбластьМакета);
					
					Если НЕ ЭтоСчетФактураНаАванс Тогда
						ЗаполнитьРеквизитыСтрокиТовараГТД(СтрокаТовары, ОбластьМакета);
					КонецЕсли;
					
					Если ЭтоСчетФактураНаАванс Тогда
						ОбластьМакета.Параметры.Акциз = "";
						ОбластьМакета.Параметры.ЕдиницаИзмеренияКод = "";
					Иначе
						ОбластьМакета.Параметры.Акциз = "без акциза";
					КонецЕсли;
					
					Если ЭтоСчетФактураНаАванс Тогда
						// В счетах-фактурах на аванс колонки 3,4,5 не выводятся
						ОбластьМакета.Параметры.Заполнить(Новый Структура("Количество,Цена,СуммаБезНДС",0,0,0));
					КонецЕсли;
					НомерСтрокиПравильный = НомерСтрокиПравильный + 1;
					ОбластьМакета.Параметры.НомерСтроки = НомерСтрокиПравильный;
					ПроставитьПрочеркиВПустыеПоляСтрокиСчетФактура(ОбластьМакета);
					
					ТабличныйДокумент.Вывести(ОбластьМакета);
					РассчитатьИтоговыеСуммы(ИтоговыеСуммы, ДанныеСтроки);
					
				КонецЦикла;
			Иначе
				КоличествоСтрок = 1;
				УслугаСтроки = ТаблицаТовары.НайтиСтроки(Новый Структура("ЭтоУслуга", Истина));
				Если УслугаСтроки.Количество() Тогда
					
					СтрокаНаименованиеТоваров = "";	
					Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
						
						Если НЕ СтрокаТовары.ЭтоУслуга Тогда
						
							СтрокаНаименованиеТоваров = СтрокаНаименованиеТоваров + ?(ПустаяСтрока(СтрокаНаименованиеТоваров), "", ", ") +
										ФормированиеПечатныхФорм.ПолучитьПредставлениеНоменклатурыДляПечати(СтрокаТовары.ТоварНаименование) + 
										?(СтрокаТовары.ЭтоВозвратнаяТара, НСтр("ru=' (возвратная тара)'"), "");					
							
									КонецЕсли;
						ЗаполнитьРеквизитыСтрокиТовара(ДанныеПечати, СтрокаТовары, ДанныеСтроки, ОбластьМакета);
                       	РассчитатьИтоговыеСуммы(ИтоговыеСуммы, ДанныеСтроки);
					КонецЦикла;
					
					УслугаНаименование = УслугаСтроки[0].ТоварНаименование + " в т.ч.:"; 
					ТоварНаименование = УслугаНаименование + Символы.ПС + СтрокаНаименованиеТоваров; 
					КоличествоНормоЧас = УслугаСтроки[0].Количество; 
					
					ЗаполнитьРеквизитыСтрокиТовара(ДанныеПечати, УслугаСтроки[0], ДанныеСтроки, ОбластьМакета);
					
					ОбластьМакета.Параметры.Заполнить(Новый Структура("СуммаСНДС, СуммаНДС, СуммаБезНДС, ТоварНаименование", 
										ИтоговыеСуммы.ИтогоСуммаСНДС, ИтоговыеСуммы.ИтогоНДС, ИтоговыеСуммы.ИтогоСумма,  ТоварНаименование));
										
					ОбластьМакета.Параметры.Цена = 	ИтоговыеСуммы.ИтогоСумма / КоличествоНормоЧас;					 
					ОбластьМакета.Параметры.Акциз = "без акциза";
		
					ПроставитьПрочеркиВПустыеПоляСтрокиСчетФактура(ОбластьМакета);
				
					МассивВыводимыхОбластей.Очистить();
					МассивВыводимыхОбластей.Добавить(ОбластьМакета);
					МассивВыводимыхОбластей.Добавить(ОбластьИтого);
					МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
					//
					//МассивВыводимыхОбластей.Добавить(ОбластьПодвалаНакладной);
					//
				
					Если НЕ ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
						НомерСтраницы = НомерСтраницы + 1;
						ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
						///
						ОбластьНумерацияЛистов.Параметры.Номер = "Универсальный передаточный документ № "+ФормированиеПечатныхФорм.ПолучитьНомерНаПечать(ДанныеПечати.Номер, Истина)+" от "+Формат(ДанныеПечати.Дата, "ДФ='дд ММММ гггг'")+" г.";
						ОбластьНумерацияЛистов.Параметры.НомерЛиста = НомерСтраницы;
						ТабличныйДокумент.Вывести(ОбластьНумерацияЛистов);
						///
						ТабличныйДокумент.Вывести(ЗаголовокТаблицы);
					КонецЕсли;
						
					ТабличныйДокумент.Вывести(ОбластьМакета);

				КонецЕсли;
				
			КонецЕсли;
			// Выводим итоги по документу
			ДобавитьИтоговыеДанныеПодвала(ИтоговыеСуммы, ДанныеСтроки.Номер, ВалютаРегламентированногоУчета);
			ЗаполнитьРеквизитыПодвалаУПД(ДанныеПечати, СведенияОбОрганизации, ИтоговыеСуммы, Макет, ТабличныйДокумент, ЭтоСчетФактураНаАванс);
			
			ЗаполнитьРеквизитыПодвалаНакладной(ДанныеПечати, СведенияОбОрганизации, ИтоговыеСуммы, Макет, ТабличныйДокумент, Основание)
			//ЗаполнитьИВывестиПодвалНакладной()
			//УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
			
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры // ЗаполнитьТабличныйДокументСчетФактура()

Процедура ЗаполнитьРеквизитыШапкиУПД(ДанныеПечати, СведенияОПоставщике, Макет, ТабличныйДокумент, Номер, Дата, ПечатьВВалюте, ЭтоСчетФактураНаАванс)
		
	НомераДаты = Новый Структура;
	НомераДаты.Вставить("Номер", ФормированиеПечатныхФорм.ПолучитьНомерНаПечать(ДанныеПечати.Номер, Истина));
	
	УчетПоОП = ЗначениеЗаполнено(ДанныеПечати.Дата) И ДанныеПечати.Дата >= КэшируемыеФункции.НачалоВеденияСФПоОбособленнымПодразделениям();
	
	//НомераДаты.Вставить("НомерПодразделения", ?(УчетПоОП И ДанныеПечати.НомерПодразделения <> 0, "/" + Строка(ДанныеПечати.НомерПодразделения), ""));
	
	НомераДаты.Вставить("НомерПодразделения", ?(УчетПоОП И ДанныеПечати.Ссылка.Склад.НомерПодразделения <> 0, "/" + Строка(ДанныеПечати.Ссылка.Склад.НомерПодразделения), ""));
		
	НомераДаты.Вставить("Дата", Формат(ДанныеПечати.Дата, "ДФ='дд ММММ гггг'")+ " г.");
	
	НомераДаты.Вставить("НомерИсправления","--");
	НомераДаты.Вставить("ДатаИсправления", "--");
	
	СведенияОПоставщике = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, Дата);
	СведенияОПокупателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Контрагент, Дата);
	СведенияОГрузоотправителе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузоотправитель, Дата);
	СведенияОГрузополучателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузополучатель,  Дата);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати); 
	ОбластьМакета.Параметры.Заполнить(НомераДаты);
	////
	Если ДанныеПечати.Ссылка.УчитыватьНДС Тогда
		ОбластьМакета.Параметры.СтатусУПД = "1";
	Иначе
		ОбластьМакета.Параметры.СтатусУПД = "2";
	КонецЕсли;
	//ОбластьМакета.Параметры.Номер = "Счет-фактура № " + ФормированиеПечатныхФорм.ПолучитьНомерНаПечать(Номер)
	//	+ " от " + Формат(Дата, "ДФ='дд ММММ гггг'")+ " г.";
	
	// Выводим данные о поставщике.
	ПредставлениеПоставщика = СведенияОПоставщике.ОфициальноеНаименование;	
	
	ОбластьМакета.Параметры.ПредставлениеПоставщика = ПредставлениеПоставщика;
	ОбластьМакета.Параметры.АдресПоставщика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ЮридическийАдрес");

	КПП = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправителе, "КПП,", Ложь);
	ОбластьМакета.Параметры.ИННПоставщика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ИНН", Ложь)
		+ ?(Не ПустаяСтрока(КПП), "/" + КПП, "");
		
	// Выводим данные грузоотправителя.	
	ПредставлениеГрузоотправителя = "";
	
	Если ДанныеПечати.ТолькоУслуги ИЛИ ДанныеПечати.ЕстьУслуги ИЛИ ЭтоСчетФактураНаАванс Тогда
		ПредставлениеГрузоотправителя = ПредставлениеГрузоотправителя + "--";
	ИначеЕсли ДанныеПечати.Организация = ДанныеПечати.Грузоотправитель Тогда
		ПредставлениеГрузоотправителя = ПредставлениеГрузоотправителя + "он же";
	Иначе
		ПредставлениеГрузоотправителя = ПредставлениеГрузоотправителя 
			+ ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправителе, "ПолноеНаименование,ФактическийАдрес");
	КонецЕсли;
	ОбластьМакета.Параметры.ПредставлениеГрузоотправителя = ПредставлениеГрузоотправителя;
		
	// Выводим данные грузополучателя и покупателя.
	ПредставлениеГрузополучателя = "";
	Если ДанныеПечати.ТолькоУслуги ИЛИ ДанныеПечати.ЕстьУслуги ИЛИ ЭтоСчетФактураНаАванс Тогда
		ПредставлениеГрузополучателя = ПредставлениеГрузополучателя + "--";
	Иначе
		Если Не ПустаяСтрока(ДанныеПечати.АдресДоставки) Тогда
			ПредставлениеГрузополучателя = ПредставлениеГрузополучателя
				+ ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, "ПолноеНаименование", Ложь)
				+ ", " + СокрЛП(ДанныеПечати.АдресДоставки)
			;
		Иначе
			ПредставлениеГрузополучателя = ПредставлениеГрузополучателя
				+ ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, "ПолноеНаименование,ФактическийАдрес", Ложь);
				 
		КонецЕсли;
	КонецЕсли;
	ОбластьМакета.Параметры.ПредставлениеГрузополучателя = ПредставлениеГрузополучателя;
	
	ПоДокументу = "";
	ЕстьОплата	= Ложь;
	//ОбластьМакета.Параметры.ПоДокументу = ОбластьМакета.Параметры.ПоДокументу + ФормированиеПечатныхФорм.ПолучитьНомерНаПечать(ДанныеПечати.ПоДокументуНомер ) + " от " + Формат(ДанныеПечати.ПоДокументуДата, "ДФ='дд ММММ гггг'")+ " г.";
	
	
	Попытка
		РасчетныеДокументы = ДанныеПечати.РасчетныеДокументы.Выгрузить();
		ЕстьРасчетныеДокументы = РасчетныеДокументы.Количество();
	Исключение
		ЕстьРасчетныеДокументы = Ложь;
	КонецПопытки;
	
	Если ЕстьРасчетныеДокументы Тогда
		Для Каждого Строка ИЗ РасчетныеДокументы Цикл
			Если ЗначениеЗаполнено(Строка.Номер) Тогда ЕстьОплата = Истина;
					ПоДокументу = ПоДокументу+ " " +  
					ФормированиеПечатныхФорм.ПолучитьНомерНаПечать(Строка.Номер) + " от " +
					Формат(Строка.Дата, "ДФ='дд ММММ гггг'")+ " г." + ",";					
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ЕстьОплата	Тогда
		ОбластьМакета.Параметры.ПоДокументу = Лев(ПоДокументу, СтрДлина(ПоДокументу)-1);
	Иначе
		ОбластьМакета.Параметры.ПоДокументу = ПоДокументу + "-- от --";
	КонецЕсли;
	
	ОбластьМакета.Параметры.ПредставлениеПокупателя = "" 
		+ ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование", Ложь);
	ОбластьМакета.Параметры.АдресПокупателя = ""
		+ ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ЮридическийАдрес", Ложь);
		
	Если ДанныеПечати.ТолькоУслуги ИЛИ ДанныеПечати.ЕстьУслуги ИЛИ ЭтоСчетФактураНаАванс Тогда
		КПП = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "КПП,", Ложь);
	Иначе
		КПП = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, "КПП,", Ложь);
    КонецЕсли;
		
	ОбластьМакета.Параметры.ИННПокупателя = ""
		+ ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ИНН,", Ложь)
		+ ?(Не ПустаяСтрока(КПП), "/" + КПП, "");
	
	Если ЗначениеЗаполнено(ДанныеПечати.Валюта) Тогда //И ПечатьВВалюте Тогда
		ОбластьМакета.Параметры.Валюта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1, %2'"),
			СокрЛП(ДанныеПечати.ВалютаНаименованиеПолное),
			ДанныеПечати.ВалютаКод
		);
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
		
КонецПроцедуры // ЗаполнитьРеквизитыШапкиСчетФактура()

Функция СтруктураИтоговыеСуммы()
	
	Структура = Новый Структура;
	
	// Инициализация итогов по странице.
	Структура.Вставить("ИтогоМассаБруттоНаСтранице", 0);
	Структура.Вставить("ИтогоМестНаСтранице", 0);
	Структура.Вставить("ИтогоКоличествоНаСтранице", 0);
	Структура.Вставить("ИтогоСуммаНаСтранице", 0);
	Структура.Вставить("ИтогоНДСНаСтранице", 0);
	Структура.Вставить("ИтогоСуммаСНДСНаСтранице", 0);
	Структура.Вставить("ИтогоМассаБруттоНаСтранице", 0);
	Структура.Вставить("ИтогоМассаНеттоНаСтранице", 0);
	
	// Инициализация итогов по документу.
	Структура.Вставить("ИтогоМассаБрутто", 0);
	Структура.Вставить("ИтогоМест", 0);
	Структура.Вставить("ИтогоКоличество", 0);
	Структура.Вставить("ИтогоСуммаСНДС", 0);
	Структура.Вставить("ИтогоСумма", 0);
	Структура.Вставить("ИтогоНДС", 0);
	Структура.Вставить("ИтогоМассаБрутто", 0);
	Структура.Вставить("ИтогоМассаНетто", 0);
    	
	Структура.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", 0);
	Структура.Вставить("СуммаПрописью", "");
	
	Возврат Структура;
	
КонецФункции // СтруктураИтоговыеСуммы()

Функция КоэффициентПересчетаВалюты(ДанныеПечати, ТаблицаКурсовВалют, ВалютаРегламентированногоУчета, Дата = Неопределено)
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Дата = ДанныеПечати.Дата;
	КонецЕсли;

	
	КоэффициентПересчета = 1;
	Если ДанныеПечати.Валюта <> ВалютаРегламентированногоУчета Тогда
		
		СтруктураПоиска = Новый Структура("Валюта, Дата", ДанныеПечати.Валюта, НачалоДня(Дата));
		Массив = ТаблицаКурсовВалют.НайтиСтроки(СтруктураПоиска);
		Если Массив.Количество() > 0 Тогда
			КоэффициентПересчета = ?(Массив[0].Кратность <> 0, Массив[0].Курс / Массив[0].Кратность, 1);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КоэффициентПересчета;
	
КонецФункции // КоэффициентПересчетаВалюты()

Функция СтруктураДанныеСтроки(КоэффициентПересчета)
	
	Структура = Новый Структура;
	Структура.Вставить("ТоварКод", 0);
	Структура.Вставить("Номер", 0);
	Структура.Вставить("Мест", 0);
	Структура.Вставить("Количество", 0);
	Структура.Вставить("Цена", 0);
	Структура.Вставить("СуммаБезНДС", 0);
	Структура.Вставить("СуммаНДС", 0);
	Структура.Вставить("СуммаСНДС", 0);
	Структура.Вставить("КоэффициентПересчета", КоэффициентПересчета);
	Структура.Вставить("МассаБрутто", 0);
	Структура.Вставить("МассаНетто", 0);
	
	Возврат Структура;
	
КонецФункции // СтруктураДанныеСтроки()

Процедура ЗаполнитьРеквизитыСтрокиТовара(ДанныеПечати, СтрокаТовары, ДанныеСтроки, ОбластьМакета, ЕдиницаИзмеренияВеса = Неопределено)
	
	ОбластьМакета.Параметры.Заполнить(СтрокаТовары);
	ОбластьМакета.Параметры.ТоварНаименование = ФормированиеПечатныхФорм.ПолучитьПредставлениеНоменклатурыДляПечати(
		СтрокаТовары.ТоварНаименование)
		+ ?(СтрокаТовары.ЭтоВозвратнаяТара, НСтр("ru=' (возвратная тара)'"), "");
	
	ДанныеСтроки.Мест = СтрокаТовары.КоличествоМест;
	ДанныеСтроки.Количество  = СтрокаТовары.Количество;
	ДанныеСтроки.ТоварКод = СтрокаТовары.Номенклатура.Артикул;
	Если ЕдиницаИзмеренияВеса <> Неопределено Тогда
		Если Не ЗначениеЗаполнено(ЕдиницаИзмеренияВеса) Тогда
			ДанныеСтроки.МассаБрутто = 0;
		Иначе
			ДанныеСтроки.МассаБрутто = СтрокаТовары.МассаБрутто;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеСтроки.СуммаСНДС   = Окр((СтрокаТовары.Сумма + ?(ДанныеПечати.ЦенаВключаетНДС, 0, СтрокаТовары.СуммаНДС)) * ДанныеСтроки.КоэффициентПересчета, 2);
	ДанныеСтроки.СуммаНДС    = Окр(СтрокаТовары.СуммаНДС * ДанныеСтроки.КоэффициентПересчета, 2);
	ДанныеСтроки.СуммаБезНДС = ДанныеСтроки.СуммаСНДС - ДанныеСтроки.СуммаНДС;
	
	Если ДанныеПечати.ЦенаВключаетНДС Тогда
		ДанныеСтроки.Цена = ?(ДанныеСтроки.Количество = 0, 0, ДанныеСтроки.СуммаБезНДС / ДанныеСтроки.Количество);
	Иначе
		ДанныеСтроки.Цена = СтрокаТовары.Цена * ДанныеСтроки.КоэффициентПересчета;
	КонецЕсли;
	
	ОбластьМакета.Параметры.Заполнить(ДанныеСтроки);
КонецПроцедуры // ЗаполнитьРеквизитыСтрокиТовара()


Процедура ПроставитьПрочеркиВПустыеПоляСтрокиСчетФактура(ОбластьМакета)

	Для т = 0 По ОбластьМакета.Параметры.Количество() - 1 Цикл
		
		ТекПараметр = ОбластьМакета.Параметры.Получить(т);
		
		Если НЕ ЗначениеЗаполнено(ТекПараметр) Тогда
			ОбластьМакета.Параметры.Установить(т, "--");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ПроставитьПрочеркиВПустыеПоля()

Процедура РассчитатьИтоговыеСуммы(ИтоговыеСуммы, ДанныеСтроки)
	
	// Увеличим итоги по странице.
	ИтоговыеСуммы.ИтогоМестНаСтранице        = ИтоговыеСуммы.ИтогоМестНаСтранице        + ДанныеСтроки.Мест;
	ИтоговыеСуммы.ИтогоКоличествоНаСтранице  = ИтоговыеСуммы.ИтогоКоличествоНаСтранице  + ДанныеСтроки.Количество;
	ИтоговыеСуммы.ИтогоСуммаНаСтранице       = ИтоговыеСуммы.ИтогоСуммаНаСтранице       + ДанныеСтроки.СуммаБезНДС;
	ИтоговыеСуммы.ИтогоНДСНаСтранице         = ИтоговыеСуммы.ИтогоНДСНаСтранице         + ДанныеСтроки.СуммаНДС;
	ИтоговыеСуммы.ИтогоСуммаСНДСНаСтранице   = ИтоговыеСуммы.ИтогоСуммаСНДСНаСтранице   + ДанныеСтроки.СуммаСНДС;
	ИтоговыеСуммы.ИтогоМассаБруттоНаСтранице = ИтоговыеСуммы.ИтогоМассаБруттоНаСтранице + ДанныеСтроки.МассаБрутто;
	ИтоговыеСуммы.ИтогоМассаНеттоНаСтранице  = ИтоговыеСуммы.ИтогоМассаНеттоНаСтранице  + ДанныеСтроки.МассаНетто;
	
	// Увеличим итоги по документу.
	ИтоговыеСуммы.ИтогоМест        = ИтоговыеСуммы.ИтогоМест        + ДанныеСтроки.Мест;
	ИтоговыеСуммы.ИтогоКоличество  = ИтоговыеСуммы.ИтогоКоличество  + ДанныеСтроки.Количество;
	ИтоговыеСуммы.ИтогоСумма       = ИтоговыеСуммы.ИтогоСумма       + ДанныеСтроки.СуммаБезНДС;
	ИтоговыеСуммы.ИтогоНДС         = ИтоговыеСуммы.ИтогоНДС         + ДанныеСтроки.СуммаНДС;
	ИтоговыеСуммы.ИтогоСуммаСНДС   = ИтоговыеСуммы.ИтогоСуммаСНДС   + ДанныеСтроки.СуммаСНДС;
	ИтоговыеСуммы.ИтогоМассаБрутто = ИтоговыеСуммы.ИтогоМассаБрутто + ДанныеСтроки.МассаБрутто;
	ИтоговыеСуммы.ИтогоМассаНетто  = ИтоговыеСуммы.ИтогоМассаНетто  + ДанныеСтроки.МассаНетто;
	
КонецПроцедуры // РассчитатьИтоговыеСуммы()

Процедура ДобавитьИтоговыеДанныеПодвала(ИтоговыеСуммы, ВсегоНомеров, ВалютаРегламентированногоУчета)
	
	ИтоговыеСуммы.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", ЧислоПрописью(ВсегоНомеров, ,",,,,,,,,0"));
	ИтоговыеСуммы.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(ИтоговыеСуммы.ИтогоСуммаСНДС, ВалютаРегламентированногоУчета));
	
КонецПроцедуры // ДобавитьИтоговыеДанныеПодвала()

Процедура ЗаполнитьРеквизитыПодвалаУПД(ДанныеПечати, СведенияОбОрганизации, ИтоговыеСуммы, Макет, ТабличныйДокумент, ЭтоСчетФактураНаАванс)
	
	ОбластьИтого = Макет.ПолучитьОбласть("Итого");
    ОбластьИтого.Параметры.ИтогоВсего = ИтоговыеСуммы.ИтогоСуммаСНДС;
	ОбластьИтого.Параметры.ИтогоКоличество = ИтоговыеСуммы.ИтогоКоличество;
	Если НЕ ЭтоСчетФактураНаАванс Тогда
		
		ОбластьИтого.Параметры.ИтогоСтоимость = ИтоговыеСуммы.ИтогоСумма;
		ОбластьИтого.Параметры.ИтогоСуммаНДС = ?(
			ИтоговыеСуммы.ИтогоНДС > 0, 
			ИтоговыеСуммы.ИтогоНДС, 
			НСтр("ru='без НДС'")
		);
		
	КонецЕсли;
		
	ТабличныйДокумент.Вывести(ОбластьИтого);
	
	ОбластьПодвала = Макет.ПолучитьОбласть("Подвал");
	
	Если СведенияОбОрганизации.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
		ОбластьПодвала.Параметры.ФИОРуководителя = ФормированиеПечатныхФорм.ФамилияИнициалыФизЛица(ДанныеПечати.Руководитель);
		ОбластьПодвала.Параметры.ФИОГлавногоБухгалтера = ФормированиеПечатныхФорм.ФамилияИнициалыФизЛица(ДанныеПечати.ГлавныйБухгалтер);
	Иначе
		ОбластьПодвала.Параметры.ФИОПБОЮЛ = ФормированиеПечатныхФорм.ФамилияИнициалыФизЛица(ДанныеПечати.Руководитель);
		ОбластьПодвала.Параметры.Свидетельство = СведенияОбОрганизации.Свидетельство;
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьПодвала);
		
КонецПроцедуры // ЗаполнитьРеквизитыПодвалаСчетФактура()

Процедура ЗаполнитьРеквизитыПодвалаНакладной(ДанныеПечати, СведенияОбОрганизации, ИтоговыеСуммы, Макет, ТабличныйДокумент, Основание)
	ОбластьПодвалаНакладной = Макет.ПолучитьОбласть("ПодвалНакладной");
	ОбластьПодвалаНакладной.Параметры.ДатаОтгрузкиПередачи = Формат(ДанныеПечати.Дата, "ДФ='дд ММММ гггг'")+ " г.";
	ОбластьПодвалаНакладной.Параметры.ФИОКладовщика = ФормированиеПечатныхФорм.ФамилияИнициалыФизЛица(ДанныеПечати.Руководитель);
	ОбластьПодвалаНакладной.Параметры.ДолжностьКладовщика = ДанныеПечати.ДолжностьРуководителя;
	ОбластьПодвалаНакладной.Параметры.ДолжностьОТВ = ДанныеПечати.ДолжностьРуководителя;
	ОбластьПодвалаНакладной.Параметры.ФИООтв = ФормированиеПечатныхФорм.ФамилияИнициалыФизЛица(ДанныеПечати.Руководитель);
	ОбластьПодвалаНакладной.Параметры.Основание = ПолучитьОснованиеДокумента(ДанныеПечати, Основание);
	
	СведенияОПоставщике = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.Дата);
	СведенияОПокупателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Контрагент, ДанныеПечати.Дата);
	ОфНаименованиеПС = ?(ЗначениеЗаполнено(СведенияОПоставщике.ОфициальноеНаименование), СведенияОПоставщике.ОфициальноеНаименование, СведенияОПоставщике.ПолноеНаименование);
	ОфНаименованиеКР = ?(ЗначениеЗаполнено(СведенияОПокупателе.ОфициальноеНаименование), СведенияОПокупателе.ОфициальноеНаименование, СведенияОПокупателе.ПолноеНаименование);
	ОбластьПодвалаНакладной.Параметры.ПредставлениеОрганизации = Строка(ОфНаименованиеПС) + ", ИНН/КПП: " + ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ИНН,", Ложь) +"/"+ ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "КПП,", Ложь);
	ОбластьПодвалаНакладной.Параметры.ПредставлениеКонтрагента = Строка(ОфНаименованиеКР) + ", ИНН/КПП: " + ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ИНН", Ложь) +"/"+ ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "КПП", Ложь);
	ТабличныйДокумент.Вывести(ОбластьПодвалаНакладной);
КонецПроцедуры

Процедура ЗаполнитьРеквизитыСтрокиТовараГТД(СтрокаТовары, ОбластьМакета)
	
	НомерГТД = СтрЗаменить(СтрокаТовары.НомерГТД, "/", "");
	Если Не ПустаяСтрока(НомерГТД) Тогда
		ОбластьМакета.Параметры.ПредставлениеГТД = Строка(СтрокаТовары.НомерГТД);
		ОбластьМакета.Параметры.ПредставлениеСтраны = СокрЛП(СтрокаТовары.СтранаПроисхождения);
		ОбластьМакета.Параметры.СтранаПроисхожденияКод = ?(ЗначениеЗаполнено(СтрокаТовары.СтранаПроисхождения), СтрокаТовары.СтранаПроисхождения.Код, "");
	Иначе
		ОбластьМакета.Параметры.СтранаПроисхожденияКод = "";
		ОбластьМакета.Параметры.ПредставлениеГТД = "";
		ОбластьМакета.Параметры.ПредставлениеСтраны = "";
	КонецЕсли;
		
КонецПроцедуры // ЗаполнитьРеквизитыСтрокиТовараГТД()

Функция ПолучитьОснованиеДокумента(ДанныеПечати, Основание)

	Если ТипЗнч(ДанныеПечати.Контрагент) = Тип("СправочникСсылка.Контрагенты") И ДанныеПечати.Контрагент.ВРазрезеДоговоров Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 НомерДоговора, ДатаНачала ИЗ Справочник.Контрагенты.Организации ГДЕ Ссылка = &Ссылка И ЗначениеПоУмолчанию");
		Запрос.УстановитьПараметр("Ссылка", ДанныеПечати.Контрагент);
		Выполнение = Запрос.Выполнить();
		
		Если Выполнение.Пустой() Тогда Возврат "<< не указан договор !!! >>" КонецЕсли;
		
		Выборка = Выполнение.Выбрать();
		Выборка.Следующий();
		
		Возврат "Договор №" + Выборка.НомерДоговора + ?(Выборка.ДатаНачала = '00010101', ""," от " + Формат(Выборка.ДатаНачала,"ДЛФ=DD"));
		
	ИначеЕсли ЗначениеЗаполнено(ДанныеПечати.Основание) Тогда
		
		Возврат Основание + " № " + ФормированиеПечатныхФорм.ПолучитьНомерНаПечать(ДанныеПечати.Основание.Номер) + " от " + Формат(ДанныеПечати.Основание.Дата, "ДЛФ=DD");
		
	Иначе Возврат "" КонецЕсли;
	
КонецФункции

//Конец УПД
 
