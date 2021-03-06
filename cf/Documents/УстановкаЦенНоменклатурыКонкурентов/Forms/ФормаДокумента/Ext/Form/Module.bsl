﻿
&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;

&НаКлиенте
Перем АдресВременнойТаблицы, ТекущаяВалюта;

&НаКлиенте
Перем ДействиеОтменено Экспорт;

&НаСервере
Процедура СформироватьТаблицуТоваров(Открыт) Экспорт
	
	// Добавим колонки
	
	СоответствияИмен = ПолучитьСоответствияИменКолонок();
	
	ТипЧисло 	= Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 2));
	Таблица 	= Новый ТаблицаЗначений;
	Колонки		= Таблица.Колонки;
	
	Колонки.Добавить("НомерСтроки", 	Новый ОписаниеТипов("Число"));
	Колонки.Добавить("Номенклатура", 	Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Колонки.Добавить("Упаковка", 		Новый ОписаниеТипов("СправочникСсылка.УпаковкиНоменклатуры"));
		
	КолонкиТаблицыТоваров = Новый Массив;
	
	// старые колонки
    
	Для Каждого Элемент Из ПолучитьРеквизиты("ТаблицаТоваров") Цикл
		ИмяРеквизита = Элемент.Имя;
		Если Найти(ИмяРеквизита, "Цена") ИЛИ Найти(ИмяРеквизита, "Валюта")  Тогда
			КолонкиТаблицыТоваров.Добавить(ИмяРеквизита);
		КонецЕсли;
	КонецЦикла;
	
//	ИзменитьРеквизиты(,КолонкиТаблицыТоваров);
	
	// Добавим колонки
	
//	КолонкиТаблицыТоваров.Очистить();
	
	// новые колонки
	
	НовыеКолонки = Новый Массив;
	ИменаНовыхКолонок = Новый Массив;

	Для Каждого Элемент Из СоответствияИмен Цикл
		
		ИмяКолонки = Элемент.Ключ;
			
		Колонки.Добавить("Цена" + ИмяКолонки, ТипЧисло);           
		Колонки.Добавить("Валюта" + ИмяКолонки, Новый ОписаниеТипов("СправочникСсылка.Валюты"));        
        
		
		ИменаНовыхКолонок.Добавить("Цена" + ИмяКолонки);
        ИменаНовыхКолонок.Добавить("Валюта" + ИмяКолонки);
        
		НовыеКолонки.Добавить(Новый РеквизитФормы("Цена" + ИмяКолонки, ТипЧисло, "ТаблицаТоваров", ИмяКолонки, Истина));
		НовыеКолонки.Добавить(Новый РеквизитФормы("Валюта" + ИмяКолонки, Новый ОписаниеТипов("СправочникСсылка.Валюты"), "ТаблицаТоваров", ИмяКолонки, Истина));
		
	КонецЦикла;
	
	// добавляемые реквизиты
	
	КолонкиДобавить = Новый Массив;
	ГруппыДобавить = Новый Массив;
	
	
	Для Каждого Строка Из НовыеКолонки Цикл
		Если КолонкиТаблицыТоваров.Найти(Строка.Имя) = Неопределено Тогда  // в старых рекцизитах такого элемнета нет, нужно его добавить
			КолонкиДобавить.Добавить(Строка);
			Если ГруппыДобавить.Найти(Строка.Заголовок) = Неопределено Тогда
				ГруппыДобавить.Добавить(Строка.Заголовок);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	//удаляемые реквизиты
	
	КолонкиУдалить = Новый Массив;
	ГруппыУдалить = Новый Массив;
	
	Для Каждого Строка Из КолонкиТаблицыТоваров Цикл
		
		Если ИменаНовыхКолонок.Найти(Строка) = Неопределено Тогда // старой колонки нету в новых значит удалим ее
			КолонкиУдалить.Добавить("ТаблицаТоваров." + Строка);
			
			ИмяТипЦен = "";
			Если Найти(Строка, "Цена") Тогда
				ИмяТипЦен = СтрЗаменить(Строка,  "Цена", "");
			ИначеЕсли Найти(Строка, "Валюта") Тогда
				ИмяТипЦен = СтрЗаменить(Строка,  "Валюта", "");
			КонецЕсли;
			
			Если Не ПустаяСтрока(ИмяТипЦен) И ГруппыУдалить.Найти(ИмяТипЦен) = Неопределено Тогда
				ГруппыУдалить.Добавить(ИмяТипЦен);
			КонецЕсли;
  		
		КонецЕсли;
		
	КонецЦикла;
	
	ИзменитьРеквизиты(КолонкиДобавить, КолонкиУдалить);
	Для Каждого Строка Из ГруппыУдалить Цикл
		Если Элементы.ТаблицаТоваров.ПодчиненныеЭлементы["Группа" + Строка] <> Неопределено Тогда
			Элементы.Удалить(Элементы.ТаблицаТоваров.ПодчиненныеЭлементы["Группа" + Строка]);
		КонецЕсли;
	КонецЦикла;

	// Добавим колонки на форме
	Для Каждого Элемент Из ГруппыДобавить Цикл
		ИмяКолонки = Элемент;	
		НоваяГруппа =  ДобавитьГруппуФормы("Группа" + ИмяКолонки,  СоответствияИмен[Элемент].Наименование, Элементы.ТаблицаТоваров, ГруппировкаКолонок.Вертикальная);
		НоваяПодГруппа = ДобавитьГруппуФормы("ПодГруппа" + ИмяКолонки, СоответствияИмен[Элемент].Наименование, НоваяГруппа, ГруппировкаКолонок.Горизонтальная, Ложь);
		
		ДобавитьПолеФормы("Цена" + ИмяКолонки, НоваяПодГруппа,  "Цена" , "ЦенаПриИзменении");
		полеформыВалюта = ДобавитьПолеФормы("Валюта" + ИмяКолонки, НоваяПодГруппа, "Валюта", "ВалютаПриИзменении", "ВалютаНачалоВыбораИзСписка");
		полеформыВалюта.ПропускатьПриВводе = Истина;
	КонецЦикла;
	
	// Заполним строки
	Если Открыт Тогда
		 ЗагрузитьСписокТоваров(Таблица);
	Иначе	 
		// ИзменитьСписокТоваров(Таблица);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписокТоваров(Таблица);
	
	СоответствияТиповЦен = ПолучитьСоответствияТиповЦен();
	
	Для Каждого Строка Из Объект.Товары Цикл
		
		Строки = Таблица.НайтиСтроки(Новый Структура("Номенклатура, Упаковка", Строка.Номенклатура, Строка.Упаковка));
		
		Если Не Строки.Количество() Тогда
			НовСтрока = Таблица.Добавить();
			НовСтрока.НомерСтроки	= Таблица.Количество();
			НовСтрока.Номенклатура 	= Строка.Номенклатура;
			НовСтрока.Упаковка 		= Строка.Упаковка;
		Иначе
			НовСтрока = Строки[0];
		КонецЕсли;
		
		Если Не Строка.ТипЦен.Пустая() Тогда
			
			ИмяКолонки = СоответствияТиповЦен[Строка.ТипЦен];
		
			Если ИмяКолонки <> Неопределено Тогда
		
				НовСтрока["Цена" + ИмяКолонки] = Строка.Цена;
				НовСтрока["Валюта" + ИмяКолонки] = Строка.Валюта;
			
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	// Загрузим в таблицу
	
	ТаблицаТоваров.Загрузить(Таблица);
	
КонецПроцедуры

Процедура ИзменитьСписокТоваров(Таблица, ПроставитьЦену = Ложь);
	
	СоответствияТиповЦен = ПолучитьСоответствияТиповЦен();
	
	Для Каждого Строка Из ТаблицаТоваров Цикл
		Для Каждого СтрокаТипЦен Из СписокТиповЦен Цикл
			НовСтрока = Таблица.Добавить();
			НовСтрока.НомерСтроки	= Таблица.Количество();
			НовСтрока.Номенклатура 	= Строка.Номенклатура;
			
			ИмяКолонки = СоответствияТиповЦен[СтрокаТипЦен.Значение];
			Если ИмяКолонки <> Неопределено Тогда
		
				НовСтрока["Цена" + ИмяКолонки] = ?(ПроставитьЦену, РаботаСНоменклатурой.ПолучитьЦену(НовСтрока.Номенклатура, СтрокаТипЦен.Значение), Строка["Цена" + ИмяКолонки]);
				НовСтрока["Валюта" + ИмяКолонки] = Строка["Валюта" + ИмяКолонки];
			
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Загрузим в таблицу

	ТаблицаТоваров.Загрузить(Таблица);

КонецПроцедуры

Процедура ДОбавитьВСписокТоваров(Таблица)
	
	СоответствияТиповЦен = ПолучитьСоответствияТиповЦен();
	
	Для Каждого Строка Из Таблица Цикл
		
		НовСтрока = ТаблицаТоваров.Добавить();
		НовСтрока.НомерСтроки	= ТаблицаТоваров.Количество();
		НовСтрока.Номенклатура 	= Строка.Номенклатура;
		НовСтрока.Упаковка 		= Строка.Упаковка;
		
		//Для Каждого СтрокаТипЦен Из СписокТиповЦен Цикл
		//	
		//	текТипЦен = СтрокаТипЦен.Значение;
		//	
		//	ИмяКолонки = СоответствияТиповЦен[текТипЦен];
		//	Если ИмяКолонки <> Неопределено Тогда
		//		
		//		текЦена = РаботаСНоменклатурой.ПолучитьЦену(НовСтрока.Номенклатура, текТипЦен);
		//		НовСтрока["Цена" + ИмяКолонки] = текЦена;
		//		Если ЗначениеЗаполнено(текЦена) Тогда
		//			НовСтрока["Валюта" + ИмяКолонки] =  текТипЦен.Валюта;
		//		КонецЕсли;
		//	
		//	КонецЕсли;
		//КонецЦикла;
	КонецЦикла;
	
	// Загрузим в таблицу

	//ТаблицаТоваров.Загрузить(Таблица);

КонецПроцедуры


&НаСервере
Функция ПолучитьТипыЦен()
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ Ссылка ИЗ Справочник.ТипыЦен ГДЕ НЕ ПометкаУдаления УПОРЯДОЧИТЬ ПО Наименование");
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции
 
&НаСервере
Процедура ЗагрузитьСписокТиповЦен()
	
	ВрТаблица = Объект.Товары.Выгрузить(,"ТипЦен");
	ВрТаблица.Свернуть("ТипЦен");
	
	СписокТиповЦен.ЗагрузитьЗначения(ВрТаблица.ВыгрузитьКолонку("ТипЦен"));
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСоответствияИменКолонок()
	
	Соответствия	= Новый Соответствие;
	Инд				= 0;
	
	Для Каждого Элемент Из СписокТиповЦен Цикл Инд = Инд + 1;
		Соответствия.Вставить(СтрЗаменить(Строка(Элемент.Значение.УникальныйИдентификатор()),"-",""), Элемент.Значение);
	КонецЦикла;
	
	Возврат Соответствия;
	
КонецФункции

&НаСервере
Функция ПолучитьСоответствияТиповЦен() Экспорт
	
	Соответствия	= Новый Соответствие;
	Инд				= 0;
	
	Для Каждого Элемент Из СписокТиповЦен Цикл Инд = Инд + 1;
			
		Соответствия.Вставить(Элемент.Значение, СтрЗаменить(Строка(Элемент.Значение.УникальныйИдентификатор()),"-",""));
		
	КонецЦикла;
	
	Возврат Соответствия;
	
КонецФункции
                                                                                                                                                                                  
&НаСервере
Функция ДобавитьПолеФормы(Имя, Группа, Заголовок = Неопределено, ОбработчикПриИзменении = "", НачалоВыбораИзСписка = "", ИзменитьЦвет = Ложь, ОтображатьВШапке = Истина, ЦветФона = Неопределено, ЦветФонаЗаголовка = Неопределено)
	                      // уникальное имя     тип      родитель       
	НовоеПоле = Элементы.Добавить(Имя, Тип("ПолеФормы"), Группа);	
	НовоеПоле.ПутьКДанным = "ТаблицаТоваров." + Имя;
	НовоеПоле.Заголовок = ?(Заголовок <> Неопределено, Заголовок, Имя);
	НовоеПоле.РежимРедактирования = РежимРедактированияКолонки.Непосредственно;
	НовоеПоле.Вид = ВидПоляФормы.ПолеВвода;
	НовоеПоле.ОтображатьВШапке = ОтображатьВШапке;
	
	Если ИзменитьЦвет Тогда
		НовоеПоле.ЦветТекста = WebЦвета.Серый;
	КонецЕсли;
	
	Если ЦветФонаЗаголовка <> Неопределено Тогда
		НовоеПоле.ЦветФонаЗаголовка = ЦветФонаЗаголовка;
	КонецЕсли;
	
	Если ЦветФона <> Неопределено Тогда
		НовоеПоле.ЦветФона = ЦветФона;
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ОбработчикПриИзменении) Тогда
		НовоеПоле.УстановитьДействие("ПриИзменении", ОбработчикПриИзменении);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НачалоВыбораИзСписка) Тогда
		НовоеПоле.УстановитьДействие("НачалоВыбораИзСписка", НачалоВыбораИзСписка);
	КонецЕсли;
	
	Возврат НовоеПоле;
	
