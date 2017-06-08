﻿
Функция ПолучитьТекНарядНаЗагрузку(Автомобиль) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Документ.НарядНаЗагрузку ГДЕ ТранспортноеСредство = &Автомобиль И Не Проведен И НЕ ПометкаУдаления");
	Запрос.УстановитьПараметр("Автомобиль", Автомобиль);
	Выполнение = Запрос.Выполнить();
	
	Если Не Выполнение.Пустой() Тогда
		
		Выборка = Выполнение.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка; КонецЕсли;
	
КонецФункции

Функция ВыделитьЗаказыИзБПиДокументов(массив)
	
	// Делает чтобы в массиве были токо заказы
	
	новМассив = Новый Массив;
	
	метаДокументы 	= Метаданные.Документы;
	ТипЗаказНаряд 	= Тип("БизнесПроцессСсылка.РемонтИнструмента");
	ЗаказВПоле 		= массив.Количество() И ТипЗнч(массив[0]) = Тип("РегистрСведенийКлючЗаписи.ЗаказыЖурнал");
	
	Для Каждого Элемент Из массив Цикл 
		
		Объект = ?(ЗаказВПоле, Элемент.Заказ, Элемент);
		
		Если ЗаказВПоле Тогда 											новМассив.Добавить(Элемент.Заказ);
		ИначеЕсли метаДокументы.Содержит(Элемент.Метаданные()) Тогда 	новМассив.Добавить(Элемент) 
		ИначеЕсли ТипЗнч(Элемент) = ТипЗаказНаряд Тогда 				новМассив.Добавить(Элемент.ЗаказНаряд) 
		Иначе 															новМассив.Добавить(Элемент.Заказ) КонецЕсли; КонецЦикла;
	
	Возврат новМассив;
	
КонецФункции

Функция ВычислитьВесЗаказов(токоЗаказы)
	
	// Возвращает таблицу в которой заказы и не отгруженные реализации с весом и объекмом
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Заказ,
	|	ДокументОтгрузки,
	|	ВесПодготовленоОборот - ВесОтгруженоОборот ВесОтгружено,
	|	ОбъемПодготовленоОборот - ОбъемОтгруженоОборот ОбъемОтгружено
	|ИЗ
	|	РегистрНакопления.ОтгруженныеЗаказы.Обороты(,,,Заказ В(&Заказы) И ДокументОтгрузки <> НЕОПРЕДЕЛЕНО)
	|");
	
	Запрос.УстановитьПараметр("Заказы", токоЗаказы);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ОчиститьМашину(Автомобиль, ЗаказыОтправлены, НарядСсылка = Неопределено) Экспорт
	
	// ЗаказыОтправлены - булево, говорит что заказы отправлены, а не просто очищены
	// НарядСсылка - если передать сюда ссылку тогда не будет поиск по документам а сразу работа с данным документам
	//				а если не передавать тогда в эту переменную вернется ссылка на документ
	
	Если НарядСсылка = Неопределено Тогда
	
		НарядСсылка = ПолучитьТекНарядНаЗагрузку(Автомобиль);
		Если НарядСсылка = Неопределено Тогда
			ОбщиеФункции.СообщитьТекст("Автомобиль пустой!");
			Возврат Ложь; КонецЕсли; КонецЕсли;
	
	// Заполним
	
	Док = НарядСсылка.ПолучитьОбъект();
	Док.ЗаказыОтправлены = ЗаказыОтправлены;
	
	// Запишем в журнал заказов
	
	Для Каждого Строка Из Док.ТабЗаказов Цикл Заказы.УстановитьРеквизитЖурнала(Строка.Заказ, Новый Структура("ТранспортноеСредство", Справочники.ТранспортныеСредства.ПустаяСсылка())) КонецЦикла;

	// Проведем документ
	
	Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Док, РежимЗаписиДокумента.Проведение);
	
КонецФункции


