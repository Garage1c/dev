﻿
Функция ПолучитьТекущуюКассу() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ 	Ссылка 
	|ИЗ 		Справочник.Кассы
	|ГДЕ		ИмяКомпьютера = """ + ПараметрыСеанса.ИмяКомпьютераКлиента + """
	|");
	
	Выполнение = Запрос.Выполнить();
	Если Выполнение.Пустой() Тогда
		
		Возврат ПустаяСсылка();
		
	Иначе
		
		Выборка = Выполнение.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.Ссылка;
		
	КонецЕсли;
	
КонецФункции