
&НаКлиенте
Перем структураЗакрытияФормы;

&НаСервере
Функция НачалоHTML()
	
	Возврат "
	|	<HTML><HEAD>
	|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
	|<META name=GENERATOR content=""MSHTML 9.00.8112.16470""></HEAD>
	//|<body style=""background-color:#FCFAEB;"">
	|<style type=""text/css"">
	|.buttons {
	|	width: 260px;
	|	height: 30px;
	|	position:absolute;
	|	left:0;
	|	right:0;
	|	margin:0px auto;
	|}

	//|.radio {
	//|  display: none;
	//|}

	//|.label {
	//|	border: 1px solid #ccc;
	//|	width:100px;
	//|  text-transform: uppercase;
	//|	text-align:center;
	//|  display: inline-block;
	//|  margin: 0 5px 20px;
	//|  padding: 3px 8px;
	//|  color: #aaa;
	//|  text-shadow: 0 1px black;
	//|  border-radius: 3px;
	//|  cursor: pointer;
	//|  -webkit-transition: all 0.5s ease-out .3s;
	//|	-moz-transition:all 1s ease-out .3s;
	//|		transition:all 1s ease-out .3s;
	//|}
	//|	
	//|	.light{
	//|		background: rgb(255,255,255);
	//|background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iI2ZmZmZmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjUwJSIgc3RvcC1jb2xvcj0iI2YxZjFmMSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjUxJSIgc3RvcC1jb2xvcj0iI2UxZTFlMSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiNmNmY2ZjYiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
	//|background: -moz-linear-gradient(top,  rgba(255,255,255,1) 0%, rgba(241,241,241,1) 50%, rgba(225,225,225,1) 51%, rgba(246,246,246,1) 100%);
	//|background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(255,255,255,1)), color-stop(50%,rgba(241,241,241,1)), color-stop(51%,rgba(225,225,225,1)), color-stop(100%,rgba(246,246,246,1)));
	//|background: -webkit-linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(241,241,241,1) 50%,rgba(225,225,225,1) 51%,rgba(246,246,246,1) 100%);
	//|background: -o-linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(241,241,241,1) 50%,rgba(225,225,225,1) 51%,rgba(246,246,246,1) 100%);
	//|background: -ms-linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(241,241,241,1) 50%,rgba(225,225,225,1) 51%,rgba(246,246,246,1) 100%);
	//|background: linear-gradient(to bottom,  rgba(255,255,255,1) 0%,rgba(241,241,241,1) 50%,rgba(225,225,225,1) 51%,rgba(246,246,246,1) 100%);
	//|filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#f6f6f6',GradientType=0 );

	//|	}

	//|.dark{background: rgb(149,149,149);
	//|background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzk1OTU5NSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjQ2JSIgc3RvcC1jb2xvcj0iIzBkMGQwZCIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjUwJSIgc3RvcC1jb2xvcj0iIzAxMDEwMSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjUzJSIgc3RvcC1jb2xvcj0iIzBhMGEwYSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9Ijc2JSIgc3RvcC1jb2xvcj0iIzRlNGU0ZSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9Ijg3JSIgc3RvcC1jb2xvcj0iIzM4MzgzOCIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMxYjFiMWIiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
	//|background: -moz-linear-gradient(top,  rgba(149,149,149,1) 0%, rgba(13,13,13,1) 46%, rgba(1,1,1,1) 50%, rgba(10,10,10,1) 53%, rgba(78,78,78,1) 76%, rgba(56,56,56,1) 87%, rgba(27,27,27,1) 100%);
	//|background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(149,149,149,1)), color-stop(46%,rgba(13,13,13,1)), color-stop(50%,rgba(1,1,1,1)), color-stop(53%,rgba(10,10,10,1)), color-stop(76%,rgba(78,78,78,1)), color-stop(87%,rgba(56,56,56,1)), color-stop(100%,rgba(27,27,27,1)));
	//|background: -webkit-linear-gradient(top,  rgba(149,149,149,1) 0%,rgba(13,13,13,1) 46%,rgba(1,1,1,1) 50%,rgba(10,10,10,1) 53%,rgba(78,78,78,1) 76%,rgba(56,56,56,1) 87%,rgba(27,27,27,1) 100%);
	//|background: -o-linear-gradient(top,  rgba(149,149,149,1) 0%,rgba(13,13,13,1) 46%,rgba(1,1,1,1) 50%,rgba(10,10,10,1) 53%,rgba(78,78,78,1) 76%,rgba(56,56,56,1) 87%,rgba(27,27,27,1) 100%);
	//|background: -ms-linear-gradient(top,  rgba(149,149,149,1) 0%,rgba(13,13,13,1) 46%,rgba(1,1,1,1) 50%,rgba(10,10,10,1) 53%,rgba(78,78,78,1) 76%,rgba(56,56,56,1) 87%,rgba(27,27,27,1) 100%);
	//|background: linear-gradient(to bottom,  rgba(149,149,149,1) 0%,rgba(13,13,13,1) 46%,rgba(1,1,1,1) 50%,rgba(10,10,10,1) 53%,rgba(78,78,78,1) 76%,rgba(56,56,56,1) 87%,rgba(27,27,27,1) 100%);
	//|filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#959595', endColorstr='#1b1b1b',GradientType=0 );
	//|}

	//|.radio:checked + .label {
	//|  color: white;
	//|}

	//|.label:hover {
	//|  color: white;
	//|  background: rgba(40,40,40,0.30);
	//|  -webkit-transition:0.5s;
	//|}

	//|#light:checked ~ .body > .buttons {
	//|	  background-color: #76e87e;
	//|}

	|</style>
	|<BODY style=""background-color:#FCFAEB;"">
	|


	|<div class=""body"">
	|	<div class=""buttons"">
	|"
	
