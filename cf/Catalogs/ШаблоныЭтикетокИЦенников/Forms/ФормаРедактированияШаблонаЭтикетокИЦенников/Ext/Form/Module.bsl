﻿
&НаСервере
// Функция возвращает структуру шаблона
//
Функция ПолучитьСтруктуруШаблона()
	
	СтруктураШаблона = Неопределено;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
	СтруктураШаблона = Объект.Ссылка.Шаблон.Получить();
	Иначе
		ЗначениеКопирования = Неопределено;
		Параметры.Свойство("ЗначениеКопирования", ЗначениеКопирования);
		Если ЗначениеКопирования <> Неопределено Тогда
			СтруктураШаблона = ЗначениеКопирования.Шаблон.Получить();
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураШаблона;
	
КонецФункции // ПолучитьСтруктуруШаблона()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	// Заполнение доступных полей
	СхемаКомпоновкиДанных = Обработки.ПечатьЦенников.ПолучитьМакет("ПоляШаблона");
	АдресВХранилище = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресВХранилище));
	УстановитьПривилегированныйРежим(Ложь);
	
	СтруктураШаблона = ПолучитьСтруктуруШаблона();
	
	Если СтруктураШаблона <> Неопределено Тогда
		// Загрузка шаблона.
		СтруктураШаблона.Свойство("РедакторТабличныйДокумент", ПолеТабличногоДокумента);
		СтруктураШаблона.Свойство("КоличествоПоВертикали"    , КоличествоПоВертикали);
		СтруктураШаблона.Свойство("КоличествоПоГоризонтали"  , КоличествоПоГоризонтали);
		СтруктураШаблона.Свойство("ТипКода"                  , ТипКода);
		СтруктураШаблона.Свойство("РазмерШрифта"             , РазмерШрифта);
		СтруктураШаблона.Свойство("ОтображатьТекст"          , ОтображатьТекст);
	Иначе
		// Создание нового шаблона.
		ПолеТабличногоДокумента = Новый ТабличныйДокумент;
		ПолеТабличногоДокумента.ОбластьПечати = ПолеТабличногоДокумента.Область("R2C2:R20C5");
		РедкийПунктир = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.РедкийПунктир, 1);
		ПолеТабличногоДокумента.ОбластьПечати.Обвести(РедкийПунктир,РедкийПунктир,РедкийПунктир,РедкийПунктир);
		КоличествоПоГоризонтали = 1;
		КоличествоПоВертикали   = 1;
		ТипКода                 = 1; // EAN-13
		ОтображатьТекст         = Истина;
		РазмерШрифта            = 12;
	КонецЕсли;
	
	Элементы.РазмерШрифта.Доступность = ОтображатьТекст;
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура
//
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ПроверитьУмещение() Тогда
		Отказ = Истина;
	Иначе
		ТекущийОбъект.Шаблон = Новый ХранилищеЗначения(ПодготовитьСтруктуруМакетаШаблона());
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписьюНаСервере()

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ

// Функция получение параметров из строки-шаблона табличного документа.
//
&НаСервере
Функция ПолучитьПозицииПараметров(ТекстЯчейки)
	
	Массив = Новый Массив;
	
	Начало = -1;
	Конец  = -1;
	СчетчикСкобокОткрывающих = 0;
	СчетчикСкобокЗакрывающих = 0;
	
	Для Индекс = 1 По СтрДлина(ТекстЯчейки) Цикл
		Симв = Сред(ТекстЯчейки, Индекс, 1);
		Если Симв = "[" Тогда
			СчетчикСкобокОткрывающих = СчетчикСкобокОткрывающих + 1;
			Если СчетчикСкобокОткрывающих = 1 Тогда
				Начало = Индекс;
			КонецЕсли;
		ИначеЕсли Симв = "]" Тогда
			СчетчикСкобокЗакрывающих = СчетчикСкобокЗакрывающих + 1;
			Если СчетчикСкобокЗакрывающих = СчетчикСкобокОткрывающих Тогда
				Конец = Индекс;
				
				Массив.Добавить(Новый Структура("Начало, Конец", Начало, Конец));
				
				Начало = -1;
				Конец  = -1;
				СчетчикСкобокОткрывающих = 0;
				СчетчикСкобокЗакрывающих = 0;
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции // ПолучитьПозицииПараметров()

