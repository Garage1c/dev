﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	УстановитьПривилегированныйРежим(Истина);

	Настройки = КомпоновщикНастроек.ПолучитьНастройки();

	ЗаполнитьТЗ();
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТЗ",ТЗ);
	ВнешниеНаборыДанных.Вставить("ТЗРоли",ТЗРолей);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,Настройки,ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);

	ДокументРезультат.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	ПроцессорВывода.НачатьВывод();

	ЭлементРезультата = ПроцессорКомпоновки.Следующий();
	Пока ЭлементРезультата <> Неопределено Цикл
		ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();
	КонецЦикла;
	ПроцессорВывода.ЗакончитьВывод();
КонецПроцедуры

Процедура ЗаполнитьТЗ()
	ТЗ.Очистить();
	ТЗРолей.Очистить();
	
	МассивПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
//	Параметры = КомпоновщикНастроек.Настройки.ПараметрыДанных;
//	ЗначениеПараметра = Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СписокРеквизитов"));
//	//ЗначениеПараметраПериод = Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
//	Если НЕ ЗначениеПараметра.Использование ИЛИ НЕ ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда
//		ЗначениеПараметра.Использование = Истина;
//   		Параметры.УстановитьЗначениеПараметра("СписокРеквизитов", МассивРеквизитов);
//	КонецЕсли;
	
	Роли = Новый Массив;
	ЗначениеПараметраРоли = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0];
	Если ЗначениеПараметраРоли.Использование = Истина И ЗначениеЗаполнено(ЗначениеПараметраРоли.Значение) Тогда
		Если ТипЗнч(ЗначениеПараметраРоли.Значение) = Тип("Строка") Тогда
			Роли.Добавить(НРег(ЗначениеПараметраРоли.Значение));
		Иначе
			Для Каждого ТекРоль Из ЗначениеПараметраРоли.Значение Цикл
				Роли.Добавить(НРег(ТекРоль.Значение));
			КонецЦикла;
			//Роли = ЗначениеПараметраРоли.Значение.ВыгрузитьЗначения();
		КонецЕсли;
	КонецЕсли;
	
	Пользователи = Новый Массив;
	ЗначениеПараметраПользователи = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1];
	Если ЗначениеПараметраПользователи.Использование = Истина И ЗначениеЗаполнено(ЗначениеПараметраПользователи.Значение) Тогда
		Если ТипЗнч(ЗначениеПараметраПользователи.Значение) = Тип("СправочникСсылка.Пользователи") Тогда
			Пользователи.Добавить(ЗначениеПараметраПользователи.Значение);
		Иначе
			Для Каждого ТекПользователь Из ЗначениеПараметраПользователи.Значение Цикл
				Пользователи.Добавить(ТекПользователь.Значение);
			КонецЦикла;
			//Роли = ЗначениеПараметраПользователи.Значение.ВыгрузитьЗначения();
		КонецЕсли;
	КонецЕсли;
	
	Для каждого ПользовательИБ Из МассивПользователей Цикл
		Для Каждого РольПользователя ИЗ ПользовательИБ.Роли Цикл
			Если Роли.Количество()>0 И Роли.Найти(НРег(РольПользователя.Имя))=Неопределено И Роли.Найти(НРег(РольПользователя.Синоним))=Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если Пользователи.Количество()>0 Тогда
				Если Пользователи.Найти(Справочники.Пользователи.НайтиПоРеквизиту("ПользовательИБ",ПользовательИБ.УникальныйИдентификатор))=Неопределено Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			СтрокаРоли = ТЗ.Добавить();
			СтрокаРоли.ИмяРоли = РольПользователя.Имя;			
			СтрокаРоли.Пометка = Истина;     	
			СтрокаРоли.ПользовательИБ = ПользовательИБ.Имя;
			СтрокаРоли.Пользователь = Справочники.Пользователи.НайтиПоРеквизиту("ПользовательИБ",ПользовательИБ.УникальныйИдентификатор);
			СтрокаРоли.ВходРазрешен = ?(ПользовательИБ.АутентификацияСтандартная Или ПользовательИБ.АутентификацияОС Или ПользовательИБ.АутентификацияOpenID,"+","");

			СтрокаРоли.ПарольУстановлен = ПользовательИБ.ПарольУстановлен;
			СтрокаРоли.ПолноеИмя = ПользовательИБ.ПолноеИмя;
			
		КонецЦикла; 
	КонецЦикла;
	
	Для каждого Роль Из Метаданные.Роли Цикл
		Если Роли.Количество()>0 И Роли.Найти(НРег(Роль.Имя))=Неопределено И Роли.Найти(НРег(Роль.Синоним))=Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаРоли = ТЗРолей.Добавить();
		СтрокаРоли.ИмяРоли = Роль.Имя;
		СтрокаРоли.ПредставлениеРоли = Роль.Синоним;
	КонецЦикла;
КонецПроцедуры