КонецФункции
&НаСервере
Функция ТекстСпискаСкладов(Склады)
	
	ТекстВариант = "<ol>";
	
	Для Каждого Склад Из Склады Цикл ТекстВариант = ТекстВариант + "<li>" + Склад + "</li>"; КонецЦикла;
	
	Возврат ТекстВариант + "</ol>";
	
КонецФункции

&НаСервере
Функция ПолучитьМассивСкладов(СкладНачала = Неопределено, ВыборкаВариантов, СкладКонец = Неопределено)
	
	Склады = Новый Массив;
	
	Если СкладНачала <> Неопределено Тогда Склады.Добавить(СкладНачала) КонецЕсли;
	
	ВыборкаСклады = ВыборкаВариантов.Выбрать();
	Пока ВыборкаСклады.Следующий() Цикл
		Если НЕ (НЕ СоВсехСкладов И СписокСкладов.НайтиПоЗначению(ВыборкаСклады.Склад) = Неопределено) Тогда
			Склады.Добавить(ВыборкаСклады.Склад);
		КонецЕсли;
	КонецЦикла;
	
	Если СкладКонец <> Неопределено Тогда Склады.Добавить(СкладКонец) КонецЕсли;
	
	Возврат Склады;
	
КонецФункции
&НаСервере
Функция ТекстЗакрытияЯчейки(Склады)
	
	стрСкладов = "";
	Для Каждого Склад Из Склады Цикл стрСкладов = стрСкладов + "," + XMLСтрока(Склад); КонецЦикла;
	
	стрРазместить = НСтр("de='Waren reservieren'; ru='Разместить';");
	
	Возврат 	"<button id=""run" + стрСкладов + """ title=""" + стрРазместить + """> " + стрРазместить + " </button>
				|</td>";
	
	//Возврат 	"<input type=""radio"" class=""radio"" name=""menu"" value=""" + Класс + """ id=""dark"">
	//			|<label for=""" + Класс + """ class=""label " + Класс + """>" + Текст + "</label>
	//			|</td>";
КонецФункции

&НаСервере
Процедура СформироватьТекстHTML()
	
	Текст = НачалоHTML();
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ Вариант, Склад, НомерСтроки ИЗ Справочник.Склады.ПорядокРазмещения " + ?(ТекущийСклад.Пустая(),"","ГДЕ Ссылка = &Склад") + " УПОРЯДОЧИТЬ ПО НомерСтроки ИТОГИ ПО Вариант");
	Запрос.УстановитьПараметр("Склад", ТекущийСклад);
	
	ВыборкаВариантов = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	Пока ВыборкаВариантов.Следующий() Цикл
		
		Текст = Текст + "<h5>" + ?(ПустаяСтрока(ВыборкаВариантов.Вариант), "порядок размещения", ВыборкаВариантов.Вариант) + "</h5>
		|<table border=""0"">
		|<tbody>
		|<tr>
		|<td>";
		
		Если ТекущийСклад.Пустая() Тогда
			
			Склады = ПолучитьМассивСкладов(, ВыборкаВариантов);
			//Текст = Текст + ТекстСпискаСкладов(Склады) + ТекстЗакрытияЯчейки("разместить","light");
			Текст = Текст + ТекстСпискаСкладов(Склады) + ТекстЗакрытияЯчейки(Склады);
			
		Иначе
			
			Склады = ПолучитьМассивСкладов(ТекущийСклад, ВыборкаВариантов);
			//Текст = Текст + ТекстСпискаСкладов(Склады) + ТекстЗакрытияЯчейки("разместить","light");
			Текст = Текст + ТекстСпискаСкладов(Склады) + ТекстЗакрытияЯчейки(Склады);
			
			Склады = ПолучитьМассивСкладов(, ВыборкаВариантов, ТекущийСклад);
			//Текст = Текст + "<td>" + ТекстСпискаСкладов(Склады) + ТекстЗакрытияЯчейки("разместить","dark"); КонецЕсли;
			Текст = Текст + "<td>" + ТекстСпискаСкладов(Склады) + ТекстЗакрытияЯчейки(Склады); КонецЕсли;
		
		Текст = Текст + "
		|</tr>
		|</table>"; КонецЦикла;
	
	Текст = Текст + "
	|</div></div>
	|</BODY></HTML>";
	
	ТекстHTML = Текст;
	
