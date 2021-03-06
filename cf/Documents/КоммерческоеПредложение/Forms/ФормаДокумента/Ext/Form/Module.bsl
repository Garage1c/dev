﻿&НаКлиенте
Перем СтруктураКолонокТовары Экспорт;

&НаКлиенте
Перем ЗначенияНДС, Ставка18;

&НаСервере
Функция ПолучитьСтавкуПоУмолчанию() Возврат ?(ПолучитьФункциональнуюОпцию("НемецкийУчет"), Перечисления.СтавкиНДС.НДС19, Перечисления.СтавкиНДС.НДС18)	 КонецФункции
&НаСервере
Функция ПустойТовар() Возврат Справочники.Номенклатура.ПустаяСсылка() КонецФункции

&НаСервере
Функция ТаблицаТолькоТовары()
	
	ТипТовар	= Тип("СправочникСсылка.Номенклатура");
	НовТЗ 		= Объект.Товары.Выгрузить(); КолСтрок = НовТЗ.Количество();
	
	Для Ном = 1 По КолСтрок Цикл 
		
		Строка = НовТЗ[КолСтрок - Ном];
		Если ТипЗнч(Строка.Номенклатура) <> ТипТовар Тогда 
			НовТЗ.Удалить(Строка); КонецЕсли; КонецЦикла;

	Возврат НовТЗ;
	
КонецФункции

#Область Типовые

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗначенияНДС = Новый Соответствие;
	Ставка18 	= ПолучитьСтавкуПоУмолчанию();
	СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, Объект.СуммаВключаетНДС, Объект.ТипЦен, "Товары" , , Объект.Валюта, Объект.УчитыватьНДС, Объект.Валюта, Объект.СуммаВключаетНДС,,Объект.УчитыватьНДС);
	
	// Автосохранение
	
	Если АвтосохранениеКлиент.ИницилизироватьСохранение(ЭтаФорма) Тогда
			
		ДанныеДляПодбора = "";
		ЗагрузитьДанныеАвтосохранения(ДанныеДляПодбора); 
		Модифицированность = Истина; 
			
		Если Не ПустаяСтрока(ДанныеДляПодбора) Тогда ПодборВыполнить(,Новый Структура("МассивТоваровСтрокой", ДанныеДляПодбора)) КонецЕсли; КонецЕсли;
		
	// Обновим картинки строк
		
	Для Каждого Строка ИЗ Объект.Товары Цикл ОбновитьКартинку(Строка) КонецЦикла;
	
	ОбновитьПодвал();
	
КонецПроцедуры
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Автосохранение
	Если Не Отказ И Объект.Ссылка.Пустая() Тогда АвтосохранениеСервер.УдалитьАвтоСохранение(ИмяФормы, Объект.Ссылка) КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ПриЗакрытии()
	
	// Автосохранение
	Попытка АвтосохранениеСервер.УдалитьАвтоСохранение(ИмяФормы, Объект.Ссылка)
	Исключение КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Значения по умолчанию
	Если Объект.Ссылка.Пустая() Тогда
		ФункцииФормДокументов.ЗаполнитьЗначенияПоУмолчанию( Объект, КэшируемыеФункции.ПолучитьРеквизитыДокумента("КоммерческоеПредложение")) КонецЕсли;
	
	// Информация о товаре
	РаботаСНоменклатурой.ДобавитьОперативнуюИнформациюОТоваре(ЭтаФорма);
	
	// прикрепленные файлы
	ОбновитьВидимостьПрикрепленныхФайловНаСервере();
		
КонецПроцедуры

#КонецОбласти

#Область Информация // о товаре

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	// информация о товаре
	ОбработатьОтображениеИнформацииОТоваре()	
	 	
КонецПроцедуры
&НаКлиенте
Процедура ОбработатьОтображениеИнформацииОТоваре() Экспорт 
	РаботаСНоменклатуройКлиент.ОбработатьОтображениеИнформацииОТоваре(ЭтаФорма, "Товары", "Объект.Товары",,,"Объект.Валюта");
КонецПроцедуры

&НаКлиенте
Процедура ИнфТовараТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараТекстHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура ИнфТовараЗаголовокHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	РаботаСНоменклатуройКлиент.ИнфТовараЗаголовокHTMLПриНажатии(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка, "Товары", "Объект.Товары");
КонецПроцедуры

 &НаКлиенте
Процедура ПоказатьСкрытьИнфОТоваре(Команда)
	РаботаСНоменклатуройКлиент.ПоказатьСкрытьИнфОТоваре(ЭтаФорма);
КонецПроцедуры
&НаКлиенте
Процедура НастройкаИнфОТоваре(Команда) 
	РаботаСНоменклатуройКлиент.НастройкаИнфОТоваре(ЭтаФорма, "Товары", "Объект.Товары");
КонецПроцедуры

#КонецОбласти

#Область Автосохранение

&НаСервере
Процедура ЗагрузитьДанныеАвтосохранения(ДанныеДляПодбора)
	
	АвтосохранениеСервер.СчитатьДанныеФормыИУдалитьСохранение(ЭтаФорма, ДанныеДляПодбора)
	
КонецПроцедуры
&НаСервере
Функция АвтосохранениеСервер(ЕстьДамп)
	
	Возврат АвтосохранениеСервер.СохранитьДампФормы(ЭтаФорма, ЕстьДамп);
	
