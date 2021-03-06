﻿&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;
&НаКлиенте
Перем СортироватьПоУбыванию, ПовторноеПроведение;

//КОМАНДЫ

&НаКлиенте
Процедура ДополнительныеРеквизиты(Команда)
	
	ФункцииФормДокументов.ОткрытьОбщиеРеквизиты(ЭтаФорма);

КонецПроцедуры
&НаСервере
Процедура ПересчитатьСуммыТабличныхЧастей(СтруктураКолонокТовары) Экспорт
	
	ФункцииФормДокументов.ПересчитатьСуммыТабличныхЧастей(Объект.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры

// ОБРАБОТКИ ТАБЛИЧНОЙ ЧАСТИ

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)

	ФункцииФормДокументов.НоменклатураПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары,,,, Истина);
КонецПроцедуры
			
&НаКлиенте
Процедура УпаковкаПриИзменении(Элемент)
	
	ФункцииФормДокументов.УпаковкаПриИзменении(
		Элементы.Товары, 
		СтруктураКолонокТовары);

КонецПроцедуры
	
&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	ФункцииФормДокументов.КоличествоПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура ЦенаПриИзменении(Элемент)
	
	ФункцииФормДокументов.ЦенаПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	
	ФункцииФормДокументов.СуммаПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)
	
	ФункцииФормДокументов.СтавкаНДСПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры
&НаКлиенте
Процедура СуммаНДСПриИзменении(Элемент)
	
	ФункцииФормДокументов.СуммаНДСПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
	
КонецПроцедуры

&НаСервере
Процедура СортироватьПоАртикулуНаСервере(ПоВозрастанию)

	Товары = Объект.Товары.Выгрузить();
	Товары.Колонки.Добавить("Артикул", Новый ОписаниеТипов("Строка"));
	
	КонвертацияТипов.ВыполнитьВыражениеВКаждойСтрокеТаблицы(Товары, "Строка.Артикул = Строка.Номенклатура.Артикул");
	Товары.Сортировать("Артикул" + ?(ПоВозрастанию, "", " убыв"));
	
	Объект.Товары.Загрузить(Товары);
	
КонецПроцедуры
&НаКлиенте
Процедура СортироватьПоАртикулу(Команда)
	
	СортироватьПоУбыванию = НЕ СортироватьПоУбыванию = Истина;
	СортироватьПоАртикулуНаСервере(НЕ СортироватьПоУбыванию);
	
КонецПроцедуры


