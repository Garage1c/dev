﻿

Функция РазмаскироватьСобытие(маскСтрСобытие) Экспорт
	
	// Возвращаем точки
	
	стрСобытие = СтрЗаменить(маскСтрСобытие,"_t_",".");
	
	// Возвращаем пробелы
	
	Возврат СтрЗаменить(стрСобытие,"_"," ");
	
КонецФункции

Функция МаскироватьСобытие(стрСобытие) Экспорт
	
	// Убираем точки
	МаскСтрСобытие =  СтрЗаменить(стрСобытие,".","_t_");
	
	// Убираем пробелы
	Возврат СтрЗаменить(МаскСтрСобытие," ","_");
	
КонецФункции
