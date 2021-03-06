﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Объект.Ссылка.Пустая()	Тогда
		ЗадачиБизнесПроцесса.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
	Иначе
		ЗадачиБизнесПроцесса.Параметры.УстановитьЗначениеПараметра("Ссылка", БизнесПроцессы.УтверждениеДоговора.ПустаяСсылка());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеВидимостьюЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеВидимостьюЭлементовФормы()
	
	Если Объект.Стартован Или Объект.Завершен Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры