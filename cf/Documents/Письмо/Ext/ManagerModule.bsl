﻿
Функция СформироватьПараметрыПисьма(Письмо,
									знач ПриведенныйПочтовыйАдрес,
                                    знач Пароль = Неопределено)
	// Проверяет возможность отправления письма и если
	// это возможно - формирует параметры отправки
	//

	ПараметрыПисьма = Новый Структура;
	
	//Если ЗначениеЗаполнено(Пароль) Тогда
	//	ПараметрыПисьма.Вставить("Пароль", Пароль);
	//КонецЕсли;
	
	Если ЗначениеЗаполнено(ПриведенныйПочтовыйАдрес) Тогда
		ПараметрыПисьма.Вставить("Кому", ПриведенныйПочтовыйАдрес);
	КонецЕсли;
	
	//Если ЗначениеЗаполнено(АдресОтвета) Тогда
	//	ПараметрыПисьма.Вставить("АдресОтвета", АдресОтвета);
	//КонецЕсли;
	
	Если ЗначениеЗаполнено(Письмо.Тема) Тогда
		ПараметрыПисьма.Вставить("Тема", Письмо.Тема);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Письмо.Текст) Тогда
		ПараметрыПисьма.Вставить("Тело", Письмо.Текст);
	КонецЕсли;

	Если ЗначениеЗаполнено(Письмо.Текст) Тогда
		ПараметрыПисьма.Вставить("ТипТекста", Письмо.ТипТекста);
	КонецЕсли;

	
	Возврат ПараметрыПисьма;
	
КонецФункции

Функция ПослатьПисьмо(Письмо, стрОшибки = "") Экспорт
	
	Попытка
		ПриведенныйПочтовыйАдрес = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(Письмо.Кому);
	Исключение
		стрОшибки = ОбщегоНазначенияКлиентСервер.ПолучитьПредставлениеОписанияОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	Пароль 			= Письмо.УчетнаяЗапись.Пароль;
	ПараметрыПисьма = СформироватьПараметрыПисьма(Письмо, ПриведенныйПочтовыйАдрес);
	
	Если ПараметрыПисьма = Неопределено Тогда
		стрОшибки = НСтр("ru = 'Ошибка формирования параметров почтового сообщения'");
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		ЭлектроннаяПочта.ОтправитьПочтовоеСообщение(Письмо.УчетнаяЗапись, ПараметрыПисьма);
	Исключение
		стрОшибки = ОбщегоНазначенияКлиентСервер.ПолучитьПредставлениеОписанияОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции


Функция ПослатьПисьмо_Нов(ДокПисьмо, стрОшибки = "") Экспорт

 	Попытка
		ПриведенныйПочтовыйАдрес = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ДокПисьмо.Кому);
	Исключение
		стрОшибки = ОбщегоНазначенияКлиентСервер.ПолучитьПредставлениеОписанияОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	Пароль 			= ДокПисьмо.УчетнаяЗапись.Пароль;
	ПараметрыПисьма = СформироватьПараметрыПисьма(ДОкПисьмо, ПриведенныйПочтовыйАдрес);
	
	Если ПараметрыПисьма = Неопределено Тогда
		стрОшибки = НСтр("ru = 'Ошибка формирования параметров почтового сообщения'");
		Возврат Ложь;
	КонецЕсли;
	

		
			
	Если ТипЗнч(ДокПисьмо.Кому) = Тип("Строка") Тогда
		Кому = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ДокПисьмо.Кому);
	КонецЕсли;
	
	Если ТипЗнч(ДокПисьмо.Копия) = Тип("Строка") Тогда
		Копия = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ДокПисьмо.Копия);
	КонецЕсли;

		
	Письмо = Новый ИнтернетПочтовоеСообщение;
	
	Письмо.Тема = ДокПисьмо.Тема;
	

// добавляем текст
    
    ТипТекста = Неопределено;
	Текст = Письмо.Тексты.Добавить(ПараметрыПисьма.Тело);
	Если ПараметрыПисьма.Свойство("ТипТекста", ТипТекста) Тогда
		Если ТипЗнч(ТипТекста) = Тип("Строка") Тогда
			Если      ТипТекста = "HTML" Тогда
				Текст.ТипТекста = ТипТекстаПочтовогоСообщения.HTML;
				
				 
			ИначеЕсли ТипТекста = "RichText" Тогда
				Текст.ТипТекста = ТипТекстаПочтовогоСообщения.РазмеченныйТекст;
			Иначе
				Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
			КонецЕсли;
		ИначеЕсли ТипЗнч(ТипТекста) = Тип("ПеречислениеСсылка.ТипыТекстовЭлектронныхПисем") Тогда
			Если      ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML
				  ИЛИ ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTMLСКартинками Тогда
				Текст.ТипТекста = ТипТекстаПочтовогоСообщения.HTML;
			ИначеЕсли ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.РазмеченныйТекст Тогда
				Текст.ТипТекста = ТипТекстаПочтовогоСообщения.РазмеченныйТекст;
			Иначе
				Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
			КонецЕсли;
		Иначе
			Текст.ТипТекста = ТипТекста;
		КонецЕсли;
	Иначе
		Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	КонецЕсли;


	Для Каждого ПочтовыйАдресПолучателя Из Кому Цикл
		Получатель = Письмо.Получатели.Добавить(ПочтовыйАдресПолучателя.Адрес);
		Получатель.ОтображаемоеИмя = ПочтовыйАдресПолучателя.Представление;
	КонецЦикла;
	    //письмо.Копии.
	Для Каждого ПочтовыйАдресПолучателяКопия Из Копия Цикл
		ПолучательКопия = Письмо.Копии.Добавить(ПочтовыйАдресПолучателяКопия.Адрес);
	КонецЦикла;
		
	
	// добавляем к письму имя отправителя
	Письмо.ИмяОтправителя              = ДокПисьмо.УчетнаяЗапись.ИмяПользователя;
	Письмо.Отправитель.ОтображаемоеИмя = ДокПисьмо.УчетнаяЗапись.ИмяПользователя;
	Письмо.Отправитель.Адрес           = ДокПисьмо.УчетнаяЗапись.АдресЭлектроннойПочты;
	
	Профиль = ЭлектроннаяПочта.СформироватьИнтернетПрофиль(ДокПисьмо.УчетнаяЗапись);
		
	// Добавим вложения
	
	Инд = -1;
	Для Каждого Вложение Из ДокПисьмо.Вложения Цикл Инд = Инд + 1;
		
		ДвоичныеДанные = Вложение.Вложение.Получить();
		//?(Не ПустаяСтрока(Вложение.ПолноеИмяФайла), Новый ДвоичныеДанные(Вложение.ПолноеИмяФайла), ПолучитьИзВременногоХранилища(ПолучитьАдресДанныхПоИндексу(Инд)));
		
		Если ДвоичныеДанные = Неопределено Тогда
			ОбщиеФункции.СообщитьТекст("Не удалось получить вложение, повторите попытку"); Возврат ложь КонецЕсли;
		
		Письмо.Вложения.Добавить(ДвоичныеДанные, Вложение.ИмяФайла); КонецЦикла;

			
	Соединение = Новый ИнтернетПочта;
	
	Соединение.Подключиться(Профиль);
	
	Попытка
		Соединение.Послать(Письмо);
	Исключение
		стрОшибки = "Не удалось отправить письмо: " + ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;		
	
	Соединение.Отключиться();
	
	Возврат Истина;//Письмо.ИдентификаторСообщения;

КонецФункции

