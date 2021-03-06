﻿
&НаКлиенте
Перем ОрганизацияПоДокументу, ПартнерПоДокументу;


&НаКлиенте
Процедура ОбщиеРеквизиты(Команда)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизиты(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	    
	Если Объект.Ссылка.Пустая() Тогда
		
		МассивРеквизитов = ФункцииФормДокументов.ПолучитьРеквизитыДокумента(Документы.ПлатежноеПоручениеВходящее.ПустаяСсылка());
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
Функция КонтрагентРаботаетСОрганизацией() Экспорт
	
	Возврат Справочники.Контрагенты.КонтрагентРаботаетСОрганизацией(Объект.Контрагент, Объект.Организация);
	
КонецФункции
&НаСервере
Функция КонтраСоргой(Контрагент, Организация) Экспорт
	
	Возврат Справочники.Контрагенты.КонтрагентРаботаетСОрганизацией(Контрагент, Организация);
	
КонецФункции


// ЗАПОЛНИТЬ ОПЛАТУ

&НаКлиенте
Процедура АнализОплат(Команда)
	
	ОткрытьФорму("Обработка.ДолгиПоОплате_Управление.Форма.Управление", 
			Новый Структура("Организация, Контрагент", 
						Объект.Организация, 
						Объект.Контрагент));
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере(ЗаполняемаяСумма = 0)
	
	Заказы.ЗаполнитьТаблицуДокументаОплаты(Объект, ЗаполняемаяСумма);
			
КонецПроцедуры
&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры
&НаКлиенте
Процедура ЗаполнитьПоСумме(Команда)
	
	Сумма = Объект.Сумма;
	
	Если ВвестиЧисло(Сумма, "Сумма заполнения:", 15,2) Тогда
		
		ЗаполнитьНаСервере(Сумма);
		
	КонецЕсли;
	
КонецПроцедуры

//ПОДОБРАТЬ ЗАКАЗЫ

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
					Ложь),,,,,Новый ОписаниеОповещения("ОбработкаПодбораЗаказов",ЭтаФОрма,));

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
	
	Если ПроверитьОтделы(ТЗ) Тогда
		
		Модифицированность=Истина;
		
		Объект.РасшифровкаСуммы.Очистить();
		Объект.РасшифровкаСуммы.Загрузить(ТЗ);
		
		ЗаполнитьОтдел();
		
	КонецЕсли;
	
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
		
		ЗаполнитьОтдел();
		Модифицированность=Истина;
		
	КонецЕсли;	
	
	Возврат ОтветРобота;
	
КонецФункции

#КонецОбласти


&НаСервере
Функция ПроверитьОтделы(ТЗ)
	
	Если Объект.Контрагент.ОсновнойМенеджер = Справочники.Пользователи.СвободныйЛид 
		ИЛИ НЕ ЗначениеЗаполнено(Объект.Контрагент.ОсновнойМенеджер) Тогда
		
		ВТ=Новый таблицаЗначений;
		ВТ.Колонки.Добавить("Отдел");
		Для Каждого Стр Из ТЗ Цикл
			Если ЗначениеЗаполнено(Стр.Заказ) Тогда
				НовСтр=ВТ.Добавить();
				НовСтр.Отдел = Стр.Заказ.Автор.Отдел;
			КонецЕсли;
		КонецЦикла;	
		ВТ.Свернуть("Отдел");
		Если ВТ.Количество()>1 Тогда
			Сообщить("Для свободного лида нельзя выбирать заказы с авторами из разных отделов (Заказ.Автор.Отдел)! Платежка должна быть на один отдел.");
			Возврат Ложь;
		КонецЕсли;	
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьОтдел()
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Если ЗначениеЗаполнено(Объект.Контрагент.ОсновнойМенеджер) Тогда
			Если Объект.Контрагент.ОсновнойМенеджер <> Справочники.Пользователи.СвободныйЛид Тогда
				Объект.Отдел = Объект.Контрагент.ОсновнойМенеджер.Отдел;
				Объект.Подразделение = Объект.Отдел.Подразделение;
			Иначе//если свободный лид - берем из автора заказа 
				Объект.Отдел = "";
				Если Объект.РасшифровкаСуммы.Количество()>0 Тогда
					Если ЗначениеЗаполнено(Объект.РасшифровкаСуммы[0].Заказ) Тогда
						Объект.Отдел = Объект.РасшифровкаСуммы[0].Заказ.Автор.Отдел;
					КонецЕсли;	
					Объект.Подразделение = Объект.Отдел.Подразделение;
				КонецЕсли;	
			КонецЕсли;
		Иначе// если основной менеджер не заполнен - это все равно что свободный лид
			Объект.Отдел = "";
			Если Объект.РасшифровкаСуммы.Количество()>0 Тогда
				Если ЗначениеЗаполнено(Объект.РасшифровкаСуммы[0].Заказ) Тогда
					Объект.Отдел = Объект.РасшифровкаСуммы[0].Заказ.Автор.Отдел;
				КонецЕсли;	
				Объект.Подразделение = Объект.Отдел.Подразделение;
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры


