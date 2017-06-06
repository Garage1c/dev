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

Процедура ПередЗаписью(Отказ)
	
		
	// Установим порядковый номер
	
	Если Не ПорядковыйНомер Тогда
		
		Максимум = ?(ЭтоГруппа, 
						Константы.МаксимальныйПорядковыйНомерКатегории.Получить(),
						Константы.МаксимальныйПорядковыйНомер.Получить());
						
		ПорядковыйНомер = Максимум + 1; КонецЕсли;
	
	// Проверим alies
	
	Если ПустаяСтрока(alies) Тогда
		                                                                                  
		alies = НРег(КонвертацияТипов.ПреобразоватьРусскийТекстВАнглицкий(СформироватьAliesИзНаименования()));
		
	ИначеЕсли КонвертацияТипов.ЕстьРусскиеБуквы(alies) Тогда
		
		// Проверим чтобы alies был токо англицкий
		
			alies = НРег(КонвертацияТипов.ПреобразоватьРусскийТекстВАнглицкий(СформироватьAliesИзНаименования())); КонецЕсли;
	
	Если ПустаяСтрока(alies_ru) Тогда alies_ru = НРег(СформироватьAliesИзНаименования()) КонецЕсли;
	
	новАлиес = HTTP.ПроверитьИПолучитьНовыйAlies(Ссылка, ЭтоНовый(), alies);
	Если новАлиес <> alies Тогда alies = новАлиес КонецЕсли;
	
	новАлиес = HTTP.ПроверитьИПолучитьНовыйAlies(Ссылка, ЭтоНовый(), alies_ru, "alies_ru");
	Если новАлиес <> alies_ru Тогда alies_ru = новАлиес КонецЕсли;
			
	// Если алиес изменился тогда запоминаем его
	Если Не ПустаяСтрока(Ссылка.alies) И Ссылка.alies <> alies Тогда
		СтарыйURL = Ссылка.alies + ?(ПустаяСтрока(СтарыйURL), "", Символы.ПС + СтарыйURL); КонецЕсли;
	
	//// КОД
	//
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
	////////////////////////////////////////////////////////////////////////////////
	//// Проверим код товара и если он не по правилам то зададим его
	////////////////////////////////////////////////////////////////////////////////
	//Запрос = Новый Запрос("ВЫБРАТЬ
	//	                      |	СпрНом.Ссылка.Производитель,
	//	                      |	МАКСИМУМ(СпрНом.Код2) КАК Код2
	//	                      |ПОМЕСТИТЬ Таблица
	//	                      |ИЗ
	//	                      |	Справочник.НоменклатураСайтGarage КАК СпрНом
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
	//	                      |	Справочник.НоменклатураСайтGarage КАК Спр
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
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// Увеличим константу порядкового номера
	
	ИмяКонстанты = ?(ЭтоГруппа, 
						"МаксимальныйПорядковыйНомерКатегории", 
						"МаксимальныйПорядковыйНомер");
	
	Если ПорядковыйНомер > Константы[ИмяКонстанты].Получить() Тогда Константы[ИмяКонстанты].Установить(ПорядковыйНомер) КонецЕсли;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоКода(СтандартнаяОбработка, Префикс)
	
	// Сбросим номер, вдруг он копируется
	
	Если ЭтоНовый() Тогда ПорядковыйНомер = 0 КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВыгружатьНаСайт Или ДляДилеров Тогда
		ПроверяемыеРеквизиты.Добавить("Артикул"); КонецЕсли;
	
КонецПроцедуры
