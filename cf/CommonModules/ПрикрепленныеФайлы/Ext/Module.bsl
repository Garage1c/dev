﻿

Процедура Иницилизировать(Ссылка, Форма) Экспорт
	
	ГруппаЭлементов = Форма.Элементы.ГруппаПрикрепленныхФайлов;
	
	// Удлим прошлые чтуки
	
	Для Каждого Элемент Из ГруппаЭлементов.ПодчиненныеЭлементы Цикл Форма.Элементы.Удалить(Элемент) КонецЦикла;
	Для Каждого Элемент Из ГруппаЭлементов.ПодчиненныеЭлементы Цикл Форма.Элементы.Удалить(Элемент) КонецЦикла;
	
	// нарисуем скрепочку
	
	Декорация = Форма.Элементы.Добавить("ДекорацияСкрепка", Тип("ДекорацияФормы"), ГруппаЭлементов);
	Декорация.Вид 				= ВидДекорацииФормы.Картинка;
	Декорация.Гиперссылка	 	= Истина;
	//Декорация.Ширина			= 2;
	//Декорация.Высота			= 1;
	Декорация.РазмерКартинки 	= РазмерКартинки.Пропорционально;
	Декорация.Картинка 			= БиблиотекаКартинок.Скрепка;
	Декорация.Подсказка 		= "Прикрепить файл";
	
	Декорация.УстановитьДействие("Нажатие", "ПрикрепленныеФайлыНажатиеСкрепка");
	
	// Нарисуем файлики
	
	Запрос = Новый Запрос("ВЫБРАТЬ guid, Имя, Расширение ИЗ РегистрСведений.ПрикрепленныеФайлы ГДЕ Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 1 Тогда // покажем название файла
		
		Выборка.Следующий();
		
		Декорация = Форма.Элементы.Добавить("Файл" + СтрЗаменить(Выборка.guid, "-", ""), Тип("ДекорацияФормы"), ГруппаЭлементов);
		Декорация.Вид 				= ВидДекорацииФормы.Надпись;
		Декорация.Гиперссылка	 	= Истина;
		Декорация.Заголовок			= Выборка.Имя;
		Декорация.Подсказка 		= "Нажать чтобы открыть для просмотра";
		
		Декорация.УстановитьДействие("Нажатие", "ОткрытьПрикрепленныйФайл");
		
	ИначеЕсли Выборка.Количество() > 1 Тогда // покажем что файлов несколько
		
		Декорация = Форма.Элементы.Добавить("Файл" + Выборка.guid, Тип("ДекорацияФормы"), ГруппаЭлементов);
		Декорация.Вид 				= ВидДекорацииФормы.Надпись;
		Декорация.Гиперссылка	 	= Истина;
		Декорация.Заголовок			= "файлы (" + Выборка.Количество() + ")";
		Декорация.Подсказка 		= "Показать прикрепленные файлы";
		
		Декорация.УстановитьДействие("Нажатие", "ПоказатьПрикрееленныеФайлы"); 
		
	Иначе
		
		Возврат; КонецЕсли;
	
	Декорация = Форма.Элементы.Добавить("УдалитьПрикрепленныеФайлы", Тип("ДекорацияФормы"), ГруппаЭлементов);
	Декорация.Вид 				= ВидДекорацииФормы.Картинка;
	Декорация.Гиперссылка	 	= Истина;
	Декорация.Ширина			= 1;
	Декорация.Высота			= 1;
	Декорация.РазмерКартинки 	= РазмерКартинки.Пропорционально;
	Декорация.Картинка 			= БиблиотекаКартинок.Удалить;
	Декорация.Подсказка 		= ?(Выборка.Количество() = 1, "Удалить файл", "Выбрать файл для удаления");

	Декорация.УстановитьДействие("Нажатие", "УдалитьПрикрепленныеФайлыНажатие");
	
КонецПроцедуры

Функция ПоместитьФайлВХранилище(Файл, Ссылка) Экспорт
	
	Путь = Константы.ПутьКХранилищуПрикрепленныхФайлов.Получить();
	Если ПустаяСтрока(Путь) Тогда
		ОбщиеФункции.СообщитьТекст("Не зада параметр ""Путь к хранилищу прикрепленных файлов""");
		Возврат Ложь; КонецЕсли;
	
	НачатьТранзакцию();
	
	ДвДанные = ПолучитьИзВременногоХранилища(Файл.Хранение);
	
	guid 			= Новый УникальныйИдентификатор;
	ИмяФайла 		= Сред(Файл.Имя, СтрНайти(Файл.Имя, ПолучитьРазделительПутиКлиента(), НаправлениеПоиска.СКонца) + 1);
	Расширение		= Сред(ИмяФайла, стрНайти(ИмяФайла, ".", НаправлениеПоиска.СКонца) + 1);
	ПутьВХранилище 	= Строка(guid) + ?(ПустаяСтрока(Расширение), "", ".") + Расширение;
	
	Попытка
		ДвДанные.Записать(Путь + ПутьВХранилище);
	Исключение
		ОбщиеФункции.СообщитьТекст("Ошибка записи файла " + ОписаниеОшибки());
		ОтменитьТранзакцию();
		Возврат ЛОжь; КонецПопытки;
	
	Запись = РегистрыСведений.ПрикрепленныеФайлы.СоздатьМенеджерЗаписи();
	Запись.guid 			= guid;
	Запись.Ссылка 			= Ссылка;
	Запись.Имя 				= ИмяФайла;
	Запись.ПутьВХранилище 	= ПутьВХранилище;
	Запись.Расширение 		= Расширение;
	Запись.Автор 			= ПараметрыСеанса.ТекущийПользователь;
	
	Попытка
		Запись.Записать();
	Исключение
		ОбщиеФункции.СообщитьТекст("Ошибка записи файла в регистр " + ОписаниеОшибки());
		ОтменитьТранзакцию();
		Возврат Ложь; КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	Возврат Истина;
	
КонецФункции

Функция ПолучитьФайлИзХранилища(guidФайла) Экспорт
	
	// Найдем в базе
	
	Запрос = Новый Запрос("ВЫБРАТЬ Имя, Расширение ИЗ РегистрСведений.ПрикрепленныеФайлы ГДЕ guid = &guid");
	Запрос.УстановитьПараметр("guid", Новый УникальныйИдентификатор(guidФайла));
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		ОбщиеФункции.СообщитьТекст("Не найден файл в базе " + guidФайла);
		Возврат Неопределено; КонецЕсли;
	
	// Найдем файл на диске
	
	Путь = Константы.ПутьКХранилищуПрикрепленныхФайлов.Получить();
	
	Если ПустаяСтрока(Путь) Тогда
		ОбщиеФункции.СообщитьТекст("Не задан параметр ""Путь к хранилищу прикрепленных файлов""");
		Возврат Неопределено; КонецЕсли;
	
	ИскФайл = guidФайла + "." + Выборка.Расширение;
	Файлы 	= НайтиФайлы(Путь, ИскФайл);
	Если Не Файлы.Количество() Тогда
		ОбщиеФункции.СообщитьТекст("Не найден файл " + ИскФайл);
		Возврат Неопределено; КонецЕсли;
	
	Возврат Новый Структура("Имя, Раширение, Адрес", Выборка.Имя, Выборка.Расширение, ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Файлы[0].ПолноеИмя)));
	
