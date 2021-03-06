﻿
Функция ИзменитьКартинкиТовараНаСайте(НоменклатураСсылка) Экспорт
	
	Если НоменклатураСсылка.ЭтоГруппа Тогда
		
		Ресурс = "api/images/update_categories";
		
	Иначе
		
		Ресурс = "api/images/update_products";
		
	КонецЕсли;
	
	
	HTTP.ДатьЗаданиеНаИзменениеСайту(
					НоменклатураСсылка, 
					Перечисления.КомандыHTTP.POST, 
					Ресурс,
					"",
					Ложь);
		
КонецФункции

Функция ПолучитьЦенник(Ссылка, ПараметрыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ПараметрыЦенника = Новый Структура("Организация, Номенклатура, Артикул, Производитель, Валюта, УпаковкаЕдиницаИзмерения, Цена, ДатаПечати, Бренд",
										ПараметрыПечати.Организация,
										Ссылка,
										Ссылка.Артикул,
										Ссылка.СтранаПроисхождения,
										ПараметрыПечати.Валюта,
										ПараметрыПечати.ЕдиницаИзмерения,
										ПараметрыПечати.Цена,
										ПараметрыПечати.Дата,
										ПараметрыПечати.Бренд,);
	
	Макет = ПолучитьОбщийМакет("ШаблонЦенника");
	
	Если ПараметрыПечати.ЦенаПоАкции > 0  Тогда
		ОбластьЦенник 	= Макет.ПолучитьОбласть("ЦенникАкция");
		ПараметрыЦенника.Вставить("Цена", ПараметрыПечати.ЦенаПоАкции); 
		ПараметрыЦенника.Вставить("СтараяЦена", ПараметрыПечати.Цена); 
	Иначе
		ОбластьЦенник 	= Макет.ПолучитьОбласть("Ценник"); 
	КонецЕсли;
	
	ОбластьЦенник.Параметры.Заполнить(ПараметрыЦенника);
	
	// Установим штрих код
	ШтрихКоды.УстановитьШтрихКодВМакете(ОбластьЦенник, ПолучитьЗначениеШтрихКода(Ссылка), Ложь);
	
	ТабДок.Вывести(ОбластьЦенник);

	Возврат ТабДок;
	
КонецФункции

Функция ПолучитьЦенникLicota(Ссылка, ПараметрыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ПараметрыЦенника = Новый Структура("Организация, Номенклатура, Артикул, Производитель, Валюта, УпаковкаЕдиницаИзмерения, Цена, ДатаПечати",
										ПараметрыПечати.Организация,
										Ссылка,
										Ссылка.Артикул,
										Ссылка.СтранаПроисхождения,
										ПараметрыПечати.Валюта,
										ПараметрыПечати.ЕдиницаИзмерения,
										ПараметрыПечати.Цена,
										ПараметрыПечати.Дата);
	
	Макет = Обработки.ПечатьЦенников.ПолучитьМакет("ШаблонЦенникаLicotaGarwin");
	 //18.08
	//Если ПараметрыПечати.ЦенаПоАкции > 0  Тогда
	//	ОбластьЦенник 	= Макет.ПолучитьОбласть("ЦенникАкция");
	//	ПараметрыЦенника.Вставить("Цена", ПараметрыПечати.ЦенаПоАкции); 
	//	ПараметрыЦенника.Вставить("СтараяЦена", ПараметрыПечати.Цена); 
	//Иначе
		ОбластьЦенник 	= Макет.ПолучитьОбласть(ПараметрыПечати.ИмяОбласти); 
//	КонецЕсли;


	ОбластьЦенник.Параметры.Заполнить(ПараметрыЦенника);
	Если ПараметрыПечати.ЦенаПоАкции > 0  Тогда
		ОбластьЦенник.Параметры.Цена = ПараметрыПечати.ЦенаПоАкции; 
		ОбластьЦенник.Параметры.СтараяЦена = Строка(ПараметрыПечати.Цена) + " " + Символ(164); 
		
	КонецЕсли;
	ТабДок.Вывести(ОбластьЦенник);

	Если ПараметрыПечати.ЦенаПоАкции > 0 Тогда
		ТабДок.Область("R13C2").Картинка = БиблиотекаКартинок.МаркерАкция; КонецЕсли;
	
	Если ПараметрыПечати.ЭтоНовинка Тогда
		ТабДок.Область("R13C2").Картинка = БиблиотекаКартинок.МаркерНовинки; КонецЕсли;
		
	Возврат ТабДок;
	
КонецФункции

Процедура Печать_Ценники(ТабличныйДокумент, Ссылка, ПараметрыПечати) Экспорт
	
	Макет = ПолучитьОбщийМакет("ШаблонЦенника");
	
	ПараметрыЦенника = Новый Структура("Организация, Номенклатура, Производитель, Валюта, УпаковкаЕдиницаИзмерения, Цена",
										?(ЗначениеЗаполнено(ПараметрыПечати), ПараметрыПечати.Организация, ОбщиеФункции.НастройкаПользователя("ПоУмолчанию_Организация")),/// аааа, срочно поменять, чем ваще думала!!
										Ссылка,
										Ссылка.Производитель,
										ОбщиеФункции.ПолучитьЗначениеКонстантыВОбласти("ВалютаУправленческогоУчета"),
										Ссылка.ЕдиницаИзмерения,
										РаботаСНоменклатурой.ПолучитьЦену(Ссылка, Справочники.ТипыЦен.НайтиПоКоду("000000004")));
	Макет.Параметры.Заполнить(ПараметрыЦенника);
	
	// Установим штрих код
	
	ШтрихКоды.УстановитьШтрихКодВМакете(Макет, Ссылка);
	
КонецПроцедуры

Функция ПолучитьЗначениеШтрихКода(Ссылка)
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 ШтрихКод, ТипШтрихКода ИЗ РегистрСведений.ШтрихКоды ГДЕ Объект = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат ?(Выборка.Следующий(), Выборка.Штрихкод, "");
	
КонецФункции


Процедура Печать_Этикеток(ТабличныйДокумент, Ссылка, ПараметрыПечати) Экспорт
	
	//ЗначениеШтрихкода = "";
	//ВнешняяКомпонента = ПодключитьВнешнююКомпонентуПечатиШтрихкода();

	//Макет = ПолучитьОбщийМакет("ШаблонЭтикетки");
	//
	//Для Каждого Рисунок ИЗ Макет.Рисунки ЦИкл
	//
	//	ЗначениеШтрихкода = ПолучитьЗначениеШтрихКода(Ссылка);
	//
	//	Если ЗначениеЗаполнено(ЗначениеШтрихкода) Тогда
	//					
	//		ПараметрыШтрихкода = Новый Структура;
	//		ПараметрыШтрихкода.Вставить("Ширина",          Рисунок.Ширина);// 209);
	//		ПараметрыШтрихкода.Вставить("Высота",          Рисунок.Высота);// 209);
	//		ПараметрыШтрихкода.Вставить("Штрихкод",        ЗначениеШтрихкода);
	//		ПараметрыШтрихкода.Вставить("ТипКода",         1);//Выборка.ТипШтрихКода);//СтруктураШаблона.ТипКода);
	//		ПараметрыШтрихкода.Вставить("ОтображатьТекст", Истина);//СтруктураШаблона.ОтображатьТекст);
	//		ПараметрыШтрихкода.Вставить("РазмерШрифта",    12);//СтруктураШаблона.РазмерШрифта);
	//						
	//		Рисунок.Картинка = ПолучитьКартинкуШтрихкода(ВнешняяКомпонента, ПараметрыШтрихкода);
	//						
	//	КонецЕсли;

	//КонецЦикла;
	//
	//ТабличныйДокумент.Вывести(Макет);
	
КонецПроцедуры

// ДЛЯ САЙТА

Функция СоздатьКопиюСправочникаСайта(Ссылка, СайтПриемник, НеРугатьсяЕслиЕстьУжеТакой = Ложь, СсылкаНаКопию = Неопределено) Экспорт
	
	// Создает справочник для параллельного сайта
	// Если СайтПриемник пустая строка значит это копирование в основную номенклатуру
	
	// СсылкаНаКопию - сюда будет помещена ссылка на созданный или найденный справочник
	
	// Определим сайт источник
	
	ИмяСпр 			= Ссылка.Метаданные().Имя; 
	СайтИсточник 	= ?(ИмяСпр = "Номенклатура", "", ТРег(СтрЗаменить(ВРЕГ(ИмяСпр), "НОМЕНКЛАТУРАСАЙТ", "")));
	//Если СайтПриемник = "Основной" Тогда СайтПриемник = "" КонецЕсли;
	ЭтоКопияВНоменклатуру = СайтПриемник = "Основной" Или СайтПриемник = "";
	
	Если СайтИсточник = СайтПриемник Тогда 
		ОбщиеФункции.СообщитьТекст("Невозможно скопировать самого в себя " + СайтПриемник);
		Возврат Ложь; КонецЕсли;
	
	// Определим куда переносить и заполним новый справочник
	
	Если ЭтоКопияВНоменклатуру Тогда // перенос в основную номенклатру
		
		// Проверим чтобы не было тогого справочника уже привязанного
		
		Если ЗначениеЗаполнено(Ссылка.Номенклатура) Тогда
			
			Если НеРугатьсяЕслиЕстьУжеТакой Тогда 
				Возврат Истина;
			Иначе
				ОбщиеФункции.СообщитьТекст("Уже есть другой справочник который был скопирован из этой группы для данного сайта
				|" + СайтПриемник + " " + Ссылка.Номенклатура); 
				Возврат Ложь; КонецЕсли; КонецЕсли;
		
		// Создадим справочник
		
		СпрОбъект = Справочники.Номенклатура.СоздатьГруппу();
		ЗаполнитьЗначенияСвойств(СпрОбъект, Ссылка,,"Владелец, Код, Родитель, ЭтоГруппа, Предопределенный");
		
		
	//	// Проверим alies
	//
	//Если ПустаяСтрока(СпрОбъект.alies) Тогда
	//	                                                                                  
	//	СпрОбъект.alies = НРег(КонвертацияТипов.ПреобразоватьРусскийТекстВАнглицкий(Http.СформироватьAliesИзНаименования()));
	//	
	//ИначеЕсли КонвертацияТипов.ЕстьРусскиеБуквы(СпрОбъект.alies) Тогда
	//	
	//	// Проверим чтобы alies был токо английский
	//	
	//СпрОбъект.alies = НРег(КонвертацияТипов.ПреобразоватьРусскийТекстВАнглицкий(Http.СформироватьAliesИзНаименования())); КонецЕсли;
	//
	//Если ПустаяСтрока(СпрОбъект.alies_ru) Тогда СпрОбъект.alies_ru = НРег(Http.СформироватьAliesИзНаименования()) КонецЕсли;
	//
	//новАлиес = HTTP.ПроверитьИПолучитьНовыйAlies(СпрОбъект, Истина, СпрОбъект.alies);
	//Если новАлиес <> СпрОбъект.alies Тогда СпрОбъект.alies = новАлиес КонецЕсли;
	//
	//новАлиес = HTTP.ПроверитьИПолучитьНовыйAlies(СпрОбъект, Истина, СпрОбъект.alies_ru, "alies_ru");
	//Если новАлиес <> СпрОбъект.alies_ru Тогда СпрОбъект.alies_ru = новАлиес КонецЕсли;
		
	      		
		// Привяжем к родителю
		
		Если Не Ссылка.Родитель.Пустая() И Не Ссылка.Родитель.Номенклатура.Пустая() Тогда
			СпрОбъект.Родитель = Ссылка.Родитель.Номенклатура; КонецЕсли;
	Иначе
		
		// Проверим чтобы не было тогого справочника уже привязанного
		
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.НоменклатураСайт" + СайтПриемник + " ГДЕ НоменклатураКопия = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			
			СсылкаНаКопию = Выборка.Ссылка;
			
			Если НеРугатьсяЕслиЕстьУжеТакой Тогда 
				Возврат Истина;
			Иначе
				ОбщиеФункции.СообщитьТекст("Уже есть другой справочник который был скопирован из этой группы для данного сайта
				|" + СайтПриемник + " " + Выборка.Ссылка);
				Возврат Ложь; КонецЕсли; КонецЕсли;
		
		// Создадим справочник
		
		СпрОбъект = Справочники["НоменклатураСайт" + СайтПриемник].СоздатьГруппу();
		ЗаполнитьЗначенияСвойств(СпрОбъект,Ссылка,,"Владелец");
		СпрОбъект.Наименование 				= Ссылка.Наименование;
		СпрОбъект.НоменклатураКопия 		= ?(ЗначениеЗаполнено(Ссылка.НоменклатураКопия), Ссылка.НоменклатураКопия, Ссылка);
		СпрОбъект.НастройкиИзНоменклатуры 	= Истина; 
		
		//Скопируем ТЧ
		Если НЕ ЭтоКопияВНоменклатуру Тогда 
			Для Каждого Стр Из Ссылка.ПорядокТегов Цикл
				Стр2=СпрОбъект.ПорядокТегов.Добавить();
				ЗаполнитьЗначенияСвойств(Стр2,Стр);
			КонецЦикла;
			
			Для Каждого Стр Из Ссылка.ДополнительныеКоды Цикл
				Стр2=СпрОбъект.ДополнительныеКоды.Добавить();
				ЗаполнитьЗначенияСвойств(Стр2,Стр);
			КонецЦикла;
			
			Для Каждого Стр Из Ссылка.ДополнительныеРодители Цикл
				Если ТипЗнч(Стр.Родитель) = Тип("СправочникСсылка.Номенклатура") Тогда
					Стр2=СпрОбъект.ДополнительныеРодители.Добавить();
					Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 НС.Ссылка ИЗ Справочник.НоменклатураСайт" + СайтПриемник + " НС Внутреннее соединение Справочник.Номенклатура Н по НС.Код=Н.Код ГДЕ Н.Ссылка = &Родитель");
					Запрос.УстановитьПараметр("Родитель",Стр.Родитель);
					Рез=Запрос.Выполнить();
					Если Не Рез.Пустой() Тогда
						Стр2.Родитель=Рез.Выгрузить()[0].Ссылка;
					Иначе
						ОбщиеФункции.СообщитьТекст("Дополнительный родитель '"+Стр.Родитель+"' не найден по коду  в справочнике "+СайтПриемник+". Создайте сначала дополнительного родителя."); 
						Возврат Ложь;
				КонецЕсли;	
			КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		
		// Привяжем к родителю
		
		Если Не Ссылка.Родитель.Пустая() Тогда
			Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.НоменклатураСайт" + СайтПриемник + " ГДЕ НоменклатураКопия = &Родитель");
			Запрос.УстановитьПараметр("Родитель", ?(ЗначениеЗаполнено(Ссылка.Родитель.НоменклатураКопия), Ссылка.Родитель.НоменклатураКопия, Ссылка.Родитель));
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				СпрОбъект.Родитель = Выборка.Ссылка; 
			КонецЕсли; 
		КонецЕсли; 
		
		
	КонецЕсли;
	
	Если ЭтоКопияВНоменклатуру Тогда НачатьТранзакцию() КонецЕсли;
	
	СпрОбъект.ОбменДанными.Загрузка = Истина;
	Результат 		= ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(СпрОбъект); 
	СсылкаНаКопию 	= СпрОбъект.Ссылка;
	
	
	// Перенесем свойства
	Если НЕ ЭтоКопияВНоменклатуру Тогда 
		ДР_Источник = РегистрыСведений.ЗначенияДополнительныхРеквизитовНоменклатуры.СоздатьНаборЗаписей();
		ДР_Источник.Отбор.Номенклатура.Установить(Ссылка);
		ДР_Источник.Прочитать();
		ДР_Приемник = РегистрыСведений.ЗначенияДополнительныхРеквизитовНоменклатуры.СоздатьНаборЗаписей();
		ДР_Приемник.Отбор.Номенклатура.Установить(СпрОбъект.Ссылка);
		Для Каждого Стр Из ДР_Источник Цикл
			Стр2=ДР_Приемник.Добавить();
			Стр2.Номенклатура=СпрОбъект.Ссылка;
			ЗаполнитьЗначенияСвойств(Стр2,Стр,,"Номенклатура");
		КонецЦикла;
		ДР_Приемник.Записать();
	КонецЕсли;	
	
	// Сохраним связь в текущей ссылке
	
	Если ЭтоКопияВНоменклатуру Тогда
		текСпрОб = Ссылка.ПолучитьОбъект();
		текСпрОб.НоменклатураКопия = СпрОбъект.Ссылка;
		текСпрОб.ОбменДанными.Загрузка = Истина;
		Если ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(текСпрОб) Тогда
			ЗафиксироватьТранзакцию();
		Иначе
			ОтменитьТранзакцию();
			Возврат Ложь; КонецЕсли; КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