// ПРОЦЕДУРЫ ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПовторноеПроведение = Ложь;	
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Объект.СуммаВключаетНДС, Объект.ТипЦен,,,Объект.Валюта,Объект.УчитыватьНДС,,,,,,Объект.Контрагент);
	ФункцииФормДокументов.ОбновитьПодвал(Объект, Элементы, Сумма, СтруктураКолонокТовары);
	
	//УсловиеОплаты = Объект.УсловиеПроцПосле;
	Элементы.ГруппаУсловийОплаты.Видимость = Ложь;
	ОбновитьСтрУсловийОплаты();
	
	// Автосохранение
	
	Если Не ТолькоПросмотр Тогда 
		Если АвтосохранениеКлиент.ИницилизироватьСохранение(ЭтаФорма) Тогда
			
			ДанныеДляПодбора = "";
			ЗагрузитьДанныеАвтосохранения(ДанныеДляПодбора); 
			Модифицированность = Истина; 
			
			Если Не ПустаяСтрока(ДанныеДляПодбора) Тогда ПодборВыполнить(,Новый Структура("МассивТоваровСтрокой", ДанныеДляПодбора)) КонецЕсли; КонецЕсли; КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда	
		// Автосохранение
		АвтосохранениеСервер.УдалитьАвтоСохранение(ИмяФормы, Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьРозничныеЦены()
	// если есть хотя бы один товар с пустой ценой, нужно об это предупредить
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ Таб.Номенклатура ПОМЕСТИТЬ Товары ИЗ &Таблица Таб;
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Тов.Номенклатура,
	|	Цен.Цена
	|ИЗ
	|Товары Тов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ЦеныНоменклатуры.СрезПоследних(, ТипЦен = &Розница И Номенклатура В (ВЫБРАТЬ Номенклатура ИЗ Товары)) Цен 
	|ПО Тов.Номенклатура = Цен.Номенклатура
	|ГДЕ Цен.Цена ЕСТЬ NULL");
	Запрос.УстановитьПараметр("Таблица", Объект.Товары.Выгрузить());
	Запрос.УстановитьПараметр("Розница", КэшируемыеФункции.ПолучитьТипЦенРозница());
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Объект.Товары.НайтиСтроки(Новый Структура("БольшеНеПоставляется",Истина)).Количество()>0 Тогда
		ПоказатьПредупреждение(,"В документе присутствуют товары, которые больше не поставляются. Проводить и записывать документ запрещено.");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ПовторноеПроведение И ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение И НЕ ПроверитьРозничныеЦены() Тогда
		 Отказ = Истина; ПовторноеПроведение = Ложь;
		 ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОбУстанановкеРозничныхЦен", ЭтаФорма), "На некоторые товары не установлены Розничные цены. Выполнить установку сейчас?", РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	 
КонецПроцедуры
&НаСервере
Функция ПоместитьВоВременноеХранилищеНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Товары.Выгрузить(), Новый УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ВопросОбУстанановкеРозничныхЦен(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		ПовторноеПроведение = Истина; Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение)); Закрыть();
	ИначеЕсли
		Результат = КодВозвратаДиалога.Отмена Тогда Возврат;
	Иначе 
		ДополнительныеТипыЦен = Новый Массив;
		ДополнительныеТипыЦен.Добавить(КэшируемыеФункции.ПолучитьТипЦенРозница());
		
		ОткрытьФорму("Документ.УстановкаЦенНоменклатуры.ФормаОбъекта", Новый Структура("Основание", Новый Структура("Товары, ТипЦен, ДополнительныеТипыЦен, Валюта", ПоместитьВоВременноеХранилищеНаСервере(), Объект.ТипЦен, ДополнительныеТипыЦен, КэшируемыеФункции.ВалютаУправленческогоУчета())));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере      	
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
		
	// Автосохранение
	Если Не Отказ И Объект.Ссылка.Пустая() Тогда АвтосохранениеСервер.УдалитьАвтоСохранение(ИмяФормы, Объект.Ссылка) КонецЕсли;
	
	РассылкаОбИзмененииДатыПоступления = ТекущийОбъект.Ссылка.ДатаПоступления <> Объект.ДатаПоступления;
	ДатаПоступленияПустая  = ТекущийОбъект.Ссылка.ДатаПоступления = '00010101';
	
	// #БП ->
	СтартБП = Ложь;
	Если ПараметрыЗаписи.Свойство("СтартБП", СтартБП) И СтартБП Тогда
		
		Процесс = Неопределено;
		
		Если Объект.Процесс.Пустая() Тогда
			Процесс = БизнесПроцессы.СогласованиеЗаказаПоставщику.СоздатьБизнесПроцесс();
			Процесс.Дата = ТекущаяДата();
		ИначеЕсли НЕ Объект.Процесс.Стартован Тогда
			Процесс = Объект.Процесс.ПолучитьОбъект();
		КонецЕсли;
			
		Если Процесс <> Неопределено Тогда
			
			Процесс.Заказ = ТекущийОбъект.Ссылка;
			Попытка
				Процесс.Записать();
				Процесс.Старт();
			Исключение
				Сообщить(ОписаниеОшибки());
				Отказ = Истина;
				Возврат;
			КонецПопытки; 
				
			ТекущийОбъект.Процесс = Процесс.Ссылка;
			Задача = ФункцииБизнесПроцессов.ТекущаяЗадача(Процесс.Ссылка);

		КонецЕсли;
	КонецЕсли;
	// <- #БП
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// #БП ->
	// для нового заказа запишем статус, если для заказа нет БП (если БП не пустой - то статус присвоится по ходу БП)

	Если Объект.Ссылка.Пустая() И ТекущийОбъект.Процесс.Пустая() И НЕ Заказы.УстановитьСостояниеЗаказа(ТекущийОбъект.Ссылка, Статус) Тогда Отказ = Истина; Возврат; КонецЕсли;
	// <- #БП
	
	// + neti Леконцев 21.06.2017
	ТаблицаСоответствий = Заказы.ПолучитьТаблицуСоответствий();
		
	Заказы.ДокументВТаблицуСоответствий(ТаблицаСоответствий, ТекущийОбъект.Ссылка, ЭтаФорма.СтатусДокумента);
		
	Заказы.НовыеСтатусыДокументов(ТаблицаСоответствий, ТекущийОбъект.Дата);
	// - neti Леконцев 21.06.2017
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ФункцииФормДокументов.ЗаполнитьЗначенияПоУмолчанию(
					Объект,
					КэшируемыеФункции.ПолучитьРеквизитыДокумента("ЗаказПоставщику")
					);
		// #БП -> 
		Статус = Перечисления.СостоянияЗаказа.Редактируется; // <- #БП
		 
	КонецЕсли;	
	
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	
	ФункцииФормДокументов.РассчитатьДинамическиеКолонки(
					Объект.Товары,
					ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Объект.СуммаВключаетНДС, Объект.ТипЦен));
					
	ЗаполнитьДинамическиеКолонки();

	// #БП ->
	//
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		
		// получаем состояние заказа	
		
		Запрос = Новый Запрос("ВЫБРАТЬ Состояние ИЗ РегистрСведений.СостоянияЗаказовТекущее ГДЕ Заказ = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Статус = Выборка.Состояние; КонецЕсли;
		
	КонецЕсли;
	
	ЗадачаРазрешенаКВыполнению = Объект.Процесс.Пустая();  // если БП нет - то считаем что разрешено редактирование

	Если НЕ Объект.Процесс.Пустая() Тогда
		
		// получаем текущую задачу, если есть
	
		Задача =Параметры.Задача;	
		Если НЕ ЗначениеЗаполнено(Задача) Тогда
			Задача = ФункцииБизнесПроцессов.ТекущаяЗадача(Объект.Процесс); 
		КонецЕсли;
		
	    ЗадачаРазрешенаКВыполнению = ФункцииБизнесПроцессов.РазрешенаЗадачаКВыполнению(Задача);

	КонецЕсли;
	
	// проверяем можно ли редактировать заказ
	
	Согласован = Статус = Перечисления.СостоянияЗаказа.Согласован;
	
	РазрешеноРедактирование = (НЕ Согласован И ЗадачаРазрешенаКВыполнению) ИЛИ КэшируемыеФункции.ЭтоПолныеПрава();
	
	Если НЕ РазрешеноРедактирование И НЕ РольДоступна("ОтменятьДокументыСКонтролем") Тогда
		
		//ТолькоПросмотр = Истина; 
		Для Каждого ЭлементФормы Из Элементы Цикл
			Если Не ТипЗнч(ЭлементФормы)=Тип("ДекорацияФормы") Тогда
				Если НЕ (ЭлементФормы.Имя = "Сроки" ИЛИ  
					ЭлементФормы.Имя = "Группа8" ИЛИ
					ЭлементФормы.Имя = "Группа7" ИЛИ
					ЭлементФормы.Имя = "ФормаЗаписать" ИЛИ
					ЭлементФормы.Имя = "ДатаОплаты" ИЛИ
					ЭлементФормы.Имя = "ДатаПоступления" ИЛИ
					ЭлементФормы.Имя = "ДатаРазмещения" ИЛИ
					ЭлементФормы.Имя = "ДатаОкончанияПроизводства")
					
					Тогда
					ЭлементФормы.Доступность =  Ложь;
				КонецЕсли;
			КонецЕСли;
		КонецЦикла;
		
	КонецЕсли;
	
	// устанавливаем видимость элементов формы в соответствии со статусом и точкой маршрута
	
	ЭтоОформлениеЗаказа			 = ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(Объект.Процесс, БизнесПроцессы.СогласованиеЗаказаПоставщику.ТочкиМаршрута.Оформление);
	ЭтоСогласованиеСПоставщиком  = ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(Объект.Процесс, БизнесПроцессы.СогласованиеЗаказаПоставщику.ТочкиМаршрута.СогласованиеСПоставщиком);
	
	Редактируется = НЕ Согласован И (Объект.Процесс.Пустая() ИЛИ НЕ Объект.Процесс.Стартован ИЛИ ЭтоОформлениеЗаказа);
	
	Элементы.ОтправитьНаСогласованиеИМ.Видимость 		= РазрешеноРедактирование И Редактируется;
	Элементы.Согласовано.Видимость 						= РазрешеноРедактирование И Редактируется;
	Элементы.ВернутьКатегорийномуМенеджеру.Видимость 	= РазрешеноРедактирование И ЭтоСогласованиеСПоставщиком;
	
	Элементы.ТоварыЗаполнитьПоДаннымПоставщика.Видимость = ЭтоОформлениеЗаказа; // менеджер-закупок может принять изменения, внесенные импорт-менеджером
	Элементы.ТоварыЗагрузитьДанныеТабличногоДокумента.Видимость = НЕ ЭтоСогласованиеСПоставщиком; // у импорт-менеджера нет возможности загрузить данные для заказа поставщику
	Элементы.ТоварыЗагрузитьДанныеПоставщика.Видимость = ЭтоСогласованиеСПоставщиком;  // у импорт-менеджера специальная загрузка данных, которые им предоставил поставщик, в специальные колонки
	
	
	// Импорт-менеджер не может менять товар в заказе, его количество и цену, он может только добавлять позиции и/или указывать согласованную цену и согласованное количество 
	Элементы.Количество.РедактированиеТекста = НЕ ЭтоСогласованиеСПоставщиком;
	Элементы.Цена.РедактированиеТекста =  НЕ ЭтоСогласованиеСПоставщиком;
	
	Элементы.ФормаПровестиИЗакрыть.Видимость = НЕ ЭтоСогласованиеСПоставщиком;
	Элементы.ФормаПровести.Видимость = НЕ ЭтоСогласованиеСПоставщиком;

	//
	// <- #БП
	
	// + neti Леконцев 21.06.2017
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекущийСтатус = Заказы.ТекущийСтатусДокумента(Объект.Ссылка);
		Если ТекущийСтатус = Перечисления.СтатусыЗаказаПоставщику.ПустаяСсылка() Тогда
			СтатусДокумента = Перечисления.СтатусыЗаказаПоставщику.Создан;
		Иначе
			СтатусДокумента = ТекущийСтатус;
		КонецЕсли;				
		
	Иначе
			
		СтатусДокумента = Перечисления.СтатусыЗаказаПоставщику.Создан;
		
	КонецЕсли;
	// - neti Леконцев 21.06.2017	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитаВлияющегоНаТабличнуюЧасть(СтруктураКолонокТовары, ОбновитьСтруктуру = Истина)
	
	Если ОбновитьСтруктуру Тогда
		ФункцииФормДокументов.ОбновитьСтруктуруКолонокТовары(
				Объект, 
				СтруктураКолонокТовары, 
				КэшируемыеФункции.ПолучитьРеквизитыДокумента("ЗаказПоставщику"));
	КонецЕсли;
	
	ФункцииФормДокументов.ПересчитатьСуммыТабличныхЧастей(Объект.Товары, СтруктураКолонокТовары, Ложь);
	
	ФункцииФормДокументов.ОбновитьПодвал(Объект, Элементы, Сумма, СтруктураКолонокТовары);

КонецПроцедуры 


&НаСервере
Процедура КонтрагентПриИзмененииНаСервере(СтруктураКолонокТовары)
	
	
	// заполним зависимые реквизиты
	
	Структура = ФункцииФормДокументов.КонтрагентПриИзменении(Объект);
	
	Если Структура <> Неопределено Тогда 
		ФункцииФормДокументов.ОбновитьСтруктуруКолонокТоварыПоСтруктуре(СтруктураКолонокТовары, Структура) КонецЕсли;
			
	Если Структура <> Неопределено Тогда 
        ПриИзмененииРеквизитаВлияющегоНаТабличнуюЧасть(СтруктураКолонокТовары) КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	КонтрагентПриИзмененииНаСервере(СтруктураКолонокТовары);	
КонецПроцедуры



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

// ПОДБОР

&НаСервере
Функция ПоместитьТоварыВХранилище() 
	
	Возврат ПоместитьВоВременноеХранилище(
					Объект.Товары.Выгрузить(), 
					УникальныйИдентификатор);
КонецФункции
&НаКлиенте
Процедура ПодборВыполнить(Кнопка = Неопределено, ДополнительныеПараметрыПодбора = Неопределено)
	
	ИмяТабличнойЧасти = "Товары";
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	ПараметрыПодбора = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	
	ПараметрыПодбора.Вставить("СтруктураКолонокТовары", СтруктураКолонокТовары);
	//ПараметрыПодбора.Вставить("ВидЗапроса", 			"СписокНоменклатуры");
	//ПараметрыПодбора.Вставить("ВидыЗапросов", 			"СписокНоменклатуры");
	ПараметрыПодбора.Вставить("Склад", 					Объект.Склад);
	ПараметрыПодбора.Вставить("ТипЦен", 				Объект.ТипЦен);
	ПараметрыПодбора.Вставить("Валюта", 				Объект.Валюта);
	ПараметрыПодбора.Вставить("ЗаполнитьУпаковкуПоставщика", Истина);
	ПараметрыПодбора.Вставить("Контрагент", Объект.Контрагент);
	
	// Автосохранение
	АвтосохранениеКлиент.ОткрываетсяПодбор(ПараметрыПодбора, Объект.Ссылка, ЭтаФорма, ПолучитьДамп());
	Если ДополнительныеПараметрыПодбора <> Неопределено Тогда
		КонвертацияТипов.ДобавитьВСтруктуруСтруктуру(ПараметрыПодбора, ДополнительныеПараметрыПодбора) КонецЕсли;
	
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
		
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда

			ПолучитьТоварыИзХранилища(ВыбранноеЗначение.Товары);		// получаем
			УдалитьИзВременногоХранилища(ВыбранноеЗначение.Товары); 	// заметаем следы
		Иначе
			ПолучитьТоварыИзХранилища(ВыбранноеЗначение);		// получаем
			УдалитьИзВременногоХранилища(ВыбранноеЗначение); 	// заметаем следы
		КонецЕсли;

		ОбновитьСтрУсловийОплаты();
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПотребностиНаСервере(ПараметрыЗаполнения, СтруктураКолонокТовары)
	
	Запрос = Новый Запрос(" ВЫБРАТЬ Разрешенные
	| 	Номенклатура,
	|	Упаковка,
	|	КоличествоОстаток 	Количество
	|ПОМЕСТИТЬ ПотребностьВся
	|ИЗ
	|
	|РегистрНакопления.РазмещениеЗаказов.Остатки(, 
	|" + ?(ПараметрыЗаполнения.ПроизводительНеЗаполнен, "Номенклатура.Производитель = &ПустойПроизводитель И", "") +  " 
	|" + ?(ЗначениеЗаполнено(ПараметрыЗаполнения.КатегорияТовара), "Номенклатура.КатегорияТовара = &КатегорияТовара И", "") +  " 
	|" + ?(ПараметрыЗаполнения.ТолькоПодтверженные, " Заказ.ЗакупитьНедостающее = ИСТИНА И ", "") + "
	|	ВЫБОР КОГДА Заказ ССЫЛКА Документ.ВнутреннийЗаказ ТОГДА Заказ.Заказчик В (&Склады) ИНАЧЕ Заказ.Склад В (&Склады) КОНЕЦ
	|" + ?(ПараметрыЗаполнения.Производитель.Количество(), " И Номенклатура.Производитель В (&Производитель)", "") + ")
 	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	| 	Номенклатура,
	|	Упаковка,
	|	КоличествоОстаток 	Количество
	|ИЗ
	|
	|РегистрНакопления.РазмещениеЗаказовВПути.Остатки(, 
	|" + ?(ПараметрыЗаполнения.ПроизводительНеЗаполнен, "Номенклатура.Производитель = &ПустойПроизводитель И", "") +  " 
	|" + ?(ЗначениеЗаполнено(ПараметрыЗаполнения.КатегорияТовара), "Номенклатура.КатегорияТовара = &КатегорияТовара И", "") +  " 
	| 	ВЫБОР КОГДА Размещение ССЫЛКА Документ.ВнутреннийЗаказ ТОГДА Размещение.Заказчик В (&Склады) ИНАЧЕ Размещение.Склад В (&Склады) КОНЕЦ
	|" + ?(ПараметрыЗаполнения.Производитель.Количество(), " И Номенклатура.Производитель В (&Производитель)", "") + ")
	|;
	|ВЫБРАТЬ Номенклатура, Упаковка, СУММА(Количество) Количество ПОМЕСТИТЬ Потребность  ИЗ ПотребностьВся СГРУППИРОВАТЬ ПО Номенклатура, Упаковка
	|;
	|ВЫБРАТЬ Разрешенные
	|	Потр.Номенклатура,
	|	Потр.Упаковка,
	|	НомПост.АртикулПоставщика АртикулПоставщика,
	|	Потр.Количество - ЕСТЬNULL(Зак.КоличествоОстаток, 0) - ЕСТЬNULL(Инв.КоличествоОстаток, 0) Количество
	|ИЗ
	| Потребность Потр
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ЗаказыПоставщикам.Остатки(, ЗаказПоставщику.Склад В (&Склады) 
	|" 		+ ?(ПараметрыЗаполнения.Производитель.Количество(), " И Номенклатура.Производитель В (&Производитель)", "") + "
	|" 		+ ?(ПараметрыЗаполнения.ПроизводительНеЗаполнен, " И Номенклатура.Производитель = &ПустойПроизводитель", "") +  " 
	|		) Зак
	|		ПО	Потр.Номенклатура = Зак.Номенклатура И Потр.Упаковка = Зак.Упаковка 
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ТоварыПоставщиковВПути.Остатки(, ЗаказПоставщику.Склад В (&Склады) 
	|" 		+ ?(ПараметрыЗаполнения.Производитель.Количество(), " И Номенклатура.Производитель В (&Производитель)", "") + "
	|" 		+ ?(ПараметрыЗаполнения.ПроизводительНеЗаполнен, " И Номенклатура.Производитель = &ПустойПроизводитель", "") +  " 
	|		) Инв
	|		ПО	Потр.Номенклатура = Инв.Номенклатура И Потр.Упаковка = Инв.Упаковка 
	|
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|  		 (	ВЫБРАТЬ Номенклатура, АртикулПоставщика ИЗ РегистрСведений.НоменклатураПартнеров ГДЕ Контрагент = &Контрагент) НомПост
	|			ПО Потр.Номенклатура = НомПост.Номенклатура
	|
	|ГДЕ Потр.Количество - ЕСТЬNULL(Зак.КоличествоОстаток, 0)- ЕСТЬNULL(Инв.КоличествоОстаток, 0) > 0
	|" + ?(ЗначениеЗаполнено(ПараметрыЗаполнения.Поставщик), " И НЕ НомПост.Номенклатура ЕСТЬ NULL", "") + "
	|");
	
	Запрос.УстановитьПараметр("Склады", ПараметрыЗаполнения.Склады);
	Запрос.УстановитьПараметр("Контрагент", ПараметрыЗаполнения.Поставщик);
	Запрос.УстановитьПараметр("Производитель", ПараметрыЗаполнения.Производитель);
	Запрос.УстановитьПараметр("ПустойПроизводитель", Справочники.Производители.ПустаяСсылка());  
	Запрос.УстановитьПараметр("КатегорияТовара", ПараметрыЗаполнения.КатегорияТовара);
	
	Объект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());
				
	ФункцииФормДокументов.ЗаполнитьСтавкуНДС(Объект.Товары, СтруктураКолонокТовары);
	ПересчитатьСуммыТабличныхЧастей(СтруктураКолонокТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПотребности(Команда)
	
	ОткрытьФорму("Документ.ЗаказПоставщику.Форма.ФормаВыбораСкладов2", Новый Структура("Поставщик", Объект.Контрагент),ЭтаФорма,,,, Новый ОписаниеОповещения("ОкончаниеВыбораСкладов", ЭтаФорма));


КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьПоРекомендуемымОстаткам(Команда)
	Если Объект.Товары.Количество() Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоРекомендуемымОстаткам_ПослеЗакрытияВопроса", ЭтаФорма, Параметры);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Табличная часть будет очищена. Продолжить?';"), Режим, 0);
	Иначе
		ПодборСОтбором()
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьПоРекомендуемымОстаткам_ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
    Если Не Результат = КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
	ПодборСОтбором()	
