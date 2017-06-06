﻿
Функция ПолучитьТелефонОрганизацииКонтрагента(Объект) Экспорт
	
	// Возвращает строковое представление телефона организации по коду 29 ))
	// проверяет у контры, если нету то у организации
	
	ЭтоКонтрагент = ТипЗнч(Объект) = Тип("СправочникСсылка.Контрагенты");
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1 ВЫРАЗИТЬ(Представление КАК СТРОКА(80)) Представление ИЗ РегистрСведений.ПредставлениеКонтактнойИнформации 
	|ГДЕ Объект = &Объект И Вид = &ВидТелефонОрганизации
	|" + ?(ЭтоКонтрагент,"ОБЪЕДИНИТЬ
	|ВЫБРАТЬ ПЕРВЫЕ 1 ВЫРАЗИТЬ(Представление КАК СТРОКА(80)) Представление ИЗ РегистрСведений.ПредставлениеКонтактнойИнформации 
	|ГДЕ Объект = &Партнер И Вид = &ВидТелефонОрганизации","") + "
	|");
	
	Запрос.УстановитьПараметр("Объект", 			Объект);
	Запрос.УстановитьПараметр("ВидТелефонОрганизации", 	Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00006"));
	Если ЭтоКонтрагент Тогда Запрос.УстановитьПараметр("Партнер", Объект.Партнер); КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();	
	Возврат ?(Выборка.Следующий(), Выборка.Представление, "");
	
КонецФункции


// Возвращает структуру данных со сводным описанием контрагента
//
// Параметры: 
//  СписокСведений - список значений со значениями параметров организации
//   СписокСведений формируется функцией СведенияОЮрФизЛице
//  Список         - список запрашиваемых параметров организации
//  СПрефиксом     - Признак выводить или нет префикс параметра организации
//
// Возвращаемое значение:
//  Строка - описатель организации / контрагента / физ.лица.
//
Функция ОписаниеОрганизации(СписокСведений, Список = "", СПрефиксом = Истина, Разделитель = ",") Экспорт

	Если ПустаяСтрока(Список) Тогда
		Список = "ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет";
	КонецЕсли;

	Результат = "";

	СоответствиеПараметров = Новый Соответствие();
	СоответствиеПараметров.Вставить("ПолноеНаименование", " ");
	СоответствиеПараметров.Вставить("ИНН",                " ИНН ");
	СоответствиеПараметров.Вставить("КПП",                " КПП ");
	СоответствиеПараметров.Вставить("ЮридическийАдрес",   " ");
	СоответствиеПараметров.Вставить("ФактическийАдрес",   " ");
	СоответствиеПараметров.Вставить("Телефоны",           " ");
	СоответствиеПараметров.Вставить("НомерСчета",         " р/с ");
	СоответствиеПараметров.Вставить("Банк",               " в банке ");
	СоответствиеПараметров.Вставить("БИК",                " БИК ");
	СоответствиеПараметров.Вставить("КоррСчет",           " к/с ");
	СоответствиеПараметров.Вставить("КодПоОКПО",          " Код по ОКПО ");

	Список          = Список + ?(Прав(Список, 1) = ",", "", ",");
	ЧислоПараметров = СтрЧислоВхождений(Список, ",");

	Для Счетчик = 1 по ЧислоПараметров Цикл

		ПозЗапятой = Найти(Список, ",");

		Если ПозЗапятой > 0  Тогда
			
			ИмяПараметра = Лев(Список, ПозЗапятой - 1);
			Список       = Сред(Список, ПозЗапятой + 1, СтрДлина(Список));

			Попытка
				СтрокаДополнения = "";
				СписокСведений.Свойство(ИмяПараметра, СтрокаДополнения);

				Если ПустаяСтрока(СтрокаДополнения) Тогда
					Продолжить;
				КонецЕсли;

				Префикс = СоответствиеПараметров[ИмяПараметра];
				Если Не ПустаяСтрока(Результат)  Тогда
					Результат = Результат + Разделитель;
				КонецЕсли; 

				Результат = Результат + ?(СПрефиксом = Истина, Префикс, "") + СтрокаДополнения;
			Исключение
				
				ТекстСообщения  = НСтр("ru='Не удалось определить значение параметра организации: %ИмяПараметра%'");
				ТекстСообщения  = СтрЗаменить(ТекстСообщения,"%ИмяПараметра%",ИмяПараметра);
				Сообщение       = Новый СообщениеПользователю();
				Сообщение.Текст = ТекстСообщения;
				Сообщение.Сообщить();
				
			КонецПопытки;

		КонецЕсли;

	КонецЦикла;

	Возврат СокрЛП(Результат);

КонецФункции // ОписаниеОрганизации()

// Функция находит актуальное значение телефона в контакной информации.
//
// Параметры:
//  Объект - СправочникСсылка, объект контактной информации
//
// Возвращаемое значение
//  Строка - представление найденного телефона
//
Функция ПолучитьТелефонИзКонтактнойИнформации(Объект) Экспорт

	СтрокаРезультат = "";
	
	Если ЗначениеЗаполнено(Объект) Тогда
		
		Запрос = Новый Запрос("	ВЫБРАТЬ
								|	Представление, ЗначениеПоУмолчанию
								|ИЗ
								|	РегистрСведений.ПредставлениеКонтактнойИнформации
		                        |ГДЕ
								|	Объект = &Объект И Вид В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.Телефон))
								|УПОРЯДОЧИТЬ ПО
								|	ЗначениеПоУмолчанию Убыв");
								
		Запрос.УстановитьПараметр("Объект", Объект);
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			Если ТипЗнч(Объект) = Тип("СправочникСсылка.Контрагенты") Тогда
				// найдем количество контров с таким же партнером
				ЗапросПартнера = Новый Запрос("	ВЫБРАТЬ
												|	Ссылка
												|ИЗ
												|	Справочник.Контрагенты
												|	ГДЕ
												|		Партнер = &ОбъектПартнер И НЕ ПометкаУдаления
												|");
				ЗапросПартнера.УстановитьПараметр("ОбъектПартнер", Объект.Партнер);
				Выборка = ЗапросПартнера.Выполнить().Выбрать();
				Если Выборка.Количество() = 1 Тогда
					//если для партнера, к которому относится данный контр, существует лишь он один, тянем из партнера КИ (если нет, то пусть менеджеры раскидают КИ по контрам)
					СтрокаРезультат = ПолучитьТелефонИзКонтактнойИнформации(Объект.Партнер);
				КонецЕсли;
			КонецЕсли;
		Иначе	
			Выборка = РезультатЗапроса.Выбрать();
			Если  ТипЗнч(Объект) = Тип("СправочникСсылка.Организации") Тогда
				Пока Выборка.Следующий() И Выборка.ЗначениеПоУмолчанию Цикл
					СтрокаРезультат = ?(ЗначениеЗаполнено(СтрокаРезультат), СтрокаРезультат + ", ", СтрокаРезультат + "тел.: ") + Выборка.Представление; 
				КонецЦикла;
			Иначе
				Пока Выборка.Следующий() Цикл
					СтрокаРезультат = ?(ЗначениеЗаполнено(СтрокаРезультат), СтрокаРезультат + ", ", СтрокаРезультат + "тел.: ") + Выборка.Представление; 
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтрокаРезультат;
	
КонецФункции // ПолучитьТелефонИзКонтактнойИнформации()

// Функция находит актуальное значение емейла в контакной информации.
//
// Параметры:
//  Объект - СправочникСсылка, объект контактной информации
//
// Возвращаемое значение
//  Строка - представление найденного телефона
//
Функция ПолучитьЕмейлИзКонтактнойИнформации(Объект) Экспорт

	СтрокаРезультат = "";
	
	Если ЗначениеЗаполнено(Объект) Тогда
		
		Запрос = Новый Запрос("	ВЫБРАТЬ
								|	Представление, ЗначениеПоУмолчанию
								|ИЗ
								|	РегистрСведений.ПредставлениеКонтактнойИнформации
		                        |ГДЕ
								|	Объект = &Объект И Вид В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресЭлектроннойПочты))
								|УПОРЯДОЧИТЬ ПО
								|	ЗначениеПоУмолчанию Убыв");
								
		Запрос.УстановитьПараметр("Объект", Объект);
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			Если ТипЗнч(Объект) = Тип("СправочникСсылка.Контрагенты") Тогда
				// найдем количество контров с таким же партнером
				ЗапросПартнера = Новый Запрос("	ВЫБРАТЬ
												|	Ссылка
												|ИЗ
												|	Справочник.Контрагенты
												|	ГДЕ
												|		Партнер = &ОбъектПартнер И НЕ ПометкаУдаления
												|");
				ЗапросПартнера.УстановитьПараметр("ОбъектПартнер", Объект.Партнер);
				Выборка = ЗапросПартнера.Выполнить().Выбрать();
				Если Выборка.Количество() = 1 Тогда
					//если для партнера, к которому относится данный контр, существует лишь он один, тянем из партнера КИ (если нет, то пусть менеджеры раскидают КИ по контрам)
					СтрокаРезультат = ПолучитьЕмейлИзКонтактнойИнформации(Объект.Партнер);
				КонецЕсли;
			КонецЕсли;
		Иначе	
			Выборка = РезультатЗапроса.Выбрать();
			Если  ТипЗнч(Объект) = Тип("СправочникСсылка.Организации") Тогда
				Пока Выборка.Следующий() И Выборка.ЗначениеПоУмолчанию Цикл
					СтрокаРезультат = ?(ЗначениеЗаполнено(СтрокаРезультат), СтрокаРезультат + ", ", СтрокаРезультат + "") + Выборка.Представление; 
				КонецЦикла;
			Иначе
				Пока Выборка.Следующий() Цикл
					СтрокаРезультат = ?(ЗначениеЗаполнено(СтрокаРезультат), СтрокаРезультат + ", ", СтрокаРезультат + "") + Выборка.Представление; 
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтрокаРезультат;
	
КонецФункции // ПолучитьТелефонИзКонтактнойИнформации()

// Функция находит актуальное значение адреса в контакной информации.
//
// Параметры:
//  Объект - СправочникСсылка, объект контактной информации
//  ТипАдреса - тип контактной информации
//
// Возвращаемое значение
//  Строка - представление найденного адреса
//
Функция ПолучитьАдресИзКонтактнойИнформации(Объект, ТипАдреса = "") Экспорт

	Адрес = "";
	
	Если ЗначениеЗаполнено(Объект) Тогда
		
		// выбирает первый адрес по-умолчанию(если есть) из группы Адрес<ТипАдреса>
		Запрос = Новый Запрос("	ВЫБРАТЬ ПЕРВЫЕ 1
								|	Представление
								|ИЗ
								|	РегистрСведений.ПредставлениеКонтактнойИнформации
		                        |ГДЕ
								|	Объект = &Объект И Вид В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.Адрес" + ТипАдреса + "))
								|УПОРЯДОЧИТЬ ПО
								|	ЗначениеПоУмолчанию Убыв");
								
		Запрос.УстановитьПараметр("Объект", Объект);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			Возврат "";
			
		//	Если ТипЗнч(Объект) = Тип("СправочникСсылка.Контрагенты") Тогда
		//		// если для контрагента нет контактной информации, тянем ее из парнера
		//		Адрес = ПолучитьАдресИзКонтактнойИнформации(Объект.Контрагент, ТипАдреса);
		//		
		//		//// найдем количество контров с таким же партнером
		//		//ЗапросПартнера = Новый Запрос("	ВЫБРАТЬ
		//		//								|	Ссылка
		//		//								|ИЗ
		//		//								|	Справочник.Контрагенты
		//		//								|	ГДЕ
		//		//								|		Партнер = &ОбъектПартнер
		//		//								|");
		//		//ЗапросПартнера.УстановитьПараметр("ОбъектПартнер", Объект.Партнер);
		//		//Выборка = ЗапросПартнера.Выполнить().Выбрать();
		//		//Если Выборка.Количество() = 1 Тогда
		//		//	//если для партнера, к которому относится данный контр, существует лишь он один, тянем оттуда КИ (если нет, то пусть менеджеры раскидают КИ по контрам)
		//		//	Адрес = ПолучитьАдресИзКонтактнойИнформации(Объект.Партнер, ТипАдреса);
		//		//КонецЕсли;
		//	КонецЕсли;
		Иначе
			Адрес = РезультатЗапроса.Выгрузить()[0].Представление;
		КонецЕсли;
		
		Возврат Адрес;

	КонецЕсли;                                          
