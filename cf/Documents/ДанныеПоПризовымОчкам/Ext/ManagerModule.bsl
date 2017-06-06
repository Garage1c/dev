﻿Процедура ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос(
	         
	КэшируемыеФункции.ТектЗапросаПолученияПараметровСистемы() + "
	|;
	
	// ШАПКА
	
	|ВЫБРАТЬ
	|	Автор, Ответственный, Месяц
	|ИЗ
	|	Документ.ПризовыеОчки
	|ГДЕ
	|	Ссылка = &Ссылка
	|;
	
	|ВЫБРАТЬ
	|	Ссылка.Месяц Период, &ВидДвиженияРасход ВидДвижения, Отдел, Подразделение, Сотрудник, Выдача Количество
	|ИЗ 
	|	Документ.ДанныеПоПризовымОчкам.Очки 
	|ГДЕ 
	|	Ссылка = &Ссылка И Выдача > 0
	//|;
	//|
	//|ВЫБРАТЬ
	//|	Ссылка.Месяц Период, Отдел, Подразделение, Сотрудник, Ссылка.ВидОчков, -Итого Количество
	//|ИЗ 
	//|	Документ.ДанныеПоПризовымОчкам.Очки 
	//|ГДЕ 
	//|	Ссылка = &Ссылка И Итого > 0
	|");
	

	//Запрос.УстановитьПараметр("Область", 		ПараметрыСеанса.ТекущаяОбласть);
	Запрос.УстановитьПараметр("Ссылка", 		Ссылка);
	Запрос.УстановитьПараметр("ВидДвиженияРасход", 	ВидДвиженияНакопления.Расход);
	
	Пакет = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.Вставить("ПараметрыСистемы", 		КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[0].Выгрузить()));
	ДополнительныеСвойства.Вставить("Шапка", 					КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(Пакет[1].Выгрузить()));
	
	ДополнительныеСвойства.Вставить("ПризовыеОчки", Пакет[2].Выгрузить());
//	ДополнительныеСвойства.Вставить("ОборотыПоПризовымОчкам", Пакет[3].Выгрузить());
	
	                       
КонецПроцедуры