КонецПроцедуры // ()

&НаКлиенте
Процедура ПодборСОтбором()
	Период = ?(ЗначениеЗаполнено(Объект.Ссылка), Объект.Дата, ТекущаяДата());
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УникальныйИдентификатор",  УникальныйИдентификатор);
	ПараметрыФормы.Вставить("Поставщик", 			    Объект.Контрагент);
	ПараметрыФормы.Вставить("Период", 				    Период);
	ПараметрыФормы.Вставить("Склад",					Объект.Склад);
	ОповещениеЗакрытия = Новый ОписаниеОповещения("ПодборСОтборомЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.ЗаказПоставщику.Форма.ФормаПодбора", ПараметрыФормы, ЭтотОбъект,,,,ОповещениеЗакрытия);
КонецПроцедуры	

&НаКлиенте
Процедура ПодборСОтборомЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт 

	Если ЭтоАдресВременногоХранилища(РезультатЗакрытия) Тогда
	
		ЗаполнитьТоварыИзХранилищаНаСервере(РезультатЗакрытия);
	
	КонецЕсли;
	//заполняем цену и тд
	Для каждого Эл Из Объект.Товары Цикл
		ФункцииФормДокументов.НоменклатураПриИзменении(
		Элементы.Товары, 
		СтруктураКолонокТовары,Эл,,, Истина);
	КонецЦикла;
