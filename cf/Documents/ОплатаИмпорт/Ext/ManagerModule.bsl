﻿Процедура ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства) Экспорт
	
	
	Запрос = Новый Запрос(
			 
	КэшируемыеФункции.ТектЗапросаПолученияПараметровСистемы() + "
	|;
		
	// ОПЛАТА ПО ИМПОРТУ
		
	|ВЫБРАТЬ
	|	&Период				Период,
	|	&ВидДвиженияРасход 	ВидДвижения,
	|	Инвойс,
	|   СУММА(Сумма)        Сумма
	|ИЗ
	|	Документ.ОплатаИмпорт.РасшифровкаСуммы
	|ГДЕ
	|	Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО Ссылка, Инвойс
	|;
	
	// ОПЛАТЫ ПО ИНВОЙСУ
	
	|ВЫБРАТЬ
	|	&Период			Период,
	|	Инвойс,
	|   СУММА(Сумма)	Сумма,
	|	СУММА(СуммаУпр) СуммаУпр
	|ИЗ
	|	Документ.ОплатаИмпорт.РасшифровкаСуммы
	|ГДЕ
	|	Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО Ссылка, Инвойс
	|;
	
	// ДОЛГИ ПО ЗАКАЗАМ ПОСТАВЩИКУ
	
	|ВЫБРАТЬ
	|	&Период				Период,
	|	&ВидДвиженияРасход 	ВидДвижения,
	|	Ссылка.Контрагент	Контрагент,
	|	ЗаказПоставщику,
	|   Сумма
	|ИЗ
	|	Документ.ОплатаИмпорт.РасшифровкаСуммы
	|ГДЕ
	|	Ссылка = &Ссылка
	|;
	
	// ДОЛГИ ПО ИНВОЙСАМ
	
	|ВЫБРАТЬ
	|	&Период				Период,
	|	&ВидДвиженияРасход 	ВидДвижения,
	|	Ссылка.Контрагент	Контрагент,
	|	ЗаказПоставщику,
	|	Инвойс,
	|   Сумма
	|ИЗ
	|	Документ.ОплатаИмпорт.РасшифровкаСуммы
	|ГДЕ
	|	Ссылка = &Ссылка
	|	
	|");
	
	
	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.УстановитьПараметр("Период", 			Ссылка.Дата);
	Запрос.УстановитьПараметр("Валюта", 			Ссылка.Валюта);

	Запрос.УстановитьПараметр("ВидДвиженияПриход", 	ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("ВидДвиженияРасход", 	ВидДвиженияНакопления.Расход);

	Пакет = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.Вставить("ПараметрыСистемы", КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[0].Выгрузить()));
	ДополнительныеСвойства.Вставить("ОплатыИмпорт", 	Пакет[1].Выгрузить());
  	ДополнительныеСвойства.Вставить("ОплатыПоИнвойсу", 	Пакет[2].Выгрузить());
   	ДополнительныеСвойства.Вставить("ДолгиПоЗаказамПоставщику", 	Пакет[3].Выгрузить());
    ДополнительныеСвойства.Вставить("ДолгиПоИнвойсам", 	Пакет[4].Выгрузить());
                 
КонецПроцедуры
Функция ЗаполнитьРасшифровкуСуммы(Дата, Знач Сумма, Знач СуммаУпр) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ 
	|	Инвойс,
	|	СуммаОстаток 			Сумма
	|ИЗ 
	|	РегистрНакопления.ОплатыИмпорт.Остатки(&Период,)
	|УПОРЯДОЧИТЬ ПО Инвойс.Дата");
	           
	Запрос.УстановитьПараметр("Период", Дата);
	
	Оплаты = Новый ТаблицаЗначений;
	Оплаты.Колонки.Добавить("Инвойс");
	Оплаты.Колонки.Добавить("Сумма");
	Оплаты.Колонки.Добавить("СуммаУпр");
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СколькоРаспределить =  Сумма; 
	СколькоРаспределитьРуб = СуммаУпр;
	Коэффициент  =  ?(СуммаУпр >0, СколькоРаспределитьРуб/СколькоРаспределить, 0);
	Пока Выборка.Следующий() Цикл
		НовСтрока = Оплаты.Добавить();
		НовСтрока.Инвойс = Выборка.Инвойс;
		
		Если Выборка.Сумма >= СколькоРаспределить Тогда
			НовСтрока.Сумма = СколькоРаспределить;
			НовСтрока.СуммаУпр = Коэффициент*НовСтрока.Сумма;
			Прервать;
		Иначе
			НовСтрока.Сумма = Выборка.Сумма;
			НовСтрока.СуммаУпр = Коэффициент*НовСтрока.Сумма;
			СколькоРаспределить = СколькоРаспределить - НовСтрока.Сумма;
		КонецЕсли;
	 КонецЦикла;
	 
	 Возврат Оплаты;
	 
КонецФункции
