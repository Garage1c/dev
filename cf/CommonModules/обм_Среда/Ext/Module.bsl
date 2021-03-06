﻿
Функция Имя_Версия() 	Возврат "verKey" КонецФункции
Функция Имя_Путь() 		Возврат "path" КонецФункции
Функция Имя_Значение() 	Возврат "id" КонецФункции
Функция Имя_ЭтоГруппа() Возврат "thisGroup" КонецФункции

#Область Конвератция_типов

Функция ЭтоПримитивныйТип(Тип) Экспорт 			Возврат Тип = Тип("Строка") Или Тип = Тип("Число") Или Тип = Тип("Дата") Или Тип = Тип("Булево") КонецФункции
Функция ЭтоПримитивный(ОписаниеТипа) Экспорт 	Тип = ОписаниеТипа.Типы(); Возврат Тип.Количество() = 1 И ЭтоПримитивныйТип(Тип[0]); КонецФункции
Функция ЭтоСсылочныйТип(Тип, ПеречислениеЭтоСсылка = Истина) Экспорт
	
	// ПеречислениеЭтоСсылка - если передать истина, значит перечисление будет считаться ссылочным типпом
	//							если передать ложь, значит перечисление будет считаться не ссылочным типом
	
	ЭтоСсылка = Не ЭтоПримитивныйТип(Тип) И Тип <> Тип("ХранилищеЗначения") И Тип <> Тип("УникальныйИдентификатор") И Тип <> Тип("null");
	
	Если ЭтоСсылка И Не ПеречислениеЭтоСсылка Тогда // Проверим что это перечисление
		
		 ЭтоСсылка = Не Метаданные.Перечисления.Содержит(Метаданные.НайтиПоТипу(Тип)); КонецЕсли;
		
	Возврат ЭтоСсылка; 
				
КонецФункции

Функция ЭтоКлюч(ЗначДанных) Экспорт
	
	//Если Тип(ЗначДанных) = Тип("Структура") и ЗначДанных.Свойство("id")<>Неопределено   Тогда Возврат Истина; Иначе Возврат Ложь; КонецЕсли;
	Если ТипЗнч(ЗначДанных) = Тип("Структура") и ЗначДанных.Свойство(Имя_Значение()) <> Неопределено Тогда Возврат Истина; Иначе Возврат Ложь; КонецЕсли;
	
КонецФункции

Функция ПолучитьПустуюСсылкуПоПолномуПути(Путь) Экспорт
	
	// Возвращает пустой тип
	//	например: 	-> "Справочник.Банки" вернет пустую ссылку справочника банки
	//				-> "Документ.Счет" вернет пустую ссылку докумета счет
	
	поз = СтрНайти(Путь, ".");
	Возврат Новый (Тип(Лев(Путь, поз - 1) + "Ссылка" + Сред(Путь, Поз)));
	
КонецФункции
Функция ПолучитьНовыйОбъектПоПолномуПути(Путь, ЭтоГруппа = Ложь, СсылкаНового = Неопределено) Экспорт
	
	// Возвращает новый объект ссылочного типа
	//	например: 	-> "Справочник.Банки" вернет новый элемент справочника банки
	//				-> "Документ.Счет" вернет новый документ счет
		
	поз = СтрНайти(Путь, ".");			// ЭТОТ СУПЕР КОД НЕ работает (
	//
	// Если ЭтоГруппа Тогда	Возврат Справочники[Сред(Путь, Поз)].СоздатьГруппу() 
	//Иначе					Возврат Новый (Тип(Лев(Путь, поз - 1) + "Объект" + Сред(Путь, Поз))) КонецЕсли;
	
	Нач = Лев(Путь, СтрНайти(Путь, ".") - 1);
	Имя	= Сред(Путь, Поз + 1);
	
	Если 		Нач = "Справочник" Тогда 				НовОб = ?(ЭтоГруппа, Справочники[Имя].СоздатьГруппу(), Справочники[Имя].СоздатьЭлемент());
	ИначеЕсли 	Нач = "Документ" Тогда 					НовОб = Документы[Имя].СоздатьДокумент();
	ИначеЕсли 	Нач = "БизнесПроцесс" Тогда 			НовОб = БизнесПроцессы[Имя].СоздатьБизнесПроцесс();
	ИначеЕсли 	Нач = "Задача" Тогда 					НовОб = Задачи[Имя].СоздатьЗадачу();
		
	Иначе ВызватьИсключение "Не могу создать объект по менеджеру объекта " + Путь КонецЕсли;
	
	Если СсылкаНового <> Неопределено Тогда
		НовОб.УстановитьСсылкуНового(СсылкаНового); КонецЕсли;
	
	Возврат НовОб;
	
КонецФункции
Функция ПолучитьМенеджерОбъектаПоПути(Путь)
	
	Поз	= СтрНайти(Путь, ".");
	Нач = Лев(Путь, СтрНайти(Путь, ".") - 1);
	Имя	= Сред(Путь, Поз + 1);
	
	Если 		Нач = "Справочник" Тогда 				Возврат Справочники[Имя];
	ИначеЕсли 	Нач = "Документ" Тогда 					Возврат Документы[Имя];
	ИначеЕсли 	Нач = "Перечисление" Тогда 				Возврат Перечисления[Имя];
	ИначеЕсли 	Нач = "БизнесПроцесс" Тогда 			Возврат БизнесПроцессы[Имя];
	ИначеЕсли 	Нач = "Задача" Тогда 					Возврат Задачи[Имя];
	ИначеЕсли 	Нач = "ПланВидовХарактеристик" Тогда 	Возврат ПланыВидовХарактеристик[Имя];
	ИначеЕсли 	Нач = "ПланСчетов" Тогда 				Возврат ПланыСчетов[Имя];
	ИначеЕсли 	Нач = "ПланВидовРасчета" Тогда 			Возврат ПланыВидовРасчета[Имя];
	ИначеЕсли 	Нач = "ПланОбмена" Тогда 				Возврат ПланыОбмена[Имя];
		
	Иначе ВызватьИсключение "Не могу определить менеджер объекта " + Путь КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область Функции_для_алгоритмов

Функция ЗаписатьОбъектИСообщитьЕслиОшибка(ОбъектЗаписи, Параметр1 = Неопределено, стрОшибки = "", Сообщать = Истина) Экспорт

	Попытка
		
		Если Параметр1 = Неопределено Тогда
			ОбъектЗаписи.Записать();
		Иначе
			ОбъектЗаписи.Записать(Параметр1); КонецЕсли;
		
	Исключение
		
		текОшибка 	= ОписаниеОшибки();
		стрОшибки 	= стрОшибки + ?(стрОшибки = "","","   ") + "Ошибка при записи " + Строка(ОбъектЗаписи) + "
						|" + текОшибка;
						
		Если Сообщать Тогда Сообщить(стрОшибки) КонецЕсли; Возврат Ложь; КонецПопытки; Возврат Истина;
					
КонецФункции

Процедура УстановитьРеквизит(ЗначениеБыло, ЗначениеНужно, ЕстьИзменения)

	Если ЗначениеБыло <> ЗначениеНужно Тогда
		
		ЗначениеБыло 	= ЗначениеНужно;
		ЕстьИзменения 	= Истина; КонецЕсли;
	
КонецПроцедуры


Функция ПолучитьКлючПоСсылке(Значение, ЭтотОбъект, КэшДанные) Экспорт
	
	ИзКэша = КэшДанные[Значение];
	Если ИзКэша <> Неопределено Тогда Возврат ИзКэша КонецЕсли;
	
	АлгоритмТекст = обм_Обмен.ПолучитьТекстАлгоритма(ЭтотОбъект, "АлгоритмПолученияКлюча");
	
	Если ПустаяСтрока(АлгоритмТекст) Тогда
		ВызватьИсключение "Не указан алгоритм получения ключа из значения (" + ЭтотОбъект + ")"; КонецЕсли;
	
	стрОшибки 	= "";
	Ключ 		= ВыполнитьФункциюАлгоритм("Ключ", АлгоритмТекст, КэшДанные, Новый Структура("Значение, ЭтотОбъект", Значение, ЭтотОбъект), стрОшибки);
	Если Ключ = Неопределено Тогда
		ВызватьИсключение "Ошибка алгоритма получения ключа из значения (" + ЭтотОбъект + ") - " + строка(Значение) + "
																|" + стрОшибки; КонецЕсли;
	КэшДанные.Вставить(Значение, Ключ);
	Возврат Ключ;
	
