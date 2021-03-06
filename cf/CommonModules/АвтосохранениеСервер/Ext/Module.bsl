﻿
Функция ПолучитьИнтервал() Экспорт
	
	Значение = ОбщиеФункции.НастройкаПользователя("АвтосохранениеДокументов");
	Возврат ?(ЗначениеЗаполнено(Значение), Значение, Ложь);
	
КонецФункции

Процедура ЗаполнитьПоСТруктуре(Объект, Структура)
	
	ТипМассив = Тип("Массив");
	
	Для Каждого Элемент Из Структура Цикл
		
		Значение = Элемент.Значение;
		
		Если ТипЗнч(Значение) = ТипМассив Тогда
			Объект[Элемент.Ключ].Очистить();
			Для Каждого ЭлементМассива Из Значение Цикл ЗаполнитьЗначенияСвойств(Объект[Элемент.Ключ].Добавить(), ЭлементМассива) КонецЦикла;
				
		Иначе Попытка Объект[Элемент.Ключ] = Значение; Исключение КонецПопытки; КонецЕсли; КонецЦикла;
		
	КонецПроцедуры
	
Функция СчитатьДанныеФормыИУдалитьСохранение(Форма, ДанныеДляПодбора, ИмяОбъект = "Объект") Экспорт
	
	Объект = Форма[ИмяОбъект];
	Ссылка = Объект.Ссылка;
	
	Запись = РегистрыСведений.Автосохранение.СоздатьМенеджерЗаписи();
	Запись.Ссылка 		= Ссылка;
	Запись.ИмяФормы 	= Форма.ИмяФормы;
	Запись.Пользователь = ПараметрыСеанса.ТекущийПользователь;
	
	Запись.Прочитать();
	Данные = Запись.Дамп.Получить();
	
	Если Данные <> Неопределено Тогда
		
		// Заполним форму
		
		ЗаполнитьПоСТруктуре(Форма, Данные.РеквизитыФормы);
		
		// Заполним объект
		
		ЗаполнитьПоСТруктуре(Объект, Данные.РеквизитыОбъекта); 
		
		// Подбор
		
		Если Данные.Свойство("Подбор") Тогда
			ДанныеДляПодбора = ЗначениеВСтрокуВнутр(Данные.Подбор) КонецЕсли; КонецЕсли;
	
	//Возврат УдалитьАвтоСохранение(ИмяФормы, Ссылка);
	Возврат Истина; // пускай удаляет при закрытии формы
	
КонецФункции

Функция УдалитьАвтоСохранение(ИмяФормы, Ссылка) Экспорт
	
	Запись = РегистрыСведений.Автосохранение.СоздатьМенеджерЗаписи();
	
	Запись.ИмяФормы 		= ИмяФормы;
	Запись.Ссылка 			= Ссылка;
	Запись.Пользователь 	= ПараметрыСеанса.ТекущийПользователь;
	
	// Запишем
	
	Возврат ОбщиеФункции.УдалитьОбъектИСообщитьЕслиОшибка(Запись); 
	
КонецФункции
Функция СохранитьДамп(Ссылка, ИмяФормы, Дамп) Экспорт
	
	Запись = РегистрыСведений.Автосохранение.СоздатьМенеджерЗаписи();
	
	Запись.ИмяФормы 		= ИмяФормы;
	Запись.Ссылка 			= Ссылка;
	Запись.ДатаСохранения 	= ТекущаяДата();
	Запись.Пользователь 	= ПараметрыСеанса.ТекущийПользователь;
	Запись.Дамп 			= Новый ХранилищеЗначения(Дамп, Новый СжатиеДанных(9));
	
	// Запишем
	
	Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Запись); 
	
КонецФункции

Функция ЕстьДамп(Ссылка, ИмяФормы) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 ИмяФормы ИЗ РегистрСведений.Автосохранение ГДЕ ИмяФормы = """ + ИмяФормы + """ И Ссылка = &Ссылка И Пользователь = &ТекущийПользователь");
	
	Запрос.УстановитьПараметр("Ссылка", 				Ссылка);
	Запрос.УстановитьПараметр("ТекущийПользователь", 	ПараметрыСеанса.ТекущийПользователь);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции
Функция ПолучитьДамп(Форма, ИмяОбъект = "Объект") Экспорт
	
	РеквизитыФормы 	= Новый Структура;
	ТипТаблица		= Новый ОписаниеТипов("ТаблицаЗначений");
	
	Реквизиты = Форма.ПолучитьРеквизиты();
	Для Каждого Реквизит Из Реквизиты Цикл Если Реквизит.СохраняемыеДанные И Реквизит.Имя <> ИмяОбъект Тогда 
		РеквизитыФормы.Вставить(Реквизит.Имя, ?(Реквизит.ТипЗначения = ТипТаблица, 
				КонвертацияТипов.ПолучитьМассивИзТаблицыЗначений(Форма[Реквизит.Имя].Выгрузить()),
				Форма[Реквизит.Имя])); КонецЕсли; КонецЦикла;
			
	РеквизитыОбъекта = КонвертацияТипов.ПолучитьСтруктуруИзОбъекта(Форма[ИмяОбъект], Форма[ИмяОбъект].Ссылка.Метаданные());
	РеквизитыОбъекта.Удалить("Ссылка");
		
	Возврат Новый Структура("РеквизитыОбъекта, РеквизитыФормы", РеквизитыОбъекта, РеквизитыФормы);
	
КонецФункции
Функция СохранитьДампФормы(Форма, ЕстьДамп, ИмяОбъект = "Объект") Экспорт
	
	Ссылка 		= Форма[ИмяОбъект].Ссылка;
	ЕстьДамп 	= ЕстьДамп(Ссылка, Форма.ИмяФормы);
	
	// Возвращает ИСТИНА если был факт сохранения
	
	//Возврат ?(Не Ссылка.Пустая() И Форма.Модифицированность,
	Возврат ?(Форма.Модифицированность,
					СохранитьДамп(Ссылка, Форма.ИмяФормы, ПолучитьДамп(Форма, ИмяОбъект)),
					Ложь);
	
КонецФункции