КонецФункции
&НаКлиенте
Процедура Автосохранение()
	
	Перем ЕстьДамп;
	
	Сохранилось = АвтосохранениеСервер(ЕстьДамп);
	
	АвтосохранениеКлиент.ПроизошлоАвтосохранение(Сохранилось, ЕстьДамп, Объект.Ссылка);
	
КонецПроцедуры
&НаСервере
Функция ПолучитьДамп()
	
	Возврат АвтосохранениеСервер.ПолучитьДамп(ЭтаФорма);

КонецФункции

#КонецОбласти

#Область Подбор

&НаСервере
Функция ПоместитьТоварыВХранилище() 
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаТолькоТовары(), УникальныйИдентификатор);
	
КонецФункции
&НаКлиенте
Процедура ПодборВыполнить(Кнопка = Неопределено, ДополнительныеПараметрыПодбора = Неопределено)
	
	ИмяТабличнойЧасти = "Товары";
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	ПараметрыПодбора = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	
	ПараметрыПодбора.Вставить("СтруктураКолонокТовары", СтруктураКолонокТовары);
	ПараметрыПодбора.Вставить("ТипЦен", 				Объект.ТипЦен);
	ПараметрыПодбора.Вставить("Валюта", 				Объект.Валюта);
	
	// Автосохранение
	                                                                 
	АвтосохранениеКлиент.ОткрываетсяПодбор(ПараметрыПодбора, Объект.Ссылка, ЭтаФорма, ПолучитьДамп());
	Если ДополнительныеПараметрыПодбора <> Неопределено Тогда
		КонвертацияТипов.ДобавитьВСтруктуруСтруктуру(ПараметрыПодбора, ДополнительныеПараметрыПодбора) КонецЕсли;
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаПодбора", ПараметрыПодбора, Элементы.Товары);
	
КонецПроцедуры
&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресТоваровВХранилище, ДобавитьВКонец = Ложь)
	
	// Заполним
	
	ТЗТов = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	Если ТЗТов.Колонки.Найти("Артикул") = Неопределено Тогда ТЗТов.Колонки.Добавить("Артикул", 	Новый ОписаниеТипов("Строка")); КонецЕсли;
	Если ТЗТов.Колонки.Найти("Картинка") = Неопределено Тогда  ТЗТов.Колонки.Добавить("Картинка", 	Новый ОписаниеТипов("Число")); КонецЕсли;
	Если ТЗТов.Колонки.Найти("Пересчет") = Неопределено Тогда ТЗТов.Колонки.Добавить("Пересчет",	Новый ОписаниеТипов("Булево")); КонецЕсли;
	
	ТЗТов.Колонки.Номенклатура.Имя = "стНоменклатура";
	
	ТЗТов.Колонки.Добавить("Номенклатура");
	ТЗТов.ЗагрузитьКолонку(ТЗТов.ВыгрузитьКолонку("стНоменклатура"), "Номенклатура");
	
	ТипТовар 	= Тип("СправочникСсылка.Номенклатура");
	ТипСтрока 	= Тип("Строка");
	
	Для Каждого Строка Из ТЗТов Цикл
		
		Тип = ТипЗнч(Строка.Номенклатура);
		
		Если Тип = ТипТовар Тогда
		
			Строка.Пересчет = Истина;
			Строка.Артикул = Строка.Номенклатура.Артикул;
			Строка.Картинка = 1;
		
		ИначеЕсли Тип = ТипСтрока  Тогда
			Строка.Картинка = 2; КонецЕсли; КонецЦикла;
	
	// Склеем строки
	
	Если Не ДобавитьВКонец Тогда
	
		Для Каждого Строка Из Объект.Товары Цикл
		Если ТипЗнч(Строка.Номенклатура) <> ТипТовар Тогда
			ЗаполнитьЗначенияСвойств(ТЗТов.Вставить(Строка.НомерСтроки - 1), Строка); КонецЕсли; КонецЦикла; КонецЕсли;
	
	КонвертацияТипов.ДобавитьТаблицуКДругойТаблице(Объект.Товары, ТЗТов);
	ОбновитьПодвалНаСервере();
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Перем ДобавитьВКонец, Пересчитать;
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение <> Неопределено Тогда		
		
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
			
			ВыбранноеЗначение.Свойство("ПересчитатьЦену", Пересчитать);
			ВыбранноеЗначение.Свойство("ДобавитьВКонец", ДобавитьВКонец);
			
			Если Пересчитать = Истина Тогда Кол = Объект.Товары.Количество() КонецЕсли;
			
			ПолучитьТоварыИзХранилища(ВыбранноеЗначение.Товары, ДобавитьВКонец = Истина);	// получаем
			УдалитьИзВременногоХранилища(ВыбранноеЗначение.Товары); 						// заметаем следы
			
			Если Пересчитать = Истина Тогда // пересчитаем добавленные товары
				Для Инд = Кол По Объект.Товары.Количество() - 1 Цикл Строка = Объект.Товары[Инд];
					ПересчитатьВсюСтроку(Строка); КонецЦикла; КонецЕсли;
		Иначе
			ПолучитьТоварыИзХранилища(ВыбранноеЗначение);		// получаем
			УдалитьИзВременногоХранилища(ВыбранноеЗначение); 	// заметаем следы
		КонецЕсли;

		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Корзина