// Функция возвращает структуру макета шаблона ценников и этикеток.
//
&НаСервере
Функция ПодготовитьСтруктуруМакетаШаблона()
	
	СтруктураМакетаШаблона = Новый Структура;
	ПараметрыШаблона       = Новый Соответствие;
	СчетчикПараметров      = 0;
	ПрефиксИмениПараметра  = "ПараметрМакета";
	
	ОбластьМакетаЭтикетки = ПолеТабличногоДокумента.ПолучитьОбласть();
	
	// Копирование настроек табличного документа.
	ЗаполнитьЗначенияСвойств(ОбластьМакетаЭтикетки, ПолеТабличногоДокумента);
	
	Для НомерКолонки = 1 По ОбластьМакетаЭтикетки.ШиринаТаблицы Цикл
		
		Для НомерСтроки = 1 По ОбластьМакетаЭтикетки.ВысотаТаблицы Цикл
			
			Ячейка = ОбластьМакетаЭтикетки.Область(НомерСтроки, НомерКолонки);
			Если Ячейка.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Шаблон Тогда
				
				МассивПараметров = ПолучитьПозицииПараметров(Ячейка.Текст);
				
				КоличествоПараметров = МассивПараметров.Количество();
				Для Индекс = 0 По КоличествоПараметров - 1 Цикл
					
					Структура = МассивПараметров[КоличествоПараметров - 1 - Индекс];
					
					ИмяПараметра = Сред(Ячейка.Текст, Структура.Начало + 1, Структура.Конец - Структура.Начало - 1);
					Если Найти(ИмяПараметра, ПрефиксИмениПараметра) = 0 Тогда
						
						ЛеваяЧасть = Лев(Ячейка.Текст, Структура.Начало);
						ПраваяЧасть = Прав(Ячейка.Текст, СтрДлина(Ячейка.Текст) - Структура.Конец+1);
						
						СохраненноеИмяПараметраМакета = ПараметрыШаблона.Получить(ИмяПараметра);
						Если СохраненноеИмяПараметраМакета = Неопределено Тогда
							СчетчикПараметров = СчетчикПараметров + 1;
							Ячейка.Текст = ЛеваяЧасть + (ПрефиксИмениПараметра + СчетчикПараметров) + ПраваяЧасть;
							ПараметрыШаблона.Вставить(ИмяПараметра, ПрефиксИмениПараметра + СчетчикПараметров);
						Иначе
							Ячейка.Текст = ЛеваяЧасть + (СохраненноеИмяПараметраМакета) + ПраваяЧасть;
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			ИначеЕсли Ячейка.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Параметр Тогда
				
				Если Найти(Ячейка.Параметр, ПрефиксИмениПараметра) = 0 Тогда
					СохраненноеИмяПараметраМакета = ПараметрыШаблона.Получить(Ячейка.Параметр);
					Если СохраненноеИмяПараметраМакета = Неопределено Тогда
						СчетчикПараметров = СчетчикПараметров + 1;
						ПараметрыШаблона.Вставить(Ячейка.Параметр, ПрефиксИмениПараметра + СчетчикПараметров);
						Ячейка.Параметр = ПрефиксИмениПараметра + СчетчикПараметров;
					Иначе
						Ячейка.Параметр = СохраненноеИмяПараметраМакета;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Вставляем в параметры штрихкод
	Если ПараметрыШаблона.Получить(ПолучитьИмяПараметраШтрихкод()) = Неопределено Тогда
		Для Каждого Рисунок Из ОбластьМакетаЭтикетки.Рисунки Цикл
			Если Лев(Рисунок.Имя,8) = ПолучитьИмяПараметраШтрихкод() Тогда
				ПараметрыШаблона.Вставить(ПолучитьИмяПараметраШтрихкод(), ПрефиксИмениПараметра + (СчетчикПараметров+1));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Заменяем на пустую картинку.
	Для Каждого Рисунок Из ОбластьМакетаЭтикетки.Рисунки Цикл
		Если Лев(Рисунок.Имя,8) = ПолучитьИмяПараметраШтрихкод() Тогда
			Рисунок.Картинка = Новый Картинка;
		КонецЕсли;
	КонецЦикла;
	
	СтруктураМакетаШаблона.Вставить("МакетЭтикетки"              , ОбластьМакетаЭтикетки);
	СтруктураМакетаШаблона.Вставить("ИмяОбластиПечати"           , ПолеТабличногоДокумента.ОбластьПечати.Имя);
	СтруктураМакетаШаблона.Вставить("ТипКода"                    , ТипКода);
	СтруктураМакетаШаблона.Вставить("РазмерШрифта"               , РазмерШрифта);
	СтруктураМакетаШаблона.Вставить("ОтображатьТекст"            , ОтображатьТекст);
	СтруктураМакетаШаблона.Вставить("ПараметрыШаблона"           , ПараметрыШаблона);
	СтруктураМакетаШаблона.Вставить("РедакторТабличныйДокумент"  , ПолеТабличногоДокумента);
	СтруктураМакетаШаблона.Вставить("КоличествоПоВертикали"      , КоличествоПоВертикали);
	СтруктураМакетаШаблона.Вставить("КоличествоПоГоризонтали"    , КоличествоПоГоризонтали);
	
	Возврат СтруктураМакетаШаблона;
	
