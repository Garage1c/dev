﻿
// ПРЕДСТАВЛЕНИЕ

Процедура ОбновитьОписание()
	
	Описание = 
	"<HTML><HEAD>
	|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
	|<META name=GENERATOR content=""MSHTML 8.00.7600.16588""></HEAD>
	|<body bgcolor=""#FCFAEB"">
	|" + Объект.Описание + "
	|</body>
	|</HTML>
	|";
	
КонецПроцедуры

&НаСервере
Функция ТекущийПользовательМожетВидитьСтоимостьЗадачи()
	
	Если 	РольДоступна("ПолныеПрава") ИЛИ РольДоступна("ПолныеПраваВОбласти") Или
			Объект.Исполнитель = ПараметрыСеанса.ТекущийПользователь Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1 ИСТИНА 
	|ИЗ 		Справочник.Пользователи.КтоМожетПросматриватьСтоимость 
	|ГДЕ 		Ссылка 			= &Исполнитель И
	|			Пользователь 	= &ТекущийПользователь
	|");
	
	Запрос.УстановитьПараметр("Исполнитель", 			Объект.Исполнитель);
	Запрос.УстановитьПараметр("ТекущийПользователь", 	ПараметрыСеанса.ТекущийПользователь);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Процедура ВидимостьЭлементов()
	
	точкиМаршрута = БизнесПроцессы.ЗадачаРазработчику.ТочкиМаршрута;
	
	Завершен			= Объект.Завершен;
	ЭтоНовый			= Объект.Ссылка.Пустая();
	ТекЗадачаРешение 	= ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(Объект.Ссылка, точкиМаршрута.РешениеЗадачи);
	ТекЗадачаКонтроль 	= ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(Объект.Ссылка, точкиМаршрута.ПроверкаЗадачи);
	
	Элементы.ГруппаКнопок.Видимость 	= Не Завершен;
	Элементы.ИсторияДоп.Видимость 		= Завершен;
	Элементы.Комментарий.Видимость 		= Не Завершен;
	Элементы.ЛевоеПоле.Видимость 		= не Завершен И Не ЭтоНовый;
	
	Элементы.СформироватьЗадачу.Видимость 	= Не Объект.Стартован;
	//Элементы.ОбновитьЗадачу.Видимость 		= Не ЭтоНовый;
	Элементы.Подтвердить.Видимость			= ТекЗадачаКонтроль;
	Элементы.Отклонить.Видимость			= ТекЗадачаКонтроль;
	Элементы.ЗадачаРешена.Видимость			= ТекЗадачаРешение;
	
	Элементы.Авторасчет.Видимость = Не Завершен;
	
	ДоступКСтоимости = 	ЭтоНовый Или
						ТекущийПользовательМожетВидитьСтоимостьЗадачи();
	Элементы.ГруппаЦены.Видимость 		= ДоступКСтоимости;
	Элементы.Исполнитель.Доступность 	= ДоступКСтоимости;
	
	//Элементы.КакВсавитьКартинкуНадпись.Видимость = Не Завершен;
	
	Если Завершен Тогда
		
		История = Объект.Описание + "<p>" + БизнесПроцессы.ЗадачаРазработчику.ПолучитьТекстHTMLОВыполнении(Объект.Ссылка) + "</p>";
		
	ИначеЕсли Не ЭтоНовый Тогда
		     
		ОбновитьОписание();
		История = БизнесПроцессы.ЗадачаРазработчику.ПолучитьТекстHTMLОВыполнении(Объект.Ссылка);
		
	КонецЕсли;
	
	ТолькоПросмотр = Завершен;
	
	// Смотрим или редактируем
	
	//Если  Тогда
	//	
	//	ТолькоПросмотр = Истина;
	//	Элементы.ИсторияДоп.Видимость 	= Истина;
	//	Элементы.Комментарий.Видимость 	= Ложь;
	//	Элементы.ГруппаКнопок.Видимость = Ложь;
	//	Элементы.ЛевоеПоле.Видимость 	= Ложь;
	//	
	//Иначе
	//	
	//	Элементы.ИсторияДоп.Видимость 	= Ложь;
	//	Элементы.Комментарий.Видимость 	= Истина;
	//	Элементы.ГруппаКнопок.Видимость = Истина;
	//	Элементы.ЛевоеПоле.Видимость 	= Истина;
	//	
	//КонецЕсли;
	
КонецПроцедуры

// ПРЕДОПРЕДЕЛЕННЫЕ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Авторасчет = Истина;
	
КонецПроцедуры
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Комментарий = "";
	ВидимостьЭлементов();
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Объект.Контроллер 	= ПараметрыСеанса.ТекущийПользователь;
		Объект.Проект 		= Параметры.Проект;
		
	КонецЕсли;
	