КонецФункции

&НаСервере
Функция ДобавитьГруппуФормы(Имя, Заголовок = Неопределено, Родитель = Неопределено, Группировка = Неопределено, ОтображатьВШапке = Истина, ОбработчикПриИзменении = "", ОбработчикНачалоВыбора = "", ЦветФона = Неопределено, ЦветФонаЗаголовка = Неопределено)
	
	// уникально имя      тип         родитель(таблица формы) 
	НоваяГруппа = Элементы.Добавить(Имя, Тип("ГруппаФормы"), Родитель);	
	НоваяГруппа.Заголовок = ?(ЗначениеЗаполнено(Заголовок), Заголовок, Имя);
	НоваяГруппа.Вид = ВидГруппыФормы.ГруппаКолонок;
	НоваяГруппа.ОтображатьВШапке = ОтображатьВШапке;
	НоваяГруппа.Группировка = Группировка;
	
	Если ЦветФонаЗаголовка <> Неопределено Тогда
		НоваяГруппа.ЦветФонаЗаголовка = ЦветФонаЗаголовка;
	КонецЕсли;
	
	Если ЦветФона <> Неопределено Тогда
		НоваяГруппа.ЦветФона = ЦветФона;
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ОбработчикПриИзменении) Тогда
		НоваяГруппа.УстановитьДействие("ПриИзменении", ОбработчикПриИзменении);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбработчикНачалоВыбора) Тогда
		НоваяГруппа.УстановитьДействие("НачалоВыбора", ОбработчикНачалоВыбора);
	КонецЕсли;
	
	Возврат НоваяГруппа;
	
