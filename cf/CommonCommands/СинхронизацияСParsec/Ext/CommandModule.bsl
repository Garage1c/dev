﻿
&НаСервере
Процедура Синхронизировать()
	
	Parsec.СинхронизацияСParsec();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("ОбщаяФорма.", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
	ПоказатьОповещениеПользователя("Запущено фоновое задания синхронизации с Parsec");
	
	Синхронизировать();
	
	ПоказатьПредупреждение(,"Синхронизировано",,"Сообщение!");
	
	
КонецПроцедуры
