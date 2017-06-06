﻿
&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;

&НаКлиенте
Процедура ДополнительныеРеквизиты(Команда)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизиты(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТовары()
	
	Если НЕ Объект.Ссылка.Пустая() Тогда		
		
		Запрос = Новый Запрос("	ВЫБРАТЬ
								|	Номенклатура,
								|	ВЫБОР КОГДА Ссылка.ВариантСкидки = ЗНАЧЕНИЕ(Перечисление.ВариантСкидки.Товар) 	ТОГДА Скидка КОНЕЦ Товар,
								|	ВЫБОР КОГДА Ссылка.ВариантСкидки = ЗНАЧЕНИЕ(Перечисление.ВариантСкидки.Процент) ТОГДА Скидка КОНЕЦ Процент,
								|	ВЫБОР КОГДА Ссылка.ВариантСкидки = ЗНАЧЕНИЕ(Перечисление.ВариантСкидки.Цена) 	ТОГДА Скидка КОНЕЦ Цена,
                                |	""%"" ЗнакПроцента,
								|	Ссылка.Валюта Валюта
								|ИЗ
								|	Документ.Акция.Товары ГДЕ Ссылка = &Ссылка
								|");
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка); 						
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Товары.Загрузить(РезультатЗапроса.Выгрузить());
		КонецЕсли;
	КонецЕсли;							

КонецПроцедуры
&НаСервере
Процедура СохранитьТаблицуТовары(ТекущийОбъект)
	Если Модифицированность Тогда
		Таб = Товары.Выгрузить(,"Номенклатура, " + Строка(Объект.ВариантСкидки));
		Таб.Колонки[Строка(Объект.ВариантСкидки)].Имя = "Скидка";
		ТекущийОбъект.Товары.Загрузить(Таб);		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьМеню();
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Истина, Объект.ТипЦен, "Товары", , Объект.Валюта, Истина);

	//// Автосохранение
	//
	//Если Не ТолькоПросмотр Тогда 
	//	Если АвтосохранениеКлиент.ИницилизироватьСохранение(ЭтаФорма) Тогда
	//		
	//		ДанныеДляПодбора = "";
	//		ЗагрузитьДанныеАвтосохранения(ДанныеДляПодбора); 
	//			СформироватьТаблицуТоваров(Ложь);
	//			// Повторно считаем так как колонки могли изменится
	//			ЗагрузитьДанныеАвтосохранения(ДанныеДляПодбора);
	//		Модифицированность = Истина; 
	//		
	//		Если Не ПустаяСтрока(ДанныеДляПодбора) Тогда Подбор(,Новый Структура("МассивТоваровСтрокой", ДанныеДляПодбора)) КонецЕсли; КонецЕсли; КонецЕсли;

	// Получим картинку из базы
	АдресКартинки = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "Картинка");

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписокТиповЦен()
	
	ВрТаблица = Объект.Товары.Выгрузить(,"ТипЦен");
	ВрТаблица.Свернуть("ТипЦен");
	
	ТипыЦен.ЗагрузитьЗначения(ВрТаблица.ВыгрузитьКолонку("ТипЦен"));
	
КонецПроцедуры
//&НаСервере
//Процедура ЗагрузитьСписокУчастников()
//	
//	ВрТаблица = Объект.Участники.Выгрузить(,"Участник");
//	ВрТаблица.Свернуть("Участник");
//	
//	Участники.Загрузить(ВрТаблица);
//	
//КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличнуюЧасть() 
	
	ТоварыДокумента = Объект.Товары;
	ТоварыДокумента.Очистить();
	
	СоответствиеТиповЦен = ПолучитьСоответствияТиповЦен();
	
	Для Каждого СтрокаТовар Из Товары Цикл
		
		ТекТовар 		= СтрокаТовар.Номенклатура;
		ТекУпаковка 	= СтрокаТовар.Упаковка;

		Для Каждого СтрокаТипЦен Из ТипыЦен Цикл
		    ТекТипЦен = СтрокаТипЦен.Значение;
			
			НоваяСтрока =  ТоварыДокумента.Добавить();

			НоваяСтрока.ТипЦен	 	 = ТекТипЦен;
		    НоваяСтрока.Номенклатура = ТекТовар;
			НоваяСтрока.Упаковка 	 = ТекУпаковка; 
			
			НоваяСтрока.Цена	  	  = СтрокаТовар["Цена" + СоответствиеТиповЦен[ТекТипЦен]];
			НоваяСтрока.НоваяЦена	  = СтрокаТовар["НоваяЦена" + СоответствиеТиповЦен[ТекТипЦен]];
			НоваяСтрока.ПроцентСкидки = СтрокаТовар["Процент" + СоответствиеТиповЦен[ТекТипЦен]]; 
		    
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры
//&НаСервере
//Процедура ЗаполнитьТабличнуюЧастьУчастники() 
//	
//	ТаблицаДокумента = Объект.Участники;
//	ТаблицаДокумента.Очистить();
//	
//	Для Каждого СтрокаУчастник Из Участники Цикл		
//		ТекУчастник = СтрокаУчастник.Участник;

