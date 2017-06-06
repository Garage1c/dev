﻿
Функция ПолучитьТекстВыраженияВЗапросе(Значение1с, стрОшибки = "") Экспорт
	
	типЗнч = ТипЗнч(Значение1с);
		
	Если типЗнч = Тип("Строка") Тогда
		
		Возврат "'" + СтрЗаменить(Значение1с,"'","''") + "'";
		
	ИначеЕсли типЗнч = Тип("Число") Тогда
		
		Возврат """" + Формат(Значение1с,"ЧГ=0") + """";
		
	ИначеЕсли типЗнч = Тип("Булево") Тогда
		
		Возврат ?(Значение1с, "TRUE","FALSE");
		
	ИначеЕсли 	типЗнч = Тип("Дата") Или
				типЗнч = Тип("ДатаВремя") Тогда
		
		Возврат Формат(Значение1с,"ДФ = ""ггггММддччммсс""");
			
	Иначе
			
		стрОшибки = "не могу представить тип в MySQL " + ТипЗнч;
		Возврат Ложь;
			
	КонецЕсли;
	
КонецФункции

Функция ЗагрузитьТаблицуДанных(СоединениеADO, ИмяТаблицы, КолонкиТаблицы, ТаблицаДанных) Экспорт
	
	//Command2 = Новый COMОбъект("ADODB.Command");
	//Command2.ActiveConnection = Connection;
	//
	//Command2.CommandText = "SET NAMES cp1251";
	//RecordSet2 = Новый COMОбъект("ADODB.RecordSet");
	//RecordSet2 = Command2.Execute();
    
    Command = Новый COMОбъект("ADODB.Command");
    Command.ActiveConnection = СоединениеADO;
	
	Command.CommandText = "Select * From " + ИмяТаблицы;
    Command.CommandType = 1;
	
    RecordSet = Новый COMОбъект("ADODB.RecordSet");
    RecordSet = Command.Execute();
	
    НомерСтроки = 1;
	Пока Не RecordSet.EOF Цикл
		
		Для КАждого Колонка Из КолонкиТаблицы Цикл
				
			новСтрока = ТаблицаДанных.Добавить();
			ЗаполнитьЗначенияСвойств(новСтрока, RecordSet);
				
			новСтрока.ТекстВЯчейке = RecordSet.Fields(Колонка.ИмяКолонки).Value;
				
		КонецЦикла;
		
        RecordSet.MoveNext();
		
	КонецЦикла;      
	
    Возврат ТаблицаДанных;
	
КонецФункции

