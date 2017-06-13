﻿&НаКлиенте
Перем МассивКомментариев Экспорт;


&НаСервере
Функция УстановитьСостояниеИВыполнитьЗадачу(ИмяСостояния)
	
	Если Заказы.УстановитьСостояниеЗаказа(Объект.Заказ, Перечисления.СостоянияЗаказа[ИмяСостояния]) Тогда
	
		Возврат Записать(Новый Структура("ВыполнитьЗадачу",Истина));
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции


// ТИПОВЫЕ

&НаКлиенте
Процедура ДекорацияДобавитьКомментарийНажатие(Элемент)
	
	Элементы.ГруппаДобавитьКомментарий.Видимость 		= Ложь;
	Элементы.ГруппаРедактированиеКомментария.Видимость 	= Истина;

КонецПроцедуры
&НаКлиенте
Процедура ПоказатьСкрытьАдресацию(Команда)
	
	КоманднаяПанель.ПодчиненныеЭлементы.ПоказатьСкрытьАдресацию.Пометка = Не КоманднаяПанель.ПодчиненныеЭлементы.ПоказатьСкрытьАдресацию.Пометка;
	
	// Обновим видимость
	
	ФункцииФормЗадач.ВидимостьАдресации(ЭтаФорма);

КонецПроцедуры
&НаСервере
Процедура ПрочитатьРеквизиты()
	
	ФункцииБизнесПроцессов.ЗаполнитьДанные(ЭтаФорма, 
		Объект.Ссылка.БизнесПроцесс, 
		Объект.Ссылка);
	
КонецПроцедуры
&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	//Элементы.Кнопка_ТоварОтправлен.Видимость		= Не ТолькоПросмотр;
	
КонецПроцедуры

//&НаСервере
//Функция СоздатьОтменыСборок()
//	
//	Успех = Истина;
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = "Выбрать Склад, СборочныйЛист, Номенклатура, КоличествоОстаток Собрано из РегистрНакопления.ТоварыСобранные.Остатки(, Заказ = &Заказ) Итоги По СборочныйЛист,Склад";
//	Запрос.УстановитьПараметр("Заказ", Объект.Заказ);
//	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
//	
//	Пока Выборка.Следующий() Цикл
//		Выборка2 = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
//		Пока Выборка2.Следующий() Цикл
//			
//			Сборка = Документы.ОтменаСборки.СоздатьДокумент();
//			Сборка.Дата 	= ТекущаяДата();
//			Сборка.Заказ 	= Объект.Заказ;
//			Сборка.Склад 	= Выборка2.Склад;
//			Сборка.СборочныйЛист = Выборка2.СборочныйЛист;
//			
//			ВыборкаНом = Выборка2.Выбрать();
//			Пока ВыборкаНом.Следующий() Цикл
//				Стр = Сборка.Товары.Добавить();
//				ЗаполнитьЗначенияСвойств(Стр,ВыборкаНом);
//			КонецЦикла;
//			
//			Успех = Успех и ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Сборка, РежимЗаписиДокумента.Проведение);
//			
//		КонецЦикла;
//	КонецЦикла;
//	
//	Возврат Успех;
//	
//КонецФункции

// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// комментарии
	ФункцииБизнесПроцессовКлиент.ПолучитьМассивКомментариев(ЭтаФорма, Объект.БизнесПроцесс);
	
	ФункцииФормЗадач.ПриОткрытии(Объект, ЭтаФорма, Отказ); // видимость адресации и комментария, доступность формы
	
КонецПроцедуры
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	// комментарии
	ФункцииБизнесПроцессов.ДобавитьРаботуСКомментариями(ЭтаФорма);
	
	ПрочитатьРеквизиты();
	
	УправлениеВидимостьюДоступностью();

КонецПроцедуры
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ФункцииФормЗадач.ПослеЗаписи(Объект, ЭтаФорма, ПараметрыЗаписи);
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//Если 	ПараметрыЗаписи.ВыполнитьЗадачу И
	//		//Не ЗаписатьЗакрывающуюОтменуСборки() Тогда
	//		Не СоздатьОтменыСборок() Тогда
	//	Отказ = Истина; 
	//КонецЕсли;
	//
