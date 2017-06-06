﻿
&НаСервере
Процедура УстановитьОтменено() Объект.Статус = Перечисления.СтатусыЗадач.Отклонена КонецПроцедуры
&НаСервере
Процедура УстановитьРешено() Объект.Статус = Перечисления.СтатусыЗадач.Решена КонецПроцедуры
&НаСервере
Процедура УстановитьРешаю() Объект.Статус = Перечисления.СтатусыЗадач.ВРаботе КонецПроцедуры
&НаСервере
Процедура УставновитьВочередь() Объект.Статус = Перечисления.СтатусыЗадач.ВОчереди КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	Элементы.ГруппаКнопкиУправленияТекстом.Видимость	= ТекущийРежимПросмотр;							// это кнопки что делать в начале
	Элементы.ТекстовыйДокумент.Видимость			 	= Не ТекущийРежимПросмотр;						// это поле где редактируют
	Элементы.ГруппаКнопкиКомментария.Видимость 			= ТекстЭтоКомментарий;							// это кнопки где нажимают "комментриовать"
	Элементы.ГруппаРедактированиеТекста.Видимость 		= Не ТекущийРежимПросмотр;						// Это общая группа редактирования
	Элементы.ГруппаПросмотраТекста.Видимость			= ТекущийРежимПросмотр Или ТекстЭтоКомментарий;	// Это где смотрим текст
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Перем стрКартинок;
	
	// Сохраним доп параметры
	Для Каждого Элемент Из ПараметрыЗаписи Цикл ТекущийОбъект.ДополнительныеСвойства.Вставить(Элемент.Ключ, Элемент.Значение) КонецЦикла;
	
	// Сохраним описание
	Если Не ТекущийРежимПросмотр Тогда
		
		Если ТекстЭтоКомментарий Тогда
			
			НовКомментарий = ТекущийОбъект.Комментарии.Добавить();
			НовКомментарий.Пользователь 	= ПараметрыСеанса.ТекущийПользователь;
			НовКомментарий.Дата 			= ТекущаяДата();
			ТекстовыйДокумент.ПолучитьHTML(НовКомментарий.Комментарий , стрКартинок); 
			
			НомСтроки = ТекущийОбъект.Комментарии.Количество();
			
			// Считаем картирнки
			
			Для каждого Элемент Из стрКартинок Цикл
				
				НовСтрока = ТекущийОбъект.ВложенияКомментариев.Добавить();
				НовСтрока.НомерСтрокиКомментария	= НомСтроки;
				НовСтрока.Ключ 						= Элемент.Ключ;
				НовСтрока.Данные 					= Новый ХранилищеЗначения(Элемент.Значение); КонецЦикла;
		Иначе
		
			ТекстовыйДокумент.ПолучитьHTML(ТекущийОбъект.Описание, стрКартинок); 
			
			// Считаем картирнки
			
			ТекущийОбъект.Вложения.Очистить();
			Для каждого Элемент Из стрКартинок Цикл
				
				НовСтрока = ТекущийОбъект.Вложения.Добавить();
				НовСтрока.Ключ 		= Элемент.Ключ;
				НовСтрока.Данные 	= Новый ХранилищеЗначения(Элемент.Значение); КонецЦикла; КонецЕсли; КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВОчередьВКонец(Команда)
	
	УставновитьВочередь();
	Если Записать(Новый Структура("ВОчередь", "Вконец")) Тогда Закрыть() КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ВОчередьВНачало(Команда)
	
	УставновитьВочередь();
	Если Записать(Новый Структура("ВОчередь", "Вначало")) Тогда Закрыть() КонецЕсли;
	
КонецПроцедуры
&НаСервере
Функция ПолучитьТекущегоПользователя()
	
	Возврат ПараметрыСеанса.ТекущийПользователь;
	
