﻿////////////////////////////////////////////////////////////////////////////////
// Блок обработчиков событий формы и элементов формы
//

&НаСервере
// Обработчик события "при создании на сервере" 
// Устанавливает даты начала и конца для загрузки курсов по умолчанию
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.НачалоПериодаЗагрузки = НачалоМесяца(ТекущаяДата());
	Объект.ОкончаниеПериодаЗагрузки = ТекущаяДата();
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "обработка выбора" формы
// Обрабатывает выбор валюты в форме выбора
//
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Если ТипЗнч(РезультатВыбора) = Тип("СправочникСсылка.Валюты") Тогда
		
		Если Не ВалютаПрисутствуетВСпискеВалют(РезультатВыбора) Тогда
			ДобавитьВалютуВСписок(РезультатВыбора);
		Иначе
			Предупреждение(НСтр("ru = 'Валюта уже присутствует в списке'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "перед началом добавления" элемента формы СписокВалют
// Вызывает форму выбора валют в режиме выбора
//
Процедура СписокВалютПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ПараметрыФорма = Новый Структура("ЗагружаемыеВалюты", Истина);
	ОткрытьФорму("Справочник.Валюты.ФормаВыбора", ПараметрыФорма, ЭтаФорма);
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события "выбор" табличной части "СписокВалют" формы
// Открывает форму валюты
//
Процедура СписокВалютВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьЗначение(Элементы.СписокВалют.ТекущиеДанные.Валюта);
	
КонецПроцедуры

&НаКлиенте
// Обработчик события нажания на кнопку "Очистить"
// Очищает список валют
//
Процедура КомандаОчиститьВыполнить()
	
	Объект.СписокВалют.Очистить();
	
КонецПроцедуры

&НаКлиенте
// Обработчик нажатия на кнопку "Заполнить"
// Вызывает функциональность заполнения списка валют
//
Процедура КомандаЗаполнитьСписокВалютВыполнить()
	
	ЗаполнитьВалюты();
	
КонецПроцедуры

&НаКлиенте
// Обработчик нажатия на кнопку "Подбор"
// Вызывает форму выбора валют в режиме подбора
//
Процедура КомандаПодборВалютВыполнить()
	
	ПараметрыФормы = Новый Структура("ФормаПодбора, ЗагружаемыеВалюты", Истина, Истина);
	ОткрытьФорму("Справочник.Валюты.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Обработчик нажаитя на кнопку "Загрузить"
// Вызывает функциональность загрузки курсов
//
Процедура КомандаЗагрузитьВыполнить()
	
	Если Не ЗначениеЗаполнено(Объект.НачалоПериодаЗагрузки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Не задана дата начала периода загрузки.'"),
					Объект,
					"Объект.СписокВалют");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ОкончаниеПериодаЗагрузки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Не задана дата окончания периода загрузки.'"),
					Объект,
					"Объект.СписокВалют");
		Возврат;
	КонецЕсли;
	
	Если Объект.СписокВалют.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		              НСтр("ru = 'Для загрузки курсов с веб-сайта РБК необходимо добавить в список хотя бы одну валюту.'"),
		              Объект,
		              "Объект.СписокВалют");
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Состояние(НСтр("ru = 'Загружаются курсы валют...'"));
	ПоясняющееСообщение = "";
	СтатусОперации = ЗагрузитьКурсыСРБК(ПоясняющееСообщение);
	Если СтатусОперации Тогда
		Оповестить("ИзменениеКурсовВалют");
		ТекстСообщенияОЗавершенииЗагрузки = НСтр("ru = 'Загрузка курсов валют завершена.'");
		Если ЗначениеЗаполнено(ПоясняющееСообщение) Тогда
			ТекстСообщенияОЗавершенииЗагрузки = ТекстСообщенияОЗавершенииЗагрузки + Символы.ПС
										+ ПоясняющееСообщение;
		КонецЕсли;
		
		// silber {
		
		// Обновим кэш номенклатуры
		
		текВремя = ТекущаяДата();
		ПоказатьОповещениеПользователя("Обновление кэша",,"Запущена медленная процедура обновление всего кэша");
		ОбновитьКэшНоменклатуры();
		ПоказатьОповещениеПользователя("Обновление кэша",,"Выполнено! за " + Строка(ТекущаяДата() - текВремя) + " сек.");
		
		// } silber
			
		Состояние(ТекстСообщенияОЗавершенииЗагрузки);
	КонецЕсли;
	
КонецПроцедуры

// silber {
Процедура ОбновитьКэшНоменклатуры()
	
	РаботаСНоменклатурой.ОбновитьКэш();
	
КонецПроцедуры

// } silber

////////////////////////////////////////////////////////////////////////////////
// Секция служебных процедур
//

&НаКлиенте
Функция ЗагрузитьКурсыСРБК(ПоясняющееСообщение)
	
	ПоясняющееСообщение = "";
	
	СтатусОперации = РаботаСКурсамиВалютКлиентСервер.ЗагрузитьКурсыВалютПоПараметрам(
	           Объект.СписокВалют,
	           Объект.НачалоПериодаЗагрузки,
	           Объект.ОкончаниеПериодаЗагрузки,
	           ПоясняющееСообщение);
	
	Если Не СтатусОперации Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ПоясняющееСообщение);
	Иначе
		ОбновитьСведенияВСпискеВалют();
	КонецЕсли;
	
	Возврат СтатусОперации;
	