Функция ПолучитьСтруктуруСложнойКолонки(ИмяКолонки) Экспорт
	
	Параметры = КонвертацияТипов.ПолучитьМассивИзСтроки(ИмяКолонки, ".");
	
	Возврат Новый Структура("
	|ИмяПоляОсновнойТаблицы, 
	|ИмяДополнительнойТаблицы, 
	|ИмяКлючаДополнительнойТаблицы,
	|ИмяПоляДополнительнойТаблицы
	|",	Параметры[0], Параметры[1], Параметры[2], Параметры[3]);
				
	
КонецФункции

Функция ПолучитьТаблицу(СоединениеADO, СтруктураПравил, стрОшибки = "") Экспорт
	
	// Создадим текст запроса
	
	Таблица 			= Новый ТаблицаЗначений;
	текстОтбораMySQL 	= "";
	ТекстПолей 			= "";
	ТекстПолейБезАлисов = "";
	ИмяПсевдОснТаблицы	= "OsnTabl";
	
	ТекДопТаблиц		= "";
	НомПодклТаблицы		= 0;
	
	ИменаКолонок = Новый Массив;
	
	Для КАждого Колонка Из СтруктураПравил.ЗагружаемыеСтроки Цикл
		Если Не ПустаяСтрока(Колонка.ИмяКолонки) Тогда
			
			КолТочек = СтрЧислоВхождений(Колонка.ИмяКолонки,".");
			
			Если КолТочек = 3 Тогда НомПодклТаблицы = НомПодклТаблицы + 1;
				
				// Сложная колонка
				
				СтруктураКолонки = ПолучитьСтруктуруСложнойКолонки(Колонка.ИмяКолонки);
				
				ИмяПсевдТаблицы = "DopTabl" + Формат(НомПодклТаблицы,"ЧГ=0");
				
				ТекДопТаблиц = ТекДопТаблиц + "
				|LEFT JOIN
				|	" + СтруктураКолонки.ИмяДополнительнойТаблицы + " AS " + ИмяПсевдТаблицы + "
				|ON
				|	" + ИмяПсевдОснТаблицы + "." + СтруктураКолонки.ИмяПоляОсновнойТаблицы + " = " + ИмяПсевдТаблицы + "." + СтруктураКолонки.ИмяКлючаДополнительнойТаблицы + "
				|";
				
				// Основная таблица
				ТекстПолей 			= ТекстПолей + ?(ТекстПолей = "","",", " + Символы.ПС) + ИмяПсевдОснТаблицы + "." + СтруктураКолонки.ИмяПоляОсновнойТаблицы + " AS " + СтруктураКолонки.ИмяПоляОсновнойТаблицы;
				ТекстПолейБезАлисов = ТекстПолейБезАлисов + ?(ТекстПолейБезАлисов = "","",", " + Символы.ПС) + ИмяПсевдОснТаблицы + "." + СтруктураКолонки.ИмяПоляОсновнойТаблицы;
				текстОтбораMySQL	= текстОтбораMySQL + ?(текстОтбораMySQL = "",""," AND " + Символы.ПС) + " NOT " + ИмяПсевдОснТаблицы   + "." + СтруктураКолонки.ИмяПоляОсновнойТаблицы + " IS NULL";
				
				Таблица.Колонки.Добавить(СтруктураКолонки.ИмяПоляОсновнойТаблицы, КэшируемыеФункции.ПолучитьОписаниеТипаОбъектаИзСтрокиТипа(Колонка.ТипОбъекта));
				ИменаКолонок.Добавить(СтруктураКолонки.ИмяПоляОсновнойТаблицы);
				
				// Добавочная таблица
				ТекстПолей 			= ТекстПолей + ?(ТекстПолей = "","",", " + Символы.ПС) + ИмяПсевдТаблицы + "." + СтруктураКолонки.ИмяПоляДополнительнойТаблицы + " AS " + СтруктураКолонки.ИмяПоляДополнительнойТаблицы;
				ТекстПолейБезАлисов = ТекстПолейБезАлисов + ?(ТекстПолейБезАлисов = "","",", " + Символы.ПС) + ИмяПсевдТаблицы + "." + СтруктураКолонки.ИмяПоляДополнительнойТаблицы;
				текстОтбораMySQL	= текстОтбораMySQL + ?(текстОтбораMySQL = "",""," AND " + Символы.ПС) + " NOT " + ИмяПсевдТаблицы  + "." + СтруктураКолонки.ИмяПоляДополнительнойТаблицы + " IS NULL";
				
				Таблица.Колонки.Добавить(СтруктураКолонки.ИмяПоляДополнительнойТаблицы, КэшируемыеФункции.ПолучитьОписаниеТипаОбъектаИзСтрокиТипа(Колонка.ТипОбъекта2));
				ИменаКолонок.Добавить(СтруктураКолонки.ИмяПоляДополнительнойТаблицы);
							
			ИначеЕсли Не КолТочек Тогда
				
				// Простая колонка
				
				ТекстПолей 			= ТекстПолей + ?(ТекстПолей = "","",", " + Символы.ПС) + ИмяПсевдОснТаблицы + "." + Колонка.ИмяКолонки + " AS " + Колонка.ИмяКолонки;
				ТекстПолейБезАлисов = ТекстПолейБезАлисов + ?(ТекстПолейБезАлисов = "","",", " + Символы.ПС) + ИмяПсевдОснТаблицы + "." + Колонка.ИмяКолонки;
				текстОтбораMySQL	= текстОтбораMySQL + ?(текстОтбораMySQL = "",""," AND " + Символы.ПС) + " NOT " + ИмяПсевдОснТаблицы + "." + Колонка.ИмяКолонки + " IS NULL";
				
				Таблица.Колонки.Добавить(Колонка.ИмяКолонки, КэшируемыеФункции.ПолучитьОписаниеТипаОбъектаИзСтрокиТипа(Колонка.ТипОбъекта));
				ИменаКолонок.Добавить(Колонка.ИмяКолонки);
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Сформируем текст отборов MySQL
		
	Для Каждого Строка Из СтруктураПравил.ОтборыMySQL Цикл
		
		ТекстMySQL = ПолучитьТекстВыраженияВЗапросе(Строка.Значение, стрОшибки);
		Если ТекстMySQL = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
		текстОтбораMySQL = текстОтбораMySQL + ?(текстОтбораMySQL = "",""," AND ") + Строка.ИмяПоля + " " + КэшируемыеФункции.ОпределитьТекстУсловияОтбораПостроке(Строка.ВидСравнения) + " " + ТекстMySQL;
		
	КонецЦикла;
		
	// Создадим объекты запроса
	
	Command = Новый COMОбъект("ADODB.Command");
    Command.ActiveConnection = СоединениеADO;
	
	Command.CommandText = "
	|SELECT
	|"	+ ТекстПолей + " 
	|FROM
	|"	+ СтруктураПравил.ИмяТаблицы + " AS " + ИмяПсевдОснТаблицы + "
	|" 	+ ТекДопТаблиц + "
	|" 	+ ?(текстОтбораMySQL = "","","
	|WHERE 
	|" 	+ текстОтбораMySQL) + "
	|GROUP BY
	|" + ТекстПолейБезАлисов + " 
	|";
	
	Command.CommandType = 1;
	
    RecordSet = Новый COMОбъект("ADODB.RecordSet");
	Попытка
    	RecordSet = Command.Execute();
	Исключение
		опОшибки = ОписаниеОшибки();
		стрОшибки = "Ошибка при выполнении запроса MYSQL
					|" + опОшибки;
		Возврат Неопределено;
	КонецПопытки;
	
	// Заполним запрос
	
	Пока Не RecordSet.EOF Цикл
		
		новСтрока = Таблица.Добавить();
		
		Для КАждого Колонка Из ИменаКолонок Цикл
			новСтрока[Колонка] = RecordSet.Fields(Колонка).Value;
		КонецЦикла;
		
        RecordSet.MoveNext();
		
	КонецЦикла;      
	
    Возврат Таблица;
	
КонецФункции


Функция ОбновитьДанные(СоединениеADO, ИмяТаблицы, Данныеобновления, ОтборыДанных = Неопределено, стрОшибки = "") Экспорт
	
	// Данныеобновления - Таблица, 
	//				- ИмяПоля - строка поля MySQL
	//				- Значение - устанавливоемое значение поля MySQL
	//
	// ОтборыДанных 	- Таблица
	//				- ИмяПоля - строка поля MySQL
	//				- Значение - фильтруемое поле MySQL
	
	текстПолей 		= "";
	текстОтборов 	= "";
	
	// Сформируем поля
	
	Для Каждого Строка Из Данныеобновления Цикл
		
		текстMySQL = ПолучитьТекстВыраженияВЗапросе(Строка.Значение);
		
		Если текстMySQL = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
		текстПолей = текстПолей + ?(текстПолей = "","",", ") + Строка.ИмяПоля + " = " + текстMySQL;
		
	КонецЦикла;
	
	// Сформируем условия
	
	Если ОтборыДанных <> Неопределено Тогда
		Для Каждого Строка Из ОтборыДанных Цикл
			
			текстMySQL = ПолучитьТекстВыраженияВЗапросе(Строка.Значение);
			
			Если текстMySQL = Неопределено Тогда
				Возврат Ложь;
			КонецЕсли;
			
			текстОтборов = текстОтборов + ?(текстОтборов = "","",", ") + Строка.ИмяПоля + " = " + текстMySQL;
			
		КонецЦикла;
	КонецЕсли;
	
	// Пошлем команду
	
	Command = Новый COMОбъект("ADODB.Command");
    Command.ActiveConnection = СоединениеADO;
	
	Command.CommandText = "UPDATE " + ИмяТаблицы + " SET " + ТекстПолей + " WHERE " + текстОтборов;
    Command.CommandType = 1;
	
    RecordSet = Новый COMОбъект("ADODB.RecordSet");
	Попытка
    	RecordSet = Command.Execute();
	Исключение
		опОшибки = ОписаниеОшибки();
		стрОшибки = "Ошибка при обновлении запроса MYSQL
					|" + опОшибки;
		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;
	
КонецФункции
Функция ВставитьДанные(СоединениеADO, ИмяТаблицы, Данныеобновления, стрОшибки = "") Экспорт
	
	// Данныеобновления - Таблица, 
	//				- ИмяПоля - строка поля MySQL
	//				- Значение - устанавливоемое значение поля MySQL
	
	ТекстИменПолей 		= "";
	ТекстЗначенийПолей 	= "";
	
	// Сформируем поля
	
	Для Каждого Строка Из Данныеобновления Цикл
		
		текстMySQL = ПолучитьТекстВыраженияВЗапросе(Строка.Значение);
		
		Если текстMySQL = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ТекстИменПолей 		= ТекстИменПолей + ?(ТекстИменПолей = "","",",") + Строка.ИмяПоля;
		ТекстЗначенийПолей 	= ТекстЗначенийПолей + ?(ТекстЗначенийПолей = "","",",") + текстMySQL;
		
	КонецЦикла;
	
	// Пошлем команду
	
	Command = Новый COMОбъект("ADODB.Command");
    Command.ActiveConnection = СоединениеADO;
	
	Command.CommandText = "INSERT INTO " + ИмяТаблицы + " (" + ТекстИменПолей + ") VALUES(" + ТекстЗначенийПолей + ")";
    Command.CommandType = 1;
	
    RecordSet = Новый COMОбъект("ADODB.RecordSet");
	Попытка
    	RecordSet = Command.Execute();
	Исключение
		опОшибки = ОписаниеОшибки();
		стрОшибки = "Ошибка при вставке данных MySQL
					|" + опОшибки;
		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;
	
КонецФункции
Функция УдалитьДанные(СоединениеADO, ИмяТаблицы, Данныеобновления, стрОшибки = "") Экспорт
	
	// Данныеобновления - Таблица, 
	//				- ИмяПоля - строка поля MySQL
	//				- Значение - устанавливоемое значение поля MySQL
	
	текстПолей 		= "";
	текстОтборов 	= "";
	
	// Сформируем поля
	
	Для Каждого Строка Из Данныеобновления Цикл
		
		текстMySQL = ПолучитьТекстВыраженияВЗапросе(Строка.Значение);
		
		Если текстMySQL = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
		текстПолей = текстПолей + ?(текстПолей = "",""," AND ") + Строка.ИмяПоля + " = " + текстMySQL;
		
	КонецЦикла;
	
	// Пошлем команду
	
	Command = Новый COMОбъект("ADODB.Command");
    Command.ActiveConnection = СоединениеADO;
	
	Command.CommandText = "DELETE FROM " + ИмяТаблицы + " WHERE " + ТекстПолей;
    Command.CommandType = 1;
	
    RecordSet = Новый COMОбъект("ADODB.RecordSet");
	Попытка
    	RecordSet = Command.Execute();
	Исключение
		опОшибки = ОписаниеОшибки();
		стрОшибки = "Ошибка при удалении данных MySQL
					|" + опОшибки;
		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;
	
КонецФункции