КонецПроцедуры // ПодборСОтборомЗавершение()

&НаСервере
Процедура ЗаполнитьТоварыИзХранилищаНаСервере(АдресХранилища)
    Объект.Товары.Загрузить(ПолучитьИзВременногоХранилища(АдресХранилища));
	Модифицированность = Истина;
	
КонецПроцедуры // ЗаполнитьСтавкиИзХранилищаНаСервере()
 



&НаКлиенте
Процедура ОкончаниеВыбораСкладов(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		// ТоварыОбработкаВыбора(Элементы.Товары, Результат, Ложь);
		ЗаполнитьПоПотребностиНаСервере(Результат, СтруктураКолонокТовары);  
	КонецЕсли;
	
КонецПроцедуры


// ИНФОРМАЦИЯ О ТОВАРЕ

&НаКлиенте
Процедура ОбработатьОтображениеИнформацииОТоваре() Экспорт 
	РаботаСНоменклатуройКлиент.ОбработатьОтображениеИнформацииОТоваре(ЭтаФорма, "Товары", "Объект.Товары",,,"Объект.Валюта");
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

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре();

КонецПроцедуры


// РЕЗЕРВ

&НаКлиенте
Процедура НазначитьРезерв(Команда)
	СтруктураКолонокРезервов = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Резервы, Объект.СуммаВключаетНДС, Объект.ТипЦен, "Резервы",, Объект.Валюта, Объект.УчитыватьНДС);
	СтруктураКолонокРезервов.Вставить("ЕстьЗаказчик", Ложь);
	НазначитьРезервНаСервере(СтруктураКолонокРезервов);