//		Для Каждого СтрокаТипЦен Из ТипыЦен Цикл
//			НоваяСтрока =  ТаблицаДокумента.Добавить();

//			НоваяСтрока.ТипЦен	 	 = СтрокаТипЦен.Значение;
//			НоваяСтрока.Участник	 = ТекУчастник;

//		КонецЦикла;
//	КонецЦикла;
//КонецПроцедуры

&НаСервере
Процедура СформироватьТаблицуТоваров(ЗагрузитьТовары = Ложь) Экспорт
	
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
    РеквизитыТаблицы = ПолучитьРеквизиты("Товары");
	Для Каждого Элемент Из РеквизитыТаблицы Цикл
		ИмяРеквизита = Элемент.Имя;
		Если Найти(ИмяРеквизита, "Цена") ИЛИ Найти(ИмяРеквизита, "НоваяЦена") ИЛИ Найти(ИмяРеквизита, "Процент")  Тогда
			КолонкиТаблицыТоваров.Добавить(ИмяРеквизита);

		КонецЕсли;
	КонецЦикла;
		
	// новые колонки
	
	НовыеКолонки = Новый Массив;
	ИменаНовыхКолонок = Новый Массив;

	Для Каждого Элемент Из СоответствияИмен Цикл
		
		ИмяКолонки = Элемент.Ключ;
			
		Колонки.Добавить("Цена" + ИмяКолонки, ТипЧисло);           
		Колонки.Добавить("НоваяЦена" + ИмяКолонки, ТипЧисло);        
        Колонки.Добавить("Процент" + ИмяКолонки, ТипЧисло);           
		
		
		ИменаНовыхКолонок.Добавить("Цена" + ИмяКолонки);
        ИменаНовыхКолонок.Добавить("НоваяЦена" + ИмяКолонки);
        ИменаНовыхКолонок.Добавить("Процент" + ИмяКолонки);
		                                                               
		НовыеКолонки.Добавить(Новый РеквизитФормы("Цена" + ИмяКолонки, ТипЧисло, "Товары", ИмяКолонки, Истина));
		НовыеКолонки.Добавить(Новый РеквизитФормы("НоваяЦена" + ИмяКолонки, ТипЧисло, "Товары", ИмяКолонки, Истина));
		НовыеКолонки.Добавить(Новый РеквизитФормы("Процент" + ИмяКолонки, ТипЧисло, "Товары", ИмяКолонки, Истина));
		
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
			КолонкиУдалить.Добавить("Товары." + Строка);
			
			ИмяТипЦен = "";
			Если Найти(Строка, "Цена") Тогда
				ИмяТипЦен = СтрЗаменить(Строка,  "Цена", "");
			ИначеЕсли Найти(Строка, "НоваяЦена") Тогда
				ИмяТипЦен = СтрЗаменить(Строка,  "НоваяЦена", "");
			ИначеЕсли Найти(Строка, "Процент") Тогда
				ИмяТипЦен = СтрЗаменить(Строка,  "Процент", "");
			КонецЕсли;
			
			Если Не ПустаяСтрока(ИмяТипЦен) И ГруппыУдалить.Найти(ИмяТипЦен) = Неопределено Тогда
				ГруппыУдалить.Добавить(ИмяТипЦен);
			КонецЕсли;
  		
		КонецЕсли;
		
	КонецЦикла;
	
	ИзменитьРеквизиты(КолонкиДобавить, КолонкиУдалить);
	Для Каждого Строка Из ГруппыУдалить Цикл
		Если Элементы.Товары.ПодчиненныеЭлементы["Группа" + Строка] <> Неопределено Тогда
			Элементы.Удалить(Элементы.Товары.ПодчиненныеЭлементы["Группа" + Строка]);
		КонецЕсли;
	КонецЦикла;
	
	// Добавим колонки на форме
	Для Каждого Элемент Из ГруппыДобавить Цикл
			
		ИмяКолонки = Элемент;	
		
		НоваяГруппа =  ДобавитьГруппуФормы("Группа" + ИмяКолонки,  СоответствияИмен[Элемент].Наименование, Элементы.Товары, ГруппировкаКолонок.Горизонтальная);
									   
		//НоваяПодГруппа = ДобавитьГруппуФормы("ПодГруппа" + ИмяКолонки, СоответствияИмен[Элемент].Наименование, НоваяГруппа, ГруппировкаКолонок.Горизонтальная, Ложь);
		
		ДобавитьПолеФормы("Цена" + ИмяКолонки, НоваяГруппа, "Цена",,, Истина);
		ДобавитьПолеФормы("НоваяЦена" + ИмяКолонки, НоваяГруппа,  "Новая цена" , "НоваяЦенаПриИзменении");
				
		ДобавитьПолеФормы("Процент" + ИмяКолонки, НоваяГруппа, "Процент скидки", "ПроцентСкидкиПриИзменении");	
		                                                                                        
	КонецЦикла;
	
	// Заполним строки
	
	Если ЗагрузитьТовары Тогда
		 ЗагрузитьСписокТоваров(Таблица);
	Иначе	 
		// ИзменитьСписокТоваров(Таблица);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСоответствияИменКолонок()
	
	Соответствия	= Новый Соответствие;
	Инд				= 0;
	
	Для Каждого Элемент Из ТипыЦен Цикл Инд = Инд + 1;
		Соответствия.Вставить(СтрЗаменить(Строка(Элемент.Значение.УникальныйИдентификатор()),"-",""), Элемент.Значение);
	КонецЦикла;
	
	Возврат Соответствия;
	