// ПРИ Изменении

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ФункцииФормДокументов.ОрганизацияПриИзменении(Объект);
	
КонецПроцедуры
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если НЕ ДиалогиСПользователем.ПроверитьНаСоответствиеОсновнойОрганизации(
				Объект.Контрагент, 
				Объект.Организация, 
				КонтраСоргой(Объект.Контрагент, Объект.Организация)) Тогда
		
		Объект.Организация = ОрганизацияПоДокументу;
	КонецЕсли;	
	
	ОрганизацияПриИзмененииНаСервере();
    ОрганизацияПоДокументу = Объект.Организация;

КонецПроцедуры


&НаСервере
Процедура КонтрагентПриИзмененииНаСервере(ЗаполнитьОрганизацию = Истина)
	
	
	ФункцииФормДокументов.КонтрагентПриИзменении(Объект, ЗаполнитьОрганизацию);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	
	Если НЕ ДиалогиСПользователем.ПроверитьНаСоответствиеОсновнойОрганизации(
				Объект.Контрагент, 
				Объект.Организация, 
				КонтраСоргой(Объект.Контрагент, Объект.Организация)) Тогда
				
		Объект.Организация = ОрганизацияПоДокументу;
		КонтрагентПриИзмененииНаСервере(Ложь);
	Иначе
		КонтрагентПриИзмененииНаСервере();
		ОрганизацияПоДокументу = Объект.Организация;
	КонецЕсли;	
	
	ЗаполнитьОтдел();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОрганизацияПоДокументу = Объект.Организация;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуРасшифровки(ВыбранноеЗначение)
	
	Объект.РасшифровкаСуммы.Очистить();
	Объект.РасшифровкаСуммы.Загрузить(ЗначениеИзСтрокиВнутр(ВыбранноеЗначение));
	
