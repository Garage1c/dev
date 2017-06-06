﻿
&НаСервере
Процедура ПрочитатьИнформациюпоСкладам()
	
	текСтрока = Элементы.Список.ТекущаяСтрока;
	
	Если 	текСтрока <> Неопределено Тогда
		
		Если Не текСтрока.ЭтоГруппа Тогда
		
			ТаблицаПоСкладм.Параметры.УстановитьЗначениеПараметра("Номенклатура", текСтрока);
		Иначе 
			ТаблицаПоСкладм.Параметры.УстановитьЗначениеПараметра("Номенклатура",  Справочники.Номенклатура.ПустаяСсылка());
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	//ТекДанные = Элементы.Список.ТекущаяСтрока;
	
	//АдресКартинки = Картинки.ПолучитьНавигационнуюСсылкуОсновногоИзображения(ТекДанные);
	
	//ПрочитатьИнформациюпоСкладам();
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре();	 	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДвижениеТовара(Команда)
	
	ТекНоменклатура = Элементы.Список.ТекущаяСтрока;
	
	Если ТекНоменклатура <> Неопределено Тогда
		
		ПараметрыФормы = Новый Структура("Отбор, КлючНазначенияИспользования, СформироватьПриОткрытии", 
		 							Новый Структура("Номенклатура", 
												ТекНоменклатура),,
									Истина);
									
		ОткрытьФорму("Отчет.ВедомостьОдногоТовара.ФормаОбъекта", ПараметрыФормы);

					
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	// Матрицы
	РаботаСНоменклатурой.ДобавитьМатрицы(ЭтаФорма, Список);

КонецПроцедуры

// ИНФОРМАЦИЯ О ТОВАРЕ

&НаСервере
Процедура ОбработатьОтображениеИнформацииОТоваре() Экспорт
	РаботаСНоменклатурой.ОбработатьОтображениеИнформацииОТоваре(ЭтаФорма, "Список", "Список");
КонецПроцедуры

&НаКлиенте
Процедура ИнфТовараТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка, "Список");
КонецПроцедуры
&НаКлиенте
Процедура ИнфТовараЗаголовокHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараЗаголовокHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка, "Список", "Список");
КонецПроцедуры

 &НаКлиенте
Процедура ПоказатьСкрытьИнфОТоваре(Команда)
	РаботаСНоменклатуройКлиент.ПоказатьСкрытьИнфОТоваре(ЭтаФорма);
КонецПроцедуры
&НаКлиенте
Процедура НастройкаИнфОТоваре(Команда) 
	РаботаСНоменклатуройКлиент.НастройкаИнфОТоваре(ЭтаФорма, "Список", "Список");
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РаботаСНоменклатуройКлиент.ПоказатьСкрытьИнфОТоваре(ЭтаФорма);

КонецПроцедуры

#Область Матрицы

&НаСервере
Процедура ОбработкаДействияФильтраМатрицыНаСервере(ИмяЭлементаКартинкиМатрицы)
	
	РаботаСНоменклатурой.ИзменилсяФильтрМатрицы(ЭтаФорма, ИмяЭлементаКартинкиМатрицы, Список);
	
КонецПроцедуры
&НаКлиенте
Процедура ОбработкаДействияФильтраМатрицы(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// Переключим значение реквизиты
	
	Если ЭтотОбъект["МатрицаФильтровать"] Тогда
		ЭтотОбъект[Элемент.Имя] = Не ЭтотОбъект[Элемент.Имя];
		ОбработкаДействияФильтраМатрицыНаСервере(Элемент.Имя);
	Иначе	
		ПоказатьОповещениеПользователя("Фильтры по матрицам отключены",,"Включите фильтры если нужно фильтровать"); КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура МатрицаФильтроватьИзмененииНаСервере()
	
	РаботаСНоменклатурой.МатрицаФильтроватьИзменении(ЭтаФорма, Список);
	
КонецПроцедуры
&НаКлиенте
Процедура МатрицаФильтроватьИзменении(Элемент)
	
	МатрицаФильтроватьИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокКнопокУправления()
	
	Возврат РаботаСНоменклатурой.ПолучитьСписокКомандУправленияМатрицами(ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура УстановитьЗначениеВсехМатрицНаСервере(Значение)
	
	РаботаСНоменклатурой.УстановитьЗначениеВсехМатриц(Значение, ЭтаФорма, Список);
	
КонецПроцедуры
&НаКлиенте
Процедура УстановитьЗначениеВсехМатриц(Значение) Экспорт
	
	УстановитьЗначениеВсехМатрицНаСервере(Значение);
	
КонецПроцедуры
&НаКлиенте
Процедура КнопкаУправленияМатрицами(Команда)
	
	ПоказатьВыборИзМеню(Новый ОписаниеОповещения("ОбработкаУправленияМатрицей", РаботаСНоменклатуройКлиент, Новый Структура("Форма", ЭтаФорма)), ПолучитьСписокКнопокУправления(), Команда);
	
КонецПроцедуры

#КонецОбласти