﻿
Процедура ПередЗаписью(Отказ)
	
	// реквизиты по умолчанию
	
	Если ДатаСоздания 			= '00010101' Тогда ДатаСоздания = ТекущаяДата(); КонецЕсли;
	Если ДатаНачалаВыполнения 	= '00010101' И Статус = Перечисления.СтатусыЗадач.ВРаботе Тогда ДатаНачалаВыполнения = ТекущаяДата(); КонецЕсли;
	Если Автор.Пустая() И ЭтоНовый() Тогда Автор = ПараметрыСеанса.ТекущийПользователь; КонецЕсли;
	
КонецПроцедуры



Процедура СформироватьПисьмоОбИзмененииСтатуса(СтатусСт)
	
	// Запросим всех кто подписан
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ Пользователь.Почта Почта ИЗ РегистрСведений.ОтслеживаниеЗадач ГДЕ Задача = &Ссылка И Пользователь.Почта <> """"");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		// Заполним документ вложениями если там есть картинки
		
		Письмо = Документы.Письмо.СоздатьДокумент();
		Письмо.КомуСписок.Добавить().Кому = Выборка.Почта;
		
		//Для Каждого Вложение ИЗ Вложения Цикл
		//	НовСтрока = Письмо.Вложения.Добавить();
		//	НовСтрока.Вложение = Вложение.Данные;
		//	НовСтрока.ИмяФайла = Вложение.Ключ; КонецЦикла;
		
		ЗаголовокПисьма = "
		|<h3>Задача (ticket_" + Строка(Код) + ") <font color=#ff0000><strike>" + НРег(СтатусСт) + "</strike></font> -> <font color=#536ac2>" + НРег(Статус) + "</font></h3>
		//|<hr>
		|<h2>" + Наименование + "</h2>";
		
		ПодвалПисьма = "<hr>
		|<i><small>
		|<p>Мы выслали вам это автоматическое письмо, так как вы подписаны на отслеживание данной задачи</p>
		|<p>Если вам больше не нужно отслеживать данную задачу, тогда в базе отключите отслеживание задачи (В списке задач нужно нажать клавишу ""пробел"")</p>
		|<p>Письмо сформировано автоматически, не нужно отвечать на это письмо.</p>
		|</small></i>";
							
		ОбщиеФункции.ОповеститьПоПочте(Выборка.Почта , "[Ticket " + Строка(Код) + "] (" + Статус + ")  " + Наименование, 
								ЗаголовокПисьма + Описание + ПодвалПисьма,
								Ложь, Перечисления.ТипыТекстовЭлектронныхПисем.HTML,
								Письмо); КонецЦикла;
	
КонецПроцедуры
Процедура ПриЗаписи(Отказ)
	
	МожетБытьВочереди = Справочники.Задачи.ЗадачаМожетБытьВОчереди(Ссылка);
	
	Если МожетБытьВочереди Тогда
		
		Номер = Неопределено;
		Если ДополнительныеСвойства.Свойство("ВОчередь") Тогда
			Если Врег(ДополнительныеСвойства.ВОчередь) = ВРег("Вначало") Тогда
				Номер = Справочники.Задачи.ПолучитьНомерПервойЗадачи(Закреплённая);
			ИначеЕсли Врег(ДополнительныеСвойства.ВОчередь) = ВРег("Вконец") Тогда
				Номер = Справочники.Задачи.ПолучитьПоследнийНомерЗадачи() + 1; КонецЕсли; КонецЕсли;
		
		// Если в очередь тогда установим последним в очередь или если вперед тогда поставим вперед
		
		Если Номер <> Неопределено Или Не Справочники.Задачи.ПолучитьОчередь(Ссылка) Тогда
			Справочники.Задачи.ПоставитьВОчередь(Ссылка, Номер); КонецЕсли;
		
	Иначе
		
		// Проверим что задачи нет в очереди
		
		Запись = РегистрыСведений.ОчередностьЗадач.СоздатьМенеджерЗаписи();
		Запись.Задача = Ссылка;
		
		Запись.Прочитать();
		
		Если Запись.Номер Тогда Запись.Удалить(); КонецЕсли; КонецЕсли;
		
	// Если у заказчика есть наблюдатель и он не наблюдатель задачи тогда сделаем его наблюдателем
	
	//Если Не Отказ И Не ОбменДанными.Загрузка  Тогда
	//	ПроверитьНаблюдателейПоУмолчаниюИНазначитьЕслиИхНет() КонецЕсли;
		
	// Если есть напоминалка тогда напомним пользователю об изменениях по почте
	
	Если 	Не Отказ И Не ОбменДанными.Загрузка И 
			ДополнительныеСвойства.Свойство("ИзмененныеРеквизиты") И 
			ДополнительныеСвойства.ИзмененныеРеквизиты.Свойство("Статус") Тогда
			
		СформироватьПисьмоОбИзмененииСтатуса(ДополнительныеСвойства.ИзмененныеРеквизиты.Статус); КонецЕсли;
	
	// Запишем статус
	
	Если Не Отказ Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Зап = РегистрыСведений.СрезЗадачПоДням.СоздатьМенеджерЗаписи();
		
		Зап.Период 	= ТекущаяДата();
		Зап.Задача 	= Ссылка;
		Зап.Статус 	= Статус;
		//Зап.Автор 	= ПараметрыСеанса.ТекущийПользователь;
		
		Если Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Зап) Тогда
			Отказ = Истина; КонецЕсли; 
		
		УстановитьПривилегированныйРежим(Ложь); КонецЕсли;
	
КонецПроцедуры
