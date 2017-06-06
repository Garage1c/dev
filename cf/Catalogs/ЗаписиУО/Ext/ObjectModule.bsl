﻿
Функция ОбновитьРезультат() Экспорт
	
	// пересчитывает результат
	
	текРезультат = Справочники.ЗаписиУО.ПолучитьРезультат(Ссылка, Владелец.ДатаНачала, Владелец.ДатаОкончания);
	Если текРезультат = Неопределено Тогда
		
		Возврат Ложь;
		
	ИначеЕсли Результат <> текРезультат Тогда
		
		Результат 		= текРезультат;
		АвтоРезультат 	= текРезультат;
		Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(ЭтотОбъект); КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПередЗаписью(Отказ)
	
	// Сохраним историю результата
	
	Если Результат И
			(	Не ИсторияРезультатов.Количество() Или
				ИсторияРезультатов[ИсторияРезультатов.Количество() - 1].Результат <> Результат) Тогда
				
		НовЗапись = ИсторияРезультатов.Добавить();
		НовЗапись.Дата 			= ТекущаяДата();
		НовЗапись.Пользователь 	= ПараметрыСеанса.ТекущийПользователь;
		НовЗапись.Результат 	= Результат; КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// Если результат изменился тогда пересчитаем все зависимые показатели
	
	Если 	ДополнительныеСвойства.Свойство("ИзмененныеРеквизиты") И 
			ДополнительныеСвойства.ИзмененныеРеквизиты.Свойство("Результат") И 
			Результат <> ДополнительныеСвойства.ИзмененныеРеквизиты.Результат Тогда
		
		// Получим соответвие в котором будем хранить ссылки на уже подсчитанные объекты, чтобы повторно из их не пересчитывать
		
		ОтработанныеРезультаты = ?(ДополнительныеСвойства.Свойство("ОтработанныеРезультаты"), ДополнительныеСвойства.ОтработанныеРезультаты, Новый Соответствие);
		Если ОтработанныеРезультаты[Ссылка] <> Истина Тогда ОтработанныеРезультаты.Вставить(Ссылка, Истина);
		
			// Построим цепочку зависимостей чтобы пересчитать зависимые
			
			Запрос = Новый Запрос("
			|ВЫБРАТЬ Ссылка ИЗ Справочник.ЗаписиУО ГДЕ Владелец = &Владелец И СпособПолученияРезультата = 2 И Результат = АвтоРезультат И Не ПометкаУдаления И Выражение ПОДОБНО ""%[" + Код + "]%""
			|ОБЪЕДИНИТЬ
			|ВЫБРАТЬ Ссылка ИЗ Справочник.ЗаписиУО ГДЕ СпособПолученияРезультата = 1 И Ссылка = &Родитель И Результат = АвтоРезультат И Не ПометкаУдаления");
			
			Запрос.УстановитьПараметр("Владелец", 	Владелец);
			Запрос.УстановитьПараметр("Родитель", 	Родитель);
			
			// Пересчитаем их всех заного
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				
				ЗависимыйОб = Выборка.Ссылка.ПолучитьОбъект();
				ЗависимыйОб.ДополнительныеСвойства.Вставить("ОтработанныеРезультаты", ОтработанныеРезультаты);
				Если Не ЗависимыйОб.ОбновитьРезультат() Тогда
					Отказ = Истина; КонецЕсли; КонецЦикла; КонецЕсли; КонецЕсли;
	
КонецПроцедуры

Функция ЗаписатьНовыйПоказатель(текРезультат, текАвтоРезультат = Неопределено) Экспорт

	Результат 		= текРезультат;
	АвтоРезультат 	= ?(текАвтоРезультат  = Неопределено, Результат, текАвтоРезультат );
	
	Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(ЭтотОбъект);
	
КонецФункции