Функция ПолучитьВыборкуИнформациюОЗагрузке(ДокСсылка)
	
	Запрос = Новый Запрос("ВЫБРАТЬ КОЛИЧЕСТВО(Заказ) Заказов, СУММА(Места) Мест, СУММА(Вес) Вес ИЗ Документ.НарядНаЗагрузку.ТабЗаказов ГДЕ Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", ДокСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;
	
КонецФункции

Функция ДобавитьЗаказы(Автомобиль, Знач массЗаказов, ДокСсылка = Неопределено, стрСообщения = "") Экспорт
	
	Если Не массЗаказов.Количество() Тогда
		ОбщиеФункции.СообщитьТекст("Нет заказов для добавления!");
		Возврат Ложь; КонецЕсли;
	
	// Найдем есть пустой документ или нема
	
	НарядСсылка = ПолучитьТекНарядНаЗагрузку(Автомобиль);
	
	Если НарядСсылка = Неопределено Тогда
		
		Док = Документы.НарядНаЗагрузку.СоздатьДокумент();
		Док.ТранспортноеСредство 	= Автомобиль;
		Док.Водитель				= Автомобиль.ОсновнойВодитель;
		Док.Дата = ТекущаяДата();

	Иначе 
		Док = НарядСсылка.ПолучитьОбъект(); КонецЕсли;
	
	// Добавим заказы
	
	КолДоб = 0;
	
	токоЗаказы = ВыделитьЗаказыИзБПиДокументов(массЗаказов);

	Для Каждого ТекЗаказ Из токоЗаказы Цикл Если Док.ТабЗаказов.Найти(ТекЗаказ, "Заказ") = Неопределено Тогда ДобавитьДанныеПоЗаказу(Док, Док.ТабЗаказов.Добавить(), Ложь, ТекЗаказ); КолДоб = КолДоб + 1; КонецЕсли; КонецЦикла;
	
	//ТабЗаказов = ВычислитьВесЗаказов(токоЗаказы);
	//ПредЗаказы = Док.ТабЗаказов.Выгрузить();
	//Для каждого Строка Из ТабЗаказов Цикл Если ПредЗаказы.Найти(Строка.Заказ, "Заказ") = Неопределено Тогда ЗаполнитьЗначенияСвойств(Док.ТабЗаказов.Добавить(), Строка); КолДоб = КолДоб + 1; КонецЕсли; КонецЦикла;
	
	// Запишем
	
	Если КолДоб И Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Док) Тогда Возврат Ложь КонецЕсли;
	
	ДокСсылка = Док.Ссылка;
	
	// Запишем в журнал заказов
	
	Для Каждого Заказ Из токоЗаказы Цикл Заказы.УстановитьРеквизитЖурнала(Заказ, Новый Структура("ТранспортноеСредство", Автомобиль)) КонецЦикла;
	
	// Посчитаем скоко там чего чтобы вывести красивое сооющение
	
	Выборка = ПолучитьВыборкуИнформациюОЗагрузке(Док.Ссылка);
	
	стрСообщения = ?(КолДоб,
						"Добавлено " + КолДоб + ". Заказов в машине:" + Выборка.Заказов,
						"Заказ не добавлен (был отгружен раньше, или на него нет реализации, или он уже в машине). Заказов в машине:" + Выборка.Заказов);
	Возврат Истина;
	
КонецФункции
Функция УдалитьЗаказы(Автомобиль, Знач массЗаказов, ДокСсылка = Неопределено, стрСообщения = "") Экспорт
	
	Если Не массЗаказов.Количество() Тогда
		ОбщиеФункции.СообщитьТекст("Нет заказов для удаления!");
		Возврат Ложь; КонецЕсли;
	
	// Найдем есть пустой документ или нема
	
	НарядСсылка = ПолучитьТекНарядНаЗагрузку(Автомобиль);
	
	Если НарядСсылка = Неопределено Тогда
		
		ОбщиеФункции.СообщитьТекст("Машина пустая, удалять нечего!");
		Возврат Ложь; КонецЕсли;
		
	Док = НарядСсылка.ПолучитьОбъект();
	
	// Добавим заказы
	
	КолУд = 0;
	токоЗаказы = ВыделитьЗаказыИзБПиДокументов(массЗаказов);
	ТЗЗаказов 		= Док.ТабЗаказов.Выгрузить();
	новТЗЗаказов 	= ТЗЗаказов.СкопироватьКолонки();
	Для Каждого Строка Из ТЗЗаказов Цикл Если токоЗаказы.Найти(Строка.Заказ) = Неопределено Тогда новТЗЗаказов.Добавить().Заказ = Строка.Заказ Иначе КолУд = КолУд + 1 КонецЕсли; КонецЦикла;
	Док.ТабЗаказов.Загрузить(новТЗЗаказов);
	
	// Запишем
	
	Если КолУд И Не ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(Док) Тогда Возврат Ложь КонецЕсли;
	
	ДокСсылка = Док.Ссылка;
	
	// Запишем в журнал заказов
	
	Для Каждого Заказ Из токоЗаказы Цикл Заказы.УстановитьРеквизитЖурнала(Заказ, Новый Структура("ТранспортноеСредство", Справочники.ТранспортныеСредства.ПустаяСсылка())) КонецЦикла;

	// Посчитаем скоко там чего чтобы вывести красивое сооющение
	
	Выборка = ПолучитьВыборкуИнформациюОЗагрузке(Док.Ссылка);
	
	стрСообщения = ?(КолУд,
						"Удалено " + КолУд + ". Заказов в машине:" + Выборка.Заказов,
						"нечего удалять. Заказов в машине:" + Выборка.Заказов);
	Возврат Истина;
	
