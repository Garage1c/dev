﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидомостьЭлементовОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтбор(Команда)
	
	УстановитьВидомостьЭлементовОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидомостьЭлементовОтбора()
	
	Если НЕ Элементы.ФормаПоказатьОтбор.Пометка Тогда
		Элементы.КомпоновщикНастроекНастройкиОтбор.Видимость = Истина;
		Элементы.ФормаПоказатьОтбор.Пометка = Истина;
	Иначе
		Элементы.КомпоновщикНастроекНастройкиОтбор.Видимость = Ложь;
		Элементы.ФормаПоказатьОтбор.Пометка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьРезультатОтчета(Команда)
	
	СформироватьРезультатОтчетаНаСервере();
	
	УстановитьВидомостьЭлементовОтбора();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьРезультатОтчетаНаСервере()
	
	Результат.Очистить();
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	ОтчетОбъект.СформироватьОтчет(Результат, УникальныйИдентификатор, ДанныеРасшифровки);	
	
КонецПроцедуры
