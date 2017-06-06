﻿
&НаКлиенте
Процедура ОтправитьВСборку(Команда)
	
	Закрыть("ВСборку");
	Возврат;
	
	ВремяТекущее = '00010101' + (ТекущаяДата() - НачалоДня(ТекущаяДата()));
	ДоступныйИнтервал = КэшируемыеФункции.ПолучитьДедлайнНаОтправкуВСборку();
	Если 
		
		ДоступныйИнтервал.Начало = ДоступныйИнтервал.Окончание ИЛИ
		(ВремяТекущее >= ДоступныйИнтервал.Начало И ВремяТекущее <= ДоступныйИнтервал.Окончание) Тогда
	
		Закрыть("ВСборку");
	Иначе
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ЗакрытиеПредупреждения", ЭтаФорма, Новый Структура("ИмяДействия", "ВСборку")), "Ваш заказ будет обработан НЕ ранее завтрашнего дня.");
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеПредупреждения(Параметры) Экспорт
	
	Закрыть(Параметры.ИмяДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура БыстроПродать(Команда)
	
	Закрыть("ПродатьЧастично");
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗаказСрезервом(Команда)
	
	Закрыть("Сохранить");
	
КонецПроцедуры


&НаКлиенте
Процедура ЭкстренноПродать(Команда)
	Закрыть("Экстренно");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КлючСохраненияПоложенияОкна =  Новый УникальныйИдентификатор;;
	Элементы.ГруппаЗакупить.Видимость = Параметры.ЕстьТоварПодЗаказ = Истина;
	Элементы.ВЗакупке.Видимость = Параметры.ЗакупитьНедостающее = Истина;
	Элементы.ДляПередачи.Видимость = Параметры.ПередачаТовара = Истина;
	Заказ=Параметры.Заказ;
	
КонецПроцедуры


&НаКлиенте
Процедура СохранитьИЗакупитьЗаказ(Команда)
	ПоказатьВопрос(Новый ОписаниеОповещения("ПодтверждениеВыполненияКоманды", ЭтаФорма), "Закупить недостающие позиции?", РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеВыполненияКоманды(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		Если Результат = КодВозвратаДиалога.Отмена Тогда Возврат;
		ИначеЕсли
			Результат = КодВозвратаДиалога.Нет Тогда
			
			Закрыть("Сохранить");
		Иначе
			Закрыть("СохранитьИЗакупить");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
