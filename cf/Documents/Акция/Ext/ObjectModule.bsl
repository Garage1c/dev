﻿Функция ПолучитьТекстЗапросаПолученияСпискаТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура
	|ИЗ
	|	Документ.Акция.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка
	|";
	
КонецФункции


Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если НЕ КонтрольУникальность() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Проведение
	
	Если Не Отказ Тогда
		ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;
	
	// Запись
	
	Движения.Записать();

КонецПроцедуры


Функция КонтрольУникальность()
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Номенклатура,
		|	Упаковка,
		|	ТипЦен,
		|	НоваяЦена,
		|	ПроцентСкидки,
		|	Ссылка.ДатаНачала 		ДатаНачала,
		|	Ссылка.ДатаОкончания 	ДатаОкончания
		|ПОМЕСТИТЬ
		|	ТоварыАкции
		|ИЗ
		|	Документ.Акция.Товары
		|ГДЕ
		|	Ссылка = &Ссылка
		|;
		
		// дата начала новой акции должна быть больше чем окончание любой другой акции, а дата окончания новой акции должна быть меньше чем дата начала любой другой акции
		// если нарушается одно из этих условий, акцию запускать нельзя
		
		|ВЫБРАТЬ 
		|	Тов.Номенклатура,
		|	Тов.ТипЦен,
		|	Рег.Акция
		|ИЗ
		|	ТоварыАкции Тов
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		(	ВЫБРАТЬ Номенклатура, ТипЦен, Период, Акция, Акция.ДатаОкончания Период2 ИЗ РегистрСведений.Акция 
		|		 	ГДЕ Номенклатура В (ВЫБРАТЬ Номенклатура Из ТоварыАкции) И Акция <> &Ссылка И Акция <> &ПустаяАкция
		|		) Рег 
		|		ПО Рег.Номенклатура = Тов.Номенклатура И Рег.ТипЦен = Тов.ТипЦен
		|	ГДЕ НЕ Рег.Период ЕСТЬ NULL
		|	И НЕ (Тов.ДатаОкончания < Рег.Период ИЛИ Тов.ДатаНачала > Рег.Период2)
		|;
		|ВЫБРАТЬ Тов.Номенклатура ИЗ ТоварыАкции Тов ГДЕ Тов.ПроцентСкидки = 0 И Тов.НоваяЦена = 0
		|;
		|ВЫБРАТЬ Тов.Номенклатура, Тов.Упаковка, Тов.ТипЦен ИЗ ТоварыАкции Тов СГРУППИРОВАТЬ ПО Тов.Номенклатура, Тов.Упаковка, Тов.ТипЦен ИМЕЮЩИЕ КОЛИЧЕСТВО(Тов.Номенклатура)>1");
		
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ТипЦен", ТипЦен);

	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("ПустаяАкция", Документы.Акция.ПустаяСсылка());
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Если НЕ РезультатЗапроса[2].Пустой() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Величина скидки не может быть пустой");
		Возврат Ложь;
	КонецЕсли;
	Если НЕ РезультатЗапроса[3].Пустой() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("В рамках одной акции для товара не может быть назначено несколько скидок");
		Возврат Ложь;
	КонецЕсли;	

	Если НЕ РезультатЗапроса[1].Пустой() Тогда
		Выборка = РезультатЗапроса[1].Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Товар уже участвует в акции: " + Выборка.Номенклатура + "(" + Выборка.Акция + ") для типа цен " + Выборка.ТипЦен);
		КонецЦикла;
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

Функция СформироватьAliesИзНаименования()
	
	ДоступныеСимволы 	= "-_1234567890ABCDEIFGHIJKLMNOPQRSTUVWXYZАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯЁ";
	СимволыНаТире 		= ".,=;/\- ";
	
	НаименованиеВРег 	= ВРег(СокрЛП(Наименование));
	ДлинаНаим 			= СтрДлина(СокрЛП(Наименование));
	
	СтрAlies = "";
	
	Для ном = 1 По ДлинаНаим Цикл текСимволВрег = Сред(НаименованиеВРег, ном, 1); текСимвол = Сред(Наименование, ном, 1); Если Найти(ДоступныеСимволы, текСимволВрег) Тогда СтрAlies = СтрAlies + текСимвол; ИначеЕсли Найти(СимволыНаТире, текСимволВрег) Тогда СтрAlies = СтрAlies + "-"; КонецЕсли;КонецЦикла;
	
	// { Удалить временная мера
	
	СтрAlies = СтрЗаменить(СтрAlies, "--", "-");
	СтрAlies = СтрЗаменить(СтрAlies, "--", "-");
	СтрAlies = СтрЗаменить(СтрAlies, "--", "-");
	СтрAlies = СтрЗаменить(СтрAlies, "--", "-");
	
	Если Прав(СтрAlies,1) = "-" Тогда СтрAlies = Лев(СтрAlies, СтрДлина(СтрAlies) - 1) КонецЕсли;
	Если Прав(СтрAlies,1) = "-" Тогда СтрAlies = Лев(СтрAlies, СтрДлина(СтрAlies) - 1) КонецЕсли;
	Если Прав(СтрAlies,1) = "-" Тогда СтрAlies = Лев(СтрAlies, СтрДлина(СтрAlies) - 1) КонецЕсли;
	
	// }
	
	Возврат СтрAlies;
	
КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	// Проверим alies
	
	Если ПустаяСтрока(alies) Тогда
		alies = НРег(КонвертацияТипов.ПреобразоватьРусскийТекстВАнглицкий(СформироватьAliesИзНаименования()));
	ИначеЕсли КонвертацияТипов.ЕстьРусскиеБуквы(alies) Тогда
		alies = НРег(КонвертацияТипов.ПреобразоватьРусскийТекстВАнглицкий(СформироватьAliesИзНаименования())); 
	КонецЕсли;
	
	новАлиес = HTTP.ПроверитьИПолучитьНовыйAlies(Ссылка, ЭтоНовый(), alies, , "Документ");
	Если новАлиес <> alies Тогда alies = новАлиес КонецЕсли;
КонецПроцедуры