КонецФункции

Функция ПолучитьСписокАвтомобилейДляЗагрузки() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ 	Ссылка Автомобиль, Наименование, ЕСТЬNULL(Заказов, 0) Заказов, ЕСТЬNULL(Мест, 0) Мест, ЕСТЬNULL(Вес, 0) Вес
	|ИЗ 		Справочник.ТранспортныеСредства Спр
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|(	ВЫБРАТЬ Ссылка.ТранспортноеСредство ТранспортноеСредство, КОЛИЧЕСТВО(Заказ) Заказов, СУММА(Места) Мест, СУММА(Вес) Вес
	|	ИЗ Документ.НарядНаЗагрузку.ТабЗаказов
	|	ГДЕ НЕ Ссылка.ПометкаУдаления И Не Ссылка.Проведен
	|	СГРУППИРОВАТЬ ПО Ссылка
	|) Загр
	|ПО
	|	Спр.Ссылка = Загр.ТранспортноеСредство
	|
	|УПОРЯДОЧИТЬ ПО
	|	Спр.Наименование
	|");
	
	Список 	= Новый СписокЗначений;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл Список.Добавить(Выборка.Автомобиль, Выборка.Наименование + " " + Выборка.Автомобиль.ГосНомер + ?(Выборка.Заказов, " (зак:" + Выборка.Заказов + "; мест:" + Выборка.Мест + "; вес:" + Выборка.Вес + ";)", " (пустой)") + " Водитель: "+Выборка.Автомобиль.ОсновнойВодитель); КонецЦикла;
	
	Возврат Список;
	
КонецФункции

Функция ПолучитьПоследнийДокументОтгрузки(Заказ,Склад) Экспорт
	ТекстЗапроса = "ВЫБРАТЬ
	                      |	РеализацияТоваров.Заказ,
	                      |	РеализацияТоваров.Ссылка КАК Реализация,
	                      |	РеализацияТоваров.Дата КАК Дата
	                      |ИЗ
	                      |	Документ.РеализацияТоваров КАК РеализацияТоваров
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДокументовОтгрузки.СрезПоследних КАК СостоянияДокументовОтгрузкиСрезПоследних
	                      |		ПО РеализацияТоваров.Ссылка = СостоянияДокументовОтгрузкиСрезПоследних.ДокументОтгрузки
	                      |			И (СостоянияДокументовОтгрузкиСрезПоследних.Состояние В (ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.Отправлен), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.ОтправленЧастично), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.Доставлен), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.ДоставленЧастично)))
	                      |ГДЕ
	                      |	РеализацияТоваров.Проведен
	                      |	И РеализацияТоваров.Заказ = &Заказ
	                      |	И СостоянияДокументовОтгрузкиСрезПоследних.Состояние ЕСТЬ NULL
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Дата УБЫВ";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Заказ",Заказ);
	Результат = Запрос.Выполнить();
	Док = "реализаций";
	Если Результат.Пустой() Тогда
		Запрос.Текст = СтрЗаменить(ТекстЗапроса,"Документ.РеализацияТоваров","Документ.ПередачаТовара");
		Результат = Запрос.Выполнить();
		Док = "передач товара";
	КонецЕсли;
	Если Результат.Пустой() Тогда
		Запрос.Текст = СтрЗаменить(ТекстЗапроса,"Документ.РеализацияТоваров","Документ.ЗаказНаПеремещение");
		Если ЗначениеЗаполнено(Склад) Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст,"РеализацияТоваров.Проведен","РеализацияТоваров.Проведен И РеализацияТоваров.СкладОтправитель = &Склад");
			Запрос.УстановитьПараметр("Склад",Склад);
		КонецЕсли;
		Результат = Запрос.Выполнить();
		Док = "заказов на перемещение";
	КонецЕсли;
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Выборка = Результат.Выбрать();
	Если Выборка.Количество()>1 Тогда
		Сообщить("Внимание! По заказу №"+Заказ.Номер+" есть "+Выборка.Количество()+" "+Док+" с неотправленным и неотгруженным товаром.");
	КонецЕсли;
	Выборка.Следующий();
	Возврат Выборка.Реализация;
КонецФункции


Процедура ДобавитьДанныеПоЗаказу(НарядНаЗагрузку,ТекСтрока,ТСД,Заказ = Неопределено) Экспорт
	Если ЗначениеЗаполнено(Заказ) Тогда
		ТекСтрока.Заказ = Заказ;
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекСтрока.Заказ)	Тогда
		ТекСтрока.Контрагент 				= ?(Метаданные.ОбщиеРеквизиты.Контрагент.Состав.Найти(ТекСтрока.Заказ.Метаданные()).Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать,ТекСтрока.Заказ.Контрагент,Справочники.Контрагенты.ПустаяСсылка());
		ТекСтрока.ДокументОтгрузки 			= ПолучитьПоследнийДокументОтгрузки(ТекСтрока.Заказ,НарядНаЗагрузку.МестоОтгрузки);
		//ТекСтрока.ДокументОтгрузки 			= ПолучитьПоследнююРеализацию(ТекСтрока.Заказ);
		//Если НЕ ЗначениеЗаполнено(ТекСтрока.ДокументОтгрузки) Тогда
		//	ТекСтрока.ДокументОтгрузки		= ПолучитьПоследнююПередачуТовара(ТекСтрока.Заказ);
		//КонецЕсли;
		//Если НЕ ЗначениеЗаполнено(ТекСтрока.ДокументОтгрузки) Тогда
		//	ТекСтрока.ДокументОтгрузки		= ПолучитьПоследнийЗаказНаПеремещение(ТекСтрока.Заказ);
		//КонецЕсли;
		ДобавитьДанныеПоСборочнику(НарядНаЗагрузку,ТекСтрока);
		//ПС = ПолучитьПоследнийСборочныйЛист(ТекСтрока.Заказ);
		ТекСтрока.ВесОтгружено 				= 0;
		ТекСтрока.ОбъемОтгружено 			= 0;
		ТекСтрока.Комментарий 				= ФункцииБизнесПроцессов.ПолучитьКомментарийЗаказа(ТекСтрока.Заказ);
		ЗаполнитьКонтактныеДанные(ТекСтрока);
		Если ТСД Тогда
			ТипыПечатаемыхДокументов = Новый Массив;
			ТипыПечатаемыхДокументов.Добавить(Перечисления.ТипыПечатаемыхДокументов.УПД);
			ТипыПечатаемыхДокументов.Добавить(Перечисления.ТипыПечатаемыхДокументов.СчетФактура);
			ТипыПечатаемыхДокументов.Добавить(Перечисления.ТипыПечатаемыхДокументов.АктПриемаПередачи);
			ТекСтрока.ТСД = ?(ЗначениеЗаполнено(ПечатьНаСервере.ПолучитьПоследнююПечать(ТекСтрока.Заказ,ТипыПечатаемыхДокументов,?(ЗначениеЗаполнено(ТекСтрока.ДокументОтгрузки),ТекСтрока.ДокументОтгрузки,Неопределено))),Истина,Ложь);
			ТекСтрока.Состояние = Неопределено;
			Если ЗначениеЗаполнено(ТекСтрока.ДокументОтгрузки) Тогда
				ТекСтрока.Состояние = Заказы.ПолучитьСостояниеДокументаОтгрузки(ТекСтрока.ДокументОтгрузки);
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(ТекСтрока.Состояние) Тогда
				ТекСтрока.Состояние = Заказы.ПолучитьСостояниеЗаказа(ТекСтрока.Заказ);
			КонецЕсли;
		КонецЕсли;
	Иначе
		ТекСтрока.Контрагент 				= Справочники.Контрагенты.ПустаяСсылка();
		ТекСтрока.ДокументОтгрузки 			= Неопределено;
		ТекСтрока.Места 					= 0;
		ТекСтрока.Вес 						= 0;
		ТекСтрока.Объем 					= 0;
		ТекСтрока.Грузоперевозчик 			= Справочники.Контрагенты.ПустаяСсылка();
		ТекСтрока.ВесОтгружено 				= 0;
		ТекСтрока.ОбъемОтгружено 			= 0;
		ТекСтрока.ЯчейкаХраненияЗаказа 		= "";
		//ТекСтрока.Состояние 				= Перечисления.СостоянияЗаказа.ПустаяСсылка();
		ТекСтрока.АдресДоставки 			= "";
		ТекСтрока.КонтактноеЛицо 			= Справочники.КонтактныеЛица.ПустаяСсылка();
		ТекСтрока.ТелефонКонтактногоЛица	= "";
		ТекСтрока.ВариантДоставки 			= Перечисления.ВариантДоставки.ПустаяСсылка();
		ТекСтрока.ЗаЧейСчетДоставка 		= Перечисления.ЗаЧейСчетДоставка.ПустаяСсылка();
		ТекСтрока.Комментарий 				= "";
		Если ТСД Тогда
			ТекСтрока.ТСД = Ложь;
			ТекСтрока.Состояние = Неопределено;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьКонтактныеДанные(ТекСтрока) Экспорт
	ТекСтрока.АдресДоставки 			= "";
	ТекСтрока.КонтактноеЛицо 			= Неопределено;
	ТекСтрока.ТелефонКонтактногоЛица	= "";
	ТекСтрока.ВариантДоставки 			= Перечисления.ВариантДоставки.ПустаяСсылка();
	ТекСтрока.ЗаЧейСчетДоставка 		= Перечисления.ЗаЧейСчетДоставка.ПустаяСсылка();
	ТекСтрока.Грузоперевозчик 			= Справочники.Контрагенты.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(ТекСтрока.ДокументОтгрузки) И ТипЗнч(ТекСтрока.ДокументОтгрузки) = Тип("ДокументСсылка.ЗаказНаПеремещение") Тогда
		Если ЗначениеЗаполнено(ТекСтрока.ДокументОтгрузки.СкладПолучатель) Тогда
			ТекСтрока.ВариантДоставки 			= ТекСтрока.ДокументОтгрузки.СкладПолучатель.ВариантДоставки;
			ТекСтрока.Грузоперевозчик 			= ТекСтрока.ДокументОтгрузки.СкладПолучатель.Грузоперевозчик;
			ТекСтрока.АдресДоставки 			= ТекСтрока.ДокументОтгрузки.СкладПолучатель.АдресДоставки;
			ТекСтрока.КонтактноеЛицо 			= ТекСтрока.ДокументОтгрузки.СкладПолучатель.КонтактноеЛицо;
			ТекСтрока.ТелефонКонтактногоЛица	= ТекСтрока.ДокументОтгрузки.СкладПолучатель.ТелефонКонтактногоЛицаДоставки;
			ТекСтрока.ЗаЧейСчетДоставка 		= Перечисления.ЗаЧейСчетДоставка.ЗаНаш;
		КонецЕсли;
	Иначе
		Если ТипЗнч(ТекСтрока.Заказ) = Тип("ДокументСсылка.ИнтернетЗаказПокупателя") Тогда
			ТекСтрока.АдресДоставки 			= ТекСтрока.Заказ.АдресДоставкиНов;
			ТекСтрока.КонтактноеЛицо 			= ТекСтрока.Заказ.КонтактноеЛицоДоставки;
			ТекСтрока.ТелефонКонтактногоЛица	= ТекСтрока.Заказ.ТелефонКонтактногоЛицаДоставки;
			ТекСтрока.ВариантДоставки 			= ТекСтрока.Заказ.ВариантДоставкиНов;
			ТекСтрока.ЗаЧейСчетДоставка 		= ТекСтрока.Заказ.ЗаЧейСчетДоставка;
			ТекСтрока.Грузоперевозчик 			= ТекСтрока.Заказ.Грузоперевозчик;
		ИначеЕсли ТипЗнч(ТекСтрока.Заказ) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			ТекСтрока.АдресДоставки 			= ТекСтрока.Заказ.АдресДоставкиНов;
			ТекСтрока.КонтактноеЛицо 			= ТекСтрока.Заказ.КонтактноеЛицо;
			ТекСтрока.ТелефонКонтактногоЛица	= ТекСтрока.Заказ.ТелефонКонтактногоЛицаДоставки;
			ТекСтрока.ВариантДоставки 			= ТекСтрока.Заказ.ВариантДоставкиНов;
			ТекСтрока.ЗаЧейСчетДоставка 		= ТекСтрока.Заказ.ЗаЧейСчетДоставка;
			ТекСтрока.Грузоперевозчик 			= ТекСтрока.Заказ.Грузоперевозчик;
		ИначеЕсли ТипЗнч(ТекСтрока.Заказ) = Тип("ДокументСсылка.ВнутреннийЗаказ") Тогда
			Если ТипЗнч(ТекСтрока.Заказ.Заказчик) = Тип("СправочникСсылка.Склады") Тогда
				ТекСтрока.АдресДоставки 		= ТекСтрока.Заказ.Заказчик.Адрес;
			ИначеЕсли ТипЗнч(ТекСтрока.Заказ.Заказчик) = Тип("БизнесПроцессСсылка.СборкаЗаказа") Тогда
				ТекСтрока.АдресДоставки 		= ТекСтрока.Заказ.Заказчик.Склад.Адрес;
			Иначе
				ТекСтрока.АдресДоставки 		= "";
			КонецЕсли;
			ТекСтрока.КонтактноеЛицо 			= "ГаражТулс";
			ТекСтрока.ТелефонКонтактногоЛица	= "";
			ТекСтрока.ВариантДоставки 			= Перечисления.ВариантДоставки.ПустаяСсылка();
			ТекСтрока.ЗаЧейСчетДоставка 		= Перечисления.ЗаЧейСчетДоставка.ПустаяСсылка();
			ТекСтрока.Грузоперевозчик 			= Справочники.Контрагенты.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ДобавитьДанныеПоСборочнику(НарядНаЗагрузку,ТекСтрока) Экспорт
	ТекСтрока.Места 					= 0;
	ТекСтрока.Вес 						= 0;
	ТекСтрока.Объем 					= 0;
	ТекСтрока.ЯчейкаХраненияЗаказа 		= "";
	
	Если Не ЗначениеЗаполнено(ТекСтрока.ДокументОтгрузки) Тогда
		Возврат;
	КонецЕсли;
	
	ПолучитьДанныеПоСборочнымЛистам(НарядНаЗагрузку,ТекСтрока.ДокументОтгрузки,ТекСтрока);
	//Если ПС = Неопределено Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//ЗаполнитьЗначенияСвойств(ТекСтрока,ПС);
