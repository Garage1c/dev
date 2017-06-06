﻿
&НаСервере
Процедура УстановитьФильтрСпискаПользователей(Ссылка)
	
	СписокПользователей.Параметры.УстановитьЗначениеПараметра("Профиль", Ссылка);
	
КонецПроцедуры
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьФильтрСпискаПользователей(Объект.Ссылка);
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ключ, Значение ИЗ Справочник.Профили.КартинкиОписания ГДЕ Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Структура = Новый Структура;
	Пока Выборка.Следующий() Цикл
		Структура.Вставить(Выборка.Ключ, Выборка.Значение.Получить()); КонецЦикла; 
	
	Описание.УстановитьHTML(Объект.Описание, Структура);
			
КонецПроцедуры
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Перем Структура;
	
	Описание.ПолучитьHTML(ТекущийОбъект.Описание, Структура);
	ТекущийОбъект.КартинкиОписания.Очистить();
	
	Для Каждого Элемент Из Структура Цикл
		
		НовСтрока = ТекущийОбъект.КартинкиОписания.Добавить();
		НовСтрока.Ключ 		= Элемент.Ключ;
		НовСтрока.Значение 	= Новый ХранилищеЗначения(Элемент.Значение); КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	//УстановитьФильтрСпискаПользователей(ТекущийОбъект.Ссылка);
	//Элементы.ГруппаСписок.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если 	ИмяСобытия = "СохраненыНастройкиПрофиля" И
			Параметр.Профиль = Объект.Ссылка Тогда
			
		//Закрыть(); 
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Функция ЗаписанИКрасавчег()
	
	Если Модифицированность И Элементы.СписокПользователей.ВыделенныеСтроки.Количество() Тогда
		ПоказатьПредупреждение(,"Сперва нужно записать");
		Возврат Ложь; КонецЕсли;
	
	Возврат Истина;
	
КонецФункции
Функция МассивТекущегоПрофиля()
	
	Массив = Новый Массив;
	Массив.Добавить(Объект.Ссылка);
	
	Возврат Массив;
	
КонецФункции


&НаСервере
Функция УСтановитьПользователямПрофиль()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ Ссылка Пользователь, &Профиль Профиль ИЗ Справочник.Пользователи Спр
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ПрофилиПользователей Рег
	|ПО
	|	Рег.Пользователь 	= Спр.Ссылка И
	|	Рег.Профиль 		= &Профиль
	|
	|ГДЕ Ссылка В(&Пользователи) И Рег.Пользователь ЕСТЬ NULL
	|");
	
	Запрос.УстановитьПараметр("Профиль", 		Объект.Ссылка);
	Запрос.УстановитьПараметр("Пользователи", 	Элементы.СписокПользователей.ВыделенныеСтроки);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Запись = РегистрыСведений.ПрофилиПользователей.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
		
		Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Запись) Тогда
			Возврат Ложь; КонецЕсли; КонецЦикла;
	
	Возврат Истина;	
	
КонецФункции

&НаСервере
Функция ОбнулититьПользователейНаСервере()
	
	НачатьТранзакцию();
	
	Если 	УСтановитьПользователямПрофиль() И
			НастройкиПользователя.ОчиститьИУстановитьПрофилиПользователей(Элементы.СписокПользователей.ВыделенныеСтроки, МассивТекущегоПрофиля()) Тогда
			
		ЗафиксироватьТранзакцию();
		Возврат Истина; КонецЕсли;
	
	ОтменитьТранзакцию();
	Возврат Ложь;
	
КонецФункции
&НаКлиенте
Процедура ОбнулититьПользователей(Ответ, ДопПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да И ОбнулититьПользователейНаСервере() Тогда
		ПоказатьОповещениеПользователя("Настройки выбранных пользователей сброшены и установлены из профиля: " + Объект.Наименование,,"Обнуление пользователей"); 
		Закрыть(); КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция ДобавитьНастройкиПользователямНаСервере()
	
	НачатьТранзакцию();
	
	Если 	УСтановитьПользователямПрофиль() И
			НастройкиПользователя.УстановитьПрофилиНаПользователей(Элементы.СписокПользователей.ВыделенныеСтроки, МассивТекущегоПрофиля()) Тогда
			
		ЗафиксироватьТранзакцию();
		Возврат Истина; КонецЕсли;
	
	ОтменитьТранзакцию();
	Возврат Ложь; 
	
КонецФункции
&НаКлиенте
Процедура ДобавитьНастройкиПользователям(Ответ, ДопПараметр) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да И ДобавитьНастройкиПользователямНаСервере() Тогда
		ПоказатьОповещениеПользователя("Добавлены выбранным пользователям настройки из профиля: " + Объект.Наименование,,"Обновление настроек пользователей"); 
		Закрыть(); КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПоверх(Команда)
	
	Если ЗаписанИКрасавчег() Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ДобавитьНастройкиПользователям", ЭтаФорма), "Добавить выбранным пользователям настройки этого профиля??", РежимДиалогаВопрос.ДаНет) КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ОчиститьИУстановить(Команда)
	
	Если ЗаписанИКрасавчег() Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбнулититьПользователей", ЭтаФорма), "Будут очищены все настройки выбранных пользователе и назначены только из этого профиля, Продожить?", РежимДиалогаВопрос.ДаНет) КонецЕсли;
	
КонецПроцедуры

