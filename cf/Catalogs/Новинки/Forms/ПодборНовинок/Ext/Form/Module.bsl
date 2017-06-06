﻿
&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ЕстьСклад = ЗначениеЗаполнено(Склад);
	ЕстьПроизводитель = Производитель.Количество();
	
	Новинки.Очистить();
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Тов1.Номенклатура КАК Номенклатура
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.ОстаткиИОбороты(&Период, &КонецПериода, , ,"+?(ЕстьСклад,"Склад = &Склад","") + 
																					   ?(ЕстьСклад И ЕстьПроизводитель," И ","") + 
																					   ?(ЕстьПроизводитель," Номенклатура.Производитель В (&Производитель) ","")+") КАК Тов1
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.ОстаткиИОбороты(, &Период, , ,"+?(ЕстьПроизводитель," Номенклатура.Производитель В (&Производитель) ","")+" ) КАК Тов2
	|		ПО Тов1.Номенклатура = Тов2.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			НовинкиТовары.Номенклатура КАК Номенклатура
	|		ИЗ
	|			Справочник.Новинки.Товары КАК НовинкиТовары
	|		ГДЕ
	|			НовинкиТовары.Ссылка.ПометкаУдаления = ЛОЖЬ) КАК Новинки
	|		ПО Тов1.Номенклатура = Новинки.Номенклатура
	|ГДЕ
	|	Тов1.КоличествоНачальныйОстаток = 0
	|	И Тов1.КоличествоПриход > 0
	|	И Тов2.КоличествоПриход ЕСТЬ NULL 
	|	И Новинки.Номенклатура ЕСТЬ NULL ";
	Запрос.УстановитьПараметр("Период",Период.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода",Период.ДатаОкончания);
	Запрос.УстановитьПараметр("Производитель",Производитель);
	
	
	Запрос.УстановитьПараметр("Склад",Склад);
	Выборка = Запрос.Выполнить().Выгрузить();
	
	КонвертацияТипов.ДобавитьТаблицуКДругойТаблице(Новинки,Выборка);

КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	Очистить();
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если нЕ ЗначениеЗаполнено(Период) Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(ПолучитьАдресВременногоХранилищаТаблицы());
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресВременногоХранилищаТаблицы()
	
	Возврат ПоместитьВоВременноеХранилище(Новинки.Выгрузить(),УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура Очистить()
	ЭтотОбъект.Новинки.Очистить();
КонецПроцедуры