#Если Не ВебКлиент Тогда
&НаСервере
Процедура ДобавитьИзКорзиныНаСервере(ИмяКомпа, СтруктураКолонокТовары, КолСтрок)
	
	МодульКорзины.ПолучитьТоварИзКорзины(Элементы.Товары, Объект.Товары, СтруктураКолонокТовары, ИмяКомпа, КолСтрок,,,,Новый Структура("Картинка, Пересчет", 1, Истина), "НовСтрока.Артикул = Строка.Номенклатура.Артикул");
	
КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура ВставитьИзКорзины(Команда)
	
	КолСтрок = 0;
	ДобавитьИзКорзиныНаСервере(ИмяКомпьютера(), СтруктураКолонокТовары, КолСтрок);
	
	Если КолСтрок Тогда
		
		МодульКорзины.ОповеститьОВставкеТовараВДокумент(КолСтрок, Объект.Товары.Количество());
		
	Иначе
		
		МодульКорзины.ОповеститьЧтоНечегоДобавлять();
		
	КонецЕсли;
	

КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаСервере
Функция ПоложитьВКорзинуНаСервере(ВыделенныеИндексы, ИмяКомпа, КолВКорзине)
	
	Возврат МодульКорзины.ПоложитьТоварВКорзину(Объект.Товары, ВыделенныеИндексы, ИмяКомпа, КолВКорзине);
	
КонецФункции
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура ДобавитьВКорзину(Команда)
	
	ВыделенныеИндексы 	= МодульКорзины.ПолучитьВыделенныеСтрокиТоваров(Элементы.Товары, Объект.Товары);
	КолВКорзине 		= 0;
	КолТовара			= ВыделенныеИндексы.Количество();
	
	
	Если КолТовара Тогда
		
		Если ПоложитьВКорзинуНаСервере(ВыделенныеИндексы, ИмяКомпьютера(), КолВКорзине) Тогда
			МодульКорзины.ОповеститьОПомещенииТовара(КолТовара, КолВКорзине);
		КонецЕсли;
		
	Иначе
		
		МодульКорзины.ОповеститьЧтоНечегоДобавлять();
				
	КонецЕсли;

КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура РедактироватьТоварВКорзине(Команда)
	
	ОткрытьФорму("РегистрСведений.Корзина.Форма.Форма");
	
КонецПроцедуры
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаСервере
Функция ОчиститьНаСервере(ИмяКомпа)
	
	Возврат МодульКорзины.ОчиститьКорзину(ИмяКомпа);
	
КонецФункции
#КонецЕсли

#Если Не ВебКлиент Тогда
&НаКлиенте
Процедура ОчиститьКорзину(Команда)
	
	Если ОчиститьНаСервере(ИмяКомпьютера()) Тогда
		
		МодульКорзины.ОповеститьЧтоКорзинаОчищена();
		
	КонецЕсли;

КонецПроцедуры
#КонецЕсли

#КонецОбласти

#Область ПриИзменении

&НаКлиенте
Процедура РассчитатьСумму(Строка)
	
	Если Строка.Пересчет Тогда
		
		Строка.Сумма 						= Строка.Цена * Строка.Количество; 
		Строка.СуммаРучнойСкидки 			= Строка.Сумма / 100 * Строка.ПроцентРучнойСкидки;
		Строка.СуммаАвтоматическойСкидки 	= Строка.Сумма / 100 * Строка.ПроцентАвтоматическойСкидки; КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура РассчитатьНДС(Строка)
	
	Если Строка.Пересчет Тогда
		
		Если Объект.УчитыватьНДС Тогда
			
			СуммаСоСкидкой = Строка.Сумма - Строка.СуммаРучнойСкидки - Строка.СуммаАвтоматическойСкидки;
			
			// Получим ставку
				
			Ставка = ЗначенияНДС[Строка.СтавкаНДС];
			Если Ставка = Неопределено Тогда
				Ставка = КэшируемыеФункции.ПолучитьЧислоСтавкиНДС(Строка.СтавкаНДС);
				ЗначенияНДС.Вставить(Строка.СтавкаНДС, Ставка); КонецЕсли;
			
			// Рассчитаем НДС
			
			Строка.СуммаНДС = ?(Объект.СуммаВключаетНДС, 
						СуммаСоСкидкой * Ставка / (100 + Ставка), //Строка.Сумма * Ставка / (100 + Ставка),
						СуммаСоСкидкой * Ставка / 100); //Строка.Сумма * Ставка / 100); 
		Иначе
			
			Строка.СуммаНДС = 0; КонецЕсли; КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура РассчитатьВсего(Строка)
	
	Если Строка.Пересчет Тогда
		Строка.Всего = Строка.Сумма
			+ ?(Объект.СуммаВключаетНДС ИЛИ НЕ Объект.УчитыватьНДС, 0, Строка.СуммаНДС)
			- Строка.СуммаРучнойСкидки - Строка.СуммаАвтоматическойСкидки; КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьЦеныТоваров()
	
	ТипТовар = Тип("СправочникСсылка.Номенклатура");
	
	Для Каждого Строка Из Объект.Товары Цикл
		//Если ТипЗнч(Строка.Номенклатура) = ТипТовар Тогда
			ОбновитьЦенуСтроки(Строка);  
		//КонецЕсли; 
	КонецЦикла;
	
	ОбновитьПодвал();
	
