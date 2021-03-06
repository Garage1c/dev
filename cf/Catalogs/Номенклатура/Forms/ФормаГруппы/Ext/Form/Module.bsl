﻿
&НаКлиенте
Перем ИзмениласьНаследственность; // следит - стоит мучить наследников или нет
&НаКлиенте
Перем СледитьЗаНаследственностью; // будет отслеживать или нет (диалог выводить юзеру или нет)

&НаКлиенте
Перем мФормаВыбораТекстHTML, мФормаВыбораТекст;

&НаКлиенте
перем ластКолСек;

#Область Предопреденные

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПрочитатьМеню();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДополнительныеРеквизиты.Загрузить(РаботаСНоменклатурой.ПолучитьДополнительныеРеквизитыНоменклатуры(Объект.Ссылка));
	ЗагрузитьДопГруппы();
	
	GUID = Объект.Ссылка.УникальныйИдентификатор();
	
	//desh.avdonin {{18.03.2015#
	ПроверитьПоявлениеНовыхТеговДляСортировкиУКатегории();
	//}}desh.avdonin
	
	ОбновитьТаблицуСайтов();
	
КонецПроцедуры

Функция ПроверитьПоявлениеНовыхТеговДляСортировкиУКатегории()
	// Проверим появление новых категорий
	Если НЕ Объект.Ссылка.Пустая() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ 
		|	ТегиНоменклатуры.Тег КАК Тег
		|Поместить ТегиКатегории
		|ИЗ 
		|	РегистрСведений.ТегиНоменклатуры КАК ТегиНоменклатуры
		|ГДЕ
		|	ТегиНоменклатуры.Номенклатура.Родитель = &ТекущяяКатегория
		|СГРУППИРОВАТЬ ПО
		|	ТегиНоменклатуры.Тег
		|;
		|ВЫБРАТЬ 
		|	ТегиКатегории.Тег КАК Тег
		|ИЗ 
		|	ТегиКатегории КАК ТегиКатегории
		|ЛЕВОЕ СОЕДИНЕНИЕ 
		|	Справочник.Номенклатура.ПорядокТегов КАК ТекущиеТеги
		|ПО
		|	ТекущиеТеги.Тег = ТегиКатегории.Тег И ТекущиеТеги.Ссылка = &ТекущяяКатегория
		|ГДЕ
		|	ТекущиеТеги.Ссылка Есть NULL
		|";
		
		Запрос.УстановитьПараметр("ТекущяяКатегория", Объект.Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			новСтрока = Объект.ПорядокТегов.Добавить();
			новСтрока.Тег = Выборка.Тег;
		КонецЦикла;
	КонецЕсли;
КонецФункции // ПроверитьПоявлениеНовыхТеговДляСортировкиУКатегории()

&НаСервере
Функция ЕстьПодчиненныеЭлементы()
	
	СсылкаОбъекта = Объект.Ссылка;
	
	Если СсылкаОбъекта.Пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1 ИСТИНА КАК Подчинение ИЗ Справочник.Номенклатура ГДЕ Ссылка <> &Ссылка И Ссылка В ИЕРАРХИИ(&Ссылка)");
	Запрос.УстановитьПараметр("Ссылка", СсылкаОбъекта);
	
	Выполнение = Запрос.Выполнить();
	Если Выполнение.Пустой() Тогда
		
		Возврат Ложь;
		
	Иначе
		
		Выборка = Выполнение.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.Подчинение = ИСТИНА;
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ластКолСек = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	СледитьЗаНаследственностью = ЕстьПодчиненныеЭлементы();
	ИзмениласьНаследственность = Ложь;
	ОбновитьHTML();
	
	ОбновитьВидимостьЭлементов();
	
	ОбновитьКартинку();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Сохраним описание HTML
	
	Если БылоИзмененоHTMLОписание Тогда ТекущийОбъект.Описание = СокрЛП(КонвертацияТипов.ПолучитьТекстHTMLВнутри_Body(ОписаниеHTML)) КонецЕсли;
	
	// Сохраним новые значения свойств
	стрОшибки = "";
	Если НЕ (РаботаСНоменклатурой.СохранитьДополнительныеРеквизиты(
						ТекущийОбъект.Ссылка, 
						ДополнительныеРеквизиты.Выгрузить(), 
						ПараметрыЗаписи.ИзмениласьНаследственность, стрОшибки) И
	// Сохраним меню
	
			СохранитьМеню()) Тогда
			
		Отказ = Истина;  Если НЕ ПустаяСтрока(стрОшибки) Тогда Сообщить(стрОшибки); КонецЕсли; КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ИзмениласьНаследственность", ИзмениласьНаследственность);
	СохранитьДопГруппы();
	
КонецПроцедуры

#КонецОбласти


&НаКлиенте
Процедура ОбновитьВидимостьЭлементов()

	//Если Элементы.УдалитьДополнительныйРеквизит.Видимость Тогда
	//	Элементы.УдалитьДополнительныйРеквизит.Доступность = ТаблицаСвойств.Количество();
	//КонецЕсли;
	
	Элементы.НадписьОЗаписеНаследников.Видимость = СледитьЗаНаследственностью И ИзмениласьНаследственность;
	
	Элементы.ДополнительныеРеквизиты.ИзменятьПорядокСтрок 	= Объект.СортировкаДопРеквизитов;
	Элементы.ДекорацияДопРекв_СорттировкаВкл.Доступность 	= Не Объект.СортировкаДопРеквизитов;
	Элементы.ДекорацияДопРекв_СорттировкаВыкл.Доступность 	= Объект.СортировкаДопРеквизитов;
	
КонецПроцедуры

#Область Меню

&НаСервере
Процедура ПрочитатьМеню()
	
	Запрос = Новый Запрос("ВЫБРАТЬ * ИЗ РегистрСведений.ЧастныеСвойстваМенюОбъекта ГДЕ Объект = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	ТаблицаМеню.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция СохранитьМеню()
	
	ВрТаблица = ТаблицаМеню.Выгрузить();
	ВрТаблица.Колонки.Добавить("Объект", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ВрТаблица.ЗаполнитьЗначения(Объект.Ссылка, "Объект");
	
	Набор = РегистрыСведений.ЧастныеСвойстваМенюОбъекта.СоздатьНаборЗаписей();
	Набор.Отбор.Объект.Установить(Объект.Ссылка);
	Набор.Загрузить(ВрТаблица);
	
	Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Набор);
	
КонецФункции

#КонецОбласти

#Область HTML_описание

&НаКлиенте
Процедура ОбновитьHTML()
	
	ОписаниеHTML 		= ДиалогиСПользователем.СформироватьТекстHTML(Объект.Описание);
	ОписаниеHTML_Дилер 	= ДиалогиСПользователем.СформироватьТекстHTML(Объект.Описание_Дилер);
	
КонецПроцедуры


&НаКлиенте
Процедура РедактироватьОписаниеHTML(Команда)
	
	мФормаВыбораТекстHTML = ОткрытьФорму("ОбщаяФорма.РедактированияТекстаHTML", Новый Структура("ЗакрыватьПриВыборе, Текст, НеПоказыватьЗаголовокHTML", Истина, ОписаниеHTML, Истина), ЭтаФорма);
	
КонецПроцедуры
&НаКлиенте
Процедура РедактироватьОписаниеТекстом(Команда)
	
	мФормаВыбораТекст = ОткрытьФорму("ОбщаяФорма.РедактированияТекстаHTMLВФорматированномДокументе", Новый Структура("ЗакрыватьПриВыборе, Текст", Истина, ОписаниеHTML), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора = мФормаВыбораТекстHTML Тогда
		
		ОписаниеHTML = ВыбранноеЗначение; 
		Модифицированность = Истина;
		БылоИзмененоHTMLОписание = Истина;
		
	ИначеЕсли ИсточникВыбора = мФормаВыбораТекст Тогда
		
		ОписаниеHTML = ВыбранноеЗначение; 
		Модифицированность = Истина; 
		БылоИзмененоHTMLОписание = Истина; КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если БылоИзмененоHTMLОписание Тогда ТекущийОбъект.Описание = СокрЛП(КонвертацияТипов.ПолучитьТекстHTMLВнутри_Body(ОписаниеHTML)) КонецЕсли;
	
	// Сохраним наши свойства которые будут записаны в базу
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("БудутЗаписаны", 
			Новый Структура("Меню, Свойства", ТаблицаМеню.Выгрузить(), ДополнительныеРеквизиты.Выгрузить()));
			
	
КонецПроцедуры

#КонецОбласти

#Область Дополнительные_группы

&НаСервере
Процедура ЗагрузитьДопГруппы()
	
	Для Каждого строка Из Объект.ДополнительныеРодители Цикл
		НовСтрока = Группы.Добавить();
		НовСтрока.Родитель 	= Строка.Родитель;
		НовСтрока.Сайт 		= РаботаСНоменклатурой.ИмяСайтаИзТипаОбъекта(Строка.Родитель); КонецЦикла;
	
КонецПроцедуры
&НаСервере
Процедура СохранитьДопГруппы()
	
	Объект.ДополнительныеРодители.Загрузить(Группы.Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяСайтаПоНоменклатуре(Ссылка)
	
	Возврат РаботаСНоменклатурой.ИмяСайтаИзТипаОбъекта(Ссылка);
	
КонецФункции
&НаКлиенте
Процедура Группы1ГруппаПриИзменении(Элемент)
	
	текДанные = Элементы.ГруппыСайта.ТекущиеДанные;
	Если текДанные <> Неопределено Тогда
		текДанные.Сайт = ПолучитьИмяСайтаПоНоменклатуре(текДанные.Родитель); КонецЕсли;
	
КонецПроцедуры


#Область Старый_Код
&НаСервере
Процедура ЗагрузитьСписокгруппКВыбору()
	
	Список = Новый СписокЗначений;
	Для Каждого Строка Из Объект.ДополнительныеРодители Цикл
		Список.Добавить(Строка.Родитель);
	КонецЦикла;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Ссылка,
	|	ВЫБОР КОГДА Ссылка В(&ВыбранныеГруппы) ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ КАК Пометка
	|ИЗ
	|	Справочник.Номенклатура
	|ГДЕ
	|	ЭтоГруппа 		= ИСТИНА И
	|	ПометкаУдаления = ЛОЖЬ И
	|	Ссылка <> &ОсновнаяГруппа
	|");
	
	Запрос.УстановитьПараметр("ОсновнаяГруппа", 	Объект.Родитель);
	Запрос.УстановитьПараметр("ВыбранныеГруппы", 	Список);
	
	СписокВыбораГруппы.Очистить();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СписокВыбораГруппы.Добавить(Выборка.Ссылка,,Выборка.Пометка);
		
	КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Процедура ВыбратьГруппы(Команда)
	
	ЗагрузитьСписокгруппКВыбору();
	
	Если СписокВыбораГруппы.ОтметитьЭлементы("Отметить дополнительные группы:") Тогда
		
		Объект.ДополнительныеРодители.Очистить();
		
		Для Каждого Элемент Из СписокВыбораГруппы Цикл
			Если Элемент.Пометка Тогда
			
				Объект.ДополнительныеРодители.Добавить().Родитель = Элемент.Значение;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;	
	
КонецПроцедуры
#КонецОбласти

#КонецОбласти

#Область Картинки

&НаКлиенте
Процедура ОбновитьКартинку()
	
	АдресКартинки = Картинки.ПолучитьНавигационнуюСсылкуОсновногоИзображения(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура АватарНажатие1(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// Выберем картинку
	
	ДВ = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	Если ДВ.Выбрать() Тогда
		
		стрОшибки 	= "";
		ИмяФайла 	= Сред(ДВ.ПолноеИмяФайла, СтрДлина(ДВ.Каталог) + 1);
		
		Если Картинки.ОбновитьКартинкуОсновногоИзображения(	Новый Картинка(ДВ.ПолноеИмяФайла),
															Объект.Ссылка,,,стрОшибки) Тогда
			ОбновитьКартинку();
			//ЭтаФорма.ОбновитьОтображениеДанных();
			
		Иначе
			
			ОбщиеФункции.СообщитьТекст(стрОшибки);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Дополнительные_реквизиты

&НаКлиенте
Функция ПользовательРазрешаетИзменятьНаследственность()
	
	Возврат 
			ИзмениласьНаследственность ИЛИ
			
			Не СледитьЗаНаследственностью ИЛИ
			
			(	СледитьЗаНаследственностью И
					Вопрос("Будут измененны все подчиненные элементы при записи,
					|это может занять продолжительное время,
					|Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да
			);
			
КонецФункции

&НаКлиенте
Процедура ДополнительныеРеквизитыНаследоватьПриИзменении(Элемент)
	
	ТекДанные = Элементы.ДополнительныеРеквизиты.ТекущиеДанные;
	
	// Проверим что низя изменять наследственность верхнего по уровню
	
	//Если 	Не ТекДанные.Владелец.Пустая() И
	//		ТекДанные.Владелец <> Объект.Ссылка Тогда
	//		
	//	ТекДанные.Наследовать = Не ТекДанные.Наследовать;
	//	Возврат;
	//		
	//КонецЕсли;
	
	// Проверим что юзер согласен на изменение всех подчиненных
	
	Если Не ПользовательРазрешаетИзменятьНаследственность() Тогда
		
		ТекДанные.Наследовать = Не ТекДанные.Наследовать;
		
	Иначе
		
		ИзмениласьНаследственность = Истина;
		ОбновитьВидимостьЭлементов();
		
	КонецЕсли;
				
КонецПроцедуры
&НаКлиенте
Процедура ДополнительныеРеквизитыПередНачаломИзменения(Элемент, Отказ)
	
	Если Элементы.ДополнительныеРеквизиты.ТекущиеДанные.Наследовать Тогда
		
		Если Не ПользовательРазрешаетИзменятьНаследственность() Тогда
		
			Отказ = Истина;
			
		Иначе
			
			ИзмениласьНаследственность = Истина;
			ОбновитьВидимостьЭлементов();
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ДополнительныеРеквизитыПередУдалением(Элемент, Отказ)
	
	Если Элементы.ДополнительныеРеквизиты.ТекущиеДанные.Наследовать Тогда
		
		Если Не ПользовательРазрешаетИзменятьНаследственность() Тогда
		
			Отказ = Истина;
			
		Иначе
			
			ИзмениласьНаследственность = Истина;
			ОбновитьВидимостьЭлементов();
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРеквизитыПриАктивизацииСтроки(Элемент)
	
	ТекДанные = Элементы.ДополнительныеРеквизиты.ТекущиеДанные;
	
	// Определим доступность колонок таблицы
	
	Если ТекДанные <> Неопределено Тогда
	
		ЭтоСтрокаРодителя = Не ТекДанные.Владелец.Пустая() И ТекДанные.Владелец <> Объект.Ссылка;
		
		Элементы.ДополнительныеРеквизитыНаследовать.ТолькоПросмотр 			= ЭтоСтрокаРодителя;
		Элементы.ДополнительныеРеквизитыОтображатьВСписке.ТолькоПросмотр 	= ЭтоСтрокаРодителя;
		Элементы.ДополнительныеРеквизитыСвойство.ТолькоПросмотр 			= ЭтоСтрокаРодителя;
		
	КонецЕсли;
		
КонецПроцедуры


&НаКлиенте
Процедура ДекорацияДопРекв_СорттировкаВклНажатие(Элемент)
	
	Если ДополнительныеРеквизиты.НайтиСтроки(Новый Структура("Наследовать", Истина)).Количество() Тогда
		
		Если Не ПользовательРазрешаетИзменятьНаследственность() Тогда
		
			Возврат;
			
		Иначе
			
			ИзмениласьНаследственность = Истина;
			
		КонецЕсли;
	КонецЕсли;

	Объект.СортировкаДопРеквизитов = Истина;
	ОбновитьВидимостьЭлементов();
	
КонецПроцедуры
&НаКлиенте
Процедура ДекорацияДопРекв_СорттировкаВыклНажатие(Элемент)
	
	Если ДополнительныеРеквизиты.НайтиСтроки(Новый Структура("Наследовать", Истина)).Количество() Тогда
		
		Если Не ПользовательРазрешаетИзменятьНаследственность() Тогда
		
			Возврат;
			
		Иначе
			
			ИзмениласьНаследственность = Истина;
			
		КонецЕсли;
	КонецЕсли;

	Объект.СортировкаДопРеквизитов = Ложь;
	ОбновитьВидимостьЭлементов();

	
КонецПроцедуры


&НаКлиенте
Процедура ДополнительныеРеквизитыЗначениеПриИзменении(Элемент)
	
	Если 	СледитьЗаНаследственностью И 
			Элементы.ДополнительныеРеквизиты.ТекущиеДанные.Наследовать И 
			ЗначениеЗаполнено(Элементы.ДополнительныеРеквизиты.ТекущиеДанные.Значение) Тогда
		
		ОбщиеФункции.СообщитьТекст("Не рекомендуеться устанавливать значение в группе номенклатуры, 
		|устанавливаемое значение свойства, перезапишет значение всех товаров подчиненных этой группе!",
		"ДополнительныеРеквизиты[" + Формат(Элементы.ДополнительныеРеквизиты.ТекущаяСтрока,"ЧГ=") + "].Значение");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРеквизитыКлючевойПриИзменении(Элемент)
	Строки = ДополнительныеРеквизиты.НайтиСтроки(Новый Структура("Ключевой", Истина));
	Если Строки.Количество() > 1 Тогда
		ТекДанные = Элементы.ДополнительныеРеквизиты.ТекущиеДанные;	
		Если ТекДанные <> Неопределено Тогда ТекДанные.Ключевой = Ложь; Сообщить("Ключевым может быть только одно свойство"); КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область Сайты

&НаСервере
Процедура ОбновитьТаблицуСайтов()
	
	// Добавим текущий элемент
	
	Сайты.Очистить();
	НовСтрока = Сайты.Добавить();
	НовСтрока.Сайт 		= РаботаСНоменклатурой.ИмяОсновногоСайта();
	НовСтрока.Ссылка 	= Объект.Ссылка;
	
	// Подготовим текст запроса
	
	ИменаСайтов = КэшируемыеФункции.ПолучитьМассивСайтовНоменклатуры();
	Текст = "ВЫБРАТЬ Ссылка КАК Ссылка, """ + РаботаСНоменклатурой.ИмяОсновногоСайта() + """ Сайт, ЛОЖЬ ЭтоКопия ИЗ Справочник.Номенклатура ГДЕ Ссылка = &Ссылка";
	Для Каждого Сайт Из ИменаСайтов Цикл Текст = Текст + " ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ Ссылка, """ + Сайт + """, НастройкиИзНоменклатуры ИЗ Справочник.НоменклатураСайт" + Сайт + " ГДЕ НоменклатураКопия = &Ссылка"; КонецЦикла;
	
	// Выполним
	
	Запрос = Новый Запрос(Текст);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	ТаблЗапрос = Запрос.Выполнить().Выгрузить();
	
	// Заполним таблицу
	
	Для Каждого Сайт Из ИменаСайтов Цикл
		НовСтрока 	= Сайты.Добавить();
		Строка 		= ТаблЗапрос.Найти(Сайт, "Сайт");
		Если Строка <> Неопределено Тогда ЗаполнитьЗначенияСвойств(НовСтрока, Строка) КонецЕсли;
		НовСтрока.Сайт = Сайт; КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидимостьСайтов()
	
	текДанные = Элементы.Сайты.ТекущиеДанные;
	
	Если текДанные <> Неопределено Тогда
		
		// Декорация создать
		
		Если 	текДанные.Ссылка = Неопределено И
				Не Элементы.ДекорацияСайты_Создать.Видимость Тогда
				
			Элементы.ДекорацияСайты_Создать.Видимость = Истина;
				
		ИначеЕсли  	текДанные.Ссылка <> Неопределено И
					Элементы.ДекорацияСайты_Создать.Видимость Тогда
					
			Элементы.ДекорацияСайты_Создать.Видимость = Ложь; КонецЕсли;
		
		// Декорация свои настройки
		
		Если 	текДанные.ЭтоКопия И
				Не Элементы.ДекорацияСайты_СвоиНастройки.Видимость Тогда
				
			Элементы.ДекорацияСайты_СвоиНастройки.Видимость = Истина;
			
		ИначеЕсли 	(Не текДанные.ЭтоКопия И
					Элементы.ДекорацияСайты_СвоиНастройки.Видимость) Тогда // Или текДанные.Ссылка = Объект.Ссылка Тогда
					
			Элементы.ДекорацияСайты_СвоиНастройки.Видимость = Ложь; КонецЕсли;
		
		// Декарация настройки копии
		
		Если 	Не текДанные.ЭтоКопия И
				Не Элементы.ДекорацияСайты_НастройкиКопии.Видимость Тогда
				
			Элементы.ДекорацияСайты_НастройкиКопии.Видимость = Истина;
			
		ИначеЕсли 	(текДанные.ЭтоКопия И
					Элементы.ДекорацияСайты_НастройкиКопии.Видимость) Тогда // Или текДанные.Ссылка = Объект.Ссылка Тогда
					
			Элементы.ДекорацияСайты_НастройкиКопии.Видимость = Ложь; КонецЕсли; КонецЕсли; 
	
КонецПроцедуры
&НаКлиенте
Процедура СайтыПриАктивизацииСтроки(Элемент)
	
	//Если ТекущаяУниверсальнаяДатаВМиллисекундах() - ластКолСек > 1000 Тогда
	
	ОбновитьВидимостьСайтов();
	
	//ластКолСек = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСайты_СоздатьНажатие(Элемент)
	
	текДанные = Элементы.Сайты.ТекущиеДанные;
	Если текДанные <> Неопределено Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("СоздатьНовуюГруппуСайта", ЭтаФорма, Новый Структура("Сайт", текДанные.Сайт)), "Создать группу " + текДанные.Сайт + " и связать с текущей группой?", РежимДиалогаВопрос.ДаНет); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура СоздатьНовуюГруппуСайта(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		// Создадим новый справочник
		Если СоздатьНовуюГруппуСайтаНаСервере(ДополнительныеПараметры.Сайт, Истина) Тогда
			ПоказатьОповещениеПользователя("Создание группы",,"Группа для " + ДополнительныеПараметры.Сайт +  " успешно создана", БиблиотекаКартинок.СохранитьФайл); 
			ОбновитьВидимостьСайтов(); КонецЕсли; КонецЕсли;
	
КонецПроцедуры
&НаСервере
Функция СоздатьНовуюГруппуСайтаНаСервере(Сайт, ОбновитьТаблицу = Ложь)
	
	Результат = Справочники.Номенклатура.СоздатьКопиюСправочникаСайта(Объект.Ссылка, Сайт);
	
	//// Создадим справочник
	//
	//СпрОбъект = Справочники["НоменклатураСайт" + Сайт].СоздатьГруппу();
	//СпрОбъект.Наименование 	= Объект.Наименование;
	//СпрОбъект.Номенклатура 	= Объект.Ссылка;
	//СпрОбъект.НастройкиИзНоменклатуры 	= Истина;
	//
	//// Привяжем к родителю
	//
	//Если Не Объект.Родитель.Пустая() Тогда
	//	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.НоменклатураСайт" + Сайт + " ГДЕ Номенклатура = &Родитель");
	//	Запрос.УстановитьПараметр("Родитель", Объект.Родитель);
	//	Выборка = Запрос.Выполнить().Выбрать();
	//	Если Выборка.Следующий() Тогда
	//		СпрОбъект.Родитель = Выборка.Ссылка; КонецЕсли; КонецЕсли;
	//
	//Результат = ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(СпрОбъект);
	
	// Обновим таблицу
	
	Если ОбновитьТаблицу Тогда ОбновитьТаблицуСайтов() КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти