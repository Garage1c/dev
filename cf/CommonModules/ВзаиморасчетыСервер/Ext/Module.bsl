﻿

//РОБОТ-Помощник бухгалтера
Функция ПолучитьЗаказыДляПлатежки(Парам) Экспорт
	
	Если Парам.ВидДокумента="ПлатежноеПоручениеИсходящее"
		или Парам.ВидДокумента="РасходныйКассовыйОрдер"
		Тогда
		ЭтоВозвратОплаты=Истина;
	Иначе
		ЭтоВозвратОплаты=Ложь;
	КонецЕсли;	
		
	
	ОтветРобота="Готово!";
	
	Если НЕ ЭтоВозвратОплаты Тогда
		
		//1. ищем в заказа по номеру
		ТекстЗапроса=
		"ВЫБРАТЬ 
		|	Заказ,
		|	Заказ.Дата ЗаказДата,
		|	Заказ.Номер ЗаказНомер,
		|	Сумма(Сумма)
		|из (
		|ВЫБРАТЬ 
		|	Заказ,
		|	СуммаОстаток Сумма
		|ИЗ
		|	РегистрНакопления.ДолгиПоЗаказам.Остатки(,Контрагент=&Контрагент)
		|Где
		|  СуммаОстаток>0
		|  и НЕ Заказ=Неопределено
		|
		|объединить все
		|
		| ВЫБРАТЬ 
		|	Заказ,
		|	Сумма
		|ИЗ
		|	РегистрНакопления.ДолгиПоЗаказам
		|Где
		|	Регистратор=&Регистратор
		|  и НЕ Заказ=Неопределено
		|) как ВТ
		|
		|Сгруппировать по Заказ,Заказ.Дата,Заказ.Номер
		|
		|Упорядочить по ЗаказДата Убыв
		|";
		
		Запрос=Новый Запрос;
		Запрос.Текст=ТекстЗапроса;
		Запрос.УстановитьПараметр("Контрагент",Парам.Контрагент);
		Запрос.УстановитьПараметр("Регистратор",Парам.Ссылка);
		ТабЗак=Запрос.Выполнить().Выгрузить();
		
		// выделяем цифры из назначения платежа, создаем массив найденных цифр
		МассивЦифр=ПолучитьМассивЦифрИзСтроки(Парам.НазначениеПлатежа);
		
		//убираем префиксы и лидирующие нули в номерах заказов
		УбратьПрефиксыИЛидирующиеНули(ТабЗак,"ЗаказНомер");
		
		//перебираем заказы и находим точные соответствия
		ТабРез=ПолучитьПодходящиеСтроки(МассивЦифр,ТабЗак,"ЗаказНомер");
		
		
		
		//2. если не нашли по номеру заказа - поищем по номеру документа отгрузки
		Если ТабРез.Количество()=0 Тогда
			ТекстЗапроса=
			"ВЫБРАТЬ 
			|	Заказ,
			|	ДокументОтгрузки,
			|	Заказ.Дата ЗаказДата,
			|	ДокументОтгрузки.Номер ДокументОтгрузкиНомер,
			|	ДокументОтгрузки.Дата ДокументОтгрузкиДата,
			|	Сумма(Сумма)
			|из (
			|ВЫБРАТЬ 
			|	Заказ,
			|	ДокументОтгрузки,
			|	СуммаОстаток Сумма
			|ИЗ
			|	РегистрНакопления.ДолгиПоОтгрузкам.Остатки(,Контрагент=&Контрагент)
			|Где
			|  СуммаОстаток>0
			|  и НЕ ДокументОтгрузки=Неопределено
			|
			|объединить все
			|
			| ВЫБРАТЬ 
			|	Заказ,
			|	ДокументОтгрузки,
			|	Сумма
			|ИЗ
			|	РегистрНакопления.ДолгиПоОтгрузкам
			|Где
			|	Регистратор=&Регистратор
			|  и НЕ ДокументОтгрузки=Неопределено
			|) как ВТ
			|
			|Сгруппировать по Заказ,ДокументОтгрузки,Заказ.Дата,ДокументОтгрузки.Дата,ДокументОтгрузки.Номер
			|
			|Упорядочить по ЗаказДата Убыв
			|";
			
			Запрос=Новый Запрос;
			Запрос.Текст=ТекстЗапроса;
			Запрос.УстановитьПараметр("Контрагент",Парам.Контрагент);
			Запрос.УстановитьПараметр("Регистратор",Парам.Ссылка);
			ТабОтгр=Запрос.Выполнить().Выгрузить();
			
			//убираем префиксы и лидирующие нули в номерах заказов
			УбратьПрефиксыИЛидирующиеНули(ТабОтгр,"ДокументОтгрузкиНомер");
			
			//перебираем заказы и находим точное соответствие номера документаОтгрузки
			ТабРез=ПолучитьПодходящиеСтроки(МассивЦифр,ТабОтгр,"ДокументОтгрузкиНомер");
			
			Если ТабРез.Количество()>0 Тогда
				ОтветРобота="Нашел по № отгрузки!";
			КонецЕсли;	
			
		КонецЕсли;	
		
		
		
	Иначе//это возврат оплаты
		
		ТекстЗапроса="
		//входящие номера платежек
		|Выбрать Ссылка.НомерВходящегоДокумента НомерПП, Заказ Поместить НомераПП из Документ.ПлатежноеПоручениеВходящее.РасшифровкаСуммы ГДЕ Ссылка.Контрагент=&Контрагент и Ссылка.Проведен
		|;
		|
		|Выбрать НомерПП, ВТ.Заказ, ЗаказДата, Сумма(Сумма) из (
		//все платежи поступления ДС идут со знаком+ возвраты со знаком- . В итоге получаем суммы платежей за минусом возвращенных.
		|Выбрать Заказ,Заказ.Дата,Сумма из РегистрНакопления.ДолгиПоЗаказам 
		|ГДЕ Контрагент=&Контрагент и ВидДвижения=Значение(ВидДвиженияНакопления.расход)  и не Заказ=Неопределено и НЕ Регистратор=&Регистратор
		|) как ВТ
		|Левое соединение НомераПП
		|По ВТ.Заказ=НомераПП.Заказ
		|Сгруппировать по НомерПП,ВТ.Заказ,ЗаказДата
		|
		|Упорядочить по ЗаказДата Убыв
		|"
		;
		
		Запрос=Новый Запрос;
		Запрос.Текст=ТекстЗапроса;
		Запрос.УстановитьПараметр("Контрагент",Парам.Контрагент);
		Запрос.УстановитьПараметр("Регистратор",Парам.Ссылка);
		ТабОтгр=Запрос.Выполнить().Выгрузить();
		
		// выделяем цифры из назначения платежа, создаем массив найденных цифр
		МассивЦифр=ПолучитьМассивЦифрИзСтроки(Парам.НазначениеПлатежа);
		
		//перебираем заказы и находим точное соответствие номера ПП
		ТабРез=ПолучитьПодходящиеСтроки(МассивЦифр,ТабОтгр,"НомерПП");
		
	КонецЕсли;
	
	
	
	//3. если ничего не нашли, подыщем по сумме в таблице заказов
	Если ТабРез.Количество()=0 Тогда
		Отбор=Новый Структура("Сумма",парам.Сумма);
		мСтрок=ТабЗак.НайтиСтроки(Отбор);
		Если мСтрок.Количество()=1 Тогда
			НовСтр=ТабРез.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр,мСтрок[0]);
			ОтветРобота="Нашел по сумме заказа!";
		ИначеЕсли мСтрок.Количество()>1 Тогда
			//ТЗ отсортирована по убыванию, так что берем последний док
			Для Каждого Стр из мСтрок Цикл
				Если ЗначениеЗаполнено(Стр.Заказ) Тогда
					НовСтр=ТабРез.Добавить();
					ЗаполнитьЗначенияСвойств(НовСтр,Стр);
					ОтветРобота="Нашел несколько заказов по сумме,"+Символы.ПС+"взял первый попавшийся!";
					Прервать;
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;	
		
	КонецЕсли;	
	
	
	//4. если и теперь не нашли, то попробуем по сумме в таблице док.Отгрузки
	Если ТабРез.Количество()=0 Тогда
		Отбор=Новый Структура("Сумма",парам.Сумма);
		мСтрок=ТабОтгр.НайтиСтроки(Отбор);
		Если мСтрок.Количество()=1 Тогда
			НовСтр=ТабРез.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр,мСтрок[0]);
			ОтветРобота="Нашел по сумме док.отгр !";
		ИначеЕсли мСтрок.Количество()>1 Тогда
			//ТЗ отсортирована по убыванию, так что берем последний док
			Для Каждого Стр из мСтрок Цикл
				Если ЗначениеЗаполнено(Стр.Заказ) Тогда
					НовСтр=ТабРез.Добавить();
					ЗаполнитьЗначенияСвойств(НовСтр,Стр);
					ОтветРобота="Нашел несколько док.отгр. по сумме,"+Символы.ПС+"взял первый попавшийся!";
					Прервать;
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;	
		
	КонецЕсли;	
	
	
	//5. сдаемся
	Если ТабРез.Количество()=0 Тогда
		ОтветРобота="Не смог найти ничего подходящего...";
	КонецЕсли;	
	
	
	//регулируем сумму
	ИтогСумма=ТабРез.Итог("Сумма");
	Если ИтогСумма<Парам.Сумма Тогда
		НовСтр=ТабРез.Добавить();
		НовСтр.Заказ=Неопределено;
		Новстр.Сумма=Парам.Сумма-ИтогСумма;
	ИначеЕсли ИтогСумма>Парам.Сумма Тогда
		ТабРез.Сортировать("ЗаказДата Убыв");
		ОсталосьУрезать=ИтогСумма-Парам.Сумма;
		Для Каждого Стр из ТабРез Цикл
			Урезаем=Мин(Стр.Сумма,ОсталосьУрезать);
			Если Урезаем=0 Тогда Прервать; КонецЕсли;
			Стр.Сумма=Стр.Сумма-Урезаем;
			ОсталосьУрезать=ОсталосьУрезать-Урезаем;
		КонецЦикла;	
		
	КонецЕсли;	
	
	ТабРез.Сортировать("ЗаказДата Возр");
	
	Возврат Новый Структура("ТабЗаказов,ОтветРобота",ТабРез,ОтветРобота);
	