КонецФункции
&НаКлиенте
Процедура Решено(Команда)
	
	УстановитьРешено();
	Если Объект.ДатаЗавершения = '00010101' Тогда Объект.ДатаЗавершения = ТекущаяДата() КонецЕсли;
	Если Объект.Исполнитель.Пустая() Тогда Объект.Исполнитель = ПолучитьТекущегоПользователя() КонецЕсли;
	Если Записать() Тогда Закрыть() КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура Отклонить(Команда)
	
	УстановитьОтменено();
	Если Объект.ДатаЗавершения = '00010101' Тогда Объект.ДатаЗавершения = ТекущаяДата() КонецЕсли;
	Если Объект.Исполнитель.Пустая() Тогда Объект.Исполнитель = ПолучитьТекущегоПользователя() КонецЕсли;
	Если Записать() Тогда Закрыть() КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ДобавитьТекст(ПутьКДанным, Текст, Знач ТекстДобавления, ТаблицаВложений, СтруктураДанных = Неопределено)
	
	Для Каждого Строка Из ТаблицаВложений Цикл
		
		Если СтруктураДанных = Неопределено Тогда
			ТекстДобавления = СтрЗаменить(ТекстДобавления, "'" + Строка.Ключ + "'", "'" + ПолучитьНавигационнуюСсылку(Объект.Ссылка, ПутьКДанным, Строка.НомерСТроки - 1) + "'");
		Иначе
			СтруктураДанных.Вставить(Строка.Ключ, Строка.Данные.Получить());  КонецЕсли; КонецЦикла;
	
	Текст = Текст + КонвертацияТипов.ВычленитьТело(ТекстДобавления);
	