КонецФункции
Функция ПолучитьСсылкуПоКлючу(Ключ, ЭтотОбъект, КэшДанные) Экспорт
	
	ИзКэша = КэшДанные[Ключ];
	Если ИзКэша <> Неопределено Тогда Возврат ИзКэша КонецЕсли;
	
	АлгоритмТекст = обм_Обмен.ПолучитьТекстАлгоритма(ЭтотОбъект, "АлгоритмПолученияЗначения");
	
	Если ПустаяСтрока(АлгоритмТекст) Тогда
		ВызватьИсключение "Не указан алгоритм получения значения (" + ЭтотОбъект + ")"; КонецЕсли;
	
	стрОшибки 	= "";
	Значение 	= ВыполнитьФункциюАлгоритм("Значение", АлгоритмТекст, КэшДанные, Новый Структура("Ключ, ЭтотОбъект", Ключ, ЭтотОбъект), стрОшибки);
	Если Значение = Неопределено Тогда
		ВызватьИсключение "Ошибка алгоритма получения значения (" + ЭтотОбъект + ") - " + строка(ЗначениеВСтрокуВнутр(Ключ)) + "
																|значение вернуло НЕОПРЕДЕЛЕНО
																|" + стрОшибки; КонецЕсли;
	КэшДанные.Вставить(Ключ, Значение);
	Возврат Значение;
	
КонецФункции

Функция ПолучитьМассивИзПростыхОбъектов(Обмен, Ссылки, КэшДанные, Знач ТолькоЭтиРеквизиты = "", Знач ИсключитьЭтиРеквизиты = "", УчитыватьОбщиеРеквизиты = Ложь, стрЗамены = "")
	
	// Ссылки - массив ссылок простых документов
	// Возвращает массив внутри которого будут структуры простого ссылочного объекта (Справочник, документ и т.д.)
	// 		если "Cсылки" будут пустые значит вернет пустой массив
	//
	// ТолькоЭтиРеквизиты 		- строка где через запятую представлены реквизиты которые нужно переносить, если не заполнить значит все реквизиты
	//								если это реквизит табличной части то нужно писать через точку "Таблица.Реквизит"
	// ИсключитьЭтиРеквизиты 	- строка где через запятую представлены реквизиты которые нужно проигнорировать
	// 								если это реквизит табличной части то нужно писать через точку "Таблица.Реквизит"
	// если нужно не переносить таблицу тогда нужно перечислить все колонки таблицы
	//
	//	ДобавитьОбщие - будет перебирвать общие (для ускорения по умолчанию отключено)
	//
	//	стрЗамены - строка, в которой можно указывать как будут называтся ключи (реквизиты), вместо текущих
	//				вначале пишется название текущего реквизита, затем нового, между ними знак ->
	//				если много реквизитов, тогда их нужно разделить запятыми
	//				например реквизит Партнер нужно назвать Контрагентом, а валюта назвать валюта2 тогда сл.запись
	//							партнер -> контрагент, валюта -> валюта2
	
	символРазЗамены	= "->";
	СтруктЗамен		= Новый Структура;
	масРеквизитов 	= Новый Массив;
	Если Ссылки.Количество() Тогда
		Мета 			= Ссылки[0].Метаданные();
		
		реквНет = НРег(СтрЗаменить(ИсключитьЭтиРеквизиты, " ", ""));
		реквДа 	= НРег(СтрЗаменить(ТолькоЭтиРеквизиты, " ", ""));
		
		// Подготовим структуру замен
		
		Если Не ПустаяСтрока(стрЗамены) Тогда
			масЗамен = СтрРазделить(стрЗамены,",", Ложь);
			Для Каждого текЗамена Из масЗамен Цикл
				поз = СтрНайти(текЗамена, символРазЗамены);
				СтруктЗамен.Вставить(
						СокрЛП(Лев(текЗамена, поз - 1)), 
						СокрЛП(Сред(текЗамена, поз + СтрДлина(символРазЗамены)))); КонецЦикла; КонецЕсли;
				
		// Добавим системные
		
		Для Каждого МетаРекв ИЗ Мета.СтандартныеРеквизиты Цикл _ДобавитьРеквизит(масРеквизитов, МетаРекв.Имя, реквДа, реквНет) КонецЦикла;
		
		// Добавим общие
		
		Если УчитыватьОбщиеРеквизиты Тогда Использовать = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать;
			
			Для Каждого МетаОбщ Из Метаданные.ОбщиеРеквизиты Цикл
				
				Если МетаОбщ.Состав.Найти(Мета).Использование = Использовать Тогда
					_ДобавитьРеквизит(масРеквизитов, МетаОбщ.Имя, реквДа, реквНет); КонецЕсли; КонецЦикла; КонецЕсли;
		
		// Вернем объект
		
		Возврат обм_Обмен.ВозвратМассивОбъекта(Обмен, Ссылки, масРеквизитов, Мета, реквДа, реквНет, КэшДанные, СтруктЗамен);
	Иначе
		Возврат Новый Массив; КонецЕсли;	// были переданны не "Ссылки" с количеством 0
	
