﻿
Процедура ВывестиЛист(	ТабДок, 
						ОбластьСтрок,
						ОбластьПустаяСтрока,
						ОбластьШапка1, 
						ОбластьШапка2, 
						ОбластьПодвал1, 
						ОбластьПодвал2,
						НомНачалаПустойСтроки, 
						НомОкончанияПустойСтроки)
						
	//Для Номер = ЧислоСтрокНаЛисте - КоличествоПустыхСтрок + 1 По ЧислоСтрокНаЛисте Цикл
	
	ОбластьЧистыхСтрок = Новый ТабличныйДокумент;
	
	Для Номер = НомНачалаПустойСтроки По НомОкончанияПустойСтроки Цикл
		
		ОбластьПустаяСтрока.Параметры.Номер = Номер;
		ОбластьЧистыхСтрок.Вывести(ОбластьПустаяСтрока);
		
	КонецЦикла;
	
	ТабДок.Вывести(ОбластьШапка1);
	ТабДок.Вывести(ОбластьСтрок);
	ТабДок.Вывести(ОбластьЧистыхСтрок);
	ТабДок.Вывести(ОбластьПодвал1);
	
	ТабДок.Вывести(ОбластьШапка2);
	ТабДок.Вывести(ОбластьСтрок);
	ТабДок.Вывести(ОбластьЧистыхСтрок);
	ТабДок.Вывести(ОбластьПодвал2);
	
КонецПроцедуры

