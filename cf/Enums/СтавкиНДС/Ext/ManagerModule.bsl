﻿
Функция ПолучитьЧислоСтавкиНДС(Ссылка) Экспорт
	
	Если Ссылка = Перечисления.СтавкиНДС.НДС18 ИЛИ Ссылка = Перечисления.СтавкиНДС.НДС18_118 Тогда
		
		Возврат 18;
		
	ИначеЕсли Ссылка = Перечисления.СтавкиНДС.НДС19 ИЛИ Ссылка = Перечисления.СтавкиНДС.НДС19 Тогда
		
		Возврат 19;
		
	ИначеЕсли Ссылка = Перечисления.СтавкиНДС.НДС10 ИЛИ Ссылка = Перечисления.СтавкиНДС.НДС10_110 Тогда
		
		Возврат 10;
				
	ИначеЕсли Ссылка = Перечисления.СтавкиНДС.НДС20 ИЛИ Ссылка = Перечисления.СтавкиНДС.НДС20_120 Тогда
			
		Возврат 20;
		
	Иначе 
		
		Возврат 0; КонецЕсли;
	
КонецФункции