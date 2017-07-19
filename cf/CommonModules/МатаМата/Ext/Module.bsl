﻿&НаСервере
Функция ПреобразоватьJSON(Свойство, Значение, ДополнительныеПараметры, Отказ) Экспорт
	
	Возврат XMLСтрока(Значение);
	
КонецФункции


Функция ВернутьОшибку(Ответ, стрОшибки)
	
	Если Ответ = Неопределено Тогда Возврат стрОшибки КонецЕсли;
	
	Ответ.КодСостояния = 500;
	Ответ.УстановитьТелоИзСтроки(стрОшибки);
	
	Возврат Ответ;
	
КонецФункции

Функция ПолучитьПередачиТовараPOST(ЗапросHTTP = Неопределено, стрJSONСтруктураДляТестов = Неопределено) Экспорт
	
	// СтруктураДляТестов - для тестирования, в боевом режиме всегда неопределено
	//	ЗапросHTTP - в тестовом режиме неопределено
	
	стрОшибки = "";
	
	Если стрJSONСтруктураДляТестов = Неопределено Тогда
		
		Ответ = Новый HTTPСервисОтвет(200);
		
		ПереданныеДанные = ЗапросHTTP.ПолучитьТелоКакСтроку();
		Если ПустаяСтрока(ПереданныеДанные) Тогда Возврат ВернутьОшибку(Ответ, "Нет данных документа в json формате" + ПереданныеДанные+ "__") КонецЕсли;
	 	//СтруктураЗапроса = w1_Json.UnJSON(ПереданныеДанные);
	Иначе
		
		Ответ = Неопределено;
		ПереданныеДанные = стрJSONСтруктураДляТестов; КонецЕсли;
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(ПереданныеДанные);
	СтруктураЗапроса = ПрочитатьJSON(Чтение);
	Чтение.Закрыть();
		
	Если ТипЗнч(СтруктураЗапроса) <> Тип("Структура") Тогда Возврат ВернутьОшибку(Ответ, "Не верный тип (должно быть структура)") КонецЕсли;
	
	Запрос = Новый Запрос();
	
	//обязательые поля, проверим структуру
	
	ТекПользователь   = ПараметрыСеанса.ТекущийПользователь;
	КонтрагентСсылка     = ТекПользователь.Контрагент;
	КонтрагентИнфСистема = КонтрагентСсылка.ИнформационнаяСистемаПартнера;
	Если КонтрагентСсылка = Справочники.Контрагенты.ПустаяСсылка()  Тогда Возврат ВернутьОшибку(Ответ, "Нет данных о Контрагенте, для текущего пользователя не указан Контрагент") КонецЕсли;
		 
	ДатаНачала = ?(СтруктураЗапроса.Свойство("data_begin"), XMLЗначение(Тип("Дата"), СтруктураЗапроса.data_begin), Неопределено);
	ДатаКонца  = ?(СтруктураЗапроса.Свойство("data_end"), XMLЗначение(Тип("Дата"), СтруктураЗапроса.data_end), Неопределено);
		
	МВЗ 	= ?(СтруктураЗапроса.Свойство("mvz"), 	СтруктураЗапроса.mvz, 	Неопределено);
	Если ЗначениеЗаполнено(МВЗ) Тогда МВЗ = HTTP.ПолучитьОбъектПоСсылке(Справочники.МВЗ,    СтруктураЗапроса.mvz,       стрОшибки); МВЗСсылка = МВЗ.Ссылка;
	Если СтрОшибки = "" Тогда Запрос.УстановитьПараметр("МВЗ",МВЗСсылка);КонецЕсли;КонецЕсли;
	
	ДокументПередачи	= ?(СтруктураЗапроса.Свойство("transaction_id"), 	СтруктураЗапроса.transaction_id, 	Неопределено);
	Если ЗначениеЗаполнено(ДокументПередачи) Тогда ДокументПередачи = HTTP.ПолучитьОбъектПоСсылке(Документы.ПередачаТовара,    СтруктураЗапроса.transaction_id,  стрОшибки); ДокументПередачиСсылка = ДокументПередачи.Ссылка;	 
	Если СтрОшибки = "" Тогда Запрос.УстановитьПараметр("ДокументПередачи",ДокументПередачиСсылка);КонецЕсли;КонецЕсли;
	
	ОтветственноеЛицо	= ?(СтруктураЗапроса.Свойство("partner_user_id"), 	СтруктураЗапроса.partner_user_id, 	Неопределено);
	Если ЗначениеЗаполнено(ОтветственноеЛицо) Тогда ОтветственноеЛицо = HTTP.ПолучитьОбъектПоСсылке(Справочники.ФизическиеЛица,    СтруктураЗапроса.partner_user_id,  стрОшибки); ОтветственноеЛицоСсылка = ОтветственноеЛицо.Ссылка;	 
	Если СтрОшибки = "" Тогда Запрос.УстановитьПараметр("ОтветственноеЛицо",ОтветственноеЛицоСсылка);КонецЕсли;КонецЕсли;
	
    Подробно = Ложь;
	
	Если СтруктураЗапроса.Свойство("detail") и СтруктураЗапроса.detail = Истина Тогда Подробно = Истина КонецЕсли;

	// Установим фильтры по складам пользователя запроса
	
	Запрос.УстановитьПараметр("Пользователь", ТекПользователь);
	
	стрФиртФильтр = ?(ДатаНачала = Неопределено, ""," &ДатаНачала") + ", " + ?(ДатаКонца = Неопределено, ""," &ДатаКонца") + ", , 
	|(НЕ (ИСТИНА В(ВЫБРАТЬ Ограничить ИЗ ОграничитьПоСкладам)) ИЛИ Размещение В(ВЫБРАТЬ Склад ИЗ СкладыПользователя)) 
	|И Контрагент = &Контрагент " + ?(ЗначениеЗаполнено(МВЗСсылка), " И Инициатор = &МВЗ", "") + ?(ЗначениеЗаполнено(ДокументПередачиСсылка), " И ДокументПередачи = &ДокументПередачи", "");
	
	стрФильтрПоСкладам = "
	|ВЫБРАТЬ ПЕРВЫЕ 1 ИСТИНА Ограничить ПОМЕСТИТЬ ОграничитьПоСкладам ИЗ РегистрСведений.МВЗДоступКСкладам ГДЕ Пользователь = &Пользователь;
	|ВЫБРАТЬ Склад ПОМЕСТИТЬ СкладыПользователя ИЗ РегистрСведений.МВЗДоступКСкладам ГДЕ Пользователь = &Пользователь;";
	
	// Запрос
	
	Если Подробно Тогда
		
		Запрос.Текст = стрФильтрПоСкладам + "
		
		|ВЫБРАТЬ РАЗЛИЧНЫЕ Владелец Контрагент, Наименование НомерДоговора, Организация.ИНН ИНН
		|ПОМЕСТИТЬ	СписокКонтрагентов
		|ИЗ 		Справочник.ДоговорыКонтрагентов
		|ГДЕ		ЗначениеПоУмолчанию И Владелец В (ВЫБРАТЬ Контрагент ИЗ РегистрНакопления.ПередачаТоваров.Обороты(" + стрФиртФильтр + "));
		
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПередачаТоваровОбороты.ДокументПередачи.ОтветственноеЛицо
		|ПОМЕСТИТЬ СписокОтветственных
		|ИЗ
		|	РегистрНакопления.ПередачаТоваров.Обороты(" + стрФиртФильтр + ") КАК ПередачаТоваровОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Почта.Представление,
		|	СписокОтветственных.ДокументПередачиОтветственноеЛицо
		|ПОМЕСТИТЬ ПочтаОтветственныхЛиц
		|ИЗ
		|	СписокОтветственных КАК СписокОтветственных
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредставлениеКонтактнойИнформации КАК Почта
		|		ПО СписокОтветственных.ДокументПередачиОтветственноеЛицо = Почта.Объект
		|ГДЕ
		|	Почта.Вид В ИЕРАРХИИ(&Вид)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СоответствиеТоваровПартнеров.Номенклатура,
		|	СоответствиеТоваровПартнеров.ИнформационнаяСистема,
		|	СоответствиеТоваровПартнеров.КодНоменклатуры
		|ПОМЕСТИТЬ НомИнфСистПартнера
		|ИЗ
		|	РегистрСведений.СоответствиеТоваровПартнеров КАК СоответствиеТоваровПартнеров
		|ГДЕ
		|	СоответствиеТоваровПартнеров.ИнформационнаяСистема = &КонтрагентИнфСистема
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПередачаТоваровОбороты.ДокументПередачи КАК transaction_id,
		|	ПередачаТоваровОбороты.ДокументПередачи.ОтветственноеЛицо КАК partner_user_id,
		|	ПередачаТоваровОбороты.Номенклатура КАК product_id,
		|	ПередачаТоваровОбороты.КоличествоПриход КАК quantity,
		|	ПередачаТоваровОбороты.СуммаПриход КАК sum,
		|	ПередачаТоваровОбороты.Цена									price,
		|	ВЫБОР КОГДА СтавкаНДС = &Ставка18 ТОГДА 18 ИНАЧЕ 0 КОНЕЦ	nds,
		|	ИНН															inn,
		|	НомерДоговора												ndog,
		|	ПередачаТоваровОбороты.ДокументПередачи.Дата КАК data,
		|	ПередачаТоваровОбороты.ДокументПередачи.Номер КАК number,
		|	ПередачаТоваровОбороты.Инициатор КАК mvz,
		|	ПередачаТоваровОбороты.Инициатор.Код КАК mvz_kod,
		|	ПередачаТоваровОбороты.ДокументПередачи.ОтветственноеЛицо.Представление КАК FIO,
		|	ПередачаТоваровОбороты.Номенклатура.Наименование КАК name,
		|	ПередачаТоваровОбороты.Номенклатура.Артикул КАК art,
		|	ПередачаТоваровОбороты.Номенклатура.Код КАК kod,
		|	НомИнфСистПартнера.КодНоменклатуры КАК kod_partner,
		|	ПередачаТоваровОбороты.Номенклатура.ЕдиницаИзмерения.Наименование КАК unit,
		|	ПочтаОтветственныхЛиц.Представление КАК mail
		|ИЗ
		|	РегистрНакопления.ПередачаТоваров.Обороты(" + стрФиртФильтр + ") КАК ПередачаТоваровОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПочтаОтветственныхЛиц КАК ПочтаОтветственныхЛиц
		|		ПО ПередачаТоваровОбороты.ДокументПередачи.ОтветственноеЛицо = ПочтаОтветственныхЛиц.ДокументПередачиОтветственноеЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ НомИнфСистПартнера КАК НомИнфСистПартнера
		|		ПО ПередачаТоваровОбороты.Номенклатура = НомИнфСистПартнера.Номенклатура
		|			И ПередачаТоваровОбороты.Контрагент.ИнформационнаяСистемаПартнера = НомИнфСистПартнера.ИнформационнаяСистема
		|
		|ЛЕВОЕ СОЕДИНЕНИЕ	СписокКонтрагентов Контры
		|ПО					Контры.Контрагент = ПередачаТоваровОбороты.Контрагент
		|
		|" + ?(ЗначениеЗаполнено(ОтветственноеЛицо), " Где ПередачаТоваровОбороты.ДокументПередачи.ОтветственноеЛицо = &ОтветственноеЛицо", "");

				   
				   Запрос.УстановитьПараметр("Вид",Справочники.ВидыКонтактнойИнформации.АдресЭлектроннойПочты);
	Иначе			   
		Запрос.Текст = стрФильтрПоСкладам + " ВЫБРАТЬ
	               |	СоответствиеТоваровПартнеров.Номенклатура,
	               |	СоответствиеТоваровПартнеров.ИнформационнаяСистема,
	               |	СоответствиеТоваровПартнеров.КодНоменклатуры
	               |ПОМЕСТИТЬ НомИнфСистПартнера
	               |ИЗ
	               |	РегистрСведений.СоответствиеТоваровПартнеров КАК СоответствиеТоваровПартнеров
	               |ГДЕ
	               |	СоответствиеТоваровПартнеров.ИнформационнаяСистема = &КонтрагентИнфСистема
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПередачаТоваровОбороты.ДокументПередачи КАК transaction_id,
	               |	ПередачаТоваровОбороты.ДокументПередачи.ОтветственноеЛицо КАК partner_user_id,
	               |	ПередачаТоваровОбороты.Номенклатура КАК product_id,
	               |	НомИнфСистПартнера.КодНоменклатуры КАК product_kod_partner,
	               |	ПередачаТоваровОбороты.КоличествоПриход КАК quantity,
	               |	ПередачаТоваровОбороты.СуммаПриход КАК sum
	               |ИЗ
	               |	РегистрНакопления.ПередачаТоваров.Обороты(" + стрФиртФильтр + ") КАК ПередачаТоваровОбороты
	               |		ЛЕВОЕ СОЕДИНЕНИЕ НомИнфСистПартнера КАК НомИнфСистПартнера
	               |		ПО ПередачаТоваровОбороты.Номенклатура = НомИнфСистПартнера.Номенклатура
	               |			И ПередачаТоваровОбороты.Контрагент.ИнформационнаяСистемаПартнера = НомИнфСистПартнера.ИнформационнаяСистема
				   |" + ?(ЗначениеЗаполнено(ОтветственноеЛицо), " Где ПередачаТоваровОбороты.ДокументПередачи.ОтветственноеЛицо = &ОтветственноеЛицо", ""); КонецЕсли;
			   
			   
	Запрос.УстановитьПараметр("Контрагент",			КонтрагентСсылка);
	Запрос.УстановитьПараметр("КонтрагентИнфСистема",	КонтрагентИнфСистема);
	Запрос.УстановитьПараметр("Ставка18", 			Перечисления.СтавкиНДС.НДС18);

	Запрос.УстановитьПараметр("ДатаНачала",ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКонца",ДатаКонца);
	
	ТаблицаЗначений = Запрос.Выполнить().Выгрузить();
	
	МассивОтвета = Новый Массив;
		
	Если Подробно Тогда
		
		Для Каждого Строка ИЗ ТаблицаЗначений Цикл 
		МассивОтвета.Добавить(Новый Структура("transaction_id, partner_user_id, product_id,quantity,sum, price, nds",
										новый Структура("id,data,number,mvz,mvz_kod, inn, ndog", 
												Строка.transaction_id,Строка.data,Строка.number,Строка.mvz,Строка.mvz_kod,Строка.inn,Строка.ndog),
										Новый Структура("id,FIO,mail",
												Строка.partner_user_id,Строка.FIO,Строка.mail),
										новый Структура("id,name,art,kod,kod_partner,unit",
												Строка.product_id,Строка.name,Строка.art,Строка.kod,Строка.kod_partner,Строка.unit),
										Строка.quantity,Строка.sum, Строка.price, Строка.nds));КонецЦикла;
											
	Иначе  Для Каждого Строка ИЗ ТаблицаЗначений Цикл 
		МассивОтвета.Добавить(КонвертацияТипов.ПолучитьСтруктуруИзСТрокиТаблицыЗначений(ТаблицаЗначений, ТаблицаЗначений.Индекс(Строка))) КонецЦикла;КонецЕсли;

	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(,"  "));
	ЗаписатьJSON(ЗаписьJSON, МассивОтвета,,"ПреобразоватьJSON", МатаМата);
	стрJSON = ЗаписьJSON.Закрыть();
	
	Если стрJSONСтруктураДляТестов = Неопределено Тогда
		
		Ответ.УстановитьТелоИзСтроки(стрJSON);
		Возврат Ответ;
	Иначе
		
		Возврат стрJSON КонецЕсли;

КонецФункции
Функция ПолучитьСсылкуСправочника(Менеджер, Структура, стрОшибки = "")
	
	Ссылка = Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(Структура.Ссылка));
	Если Ссылка.ПолучитьОбъект() = Неопределено Тогда
		
		СпрОбъект = Менеджер.СоздатьЭлемент();
		СпрОбъект.Наименование = Структура.Наименование;
		Если ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(СпрОбъект,,стрОшибки, Ложь) Тогда
			Возврат СпрОбъект.Ссылка КонецЕсли;
	Иначе
		
		Возврат Ссылка; КонецЕсли;
	
КонецФункции