КонецФункции

Процедура _ДобавитьРеквизит(Массив, Реквизит, реквДа, реквНет)
	
	нРеквизит = НРег(Реквизит);
	
	Если 	Не СтрНайти(реквНет, нРеквизит) И
			(ПустаяСтрока(реквДа) ИЛИ СтрНайти(реквДа, нРеквизит)) Тогда

		Массив.Добавить(Реквизит); КонецЕсли;
	
КонецПроцедуры

Функция УстановитьРеквизитыПоМетаНабору(МетаНабор, ОбъектБазы, СтруктураДанные, КэшДанные, Обмен, МетаПуть, ЕстьИзменения, ТолькоПримитивные = Истина, ТолькоЭтиРеквизиты = "", ИсключитьЭтиРеквизиты = "", ЗапрашиватьЕслиОбъектНеНайден = Ложь)
	
	Для Каждого Реквизит Из МетаНабор Цикл
		
		// Проверим что можно
		
		ИмяРевизита = Реквизит.Имя;
		Если 	СтрНайти(ИсключитьЭтиРеквизиты, ИмяРевизита) Или
				(Не ПустаяСтрока(ТолькоЭтиРеквизиты) И Не СтрНайти(ТолькоЭтиРеквизиты, ИмяРевизита)) Тогда Продолжить КонецЕсли;
			
		// Иницилизируем реквизит
			
		ЗначДанных = Неопределено;
		Если СтруктураДанные.Свойство(ИмяРевизита, ЗначДанных) Тогда
			
			// Получим значение для ссылочного типа
				
			Если Не ЭтоПримитивный(Реквизит.Тип) Тогда 
				Если ТолькоПримитивные Тогда Продолжить КонецЕсли;

				ОписаниеТипа 	= Реквизит.Тип;
				Тип 			= ОписаниеТипа.Типы()[0];
				
				Если НЕ ЭтоКлюч(ЗначДанных) Тогда
					
					Если ОписаниеТипа.Типы().Количество() > 1 Тогда
						ВызватьИсключение МетаПуть + ".Реквизит. " + ИмяРевизита + " имеет несколько типов и должен быть записан в алгоритме набора правил";
					ИначеЕсли Тип = Тип("ХранилищеЗначения") Или Тип = Тип("УникальныйИдентификатор") Тогда 
						Продолжить КонецЕсли; КонецЕсли; // Эти типы не обрабатываем
					
				// Если не примитивный значит ссылочный
				
				Если СтруктураДанные[ИмяРевизита] <> Неопределено Тогда
					
					Если ЭтоКлюч(ЗначДанных) Тогда
						
						текМетаПуть = ЗначДанных[Имя_Путь()];
						Набор 		= обм_Обмен.ПолучитьНаборПоМетаПути(текМетаПуть, Обмен);
						ЗначДанных 	= ?(ПустаяСтрока(Набор.АлгоритмПолученияЗначения), ЗначениеИзТиповогоКлюча(ЗначДанных), ПолучитьСсылкуПоКлючу(ЗначДанных, Набор, КэшДанные));
						текТип		= ТипЗнч(ЗначДанных);
						
					Иначе
						текМетаПуть	= Метаданные.НайтиПоТипу(Тип).ПолноеИмя();
						Набор 		= обм_Обмен.ПолучитьНаборПоМетаПути(текМетаПуть, Обмен);
						ЗначДанных 	= ПолучитьСсылкуПоКлючу(СтруктураДанные[ИмяРевизита], Набор, КэшДанные);  
						текТип 		= Тип; КонецЕсли;
					
					// Считаем у базы если не нужно чтобы было написано "Объект не найден"
					
					Если 	ЗапрашиватьЕслиОбъектНеНайден И
							ЭтоСсылочныйТип(текТип, Ложь) И
							НЕ ЗначДанных.Пустая() И
							ЗначДанных.ПолучитьОбъект() = Неопределено Тогда
							
						СтруктураДрДанных = обм_Обмен.ЗапроситьОбъект(Набор, ПолучитьКлючПоСсылке(ЗначДанных, Набор, КэшДанные));
						Если СтруктураДрДанных <> Неопределено Тогда
							
							текОбъект = ПолучитьНовыйОбъектПоПолномуПути(текМетаПуть, СтрНачинаетсяС(текМетаПуть, "Справочник") И СтруктураДрДанных.Свойство("ЭтоГруппа") И СтруктураДрДанных.ЭтоГруппа, ЗначДанных);
						 	Если Не УстановитьРеквизитыОбъектаЕслиЕстьИзменения(текОбъект, СтруктураДрДанных, КэшДанные, Обмен, ТолькоПримитивные,,,,,Ложь) Тогда
								Возврат Ложь; КонецЕсли; КонецЕсли; КонецЕсли; КонецЕсли; КонецЕсли;
			
			// Установим реквизит	
			
			УстановитьРеквизит(ОбъектБазы[ИмяРевизита], ЗначДанных, ЕстьИзменения); КонецЕсли; КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция УстановитьРеквизитыОбъектаЕслиЕстьИзменения(ОбъектБазы, СтруктураДанные, КэшДанные, Обмен, ТолькоПримитивные = Ложь, Записать = Истина, Знач ТолькоЭтиРеквизиты = "", Знач ИсключитьЭтиРеквизиты = "Ссылка", ЕстьИзменения = Ложь, ЗапрашиватьЕслиОбъектНеНайден = Ложь)
	
	// Возвращает ИСТИНА если реквизиты изменились
	// ЛОЖЬ если не было изменений
	// при этом устанавливает измененные значения
	
	МетаОб 			= ОбъектБазы.Метаданные();
	ПолноеИмя		= МетаОб.ПолноеИмя();
	
	// Стандартные реквизиты
	
	Если Не УстановитьРеквизитыПоМетаНабору(МетаОб.СтандартныеРеквизиты, 	ОбъектБазы, СтруктураДанные, КэшДанные, Обмен, ПолноеИмя, ЕстьИзменения, ТолькоПримитивные, ТолькоЭтиРеквизиты, ИсключитьЭтиРеквизиты, Ложь) Тогда 
		Возврат Ложь КонецЕсли;
	
	// Реквизиты
	              
	Если Не УстановитьРеквизитыПоМетаНабору(МетаОб.Реквизиты, 				ОбъектБазы, СтруктураДанные, КэшДанные, Обмен, ПолноеИмя, ЕстьИзменения, ТолькоПримитивные, ТолькоЭтиРеквизиты, ИсключитьЭтиРеквизиты, ЗапрашиватьЕслиОбъектНеНайден) Тогда
		Возврат Ложь КонецЕсли;
		
	// Табличные части
	
	Для Каждого Таблица Из МетаОб.ТабличныеЧасти Цикл
		
		СтруктураТаблицы = Неопределено;
		Если СтруктураДанные.Свойство(Таблица.Имя, СтруктураТаблицы) Тогда
		
			Инд = -1;
			КолТут = ОбъектБазы[Таблица.Имя].Количество();
			КолТам = СтруктураТаблицы.Количество();
			
			// Тут строк меньше чем там, значит добавим
				
			Для Каждого СтрокаТам Из СтруктураТаблицы Цикл Инд = Инд + 1; 
				
				// Определим строку в базе
				
				Если Инд >= КолТут Тогда ЕстьИзменения = Истина;
						СтрокаТут = ОбъектБазы[Таблица.Имя].Добавить();
				Иначе	СтрокаТут = ОбъектБазы[Таблица.Имя][Инд]; КонецЕсли;
				
				// Заполним
					
				УстановитьРеквизитыПоМетаНабору(Таблица.Реквизиты, СтрокаТут, СтрокаТам, КэшДанные, Обмен, ПолноеИмя, ЕстьИзменения, ТолькоПримитивные, ТолькоЭтиРеквизиты, ИсключитьЭтиРеквизиты, ЗапрашиватьЕслиОбъектНеНайден); КонецЦикла;
											
			// Удалим лишнии строки
			
			Если Инд < КолТут Тогда ЕстьИзменения = Истина;
				Для Ном = 1 По КолТам - КолТут Цикл ОбъектБазы[Таблица.Имя].Удалить(КолТут - Ном) КонецЦикла; КонецЕсли; КонецЕсли; КонецЦикла;
			
	// Запишем объект			
	
	Если ЕстьИзменения И Записать Тогда
		ОбъектБазы.ОбменДанными.Загрузка = Истина;
		ОбъектБазы.Записать(); КонецЕсли;
	
	Возврат Истина;
	
