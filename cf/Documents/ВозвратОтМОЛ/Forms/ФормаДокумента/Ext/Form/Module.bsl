﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТипЦен = Справочники.ТипыЦен.НайтиПоНаименованию("Розничные");
	Валюта = Справочники.Валюты.НайтиПоКоду("643");
	//СтруктураКолонокТовары = ФункцииФормДокументов.ПолучитьСтруктуруКолонокТовары(Элементы.Товары, , ТипЦен, "Товары", , Валюта, , Валюта, ,,);
КонецПроцедуры

// ПОДБОР
&НаКлиенте
Процедура ПодборВыполнить()
	
	ИмяТабличнойЧасти = "Товары";
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	ПараметрыПодбора = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	
	ПараметрыПодбора.Вставить("МОЛ", 					Объект.МОЛ);
	ПараметрыПодбора.Вставить("ТипЦен", 					ТипЦен);
	ПараметрыПодбора.Вставить("Валюта", 					Валюта);
	ОткрытьФорму("Документ.ВозвратОтМОЛ.Форма.ФормаПодбора", ПараметрыПодбора, Элементы.Товары);
	
КонецПроцедуры
&НаСервере
Функция ПоместитьТоварыВХранилище() 
	
	Возврат ПоместитьВоВременноеХранилище(
					Объект.Товары.Выгрузить(), 
					УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресТоваровВХранилище)
	
	Объект.Товары.Загрузить(ПолучитьИзВременногоХранилища(АдресТоваровВХранилище));
	
КонецПроцедуры

//СОБЫТИЯ ФОРМЫ
&НаКлиенте
Процедура ТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение <> Неопределено Тогда		
		
		ПолучитьТоварыИзХранилища(ВыбранноеЗначение);		// получаем
		УдалитьИзВременногоХранилища(ВыбранноеЗначение); 	// заметаем следы
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСтрокаПриИзменении(Элемент)
	ТД = Элементы.Товары.ТекущиеДанные;
	ПересчитатьЦенуПриИзменении(ТД);
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьЦенуПриИзменении(ТекСтрока)
	
	ТекСтрока.Цена = РаботаСНоменклатурой.ПолучитьЦену(	ТекСтрока.Номенклатура, ТипЦен, Валюта, ТекСтрока.Упаковка); 
   	ТекСтрока.Сумма = ТекСтрока.Цена * ТекСтрока.Количество;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	 ТД = Элементы.Товары.ТекущиеДанные;
	 ТД.Сумма = ТД.Количество * ТД.Цена;
КонецПроцедуры