КонецПроцедуры
&НаКлиенте
Процедура ПодтвердитьОплатуКартой(Команда)
	ВыбранноеЗначение = ОткрытьФорму("Документ.ЧекККМ.Форма.ФормаПодтвержденияОплатПоКартам", Новый Структура("ДатаВыборки", Объект.Дата),ЭтаФорма,,,,Новый ОписаниеОповещения("ОбработкаПодтвержденияОплатыКартой",ЭтаФорма,));
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПодтвержденияОплатыКартой(Результат, Парамтеры) Экспорт
	Если Результат <> Неопределено Тогда
		ЗаполнитьТаблицуРасшифровки(Результат);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостью()
	
	ЭтоОплата =  Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя;
	ЗаполнятьНДС = ЭтоОплата ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ВозвратОтПоставщика;
	Элементы.НДС.Видимость = ЗаполнятьНДС;
	
	
	Если НЕ ЗаполнятьНДС Тогда
		Объект.СтавкаНДС = Неопределено;
		Объект.СуммаНДС	 = 0;
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.СтавкаНДС) Тогда
		Объект.СтавкаНДС = ОбщиеФункции.НастройкаПользователя("ПоУмолчанию_СтавкаНДС");
		РассчитатьСуммуНДС();
	КонецЕсли;
	
	ЭтоОплатаПоБанковскойКарте = Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПоБанковскойКарте;
	
	Элементы.Расшифровка.Видимость = ЭтоОплата ИЛИ ЭтоОплатаПоБанковскойКарте;
	
	//ЗаполнитьРеквизитыПокупкиВалюты = Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПриобретениеИностраннойВалюты;
	ЗаполнитьРеквизитыПокупкиВалюты = Ложь;
	Элементы.ПокупкаВалюты.Видимость = ЗаполнитьРеквизитыПокупкиВалюты;
	Если НЕ ЗаполнитьРеквизитыПокупкиВалюты и Объект.Ссылка.Пустая() Тогда
		Объект.КурсВзаиморасчетов = 1;
		Объект.КурсЦБНаДатуПриобретенияВалюты = 0;
		Объект.СуммаВзаиморасчетов = 0;
		Объект.Валюта = ОбщиеФункции.НастройкаПользователя("ПоУмолчанию_Валюта");
	КонецЕсли;
	
	ЗаполнитьНомерДоговора = ЗаполнитьРеквизитыПокупкиВалюты ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.РасчетыПоКредитамИЗаймам;
	Элементы.НомерДоговора.Видимость = ЗаполнитьНомерДоговора;
	Если НЕ ЗаполнитьНомерДоговора Тогда
		Объект.НомерДоговора = "";
	КонецЕсли;
	
	//
	Элементы.Сумма.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.НазначениеПлатежа.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.ВидОперации.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.Контрагент.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.Организация.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.БанковскийСчетОрганизации.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.БанковскийСчетПартнера.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.Подразделение.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.Отдел.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер") ИЛИ РольДоступна("РаботатьСОптовымиПокупателями"),Истина, Ложь); 
	Элементы.СтавкаНДС.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.СуммаНДС.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.Дата.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.НомерВходящегоДокумента.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь); 
	Элементы.ФормаДополнительныеРеквизиты.Доступность = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер"),Истина, Ложь);
	
	Элементы.РасшифровкаСуммы.ТолькоПросмотр = ?(РольДоступна("ПолныеПрава") ИЛИ РольДоступна("Бухгалтер") ИЛИ РольДоступна("ПолныеПраваВОбласти"),Ложь, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
 	УправлениеВидимостью();
	ЗаполнитьСтатьиДДС();
КонецПроцедуры


&НаКлиенте
Процедура ПоискВБухгалтерии(Команда)
	ВыбранноеЗначение = ОткрытьФорму("ОбщаяФорма.ПоискПартнераВБухгалтерии",Новый Структура("Контрагент", Объект.Контрагент), ЭтаФорма,,,,Новый ОписаниеОповещения("ОбработкаПоискаВБухгалтерии",ЭтаФорма,));
КонецПроцедуры
&НаКлиенте
Процедура ОбработкаПоискаВБухгалтерии(Результат, Параметры) Экспорт
	Если Результат <> Неопределено Тогда
		Объект.Контрагент = Результат;
		КонтрагентПриИзмененииНаСервере();
	   	ОрганизацияПоДокументу = Объект.Организация;		
	КонецЕсли;	
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

Процедура РасчитатьСуммуВзаиморасчетов(Элемент = "")
		
	Если Элемент = "СуммаВзаиморасчетов" Тогда
		Объект.КурсВзаиморасчетов = ?(Объект.СуммаВзаиморасчетов = 0, 0, Объект.СуммаВзаиморасчетов /Объект.Сумма);
	Иначе
		Объект.СуммаВзаиморасчетов = Объект.Сумма * Объект.КурсВзаиморасчетов;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	Если Элементы.НДС.Видимость Тогда
		РассчитатьСуммуНДС();
	КонецЕсли;
	
	Если Элементы.ПокупкаВалюты.Видимость Тогда
		РасчитатьСуммуВзаиморасчетов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаВзаиморасчетовПриИзменении(Элемент)
	РасчитатьСуммуВзаиморасчетов(Элемент.Имя);
КонецПроцедуры
&НаКлиенте
Процедура КурсВзаиморасчетовПриИзменении(Элемент)
	РасчитатьСуммуВзаиморасчетов();
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)
	РассчитатьСуммуНДС();
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
		ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ВыборДоговора", ЭтаФорма), Список); КонецЕсли;