КонецПроцедуры
&НаКлиенте
Процедура ПересчитатьВсюСтроку(Строка)
	
	Если ТипЗнч(Строка.Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		ФункцииФормДокументов.РассчитатьСуммыСтрокиОтЦены(Строка, СтруктураКолонокТовары, Объект.ПересчитыватьЦену);
	Иначе
		
		Ставка = КэшируемыеФункции.ПолучитьЧислоСтавкиНДС(Строка.СтавкаНДС);
		
		Если Объект.ПересчитыватьЦену Тогда
			
			Строка.Цена = ПересчитатьЦенуСтроки(Строка.Цена,СтруктураКолонокТовары.стВалюта);
						
			Если  Объект.УчитыватьНДС Тогда
				
				Если НЕ Объект.СуммаВключаетНДС Тогда
					Строка.СуммаНДС =  Строка.Цена * Строка.Количество * Ставка / (100 + Ставка);
					Строка.Цена=Строка.Цена - (Строка.Цена * Ставка / (100 + Ставка));
					Строка.Сумма =Строка.Цена* Строка.Количество;
					Строка.Всего =Строка.Цена* Строка.Количество+Строка.СуммаНДС;
				Иначе
					Строка.Цена=Строка.Цена/(1-(Ставка/(100+Ставка)));
					Строка.СуммаНДС =  Строка.Цена * Строка.Количество * Ставка / (100 + Ставка);
					Строка.Сумма =Строка.Цена* Строка.Количество;
					Строка.Всего =Строка.Цена* Строка.Количество;
				КонецЕсли;	
				
			Иначе
				Строка.СуммаНДС=0;
				РассчитатьСумму(Строка);
				РассчитатьВсего(Строка);
			КонецЕсли;
			
		Иначе
			
			РассчитатьСумму(Строка);
			РассчитатьВсего(Строка);
			РассчитатьНДС(Строка);
		КонецЕСли;
		//РассчитатьПроцентАвтоматическойСкидки(Строка);
		//РассчитатьСумму(Строка);
		//РассчитатьНДС(Строка);
		//РассчитатьВсего(Строка);
		
		//ФункцииФормДокументов.РассчитатьСуммыСтрокиОтЦены(Строка, СтруктураКолонокТовары, Ложь);
		
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Функция ПересчитатьЦенуСтроки(Цена,стВалюта)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&Цена * (ЕСТЬNULL(стВалюта.Курс, 1) * ЕСТЬNULL(ВалютаПеревода.Кратность, 1)) / (ЕСТЬNULL(ВалютаПеревода.Курс, 1) * ЕСТЬNULL(стВалюта.Кратность, 1)) КАК Цена
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &стВалюта ) КАК стВалюта,
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &ВалютаПеревода) КАК ВалютаПеревода";
	
	Запрос.УстановитьПараметр("Дата", ?(Объект.Дата = Неопределено, ТекущаяДата(),Объект.Дата));
	Запрос.УстановитьПараметр("ВалютаПеревода", Объект.Валюта); 
	Запрос.УстановитьПараметр("стВалюта", стВалюта);
	Запрос.УстановитьПараметр("Цена", Цена);
	
	Результат=Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Окр(Выборка.Цена, 2);
		
	КонецЕсли;
	
	Возврат Цена;
	
КонецФункции

