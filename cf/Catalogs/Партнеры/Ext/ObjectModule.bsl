﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
    НастройкаОсновнойМенеджер = КэшируемыеФункции.ПолучитьЗначениеЗначениеНастройкиПользователя("ПоУмолчанию_ОсновнойМенеджер");
	
	ОсновнойМенеджер = ?(ЗначениеЗаполнено(НастройкаОсновнойМенеджер) ,НастройкаОсновнойМенеджер,ПараметрыСеанса.ТекущийПользователь);
	ДатаРегистрации = ТекущаяДата();

	// Выполним заполнение контактной информации
	//УправлениеКонтактнойИнформацией.ОбработкаЗаполненияКИ(ЭтотОбъект, ДанныеЗаполнения);

	//Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
	//   И ДанныеЗаполнения.Свойство("Наименование") Тогда

	//		//создание из взаимодействия по описанию участника
	//		Наименование = ДанныеЗаполнения.Наименование;
	//КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события "ПриКопировании".
//
Процедура ПриКопировании(ОбъектКопирования)

	ОсновнойМенеджер = ПараметрыСеанса.ТекущийПользователь;
	ДатаРегистрации = ТекущаяДата();

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если Не ЭтоГруппа И КаналыПродаж.Количество() Тогда	
		
		ВТ = КаналыПродаж.Выгрузить();
		ВТ.Сортировать("Оценка Убыв");
		ОсновнойКаналПродаж = ВТ[0].КаналПродаж;
	КонецЕсли;
	
	Если ОсновнойМенеджер <> Ссылка.ОсновнойМенеджер Тогда
		ДополнительныеСвойства.Вставить("ИзменениеМенеджера", Истина);
		ДополнительныеСвойства.Вставить("ИзменененныеМенеджеры", Новый Структура("НовыйМенеджер, СтарыйМенеджер", ОсновнойМенеджер, Ссылка.ОсновнойМенеджер));
	КонецЕсли;

	
	Если Не ЭтоГруппа И Не ЭтоНовый() Тогда УправлениеКонтактнойИнформацией.ПередЗаписью(Ссылка, НЕ Ссылка.ПометкаУдаления И ПометкаУдаления, Отказ) КонецЕсли;
	
	// запишем когда создан
	
	Если Не ЭтоГруппа И ЭтоНовый() Тогда ДатаСоздания = ТекущаяДата() КонецЕсли;
	Если Автор.Пустая() И ЭтоНовый() Тогда Автор = ПараметрыСеанса.ТекущийПользователь; КонецЕсли;
	
	// Проверим чтобы номер клиента был не занят кем либо еще
	
	Если Не ПустаяСтрока(НомерКлиента) Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.Партнеры ГДЕ Ссылка <> &Ссылка И НомерКлиента = """ + НомерКлиента + """");
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			
			Отказ = Истина;
			ОбщиеФункции.СообщитьТекст(НСтр("ru='Точно такой же номер клиента уже существует партнера: '; de='Genau die gleiche Kundennummer existiert bereits Partner'") + Выборка.Ссылка); КонецЕсли; КонецЕсли;
			
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ИзменениеМенеджера = Ложь;	
	Если ДополнительныеСвойства.Свойство("ИзменениеМенеджера", ИзменениеМенеджера) И ИзменениеМенеджера Тогда
		
		Мен = РегистрыСведений.ОсновнойМенеджерПартнера.СоздатьМенеджерЗаписи();
		Мен.Период 		= ТекущаяДата();
		Мен.Партнер 	= Ссылка;
		Мен.Менеджер 	= ОсновнойМенеджер;
		
		Если ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Мен) Тогда
			
			Параметры = ДополнительныеСвойства.ИзменененныеМенеджеры;
			
			События.ЗарегистрироватьСобытие(
					"НазначенОсновнойМенеджер",	// Зарегистрируем событие в системе оповещение
					Новый Структура("Ссылка, Инициатор, Название, КраткоеОписание, Параметры",
								Ссылка, Ссылка, "Назначен основной менеджер",
								//"(" + Код + ") " + Наименование + ", назначен основным менеджером - " + ОсновнойМенеджер,
								"Партнер: (" + Код + ") " + Наименование + ?(ОсновнойРегион.Пустая(),"", " - " + ОсновнойРегион) + ", изменился основной менеджер." +
								?(ЗначениеЗаполнено(Параметры.СтарыйМенеджер), "
								|был:	" + Параметры.СтарыйМенеджер + "
								|стал:	" + Параметры.НовыйМенеджер, "
								|назначен: " + Параметры.НовыйМенеджер),
								Параметры), 
					ЭтотОбъект);
		Иначе
			Сообщить("Не удалось записать основного менеджера в регистр сведений. " + ОписаниеОшибки());
			Отказ = Истина; КонецЕсли; КонецЕсли;
	
КонецПроцедуры