Процедура ПечатьБланкЗаявки(ТабДок, Ссылка, ОперативныеДанные = Неопределено) Экспорт
	
	ЧислоСтрокНаЛисте = 5;
	
	Если ОперативныеДанные = Неопределено Тогда
		ОперативныеДанные = Новый Структура;
	КонецЕсли;
	
	Макет = БизнесПроцессы.РемонтИнструмента.ПолучитьМакет("Заявка");
	
	ОбластьШапка1 		= Макет.ПолучитьОбласть("Шапка1");
	ОбластьШапка2 		= Макет.ПолучитьОбласть("Шапка2");
	ОбластьСтрока 		= Макет.ПолучитьОбласть("Строка");
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	ОбластьПодвал1 		= Макет.ПолучитьОбласть("Подвал1");
	ОбластьПодвал2 		= Макет.ПолучитьОбласть("Подвал2");
	
	// Данные
	
	Запрос 	= Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Дата,
	|	Номер,
	|	Контрагент,
	|	Товары.(
	|		Номенклатура,
	|		Номенклатура.Артикул КАК Артикул,
	|		Номенклатура.Производитель КАК Производитель,
	|		Неисправность,
	|		Гарантия,
	|		Количество,
	|		ВЫБОР КОГДА ЕСТЬNULL(Номенклатура.Производитель.ЦенаЗаЧас,0) = 0 ТОГДА """" ИНАЧЕ Номенклатура.Производитель.ЦенаЗаЧас / 1000 КОНЕЦ КАК Коэффициент
	|	) КАК Товары
	|ИЗ
	|	БизнесПроцесс.РемонтИнструмента
	|ГДЕ
	|	Ссылка = &Ссылка
	|";
	
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		// Заполним шапку
		
		Контрагент = Справочники.Контрагенты.ПустаяСсылка();
	
		Если ОперативныеДанные.Свойство("Контрагент") Тогда
			Контрагент = ОперативныеДанные.Контрагент;
		КонецЕсли;
	
		ОбластьШапка1.Параметры.Заполнить(Выборка);
		ОбластьШапка2.Параметры.Заполнить(Выборка);
	
		ОбластьШапка1.Параметры.Контрагент 			= Контрагент;
		ОбластьШапка1.Параметры.ДоверенноеЛицоПартнера = Ссылка.ДоверенноеЛицо;
		ОбластьШапка1.Параметры.ТелефонПартнера		= Ссылка.Контакты;
		

		
		// Нанем таблицу
		
		ОбластьСтрок 	= Новый ТабличныйДокумент;
		ВыводЛиста 		= Ложь;
		ВыборкаСтрок 	= Выборка.Товары.Выбрать();
		НомСтроки 		= 1;
		
		Пока ВыборкаСтрок.Следующий() Цикл
			
			// Заполним строку
			
			ОбластьСтрока.Параметры.Заполнить(ВыборкаСтрок);
			ОбластьСтрока.Параметры.Номер = НомСтроки;
			ОбластьСтрок.Вывести(ОбластьСтрока);
			
			// Опредлимся кого выводить а кого нет
			                                
			ВыводЛиста = Не НомСтроки % ЧислоСтрокНаЛисте;
			
			// Вывод шапки
			
			Если ВыводЛиста Тогда
				
				// Выведем
				
				ВывестиЛист(	ТабДок, 
								ОбластьСтрок, 
								ОбластьПустаяСтрока, 
								ОбластьШапка1, 
								ОбластьШапка2, 
								ОбластьПодвал1, 
								ОбластьПодвал2,
								1, 
								0);
								
				// сбросим параметры для следующего листа
			
				ОбластьСтрок.Очистить();
				
			КонецЕсли;
			
			НомСтроки = НомСтроки + 1;
			
		КонецЦикла;
		
		// Выведем если еще не выведено
		
		Если Не ВыводЛиста Тогда
		
			ВывестиЛист(	ТабДок, 
								ОбластьСтрок, 
								ОбластьПустаяСтрока, 
								ОбластьШапка1, 
								ОбластьШапка2, 
								ОбластьПодвал1, 
								ОбластьПодвал2,
								НомСтроки, 
								Цел(НомСтроки / ЧислоСтрокНаЛисте) * ЧислоСтрокНаЛисте + ЧислоСтрокНаЛисте);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

Процедура Печать_ЗаявкаНаРемонт(ТабДок, Ссылка) Экспорт
	
	Макет = БизнесПроцессы.РемонтИнструмента.ПолучитьМакет("ЗаявкаНаРемонт");
		
	// Запрос
	
	Запрос 	= Новый Запрос("
	|ВЫБРАТЬ
	|	Номер,
	|	Контрагент КАК Заказчик,
	|	Контрагент,
	|	Дата 				КАК Дата,
	|	Номер				КАК Номер,
	|	ДоверенноеЛицо 		КАК ДоверенноеЛицо,
	|	Контакты			КАК Телефон,
	|   ВЫБОР КОГДА ВариантПроведенияДополнительныхРабот = 0 ТОГДА ""■"" ИНАЧЕ ""□"" КОНЕЦ ДР0,
	|   ВЫБОР КОГДА ВариантПроведенияДополнительныхРабот = 1 ТОГДА ""■"" ИНАЧЕ ""□"" КОНЕЦ ДР1,
	|   ВЫБОР КОГДА ВариантПроведенияДополнительныхРабот = 2 ТОГДА ""■"" ИНАЧЕ ""□"" КОНЕЦ ДР2,
	|	ВЫБОР КОГДА Расчет = ЗНАЧЕНИЕ(Перечисление.ВидыРасчета.Наличный) ТОГДА ""■"" ИНАЧЕ ""□"" КОНЕЦ ВО0,
	|	ВЫБОР КОГДА Расчет = ЗНАЧЕНИЕ(Перечисление.ВидыРасчета.Безналичный) ТОГДА ""■"" ИНАЧЕ ""□"" КОНЕЦ ВО1,
	|	ЧисткаГрязногоИнструмента 		КАК Чистка,
	|   Организация.Наименование 		КАК НаименованиеОрганизации,
	|	Товары.(
	|		НомерСтроки,
	|		Номенклатура 				КАК Номенклатура,
	|		Номенклатура.Артикул 		КАК Артикул,
	|		Количество,
	|		Неисправность.Наименование 	КАК Неисправность
	|	)
	|ИЗ
	|	БизнесПроцесс.РемонтИнструмента
	|ГДЕ
	|	Ссылка = &Ссылка
	|");
	
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Определим облости
	
	Если Выборка.Следующий() Тогда
		
		// Шапка
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
		
		ОбластьШапка.Параметры.Заполнить(Выборка);
		
		ОбластьШапка.Параметры.НомерЗаявки = ФормированиеПечатныхФорм.ПолучитьНомерНаПечать(Выборка.Номер);
		ОбластьШапка.Параметры.ДатаОбращения = Формат(Выборка.Дата, "ДЛФ=DD");
		//ОбластьШапка.Параметры.Телефон 	= ФормированиеПечатныхФорм.ПолучитьТелефонИзКонтактнойИнформации(Ссылка.Контрагент);
		ОбластьШапка.Параметры.Адрес 	= ФормированиеПечатныхФорм.ПолучитьАдресИзКонтактнойИнформации(Ссылка.Контрагент, "Юридический");
	
		ТабДок.Вывести(ОбластьШапка);
		
		ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабДок.Вывести(ОбластьШапкаТаблицы);
		
		ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаТаблицы");
		// Товары
		
		ТаблицаТоваров = Выборка.Товары.Выгрузить();
		
		Для Каждого СтрокаТаблицы ИЗ ТаблицаТоваров Цикл 
			
			ОбластьСтрока.Параметры.Заполнить(СтрокаТаблицы);
			ТабДок.Вывести(ОбластьСтрока);
			
		КонецЦикла;
		
		ТабДок.НижнийКолонтитул.Выводить = истина;
		ТабДок.НижнийКолонтитул.ТекстСправа = "Страница [&НомерСтраницы] из [&СтраницВсего]";

		// Если до конца страницы не выйдет то выведем на новой
		ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		ОбластьПодвал.Параметры.Заполнить(Выборка);
		
		Если не ТабДок.ПроверитьВывод(ОбластьПодвал) Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ТабДок.Вывести(ОбластьПодвал);
		
	КонецЕсли;
	
КонецПроцедуры


// СТАНДАРТНЫЙ ИНТЕРФЕЙС

Процедура ЗаполнитьФормуПоБП(ФормаЗадачи, БизнесПроцесс, СсылкаЗадача) Экспорт
	
	ТоварыИзЗаказа = НЕ БизнесПроцесс.ЗаказНаряд.Пустая(); 
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ 	
	|	ЗаказНаряд,
	|	Организация,
	|	Контрагент,
	|	Склад,
	|	СкладПолучатель,
	|	ЗаменныйИнструмент,
	|	Менеджер,
	|	ОтветМенеджера ОтветМенеджераЧисло,
	|	ВЫБОР 	КОГДА ОтветМенеджера = 0 ТОГДА ""Менеджер пока не дал ответа"" 
	|	 		КОГДА ОтветМенеджера = 1 ТОГДА ""Необходимо ждать оплату"" 
	|			КОГДА ОтветМенеджера = 2 ТОГДА ""Отсрочка платежа"" 
	|	КОНЕЦ ОтветМенеджера,
	|	ЧисткаГрязногоИнструмента, 
	|	ДоверенноеЛицо,
	|" + ?(ТоварыИзЗаказа, "
	|	ЕСТЬNULL(СуммаРабот, 0) + ЕСТЬNULL(СуммаЗапчастей,0) 	ВсегоПоЗаказу,
	|	СуммаРабот,
	|	СуммаЗапчастей,
	|	ЗаказНаряд.Скидка 		СуммаГарантии,
	|	ЗаказНаряд.Запчасти 	ЗапчастиЗапроса,
	|	ЗаказНаряд.Работы		РаботыЗапроса
	|
	|ИЗ
	|	БизнесПроцесс.РемонтИнструмента КАК Процесс
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	(
	|		ВЫБРАТЬ СУММА(Раб.Сумма) КАК СуммаРабот 
	|		ИЗ 		Документ.ЗаказНаряд.Работы КАК Раб
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ 	
	|			(ВЫБРАТЬ НомерСтроки - 1 КАК ИндексСтроки ИЗ Документ.ЗаказНаряд.Товары ГДЕ Ссылка = &СсылкаЗаказ И Гарантия = ЛОЖЬ) КАК Тов
	|		ПО 	
	|			Раб.ИндексСтрокиНоменклатуры = Тов.ИндексСтроки
	|
	|		ГДЕ Раб.Ссылка = &СсылкаЗаказ
	|
	|	) КАК Работы
	|ПО
	|	ИСТИНА
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	(
	|		ВЫБРАТЬ СУММА(Зап.Сумма) КАК СуммаЗапчастей 
	|		ИЗ 		Документ.ЗаказНаряд.Запчасти КАК Зап
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ 	
	|			(ВЫБРАТЬ НомерСтроки - 1 КАК ИндексСтроки ИЗ Документ.ЗаказНаряд.Товары ГДЕ Ссылка = &СсылкаЗаказ И Гарантия = ЛОЖЬ) КАК Тов
	|		ПО 	
	|			Зап.ИндексСтрокиНоменклатуры = Тов.ИндексСтроки
	|
	|		ГДЕ Зап.Ссылка = &СсылкаЗаказ
	|
	|	) КАК Запчасти
	|ПО
	|	ИСТИНА
	|
	|ГДЕ
	|	Ссылка = &Ссылка
	|;
	|	ВЫБРАТЬ *, ИСТИНА Отметка, Сумма НоваяСумма, СуммаАвтоматическойСкидки НоваяСуммаСкидки ИЗ Документ.ЗаказНаряд.Товары ГДЕ	Ссылка = &СсылкаЗаказ

	|","
	|
	|	0 КАК ВсегоПоЗаказу,
	|	0 КАК СуммаРабот,
	|	0 КАК СуммаЗапчастей,
	|	0 КАК СуммаГарантии
	|ИЗ
	|	БизнесПроцесс.РемонтИнструмента КАК Процесс
	|ГДЕ
	|	Ссылка = &Ссылка 
	|;
	|	ВЫБРАТЬ *, ЛОЖЬ Отметка, 0 НоваяСумма, 0 НоваяСуммаСкидки ИЗ БизнесПроцесс.РемонтИнструмента.Товары ГДЕ	Ссылка = &Ссылка
	|"));
	
	
	Запрос.УстановитьПараметр("ДатаТекЗадачи", 		?(СсылкаЗадача.Дата = '00010101', ТекущаяДата(), СсылкаЗадача.Дата));
	Запрос.УстановитьПараметр("Ссылка", 			БизнесПроцесс);
	Запрос.УстановитьПараметр("СсылкаЗаказ", 		БизнесПроцесс.ЗаказНаряд);
	
	// Заполним шапку
	
	Результат = Запрос.ВыполнитьПакет();
	Выборка = Результат[0].Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ФормаЗадачи, Выборка);
	
	ТоварыЗапроса = Результат[1].Выгрузить();
	
	// Заполним таблицу
		
	ФормаЗадачи.Товары.Загрузить(ТоварыЗапроса);
	Если НЕ БизнесПроцесс.ЗаказНаряд.Пустая() Тогда
		
		Если ФормаЗадачи.Элементы.Найти("Запчасти") <> Неопределено Тогда
		     ФормаЗадачи.ЗапчастиЗаказа.Загрузить(Выборка.ЗапчастиЗапроса.Выгрузить());
		КонецЕсли;
		
		Если ФормаЗадачи.Элементы.Найти("Работы") <> Неопределено Тогда
        	ФормаЗадачи.РаботыЗаказа.Загрузить(Выборка.РаботыЗапроса.Выгрузить());
		КонецЕсли;
		
		//ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(БизнесПроцесс, БизнесПроцессы.РемонтИнструмента.ТочкиМаршрута.ПроизвестиДефектовку) Тогда	
	КонецЕсли;
	
	Если ФормаЗадачи.Элементы.Найти("ИтогоHTML") <> Неопределено Тогда
		ФормаЗадачи.ИтогоHTML = СформироватьИтоговуюНадпись(Выборка.ВсегоПоЗаказу, Выборка.СуммаГарантии, Выборка.СуммаРабот, Выборка.СуммаЗапчастей)
	КонецЕсли;

	//КонецЕсли;
	
КонецПроцедуры

Функция СформироватьИтоговуюНадпись(Всего, Гарантия, Работы = 0 , Запчасти = 0)  Экспорт
	
	Кратко = Работы = 0 И Запчасти = 0;
	
	Возврат "
		|<HTML><HEAD>
		|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
		|<META name=GENERATOR content=""MSHTML 8.00.7600.16588"">
		|<style>* {margin: 0;padding: 0;}</style>
		|</HEAD>
		|<body bgcolor=""#FCFAEB""> Всего <B>" + Строка(Всего) + "</B>" + ?(Кратко, "", "<small>(работ <B>" + Строка(Работы) + "</B>запчастей <B>" + Строка(Запчасти) + "</B></small>)") + " Гарантия <B>" + Строка(Гарантия) + "</B>
		|</BODY></HTML>"; 

КонецФункции


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
	|		БизнесПроцесс = &Ссылка 
	
		// коменты из документа Заказ
	
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Комментарий, ""Заказ-Наряд"", Дата, Ответственный
	|	ИЗ
	|		Документ.ЗаказНаряд
	|	ГДЕ
	|		Ссылка = &Заказ
	|
	
		// коменты БП
	
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Комментарий, ""Ремонт-инструмента"", Дата, ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	ИЗ
	|		БизнесПроцесс.РемонтИнструмента
	|	ГДЕ
	|		Ссылка = &Ссылка
    |
	|) Запрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаВыполнения
	|");
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаПроцесс);
	Запрос.УстановитьПараметр("Заказ", 	СсылкаПроцесс.ЗаказНаряд);

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ПустаяСтрока(Выборка.Комментарий) Тогда
		
			Массив.Добавить(Новый Структура("Комментарий, Заголовок, ДатаВыполнения, Исполнитель",
									Выборка.Комментарий, Выборка.Заголовок, Выборка.ДатаВыполнения, Выборка.Исполнитель));
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции


Функция ПолучитьТаблицуТоваров(СсылкаПроцесс, СсылкаЗадача)
	
	Запрос = Новый Запрос ("
	|ВЫБРАТЬ
	|	Номенклатура,
	|	Неисправность,
	|	Гарантия,
	|	КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ЗаказНаряды.Остатки(&Дата)");
	
	
КонецФункции