&НаКлиенте
Процедура РассчитатьПроцентАвтоматическойСкидки(Строка)
	
	Строка.ПроцентАвтоматическойСкидки = РаботаСНоменклатурой.ПолучитьПроцентАвтоматическойСкидки(Строка.Номенклатура, Объект.Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЦенуСтроки(Строка)
	
	Если Строка.Пересчет Тогда
		
		//ФункцииФормДокументов.РассчитатьСуммыСтрокиОтЦены(Строка, СтруктураКолонокТовары);
		
		//Строка.Цена = РаботаСНоменклатурой.ПолучитьЦену(Строка.Номенклатура, Объект.ТипЦен, Объект.Валюта,,,,,,,,,,,Объект.СуммаВключаетНДС);
		ПересчитатьВсюСтроку(Строка); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПересчетПриИзменении(Элемент)
	
	ПересчитатьВсюСтроку(Элементы.Товары.ТекущиеДанные);
	Если Элементы.Товары.ТекущиеДанные.пересчет Тогда 
		ОбновитьПодвал(); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ПересчитатьВсюСтроку(Элементы.Товары.ТекущиеДанные);
	ОбновитьПодвал();
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	ПересчитатьВсюСтроку(Элементы.Товары.ТекущиеДанные);
	ОбновитьПодвал();
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыПроцентРучнойСкидкиПриИзменении(Элемент)
	
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	Если ТекСтрока <> Неопределено Тогда
		ФункцииФормДокументов.ПроцентРучнойСкидкиПриИзменении(Элементы.Товары, СтруктураКолонокТовары, ТекСтрока);
		ОбновитьПодвал();КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	Если ТекСтрока.Сумма = 0 И ТекСтрока.Пересчет Тогда
		
		ПоказатьПредупреждение(,"Это бесконечность...",,"E=MC2");
		
	Иначе
		
		Если ТекСтрока.Пересчет Тогда
			//ТекСтрока.Цена = ТекСтрока.Сумма / ТекСтрока.Количество;
			//РассчитатьНДС(ТекСтрока);
			//РассчитатьВсего(ТекСтрока);  
			ФункцииФормДокументов.СуммаПриИзменении(Элементы.Товары, СтруктураКолонокТовары, ТекСтрока);
		
		КонецЕсли;
		ОбновитьПодвал();КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыСуммаРучнойСкидкиПриИзменении(Элемент)
	
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	
	Если ТекСтрока.Пересчет Тогда
		
		ФункцииФормДокументов.СуммаРучнойСкидкиПриИзменении(Элементы.Товары, СтруктураКолонокТовары, ТекСтрока);
		
		
		// Попробуем рассчитать процент
		//
		//ТекСтрока.ПроцентРучнойСкидки = ТекСтрока.СуммаРучнойСкидки / (ТекСтрока.Сумма / 100);
		//
		//// Если обратный пересчет даст не верную сумму тогда отключим автоматический пересчет
		//Если ТекСтрока.Сумма / 100 * ТекСтрока.ПроцентРучнойСкидки  <> ТекСтрока.СуммаРучнойСкидки Тогда
		//	ТекСтрока.Пересчет = Ложь;
		//	ПоказатьОповещениеПользователя("Отключение пересчета",, "При расчете суммы ручной скидки не удалось получить требуюмую сумму, автоматический пересчет отключается"); 
		//Иначе
		//	ПересчитатьВсюСтроку(ТекСтрока);КонецЕсли;
		
		ОбновитьПодвал(); КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСтавкаНДСПриИзменении(Элемент)
	
	ФункцииФормДокументов.СтавкаНДСПриИзменении(Элементы.Товары, СтруктураКолонокТовары);

	//РассчитатьНДС(Элементы.Товары.ТекущиеДанные);
	//ОбновитьПодвал();
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыСуммаНДСПриИзменении(Элемент)
	
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	
	Если ТекСтрока.Пересчет Тогда
		
		//ТекСтрока.Пересчет = Ложь;
		//ПоказатьОповещениеПользователя("Отключение пересчета",, "При расчете суммы НДС вручную отключается автоматический пересчет");
		ФункцииФормДокументов.СуммаНДСПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
		ОбновитьПодвал(); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыВсегоПриИзменении(Элемент)
	
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	
	Если ТекСтрока.Пересчет Тогда
		
		//ТекСтрока.Пересчет = Ложь;
		//ПоказатьОповещениеПользователя("Отключение пересчета",, "При расчете всего вручную отключается автоматический пересчет"); 
		ФункцииФормДокументов.ВсегоПриИзменении(Элементы.Товары, СтруктураКолонокТовары);
		ОбновитьПодвал(); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыАртикулПриИзменении(Элемент)
	
	// Если тип не определен но введн артикул и не определен товар значит это строка
	
	текСтрока = Элементы.Товары.ТекущиеДанные;
	Если Не ПустаяСтрока(текСтрока.Артикул) И текСтрока.Номенклатура = Неопределено Тогда
		текСтрока.Номенклатура = ""; 
		ОбновитьКартинку(текСтрока); КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКартинку(Строка)
	
	Если ТипЗнч(Строка.Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда 	Строка.Картинка = 1;
	ИначеЕсли ТипЗнч(Строка.Номенклатура) = Тип("Строка") Тогда						Строка.Картинка = 2;
	Иначе																			Строка.Картинка = 0; КонецЕсли;
	
КонецПроцедуры
&НаСервере
Функция ПолучитьАртикул(Товар)
	
	Возврат Товар.Артикул;
	
КонецФункции
&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	текСтрока = Элементы.Товары.ТекущиеДанные;
	Если ТипЗнч(текСтрока.Номенклатура) = Тип("СправочникСсылка.Номенклатура") И Не текСтрока.Номенклатура.Пустая() Тогда
		
		ФункцииФормДокументов.НоменклатураПриИзменении(
				Элементы.Товары, 
				СтруктураКолонокТовары, текСтрока);
		
		
		текСтрока.Артикул = ПолучитьАртикул(текСтрока.Номенклатура);
	КонецЕсли;
	
	ОбновитьКартинку(текСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		ТекСтрока = Элемент.ТекущиеДанные;
		ТекСтрока.СтавкаНДС 	= Ставка18;
		ТекСтрока.Количество 	= 1;
		ТекСтрока.Пересчет 		= Истина; КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьНДСПриИзменении(Элемент)
	
	СтруктураКолонокТовары.УчитыватьНДС = Объект.УчитыватьНДС;
	
	Для Каждого Строка Из Объект.Товары Цикл ПересчитатьВсюСтроку(Строка) КонецЦикла;
	ОбновитьПодвал();
	
КонецПроцедуры
&НаКлиенте
Процедура СуммаВключаетНДСПриИзменении(Элемент)
	
	СтруктураКолонокТовары.СуммаВключаетНДС = Объект.СуммаВключаетНДС;
	
	Для Каждого Строка Из Объект.Товары Цикл ПересчитатьВсюСтроку(Строка) КонецЦикла;
	ОбновитьПодвал();
	
КонецПроцедуры


&НаСервере
Функция ПолучитьАртикулыДляВыбора(Текст)
	
	Список = Новый СписокЗначений;
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 5 
	|	1 Картинка, Артикул, Ссылка, &текДата Дата, 0 Цена
	|ИЗ 
	|	Справочник.Номенклатура 
	|ГДЕ 
	|	НЕ ПометкаУдаления И 
	|	Артикул ПОДОБНО """ + Текст + "%"" 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 5 
	|	МАКСИМУМ(2) Картинка, Артикул, Номенклатура, МАКСИМУМ(Ссылка.Дата) Дата, МАКСИМУМ(ЦЕна)
	|ИЗ 
	|	Документ.КоммерческоеПредложение.Товары 
	|ГДЕ 
	|	НЕ Ссылка.ПометкаУдаления И 
	|	ТИПЗНАЧЕНИЯ(Номенклатура) = ТИП(СТРОКА) И 
	|	Артикул ПОДОБНО """ + Текст + "%""
	|
	|СГРУППИРОВАТЬ ПО
	|	Артикул, Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО Дата Убыв
	|");
	
	Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл Список.Добавить(Новый Структура("Артикул, Номенклатура, Цена", Выборка.Артикул, Выборка.Ссылка, Выборка.Цена), "[" + Выборка.Артикул + "] " + Выборка.Ссылка,,?(Выборка.Картинка = 1, БиблиотекаКартинок.ТоварВКоммПр, БиблиотекаКартинок.ТекстВКоммПр)) КонецЦикла;
	
	Возврат Список;
	
КонецФункции
&НаКлиенте
Процедура ТоварыАртикулАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Текст) Тогда Текст = Элементы.Товары.ТекущиеДанные.Артикул КонецЕсли;
	СтандартнаяОбработка = ПустаяСтрока(Текст);
	
	Если Не ПустаяСтрока(Текст) Тогда
		ДанныеВыбора = ПолучитьАртикулыДляВыбора(Текст); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыАртикулОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	ЗаполнитьЗначенияСвойств(ТекСтрока, ВыбранноеЗначение);
	ТоварыНоменклатураПриИзменении(Элемент);
	ОбновитьКартинку(текСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	// Если изменили текст номенклатуры значит это теперь строка
	
	текСтрока = Элементы.Товары.ТекущиеДанные;
	Если ТипЗнч(текСтрока.Номенклатура) = Тип("СправочникСсылка.Номенклатура")  Тогда
		текСтрока.Номенклатура = Текст;
		ОбновитьКартинку(текСтрока); КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПохожийТовар(Артикул, Наименование)
	
	текАртикул 		= СтрЗаменить(Артикул, """", """""");
	текНаименование = СтрЗаменить(Наименование, """", """""");
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка, ПометкаУдаления, 1 Порядок
	|ИЗ Справочник.Номенклатура 
	|ГДЕ ИСТИНА " + ?(ПустаяСтрока(текАртикул), ""," И Артикул = """ + текАртикул + """") + ?(ПустаяСтрока(текНаименование), "", " И Наименование = """ + текНаименование + """") + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка, ПометкаУдаления, 2
	|ИЗ Справочник.Номенклатура 
	|ГДЕ ИСТИНА " + ?(ПустаяСтрока(текАртикул), ""," И Артикул = """ + текАртикул + """") + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка, ПометкаУдаления, 3
	|ИЗ Справочник.Номенклатура 
	|ГДЕ ИСТИНА " + ?(ПустаяСтрока(текНаименование), "", " И Наименование = """ + текНаименование + """") + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка, ПометкаУдаления, 4
	|ИЗ Справочник.Номенклатура 
	|ГДЕ ИСТИНА " + ?(ПустаяСтрока(Артикул), ""," И Артикул ПОДОБНО ""%" + текАртикул + "%""") + ?(ПустаяСтрока(текНаименование), ""," И Наименование ПОДОБНО ""%" + текНаименование + "%""") + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка, ПометкаУдаления, 5
	|ИЗ Справочник.Номенклатура 
	|ГДЕ ИСТИНА " + ?(ПустаяСтрока(Артикул), ""," И Артикул ПОДОБНО ""%" + текАртикул + "%""") + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка, ПометкаУдаления, 6
	|ИЗ Справочник.Номенклатура 
	|ГДЕ ИСТИНА " + ?(ПустаяСтрока(текНаименование), ""," И Наименование ПОДОБНО ""%" + текНаименование + "%""") + "
	|
	|УПОРЯДОЧИТЬ ПО ПометкаУдаления, Порядок
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
			Возврат Выборка.Ссылка;
	Иначе	Возврат Справочники.Номенклатура.ПустаяСсылка(); КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВыбранТовар(ВыбТовар, ДопПараметры) Экспорт
	
	Если ВыбТовар <> Неопределено Тогда
		
		текСтрока = Элементы.Товары.ТекущиеДанные;
		текСтрока.Номенклатура = ВыбТовар; 
		
		ТоварыНоменклатураПриИзменении(Элементы.ТоварыНоменклатура); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ОнВыбралКтоЭто(ВыбЭлемент, ДопПараметры) Экспорт
	
	Если ВыбЭлемент <> Неопределено Тогда
		
		ТекСтрока = Элементы.Товары.ТекущиеДанные;
		
		Если ВыбЭлемент.Значение = "Товар" Тогда
			
			Если ТипЗнч(ТекСтрока.Номенклатура) = Тип("Строка") И Не ПустаяСтрока(ТекСтрока.Номенклатура) Тогда
				ТекСтрока.Номенклатура = ПолучитьПохожийТовар(ТекСтрока.Артикул, ТекСтрока.Номенклатура);
			ИначеЕсли ТипЗнч(ТекСтрока.Номенклатура) <> Тип("СправочникСсылка.Номенклатура") Тогда
				ТекСтрока.Номенклатура = ПустойТовар(); КонецЕсли;
			
			ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", Новый Структура("ТекущаяСтрока", ТекСтрока.Номенклатура),ЭтаФорма,,,,Новый ОписаниеОповещения("ВыбранТовар", ЭтаФорма));
			
		Иначе
			ТекСтрока.Номенклатура = Строка(ТекСтрока.Номенклатура); КонецЕсли;
		
		ОбновитьКартинку(ТекСтрока); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	текТовар = Элементы.Товары.ТекущиеДанные.Номенклатура;
	Если ТипЗнч(текТовар) = Тип("СправочникСсылка.Номенклатура") И Не текТовар.Пустая() Тогда
		ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", Новый Структура("ТекущаяСтрока", текТовар),ЭтаФорма,,,,Новый ОписаниеОповещения("ВыбранТовар", ЭтаФорма));
		
	Иначе
			
		Список = Новый СписокЗначений;
		Список.Добавить("Товар", "Это товар",, БиблиотекаКартинок.ТоварВКоммПр);
		Список.Добавить("Текст", "Это текст",, БиблиотекаКартинок.ТекстВКоммПр);
		
		ПоказатьВыборИзМеню(Новый ОписаниеОповещения("ОнВыбралКтоЭто", ЭтаФорма, Новый Структура("Элемент", Элемент)), Список, Элемент); КонецЕсли;
	
КонецПроцедуры



#КонецОбласти

#Область Изменение_шапки

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	ФункцииФормДокументов.ОрганизацияПриИзменении(Объект);
	
КонецПроцедуры
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
	СтруктураКолонокТовары.УчитыватьНДС = Объект.УчитыватьНДС;
	
	Для Каждого Строка Из Объект.Товары Цикл ПересчитатьВсюСтроку(Строка) КонецЦикла;
	ОбновитьПодвал();
	
КонецПроцедуры


&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Для Каждого Строка Из Объект.Товары Цикл 
		ПересчитатьВсюСтроку(Строка)
	КонецЦикла;
	ОбновитьПодвал();
	
КонецПроцедуры


&НаКлиенте
Процедура ПересчитатьЦеныОтвет(Ответ, ДопПараметры) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Да Тогда 
		
		СтруктураКолонокТовары.ТипЦен= Объект.ТипЦен;
		СтруктураКолонокТовары.Валюта= Объект.Валюта;
        СтруктураКолонокТовары.УчитыватьНДС= Объект.УчитыватьНДС;
		СтруктураКолонокТовары.СуммаВключаетНДС= Объект.СуммаВключаетНДС;
		
		ПересчитатьЦеныТоваров() КонецЕсли
	
КонецПроцедуры
&НаКлиенте
Процедура ПересчитатьЦеныВопрос()
	
	// Узнаем стоит или нет задавать подобные вопросы
	
	ТипТовар = Тип("СправочникСсылка.Номенклатура");
	Для Каждого Строка Из Объект.Товары Цикл
		Если Строка.Пересчет 
			//И ТипЗнч(Строка.Номенклатура) = ТипТовар 
			Тогда
			ПоказатьВопрос(Новый ОписаниеОповещения("ПересчитатьЦеныОтвет", ЭтаФорма), "Пересчитать цены?", РежимДиалогаВопрос.ДаНет,,,"Пересчет цен");
			Прервать; КонецЕсли; КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Процедура ТипЦенПриИзменении(Элемент)
	
	ПересчитатьЦеныВопрос()
	
КонецПроцедуры
&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	ПересчитатьЦеныВопрос()
	
КонецПроцедуры

#КонецОбласти

#Область Прикрепленные_файлы

&НаКлиенте
Процедура УдалитьПрикрепленныеФайлыНажатие(Элемент)
	
	ПрикрепленныеФайлыКлиент.УдалитьНажатие(Объект.Ссылка, ЭтаФорма, Элемент);
	
КонецПроцедуры
&НаКлиенте
Процедура ПрикрепленныеФайлыНажатиеСкрепка(Элемент)
	
	ПрикрепленныеФайлыКлиент.НажатиеСкрепка(Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПрикрепленныйФайл(Элемент)
	
	ПрикрепленныеФайлыКлиент.ОткрытьПрикрепленныйФайл(Элемент.Имя);
	
КонецПроцедуры
&НаКлиенте
Процедура ПоказатьПрикрееленныеФайлы(Элемент)
	
	ПрикрепленныеФайлыКлиент.ПоказатьПрикрепленныеФайлы(Объект.Ссылка, ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьПрикрепленныхФайловНаСервере()
	
	ПрикрепленныеФайлы.Иницилизировать(Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры
&НаКлиенте
Процедура ОбновитьВидимостьПрикрепленныхФайлов() Экспорт
	
	ОбновитьВидимостьПрикрепленныхФайловНаСервере();
	
КонецПроцедуры


#КонецОбласти

&НаКлиенте
Процедура ВсемПересчет(Команда)
	
	Для Каждого Строка Из Объект.Товары Цикл Строка.Пересчет = Истина; ПересчитатьВсюСтроку(Строка); КонецЦикла;
	ОбновитьПодвал();
	
КонецПроцедуры
&НаКлиенте
Процедура УбратьПересчет(Команда)
	
	Для Каждого Строка Из Объект.Товары Цикл Строка.Пересчет = Ложь КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранНДС(ВыбНДС, ДопПараметры) Экспорт
	
	Если ВыбНДС <> Неопределено Тогда
		Для Каждого Строка Из Объект.Товары Цикл Строка.СтавкаНДС = ВыбНДС;
			ФункцииФормДокументов.СтавкаНДСПриИзменении(Элементы.Товары, СтруктураКолонокТовары, Строка);
			//РассчитатьНДС(Строка); РассчитатьВсего(Строка); 
			КонецЦикла; 
		ОбновитьПодвал();КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ИзменитьСтавкуНДС(Команда)
	
	ОткрытьФорму("Перечисление.СтавкиНДС.ФормаВыбора",,ЭтаФорма,,,,Новый ОписаниеОповещения("ВыбранНДС", ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура ВведенаСкидкаДляВсех(ВведЧисло, ДопПараметры) Экспорт
	
	Если ВведЧисло <> Неопределено Тогда
		
		Для Каждого Строка Из Объект.Товары Цикл 
			Строка.ПроцентРучнойСкидки = ВведЧисло;
		//	РассчитатьСумму(Строка);
		//	РассчитатьНДС(Строка);
		//	РассчитатьВсего(Строка); 		
			ФункцииФормДокументов.ПроцентРучнойСкидкиПриИзменении(
					Объект.Товары, 
					СтруктураКолонокТовары, 
					Строка);
		
		КонецЦикла;

		ОбновитьПодвал(); КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура УстановитьСкидку(Команда)
	
	ПоказатьВводЧисла(Новый ОписаниеОповещения("ВведенаСкидкаДляВсех", ЭтаФорма), 1,"Скидка:", 3, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПодвал()

	Сумма = 0; СуммаНДС = 0; Всего = 0; Скидка = 0; СуммаБезСкидки = 0;
	Для Каждого Строка Из Объект.Товары Цикл Сумма = Сумма + Строка.Сумма; Скидка = Скидка + Строка.СуммаРучнойСкидки + Строка.СуммаАвтоматическойСкидки; СуммаНДС = СуммаНДС + Строка.СуммаНДС; Всего = Всего + Строка.Всего; СуммаБезСкидки = СуммаБезСкидки + Строка.Всего - Строка.СуммаРучнойСкидки - Строка.СуммаАвтоматическойСкидки;КонецЦикла;
	
	ЦветСиний = Новый Цвет(0,0,255);
	
	Строки = Новый Массив;
	Строки.Добавить(Новый ФорматированнаяСтрока("Поз: "));
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Объект.Товары.Количество()) + " ",,ЦветСиний));
	Строки.Добавить(Новый ФорматированнаяСтрока("Сумма: "));
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Сумма) + " ",,ЦветСиний));
	Строки.Добавить(Новый ФорматированнаяСтрока("Сумма НДС: "));
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(СуммаНДС) + " ",,ЦветСиний));
	Строки.Добавить(Новый ФорматированнаяСтрока("Всего: "));
	Если Скидка Тогда Строки.Добавить(Новый ФорматированнаяСтрока("(" + СуммаБезСкидки + " - " + Скидка + ") = ")) КонецЕсли;
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Всего), Новый Шрифт(,,12,Истина), ЦветСиний));
	Строки.Добавить(Новый ФорматированнаяСтрока(" " + Объект.Валюта));
	
	Элементы.ИнфСтрока.Заголовок = Новый ФорматированнаяСтрока(Строки);
	
