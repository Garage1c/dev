﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Идн=-1;
	Для Каждого БизнесПроцесс Из Метаданные.БизнесПроцессы Цикл Идн=Идн+1;
		Элементы.Процесс.СписокВыбора.Вставить(Идн,  БизнесПроцесс.Имя, БизнесПроцесс.Синоним);	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДинамическийСписок()
	Процессы.ТекстЗапроса = "ВЫБРАТЬ * ИЗ БизнесПроцесс." + Процесс;
	Процессы.ОсновнаяТаблица = "БизнесПроцесс." + Процесс;
	Процессы.ДинамическоеСчитываниеДанных = Истина;	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессПриИзменении(Элемент)
	ОбновитьДинамическийСписок();	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессыПриАктивизацииСтроки(Элемент)
	ЗадачиПроцесса.Параметры.УстановитьЗначениеПараметра("Ссылка", Элементы.Процессы.ТекущаяСтрока);
	Элементы.Группа1.Заголовок = Элементы.Процессы.ТекущаяСтрока; 
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиПроцессаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Задача.ЗадачаПользователю.Форма.ФормаЗадачи", Новый Структура("Ключ, НеОткрыватьДругуюФорму",ВыбраннаяСтрока, Истина), ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПроцессыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("БизнесПроцесс." + Процесс + ".Форма.УпрФормаБП", Новый Структура("Ключ", ВыбраннаяСтрока), ЭтаФорма);
КонецПроцедуры