КонецПроцедуры


&НаСервере
Функция ПроверитьСборщиков()
	
	Отказ = Ложь;
	
	Если НЕ Объект.Склад.УчетПоСбощикамЗаказов Тогда
		Возврат Не Отказ; КонецЕсли;
	
	Инд = -1;
	Для Каждого Строка Из Товары Цикл Инд = Инд + 1;
		Если 	Строка.Количество И
				Строка.Сборщик.Пустая() Тогда
					
			Отказ = Истина;
			ОбщиеФункции.СообщитьТекст("Не выбран сборщик позиции!","Товары[" + Формат(Инд,"ЧГ=") + "].Сборщик"); КонецЕсли; КонецЦикла;
	
	Возврат Не Отказ;
	
КонецФункции
&НаСервере
Функция ПроверитьЯчейки()
	
	Отказ = Ложь;
	
	Если Объект.Склад.Ячеестый Тогда
	
		Инд = -1;
		Для Каждого Строка Из Товары Цикл Инд = Инд + 1;
			Если 	Строка.Количество И
					Строка.Ячейка.Пустая() Тогда
					
				Отказ = Истина;
				ОбщиеФункции.СообщитьТекст("Не заполнена ячейка","Товары[" + Формат(Инд,"ЧГ=") + "].Ячейка"); КонецЕсли; КонецЦикла; КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции



&НаСервере
Функция СформироватьРазборочныйЛистИВыполнитьЗадачу() 
	
	НачатьТранзакцию();
	
	Записать(Новый Структура("ВыполнитьЗадачу",Истина));
	
	Если Товары.Количество() Тогда
		Док = Документы.РазборочныйЛист.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(Док,ЭтаФорма);
		ЗаполнитьЗначенияСвойств(Док,Объект);
		Док.Дата = ТекущаяДата();
		
		Док.Товары.Загрузить(Товары.Выгрузить());
		Док.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
	
КонецФУнкции


// КОМАНДЫ