КонецПроцедуры

Процедура ПолучитьДанныеПоСборочнымЛистам(НарядНаЗагрузку,Документ,ТекСтрока)
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.РеализацияТоваров") Или ТипЗнч(Документ) = Тип("ДокументСсылка.ПередачаТовара") Тогда
		СборочныеЛисты = Документ.СобранныеТовары.Выгрузить(,"СборочныйЛист");
		СборочныеЛисты.Свернуть("СборочныйЛист");
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ЗаказНаПеремещение") Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	СборкаТовара.СборочныйЛист КАК СборочныйЛист
		                      |ИЗ
		                      |	БизнесПроцесс.СборкаТовара КАК СборкаТовара
		                      |ГДЕ
		                      |	СборкаТовара.ВедущаяЗадача.БизнесПроцесс.Ссылка = &Ссылка
		                      |	И (СборкаТовара.Склад = &Склад ИЛИ &ВсеСклады)
		                      |
		                      |СГРУППИРОВАТЬ ПО
		                      |	СборкаТовара.СборочныйЛист");
		Запрос.УстановитьПараметр("Ссылка",Документ.БПСсылка);
		Запрос.УстановитьПараметр("ВсеСклады",НЕ ЗначениеЗаполнено(НарядНаЗагрузку.МестоОтгрузки));
		Запрос.УстановитьПараметр("Склад",НарядНаЗагрузку.МестоОтгрузки);
		СборочныеЛисты = Запрос.Выполнить().Выгрузить();
	Иначе
		Возврат;
	КонецЕсли;
	Для Каждого ТекСборочник Из СборочныеЛисты Цикл
		Если ЗначениеЗаполнено(ТекСборочник.СборочныйЛист) Тогда
			ТекСтрока.Места	= ТекСтрока.Места	+ ТекСборочник.СборочныйЛист.КоличествоМест;
			ТекСтрока.Вес	= ТекСтрока.Вес		+ ТекСборочник.СборочныйЛист.Вес;
			ТекСтрока.Объем = ТекСтрока.Объем	+ ТекСборочник.СборочныйЛист.Объем;
			Если ЗначениеЗаполнено(ТекСборочник.СборочныйЛист.ЯчейкаСобранногоТовара) Тогда
				ТекСтрока.ЯчейкаХраненияЗаказа = ТекСтрока.ЯчейкаХраненияЗаказа + ?(ТекСтрока.ЯчейкаХраненияЗаказа<>"",", ","") + ТекСборочник.СборочныйЛист.ЯчейкаСобранногоТовара.Наименование;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры



//Паноктикум
Функция Стар_ПолучитьПоследнийСборочныйЛист(Заказ)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СборочныйЛист.Ссылка,
	                      |	СборочныйЛист.Дата,
	                      |	СборочныйЛист.Заказ,
	                      |	СборочныйЛист.Вес,
	                      |	СборочныйЛист.Объем,
	                      |	СборочныйЛист.КоличествоПозиций КАК Места,
	                      |	СборочныйЛист.ЯчейкаСобранногоТовара КАК ЯчейкаХраненияЗаказа
	                      |ПОМЕСТИТЬ втВсеСборочныеЛисты
	                      |ИЗ
	                      |	Документ.СборочныйЛист КАК СборочныйЛист
	                      |ГДЕ
	                      |	СборочныйЛист.Склад = СборочныйЛист.Заказ.Склад
	                      |	И СборочныйЛист.Проведен
	                      |	И СборочныйЛист.ТипСборочногоЛиста = ЗНАЧЕНИЕ(Перечисление.ТипыСборочныхЛистов.Сборка)
	                      |	И СборочныйЛист.Заказ = &Заказ
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	втВсеСборочныеЛисты.Заказ,
	                      |	МАКСИМУМ(втВсеСборочныеЛисты.Дата) КАК Дата
	                      |ПОМЕСТИТЬ втДатаПоследнегоСборочного
	                      |ИЗ
	                      |	втВсеСборочныеЛисты КАК втВсеСборочныеЛисты
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	втВсеСборочныеЛисты.Заказ
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	МАКСИМУМ(втВсеСборочныеЛисты.Вес) КАК Вес,
	                      |	МАКСИМУМ(втВсеСборочныеЛисты.Объем) КАК Объем,
	                      |	МАКСИМУМ(втВсеСборочныеЛисты.Места) КАК Места,
	                      |	МАКСИМУМ(втВсеСборочныеЛисты.ЯчейкаХраненияЗаказа) КАК ЯчейкаХраненияЗаказа
	                      |ИЗ
	                      |	втВсеСборочныеЛисты КАК втВсеСборочныеЛисты
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДатаПоследнегоСборочного КАК втДатаПоследнегоСборочного
	                      |		ПО втВсеСборочныеЛисты.Заказ = втДатаПоследнегоСборочного.Заказ
	                      |			И втВсеСборочныеЛисты.Дата = втДатаПоследнегоСборочного.Дата");
	Запрос.УстановитьПараметр("Заказ",Заказ);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка;
	КонецЕсли;