КонецФункции // ПолучитьАдресИзКонтактнойИнформации()

 // Функция находит актуальное значение адреса в контакной информации.
//
// Параметры:
//  Объект - СправочникСсылка, объект контактной информации
//  ТипАдреса - тип контактной информации
//
// Возвращаемое значение
//  Строка - представление найденного адреса
//
Функция ПолучитьАдресДоствкиИзКонтактнойИнформации(Объект, ТипАдреса = "") Экспорт

	Адрес = "";
	
	Если ЗначениеЗаполнено(Объект) Тогда
		
		// выбирает первый адрес по-умолчанию(если есть) из группы Адрес<ТипАдреса>
		Запрос = Новый Запрос("	ВЫБРАТЬ ПЕРВЫЕ 1
								|	Представление
								|ИЗ
								|	РегистрСведений.ПредставлениеКонтактнойИнформации
		                        |ГДЕ
								|	Объект = &Объект И Вид = &Вид
								|УПОРЯДОЧИТЬ ПО
								|	ЗначениеПоУмолчанию");
								
		Запрос.УстановитьПараметр("Объект", Объект);
		Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.НайтиПоНаименованию("Адрес доставки"));
		
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Адрес = РезультатЗапроса.Выгрузить()[0].Представление;
		КонецЕсли;
	КонецЕсли; 
	
	Возврат Адрес;