КонецФункции

Функция ПолучитьМассивЦифрИзСтроки(Стр)
	цифры="0123456789";
	МассивЦифр=Новый Массив;
	ПредСимволЭтоЦифра=Ложь;
	ТекЦифра="";
	Для Поз=1 по СтрДлина(Стр) Цикл
		ТекСимвол= Сред(Стр,Поз,1);
		Если СтрНайти(цифры,ТекСимвол)>0 Тогда
			
			ТекЦифра=ТекЦифра+ТекСимвол;
			
			ПредСимволЭтоЦифра=Истина;
		Иначе
			Если Не ТекЦифра="" Тогда
				МассивЦифр.Добавить(ТекЦифра);
				ТекЦифра="";
			КонецЕсли;	
			
			ПредСимволЭтоЦифра=Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивЦифр;
КонецФункции	

Функция ПолучитьПодходящиеСтроки(МассивЦифр,ТЗ,ИмяКолонки)
	
	ТабРез=ТЗ.СкопироватьКолонки();
	Для Каждого Стр из ТЗ Цикл
		ТекНомер=Стр[ИмяКолонки];
		Для Каждого Цифра из МассивЦифр Цикл
			Если ТекНомер=Цифра Тогда
				НовСтр=ТабРез.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтр,Стр);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;	
	
	Возврат ТабРез;