КонецПроцедуры
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
		
	Если Не ДиалогиСПользователем.ЗаписатьОтформатированныйДокументНаСервере(
						ТекущийОбъект,
						"ЗадачаРазработчикам",
						ВводТекстаПользователем,
						?(ТекущийОбъект.ЭтоНовый(), "Описание", "Комментарий"),
						"i" + ?(ТекущийОбъект.ЭтоНовый(),
									"",
							 		Формат(ТекущийОбъект.ИсторияИзменений.Количество(),"ЧГ="))
																		) Тогда
		Отказ = Истина;
		
	КонецЕсли;
	
	//Если Не Отказ Тогда
	//	ПреобразоватьКомментарийВОписание(ТекущийОбъект);
	//КонецЕсли;
						
КонецПроцедуры
&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПродолжитьБП = Ложь;
	ПараметрыЗаписи.Свойство("ПродолжитьБП", ПродолжитьБП);
	
	Если 	ПродолжитьБП = Истина И
			Не ВыполнитьЗадачуБПНаСервере() Тогда
			
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	ЗагрузитьВложенияКомментарияВБазуНаСервере(ТекущийОбъект, Отказ);
	
КонецПроцедуры
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Перем ВопросРешения;
	Перем ВопросПодтверждения;
	Перем ВопросОтмены;
	Перем ОповещатьПоПочте;
	
	// Проверим диалоги
	
	ПараметрыЗаписи.Свойство("ВопросРешения", 		ВопросРешения);
	ПараметрыЗаписи.Свойство("ВопросОтмены", 		ВопросОтмены);
	ПараметрыЗаписи.Свойство("ВопросПодтверждения", ВопросПодтверждения);
	ПараметрыЗаписи.Свойство("ОповещатьПоПочте", 	ОповещатьПоПочте);
	
	Объект.ОповещатьПоПочте = ОповещатьПоПочте <> Ложь;
	
	Если 	ВопросРешения = Истина И
			Вопрос("Задача решена ?
					|после подтверждения задача будет отправлена контролеру на подтверждение.", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если 	ВопросОтмены = Истина И
			Вопрос("Считаете что задача не решена ?
					|после отказа задача будет возвращена разработчику на доработку.", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если 	ВопросПодтверждения = Истина Тогда
		
		Если Вопрос("Подтвержадаете что задача решена ?
					|после подтверждения задача будет считаться выполненой.", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Отказ = Истина;
			Возврат;
		Иначе
			Объект.КонтролерПринимаетЗадачу = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	//ЗагрузитьВложенияКомментарияВБазуНаКлиенте(Отказ);
	
	Если Не Отказ Тогда
		ПреобразоватьКомментарийВОписание();
	КонецЕсли;
			
КонецПроцедуры
&НаКлиенте
Процедура ПередСтартом(Отказ)
	
	//ПреобразоватьКомментарийВОписание();
	
	Отказ = Вопрос("Создать задачу разработчику?", РежимДиалогаВопрос.ДаНет) <> КодВозвратаДиалога.Да;
	
КонецПроцедуры
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	//СобытияСистемы.ОповеститьОЗаписиБизнесПроцесса(Объект.Ссылка);
	//
	////Закрыть(Объект.Ссылка);
	//Закрыть();
	
	// Почемуто на ВЕБе вываливается с ошибкой если закрывать после записи
	
	#Если ВебКлиент Тогда 
		ПодключитьОбработчикОжидания("ЗакрытьФорму",0.1,Истина);
	#Иначе
		Закрыть();
	#КонецЕсли
	
КонецПроцедуры
&НаКлиенте
Процедура ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры


// ВЛОЖЕНИЯ

&НаСервере
Процедура ЗагрузитьВложенияКомментарияВБазуНаСервере(ТекущийОбъект, Отказ)
	
	//Для Каждого Строка Из ВложенияТекстаПользователя Цикл
	//	
	//	ПутьККартинкам 	= "c:\inetpub\wwwroot\img\develop\"; // вот так грубо сказал тут и все, как отрезал
	//	Картинка 		= Строка.Картинка;
	//	ИмяКаринки 		= Строка.Имя + "." + Строка.Формат;
	//	
	//	// Запишем на диск
	//	
	//	Попытка
	//		Картинка.Записать(ПутьККартинкам + ИмяКаринки);
	//	Исключение
	//		опОшибки = ОписаниеОшибки();
	//		Отказ = Истина;
	//		ОбщиеФункции.СообщитьТекст("Ошибка при записи картинки в веб ресурс:
	//				|" + опОшибки);
	//		Возврат;
	//	КонецПопытки;
	//		
	//	// Запишем в базу
	//	
	//	МенЗаписи = РегистрыСведений.ВложенияВЗадачиРазработчикам.СоздатьМенеджерЗаписи();
	//	
	//	МенЗаписи.ЗадачаРазработчику 	= ТекущийОбъект.Ссылка;
	//	МенЗаписи.Имя 					= ИмяКаринки;
	//	МенЗаписи.Вложение 				= Новый ХранилищеЗначения(Картинка.ПолучитьДвоичныеДанные());
	//	
	//	Попытка
	//		МенЗаписи.Записать();
	//	Исключение
	//		опОшибки 	= ОписаниеОшибки();
	//		Отказ 		= Истина;
	//		ОбщиеФункции.СообщитьТекст("Ошибка при записи картинки в базу:
	//		|" + опОшибки);
	//		Возврат;
	//	КонецПопытки;
	//	
	//КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Процедура ЗагрузитьВложенияКомментарияВБазуНаКлиенте(Отказ)
	
	//Перем ТекстHTML;
	//Перем ВложенияHTML;
	//
	//ПутьКHTMLВложениям = "http://93.153.230.178/img/develop/"; // вот так грубо сказал тут и все, как отрезал
	//
	//ВложенияТекстаПользователя.Очистить();
	//ВводТекстаПользователем.ПолучитьHTML(ТекстHTML, ВложенияHTML);
	//
	//Объект.Комментарий = ТекстHTML;
	//
	//Для Каждого Вложение Из ВложенияHTML Цикл
	//	
	//	Картинка = Вложение.Значение;
	//	
	//	Попытка                  // какоето гавно на вебе творится
	//		ФорматСтр = Строка(Картинка.Формат());
	//	Исключение
	//		ФорматСтр = "JPEG";
	//	КонецПопытки;
	//	
	//	// Преобразуем имя вложения
	//	//НовоеИмя = СтрЗаменить(Строка(Новый УникальныйИдентификатор()),"-","_") + "." + Картинка.Формат();
	//	//НовоеИмя = СтрЗаменить(Строка(Новый УникальныйИдентификатор()),"-","_");
	//	НовоеИмя = Строка(Новый УникальныйИдентификатор());
	//	Объект.Комментарий = СтрЗаменить(ТекстHTML, Вложение.Ключ, ПутьКHTMLВложениям + НовоеИмя + "." + ФорматСтр);
	//	
	//	
	//	// Поставим в очередь загрузки на сервак
	//	//ВложенияТекстаПользователя.Добавить(Вложение.Значение, НовоеИмя);
	//	
	//	НовСтрока = ВложенияТекстаПользователя.Добавить();
	//	НовСтрока.Картинка 	= Новый Картинка(Картинка.ПолучитьДвоичныеДанные());
	//	НовСтрока.Имя 		= НовоеИмя;
	//	НовСтрока.Формат	= ФорматСтр;
	//	
	//КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Функция ЗаписатьВложения()
	
	//Отказ = Ложь;
	//ЗагрузитьВложенияКомментарияВБазуНаКлиенте(Отказ);
	//
	//Если Не Отказ Тогда
	//	ЗагрузитьВложенияКомментарияВБазуНаСервере(Объект,Отказ);
	//КонецЕсли;
	//
	//Попытка
	//	Записать();
	//Исключение
	//	опОшибки = ОписаниеОшибки();
	//	ОбщиеФункции.СообщитьТекст("Ошибка доп. записи, часть данных может быть не записана!
	//										|" + опОшибки);
	//	Отказ = Истина;
	//КонецПопытки;
	//
	//Возврат Не Отказ;
	
КонецФункции


// ВЫПОЛНЕНИЕ

//&НаКлиенте
&НаСервере
Функция ПреобразоватьКомментарийВОписание()
	
	Если 	ПустаяСтрока(Объект.Описание) И
			Не ПустаяСтрока(Объект.Комментарий) Тогда
		
		Объект.Описание 	= Объект.Комментарий;
		Объект.Комментарий 	= "";
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ВыполнитьЗадачуБПНаСервере()
	
	ТекЗадача = ФункцииБизнесПроцессов.ТекущаяЗадача(Объект.Ссылка);
	Если ТекЗадача = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЗадачаОбъект = ТекЗадача.ПолучитьОбъект();
	
	Если Не ЗадачаОбъект.ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		ЗадачаОбъект.ВыполнитьЗадачу();
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции
&НаСервере
Функция ПродолжитьЗадачу()
	
	НачатьТранзакцию();
	
	Если 	ЗаписатьОбъектБПНаСервере() И
			ВыполнитьЗадачуБПНаСервере() Тогда
			
		ЗафиксироватьТранзакцию();
		//Возврат БизнесПроцессы.ЗадачаРазработчику.ЗаписатьСтатусПроцесса(Объект.Ссылка);
		Возврат Истина;
		
	Иначе
		
		ОтменитьТранзакцию();
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ЗаписатьОбъектБПНаСервере() Экспорт
	
	ПроцессОбъект = РеквизитФормыВЗначение("Объект");
	
	Если Не ПроцессОбъект.ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		ПроцессОбъект.Записать();
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции
&НаСервере
Функция ЗапуститьБПНаСервере() Экспорт
	
	ПроцессОбъект = РеквизитФормыВЗначение("Объект");
	
	Если Не ПроцессОбъект.ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	//ПроцессОбъект.ДополнительныеСвойства.Вставить("НеПисатьИсторию", Истина);
	
	Попытка
		ПроцессОбъект.Записать();
		ПроцессОбъект.Старт();
	Исключение
		ОбщиеФункции.СообщитьТекст(ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
	//Возврат БизнесПроцессы.ЗадачаРазработчику.ЗаписатьСтатусПроцесса(ПроцессОбъект.Ссылка);
	Возврат Истина;
	
КонецФункции


// КНОПКИ

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	
	
КонецПроцедуры


&НаКлиенте
Процедура КнопкаСформироватьЗадачу(Команда)
	
	//Если Вопрос("Создать задачу разработчику?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
	//	
	//	//ПреобразоватьКомментарийВОписание();
	//	
	//	Попытка
	//		Записать();
	//	Исключение
	//		ОбщиеФункции.СообщитьТекст(ОписаниеОшибки());
	//		Возврат;
	//	КонецПопытки;
	//	
	//	Если ЗапуститьБПНаСервере() Тогда
	//			//ЗаписатьВложения() Тогда
	//		
	//		Модифицированность = Ложь;
	//		СобытияСистемы.ОповеститьОЗаписиБизнесПроцесса(объект.Ссылка, ЭтаФорма);
	//		Закрыть();
	//		
	//		
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура КнопкаОбновитьЗадачу(Команда)
	
	//// Отработаем типовые чтуки
	////ПередЗаписью(Отказ, ПараметрыЗаписи);
	//
	//Отказ = Ложь;
	//
	//Попытка
	//	Записать();
	//Исключение
	//	Возврат;
	//КонецПопытки;
	////
	////Если Не Отказ Тогда
	////
	//////Если ЗаписатьОбъектБПНаСервере() Тогда
	////	
	//	Модифицированность = Ложь;
	////	//СобытияСистемы.ОповеститьОЗаписиБизнесПроцесса(объект.Ссылка, ЭтаФорма);
	//	Закрыть();
	////	
	////КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура КнопкаПодтвердить(Команда)
	
	Записать(Новый Структура("ВопросПодтверждения, ПродолжитьБП, ОповещатьПоПочте", Истина, Истина, Ложь));
	
	//Объект.КонтролерПринимаетЗадачу = Истина;
	//
	//Если Вопрос("Подтвержадаете что задача решена ?
	//				|после подтверждения задача будет считаться выполненой.", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
	//				
	//	Попытка
	//		Записать();
	//	Исключение
	//		ОбщиеФункции.СообщитьТекст(ОписаниеОшибки());
	//		Возврат;
	//	КонецПопытки;
	//				
	//	Если ПродолжитьЗадачу() Тогда
	//		
	//	Модифицированность = Ложь;
	//	СобытияСистемы.ОповеститьОЗаписиБизнесПроцесса(объект.Ссылка, ЭтаФорма);
	//	Закрыть();
	//	
	//КонецЕсли;КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура КнопкаОтклонить(Команда)
	
	Записать(Новый Структура("ВопросОтмены, ПродолжитьБП, ОповещатьПоПочте", Истина, Истина, Ложь));
	
	//Объект.КонтролерПринимаетЗадачу = Ложь;
	//
	//Если 	Вопрос("Считаете что задача не решена ?
	//				|после отказа задача будет возвращена разработчику на доработку.", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
	//				
	//	Попытка
	//		Записать();
	//	Исключение
	//		ОбщиеФункции.СообщитьТекст(ОписаниеОшибки());
	//		Возврат;
	//	КонецПопытки;
	//				
	//		Если ПродолжитьЗадачу() Тогда
	//		
	//	Модифицированность = Ложь;
	//	СобытияСистемы.ОповеститьОЗаписиБизнесПроцесса(объект.Ссылка, ЭтаФорма);
	//	Закрыть();
	//	
	//КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура КнопкаЗадачаРешена(Команда)
	
	Записать(Новый Структура("ВопросРешения, ПродолжитьБП, ОповещатьПоПочте", Истина, Истина, Ложь));
	
	//Если 	Вопрос("Задача решена ?
	//				|после подтверждения задача будет отправлена контролеру на подтверждение.", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
	//				
	//				Попытка
	//		Записать();
	//	Исключение
	//		ОбщиеФункции.СообщитьТекст(ОписаниеОшибки());
	//		Возврат;
	//	КонецПопытки;
	//	
	//	Если	ПродолжитьЗадачу() Тогда
	//		
	//	Модифицированность = Ложь;
	//	СобытияСистемы.ОповеститьОЗаписиБизнесПроцесса(объект.Ссылка, ЭтаФорма);
	//	Закрыть();
	//	
	//КонецЕсли;КонецЕсли;

КонецПроцедуры
&НаКлиенте
Процедура КнопкаПредварительныйПросмотрКомментария(Команда)
	
	ОткрытьФорму("ОбщаяФорма.страницаHTML", Новый Структура("ТелоHTML", Объект.Комментарий));
		
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВсеРеквизиты(Команда)
	
	ОткрытьФорму("БизнесПроцесс.ЗадачаРазработчику.Форма.ФормаВсеРеквизиты", 
				Новый Структура(	"Ключ", 
									Параметры.Ключ));
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеВперед(Команда)
	
	Элементы.Описание.Вперед();
	
КонецПроцедуры
&НаКлиенте
Процедура ОписаниеНазад(Команда)
	
	Элементы.Описание.Назад();
	
КонецПроцедуры
&НаСервере
Процедура ПерейтиВНачало()
	
	Описание = 
	"<HTML><HEAD>
	|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
	|<META name=GENERATOR content=""MSHTML 8.00.7600.16588""></HEAD>
	|<body bgcolor=""#FCFAEB"">
	| " + Объект.Описание + "
	|</body>
	|</HTML>
	|";
	
КонецПроцедуры
&НаКлиенте
Процедура ВернутьсяВСамоеНачало(Команда)
	
	//ОбновитьОписание();
	
	ПерейтиВНачало();
	
	
КонецПроцедуры
&НаКлиенте
Процедура ОткрытьВОтдельномОкнеОписание(Команда)
	
	ОткрытьФорму("ОбщаяФорма.страницаHTML", Новый Структура("ТелоHTML", Объект.Описание), ЭтаФорма);
	
КонецПроцедуры


// РАСЧЕТ

&НаКлиенте
Процедура ЦенаЗаЧасПриИзменении(Элемент)
	
	Если Авторасчет Тогда
		
		Объект.Стоимость = Объект.Часов * Объект.ЦенаЗаЧас;
		
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ЧасовПриИзменении(Элемент)
	
	Если Авторасчет Тогда
		
		Объект.Стоимость = Объект.Часов * Объект.ЦенаЗаЧас;
		
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура СтоимостьПриИзменении(Элемент)
	
	Если Авторасчет Тогда
		
		Объект.ЦенаЗаЧас = ?(Объект.Часов = 0, 0, Объект.Стоимость / Объект.Часов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	
	Перем ТекстHTML;
	Перем ВложенияHTML;
	
	ВводТекстаПользователем.ПолучитьHTML(ТекстHTML, ВложенияHTML);
	
	Объект.Комментарий = ТекстHTML;
	
КонецПроцедуры

&НаКлиенте
Процедура КакВсатвитьКартинкуНадписьНажатие(Элемент)
	
	ОткрытьФорму("ОбщаяФорма.страницаHTML", Новый Структура("ТелоHTML", 
					"<P>Вставить картинку можно:</P>
					|<UL>
					|<LI>На <STRONG>тонком клиенте</STRONG> - достаточно нажать ""Все действия"" -> ""Вставить картинку"" и выбрать ее. 
					|<LI>На <STRONG>веб клиенте</STRONG> к сожалению сейчас это не возможно, кнопка сработает но изображение не передаста в базу, изза этого оно будет пустое. Поэтому ее можно добавить только вручную. Так как текст поддерживает теги, то для этого нужно вставить тэг изображения &lt;img&gt;. 
					|<UL>
					|<LI>Например <FONT color=#0000ff>&lt;img src='http://93.153.230.178/img/develop/картинка.JPEG'&gt;</FONT></LI></UL></LI></UL></BODY></HTML>"), 
					ЭтаФорма);
	
КонецПроцедуры