КонецФункции

Функция Стар_ПолучитьПоследнююРеализацию(Заказ) 
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	РеализацияТоваров.Заказ,
	                      |	РеализацияТоваров.Ссылка КАК Реализация,
	                      |	РеализацияТоваров.Дата КАК Дата
	                      |ИЗ
	                      |	Документ.РеализацияТоваров КАК РеализацияТоваров
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДокументовОтгрузки.СрезПоследних КАК СостоянияДокументовОтгрузкиСрезПоследних
	                      |		ПО РеализацияТоваров.Ссылка = СостоянияДокументовОтгрузкиСрезПоследних.ДокументОтгрузки
	                      |			И (СостоянияДокументовОтгрузкиСрезПоследних.Состояние В (ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.Отправлен), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.ОтправленЧастично), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.Доставлен), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.ДоставленЧастично)))
	                      |ГДЕ
	                      |	РеализацияТоваров.Проведен
	                      |	И РеализацияТоваров.Заказ = &Заказ
	                      |	И СостоянияДокументовОтгрузкиСрезПоследних.Состояние ЕСТЬ NULL
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Дата УБЫВ");
	Запрос.УстановитьПараметр("Заказ",Заказ);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Выборка = Результат.Выбрать();
	Если Выборка.Количество()>1 Тогда
		Сообщить("Внимание! По заказу №"+Заказ.Номер+" есть "+Выборка.Количество()+" реализаций с неотправленным и неотгруженным товаром.");
	КонецЕсли;
	Выборка.Следующий();
	Возврат Выборка.Реализация;
КонецФункции