КонецФункции // ПолучитьАдресИзКонтактнойИнформации()


// Функция формирует сведения об указанном ЮрФизЛице. К сведениям относятся -
// наименование, адрес, номер телефона, банковские реквизиты.
//
// Параметры: 
//  ЮрФизЛицо   - организация или физическое лицо, о котором собираются сведения.
//  ДатаПериода - дата, на которую выбираются сведения о ЮрФизЛице.
//  ДляФизЛицаТолькоИнициалы - Для физ. лица выводить только инициалы имени и отчества.
//  БанковскийСчет - Банковский счет, если счет не основной.
//
// Возвращаемое значение:
//  Сведения - собранные сведения.
//
Функция СведенияОЮрФизЛице(ЮрФизЛицо, ДатаПериода, ДляФизЛицаТолькоИнициалы = Истина, Знач БанковскийСчет = Неопределено) Экспорт

	Сведения = Новый Структура("Представление, ОфициальноеНаименование, ПолноеНаименование, КодПоОКПО, ИНН, КПП, Телефоны, ЮридическийАдрес, Банк, БИК, КоррСчет, НомерСчета, ЮрФизЛицо, Свидетельство, ЭлПочта");

	Если ЗначениеЗаполнено(ЮрФизЛицо) Тогда
		Если ТипЗнч(ЮрФизЛицо) = Тип("СправочникСсылка.Грузополучатели") Тогда
			Реквизиты = Справочники.Грузополучатели.ПолучитьРеквизитыГрузополучателя(ЮрФизЛицо);
			
			Если Не ЗначениеЗаполнено(БанковскийСчет) Тогда
				БанковскийСчет = Справочники.БанковскиеСчета.ПолучитьБанковскийСчетПоУмолчанию(ЮрФизЛицо);
			КонецЕсли;
			РеквизитыСчета = Справочники.БанковскиеСчета.ПолучитьРеквизитыБанковскогоСчета(БанковскийСчет);
			
			Сведения.Вставить("Представление", Реквизиты.Представление);
			Сведения.Вставить("ПолноеНаименование", Реквизиты.НаименованиеПолное);
			Сведения.Вставить("ИНН", Реквизиты.ИНН);
			Сведения.Вставить("КодПоОКПО", Реквизиты.КодПоОКПО);
			Сведения.Вставить("ЮрФизЛицо", Реквизиты.ЮрФизЛицо);
			
			Если ТипЗнч(ЮрФизЛицо.Владелец) = Тип("СправочникСсылка.Организации") Тогда
				Сведения.Вставить("ОфициальноеНаименование", Реквизиты.НаименованиеПолное);
				Сведения.Вставить("Свидетельство", Реквизиты.Свидетельство);
			Иначе
				Сведения.Вставить("Свидетельство", "");
			КонецЕсли;
			
			Если ТипЗнч(ЮрФизЛицо.Владелец) = Тип("СправочникСсылка.Организации") ИЛИ ЮрФизЛицо.Владелец.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
				Сведения.Вставить("КПП", Реквизиты.КПП);
			Иначе
				Сведения.Вставить("КПП", "");
			КонецЕсли;
			
			Сведения.Вставить("Телефоны", ПолучитьТелефонИзКонтактнойИнформации(ЮрФизЛицо));
			Сведения.Вставить("ЭлПочта", ПолучитьЕмейлИзКонтактнойИнформации(ЮрФизЛицо));
			
			Сведения.Вставить("НомерСчета", РеквизитыСчета.НомерСчета);
			Сведения.Вставить("Банк", РеквизитыСчета.Банк);
			Сведения.Вставить("БИК", РеквизитыСчета.БИК);
			Сведения.Вставить("КоррСчет", РеквизитыСчета.КоррСчет);
			
			Сведения.Вставить("ЮридическийАдрес", ПолучитьАдресИзКонтактнойИнформации(ЮрФизЛицо, "Юридический"));
			Сведения.Вставить("ФактическийАдрес", ПолучитьАдресИзКонтактнойИнформации(ЮрФизЛицо, "Фактический"));
		ИначеЕсли (ТипЗнч(ЮрФизЛицо) = Тип("СправочникСсылка.Организации") ИЛИ ТипЗнч(ЮрФизЛицо) = Тип("СправочникСсылка.Контрагенты")) Тогда
			
			Если ТипЗнч(ЮрФизЛицо) = Тип("СправочникСсылка.Организации") Тогда
				Реквизиты = Справочники.Организации.ПолучитьРеквизитыОрганизации(ЮрФизЛицо);
				Реквизиты.Вставить("ЮрФизЛицо", Перечисления.ЮрФизЛицо.ЮрЛицо);
			ИначеЕсли ТипЗнч(ЮрФизЛицо) = Тип("СправочникСсылка.Контрагенты") Тогда
				Реквизиты = Справочники.Контрагенты.ПолучитьРеквизитыКонтрагента(ЮрФизЛицо);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(БанковскийСчет) Тогда
				БанковскийСчет = Справочники.БанковскиеСчета.ПолучитьБанковскийСчетПоУмолчанию(ЮрФизЛицо);
			КонецЕсли;
			РеквизитыСчета = Справочники.БанковскиеСчета.ПолучитьРеквизитыБанковскогоСчета(БанковскийСчет);
			
			Сведения.Вставить("Представление", Реквизиты.Представление);
			Сведения.Вставить("ПолноеНаименование", Реквизиты.НаименованиеПолное);
			Сведения.Вставить("ИНН", Реквизиты.ИНН);
			Сведения.Вставить("КодПоОКПО", Реквизиты.КодПоОКПО);
			Сведения.Вставить("ЮрФизЛицо", Реквизиты.ЮрФизЛицо);
			
			Если ТипЗнч(ЮрФизЛицо) = Тип("СправочникСсылка.Организации") Тогда
				Сведения.Вставить("ОфициальноеНаименование", Реквизиты.НаименованиеПолное);
				Сведения.Вставить("Свидетельство", Реквизиты.Свидетельство);
			Иначе
				Сведения.Вставить("Свидетельство", "");
			КонецЕсли;
			
			Если ТипЗнч(ЮрФизЛицо) = Тип("СправочникСсылка.Организации") ИЛИ ЮрФизЛицо.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
				Сведения.Вставить("КПП", Реквизиты.КПП);
			Иначе
				Сведения.Вставить("КПП", "");
			КонецЕсли;
			
			Сведения.Вставить("Телефоны", ПолучитьТелефонИзКонтактнойИнформации(ЮрФизЛицо));
			Сведения.Вставить("ЭлПочта", ПолучитьЕмейлИзКонтактнойИнформации(ЮрФизЛицо));
			
			Сведения.Вставить("НомерСчета", РеквизитыСчета.НомерСчета);
			Сведения.Вставить("Банк", РеквизитыСчета.Банк);
			Сведения.Вставить("БИК", РеквизитыСчета.БИК);
			Сведения.Вставить("КоррСчет", РеквизитыСчета.КоррСчет);
			
			Сведения.Вставить("ЮридическийАдрес", ПолучитьАдресИзКонтактнойИнформации(ЮрФизЛицо, "Юридический"));
			Сведения.Вставить("ФактическийАдрес", ПолучитьАдресИзКонтактнойИнформации(ЮрФизЛицо, "Фактический"));
		КонецЕсли;
	КонецЕсли;
		
	Возврат Сведения;

