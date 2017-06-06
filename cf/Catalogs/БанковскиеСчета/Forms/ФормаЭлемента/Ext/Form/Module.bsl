﻿&НаСервере
Процедура НазначитьРеквизитыБанка(Значение, Банк, БИК, КоррСчет, Поле="")
	
	Если ТипЗнч(Значение) = Тип("СправочникСсылка.Банки") Тогда
		Банк = Значение;
	ИначеЕсли Поле = "Код" Тогда
		
		//Банк = Справочники.Банки.НайтиПоКоду(Значение);
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка
		|ИЗ
		|	Справочник.Банки
		|ГДЕ
		|	Код = """ + Значение + """ И НЕ ПометкаУдаления
		|");
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Банк = Выборка.Ссылка;
		Иначе
			Банк = Справочники.Банки.ПустаяСсылка();
		КонецЕсли;
	Иначе
		Банк = Справочники.Банки.НайтиПоРеквизиту(Поле, Значение);
	КонецЕсли;
		
	БИК		 = Банк.Код;
	КоррСчет = Банк.КоррСчет;
	
КонецПроцедуры


&НаКлиенте
Процедура БИКБанкаПриИзменении(Элемент)
	НазначитьРеквизитыБанка(БИКБанка, Объект.Банк, БИКБанка, КоррСчетБанка, "Код")
 КонецПроцедуры
&НаКлиенте
Процедура БИКБанкаДляРасчетовПриИзменении(Элемент)
	НазначитьРеквизитыБанка(БИКБанкаДляРасчетов, Объект.БанкДляРасчетов, БИКБанкаДляРасчетов, КоррСчетБанкаДляРасчетов, "Код")
 КонецПроцедуры
 &НаКлиенте
Процедура КоррСчетБанкаПриИзменении(Элемент)
	НазначитьРеквизитыБанка(КоррСчетБанка, Объект.Банк, БИКБанка, КоррСчетБанка, "КоррСчет")
 КонецПроцедуры
&НаКлиенте
Процедура КоррСчетБанкаДляРасчетовПриИзменении(Элемент)
	НазначитьРеквизитыБанка(КоррСчетБанкаДляРасчетов, Объект.БанкДляРасчетов, БИКБанкаДляРасчетов, КоррСчетБанкаДляРасчетов, "КоррСчет")
КонецПроцедуры
 &НаКлиенте
Процедура БанкПриИзменении(Элемент)
	НазначитьРеквизитыБанка(Объект.Банк, Объект.Банк, БИКБанка, КоррСчетБанка);
	Ответ = Вопрос("Сформировать новое наименование для счета?", РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.Наименование = СформироватьАвтоНаименование();
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура БанкДляРасчетовПриИзменении(Элемент)
	НазначитьРеквизитыБанка(Объект.БанкДляРасчетов, Объект.БанкДляРасчетов, БИКБанкаДляРасчетов, КоррСчетБанкаДляРасчетов);
КонецПроцедуры

&НаКлиенте
Функция СформироватьАвтоНаименование()
		
	СтрокаНаименования = ?(ЗначениеЗаполнено(Объект.Банк), Строка(Объект.Банк), "")
		+ " (" + Строка(Объект.ВалютаДенежныхСредств) + ")";
	СтрокаНаименования = Лев(СтрокаНаименования, 150);
	
	Возврат СтрокаНаименования;

КонецФункции

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = СформироватьАвтоНаименование();
	КонецЕсли;

КонецПроцедуры


