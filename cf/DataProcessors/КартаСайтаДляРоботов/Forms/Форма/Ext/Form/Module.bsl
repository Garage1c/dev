﻿
&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДВ = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДВ.Фильтр = "Файл XML (*.xml)|*.xml";
	
	Если Дв.Выбрать() Тогда
		
		Объект.ИмяФайла = ДВ.ПолноеИмяФайла;
		
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция КоличествоИдТоваров()
	
	Возврат Константы.МаксимальныйПорядковыйНомер.Получить();
	
КонецФункции
&НаСервере
Функция ПолучитьАлиесТовара(НомТовара)
	
	Запрос = Новый Запрос("ВЫБРАТЬ alies ИЗ Справочник.Номенклатура ГДЕ alies <> """" И ПорядковыйНомер = " + Формат(НомТовара,"ЧГ="));
	
	Выполнение = Запрос.Выполнить();
	
	Если Выполнение.Пустой() Тогда
		
		Возврат "";
		
	Иначе
		
		Выборка = Выполнение.Выбрать();
		Возврат Выборка.alies;
		
	КонецЕсли;
	
КонецФункции
&НаСервере
Функция ПолучитьАлиесыТоваров(НачНомер, КОнНомер)
	
	Таблица.Очистить();
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ 
		|	РАЗЛИЧНЫЕ alies КАК loc, 0 КАК lastmod 
		|ИЗ 
		|	Справочник.Номенклатура 
		|ГДЕ
		|	alies <> """" И
		|	ВыгружатьНаСайт = ИСТИНА И 
		|	ПорядковыйНомер >= " + Формат(НачНомер,"ЧГ=") + " И 
		|	ПорядковыйНомер <= " + Формат(КОнНомер,"ЧГ="));
		
	// подготовим таблицу
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НовСтрока = Таблица.Добавить();
		НовСтрока.loc 		= НРег(Выборка.loc);
		НовСтрока.lastmod 	= XMLСтрока(ТекущаяДата());
      	
	КонецЦикла;
	
	Возврат Истина;
		
КонецФункции
&НаСервере
Функция ПолучитьАлиесыСтаей()
	
	Таблица.Очистить();
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ Ссылка ПОМЕСТИТЬ ГруппыНовостей ИЗ Справочник.ИнтернетСтатьи ГДЕ ЭтоГруппа = Истина И ЭтоНовости = Истина;
		|ВЫБРАТЬ 
		|	РАЗЛИЧНЫЕ Наименование КАК loc, 0 КАК lastmod 
		|ИЗ 
		|	Справочник.ИнтернетСтатьи 
		|ГДЕ
		|	ЭтоГруппа = ЛОЖЬ И
		|	Не Родитель В(ВЫБРАТЬ Ссылка ИЗ ГруппыНовостей) И
		//|	alies <> """" И
		|	ВыгружатьНаСайт = ИСТИНА
		|");
		
	// подготовим таблицу
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НовСтрока = Таблица.Добавить();
		НовСтрока.loc 		= СтрЗаменить(Выборка.loc, " ", "");
		НовСтрока.lastmod 	= XMLСтрока(ТекущаяДата());
      	
	КонецЦикла;
	
	Возврат Истина;
		
КонецФункции
&НаСервере
Функция ПолучитьАлиесыНовостей()
	
	Таблица.Очистить();
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ Ссылка ПОМЕСТИТЬ ГруппыНовостей ИЗ Справочник.ИнтернетСтатьи ГДЕ ЭтоГруппа = Истина И ЭтоНовости = Истина;
		|ВЫБРАТЬ 
		|	РАЗЛИЧНЫЕ Наименование КАК loc, 0 КАК lastmod 
		|ИЗ 
		|	Справочник.ИнтернетСтатьи 
		|ГДЕ
		|	ЭтоГруппа = ЛОЖЬ И
		|	Родитель В(ВЫБРАТЬ Ссылка ИЗ ГруппыНовостей) И
		//|	alies <> """" И
		|	ВыгружатьНаСайт = ИСТИНА
		|");
		
	// подготовим таблицу
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НовСтрока = Таблица.Добавить();
		НовСтрока.loc 		= СтрЗаменить(Выборка.loc, " ", "");
		НовСтрока.lastmod 	= XMLСтрока(ТекущаяДата());
      	
	КонецЦикла;
	
	Возврат Истина;
		
КонецФункции

&НаКлиенте
Процедура ЗаписатьСтрокуURL(ЗаписьXML, loc, lastmod)
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("url");
				
	ЗаписьXML.ЗаписатьНачалоЭлемента("loc");
	ЗаписьXML.ЗаписатьТекст(loc);
	ЗаписьXML.ЗаписатьКонецЭлемента();
				
	ЗаписьXML.ЗаписатьНачалоЭлемента("lastmod");
	ЗаписьXML.ЗаписатьТекст(lastmod);
	ЗаписьXML.ЗаписатьКонецЭлемента();
			
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры
&НаКлиенте
Процедура СформироватьФайлКарту(Команда)
	
	НачалоСайта 			= "http://93.153.133.10";
	НачалоТовара 			= "/shop";
	НачалоСтатей			= "/articles";
	НачалоНовостей			= "/news";
	ДатаСайта 				= ТекущаяДата();
	ПространствоИмен		= "http://www.sitemaps.org/schemas/sitemap/0.9";
	ПрефиксПространстваИмен = "lc";
	ТоварыГрузитьПо			= 100;
	
	// Проверим корректность
	
	Если ПустаяСтрока(Объект.ИмяФайла) Тогда                                      
		ОбщиеФункции.СообщитьТекст("Не выбран файл", Элементы.ИмяФайла);
		Возврат;
	КонецЕсли;
	
	// Откроем файл для записи
		
	ЗаписьXML = Новый ЗаписьXML;
	
	Попытка
		ЗаписьXML.ОткрытьФайл(Объект.ИмяФайла, Новый ПараметрыЗаписиXML("windows-1251", "1.0", Истина, Ложь, Символы.Таб));
	Исключение
		ОбщиеФункции.СообщитьТекст(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	// Начнемс
	
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("urlset");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен(ПрефиксПространстваИмен, ПространствоИмен);
	
	// СТЬИИ
	
	Если ПолучитьАлиесыСтаей() Тогда
		
		Для Каждого Строка Из Таблица Цикл
			
			ЗаписатьСтрокуURL(ЗаписьXML, НачалоСайта + НачалоСтатей + "/" + Строка.loc, Строка.lastmod)
				
		КонецЦикла;
	КонецЕсли;
	
	// НОВОСТИ
	
	Если ПолучитьАлиесыСтаей() Тогда
		
		Для Каждого Строка Из Таблица Цикл
			
			ЗаписатьСтрокуURL(ЗаписьXML, НачалоСайта + НачалоНовостей + "/" + Строка.loc, Строка.lastmod)
				
		КонецЦикла;
	КонецЕсли;
	
	// ТОВАРЫ
	
	Ном 		= 1;
	КолТоваров 	= КоличествоИдТоваров();
	
	Пока Ном < КолТоваров Цикл
	
		ОбработкаПрерыванияПользователя();
		
		Если ПолучитьАлиесыТоваров(Ном, Ном + ТоварыГрузитьПо) Тогда
		
			Для Каждого Строка Из Таблица Цикл
				ЗаписатьСтрокуURL(ЗаписьXML, НачалоСайта + НачалоТовара + "/" + Строка.loc, Строка.lastmod)
			КонецЦикла;
			
		КонецЕсли;
		
		Ном = Ном + ТоварыГрузитьПо;
		
		Состояние("Выгрузка товаров", ном / КолТоваров * 100, "" + Ном + " из " + КолТоваров);
		
	КонецЦикла;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.Закрыть();
	
	ОбщиеФункции.СообщитьТекст("Файл " + Объект.ИмяФайла + " сформирован");
	
КонецПроцедуры


&НаСервере
Процедура ВыполнитьНаСервере()
	
	МодульРегламентныхЗаданий.ВыгрузкаФайлаКартыСайтаДляРоботов();
	
КонецПроцедуры
&НаКлиенте
Процедура СформироватьНаСервере(Команда)
	
	ВыполнитьНаСервере();
	
	ОбщиеФункции.СообщитьТекст("Серваку отпавлена команда, смотри журнал");
	
КонецПроцедуры