КонецФункции // СведенияОЮрФизЛице()

// Функция возвращает представление номенклатуры для печати.
//
Функция ПолучитьПредставлениеНоменклатурыДляПечати(НаименованиеНоменклатуры) Экспорт
	
	Возврат СокрЛП(НаименованиеНоменклатуры);
	
КонецФункции // ПолучитьПредставлениеНоменклатурыДляПечати()

Функция ПечатьПолногоНомера(Дата) Экспорт
	Возврат Дата >= '20150801'; // с этой даты номера основных документов выводятся на печать с полным номером, включая префикс и лидирующие нули
КонецФункции
// Получает номер документа для вывода на печать
//
Функция ПолучитьНомерНаПечать(Знач НомерОбъекта, УбратьПризнакГода = Ложь, Дата = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(Дата) И ПечатьПолногоНомера(Дата)  Тогда
		Возврат СокрЛП(НомерОбъекта);
	КонецЕсли;
	
	// может попадутся префиксы
	Если Найти(НомерОбъекта, "Т-") = 1 Тогда
		НомерОбъекта = Сред(НомерОбъекта, 3);
	ИначеЕсли
		Найти(НомерОбъекта, "Г-") = 1 Тогда
		НомерОбъекта = Сред(НомерОбъекта, 3);
	ИначеЕсли
		Найти(НомерОбъекта, "В-") = 1 Тогда
		НомерОбъекта = Сред(НомерОбъекта, 3);
	ИначеЕсли
		Найти(НомерОбъекта, "А-") = 1 Тогда
		НомерОбъекта = Сред(НомерОбъекта, 3);
	ИначеЕсли
		Найти(НомерОбъекта, "М-") = 1 Тогда
		НомерОбъекта = Сред(НомерОбъекта, 3);
	ИначеЕсли
		Найти(НомерОбъекта, "Мо-") = 1 Тогда
		НомерОбъекта = Сред(НомерОбъекта, 4);
	ИначеЕсли
		Найти(НомерОбъекта, "С-") = 1 Тогда
		НомерОбъекта = Сред(НомерОбъекта, 3);
	ИначеЕсли
		Найти(НомерОбъекта, "И-") = 1 Тогда
		НомерОбъекта = Сред(НомерОбъекта, 3);
	КонецЕсли;

	Если УбратьПризнакГода Тогда
		НомерОбъекта = Сред(НомерОбъекта, 3); КонецЕсли;

	// удаляем лидирующие нули слева в номере
	Пока Лев(НомерОбъекта, 1)= "0" Цикл	
		НомерОбъекта = Сред(НомерОбъекта, 2);
	КонецЦикла;
	
	Возврат СокрЛП(НомерОбъекта);
	
КонецФункции // ПолучитьНомерНаПечать()

// Стандартная для данной конфигурации функция форматирования сумм
//
// Параметры: 
//  Сумма  - число, которое мы хотим форматировать, 
//  Валюта - ссылка на элемент справочника валют, если задан, то к в результирующую строку
//           будет добавлено представление валюты
//  ЧН     - строка, представляющая нулевое значение числа,
//  ЧРГ    - символ-разделитель групп целой части числа.
//
// Возвращаемое значение:
//  Отформатированная должным образом строковое представление суммы.
//
Функция ФорматСумм(Знач Сумма, Валюта = Неопределено, ЧН = "", ЧРГ = "") Экспорт
	
	Сумма = ?(Сумма < 0, -Сумма, Сумма);
	ФорматнаяСтрока = "ЧЦ=15;ЧДЦ=2" +
					?(НЕ ЗначениеЗаполнено(ЧН), "", ";" + "ЧН=" + ЧН) +
					?(НЕ ЗначениеЗаполнено(ЧРГ),"", ";" + "ЧРГ=" + ЧРГ);
	РезультирующаяСтрока = СокрЛ(Формат(Сумма, ФорматнаяСтрока));
	
	Если ЗначениеЗаполнено(Валюта) Тогда
		РезультирующаяСтрока = РезультирующаяСтрока + " " + СокрП(Валюта);
	КонецЕсли;

	Возврат РезультирующаяСтрока;

КонецФункции // ФорматСумм()

//Формирует представление документа для вывода на печать
//Параметры:
//		Шапка - структура, поля:
//				Дата - дата документа
//				Номер - Номер документа
//				Представление - если название документа не передано, оно может быть
//								вычислено по строковому представлению ссылки на документ
//		НазваниеДокумента (по умолчанию "") - название документа для вывода на печать
//Возвращаемое значение:
//		Строка - строковое представление документа для вывода на печать
//
Функция СформироватьЗаголовокДокумента(Шапка, НазваниеДокумента = "", УбратьПризнакГода = Ложь, ПечатьПолногоНомера = Ложь) Экспорт
	
	//Если название документа не передано, получим название по представлению документа
	Если НазваниеДокумента = ""
		И Шапка.Свойство("Представление")
		И ЗначениеЗаполнено(Шапка.Представление) Тогда
		
		ПоложениеНомера = Найти(Шапка.Представление, Шапка.Номер);
		
		Если ПоложениеНомера > 0 Тогда
			НазваниеДокумента = СокрЛП(Лев(Шапка.Представление,ПоложениеНомера-1));
		КонецЕсли;
		
	КонецЕсли;

	Возврат НазваниеДокумента + " № " + ПолучитьНомерНаПечать(Шапка.Номер, УбратьПризнакГода, ?(ПечатьПолногоНомера, Шапка.Дата, Неопределено))
	                          + " от " + Формат(Шапка.Дата, "ДФ='дд ММММ гггг'") + " г.";
	
КонецФункции // СформироватьЗаголовокДокумента()

Функция ФамилияИнициалыФизЛица(Объект) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Объект) Тогда
		Возврат "";
	КонецЕсли;
	
	ПолноеИмя=Строка(Объект);
    
    ПолноеИмя=СокрЛП(ПолноеИмя);
    
    ПозицияПервогоПробела = Найти(ПолноеИмя, " ");
    
    Фамилия = Лев(ПолноеИмя, ПозицияПервогоПробела);
    Фамилия=СокрЛП(Фамилия);
	ИмяОтчество = Сред(ПолноеИмя, ПозицияПервогоПробела+1);
    ИмяОтчество = СокрЛП(ИмяОтчество);
    ПозицияТочки=Найти(ИмяОтчество,".");
    Если ПозицияТочки>0 Тогда //если введены инициалы
        Имя=Сред(ИмяОтчество,1,ПозицияТочки);
        Отчество=Сред(ИмяОтчество,ПозицияТочки+1);
        Отчество=СокрЛ(Отчество);
    Иначе
        ПозицияВторогоПробела = Найти(ИмяОтчество, " ");
        Имя = Сред(ИмяОтчество,1, ПозицияВторогоПробела-1);
        Имя=СокрЛП(Имя);
        Отчество = Сред(ИмяОтчество, ПозицияВторогоПробела+1);
        Отчество = СокрЛП(Отчество);
    КонецЕсли;
	
	Возврат ?(Не ПустаяСтрока(Фамилия), 
				Фамилия + ?(Не ПустаяСтрока(Имя)," " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество),Лев(Отчество,1)+".", ""), ""),"")
	