КонецФункции // ПодготовитьСтруктуруМакетаШаблона()

// Функция выполняет проверку умещения ценников и этикеток на листе с заданными
// параметрами.
&НаСервере
Функция ПроверитьУмещение()
	
	Ошибка = Ложь;
	
	ОбластьМакета = ПолеТабличногоДокумента.ПолучитьОбласть(ПолеТабличногоДокумента.ОбластьПечати.Имя);
	
	Если НЕ (ПолеТабличногоДокумента.ОбластьПечати.Лево = 0 И ПолеТабличногоДокумента.ОбластьПечати.Право = 0) Тогда
		
		МассивТаблиц = Новый Массив;
		Для Инд = 1 По КоличествоПоГоризонтали Цикл
			МассивТаблиц.Добавить(ОбластьМакета);
		КонецЦикла;
		
		Пока НЕ ПолеТабличногоДокумента.ПроверитьПрисоединение(МассивТаблиц) Цикл
			МассивТаблиц.Удалить(МассивТаблиц.Количество()-1);
		КонецЦикла;
		
		Если КоличествоПоГоризонтали <> МассивТаблиц.Количество() Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Максимальное количество по горизонтали:'") + " " + МассивТаблиц.Количество();
			Сообщение.Поле  = "КоличествоПоГоризонтали";
			Сообщение.Сообщить();
			
			Ошибка = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ (ПолеТабличногоДокумента.ОбластьПечати.Верх = 0 И ПолеТабличногоДокумента.ОбластьПечати.Низ = 0) Тогда
		
		МассивТаблиц = Новый Массив;
		Для Инд = 1 По КоличествоПоВертикали Цикл
			МассивТаблиц.Добавить(ОбластьМакета);
		КонецЦикла;
		
		Пока НЕ ПолеТабличногоДокумента.ПроверитьВывод(МассивТаблиц) Цикл
			МассивТаблиц.Удалить(МассивТаблиц.Количество()-1);
		КонецЦикла;
		
		Если КоличествоПоВертикали <> МассивТаблиц.Количество() Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Максимальное количество по вертикали:'") +" " + МассивТаблиц.Количество();
			Сообщение.Поле  = "КоличествоПоВертикали";
			Сообщение.Сообщить();
			
			Ошибка = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НЕ Ошибка;
	
КонецФункции // ПроверитьУмещение()

// Процедура устанавливает область печати в табличном документе и рисует по краю пунктирную рамку.
//
&НаСервере
Процедура УстановитьОбластьПечатиНаСервере(ИмяОбласти)
	
	ВыделеннаяОбласть = ПолеТабличногоДокумента.Область(ИмяОбласти);
	
	НетЛинии = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, 0);
	РедкийПунктир = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.РедкийПунктир, 1);
	
	Если ПолеТабличногоДокумента.ОбластьПечати <> Неопределено Тогда
		ПолеТабличногоДокумента.ОбластьПечати.Обвести(НетЛинии,НетЛинии,НетЛинии,НетЛинии);
	КонецЕсли;
	
	ПолеТабличногоДокумента.ОбластьПечати = ВыделеннаяОбласть;
	ПолеТабличногоДокумента.ОбластьПечати.Обвести(РедкийПунктир,РедкийПунктир,РедкийПунктир,РедкийПунктир);
	
	ПолеТабличногоДокумента.ОбластьПечати.АвтоВысотаСтроки = Ложь;
	
