﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовФормы()
	
	СпеификацияАктивна = (Объект.СтатусСпецификации = Перечисления.СтатусыСпецификаций.Активна);
	Элементы.Состав.ТолькоПросмотр = СпеификацияАктивна;
	Элементы.ТабличныйДокумент.ТолькоПросмотр = СпеификацияАктивна;
	Элементы.ЗагрузитьСостав.Доступность = Не СпеификацияАктивна;
	Элементы.Поставщик.ТолькоПросмотр = ЗначениеЗаполнено(Объект.Договор);
	
	// + neti Муталлапова 25.05.2017
	Элементы.ПроцентКолебанияЦен.Доступность = РольДоступна("РедактированиеПроцентаКолебанияЦенСпецификации");	
	// - neti Муталлапова 25.05.2017
	
КонецПроцедуры

&НаКлиенте
Процедура СоставНоменклатураПриИзменении(Элемент)
	ТекСтрока = Элементы.Состав.ТекущиеДанные;
	ДанныеНоменклатуры = ПолучитьДанныеНоменклатуры(ТекСтрока.Номенклатура);
	ЗаполнитьЗначенияСвойств(ТекСтрока, ДанныеНоменклатуры);
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьИтоговуюСтоимостьНоменклатуры(ТекСтрока)
	ТекСтрока.ИтоговаяСтоимость = ТекСтрока.БазоваяЦена - ТекСтрока.БазоваяЦена * ТекСтрока.Скидка / 100;		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатуры(Номенклатура)
	
	СтруктураСвойствНоменклатуры = Новый Структура("АртикулПоДаннымОрганизации,АртикулПоДанымПоставщика");	
	СтруктураСвойствНоменклатуры.АртикулПоДаннымОрганизации = Номенклатура.Артикул;
	СтруктураСвойствНоменклатуры.АртикулПоДанымПоставщика = Номенклатура.АртикулПоставщика;
	
	Возврат СтруктураСвойствНоменклатуры;
	
КонецФункции

&НаКлиенте
Процедура СоставБазоваяЦенаПриИзменении(Элемент)
	ТекСтрока = Элементы.Состав.ТекущиеДанные;
	РассчитатьИтоговуюСтоимостьНоменклатуры(ТекСтрока);
КонецПроцедуры

&НаКлиенте
Процедура СоставПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда 
		ДоговорКонтрагента = Объект.Договор;
		Элементы.Состав.ТекущиеДанные.Валюта = ВалютаДоговора(ДоговорКонтрагента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВалютаДоговора(ДоговорКонтрагента)
	Возврат ДоговорКонтрагента.Валюта;	
КонецФункции

&НаКлиенте
Процедура СоставСкидкаПриИзменении(Элемент)
	ТекСтрока = Элементы.Состав.ТекущиеДанные;
	РассчитатьИтоговуюСтоимостьНоменклатуры(ТекСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ДоговорНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	ПараметрыФормы = Новый Структура;

	ДоговорыСПоставщиком = ДоговорыСПоставщиком(Объект.Поставщик);	
	ПараметрыФормы.Вставить("СписокДопустимыхСсылок", ДоговорыСПоставщиком);
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДоговорыСПоставщиком(Поставщик) 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.ВидДоговора.Код = ""000000002""
	|	И ДоговорыКонтрагентов.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", Поставщик);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененСтатус" Тогда
		Прочитать();
		УстановитьДоступностьЭлементовФормы();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзExcel(Команда)
	
	АдресВХранилище = "";
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьЗагрузкуИзФормыЗавершение", ЭтотОбъект);
	НачатьПомещениеФайла(ОписаниеОповещения, АдресВХранилище, НСтр("ru = 'Файл данных'"),, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуИзФормыЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		
		Состояние(НСтр("ru = 'Выполняется загрузка данных. Пожалуйста, подождите...'"));
		ВыполнитьЗагрузкуНаСервере(Адрес, ВыбранноеИмяФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗагрузкуНаСервере(АдресФайла, ИмяФайлаДляРасширения)
	
	//ИмяЗагружаемогоФайла = ИмяФайлаНаСервереИлиКлиенте(ИмяФайлаОбмена ,АдресФайла, ИмяФайлаДляРасширения);
	//
	//Если ИмяЗагружаемогоФайла = Неопределено Тогда
	//	
	//	Возврат;
	//	
	//КонецЕсли;
	
	//!!!Выполнить загрузку
	
	//Попытка
	//	
	//	Если Не ПустаяСтрока(АдресФайла) Тогда
	//		УдалитьФайлы(ИмяЗагружаемогоФайла);
	//	КонецЕсли;
	//	
	//Исключение
	//КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ИмяФайлаНаСервереИлиКлиенте(ИмяРеквизита ,Знач АдресФайла, Знач ИмяФайлаДляРасширения = ".xml",
	СоздатьНовый = Ложь, ПроверятьСуществование = Истина)
	
	ИмяФайла = Неопределено;
		
	Расширение = РасширениеФайла(ИмяФайлаДляРасширения);
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайла);
	АдресНаСервере = ПолучитьИмяВременногоФайла(Расширение);
	ДвоичныеДанные.Записать(АдресНаСервере);
	ИмяФайла = АдресНаСервере;
	
	Возврат ИмяФайла;
	
КонецФункции

&НаСервере
Функция РасширениеФайла(Знач ИмяФайла)
	
	ПозицияТочки = ПоследнийРазделитель(ИмяФайла);
	
	Расширение = Прав(ИмяФайла,СтрДлина(ИмяФайла) - ПозицияТочки + 1);
	
	Возврат Расширение;
	
КонецФункции

&НаСервере
Функция ПоследнийРазделитель(СтрокаСРазделителем, Разделитель = ".")
	
	ДлинаСтроки = СтрДлина(СтрокаСРазделителем);
	
	Пока ДлинаСтроки > 0 Цикл
		
		Если Сред(СтрокаСРазделителем, ДлинаСтроки, 1) = Разделитель Тогда
			
			Возврат ДлинаСтроки; 
			
		КонецЕсли;
		
		ДлинаСтроки = ДлинаСтроки - 1;
		
	КонецЦикла;

КонецФункции

&НаКлиенте
Процедура ЗагрузитьСостав(Команда)
	
	ЗагрузитьСоставНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСоставНаСервере()
	
	НомерТекущейСтроки = 1;
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	
	КС = Новый КвалификаторыСтроки(200);
	КЧ = Новый КвалификаторыЧисла(12,2);
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ОписаниеТиповС = Новый ОписаниеТипов(Массив, , КС);
	
	Массив.Очистить();
	Массив.Добавить(Тип("Число"));
	ОписаниеТиповЧ = Новый ОписаниеТипов(Массив, , , КЧ);
	
	ТаблицаДанных.Колонки.Добавить("Артикул", ОписаниеТиповС, "Артикул", 200);
	ТаблицаДанных.Колонки.Добавить("АртикулПоставщика", ОписаниеТиповС, "АртикулПоставщика", 200);
	ТаблицаДанных.Колонки.Добавить("Наименование", ОписаниеТиповС, "Наименование", 200);
	ТаблицаДанных.Колонки.Добавить("СрокПроизводства", ОписаниеТиповС, "СрокПроизводства", 200);
	ТаблицаДанных.Колонки.Добавить("БазоваяЦена", ОписаниеТиповЧ, "БазоваяЦена", 10);
	ТаблицаДанных.Колонки.Добавить("ПроцентСкидки", ОписаниеТиповЧ, "ПроцентСкидки", 10);


	Для К = 2  По ТабличныйДокумент.ВысотаТаблицы Цикл
		
		НомерТекущейСтроки = НомерТекущейСтроки + 1;
		НоваяСтрока = ТаблицаДанных.Добавить();
		
		НомерКолонки = 1;
		
		Для Каждого Колонка Из ТаблицаДанных.Колонки Цикл
			ТекстЯчейки = ТабличныйДокумент.Область("R" 
														+ Формат(К, "ЧГ=0") 
														+ "C" 
														+ Формат(НомерКолонки)).Текст;
			Если НомерКолонки < 4 Тогда
				НоваяСтрока[Колонка.Имя] = ТекстЯчейки;	
			Иначе
				Попытка
					НоваяСтрока[Колонка.Имя] = Число(ТекстЯчейки);
				Исключение
					НоваяСтрока[Колонка.Имя] = 0;
				КонецПопытки;
			КонецЕсли;
			
			НомерКолонки = НомерКолонки +1;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ВыборкаНоменклатуры = СсылкиНаНоменклатуру(ТаблицаДанных);
	
	Пока ВыборкаНоменклатуры.Следующий() Цикл 
		
		Если Не ЗначениеЗаполнено(ВыборкаНоменклатуры.НоменклатураСсылка) Тогда 
			Сообщить("Для позиции " + ВыборкаНоменклатуры.Наименование + " не найдено соответствие!");	
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Объект.Состав.Добавить();
		НоваяСтрока.АртикулПоДаннымОрганизации = ВыборкаНоменклатуры.Артикул;
		НоваяСтрока.АртикулПоДанымПоставщика = ВыборкаНоменклатуры.АртикулПоставщика;
		НоваяСтрока.СрокПроизводства = ВыборкаНоменклатуры.СрокПроизводства;
		НоваяСтрока.БазоваяЦена = ВыборкаНоменклатуры.БазоваяЦена;
		НоваяСтрока.Скидка = ВыборкаНоменклатуры.ПроцентСкидки;
		НоваяСтрока.Номенклатура = ВыборкаНоменклатуры.НоменклатураСсылка;
		НоваяСтрока.Валюта = Объект.Договор.Валюта;
		НоваяСтрока.ИтоговаяСтоимость = ВыборкаНоменклатуры.ПроцентСкидки 
										- ВыборкаНоменклатуры.БазоваяЦена * ВыборкаНоменклатуры.ПроцентСкидки / 100;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СсылкиНаНоменклатуру(ТаблицаДанных)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДанных.Артикул,
	|	ТаблицаДанных.АртикулПоставщика,
	|	ТаблицаДанных.Наименование,
	|	ТаблицаДанных.БазоваяЦена,
	|	ТаблицаДанных.ПроцентСкидки,
	|	ТаблицаДанных.СрокПроизводства
	|ПОМЕСТИТЬ ВТ_ДанныеТабличногоДокумента
	|ИЗ
	|	&ТаблицаДанных КАК ТаблицаДанных
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура.Ссылка КАК НоменклатураСсылка,
	|	ВТ_ДанныеТабличногоДокумента.Артикул,
	|	ВТ_ДанныеТабличногоДокумента.АртикулПоставщика,
	|	ВТ_ДанныеТабличногоДокумента.Наименование,
	|	ВТ_ДанныеТабличногоДокумента.БазоваяЦена,
	|	ВТ_ДанныеТабличногоДокумента.ПроцентСкидки,
	|	ВТ_ДанныеТабличногоДокумента.СрокПроизводства
	|ИЗ
	|	ВТ_ДанныеТабличногоДокумента КАК ВТ_ДанныеТабличногоДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	|		ПО (ВТ_ДанныеТабличногоДокумента.Артикул = Номенклатура.Артикул
	|				ИЛИ ВТ_ДанныеТабличногоДокумента.АртикулПоставщика = Номенклатура.АртикулПоставщика
	|				ИЛИ ВТ_ДанныеТабличногоДокумента.Наименование = Номенклатура.Наименование)";
	
	Запрос.УстановитьПараметр("ТаблицаДанных", ТаблицаДанных);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка;
	
КонецФункции

