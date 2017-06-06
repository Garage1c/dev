﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СписокВыбора = Элементы.ОбъектОбработки.СписокВыбора;
	
	Для Каждого Спр ИЗ Метаданные.Справочники Цикл
		
		СписокВыбора.Добавить(Спр.Имя, Спр.Представление());
	КонецЦикла;
	Язык 	= Перечисления.Языки.Немецкий;

КонецПроцедуры

&НаСервере
Функция ПолучитьРеквизитыОбъекта()   
	
	МассивРеквизитов = Новый СписокЗначений;
	МетаОбъект = Метаданные.Справочники[ОбъектОбработки];	
	
	// стандартные
		
	Если МетаОбъект.ДлинаКода > 0 Тогда
		МассивРеквизитов.Добавить("Код", НСтр("ru='Код'; de='code'")); КонецЕсли;
	
	Если МетаОбъект.ДлинаНаименования > 0 Тогда
		МассивРеквизитов.Добавить("Наименование", НСтр("ru='Наименование'; de='Name'")); КонецЕсли;
	
	// пробежимся по реквизитам, если строковые, добавим в список
	
	ПроверяемыйТип = Тип("Строка");
	
	МетаРеквизиты = МетаОбъект.Реквизиты;
	Для Каждого Рекв ИЗ МетаРеквизиты Цикл
		Если Рекв.Тип.СодержитТип(ПроверяемыйТип) Тогда
			МассивРеквизитов.Добавить(Рекв.Имя, ?(ПустаяСтрока(Рекв.Синоним), Рекв.Имя, Рекв.Синоним)); КонецЕсли;
	КонецЦикла;
	
	// получим из общих реквизитов
	
	СвойствоИспользовать = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать;
	   
	Для Каждого ОбщийРеквизит ИЗ Метаданные.ОбщиеРеквизиты Цикл
		
		Элемент = ОбщийРеквизит.Состав.Найти(МетаОбъект);
		
		Если Элемент.Использование = СвойствоИспользовать Тогда
			МассивРеквизитов.Добавить(ОбщийРеквизит.Имя, ?(ПустаяСтрока(ОбщийРеквизит.Синоним), ОбщийРеквизит.Имя, ОбщийРеквизит.Синоним));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивРеквизитов; 	
	
КонецФункции