КонецПроцедуры // УстановитьОбластьПечати()

// Процедура устанавливает область печати в табличном документе и рисует по краю пунктирную рамку.
//
&НаКлиенте
Процедура УстановитьОбластьПечати(Команда)
	
	Если (ПолеТабличногоДокумента.ВыделенныеОбласти[0].Лево <> 0 И ПолеТабличногоДокумента.ВыделенныеОбласти[0].Верх <> 0)
		И ПолеТабличногоДокумента.ВыделенныеОбласти.Количество() = 1
		И ТипЗнч(ПолеТабличногоДокумента.ВыделенныеОбласти[0]) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		
		УстановитьОбластьПечатиНаСервере(ПолеТабличногоДокумента.ВыделенныеОбласти[0].Имя);
		
	Иначе
		
		ОчиститьСообщения();
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Некорректная область печати'");
		Сообщение.Поле = "ПолеТабличногоДокумента";
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьОбластьПечати()


// Процедура помещает в табличный документ рисунок штрихокода.
//
&НаСервере
Процедура ВставитьРисунокШтрихкода(ИмяТекущейОбласти)
	
	//получим рисунок штрихкода из дополнительного макета
	МакетШтрихкода = Новый Картинка(Справочники.ШаблоныЭтикетокИЦенников.ПолучитьМакет("КартинкаШтрихкода"));
	
	РисунокШтрихкода = ПолеТабличногоДокумента.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
	Индекс = ПолеТабличногоДокумента.Рисунки.Индекс(РисунокШтрихкода);
	ПолеТабличногоДокумента.Рисунки[Индекс].Картинка = МакетШтрихкода;
	ПолеТабличногоДокумента.Рисунки[Индекс].Имя = ПолучитьИмяПараметраШтрихкод()+СтрЗаменить(Новый УникальныйИдентификатор,"-","_");
	ПолеТабличногоДокумента.Рисунки[Индекс].Расположить(ПолеТабличногоДокумента.Область(ИмяТекущейОбласти));
	
КонецПроцедуры // ВставитьРисунокШтрихкода()

// Функция получает строку с именем параметра штрихкода для передачи в СКД.
//
&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИмяПараметраШтрихкод()
	
	Возврат "Штрихкод";
	
КонецФункции // ПолучитьИмяПараметраШтрихкод()


&НаСервере
// Процедура объединяет ячейки области
//
// Параметры
//  ИмяОбласти  - Строка - Имя области для объединения
//
Процедура ОбъединитьОбласть(ИмяОбласти)
	
	Область = ПолеТабличногоДокумента.Область(ИмяОбласти);
	Область.Объединить();
	
КонецПроцедуры // ОбъединитьОбласть()

&НаСервере
// Процедура разъедининяет ячейки области
//
// Параметры
//  ИмяОбласти  - Строка - Имя области для объединения
//
Процедура РазъединитьОбласть(ИмяОбласти)
	
	Область = ПолеТабличногоДокумента.Область(ИмяОбласти);
	Область.Разъединить();
	
КонецПроцедуры // ОбъединитьОбласть()

