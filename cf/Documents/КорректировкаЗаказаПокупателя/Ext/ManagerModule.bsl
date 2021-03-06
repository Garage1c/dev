﻿
Процедура ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства) Экспорт
	
	ИменаРегистров = Новый Массив;
	ПоВсем=Ложь;
	Если Не ДополнительныеСвойства.Свойство("ИменаРегистров",ИменаРегистров) Тогда
		ПоВсем=Истина;
		ИменаРегистров = Новый Массив;
	КонецЕсли;	
	
	ТекстЗапроса=КэшируемыеФункции.ТектЗапросаПолученияПараметровСистемы() +Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+

		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаказПокупателя.Заказ
		|ИЗ
		|	Документ.КорректировкаЗаказаПокупателя КАК ЗаказПокупателя
		|ГДЕ
		|	ЗаказПокупателя.Ссылка = &Ссылка"
		;
		
	Нтаб=Новый Структура;
	ТекНомер=1;	
	
	Если ИменаРегистров.Найти("ЗаказыПокупателей")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("ЗаказыПокупателей",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+

	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&Период				КАК Период,
	|	ВЫБОР КОГДА Ссылка.ВидДвиженияРасход = ИСТИНА ТОГДА &ВидДвиженияРасход ИНАЧЕ &ВидДвиженияПриход КОНЕЦ ВидДвижения,
	|	Ссылка.Заказ		КАК ЗаказПокупателя,
	|	Номенклатура,
	|	Упаковка,
	|	Цена,
	|	Акция,
	|	Размещение,
	|	ПроцентРучнойСкидки,
	|	ПроцентАвтоматическойСкидки,
	|	СтавкаНДС,
	|	СУММА(Количество)	КАК Количество,
    |	СУММА(Сумма)		КАК Сумма
	|ИЗ
	|	Документ.КорректировкаЗаказаПокупателя.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Ссылка,
	|	Номенклатура,
	|	Упаковка,
	|	Цена,
	|	Акция,
	|	Размещение,
	|	ПроцентРучнойСкидки,
	|	ПроцентАвтоматическойСкидки,
	|	СтавкаНДС"
	КонецЕсли;	
	
	
	Если ИменаРегистров.Найти("ТоварыВРезерве")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("ТоварыВРезерве",ТекНомер);
		
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&Период				КАК Период,
	|	ВЫБОР КОГДА Ссылка.ВидДвиженияРасход = ИСТИНА ТОГДА &ВидДвиженияРасход ИНАЧЕ &ВидДвиженияПриход КОНЕЦ ВидДвижения,
	|	Размещение,
	|	Ссылка.Заказ		КАК ДокументРезерва,
	|	Номенклатура,
	|	ВЫБОР 	КОГДА Упаковка = &ПустаяУпаковка 
	|			ТОГДА СУММА(Количество)	
    |			ИНАЧЕ СУММА(Количество)*Упаковка.Коэффициент  КОНЕЦ КАК Количество
	|ИЗ
	|	Документ.КорректировкаЗаказаПокупателя.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка И НЕ Ссылка.БезДвиженийПоРезерву И
	|	Размещение ССЫЛКА Справочник.Склады  И
	|	ЕСТЬNULL(Размещение, &ПустойСклад) <> &ПустойСклад
	|
	|СГРУППИРОВАТЬ ПО
	|	Ссылка,
	|	Размещение,
	|	Номенклатура,
	|	Упаковка
	|ИМЕЮЩИЕ СУММА(Количество) <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период				КАК Период,
	|	ВЫБОР КОГДА Ссылка.ВидДвиженияРасход = ИСТИНА ТОГДА &ВидДвиженияРасход ИНАЧЕ &ВидДвиженияПриход КОНЕЦ ВидДвижения,
	|	Размещение,
	|	Ссылка.Заказ		КАК ДокументРезерва,
	|	Номенклатура,
	|	СУММА(Количество)	КАК Количество
	|ИЗ
	|	Документ.КорректировкаЗаказаПокупателя.РазмещениеТоваров	
	|ГДЕ
	|	Ссылка = &Ссылка И НЕ Ссылка.БезДвиженийПоРезерву И
	|	Размещение ССЫЛКА Справочник.Склады  И
	|	ЕСТЬNULL(Размещение, &ПустойСклад) <> &ПустойСклад
	|
	|СГРУППИРОВАТЬ ПО
	|	Ссылка, Размещение, Номенклатура"
	КонецЕсли;	
	
	
	Если ИменаРегистров.Найти("РазмещениеЗаказов")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("РазмещениеЗаказов",ТекНомер);
		
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&Период				КАК Период,
	|	ВЫБОР КОГДА Ссылка.ВидДвиженияРасход = ИСТИНА ТОГДА &ВидДвиженияРасход ИНАЧЕ &ВидДвиженияПриход КОНЕЦ ВидДвижения,
	|	Размещение 			КАК Очередь,
	|	Ссылка.Заказ		КАК Заказ,
	|	Номенклатура,
	|	Упаковка,
	|	СУММА(Количество)	КАК Количество
	|ИЗ
	|	Документ.КорректировкаЗаказаПокупателя.Товары
	|
	|ГДЕ
	|	Ссылка = &Ссылка И
	|	Ссылка = &Ссылка И ТИПЗНАЧЕНИЯ(Размещение) = ТИП(ЧИСЛО)
	//|	НЕ Размещение ССЫЛКА Справочник.Склады И Размещение <> Неопределено И ЕСТЬNULL(Размещение, 0) <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР КОГДА Ссылка.ВидДвиженияРасход = ИСТИНА ТОГДА &ВидДвиженияРасход ИНАЧЕ &ВидДвиженияПриход КОНЕЦ,
	|	Размещение,
	|	Ссылка.Заказ,
	|	Номенклатура,
	|	Упаковка
	|ИМЕЮЩИЕ СУММА(Количество) <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период				КАК Период,
	|	ВЫБОР КОГДА Ссылка.ВидДвиженияРасход = ИСТИНА ТОГДА &ВидДвиженияРасход ИНАЧЕ &ВидДвиженияПриход КОНЕЦ ВидДвижения,
	|	Размещение 			Очередь,
	|	Ссылка.Заказ		КАК Заказ,
	|	Номенклатура,
	|	&ПустаяУпаковка,
	|	СУММА(Количество) Количество
    |ИЗ
	|	Документ.КорректировкаЗаказаПокупателя.РазмещениеТоваров
	|
	|ГДЕ
	|	Ссылка = &Ссылка И
	|	ТИПЗНАЧЕНИЯ(Размещение) = ТИП(ЧИСЛО) И
	|	Размещение <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	Ссылка, Размещение, Номенклатура"
	КонецЕсли;	
	
	
	Если ИменаРегистров.Найти("ДолгиПоЗаказам")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("ДолгиПоЗаказам",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
	"ВЫБРАТЬ
	|	&Период				Период,
	|	&ВидДвиженияПриход	ВидДвижения,
	|	Заказ.Организация	Организация,
	|	Заказ.Контрагент	Контрагент,
	|	Заказ				Заказ,
	|	&СуммаДокумента		Сумма
	|ИЗ
	|	Документ.КорректировкаЗаказаПокупателя
	|ГДЕ
	|	Ссылка = &Ссылка и &СуммаДокумента<>0 и (Заказ.Склад.ПередачаТовараМВЗ=Ложь И Заказ.МВЗ=Значение(Справочник.МВЗ.ПустаяСсылка) И Заказ.ПередачаТовара=Ложь)"
	КонецЕсли;	
	
	
	Если ИменаРегистров.Найти("ДолгиПоОтгрузкам")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("ДолгиПоОтгрузкам",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
		"ВЫБРАТЬ
		|	""стиратель движений"""
	КонецЕсли;	
	
	
	Если ИменаРегистров.Найти("ОтгруженныеЗаказы")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("ОтгруженныеЗаказы",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&Период	Период,
	|	Ссылка.Заказ Заказ,
	|	СУММА(Номенклатура.Вес * ВЫБОР КОГДА Упаковка = &ПустаяУпаковка ТОГДА Количество ИНАЧЕ Количество * Упаковка.Коэффициент КОНЕЦ) 	ВесЗаказа,
	|	СУММА(Номенклатура.Объем * ВЫБОР КОГДА Упаковка = &ПустаяУпаковка ТОГДА Количество ИНАЧЕ Количество * Упаковка.Коэффициент КОНЕЦ) 	ОбъемЗаказа
	|ИЗ
	|	Документ.КорректировкаЗаказаПокупателя.Товары
	|ГДЕ
	|	Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Ссылка"
	КонецЕсли;	
	
	Если ИменаРегистров.Найти("Лимиты")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+1;
		Нтаб.Вставить("Лимиты",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
	"ВЫБРАТЬ
	|   &Период,
	|	&ВидДвиженияРасход		ВидДвижения,
	|	Ссылка.Заказ.ОтветственноеЛицо	Инициатор,
	|	СУММА(Сумма) 			Сумма
	|ИЗ
	|	Документ.КорректировкаЗаказаПокупателя.Товары
	|ГДЕ
	|   Ссылка = &Ссылка И Ссылка.Заказ.ОтветственноеЛицо <> &ПустойИнициатор
	|СГРУППИРОВАТЬ ПО Ссылка
	|ИМЕЮЩИЕ СУММА(Сумма) <> 0"
	КонецЕсли;	
	
	Если ИменаРегистров.Найти("РазмещениеЗаказовВПути")<>Неопределено ИЛИ ПоВсем Тогда
		ТекНомер=ТекНомер+3;
		Нтаб.Вставить("РазмещениеЗаказовВПути",ТекНомер);
		
		ТекстЗапроса=ТекстЗапроса+Символы.ПС+";"+Символы.ПС+"/////////////////////////////////////////"+Символы.ПС+
		"ВЫБРАТЬ
		|	ЗаказПокупателяРазмещениеТоваров.Номенклатура
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	Документ.КорректировкаЗаказаПокупателя.РазмещениеТоваров КАК ЗаказПокупателяРазмещениеТоваров
		|ГДЕ
		|	ЗаказПокупателяРазмещениеТоваров.Ссылка = &Ссылка
		|	И ЗаказПокупателяРазмещениеТоваров.Размещение ССЫЛКА Документ.ЗаказПоставщику
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РазмещениеЗаказовВПутиОстатки.Номенклатура,
		|	МАКСИМУМ(РазмещениеЗаказовВПутиОстатки.Очередь) КАК Очередь
		|ПОМЕСТИТЬ ТаблОчереди
		|ИЗ
		|	РегистрНакопления.РазмещениеЗаказовВПути.Остатки(
		|			&ПериодОчереди,
		|			Номенклатура В
		|				(ВЫБРАТЬ
		|					Товары.Номенклатура
		|				ИЗ
		|					Товары)) КАК РазмещениеЗаказовВПутиОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	РазмещениеЗаказовВПутиОстатки.Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	&Период КАК Период,
		|	&ВидДвиженияПриход 		КАК ВидДвижения,
		|	ЕСТЬNULL(Оч.Очередь, 1) КАК Очередь,
		|	Док.Ссылка.Заказ 		КАК Размещение,
		|	Док.Номенклатура 		КАК Номенклатура,
		|	Док.Размещение 			КАК ЗаказПоставщику,
		|	СУММА(Док.Количество) 	КАК Количество
		|ИЗ
		|	Документ.КорректировкаЗаказаПокупателя.РазмещениеТоваров КАК Док
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблОчереди КАК Оч
		|		ПО Док.Номенклатура = Оч.Номенклатура
		|ГДЕ
		|	Док.Ссылка = &Ссылка
		|	И Док.Размещение ССЫЛКА Документ.ЗаказПоставщику
		|
		|СГРУППИРОВАТЬ ПО
		|	Док.Ссылка,
		|	ЕСТЬNULL(Оч.Очередь, 1),
		|	Док.Размещение,
		|	Док.Номенклатура"
	КонецЕсли;	
	
	
	
	Запрос=Новый Запрос;
	Запрос.Текст=ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Организация", 			Ссылка.Заказ.Организация);
	Запрос.УстановитьПараметр("Контрагент", 			Ссылка.Заказ.Контрагент);
	Запрос.УстановитьПараметр("СуммаДокумента", 		Ссылка.Сумма);
	Запрос.УстановитьПараметр("Заказ", 					Ссылка.Заказ);
	
	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.УстановитьПараметр("Период", 			Ссылка.Дата);
	Запрос.УстановитьПараметр("ПериодОчереди", 		?(НачалоДня(Ссылка.Дата) = НачалоДня(ТекущаяДата()), НачалоДня(ТекущаяДата()), Ссылка.Дата));
	Запрос.УстановитьПараметр("ВидДвиженияПриход", 	ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("ВидДвиженияРасход", 	ВидДвиженияНакопления.Расход);
	Запрос.УстановитьПараметр("ПустойСклад", 		Справочники.Склады.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяУпаковка", 	Справочники.УпаковкиНоменклатуры.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустойИнициатор", 	Справочники.ФизическиеЛица.ПустаяСсылка());

	Пакет = Запрос.ВыполнитьПакет();
	ПараметрыСистемы = КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[0].Выгрузить());
	
	ДополнительныеСвойства.Вставить("ПараметрыСистемы", 	ПараметрыСистемы);
	ДополнительныеСвойства.Вставить("Шапка", 				КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[1].Выгрузить()));
	
	Для Каждого Элем Из Нтаб Цикл
		ДополнительныеСвойства.Вставить(Элем.Ключ,Пакет[Элем.Значение].Выгрузить());
	КонецЦикла;	
	
	ДополнительныеСвойства.Вставить("ДолгиПоОтгрузкам", Новый ТаблицаЗначений);  //очистка
	
	
	
	Если ДополнительныеСвойства.Свойство("ЗаказыПокупателей") Тогда
		ДополнительныеСвойства.Вставить("НеудоволетворенныйСпрос", РаботаСНоменклатурой.ОпределитьНеудовлетворенныйСпрос(ДополнительныеСвойства.ЗаказыПокупателей, Ссылка.Заказ, Ссылка.Заказ.Склад, Ссылка.Заказ.Подразделение, Ссылка.Дата));
	КонецЕсли;
	
КонецПроцедуры