Функция Стар_ПолучитьПоследнююПередачуТовара(Заказ) 
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ПередачаТовара.Заказ,
	                      |	ПередачаТовара.Ссылка КАК Передача,
	                      |	ПередачаТовара.Дата КАК Дата
	                      |ИЗ
	                      |	Документ.ПередачаТовара КАК ПередачаТовара
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДокументовОтгрузки.СрезПоследних КАК СостоянияДокументовОтгрузкиСрезПоследних
	                      |		ПО ПередачаТовара.Ссылка = СостоянияДокументовОтгрузкиСрезПоследних.ДокументОтгрузки
	                      |			И (СостоянияДокументовОтгрузкиСрезПоследних.Состояние В (ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.Отправлен), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.ОтправленЧастично), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.Доставлен), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.ДоставленЧастично)))
	                      |ГДЕ
	                      |	ПередачаТовара.Проведен
	                      |	И ПередачаТовара.Заказ = &Заказ
	                      |	И СостоянияДокументовОтгрузкиСрезПоследних.Состояние ЕСТЬ NULL
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Дата УБЫВ");
	Запрос.УстановитьПараметр("Заказ",Заказ);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Выборка = Результат.Выбрать();
	Если Выборка.Количество()>1 Тогда
		Сообщить("Внимание! По заказу №"+Заказ.Номер+" есть "+Выборка.Количество()+" передачи с неотправленным и неотгруженным товаром.");
	КонецЕсли;
	Выборка.Следующий();
	Возврат Выборка.Передача;
КонецФункции

Функция Стар_ПолучитьПоследнийЗаказНаПеремещение(Заказ) 
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЗаказНаПеремещение.Заказ,
	                      |	ЗаказНаПеремещение.Ссылка КАК Передача,
	                      |	ЗаказНаПеремещение.Дата КАК Дата
	                      |ИЗ
	                      |	Документ.ЗаказНаПеремещение КАК ЗаказНаПеремещение
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДокументовОтгрузки.СрезПоследних КАК СостоянияДокументовОтгрузкиСрезПоследних
	                      |		ПО ЗаказНаПеремещение.Ссылка = СостоянияДокументовОтгрузкиСрезПоследних.ДокументОтгрузки
	                      |			И (СостоянияДокументовОтгрузкиСрезПоследних.Состояние В (ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.Отправлен), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.ОтправленЧастично), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.Доставлен), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказа.ДоставленЧастично)))
	                      |ГДЕ
	                      |	ЗаказНаПеремещение.Проведен
	                      |	И ЗаказНаПеремещение.Заказ = &Заказ
	                      |	И СостоянияДокументовОтгрузкиСрезПоследних.Состояние ЕСТЬ NULL
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Дата УБЫВ");
	Запрос.УстановитьПараметр("Заказ",Заказ);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Выборка = Результат.Выбрать();
	Если Выборка.Количество()>1 Тогда
		Сообщить("Внимание! По заказу №"+Заказ.Номер+" есть "+Выборка.Количество()+" заказов на перемещение с неотправленным и неотгруженным товаром.");
	КонецЕсли;
	Выборка.Следующий();
	Возврат Выборка.Передача;
КонецФункции

Функция Стар_ПолучитьДанныеПоСборочнымЛистам(НарядНаЗагрузку,Документ,ТекСтрока)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СУММА(СборочныйЛист.Вес) КАК Вес,
	                      |	СУММА(СборочныйЛист.Объем) КАК Объем,
	                      |	СУММА(СборочныйЛист.КоличествоМест) КАК Места,
	                      |	МАКСИМУМ(СборочныйЛист.ЯчейкаСобранногоТовара) КАК ЯчейкаХраненияЗаказа
	                      |ИЗ
	                      |	Документ.СборочныйЛист КАК СборочныйЛист
	                      |ГДЕ
	                      |	СборочныйЛист.Проведен
	                      |	И СборочныйЛист.Ссылка В(&Сборочники)");
	мДок = Новый Массив;
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.РеализацияТоваров") Или ТипЗнч(Документ) = Тип("ДокументСсылка.ПередачаТовара") Тогда
		Если Документ.СобранныеТовары.Количество()>0 Тогда
			мДок = Документ.СобранныеТовары.Выгрузить(,"СборочныйЛист");
		КонецЕсли;
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ОтгрузкаТоваров") Тогда
		Если ЗначениеЗаполнено(Документ.СборочныйЛист) Тогда
			мДок.Добавить(Документ.СборочныйЛист);
		КонецЕсли;
	КонецЕсли;
	Запрос.УстановитьПараметр("Сборочники",мДок);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Результат = Результат.Выбрать();
	Результат.Следующий();
	Возврат Результат;
КонецФункции