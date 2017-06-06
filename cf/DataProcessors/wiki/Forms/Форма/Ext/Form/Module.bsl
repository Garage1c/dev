
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ТекстHTML = //"<meta http-equiv=""Refresh"" content=""http://wiki.garagetools.ru:83/doku.php?id=start"">
	////"<meta http-equiv=""Refresh"" content=""1; URL=http://wiki.garagetools.ru:83/doku.php?id=start"">
	//"<HTML><HEAD>
	//|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
	//|<META name=GENERATOR content=""MSHTML 11.00.9600.18052""></HEAD>
	////|<BODY onload='http://wiki.garagetools.ru:83/doku.php?id=start'></BODY></HTML>
	//|<BODY>
	//|<script language=""JavaScript"" type=""text/javascript"">
	//|location=""http://wiki.garagetools.ru:83/doku.php?id=start""
	//|</script>
	//|</BODY></HTML>";
	
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ТекстHTML.Вперед();
	Элементы.ТекстHTML.Назад();
	
КонецПроцедуры

&НаКлиенте
Процедура Вперед(Команда)
	
	Элементы.ТекстHTML.Вперед();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	а = 2;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	
	ТекстHTML = //"<meta http-equiv=""Refresh"" content=""http://wiki.garagetools.ru:83/doku.php?id=start"">
	//"<meta http-equiv=""Refresh"" content=""1; URL=http://wiki.garagetools.ru:83/doku.php?id=start"">
	"<HTML><HEAD>
	|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
	|<META name=GENERATOR content=""MSHTML 11.00.9600.18052""></HEAD>
	//|<BODY onload='http://wiki.garagetools.ru:83/doku.php?id=start'></BODY></HTML>
	|<BODY>
	|<script language=""JavaScript"" type=""text/javascript"">
	|location=""http://wiki.garagetools.ru:83/doku.php?id=start""
	|</script>
	|</BODY></HTML>";

	
	//ПерейтиПоНавигационнойСсылке(
	//
	//ЧтениеHTML = Новый ЧтениеHTML;
	//ЧтениеHTML.УстановитьСтроку("<html><head><title>Тест</title></head><body><a href='http://www.1c.ru'>Компания 1С</a></html>");
	//ПостроительDOM = Новый ПостроительDOM;
	//ДокументHTML = ПостроительDOM.Прочитать(ЧтениеHTML);
	
	
 

	
	//Соед = Новый HTTPСоединение("wiki.garagetools.ru", 83);
	//
	//ht = Новый HTTPЗапрос;
	//ht.АдресРесурса = "doku.php?id=start";
	//
	//Ответ = Соед.Получить(ht);
	//ТекстHTML = Ответ.ПолучитьТелоКакСтроку();
	
КонецПроцедуры