КонецФункции

&НаКлиенте
// Процедура заполняет табличную часть списком валют. В список попадают только 
// валюты, курс которых не зависит от курса других валют.
//
Функция ВалютаПрисутствуетВСпискеВалют(знач ИскомаяВалюта)
	
	Если Объект.СписокВалют.НайтиСтроки(Новый Структура("Валюта", ИскомаяВалюта)).Количество() = 0 Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаСервере
// Процедура заполняет табличную часть списком валют. В список попадают только 
// валюты, курс которых не зависит от курса других валют.
//
Процедура ЗаполнитьВалюты()
	
	ОкончаниеПериодаЗагрузки = Объект.ОкончаниеПериодаЗагрузки;
	СписокВалют = Объект.СписокВалют;
	СписокВалют.Очистить();
	
	ЗагружаемыеВалюты = РаботаСКурсамиВалют.ПолучитьМассивЗагружаемыхВалют();
	
	Для Каждого ЭлементВалюта Из ЗагружаемыеВалюты Цикл
		ДобавитьВалютуВСписок(ЭлементВалюта);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
// Процедура добавляет в список валют новую строку и заполняет ее информацией
// о курсе на основе ссылки на валюту
//
// Параметры:
// Валюта - Справочник.Валюты / Ссылка - ссылка на валюту, которая добавляется
//                 в список
//
Процедура ДобавитьВалютуВСписок(Валюта)
	
	НоваяСтрока = Объект.СписокВалют.Добавить();
	ЗаполнитьДанныеСтрокиТаблицыНаОсновеВалюты(НоваяСтрока, Валюта);
	
КонецПроцедуры

&НаСервере
// Процедура обновляет записи о курсах валют в списке.
//
Процедура ОбновитьСведенияВСпискеВалют()
	
	Для Каждого СтрокаДанных Из Объект.СписокВалют Цикл
		СсылкаНаВалюту = СтрокаДанных.Валюта;
		ЗаполнитьДанныеСтрокиТаблицыНаОсновеВалюты(СтрокаДанных, СсылкаНаВалюту);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
// Процедура заполняет строку табличной части информацией о курсе на основе
// ссылки на валюту.
//
// Параметры:
// ТекСтрока       - ДанныеФормыЭлементКоллекции - ссылка на строку табличной
//                  части, которую необходимо заполнить информацией о курсе 
//                  валюты
// ВыбраннаяВалюта - Справочник.Валюты / Ссылка - ссылка на валюту, информацию
//                  о которой необходимо получить.
//
Процедура ЗаполнитьДанныеСтрокиТаблицыНаОсновеВалюты(ТекСтрока, СсылкаНаВалюту);
	
	ТекСтрока.Валюта = СсылкаНаВалюту;
	ТекСтрока.КодВалюты = СсылкаНаВалюту.Код;
	
	ДанныеКурса = РаботаСКурсамиВалют.ЗаполнитьДанныеКурсаДляВалюты(СсылкаНаВалюту);
	
	Если ТипЗнч(ДанныеКурса) = Тип ("Структура") Тогда
		ТекСтрока.ДатаКурса = ДанныеКурса.ДатаКурса;
		ТекСтрока.Курс      = ДанныеКурса.Курс;
		ТекСтрока.Кратность = ДанныеКурса.Кратность;
	КонецЕсли;
	
КонецПроцедуры
