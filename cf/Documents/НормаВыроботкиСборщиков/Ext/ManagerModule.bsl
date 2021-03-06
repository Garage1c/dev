﻿
Процедура ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос(
	
	КэшируемыеФункции.ТектЗапросаПолученияПараметровСистемы() + "
	|;
	
	|ВЫБРАТЬ
	|	Ссылка
	|ИЗ
	|	Документ.НормаВыроботкиСборщиков
	|ГДЕ
	|	Ссылка = &Ссылка
	|;
	
	// НОРМЫ СБОРЩИКОВ
	
	|ВЫБРАТЬ
	|	&Период Период,
	|	Сборщик, 
	|	ПозицийВДень
	|ИЗ
	|	Документ.НормаВыроботкиСборщиков.Сборщики
	|
	|ГДЕ
	|	Ссылка = &Ссылка
	|");

	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.УстановитьПараметр("Период", 			Ссылка.Дата);
	
	Пакет = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.Вставить("ПараметрыСистемы", 		КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[0].Выгрузить()));
	ДополнительныеСвойства.Вставить("Шапка", 					КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[1].Выгрузить()));
	ДополнительныеСвойства.Вставить("НормаВыработкиСборщиков",Пакет[2].Выгрузить());
	
КонецПроцедуры