КонецПроцедуры

&НаСервере
Процедура НазначитьРезервНаСервере(СтруктураКолонокТовары)
	
	Объект.Резервы.Очистить();
	
	ТЗТоваров = Объект.Товары.Выгрузить();
	
	Заказы.ПроставитьЗаказыВПорядкеОчереди(ТЗТоваров, Объект.Резервы, Объект.Склад, СтруктураКолонокТовары, ?(Объект.Ссылка.Проведен, Объект.Дата, Неопределено));
	//пока вот так тупо
	ЗаполнитьДинамическиеКолонки();

	
	//Объект.Резервы.Загрузить(ТЗТоваров);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДинамическиеКолонки()
	//пока вот так тупо
	Для Каждого Строка Из Объект.Резервы ЦИкл
		Если ТипЗнч(Строка.Размещение) <> Тип("ДокументСсылка.ВнутреннийЗаказ") Тогда
			Если Строка.Размещение <> Неопределено Тогда Строка.Контрагент = Строка.Размещение.Контрагент; КонецЕсли;
		Строка.Менеджер = Строка.Контрагент.ОсновнойМенеджер; КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// ПИСЬМО

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	// Если поменяли дату, шлем письмо
	Если РассылкаОбИзмененииДатыПоступления И Объект.Резервы.Количество() Тогда
		Сообщение = ОтправитьПисьмоПредупреждение();
		Если Не ПустаяСтрока(Сообщение) Тогда
			
			ПоказатьОповещениеПользователя("Автоматическая рассылка",,Сообщение, БиблиотекаКартинок.Почта);
			
	КонецЕсли; КонецЕсли;
	