КонецФункции

&НаСервере
Функция ПолучитьСоответствияТиповЦен() Экспорт
	
	Соответствия	= Новый Соответствие;
	Инд				= 0;
	
	Для Каждого Элемент Из ТипыЦен Цикл Инд = Инд + 1;
			
		Соответствия.Вставить(Элемент.Значение, СтрЗаменить(Строка(Элемент.Значение.УникальныйИдентификатор()),"-",""));
		
	КонецЦикла;
	
	Возврат Соответствия;
	
КонецФункции


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
				НовСтрока["НоваяЦена" + ИмяКолонки] = Строка.НоваяЦена;
				НовСтрока["Процент" + ИмяКолонки] = Строка.ПроцентСкидки;
			
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	// Загрузим в таблицу
	
	Товары.Загрузить(Таблица);
	
КонецПроцедуры

&НаСервере
Функция ДобавитьПолеФормы(Имя, Группа, Заголовок = Неопределено, ОбработчикПриИзменении = "", НачалоВыбораИзСписка = "", ИзменитьЦвет = Ложь, ОтображатьВШапке = Истина, ЦветФона = Неопределено, ЦветФонаЗаголовка = Неопределено)
	                      // уникальное имя     тип      родитель       
	НовоеПоле = Элементы.Добавить(Имя, Тип("ПолеФормы"), Группа);	
	НовоеПоле.ПутьКДанным = "Товары." + Имя;
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
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ЗаполнитьТаблицуТовары();
	//ВидимостьКолонок();	
	
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	Если Объект.Ссылка.Пустая() Тогда	
		Объект.Валюта = КэшируемыеФункции.ВалютаУправленческогоУчета(); 
		Объект.ТипЦен = ОбщиеФункции.НастройкаПользователя("ПоУмолчанию_ТипЦен");
	Иначе
		ЗагрузитьСписокТиповЦен();
		//ЗагрузитьСписокУчастников();
		СформироватьТаблицуТоваров(Истина);
	КонецЕсли;
		
	// не выбираются общие реквизиты для этого документа, какой то глюк
	//ФункцииФормДокументов.ЗаполнитьЗначенияПоУмолчанию(
	//				Объект,
	//				ФункцииФормДокументов.ПолучитьРеквизитыДокумента(Документы.Акция.ПустаяСсылка()));
	
	GUID = Объект.Ссылка.УникальныйИдентификатор();
		
КонецПроцедуры
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Запишем картинку
	
	Если ЭтоАдресВременногоХранилища(АдресКартинки) Тогда
		ТекущийОбъект.Картинка = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресКартинки));
	КонецЕсли;
	
	//// Автосохранение
	//Если Не Отказ И Объект.Ссылка.Пустая() Тогда АвтосохранениеСервер.УдалитьАвтоСохранение(ИмяФормы, Объект.Ссылка) КонецЕсли;
	//
КонецПроцедуры
 
&НаСервере
Процедура ВидимостьКолонок()
	
	// тупо так
	Если 
		Объект.ВариантСкидки = Перечисления.ВариантСкидки.Товар Тогда
		
//		Элементы.ТоварыТовар.Видимость = Истина;
 		Элементы.КолонкаПроцент.Видимость = Ложь;
		Элементы.КолонкаЦена.Видимость = Ложь;
	ИначеЕсли
		Объект.ВариантСкидки = Перечисления.ВариантСкидки.Процент Тогда
		
//		Элементы.ТоварыТовар.Видимость = Ложь;
 		Элементы.КолонкаПроцент.Видимость = Истина;
		Элементы.КолонкаЦена.Видимость = Ложь;
	Иначе
//		Элементы.ТоварыТовар.Видимость = Ложь;
 		Элементы.КолонкаПроцент.Видимость = Ложь;
		Элементы.КолонкаЦена.Видимость = Истина;
		
	КонецЕсли;	


