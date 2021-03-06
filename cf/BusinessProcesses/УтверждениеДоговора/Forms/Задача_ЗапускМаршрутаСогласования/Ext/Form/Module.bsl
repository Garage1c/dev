﻿&НаКлиенте
Процедура УправлениеВидимостьюЭлементовФормы()
	
	Если Объект.Выполнена Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
		ЭтаФорма.Элементы.ГруппаКнопки.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры	


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеВидимостьюЭлементовФормы();
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.БизнесПроцесс) Тогда
		Договор = Объект.БизнесПроцесс.Договор;
		Контрагент = Договор.Владелец;
	Иначе Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();	
	КонецЕсли;

	Комментарии = ФункцииБизнесПроцессов.ПолучитьТекстКомментариевHTML(Объект.БизнесПроцесс);
	Элементы.Комментарии.Видимость = НЕ ПустаяСтрока(Комментарии);
	ОбновитьВидимостьПрикрепленныхФайловНаСервере();
	
КонецПроцедуры


&НаКлиенте
Процедура ВыполнитьЗадачу(Команда)
	
	Если ВыполнитьЗадачуНаСервере() Тогда
		
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
	
	Возврат истина;
	
КонецФункции


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