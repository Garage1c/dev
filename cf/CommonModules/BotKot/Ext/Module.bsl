﻿Функция Ключ() Экспорт 		Возврат "204144897:AAHqE3GisnL9Gzv-RnPLAozL0EP1BDp1A4I" КонецФункции
Функция Сервер() Экспорт 	Возврат "api.telegram.org" КонецФункции

Функция СообщитьКоту(idUser, ТекстСообщения) Экспорт
	
	Ресурс 		= "bot" + Ключ() + "/sendMessage?chat_id=" + idUser + "&text=" + ТекстСообщения;
	Соединение  =  Новый HTTPСоединение(Сервер(), 443,,,,,Новый ЗащищенноеСоединениеOpenSSL());
	ЗапросHTTP 	= Новый HTTPЗапрос(Ресурс);
	Ответ 		= Соединение.Получить(ЗапросHTTP);
	
	Возврат Ответ.КодСостояния = 200;
				
КонецФункции

Функция СформироватьСообщение(ВходящееСообщение, ИсходящееСообщение, Алгоритм, стрОшибки = "")
	
	Попытка		Выполнить(Алгоритм);
	Исключение
		стрОшибки = "Ошибка выполняения алгоритма - " + ОписаниеОшибки();
		Возврат Ложь; КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ПоследнииСообщенияПользователя(idUser, Первые = 0)
	
	// Возвращает массив последних сообщений пользователя
	
	//Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 ИЗ РегистрСведений.
	
	
КонецФункции

Функция ПолучитьПользователя(idUser)
	
	Запрос 	= Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.Пользователи ГДЕ idДиалогаТелеграм = """ + idUser + """");
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка КонецЕсли;
	
КонецФункции
Функция ВыполнитьПравилоКота(СтруктураСообщения, Алгоритм, ИсходящееСообщение, стрОшибки = "")
	
	Если ПустаяСтрока(Алгоритм) И Не ПустаяСтрока(ИсходящееСообщение) Тогда
		
		Возврат Истина;
		
	ИначеЕсли ПустаяСтрока(Алгоритм) И ПустаяСтрока(ИсходящееСообщение) Тогда
		
		стрОшибки = "Человек ты глупый
		|Ни алгоритм ни Исходящее сообщение не заполнено";
		Возврат Ложь;
		
	Иначе
	
		Отказ = Ложь;
		
		Попытка		Выполнить Алгоритм;
		Исключение	стрОшибки = "Человек ты глупый
								|" + ОписаниеОшибки();
					Возврат Ложь; КонецПопытки;
		
		Возврат Не Отказ; КонецЕсли;
	
КонецФункции
Функция ПолученоВходящееСообщение(ЗапросHTTP, стрОшибки = "") Экспорт
	
	текJSONСообщения = ЗапросHTTP.ПолучитьТелоКакСтроку();
	
	// преобразуем в структуру
			
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(текJSONСообщения);
	Структура = ПрочитатьJSON(Чтение);
	Чтение.Закрыть();
	
	Если Структура.Свойство("message") Тогда
		
		// Заполним параметрами
		
		СтруктураСообщения = Новый Структура;
		
		Если Структура.message.Свойство("from") И Структура.message.from.Свойство("id") Тогда
			idUser = Формат(Структура.message.from.id, "ЧГ=");
			СтруктураСообщения.Вставить("Пользователь", ПолучитьПользователя(idUser)) КонецЕсли;
		
		Если Структура.message.Свойство("text") Тогда
			СтруктураСообщения.Вставить("Текст", Структура.message.text) КонецЕсли;
			
		Если Структура.message.Свойство("date") Тогда
			СтруктураСообщения.Вставить("Дата", МестноеВремя(Дата('19700101') + Структура.message.date)) КонецЕсли;
		
		// Найдем ответ из справочника
		
		Если СтруктураСообщения.Свойство("Текст") И Не ПустаяСтрока(СтруктураСообщения.Текст) Тогда
		
			Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 ИсходящееСообщение, Алгоритм ИЗ Справочник.BotKotОбработкаСообщений ГДЕ НЕ ПометкаУдаления И ВходящееСообщение ПОДОБНО """ + СтруктураСообщения.Текст + """");
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				
				// Если есть алгоритм выполняем сперва его, а затем полученное исходящее сообщение
				
				ИсходящееСообщение = Выборка.ИсходящееСообщение; // защита переменной
				
				стрОшибки = "";
				Если ВыполнитьПравилоКота(СтруктураСообщения, Выборка.Алгоритм, ИсходящееСообщение, стрОшибки) Тогда
					СообщитьКоту(idUser, ИсходящееСообщение); 
				Иначе
					СообщитьКоту(idUser, стрОшибки); КонецЕсли; 
				
			Иначе // выполним полнотекстовый поиск
				
				СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтруктураСообщения.Текст, 1);
				//СписокПоиска.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.HTMLТекст);
				Если СписокПоиска.Количество() Тогда
					Эл = СписокПоиска.Получить(0);
					СообщитьКоту(idUser, Строка(Эл.Значение) + " " + Эл.Описание + " " + Эл.Представление); КонецЕсли; КонецЕсли; КонецЕсли; КонецЕсли;
	
	Возврат Истина;
	
КонецФункции