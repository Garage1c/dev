﻿&НаКлиенте
Перем БылоРедактированиеКИ;
&НаКлиенте
Перем ИДСтрокиРедактирования;
&НаКлиенте
Перем ИДСтрокиВладельца;
&НаКлиенте
Перем ИДНовогоКЛ, НовоеКонтактноеЛицо, текВидКИ;

////////////////////////////////
// HTML

&НаСервере
Функция ЗаполнитьКарточку(Ссылка)
	
	Текст = "";

	Если
		 ТипЗнч(Ссылка) = Тип("СправочникСсылка.Контрагенты") Тогда
		 
		УправлениеКонтактнойИнформацией.СформироватьКарточкуКонтактаHTML(Текст, Ссылка, "Контрагенты",,,, "Комментарий", Новый Структура("ЮрФизЛицо, ИНН, КПП, КодПоОКПО"),, Ложь);	
	ИначеЕсли
		 ТипЗнч(Ссылка) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		 
		УправлениеКонтактнойИнформацией.СформироватьКарточкуКонтактаHTML(Текст,Ссылка, "КонтактныеЛица",,,,,Новый Структура("Должность"),, Ложь);
	КонецЕсли;

	Возврат Текст;
	
КонецФункции


&НаСервере
Функция ПоместитьИнформациюВХранилище_ст(ИД) 
	
	ЭлементДерева = КонтактнаяИнформация.НайтиПоИдентификатору(ИД);
	
	Возврат ПоместитьВоВременноеХранилище(
					ЭлементДерева.Поля.Выгрузить(), 
					УникальныйИдентификатор);
КонецФункции


/////////////////////////////////////////////////////
// КОНТАКТНАЯ ИНФОРМАЦИЯ

