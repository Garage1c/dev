﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Новый ТабличныйДокумент;
	Если ТипЗнч(ПараметрКоманды[0]) = Тип("БизнесПроцессСсылка.ЗаявкаПокупателя") Тогда  
		
		Список = ПолучитьРеализацииПоЗаказу(ПараметрКоманды);
		Если Список.Количество() > 1 Тогда
			Реализация = Список.ВыбратьЭлемент();
			Если Реализация <> Неопределено Тогда
				РеализацияСсылка =  Реализация.Значение;
			КонецЕсли;
		ИначеЕсли Список.Количество() = 1 Тогда
			РеализацияСсылка = Список[0].Значение;
		Иначе
			Возврат;
		КонецЕсли;
		МассивСсылок = Новый Массив;
 		МассивСсылок.Добавить(РеализацияСсылка);
		
		Печать(ТабДок, МассивСсылок);
	Иначе
		Печать(ТабДок, ПараметрКоманды);
	КонецЕсли;
		
	ФункцииФормДокументов.УстановитьНастройкиТабличногоДокумента(ТабДок);
	
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ДвусторонняяПечать = ТипДвустороннейПечати.ПереворотВверх;

	Если ТабДок.Области.Количество() Тогда
		ТабДок.Показать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды)
	
	Инд = -1;
	Для Каждого Ссылка Из ПараметрКоманды Цикл Инд = Инд + 1;
		
		Если Инд Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		Обработки.ПечатьОбщихФорм.Печать_ТОРГ12(ТабДок, Ссылка);	
			
	КонецЦикла;
	
КонецПроцедуры
&НаСервере
Функция ПолучитьРеализацииПоЗаказу(ПараметрКоманды)
	
	МассивСсылок = Новый Массив;
	Для Каждого Строка ИЗ ПараметрКоманды Цикл
		МассивСсылок.Добавить(Строка.Заказ);
	КонецЦикла;
	
	Возврат Заказы.ПолучитьРеализацииПоЗаказу(МассивСсылок);
	
КонецФункции

