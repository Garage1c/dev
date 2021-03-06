﻿&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;

&НаКлиенте
Процедура ОбщиеРеквизиты(Команда)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизиты(ЭтаФорма);
	
КонецПроцедуры
&НаКлиенте
Процедура УправлениеВидимостьюДоступностью()
	
	
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостьюДоступностьюСервер()
	СогласованиеДоступно = СогласованиеДоступно();
	Элементы.Статус.Доступность = СогласованиеДоступно;
	Если Не СогласованиеДоступно И Объект.Статус = Перечисления.СтатусыВнутреннегоЗаказа.Согласовано Тогда
		Элементы.ОснованиеВыдачиИнструмента.Доступность = Ложь		
	КонецЕсли;
КонецПроцедуры



// ПРЕДОПРЕДЕЛЕННЫЕ ПРОЦЕДУРЫ

&НаСервере
Функция ПолучитьПроцессДляЗаказа()
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ БизнесПроцесс.СборкаЗаказа ГДЕ Заказ = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Рассчитаем динамические колонки
	
	ФункцииФормДокументов.РассчитатьДинамическиеКолонки(
					Объект.Товары,
					ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Истина));
					
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	Если ТипЗнч(ОБъект.Заказчик) = Тип("СправочникСсылка.Склады") Тогда
		Процесс = ПолучитьПроцессДляЗаказа();
	Иначе
		Процесс = ОБъект.Заказчик;
	КонецЕсли;
	Если Процесс <> Неопределено Тогда
		Товары.Загрузить(Заказы.ПолучитьТаблицуТоваровВнутр(Процесс));
	КонецЕсли;

	УправлениеВидимостьюДоступностьюСервер();
КонецПроцедуры

Функция МожноСоздаватьЗаказ()
	Возврат РольДоступна("ПолныеПрава") Или РольДоступна("ПолныеПраваВОбласти");	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Истина);
	
	УправлениеВидимостьюДоступностью();
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Отказ = Истина;
		
		Если Вопрос("Для создания внутреннего заказа рекомендуется
				|использовать ""Внутреннюю заявку""
				|Открыть заявку?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			
			ОткрытьФорму("БизнесПроцесс.ВнутренняяЗаявка.ФормаОбъекта");
		ИначеЕсли МожноСоздаватьЗаказ() Тогда
			Отказ = Ложь;	
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры


// ПОДБОР

&НаСервере
Функция ПоместитьТоварыВХранилище() 
	
	Возврат ПоместитьВоВременноеХранилище(
					Объект.Товары.Выгрузить(), 
					УникальныйИдентификатор);
КонецФункции
&НаКлиенте
Процедура ПодборВыполнить()
	
	ИмяТабличнойЧасти = "Товары";
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	ПараметрыПодбора = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	
	ПараметрыПодбора.Вставить("СтруктураКолонокТовары", СтруктураКолонокТовары);
	//ПараметрыПодбора.Вставить("ВидЗапроса", 			"ОстаткиНоменклатуры");
	//ПараметрыПодбора.Вставить("ВидыЗапросов", 			"СписокНоменклатуры");
	ПараметрыПодбора.Вставить("Склад", 					Объект.Склад);
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", ПараметрыПодбора, Элементы.Товары);
	
КонецПроцедуры
&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресТоваровВХранилище)
	
	Объект.Товары.Загрузить(ПолучитьИзВременногоХранилища(АдресТоваровВХранилище));
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение <> Неопределено Тогда		
		
		ПолучитьТоварыИзХранилища(ВыбранноеЗначение);		// получаем
		УдалитьИзВременногоХранилища(ВыбранноеЗначение); 	// заметаем следы
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры


// ОБРАБОТКИ ТАБЛИЧНОЙ ЧАСТИ

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент, КонкретнаяСтрока = Неопределено)

	ФункцииФормДокументов.НоменклатураПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары,
				КонкретнаяСтрока);

КонецПроцедуры
&НаКлиенте
Процедура КоличествоПриИзменении(Элемент, КонкретнаяСтрока = Неопределено)
	
	ФункцииФормДокументов.КоличествоПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары, 
				КонкретнаяСтрока);
	
КонецПроцедуры
&НаКлиенте
Процедура УпаковкаПриИзменении(Элемент, КонкретнаяСтрока = Неопределено)
	
	ФункцииФормДокументов.УпаковкаПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары, 
				КонкретнаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРазмещение(Команда)
	
	ДиалогиСПользователем.ЗаполнитьРазмещение(Объект.Товары);
	
КонецПроцедуры

// ПРИ ИЗМЕНЕНИИ

&НаКлиенте
Процедура ЗаказчикПриИзменении(Элемент)
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

&НаСервере
Процедура РазместитьНаСервере(СпособРазмещения)
	
	ТЗТоваров = Объект.Товары.Выгрузить();
	
	Заказы.ПроставитьРазмещениеВТаблицеТоваров(
				ТЗТоваров, 
				Объект.Склад,,,,
				СпособРазмещения);
				
	Объект.Товары.Загрузить(ТЗТоваров);
	
