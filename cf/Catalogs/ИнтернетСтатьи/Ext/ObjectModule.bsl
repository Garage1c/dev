﻿
Функция СформироватьAliesИзТекста(формТекст)
	
	ДоступныеСимволы 	= "-_1234567890ABCDEIFGHIJKLMNOPQRSTUVWXYZАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯЁ";
	СимволыНаТире 		= ".,=;/\- ";
	
	НаименованиеВРег 	= ВРег(СокрЛП(формТекст));
	ДлинаНаим 			= СтрДлина(СокрЛП(формТекст));
	
	СтрAlies = "";
	
	Для ном = 1 По ДлинаНаим Цикл текСимволВрег = Сред(НаименованиеВРег, ном, 1); текСимвол = Сред(формТекст, ном, 1); Если Найти(ДоступныеСимволы, текСимволВрег) Тогда СтрAlies = СтрAlies + текСимвол; ИначеЕсли Найти(СимволыНаТире, текСимволВрег) Тогда СтрAlies = СтрAlies + "-"; КонецЕсли;КонецЦикла;
	
	// { Удалить временная мера
	
	СтрAlies = СтрЗаменить(СтрAlies, "--", "-");
	СтрAlies = СтрЗаменить(СтрAlies, "--", "-");
	СтрAlies = СтрЗаменить(СтрAlies, "--", "-");
	СтрAlies = СтрЗаменить(СтрAlies, "--", "-");
	
	Если Прав(СтрAlies,1) = "-" Тогда СтрAlies = Лев(СтрAlies, СтрДлина(СтрAlies) - 1) КонецЕсли;
	Если Прав(СтрAlies,1) = "-" Тогда СтрAlies = Лев(СтрAlies, СтрДлина(СтрAlies) - 1) КонецЕсли;
	Если Прав(СтрAlies,1) = "-" Тогда СтрAlies = Лев(СтрAlies, СтрДлина(СтрAlies) - 1) КонецЕсли;
	
	// }
	
	Возврат СтрAlies;
	
КонецФункции


Процедура ПередЗаписью(Отказ)
	
	// Проверим alies
	
	Если ПустаяСтрока(alies) Тогда
		                                                                                  
		alies = СформироватьAliesИзТекста(h1);
		Если ПустаяСтрока(alies) Тогда
			alies = СформироватьAliesИзТекста(Наименование); КонецЕсли; КонецЕсли;
	
	// Проверим чтобы alies был токо англицкий
	
	Если КонвертацияТипов.ЕстьРусскиеБуквы(alies) Тогда
		alies = НРег(КонвертацияТипов.ПреобразоватьРусскийТекстВАнглицкий(alies)); КонецЕсли;

		
	// Проверим alies
	
	новАлиес = HTTP.ПроверитьИПолучитьНовыйAlies(Ссылка, ЭтоНовый(), alies);
	Если новАлиес <> alies Тогда alies = новАлиес КонецЕсли;
	//HTTP.ПроверитьОбновитьAlies(ЭтотОбъект);
	
	// Экранируем хрень
	
	API2.ЗаменитьЭкранНаСпецсимволы(КраткоеСодержание);
	API2.ЗаменитьЭкранНаСпецсимволы(ТекстСтатьи);

	
КонецПроцедуры