КонецФункции

Процедура УбратьПрефиксыИЛидирующиеНули(ТЗ,ИмяКолонки)
	цифрыБезНулей="123456789";
	Для Каждого Стр из ТЗ Цикл
		ТекНомер=Стр[ИмяКолонки];
		Для Поз=1 по СтрДлина(ТекНомер) Цикл
			ТекСимвол= Сред(ТекНомер,Поз,1);
			Если СтрНайти(цифрыБезНулей,ТекСимвол)=0 Тогда
				Продолжить;
			Иначе
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		ТекНомер=Сред(ТекНомер,Поз);
		Стр[ИмяКолонки]=ТекНомер;
	КонецЦикла;
КонецПроцедуры	


//РОБОТ-разносчик платежк по документам отгрузки
Процедура РаспределитьОплаты() Экспорт
	
	#Область РаспределениеОплат
	//алгоритм:
	//1. выбираем движения "расход" с положительными суммами, заполненными заказами, но не заполнеными документами-отгрузками 
	//2. выбираем незакрытые отгрузки (положительные остатки)
	//3. перебираем регистраторы и привязываем по ФИФО
	
	ТекстЗапроса=
	"  
	//выбираем регистраторы (в т.ч. вводы остатков с отрицательными приходами)
	|ВЫБРАТЬ
	|	НачалоПериода(Период,Месяц) Период,
	|	Регистратор,
	|	ТипЗначения(Регистратор) ВидДок,
	|	Организация,
	|	Контрагент,
	|	Заказ,
	|	Сумма СуммаОплаты
	|Поместить Регистраторы
	|ИЗ
	|	РегистрНакопления.ДолгиПоОтгрузкам 
	|
	|Где
	|	ВидДвижения = Значение(ВидДвиженияНакопления.Расход) 
	|	и Сумма>0
	|  и НЕ Заказ = Неопределено
	|  и ДокументОтгрузки = Неопределено
	|
	|Объединить все
	|
	|ВЫБРАТЬ
	|	НачалоПериода(Период,Месяц) Период,
	|	Регистратор,
	|	ТипЗначения(Регистратор) ВидДок,
	|	Организация,
	|	Контрагент,
	|	Заказ,
	|	-Сумма СуммаОплаты
	|ИЗ
	|	РегистрНакопления.ДолгиПоОтгрузкам 
	|
	|Где
	|	ВидДвижения = Значение(ВидДвиженияНакопления.Приход) 
	|	и Регистратор Ссылка Документ.РедактированиеРегистра
	|	и Сумма<0
	|  и НЕ Заказ = Неопределено
	|  и ДокументОтгрузки = Неопределено
	|;
	//выбираем незакрытые отгрузки
	| ВЫБРАТЬ 
	|	Организация,
	|	Контрагент,
	|	Заказ,
	|	ДокументОтгрузки,
	|	СуммаОстаток СуммаОтгр
	|Поместить Остатки
	|ИЗ
	|	РегистрНакопления.ДолгиПоОтгрузкам.Остатки
	|Где
	|  СуммаОстаток>0
	|  и НЕ Заказ=Неопределено
	|  и НЕ ДокументОтгрузки=Неопределено
	|;
	|
	|Выбрать Период,Регистратор,ВидДок,Организация,Контрагент,Заказ,Сумма(СуммаОплаты) СуммаОплаты 
	|из Регистраторы 
	|ГДЕ Заказ в (Выбрать Заказ из Остатки) 
	|Сгруппировать по Период,Регистратор,ВидДок,Организация,Контрагент,Заказ 
	|Упорядочить по Период 
	|Итоги Сумма(СуммаОплаты) по Период,Регистратор 
	|;
	|
	|Выбрать * из Остатки ГДЕ Заказ в (Выбрать Заказ из Регистраторы)
	|Упорядочить по ДокументОтгрузки.Дата
	|";
	
	ОбработатьРегистраторыПоФИФО(ТекстЗапроса,1);
	
	#КонецОбласти
	
	
	#Область РаспределениеВозвратовОплат
	//делаем отдельной итерацией так как после распределения оплат изменятся остатки
	
	
	//алгоритм:
	//1. выбираем движения "расход" с отрицательным количеством с заполненными заказами, но не заполнеными документами-отгрузками 
	//2. выбираем отрицательные остатки с заполненными заказами и документами отгрузок (возникают после проведения возвратов от покупателя)
	//3. перебираем регистраторы и привязываем к остаткам по ФИФО
	
	
	ТекстЗапроса=
	"  
	//выбираем регистраторы
	|ВЫБРАТЬ
	|	НачалоПериода(Период,Месяц) Период,
	|	Регистратор,
	|	ТипЗначения(Регистратор) ВидДок,
	|	Организация,
	|	Контрагент,
	|	Заказ,
	|	-Сумма СуммаОплаты
	|Поместить Регистраторы
	|ИЗ
	|	РегистрНакопления.ДолгиПоОтгрузкам 
	|
	|Где
	|	ВидДвижения = Значение(ВидДвиженияНакопления.Расход) 
	|	и Сумма<0
	|  и НЕ Заказ = Неопределено
	|  и ДокументОтгрузки = Неопределено
	|
	|;
	//выбираем остатки 
	| ВЫБРАТЬ 
	|	Организация,
	|	Контрагент,
	|	Заказ,
	|	ДокументОтгрузки,
	|	-СуммаОстаток СуммаОтгр
	|Поместить Остатки
	|ИЗ
	|	РегистрНакопления.ДолгиПоОтгрузкам.Остатки
	|Где
	|  СуммаОстаток<0
	|  и НЕ Заказ=Неопределено
	|  и НЕ ДокументОтгрузки=Неопределено
	|;
	|Выбрать Период,Регистратор,ВидДок,Организация,Контрагент,Заказ,Сумма(СуммаОплаты) СуммаОплаты 
	|из Регистраторы 
	|ГДЕ Заказ в (Выбрать Заказ из Остатки) 
	|Сгруппировать по Период,Регистратор,ВидДок,Организация,Контрагент,Заказ 
	|Упорядочить по Период 
	|Итоги Сумма(СуммаОплаты) по Период,Регистратор 
	|;
	|Выбрать * из Остатки ГДЕ Заказ в (Выбрать Заказ из Регистраторы)
	|Упорядочить по ДокументОтгрузки.Дата
	|";
	
	ОбработатьРегистраторыПоФИФО(ТекстЗапроса,-1);
	
	#КонецОбласти
	
