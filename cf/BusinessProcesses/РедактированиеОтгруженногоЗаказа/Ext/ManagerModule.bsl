﻿
Функция ПолучитьЗаголовокБП(СсылкаПроцесс) Экспорт Возврат Строка(СсылкаПроцесс) КонецФункции

Процедура ЗаполнитьФормуПоБП_Ст(Форма, СсылкаПроцесс, СсылкаЗадача = Неопределено) Экспорт
	
	// Определим тип
	
	Если СсылкаПроцесс.Заказ = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		ИмяПроцесса = "ЗаявкаПокупателя";
	ИначеЕсли СсылкаПроцесс.Заказ = Тип("ДокументСсылка.ИнтернетЗаказПокупателя") Тогда
		ИмяПроцесса = "ИнтернетЗаказПокупателя";
	Иначе Возврат; КонецЕсли; 
	
	// Если новый тоогда найдем БП заказа и получим данные из него
	
	Если Форма.Объект.Ссылка.Пустая() Тогда
		
		Запрос 	= Новый Запрос("ВЫБРАТЬ Ссылка ИЗ БизнесПроцесс." + ИмяПроцесса + " ГДЕ Заказ = &Заказ");
		Запрос.УстановитьПараметр("Заказ", Форма.Объект.Заказ);
		Выборка = Запрос.Выполнить().Выбрать();
		Ссылка 	= Выборка.Ссылка;
		
	Иначе Ссылка = СсылкаПроцесс;	КонецЕсли;
	
	// Заполним из типовой формы
	
	БизнесПроцессы[ИмяПроцесса].ЗаполнитьФормуПоБП(Форма, Ссылка, СсылкаЗадача);
	
КонецПроцедуры
Процедура ЗаполнитьФормуПоБП(Форма, СсылкаПроцесс, СсылкаЗадача = Неопределено) Экспорт
	
	Заказ 		= Форма.Объект.Заказ;
	БПЗаказа 	= Заказы.ПолучитьПроцесс(Заказ);
	
	// Заполним шапку
	
	БизнесПроцессы[БПЗаказа.Метаданные().Имя].ЗаполнитьФормуПоБП(Форма, БПЗаказа, СсылкаЗадача);
	
	// Отсеем только отгруженные товары
	
	Форма.Товары.Загрузить(
			КонвертацияТипов.ПолучитьТаблицуИзНайденныхСтрокТаблицыЗначений(
				Заказы.ПолучитьТаблицуТоваров(БПЗаказа),
				Новый Структура("Отгружено", Истина)));
				
	Товары = Форма.Товары.Выгрузить();
				
	// Добавим к товаром слово было
	
	Для Каждого Колонка Из Товары.Колонки Цикл Имя = Колонка.Имя;
		Если Врег(Прав(Колонка.Имя, 4)) = Врег("Было") Тогда
			Товары.ЗагрузитьКолонку(Товары.ВыгрузитьКолонку(Сред(Колонка.Имя, 1, СтрДлина(Колонка.Имя) - 4)), Колонка.Имя); КонецЕсли; КонецЦикла;
	
	// Обратно вернем
	
	Форма.Товары.Загрузить(Товары);
	
КонецПроцедуры

Функция ПолучитьМассивКомментариев(СсылкаПроцесс) Экспорт
	
	Массив = Новый Массив;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Комментарий, Заголовок, ДатаВыполнения, Исполнитель
	|ИЗ
	|(
		// коменты из задач БП и задач всех вложенных БП
	
	|	ВЫБРАТЬ
	|		Комментарий, Наименование Заголовок, ДатаВыполнения, Исполнитель
	|	ИЗ
	|		Задача.ЗадачаПользователю
	|	ГДЕ
	|		БизнесПроцесс = &Ссылка ИЛИ
	|		БизнесПроцесс В (ВЫБРАТЬ Ссылка ИЗ БизнесПроцесс.СборкаЗаказа ГДЕ Заказ = &Заказ) ИЛИ
	|		БизнесПроцесс В (ВЫБРАТЬ Ссылка ИЗ БизнесПроцесс.ПеремещениеТоваров ГДЕ Заказчик В (ВЫБРАТЬ Ссылка ИЗ БизнесПроцесс.СборкаЗаказа ГДЕ Заказ = &Заказ))
	
		// коменты из документа Заказ
	
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Комментарий, ""Редактирование отгруженного заказа"", Дата, Ответственный
	|	ИЗ
	|		Документ.ЗаказПокупателя
	|	ГДЕ
	|		Ссылка = &Заказ
	|
	
		// коменты из данного БП
	
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Комментарий, ""Редактирование отгруженного заказа"", Дата, ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	ИЗ
	|		БизнесПроцесс.РедактированиеОтгруженногоЗаказа
	|	ГДЕ
	|		Ссылка = &Ссылка
    |
	|) Запрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаВыполнения
	|");
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаПроцесс);
	Запрос.УстановитьПараметр("Заказ", 	СсылкаПроцесс.Заказ);

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ПустаяСтрока(Выборка.Комментарий) Тогда
		
			Массив.Добавить(Новый Структура("Комментарий, Заголовок, ДатаВыполнения, Исполнитель",
									Выборка.Комментарий, Выборка.Заголовок, Выборка.ДатаВыполнения, Выборка.Исполнитель));
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции
