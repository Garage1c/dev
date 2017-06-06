﻿
Функция ПолучитьТекстЗапросаПолученияСпискаТоваров() Экспорт
	
	Возврат "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура 
	|ИЗ
	|	Документ.ЗаказПоставщику.Товары
	|ГДЕ
	|	Ссылка = &ДокументСсылка
	|";
	
КонецФункции


Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Если есть стоп заказ то не будем даже напрягать систему
	
	Если 	РежимПроведения = РежимПроведенияДокумента.Оперативный И
			РаботаСНоменклатурой.ЕстьСтопЗаказ(Товары.ВыгрузитьКолонку("Номенклатура")) Тогда
			
		Отказ = Истина;
		Возврат; КонецЕсли;
	
	// Подготовка
	
	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриПроведенииДокумента(Ссылка);
	
	Документы[Метаданные().Имя].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Проведение
	
//	ПроведенияДокументов.ЗаказыПоставщикам(ДополнительныеСвойства, Движения, Отказ);
//	ПроведенияДокументов.РасчетныеСрокиДвиженияЗаказа(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведенияДокументов.ПровестиПоВсемРегистрам(Метаданные().Движения, ДополнительныеСвойства, Движения, Отказ);
	       
	// Запись
	
	Движения.Записать();
	
	//КонтрольПроведения.ПроверитьЗаказыПоставщикам(ЭтотОбъект, Отказ, Заголовок);
		КонтрольПроведения.ПроверитьПоВсемРегистрам(ЭтотОбъект, Отказ, Заголовок);

	
	// Установим состояние
	
	Если Не Отказ Тогда
		масЗаказов = Новый Массив; масЗаказов.Добавить(Ссылка);
		Если Не Документы.ЗаказПоставщику.УстановитьСостояния(масЗаказов) Тогда
			Отказ = Истина; КонецЕсли; КонецЕсли;

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка

	Заголовок = КонтрольПроведения.ПолучитьСтандарнтыйЗаголовокПриОтменеПроведенияДокумента(Ссылка);
	
	// Запись
	
	Движения.ЗаказыПоставщикам.Очистить();
	Движения.Записать();

	КонтрольПроведения.ПроверитьЗаказыПоставщикам(ЭтотОбъект, Отказ, Заголовок);
	
	// Установим состояние
	
	Если Не Отказ Тогда
		Если Не Заказы.УстановитьСостояниеЗаказа(Ссылка, Перечисления.СостоянияЗаказа.ПустаяСсылка()) Тогда
			Отказ = Истина; КонецЕсли; КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Сумма = Товары.Итог("Сумма") + ?(СуммаВключаетНДС,0,Товары.Итог("СуммаНДС"));
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ Процесс.Пустая() И ФункцииБизнесПроцессов.СтоитНаТочкеМаршрута(Процесс, БизнесПроцессы.СогласованиеЗаказаПоставщику.ТочкиМаршрута.СогласованиеСПоставщиком) Тогда
		 Колич  = ПроверяемыеРеквизиты.Найти("Товары.Количество");
		 Если Колич <> Неопределено Тогда ПроверяемыеРеквизиты.Удалить(Колич); КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус = Перечисления.СтатусыЗаказаПоставщику.Создан;
	
КонецПроцедуры