КонецФункции
Функция УстановитьРеквизитыОбъектаПоКлючу(key, СтруктураДанные, КэшДанные, Обмен, ТолькоПримитивные = Ложь, Записать = Истина, Знач ТолькоЭтиРеквизиты = "", Знач ИсключитьЭтиРеквизиты = "Ссылка", ЕстьИзменения = Ложь, ЗапрашиватьЕслиОбъектНеНайден = Ложь)
	
	// Функция определяет первый объект в наборе, считывает из него информацию что это за тип объекта и записывает его
	
	// Получим объект
	
	Набор 	= обм_Обмен.ПолучитьНаборПоМетаПути(key[Имя_Путь()], Обмен);
	Ссылка 	= ПолучитьСсылкуПоКлючу(key, Набор, КэшДанные);
	Объект 	= Ссылка.ПолучитьОбъект();
	
	// Создадим новый объект
	
	Если Объект = Неопределено Тогда
		Объект = ПолучитьНовыйОбъектПоПолномуПути(key[Имя_Путь()], key.Свойство(Имя_ЭтоГруппа()) И key[Имя_ЭтоГруппа()], Ссылка);
		Объект.УстановитьСсылкуНового(Ссылка); КонецЕсли;
	
	// Запишем его реквизиты
	
	Возврат УстановитьРеквизитыОбъектаЕслиЕстьИзменения(Объект, СтруктураДанные, КэшДанные, Обмен, ТолькоПримитивные, Записать, ТолькоЭтиРеквизиты, ИсключитьЭтиРеквизиты, ЕстьИзменения, ЗапрашиватьЕслиОбъектНеНайден);
	
