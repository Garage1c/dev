﻿
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ОбменДанными.Загрузка Тогда
		УправлениеКонтактнойИнформацией.ПередЗаписью(Ссылка, НЕ Ссылка.ПометкаУдаления И ПометкаУдаления, Отказ);
	КонецЕсли;	
	
	// пока так
	//стОсновнаяОрганизация = ОсновнаяОрганизацияКонтрагента(Ссылка);
	//Для Каждого Строка Из Организации Цикл
	//	Если Строка.ЗначениеПоУмолчанию Тогда
	//		ОсновнаяОрганизация = Строка.Организация;
	//		Прервать;
	//	КонецЕсли;
	//КонецЦикла;
	//Если стОсновнаяОрганизация <> ОсновнаяОрганизация Тогда
	
	Если ОсновнойМенеджер <> Ссылка.ОсновнойМенеджер Тогда
		ДополнительныеСвойства.Вставить("ИзменениеМенеджера", Истина);
		ДополнительныеСвойства.Вставить("ИзменененныеМенеджеры", Новый Структура("НовыйМенеджер, СтарыйМенеджер", ОсновнойМенеджер, Ссылка.ОсновнойМенеджер));
	КонецЕсли;
	
	Если Не ЭтоГруппа И ЭтоНовый() Тогда 
		ДатаСоздания = ТекущаяДата() 
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если НЕ ОбменДанными.Загрузка Тогда
		// Проверим чтобы номер договора был уникальным
		
		Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.Контрагенты.Организации ГДЕ Ссылка <> &Ссылка И НомерДоговора В(ВЫБРАТЬ НомерДоговора ИЗ Справочник.Контрагенты.Организации ГДЕ Ссылка = &Ссылка И НомерДоговора <> """")");
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ОбщиеФункции.СообщитьТекст("Такой номер договора не уникален и принадлежит другому контрагенту - " + Выборка.Ссылка);
			Отказ = Истина;
		КонецЕсли;
		
		
		ИзменениеМенеджера = Ложь;	
		Если ДополнительныеСвойства.Свойство("ИзменениеМенеджера", ИзменениеМенеджера) И ИзменениеМенеджера Тогда
			
			Мен = РегистрыСведений.ОсновнойМенеджерПартнера.СоздатьМенеджерЗаписи();
			Мен.Период 		= ТекущаяДата();
			Мен.Контрагент 	= Ссылка;
			Мен.Менеджер 	= ОсновнойМенеджер;
			
			Если ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Мен) Тогда
				
				Параметры = ДополнительныеСвойства.ИзменененныеМенеджеры;
				
				События.ЗарегистрироватьСобытие(
				"НазначенОсновнойМенеджер",	// Зарегистрируем событие в системе оповещение
				Новый Структура("Ссылка, Инициатор, Название, КраткоеОписание, Параметры",
				Ссылка, Ссылка, "Назначен основной менеджер",
				//"(" + Код + ") " + Наименование + ", назначен основным менеджером - " + ОсновнойМенеджер,
				"Контрагент: (" + Код + ") " + Наименование + ?(ОсновнойРегион.Пустая(),"", " - " + ОсновнойРегион) + ", изменился основной менеджер." +
				?(ЗначениеЗаполнено(Параметры.СтарыйМенеджер), "
				|был:	" + Параметры.СтарыйМенеджер + "
				|стал:	" + Параметры.НовыйМенеджер, "
				|назначен: " + Параметры.НовыйМенеджер),
				Параметры), 
				ЭтотОбъект);
			Иначе
				Сообщить("Не удалось записать основного менеджера в регистр сведений. " + ОписаниеОшибки());
				Отказ = Истина; 
			КонецЕсли; 
		КонецЕсли;
		
		
	КонецЕсли;
	
КонецПроцедуры
