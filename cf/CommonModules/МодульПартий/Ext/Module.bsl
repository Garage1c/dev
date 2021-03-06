﻿
Функция ПолучитьТаблицуВесаТоваровПоТипуЦен(МассивТоваров, ДатаКурса = Неопределено, ТипЦен = Неопределено) Экспорт
	
	// Возвращает таблицу значений в ктоторой
	//	 	Номенклатура 	- товар
	//		Коэфициент 		- коэфициент из сумм данных товаров
	//
	//	если тип цен не указывать тогда будет брать из максимальных цен (МАX)
	
	Запрос = Новый Запрос("
	
	// Вытащим все супер большие цены по типу цен
	
	|ВЫБРАТЬ 	Номенклатура, МАКСИМУМ(Цена * (ЕСТЬNULL(ВалЦен.Курс, 1) * ЕСТЬNULL(ВалУпр.Кратность, 1)) / (ЕСТЬNULL(ВалУпр.Курс, 1) * ЕСТЬNULL(ВалЦен.Кратность, 1))) КАК Цена
	|ПОМЕСТИТЬ 	ТаблТоваров
	|ИЗ 		РегистрСведений.ЦеныНоменклатуры.СрезПоследних(" + ?(ЗначениеЗаполнено(ДатаКурса), "&ДатаКурса", "") + ", Упаковка = &ПустаяУпаковка " + ?(ТипЦен = Неопределено, ""," И ТипЦен = &ТипЦен") + " И Номенклатура В(&Товары)) Рег
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ 
	|	РегистрСведений.КурсыВалют.СрезПоследних(" + ?(ЗначениеЗаполнено(ДатаКурса), "&ДатаКурса", "") + ", ) ВалЦен
	|	ПО	Рег.Валюта = ВалЦен.Валюта
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(" + ?(ЗначениеЗаполнено(ДатаКурса), "&ДатаКурса", "") + ", Валюта В (ВЫБРАТЬ Значение ИЗ Константа.ВалютаУправленческогоУчета)) ВалУпр ПО ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	Номенклатура;
	
	// Посчитаем общий итог
	
	|ВЫБРАТЬ СУММА(Цена) Итог
	|ПОМЕСТИТЬ ИтогТаблица
	|ИЗ ТаблТоваров;
	
	// Рассчитаем коэффициент
	
	|ВЫБРАТЬ	Номенклатура, Цена / Итог Коэффициент
	|ИЗ			ТаблТоваров, ИтогТаблица
	|");
	
	Запрос.УстановитьПараметр("ДатаКурса",		ДатаКурса);
	Запрос.УстановитьПараметр("ТипЦен",			ТипЦен);
	Запрос.УстановитьПараметр("Товары",			МассивТоваров);
	Запрос.УстановитьПараметр("ПустаяУпаковка",	Справочники.УпаковкиНоменклатуры.ПустаяСсылка());
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции


Функция ПолучитьСписокПартийДляВыбора(Номенклатура, Склад, Дата = Неопределено) Экспорт
	
	// Возвращает список для выбора партии в диалоге
	
	Список = Новый СписокЗначений;
	Запрос = Новый Запрос("ВЫБРАТЬ Партия, Партия.Номер Номер, СуммаОстаток Сумма, КоличествоОстаток Количество, Партия.Дата Дата ИЗ РегистрНакопления.ПартииТоваров.Остатки(" + ?(ЗначениеЗаполнено(Дата), "&Дата", "") + ",Склад = &Склад И Номенклатура = &Номенклатура) УПОРЯДОЧИТЬ ПО Партия.Дата");
	
	Запрос.УстановитьПараметр("Номенклатура", 	Номенклатура);
	Запрос.УстановитьПараметр("Склад", 			Склад);
	Запрос.УстановитьПараметр("Дата", 			Дата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл Список.Добавить(
			Новый Структура("Партия, Сумма, Количество", Выборка.Партия, Выборка.Сумма, Выборка.Количество),
			Формат(Выборка.Дата, "ДЛФ=DT") + " - " + Выборка.Партия.Метаданные().Синоним + " (" + Выборка.Номер + ") " + Строка(Выборка.КОличество) + " ед.") КонецЦикла;
	
	Возврат Список;
	
КонецФункции

Функция ПолучитьПартииДляСписания(Номенклатура, Склад, Дата = Неопределено) Экспорт
	
	// Возвращает таблице партий в хронологической полседновательности
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ Партия, СуммаОстаток Сумма, КоличествоОстаток Количество, СуммаОстаток / КоличествоОстаток Цена
	|ИЗ		РегистрНакопления.ПартииТоваров.Остатки(" + ?(ЗначениеЗаполнено(Дата), "&Дата", "") + ",Склад = &Склад И Номенклатура = &Номенклатура)
	|УПОРЯДОЧИТЬ ПО Партия.Дата");
	
	Запрос.УстановитьПараметр("Номенклатура", 	Номенклатура);
	Запрос.УстановитьПараметр("Склад", 			Склад);
	Запрос.УстановитьПараметр("Дата", 			Дата);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции
Функция ПолучитьПартиюДляСписания(Номенклатура, Количество, Склад, Дата = Неопределено) Экспорт
	
	// Возвращает структуру партии для номенклатуры где хватает количества по методу фифы
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1 Партия, СуммаОстаток Сумма, КоличествоОстаток Количество, СуммаОстаток / КоличествоОстаток Цена
	|ИЗ		РегистрНакопления.ПартииТоваров.Остатки(" + ?(ЗначениеЗаполнено(Дата), "&Дата", "") + ",Склад = &Склад И Номенклатура = &Номенклатура)
	|ГДЕ	КоличествоОСтаток >= &Количество
	|УПОРЯДОЧИТЬ ПО Партия.Дата");
	
	Запрос.УстановитьПараметр("Номенклатура", 	Номенклатура);
	Запрос.УстановитьПараметр("Количество", 	Количество);
	Запрос.УстановитьПараметр("Склад", 			Склад);
	Запрос.УстановитьПараметр("Дата", 			Дата);
	
	Табл = Запрос.Выполнить().Выгрузить();
	Если Табл.Количество() Тогда Возврат КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Табл) КонецЕсли;
	
КонецФункции
	
Процедура УстановитьКоличествоКратноеУпаковке(Количество, КоэффУпаковки, НовСтрока, ПересчитатьСумму, СтруктураКолонокТовары, Строка)
	
	НовСтрока.Количество = Количество;
	
	Если КоэффУпаковки <> 1 Тогда
		
		// изменим цену если измениться количество
	
		Если СтруктураКолонокТовары.ЕстьЦена Тогда
			НовСтрока.Цена = Количество * Строка.Цена / Строка.Количество; КонецЕсли; 
		
		// Если списываем не кратно упаковкам тогда упаковку удалим
		
		Если Цел(Количество / КоэффУпаковки) <> Количество / КоэффУпаковки Тогда 
			
			НовСтрока.Упаковка = Справочники.УпаковкиНоменклатуры.ПустаяСсылка();
			
		Иначе	// Если кратно то умеьшим количество на кратность
		
			НовСтрока.Количество = НовСтрока.Количество / КоэффУпаковки; КонецЕсли; КонецЕсли;
	
	Если СтруктураКолонокТовары.ЕстьСумма И ПересчитатьСумму Тогда 
		ФункцииФормДокументов.РассчитатьСуммыСтрокиОтЦены(НовСтрока, СтруктураКолонокТовары, Ложь); КонецЕсли;
	
КонецПроцедуры
Процедура РазнестиПартииВТаблицеМетодомFIFO(Таблица, СкладИлиИмяКолонкиСклада, СтруктураКолонокТовары, Дата = Неопределено, ПропускатьТоварыНеВступившиеВСекту = Ложь, ПерезаполнятьПартии = Ложь, ДопСклад = Неопределено) Экспорт
	
	// СкладИлиИмяКолонкиСклада - 	если указать ссылку на склад, тогда будет разнесено только по указаному складу
	//								если указать строку то это имя колонки в таблице где указан склад (склад будет браться из таблицы)
	// ДопСклад - ссылка, дополнительный склад имеет смысл устанавливать когда "СкладИлиИмяКолонкиСклада" это строка указывающая на склад
	//				тогда в случае если в таблице склад на текущую строку будет не установлен, тогда будет браться ДопСклад
	//
	// ПерезаполнятьПартии - значит будет проверять и перезаполнять даже те строки где указаны партии
	
	ЭтоОдинСклад = ТипЗнч(СкладИлиИмяКолонкиСклада) = Тип("СправочникСсылка.Склады");
	
	ЕстьУпаковка	= СтруктураКолонокТовары.ЕстьУпаковка;
	ТабличнаяЧасть 	= ?(ТипЗнч(Таблица) = Тип("ТаблицаЗначений"), Таблица.Скопировать(), Таблица.Выгрузить());
	Товары 			= Новый Массив;
	Для Каждого Строка ИЗ Таблица Цикл Товары.Добавить(Строка.Номенклатура) КонецЦикла;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ 
	|	Склад, Номенклатура, Партия, 
	|	КоличествоОстаток 	Количество,
	|	СуммаОстаток 		Сумма
	|ИЗ
	|	РегистрНакопления.ПартииТоваров.Остатки(" + ?(ЗначениеЗаполнено(Дата), "&Дата", "") + ",Склад" + ?(ЭтоОдинСклад," = &Склад", " В(&Склады)") + " И Номенклатура В(&Товары))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Партия.Дата
	|");
	
	Запрос.УстановитьПараметр("Дата",	Дата);
	Запрос.УстановитьПараметр("Товары",	Товары);
	
	// Соберем склады
	Если ЭтоОдинСклад Тогда
		Запрос.УстановитьПараметр("Склад",	СкладИлиИмяКолонкиСклада);
	Иначе
		Склады = Новый Массив;
		Если ДопСклад <> Неопределено Тогда Склады.Добавить(ДопСклад) КонецЕсли;
		Для Каждого Строка Из Таблица Цикл Если Склады.Найти(Строка[СкладИлиИмяКолонкиСклада]) = Неопределено Тогда Склады.Добавить(Строка[СкладИлиИмяКолонкиСклада]) КонецЕсли; КонецЦикла; 
		Запрос.УстановитьПараметр("Склады", Склады); КонецЕсли;
	
	ТаблицаПартий = Запрос.Выполнить().Выгрузить();
	Таблица.Очистить();
	
	Для Каждого Строка Из ТабличнаяЧасть Цикл
		
		КоэффУпаковки = ?(ЕстьУпаковка И Строка.Упаковка.Коэффициент, Строка.Упаковка.Коэффициент, 1);
		
		Если 	Не ПерезаполнятьПартии И
					(ЗначениеЗаполнено(Строка.Партия) Или
					(ПропускатьТоварыНеВступившиеВСекту И Не Строка.Номенклатура.ПартионныйУчет)) Тогда 
			
			// Не трогаем строку
			
			НовСтрока = Таблица.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
			
			// Но зато удалим из таблицы остатков партии уже установленные значения чтобы повторно их не раздать другим
			
			СтрокиПартий 			= ТаблицаПартий.НайтиСтроки(Новый Структура("Номенклатура, Партия", Строка.Номенклатура, Строка.Партия));
			НужноУдалитьИзПартии 	= Строка.Количество * КоэффУпаковки;
			Для Каждого СтрокаПартии ИЗ СтрокиПартий Цикл 
				
				УдаляемИзПартии = Мин(СтрокаПартии.Количество, НужноУдалитьИзПартии);
				СтрокаПартии.Количество = УдаляемИзПартии;
				СтрокаПартии.Сумма 		= ?(СтрокаПартии.Количество = УдаляемИзПартии, СтрокаПартии.Сумма, УдаляемИзПартии / СтрокаПартии.Количество * СтрокаПартии.Сумма);
				
				Если Не УдаляемИзПартии Тогда Продолжить; КонецЕсли; КонецЦикла;
		Иначе
			
			Если Не Строка.Количество Тогда	// Если какойто идиот (такие есть случаи) забудет указать количество, то при выполнении дальнешего алгоритма 
											// строка будет удалена, поэтому чтобы не допустим это скопируем строку с 0 количеством как есть
				НовСтрока = Таблица.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
				
			Иначе
			
				// Начнем расспределять
				
				НужноРасспределить 	= Строка.Количество * КоэффУпаковки;
				Распределено		= 0;
				
				СтрокиПартий = ТаблицаПартий.НайтиСтроки(?(ЭтоОдинСклад, 
											Новый Структура("Номенклатура", 		Строка.Номенклатура),
											Новый Структура("Номенклатура, Склад", 	Строка.Номенклатура, ?(ЗначениеЗаполнено(Строка[СкладИлиИмяКолонкиСклада]), Строка[СкладИлиИмяКолонкиСклада], ДопСклад))));
				Для каждого СтрокаПартии ИЗ СтрокиПартий Цикл
					Если СтрокаПартии.Количество > 0 Тогда
						
						Списываем = Мин(НужноРасспределить, СтрокаПартии.Количество);
						
						Если Списываем Тогда
							
							НовСтрока = Таблица.Добавить();
							ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
							
							НовСтрока.Партия 		= СтрокаПартии.Партия;
							НовСтрока.СуммаПартии 	= ?(СтрокаПартии.Количество = Списываем, СтрокаПартии.Сумма, Списываем / СтрокаПартии.Количество * СтрокаПартии.Сумма);
							
							НужноРасспределить 		= НужноРасспределить - Списываем;
							Распределено 			= Распределено + Списываем; 
							
							УстановитьКоличествоКратноеУпаковке(Списываем, КоэффУпаковки, НовСтрока, Списываем <> Строка.Количество, СтруктураКолонокТовары, Строка);
							СтрокаПартии.Количество = СтрокаПартии.Количество - Списываем;
							СтрокаПартии.Сумма 		= СтрокаПартии.Сумма - НовСтрока.СуммаПартии; КонецЕсли; КонецЕсли; КонецЦикла;
						
				Если НужноРасспределить Тогда // Нехватило
					
					НовСтрока = Таблица.Добавить();
					ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
					УстановитьКоличествоКратноеУпаковке(НужноРасспределить, КоэффУпаковки, НовСтрока, НужноРасспределить <> Строка.Количество, СтруктураКолонокТовары, Строка); КонецЕсли; КонецЕсли; КонецЕсли; КонецЦикла;
				
	// А теперь раздадим копеечки
	
	СтруктураКопеек = Новый Структура;
	
	Если Не ПерезаполнятьПартии Тогда 								СтруктураКопеек.Вставить("СуммаПартии", 		ТабличнаяЧасть.Итог("СуммаПартии")) КонецЕсли;
	Если СтруктураКолонокТовары.ЕстьСумма Тогда 					СтруктураКопеек.Вставить("Сумма", 				ТабличнаяЧасть.Итог("Сумма")) КонецЕсли;
	Если СтруктураКолонокТовары.ЕстьСуммаНДС Тогда 					СтруктураКопеек.Вставить("СуммаНДС", 			ТабличнаяЧасть.Итог("СуммаНДС")) КонецЕсли;
	Если СтруктураКолонокТовары.ЕстьСуммаРучнойСкидки Тогда 		СтруктураКопеек.Вставить("СуммаРучнойСкидки", 	ТабличнаяЧасть.Итог("СуммаРучнойСкидки")) КонецЕсли;
	Если СтруктураКолонокТовары.ЕстьСуммаАвтоматическойСкидки Тогда СтруктураКопеек.Вставить("СуммаРучнойСкидки", 	ТабличнаяЧасть.Итог("СуммаРучнойСкидки")) КонецЕсли;
	Если СтруктураКолонокТовары.ЕстьСуммаБезСкидки Тогда 			СтруктураКопеек.Вставить("СуммаБезСкидки", 		ТабличнаяЧасть.Итог("СуммаБезСкидки")) КонецЕсли;
	
	КонвертацияТипов.РаздатьКопейкиНуждающимся_Колонкам(Таблица, СтруктураКопеек);
	
КонецПроцедуры

Процедура АвтоматическоеЗаполнениеПартийКСписаниюПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Константы.ПартионныйУчет.Получить() Тогда
	
		НеРазноситьПартии = Ложь;
		Источник.ДополнительныеСвойства.Свойство("НеРазноситьПартии", НеРазноситьПартии);
		Если НеРазноситьПартии = ИСТИНА Тогда Возврат; КонецЕсли;
		
		//Если Источник.ЭтоНовый() И Не Источник.ОбменДанными.Загрузка Тогда
		Если Не Источник.ОбменДанными.Загрузка Тогда
			
			МетаДок		= Источник.Метаданные();
			Реквизиты 	= МетаДок.Реквизиты;
			
			Если 		Реквизиты.Найти("СкладОтправитель") <> Неопределено Тогда 	Склад = Источник.СкладОтправитель;
			ИначеЕсли 	Реквизиты.Найти("Склад") <> Неопределено Или Метаданные.ОбщиеРеквизиты.Склад.Состав.Найти(МетаДок) <> Неопределено Тогда Склад = Источник.Склад;
			Иначе Возврат КонецЕсли;
			
			ИмяТовары = ?(МетаДок.Имя = "ЗаказНаряд", "Запчасти", "Товары");
			РазнестиПартииВТаблицеМетодомFIFO(Источник[ИмяТовары], Склад, ФункцииФормДокументов.ПолучитьСтруктуруКолонокТоварыПоОбъекту(Источник, ИмяТовары), ?(Источник.ЭтоНовый(),Неопределено, Источник.Дата), Истина) КонецЕсли; КонецЕсли;
	
КонецПроцедуры