&НаКлиенте
Процедура СписокРеквизитовНачалоВыбора_ст(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	         
	РеквизитыОбъекта = ПолучитьРеквизитыОбъекта();
	СписокВыбора 	 = Новый СписокЗначений;
	
	// Проставим отметки
	
	СтарыеОтметки = Новый Массив;
	
	СписокВыбора.ЗагрузитьЗначения(РеквизитыОбъекта);
	
	Для Каждого ЭлементСписка Из СписокВыбора Цикл
		
		ЭлементСписка.Пометка = СписокРеквизитов.НайтиПоЗначению(ЭлементСписка.Значение) <> Неопределено;
		Если ЭлементСписка.Пометка Тогда
			СтарыеОтметки.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	// Выберем
	
	Если СписокВыбора.ОтметитьЭлементы("Выбор реквизитов для перевода:") Тогда
		
		// Созадим список
		
		НовыеОтметки = Новый Массив;
		
		СписокРеквизитов.Очистить();
		Для Каждого ЭлементСписка Из СписокВыбора Цикл
			Если ЭлементСписка.Пометка Тогда
				
				ВыбранноеЗначение = ЭлементСписка.Значение;
				
				СписокРеквизитов.Добавить(ВыбранноеЗначение);
				
				Если СтарыеОтметки.Найти(ВыбранноеЗначение) = Неопределено Тогда
					НовыеОтметки.Добавить(ВыбранноеЗначение);
				КонецЕсли;
				
			КонецЕсли; 
			
		КонецЦикла;
		
		ЗаполнитьТаблицуРеквизитов();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбъектОбработкиПриИзменении(Элемент)

	СписокВыбораИД = Элементы.РеквизитИдентификатор.СписокВыбора;
	
	МассивРеквизитов = ПолучитьРеквизитыОбъекта();
	СписокВыбораИД.ЗагрузитьЗначения(МассивРеквизитов.ВыгрузитьЗначения());
	
	ОчиститьПолеПоиска();
	
	Реквизиты.Очистить();
	Для Каждого Строка Из МассивРеквизитов Цикл
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Имя = Строка.Значение;
		НоваяСтрока.Представление = Строка.Представление;
	КонецЦикла;
	
	ЗадатьОбластьТабличногоДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьТабличныйДокумент()
	ТабличныйДокумент.Очистить();
КонецПроцедуры

&НаСервере 
Процедура ОчиститьПолеПоиска()
	
	МетаОбъект = Метаданные.Справочники[ОбъектОбработки];
	РеквизитИдентификатор = ?(МетаОбъект.ДлинаКода > 0, "Код", 
		?(МетаОбъект.ДлинаНаименования > 0, "Наименование","")); 

	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуРеквизитов()
	
	Реквизиты.Очистить();
	
	Если НЕ ПустаяСтрока(РеквизитИдентификатор) Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.ИмяРеквизита = РеквизитИдентификатор;
	КонецЕсли;
	
	Для Каждого Строка ИЗ СписокРеквизитов Цикл
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.ИмяРеквизита = Строка.Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитИдентификаторПриИзменении(Элемент)
	
	ЗадатьОбластьТабличногоДокумента();

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПеревод(Команда)
	
	Если ПустаяСтрока(РеквизитИдентификатор) Тогда
		ПоказатьПредупреждение(,"Не задано поле поиска. Загрузка перевода не может быть выполнена"); Возврат; КонецЕсли;
	
	строшибки = "";
	ЗагрузитьПереводНаСервере(стрОшибки);
	Если ПустаяСтрока(стрОшибки) Тогда
		ПоказатьОповещениеПользователя("Загрузка заверешена",,"Загрузка переводов");
	Иначе
		ОбщиеФункции.СообщитьТекст(стрОшибки);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НайтиОбъект(ИмяОбъекта, РеквизитПоиска, Значение, стрОшибки = "")
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник." + ИмяОбъекта + " ГДЕ " + РеквизитПоиска + " = """ + Значение + """");
	
	Попытка                      // мало ли что подусунули в реквизит...
		Рез = Запрос.Выполнить();
	Исключение
		стрОшибки = "Объект не найден. " +  ОписаниеОшибки();
		Возврат Неопределено;
	КонецПопытки;
	
	Если НЕ Рез.Пустой() Тогда
		
		Выборка = Рез.Выбрать();
		Если Выборка.Следующий() Тогда
			
			Возврат Выборка.Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	стрОшибки = "Объект не найден. Не найдено ни одного объекта по критерию поиска """ + Значение + """";
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПереводНаСервере(стрОшибки = "")
	
	КоличествоСтрок = ТабличныйДокумент.ВысотаТаблицы;
	Менеджер 		= РегистрыСведений.ПереводыРеквизитов;
	
	Для Сч = 2 По КоличествоСтрок Цикл
		
		СтрокаИД = СокрЛП(ТабличныйДокумент.Область("R"+Строка(Сч)+"C2").Текст);
		Если ПустаяСтрока(СтрокаИД) Тогда
			стрОшибки = стрОшибки + "|Строка #" + Строка(Сч-1) + ": Не заполнен реквизит поиска объекта. Выгрузка данных по этой строке не произведена";
			ТабличныйДокумент.Область("R"+Строка(Сч)+"C2").ЦветФона = WebЦвета.Красный;
			Продолжить;
		КонецЕсли;
		Ошибка = "";
		Ссылка = НайтиОбъект(ОбъектОбработки, РеквизитИдентификатор, СтрокаИД, Ошибка);
		Если Ссылка = Неопределено Тогда
			стрОшибки = стрОшибки + "|Строка #" + Строка(Сч-1) + " :" + Ошибка;
			ТабличныйДокумент.Область("R"+Строка(Сч)+"C2").ЦветФона = WebЦвета.Красный;
			Продолжить;
		КонецЕсли;
		
		Ид = 2;
		Для Каждого Строка ИЗ Реквизиты Цикл Если Строка.Выбор Тогда Ид = Ид+1;
			СтрокаРеквизит = ТабличныйДокумент.Область("R"+Строка(Сч)+"C" + Строка(Ид)).Текст;
			НаборСтрока = Менеджер.СоздатьМенеджерЗаписи();
			НаборСтрока.Язык 	= Язык;
		//	НаборСтрока.Объект 	= ОбъектОбработки;
			НаборСтрока.Ссылка 	= Ссылка;
			НаборСтрока.ИмяРеквизита = Строка.Имя;
			НаборСтрока.Перевод = СтрокаРеквизит;
			
			Попытка
				 НаборСтрока.Записать();
			Исключение
				стрОшибки = стрОшибки + "|Строка #" + Строка(Сч-1) + ": Не удалось выполнить запись перевода в базу данных. " + ОписаниеОшибки();
				ТабличныйДокумент.Область("R"+Строка(Сч)+"C" + Строка(Ид)).ЦветФона = WebЦвета.Красный;
			КонецПопытки; 
		КонецЕсли;	
		КонецЦикла;
	КонецЦикла;	 

КонецПроцедуры
&НаСервере
Процедура ЗадатьОбластьТабличногоДокумента()
	
	ТабличныйДокумент.Очистить();
	Макет = Обработки.ЗагрузитьПереводы.ПолучитьМакет("Перевод");
	ОбластьКолонкаНомер = Макет.ПолучитьОбласть("Заголовок|КолонкаНомер");
	ТабличныйДокумент.Присоединить(ОбластьКолонкаНомер);
	
	ОбластьИмя = Макет.ПолучитьОбласть("Заголовок|КолонкаИмя");
	ОбластьИмя.Параметры.ИмяРеквизита = РеквизитИдентификатор;
	ТабличныйДокумент.Присоединить(ОбластьИмя); 

	Для Каждого Строка Из Реквизиты Цикл Если Строка.Выбор Тогда
		ОбластьИмя.Параметры.ИмяРеквизита = Строка.Представление;
		ТабличныйДокумент.Присоединить(ОбластьИмя); КонецЕсли;
	КонецЦикла;
	
	Область = Макет.ПолучитьОбласть("Строки");
	//Для Сч = 1 По КоличествоСтрок Цикл
	//	Область.Параметры.Номер = Сч;
	ТабличныйДокумент.Вывести(Область);
	//КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьОбласть_ст(Команда)
	ИД = Ложь;
	Для Каждого Строка Из СписокРеквизитов Цикл
		Если Строка.Пометка Тогда ЕстьИД = Истина; Прервать; КонецЕсли;
	КонецЦикла;
	Если НЕ ЕстьИД Тогда
		ПоказатьПредупреждение(,"Идентификатор объекта не задан",,"Предупреждение"); Возврат; КонецЕсли;
	ЗадатьОбластьТабличногоДокумента();
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыВыборПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Реквизиты.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ТекущиеДанные.НомерКолонки = 0;
		ПеренумероватьКолонки();
	КонецЕсли;
	ЗадатьОбластьТабличногоДокумента();

КонецПроцедуры

&НаКлиенте
Процедура ТабличныйДокументПриИзменении(Элемент)
	ТабличныйДокументПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ТабличныйДокументПриИзмененииНаСервере()
	
	КоличествоСтрок = ТабличныйДокумент.ВысотаТаблицы;
	
	Для Сч = 2 По КоличествоСтрок Цикл ТабличныйДокумент.Область("R"+Строка(Сч)+"C1").Текст = Строка(Сч-1); КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СписокВыбораИД = Элементы.РеквизитИдентификатор.СписокВыбора;
	
	МассивРеквизитов = ПолучитьРеквизитыОбъекта();
	СписокВыбораИД.ЗагрузитьЗначения(МассивРеквизитов.ВыгрузитьЗначения());
	ЗадатьОбластьТабличногоДокумента();

	//Реквизиты.Очистить();
//	ОбъектОбработкиПриИзмененииНаСервере();
	//Для Каждого Строка Из МассивРеквизитов Цикл
	//	НоваяСтрока = Реквизиты.Добавить();
	//	НоваяСтрока.Имя = Строка.Значение;
	//	НоваяСтрока.Представление = Строка.Представление;
	//КонецЦикла;
	//

КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	ЗадатьОбластьТабличногоДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ТабличныйДокументПриИзмененииСодержимогоОбласти(Элемент, Область)
	ТабличныйДокументПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	//Для Каждого Строка ИЗ ПараметрыПеретаскивания.Значение Цикл
	Строка = ПараметрыПеретаскивания.Значение;
	
	// перенумерация если перетаскивают выбранную колонку
	Если Строка.Выбор Тогда	ПеренумероватьКолонки(); КонецЕсли;
	//КонецЦикла;
	
	ЗадатьОбластьТабличногоДокумента();	
			
КонецПроцедуры

&НаКлиенте
Процедура ПеренумероватьКолонки()
	
	Строки = Реквизиты.НайтиСтроки(Новый Структура("Выбор", Истина));
	Ном = 0;
	Для Каждого Строка Из Строки Цикл Ном = Ном + 1; Строка.НомерКолонки = Ном;	КонецЦикла;

КонецПроцедуры
