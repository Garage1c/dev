﻿
&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	КОлПартнеров = ПохожиеПартнеры.Количество();
	
	Элементы.ПохожиеПартнеры.Видимость 	= КОлПартнеров;
	Элементы.НадписьНичегоНет.Видимость = Не КОлПартнеров;
	Элементы.Выбрать.Видимость 			= Не Партнер.Пустая();
	
КонецПроцедуры

&НаСервере
Функция стрПусто(Стр1, Стр2 = "", Стр3 = "")
	
	Стр = 	?(ПустаяСтрока(Стр1),"","%" + Стр1 + "%") +
			?(ПустаяСтрока(Стр2),"","%" + Стр2 + "%") +
			?(ПустаяСтрока(Стр3),"","%" + Стр3 + "%");
	
	Возврат СтрЗаменить(Стр,"%%","%");
	
КонецФункции
&НаСервере
Функция СострЗапрос(Текст, СуффУсловия, стрУсловие)
	
	Если ПустаяСтрока(стрУсловие) Тогда
		
		Возврат "";
		
	Иначе
		
		Возврат "
		|ОБЪЕДИНИТЬ
		|
		|" + Текст + "
		|" + СуффУсловия + """" + стрУсловие + """";
		
	КонецЕсли;
	
КонецФункции
&НаСервере
Процедура ПоискатьПодобных()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ Ссылка Партнер, МАКСИМУМ(Наименование) Наименование, МИНИМУМ(Порядок) Порядок
	|ИЗ (
	|ВЫБРАТЬ 	Партнер КАК Ссылка, Партнер.Наименование КАК Наименование, 1 Порядок
	|ИЗ 		Справочник.ПользователиИнтернет
	|ГДЕ		Ссылка = &ПользовательИнтернет И
	|			Партнер <> &ПустойПартнер
	|
	|" + СострЗапрос("ВЫБРАТЬ Партнер, Партнер.Наименование, 2 ИЗ Справочник.Контрагенты", "ГДЕ ИНН=",СокрЛП(ПользовательИнтернет.ИНН)) + "
	|" + СострЗапрос("ВЫБРАТЬ Ссылка, Наименование, 3 ИЗ Справочник.Партнеры", "ГДЕ Наименование ПОДОБНО ",стрПусто(ПользовательИнтернет.Фамилия, ПользовательИнтернет.Имя, ПользовательИнтернет.Отчество)) + "
	|" + СострЗапрос("ВЫБРАТЬ Ссылка, Наименование, 3 ИЗ Справочник.Партнеры", "ГДЕ Наименование ПОДОБНО ",стрПусто(ПользовательИнтернет.Имя, ПользовательИнтернет.Фамилия)) + "
	|" + СострЗапрос("ВЫБРАТЬ Ссылка, Наименование, 4 ИЗ Справочник.Партнеры", "ГДЕ Наименование ПОДОБНО ",стрПусто(ПользовательИнтернет.Фамилия, ПользовательИнтернет.Имя)) + "
	|" + СострЗапрос("ВЫБРАТЬ Ссылка, Наименование, 5 ИЗ Справочник.Партнеры", "ГДЕ Наименование ПОДОБНО ",стрПусто(ПользовательИнтернет.Фамилия)) + "
	|" + СострЗапрос("ВЫБРАТЬ Ссылка, Наименование, 5 ИЗ Справочник.Партнеры", "ГДЕ Наименование ПОДОБНО ",стрПусто(ПользовательИнтернет.Имя)) + "
	|" + СострЗапрос("ВЫБРАТЬ Ссылка, Наименование, 5 ИЗ Справочник.Партнеры", "ГДЕ Наименование ПОДОБНО ",стрПусто(ПользовательИнтернет.Отчество)) + "
	|) Запрос
	|СГРУППИРОВАТЬ ПО
	|	Ссылка
	|
	|УПОРЯДОЧИТЬ ПО 
	|	Порядок, Наименование
	|");
	
	Запрос.УстановитьПараметр("ПользовательИнтернет", 	ПользовательИнтернет);
	Запрос.УстановитьПараметр("ПустойПартнер", 			Справочники.Партнеры.ПустаяСсылка());
	
	ПохожиеПартнеры.Загрузить(Запрос.Выполнить().Выгрузить());//.ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПользовательИнтернет = Параметры.ПользовательИнтернет;
	
	ПоискатьПодобных();
	ОперативнаяИнформация.ДобавитьОперативнуюИнформациюОПартнере(ЭтаФорма);
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

&НаСервере
Функция СверитьПартнераИЗаписатьСвязь()
	
	Если ПользовательИнтернет.Партнер <> Партнер Тогда
		
		СпрОбъект = ПользовательИнтернет.ПолучитьОбъект();
		СпрОбъект.Партнер = Партнер;
		
		Попытка
			СпрОбъект.Записать();
		Исключение
			ОбщиеФункции.СообщитьТекст("Не удалось записать связь");
			Возврат Ложь;
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат ИСтина;
	