КонецФункции

// Функция возвращает, нужно ли вы водить данные о скидках в печатную форму документа
//
Функция НужноВыводитьСкидки(Знач Товары, ИспользоватьСкидки = Истина) Экспорт
	
	Если ИспользоватьСкидки Тогда
		
		Если ТипЗнч(Товары) = Тип("ТаблицаЗначений") Тогда
			
			Для Каждого СтрокаТоваров Из Товары Цикл
				Если ЗначениеЗаполнено(СтрокаТоваров.СуммаСкидки) Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ТипЗнч(Товары) = Тип("ВыборкаИзРезультатаЗапроса") Тогда
			
			Пока Товары.Следующий() Цикл
				Если ЗначениеЗаполнено(Товары.СуммаСкидки) Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
			
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции // НужноВыводитьСкидки()

// Функция формирует представление суммы в рублях и копейках.
//
// Параметры:
//  Сумма - Число - Сумма, которую необходимо отформатировать.
//  Валюта - СправочникСсылка.Валюты - Валюта, в которой нужно представить сумму.
//
// Возвращаемое значение
//  Строка - Отформатированная сумма.
//
Функция СуммаРубКоп(Сумма, Валюта, ВалютаРегламентированногоУчета) Экспорт
	
	Если Валюта = ВалютаРегламентированногоУчета Тогда
		Рубли = Цел(Сумма);
		Копейки = Окр(100 * (Сумма - Рубли), 0, 1);
		СуммаРубКоп = "" 
			+ Формат(Рубли, "ЧДЦ=0; ЧГ=0")
			+ " руб. " 
			+ Цел(Копейки /10) 
			+ (Копейки - 10 * Цел(Копейки / 10))
			+" коп."
		;
	Иначе
		СуммаРубКоп = СуммаПлатежногоДокумента(Сумма, Ложь);
	КонецЕсли;
	
	Возврат СуммаРубКоп;
	