КонецПроцедуры
&НаСервере
Функция ОтправитьПисьмоПредупреждение()
	
	Запрос = Новый Запрос("ВЫБРАТЬ Таб.Размещение, Таб.Количество, Таб.Номенклатура ПОМЕСТИТЬ Резервы ИЗ &Товары Таб;
	|ВЫБРАТЬ Размещение, Размещение.Контрагент Контрагент, Количество, Номенклатура, Номенклатура.Артикул Артикул, Размещение.Контрагент.ОсновнойМенеджер.Почта Почта ИЗ Резервы ГДЕ Размещение <> Неопределено И НЕ Размещение ССЫЛКА Документ.ВнутреннийЗаказ ИТОГИ ПО Почта, Размещение");	
	Запрос.УстановитьПараметр("Товары", Объект.Резервы.Выгрузить());
	ВыборкаПочты = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	КолПисем = 0; Отказ = Ложь;
	Пока ВыборкаПочты.Следующий() Цикл
	
		Если ПустаяСтрока(ВыборкаПочты.Почта) Тогда Продолжить; КонецЕсли;
			
		ТемаПисьма 	= ?(ДатаПоступленияПустая, "Установлены сроки поставки товара, зарезервированного по вашему заказу", "Перенесены сроки поставки товара, зарезервированного по вашему заказу");
		ТипТекста 	= Перечисления.ТипыТекстовЭлектронныхПисем.HTML;
		
		ТекстПисьма = ?(ДатаПоступленияПустая, 
					"<P>Здравствуйте, уважаемый(ая) сотрудник ""Гаража""!<BR><BR></p>
					|<p>В Заказе поставщику № " + СокрЛП(Объект.Номер) + " от " + Формат(Объект.Дата, "ДЛФ=D") + " установлена ориентировочная дата поступления на " + Формат(Объект.ДатаПоступления, "ДЛФ=D") + " <br>Указанный заказ поставщику был офомлен на следующие товары по вашим заказам: </p>"
					,
					"<P>Здравствуйте, уважаемый(ая) сотрудник ""Гаража""!<BR><BR></p>
					|<p>В Заказе поставщику № " + СокрЛП(Объект.Номер) + " от " + Формат(Объект.Дата, "ДЛФ=D") + " перенесена ориентировочная дата поступления на " + ?(Объект.ДатаПоступления = '00010101', "неопределенную дату", Формат(Объект.ДатаПоступления, "ДЛФ=D")) + " <br>Указанный заказ поставщику был офомлен на следующие товары по вашим заказам: </p>");
						
			
		// Начнем выбор заказов
			
		ВыборкаЗаказов = ВыборкаПочты.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		Пока ВыборкаЗаказов.Следующий() Цикл
				
				ТекстПисьма = ТекстПисьма + "<p>
								|" + ВыборкаЗаказов.Размещение + " (" + ВыборкаЗаказов.Контрагент + ")<UL>";
								
				// Переберем товары
								
				ВыборкаТоваров = ВыборкаЗаказов.Выбрать();
				Пока ВыборкаТоваров.Следующий() Цикл
					
					ТекстПисьма = ТекстПисьма + "<LI>" + ВыборкаТоваров.Артикул + " " + ВыборкаТоваров.Номенклатура + "  " + ВыборкаТоваров.Количество + "ед. <br>";
										
				КонецЦикла;
				
				ТекстПисьма = ТекстПисьма + "</LI></UL></p>";
				
			КонецЦикла;
			
			ТекстПисьма = ТекстПисьма + "</p>";
			
			// Отправим письмо
			
			Письмо = ОбщиеФункции.ОповеститьПоПочте(ВыборкаПочты.Почта, ТемаПисьма, ТекстПисьма, Отказ, ТипТекста);
			КолПисем =КолПисем +1;			
		КонецЦикла;
	
	Возврат ?(Не КолПисем, "", ?(КолПисем = 1, "Было отправлено письмо менеджеру об изменении даты поступления товара", "Были отправлены письма менеджерам об изменении даты поступления товара"));
	
КонецФункции

// МЕНЮ - "ЗАГРУЗИТЬ"
&НаКлиенте
Процедура ЗагрузитьДанныеТабличногоДокумента(Команда)
	  ЗагрузитьВнешниеДанные(Команда.Имя);
КонецПроцедуры
&НаКлиенте
Процедура ЗагрузитьВнешниеДанные(ИмяКоманды)
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	
	ОткрытьФорму("Документ.ЗаказПокупателя.Форма.ЗагрузкаДанных", Новый Структура("Страница, СтруктураКолонокТовары, ИмяТаблицы, АдресТоваровВХранилище, ИскатьНоменклатуру", ИмяКоманды, СтруктураКолонокТовары, "Объект.Товары", АдресТоваровВХранилище, Истина), Элементы.Товары);
	
КонецПроцедуры


#Область БизнесПроцесс

// #БП

// записывает изменения заказа и выполняет текущую задачу бизнес-процесса
Функция ЗаписатьЗаказИВыполнитьЗадачу(ПараметрыЗаписи, ВыполнитьЗадачу = Истина, ЕстьТранзакция = Ложь)

	Если НЕ ЕстьТранзакция Тогда НачатьТранзакцию(); КонецЕсли;
	
	Попытка
		Записать(ПараметрыЗаписи);
	Исключение
		ОтменитьТранзакцию();
		Возврат Ложь;
	КонецПопытки;

	Если ВыполнитьЗадачу Тогда 
	
		ЗадачаОбъект = Задача.ПолучитьОбъект();
		Если ЗадачаОбъект <> Неопределено Тогда
			Попытка
				ЗадачаОбъект.ВыполнитьЗадачу();
			Исключение
				ОтменитьТранзакцию();
				Возврат Ложь;
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;

	Если НЕ ЕстьТранзакция Тогда ЗафиксироватьТранзакцию(); КонецЕсли;
	Возврат Истина;
	
КонецФункции

// Команда ОТПРАВИТЬ НА СОГЛАСОВАНИЕ ИМПОРТ-МЕНЕДЖЕРУ

&НаСервере
Функция ОтправитьНаСогласованиеИМНаСервере()
	
	// проставим тоже самое количество согласованное и цену согласованную, для того что бы в дальнейшем импорт-менеджер мог нужное откорректировать (то есть по умолчанию цена и количество согласованы)
	Для Каждого Строка Из Объект.Товары Цикл
		Строка.КоличествоПодтвержденное = Строка.Количество;
		Строка.ЦенаПодтвержденная = Строка.Цена;
	КонецЦикла;
	
	Возврат ЗаписатьЗаказИВыполнитьЗадачу(Новый Структура("СтартБП", Истина));
	
КонецФункции
&НаКлиенте
Процедура ОтправитьНаСогласованиеИМ(Команда)

	Если ОтправитьНаСогласованиеИМНаСервере() Тогда
		Закрыть(); КонецЕсли;
КонецПроцедуры

// Команда ПЕРЕДАТЬ МЕНЕДЖЕРУ ЗАКУПОК
&НаСервере
Функция ВернутьКатегорийномуМенеджеруНаСервере()
	Возврат ЗаписатьЗаказИВыполнитьЗадачу(Новый Структура);
КонецФункции
&НаКлиенте
Процедура ВернутьКатегорийномуМенеджеру(Команда)
	
	Если ВернутьКатегорийномуМенеджеруНаСервере() Тогда
		Закрыть();  КонецЕсли;
КонецПроцедуры


// Команда СОГЛАСОВАНО
&НаСервере
Функция СогласованоНаСервере()
	
	Объект.Согласован  = Истина;   // запоминаем флаг
	
	НачатьТранзакцию();
	
	Если НЕ ЗаписатьЗаказИВыполнитьЗадачу(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение), НЕ Объект.Процесс.Пустая(), Истина) Тогда Возврат Ложь; КонецЕсли;

	Если Объект.Процесс.Пустая() Тогда 
		Если НЕ	Заказы.УстановитьСостояниеЗаказа(Объект.Ссылка, Перечисления.СостоянияЗаказа.Согласован) Тогда ОтменитьТранзакцию(); Возврат Ложь; КонецЕсли;
	КонецЕсли; 	
	
	ЗафиксироватьТранзакцию();
	Возврат Истина;
	
КонецФункции
&НаКлиенте
Процедура Согласовано(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаРазмещения) Тогда

		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОЗаполненииДат", ЭтаФорма, "ДатаРазмещения"), "Не заполнено поле ""Дата размещения"". Вернуться к редактированию?", РежимДиалогаВопрос.ДаНетОтмена);
		
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.ДатаОкончанияПроизводства) Тогда
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОЗаполненииДат", ЭтаФорма, "ДатаОкончанияПроизводства"), "Не заполнено поле ""Дата окончания производства"". Вернуться к редактированию?", РежимДиалогаВопрос.ДаНетОтмена);

	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.ДатаОплаты) Тогда
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОЗаполненииДат", ЭтаФорма, "ДатаОплаты"), "Не заполнено поле ""Дата оплаты"". Вернуться к редактированию?", РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		
		Если СогласованоНаСервере() Тогда Закрыть(); КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОЗаполненииДат(Результат, ИмяЭлемента) Экспорт
	
	Если Результат = Неопределено Тогда Возврат; КонецЕсли;
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Если СогласованоНаСервере() Тогда
		Закрыть(); КонецЕсли;
	Иначе
	    ЭтаФорма.ТекущийЭлемент = Элементы[ИмяЭлемента];
	КонецЕсли;
	