КонецФункции

Функция ПолучитьСправочникОбъектПоГуиду(Менеджер, стрГуид, ЭтоГруппа = Ложь) Экспорт
	
	// Найдм по гуиду
	
	СпрСсылка = Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(стрГуид));
	СпрОбъект = СпрСсылка.ПолучитьОбъект();
	                                      	
	Если СпрОбъект = Неопределено Тогда // Это новый
		
		// Создадим новый и установим такойже гуид
		
		СпрОбъект = ?(ЭтоГруппа, Менеджер.СоздатьГруппу(), Менеджер.СоздатьЭлемент());
		СпрОбъект.УстановитьСсылкуНового(СпрСсылка); КонецЕсли;
	
	Возврат СпрОбъект;
	
КонецФункции
Функция ПолучитьДокументОбъектПоГуиду(Менеджер, стрГуид)
	
	// Найдм по гуиду
	
	ДокСсылка = Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(стрГуид));
	ДокОбъект = ДокСсылка.ПолучитьОбъект();
	
	Если ДокОбъект = Неопределено Тогда // Это новый
		
		// Создадим новый и установим такойже гуид
		
		ДокОбъект = Менеджер.СоздатьДокумент();
		ДокОбъект.УстановитьСсылкуНового(ДокСсылка); КонецЕсли;
	
	Возврат ДокОбъект;
	