КонецФункции

&НаСервере
Процедура ВнестиЦенуВТовары(СтруктураТоваров, Цена, Валюта)
	
	Строки = Объект.Товары.НайтиСтроки(СтруктураТоваров);
	
	Если Строки.Количество() Тогда
		
		Строки[0].Цена = Цена;
		
	Иначе
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураТоваров);
		НоваяСтрока.Цена = Цена;
		НоваяСтрока.Валюта = Валюта;
	КонецЕсли;
	
КонецПроцедуры
								
Процедура ВнестиВалютуВТовары(СтруктураТоваров, Цена, Валюта)
	
	Строки = Объект.Товары.НайтиСтроки(СтруктураТоваров);
	
	Если Строки.Количество() Тогда
		
		Строки[0].Валюта = Валюта;
		
	Иначе
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураТоваров);
		НоваяСтрока.Валюта = Валюта;
		НоваяСтрока.Цена = Цена;
	КонецЕсли;
	
КонецПроцедуры
								
&НаСервере
Процедура ВнестиИзмененияВТовары(СтруктураПоиска, ИмяКолонки, Значение)
	
	Строки = Объект.Товары.НайтиСтроки(СтруктураПоиска);
	
	Если Строки.Количество() Тогда
		
		Для Каждого Строка Из Строки Цикл
		
			Строка[ИмяКолонки] = Значение;
			
		КонецЦикла;
		
	Иначе
		
		Строка = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, СтруктураПоиска);
		Строка[ИмяКолонки] = Значение;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличнуюЧасть() 
	
	Товары = Объект.Товары;
	
	Товары.Очистить();
	
	СоответствиеТиповЦен = ПолучитьСоответствияТиповЦен();
	
	Для Каждого СтрокаТовар Из ТаблицаТоваров Цикл
		
		ТекТовар = СтрокаТовар.Номенклатура;
		ТекУпаковка = СтрокаТовар.Упаковка;

		Для Каждого СтрокаТипЦен Из СписокТиповЦен Цикл
		    ТекТипЦен = СтрокаТипЦен.Значение;
			
			НоваяСтрока =  Товары.Добавить();
			КолонкаЦена = "Цена" + СоответствиеТиповЦен[ТекТипЦен];
			КолонкаВалюта = "Валюта" + СоответствиеТиповЦен[ТекТипЦен];
			НоваяСтрока.ТипЦен = ТекТипЦен;
		    НоваяСтрока.Номенклатура = ТекТовар;
			НоваяСтрока.Упаковка 	= ТекУпаковка; 
			
			НоваяСтрока.Цена = СтрокаТовар[КолонкаЦена];
			НоваяСтрока.Валюта = СтрокаТовар[КолонкаВалюта]; 
		    
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УдалитьЛишниеКолонки()

	СоответствиеЦен = ПолучитьСоответствияТиповЦен();
	Товары			= Объект.Товары;
	КолСтрок		= Товары.Количество();
	
	Для Ном = 1 По КолСтрок Цикл
		
		Строка = Товары[КолСтрок - Ном];
		Если СоответствиеЦен[Строка.ТипЦен] = Неопределено Тогда
			
			Товары.Удалить(Строка);
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