КонецПроцедуры

// функция для Менеджера закупок, позволяет принять изменения, внесенные импорт-менеджером
// заполняет колокни Количество и Цену из колонок КоличествоПодтвержденное и ЦенаПодтвержденная
// если КоличествоПодтвержденное = 0 (товар не подтвержден), то такой товар удаляется из таблицы
&НаСервере
Процедура ЗаполнитьПоДаннымПоставщикаНаСервере()
	
	СтрокиУдалить = Объект.Товары.НайтиСтроки(Новый Структура("КоличествоПодтвержденное",0));
	
	Для Каждого Строка ИЗ СтрокиУдалить Цикл
		Если Строка.Отметка Тогда
			Объект.Товары.Удалить(Строка);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Строка ИЗ Объект.Товары Цикл
		Если Строка.Отметка Тогда
			Строка.Количество = Строка.КоличествоПодтвержденное;
			Строка.Цена = Строка.ЦенаПодтвержденная;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Процедура ЗаполнитьПоДаннымПоставщика(Команда)
	ЗаполнитьПоДаннымПоставщикаНаСервере();
КонецПроцедуры

// функция для Импорт-менеджера, для загрузки данных, которые предоставил поставщик
// грузит в специальные колокни КоличествоПодтвержденное и ЦенаПодтвержденная
&НаКлиенте
Процедура ЗагрузитьДанныеПоставщика(Команда)
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	ОткрытьФорму("Документ.ЗаказПокупателя.Форма.ЗагрузкаДанных", Новый Структура("Страница, СтруктураКолонокТовары, ИмяТаблицы, АдресТоваровВХранилище, ИмяКолонкиКоличество, ИмяКолонкиЦена, ИскатьНоменклатуру, ЗамещатьКоличество", "ЗагрузитьДанныеТабличногоДокумента", СтруктураКолонокТовары, "Объект.Товары", АдресТоваровВХранилище, "КоличествоПодтвержденное", "ЦенаПодтвержденная", Истина, Истина), Элементы.Товары);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломИзменения(Элемент, Отказ)
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекДанные <> Неопределено И Элементы.Товары.ТекущийЭлемент.Имя <> "КоличествоПодтвержденное"  И Элементы.Товары.ТекущийЭлемент.Имя <> "ЦенаПодтвержденная" Тогда
		Если ЭтоСогласованиеСПоставщиком И ТекДанные.Количество > 0 Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	Для Каждого Строка ИЗ Объект.Товары Цикл
		Строка.Отметка = Истина;
	КонецЦикла
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Для Каждого Строка ИЗ Объект.Товары Цикл
		Строка.Отметка = Ложь;
	КонецЦикла

