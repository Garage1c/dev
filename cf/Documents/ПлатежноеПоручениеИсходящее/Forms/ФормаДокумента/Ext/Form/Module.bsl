﻿&НаКлиенте
Перем ОрганизацияПоДокументу;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		МассивРеквизитов = ФункцииФормДокументов.ПолучитьРеквизитыДокумента(Документы.ПлатежноеПоручениеИсходящее.ПустаяСсылка());
		МассивРеквизитов.Удалить(МассивРеквизитов.Найти("СтавкаНДС"));
		
		ФункцииФормДокументов.ЗаполнитьЗначенияПоУмолчанию(
					Объект,
					МассивРеквизитов);
		
	КонецЕсли;	
		
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Объект.Организация"));
	Элементы.БанковскийСчетОрганизации.СвязиПараметровВыбора  = Новый ФиксированныйМассив(НовыйМассив);
	
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Объект.Контрагент"));
	Элементы.БанковскийСчетПартнера.СвязиПараметровВыбора = Новый ФиксированныйМассив(НовыйМассив);
	
	УправлениеВидимостью();

КонецПроцедуры



 &НаСервере
Процедура КонтрагентПриИзмененииНаСервере(ЗаполнитьОрганизацию = Истина)
	
	ФункцииФормДокументов.КонтрагентПриИзменении(ОБъект, ЗаполнитьОрганизацию = Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	
	Если НЕ ДиалогиСПользователем.ПроверитьНаСоответствиеОсновнойОрганизации(
				Объект.Контрагент, 
				Объект.Организация, 
				КонтрагентРаботаетСОрганизацией(Объект.Контрагент, Объект.Организация)) Тогда
				
		Объект.Организация = ОрганизацияПоДокументу;
		КонтрагентПриИзмененииНаСервере(Ложь);
	Иначе
		КонтрагентПриИзмененииНаСервере();
		ОрганизацияПоДокументу = Объект.Организация;
	КонецЕсли;	

КонецПроцедуры


Функция КонтрагентРаботаетСОрганизацией(Контрагент, Организация)
	
	Возврат Справочники.Контрагенты.КонтрагентРаботаетСОрганизацией(Контрагент, Организация);
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ФункцииФормДокументов.ОрганизацияПриИзменении(Объект);
	
КонецПроцедуры
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ДиалогиСПользователем.ПроверитьНаСоответствиеОсновнойОрганизации(
				Объект.Контрагент, 
				Объект.Организация, 
				КонтрагентРаботаетСОрганизацией(Объект.Контрагент, Объект.Организация)) Тогда
		
		//ОрганизацияПриИзмененииНаСервере();
		ОрганизацияПоДокументу = Объект.Организация;
		
	Иначе
		
		Объект.Организация = ОрганизацияПоДокументу;
		
	КонецЕсли;
    ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОрганизацияПоДокументу = Объект.Организация;
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРеквизиты(Команда)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизиты(ЭтаФорма);

КонецПроцедуры

Процедура РассчитатьСуммуНДС()
	Если 	Объект.УчитыватьНДС = Истина Тогда
		
		СтавкаНДС = КэшируемыеФункции.ПолучитьЧислоСтавкиНДС(Объект.СтавкаНДС);

		Если СтавкаНДС И Объект.СуммаВключаетНДС Тогда	
			Объект.СуммаНДС = СтавкаНДС * Объект.Сумма / (СтавкаНДС + 100);
		Иначе
			Объект.СуммаНДС = СтавкаНДС * Объект.Сумма / 100;
		КонецЕсли;
	КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	Если Элементы.НДС.Видимость Тогда
		РассчитатьСуммуНДС();
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)
	РассчитатьСуммуНДС();
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостью()
	
	ЭтоОплата = (Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ОплатаПоставщику) ИЛИ (Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ВозвратПокупателю); 
	
	Элементы.ДокументОснование.Видимость = ЭтоОплата;
	Элементы.НДС.Видимость				 = ЭтоОплата;

	Если НЕ ЭтоОплата Тогда
		Объект.ДокументОснование = Неопределено;
		Объект.СтавкаНДС = Неопределено;
		Объект.СуммаНДС	 = 0;
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.СтавкаНДС) Тогда
		Объект.СтавкаНДС = ОбщиеФункции.НастройкаПользователя("ПоУмолчанию_СтавкаНДС");
		РассчитатьСуммуНДС();
	КонецЕсли;
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеПодотчетномуЛицу Тогда
		Элементы.ФизЛицо.Заголовок = "Подотчетное лицо";
	Иначе
		Элементы.ФизЛицо.Заголовок = "Работник организации";
	КонецЕсли;
	
	ЗаполнитьФизЛицо = Объект.СтатьяДвиженияДенежныхСредств.РеквизитКЗаполнению = "ФизЛицо";
	Элементы.ФизЛицо.Видимость 			= ЗаполнитьФизЛицо;
	Если НЕ ЗаполнитьФизЛицо Тогда
		Объект.ФизЛицо = Неопределено;
	КонецЕсли;
	
	ЗаполнитьУровниБюджетов = Объект.СтатьяДвиженияДенежныхСредств.РеквизитКЗаполнению = "УровниБюджетов";
	Элементы.УровниБюджетов.Видимость 		= ЗаполнитьУровниБюджетов;
	Если НЕ ЗаполнитьУровниБюджетов Тогда
		Объект.УровниБюджетов = Неопределено;
	КонецЕсли;
	
	ЗаполнитьНомерДоговора = Объект.СтатьяДвиженияДенежныхСредств.РеквизитКЗаполнению = "ДоговорКонтрагента" ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.РасчетыПоКредитамИЗаймам;
	Элементы.НомерДоговора.Видимость = ЗаполнитьНомерДоговора;
	Если НЕ ЗаполнитьНомерДоговора Тогда
		Объект.НомерДоговора = "";
	КонецЕсли;
	
	ЗаполнитьВедомость = Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеЗП;
	Элементы.НомерВедомости.Видимость = ЗаполнитьВедомость;
	Если НЕ ЗаполнитьВедомость Тогда
		Объект.НомерВедомости = "";
	КонецЕсли;
	
	ЗаполнитьВидПлатежа = Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога;
	Элементы.ВидПлатежаВБюджет.Видимость = ЗаполнитьВидПлатежа;
	Если Не ЗаполнитьВидПлатежа Тогда
		Объект.ВидПлатежаВБюджет = Неопределено;
	КонецЕсли;
	
	Элементы.РасшифровкаСуммы.Видимость =  Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ВозвратПокупателю;
	
	Элементы.Сумма.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.НазначениеПлатежа.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	//Элементы.СтатьяДвиженияДенежныхСредств.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	//Элементы.СтатьяДДСБух.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.ВидОперации.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.Контрагент.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.Организация.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.БанковскийСчетОрганизации.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.БанковскийСчетПартнера.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.Подразделение.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.Отдел.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.СтавкаНДС.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.СуммаНДС.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.Дата.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.НомерВходящегоДокумента.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.БезВзаиморасчетов.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.ОтветственныйЗаПлатёж.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.НомерДоговора.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.ВидПлатежаВБюджет.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.ОбщиеРеквизиты.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	УправлениеВидимостью();
	ЗаполнитьСтатьиДДС();