КонецПроцедуры	


Процедура ОбработатьРегистраторыПоФИФО(ТекстЗапроса,Коэф,ОтключитьИтоги=Ложь)
	
	//коэф - коэффициент для записи сумм в регистр. Для распределения оплат ставим 1, для возвратов оплат клиентам -1.
	
	Запрос=Новый Запрос;
	Запрос.Текст=ТекстЗапроса;
	мРез= Запрос.ВыполнитьПакет();
	ТабОст=мРез[3].Выгрузить();
	ТабОст.Индексы.Добавить("Организация,Контрагент,Заказ");
		
	Если ОтключитьИтоги Тогда
		РегистрыНакопления.ДолгиПоОтгрузкам.УстановитьИспользованиеИтогов(Ложь);
	КонецЕсли;	
	
	ВыборкаПериод=мРез[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПериод.Следующий() Цикл
		
		НачатьТранзакцию();// запись делаем порциями по месяцам
		
		ВыборкаРег=ВыборкаПериод.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам); //каждый регистратор проходим один раз
		Пока ВыборкаРег.Следующий() Цикл
			
			ВидДок=ВыборкаРег.Регистратор.Метаданные().Имя;
			
			Если ВидДок="ПлатежноеПоручениеВходящее"
				ИЛИ ВидДок="ПлатежноеПоручениеИсходящее"
				ИЛИ ВидДок="ПриходныйКассовыйОрдер"
				ИЛИ ВидДок="РасходныйКассовыйОрдер"
				ИЛИ ВидДок="ОплатаБанковскойКартой" Тогда
					ОбработатьДокументСТЧ(ВыборкаРег,ТабОст);
			ИначеЕсли ВидДок="РедактированиеРегистра" Тогда
				ОбработатьДокументРедРегистра(ВыборкаРег,ТабОст,Коэф);
			ИначеЕсли ВидДок="ОплатаЭлектроннымиДеньгами" Тогда
				ОбработатьДокументОплЭД(ВыборкаРег,ТабОст);
			Иначе
				ЗаписьЖурналаРегистрации("РаспределениеОплатПоОтгрузкам",УровеньЖурналаРегистрации.Ошибка, ,ВыборкаРег.Регистратор,"Встречен документ неизвестного вида. Документ "+ВыборкаРег.Регистратор+" не обработан.");
			КонецЕсли;	
			
		КонецЦикла;//по регистраторам
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;//по месяцам	
	
	Если ОтключитьИтоги Тогда
		РегистрыНакопления.ДолгиПоОтгрузкам.УстановитьИспользованиеИтогов(Истина);
	КонецЕсли;	
	
КонецПроцедуры


Процедура ОбработатьДокументСТЧ(ВыборкаРег,ТабОст)
	
	ДокОбъект=ВыборкаРег.Регистратор.ПолучитьОбъект();
	ТЗ=ДокОбъект.РасшифровкаСуммы;
	
	Выборка=ВыборкаРег.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Отбор=Новый Структура("Заказ,ДокументОтгрузки",Выборка.Заказ,Неопределено);
		мЗап=ТЗ.НайтиСтроки(Отбор);
		
		Если мЗап.Количество()=0 Тогда //это исключительная ситуация с которой нужно разбираться
			ЗаписьЖурналаРегистрации("РаспределениеОплатПоОтгрузкам",УровеньЖурналаРегистрации.Ошибка, ,ДокОбъект.Ссылка,"В ТЧ документа не найдены строки попавшие в запрос ("+Выборка.Организация+" ; "+Выборка.Контрагент+" ; "+Выборка.Заказ+" ; ДокументОтгрузки=Неопределено). Документ "+Выборка.Регистратор+" не обработан.");
			Продолжить; 
		КонецЕсли;	
		
		//удаляем старые записи
		ОсталосьСписать=0;
		Для Каждого Зап из мЗап Цикл
			ОсталосьСписать=ОсталосьСписать+Зап.Сумма;
			ТЗ.Удалить(Зап);
		КонецЦикла;	
		
		
		//создаем новые записи по FIFO
		Отбор=Новый Структура("Организация,Контрагент,Заказ",Выборка.Организация,Выборка.Контрагент,Выборка.Заказ);
		мОст=ТабОст.НайтиСтроки(Отбор);
		
		Для Каждого Ост из мОст Цикл
			Списываем = Мин(ОсталосьСписать,Ост.СуммаОтгр);
			
			Если Списываем<=0 Тогда Продолжить; КонецЕсли;
			
			Нов=ТЗ.Добавить();
			Нов.Заказ=Выборка.Заказ;
			Нов.ДокументОтгрузки=Ост.ДокументОтгрузки;
			Нов.Сумма=Списываем;
			
			ОсталосьСписать = ОсталосьСписать-Списываем;
			
			//актуализируем таблицу 
			Ост.СуммаОтгр=Ост.СуммаОтгр-Списываем;
			
		КонецЦикла;
		//если так и не распределилось - добавляем пустую запись
		Если ОсталосьСписать>0 тогда
			Нов=ТЗ.Добавить();
			Нов.Заказ=Выборка.Заказ;
			Нов.ДокументОтгрузки=Неопределено;
			Нов.Сумма=ОсталосьСписать;
		КонецЕсли;	
		
	КонецЦикла;
	
	ЗаписатьИПровестиДокумент(ДокОбъект);
	
КонецПроцедуры	


