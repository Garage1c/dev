﻿
Функция СформироватьAliesИзНаименования()
	
	ДоступныеСимволы 	= "-_1234567890ABCDEIFGHIJKLMNOPQRSTUVWXYZАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯЁ";
	СимволыНаТире 		= ".,=;/\- ";
	
	НаименованиеВРег 	= ВРег(СокрЛП(Наименование));
	ДлинаНаим 			= СтрДлина(СокрЛП(Наименование));
	
	СтрAlies = "";
	
	Для ном = 1 По ДлинаНаим Цикл текСимволВрег = Сред(НаименованиеВРег, ном, 1); текСимвол = Сред(Наименование, ном, 1); Если Найти(ДоступныеСимволы, текСимволВрег) Тогда СтрAlies = СтрAlies + текСимвол; ИначеЕсли Найти(СимволыНаТире, текСимволВрег) Тогда СтрAlies = СтрAlies + "-"; КонецЕсли;КонецЦикла;
	
	// { Удалить - временная мера
	
	СтрAlies = СтрЗаменить(СтрAlies, "--", "-");
	СтрAlies = СтрЗаменить(СтрAlies, "--", "-");
	СтрAlies = СтрЗаменить(СтрAlies, "--", "-");
	СтрAlies = СтрЗаменить(СтрAlies, "--", "-");
	
	Если Прав(СтрAlies,1) = "-" Тогда СтрAlies = Лев(СтрAlies, СтрДлина(СтрAlies) - 1) КонецЕсли;
	Если Прав(СтрAlies,1) = "-" Тогда СтрAlies = Лев(СтрAlies, СтрДлина(СтрAlies) - 1) КонецЕсли;
	Если Прав(СтрAlies,1) = "-" Тогда СтрAlies = Лев(СтрAlies, СтрДлина(СтрAlies) - 1) КонецЕсли;
	
	// }
	
	Возврат СтрAlies;
	
КонецФункции

Функция ПолучитьПоследнийНомерНоменклатуры() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ КОЛИЧЕСТВО(Ссылка) Всего ИЗ Справочник.Номенклатура");
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Всего;	
	
КонецФункции

Процедура ПередЗаписью(Отказ)
	
	//пока уберем
	//Если Ранг <> Ссылка.Ранг Тогда ДополнительныеСвойства.Вставить("indexer", Истина) КонецЕсли;
	
	// Установим порядковый номер
	
	// belova 09.12.2016 убираю этот механизм -> {
	
	//Если Не ПорядковыйНомер Тогда
	//	
	//	Максимум = ?(ЭтоГруппа, 
	//					Константы.МаксимальныйПорядковыйНомерКатегории.Получить(),
	//					Константы.МаксимальныйПорядковыйНомер.Получить());
	//					
	//	ПорядковыйНомер = Максимум + 1; КонецЕсли;
	
	//  } <- belova 09.12.2016 убираю этот механизм

	
	// Проверим alies
	
	Если ПустаяСтрока(alies) Тогда
		                                                                                  
		alies = НРег(КонвертацияТипов.ПреобразоватьРусскийТекстВАнглицкий(СформироватьAliesИзНаименования()));
		
	ИначеЕсли КонвертацияТипов.ЕстьРусскиеБуквы(alies) Тогда
		
		// Проверим чтобы alies был токо англицкий
		
			// Отключаем исторю по старому урлу 
			// СтарыйURL = alies + ?(ПустаяСтрока(СтарыйURL), "", Символы.ПС + СтарыйURL);
			alies = НРег(КонвертацияТипов.ПреобразоватьРусскийТекстВАнглицкий(СформироватьAliesИзНаименования())); КонецЕсли;
	
	Если ПустаяСтрока(alies_ru) Тогда alies_ru = НРег(СформироватьAliesИзНаименования()) КонецЕсли;
	
	новАлиес = HTTP.ПроверитьИПолучитьНовыйAlies(Ссылка, ЭтоНовый(), alies);
	Если новАлиес <> alies Тогда alies = новАлиес КонецЕсли;
	
	новАлиес = HTTP.ПроверитьИПолучитьНовыйAlies(Ссылка, ЭтоНовый(), alies_ru, "alies_ru");
	Если новАлиес <> alies_ru Тогда alies_ru = новАлиес КонецЕсли;
			
	// Если алиес изменился тогда запоминаем его
	Если Не ПустаяСтрока(Ссылка.alies) И Ссылка.alies <> alies Тогда
		СтарыйURL = Ссылка.alies + ?(ПустаяСтрока(СтарыйURL), "", Символы.ПС + СтарыйURL); КонецЕсли;
	
	// КОД
	
	//Если ПустаяСтрока(Код2) Тогда
	//	Запрос 	= Новый Запрос("ВЫБРАТЬ Количество(Ссылка) Кол ИЗ Справочник.Номенклатура");
	//	Выборка = Запрос.Выполнить().Выбрать();
	//	Выборка.Следующий();
	//	Код2 = Выборка.Кол; КонецЕсли;
			
	
	// Запомним когда был создан
	
	Если ЭтоНовый() Тогда 
		ДатаСоздания = ТекущаяДата();
		Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	
