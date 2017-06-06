﻿
&НаКлиенте
Перем РеквизитыВладельца;

&НаСервере
Функция ПолучитьРеквизитыДокумента(Ссылка)
	
	РеквизитыВладельца 	= Новый Массив;
	ОбъектМетаданные 	= Ссылка.Метаданные();
	
	// Добавим предопределенные реквизиты
	
	РеквизитыВладельца.Добавить("Номер");
	РеквизитыВладельца.Добавить("Дата");
	РеквизитыВладельца.Добавить("Стартован");
	РеквизитыВладельца.Добавить("Завершен");
	
	// Получим из реквизитов
	
	КонвертацияТипов.ДобавитьМассивВКонецМассива(РеквизитыВладельца,
						КонвертацияТипов.ПолучитьМассивИзКлючейСтруктуры(
								КонвертацияТипов.ПолучитьПустуюСтруктуруИзПолейТабличнойЧасти(ОбъектМетаданные)));
							
	// Получим из общих реквизитов
	
	СвойствоИспользовать = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать;
	   
	Для Каждого ОбщийРеквизит ИЗ Метаданные.ОбщиеРеквизиты Цикл
		
		Элемент = ОбщийРеквизит.Состав.Найти(ОбъектМетаданные);
		
		Если Элемент.Использование = СвойствоИспользовать Тогда
			РеквизитыВладельца.Добавить(ОбщийРеквизит.Имя);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат РеквизитыВладельца;
	
КонецФункции

&НаКлиенте
Процедура УстановитьВидимость()
	
	ТипГруппа = Тип("ГруппаФормы");
	ТипДекорация = Тип("ДекорацияФормы");
	
	Для Каждого Элемент Из Элементы Цикл
		Если ТипЗнч(Элемент) <> ТипГруппа И ТипЗнч(Элемент) <> ТипДекорация Тогда
			Элемент.Видимость = РеквизитыВладельца.Найти(Элемент.Имя) <> Неопределено;
		КонецЕсли;
	КонецЦикла;
 	
КонецПроцедуры
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РеквизитыВладельца = ПолучитьРеквизитыДокумента(ВладелецФормы.Объект.Ссылка);
	
	Для Каждого Имя Из РеквизитыВладельца Цикл
		Если Элементы.Найти(Имя) <> Неопределено Тогда
			ЭтаФорма[Имя] = ВладелецФормы.Объект[Имя];
		КонецЕсли;
	КонецЦикла;
	
	УстановитьВидимость();
	
	// Заголовим
	
	Заголовок = "Общие реквизиты - " + ВладелецФормы.Заголовок;
	
	Если НЕ ЗначениеЗаполнено(Грузополучатель)  Тогда Грузополучатель  = ПредопределенноеЗначение("Справочник.Грузополучатели.ПустаяСсылка"); КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Грузоотправитель) Тогда Грузоотправитель = ПредопределенноеЗначение("Справочник.Грузополучатели.ПустаяСсылка"); КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЭлементПриИзменении(Элемент)
	
	Имя 		= Элемент.Имя;
	Значение 	= ЭтаФорма[Имя];
	
	ВладелецФормы.Объект[Имя] 			= Значение;
	ВладелецФормы.Модифицированность 	= Истина;
	
	ВладелецФормы.ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//  Установим отборы
	
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Организация"));
	Элементы.БанковскийСчетОрганизации.СвязиПараметровВыбора  = Новый ФиксированныйМассив(НовыйМассив);
	
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Партнер"));
	Элементы.БанковскийСчетПартнера.СвязиПараметровВыбора = Новый ФиксированныйМассив(НовыйМассив);
    	
КонецПроцедуры