Процедура ОбработатьДокументРедРегистра(ВыборкаРег,ТабОст,Коэф)

	НЗ=РегистрыНакопления.ДолгиПоОтгрузкам.СоздатьНаборЗаписей();
	НЗ.Отбор.Регистратор.Установить(ВыборкаРег.Регистратор);
	НЗ.Прочитать();
	ТЗ=НЗ.Выгрузить();
	
	Выборка=ВыборкаРег.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		
		//находим записи
		Отбор=Новый Структура("Организация,Контрагент,Заказ,ДокументОтгрузки",Выборка.Организация,Выборка.Контрагент,Выборка.Заказ,Неопределено); //фильтруем также по Контрагенту и организации т.к. в данных могут быть ошибочные заказы
		
		мЗап=ТЗ.НайтиСтроки(Отбор);
		
		Если мЗап.Количество()=0 Тогда //это исключительная ситуация с которой нужно разбираться
			ЗаписьЖурналаРегистрации("РаспределениеОплатПоОтгрузкам",УровеньЖурналаРегистрации.Ошибка, ,ВыборкаРег.Регистратор,"У документа отсутствуют движения попавшие в запрос ("+Выборка.Организация+" ; "+Выборка.Контрагент+" ; "+Выборка.Заказ+" ; ДокументОтгрузки=Неопределено). Документ "+ВыборкаРег.Регистратор+" не обработан.");
			Продолжить; 
		КонецЕсли;	
		
		//заполняем шаблон
		Шаблон=Новый Структура("ВидДвижения,Активность,Период,Регистратор,Контрагент,Контрагент,Организация");
		ЗаполнитьЗначенияСвойств(Шаблон,мЗап[0]);
		Шаблон.ВидДвижения=ВидДвиженияНакопления.Расход; //новые движения - всегда расход с положительной суммой
		
		
		//удаляем старые записи
		ОсталосьСписать=0;
		Для Каждого Зап из мЗап Цикл
			ЗнакДвижения=?(Зап.ВидДвижения=ВидДвиженияНакопления.Расход,1,-1); //расход - это нормальный вид записи, но в некоторых документах ввода остатков присутствует приход с минусом
			ОсталосьСписать=ОсталосьСписать+Зап.Сумма*Коэф*ЗнакДвижения;
			ТЗ.Удалить(Зап);
		КонецЦикла;	
		
		
		//создаем новые записи на основании данных об остатках
		Отбор=Новый Структура("Организация,Контрагент,Заказ",Выборка.Организация,Выборка.Контрагент,Выборка.Заказ);
		мОст=ТабОст.НайтиСтроки(Отбор);
		
		Для Каждого Ост из мОст Цикл
			Списываем = Мин(ОсталосьСписать,Ост.СуммаОтгр);
			
			Если Списываем<=0 Тогда Продолжить; КонецЕсли;
			
			Нов=ТЗ.Добавить();
			ЗаполнитьЗначенияСвойств(Нов,Шаблон);
			Нов.Заказ=Выборка.Заказ;
			Нов.ДокументОтгрузки=Ост.ДокументОтгрузки;
			Нов.Сумма=Коэф*Списываем;
			
			ОсталосьСписать = ОсталосьСписать-Списываем;
			
			//актуализируем таблицу 
			Ост.СуммаОтгр=Ост.СуммаОтгр-Списываем;
			
		КонецЦикла;
		//если так и не распределилось - добавляем пустую запись
		Если ОсталосьСписать>0 тогда
			Нов=ТЗ.Добавить();
			ЗаполнитьЗначенияСвойств(Нов,Шаблон); 
			Нов.Заказ=Выборка.Заказ;
			Нов.ДокументОтгрузки=Неопределено;
			Нов.Сумма=Коэф*ОсталосьСписать;
		КонецЕсли;	
		
	КонецЦикла;
	
	
	Попытка
		НЗ.Загрузить(ТЗ);
		НЗ.Записать(Истина);
	Исключение
		
		Ош = ОписаниеОшибки();
		ЗаписьЖурналаРегистрации("РаспределениеОплатПоОтгрузкам",УровеньЖурналаРегистрации.Ошибка, ,ВыборкаРег.Регистратор,"Не удалось записать набор записей для "+ВыборкаРег.Регистратор+". Документ не обработан. "+Ош);
		
	КонецПопытки;	
	
	
КонецПроцедуры	

