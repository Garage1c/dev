﻿//данный алгоритм работоспособен только при использовании обработки в составе конфигурации (не внешней) и при условии выполнения кода в фоновом задании


&НаСервере
Процедура ОбработатьНаСервере()
	
	//Обязательная часть кода №2
	ИмяОбработки=РеквизитФормыВЗначение("Объект").Метаданные().Имя;
	Поток.ЗапуститьПоток("Обработки."+ИмяОбработки+".Создать().ОбработатьНаСервере("""+ИмяФормы+""")",УникальныйИдентификатор);
	//
	
КонецПроцедуры


&НаКлиенте
Процедура Обработать(Команда)
	
	//Обязательная часть кода №1
	ПодключитьОбработчикОжидания("ПоказатьТекущееСостояние",1);
	//
	
	ОбработатьНаСервере();
	
КонецПроцедуры


//Обязательная часть кода №3
&НаКлиенте
Процедура ПоказатьТекущееСостояние()
	СтруктураВозврата = ПоказатьТекущееСостояниеНаСервере(ИмяФормы);
	Прогресс=СтруктураВозврата.Прогресс;
	Сост=СтруктураВозврата.Состояние;
	Состояние(Сост+". Обработано : "+Прогресс+" %",Прогресс);
	Если Прогресс>=100 Тогда
		ОтключитьОбработчикОжидания("ПоказатьТекущееСостояние");
		СброситьСчетчик(ИмяФормы);
	КонецЕсли;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПоказатьТекущееСостояниеНаСервере(ИмяФормы)
	Возврат РегистрыСведений.ПрогрессБар.ПолучитьЗначение(ИмяФормы);
КонецФункции

&НаСервереБезКонтекста
Процедура СброситьСчетчик(ИмяФормы)
	 РегистрыСведений.ПрогрессБар.СброситьСчетчик(ИмяФормы);
КонецПроцедуры
//



