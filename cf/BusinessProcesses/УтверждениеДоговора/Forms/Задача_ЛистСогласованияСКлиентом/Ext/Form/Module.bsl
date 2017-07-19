﻿&НаКлиенте
Процедура УправлениеВидимостьюЭлементовФормы()
	
	Если Объект.Выполнена Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
		ЭтаФорма.Элементы.ГруппаКнопки.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры	


&НаКлиенте
Процедура ЛистСогласования(Команда)
	
	Если 	ЛистСогласованияНаСервере(Ложь, Ложь) И
		ВыполнитьЗадачуНаСервере() Тогда
		
		Модифицированность = Ложь;
		ФункцииФормЗадач.ПослеЗаписи(Объект, ЭтаФорма, Новый Структура);
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция ЛистСогласованияНаСервере(ВернутьИнициатору, ВернутьНаШагНазад)
	
	Процесс = Объект.БизнесПроцесс.ПолучитьОбъект();
	Процесс.ВернутьИнициатору = ВернутьИнициатору;
	Процесс.ВернутьНаШагНазад = ВернутьНаШагНазад;
	
	Попытка
		Процесс.Записать();
	Исключение
		стрОшибки = ОписаниеОшибки();
		ОбщиеФункции.СообщитьТекст("Ошибка при записи бизнес процесса
		|" + стрОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат истина;
	
КонецФункции


&НаСервере
Функция ВыполнитьЗадачуНаСервере()
	
	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");
	
	Попытка
		ЗадачаОбъект.ВыполнитьЗадачу();
	Исключение
		стрОшибки = ОписаниеОшибки();
		ОбщиеФункции.СообщитьТекст("Ошибка при выполнении задачи
		|" + стрОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат истина;
	
КонецФункции


&НаКлиенте
Процедура ВернутьИнициатору(Команда)
	
	Если 	ЛистСогласованияНаСервере(Истина, Ложь) И
		ВыполнитьЗадачуНаСервере() Тогда
		
		Модифицированность = Ложь;
		ФункцииФормЗадач.ПослеЗаписи(Объект, ЭтаФорма, Новый Структура);
		Закрыть();
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ВернутьНаШагНазад(Команда)
	
	Если 	ЛистСогласованияНаСервере(Ложь, Истина) И
		ВыполнитьЗадачуНаСервере() Тогда
		
		Модифицированность = Ложь;
		ФункцииФормЗадач.ПослеЗаписи(Объект, ЭтаФорма, Новый Структура);
		Закрыть();
	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.БизнесПроцесс) Тогда
		Договор = Объект.БизнесПроцесс.Договор;
	Иначе Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();	
	КонецЕсли;
	
	Комментарии = ФункцииБизнесПроцессов.ПолучитьТекстКомментариевHTML(Объект.БизнесПроцесс);
	Элементы.Комментарии.Видимость = НЕ ПустаяСтрока(Комментарии);
	ОбновитьВидимостьПрикрепленныхФайловНаСервере();
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеВидимостьюЭлементовФормы();

КонецПроцедуры


#Область Прикрепленные_файлы

&НаКлиенте
Процедура УдалитьПрикрепленныеФайлыНажатие(Элемент)
	
	ПрикрепленныеФайлыКлиент.УдалитьНажатие(Объект.Ссылка, ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепленныеФайлыНажатиеСкрепка(Элемент)
	
	ПрикрепленныеФайлыКлиент.НажатиеСкрепка(Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПрикрепленныйФайл(Элемент)
	
	ПрикрепленныеФайлыКлиент.ОткрытьПрикрепленныйФайл(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПрикрееленныеФайлы(Элемент)
	
	ПрикрепленныеФайлыКлиент.ПоказатьПрикрепленныеФайлы(Объект.Ссылка, ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьПрикрепленныхФайловНаСервере()
	
	ПрикрепленныеФайлы.Иницилизировать(Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидимостьПрикрепленныхФайлов() Экспорт
	
	ОбновитьВидимостьПрикрепленныхФайловНаСервере();
	
КонецПроцедуры

#КонецОбласти


#Область Отправить_письмо_контрагенту

&НаСервереБезКонтекста
Функция НайтиПочтуКонтрагента(Контрагент)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ПредставлениеКонтактнойИнформации.Объект КАК Справочник.Контрагенты) КАК Контрагент,
	|	ПредставлениеКонтактнойИнформации.Представление Как Почта
	|ИЗ
	|	РегистрСведений.ПредставлениеКонтактнойИнформации КАК ПредставлениеКонтактнойИнформации
	|ГДЕ
	|	ПредставлениеКонтактнойИнформации.Вид.Наименование ПОДОБНО ""%Email контрагент%""
	|	И ПредставлениеКонтактнойИнформации.Объект = &Контрагент";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат СокрЛП(Выборка.Почта);	
	Иначе
		Возврат Неопределено;	
	КонецЕсли;	
	
КонецФункции	


&НаКлиенте
Процедура ОтправитьПоПочте(Команда)
	
	ФайлыДляПочты = ОтправитьПоПочтеНаСервере();
	
	Если ФайлыДляПочты <> Неопределено Тогда
		Вложения = Новый Массив;
		Для Каждого Файл Из ФайлыДляПочты Цикл
			ДвДанные = ПолучитьИзВременногоХранилища(Файл.Адрес);	
			Попытка
				ДвДанные.Записать(КаталогВременныхФайлов() + Файл.Имя);
			Исключение
				ОбщиеФункции.СообщитьТекст("Ошибка записи файла " + ОписаниеОшибки());
				Возврат;
			КонецПопытки;
			Вложения.Добавить(Новый Структура("ИмяФайла, ПолноеИмяФайла", Файл.Имя, КаталогВременныхФайлов() + Файл.Имя));
		КонецЦикла;
		
	Иначе
		
		Возврат;
		
	КонецЕсли;	

	АдресПочты = НайтиПочтуКонтрагента(Контрагент);
	Если АдресПочты = Неопределено Тогда
		АдресПочты = "";	
	КонецЕсли;
	
	Кому = Новый Массив;
	СтруктураКому = Новый Структура;
	СтруктураКому.Вставить("Контрагент", Неопределено);
	СтруктураКому.Вставить("Почта" , АдресПочты);
	Кому.Добавить(СтруктураКому);
	
	Если ФайлыДляПочты <> Неопределено Тогда
		ОткрытьФорму("Документ.Письмо.Форма.Письмо2", Новый Структура("Вложения, УдалитьФайлыПослеОтправки, Кому", Вложения, Истина ,Кому));
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция ОтправитьПоПочтеНаСервере()
	
	СписокФайлов = ПрикрепленныеФайлы.ПолучитьСписокФайловДляВыбора(Объект.Ссылка);
	
	Если СписокФайлов.Количество() = 0 Тогда
		ОбщиеФункции.СообщитьТекст("Нет прикрепленных файлов для отправки");
		Возврат Неопределено;
	КонецЕсли;	
		
	ФайлыДляПочты = Новый Массив;
	Для Каждого ЭлементаСписка из СписокФайлов Цикл
		ФайлыДляПочты.Добавить(ПрикрепленныеФайлы.ПолучитьФайлИзХранилища(УвеличитьГуид(ЭлементаСписка.Значение))); //"Имя, Раширение, Адрес"
	КонецЦикла;
	
	Возврат ФайлыДляПочты;
	 	
	//Путь = Константы.ПутьКХранилищуПрикрепленныхФайлов.Получить();
	//Если ПустаяСтрока(Путь) Тогда
	//	ОбщиеФункции.СообщитьТекст("Не задан параметр ""Путь к хранилищу прикрепленных файлов""");
	//	Возврат Неопределено;
	//КонецЕсли;	
	//
	//Запрос = Новый Запрос("ВЫБРАТЬ
	//|	ПрикрепленныеФайлы.guid,
	//|	ПрикрепленныеФайлы.Имя,
	//|	ПрикрепленныеФайлы.Автор,
	//|	ПрикрепленныеФайлы.ПутьВХранилище
	//|ИЗ
	//|	РегистрСведений.ПрикрепленныеФайлы КАК ПрикрепленныеФайлы
	//|ГДЕ
	//|	ПрикрепленныеФайлы.Ссылка = &Ссылка");
	//Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	//Выборка = Запрос.Выполнить().Выбрать();
	//
	//Если Выборка.Количество() <> 0 Тогда
	//	
	//	ФайлыДляПочты = Новый Массив;
	//	
	//	Пока Выборка.Следующий() Цикл
	//		ИмяФайла 		= Выборка.Имя;
	//		АдресФайлаВХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Путь + Выборка.ПутьВХранилище));
	//		ФайлыДляПочты.Добавить(Новый Структура("ИмяФайла, АдресФайлаВХранилище", ИмяФайла, АдресФайлаВХранилище));	
	//	КонецЦикла;
	//	
	//	Возврат ФайлыДляПочты;
	//	
	//Иначе
	//	ОбщиеФункции.СообщитьТекст("Нет прикрепленных файлов для отправки");
	//	Возврат Неопределено;
	//КонецЕсли;	
	
КонецФункции


Функция УвеличитьГуид(стр)
	
	Возврат Лев(стр, 8) + "-" + Сред(стр, 9, 4) + "-" + Сред(стр, 13, 4) + "-" + Сред(стр, 17, 4) + "-" + Прав(Стр, 12);	// 8d583a41-0e7c-4a76-87dd-cba4f4310365
	
КонецФункции

#КонецОбласти