КонецФункции
Функция ПолучитьСписокФайловДляВыбора(Ссылка) Экспорт
	
	Список = Новый СписокЗначений;
	Запрос = Новый Запрос("ВЫБРАТЬ guid, Имя, Автор ИЗ РегистрСведений.ПрикрепленныеФайлы ГДЕ Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл Список.Добавить(СтрЗаменить(Выборка.guid, "-", ""), Выборка.Имя + " (" + Выборка.Автор + ")") КонецЦикла;
	
	Возврат Список;
	
КонецФункции

Функция УдалитьФайл(стрguid) Экспорт
	
	// Найдем на сервере
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка, guid, ПутьВХранилище, Расширение, Автор ИЗ РегистрСведений.ПрикрепленныеФайлы ГДЕ guid = &guid");
	Запрос.УстановитьПараметр("guid", Новый УникальныйИдентификатор(стрguid));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		ОбщиеФункции.СообщитьТекст("Не найдена ссылка на удаляемый файл " + стрguid);
		Возврат Ложь; КонецЕсли;
	
	// Проверим права
	
	Если Не РольДоступна("ПолныеПрава") И Не РольДоступна("ПолныеПраваВОбласти") И Выборка.Автор <> ПараметрыСеанса.ТекущийПользователь Тогда
		ОбщиеФункции.СообщитьТекст("Вы не являетесь автором файла. Только авторы могут удалять файлы.");
		Возврат Ложь; КонецЕсли;
	
	НачатьТранзакцию();
	
	// Удалим с базы
	
	Запись = РегистрыСведений.ПрикрепленныеФайлы.СоздатьМенеджерЗаписи();
	Запись.Ссылка 	= Выборка.Ссылка;
	Запись.guid 	= Выборка.guid;
	
	Если Не ОбщиеФункции.УдалитьОбъектИСообщитьЕслиОшибка(Запись) Тогда
		ОтменитьТранзакцию();
		Возврат Ложь; КонецЕсли;
	
	// Удалим с хранилища на диске
	
	Попытка
		УдалитьФайлы(Константы.ПутьКХранилищуПрикрепленныхФайлов.Получить() + Выборка.ПутьВХранилище);
	Исключение
		ОбщиеФункции.СообщитьТекст("Ошибка удаления файла из хранилища " + ОписаниеОшибки());
		ОтменитьТранзакцию(); КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	Возврат Истина;
	
КонецФункции