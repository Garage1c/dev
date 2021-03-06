﻿///////////////////// На клиенте /////////////////////
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьНачальныеНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНачальныеНастройки()
	
	// Устанавливаем номера колонок по умолчанию
	Объект.Номенклатура	= 1;
	Объект.Поставщик	= 2;
	Объект.Матрица		= 3;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИзExcel(Команда)
	
	Если ЗначениеЗаполнено(Объект.Файл) Тогда
		Если ПроверитьЗаполненияНомеровКолонок() Тогда
			ЗагрузитьИзФайла();
			Если Объект.ТаблицаФайла.Количество() > 0 Тогда
				Состояние("Данные загружены!");
			Иначе
				Состояние("Нет данных для загрузки!");
			КонецЕсли;
		Иначе
			Возврат;
		КонецЕсли;
	Иначе
		ОбщегоНазначения.СообщитьОбОшибке("Не выбран файл!", ,);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполненияНомеровКолонок()
	
	Проверка = Истина;
	
	Если НЕ ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан номер колонки номенклатуры!", ,);
		Проверка = Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Поставщик) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан номер колонки поставщика!", ,);
		Проверка = Ложь;
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(Объект.Матрица) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан номер колонки матрицы!", ,);
		Проверка = Ложь;
	КонецЕсли;
		
	Возврат Проверка;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьФайл(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогФыбораФайла					= Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогФыбораФайла.Фильтр			= "Файл данных (*.xls, *.xlsx)|*.xls; *.xlsx";
	ДиалогФыбораФайла.Заголовок			= "Выберите файл";
	
	Если ДиалогФыбораФайла.Выбрать() Тогда
		Объект.Файл = ДиалогФыбораФайла.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДанные(Команда)
	
	Если Объект.ТаблицаФайла.Количество() > 0 Тогда
		
		ЗаписатьДанныеНаСервере();
	
		ПоказатьПредупреждение(, "Данные записаны!");
		
	Иначе
		
		ПоказатьПредупреждение(, "Данные файла отсутствуют!");
		
	КонецЕсли;
	
КонецПроцедуры

///////////////////// На сервере /////////////////////
&НаСервере
Процедура ЗагрузитьИзФайла()
	
	КомОбЭксел = Новый COMОбъект("Excel.Application");
	
	НомерЛиста = 1;
	ТекСтрока = 2;
	
	Попытка
		Book = КомОбЭксел.WorkBooks.Open(Объект.Файл);
		ТекЛист = Book.WorkSheets(НомерЛиста);
	Исключение
		Возврат;
	КонецПопытки;
	
	Объект.ТаблицаФайла.Очистить();
	
	Пока НЕ ПустаяСтрока(СокрЛП(ТекЛист.Cells(ТекСтрока, Объект.ТипОбработки).Value)) Цикл
		 
		НаимНоменклатура = Формат(ТекЛист.Cells(ТекСтрока, Объект.Номенклатура).Value, "ЧГ=0"); 
		НаимПоставщика = Формат(ТекЛист.Cells(ТекСтрока, Объект.Поставщик).Value, "ЧГ=0");
		ЗначМатрица = Формат(ТекЛист.Cells(ТекСтрока, Объект.Матрица).Value, "ЧГ=0"); 
		
		Если ЗначениеЗаполнено(НаимНоменклатура) Тогда
			
			НоваяСтрока = Объект.ТаблицаФайла.Добавить();
			НоваяСтрока.Номенклатура	= Справочники.Номенклатура.НайтиПоНаименованию(НаимНоменклатура);
			НоваяСтрока.Поставщик		= Справочники.Контрагенты.НайтиПоНаименованию(НаимПоставщика);
			НоваяСтрока.Матрица			= ЗначМатрица;
			
		КонецЕсли;
		
		ТекСтрока = ТекСтрока + 1;
		
	КонецЦикла;
	
	Book.Close(0);
	КомОбЭксел.Quit();
	КомОбЭксел = Неопределено;
		
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеНаСервере()
	
	НабЗап = РегистрыСведений.АссортиментаяМатрица.СоздатьНаборЗаписей();
	НабЗап.Записать();
	
	Для Каждого Стр из Объект.ТаблицаФайла Цикл
		
		Зап = НабЗап.Добавить();
		ЗаполнитьЗначенияСвойств(Зап, Стр);
		
		Зап.Автор = ПараметрыСеанса.ТекущийПользователь;
		Зап.ДатаЗаписи = ТекущаяДата();
		
	КонецЦикла;
	
	НабЗап.Записать();	
	
КонецПроцедуры