КонецПроцедуры
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагрузитьНаблюдателей();
	
	// Считаем картинки
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ НомерСтроки, Ключ, Данные ИЗ Справочник.Задачи.Вложения ГДЕ Ссылка = &Ссылка;
	|ВЫБРАТЬ Комментарий, Дата, Пользователь, НомерСтроки ИЗ Справочник.Задачи.Комментарии ГДЕ Ссылка = &Ссылка УПОРЯДОЧИТЬ ПО НомерСтроки Убыв;
	|ВЫБРАТЬ НомерСтрокиКомментария, Ключ, Данные, НомерСТроки ИЗ Справочник.Задачи.ВложенияКомментариев ГДЕ Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Пакет = Запрос.ВыполнитьПакет();
	
	Текст = "";
	ТаблВложенийКомментриев = Пакет[2].Выгрузить();
	
	// Добавим комментарий
	
	Выборка = Пакет[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		Текст = Текст + "<p align=""right""><FONT color=#b3ac86><small> " + Выборка.Пользователь + " " + Формат(Выборка.Дата, "ДЛФ=DDT") + "</FONT></small>";
		ДобавитьТекст("ВложенияКомментариев.Данные", Текст, Выборка.Комментарий, ТаблВложенийКомментриев.НайтиСтроки(Новый Структура("НомерСтрокиКомментария", Выборка.НомерСтроки)));
		Текст = Текст + "<hr>" ; КонецЦикла;
	
	// Добавим описание
	
	ДобавитьТекст("Вложения.Данные", Текст, Объект.Описание, Пакет[0].Выгрузить());
	
	// Отобразим
	
	ТекстHTML = КонвертацияТипов.ЗавернутьТекстВHTML(Текст);
	//ТекстовыйДокумент.УстановитьHTML(ТекстHTML, СтруктураДанных);
	
	//ТекстHTML = Объект.Описание;
	//Пока Выборка.Следующий() Цикл
	//	ТекстHTML = СтрЗаменить(ТекстHTML, "'" + Выборка.Ключ + "'", "'" + ПолучитьНавигационнуюСсылку(Объект.Ссылка, "Вложения.Данные", Выборка.НомерСТроки - 1) + "'");
	//	СтруктураДанных.Вставить(Выборка.Ключ, Выборка.Данные.Получить()); КонецЦикла;
	
	//ТекстовыйДокумент.УстановитьHTML(Объект.Описание, СтруктураДанных);
	
	// Установим значения по умолчанию
	
	ТекущийРежимПросмотр = Не Объект.Ссылка.Пустая();
	УправлениеВидимостьюДоступностью();	
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьОписание()
	
	Запрос = Новый Запрос("ВЫБРАТЬ НомерСтроки, Ключ, Данные ИЗ Справочник.Задачи.Вложения ГДЕ Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	Текст = "";
	СтруктураДанных = Новый Структура;
	
	// Добавим описание
	
	ДобавитьТекст("Вложения.Данные", Текст, Объект.Описание, Выгрузка, СтруктураДанных);
	
	// Отобразим
	
	ТекстовыйДокумент.УстановитьHTML(Текст, СтруктураДанных);
	
КонецПроцедуры
&НаКлиенте
Процедура РедактироватьТекстНажатие(Элемент)
	
	ПрочитатьОписание();
	
	ТекущийРежимПросмотр = Ложь;
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры
&НаКлиенте
Процедура ДобавитьКомментарий(Команда)
	
	ТекстЭтоКомментарий 	= Истина;
	ТекущийРежимПросмотр 	= Ложь;
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура Решаю(Команда)
	
	УстановитьРешаю();
	текПользователь = ПолучитьТекущегоПользователя();
	
	Объект.Исполнитель = текПользователь;
	
	Если 	Объект.ДатаНачалаВыполнения = '00010101' Или 
			текПользователь <> Объект.Исполнитель Тогда 
		Объект.ДатаНачалаВыполнения = ТекущаяДата() КонецЕсли;
	
	Если Записать() Тогда Закрыть() КонецЕсли;
	
КонецПроцедуры

// НАБЛЮДАТЕЛИ

&НаСервере
Функция ПолучитьСписокВозможныхНаблюдателей()
	
	Список = Новый СписокЗначений;
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка, Код, Почта ИЗ Справочник.Пользователи ГДЕ Родитель.Наименование ПОДОБНО ""Сотрудники"" И Почта <> """" И НЕ ФизЛицо.Наименование ЕСТЬ NULL УПОРЯДОЧИТЬ ПО Код");
	Выборка = Запрос.Выполнить().Выбрать();
	
	РольРаботатьСЗадачами 	= Метаданные.Роли.РаботатьСЗадачами;
	РольПолныеПраваВОбласти = Метаданные.Роли.ПолныеПраваВОбласти;
	РольПолныеПрава 		= Метаданные.Роли.ПолныеПрава;
	
	Пока Выборка.Следующий() ЦИкл
		пользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(СокрЛП(Выборка.Код));
		Если пользовательИБ <> Неопределено И (
				пользовательИБ.Роли.Содержит(РольРаботатьСЗадачами) Или 
				пользовательИБ.Роли.Содержит(РольПолныеПраваВОбласти) Или 
				пользовательИБ.Роли.Содержит(РольПолныеПрава)) Тогда
				
			Список.Добавить(Выборка.Ссылка, СокрЛП(Выборка.Код) + "(" + ВЫборка.Почта + ")", Наблюдатели.НайтиПоЗначению(Выборка.Ссылка) <> Неопределено); КонецЕсли; КонецЦикла;
	
	Возврат Список;
	
КонецФункции

&НаКлиенте
Процедура ОтмеченыНаблюдатели(Список, ДополнительныеПараметры) Экспорт
	
	Если Список <> Неопределено Тогда Модифицированность = Истина;
		
		Наблюдатели.Очистить();
		КонвертацияТипов.ДобавитьСписокВКонецСписка(Наблюдатели, Список, Истина);
		//НаблюдателиСтр = КонвертацияТипов.ПолучитьСтрокуИзПредставленийСпискаЗначений(Наблюдатели); КонецЕсли;
		//НаблюдателиСтр = КонвертацияТипов.ПолучитьСтрокуИзПредставленийСпискаЗначений(Наблюдатели); КонецЕсли;
		Объект.НаблюдателиСтр = СтрСоединить(Наблюдатели.ВыгрузитьЗначения(), "; "); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура НаблюдателиСтрОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Список = ПолучитьСписокВозможныхНаблюдателей();
	Список.ПоказатьОтметкуЭлементов(Новый ОписаниеОповещения("ОтмеченыНаблюдатели", ЭтаФорма));
	
КонецПроцедуры
&НаСервере
Процедура ЗагрузитьНаблюдателей()
	
	Запрос = Новый Запрос("ВЫБРАТЬ Пользователь ИЗ РегистрСведений.ОтслеживаниеЗадач ГДЕ Задача = &Ссылка УПОРЯДОЧИТЬ ПО Пользователь.Наименование");
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Наблюдатели.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь"));
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Набор = РегистрыСведений.ОтслеживаниеЗадач.СоздатьНаборЗаписей();
	Набор.Отбор.Задача.Установить(ТекущийОбъект.Ссылка);
	Для Каждого Элемент Из Наблюдатели Цикл 
		НовЗапись = Набор.Добавить();
		НовЗапись.Задача 		= ТекущийОбъект.Ссылка;
		НовЗапись.Пользователь 	= Элемент.Значение; КонецЦикла;
	
	Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Набор) Тогда Отказ = Истина КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ТекстовыйДокумент.УстановитьHTML("", Новый Структура); // очистим
	Справочники.Задачи.ПроверитьНаблюдателейПоУмолчаниюИНазначитьЕслиИхНет(ТекущийОбъект.Ссылка);
	
КонецПроцедуры


&НаКлиенте
Процедура Комментриовать(Команда)
	
	Если Записать() Тогда
		ТекущийРежимПросмотр = Истина;
		ТекстЭтоКомментарий = Ложь;
		ПриСозданииНаСервере(Ложь, Истина); КонецЕсли;
	
КонецПроцедуры

