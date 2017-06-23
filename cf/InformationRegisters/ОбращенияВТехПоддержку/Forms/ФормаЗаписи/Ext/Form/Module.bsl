﻿&НаКлиенте
Перем БылаЗапись; // контролирует была ли нажата кнопка "Записать". Если для нового элемента НЕ была нажата кнорка "Записать" - то надо удалить эту запись из базы, т.к. она пустая, была создана для выдачи номера.

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.КнопкаОтправить.Видимость 	= Не ТолькоПросмотр;
	
	Если Запись.Дата = '00010101' Тогда ЭтоНовый = Истина;
		
		Запрос = Новый Запрос("ВЫБРАТЬ МАКСИМУМ(Номер) ПоследнийНомер ИЗ РегистрСведений.ОбращенияВТехПоддержку");
		Выборка = Запрос.Выполнить().Выбрать();
		Номер = 1;
		Если Выборка.Следующий() Тогда
			Номер = Выборка.ПоследнийНомер + Номер;
		КонецЕсли;
		
		Запись.Номер = Номер;
		Запись.Дата = ТекущаяДата();
		Запись.Заявитель = ПараметрыСеанса.ТекущийПользователь;
		
		Попытка
			Записать();	
		Исключение
			Отказ = Истина;
			Возврат;
		КонецПопытки;
		
	КонецЕсли;	
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗакрытиемНаСервере()
	
	МенеджерЗаписи = РегистрыСведений.ОбращенияВТехПоддержку.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Запись);
	МенеджерЗаписи.Удалить();

КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если НЕ БылаЗапись И ЭтоНовый Тогда
		
		ПередЗакрытиемНаСервере();
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	БылаЗапись = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	БылаЗапись = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьДляИзменения(Команда)
	Запись.ОтправленоДляИзменения = Истина;
	Если Записать() Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	Запись.Выполнено = Истина;
	Запись.Исполнитель = НастройкиПользователя.ТекущийПользователь();
	Запись.ДатаВыполнения = ТекущаяДата();
	Если ПроверитьЗаполнение() Тогда	
			ТекстОшибки = "";
			Если ОтправкаПисьмаЗаявителю(ТекстОшибки) Тогда
				ПоказатьОповещениеПользователя(,,"Письмо заявителю успешно отправлено");
				Записать()
			Иначе
				ПоказатьОповещениеПользователя(,,ТекстОшибки);
				
				Возврат
			КонецЕсли;
			Закрыть();
	КонецЕсли;
КонецПроцедуры

Функция  ОтправкаПисьмаЗаявителю(ТекстОшибки)
	// Адрес заявителя
	УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	//УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.НайтиПоНаименованию("POSTMAN");
	АдресаЗявителя = Запись.Заявитель.Почта;
	Попытка
		ПараметрыПисьма = Новый Структура;
		ПараметрыПисьма.Вставить("Кому", АдресаЗявителя);
		ПараметрыПисьма.Вставить("Тема", "Заявка на изменение данных в 1С");
		Текст = "Добрый день! &ПС
		|Заявка №&Номер от &Дата0  (&Заказ) по проблеме &Описание выполнена :&ПС
		| &Исполнитель &ПС
		| &Комментарий &ПС
		| &ДатаВыполнения.&ПС
		|&ПС
		|Спасибо за обращение!";
		
		Текст = СтрЗаменить(Текст,"&ПС",Символы.ПС);
		Текст = СтрЗаменить(Текст,"&Номер",Запись.Номер);
		Текст = СтрЗаменить(Текст,"&Дата0",Запись.Дата);
		Текст = СтрЗаменить(Текст,"&Заказ",Запись.Заказ);
		Текст = СтрЗаменить(Текст,"&Описание",Запись.Описание);
		Текст = СтрЗаменить(Текст,"&Исполнитель",Запись.Исполнитель);
		Текст = СтрЗаменить(Текст,"&Комментарий",Запись.Комментарий);
		Текст = СтрЗаменить(Текст,"&ДатаВыполнения",Запись.ДатаВыполнения);
		ПараметрыПисьма.Вставить("Тело", Текст); 
		ЭлектроннаяПочта.ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
	Исключение
		ТекстОшибки = "Не удалось отправить письмо заявителю/" + ОписаниеОшибки();
		Возврат Ложь;		
	КонецПопытки;
	Возврат Истина;

КонецФункции	


&НаКлиенте
Процедура ОтдатьВРазборку(Команда)
	Парам = Новый Структура("Заказ",Запись.Заказ);
	ОткрытьФорму("БизнесПроцесс.ОтменаСборки.Форма.Задача_СоздатьЗаданияНаРазборку",Парам);
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	Элементы.ГруппаОтправить.Видимость = ЭтоНовый;
	Элементы.КнопкаОтправить.КнопкаПоУмолчанию = ЭтоНовый;
	
	Элементы.Описание.ТолькоПросмотр = Запись.Выполнено;
	Элементы.Заказ.ТолькоПросмотр = Запись.Выполнено;
	Элементы.ТипЗапроса.ТолькоПросмотр = Запись.Выполнено;
	Элементы.ТипЗаявки.ТолькоПросмотр = Запись.Выполнено;
	ЭтоИсполнитель = РольДоступна("ПолныеПраваВОбласти") ИЛИ РольДоступна("ПолныеПрава") ИЛИ РольДоступна("УправлениеСборкойЗаказа");
	
	Элементы.Готово.Видимость = НЕ ЭтоНовый И НЕ Запись.Выполнено И ЭтоИсполнитель;
	Элементы.Записать.Видимость = НЕ ЭтоНовый;
	
	Элементы.ГруппаКомментарий.ТолькоПросмотр = НЕ ЭтоИсполнитель;
	
	Элементы.ОтдатьВРазборку.Видимость = НЕ ЭтоНовый И НЕ Запись.Выполнено И ЭтоИсполнитель И Запись.ТипЗаявки = ПредопределенноеЗначение("Перечисление.ТипыОбращенийВТехПоддержку.ЗапросНаСклад") ;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗаявкиПриИзменении(Элемент)
	УправлениеВидимостьюДоступностью();
КонецПроцедуры