#Область уникальный_код2
	
	Если ЭтоНовый() Тогда // даем следующий номер
	
		//Запрос = Новый Запрос("ВЫБРАТЬ КОЛИЧЕСТВО(Ссылка) Всего ИЗ Справочник.Номенклатура");
		//Выборка = Запрос.Выполнить().Выбрать();
		//Выборка.Следующий();
		Номер = ПолучитьПоследнийНомерНоменклатуры();

		Код2 = Формат(Номер + 1, "ЧГ=");
		ПорядковыйНомер = Номер + 1;
		
	ИначеЕсли ПустаяСтрока(Код2) Тогда // Нарушены коды, даем новый код с префиксом сбоя
		
		ПрефиксСбоя = "er"; 
		длПреф = СтрДлина(ПрефиксСбоя);
		//длКода = Метаданные().Реквизиты.Код2.Тип.КвалификаторыСтроки.Длина;
		
		Запрос = Новый Запрос("ВЫБРАТЬ МАКСИМУМ(Код2) Код ИЗ Справочник.Номенклатура ГДЕ ПОДСТРОКА(Код2, 1, " + Формат(длПреф, "ЧГ=") + ") = """ + ПрефиксСбоя + """");
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		текКод = ?(ЗначениеЗаполнено(Выборка.Код), Число(Сред(Выборка.Код, длПреф + 1)) + 1, 0); 
		
		//стрНулей = "";
		//НехватНулей = длКода - СтрДлина(Строка(текКод));
		//Для Ном = 1 По НехватНулей Цикл стрНулей = стрНулей + "0" КонецЦикла;
		
		//Код2 = ПрефиксСбоя + стрНулей + Строка(текКод);
		Код2 = ПрефиксСбоя + Строка(текКод);
		
	Иначе	// Проверяем на уникальность код2
		
		Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.Номенклатура ГДЕ Ссылка <> &Ссылка И Код2 = """ + Код2 + """");
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Если Не Запрос.Выполнить().Пустой() Тогда
			Отказ = Истина;
			ОбщиеФункции.СообщитьТекст("Код2 не уникальный! " + Ссылка); КонецЕсли; КонецЕсли;
	
#КонецОбласти		

	Если ПорядковыйНомер = 0 И НЕ ЭтоНовый() Тогда
		
		ПорядковыйНомер = ПолучитьПоследнийНомерНоменклатуры() + 1;

	КонецЕсли;

	
#Область Антон
	
	////////////////////////////////////////////////////////////////////////////////
	//// Проверим код товара и если он не по правилам то зададим его
	////////////////////////////////////////////////////////////////////////////////
	//Запрос = Новый Запрос("ВЫБРАТЬ
	//	                      |	СпрНом.Ссылка.Производитель,
	//	                      |	МАКСИМУМ(СпрНом.Код2) КАК Код2
	//	                      |ПОМЕСТИТЬ Таблица
	//	                      |ИЗ
	//	                      |	Справочник.Номенклатура КАК СпрНом
	//	                      |ГДЕ
	//	                      |	СпрНом.Производитель = &ПР
	//	                      |	И СпрНом.Код2 ПОДОБНО &Рег0
	//	                      |
	//	                      |СГРУППИРОВАТЬ ПО
	//	                      |	СпрНом.Ссылка.Производитель
	//	                      |
	//	                      |ОБЪЕДИНИТЬ ВСЕ
	//	                      |
	//	                      |ВЫБРАТЬ
	//	                      |	Спр.Ссылка.Производитель,
	//	                      |	МАКСИМУМ(Спр.Код2)
	//	                      |ИЗ
	//	                      |	Справочник.Номенклатура КАК Спр
	//	                      |ГДЕ
	//	                      |	Спр.Производитель = &ПР
	//	                      |	И Спр.Код2 ПОДОБНО &Рег1
	//	                      |
	//	                      |СГРУППИРОВАТЬ ПО
	//	                      |	Спр.Ссылка.Производитель
	//	                      |;
	//	                      |/////////////////////////////
	//						  |ВЫБРАТЬ
	//	                      |	Таблица.СсылкаПроизводитель,
	//	                      |	МИНИМУМ(Таблица.Код2) КАК Код2
	//	                      |ИЗ
	//	                      |	Таблица КАК Таблица
	//	                      |
	//	                      |СГРУППИРОВАТЬ ПО
	//	                      |	Таблица.СсылкаПроизводитель");
	//	Запрос.УстановитьПараметр("Рег0", "[0-9][0-9][0-9].[0-9][0-9][0-9]");
	//	Запрос.УстановитьПараметр("Рег1", "[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]");
	//////////////////////////////////////////////////////////////////////////////////////////
	//Если НЕ ЭтоГруппа И	Не Производитель.Пустая() И Производитель.Код <> Лев(Код2, 3) Тогда
	//	//////////////////////////////////////////////////////////////
	//	//Запрос 		= Новый Запрос("ВЫБРАТЬ Количество(Ссылка) Количество ИЗ Справочник.Номенклатура ГДЕ Производитель = Производитель И ПОДСТРОКА(Код, 1, 3) = """ + Производитель.Код + """");
	//	//Выборка 	= Запрос.Выполнить().Выбрать();
	//	//Если Выборка.Следующий() Тогда НовКод = Выборка.Количество + 1 КонецЕсли;
	//	//////////////////////////////////////////////////////////////
	//	
	//	НовКод 		= 1;
	//	Запрос.УстановитьПараметр("ПР", Производитель);
	//	ВыборкаКод = Запрос.Выполнить().Выбрать();
	//	Если ВыборкаКод.Следующий() Тогда
	//		НовКод = Число(СтрЗаменить(Прав(ВыборкаКод.Код2, СтрДлина(ВыборкаКод.Код2) - Найти(ВыборкаКод.Код2, ".")), ".", ""))+1;
	//	КонецЕсли;
	//	////////////////////////////////////////////////////////////////
	//	Код2 = Производитель.Код + "." + Формат(НовКод, "ЧЦ=" + ?(НовКод >= 1000, "5", "3") + "; ЧРД=; ЧРГ=.; ЧВН=");
	//	////////////////////////////////////////////////////////////////
	//ИначеЕсли НЕ ЭтоГруппа И Производитель.Пустая() И Лев(Код2, 3) <> "000" Тогда
	//	
	//	НовКод 		= 1;
	//	Запрос.УстановитьПараметр("ПР", Справочники.Производители.ПустаяСсылка());
	//	ВыборкаКод = Запрос.Выполнить().Выбрать();
	//	Если ВыборкаКод.Следующий() Тогда
	//		НовКод = Число(СтрЗаменить(Прав(ВыборкаКод.Код2, СтрДлина(ВыборкаКод.Код2) - Найти(ВыборкаКод.Код2, ".")), ".", ""))+1;
	//	КонецЕсли;
	//	////////////////////////////////////////////////////////////////
	//	Код2 = "000" + "." + Формат(НовКод, "ЧЦ=" + ?(НовКод >= 1000, "5", "3") + "; ЧРД=; ЧРГ=.; ЧВН=");
	//	////////////////////////////////////////////////////////////////
	//КонецЕсли;
	//	////////////////////////////////////////////////////////////////
		
#КонецОбласти
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// Проверим соответствие матрицы
	
	Если НЕ ЭтоГруппа и НЕ ОбменДанными.Загрузка И (
			НЕ ДополнительныеСвойства.Свойство("ОтключитьПроверкуМатриц") Или (ДополнительныеСвойства.Свойство("ОтключитьПроверкуМатриц") и ДополнительныеСвойства.ОтключитьПроверкуМатриц <> ИСТИНА)) Тогда
		
		// Определим какие матрицы у товара заполнены и их нужно проверять
		
		МатрицыНаПроверку 	= Новый Массив;
		Матрицы 			= РаботаСНоменклатурой.Матрицы();
		Для Каждого Матрица Из Матрицы Цикл
			
			ЗначениеМатрицы = Ссылка[РаботаСНоменклатурой.ИмяРеквизитаМатрицыВТоваре(Матрица)];
			Если ?(Матрица.Это1К1, ЗначениеЗаполнено(ЗначениеМатрицы) И ЗначениеМатрицы = Матрица.Ссылка, ЗначениеМатрицы) Тогда
				МатрицыНаПроверку.Добавить(Матрица.Ссылка); КонецЕсли; КонецЦикла;
		
		//  Проверим
		
		Если Не РаботаСНоменклатурой.МожноУстановитьМатрицу(МатрицыНаПроверку, Ссылка) Тогда
			Отказ = Истина;
			Возврат; КонецЕсли; КонецЕсли;
	
	// Увеличим константу порядкового номера
	
	// belova 09.12.2016 убираю этот механизм -> {
	//
	//ИмяКонстанты = ?(ЭтоГруппа, 
	//					"МаксимальныйПорядковыйНомерКатегории", 
	//					"МаксимальныйПорядковыйНомер");
	//
	//Если ПорядковыйНомер > Константы[ИмяКонстанты].Получить() Тогда Константы[ИмяКонстанты].Установить(ПорядковыйНомер) КонецЕсли;
	//  } <- belova 09.12.2016 убираю этот механизм

КонецПроцедуры

Функция ПолучитьНовыйКодМатрицы()
	
	
	
КонецФункции

Процедура ПриУстановкеНовогоКода(СтандартнаяОбработка, Префикс)
	
	// Сбросим номер, вдруг он копируется
	
	// belova 09.12.2016 убираю этот механизм -> {
	
	//Если ЭтоНовый() Тогда ПорядковыйНомер = 0 КонецЕсли;
	//  } <- belova 09.12.2016 убираю этот механизм
	
	НовыйКод = ПолучитьНовыйКодМатрицы();
	
	Если Не  ЭтоГруппа Тогда
		Префикс = "g-"; КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВыгружатьНаСайт Или ДляДилеров Тогда
		ПроверяемыеРеквизиты.Добавить("Артикул"); КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Отказ = Истина;
	ОбщиеФункции.СообщитьТекст("Удалять запрещено, так как это нарушит уникальность ""Код2""");
		
КонецПроцедуры