КонецПроцедуры
&НаКлиенте
Процедура ВариантСкидкиПриИзменении(Элемент)
	
	//ВидимостьКолонок();	
	
КонецПроцедуры

// ОБРАБОТЧИКИ

&НаКлиенте
Процедура НоваяЦенаПриИзменении(Элемент)
	
	ИмяКолонки = Прав( Элемент.Имя, СтрДлина( Элемент.Имя)-СтрДлина(СокрЛП("НоваяЦена")));
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		РасчитатьПроцентСкидки(ТекущиеДанные, ИмяКолонки); КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПроцентСкидкиПриИзменении(Элемент)

	ИмяКолонки = Прав( Элемент.Имя, СтрДлина( Элемент.Имя)-СтрДлина(СокрЛП("Процент")));
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
	
		РасчитатьНовуюЦену(ТекущиеДанные, ИмяКолонки); КонецЕсли;	
КонецПроцедуры


// ИНФОРМАЦИЯ О ТОВАРЕ

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре()	
	 	
КонецПроцедуры
&НаСервере
Процедура ОбработатьОтображениеИнформацииОТоваре() Экспорт
	РаботаСНоменклатурой.ОбработатьОтображениеИнформацииОТоваре(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ИнфТовараТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура ИнфТовараЗаголовокHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараЗаголовокHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры

 &НаКлиенте
Процедура ПоказатьСкрытьИнфОТоваре(Команда)
	РаботаСНоменклатуройКлиент.ПоказатьСкрытьИнфОТоваре(ЭтаФорма);
КонецПроцедуры
&НаКлиенте
Процедура НастройкаИнфОТоваре(Команда) 
	РаботаСНоменклатуройКлиент.НастройкаИнфОТоваре(ЭтаФорма);
КонецПроцедуры


//&НаСервере
//Функция КонтрольУникальность(стрОшибки)
//	
//	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
//	
//	Запрос = Новый Запрос("	ВЫБРАТЬ
//							|	Товары.Номенклатура,
//							|	Товары.Скидка
//							|ПОМЕСТИТЬ
//							|	ТоварыАкции
//							|ИЗ
//							|	&ВыбТаблица КАК Товары");
//	
//	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
//	
//	Таб = Товары.Выгрузить(,"Номенклатура, " + Строка(Объект.ВариантСкидки));
//	Таб.Колонки[Строка(Объект.ВариантСкидки)].Имя = "Скидка";
//	ТоварыОбъект.Загрузить(Таб);
//	
//	ВремТаблица = ТоварыОбъект.Выгрузить();
// // ВремТаблица.Свернуть("Номенклатура");
//	
//	Запрос.УстановитьПараметр("ВыбТаблица", ВремТаблица);

//	Запрос.Выполнить();
//	
//	Запрос.Текст = "ВЫБРАТЬ
//					|	Рег.Номенклатура	Номенклатура,
//					|	Рег.Акция			Акция
//					|ИЗ
//					|	РегистрСведений.Акция Рег
//					|	ГДЕ Рег.Номенклатура В (Выбрать Номенклатура ИЗ ТоварыАкции) И 
//					|		Рег.ТипЦен = &ТипЦен И 
//					|		Рег.Акция <> &Акция И 
//					|		Акция <> ЗНАЧЕНИЕ(Документ.Акция.ПустаяСсылка) И 
//					|		Рег.Период < &ДатаОкончания И 
//					|		Рег.Период >= &ДатаНачала
//					|;
//					|ВЫБРАТЬ Тов.Номенклатура, Тов.Скидка ИЗ ТоварыАкции Тов ГДЕ ВЫБОР КОГДА Тов.Скидка ССЫЛКА Справочник.Номенклатура ТОГДА Тов.Скидка = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) ИНАЧЕ Тов.Скидка = 0 КОНЕЦ
//					|;
//					|ВЫБРАТЬ Тов.Номенклатура ИЗ ТоварыАкции Тов СГРУППИРОВАТЬ ПО Тов.Номенклатура ИМЕЮЩИЕ КОЛИЧЕСТВО(Тов.Номенклатура)>1";
//				
//	Запрос.УстановитьПараметр("Акция", Объект.Ссылка);
//	Запрос.УстановитьПараметр("ТипЦен", Объект.ТипЦен);

//	Запрос.УстановитьПараметр("ДатаНачала", Объект.ДатаНачала);
//	Запрос.УстановитьПараметр("ДатаОкончания", Объект.ДатаОкончания);

//	РезультатЗапроса = Запрос.ВыполнитьПакет();

//	Если НЕ РезультатЗапроса[0].Пустой() Тогда
//		Выборка = РезультатЗапроса[0].Выбрать();
//		Пока Выборка.Следующий() Цикл
//			Сообщить("Товар уже участвует в акции: " + Выборка.Номенклатура + "(" + Выборка.Акция + ")");
//		КонецЦикла;
//		Возврат Ложь;
//	КонецЕсли;
//	Если НЕ РезультатЗапроса[1].Пустой() Тогда
//		стрОшибки = "Величина скидки не может быть пустой";
//		Возврат Ложь;
//	КонецЕсли;
//	Если НЕ РезультатЗапроса[2].Пустой() Тогда
//		стрОшибки = "Для товара не может быть назначено несколько скидок";
//		Возврат Ложь;
//	КонецЕсли;	
//	Возврат Истина;
//КонецФункции

&НаСервере
Процедура УдалитьЛишниеКолонки()

	СоответствиеЦен = ПолучитьСоответствияТиповЦен();
	ТаблицаТовары	= Объект.Товары;
	КолСтрок		= ТаблицаТовары.Количество();
	
	Для Ном = 1 По КолСтрок Цикл
		
		Строка = ТаблицаТовары[КолСтрок - Ном];
		Если СоответствиеЦен[Строка.ТипЦен] = Неопределено Тогда
			
			ТаблицаТовары.Удалить(Строка);
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	
	// Удалим все колонки которые не отображенны
	
	УдалитьЛишниеКолонки();
	ЗаполнитьТабличнуюЧасть();
	//ЗаполнитьТабличнуюЧастьУчастники();
	//Если НЕ Объект.Ссылка.Пустая() И Товары.Количество() > 0 Тогда
	//	стрОшибки = "";
	//	Если НЕ КонтрольУникальность(стрОшибки) Тогда
	//		Если НЕ ПустаяСтрока(стрОшибки) Тогда
	//			Сообщить(стрОшибки);
	//		КонецЕсли;
	//		
	//		//Иначе
	//		//	Ответ = Вопрос("Для товара, уже участвующего в акции вступят в силу новые усолвия. Выполнить запись?", РежимДиалогаВопрос.ДаНет);
	//		//	Если Ответ = КодВозвратаДиалога.Нет Тогда
	//		//		Отказ = Истина;	
	//		//	КонецЕсли; 
	//		
	//		Отказ = Истина;

	//	КонецЕсли;
	//		
	//КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоваяЦенаПриИзменении(Элемент)
	РасчитатьНовуюЦену();
КонецПроцедуры

&НаКлиенте
Процедура РасчитатьНовуюЦену(ТекущиеДанные = Неопределено, ИмяКолонки = "")
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные; КонецЕсли;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные["НоваяЦена"+ ИмяКолонки] = ТекущиеДанные["Цена"+ ИмяКолонки] - ТекущиеДанные["Цена"+ ИмяКолонки]*ТекущиеДанные["Процент" + ИмяКолонки]/100; 
	КонецЕсли;

КонецПроцедуры
&НаСервере
Процедура РасчитатьНовуюЦенуНаСервере(ТекущиеДанные = Неопределено, ИмяКолонки = "")
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные; КонецЕсли;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные["НоваяЦена"+ ИмяКолонки] = ТекущиеДанные["Цена"+ ИмяКолонки] - ТекущиеДанные["Цена"+ ИмяКолонки]*ТекущиеДанные["Процент" + ИмяКолонки]/100; 
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура РасчитатьПроцентСкидки(ТекущиеДанные = Неопределено, ИмяКолонки = "")
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные; КонецЕсли;	

	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные["Процент" + ИмяКолонки] = (ТекущиеДанные["Цена"+ ИмяКолонки] - ТекущиеДанные["НоваяЦена"+ ИмяКолонки])*100/ТекущиеДанные["Цена"+ ИмяКолонки]; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
	
	ПересчитатьЦенуТовара(ТекущиеДанные); КонецЕсли;

КонецПроцедуры
&НаКлиенте
Функция ПересчитатьЦенуТовара(ТекущиеДанные)
	СоответствиеТиповЦен = ПолучитьСоответствияТиповЦен();			
	
		Для Каждого СтрокаТипЦен Из ТипыЦен Цикл
			
			текТипЦен = СтрокаТипЦен.Значение;
			
			ИмяКолонки = СоответствиеТиповЦен[текТипЦен];
			Если ИмяКолонки <> Неопределено Тогда
				
				текЦена = РаботаСНоменклатурой.ПолучитьЦену(ТекущиеДанные.Номенклатура, текТипЦен, Объект.Валюта, ТекущиеДанные.Упаковка);
				ТекущиеДанные["Цена" + ИмяКолонки] = текЦена;
				ТекущиеДанные["НоваяЦена" + ИмяКолонки] = 0;
			
				Если ТекущиеДанные["Процент" + ИмяКолонки] <> 0 Тогда
					РасчитатьНовуюЦену(ТекущиеДанные, ИмяКолонки);
				КонецЕсли; КонецЕсли; КонецЦикла;
	
КонецФункции

&НаСервере
Функция ПересчитатьЦенуТовараНаСервере(ТекущиеДанные)
	СоответствиеТиповЦен = ПолучитьСоответствияТиповЦен();			
	
		Для Каждого СтрокаТипЦен Из ТипыЦен Цикл
			
			текТипЦен = СтрокаТипЦен.Значение;
			
			ИмяКолонки = СоответствиеТиповЦен[текТипЦен];
			Если ИмяКолонки <> Неопределено Тогда
				
				текЦена = РаботаСНоменклатурой.ПолучитьЦену(ТекущиеДанные.Номенклатура, текТипЦен, Объект.Валюта, ТекущиеДанные.Упаковка);
				ТекущиеДанные["Цена" + ИмяКолонки] = текЦена;
				ТекущиеДанные["НоваяЦена" + ИмяКолонки] = 0;
			
				Если ТекущиеДанные["Процент" + ИмяКолонки] <> 0 Тогда
					РасчитатьНовуюЦенуНаСервере(ТекущиеДанные, ИмяКолонки);
				КонецЕсли; КонецЕсли; КонецЦикла;
	
КонецФункции


&НаСервере
Процедура ПересчитатьСуммыТабличныхЧастей(СтруктураКолонокТовары) Экспорт
	
	Для Каждого Строка Из Товары Цикл ПересчитатьЦенуТовараНаСервере(Строка) КонецЦикла;

КонецПроцедуры

			

&НаКлиенте
Процедура ТоварыПроцентСкидкиПриИзменении(Элемент)
	 РасчитатьПроцентСкидки();
КонецПроцедуры
&НаСервере
Функция ПолучитьТипыЦен()
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.ТипыЦен ГДЕ НЕ ПометкаУдаления УПОРЯДОЧИТЬ ПО Наименование");
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаКлиенте
Процедура ТипыЦенНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	СписокТиповЦен 	= ПолучитьТипыЦен();
	СписокВыбора 	= Новый СписокЗначений;
	
	// Проставим отметки
	
	СтарыеОтметки = Новый Массив;
	
	СписокВыбора.ЗагрузитьЗначения(СписокТиповЦен);
	
	Для Каждого ЭлементСписка Из СписокВыбора Цикл
		
		ЭлементСписка.Пометка = ТипыЦен.НайтиПоЗначению(ЭлементСписка.Значение) <> Неопределено;
		Если ЭлементСписка.Пометка Тогда
			СтарыеОтметки.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	// Выберем
	
	Если СписокВыбора.ОтметитьЭлементы("Выбор типов цен:") Тогда
		
		// Созадим список
		
		НовыеОтметки = Новый Массив;
		
		ТипыЦен.Очистить();
		Для Каждого ЭлементСписка Из СписокВыбора Цикл
			Если ЭлементСписка.Пометка Тогда
				
				ВыбранноеЗначение = ЭлементСписка.Значение;
				
				ТипыЦен.Добавить(ВыбранноеЗначение);
				
				Если СтарыеОтметки.Найти(ВыбранноеЗначение) = Неопределено Тогда
					НовыеОтметки.Добавить(ВыбранноеЗначение);
				КонецЕсли;
				
			КонецЕсли; 
			
		КонецЦикла;
		
		// Обновим товары
		
		СформироватьТаблицуТоваров();
		
		// проставить пустые колонки ценами из предыдущих установок цен
		
		ЗаполнитьЦены(НовыеОтметки);
		
		//ЗаполнитьПодменюЗаполнитьВалюту();
		//ЗаполнитьПодменюОчиститьЦены();
		//ЗаполнитьПодменюОкруглитьЦены();
		
	КонецЕсли;
	

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМеню()
	
	ЗаполнитьПодменюБазовымиТипамиЦен("КомандыЗаполнить", "КомандаПроцент", "ЗаполнитьПроцентСкидки",1)	
	
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
Процедура ЗаполнитьЦены(НовыеТипыЦен)
	
	СоответствияТиповЦен = ПолучитьСоответствияТиповЦен();
	Для Каждого ТипЦенКолонки Из НовыеТипыЦен Цикл
		ИмяКолонки = СоответствияТиповЦен[ТипЦенКолонки];
		Для Каждого Строка Из Товары Цикл
			Строка["Цена" + ИмяКолонки] 	= РаботаСНоменклатурой.ПолучитьЦену(Строка.Номенклатура, ТипЦенКолонки, Объект.Валюта, Строка.Упаковка);
		КонецЦикла;
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
	
				
	ПересчитатьЦенуТовара(ТекущиеДанные); КонецЕсли;

КонецПроцедуры


#Область Подбор

&НаСервере
Функция ПоместитьТоварыВХранилище() 
	
	Возврат ПоместитьВоВременноеХранилище(
					Объект.Товары.Выгрузить(, "Номенклатура, Упаковка"), 
					УникальныйИдентификатор);
КонецФункции
&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресТоваровВХранилище)
	
	Таблица = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	Таблица.Свернуть("Номенклатура, Упаковка");
	Колонки		= Таблица.Колонки;
	
