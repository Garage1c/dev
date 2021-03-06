﻿
Функция ПреобразоватьПервыйРезультатВВыражении(Владелец, Выражение, ДатаНач = Неопределено, ДатаКон = Неопределено)
	
	// Заменяет в квадратных скобках вычислениями результатов строк
	// Возвращает Истина если была замена и Ложь если заменять было нечего
	// 				Если неопределено вернет то произошла ошибка
	
	// Вытащим код справочника
	
	НачСкобы = СтрНайти(Выражение, "[");
	Если НачСкобы Тогда
		КонСкобы = СтрНайти(Выражение, "]",,НачСкобы);
		Если Не КонСкобы Тогда
			ОбщиеФункции.СообщитьТекст("Ожидается ""]""");
			Возврат Неопределено; КонецЕсли;
		
		// Найдем справочник по коду в базе
		
		Код = СокрЛП(Сред(Выражение, НачСкобы + 1, КонСкобы - НачСкобы - 1));
		//Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.ЗаписиУО ГДЕ Владелец = &Владелец И Код = """ + Код + """");
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Результат ИЗ Справочник.ЗаписиУО ГДЕ Владелец = &Владелец И Код = """ + Код + """");
		Запрос.УстановитьПараметр("Владелец", Владелец);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Не Выборка.Следующий() Тогда
			ОбщиеФункции.СообщитьТекст("Не найден справочник по коду " + Код);
			Возврат Неопределено; КонецЕсли;
		
		// Получим результат и вставим в текст
		
		//Результат = ПолучитьРезультат(Выборка.Ссылка, ДатаНач, ДатаКон);
		Результат = Выборка.Результат;
		
		//Если Результат = Неопределено Тогда Возврат Неопределено КонецЕсли;
		
		Выражение = СтрЗаменить(Выражение, Сред(Выражение, НачСкобы, КонСкобы - НачСкобы + 1), Формат(Результат, "ЧРД=.; ЧН=0; ЧГ="));
		Возврат Истина;                                                                                
		
	Иначе
		Возврат Ложь; КонецЕсли;
	
КонецФункции
Функция ВычислитьВыражение(Владелец, Выражение, ДатаНач = Неопределено, ДатаКон = Неопределено) Экспорт
	
	// Владелец - Справочник ссылка УправленческаяОтчетность
	// заменем все квадратные скобки на вычисление выражений
	
	Пока Истина Цикл
		
		текЦикл = ПреобразоватьПервыйРезультатВВыражении(Владелец, Выражение, ДатаНач, ДатаКон);
		Если текЦикл = Неопределено Тогда
			Возврат Неопределено;
		ИначеЕсли текЦикл = Ложь Тогда
			Прервать; КонецЕсли; КонецЦикла;
	
	// Ну и вычислим
	
	Попытка
		Результат = Вычислить(Выражение);
	Исключение
		ОбщиеФункции.СообщитьТекст("Ошибка вычисления выражения " + ОписаниеОшибки());
		Возврат Неопределено; КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если Данные.Ссылка <> Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		Представление = "(" + Строка(Данные.Код) + ") " + Данные.Ссылка.Представление; КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьРезультат_Ст(Ссылка, ДатаНач = Неопределено, ДатаКон = Неопределено) Экспорт
	
	//Если Ссылка.ЭтоГруппа Тогда
	//	
	//	// Получим сумму всех элементов
	//	
	//	Результат = 0;
	//	
	//	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.ЗаписиУО ГДЕ Родитель = &Ссылка");
	//	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	//	Выборка = Запрос.Выполнить().Выбрать();
	//	Пока Выборка.Следующий() Цикл
	//		текРезультат = Справочники.ЗаписиУО.ПолучитьРезультат(Выборка.Ссылка, ДатаНач, ДатаКон);
	//		Если текРезультат = Неопределено Тогда
	//			Возврат Неопределено КонецЕсли;
	//		Результат = Результат + текРезультат; КонецЦикла;
	//	
	//	Возврат Результат;
	//	
	//ИначеЕсли Ссылка.Источник.Пустая() Тогда
	//	
	//	ОбщиеФункции.СообщитьТекст(Строка(Ссылка) + " - не указан источник записи");
	//	Возврат Неопределено;
	//	
	//Иначе
	//
	//	Возврат Справочники.ИсточникиДанныхУО.ПолучитьРезультат(Ссылка.Источник, ДатаНач, ДатаКон); КонецЕсли;
	
КонецФункции
Функция ПолучитьРезультат(Ссылка, ДатаНач = Неопределено, ДатаКон = Неопределено) Экспорт
	
	Если Ссылка.СпособПолученияРезультата = 0 Тогда			// Вручную
		
		Возврат Ссылка.Результат;
		
	ИначеЕсли Ссылка.СпособПолученияРезультата = 1 Тогда	// Сумма
		
		//Результат = 0;
		//	
		//Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.ЗаписиУО ГДЕ Родитель = &Ссылка");
		//Запрос.УстановитьПараметр("Ссылка", Ссылка.Ссылка);
		//Выборка = Запрос.Выполнить().Выбрать();
		//Пока Выборка.Следующий() Цикл
		//	текРезультат = Справочники.ЗаписиУО.ПолучитьРезультат(Выборка.Ссылка, ДатаНач, ДатаКон);
		//	Если текРезультат = Неопределено Тогда
		//		Возврат Неопределено КонецЕсли;
		//	Результат = Результат + текРезультат; КонецЦикла;
		//	
		//Возврат Результат;
		
		Запрос = Новый Запрос("ВЫБРАТЬ СУММА(Результат) Результат ИЗ Справочник.ЗаписиУО ГДЕ Родитель = &Ссылка И Не ПометкаУдаления");
		Запрос.УстановитьПараметр("Ссылка", Ссылка.Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда 
			Возврат Выборка.Результат 
		Иначе 
			Возврат 0 КонецЕсли;
		
	ИначеЕсли Ссылка.СпособПолученияРезультата = 2 Тогда	// Формула
		
			Возврат ВычислитьВыражение(Ссылка.Владелец, Строка(Ссылка.Выражение), ДатаНач, ДатаКон);
		
	ИначеЕсли Ссылка.СпособПолученияРезультата = 3 Тогда	// Источник
		
		Если Ссылка.Источник.Пустая() Тогда
				ОбщиеФункции.СообщитьТекст(Строка(Ссылка) + " - не указан источник записи");
				Возврат Неопределено; 
		Иначе	Возврат Справочники.ИсточникиДанныхУО.ПолучитьРезультат(Ссылка.Источник, ДатаНач, ДатаКон); КонецЕсли; 
	Иначе
		
		ОбщиеФункции.СообщитьТекст("Не известный способ получения результата - " + Ссылка.СпособПолученияРезультата);
		Возврат Неопределено; КонецЕсли;
	
КонецФункции