// ОБРАБОТЧИКИ РЕКВИЗИТОВ ФОРМЫ

&НаКлиенте
Процедура СписокТиповЦенНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//Если СписокТиповЦен.Количество() И ТаблицаТоваров.Количество() Тогда
	//	
	//	Режим = РежимДиалогаВопрос.ДаНет;
	//	Текст = "Цены, установленные для текущих типов цен будут очищены. Продолжить выполнение операции?";		
	//	Ответ = Вопрос(Текст, Режим, 0, КодВозвратаДиалога.Нет);
	//	Если Ответ = КодВозвратаДиалога.Нет Тогда
	//		Возврат;
	//	КонецЕсли;	 
	//	
	//КонецЕсли;
	
	ТипыЦен 		= ПолучитьТипыЦен();
	СписокВыбора 	= Новый СписокЗначений;
	
	// Проставим отметки
	
	СтарыеОтметки = Новый Массив;
	
	СписокВыбора.ЗагрузитьЗначения(ТипыЦен);
	
	Для Каждого ЭлементСписка Из СписокВыбора Цикл
		
		ЭлементСписка.Пометка = СписокТиповЦен.НайтиПоЗначению(ЭлементСписка.Значение) <> Неопределено;
		Если ЭлементСписка.Пометка Тогда
			СтарыеОтметки.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	// Выберем
	
	Если СписокВыбора.ОтметитьЭлементы("Выбор типов цен:") Тогда
		
		// Созадим список
		
		НовыеОтметки = Новый Массив;
		
		СписокТиповЦен.Очистить();
		Для Каждого ЭлементСписка Из СписокВыбора Цикл
			Если ЭлементСписка.Пометка Тогда
				
				ВыбранноеЗначение = ЭлементСписка.Значение;
				
				СписокТиповЦен.Добавить(ВыбранноеЗначение);
				
				Если СтарыеОтметки.Найти(ВыбранноеЗначение) = Неопределено Тогда
					НовыеОтметки.Добавить(ВыбранноеЗначение);
				КонецЕсли;
				
			КонецЕсли; 
			
		КонецЦикла;
		
		// Обновим товары
		
		СформироватьТаблицуТоваров(Ложь);
		
		// проставить пустые колонки ценами из предыдущих установок цен
		
		ЗаполнитьПодменюЗаполнитьВалюту();
	    ЗаполнитьПодменюОчиститьЦены();
        ЗаполнитьПодменюОкруглитьЦены();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаНачалоВыбораИзСписка(Элемент)
КонецПроцедуры

&НаКлиенте
Процедура ЦенаПриИзменении(Элемент)
	колонкаТипЦены = СтрЗаменить(Элемент.Имя, "Цена", "");
	колонкаВалюта = "Валюта" + колонкаТипЦены;
	текСтрока = Элементы.ТаблицаТоваров.ТекущиеДанные;
	
	Если НЕ ЗначениеЗаполнено(текСтрока[колонкаВалюта]) Тогда
		текСтрока[колонкаВалюта] = ВалютаТипаЦены(колонкаТипЦены);
	КонецЕсли;
КонецПроцедуры

Функция ВалютаТипаЦены(КолонкаИмя)
	соот = ПолучитьСоответствияИменКолонок();
	
	Возврат соот[КолонкаИмя].Валюта;
КонецФункции // ВалютаТипаЦены()

// ОСНОВНЫЕ ДЕЙСТВИЯ ФОРМЫ

&НаКлиенте
Процедура ОбщиеРеквизиты(Команда)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизиты(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЦеныНаПроцент(Команда)
	
	ОткрытьФорму("Документ.УстановкаЦенНоменклатуры.Форма.ИзменениеЦенНаПроцент", Новый Структура("ТипыЦен", СписокТиповЦен), ЭтаФорма);
	
КонецПроцедуры


#Область Типовые

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// Удалим все колонки которые не отображенны
	
	УдалитьЛишниеКолонки();
	ЗаполнитьТабличнуюЧасть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаОсновании()
	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Если НЕ Параметры.Основание.Пустая() Тогда
	//	ЗаполнитьНаОсновании();
	//КонецЕсли;
	
	ЗагрузитьСписокТиповЦен();
	СформироватьТаблицуТоваров(Истина);

	Если ЗначениеЗаполнено(Параметры.Основание) И НЕ СписокТиповЦен.Количество() Тогда
		Сообщить("Тип цен не заполнен: " + Параметры.Основание);
		Отказ = Истина;
	КонецЕсли

		
КонецПроцедуры
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДействиеОтменено = Истина;
	Элементы.ТаблицаТоваровОтменитьДействие.Доступность = НЕ ДействиеОтменено;
	
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.ТаблицаТоваров, Истина);
	
	// Автосохранение
	
	Если Не ТолькоПросмотр Тогда 
		Если АвтосохранениеКлиент.ИницилизироватьСохранение(ЭтаФорма) Тогда
			
			ДанныеДляПодбора = "";
			ЗагрузитьДанныеАвтосохранения(ДанныеДляПодбора); 
				СформироватьТаблицуТоваров(Ложь);
				// Повторно считаем так как колонки могли изменится
				ЗагрузитьДанныеАвтосохранения(ДанныеДляПодбора);
			Модифицированность = Истина; 
			
			Если Не ПустаяСтрока(ДанныеДляПодбора) Тогда ПодборВыполнить(,Новый Структура("МассивТоваровСтрокой", ДанныеДляПодбора)) КонецЕсли; КонецЕсли; КонецЕсли;
		
	ЗаполнитьПодменюЗаполнитьВалюту();
    ЗаполнитьПодменюОчиститьЦены();
    ЗаполнитьПодменюОкруглитьЦены();
	
