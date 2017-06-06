﻿
&НаСервере
Процедура ЗагрузитьНаСервере(пАдресВХранилище)
	
	ДанныеЗагрузки = ЗагрузитьДанныеИзХранилища(пАдресВХранилище);
	Если ДанныеЗагрузки = Неопределено Тогда
		Сообщить("Ошибка загрузки данных из файла");
		Возврат;
	КонецЕсли;
	стрОшибки = "";
	
	ДанныеЗагрузки.Вставить("Склад", Склад);
	ДанныеЗагрузки.Вставить("Производитель", Производитель);
	
	Для каждого лСтрока Из ДанныеЗагрузки.МассивОстатков Цикл
		новСтрока = Отладка.Добавить();
		новСтрока.АртикулКод = лСтрока.АртикулКод;
		новСтрока.Остаток    = лСтрока.Остаток;
	КонецЦикла;
	//Возврат;
	
	НайтиИОпределитьТекущиеОстатки(ДанныеЗагрузки);
	
	Если ДанныеЗагрузки.Оприходование.Количество() Тогда
		новДок = Документы.ОприходованиеТоваров.СоздатьДокумент();
		новДок.Дата = ТекущаяДата();
		новДок.Склад = Склад;
		новДок.Комментарий = "Данные из файла " + ИмяФайла;
		
		Для каждого строкаОстатка Из ДанныеЗагрузки.Оприходование Цикл
			ЗаполнитьЗначенияСвойств(новДок.Товары.Добавить(), строкаОстатка);
		КонецЦикла;
		
		ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(новДок, , стрОшибки);
	КонецЕсли;
	
	Если ДанныеЗагрузки.Списание.Количество() Тогда
		новДок = Документы.СписаниеТоваров.СоздатьДокумент();
		новДок.Дата = ТекущаяДата();
		новДок.Склад = Склад;
		новДок.Комментарий = "Данные из файла " + ИмяФайла;
		
		Для каждого строкаОстатка Из ДанныеЗагрузки.Списание Цикл
			ЗаполнитьЗначенияСвойств(новДок.Товары.Добавить(), строкаОстатка);
		КонецЦикла;
		
		ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(новДок, , стрОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НайтиИОпределитьТекущиеОстатки(ДанныеЗагрузки, пАлгоритмЗагрузки = 0)
	ДанныеЗагрузки.Вставить("Оприходование", Новый Массив);
	ДанныеЗагрузки.Вставить("Списание", Новый Массив);
	ДанныеЗагрузки.Вставить("НеНайден", Новый Массив);
	
	// получаем массив артикулов
	массивАртикуловКодов = Новый массив;
	Для каждого лСтрока Из ДанныеЗагрузки.МассивОстатков Цикл
		массивАртикуловКодов.Добавить(лСтрока.АртикулКод);
	КонецЦикла;
	
Если ПолеПоиска = 0 Тогда 
    КлючевоеПоле = "Артикул";
ИначеЕсли ПолеПоиска = 1 Тогда
    КлючевоеПоле = "Код";
КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Спр.Ссылка,
	               |	ВЫРАЗИТЬ(Спр."+КлючевоеПоле+" + ""                         "" КАК СТРОКА(25)) КАК АртикулКод,
	               |	ЕСТЬNULL(Остатки.КоличествоОстаток, 0) КАК ТекущийОстаток,
	               |	Спр.Производитель
	               |ИЗ
	               |	Справочник.Номенклатура КАК Спр
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(, Склад = &Склад) КАК Остатки
	               |		ПО (Остатки.Номенклатура = Спр.Ссылка)
	               |ГДЕ
	               |	Спр."+КлючевоеПоле+" В(&массивАртикуловКодов)
	               |	И ВЫБОР
	               |			КОГДА &Производитель = &ПустойПроизводитель
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ Спр.Производитель = &Производитель
	               |		КОНЕЦ";
				   
				  		
	Запрос.УстановитьПараметр("массивАртикуловКодов", массивАртикуловКодов);
	Запрос.УстановитьПараметр("Склад", ДанныеЗагрузки.Склад);
	Запрос.УстановитьПараметр("Производитель", ДанныеЗагрузки.Производитель);
	Запрос.УстановитьПараметр("ПустойПроизводитель", Справочники.Производители.ПустаяСсылка());


	
	текОстатки = Запрос.Выполнить().Выгрузить();
	текОстатки.Индексы.Добавить("АртикулКод");
	текОстатки.Колонки.Добавить("Обработан"); текОстатки.ЗаполнитьЗначения(Ложь, "Обработан");
	
	Для каждого лСтрока Из ДанныеЗагрузки.МассивОстатков Цикл
		текОстаток = текОстатки.Найти(Лев(лСтрока.АртикулКод + "                         ",25), "АртикулКод");
		Если текОстаток = Неопределено Тогда
			ДанныеЗагрузки.НеНайден.Добавить(лСтрока.АртикулКод);
			Сообщить("! Артикул/Код: " + лСтрока.АртикулКод + " не найден по полям поиска или не соответствует отбору!" );
			Продолжить;
		КонецЕсли;
		
		Если лСтрока.Остаток > текОстаток.ТекущийОстаток Тогда
			ДанныеЗагрузки.Оприходование.Добавить(Новый Структура("Номенклатура, Количество", текОстаток.Ссылка, лСтрока.Остаток - текОстаток.ТекущийОстаток));
			Сообщить("+ " + лСтрока.АртикулКод);
		ИначеЕсли лСтрока.Остаток < текОстаток.ТекущийОстаток Тогда
			ДанныеЗагрузки.Списание.Добавить(Новый Структура("Номенклатура, Количество", текОстаток.Ссылка, текОстаток.ТекущийОстаток - лСтрока.Остаток));
			Сообщить("- " + лСтрока.АртикулКод);
		КонецЕсли;
		
		текОстаток.Обработан = Истина;
	КонецЦикла;
	
	//Если пАлгоритмЗагрузки = 3 Тогда // Не обнуляем текущие остатки
	//	Возврат Ложь;
	//КонецЕсли;
	Для каждого текОстаток Из текОстатки Цикл
		Если текОстаток.Обработан Тогда
			Продолжить;
		КонецЕсли;
		
		//ДанныеЗагрузки.Списание.Добавить(Новый Структура("Номенклатура, Количество", текОстаток.Ссылка, текОстаток.ТекущийОстаток));
		Сообщить("Ошибка! Проверьте Артикул/Код: "+  текОстаток.АртикулКод);
	КонецЦикла;
	
КонецФункции // НайтиИОпределитьТекущиеОстатки()

&НаСервере
Функция ЗагрузитьДанныеИзХранилища(пАдресВХранилище)
	
	ДанныеЗагрузки = Новый Структура("МассивОстатков", Новый Массив);
	дд = ПолучитьИзВременногоХранилища(пАдресВХранилище);
		
	лИмяФайла = ПолучитьИмяВременногоФайла();
	дд.Записать(лИмяФайла);
		
	текстДок = Новый ТекстовыйДокумент();
	текстДок.Прочитать(лИмяФайла, тКодировкаТекста);
	данныеТекст = текстДок.ПолучитьТекст();
		
	УдалитьФайлы(лИмяФайла);
		
	Для сч = 1 По СтрЧислоСтрок(данныеТекст) Цикл
		
		текСтрока = СтрПолучитьСтроку(данныеТекст, сч);
		СтрПодстр = СтрЗаменить(СокрЛП(текСтрока), РазделительСтрок, Символы.ПС);
		
		стрАртикулКод 		= СокрлП(СтрПолучитьСтроку(СтрПодстр, ПозАртикулКод));
		
		стрКоличество 	= СокрлП(СтрЗаменить(СтрПолучитьСтроку(СтрПодстр, ПозКоличество)," ",""));
		Попытка		Количество =  Число(стрКоличество)
		Исключение	Количество = 0; КонецПопытки;
		
		Если стрАртикулКод <> ""  Тогда
			ДанныеЗагрузки.МассивОстатков.Добавить(Новый Структура("АртикулКод, Остаток", стрАртикулКод, Количество)); КонецЕсли; КонецЦикла;
	 	
	Возврат ДанныеЗагрузки;
	
КонецФункции

&НаКлиенте
Процедура Загрузить(Команда)
	АдресВХранилище = "";
	ПоместитьФайл(АдресВХранилище, ИмяФайла, , Ложь);
	ЗагрузитьНаСервере(АдресВХранилище);
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	Если Диалог.Выбрать() Тогда
		ИмяФайла = Диалог.ПолноеИмяФайла;
	КонецЕСли;
КонецПроцедуры