КонецПроцедуры
	
#КонецОбласти

&НаКлиенте
Процедура ОбновитьСтрУсловийОплаты()
	
	ЦветЗеленный 	= Новый Цвет(51, 153, 102);
	ЦветСиний 		= Новый Цвет(0, 0, 255);
	ЦветКрасный 	= Новый Цвет(255, 0, 0);
	
	текСумма 	= Объект.Товары.Итог("Сумма");
	СуммаДо 	= Окр(текСумма / 100 * Объект.УсловиеПроцДо, 2);
	СуммаПосле 	= текСумма - СуммаДо;
	
	формТекст = Новый Массив;
	
	Если Объект.УсловиеПроцПосле = 0 Тогда
		формТекст.Добавить(Новый ФорматированнаяСтрока("предоплата ",,ЦветЗеленный));
		формТекст.Добавить(Новый ФорматированнаяСтрока("100% ",,ЦветКрасный));
	ИначеЕсли Объект.УсловиеПроцПосле = 100 Тогда
		формТекст.Добавить(Новый ФорматированнаяСтрока("постоплата ",,ЦветЗеленный));
		формТекст.Добавить(Новый ФорматированнаяСтрока("100% ",,ЦветКрасный));
	Иначе	
		формТекст.Добавить(Новый ФорматированнаяСтрока("оплата до ",,ЦветЗеленный));
		формТекст.Добавить(Новый ФорматированнаяСтрока(Строка(Объект.УсловиеПроцДо) + "% ",,ЦветКрасный));
		формТекст.Добавить(Новый ФорматированнаяСтрока(Строка(СуммаДо) + " ",,ЦветСиний));
		формТекст.Добавить(Новый ФорматированнаяСтрока("после ",,ЦветЗеленный));
		формТекст.Добавить(Новый ФорматированнаяСтрока(Строка(Объект.УсловиеПроцПосле) + "% ",,ЦветКрасный));
		формТекст.Добавить(Новый ФорматированнаяСтрока(Строка(СуммаПосле) + " ",,ЦветСиний)); КонецЕсли;
	
	Элементы.ФормСтрУсловиеОплаты.Заголовок = Новый ФорматированнаяСтрока(формТекст);
	
КонецПроцедуры

//&НаКлиенте
//Процедура УсловиеОплатыПриИзменении(Элемент)
//	
//	Объект.УсловиеПроцДо 	= 100 - УсловиеОплаты;
//	Объект.УсловиеПроцПосле = УсловиеОплаты;
//	
//	ОбновитьСтрУсловийОплаты();
//	
//КонецПроцедуры

&НаКлиенте
Процедура ФормСтрУсловиеОплатыНажатие(Элемент)
	
	Элементы.ГруппаУсловийОплаты.Видимость = Не Элементы.ГруппаУсловийОплаты.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	ОбновитьСтрУсловийОплаты();
	
КонецПроцедуры


&НаКлиенте
Процедура УсловиеПроцДоПриИзменении(Элемент)
	
	Объект.УсловиеПроцПосле = 100 - Объект.УсловиеПроцДо;
	ОбновитьСтрУсловийОплаты();
	
КонецПроцедуры


&НаКлиенте
Процедура УсловиеПроцПослеПриИзменении(Элемент)
	Объект.УсловиеПроцДо 	= 100 - Объект.УсловиеПроцПосле;
	ОбновитьСтрУсловийОплаты();
КонецПроцедуры