КонецФункции

#КонецОбласти

#Область Получение_объекта_типовое


Функция ПолучитьМассивИзТаблицы(Таблица)
	
	// Возвращает массив данных, внутри которой структура с ключами как поля в таблице значений
	
	// Создадим структуру
	
	стрКолонки = Новый Массив; стрТаблиц = Новый Массив; ТипТЗ = Тип("ТаблицаЗначений");
	
	Для Каждого Колонка Из Таблица.Колонки Цикл Если Колонка.ТипЗначения.СодержитТип(ТипТЗ) Тогда стрТаблиц.Добавить(Колонка.Имя) Иначе стрКолонки.Добавить(Колонка.Имя) КонецЕсли; КонецЦикла;
	//Для Каждого Колонка Из Таблица.Колонки Цикл ?(Колонка.ТипЗначения.СодержитТип(ТипТЗ),стрТаблиц, стрКолонки).Добавить(Колонка.Имя) КонецЦикла;
	
	// Вытащим значения
	
	Массив 	= Новый Массив;
	
	Для КАждого Строка Из Таблица Цикл  // новСтруктура = Структура; 
		
		новСтруктура = Новый Структура(СтрСоединить(стрКолонки, ","));
		
		// Заполним реквизитами
		ЗаполнитьЗначенияСвойств(новСтруктура, Строка); 
		
		// Заполним таблицами
		Для Каждого ВнутрТаблица Из стрТаблиц Цикл новСтруктура.Вставить(ВнутрТаблица, ПолучитьМассивИзТаблицы(Строка[ВнутрТаблица])) КонецЦикла;
		
		// Добавим
		Массив.Добавить(новСтруктура); КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

Функция ЗначениеИзТиповогоКлюча(key)
	
	Перем Путь;
	
	Значение = key[Имя_Значение()];
	
	Если key.Свойство(Имя_Путь(), Путь) Тогда
		
		Менеджер = ПолучитьМенеджерОбъектаПоПути(Путь);
		
		Если СтрНайти(Путь, "Перечисление.") = 1 Тогда
			Мета = Метаданные.НайтиПоПолномуИмени(Путь);
			Возврат ?(Мета.ЗначенияПеречисления.Найти(Значение) = Неопределено, Менеджер.ПустаяСсылка(), Менеджер[Значение]);
		Иначе
			Возврат Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(Значение)); КонецЕсли;
	Иначе
		Возврат Значение; КонецЕсли;
	