КонецФункции
&НаКлиенте
Процедура Выбрать(Команда)
	
	// Установим
	
	Если СверитьПартнераИЗаписатьСвязь() Тогда
	
		// Закроем
		
		Закрыть(Партнер);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КопироватьКонтактнуюИнформацию(Пользователь, Партнер)	
		
	Набор  = РегистрыСведений.ПредставлениеКонтактнойИнформации.СоздатьНаборЗаписей();
	Набор.Отбор.Объект.Установить(Партнер);	
	
	Если НЕ ПустаяСтрока(Пользователь.Адрес) Тогда
	НоваяЗапись = Набор.Добавить();	
	НоваяЗапись.Объект = Партнер;
	НоваяЗапись.Вид = Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00010"); // Адрес юридический контрагента
	НоваяЗапись.Представление = Пользователь.Адрес; КонецЕсли;

	Если НЕ ПустаяСтрока(Пользователь.КонтактныйТелефон) Тогда
	НоваяЗапись = Набор.Добавить();	
	НоваяЗапись.Объект = Партнер;
	НоваяЗапись.Вид = Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00014"); // Контактный телефон
	НоваяЗапись.Представление = Пользователь.КонтактныйТелефон; КонецЕсли;
	
	Если НЕ ПустаяСтрока(Пользователь.Телефон) И Пользователь.Телефон <> Пользователь.КонтактныйТелефон Тогда
	НоваяЗапись = Набор.Добавить();	
	НоваяЗапись.Объект = Партнер;
	НоваяЗапись.Вид = Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00005"); // Телефон контрагента
	НоваяЗапись.Представление = Пользователь.Телефон; КонецЕсли;

	Если НЕ ПустаяСтрока(Пользователь.Факс) Тогда
	НоваяЗапись = Набор.Добавить();
	НоваяЗапись.Объект = Партнер;
	НоваяЗапись.Вид = Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00037"); // Факс контрагента
	НоваяЗапись.Представление = Пользователь.Факс; КонецЕсли;

 	Если НЕ ПустаяСтрока(Пользователь.ЭлектроннаяПочта) Тогда
	НоваяЗапись = Набор.Добавить();	
	НоваяЗапись.Объект = Партнер;
	НоваяЗапись.Вид = Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00033"); // ЭлектроннаяПочта
	НоваяЗапись.Представление = Пользователь.ЭлектроннаяПочта; КонецЕсли;

	Адреса = CRM.ПолучитьАдресаДоставкиИнтернет(Пользователь);
	Если Адреса.Количество() Тогда
		АдресДоставки = Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00008"); // Физический адрес
		Индекс 	= ПланыВидовХарактеристик.СоставКонтактнойИнформации.Индекс;
		Регион 	= ПланыВидовХарактеристик.СоставКонтактнойИнформации.Регион;
		Город	= ПланыВидовХарактеристик.СоставКонтактнойИнформации.Город;
		НаселенныйПункт = ПланыВидовХарактеристик.СоставКонтактнойИнформации.НаселенныйПункт;
		Улица 	= ПланыВидовХарактеристик.СоставКонтактнойИнформации.Улица;
	КонецЕсли;
		
	Пока Адреса.Следующий() Цикл
		
		ЗначенияПолей = Новый Массив;
		
		ЗначенияПолей.Добавить(Новый Структура("Поле, Сокращение, Значение", Индекс, Индекс.Сокращение, Адреса.ПочтовыйИндекс));
		ЗначенияПолей.Добавить(Новый Структура("Поле, Сокращение, Значение", Регион, Регион.Сокращение, Адреса.Регион));
		ЗначенияПолей.Добавить(Новый Структура("Поле, Сокращение, Значение", Город, Город.Сокращение, 	Адреса.Город));
		ЗначенияПолей.Добавить(Новый Структура("Поле, Сокращение, Значение", НаселенныйПункт, НаселенныйПункт.Сокращение, Адреса.НаселенныйПункт));
		ЗначенияПолей.Добавить(Новый Структура("Поле, Сокращение, Значение", Улица, Улица.Сокращение, 	Адреса.Адрес));
				
		ПредставлениеАдресаДоставки = УправлениеКонтактнойИнформацией.ПолучитьСтроковоеПредставлениеАдресаБезСокращения(ЗначенияПолей);		
		
		Если НЕ ПустаяСтрока(ПредставлениеАдресаДоставки) Тогда
			
			ИД = Новый УникальныйИдентификатор();

			НаборЗаписей  = РегистрыСведений.КонтактнаяИнформация.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Объект.Установить(Партнер);
		    НаборЗаписей.Отбор.ID.Установить(ИД);
						
			Для Каждого Строка ИЗ ЗначенияПолей Цикл
				НоваяЗапись = НаборЗаписей.Добавить();
				НоваяЗапись.Объект 		= Партнер;
				НоваяЗапись.Вид  		= АдресДоставки; 
				НоваяЗапись.Поле 		= Строка.Поле; 
				НоваяЗапись.ID			= ИД;
			   	НоваяЗапись.Значение 	= Строка.Значение;
			КонецЦикла;
			
			Попытка
				НаборЗаписей.Записать();
			Исключение
				Сообщить("Ошибка при записи адреса доставки: " + ОписаниеОшибки());
				Возврат Ложь;
			КонецПопытки;
			
			НоваяЗапись = Набор.Добавить();	
			НоваяЗапись.Объект 	= Партнер;
			НоваяЗапись.Вид 	= АдресДоставки;
			НоваяЗапись.ID		= ИД;
			НоваяЗапись.Представление 	= ПредставлениеАдресаДоставки;
			НоваяЗапись.Комментарий 	= Адреса.Комментарий;
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		Набор.Записать();
	Исключение
		Сообщить("Ошибка при записи контактной информации: " + ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция СоздатьНовогоПартнераКонтрагентаЗаписатьИВернуть()
	
	НовПартнер = Справочники.Партнеры.СоздатьЭлемент();
	НовПартнер.Наименование 	= ПользовательИнтернет.Наименование;
	НовПартнер.НаименованиеПолное = ПользовательИнтернет.Наименование;
	НовПартнер.Комментарий 		= "создан автоматически из интернет пользователя";
	//НовПартнер.ТипЦен 			= ПользовательИнтернет.ТипЦен;
	НовПартнер.ТипЦен 			= КэшируемыеФункции.ПолучитьТипЦенРозница();
	//НовПартнер.ОсновнойМенеджер	= ПараметрыСеанса.ТекущийПользователь;
	НовПартнер.ОсновнойМенеджер = ОбщиеФункции.НастройкаПользователя("ПоУмолчанию_ОсновнойМенеджер");
	НовПартнер.Клиент = Истина;
	НовПартнер.Родитель = Справочники.Партнеры.НайтиПоКоду("000011101");
	НовПартнер.ОткудаПришел = Справочники.ОткудаПришел.НайтиПоНаименованию("Сайт");
	НовПартнер.Категория = Справочники.КатегорииПартнеров.ФизическоеЛицо;

	НачатьТранзакцию();
	
	Попытка
		НовПартнер.Записать();
	Исключение
		ОтменитьТранзакцию();
		Возврат Ложь;
	КонецПопытки;
	
		
	НовКонтрагент = Справочники.Контрагенты.СоздатьЭлемент();
	НовКонтрагент.Наименование = ПользовательИнтернет.Наименование;
	НовКонтрагент.НаименованиеПолное 	= ПользовательИнтернет.Наименование;
	//НовКонтрагент.ЮрФизЛицо 			= ПользовательИнтернет.ЮрФизЛицо;
	НовКонтрагент.ЮрФизЛицо    			= Перечисления.ЮрФизЛицо.ФизЛицо;
	НовКонтрагент.ИНН		 			= ПользовательИнтернет.ИНН;
	НовКонтрагент.КПП 					= ПользовательИнтернет.КПП;
	НовКонтрагент.Партнер		 		= НовПартнер.Ссылка;
	//НовКонтрагент.ТипЦен 				= ПользовательИнтернет.ТипЦен;
	НовКонтрагент.ТипЦен 				= КэшируемыеФункции.ПолучитьТипЦенРозница();
	НовКонтрагент.Комментарий		 	= "создан автоматически из интернет пользователя";
	
	Попытка
		НовКонтрагент.Записать();
	Исключение
		ОтменитьТранзакцию();
		Возврат Ложь;
	КонецПопытки;
	
	Если НЕ КопироватьКонтактнуюИнформацию(ПользовательИнтернет, НовКонтрагент.Ссылка) Тогда     //раньше создавали на партнера
		
	  	ОтменитьТранзакцию();
		Возврат Ложь;
	КонецЕсли;

	
	ЗафиксироватьТранзакцию();
	
	Партнер = НовПартнер.Ссылка;
	
	Возврат ИСтина;
	
КонецФункции
&НаКлиенте
Процедура НовыйПартнер(Команда)
	
	Если СоздатьНовогоПартнераКонтрагентаЗаписатьИВернуть() Тогда
		
		ПоискатьПодобных();
		УправлениеВидимостьюДоступностью();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПохожиеПартнерыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ПохожиеПартнеры.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		Партнер = ТекущиеДанные.Партнер;
		ОбработатьОтображениеИнфОПартнере();
	КонецЕсли;
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

#Область ОперативнаяИнформацияОПартнере 

&НаСервере
Процедура ОбработатьОтображениеИнфОПартнере() Экспорт
	ОперативнаяИнформация.ОбработатьОтображениеИнфОПартнере(ЭтаФорма, "ПохожиеПартнеры", "ПохожиеПартнеры", Партнер);//?(Партнер <> Неопределено, Партнер, ПохожиеПартнеры.Получить(Элементы.ПохожиеПартнеры.ТекущаяСтрока).Значение ));
КонецПроцедуры
&НаКлиенте
Процедура ИнфТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	ОперативнаяИнформацияКлиент.ИнфТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка,, Партнер);
КонецПроцедуры
 &НаКлиенте
Процедура ПоказатьСкрытьИнформацию(Команда)
	Если НЕ Партнер.Пустая() Тогда
		ОперативнаяИнформацияКлиент.ПоказатьСкрытьИнформацию(ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


 