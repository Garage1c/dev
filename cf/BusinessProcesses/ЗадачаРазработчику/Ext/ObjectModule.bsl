﻿
Процедура ЗадачаРешенаПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = КонтролерПринимаетЗадачу;
	
КонецПроцедуры

Функция СформироватьАдресаПолучатели()
	
	Запрос = Новый Запрос("ВЫБРАТЬ Пользователь.Почта КАК Ящик ИЗ РегистрСведений.ПодпискиНаОповещенияПоПочте ГДЕ Объект = &БизнесПроцесс");
	Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка); 
	
	ПочтовыеЯщики = "";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ПочтовыеЯщики = ПочтовыеЯщики + ?(ПочтовыеЯщики = "","",", ") + Выборка.Ящик;
		
	КонецЦикла;
	
	Возврат ПочтовыеЯщики;
	
КонецФункции
Функция ПреобразоватьТекстHMLВТекст(ТексHTML)
	
	ФормДок = Новый ФорматированныйДокумент;
	ФормДок.УстановитьHTML(ТексHTML, Новый Структура);
	
	Возврат ФормДок.ПолучитьТекст();
	
КонецФункции

Функция ДобавитьВОповещения(СылкаНаОбъект, Пользователь)
	
	Рег = РегистрыСведений.ПодпискиНаОповещенияПоПочте.СоздатьМенеджерЗаписи();
	Рег.Объект 			= СылкаНаОбъект;
	Рег.Пользователь 	= Пользователь;

	Попытка
		Рег.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОбщегоНазначенияКлиентСервер.ПолучитьПредставлениеОписанияОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ОтработатьСменуИсполнителя(ТекЗадачаСсылка)
	
	// Получим задачу
	
	Если ТекЗадачаСсылка.ТочкаМаршрута = БизнесПроцессы.ЗадачаРазработчику.ТочкиМаршрута.РешениеЗадачи Тогда
		
		ТекЗадача = ТекЗадачаСсылка.ПолучитьОбъект();
		ТекЗадача.Пользователь = Исполнитель;
		
		Попытка
			ТекЗадача.Записать();
		Исключение
			стрОшибки = ОписаниеОшибки();
			ОбщиеФункции.СообщитьТекст("Ошибка при записи задачи смены исполнителя
									|" + стрОшибки);
			Возврат Ложь;
		КонецПопытки;
		
	КонецЕсли;
	
	// Установим оповещение для исполнителя
	
	НовЗапись = РегистрыСведений.ПодпискиНаОповещенияПоПочте.СоздатьМенеджерЗаписи();
	НовЗапись.Объект 		= Ссылка;
	НовЗапись.Пользователь 	= Исполнитель;
	
	Попытка
		НовЗапись.Записать();
	Исключение
		стрОшибки = ОписаниеОшибки();
		ОбщиеФункции.СообщитьТекст("Ошибка при записи оповещения смены исполнителя
									|" + стрОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Процедура ПередЗаписью_Ст(Отказ)
	
	// Проверим что изменилось
	
	НеПисатьИсторию = Ложь;
	ДополнительныеСвойства.Свойство("НеПисатьИсторию", НеПисатьИсторию);
	
	ТекЗадача = ФункцииБизнесПроцессов.ТекущаяЗадача(Ссылка);
	
	Если 	Не ЭтоНовый() И
			НеПисатьИсторию <> Истина И
			Не Завершен Тогда
		
		
		Если ТекЗадача = Неопределено Тогда
			
			ТекЗадача = Задачи.ЗадачаПользователю.ПустаяСсылка();
			
			//ОбщиеФункции.СообщитьТекст("Не обнаружена текущая задача. БП записан быть не может");
			//Отказ = Истина;
			//Возврат;
			
		КонецЕсли;
			
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Представление(Проект),
		|	Представление(Тема),
		|	Представление(ТипЗадачи),
		|	Представление(Исполнитель),
		|	Представление(Контроллер),
		|	Представление(ПланируемаяДата),
		|	Представление(Часов),
		|	Представление(ЦенаЗаЧас),
		|	Представление(Стоимость),
		|	Представление(Комментарий),
		|	Проект,
		|	Тема,
		|	Комментарий,
		|	ТипЗадачи,
		|	Исполнитель,
		|	Контроллер,
		|	ПланируемаяДата,
		|	Часов,
		|	ЦенаЗаЧас,
		|	Стоимость
		|ИЗ
		|	БизнесПроцесс.ЗадачаРазработчику 
		|ГДЕ
		|	Ссылка = &Ссылка");
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
		Если ТаблицаЗапроса.Количество() Тогда
			
			Строка 	= ТаблицаЗапроса[0];
			текДата = ТекущаяДата();
			ТексПисьма = "";
			
			Для Каждого Колонка Из ТаблицаЗапроса.Колонки Цикл
				
				ИмяРеквизита = Колонка.Имя;
				
				Если Прав(ИмяРеквизита, 13) <> "Представление" Тогда
					
					Если 	ИмяРеквизита = "Комментарий" И
							ПустаяСтрока(Комментарий) Тогда
						Продолжить; // пустой комментарий нет смысла писать в изменения
					КонецЕсли;
					
					Если Строка[ИмяРеквизита] <> ЭтотОбъект[ИмяРеквизита] Тогда
					
						НовСтрока = ИсторияИзменений.Добавить();
						
						НовСтрока.ИмяРеквизита	 		= ИмяРеквизита;
						НовСтрока.Дата			 		= текДата;
						НовСтрока.Задача 				= ТекЗадача;
						НовСтрока.ПредставлениеДо 		= Строка[ИмяРеквизита + "Представление"];
						НовСтрока.ПредставлениеПосле 	= Строка(ЭтотОбъект[ИмяРеквизита]);
						НовСтрока.Автор					= ПараметрыСеанса.ТекущийПользователь;
						
						// Подготоимся к письму
						
						Если ИмяРеквизита = "Комментарий" Тогда 
							
							ТексПисьма = ТексПисьма + "
								|" + ПреобразоватьТекстHMLВТекст(Комментарий);
							
						Иначе
							
							Если ПустаяСтрока(Строка[ИмяРеквизита + "Представление"]) Тогда
								
								ТексПисьма = ТексПисьма + "
									|Установлено значение в поле " + ИмяРеквизита + ": " + Строка(ЭтотОбъект[ИмяРеквизита]);
								
							Иначе	
							
								ТексПисьма = ТексПисьма + "
									|Поле " + ИмяРеквизита + " изменил с " + Строка[ИмяРеквизита + "Представление"] + " на  " + Строка(ЭтотОбъект[ИмяРеквизита]);
								
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Если ТексПисьма <> "" Тогда
				
				//ОповеститьПоПочте("
				//|	Добрый день!
				//|
				//|Произошли изменения в задаче №" + Номер + "
				//|		инициатор изменения: " + ПараметрыСеанса.ТекущийПользователь + "
				//|
				//|--------------------------
				//|
				//|" + ТексПисьма + "
				//|
				//|--------------------------
				//|
				//|Письмо сформировано автоматически. Не нужно отвечать на данное письмо!
				//|
				//|Вы получили письмо, потому что являетесь подписчиком к изменению задачи №" + Номер + ",
				//|если вы не желаете получать такие письма в дальнейшем отключите подписку из данной задачи.", Отказ);
				
			КонецЕсли;
		КонецЕсли;
	
	ИначеЕсли 	ЭтоНовый() И 
				НеПисатьИсторию <> Истина И
				Не Исполнитель.Пустая() И 
				Исполнитель <> Контроллер Тогда
				
		// Подпишем на оповещения
		
		СсылкаНового = БизнесПроцессы.ЗадачаРазработчику.ПолучитьСсылку(Новый УникальныйИдентификатор);
		УстановитьСсылкуНового(СсылкаНового);
		
		Если ДобавитьВОповещения(ПолучитьСсылкуНового(), Исполнитель) Тогда
			
		//	ОповеститьПоПочте("
		//	|	Добрый день!
		//	|
		//	|Создана новая задача, в которой Вы являетесь исполнителем
		//	|		инициатор создания: " + ПараметрыСеанса.ТекущийПользователь + "
		//	|
		//	|--------------------------
		//	|
		//	|" + ПреобразоватьТекстHMLВТекст(Описание) + "
		//	|
		//	|--------------------------
		//	|
		//	|Письмо сформировано автоматически. Не нужно отвечать на данное письмо!", Отказ);
		//
		Иначе
			
			Отказ = Истина;
			
		КонецЕсли;
	КонецЕсли;
	
	Если Не Отказ Тогда
	
		Автор = ПараметрыСеанса.ТекущийПользователь;
		
		// Установим дату завершения
		
		Если 	Завершен И
				ДатаЗавершения = '00010101' Тогда
				
			ДатаЗавершения = ТекущаяДата();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
Процедура ПередЗаписью(Отказ)
	
	// Подготовим таблицу изменений для письма
	
	ОписаниеСтроки 		= Новый ОписаниеТипов("Строка");
	ТаблицаИзменений 	= Новый ТаблицаЗначений;
	ТаблицаИзменений.Колонки.Добавить("ИмяРеквизита", 		ОписаниеСтроки);
	ТаблицаИзменений.Колонки.Добавить("ПредставлениеДо", 	ОписаниеСтроки);
	ТаблицаИзменений.Колонки.Добавить("ПредставлениеПосле", ОписаниеСтроки);
	ТаблицаИзменений.Колонки.Добавить("Автор", 				Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	
	// Проверим что изменилось
	
	НеПисатьИсторию 	= Ложь;
	ДополнительныеСвойства.Свойство("НеПисатьИсторию", 	НеПисатьИсторию);
	
	текОповещетьПоПочте = Неопределено;
	Если ДополнительныеСвойства.Свойство("ОповещатьПоПочте", текОповещетьПоПочте) Тогда
		ОповещатьПоПочте = текОповещетьПоПочте;
	КонецЕсли;
	
	ТекЗадача = ФункцииБизнесПроцессов.ТекущаяЗадача(Ссылка);
	
	Если 	Не ЭтоНовый() И
			НеПисатьИсторию <> Истина И
			Не Завершен Тогда
		
		Если ТекЗадача = Неопределено Тогда
			
			ТекЗадача = Задачи.ЗадачаПользователю.ПустаяСсылка();
			
			//ОбщиеФункции.СообщитьТекст("Не обнаружена текущая задача. БП записан быть не может");
			//Отказ = Истина;
			//Возврат;
			
		КонецЕсли;
			
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Представление(Проект),
		|	Представление(Тема),
		|	Представление(ТипЗадачи),
		|	Представление(Важность),
		|	Представление(Исполнитель),
		|	Представление(Контроллер),
		|	Представление(ПланируемаяДата),
		|	Представление(Часов),
		|	Представление(ЦенаЗаЧас),
		|	Представление(Стоимость),
		|	Представление(Комментарий),
		|	Проект,
		|	Тема,
		|	Комментарий,
		|	ТипЗадачи,
		|	Важность,
		|	Исполнитель,
		|	Контроллер,
		|	ПланируемаяДата,
		|	Часов,
		|	ЦенаЗаЧас,
		|	Стоимость
		|ИЗ
		|	БизнесПроцесс.ЗадачаРазработчику 
		|ГДЕ
		|	Ссылка = &Ссылка");
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
		Если ТаблицаЗапроса.Количество() Тогда
			
			Строка 	= ТаблицаЗапроса[0];
			текДата = ТекущаяДата();
			
			// Отработаем исключения
			
			Если 	Строка.Исполнитель <> Исполнитель И
					Не ОтработатьСменуИсполнителя(ТекЗадача) Тогда
					
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			
			// Отработает изменени других реквизитов
			
			Для Каждого Колонка Из ТаблицаЗапроса.Колонки Цикл
				
				ИмяРеквизита = Колонка.Имя;
				
				Если Прав(ИмяРеквизита, 13) <> "Представление" Тогда
					
					Если 	ИмяРеквизита = "Комментарий" И
							ПустаяСтрока(Комментарий) Тогда
						Продолжить; // пустой комментарий нет смысла писать в изменения
					КонецЕсли;
					
					Если Строка[ИмяРеквизита] <> ЭтотОбъект[ИмяРеквизита] Тогда
					
						НовСтрока = ИсторияИзменений.Добавить();
						
						НовСтрока.ИмяРеквизита	 		= ИмяРеквизита;
						НовСтрока.Дата			 		= текДата;
						НовСтрока.Задача 				= ТекЗадача;
						НовСтрока.ПредставлениеДо 		= Строка[ИмяРеквизита + "Представление"];
						НовСтрока.ПредставлениеПосле 	= Строка(ЭтотОбъект[ИмяРеквизита]);
						НовСтрока.Автор					= ПараметрыСеанса.ТекущийПользователь;
						
						// Подготоимся к письму
						
						Если ОповещатьПоПочте Тогда
							ЗаполнитьЗначенияСвойств(ТаблицаИзменений.Добавить(), НовСтрока);
						КонецЕсли;
						
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			ТекстПисьма = ПолучитьТекстДляПисьмаПоИзменениям(ТаблицаИзменений);
			Если ТекстПисьма <> "" Тогда
				
				ТемаПисьма = "[" + Проект.Наименование + "] " + ?(ЭтоНовый()," новая задача", "№" + Номер) + " - " + Тема;
				
				ОбщиеФункции.ОповеститьПоПочте(СформироватьАдресаПолучатели(), ТемаПисьма,
				"
				|	Добрый день!
				|
				|Произошли изменения в задаче №" + Номер + "
				|		инициатор изменения: " + ПараметрыСеанса.ТекущийПользователь + "
				|
				|--------------------------
				|
				|" + ТекстПисьма + "
				|
				|--------------------------
				|
				|Письмо сформировано автоматически. Не нужно отвечать на данное письмо!
				|
				|Вы получили письмо, потому что являетесь подписчиком к изменению задачи №" + Номер + ",
				|если вы не желаете получать такие письма в дальнейшем отключите подписку из данной задачи.", Отказ);
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Подпишем на оповещения
	
	Если 	ЭтоНовый() И 
			НеПисатьИсторию <> Истина И
			Не Исполнитель.Пустая() И 
			Исполнитель <> Контроллер Тогда
				
		СсылкаНового = БизнесПроцессы.ЗадачаРазработчику.ПолучитьСсылку(Новый УникальныйИдентификатор);
		УстановитьСсылкуНового(СсылкаНового);
		
		Если Не ДобавитьВОповещения(ПолучитьСсылкуНового(), Исполнитель) Тогда
			
			Отказ = Истина;
			
		КонецЕсли;
	КонецЕсли;

	
	Если Не Отказ Тогда
	
		Автор 				= ПараметрыСеанса.ТекущийПользователь;
		ОповещатьПоПочте 	= Истина;
		
		// Установим дату завершения
		
		Если 	Завершен И
				ДатаЗавершения = '00010101' Тогда
				
			ДатаЗавершения = ТекущаяДата();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
Функция ПолучитьТекстДляПисьмаПоИзменениям(ТаблицаИзменений = Неопределено)
	
	// Формирует текст по изменениям
	// данные может получать как из уже записанного БП
	// так еще не записаного в момент перед записью
	// для этого ему нужно передать переменную ТаблицаИзменений
	
	Если ТаблицаИзменений = Неопределено Тогда
	
		Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Дата
		|ПОМЕСТИТЬ
		|	ТаблицаПослДаты
		|ИЗ
		|	БизнесПроцесс.ЗадачаРазработчику.ИсторияИзменений КАК История
		|ГДЕ
		|	Ссылка = &Ссылка
		|УПОРЯДОЧИТЬ ПО
		|	Дата Убыв
		|;
		|ВЫБРАТЬ 
		|	История.ИмяРеквизита,
		|	История.ПредставлениеДо,
		|	История.ПредставлениеПосле,
		|	История.Автор
		|ИЗ 
		|	БизнесПроцесс.ЗадачаРазработчику.ИсторияИзменений КАК История
		|ГДЕ
		|	История.Ссылка = &Ссылка И
		|	История.Дата В (ВЫБРАТЬ Дата ИЗ ТаблицаПослДаты)
		|");
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		ТаблицаИзменений = Запрос.Выполнить().Выгрузить();
		
	КонецЕсли;
	
	ТексПисьма = "";
	
	Для Каждого Строка Из ТаблицаИзменений Цикл
		
		Если Строка.ИмяРеквизита = "Комментарий" Тогда 
							
							ТексПисьма = ТексПисьма + "
								|" + ПреобразоватьТекстHMLВТекст(Строка.ПредставлениеПосле);
		Иначе

			Если ПустаяСтрока(Строка.ПредставлениеДо) Тогда
									
				ТексПисьма = ТексПисьма + "
					|Установлено значение в поле " + Строка.ИмяРеквизита + ": " + Строка.ПредставлениеПосле;
									
			ИначеЕсли ПустаяСтрока(Строка.ПредставлениеПосле) Тогда
				
				ТексПисьма = ТексПисьма + "
					|Очищено значение в поле " + Строка.ИмяРеквизита + ": раньше было: " + Строка.ПредставлениеДо;
					
			Иначе	
			
				ТексПисьма = ТексПисьма + "
					|Поле " + Строка.ИмяРеквизита + " изменил с " + Строка.ПредставлениеДо + " на  " + Строка.ПредставлениеПосле;
									
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТексПисьма;
	
КонецФункции

Процедура РешениеЗадачиПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	Если ФормируемыеЗадачи.Количество() Тогда
	    
		Задача 	= ФормируемыеЗадачи[0];
		Процесс = Задача.БизнесПроцесс;
		
		Задача.Пользователь = Процесс.Исполнитель;
		
		ФормируемыеЗадачи[0].Наименование = ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи + " (" + Процесс.ТипЗадачи + ") - " + Процесс.Тема;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверкаЗадачиПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	Если ФормируемыеЗадачи.Количество() Тогда
	    
		Задача 	= ФормируемыеЗадачи[0];
		Процесс = Задача.БизнесПроцесс;
		
		Задача.Пользователь = Процесс.Контроллер;
		
		ФормируемыеЗадачи[0].Наименование = ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи + " (" + Процесс.ТипЗадачи + ") - " + Процесс.Тема;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Описание = "";
	ИсторияИзменений.Очистить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//Если Не БизнесПроцессы.ЗадачаРазработчику.ЗаписатьСтатусПроцесса(Ссылка) Тогда
	//	Отказ = Истина;
	//КонецЕсли;
		
КонецПроцедуры

Процедура ПослатьОповещениеОНазначенииОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	ТекстПисьма = ПолучитьТекстДляПисьмаПоИзменениям();
	ТемаПисьма = "[" + Проект.Наименование + "] " + ?(ЭтоНовый()," новая задача", "№" + Номер) + " - " + Тема;
	
	ОбщиеФункции.ОповеститьПоПочте(Исполнитель.Почта, ТемаПисьма, "
		|Добрый день!
		|
		|Вам назначена задача, в которой Вы являетесь исполнителем
		|		контролер задачи: " + Контроллер + "
		|
		|--------------------------
		|
		|" + ?(ТекстПисьма = "", ПреобразоватьТекстHMLВТекст(Описание), ТекстПисьма) + "
		|
		|--------------------------
		|
		|Письмо сформировано автоматически. Не нужно отвечать на данное письмо!", Ложь);
	
КонецПроцедуры
Процедура ПослатьОповещениеОПроверкеОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	ТекстПисьма = ПолучитьТекстДляПисьмаПоИзменениям();
	ТемаПисьма = "[" + Проект.Наименование + "] " + ?(ЭтоНовый()," новая задача", "№" + Номер) + " - " + Тема;
	
	ОбщиеФункции.ОповеститьПоПочте(Контроллер.Почта, ТемаПисьма, "
		|Добрый день!
		|
		|Назначеная Вами задача решена и отправлена Вам на проверку, 
		|Необходимо проверить решение задачи и установить соответствующий статус (решено? да / нет).
		|		исполнитель задачи: " + Исполнитель + "
		|
		|--------------------------
		|
		|" + ?(ТекстПисьма = "", ПреобразоватьТекстHMLВТекст(Описание), ТекстПисьма) + "
		|
		|--------------------------
		|
		|Письмо сформировано автоматически. Не нужно отвечать на данное письмо!", Ложь);
	
КонецПроцедуры
Процедура ПослатьОповещениеОЗакрытииОбработка(ТочкаМаршрутаБизнесПроцесса)
	                     
	ТекстПисьма = ПолучитьТекстДляПисьмаПоИзменениям();
	ТемаПисьма = "[" + Проект.Наименование + "] " + ?(ЭтоНовый()," новая задача", "№" + Номер) + " - " + Тема;
	                    
	ОбщиеФункции.ОповеститьПоПочте(Исполнитель.Почта, ТемаПисьма, "
		|Добрый день!
		|
		|Решенная Вами задача, проверена контролером и подтверждена что решена верна.
		|Задача закрыта!
		|		контролер задачи: " + Контроллер + "
		|
		|--------------------------
		|
		|" + ?(ТекстПисьма = "", ПреобразоватьТекстHMLВТекст(Описание), ТекстПисьма) + "
		|
		|--------------------------
		|
		|Письмо сформировано автоматически. Не нужно отвечать на данное письмо!", Ложь);
	
КонецПроцедуры
