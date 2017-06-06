﻿
&НаКлиенте
Процедура ВидимостьАдресации(Форма) Экспорт
	
	Форма.Элементы.Адресация.Видимость = Форма.Элементы.Найти("ПоказатьСкрытьАдресацию").Пометка;
	 //Форма.КоманднаяПанель.ПодчиненныеЭлементы.ПоказатьСкрытьАдресацию.Пометка;

КонецПроцедуры

&НаКлиенте
Процедура ВидимостьКомментария(Элементы, Объект) Экспорт
	
	ЕстьКомментарий = Не ПустаяСтрока(Объект.Комментарий);
	
	Элементы.ГруппаДобавитьКомментарий.Видимость 		= Не Объект.Выполнена И Не ЕстьКомментарий;
	Элементы.ГруппаРедактированиеКомментария.Видимость 	= ЕстьКомментарий;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(Объект, Форма, ПараметрыЗаписи) Экспорт
	
	// Оповести что записали задачу
	
	Оповестить(СобытияСистемы.Событие_ЗаписанаЗадача(), 
					новый Структура("БизнесПроцесс", Объект.БизнесПроцесс), 
				Форма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Объект, Форма, Отказ) Экспорт
	
	ВидимостьАдресации(Форма);
	//ВидимостьКомментария(Форма.Элементы, Объект);
	
	Если Объект.Выполнена Тогда
		Форма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры


// СБОРКА

&НаСервере
Процедура ЗаполнитьПоСборочномуЛисту(Форма, ЗадачаОбъект, Товары) Экспорт
	
	// Заполняет параметрами из сборочного листа,
	// если сборочного листа нет, тогда рассчитвает из того что придется
	
	Если ЗадачаОбъект.БизнесПроцесс.СборочныйЛист.Пустая() Тогда
	
		СостояниеСобрано = Перечисления.СостояниеСборкиЗаказа.Собрано;
		текВес = 0; текОбъем = 0; текПоз = 0;
		
		Для Каждого Строка Из Товары Цикл
			Если Строка.Собрано И Строка.Состояние <> СостояниеСобрано Тогда текПоз = текПоз + 1;
			
				Коэффициент = ?(НЕ Строка.Упаковка.Пустая(), Строка.Упаковка.Коэффициент * Строка.Количество, Строка.Количество);
				
				текВес = текВес + Строка.Номенклатура.Вес * Коэффициент;
				текОбъем = текОбъем + Строка.Номенклатура.Объем * Коэффициент; КонецЕсли; КонецЦикла;                  	
		
		Если Не Форма.Вес Тогда 				Форма.Вес 					= текВес КонецЕсли;
		Если Не Форма.Объем Тогда 				Форма.Объем 				= текОбъем КонецЕсли;
		Если Не Форма.КоличествоПозиций Тогда 	Форма.КоличествоПозиций 	= текПоз КонецЕсли;
		
	Иначе
		
		Сбор = ЗадачаОбъект.БизнесПроцесс.СборочныйЛист;
		
		Форма.Вес 					 = Сбор.Вес;
		Форма.Объем 				 = Сбор.Объем;
		Форма.КоличествоМест		 = Сбор.КоличествоМест;
		Форма.КоличествоПозиций		 = Сбор.КоличествоПозиций;
		Форма.ЯчейкаСобранногоТовара = Сбор.ЯчейкаСобранногоТовара; КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьШапкуСборочногоЛиста(Форма, ТекущийОбъект, Отказ) Экспорт
	
	// Запишем сборочный лист
	
	Если Не Отказ И Не ФункцииБизнесПроцессов.ЗаполнитьСборочныйЛистЗадачи(
				ТекущийОбъект, Новый Структура("Шапка", Новый Структура(
					"Заказ, Вес, Объем, КоличествоПозиций",
					Форма.Заказ, Форма.Вес, Форма.Объем, Форма.КоличествоПозиций))) Тогда
					
		Отказ = Истина; КонецЕсли;
	
КонецПроцедуры

