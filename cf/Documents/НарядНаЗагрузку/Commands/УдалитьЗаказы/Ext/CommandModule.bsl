﻿
//&НаКлиенте
//Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
//	
//	Перем ДокСсылка;
//	
//	СписокМашин = ЗагрузкаВАвтомобильЗаказов.ПолучитьСписокАвтомобилейДляЗагрузки();
//	ВыбрЭлемент = СписокМашин.ВыбратьЭлемент("Откуда убирать?");
//	
//	Если ВыбрЭлемент <> Неопределено Тогда стрСообщения = "";
//		Если ЗагрузкаВАвтомобильЗаказов.УдалитьЗаказы(ВыбрЭлемент.Значение, ПараметрКоманды, ДокСсылка, стрСообщения) Тогда
//			
//			СобытияСистемы.ОповеститьОИзмененииЗагрузкиАвтомобиля(ВыбрЭлемент.Значение);
//			ПоказатьОповещениеПользователя("Удаление заказов с погрузки", ПолучитьНавигационнуюСсылку(ДокСсылка), стрСообщения, БиблиотекаКартинок.ЗагрузкаЗаказа_Удаление) КонецЕсли;КонецЕсли;

//КонецПроцедуры


&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если НЕ ЗначениеЗаполнено(ПараметрКоманды) Тогда
		Возврат;
	КонецЕсли;
	СписокМашин = ЗагрузкаВАвтомобильЗаказов.ПолучитьСписокАвтомобилейДляЗагрузки();
	СписокМашин.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("ПослеВыбораЭлемента", ЭтотОбъект, ПараметрКоманды),"Откуда убирать?");
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораЭлемента(ВыбранныйЭлемент, СписокПараметров) Экспорт
	Перем ДокСсылка;
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;

	стрСообщения = "";
	Если ЗагрузкаВАвтомобильЗаказов.УдалитьЗаказы(ВыбранныйЭлемент.Значение, СписокПараметров, ДокСсылка, стрСообщения) Тогда
		СобытияСистемы.ОповеститьОИзмененииЗагрузкиАвтомобиля(ВыбранныйЭлемент.Значение);
		ПоказатьОповещениеПользователя("Удаление заказов с погрузки", ПолучитьНавигационнуюСсылку(ДокСсылка), стрСообщения, БиблиотекаКартинок.ЗагрузкаЗаказа_Удаление);
	КонецЕсли;
КонецПроцедуры
