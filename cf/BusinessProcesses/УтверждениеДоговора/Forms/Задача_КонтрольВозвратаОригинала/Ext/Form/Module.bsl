﻿&НаКлиенте
Процедура УправлениеВидимостьюЭлементовФормы()
	
	Если Объект.Выполнена Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
		ЭтаФорма.Элементы.ГруппаКнопки.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры	


&НаКлиенте
Процедура КонтрольВозвратаОригинала(Команда)
	
	Если ВыполнитьЗадачуНаСервере() Тогда
		
		ПрикрепитьФайлыКДоговоруНаКлиенте();
		Модифицированность = Ложь;
		ФункцииФормЗадач.ПослеЗаписи(Объект, ЭтаФорма, Новый Структура);
		Закрыть();
	КонецЕсли;

КонецПроцедуры


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
	
	Возврат Истина;
	
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеВидимостьюЭлементовФормы();
	
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


#Область Прикрепить_файлы_к_договору

&НаКлиенте
Процедура ПрикрепитьФайлыКДоговоруНаКлиенте()
	
	Если НЕ Договор.Пустая() Тогда
		ПрикрепитьФайлыКДоговоруНаСервере();
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПрикрепитьФайлыКДоговоруНаСервере()
	
	ФайлыДляДоговора = НайтиПрикрепленныеФайлыНаСервере();
	
	Если ФайлыДляДоговора <> Неопределено Тогда
		
		Для Каждого Файл Из ФайлыДляДоговора Цикл
			
			НовыйФайл = Справочники.ХранилищеФайловДоговоров.СоздатьЭлемент();
			НовыйФайл.ИмяФайла  = Файл.ИмяФайла;
			НовыйФайл.Хранилище = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Файл.АдресФайлаВХранилище));
			НовыйФайл.Владелец  = Договор.Ссылка;
			
			Если НЕ ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(НовыйФайл) Тогда
				Возврат;
			КонецЕсли;
			
		КонецЦикла;	
		
	КонецЕсли;	
	
КонецПроцедуры	


&НаСервере
Функция НайтиПрикрепленныеФайлыНаСервере()

	Путь = Константы.ПутьКХранилищуПрикрепленныхФайлов.Получить();
	Если ПустаяСтрока(Путь) Тогда
		ОбщиеФункции.СообщитьТекст("Не задан параметр ""Путь к хранилищу прикрепленных файлов""");
		Возврат Неопределено;
	КонецЕсли;	
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ПрикрепленныеФайлы.guid,
	|	ПрикрепленныеФайлы.Имя,
	|	ПрикрепленныеФайлы.Автор,
	|	ПрикрепленныеФайлы.ПутьВХранилище
	|ИЗ
	|	РегистрСведений.ПрикрепленныеФайлы КАК ПрикрепленныеФайлы
	|ГДЕ
	|	ПрикрепленныеФайлы.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() <> 0 Тогда
		
		ФайлыДляДоговора = Новый Массив;
		
		Пока Выборка.Следующий() Цикл
			ИмяФайла 		= Выборка.Имя;
			АдресФайлаВХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Путь + Выборка.ПутьВХранилище));
			ФайлыДляДоговора.Добавить(Новый Структура("ИмяФайла, АдресФайлаВХранилище", ИмяФайла, АдресФайлаВХранилище));	
		КонецЦикла;
		
		Возврат ФайлыДляДоговора;
		
	Иначе
		ОбщиеФункции.СообщитьТекст("Нет файлов для прикрепления к договору");
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

#КонецОбласти
