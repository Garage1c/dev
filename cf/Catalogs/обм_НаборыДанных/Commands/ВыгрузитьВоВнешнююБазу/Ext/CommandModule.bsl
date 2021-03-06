﻿
&НаСервере
Функция ПолучитьСписокОбменовДляВыгрузки()
	
	Список = Новый СписокЗначений;
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.обм_ОбменДанными ГДЕ НЕ ПометкаУдаления");
	Список.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	Возврат Список;
	
КонецФункции
&НаСервере
Функция ВыгрузитьНаСервере(Ссылки, ОбменДанными)
	
	Возврат обм_Обмен.Выгрузить(Ссылки, ОбменДанными);
	
	//КэшДанные = Новый Соответствие;
	//
	//// Определим набор данных
	//
	//Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.обм_НаборыДанных.ОбрабатываемыеТипы ГДЕ ПустаяСсылка ССЫЛКА " + Ссылки[0].Метаданные().ПолноеИмя() + "");
	//Выборка = Запрос.Выполнить().Выбрать();
	//
	//Если Выборка.Следующий() Тогда
	//	
	//	Данные = обм_Обмен.ВычислитьСтруктуруПоНаборуДанных(Выборка.Ссылка, Ссылки, КэшДанные);
	//	
	//	// теперь отправим данные
	//	
	//	Если Данные = Неопределено Тогда
	//		Сообщить("Нет данных для выгрузки"); 
	//		Возврат Ложь;
	//	Иначе
	//		ДанныеJSON = обм_Обмен.ПреобразоватьВJSON(Выборка.Ссылка, Данные, КэшДанные);
	//		Возврат обм_Обмен.ОтправитьНаборДанных(Выборка.Ссылка, ДанныеJSON, КэшДанные); КонецЕсли;
	//Иначе
	//	
	//	Сообщить("Не найден набор данных для выгрузки типа " + ТипЗнч(Ссылки[0])); 
	//	Возврат Ложь; КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбораБазыПриемника(ВыбранныйЭлемент, Параметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Если ВыгрузитьНаСервере(Параметры.Ссылки, ВыбранныйЭлемент.Значение) Тогда
			
			ПоказатьОповещениеПользователя("Данные выгруженны",,?(Параметры.Ссылки.Количество() = 1, Параметры.Ссылки[0], "в количестве " + Параметры.Ссылки.Количество()));
			
		Иначе
			ПоказатьПредупреждение(,"Произошла ошибка",,"Выгрузка в " + ВыбранныйЭлемент.Значение); КонецЕсли; КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СписокВыгрузок = ПолучитьСписокОбменовДляВыгрузки();
	Если СписокВыгрузок.Количество() Тогда
		СписокВыгрузок.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("ОбработкаВыбораБазыПриемника", ЭтотОбъект, Новый Структура("Ссылки", ПараметрКоманды)), СписокВыгрузок); КонецЕсли;
	
КонецПроцедуры