//	Колонки.Добавить("НомерСтроки", 	Новый ОписаниеТипов("Число"));

	СоответствияИмен = ПолучитьСоответствияИменКолонок();
	
	Для Каждого Элемент Из СоответствияИмен Цикл
		
		ИмяКолонки = Элемент.Ключ;
			
		Колонки.Добавить("Цена" + ИмяКолонки, Новый ОписаниеТипов("Число")); 		
		Колонки.Добавить("НоваяЦена" + ИмяКолонки, Новый ОписаниеТипов("Число"));  		
		Колонки.Добавить("Процент" + ИмяКолонки, Новый ОписаниеТипов("Число"));  			
	КонецЦикла;
	
	ДобавитьВСписокТоваров(Таблица);
	 		
КонецПроцедуры
Процедура ДОбавитьВСписокТоваров(Таблица)
	
	СоответствияТиповЦен = ПолучитьСоответствияТиповЦен();
	
	Для Каждого Строка Из Таблица Цикл
		
		нСтроки = Товары.НайтиСтроки(Новый Структура("Номенклатура, Упаковка", Строка.Номенклатура, Строка.Упаковка));
		Если нСтроки.Количество() Тогда
			НовСтрока = нСтроки[0]; 
		Иначе
			НовСтрока = Товары.Добавить();
			НовСтрока.Номенклатура 	= Строка.Номенклатура;
			НовСтрока.Упаковка 		= Строка.Упаковка;
		КонецЕсли;
		
		Для Каждого СтрокаТипЦен Из ТипыЦен Цикл
			
			текТипЦен = СтрокаТипЦен.Значение;
			
			ИмяКолонки = СоответствияТиповЦен[текТипЦен];
			Если ИмяКолонки <> Неопределено Тогда
				
				текЦена = РаботаСНоменклатурой.ПолучитьЦену(НовСтрока.Номенклатура, текТипЦен,Объект.Валюта, НовСтрока.Упаковка);
				НовСтрока["Цена" + ИмяКолонки] = текЦена;
			
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Загрузим в таблицу

	//ТаблицаТоваров.Загрузить(Таблица);

