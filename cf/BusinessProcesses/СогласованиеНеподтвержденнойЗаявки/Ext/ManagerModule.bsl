﻿

Функция ПолучитьТаблицуТоваров(СсылкаПроцесс, СсылкаЗадача = Неопределено) Экспорт
	
	Возврат Заказы.ПолучитьТаблицуТоваров(
					СсылкаПроцесс, 
					СсылкаЗадача);
	
КонецФункции
Процедура ЗаполнитьФормуПоБП(Форма, СсылкаПроцесс, СсылкаЗадача = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(СсылкаПроцесс) Тогда
		Запрос = Новый Запрос("
		
		// Условия
		|ВЫБРАТЬ 	
		|	Заказ, 
		|	Заказ.АдресДоставки				АдресДоставки,
		|	Заказ.КомментарийКДоставке		КомментарийКДоставке,
		|	Заказ.ОбщийВес					ОбщийВес,
		|	Заказ.МаксимальныйСрокДоставки	МаксимальныйСрокДоставки,
		|	Заказ.Бесплатно              	Бесплатно,
		|	Заказ.is_check              	is_check,
		|	Заказ.ВидОплаты					ВидОплаты,
		|	Заказ.ВариантДоставки			ВариантДоставки,
		|	Заказ.СуммаДоставки				СуммаДоставки,
		|	Заказ.СуммаНП					СуммаНП,
		|	Заказ.ДоставкаДоДвери			ДоставкаДоДвери,
		|	Заказ.Склад 			Склад, 
		|	Заказ.ТипЦен 			ТипЦен,
		|	Заказ.Валюта 			Валюта,
		|	Заказ.БанковскийСчетОрганизации БанковскийСчетОрганизации,
		|	Заказ.БанковскийСчетПартнера 	БанковскийСчетПартнера,
		|	Заказ.Грузоотправитель 	Грузоотправитель,
		|	Заказ.Грузополучатель	Грузополучатель,
		|	Заказ.Контрагент 		Контрагент,
		|	Заказ.Организация 		Организация,
		|	Заказ.Плательщик 		Плательщик,
		|	Заказ.Подразделение 	Подразделение,
		|	Заказ.СуммаВключаетНДС 	СуммаВключаетНДС,
		|	Заказ.УчитыватьНДС 		УчитыватьНДС,
		|	Заказ.ДисконтнаяКарта 	ДисконтнаяКарта,
		|	Заказ.Комментарий 		Комментарий,
		|	Заказ.МВЗ				МВЗ,
		|	Заказ.МестоположениеСтр	МестоположениеСтр,
		|	Заказ.СуммаДоставкиРасход 		СуммаДоставкиРасход,
		|	Заказ.ОтветственноеЛицо			ОтветственноеЛицо,
		|	Заказ.АдресДоставки.Комментарий КомментарийКАдресуДоставки,
		|	Заказ.ЗакупитьНедостающее       ЗакупитьНедостающее,
		|	Заказ.ПередачаТовара			ПередачаТовара,
		|	Заказ.ВариантДоставкиНов ВариантДоставкиНов,		         	
		|	Заказ.Грузоперевозчик Грузоперевозчик,		         	
		|	Заказ.ВремяДоставкиС ВремяДоставкиС,		         	
		|	Заказ.ВремяДоставкиПо ВремяДоставкиПо,		         	
		|	Заказ.ЗаЧейСчетДоставка ЗаЧейСчетДоставка,		         	
		|	Заказ.ДатаДоставки ДатаДоставки,		         	
		|	Заказ.КонтактноеЛицоДоставки КонтактноеЛицоДоставки,		         	
		|	Заказ.ТелефонКонтактногоЛицаДоставки ТелефонКонтактногоЛицаДоставки,		         	
		|	Заказ.АдресДоставкиНов АдресДоставкиНов,		         	
		|	Заказ.КтоОформилЗаказ КтоОформилЗаказ,
		|	Заказ.МенеджерЗаказа МенеджерЗаказа
		|ИЗ
		|	БизнесПроцесс.НеподтвержденнаяЗаявка КАК Процесс
		|ГДЕ
		|	Ссылка = &СсылкаБП
		|;
		|");
		
		Заказ 				= СсылкаПроцесс.Заказ;
		ПараметрыЗаказа 	= Заказы.ПолучитьПараметрыДляЗапроса(Заказ);
		
		Запрос.УстановитьПараметр("СсылкаБП", СсылкаПроцесс);
		ВыборкаШапки = Запрос.Выполнить().Выбрать();
		ВыборкаШапки.Следующий();
		
		// Заполним шапку
		
		ЗаполнитьЗначенияСвойств(Форма, ВыборкаШапки);	
		
		// Заполним таблицу
		
		Форма.Товары.Загрузить(ПолучитьТаблицуТоваров(СсылкаПроцесс, СсылкаЗадача));
		
		// Заполним резервы
		
		Если Заказ.СпособРазмещенияБезЗаказа Тогда
			Заказы.ЗаполнитьТаблицыРазмещений(Заказ, Форма.Товары, Форма.РазмещениеТоваров, ПараметрыЗаказа); КонецЕсли; КонецЕсли;

КонецПроцедуры

Функция ПолучитьЗаголовокБП(СсылкаПроцесс) Экспорт
	
	Возврат ?(СсылкаПроцесс.Пустая(),
	                    "Создание",
						"Неподтвержденная заявка " + СсылкаПроцесс.Заказ.Номер + " от " + СсылкаПроцесс.Заказ.Дата + " (БП №" + СсылкаПроцесс.Номер + ")");
	
КонецФункции
Функция ПолучитьМассивКомментариев(СсылкаПроцесс) Экспорт
	
	Массив = Новый Массив;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Комментарий, Заголовок, ДатаВыполнения, Исполнитель
	|ИЗ
	|(
	//|	ВЫБРАТЬ
	//|		Комментарий, Наименование Заголовок, ДатаВыполнения, Исполнитель
	//|	ИЗ
	//|		Задача.ЗадачаПользователю
	//|	ГДЕ
	//|		БизнесПроцесс = &Ссылка ИЛИ
	//|		БизнесПроцесс В(ВЫБРАТЬ Ссылка ИЗ БизнесПроцесс.СборкаЗаказа ГДЕ Заказ = &Заказ) ИЛИ
	//|		БизнесПроцесс В(ВЫБРАТЬ Ссылка ИЗ БизнесПроцесс.ПеремещениеТоваров ГДЕ Заказчик = &Ссылка)
	|
	|	ВЫБРАТЬ
	|		Комментарий, Наименование Заголовок, ДатаВыполнения, Исполнитель
	|	ИЗ
	|		Задача.ЗадачаПользователю
	|	ГДЕ
	|		БизнесПроцесс = &Ссылка	
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Комментарий, Наименование Заголовок, ДатаВыполнения, Исполнитель
	|	ИЗ
	|		Задача.ЗадачаПользователю
	|	ГДЕ
	|		БизнесПроцесс в (ВЫБРАТЬ Ссылка ИЗ БизнесПроцесс.СборкаЗаказа ГДЕ Заказ = &Заказ)	
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Комментарий, Наименование Заголовок, ДатаВыполнения, Исполнитель
	|	ИЗ
	|		Задача.ЗадачаПользователю
	|	ГДЕ
	|		БизнесПроцесс в (ВЫБРАТЬ Ссылка ИЗ БизнесПроцесс.ПеремещениеТоваров ГДЕ Заказчик = &Ссылка)	
	
	
	
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Комментарий, ""Неподтвержденная заявка"", Дата, Ответственный
	|	ИЗ
	|		Документ.НеподтвержденнаяЗаявка
	|	ГДЕ
	|		Ссылка = &Заказ
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Комментарий, ""Согласование неподтвержденной заявки"", Дата, ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	ИЗ
	|		БизнесПроцесс.СогласованиеНеподтвержденнойЗаявки
	|	ГДЕ
	|		Ссылка = &Ссылка
    |
	|) Запрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаВыполнения
	|");
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаПроцесс);
	Запрос.УстановитьПараметр("Заказ", 	СсылкаПроцесс.Заказ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ПустаяСтрока(Выборка.Комментарий) Тогда
		
			Массив.Добавить(Новый Структура("Комментарий, Заголовок, ДатаВыполнения, Исполнитель",
									Выборка.Комментарий, Выборка.Заголовок, Выборка.ДатаВыполнения, Выборка.Исполнитель));
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

Функция НаименованиеДоставки(ЭтотЗаказ) Экспорт
	
	Если ЭтотЗаказ.ВариантДоставки = "courier" Тогда
		Возврат "Курьером";
	ИначеЕсли ЭтотЗаказ.ВариантДоставки = "dellin_to_door" Тогда
		Возврат "Деловые линии";
	ИначеЕсли ЭтотЗаказ.ВариантДоставки = "EMS_POD" ИЛИ ЭтотЗаказ.ВариантДоставки = "ems_to_door" Тогда
		Возврат "ЕМС Почта России";
	ИначеЕсли ЭтотЗаказ.ВариантДоставки = "from_dellin_terminal" Тогда
		Возврат "Деловые линии - терминал";
	ИначеЕсли ЭтотЗаказ.ВариантДоставки = "self_pick_up" Тогда
		Возврат "Самовывоз";
	ИначеЕсли ЭтотЗаказ.ВариантДоставки = "from_warehouse" Тогда
		Возврат "Самовывоз " + ЭтотЗаказ.СкладСамовывоза;
	ИначеЕсли ЭтотЗаказ.ВариантДоставки = "emsa" Тогда
		Возврат "ЕМС Почта России";
	ИначеЕсли ЭтотЗаказ.ВариантДоставки = "express" Тогда
		Возврат "ЕМС Почта России";
	Иначе
		Возврат ЭтотЗаказ.ВариантДоставки;
	КонецЕсли;
	                
КонецФункции

Функция ПолучитьДеталиЗаказа(ЭтотЗаказ, ДопРасходы, ОткрытиеЗаказа, СоСрокомПоставки = Ложь) Экспорт
	
	ТекстДеталиЗаказа = "
	|<!-- CONTENT STARTS -->
	|		<table width=""640"" cellspacing=""0"" cellpadding=""0"" border=""0"" style=""margin:10px 0 0"">
	|			<thead>
	|			<tr>
	|				<th style=""background-color:#333333; text-align:center;color:#fff;font-weight:400;line-height:30px;font-family: Verdana,Geneva,sans-serif;font-size:11px;border-bottom:1px solid #bbbbbb;"">Артикул</th>
	|				<th style=""background-color:#333333; text-align:center;color:#fff;font-weight:400;line-height:30px;font-family: Verdana,Geneva,sans-serif;font-size:11px;border-bottom:1px solid #bbbbbb;"">Наименование</th>
	|				<th style=""width:120px;background-color:#333333; text-align:center;color:#fff;font-weight:400;line-height:30px;font-family: Verdana,Geneva,sans-serif;font-size:11px;border-bottom:1px solid #bbbbbb;"">Цена</th>
	|				<th style=""background-color:#333333; text-align:center;color:#fff;font-weight:400;line-height:30px;font-family: Verdana,Geneva,sans-serif;font-size:11px;border-bottom:1px solid #bbbbbb;"">Количество</th>
	|				<th style=""width:120px;background-color:#333333; text-align:center;color:#fff;font-weight:400;line-height:30px;font-family: Verdana,Geneva,sans-serif;font-size:11px;border-bottom:1px solid #bbbbbb;"">Стоимость</th>
	|			</tr>
	|			</thead>
	|			<tbody>";
	
	АдресИнтернетМагазин = Константы.ПутьИнтернетМагазин.Получить();
	
	Запрос = Новый Запрос("	ВЫБРАТЬ
	|	ВЫБОР КОГДА Заказ.НоменклатураУчет = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) ТОГДА Заказ.Номенклатура.Артикул 		ИНАЧЕ Заказ.НоменклатураУчет.Артикул 		КОНЕЦ Артикул,
	|	ВЫБОР КОГДА Заказ.НоменклатураУчет = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) ТОГДА Заказ.Номенклатура.alies 			ИНАЧЕ Заказ.НоменклатураУчет.alies 			КОНЕЦ alies,
	|	ВЫБОР КОГДА Заказ.НоменклатураУчет = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) ТОГДА Заказ.Номенклатура.Наименование 	ИНАЧЕ Заказ.НоменклатураУчет.Наименование 	КОНЕЦ Наименование,
	|	ВЫБОР КОГДА Заказ.Количество = 0 ТОГДА 0 ИНАЧЕ Заказ.Сумма / Заказ.Количество КОНЕЦ Цена,
	|	Заказ.Количество 		Количество,
	|	Заказ.Сумма				Стоимость
	|ИЗ
	|	Документ.НеподтвержденнаяЗаявка.Товары Заказ ГДЕ Ссылка = &ЭтотЗаказ
	|");
	
	Запрос.УстановитьПараметр("ЭтотЗаказ", ЭтотЗаказ);

	Выборка = Запрос.Выполнить().Выбрать(); СуммаИтого = ?(ОткрытиеЗаказа, ДопРасходы, 0);
	Пока Выборка.Следующий() Цикл СуммаИтого = СуммаИтого + Выборка.Стоимость;
		ТекстДеталиЗаказа = ТекстДеталиЗаказа + "
		|<tr>
		|			<td align=""left"" valign=""top"" style=""padding:10px 5px;font-family: Verdana,Geneva,sans-serif;font-size:12px;color:#333333;border-bottom:1px solid #bbbbbb;"">" + Выборка.Артикул + "</td>
		|			<td align=""left"" valign=""top"" style=""padding: 10px 5px;border-bottom:1px solid #bbbbbb;"">
		|				<a style=""font-family: Verdana,Geneva,sans-serif;font-size:12px;color:#333333;"" href=" + АдресИнтернетМагазин+"/tovar/" + НРег(Выборка.alies)+" title=""Товар"">" + Выборка.Наименование + "</a></td>
		|			<td align=""center"" valign=""top"" style=""padding: 10px 5px;font-family: Verdana,Geneva,sans-serif;font-size:12px;color:#333333;border-bottom:1px solid #bbbbbb;"">" + Выборка.Цена + " р.</td>
		|			<td align=""left"" valign=""top"" style=""padding: 10px 5px;font-family: Verdana,Geneva,sans-serif;font-size:12px;color:#333333;border-bottom:1px solid #bbbbbb;"">" + Выборка.Количество + "</td>
		|			<td align=""center"" valign=""top"" style=""padding: 10px 5px;font-family: Verdana,Geneva,sans-serif;font-size:12px;color:#006644;border-bottom:1px solid #bbbbbb;"">" + Выборка.Стоимость + " р.</td>
		|		</tr>"; КонецЦикла; 
	
	Возврат ТекстДеталиЗаказа + "
			|</tbody>
			|	<tfoot>
			|	<tr>
			|		<td " + ?(СоСрокомПоставки, "colspan=""4""",  "colspan=""3""") + " style=""border-bottom:1px solid #000000;border-top:1px solid #000000;""></td>
			|		<td align=""right"" style=""line-height:30px;font-family: Verdana,Geneva,sans-serif;font-size:12px;color:#333333;padding: 5px 5px;border-bottom:1px solid #000000;border-top:1px solid #000000;"">Итого:</td>
			|		<td align=""center"" style=""line-height:30px;font-family: Verdana,Geneva,sans-serif;font-size:12px;color:#006644;padding: 5px 5px;border-bottom:1px solid #000000;border-top:1px solid #000000;"">" + СуммаИтого + " р.</td>
			|	</tr>
			|	</tfoot>
			|</table>
			|<!-- CONTENT END -->";
	                