КонецПроцедуры
&НаКлиенте
Процедура Разместить(Команда)
	
	СпособРазмещения = ОткрытьФорму("ОбщаяФорма.ДиалогРазмещения",,ЭтаФорма,,,,Новый ОписаниеОповещения("ОбработкаРазмещения",ЭтаФорма,));
		
КонецПроцедуры
&НаКлиенте
Процедура ОбработкаРазмещения(Результат, Параметры) Экспорт
	Если Результат <> Неопределено Тогда
		
		РазместитьНаСервере(Результат);
		
	КонецЕсли;

КонецПроцедуры
&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре()	
	
КонецПроцедуры

// ИНФОРМАЦИЯ О ТОВАРЕ

&НаСервере
Процедура ОбработатьОтображениеИнформацииОТоваре() Экспорт
	
	РаботаСНоменклатурой.ОбработатьОтображениеИнформацииОТоваре(ЭтаФорма, "Товары", "Объект.Товары");
	
КонецПроцедуры

&НаКлиенте
Процедура ИнфТовараТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиент.ИнфТовараТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
	
КонецПроцедуры
&НаКлиенте
Процедура ИнфТовараЗаголовокHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	РаботаСНоменклатуройКлиент.ИнфТовараЗаголовокHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка, "Товары", "Объект.Товары");
	
КонецПроцедуры

 &НаКлиенте
Процедура ПоказатьСкрытьИнфОТоваре(Команда)
	
	РаботаСНоменклатуройКлиент.ПоказатьСкрытьИнфОТоваре(ЭтаФорма);
	
КонецПроцедуры
&НаКлиенте
Процедура НастройкаИнфОТоваре(Команда) 
	
	РаботаСНоменклатуройКлиент.НастройкаИнфОТоваре(ЭтаФорма, "Товары", "Объект.Товары");
	
КонецПроцедуры

// МОДУЛЬ КОРЗИНЫ
#Если Не ВебКлиент Тогда
&НаСервере
Функция ПоложитьВКорзинуНаСервере(ВыделенныеИндексы, ИмяКомпа, КолВКорзине)
	
	Возврат МодульКорзины.ПоложитьТоварВКорзину(Объект.Товары, ВыделенныеИндексы, ИмяКомпа, КолВКорзине);
	
КонецФункции
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура ДобавитьВКорзину(Команда)
	
	ВыделенныеИндексы 	= МодульКорзины.ПолучитьВыделенныеСтрокиТоваров(Элементы.Товары, Объект.Товары);
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
&НаСервере
Процедура ДобавитьИзКорзиныНаСервере(ИмяКомпа, СтруктураКолонокТовары, КолСтрок)
	
	МодульКорзины.ПолучитьТоварИзКорзины(Элементы.Товары, Объект.Товары, СтруктураКолонокТовары, ИмяКомпа, КолСтрок);
	
КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура ВставитьИзКорзины(Команда)
	
	КолСтрок = 0;
	ДобавитьИзКорзиныНаСервере(ИмяКомпьютера(), СтруктураКолонокТовары, КолСтрок);
	
	Если КолСтрок Тогда
		
		МодульКорзины.ОповеститьОВставкеТовараВДокумент(КолСтрок, Объект.Товары.Количество());
		
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


// ВЕС ОБЪЕМ
&НаСервере
Функция ПодготовитьТаблицу()
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Объект.Товары.Выгрузить(), УникальныйИдентификатор);
	
	Возврат АдресХранилища;
	
КонецФункции

&НаКлиенте
Процедура ВесОбъем(Команда)
	АдресХранилища = ПодготовитьТаблицу();
	
	ОткрытьФорму("Документ.ВнутреннийЗаказ.Форма.ФормаВеса", Новый Структура("АдресХранилища", АдресХранилища));

КонецПроцедуры

//ОСНОВАНИЕ ВЫДАЧИ ИНСТРУМЕНТА
&НаСервере
Функция СогласованиеДоступно()
	Возврат РольДоступна("Руководитель");
КонецФункции

&НаКлиенте
Процедура ОснованиеВыдачиИнструментаПриИзменении(Элемент)
	Объект.ФИО = "";
	Объект.Статус = ?(Объект.ОснованиеВыдачиИнструмента.Пустая(), "", ПредопределенноеЗначение("Перечисление.СтатусыВнутреннегоЗаказа.НеСогласовано"));
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	Объект.ФИО = ?(Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыВнутреннегоЗаказа.Согласовано"),
					ПолучитьТекущегоПользователя(),"");	
КонецПроцедуры
				
&НаСервереБезКонтекста
Функция ПолучитьТекущегоПользователя()
	 Возврат ПараметрыСеанса.ТекущийПользователь;
КонецФункции	

