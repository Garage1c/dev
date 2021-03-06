﻿
Функция ПолучитьКомментарииHTMLКОбъекту(СсылкаНаОбъект, ИмяРеквизита = "", НомерСтрокиОбъекта = 0) Экспорт
	
	ТекстОграничительDIV = "<div style="" width:100%; height:1px; clear:both;""></div>";
	
	Запрос = Новый Запрос("ВЫБРАТЬ Комментарий, Вложения, Пользователь, Период ИЗ РегистрСведений.Комментарии ГДЕ СсылкаНаОбъект = &СсылкаНаОбъект
	|" + ?(ИмяРеквизита = "","","И ИмяРеквизита = """ + ИмяРеквизита + """") + "
	|" + ?(НомерСтрокиОбъекта,"И НомерСтрокиОбъекта = """ + Формат(НомерСтрокиОбъекта, "ЧГ="),"") + "
	|УПОРЯДОЧИТЬ ПО Период Убыв
	|");
	
	Запрос.УстановитьПараметр("СсылкаНаОбъект", СсылкаНаОбъект);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Текст 	= ?(СсылкаНаОбъект.Пустая(), "Объект еще не записан, комментировать не записаный объект запрещено.", "");
	
	Пока Выборка.Следующий() Цикл 
		
		текКоммент = Выборка.Комментарий;
		
		// Распакуем вложения
		ВложениеКоммента 	= Выборка.Вложения.Получить();
		Если ВложениеКоммента <> Неопределено Тогда
			Для Каждого Элемент Из ВложениеКоммента Цикл Адрес = ПоместитьВоВременноеХранилище(Элемент.Значение); текКоммент = СтрЗаменить(текКоммент, "<img src='" + Элемент.Ключ + "'", "<img src='" + Адрес + "'"); КонецЦикла; КонецЕсли;
		
		Текст = Текст + "
		|<div class=""autor"">" + Выборка.Пользователь + "   " + Формат(Выборка.Период, "ДЛФ=DDT") + "</div>
		|<div class=""Comment"">" + текКоммент + "</div>"; КонецЦикла;
		
	Возврат "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Strict//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"">
			|<html xmlns=""http://www.w3.org/1999/xhtml"" xml:lang=""ru"">
			|<head>
			|	<meta http-equiv=""Content-Type"" content=""text/html"" />
			|	<style>
			|		.Comment{
			|				width:100%; 
        	|				padding:2px;
        	|				float:left; 
        	|				margin-left:15px; 
			|				margin-right:15px;
			|				margin-top:5px;
        	|				text-align:left;
			|			}
			|		.autor{
			|				background:#EDF2F0; 
            |       		white-space: nowrap;
			|				margin-top:20px;
           	|               font-size:65%;
          	|               color:grey;
         	|               overflow: hidden; width:100%; 
			|				height:15px;
			|			}
			|	</style>
			|</head>
			|<body>
			|" + ?(СсылкаНаОбъект.Пустая(), "", "
			|<a href='V8:ВЫПОЛНИТЬ КОД:ОткрытьФорму(""РегистрСведений.Комментарии.Форма.ДобавитьКомментарий"", Новый Структура(""СсылкаНаОбъект"", ЭтаФорма.СсылкаНаОбъект), ЭтаФорма);'>Добавить новый комментарий</a>
			|") + "
			|" + ТекстОграничительDIV + "
			|" + Текст + "
			|</body>
			|</html>";
	
КонецФункции