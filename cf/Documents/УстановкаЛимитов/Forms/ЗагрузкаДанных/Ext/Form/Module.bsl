﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДВ = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДВ.Фильтр =  "Эксель (*.xls)|*.xls*";
	
	Если ДВ.Выбрать() Тогда
		
		ИмяФайла = ДВ.ПолноеИмяФайла;
		
	КонецЕсли;


КонецПроцедуры
&НаСервере
Функция НайтиНоменклатуру(Артикул, Количество, стрОшибки = "")
	
	Запрос = Новый Запрос("ВЫБРАТЬ Наименование, Ссылка ИЗ Справочник.ФизическиеЛица ГДЕ Наименование = &ПолеПоиска");
	Запрос.УстановитьПараметр("ПолеПоиска", Артикул);
	
	Попытка                      // мало ли что подусунули в артикул...
		Рез = Запрос.Выполнить();
	Исключение
		стрОшибки = ОписаниеОшибки();
		Возврат Неопределено;
	КонецПопытки;
	
	Если НЕ Рез.Пустой() Тогда
		
		Выборка = Рез.Выбрать();
		Если Выборка.Следующий() Тогда
			
			Возврат Новый Структура("Номенклатура", Выборка.Ссылка);
		КонецЕсли;
		
	КонецЕсли;
	
	стрОшибки = "Не найдено ни одного ответственного лица с наименованием " + Артикул;
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьДанные(Таблица, Эксель)
	
	стрОшибки = "";
	ЗагружатьКоличество = Истина;
	
	Лист = Эксель.Worksheets(1);
	КолВоСтрок = Лист.Cells(1,1).SpecialCells(11).Row;
	
	Для Сч = 2 По КолВоСтрок Цикл // первая строка - заголовок
		
		СтрокаАртикул = СокрЛП(Лист.Cells(Сч, КолонкаАртикул).Value);
		
		Если ПустаяСтрока(СтрокаАртикул) Тогда
			СписокСообщений.Добавить("Строка #" + Строка(Сч), "Строка #" + Строка(Сч) + ": Не указано наименование отв.лица. Выгрузка данных по этой строке не произведена");
            Продолжить;
		КонецЕсли;
		
		Если ЗагружатьКоличество Тогда
			Попытка 
				СтрокаКоличество = Число(СокрЛП(Лист.Cells(Сч, КолонкаКоличество).Value));
			Исключение
				СписокСообщений.Добавить("Строка #" + Строка(Сч), "Строка #" + Строка(Сч) + ": Колонка ""Лимит"" - Ошибка преобразования значения ячейки к числовому типу данных: " + СтрокаАртикул);
				Продолжить;
			КонецПопытки;
		КонецЕсли;
		
		Рез = НайтиНоменклатуру(СтрокаАртикул, СтрокаКоличество, стрОшибки);
		Если Рез = Неопределено Тогда
			СписокСообщений.Добавить("Строка #" + Строка(Сч), "Строка #" + Строка(Сч) + " :" + стрОшибки);
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Таблица.Добавить();
		НоваяСтрока.Инициатор= Рез.Номенклатура;
		Если ЗагружатьКоличество Тогда
			НоваяСтрока.Сумма	= СтрокаКоличество; КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуExcel(Таблица)
	
	Если ПустаяСтрока(ИмяФайла) Тогда
		ОбщиеФункции.СообщитьТекст("Не выбран файл", "ИмяФайла", ЭтаФорма);
		Возврат;
	КонецЕсли;
		
	// Получим эксель
	стрОшибки = "";	         
	Эксель = COMФункцииДиалогов.ОткрытьФайлЭкселя(ИмяФайла, стрОшибки);
	
	Если Эксель = Неопределено Тогда
		ОбщиеФункции.СообщитьТекст(стрОшибки);
		Возврат;
	КонецЕсли;
	                      
	ЗагрузитьДанные(Таблица, Эксель);
	
	COMФункцииДиалогов.ЗакрытьЭксель(Эксель);
	Сообщить("Данные загружены.");

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуТабличногоДокумента(Таблица)
	
	стрОшибки = "";
	ЗагружатьКоличество = Истина;
	Для Сч = 2 По КоличествоСтрок + 1 Цикл
		
		СтрокаАртикул = ТабличныйДокумент.Область("R"+Строка(Сч)+"C2").Текст;
		
		Если ПустаяСтрока(СтрокаАртикул) Тогда
			СписокСообщений.Добавить("Строка #" + Строка(Сч-1),"Строка #" + Строка(Сч-1) + ": Не указано наименование отв.лица. Выгрузка данных по этой строке не произведена");
			ТабличныйДокумент.Область("R"+Строка(Сч)+"C1").ЦветФона = WebЦвета.Красный;
			Продолжить;
		КонецЕсли;
		
		Если ЗагружатьКоличество Тогда
			
			Попытка 
				СтрокаКоличество = Число(ТабличныйДокумент.Область("R"+Строка(Сч)+"C3").Текст);
			Исключение
				СписокСообщений.Добавить("Строка #" + Строка(Сч-1), "Строка #" + Строка(Сч-1) + ": Колонка ""Лимит"" - Ошибка преобразования значения ячейки к числовому типу данных: " + СтрокаАртикул);
				ТабличныйДокумент.Область("R"+Строка(Сч)+"C3").ЦветФона = WebЦвета.Красный;
				Продолжить;
			КонецПопытки;
			
		КонецЕсли;
		    		
		Рез = НайтиНоменклатуру(СтрокаАртикул, СтрокаКоличество, стрОшибки);
		Если Рез = Неопределено Тогда
			СписокСообщений.Добавить("Строка #" + Строка(Сч-1), "Строка #" + Строка(Сч-1) + " :" + стрОшибки);
			ТабличныйДокумент.Область("R"+Строка(Сч)+"C2").ЦветФона = WebЦвета.Красный;
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Таблица.Добавить();
		НоваяСтрока.Инициатор= Рез.Номенклатура; 
		Если ЗагружатьКоличество Тогда НоваяСтрока.Сумма = СтрокаКоличество; КонецЕсли;
			
	КонецЦикла;	 
		 
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузку(Команда)
	
	СписокСообщений.Очистить();
		
	ЕстьКоличество = Истина;
	ТаблицаФормы = Вычислить("ВладелецФормы." + ИмяТаблицы);
	
	Если Элементы.ВводДанных.ТекущаяСтраница = Элементы.ДанныеExcel Тогда
		ВыполнитьЗагрузкуExcel(ТаблицаФормы);
	Иначе
		ВыполнитьЗагрузкуТабличногоДокумента(ТаблицаФормы);
	КонецЕсли;
	
	ВладелецФормы.Модифицированность = Истина;
	
	ОповеститьОВыборе("ВнешниеДанныеЗагружены");
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТоварыВХранилище() 
	
	//Возврат ПоместитьВоВременноеХранилище(
	//				Товары.Выгрузить(), 
	//				УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗакрыватьПриВыборе = Ложь;
	Элементы.ВводДанных.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	Если Параметры.Страница = "ЗагрузитьДанныеExcel" Тогда
		Элементы.ВводДанных.ТекущаяСтраница = Элементы.ДанныеExcel;
	Иначе
		Элементы.ВводДанных.ТекущаяСтраница = Элементы.ДанныеТабличногоДокумента;
	КонецЕсли;
	
	ЗадатьОбластьТабличногоДокумента();
	
	ИмяТаблицы = Параметры.ИмяТаблицы;
	ЕстьЦена = Ложь;
	
	ЗагрузитьКоличество = Параметры.ЗагружатьКоличество;
	
КонецПроцедуры
&НаСервере
Процедура ЗадатьОбластьТабличногоДокумента()
	
	ТабличныйДокумент.Очистить();
	Макет = Документы.УстановкаЛимитов.ПолучитьМакет("Excel");
	Область = Макет.ПолучитьОбласть("Заголовок|Основной");
	
	Область.Параметры.ПолеПоиска = "Наименование Отв.Лица";
	ТабличныйДокумент.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("Строки|Основной");
	Для Сч = 0 По КоличествоСтрок-1 Цикл
		Область.Параметры.Номер = Сч+1;
		ТабличныйДокумент.Вывести(Область);
	КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Процедура ЗадатьОбласть(Команда)
	
	ЗадатьОбластьТабличногоДокумента();
КонецПроцедуры
