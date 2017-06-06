﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Новый ТабличныйДокумент;
	Печать(ТабДок, ПараметрКоманды);

	ФункцииФормДокументов.УстановитьНастройкиТабличногоДокумента(ТабДок);
	
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;

	Если ТабДок.Области.Количество() Тогда
		ТабДок.Показать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды)
	
	Инд = -1;
	Для Каждого Ссылка Из ПараметрКоманды Цикл Инд = Инд + 1;
		
		Если Инд Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПечататьСборочныйЛист(ТабДок, Ссылка);
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПечататьСборочныйЛист(ТабДокумент, Ссылка) Экспорт
	
	Макет = Документы.ПеремещениеТоваров.ПолучитьМакет("СборочныйЛист");
	
	ОбластьШапка 			= Макет.ПолучитьОбласть("Шапка");
	ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьСтрока 			= Макет.ПолучитьОбласть("Строка");
	ОбластьИтого 			= Макет.ПолучитьОбласть("Итого");
	
	// Шапка
	
	ОбластьШапка.Параметры.Номер	= Ссылка.Номер;
	ОбластьШапка.Параметры.Дата 	= Ссылка.Дата;
	ОбластьШапка.Параметры.Процесс 	= Ссылка.Процесс;
	
	ТабДокумент.Вывести(ОбластьШапка);
	ТабДокумент.Вывести(ОбластьЗаголовокТаблицы);
	
	// Получим другие ячейки
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Номенклатура,
	|	ЯчейкаОтправитель,
	|	ЯчейкаПолучатель,
	|	ДокументРезерва,
	|	МАКСИМУМ(НомерСтроки) 					Номер,
	|	МАКСИМУМ(Номенклатура.Артикул) 			Артикул,
	|	МАКСИМУМ(Номенклатура.ЕдиницаИзмерения) ЕдиницаИзмерения,
	|	СУММА(Количество) 						Количество
	|ИЗ
	|	Документ.ПеремещениеТоваров.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Номенклатура,
	|	ЯчейкаОтправитель,
	|	ЯчейкаПолучатель,
	|	ДокументРезерва
	|");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Выводим в таблицу
	
	Количество = 0;
	Пока Выборка.Следующий() Цикл
		
		ОбластьСтрока.Параметры.Заполнить(Выборка);
		ТабДокумент.Вывести(ОбластьСтрока);
		
		//Если Выборка.ДокументРезерва Тогда
		//	
		//КонецЕсли;
		
		Количество = Количество + Выборка.Количество;
		
	КонецЦикла; 
	
	ОбластьИтого.Параметры.КолНоменклатура	= Количество;
	ОбластьИтого.Параметры.ДатаФормирования = Формат(ТекущаяДата(),"ДЛФ=DDT");
	ТабДокумент.Вывести(ОбластьИтого);
	
КонецПроцедуры