КонецФункции // СуммаРубКоп()

// Форматирует сумму банковского платежного документа.
//
// Параметры:
//  Сумма - Число - Сумма, которую необходимо отформатировать.
//  ВыводитьСуммуБезКопеек - Булево - Флаг представления суммы без копеек.
//
// Возвращаемое значение
//  Строка - Отформатированная строка.
//
Функция СуммаПлатежногоДокумента(Сумма, ВыводитьСуммуБезКопеек) Экспорт
	
	Результат  = Сумма;
	ЦелаяЧасть = Цел(Сумма);
	
	Если Результат = ЦелаяЧасть Тогда
		
		Если ВыводитьСуммуБезКопеек Тогда
			
			Результат = Формат(Результат, "ЧДЦ=2; ЧРД='='; ЧГ=0");
			Результат = Лев(Результат, Найти(Результат, "="));
			
		Иначе
			
			Результат = Формат(Результат, "ЧДЦ=2; ЧРД='-'; ЧГ=0");
			
		КонецЕсли;
		
	Иначе
		
		Результат = Формат(Результат, "ЧДЦ=2; ЧРД='-'; ЧГ=0");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // СуммаПлатежногоДокумента()

Функция ПолучитьСоответствиеСтавокНДС() Экспорт
	
	СоответствиеСтавокНДС = Новый Соответствие();
	СоответствиеСтавокНДС.Вставить(Перечисления.СтавкиНДС.НДС10,     0);
	СоответствиеСтавокНДС.Вставить(Перечисления.СтавкиНДС.НДС10_110, 0);
	СоответствиеСтавокНДС.Вставить(Перечисления.СтавкиНДС.НДС18,     0);
	СоответствиеСтавокНДС.Вставить(Перечисления.СтавкиНДС.НДС18_118, 0);
	СоответствиеСтавокНДС.Вставить(Перечисления.СтавкиНДС.НДС19,     0);
	СоответствиеСтавокНДС.Вставить(Перечисления.СтавкиНДС.НДС19_119, 0);
	СоответствиеСтавокНДС.Вставить(Перечисления.СтавкиНДС.НДС0,      0);
	
	Возврат СоответствиеСтавокНДС;
	
