﻿&НАсЕРВЕРЕ
Процедура ПечатьНаСервере(ТабДок, Физики)
	
	КолКолонок 	= 5;	    
	текКолонка 	= 0;

	Макет 		= Справочники.ФизическиеЛица.ПолучитьМакет("ШтрихКод");
	ТаблСтрока 	= Новый ТабличныйДокумент;
	Выводить 	= Ложь;
	
	Для Каждого Физик Из Физики Цикл вШтрихКоды = ШтрихКоды.ПолучитьШтрихКодыОбъекта(Физик); Если вШтрихКоды.Количество() = 1 Тогда ШтрихКод = вШтрихКоды[0];
		
		Макет.Параметры.ФИО = Физик.Наименование;
	 	ШтрихКоды.УстановитьШтрихКодВМакете(Макет, ШтрихКод, Ложь);
	
		// Увеличим счетчик
		 
		текКолонка 	= текКолонка + 1;
		
		// Добавим в макет
		
		Если текКолонка / КолКолонок = Цел(текКолонка / КолКолонок) Тогда // строка заполнена и готова
			
			ТаблСтрока.Присоединить(Макет);
		
			Если ТабДок.ПроверитьВывод(ТаблСтрока) Тогда ТабДок.Вывести(ТаблСтрока); Иначе ТабДок.ВывестиГоризонтальныйРазделительСтраниц(); ТабДок.Вывести(ТаблСтрока);КонецЕсли;
			
			ТаблСтрока	= Новый ТабличныйДокумент;
			текКолонка 	= 0;
			Выводить 	= Ложь;

		Иначе 
			
			ТаблСтрока.Присоединить(Макет); 
			Выводить = Истина; КонецЕсли; КонецЕсли;КонецЦикла;
		
	// Выведем еще раз
		
	Если Выводить Тогда 
		Если ТабДок.ПроверитьВывод(ТаблСтрока) Тогда ТабДок.Вывести(ТаблСтрока); Иначе ТабДок.ВывестиГоризонтальныйРазделительСтраниц();ТабДок.Вывести(ТаблСтрока);КонецЕсли; КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("Справочник.ФизическиеЛица.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
	ТабДок = Новый ТабличныйДокумент;
	ПечатьНаСервере(ТабДок, ПараметрКоманды);

	ФункцииФормДокументов.УстановитьНастройкиТабличногоДокумента(ТабДок);
	ТабДок.АвтоМасштаб = Истина;
	
	ТабДок.Показать();
	
КонецПроцедуры
