﻿&НаСервере
Процедура ВыполнитьНаСервере()
	
	Сценарий = ПолучитьШаблонСценария();
	
	Для Каждого Строка Из Таблица Цикл
		Если НЕ ПустаяСтрока(Строка.Артикул) Тогда
			Спр = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул", Строка.Артикул);
			
			Если НЕ Спр.Пустая() Тогда
				СпрОбъект = Спр.ПолучитьОбъект();
				СпрОбъект.Описание = Строка.Результат + Сценарий;
				СпрОбъект.Комплектация = ПолучитьШаблонКомплектации(Строка.Комплектация);
				Попытка
					СпрОбъект.Записать();
					Строка.Номенклатура = спрОбъект.Ссылка;
				Исключение
					   Сообщить("Не удалось записать Номенклатуру """ + СпрОбъект + """!
	                   |" + ОписаниеОшибки());
				КонецПопытки;
			Иначе
				Сообщить("Номенклатура " + Строка.Артикул + " не найдена");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Функция ПолучитьШаблонЗаголовка( Заголовок)
	Если НЕ ПустаяСтрока(Заголовок)
	Тогда	Возврат "<h2>" + Заголовок + "</h2>";	
	Иначе 	Возврат "";
	КонецЕсли;
КонецФункции
&НаКлиенте
Функция ПолучитьШаблонОписания( Описание)
	
	Если НЕ ПустаяСтрока(Описание) Тогда
	Возврат "<div class=""fullTextDescription"">
			|	<p class=""fullTextDescriptionContent"">
			|		" + Описание + "	
			|	</p>
			|</div>"
	Иначе	Возврат "";
	КонецЕсли;
КонецФункции
&НаКлиенте		
Функция ПолучитьШаблонВнимание(Внимание)
	
	ТекстВнимание = "";
	Если НЕ ПустаяСтрока(Внимание) Тогда  
		МассивВниманий = КонвертацияТипов.ПолучитьМассивИзСтроки(Внимание, "&&");
		ТекстВнимание = " <ul class='precaution' style=""color: red !important; list-style-type: circle !important;"">";
		Для Каждого Строка Из МассивВниманий Цикл ТекстВнимание = ТекстВнимание + "<li>" + Строка + "</li>"; КонецЦикла;
		ТекстВнимание = ТекстВнимание + "</ul>"
	КонецЕсли;
	
	Возврат ТекстВнимание;
	
КонецФункции
&НаСервереБезКонтекста
Функция ПолучитьШаблонКомплектации(Комплектация)
	ТекстКомплектация = "";
	Если НЕ ПустаяСтрока(Комплектация) Тогда
		МассивКомплектаций = КонвертацияТипов.ПолучитьМассивИзСтроки(Комплектация, "&&");
		ТекстКомплектация ="<p>";
		Для Каждого Строка Из МассивКомплектаций Цикл ТекстКомплектация = ТекстКомплектация + "<br>" + Строка; КонецЦикла;
 		ТекстКомплектация = ТекстКомплектация +  "</p>"
	КонецЕсли;
	Возврат ТекстКомплектация;
КонецФункции
&НаКлиенте		
Функция ПолучитьШаблонПреимущества(Преимущество)
	
	Возврат "<div class=""advantage"">
			|	<div class=""advantageImgCapt"">
			|		<div class=""advantageImage"">
			|			<a href=""#"">
			|                 <img src=""" + Преимущество.Картинка + """/>
			| 			</a>
			| 		</div>
			| 		<div class=""advantageCaption"">
			| 			<h3>
			|				" + Преимущество.Название + "
			| 			</h3>
			| 		</div>
			|	</div>
			|	<div class=""advantageDescription"">
			|		<p>
			|			" + Преимущество.Описание + "
			|		</p>
			|	</div>
			|</div>";	
КонецФункции

&НаКлиенте
Функция ПолучитьИтоговыйШаблон(Строка)
	Если Строка = Неопределено Тогда Возврат ""; КонецЕсли;
		
	Текст = "<link rel=""stylesheet"" type=""text/css"" href=""goodDescription.css""/>
	|<div class=""wholeDescription"">
	|" + ПолучитьШаблонЗаголовка(Строка.Заголовок) + "
	|" + ПолучитьШаблонОписания (Строка.Описание) + "
	|" + ПолучитьШаблонВнимание (Строка.Внимание) + "
	|" + ?(Строка.Преимущества.Количество(), "
	|<div class=""advantages"">
	|", "");
	
	Для Каждого прСтрока Из Строка.Преимущества Цикл
		
		Текст = Текст + ПолучитьШаблонПреимущества(прСтрока.Значение);
	КонецЦикла;
	
	Текст = Текст + ?(Строка.Преимущества.Количество(), "</div>", "");
	
	Текст = Текст + "</div>";
	
	
	//Текст = Текст + ПолучитьШаблонКомплектации(Строка.Комплектация);
	
	Возврат Текст; 
	
КонецФункции

&НаСервере
Функция ПолучитьШаблонСценария()
	
	//Возврат "
	//|<script src=""http://garagetools.ru/images/articles/magnific-popup/magnific-popup.js""></script>
	//|<script>
	//|	var main = function() {
	//|		$("".advantageImage > a > img"").each(function(){
	//|			$(this).parent(""a"").attr(""href"",$(this).attr(""src""));
	//|		});
	//|		$('.advantageImage > a').magnificPopup({ 
	//|			type: 'image',
	//|			closeOnContentClick: true
	//|		});
	//|	};
	//|	$(document).ready(main);
	//|	$(document).ready(function() {
	//|		$('.image-link').magnificPopup({type:'image'});
	//|	});
	//|</script>";
	Возврат "";
КонецФункции


&НаКлиенте
Процедура Выгрузить(Эксель)
	
	Лист = Эксель.Worksheets(1);
    КолВоСтрок = Лист.Cells(1,1).SpecialCells(11).Row;
	СписокПреимуществ = Новый СписокЗначений; 	
	предСтрокаТаблицы = Неопределено;
	Таблица.Очистить();
	Для Сч = 2 По КолВоСтрок Цикл
		
		Текст = ""; 
		
		НачальнаяКолонка = СокрЛП(Лист.Cells(Сч, 1).Value);
		
		Если ЛЕВ(НачальнаяКолонка, 1) = "!" Тогда  
			
			СтрокаТаблицы = Таблица.Добавить();
			
			Если  предСтрокаТаблицы <> Неопределено Тогда 
				предСтрокаТаблицы.Преимущества = СписокПреимуществ; 
				СписокПреимуществ = Новый СписокЗначений;
				Текст = ПолучитьИтоговыйШаблон(предСтрокаТаблицы);
				предСтрокаТаблицы.Результат = Текст;
				
			КонецЕсли;
			
			СтрокаТаблицы.Артикул = СРЕД(Лист.Cells(Сч, 1).Value, 2);
			СтрокаТаблицы.Заголовок = Лист.Cells(Сч, 2).Value; 	
				
			СтрокаТаблицы.Описание 	= Лист.Cells(Сч, 3).Value; 
			СтрокаТаблицы.Внимание = Лист.Cells(Сч, 4).Value; 
			СтрокаТаблицы.Комплектация = Лист.Cells(Сч, 5).Value;  
		    //СтрокаТаблицы.Преимущества = СписокПреимуществ; 
			
			предСтрокаТаблицы = СтрокаТаблицы; 
             
		Иначе
			Название = Лист.Cells(Сч, 1).Value;
			СписокПреимуществ.Добавить(Новый Структура("Название, Картинка, Описание, АльтТайтл", 
			Название, 
			Лист.Cells(Сч, 2).Value, 
			Лист.Cells(Сч, 3).Value, 
			Лист.Cells(Сч, 4).Value
			), Название); 
		КонецЕсли;
		
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработку(Команда)
	
	Если ПустаяСтрока(ИмяФайла) Тогда
		ОбщиеФункции.СообщитьТекст("Не выбран файл", "ИмяФайла", Объект);
		Возврат;
	КонецЕсли;
		
	// Получим эксель
	стрОшибки = "";	         
	Эксель = COMФункцииДиалогов.ОткрытьФайлЭкселя(ИмяФайла, стрОшибки);
	
	Если Эксель = Неопределено Тогда
		ОбщиеФункции.СообщитьТекст(стрОшибки);
		Возврат;
	КонецЕсли;
	
	Выгрузить(Эксель);
	
	COMФункцииДиалогов.ЗакрытьЭксель(Эксель);
	ОбщиеФункции.СообщитьТекст("Данные загружены.");

КонецПроцедуры

&НаКлиенте
Процедура ПутьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДВ = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДВ.Фильтр =  "Эксель (*.xls)|*.xls*";
	
	Если ДВ.Выбрать() Тогда
		
		ИмяФайла = ДВ.ПолноеИмяФайла;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	ВыполнитьНаСервере();
	
	Сообщить("Данные успешно сохранены");

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	УстановитьЗначениеФлагаНаСервере(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	УстановитьЗначениеФлагаНаСервере(Ложь);
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеФлагаНаСервере(Флаг)
	
	времТаблица = Таблица.Выгрузить();
	времТаблица.ЗаполнитьЗначения(Флаг, "ВыгружатьНаСайт");
	Таблица.Загрузить(времТаблица);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.Таблица.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ХТМЛ = "<HTML><HEAD>
			|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
			|<META name=GENERATOR content=""MSHTML 9.00.8112.16563""></HEAD>
			|<BODY>	" + ТекущиеДанные.Результат  + "</BODY></HTML>";
	КонецЕсли;
КонецПроцедуры