КонецПроцедуры
&НаКлиенте
Процедура ПоискВБухгалтерии(Команда)
	ВыбранноеЗначение = ОткрытьФорму("ОбщаяФорма.ПоискПартнераВБухгалтерии",Новый Структура("Контрагент", Объект.Контрагент), ЭтаФорма,,,,Новый ОписаниеОповещения("ОбработкаПоискВБухгалтерии",ЭтаФорма,));
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПоискВБухгалтерии(Результат, Параметры) Экспорт
	Если Результат <> Неопределено Тогда
		Объект.Контрагент = Результат;
		КонтрагентПриИзмененииНаСервере();
	   	ОрганизацияПоДокументу = Объект.Организация;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ВыборВедомости(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Объект.НомерВедомости = ВыбранныйЭлемент.Значение; КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура НомерВедомостиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Connector 		= ИнтеграцияСБухгалтерией.ИницилизироватьCOMConnectorБухгалтерии();
	Организация81 	= Connector.Справочники.Организации.ПолучитьСсылку(Connector.NewObject("UUID", Строка(Объект.Организация.УникальныйИдентификатор())));
	
	Список = ИнтеграцияСБухгалтерией.ПолучитьВедомостиНаВыплатуЗП(Connector, Организация81);
	Если Список = Неопределено Тогда
		ПоказатьОповещениеПользователя("Нечего выбирать");
	Иначе
		ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ВыборВедомости", ЭтаФорма), Список); КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборДоговора(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Объект.НомерДоговора = ВыбранныйЭлемент.Значение; КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура НомерДоговораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Connector 		= ИнтеграцияСБухгалтерией.ИницилизироватьCOMConnectorБухгалтерии();
	Контрагент81 	= Connector.Справочники.Контрагенты.ПолучитьСсылку(Connector.NewObject("UUID", Строка(Объект.Контрагент.УникальныйИдентификатор())));	
	
	Список = ИнтеграцияСБухгалтерией.ПолучитьДоговорыКонтрагента(Connector, Контрагент81);
	Если Список = Неопределено Тогда
		ПоказатьОповещениеПользователя("Нечего выбирать");
	Иначе
		ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ВыборДоговора", ЭтаФорма), Список); 
	КонецЕсли;
	
КонецПроцедуры

#Область ПодобратьЗаказы

&НаКлиенте
Процедура ПодобратьЗаказы(Команда)

	АдресРасшифровкиСуммы=ПоместитьТЧвВХ();
	стрВозврТабл = ОткрытьФорму("ОбщаяФорма.ПодборЗаказовДляДокументовОплаты", 
			Новый Структура("Контрагент, Сумма, ТекущийДокумент, АдресРасшифровкиСуммы,ЭтоВозвратОплаты", 
					Объект.Контрагент, 
					Объект.Сумма,
					Объект.Ссылка,
					АдресРасшифровкиСуммы,
					Истина),,,,,Новый ОписаниеОповещения("ОбработкаПодбораЗаказов",ЭтаФОрма,));

КонецПроцедуры

&НаСервере
Функция ПоместитьТЧвВХ(); 
	Возврат ПоместитьВоВременноеХранилище(Объект.РасшифровкаСуммы.Выгрузить());
КонецФункции	

&НаКлиенте
Процедура ОбработкаПодбораЗаказов(Результат, Параметры) Экспорт
	Если Результат <> Неопределено Тогда
		ЗаполнитьПодобранныеЗаказы(Результат);
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьПодобранныеЗаказы(стрВозврТабл)
	
	ТЗ= ЗначениеИзСтрокиВнутр(стрВозврТабл);
	Модифицированность=Истина;	
	Объект.РасшифровкаСуммы.Очистить();
	Объект.РасшифровкаСуммы.Загрузить(ТЗ);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗаказыАвтоматом(Команда)
	
	ОтветРобота = ЗаполнитьЗаказыАвтоматомНаСервере();
	ПоказатьОповещениеПользователя(ОтветРобота,,,БиблиотекаКартинок.Робот);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьЗаказыАвтоматомНаСервере()
	
	Парам=Новый Структура("Контрагент,Ссылка,Сумма,НазначениеПлатежа,ВидДокумента",Объект.Контрагент,Объект.Ссылка,Объект.Сумма,Объект.НазначениеПлатежа,Объект.Ссылка.Метаданные().Имя);
	Рез=ВзаиморасчетыСервер.ПолучитьЗаказыДляПлатежки(Парам);
	ТЗ=Рез.ТабЗаказов;
	ОтветРобота=Рез.ОтветРобота;
	Если ТЗ.Количество() Тогда
		
		Объект.РасшифровкаСуммы.Очистить();
		Объект.РасшифровкаСуммы.Загрузить(ТЗ);
		
		
	КонецЕсли;	
	
	Возврат ОтветРобота;
	
КонецФункции

#КонецОбласти

#Область СтатьяДДС
&НаСервере
Процедура ЗаполнитьСтатьиДДС()
	Если Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ВозвратПокупателю ТОГДА
		Объект.СтатьяДвиженияДенежныхСредств = КэшируемыеФункции.ПолучитьСтатьюВозвратПокупателю();
	ИначеЕсли
		Объект.ВидОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ОплатаПоставщику ТОГДА
		Объект.СтатьяДвиженияДенежныхСредств = КэшируемыеФункции.ПолучитьСтатьюОплатаПоставщику();
	КонецЕсли;
	
	СтатьяДДСПриИзмененииНаСервере(Объект.СтатьяДвиженияДенежныхСредств, Объект.СтатьяДДСБух);
	
КонецПроцедуры
&НаСервере
Процедура СтатьяДДСПриИзмененииНаСервере(Ст1, Ст2)
	
	ФункцииФормДокументов.ПриИзмененииСтатьиДДС(Ст1, Ст2);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДвиженияДенежныхСредствПриИзменении(Элемент)
	
	СтатьяДДСПриИзмененииНаСервере(Объект.СтатьяДвиженияДенежныхСредств, Объект.СтатьяДДСБух);
	УправлениеВидимостью();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДДСБухПриИзменении(Элемент)
	
	//ФункцииФормДокументов.ПриИзмененииСтатьиДДС(Объект.СтатьяДДСБух, Объект.СтатьяДвиженияДенежныхСредств);
	//УправлениеВидимостью();
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗапретРедактирования.УстановитьРежимТолькоПросмотрПоДатеЗапрета(ЭтаФорма);

КонецПроцедуры
