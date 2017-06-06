﻿
&НаСервере
Функция ОчищенныйМассив(Массив)
	
	Кол = Массив.Количество();
	ТипПользователь = Тип("СправочникСсылка.Пользователи");
	Для ном = 1 ПО Кол Цикл Если ТипЗнч(Массив[Кол - Ном]) <> ТипПользователь Или Массив[Кол - Ном].Пустая() Или Массив[Кол - Ном] = ПараметрыСеанса.ТекущийПользователь Тогда Массив.Удалить(Кол - Ном) КонецЕсли; КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

&НаСервере
Процедура ОбновитьДанные()
	
	СписокКтоВидит.Очистить();
	СписокКогоВидит.Очистить();
	
	СписокКтоВидит.ЗагрузитьЗначения(ОчищенныйМассив(ПолныеПрава.ПолучитьМенеджеровСДоступомКМоимПартнерам()));
	Если Не ПолныеПрава.ДоступныВсеПартнеры() Тогда
		СписокКогоВидит.ЗагрузитьЗначения(ОчищенныйМассив(ПолныеПрава.ПолучитьДоступныхМенеджеров())) КонецЕсли;
	
	Элементы.ДекорацияТолькоТыЕдинственный.Видимость 	= Не СписокКтоВидит.Количество();
	Элементы.СписокКтоВидит.Видимость 					= СписокКтоВидит.Количество();
	
	Элементы.ДекорацияОпятьТыЕдинственный.Видимость		= Не СписокКогоВидит.Количество();
	Элементы.СписокКогоВидит.Видимость 					= СписокКогоВидит.Количество();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не РольДоступна("ПолныеПрава") И Не РольДоступна("ПолныеПраваВОбласти") Тогда
			//ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(РазрешенныеПартнеры, "Пользователь", ПараметрыСеанса.ТекущийПользователь); 
	Иначе 	Элементы.ГруппаПравая.Заголовок = "Расшареные партнеры"; КонецЕсли;
	
	ОбновитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДанные();
	
КонецПроцедуры