КонецПроцедуры

&НаКлиенте
Процедура Разместить(Команда)
	
	Закрыть(Новый Структура("Склады, ЗаказыПоставщикам, ОчиститьРазмещение", 
				РазмещатьНаСкладах, РазмещатьВЗаказахПоставщику, ОчиститьРазмещение));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.СписокСкладов.Количество() = 1 И Параметры.СписокСкладов[0].Значение = Параметры.ТекущийСклад  Тогда
		СоВсехСкладов = Истина;
		Элементы.СписокСкладов.Доступность = Ложь;
	ИначеЕсли Параметры.СписокСкладов.Количество()>0 Тогда
		СписокСкладов = Параметры.СписокСкладов.Скопировать();
		СоВсехСкладов = Ложь;
		Элементы.СписокСкладов.Доступность = Истина;
	Иначе
		СоВсехСкладов = Истина;
		Элементы.СписокСкладов.Доступность = Ложь;
	КонецЕсли;
	ТекущийСклад = Параметры.ТекущийСклад;

	СформироватьТекстHTML();
		
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	
	Закрыть(структураЗакрытияФормы);
	
КонецПроцедуры
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТекущийСклад.Пустая() Тогда
		
		Отказ = Истина;
		структураЗакрытияФормы = ОткрытьФорму("ОбщаяФорма.ДиалогРазмещенияСт", , ВладелецФормы,,,,Новый ОписаниеОповещения("ОбработкаОткрытияДиалогаРазмещенияСТ",ЭтаФорма,)); 
	КонецЕсли;
	
	//имяФайла = ПолучитьИмяВременногоФайла("html");
	//
	//ТекстДок = Новый ТекстовыйДокумент;
	//ТекстДок.УстановитьТекст(текстДляПередачи);
	//ТекстДок.Записать(имяФайла);
	//
	//ТекстHTML = имяФайла;
	
КонецПроцедуры
//&Наклиенте
Процедура ОбработкаОткрытияДиалогаРазмещенияСТ(Результат, Параметры) Экспорт
	Если Результат <> Неопределено Тогда 
		;//ПодключитьОбработчикОжидания("ЗакрытьФорму", 0.1, Истина); 
	КонецЕсли;
КонецПроцедуры
&НаСервере
Функция ПолучитьМассивСкладовИзXML(МассивXML)
	
	Склады = Новый Массив;
	Для Каждого стрСклад Из МассивXML Цикл Склады.Добавить(XMLЗначение(Тип("СправочникСсылка.Склады"), стрСклад)) КонецЦикла;
	
	Возврат Склады;
	
КонецФункции
&НаКлиенте
Процедура ТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	
	id = ДанныеСобытия.Element.id;
	Если Лев(id, 3) = "run" Тогда
		
		Склады = КонвертацияТипов.ПолучитьМассивИзСтроки(id);
		Склады.Удалить(0);
		
		Закрыть(Новый Структура("Склады, ЗаказыПоставщикам, ОчиститьРазмещение, ВыбранныеПриоритеты", 
				РазмещатьНаСкладах, РазмещатьВЗаказахПоставщику, ОчиститьРазмещение, ПолучитьМассивСкладовИзXML(Склады))); КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСкладовПриИзменении(Элемент)
	
	СформироватьТекстHTML();
	
КонецПроцедуры

&НаКлиенте
Процедура СоВсехСкладовПриИзменении(Элемент)
	Элементы.СписокСкладов.Доступность = НЕ ЭтотОбъект.СоВсехСкладов;
	СформироватьТекстHTML();
КонецПроцедуры
