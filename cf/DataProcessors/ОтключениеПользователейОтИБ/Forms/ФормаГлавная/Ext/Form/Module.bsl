﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПолучитьАктивныхПользователей();
	Обработка.ПериодБлокировки=600;
	СтрокаСоединения=СтрокаСоединенияИнформационнойБазы();
	Если Найти(СтрокаСоединения,"Srvr=")=0 Тогда 
		Элементы.СписокПользователейГруппа2.Видимость=Ложь;
	КонецЕсли;
	
	Если Обработка.НомерПортаАгента=0 Тогда
		Обработка.НомерПортаАгента=1540;
	КонецЕсли;
КонецПроцедуры
	
&НаКлиенте
Процедура Настройки(Команда)
	ВидимостьНастроек();
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьНастроек()
	ОтображениеНастроек=Не ОтображениеНастроек;
	Элементы.Настройки.Видимость=ОтображениеНастроек;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.Настройки.Видимость=ОтображениеНастроек;
КонецПроцедуры

//=============================================================

&НаСервере
Процедура ПолучитьАктивныхПользователей()
	Кол=0;
	Пользователь="";
	СписокПользователей.Очистить();
	МассивПользователей=ПолучитьСеансыИнформационнойБазы();
	Для каждого элементМассива Из МассивПользователей Цикл
		Стр=СписокПользователей.Добавить();
		Стр.Пользователь=элементМассива.Пользователь.Имя;
		Стр.ВремяВхода=элементМассива.НачалоСеанса;
		Стр.ИмяПриложения=?(элементМассива.ИмяПриложения="Designer","Конфигуратор","Предприятие");
		Кол=Кол+1;
		Если элементМассива.НомерСеанса=НомерСеансаИнформационнойБазы() Тогда
			Стр.ИмяКомпьютера="ВАШ СЕАНС";
		Иначе
			Стр.ИмяКомпьютера=элементМассива.ИмяКомпьютера;
		КонецЕсли;
		Стр.НомерСеанса=элементМассива.НомерСеанса;
		Стр.НомерСоединения=элементМассива.НомерСоединения;
	КонецЦикла;
	КоличествоСоед=Кол;
	СписокПользователей.Сортировать("Пользователь");
КонецПроцедуры 

&НаКлиенте
Процедура ОбновитьСписокПользователей(Команда)
	ПолучитьАктивныхПользователей();
КонецПроцедуры

&НаКлиенте
Процедура БлокироватьВсех(Команда)
	Если Вопрос("Вы точно желаете установить блокировку на "+Обработка.ПериодБлокировки+" сек.?",РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да Тогда
		УстановитьБлокировкуСоединенийНаСервере();
		ПолучитьАктивныхПользователей();
		ПоказатьПредупреждение(,"Выполнено!",,"Сообщение!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьБлокировкуСоединенийНаСервере()
	Об=РеквизитФормыВЗначение("Обработка");
	Об.УстановитьБлокировкуСоединений();
КонецПроцедуры
 
&НаКлиенте
Процедура СнятьБлокировку(Команда)
    СнятьБлокировкуСоединенийНаСервере();
	ПолучитьАктивныхПользователей();
	ПоказатьПредупреждение(,"Выполнено!",,"Сообщение!");
КонецПроцедуры

&НаСервере
Процедура СнятьБлокировкуСоединенийНаСервере()
Об=РеквизитФормыВЗначение("Обработка");
Об.СнятьБлокировкуСоединений();
КонецПроцедуры
 
&НаКлиенте
Процедура ОтключитьПринудительноВсех(Команда)
	Если Вопрос("Вы точно желаете отключить всех?",РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да Тогда
		ОтключитьПользователейОтИБНаСервере();
		ПолучитьАктивныхПользователей();
		ПоказатьПредупреждение(,"Выполнено!",,"Сообщение!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОтключитьПользователейОтИБНаСервере(ВыбранныйСеанс=Неопределено,ВыбранноеСоединение=Неопределено)
   Об=РеквизитФормыВЗначение("Обработка");
   Об.ОтключитьПользователейОтИБ(ВыбранныйСеанс,ВыбранноеСоединение);
КонецПроцедуры 

&НаКлиенте
Процедура ОтключитьПринудительноПользователя(Команда)
	Для каждого ТекСтрока Из СписокПользователей Цикл
		Если ТекСтрока.НомерСоединения=ПолучитьНомерСоединения() И ТекСтрока.Пометка Тогда
			Сообщение=Новый СообщениеПользователю();
			Сообщение.Текст="Вы не можете отключить свой сеанс!";
			Сообщение.Сообщить();
			Продолжить;
		КонецЕсли;
		Пользователь=ТекСтрока.Пользователь;
		Если ТекСтрока.Пометка Тогда
			ОтключитьПользователейОтИБНаСервере(ТекСтрока.НомерСеанса,ТекСтрока.НомерСоединения);
		КонецЕсли;
	КонецЦикла;
	ПолучитьАктивныхПользователей();
КонецПроцедуры

&НаКлиенте
Процедура Спасибо(Команда)
	 Попытка
		 ЗапуститьПриложение("http://infostart.ru/public/159546/?rate=1");
	 Исключение
	 КонецПопытки;
 КонецПроцедуры
 
//=======================================================

&НаСервереБезКонтекста
Функция  ПолучитьНомерСоединения();
	Возврат НомерСоединенияИнформационнойБазы();	
КонецФункции

&НаКлиенте
Процедура СозданиеБэкапа(Команда)
	Если НЕ ЗначениеЗаполнено(Обработка.АдминИБ) Тогда
		ПоказатьПредупреждение(,"Не указан администратор базы!",,"Сообщение!");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Обработка.КодРазрешения) Тогда
		ПоказатьПредупреждение(,"Не указан код разрешения входа при блокировки базы!",,"Сообщение!");
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Обработка.ПутьБэкапа) Тогда
		СоздатьБэкапНаСервере();
		ПрекратитьРаботуСистемы();
	Иначе ПоказатьПредупреждение(,"Не указан путь к резервной копии!",,"Сообщение!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СоздатьБэкапНаСервере()
	Об=РеквизитФормыВЗначение("Обработка");
	Об.ОтключитьПользователейОтИБ();
	Об.СоздатьБэкап();
КонецПроцедуры

&НаКлиенте
Процедура ПутьБэкапаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Диалог=Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Фильтр="*.dt|*.dt";
	Если Диалог.Выбрать() Тогда
		Обработка.ПутьБэкапа=Диалог.ПолноеИмяФайла;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДругиеОбработки(Команда)
	Попытка
		ЗапуститьПриложение("http://infostart.ru/community/profile/287329");
	Исключение 	КонецПопытки;
КонецПроцедуры



 