КонецПроцедуры


&НаКлиенте
Процедура Подбор(Кнопка = Неопределено, ДополнительныеПараметрыПодбора = Неопределено)
	
	ИмяТабличнойЧасти = "Товары";
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	ПараметрыПодбора = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	
	ПараметрыПодбора.Вставить("СтруктураКолонокТовары", СтруктураКолонокТовары);
	//ПараметрыПодбора.Вставить("ВидЗапроса", "СписокНоменклатуры");
	//ПараметрыПодбора.Вставить("ВидыЗапросов", "СписокНоменклатуры");

	//// Автосохранение
	//АвтосохранениеКлиент.ОткрываетсяПодбор(ПараметрыПодбора, Объект.Ссылка, ЭтаФорма, ПолучитьДамп());
	//Если ДополнительныеПараметрыПодбора <> Неопределено Тогда
	//	КонвертацияТипов.ДобавитьВСтруктуруСтруктуру(ПараметрыПодбора, ДополнительныеПараметрыПодбора) КонецЕсли;
	//
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", ПараметрыПодбора, Элементы.Товары);
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение <> Неопределено Тогда		
		
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
			
			ПолучитьТоварыИзХранилища(ВыбранноеЗначение.Товары);		// получаем
			УдалитьИзВременногоХранилища(ВыбранноеЗначение.Товары); 	// заметаем следы
		
		Иначе
			
			ПолучитьТоварыИзХранилища(ВыбранноеЗначение);		// получаем
			УдалитьИзВременногоХранилища(ВыбранноеЗначение); 	// заметаем следы
		КонецЕсли;
		
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