Процедура ОбработатьДокументОплЭД(ВыборкаРег,ТабОст)
	
	ДокОбъект=ВыборкаРег.Регистратор.ПолучитьОбъект();
	
	Выборка=ВыборкаРег.Выбрать();
	Пока Выборка.Следующий() Цикл
		Отбор=Новый Структура("Организация,Контрагент,Заказ",Выборка.Организация,Выборка.Контрагент,Выборка.Заказ);
		мОст=ТабОст.НайтиСтроки(Отбор);
		Для Каждого Ост из мОст Цикл
			ДокОбъект.ДокументОтгрузки=Ост.ДокументОтгрузки;
			
			Если ДокОбъект.Сумма>Ост.СуммаОтгр Тогда
				ЗаписьЖурналаРегистрации("РаспределениеОплатПоОтгрузкам",УровеньЖурналаРегистрации.Предупреждение, ,ВыборкаРег.Регистратор,"Сумма документа Оплата электронными деньгами больше суммы отгрузки. Документ "+ВыборкаРег.Регистратор+" обработан, но требует ручной корректировки");
			КонецЕсли;
			
			Прервать;
		КонецЦикла;
		Прервать;
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(ДокОбъект.ДокументОтгрузки) Тогда
		ЗаписьЖурналаРегистрации("РаспределениеОплатПоОтгрузкам",УровеньЖурналаРегистрации.Предупреждение, ,ВыборкаРег.Регистратор,"Для документа "+ВыборкаРег.Регистратор+" не найден документ отгрузки. Документ не обработан.");
	КонецЕсли;
	
	
	ЗаписатьИПровестиДокумент(ДокОбъект);
	
КонецПроцедуры	
	
Процедура ЗаписатьИПровестиДокумент(ДокОбъект)
	
	ВидДок=ДокОбъект.Метаданные().Имя;
	Ссылка=ДокОбъект.Ссылка;
	
	Попытка
		//запишем документ
		ДокОбъект.ОбменДанными.Загрузка=Истина;
		ДокОбъект.Записать(РежимЗаписиДокумента.Запись);
		
		//проведем ускоренным методом
		Движения = Новый Массив;
		ИмяДвижения1 = "ДолгиПоОтгрузкам";
		ИмяДвижения2 = "ДолгиПоЗаказам";
		Движения.Добавить(ИмяДвижения1);
		Движения.Добавить(ИмяДвижения2);
		
		ДополнительныеСвойства = Новый Структура; 
		ДополнительныеСвойства.Вставить("ИменаРегистров",Движения);
		Документы[ВидДок].ИницилизироватьДополнительныеДанныеДокумента(Ссылка, ДополнительныеСвойства); 
		
		НовТаблица 		= ДополнительныеСвойства[ИмяДвижения1];
		НаборЗаписей 	= РегистрыНакопления[ИмяДвижения1].СоздатьНаборЗаписей(); 
		НаборЗаписей.Отбор.Регистратор.Установить(Ссылка);
		НаборЗаписей.Загрузить(НовТаблица); 
		НаборЗаписей.записать();
		
		НовТаблица 		= ДополнительныеСвойства[ИмяДвижения2];
		НаборЗаписей 	= РегистрыНакопления[ИмяДвижения2].СоздатьНаборЗаписей(); 
		НаборЗаписей.Отбор.Регистратор.Установить(Ссылка);
		НаборЗаписей.Загрузить(НовТаблица); 
		НаборЗаписей.записать();
		
	Исключение
		
		Ош = ОписаниеОшибки();
		ЗаписьЖурналаРегистрации("РаспределениеОплатПоОтгрузкам",УровеньЖурналаРегистрации.Ошибка, ,Ссылка,"Не удалось записать и провести документ "+Ссылка+". Документ не обработан. "+Ош);
		
	КонецПопытки;	
	
КонецПроцедуры	



