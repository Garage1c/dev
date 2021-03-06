﻿// Неинтерактивное обновление данных ИБ при смене версии библиотеки
// Обязательная "точка входа" обновления ИБ в библиотеке.
Процедура ВыполнитьОбновлениеИнформационнойБазы() Экспорт
	
	//ОбновлениеИнформационнойБазы.ВыполнитьИтерациюОбновления("СтандартныеПодсистемы", ВерсияБиблиотеки(), 
	//	ОбработчикиОбновления());
	
КонецПроцедуры

// Возвращает номер версии Библиотеки стандартных подсистем.
//
Функция ВерсияБиблиотеки() Экспорт
	
	Возврат "1.0.4.5";
	
КонецФункции

// Возвращает список процедур-обработчиков обновления библиотеки
//
// Возвращаемое значение:
//   Структура - описание полей структуры см. в функции
//               ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления() 
Функция ОбработчикиОбновления()
	
	//Обработчики = ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления();
	//
	//// Подключаются процедуры-обработчики обновления библиотеки
	//
	//// РаботаСПочтовымиСообщениями
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.0.0";
	//Обработчик.Процедура = "ЭлектроннаяПочта.ЗаполнитьСистемнуюУчетнуюЗапись";
	//// Конец РаботаСПочтовымиСообщениями
	//
	//// КонтактнаяИнформация
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.1.1";
	//Обработчик.Процедура = "УправлениеКонтактнойИнформациейПереопределяемый.КонтактнаяИнформацияОбновлениеИБ";
	//
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.1.3";
	//Обработчик.Процедура = "УправлениеКонтактнойИнформацией.ЗагрузитьСтраныМира";
	//// Конец КонтактнаяИнформация
	//
	//// АдресныйКлассификатор
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.1.1";
	//Обработчик.Процедура = "АдресныйКлассификатор.ЗагрузитьАдресныеОбъектыПервогоУровня";
	//// Конец АдресныйКлассификатор
	//
	//// БизнесПроцессыИЗадачи
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.2.2";
	//Обработчик.Процедура = "БизнесПроцессыИЗадачиСервер.ОбновлениеИнформационнойБазы";
	//// Конец БизнесПроцессыИЗадачи
	//
	//// ПолнотекстовыйПоиск
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.3.10";
	//Обработчик.Процедура = "ПолнотекстовыйПоискСервер.ИнициализироватьФункциональнуюОпциюПолнотекстовыйПоиск";
	//// Конец ПолнотекстовыйПоиск
	//
	//// ПолучениеФайловИзИнтернет
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "1.0.4.1";
	//Обработчик.Процедура = "ПолучениеФайловИзИнтернет.ОбновлениеХранимыхНастроекПрокси";
	//// Конец ПолучениеФайловИзИнтернет
	//
	//// ВерсионированиеОбъектов
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "*";
	//Обработчик.Процедура = "ВерсионированиеОбъектовПолныеПрава.ОчиститьНеиспользуемыеНастройкиВерсионирования";
	//// Конец ВерсионированиеОбъектов
	//
	//Возврат Обработчики;
	
КонецФункции

// Возвращает структуру параметров, необходимых для инициализации
// конфигурации на клиенте.
// 
Функция ПараметрыРаботыКлиента() Экспорт
	
	Параметры = Новый Структура();
	
	// СтандартныеПодсистемы
	Параметры.Вставить("ИнформационнаяБазаЗаблокированаДляОбновления", 
		//ОбновлениеИнформационнойБазы.ПроверитьНевозможностьОбновленияИнформационнойБазы());
		// silber {
		Ложь);
		// } silber
	Параметры.Вставить("НеобходимоОбновлениеИнформационнойБазы", 
		//ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы());
		// silber {
		Ложь);
		// } silber
	Параметры.Вставить("ТекущийПользователь", Строка(ПараметрыСеанса.ТекущийПользователь));
	//Параметры.Вставить("ЗаголовокПриложения", СокрЛП(Константы.ЗаголовокСистемы.Получить()));
	Параметры.Вставить("ЗаголовокПриложения", "Garage");
	//Параметры.Вставить("ПараметрыБлокировкиСеансов", СоединенияИБ.ПараметрыБлокировкиСеансов());
	Параметры.Вставить("ИнформационнаяБазаФайловая", ОбщегоНазначения.ИнформационнаяБазаФайловая());	
	// Конец СтандартныеПодсистемы
	
	// РегламентныеЗадания
	Параметры.Вставить("ПараметрыОткрытияСеансаОбработкиРегламентныхЗаданий", 
		РегламентныеЗаданияПолныеПрава.ПараметрыОткрытияСеансаОбработкиРегламентныхЗаданий(Истина));
	// Конец РегламентныеЗадания
	
	// РаботаСФайлами  silber { закомментарил что ниже }
	//Параметры.Вставить("ПерсональныеНастройкиРаботыСФайлами", 
	//	РаботаСФайлами.ПолучитьПерсональныеНастройкиРаботыСФайламиСервер());
	// Конец РаботаСФайлами
	
	// Для установки параметров инициализации системы можно использовать шаблон:
	//
	// Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
	//

	Возврат Параметры;
	
КонецФункции	