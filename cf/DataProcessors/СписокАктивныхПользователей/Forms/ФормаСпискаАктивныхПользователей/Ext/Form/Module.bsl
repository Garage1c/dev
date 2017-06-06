﻿
&НаКлиенте
// процедура заполняет список активных пользователей, устанавливает текущую строку
Процедура ЗаполнитьСписок()
	// Для восстановления позиции запомним текущий сеанс
	ТекущийСеанс = Неопределено;
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущийСеанс = ТекущиеДанные.Сеанс;
	КонецЕсли;
	
	ЗаполнитьСписокПользователей();
	
	// Восстанавливаем текущую строку по запомненному сеансу
	Если ТекущийСеанс <> Неопределено Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Сеанс", ТекущийСеанс);
		НайденныеСеансы = СписокПользователей.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСеансы.Количество() = 1 Тогда
			Элементы.СписокПользователей.ТекущаяСтрока = НайденныеСеансы[0].ПолучитьИдентификатор();
			Элементы.СписокПользователей.ВыделенныеСтроки.Очистить();
			Элементы.СписокПользователей.ВыделенныеСтроки.Добавить(Элементы.СписокПользователей.ТекущаяСтрока);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналРегистрации()
	ЖурналРегистрации = ОткрытьФорму("Обработка.ЖурналРегистрации.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналРегистрацииПоПользователю()
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИмяПользователя  = ТекущиеДанные.ИмяПользователя;
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Новый Структура("Пользователь", ИмяПользователя));
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВыполнить()
	ЗаполнитьСписок();
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПоКолонке(Направление)
	Колонка = Элементы.СписокПользователей.ТекущийЭлемент;
	Если Колонка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКолонкиСортировки = Колонка.Имя;
	НаправлениеСортировки = Направление;
	
	ЗаполнитьСписок();
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоВозрастанию()
	СортировкаПоКолонке("Возр");
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоУбыванию()
	СортировкаПоКолонке("Убыв");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	ИмяКолонкиСортировки = "НачалоРаботы";
	НаправлениеСортировки = "Возр";
	ЗаполнитьСписокПользователей();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПользователей()
	ТЗСписокПользователей = РеквизитФормыВЗначение("СписокПользователей");
	ТЗСписокПользователей.Очистить();
	
	СеансыИБ = ПолучитьСеансыИнформационнойБазы();
	Если СеансыИБ <> Неопределено Тогда
		Для Каждого СеансИБ Из СеансыИБ Цикл
			СтрПользователя = ТЗСписокПользователей.Добавить();
			СтрПользователя.Пользователь = СеансИБ.Пользователь.Имя;
			СтрПользователя.Приложение   = ПредставлениеПриложения(СеансИБ.ИмяПриложения);
			СтрПользователя.НачалоРаботы = СеансИБ.НачалоСеанса;
			СтрПользователя.Компьютер    = СеансИБ.ИмяКомпьютера;
			СтрПользователя.Сеанс        = СеансИБ.НомерСеанса;
			СтрПользователя.ИмяПользователя = СеансИБ.Пользователь.Имя;
			Если СеансИБ.НомерСеанса = НомерСеансаИнформационнойБазы() Тогда
				СтрПользователя.НомерРисункаПользователя = 0;
			Иначе
				СтрПользователя.НомерРисункаПользователя = 1;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	КоличествоАктивныхПользователей = СеансыИБ.Количество();
	ТЗСписокПользователей.Сортировать(ИмяКолонкиСортировки + " " + НаправлениеСортировки);
	ЗначениеВРеквизитФормы(ТЗСписокПользователей, "СписокПользователей");
КонецПроцедуры