КонецФункции // ПолучитьСоответствиеСтавокНДС()
// Формирует текст НДС по ставке для печатной формы счета и заказа
//
// Параметры:
// СтавкаНДС       - ПеречислениеСсылка.СтавкиНДС - ставка НДС, для которой необходимо сформировать текст
// ЦенаВключаетНДС - Булево - Признак включения НДС в цену
//
// Возвращаемое значение:
// Строка
//
Функция ТекстНДСПоСтавке(СтавкаНДС, ЦенаВключаетНДС) Экспорт
	
	ТекстНДСПоСтавке = ?(ЦенаВключаетНДС, НСтр("ru='В т.ч. НДС (%СтавкаНДС%):'"), НСтр("ru='НДС (%СтавкаНДС%):'"));
	ТекстНДСПоСтавке = СтрЗаменить(ТекстНДСПоСтавке, "%СтавкаНДС%", СтавкаНДС);
	
	Возврат ТекстНДСПоСтавке;
	
КонецФункции // ТекстНДСПоСтавке()

// ШТРИХ Код

Процедура НаПечатьЭтикетки(ТабДок, МассивНоменклатуры) Экспорт
	
	ШиринаЭтикетки = 38;
	ВысотаЭтикетки = 20;
	
	Макет 		= ПолучитьОбщийМакет("ШаблонЭтикетки");
	Этикетка 	= Макет.ПолучитьОбласть("Этикетка");
	//Пропуск 	= Макет.ПолучитьОбласть("Пропуск");
	//ОбластьНоменклатура = Макет.ПолучитьОбласть("Номенклатура");
	//ОбластьШтрихкод 	= Макет.ПолучитьОбласть("ШтрихКод");
	//ОбластьАртикул 		= Макет.ПолучитьОбласть("Артикул");
	ТаблСтрока 	= Новый ТабличныйДокумент;
	
	Для Каждого Номенклатура Из МассивНоменклатуры Цикл вШтрихКоды = ШтрихКоды.ПолучитьШтрихКодыОбъекта(Номенклатура); Если вШтрихКоды.Количество() = 1 Тогда ШтрихКод = вШтрихКоды[0];
		
		//ОбластьНоменклатура.Область(1,1).ВысотаСтроки = ВысотаЭтикетки * 2.65 * 0.3;
		//ОбластьШтрихкод.Область(1,1).ВысотаСтроки     = ВысотаЭтикетки * 2.65 * 0.5;
		//ОбластьАртикул.Область(1,1).ВысотаСтроки      = ВысотаЭтикетки * 2.65 * 0.3;
		//
		//ОбластьНоменклатура.Область(1,1).ШиринаКолонки 	= ШиринаЭтикетки * 0.53;
		//ОбластьШтрихкод.Область(1,1).ШиринаКолонки 		= ШиринаЭтикетки * 0.53;
		//ОбластьАртикул.Область(1,1).ШиринаКолонки 		= ШиринаЭтикетки * 0.53;

 		Этикетка.Параметры.Артикул 			= Номенклатура.Артикул;
		Этикетка.Параметры.Наименование 	= Номенклатура.Наименование;
	 	ШтрихКоды.УстановитьШтрихКодВМакете(Этикетка, ШтрихКод);
		//ТабДок.Вывести(Этикетка);
		
		//ТабДок.Вывести(ОбластьНоменклатура);
		//ТабДок.Вывести(ОбластьШтрихкод);
		//ТабДок.Вывести(ОбластьАртикул);
		
		ТабДок.Вывести(Этикетка); //ТабДок.Вывести(Пропуск); 
		ТабДок.ВывестиГоризонтальныйРазделительСтраниц(); КонецЕсли; КонецЦикла;
	
КонецПроцедуры