//старая функция
//производит привязку Платежны поручений входящих (а также ПКО, Оплата банковской картой, Оплата эл.деньгами) к документам отгрузки 
//при условии: 
//1. платежка привязана к заказу (как предоплата)
//2. Сумма отгрузки по заказу равна сумме в строке платежки по заказу
//
//все остальные случаи подлежат ручному разнесению
//На всякий случай ограничим выборку 10000 записями
Процедура РаспределитьОплаты_ст() Экспорт
	
	Запрос=Новый Запрос;
	Запрос.Текст=
	"  
	| ВЫБРАТЬ 
	|	Отгрузки.Заказ,
	|	Отгрузки.ДокументОтгрузки,
	|	Отгрузки.СуммаОстаток СуммаОтгрузки
	|Поместить Отгрузки
	|ИЗ
	|	РегистрНакопления.ДолгиПоОтгрузкам.Остатки Отгрузки
	|Где
	|  СуммаОстаток>0
	|  и Не Заказ=Неопределено
	|  И Не ДокументОтгрузки=Неопределено
	|;
	|
	//выбираем нераспределенные по  отгрузкам и привязанные к заказу оплаты
	|ВЫБРАТЬ
	|	Оплаты.Заказ,
	|	Оплаты.СуммаОстаток СуммаОплаты,
	|	Отгрузки.Заказ ,
	|	Отгрузки.ДокументОтгрузки ,
	|	Отгрузки.СуммаОтгрузки СуммаОтгрузки
	|Поместить ТабПривязки	
	|ИЗ
	|	РегистрНакопления.ДолгиПоОтгрузкам.Остатки Оплаты
	|Внутреннее Соединение
	|
	|Отгрузки
	| 
	|По Отгрузки.Заказ=Оплаты.Заказ
	|
	|Где
	|  Оплаты.ДокументОтгрузки=Неопределено
	|  и Не Оплаты.Заказ=Неопределено
	|  и Оплаты.СуммаОстаток = - Отгрузки.СуммаОтгрузки 
	|
	|;
	|
	//выбираем регистраторы-платежные документы по нужным заказам
	|Выбрать различные
	|	Регистратор,Заказ
	|Поместить Регистраторы
	|из РегистрНакопления.ДолгиПоОтгрузкам 
	|Где
	|ВидДвижения = Значение(ВидДвиженияНакопления.Расход)
	|И Заказ в (Выбрать Заказ из ТабПривязки)
	|; 
	|  
	|Выбрать 
	|	Рег.Регистратор,
	|	ТабПривязки.Заказ ,
	|	ТабПривязки.ДокументОтгрузки,
	|	ТабПривязки.СуммаОтгрузки
	|из Регистраторы Рег
	|внутреннее соединение
	|	ТабПривязки
	|По Рег.Заказ = ТабПривязки.Заказ
	|	";

	Рез= Запрос.Выполнить();

	Выборка=Рез.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДокОбъект=Выборка.Регистратор.ПолучитьОбъект();
		ВидДок=ДокОбъект.Метаданные().Имя;
		
		Если ВидДок="ПлатежноеПоручениеВходящее"
		 ИЛИ ВидДок="ПриходныйКассовыйОрдер"
		 ИЛИ ВидДок="ОплатаБанковскойКартой" Тогда
			ТЧ=ДокОбъект.РасшифровкаСуммы;
			Отбор=Новый Структура;
			Отбор.Вставить("Заказ",Выборка.Заказ);
			Отбор.Вставить("ДокументОтгрузки",Неопределено);
			Отбор.Вставить("Сумма",Выборка.СуммаОтгрузки);
			МассивСтрок=ТЧ.НайтиСтроки(Отбор);
			Если МассивСтрок.Количество()>0 Тогда
				СтрТЧ=МассивСтрок[0];
				СтрТЧ.ДокументОтгрузки=Выборка.ДокументОтгрузки;
			Иначе
				//такое часто случается в случае если оплата была на нужную сумму, но несколькими документами.
				
				//ЗаписьЖурналаРегистрации("Не удалось найти нужную строку в расшифровке платежа документа "+Выборка.Регистратор+". Оплата не разнесена.", УровеньЖурналаРегистрации.Ошибка, , ,Строка(Выборка.Заказ)+" + "+Выборка.СуммаОтгрузки);
				Продолжить;
			КонецЕсли;	
		
		ИначеЕсли ВидДок="ОплатаЭлектроннымиДеньгами" Тогда
			ДокОбъект.ДокументОтгрузки=Выборка.ДокументОтгрузки;
		Иначе
			ЗаписьЖурналаРегистрации("Встречен документ нового вида "+Выборка.ПредставлРегистраторениеДока+". Оплата не разнесена.", УровеньЖурналаРегистрации.Ошибка, , ,Выборка.Регистратор+" + "+Выборка.СуммаОтгрузки);
			Продолжить;
		КонецЕсли;
		
		
		Попытка
			//запишем документ
			ДокОбъект.Записать(РежимЗаписиДокумента.Запись);
			
			//проведем ускоренным методом
			Движения = Новый Массив;
			ИмяДвижения = "ДолгиПоОтгрузкам";
			Движения.Добавить(ИмяДвижения);
			ДополнительныеСвойства = Новый Структура; 
			ДополнительныеСвойства.Вставить("ИменаРегистров",Движения);
			Документы[ВидДок].ИницилизироватьДополнительныеДанныеДокумента(Выборка.Регистратор, ДополнительныеСвойства); 
			НовТаблица 		= ДополнительныеСвойства[ИмяДвижения];
			НаборЗаписей 	= РегистрыНакопления[ИмяДвижения].СоздатьНаборЗаписей(); 
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Загрузить(НовТаблица); 
			НаборЗаписей.записать();
			
			//ЗаписьЖурналаРегистрации("Распределена оплата в документе "+Выборка.ПредставлениеДока, УровеньЖурналаРегистрации.Информация, , ,);
			
		Исключение
			
			Ош = ОписаниеОшибки();
			ЗаписьЖурналаРегистрации("Не удалось записать и провести документ "+Выборка.ПредставлениеДока+". Оплата не разнесена.", УровеньЖурналаРегистрации.Ошибка, , ,Ош);
			
		КонецПопытки;	
	КонецЦикла;	
	
КонецПроцедуры	