КонецПроцедуры
&НаКлиенте
Процедура ПриЗакрытии()
	
	// Автосохранение
	АвтосохранениеСервер.УдалитьАвтоСохранение(ИмяФормы, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Автосохранение
	Если Не Отказ И Объект.Ссылка.Пустая() Тогда АвтосохранениеСервер.УдалитьАвтоСохранение(ИмяФормы, Объект.Ссылка) КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Подбор

&НаСервере
Функция ПоместитьТоварыВХранилище() 
	
	//Таблица =  ТаблицаТоваров.Выгрузить();
	//Таблица.Свернуть("Номенклатура");
	
	Возврат ПоместитьВоВременноеХранилище(
					Новый ТаблицаЗначений, 
					УникальныйИдентификатор);
КонецФункции
&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресТоваровВХранилище)
	
	Таблица = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	Таблица.Свернуть("Номенклатура, Упаковка");
	Колонки		= Таблица.Колонки;
	
	Колонки.Добавить("НомерСтроки", 	Новый ОписаниеТипов("Число"));
	
	СоответствияИмен = ПолучитьСоответствияИменКолонок();
	
	Для Каждого Элемент Из СоответствияИмен Цикл
		
		ИмяКолонки = Элемент.Ключ;
			
		//Колонки.Добавить("Цена" + ИмяКолонки, Новый ОписаниеТипов("Число")); 		
		//Колонки.Добавить("Валюта" + ИмяКолонки, Новый ОписаниеТипов("СправочникСсылка.Валюты"));
			
	КонецЦикла;
	
	ДобавитьВСписокТоваров(Таблица);
	 		
КонецПроцедуры

&НаКлиенте
Процедура ПодборВыполнить(Кнопка = Неопределено, ДополнительныеПараметрыПодбора = Неопределено)
	
	ИмяТабличнойЧасти = "ТаблицаТоваров";
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	ПараметрыПодбора = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	
	ПараметрыПодбора.Вставить("СтруктураКолонокТовары", СтруктураКолонокТовары);
	//ПараметрыПодбора.Вставить("ВидЗапроса", "СписокНоменклатуры");
	//ПараметрыПодбора.Вставить("ВидыЗапросов", "СписокНоменклатуры");
	//ПараметрыПодбора.Вставить("ТипЦен", Объект.ТипЦен);
	//ПараметрыПодбора.Вставить("Валюта", Объект.Валюта);

	// Автосохранение
	АвтосохранениеКлиент.ОткрываетсяПодбор(ПараметрыПодбора, Объект.Ссылка, ЭтаФорма, ПолучитьДамп());
	Если ДополнительныеПараметрыПодбора <> Неопределено Тогда
		КонвертацияТипов.ДобавитьВСтруктуруСтруктуру(ПараметрыПодбора, ДополнительныеПараметрыПодбора) КонецЕсли;
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", ПараметрыПодбора, Элементы.ТаблицаТоваров);
	
КонецПроцедуры
&НаКлиенте
Процедура ТаблицаТоваровОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение <> Неопределено Тогда		
		
		ПолучитьТоварыИзХранилища(ВыбранноеЗначение);		// получаем
		УдалитьИзВременногоХранилища(ВыбранноеЗначение); 	// заметаем следы
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Автосохранение

&НаСервере
Процедура ЗагрузитьДанныеАвтосохранения(ДанныеДляПодбора)
	
	АвтосохранениеСервер.СчитатьДанныеФормыИУдалитьСохранение(ЭтаФорма, ДанныеДляПодбора)
	