&НаКлиенте
Процедура ТоварВозвращен(Команда)
	
	// Проверим что ячейки заполнены
	Если Не ПроверитьЯчейки() Тогда Отказ = Истина; Возврат; КонецЕсли;
	
	// Проверим что ячейки заполнены
	Если Не ПроверитьСборщиков() Тогда Отказ = Истина; Возврат; КонецЕсли;
	
	Если СформироватьРазборочныйЛистИВыполнитьЗадачу() Тогда
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначениеДляВсех(Значение = Неопределено, ИмяКолонки, ТолькоСобранные = Ложь, Выражение = "")
	
	//Строки = Товары.НайтиСтроки(Новый Структура("Состояние",ПеречислениеСостояниеСобирается()));
	Для Каждого Строка Из товары Цикл 
		Если Не ТолькоСобранные Или Строка.Количество Тогда 
			Если Выражение = "" Тогда
				Строка[ИмяКолонки] = Значение;
			Иначе
				Выполнить(Выражение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Процедура УстановитьЗначениеДляВыделенных(Значение, ИмяКолонки, ТолькоСобранные = Ложь)
	
	//Собирается = ПеречислениеСостояниеСобирается();
	Для каждого ИдСтроки Из Элементы.Товары.ВыделенныеСтроки Цикл Строка = Товары.НайтиПоИдентификатору(ИдСтроки);
		//Если 
		//	Строка.Состояние = Собирается И 
		//	(Не ТолькоСобранные Или Строка.Собрано)
		//	Тогда
			Строка[ИмяКолонки] = Значение;
		//КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокСборщиков()
	
	Возврат ДиалогиСПользователем.ПолучитьСписокСборщиков();
	
КонецФункции

&НаКлиенте
Процедура ВыбСборщик(Элемент, ДопПараметры) Экспорт
	
	Если Элемент <> Неопределено Тогда
		
		Если Элементы.Товары.ВыделенныеСтроки.Количество() > 1 Тогда
				УстановитьЗначениеДляВыделенных(Элемент.Значение, "Сборщик", Истина);
		Иначе	УстановитьЗначениеДляВсех(Элемент.Значение, "Сборщик", Истина) КонецЕсли; КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСборщика(Команда)
	
	ПоказатьВыборИзМеню(Новый ОписаниеОповещения("ВыбСборщик", ЭтаФорма), ПолучитьСписокСборщиков(), Команда);

КонецПроцедуры



// КОММЕНТАРИИ

&НаКлиенте
Процедура КомандаПоказатьКомментарий(Команда)
	ФункцииБизнесПроцессовКлиент.КомандаПоказатьКомментарий(ЭтаФорма);
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


// ПЕЧАТЬ РАЗБОРОЧНОГО ЛИСТА

&НаСервере
Функция ПолучитьТабличныйДокумент(ВыводитьПомеченные = Ложь)
	
	ТабДокумент 	= Новый ТабличныйДокумент;
	Макет 			= ПолучитьОбщийМакет("СборочныйЛист");

	ОбластьШапка 			= Макет.ПолучитьОбласть("Шапка");
	ОбластьШапка.Область("Наименование").Текст = "Разборочный лист";
	ОбластьКомментарий		= Макет.ПолучитьОбласть("Комментарий");
	ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьСтрока 			= Макет.ПолучитьОбласть("Строка");
	ОбластьИтого 			= Макет.ПолучитьОбласть("Итого");
	
	// Шапка
	
	Если ТипЗнч(Объект.БизнесПроцесс.Заказ) = Тип("ДокументСсылка.ВнутреннийЗаказ") Тогда
		
		ОбластьШапка.Параметры.ПредставлениеКонтрагента = Объект.БизнесПроцесс.Заказ.Заказчик;
		
	//ИначеЕсли ТипЗнч(Объект.БизнесПроцесс.Заказ) = Тип("ДокументСсылка.ИнтернетЗаказПокупателя") Тогда

	Иначе
		
		Представление = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Объект.БизнесПроцесс.Заказ.Контрагент, ТекущаяДата()), "ПолноеНаименование,ЮридическийАдрес",,Символы.ПС);
		Если ПустаяСтрока(Представление) Тогда
			Представление = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Объект.БизнесПроцесс.Заказ.Партнер, ТекущаяДата()), "ПолноеНаименование,ЮридическийАдрес",,Символы.ПС);
		КонецЕсли;
		ОбластьШапка.Параметры.ПредставлениеКонтрагента = Представление;
		
	КонецЕсли;
		
	ОбластьШапка.Параметры.Номер 			= Объект.БизнесПроцесс.Заказ.Номер;
	ОбластьШапка.Параметры.Дата 			= Объект.БизнесПроцесс.Заказ.Дата;
	ОбластьШапка.Параметры.СинонимДокумента = "Разборочный лист";
	ОбластьШапка.Параметры.Склад = Объект.Склад.Наименование;
	
	// Установим штрих код
	
	мШтрихКоды = ШтрихКоды.ПолучитьШтрихКодыОбъекта(Объект.Заказ); Если мШтрихКоды.Количество() Тогда
		ШтрихКоды.УстановитьШтрихКодВМакете(ОбластьШапка, мШтрихКоды[мШтрихКоды.ВГраница()]);КонецЕсли;
	
	
	ТабДокумент.Вывести(ОбластьШапка);
	
	// Сформируем комментарий
	
	Комменты = БизнесПроцессы.СборкаЗаказа.ПолучитьМассивКомментариев(Объект.БизнесПроцесс.Сборка);
	Для Каждого Коммент Из Комменты Цикл
		ОбластьКомментарий.Параметры.Заполнить(Коммент);
		Если Коммент.Исполнитель.Пустая() Тогда
			ОбластьКомментарий.Параметры.Исполнитель = "Последний комментарий:";
		Иначе
			ОбластьКомментарий.Параметры.Исполнитель = Строка(Коммент.Исполнитель) + " (" + Формат(Коммент.ДатаВыполнения,"ДЛФ=DDT") + "):";
		КонецЕсли;
		ТабДокумент.Вывести(ОбластьКомментарий);
	КонецЦикла;
	
	ТабДокумент.Вывести(ОбластьЗаголовокТаблицы);
	
	
	// Отсортируем чтобы бегали быстрее
	
	ТаблВывода = Товары.Выгрузить();
	
	Если ВыводитьПомеченные Тогда
		СтрокиВывода = ТаблВывода.НайтиСтроки(Новый Структура("Количество", Истина));
	Иначе
		СтрокиВывода = ТаблВывода;
	КонецЕсли;
	// Выводим в таблицу
	
	Ном = 0;
	//ИтогПроход 	= 0;
	//ИтогСекция 	= 0;
	//ИтогЯрус 	= 0;
	//ИтогПоддон 	= 0;
	ПустаяУпаковка = Справочники.УпаковкиНоменклатуры.ПустаяСсылка();
	Для каждого Строка Из СтрокиВывода Цикл Ном = Ном + 1;
	
		ОбластьСтрока.Параметры.Заполнить(Строка);
		ОбластьСтрока.Параметры.Номер 		= Ном;
		ОбластьСтрока.Параметры.Артикул 	= Строка.Номенклатура.Артикул;
		
		Если Строка.Упаковка  = ПустаяУпаковка Тогда
			ЕдиницаИзмерения = Строка.Номенклатура.ЕдиницаИзмерения;
		Иначе
			ЕдиницаИзмерения = Строка.Упаковка;
		КонецЕсли;
		
		ОбластьСтрока.Параметры.Количество 			= Строка.Количество;
		ОбластьСтрока.Параметры.ЕдиницаИзмерения 	= ЕдиницаИзмерения; 
		
		
		ТабДокумент.Вывести(ОбластьСтрока);
		
		// Подсчитаем итоги
		
		//ИтогПроход 	= ИтогПроход + ПодсчитатьИтогЯчейки(ОтрПроход, Строка.Проход);
		//ИтогСекция 	= ИтогСекция + ПодсчитатьИтогЯчейки(ОтрСекция, Строка.Проход + "." + Строка.Секция);
		//ИтогЯрус 	= ИтогЯрус + ПодсчитатьИтогЯчейки(ОтрЯрус, Строка.Проход + "." + Строка.Секция + "." + Строка.Ярус);
		//ИтогПоддон 	= ИтогПоддон + ПодсчитатьИтогЯчейки(ОтрПоддон, Строка.Проход + "." + Строка.Секция + "." + Строка.Ярус + "." + Строка.Поддон);
		
	КонецЦикла; 
	
	ОбластьИтого.Параметры.ДатаФормирования = Формат(ТекущаяДата(),"ДЛФ=DDT");
	//ОбластьИтого.Параметры.КолЯчеек		 	= Строка(ИтогПроход) + "." + Строка(ИтогСекция) + "." + Строка(ИтогЯрус) + "." + Строка(ИтогПоддон);
	//ОбластьИтого.Параметры.КолНоменклатура 	= ВсегоКол;
	ТабДокумент.Вывести(ОбластьИтого);
	
	// Настрим просмотры
	
	ТабДокумент.ТолькоПросмотр 	= Истина;
	ТабДокумент.ОтображатьСетку = Ложь;
	
	Возврат ТабДокумент;
	
КонецФункции

&НаКлиенте
Процедура ПечатьСборочногоЛиста(Команда)
	
	//Если ФункцииФормДокументов.ЗапомнитьЯчейкиВЗадаче(Объект.Ссылка, Товары) Тогда
		ПолучитьТабличныйДокумент().Показать();
	//КонецЕсли;
	
КонецПроцедуры