&НаКлиенте
Процедура КонтактнаяИнформацияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ТекЭлемент = КонтактнаяИнформация.НайтиПоИдентификатору(Элементы.КонтактнаяИнформация.ТекущаяСтрока);
	
	// нельзя добавлять элемент, если позиция не на Объекте (не на первом уровне иерархии), в противном случае получается вложение для вида КИ, этого нужно избежать
	Если ТекЭлемент <> Неопределено И ТекЭлемент.ПолучитьРодителя() <> Неопределено Тогда Отказ = Истина; Возврат; КонецЕсли;
	
	Отказ = Истина;
	ИДСтрокиВладельца = ТекЭлемент.ПолучитьИдентификатор();
	ОткрытьФорму("Справочник.ВидыКонтактнойИнформации.ФормаВыбора",ПолучитьЗначениеОтбора(ТекЭлемент.Ссылка),ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
		
	//Если НоваяСтрока Тогда ТекущиеДанные = Элементы.КонтактнаяИнформация.ТекущиеДанные;

	//	ЭлементДерева = КонтактнаяИнформация.НайтиПоИдентификатору(Элементы.КонтактнаяИнформация.ТекущаяСтрока);
	//	Родитель = ЭлементДерева.ПолучитьРодителя();
	//	
	//	//ТекущиеДанные.Объект = Родитель.Ссылка;
	//
	//КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияПриАктивизацииСтроки(Элемент)
	
	// показать карточку контакта
	
	ТекущиеДанные = Элементы.КонтактнаяИнформация.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.Картинка > 0 Тогда
		КарточкаПартнера = ЗаполнитьКарточку(ТекущиеДанные.Ссылка);
	КонецЕсли;
	УстановитьВидимостьДоступность(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьДоступность(ТекущиеДанные = Неопределено)
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.КонтактнаяИнформация.ТекущиеДанные; КонецЕсли;
	
	Если ТекущиеДанные = Неопределено ИЛИ Элементы.КонтактнаяИнформация.ТекущаяСтрока = Неопределено Тогда Возврат; КонецЕсли;
	
	ТекЭлемент = КонтактнаяИнформация.НайтиПоИдентификатору(Элементы.КонтактнаяИнформация.ТекущаяСтрока);
	
	// нельзя добавлять элемент, если позиция не на Объекте (не на первом уровне иерархии), в противном случае получается вложение для вида КИ, этого нужно избежать
	Элементы.КонтактнаяИнформацияДобавить.Доступность = ТекЭлемент <> Неопределено И ТекЭлемент.ПолучитьРодителя() = Неопределено;
	
	// в данной форме нельзя удалить контакт, только КЛ или КИ
	Элементы.КонтактнаяИнформацияУдалить.Доступность = ТекущиеДанные <> Неопределено И 
	(ТипЗнч(ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") ИЛИ ТипЗнч(ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.КонтактныеЛица"));
	
КонецПроцедуры
&НаКлиенте
Процедура КонтактнаяИнформацияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Строка = Неопределено Тогда ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена; Возврат; КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
 	Приемник = КонтактнаяИнформация.НайтиПоИдентификатору(Строка);
	СтрокаПеретаскивания = КонтактнаяИнформация.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение[0]); 
	
	// не позволяем перетаскивать элемент первого уровня (нельзя допустить перетаскивание контакта в подчинение другому контакту)
	// не позволяем перетаскивать элемент в подчинение себе же, т.к. это ни к чему не приведет
	Если СтрокаПеретаскивания.ПолучитьРодителя() = Неопределено ИЛИ Приемник = СтрокаПеретаскивания.ПолучитьРодителя() Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена; КонецЕсли;
		
КонецПроцедуры
&НаКлиенте
Процедура КонтактнаяИнформацияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена ИЛИ Строка = Неопределено ИЛИ ПараметрыПеретаскивания.Значение[0] = Неопределено Тогда Возврат; КонецЕсли;
	
	текЭлемент = КонтактнаяИнформация.НайтиПоИдентификатору(Строка);  // узнаем КУДА
	
	// если перетаскивают на элемент первого уровня (на контакт) обрабатываем событие сами, т.к. по-умолчанию перетаскиваемый элемент  
	// не подчиняется выбранному, а становится с ним на одном уровне. Нам же нужно подчинение.
	
	Если текЭлемент.ПолучитьРодителя() = Неопределено Тогда 
		
		
		Источник = КонтактнаяИнформация.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение[0]); // узнаем ЧТО
		СтандартнаяОбработка = Ложь;
		
		// добавим куда перетаскивали
		
		ЭлементыДерева = текЭлемент.ПолучитьЭлементы();
		НоваяСтрока  = ЭлементыДерева.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Источник);
		
		// удалим то что перетаскивали
		
		ЭлементыУдалить = Источник.ПолучитьРодителя().ПолучитьЭлементы();
		ЭлементыУдалить.Удалить(ЭлементыУдалить.Индекс(Источник));
			
		Элементы.КонтактнаяИнформация.Развернуть(Строка); 

		БылоРедактированиеКИ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияПриИзменении(Элемент)
	БылоРедактированиеКИ = Истина;
	