КонецФункции
Функция НовыйТиповойКлюч(Значение, Обмен, Путь = Неопределено, ЭтоГруппа = Неопределено)
	
	// Упаковывает значение так чтобы потом можно было прочитать  ( Версия ключа, Путь, Значение, ЭтоГруппа )
	
	Структура = Новый Структура(Имя_Версия(), 1);
	
	Если ЭтоСсылочныйТип(ТипЗнч(Значение)) Тогда
		
		текПуть = Значение.Метаданные().ПолноеИмя();
		Если Путь = Неопределено Тогда 
			
			Путь 		= текПуть;
			ПутьЗамена 	= обм_Кэш.ПолучитьСоответствиеПутей(Обмен)[Путь];
			Если ПутьЗамена <> Неопределено Тогда
				Путь = ПутьЗамена; КонецЕсли; КонецЕсли;
		
		Если ЭтоГруппа = Неопределено И СтрНайти(текПуть, "Справочник.") = 1 Тогда
			ЭтоГруппа = Значение.ЭтоГруппа;
			
		ИначеЕсли СтрНайти(текПуть, "Перечисление.") = 1 И ЗначениеЗаполнено(Значение) Тогда // Перечисление храним в виде значения
			Значение = Метаданные.НайтиПоПолномуИмени(текПуть).ЗначенияПеречисления[ПолучитьМенеджерОбъектаПоПути(текПуть).Индекс(Значение)].Имя; КонецЕсли; КонецЕсли;
	
	Структура.Вставить(Имя_Значение(), 	XMLСтрока(Значение));
	
	Если Путь <> Неопределено Тогда 		Структура.Вставить(Имя_Путь(), Путь) КонецЕсли;
	Если ЭтоГруппа <> Неопределено Тогда 	Структура.Вставить(Имя_ЭтоГруппа(), ЭтоГруппа) КонецЕсли;
		
	Возврат Структура;
	
КонецФункции
Функция ПолучитьОбъектПоТиповомуКлючу(key)
	
	Возврат ЗначениеИзТиповогоКлюча(key).ПолучитьОбъект();
	
КонецФункции


#КонецОбласти


// ---------------------------------------------------------------------------------------------------
//                       m
//   $m                mm            m
//    "$mmmmm        m$"    mmmmmmm$"
//          """$m   m$    m$""""""
//        mmmmmmm$$$$$$$$$"mmmm
//  mmm$$$$$$$$$$$$$$$$$$ m$$$$m  "    m  "			Среда для выполнения алгоритмов обмена
// $$$$$$$$$$$$$$$$$$$$$$  $$$$$$"$$$                  и доступа к процедурам доступных внутри
// mmmmmmmmmmmmmmmmmmmmm  $$$$$$$$$$
// $$$$$$$$$$$$$$$$$$$$$  $$$$$$$"""  m
// "$$$$$$$$$$$$$$$$$$$$$ $$$$$$  "      "
//     """""""$$$$$$$$$$$m """"
//       mmmmmmmm"  m$   "$mmmmm
//     $$""""""      "$     """"""$$
//   m$"               "m           "
//
//
Функция ВыполнитьФункциюАлгоритм(ИмяРезультат, ТекстАлгоритм, КэшДанные = Неопределено, Параметры = Неопределено, стрОшибки = "") Экспорт
	
	Перем Рeзульtат;
	
	стрИницилизация = Новый Массив;
	
	// Вытащим параметры
	
	Если Параметры <> Неопределено Тогда
		Для Каждого Элемент Из Параметры Цикл стрИницилизация.Добавить(Элемент.Ключ + " = Параметры." + Элемент.Ключ + ";") КонецЦикла; КонецЕсли;
	
	// Выполним
	
//ЭтотОбъект = Параметры.ЭтотОбъект;
//ДанныеJSON = Параметры.ДанныеJSON;
//Соединение = Параметры.Соединение;
//Результат = ПолучитьМассивПростыхСправочников(ДанныеJSON, КэшДанные, "Наименование,ДатаРождения,Пол");
//Рeзульtат = Результат;

//Значение = Параметры.Значение;
//Ключ = НовыйТиповойКлюч(Значение, ЭтотОбъект.Владелец);
//Рeзульtат = Ключ;

	Попытка	Выполнить(СтрСоединить(стрИницилизация, Символы.ПС) + "
				|" + ТекстАлгоритм + ";
				|Рeзульtат = " + ИмяРезультат + ";");
	Исключение
				стрОшибки = ОписаниеОшибки() КонецПопытки;
				
	// Вернем
	
	Возврат Рeзульtат;
	
КонецФункции