// Процедура осуществляет выбор доступного поля
//
// Параметры
//  Выбрать  - ИдентификаторКомпоновкиДанных - Идентификатор компоновки данных
//
&НаКлиенте
Процедура ВыборДоступногоПоля(ВыбраннаяСтрока)
	
	// Перед началом добавления необходимо выделить область в табличном документе.
	Если ТипЗнч(ПолеТабличногоДокумента.ТекущаяОбласть) <> Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		Предупреждение(НСтр("ru = 'Для переноса поля шаблона нужно выделить ячейку или область ячеек!'"));
		Возврат;
	Иначе
		ТекущаяОбласть = ПолеТабличногоДокумента.ТекущаяОбласть;
		//ТекущаяОбласть.Объединить();
		ОбъединитьОбласть(ТекущаяОбласть.Имя);
	КонецЕсли;

	// Подготовка данных.
	ИмяПоляВШаблоне = Строка(КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(ВыбраннаяСтрока).Поле);
	
	// Размещение поля в шаблоне.
	Если ИмяПоляВШаблоне = ПолучитьИмяПараметраШтрихкод() Тогда
		
		Ответ = Вопрос(НСтр("ru = 'Добавить штрихкод, как картинку?'"), РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			ВставитьРисунокШтрихкода(ТекущаяОбласть.Имя);
			
		Иначе
			
			ТекущаяОбласть.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Шаблон;
			ТекущаяОбласть.Текст = ТекущаяОбласть.Текст + "["+ИмяПоляВШаблоне+"]";
			
		КонецЕсли;
		
	Иначе
		
		ТекущаяОбласть.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Шаблон;
		ТекущаяОбласть.Текст = ТекущаяОбласть.Текст + "["+ИмяПоляВШаблоне+"]";
		
	КонецЕсли;
	
КонецПроцедуры // ВыборДоступногоПоля()

&НаКлиенте
// Процедура
//
Процедура ДоступныеПоляВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЭтаФорма.ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;

	Модифицированность = Истина;
	ВыборДоступногоПоля(ВыбраннаяСтрока);
	
КонецПроцедуры // ДоступныеПоляВыбор()

// Процедура помещает в табличный документ шаблон по умолчанию.
//
&НаСервере
Процедура ПоместитьВТабличныйДокументШаблонПоУмолчанию(ИмяШаблона)
	
	ШаблонПоУмолчанию = Справочники.ШаблоныЭтикетокИЦенников.ПолучитьМакет(ИмяШаблона);
	
	ПолеТабличногоДокумента = ШаблонПоУмолчанию;
	
КонецПроцедуры // ПоместитьВТабличныйДокументШаблонПоУмолчанию()

// Процедура - обработчик команды "ЭтикеткаПоУмолчанию".
//
&НаКлиенте
Процедура ЭтикеткаПоУмолчанию(Команда)
	
	Результат = Вопрос(НСтр("ru = 'Редактируемый шаблон будет заменен на шаблон по умолчанию, продолжить?'"), РежимДиалогаВопрос.ДаНет);
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПоместитьВТабличныйДокументШаблонПоУмолчанию("ШаблонЭтикеткиПоУмолчанию");
	КонецЕсли;
	
КонецПроцедуры // ЭтикеткаПоУмолчанию()

// Процедура - обработчик команды "ЦенникПоУмолчанию".
//
&НаКлиенте
Процедура ЦенникПоУмолчанию(Команда)
	
	Результат = Вопрос(НСтр("ru = 'Редактируемый шаблон будет заменен на шаблон по умолчанию, продолжить?'"), РежимДиалогаВопрос.ДаНет);
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПоместитьВТабличныйДокументШаблонПоУмолчанию("ШаблонЦенникаПоУмолчанию");
	КонецЕсли;
	
КонецПроцедуры // ЦенникПоУмолчанию()

// Процедура - обработчик команды "Объединить".
//
&НаКлиенте
Процедура Объединить(Команда)
	
	Если ПолеТабличногоДокумента.ВыделенныеОбласти.Количество() = 1
		И ТипЗнч(ПолеТабличногоДокумента.ВыделенныеОбласти[0]) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		
		ТекущаяОбласть = ПолеТабличногоДокумента.ТекущаяОбласть;
		ОбъединитьОбласть(ТекущаяОбласть.Имя);
		
	Иначе
		
		ОчиститьСообщения();
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Некорректная область!'");
		Сообщение.Поле = "ПолеТабличногоДокумента";
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры // Объединить()

// Процедура - обработчик команды "Разъединить".
//
&НаКлиенте
Процедура Разъединить(Команда)
	
	Если ПолеТабличногоДокумента.ВыделенныеОбласти.Количество() = 1
		И ТипЗнч(ПолеТабличногоДокумента.ВыделенныеОбласти[0]) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		
		ТекущаяОбласть = ПолеТабличногоДокумента.ТекущаяОбласть;
		РазъединитьОбласть(ТекущаяОбласть.Имя);
		
	Иначе
		
		ОчиститьСообщения();
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Некорректная область!'");
		Сообщение.Поле = "ПолеТабличногоДокумента";
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры // Разъединить()

// Процедура - обработчик команды "Выбрать".
//
&НаКлиенте
Процедура Выбрать(Команда)
	
	ТекущаяСтрока = Элементы.ДоступныеПоля.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ВыборДоступногоПоля(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры // Выбрать()

&НаКлиенте
Процедура ОтображатьТекстПриИзменении(Элемент)
	Элементы.РазмерШрифта.Доступность = ОтображатьТекст;
КонецПроцедуры