КонецПроцедуры
&НаСервере
Процедура ОбновитьКонтактнуюИнформациюДерево(Ссылка, ИмяСправочника = "Контрагенты")
	
	ИмяСправочника = Ссылка.Метаданные().Имя;
	
	ЭлементыДерева = КонтактнаяИнформация.ПолучитьЭлементы();
	ЭлементыДерева.Очистить();
	
	Запрос = Новый Запрос(" 
							|ВЫБРАТЬ Ссылка ПОМЕСТИТЬ Контрагенты ИЗ Справочник.Контрагенты ГДЕ Ссылка = &Ссылка И НЕ ПометкаУдаления
	                        |;
							|ВЫБРАТЬ Ссылка ПОМЕСТИТЬ КонтактныеЛица ИЗ Справочник.КонтактныеЛица ГДЕ Владелец = &Ссылка И НЕ ПометкаУдаления  
							|ОБЪЕДИНИТЬ ВСЕ
							|ВЫБРАТЬ Ссылка  ИЗ Справочник.КонтактныеЛица ГДЕ Владелец В (ВЫБРАТЬ Ссылка ИЗ Контрагенты) И НЕ ПометкаУдаления 
							|;
							|
							|ВЫБРАТЬ Ссылка КАК Объект, Ссылка КАК Владелец, Неопределено Вид, """" ID, """" Представление, """" Комментарий, Ложь ЗначениеПоУмолчанию, &НомерКартинки Последовательность  
							|ИЗ
							|	Справочник." + ИмяСправочника + " КАК Спр
							|ГДЕ Ссылка = &Ссылка
							|
							|ОБЪЕДИНИТЬ ВСЕ
							|
							|ВЫБРАТЬ Ссылка КАК Объект, Ссылка КАК Владелец, Неопределено Вид, """" ID, """" Представление, """" Комментарий, Ложь ЗначениеПоУмолчанию, 2 Последовательность  
							|ИЗ
							|	Контрагенты
							|
 							|ОБЪЕДИНИТЬ ВСЕ
							|
							|ВЫБРАТЬ Ссылка КАК Объект, Ссылка.Владелец КАК Владелец,Неопределено Вид, """" ID, """" Представление, """" Комментарий, Ложь ЗначениеПоУмолчанию, 3 Последовательность  
							|ИЗ
							|	КонтактныеЛица
							|
							|ОБЪЕДИНИТЬ ВСЕ 
							|
							|ВЫБРАТЬ Объект, Объект КАК Владелец, Вид, ID, Представление, Комментарий, ЗначениеПоУмолчанию, &НомерКартинки Последовательность
							|ИЗ 
							|	РегистрСведений.ПредставлениеКонтактнойИнформации
							|	ГДЕ Объект = &Ссылка 
							|
							|ОБЪЕДИНИТЬ ВСЕ 
							|
							|ВЫБРАТЬ Объект,Объект КАК Владелец, Вид, ID, Представление, Комментарий, ЗначениеПоУмолчанию, 2 Последовательность 
							|ИЗ 
							|	РегистрСведений.ПредставлениеКонтактнойИнформации ГДЕ Объект В (ВЫБРАТЬ Ссылка ИЗ Контрагенты)
							|
							|ОБЪЕДИНИТЬ ВСЕ 
							|
							|ВЫБРАТЬ Объект,Объект.Владелец КАК Владелец, Вид, ID, Представление, Комментарий, ЗначениеПоУмолчанию, 3 Последовательность 
							|ИЗ 
							|	РегистрСведений.ПредставлениеКонтактнойИнформации ГДЕ Объект В (ВЫБРАТЬ Ссылка ИЗ КонтактныеЛица)
							|ИТОГИ МАКСИМУМ(Последовательность) ПО Владелец,Объект
							|;
							|ВЫБРАТЬ Объект,Объект КАК Владелец, Вид, ID, Поле, Значение ИЗ РегистрСведений.КонтактнаяИнформация ГДЕ Объект = &Ссылка 
							|
							|ОБЪЕДИНИТЬ ВСЕ
							|
							|ВЫБРАТЬ Объект,Объект КАК Владелец, Вид, ID, Поле, Значение ИЗ РегистрСведений.КонтактнаяИнформация ГДЕ Объект В (ВЫБРАТЬ Ссылка ИЗ Контрагенты)
							|
							|ОБЪЕДИНИТЬ ВСЕ
							|
							|ВЫБРАТЬ Объект,Объект КАК Владелец, Вид, ID, Поле, Значение ИЗ РегистрСведений.КонтактнаяИнформация ГДЕ Объект В (ВЫБРАТЬ Ссылка ИЗ КонтактныеЛица)
							|");
							
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("НомерКартинки", ?(ИмяСправочника = "ТочкиПродаж",4,1));
		
	УстановитьПривилегированныйРежим(Истина);
	
	Рез = Запрос.ВыполнитьПакет();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	КИ 	= Рез[3].Выгрузить();
	
	Если НЕ Рез[2].Пустой() Тогда
		
		ВыборкаСсылкаВладелец = Рез[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		// сначала обход по владельцу
		Пока ВыборкаСсылкаВладелец.Следующий() ЦИКЛ
			
        ВыборкаСсылка = ВыборкаСсылкаВладелец.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		
		// обходим по Объекту
		Пока ВыборкаСсылка.Следующий() ЦИКЛ
			
			НовыйКорень = ЭлементыДерева.Добавить();
			НовыйКорень.Ссылка 		= ВыборкаСсылка.Объект;
			НовыйКорень.Картинка 	= ВыборкаСсылка.Последовательность;
			
			// заполняем Контактую информацию Объекта
			Выборка = ВыборкаСсылка.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				// если для Объекта контактная информация не задана - идем дальше
				Если Выборка.Вид = Неопределено Тогда Продолжить; КонецЕсли;
					
				НоваяСтрока = НовыйКорень.ПолучитьЭлементы().Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
				НоваяСтрока.Ссылка = Выборка.Вид;
				
				// заполняем структуру поле контактной информации/значение поля
				СтруктураПолей = Новый Соответствие;
				Строки = КИ.НайтиСтроки(Новый Структура("Объект, Вид, ID", ВыборкаСсылка.Объект, Выборка.Вид, Выборка.ID));
				Для Каждого Строка ИЗ Строки Цикл СтруктураПолей.Вставить(Строка.Поле, Строка.Значение); КонецЦикла;						
				
				НоваяСтрока.Поля = ЗначениеВСтрокуВнутр(СтруктураПолей);
				
			КонецЦикла;
		КонецЦикла;
	    КонецЦикла;
	КонецЕсли;
	
	//Элементы.КонтактнаяИнформация.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
КонецПроцедуры

////////////////////////////////////////
// КОНТАКТНЫЕ ЛИЦА

&НаКлиенте
Процедура ДобавитьКонтактноеЛицо(Команда)
	//Для кого создаем?
 
	//ВладелецКонтакта = Элементы.КонтактнаяИнформация.ТекущиеДанные.Ссылка;
	ОткрытьФорму("Справочник.КонтактныеЛица.ФормаОбъекта",Новый Структура("Владелец", Объект.Контрагент),ЭтаФорма,,,, Новый ОписаниеОповещения("РедактированиеКИЗавершено", ЭтаФорма));
	
КонецПроцедуры
&НаКлиенте
Процедура РедактированиеКИЗавершено(Результат, Параметры) Экспорт
	Если НовоеКонтактноеЛицо <> Неопределено Тогда 	
	ЗаполнитьКИдляКЛ(НовоеКонтактноеЛицо, ИДНовогоКЛ); КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКИдляКЛ(КонтактноеЛицо, ИД)
	
	Запрос = Новый Запрос("
			|
			|ВЫБРАТЬ Объект, Вид, ID, Представление, Комментарий, ЗначениеПоУмолчанию 
			|ИЗ 
			|	РегистрСведений.ПредставлениеКонтактнойИнформации ГДЕ Объект = &Ссылка
			|");
	Запрос.УстановитьПараметр("Ссылка", КонтактноеЛицо);
	Рез = Запрос.Выполнить();
	
	Если НЕ Рез.Пустой() Тогда
		
		Элемент = КонтактнаяИнформация.НайтиПоИдентификатору(ИД);
		Если Элемент = Неопределено Тогда Возврат; КонецЕсли;
		ЭлементыДерева = Элемент.ПолучитьЭлементы();
		
		Выборка = Рез.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НовыйЭлемент = ЭлементыДерева.Добавить();
	        ЗаполнитьЗначенияСвойств(НовыйЭлемент, Выборка);
			НовыйЭлемент.Ссылка = Выборка.Вид;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Если ТипЗнч(НовыйОбъект) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		
		НовоеКонтактноеЛицо = НовыйОбъект;
		
		ЭлементыДерева = КонтактнаяИнформация.ПолучитьЭлементы();
		НовыйЭлемент = ЭлементыДерева.Добавить();
		НовыйЭлемент.Ссылка = НовыйОбъект;
		НовыйЭлемент.Картинка = 3;
		ИДНовогоКЛ = НовыйЭлемент.ПолучитьИдентификатор();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.КонтактнаяИнформация.ТекущиеДанные;
	Если ТипЗнч(ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		
		Ответ = Вопрос("Пометить элемент на удаление и удалить контактную информацию, связанную с ним?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Да Тогда УдалитьКонтактноеЛицо(ТекущиеДанные.Ссылка); 
		Иначе Отказ = Истина; КонецЕсли;
	ИначеЕсли 
		ТипЗнч(ТекущиеДанные.Ссылка) <> Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
		// в данной форме нельзя удалить контакт, только КЛ или КИ
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
&НаСервере
Процедура УдалитьКонтактноеЛицо(КонтактноеЛицо)
	
	Спр = КонтактноеЛицо.ПолучитьОбъект();	
	Спр.УстановитьПометкуУдаления(Истина); // удаляется вместе с КИ
	
КонецПроцедуры

///////////////////////////////////////
//ЗАПИСЬ КИ

&НаКлиенте
Процедура СохранитьКонтактнуюИнформацию(Команда)
	
	Если ЗаписатьНаСервере() Тогда
		БылоРедактированиеКИ = Ложь; КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ЗаписатьНаСервере(стрОшибки = "")
	
	ТипСтрока 	= Новый ОписаниеТипов("Строка");
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.ТочкиПродаж"));
	МассивТипов.Добавить(Тип("СправочникСсылка.Контрагенты"));
	МассивТипов.Добавить(Тип("СправочникСсылка.КонтактныеЛица"));
	МассивТипов.Добавить(Тип("СправочникСсылка.Грузополучатели"));
		
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Объект", 	Новый ОписаниеТипов(МассивТипов));
	ТЗ.Колонки.Добавить("Вид", 		Новый ОписаниеТипов("СправочникСсылка.ВидыКонтактнойИнформации"));
	ТЗ.Колонки.Добавить("ID", 		Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(36)));
	ТЗ.Колонки.Добавить("ЗначениеПоУмолчанию", Новый ОписаниеТипов("Булево"));
	ТЗ.Колонки.Добавить("Представление", 	ТипСтрока);
	ТЗ.Колонки.Добавить("Комментарий", 		ТипСтрока);
	ТЗ.Колонки.Добавить("Поля", 			ТипСтрока); 
		
	// запоминаем контактную ифнормацию 
	ЭлементыДерева = КонтактнаяИнформация.ПолучитьЭлементы();
	Для Каждого Элемент Из ЭлементыДерева Цикл ТЗ.Очистить();
		
		текОбъект = Элемент.Ссылка;
		
		КонтактныеДанные = Элемент.ПолучитьЭлементы();
		Для Каждого Значения Из КонтактныеДанные Цикл
			
			НоваяСтрока = ТЗ.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Значения);
			НоваяСтрока.Объект 	= текОбъект;
			НоваяСтрока.Вид 	= Значения.Ссылка;
			
			// для новых элементов добавим ID
			Если ПустаяСтрока(НоваяСтрока.ID) Тогда НоваяСтрока.ID = Новый УникальныйИдентификатор; КонецЕсли;
		КонецЦикла;
		
		// записываем в регистр для текОбъект
		Если НЕ ЗаписатьКонтактнуюИнформацию(текОбъект, ТЗ, стрОшибки) Тогда Возврат Ложь; КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;			
КонецФункции
&НаСервере
Функция ЗаписатьКонтактнуюИнформацию(Ссылка, Таблица, стрОшибки)
	
	// записываем как есть
	
	НачатьТранзакцию();
	
	Набор = РегистрыСведений.ПредставлениеКонтактнойИнформации.СоздатьНаборЗаписей();
   	Набор.Отбор.Объект.Установить(Ссылка);
	
	Набор.Загрузить(Таблица);
	
	Попытка
		Набор.Записать();
	Исключение
		стрОшибки = "Ошибка при записи контактной информации
							|" + ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;		
	
	Набор = РегистрыСведений.КонтактнаяИнформация.СоздатьНаборЗаписей();
	Набор.Отбор.Объект.Установить(Ссылка);	
		
	Набор.Прочитать();
	Набор.Очистить();
	
	Для Каждого СтрокаТаблицы ИЗ Таблица Цикл

		Если НЕ ПустаяСтрока(СтрокаТаблицы.Поля) Тогда
			
			СоответствиеПолей = ЗначениеИзСтрокиВнутр(СтрокаТаблицы.Поля);
		    Для Каждого Строка ИЗ  СоответствиеПолей Цикл
				
				НоваяСтрока = Набор.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
				НоваяСтрока.Поле = Строка.Ключ;
				НоваяСтрока.Значение = Строка.Значение;
				
			КонецЦикла;
	    КонецЕсли;
	КонецЦикла; 
	
	Попытка
		Набор.Записать();
	Исключение
		стрОшибки = "Ошибка при записи контактной информации
							|" + ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;	
	
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
	
КонецФункции

/////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ ФОРМЫ

&НаСервере
Функция ПолучитьПартнераКонтакта(Контакт)
	
	ТипКонтакта = ТипЗнч(Контакт);
	
	 
	 
	Если ТипКонтакта = Тип("СправочникСсылка.ТочкиПродаж") Тогда
		Возврат Контакт;
		
	ИначеЕсли ТипКонтакта = Тип("СправочникСсылка.Контрагенты") Тогда
		 Возврат Контакт;
		 
	ИначеЕсли ТипКонтакта = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		 Возврат Контакт.Владелец;
	ИначеЕсли ТипКонтакта = Тип("СправочникСсылка.Грузополучатели") Тогда
		 Возврат Контакт;
	КонецЕсли;
	
	 
	Возврат Неопределено;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Контакт <> Неопределено И НЕ Параметры.Контакт.Пустая() Тогда 
		Объект.Контрагент = ПолучитьПартнераКонтакта(Параметры.Контакт); 
	КонецЕсли;
	
	Если Объект.Контрагент = Неопределено ИЛИ Объект.Контрагент.Пустая() Тогда Отказ = Истина;
	 // ОбновитьКонтактнуюИнформациюДерево(Параметры.Контакт);
    Иначе
	  ОбновитьКонтактнуюИнформациюДерево(Объект.Контрагент);
	КонецЕсли; 
	
		
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// надо знать, редактировали ли КИ
	БылоРедактированиеКИ = Ложь;
	УстановитьВидимостьДоступность();
КонецПроцедуры
&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если БылоРедактированиеКИ Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗакрытияВопроса",ЭтотОбъект),"Сохранить изменения в форме?", РежимДиалогаВопрос.ДаНетОтмена);
		Отказ = Истина;
		//Ответ = Вопрос("Сохранить изменения в форме?", РежимДиалогаВопрос.ДаНетОтмена);
		//Если		Ответ = КодВозвратаДиалога.Да 		Тогда ЗаписатьНаСервере();
		//ИначеЕсли 	Ответ = КодВозвратаДиалога.Отмена	Тогда Отказ = Истина; 
		//КонецЕсли;
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	Если		Результат = КодВозвратаДиалога.Да 		Тогда ЗаписатьНаСервере(); БылоРедактированиеКИ = Ложь; Закрыть();
	ИначеЕсли 	Результат = КодВозвратаДиалога.Нет		Тогда БылоРедактированиеКИ = Ложь; Закрыть();
	КонецЕсли;	
КонецПроцедуры
//////////////////////////////////////////
// ОБРАБОТКА ДЕЙСТВИЙ НАД ПОЛЯМИ ДЕРЕВА


&НаКлиенте
Процедура СсылкаПриИзменении(Элемент)
	
	// при изменении Вида КИ попытаемся передать старую структуру полей для новой структуры
	ТекущиеДанные = Элементы.КонтактнаяИнформация.ТекущиеДанные;
	Если ТипЗнч(ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
		
		ТекущиеДанные.Поля 	= ПолучитьСтруктуруПолей(ТекущиеДанные.Ссылка, ТекущиеДанные.Поля);
		
		//ТекущиеДанные.Вид 	= ТекущиеДанные.Ссылка;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруПолей(Вид, Поля, Представление = "")
	
	// получим текущее значение полей

	Если НЕ ПустаяСтрока(Поля) Тогда времСоответствие = ЗначениеИзСтрокиВнутр(Поля); 
	Иначе Возврат ""; КонецЕсли;
	
	// если текущее значение полей пустое, тогда передавать новому виду КИ нечего
	Если НЕ времСоответствие.Количество() Тогда Возврат ""; КонецЕсли;
	
	// выбираем поля для заполнения для нового Вида КИ
	Запрос = Новый Запрос("ВЫБРАТЬ Имя Поле, """" Значение ИЗ Справочник.ВидыКонтактнойИнформации.СоставПолей ГДЕ Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Вид);
	
	СоответствиеПолей = КонвертацияТипов.ПолучитьСоответствиеИзВыборки(Запрос.Выполнить().Выбрать(), "Поле", "Значение");
	
	// в новое соответствие запишем совпадающие поля со старыми значениями
	СоответствиеВыборочно = Новый Соответствие;
	Для Каждого Строка ИЗ времСоответствие Цикл
		Поле = СоответствиеПолей.Получить(Строка.Ключ);
		Если Поле <> Неопределено И ЗначениеЗаполнено(Строка.Значение) Тогда
			СоответствиеВыборочно.Вставить(Строка.Ключ, Строка.Значение) КонецЕсли;
	КонецЦикла;
	
	//Представление = Обработки.КонтактнаяИнформация.СформироватьПредставление(Вид.Родитель, НовоеСоответствие, Ложь); 
	
	Возврат ЗначениеВСтрокуВнутр(СоответствиеВыборочно);
	
КонецФункции
&НаСервере
Функция ПолучитьЗначениеОтбора(ОбъектКИ)
	    ИмяПеречисления = СтрЗаменить(Строка(ТипЗнч(ОбъектКИ))," ","");
        ЗначениеОтбора  = Новый Структура("ГруппаКИ", Перечисления["ГруппыВидовКИ"][ИмяПеречисления]);
		ПараметрыВыбора = Новый Структура("Отбор", ЗначениеОтбора);
 
        Возврат  ПараметрыВыбора;
			
КонецФункции

&НаКлиенте
Процедура СсылкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.КонтактнаяИнформация.ТекущиеДанные;
	
	Если ТекущиеДанные.Ссылка = Неопределено ИЛИ ТипЗнч(ТекущиеДанные.Ссылка)  = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
		
		ИДСтрокиРедактирования = ТекущиеДанные.ПолучитьИдентификатор();
		текВидКИ = ТекущиеДанные.Ссылка;
		
		ТекРодитель = ТекущиеДанные.ПолучитьРодителя().Ссылка;
		ОткрытьФорму("Справочник.ВидыКонтактнойИнформации.ФормаВыбора",ПолучитьЗначениеОтбора(ТекРодитель),ЭтаФорма);
	КонецЕсли;
		
КонецПроцедуры
&НаКлиенте
Процедура КонтактнаяИнформацияПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.КонтактнаяИнформация.ТекущиеДанные;
	
	Если ТипЗнч(ТекущиеДанные.Ссылка)  = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
		
		ОткрытьФорму("Обработка.КонтактнаяИнформация.Форма.ФормаКонтактнойИнформации", 
		Новый Структура("ИдентификаторСтроки, Поля, Вид, ЗакрыватьПриЗакрытииВладельца", 
		Элементы.КонтактнаяИнформация.ТекущаяСтрока, 
		ТекущиеДанные.Поля, 
		ТекущиеДанные.Ссылка, Истина), ЭтаФорма);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	БылоРедактированиеКИ = Истина;
	//Если ВыбранноеЗначение = Неопределено Тогда Элемент.Ссылка 	= Неопределено; Возврат; КонецЕсли;                           
	// выбран Вид КИ
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") И текВидКИ <> ВыбранноеЗначение Тогда
		
		Если ИДСтрокиВладельца<>Неопределено Тогда
			Элемент = КонтактнаяИнформация.НайтиПоИдентификатору(ИДСтрокиВладельца).ПолучитьЭлементы().Добавить();
			Элемент.Ссылка = ВыбранноеЗначение;
			ИДСтрокиВладельца = Неопределено;
			Элементы.КонтактнаяИнформация.ТекущаяСтрока = Элемент.ПолучитьИдентификатор();
		ИначеЕсли ИДСтрокиРедактирования<>Неопределено Тогда
			Элемент = КонтактнаяИнформация.НайтиПоИдентификатору(ИДСтрокиРедактирования);
			Элемент.Ссылка 	= ВыбранноеЗначение;
			Элемент.Представление = "";
			ИДСтрокиРедактирования = Неопределено;
		КонецЕсли;
			
		СсылкаПриИзменении(Элемент);
	// выбраны поля КИ	
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		ЭлементДерева = КонтактнаяИнформация.НайтиПоИдентификатору(ВыбранноеЗначение.ИД);
	    Если ЭлементДерева <> Неопределено Тогда ЭлементДерева.Поля = ВыбранноеЗначение.Поля; КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияПередНачаломИзменения(Элемент, Отказ)
	ТекущиеДанные = Элементы.КонтактнаяИнформация.ТекущиеДанные;
	
	Если Элемент.ТекущийЭлемент.Имя = "Представление" Тогда
		Если ТипЗнч(ТекущиеДанные.Ссылка)  = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
			Отказ = Истина;
			
			ОткрытьФорму("Обработка.КонтактнаяИнформация.Форма.ФормаКонтактнойИнформации", 
			Новый Структура("ИдентификаторСтроки, Поля, Вид, ЗакрыватьПриЗакрытииВладельца", 
			Элементы.КонтактнаяИнформация.ТекущаяСтрока, 
			ТекущиеДанные.Поля, 
			ТекущиеДанные.Ссылка, Истина), ЭтаФорма);
			
		КонецЕсли;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "Ссылка" Тогда
		Если ТекущиеДанные.Ссылка = Неопределено ИЛИ ТипЗнч(ТекущиеДанные.Ссылка)  = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
			Отказ = Истина;
			
			ИДСтрокиРедактирования = ТекущиеДанные.ПолучитьИдентификатор();
			текВидКИ = ТекущиеДанные.Ссылка;
			
			ТекРодитель = ТекущиеДанные.ПолучитьРодителя().Ссылка;
			ОткрытьФорму("Справочник.ВидыКонтактнойИнформации.ФормаВыбора",ПолучитьЗначениеОтбора(ТекРодитель),ЭтаФорма);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//&НаКлиенте
//Процедура КонтактнаяИнформацияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
//	ОтменаРедактирования = Ложь;
//КонецПроцедуры