&НаКлиенте
Процедура ПриЗакрытии()
	
	// Автосохранение
	АвтосохранениеСервер.УдалитьАвтоСохранение(ИмяФормы, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПроцентСкидки(Команда)
	
	ИмяКолонки = СтрЗаменить(Команда.Имя, "КомандаПроцент", "");
	
	ПроцентСкидки = 0;
	ВвестиЧисло(ПроцентСкидки, "Процент скидки:", 5, 2);

	Для Каждого Строка Из Товары Цикл
		
		Строка["Процент" + ИмяКолонки]= ПроцентСкидки;
				
		РасчитатьНовуюЦену(Строка, ИмяКолонки);

	КонецЦикла;

КонецПроцедуры
	
#КонецОбласти

// МЕНЮ - "ЗАГРУЗИТЬ"
&НаКлиенте
Процедура ЗагрузитьДанныеExcel(Команда)
	  ЗагрузитьВнешниеДанные(Команда.Имя);
КонецПроцедуры
&НаКлиенте
Процедура ЗагрузитьДанныеТабличногоДокумента(Команда)
	  ЗагрузитьВнешниеДанные(Команда.Имя);
КонецПроцедуры
&НаКлиенте
Процедура ЗагрузитьВнешниеДанные(ИмяКоманды)
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();

	ОткрытьФорму("Документ.ЗаказПокупателя.Форма.ЗагрузкаДанных", Новый Структура("Страница, СтруктураКолонокТовары, ИмяТаблицы, АдресТоваровВХранилище", ИмяКоманды, СтруктураКолонокТовары, "Товары", АдресТоваровВХранилище), Элементы.Товары);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение = "ВнешниеДанныеЗагружены" Тогда
		 ЗаполнитьЦены(ТипыЦен.ВыгрузитьЗначения());	
		//УправлениеВидимостьюДоступностью();
	
		//ФункцииФормДокументов.ОбновитьПодвал(ЭтаФорма, Элементы, Всего, СтруктураКолонокТовары,,  "ВсегоНДС", ВсегоНДС);
	КонецЕсли;
	

КонецПроцедуры

// КАРТИНКА

&НаКлиенте
Процедура КартинкаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	новАдресКартинки = "";
	Если ПоместитьФайл(новАдресКартинки, "", "", Истина, УникальныйИдентификатор) Тогда
		АдресКартинки = новАдресКартинки;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура КартинкаПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыПеретаскивания.ДопустимыеДействия = ?(
					ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл"),
								ДопустимыеДействияПеретаскивания.Копирование,
								ДопустимыеДействияПеретаскивания.НеОбрабатывать);
	
КонецПроцедуры
&НаКлиенте
Процедура КартинкаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	АдресКартинки = "";
	Если ПоместитьФайл(АдресКартинки, ПараметрыПеретаскивания.Значение.ПолноеИмя, "", Ложь, УникальныйИдентификатор) Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

// КОРЗИНА
#Если Не ВебКлиент Тогда
&НаСервере
Процедура ДобавитьИзКорзиныНаСервере(ИмяКомпа, СтруктураКолонокТовары, КолСтрок)
	
	МодульКорзины.ПолучитьТоварИзКорзины(Элементы.Товары, Товары, СтруктураКолонокТовары, ИмяКомпа, КолСтрок);
	
КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура ВставитьИзКорзины(Команда)
	
	КолСтрок = 0;
	ДобавитьИзКорзиныНаСервере(ИмяКомпьютера(), СтруктураКолонокТовары, КолСтрок);
	
	Если КолСтрок Тогда
		
		МодульКорзины.ОповеститьОВставкеТовараВДокумент(КолСтрок, Товары.Количество());
		
	Иначе
		
		МодульКорзины.ОповеститьЧтоНечегоДобавлять();
		
	КонецЕсли;
	

КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаСервере
Функция ПоложитьВКорзинуНаСервере(ВыделенныеИндексы, ИмяКомпа, КолВКорзине)
	
	Возврат МодульКорзины.ПоложитьТоварВКорзину(Товары, ВыделенныеИндексы, ИмяКомпа, КолВКорзине);
	
КонецФункции
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура ДобавитьВКорзину(Команда)
	
	ВыделенныеИндексы 	= МодульКорзины.ПолучитьВыделенныеСтрокиТоваров(Элементы.Товары, Товары);
	КолВКорзине 		= 0;
	КолТовара			= ВыделенныеИндексы.Количество();
	
	
	Если КолТовара Тогда
		
		Если ПоложитьВКорзинуНаСервере(ВыделенныеИндексы, ИмяКомпьютера(), КолВКорзине) Тогда
			МодульКорзины.ОповеститьОПомещенииТовара(КолТовара, КолВКорзине);
		КонецЕсли;
		
	Иначе
		
		МодульКорзины.ОповеститьЧтоНечегоДобавлять();
				
	КонецЕсли;

КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура РедактироватьТоварВКорзине(Команда)
	
	ОткрытьФорму("РегистрСведений.Корзина.Форма.Форма");
	
КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаСервере
Функция ОчиститьНаСервере(ИмяКомпа)
	
	Возврат МодульКорзины.ОчиститьКорзину(ИмяКомпа);
	
КонецФункции
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура ОчиститьКорзину(Команда)
	
	Если ОчиститьНаСервере(ИмяКомпьютера()) Тогда
		
		МодульКорзины.ОповеститьЧтоКорзинаОчищена();
		
	КонецЕсли;

КонецПроцедуры
#КонецЕсли