КонецПроцедуры
&НаСервере
Функция АвтосохранениеСервер(ЕстьДамп)
	
	Возврат АвтосохранениеСервер.СохранитьДампФормы(ЭтаФорма, ЕстьДамп);
	
КонецФункции
&НаКлиенте
Процедура Автосохранение()
	
	Перем ЕстьДамп;
	
	Сохранилось = АвтосохранениеСервер(ЕстьДамп);
	
	АвтосохранениеКлиент.ПроизошлоАвтосохранение(Сохранилось, ЕстьДамп, Объект.Ссылка);
	
КонецПроцедуры
&НаСервере
Функция ПолучитьДамп()
	
	Возврат АвтосохранениеСервер.ПолучитьДамп(ЭтаФорма);

КонецФункции
	
#КонецОбласти


// ЗАПОЛНИТЬ ВАЛЮТУ

&НаКлиенте
Процедура УстановитьВалюту(Команда)
	Валюта = ОткрытьФорму("Справочник.Валюты.ФормаВыбора",,,,,,Новый ОписаниеОповещения("ОбработкаУстановкиНоменклатуры",ЭтаФорма, Новый Структура("КомандаИмя", Команда.Имя)));
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаУстановкиНоменклатуры(Результат, Параметры)   Экспорт
	Если Результат <> Неопределено Тогда
		УстановитьВозможностьОтменыДействия();
		ИмяКолонки = СтрЗаменить(Параметры.КомандаИмя, "КомандаЗаполнитьВалюту", "");
		УстановитьВалютуНаСервере(ИмяКолонки, Результат);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЦенаВВыбраннойВалюте(Цена, Валюта, ВалютаУстановки) Экспорт
	
	НоваяЦена = Цена;
	
	Запрос = Новый Запрос("ВЫБРАТЬ 
	|	ЕСТЬNULL(Вал.Курс, 1)			Курс,
	|   ЕСТЬNULL(Вал.Кратность, 1)		Кратность,
	|	ЕСТЬNULL(УстКурс.Курс, 1) 		УстКурс,
	|	ЕСТЬNULL(УстКурс.Кратность, 1)	УстКратность
	| ИЗ 
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта) Вал	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &УстВалюта) УстКурс
	|	ПО ИСТИНА");
	
	Запрос.УстановитьПараметр("Валюта", 	Валюта);
	Запрос.УстановитьПараметр("УстВалюта",	ВалютаУстановки);
	Запрос.УстановитьПараметр("Дата", 		Объект.Дата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Курс = Выборка.Курс;
		Кратность = Выборка.Кратность;
		
		УстКурс = Выборка.УстКурс;
		УстКратность = Выборка.УстКратность;
		
		НоваяЦена = Формат(Цена*Курс*УстКратность/УстКурс*Кратность, "ЧЦ=10; ЧДЦ=2");
				
	КонецЕсли;
	
	Возврат НоваяЦена;
	
КонецФункции

&НаСервере
Процедура УстановитьВалютуНаСервере(ИмяКолонки, Валюта)
	
	Для Каждого Строка Из ТаблицаТоваров Цикл		
		Строка["Цена" + ИмяКолонки] 	= ЦенаВВыбраннойВалюте(Строка["Цена" + ИмяКолонки], Строка["Валюта" + ИмяКолонки], Валюта);
		Строка["Валюта" + ИмяКолонки] 	= Валюта;
	КонецЦикла;
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодменюБазовымиТипамиЦен(ИмяПодменю, ПрефиксКоманды, Действие, ЧислоНеДинамическихПунктов = 0)
	
	// удаляем все ранее созданные кнопки
	Пока Элементы[ИмяПодменю].ПодчиненныеЭлементы.Количество() > ЧислоНеДинамическихПунктов Цикл
		Элементы.Удалить(Элементы[ИмяПодменю].ПодчиненныеЭлементы[Элементы[ИмяПодменю].ПодчиненныеЭлементы.Количество()-1]);
	КонецЦикла;
		
	// команды удалять не будем, никому не мешают
	// добавим новые команды, если их еще нет
	
	СоответствиеИмен = ПолучитьСоответствияИменКолонок();
	
	Для Каждого Строка Из СоответствиеИмен Цикл
		
			ИмяКоманды = ПрефиксКоманды + Строка.Ключ;
			
			Команда = Команды.Найти(ИмяКоманды);
			НоваяКоманда = ?(Команда = Неопределено, Команды.Добавить(ИмяКоманды), Команда);
			НоваяКоманда.Действие = Действие;
			
			ПунктМеню = Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Элементы[ИмяПодменю]);
			ПунктМеню.Заголовок 	= Строка.Значение;
			ПунктМеню.ИмяКоманды 	= ИмяКоманды;
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодменюЗаполнитьВалюту()
	
	ЗаполнитьПодменюБазовымиТипамиЦен("ПодменюВалюта", "КомандаЗаполнитьВалюту", "УстановитьВалюту")		
		
 КонецПроцедуры
 
 // ОЧИСТИТЬ ЦЕНЫ                       

