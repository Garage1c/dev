﻿
Процедура ОбработкаВыбораБазыПриемника(СсылкиДляВыгрузки, ОбменДанными) Экспорт
	
	// СсылкиДляВыгрузки - массив внутри выгружаемые ссылки
	// ОбменДанными - Ссылка справочник обмен данными, по правилам которого будет выгружаться
	
	Если обм_Обмен.Выгрузить(СсылкиДляВыгрузки, ОбменДанными) Тогда
		
			ПоказатьОповещениеПользователя(	"Данные выгруженны",,?(СсылкиДляВыгрузки.Количество() = 1, СсылкиДляВыгрузки[0], "в количестве " + СсылкиДляВыгрузки.Количество()));
	Иначе	ПоказатьПредупреждение(,		"Произошла ошибка",,"Выгрузка в " + ОбменДанными); КонецЕсли;
	
КонецПроцедуры