КонецФункции
Функция СформироватьПисьмо(Заказ, Действие, ТелоПисьма, ОткрытиеЗаказа = Ложь, СсылкаНаСчет = Ложь, ДеталиЗаказа = Истина, СоСрокомПоставки = Ложь) Экспорт
	
    //по кнопке заказ обработан из интернет заказа                         
	НомерЗаказа =  Заказ.Номер;
	ДоставкаВключенаВСумму = Заказ.Доставка.Количество();
	
	НомерЗаказа   = СокрЛП(НомерЗаказа);
	Пока Лев(НомерЗаказа, 1)="0" Цикл   	
		НомерЗаказа = Сред(НомерЗаказа, 2);
	КонецЦикла;                                                 	
	
	ТемаПисьма = Строка(Действие) +  " #" + НомерЗаказа;	
	
	Пользователь 	= Заказ.ПользовательИнтернет;
	ДопРасходы 		= Заказ.СуммаДоставки + заказ.СуммаНП;
	
		
	Оператор        = Заказ.Оператор;
		 
	ЭлПочта         =  УправлениеКонтактнойИнформацией.ПолучитьПредставлениеКонтактнойИнформацииОбъекта(Оператор.ФизЛицо,  Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00052"));
	ДобТелефон      =  УправлениеКонтактнойИнформацией.ПолучитьПредставлениеКонтактнойИнформацииОбъекта(Оператор.ФизЛицо,  Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00054"));
	
	ЗаголовокПисьма = "
	|<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">
	|<tr>
	|	<td align=""center"" valign=""top"">
	|		<!-- HEADER STARTS -->
	|		<table width=""640"" cellspacing=""0"" cellpadding=""0"" border=""0"">"+
	?(ТекущаяДата()>Дата(2017,4,30),"","
	|			<tr>
    |               <td colspan=""3"" bgcolor=""#FFFF00"" align=""left"" style=""font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#333333;font-weight: bold;"">
	|				<br />Внимание!<br /><br />
	|				В связи с переездом нашего центрального склада, возможны небольшие задержки отгрузок заказов из Санкт-Петербурга (3-5 дней).<br />
	|				Ситуация нормализуется до конца апреля.<br /><br />
	|				Спасибо, что относитесь с пониманием и остаетесь с нами.<br /><br />
	|				</td>
	|			</tr>
	|			<tr>
	|				<td colspan=""3"" align=""left"" style=""font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#333333;""><br /><br /></td>
	|			</tr>")+"
	|			<tr>
	|				<td align=""center"" style=""width:138px;"" ><a href=""http://garagetools.ru/"" title=""garagetools.ru""><img src=""http://spbmain.dlinkddns.com/orders_pdf/images/mail_logo.png"" /></a></td>
	|				<td align=""center"" style=""width:295px;""></td>
	|				<td align=""right"" style=""width:207px;font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#000000;padding:0 0 0 10px;"">Статус:<br/>" + Заказы.ПолучитьСостояниеЗаказаСтрокой(Заказ) + "</td>
	|			</tr>                                                                
	|			<tr>
	//|				<td align=""left"" colspan=""3"" style=""width:640px""><img src=""http://spbmain.dlinkddns.com/orders_pdf/images/site2_verstka_0490_07.png"" width=""639"" height=""8"" /></td>
	|               <td colspan=""3"" bgcolor=""#008000"" align=""center"" style=""font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#008000;"">.</td> 
	|			</tr>
	|			<tr>
	|				<td align=""left"" colspan=""3"" style=""font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#333333;padding:10px 0;"">Здравствуйте, уважаемый(ая) " + Пользователь + "!</td>
	|			</tr>
	|			<tr>
	|				<td align=""left"" colspan=""3"" style=""font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#333333;padding:10px 0;"">" + ТелоПисьма + "</td>
	|			</tr>
	|" + ?(ДеталиЗаказа, "	
	|			<tr>
	|				<td align=""left"" colspan=""3"" style=""font-family: Verdana,Geneva,sans-serif;font-size:16px;color:#006644;padding:5px 0;border-bottom:1px solid #000000;"">
	|<ul>
	| <li>Заказчик: " + Заказ.Контрагент + "</li>
	| <li>Способ оплаты: " + Заказ.ВидОплаты + " </li>
	| <li>Доставка: " + БизнесПроцессы.СогласованиеНеподтвержденнойЗаявки.НаименованиеДоставки(Заказ) + "</li>
	| <li>Стоимость доставки: " + ?(Заказ.СуммаДоставки = 0, "0 (итоговую сумму заказа смотрите ниже под таблицей)", Заказ.СуммаДоставки) + ?(ОткрытиеЗаказа ИЛИ Заказ.СуммаДоставки = 0, "", " р.(Стоимость доставки " + ?(ДоставкаВключенаВСумму, "включена в стоимость товара", "оплачивается отдельно при получении") + ")") + "</li>
	|" + ?(Заказ.СуммаНП,"<li>Сумма НП: " + Заказ.СуммаНП + " р.</li>","") + "
	|</ul>
	|	</td> 
	|			</tr>
	|", "") + "
	|		</table>
	|		<!-- HEADER END -->
	|";
	
	ПодвалПисьма = "
	|<!-- FOOTER STARTS -->
	|		<table width=""640"" cellspacing=""0"" cellpadding=""0"" border=""0"" style=""margin:20px 0 0"">
	|			<tr>
	|				<td align=""center"" style=""width:360px;"">
	|				</td>
	|				<td align=""center"" style=""width:125px;padding:0 15px 20px;border-bottom:1px solid #777777;"">
	|					<a href=""http://garagetools.ru/categories/"" title=""Перейти в интернет магазин garagetools.ru""><img src=""http://spbmain.dlinkddns.com/orders_pdf/images/butt1.png"" width=""125"" height=""30"" style=""border:none;display:block;"" /></a>
	|				</td>
	//Нэти Исмаилов ИТ 23.03.2017 Начало
	//Картинки по ссылке нет, чтобы ошибки не было все убираем
	//|				<td align=""center"" style=""width:125px;padding:0 0 20px 15px;border-bottom:1px solid #777777;"">
	//|					<a href=""http://garagetools.ru/dashboard/orders/" + Формат(Заказ.id,"ЧГ=") + """ title=""Перейти на заказ в личном кабинете""><img src=""http://spbmain.dlinkddns.com/orders_pdf/images/butt_2.png"" /></a>
	//|				</td>
	//Нэти ИСмаилов ИТ 23.03.2017 Конец
	|			</tr>
	|			<tr>
	|				<td align=""center"" >
	|				</td>
	|				<td align=""right"" colspan=""2"" style=""line-height:14px;font-family: Verdana,Geneva,sans-serif;font-size:10px;color:#777777;"">Мы всегда к Вашим услугам и ждем Ваших заказов!<br />
	|					С наилучшими пожеланиями,<br />
	|					Администрация Интернет-магазина garagetools.ru<br/>
    |<hr>
	|Ваш менеджер:  " + Оператор.ФизЛицо + "<br>
	|Бесплатный телефон:  8-800-707-8007 доб." + ДобТелефон + "<br>
//  |В Санкт-Петербурге: 458-46-64 доб." + ДобТелефон + "<br>
	|Эл.почта: " + ЭлПочта + "<br>
//	|ICQ:  " + АСК + "<br>
 	|</td>
	|			</tr>
	|		</table>
	|		<!-- FOOTER END -->
	|	</td>
	|</tr>
	|</table>";

	
	ТекстПодТаблицей = "Обратите внимание! Оплата услуги наложенного платежа производится отдельно при получении <BR>
						|Подробнее о тарифах и сроках доставки Вы можете узнать на сайте транспортной компании.";
						
	АдресПочты = Заказ.АдресОтправкиПисьма;//Пользователь.ЭлектроннаяПочта;
	
	Если ПустаяСтрока(АдресПочты) Тогда
		АдресПочты = Пользователь.ЭлектроннаяПочта;
	ИначеЕсли ПустаяСтрока(АдресПочты) Тогда	
		АдресПочты = Справочники.Контрагенты.ПолучитьЭлектроннуюПочтуПартнера(Заказ.Контрагент); 
		АдресПочты = ?( АдресПочты = "",Справочники.Контрагенты.ПолучитьЭлектроннуюПочтуПартнера(Заказ.Контрагент),АдресПочты);  //теперь почта из контрагента на крайний случай поищем и в Контрагенте
	КонецЕсли;						
						
	ОбщиеФункции.ОповеститьПоПочте(АдресПочты , ТемаПисьма, 	ЗаголовокПисьма + 
																	БизнесПроцессы.СогласованиеНеподтвержденнойЗаявки.ПолучитьДеталиЗаказа(Заказ, ДопРасходы, ОткрытиеЗаказа, СоСрокомПоставки) + 
																	?(СсылкаНаСчет, ПолучитьСсылкуНаСчет(Заказ), "") +
																	?(заказ.СуммаНП, ТекстПодТаблицей, "") + 
													 				ПодвалПисьма, Ложь, Перечисления.ТипыТекстовЭлектронныхПисем.HTML);
	//ОбщиеФункции.ОповеститьПоПочте(Пользователь.ЭлектроннаяПочта, ТемаПисьма, Константы.ПутьИнтернетМагазин.Получить(), Ложь, Перечисления.ТипыТекстовЭлектронныхПисем.HTMLСКартинками);
	
КонецФункции
Функция СформироватьПисьмо_Нов(Заказ, Действие, ТелоПисьма, ОткрытиеЗаказа = Ложь, СсылкаНаСчет = Ложь, ДеталиЗаказа = Истина, СоСрокомПоставки = Ложь
	//Нэти Исмаилов ИТ 23.03.2017 Начало
	, СвойСтатусВПисьме = ""
	//Нэти Исмаилов ИТ 23.03.2017 Конец
	) Экспорт
    //по кнопке заказ обработан из интернет заказа 
//СформироватьПисьмо_Нов(Действие, ТелоПисьма, ОткрытиеЗаказа = Ложь, СсылкаНаСчет = Ложь, ДеталиЗаказа = Истина, Параметры = Неопределено, СохранитьВложение = Ложь) Экспорт
	

	НомерЗаказа =  Заказ.Номер;
	ДоставкаВключенаВСумму = Заказ.Доставка.Количество();
	
	НомерЗаказа   = СокрЛП(НомерЗаказа);
	Пока Лев(НомерЗаказа, 1)="0" Цикл   	
		НомерЗаказа = Сред(НомерЗаказа, 2);
	КонецЦикла;                                                 	
	
	ТемаПисьма = Строка(Действие) +  " #" + НомерЗаказа+" от " + Формат(Заказ.Дата,"ДЛФ=Д");	
	
	Пользователь 	= Заказ.ПользовательИнтернет;
	ДопРасходы 		= Заказ.СуммаДоставки + заказ.СуммаНП;
	
		
	Оператор        = Заказ.Оператор;
		 
	ЭлПочта         =  УправлениеКонтактнойИнформацией.ПолучитьПредставлениеКонтактнойИнформацииОбъекта(Оператор.ФизЛицо,  Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00052"));
	ДобТелефон      =  УправлениеКонтактнойИнформацией.ПолучитьПредставлениеКонтактнойИнформацииОбъекта(Оператор.ФизЛицо,  Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00054"));
	////////////////////////////////////////////////////////////////////////
	//
	//Если Заказ.СайтИсточник = Перечисления.Сайты.licota Тогда
	//	Возврат СформироватьПисьмоLicota(Действие, ТелоПисьма, ОткрытиеЗаказа, СсылкаНаСчет, ДеталиЗаказа, Параметры,СохранитьВложение);
	//КонецЕсли;
	//
	//УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	///////////////////////////////////////////////////////////////////////	
		
   	ОсМен           = Заказ.Контрагент.ОсновнойМенеджер;
	МобТелефонМен   = УправлениеКонтактнойИнформацией.ПолучитьПредставлениеКонтактнойИнформацииОбъекта(ОсМен.ФизЛицо,  Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00020"));
	ДобТелефонМен   = УправлениеКонтактнойИнформацией.ПолучитьПредставлениеКонтактнойИнформацииОбъекта(ОсМен.ФизЛицо,  Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00054"));
	ЭлПочтаМен      = УправлениеКонтактнойИнформацией.ПолучитьПредставлениеКонтактнойИнформацииОбъекта(ОсМен.ФизЛицо,  Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00052"));

	ИнфДоставка     = Строка(Заказ.ВариантДоставкиНов);
	ВыводитьДоставку = Истина;
	
	Если Заказ.ВариантДоставкиНов = Перечисления.ВариантДоставки.СамовывозСНашегоСклада Тогда
		ИнфДоставка = ИнфДоставка +" "+Заказ.Склад.Адрес;
		ВыводитьДоставку = Ложь;
	ИначеЕсли Заказ.ВариантДоставкиНов = Перечисления.ВариантДоставки.ДоставкаДоГрузоперевозчика или Заказ.ВариантДоставкиНов = Перечисления.ВариантДоставки.ДоставкаДоКлиента Тогда
		ИнфДоставка = ИнфДоставка +" "+Строка(Заказ.Грузоперевозчик);
	КонецЕсли;
	
	//Нэти Исмаилов ИТ 23.03.2017 Начало
	Если СвойСтатусВПисьме = "" Тогда
		СтатусЗаказаСтрокой = Заказы.ПолучитьСостояниеЗаказаСтрокой(Заказ);
	Иначе
		СтатусЗаказаСтрокой = СвойСтатусВПисьме;
	КонецЕсли;
	//Нэти Исмаилов ИТ 23.03.2017 Конец

	/////////////////////////////////////////////////////////////////////////
 	ЗаголовокПисьма = "
	|<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">
	|<tr>
	|	<td align=""center"" valign=""top"">
	|		<!-- HEADER STARTS -->
	|		<table width=""640"" cellspacing=""0"" cellpadding=""0"" border=""0"">"+
	?(ТекущаяДата()>Дата(2017,4,30),"","
	|			<tr>
    |               <td colspan=""3"" bgcolor=""#FFFF00"" align=""left"" style=""font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#333333;font-weight: bold;"">
	|				<br />Внимание!<br /><br />
	|				В связи с переездом нашего центрального склада, возможны небольшие задержки отгрузок заказов из Санкт-Петербурга (3-5 дней).<br />
	|				Ситуация нормализуется до конца апреля.<br /><br />
	|				Спасибо, что относитесь с пониманием и остаетесь с нами.<br /><br />
	|				</td>
	|			</tr>
	|			<tr>
	|				<td colspan=""3"" align=""left"" style=""font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#333333;""><br /><br /></td>
	|			</tr>")+"
	|			<tr>
	|				<td align=""center"" style=""width:138px;"" ><a href=""http://garagetools.ru/"" title=""garagetools.ru""><img src=""http://spbmain.dlinkddns.com/orders_pdf/images/mail_logo.png"" /></a></td>
	|				<td align=""center"" style=""width:295px;""></td>
	//Нэти Исмаилов ИТ 23.03.2017 Начало
	//|				<td align=""right"" style=""width:207px;font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#000000;padding:0 0 0 10px;"">Статус:<br/>" + Заказы.ПолучитьСостояниеЗаказаСтрокой(Заказ) + "</td>
	|				<td align=""right"" style=""width:207px;font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#000000;padding:0 0 0 10px;"">Статус:<br/>" + СтатусЗаказаСтрокой + "</td>
	//Нэти Исмаилов ИТ 23.03.2017 Конец	
	|			</tr>                                                                
	|			<tr>
	|               <td colspan=""3"" bgcolor=""#008000"" align=""center"" style=""font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#008000;"">.</td> 
	|			</tr>
	|			<tr>
	|				<td align=""left"" colspan=""3"" style=""font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#333333;padding:10px 0;"">Здравствуйте, уважаемый(ая) " + Пользователь + "!</td>
	|			</tr>
	|			<tr>
	|				<td align=""left"" colspan=""3"" style=""font-family: Verdana,Geneva,sans-serif;font-size:14px;color:#333333;padding:10px 0;"">" + ТелоПисьма + "</td>
	|			</tr>
	|" + ?(ДеталиЗаказа, "	
	|			<tr>
	|				<td align=""left"" colspan=""3"" style=""font-family: Verdana,Geneva,sans-serif;font-size:16px;color:#006644;padding:5px 0;border-bottom:1px solid #000000;"">
	|<ul>
	| <li>Заказчик: " + Заказ.Контрагент + "</li>
	| <li>Способ оплаты: " + Заказ.ВидОплаты + " </li>
	| <li>Способ получения: " + ИнфДоставка + "</li>
	|" + ?(ВыводитьДоставку, "
	| <li>Стоимость доставки: " + ?(Заказ.Бесплатно и Заказ.СуммаДоставки = 0 ," бесплатно ",?(Заказ.СуммаДоставки = 0, " 0 (итоговую сумму заказа смотрите ниже под таблицей)", Заказ.СуммаДоставки)) + ?(ОткрытиеЗаказа ИЛИ Заказ.СуммаДоставки = 0, "", " р.(Стоимость доставки " + ?(ДоставкаВключенаВСумму, "включена в стоимость товара", "оплачивается отдельно при получении") + ")") + "</li> 
	|", "") + "
	|" + ?(Заказ.СуммаНП,"<li>Сумма НП: " + Заказ.СуммаНП + " р.</li>","") + "
	|</ul>
	|	</td> 
	|			</tr>
	|", "") + "
	|		</table>
	|		<!-- HEADER END -->
	|";

	ПодвалПисьма = "
	|<!-- FOOTER STARTS -->
	|		<table width=""640"" cellspacing=""0"" cellpadding=""0"" border=""0"" style=""margin:20px 0 0"">
	|			<tr>
	|				<td align=""center"" style=""width:360px;"">
	|				</td>
	|				<td align=""center"" style=""width:125px;padding:0 15px 20px;border-bottom:1px solid #777777;"">
	|					<a href=""http://garagetools.ru/categories/"" title=""Перейти в интернет магазин garagetools.ru""><img src=""http://spbmain.dlinkddns.com/orders_pdf/images/butt1.png"" width=""125"" height=""30"" style=""border:none;display:block;"" /></a>
	|				</td>
	|			</tr>
	|			<tr>
	|				<td align=""center"" >
	|				</td>
	|				<td align=""right"" colspan=""2"" style=""line-height:14px;font-family: Verdana,Geneva,sans-serif;font-size:10px;color:#777777;"">Мы всегда к Вашим услугам и ждем Ваших заказов!<br />
	|					С наилучшими пожеланиями,<br />
	|					Команда Гараж Тулс<br/>
	|<hr>
	|Ваш менеджер:  " + ОсМен.ФизЛицо + "<br>
	|"+?(МобТелефонМен = "","","Мобильный телефон: " + МобТелефонМен + "<br>")+" 
	|Бесплатный телефон:  8-800-707-8007 " +?(ДобТелефонМен = "","<br>","доб." + ДобТелефонМен + "<br>")+"
	|"+?(ЭлПочтаМен = "","","Эл.почта: " + ЭлПочтаМен + "<br>")+"
	|<hr>
	|"+?(ОсМен = Оператор,"",	"Менеджер отдела клиентского севиса:  " + Оператор.ФизЛицо + "<br> Бесплатный телефон:  8-800-707-8007 "+?(ДобТелефон = "","<br>"," доб." + ДобТелефон + "<br>")+ ?(ЭлПочта = "","<br>"," Эл.почта: " + ЭлПочта + "<br>")+" </td> ")+"
	|			</tr>
	|		</table>
	|		<!-- FOOTER END -->
	|	</td>
	|</tr>
	|</table>";


	
	ТекстПодТаблицей = "Обратите внимание! Оплата услуги наложенного платежа производится отдельно при получении <BR>
						|Подробнее о тарифах и сроках доставки Вы можете узнать на сайте транспортной компании.";
	АдресПочты = Заказ.АдресОтправкиПисьма;
	
	Если ПустаяСтрока(АдресПочты) Тогда
		АдресПочты = Пользователь.ЭлектроннаяПочта;
	ИначеЕсли ПустаяСтрока(АдресПочты) Тогда	
		АдресПочты = Справочники.Контрагенты.ПолучитьЭлектроннуюПочтуПартнера(Заказ.Контрагент); 
		АдресПочты = ?(АдресПочты = "",Справочники.Контрагенты.ПолучитьЭлектроннуюПочтуПартнера(Заказ.Контрагент),АдресПочты);  //теперь почта из контрагента на крайний случай поищем и в Контрагенте
	КонецЕсли;	
	
	//Если НЕ ПустаяСтрока(ОсМен)Тогда АдресПочтыКопия = ОсМен.Почта; КонецЕсли;
	
	ОбщиеФункции.ОповеститьПоПочте(АдресПочты , ТемаПисьма, 	ЗаголовокПисьма + 
																	БизнесПроцессы.СогласованиеНеподтвержденнойЗаявки.ПолучитьДеталиЗаказа(Заказ, ДопРасходы, ОткрытиеЗаказа, СоСрокомПоставки) + 
																	?(СсылкаНаСчет, ПолучитьСсылкуНаСчет(Заказ), "") +
																	?(заказ.СуммаНП, ТекстПодТаблицей, "") + 
													 				ПодвалПисьма, Ложь, Перечисления.ТипыТекстовЭлектронныхПисем.HTML);
КонецФункции

Функция ПолучитьСсылкуНаСчет(Заказ)
	
	ТекстСсылкиНаСчет = Заказы.ПолучитьСсылкуHTMLНаСчетPDF(Заказ);
	Если ПустаяСтрока(ТекстСсылкиНаСчет) Тогда Возврат "" КонецЕсли;
	
	Возврат "<a href='" + ТекстСсылкиНаСчет + "'>Ссылка на печатную форму счета</a>";
	
КонецФункции