КонецПроцедуры

Функция ПолучитьКурсВалютНаДату(Дата = Неопределено, Валюта)
	
	Если Дата = Неопределено Тогда
		Дата = ТекущаяДата();
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ Курс ИЗ РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта)");
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Курс;
	КонецЕсли;
	
	Возврат 0;

КонецФункции
Процедура УстановитьКурсВалют()
	Объект.КурсЦБНаДатуПриобретенияВалюты = ПолучитьКурсВалютНаДату(Объект.Дата, Объект.Валюта);
	Объект.КурсВзаиморасчетов = Объект.КурсЦБНаДатуПриобретенияВалюты;
	РасчитатьСуммуВзаиморасчетов();
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	УстановитьКурсВалют();	
КонецПроцедуры

Процедура УстановитьВалюту()
	Объект.Валюта = Объект.БанковскийСчетОрганизации.ВалютаДенежныхСредств;
	УстановитьКурсВалют();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРасшифровкуСуммыНаСервере()
	
	Объект.РасшифровкаСуммы.Загрузить(Документы.ПлатежноеПоручениеВходящее.ЗаполнитьРасшифровкуСуммы(Объект.Ссылка));		
	
КонецПроцедуры
 
&НаКлиенте
Процедура ЗаполнитьРасшифровкуСуммы(Команда)
	ЗаполнитьРасшифровкуСуммыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетОрганизацииПриИзменении(Элемент)
	УстановитьВалюту();
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаСуммыЗаказПриИзменении(Элемент)
	
	//ТекущиеДанные = Элементы.РасшифровкаСуммы.ТекущиеДанные;
	//Если ТекущиеДанные <> Неопределено И ТипЗнч(ТекущиеДанные.Заказ) <> Тип("Неопределено") И ТекущиеДанные.Заказ.Пустая() Тогда
	//	ТекущиеДанные.Заказ = Неопределено;
	//КонецЕсли;
	//	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаСуммыДокументОтгрузкиПриИзменении(Элемент)
	
	//ТекущиеДанные = Элементы.РасшифровкаСуммы.ТекущиеДанные;
	//Если ТекущиеДанные <> Неопределено И ТипЗнч(ТекущиеДанные.Заказ) <> Тип("Неопределено") И ТекущиеДанные.Заказ.Пустая() Тогда
	//	ТекущиеДанные.Заказ = Неопределено;
	//КонецЕсли;
	//	

КонецПроцедуры

Процедура ОчиститьРасшифровкуПлатежа()
	Объект.РасшифровкаСуммы.Очистить();	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	//Если Вопрос("Изменение даты приведет к очищению расшифровки суммы платежа.
	//|Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
	//	ОчиститьРасшифровкуПлатежа();
	//КонецЕсли;
КонецПроцедуры

#Область СтатьяДДС

&НаСервере
Процедура ЗаполнитьСтатьиДДС()
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя ТОГДА
		Объект.СтатьяДвиженияДенежныхСредств = КэшируемыеФункции.ПолучитьСтатьюОплатаПокупателя();
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ВозвратОтПоставщика ТОГДА
		Объект.СтатьяДвиженияДенежныхСредств = КэшируемыеФункции.ПолучитьСтатьюВозвратПоставщика();
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПоступлениеОтОператораПлатежнойСистемы ТОГДА
		Объект.СтатьяДвиженияДенежныхСредств = КэшируемыеФункции.ПолучитьСтатьюПоступлениеОтОператораПлатежнойСистемы();
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
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДДСБухПриИзменении(Элемент)
	
	//ФункцииФормДокументов.ПриИзмененииСтатьиДДС(Объект.СтатьяДДСБух, Объект.СтатьяДвиженияДенежныхСредств);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗапретРедактирования.УстановитьРежимТолькоПросмотрПоДатеЗапрета(ЭтаФорма);

КонецПроцедуры