КонецПроцедуры
&НаСервере
Процедура ОбновитьПодвалНаСервере()

	Сумма = 0; СуммаНДС = 0; Всего = 0;
	Для Каждого Строка Из Объект.Товары Цикл Сумма = Сумма + Строка.Сумма; СуммаНДС = СуммаНДС + Строка.СуммаНДС; Всего = Всего + Строка.Всего; КонецЦикла;
	
	ЦветСиний = Новый Цвет(0,0,255);
	
	Строки = Новый Массив;
	Строки.Добавить(Новый ФорматированнаяСтрока("Поз: "));
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Объект.Товары.Количество()) + " ",,ЦветСиний));
	Строки.Добавить(Новый ФорматированнаяСтрока("Сумма: "));
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Сумма) + " ",,ЦветСиний));
	Строки.Добавить(Новый ФорматированнаяСтрока("Сумма НДС: "));
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(СуммаНДС) + " ",,ЦветСиний));
	Строки.Добавить(Новый ФорматированнаяСтрока("Всего: "));
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Всего), Новый Шрифт(,,12,Истина), ЦветСиний));
	
	Элементы.ИнфСтрока.Заголовок = Новый ФорматированнаяСтрока(Строки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВведеноНаличие(ВведНаличие, ДопПараметры) Экспорт
	
	Если ВведНаличие <> Неопределено Тогда
		Для Каждого Строка Из Объект.Товары Цикл Строка.Наличие = ВведНаличие КонецЦикла; 
		Модифицированность = Истина; КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура УстановитьНаличие(Команда)
	
	ПоказатьВводСтроки(Новый ОписаниеОповещения("ВведеноНаличие", ЭтаФорма),,"Что написать:");
	
КонецПроцедуры


&НаКлиенте
Процедура ЗагрузитьДанныеТабличногоДокумента(Команда)
	
	ОткрытьФорму("Документ.КоммерческоеПредложение.Форма.ЗагрузкаИзТаблицы", Новый Структура("СсылкаКП", Объект.Ссылка), Элементы.Товары);
	  
КонецПроцедуры