&НаКлиенте
Процедура ОчиститьЦену(Команда)
	
	Ответ = Вопрос("Данные по новым ценам будут удалены. Очистить цены?", РежимДиалогаВопрос.ДаНет, 0);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
	    Возврат;
	КонецЕсли;	
	
	УстановитьВозможностьОтменыДействия();
	
	ИмяКолонки = СтрЗаменить(Команда.Имя, "КомандаОчистить", "");
	
	Для Каждого Строка Из ТаблицаТоваров Цикл
		Строка["Цена" + ИмяКолонки] = 0;
		Строка["Валюта" + ИмяКолонки] = Неопределено;
	КонецЦикла;
	
КонецПроцедуры
&НаСервере
Процедура ЗаполнитьПодменюОчиститьЦены()
	 ЗаполнитьПодменюБазовымиТипамиЦен("ПодменюОчистить", "КомандаОчистить", "ОчиститьЦену")
КонецПроцедуры

// ОКРУГЛИТЬ ЦЕНЫ

&НаСервере
Процедура ЗаполнитьПодменюОкруглитьЦены()
	 ЗаполнитьПодменюБазовымиТипамиЦен("ПодменюОкруглить", "КомандаОкруглить", "ОкруглитьЦену")
КонецПроцедуры

&НаСервере
Функция ПолучитьЧислоРазрядностиОкругления(Разрядность)
	
	Возврат Перечисления.ВариантыОкругления.ПолучитьЧислоВариантаОкругления(Разрядность);
	
КонецФункции

 &НаКлиенте
Процедура ОкруглитьЦену(Команда)
	Разрадность = ОткрытьФорму("Перечисление.ВариантыОкругления.ФормаВыбора",,,,,,Новый ОписаниеОповещения("ОбработкаВыбораВариантаОкругления",ЭтаФорма, Новый Структура("КомандаИмя",Команда.Имя)));
КонецПроцедуры
&НаКлиенте
Процедура ОбработкаВыбораВариантаОкругления(Результат, Параметры) Экспорт 	
	Если Результат <> Неопределено Тогда
		УстановитьВозможностьОтменыДействия();
		
		ЧислоРазрядность = ПолучитьЧислоРазрядностиОкругления(Результат);	
	
		ИмяКолонки = СтрЗаменить(Параметры.КомандаИмя, "КомандаОкруглить", "");
		
		Для Каждого Строка Из ТаблицаТоваров Цикл
			Строка["Цена" + ИмяКолонки] = Окр(Строка["Цена" + ИмяКолонки], ЧислоРазрядность);
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры

// ОТМЕНИТЬ ДЕЙСТВИЕ

&НаКлиенте
Процедура УстановитьВозможностьОтменыДействия() Экспорт
	
	АдресВременнойТаблицы = УстановитьВозможностьОтменыДействияНаСервере();
	ДействиеОтменено = Ложь;
    Элементы.ТаблицаТоваровОтменитьДействие.Доступность = НЕ ДействиеОтменено;	
	
КонецПроцедуры

&НаСервере
Функция УстановитьВозможностьОтменыДействияНаСервере()
	
	 Возврат ПоместитьВоВременноеХранилище(ТаблицаТоваров.Выгрузить(), УникальныйИдентификатор);
	 
КонецФункции
 
&НаСервере
Процедура ОтменитьДействиеНаСервере(АдресВременнойТаблицы)
	
	СтараяТаблица = ПолучитьИзВременногоХранилища(АдресВременнойТаблицы);
	Если ЗначениеЗаполнено(СтараяТаблица) Тогда
		ТаблицаТоваров.Загрузить(СтараяТаблица);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьДействие(Команда)
	
	Если НЕ ДействиеОтменено Тогда
		ОтменитьДействиеНаСервере(АдресВременнойТаблицы);
		ДействиеОтменено = Истина;
		Элементы.ТаблицаТоваровОтменитьДействие.Доступность = НЕ ДействиеОтменено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьExcel(Команда)
	ОткрытьФорму("Документ.УстановкаЦенНоменклатуры.Форма.ЗагрузкаExcel",,ЭтаФорма);
КонецПроцедуры




  

