﻿&НаКлиенте
перем ПутьКПрограмме;
&НаКлиенте
перем ИмяПрограммы;
&НаКлиенте
перем КомандаПрограммы;
&НаКлиенте
перем ВременныйКаталог;
&НаКлиенте
перем СформированныйПДФФайл;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекстХТМЛ = Параметры.ТекстХТМЛ;
	Если ТипЗнч(Параметры.ДополнительныеПараметры) = Тип("Массив") Тогда
		Для Каждого Элемент Из Параметры.ДополнительныеПараметры Цикл 
			ЗаполнитьЗначенияСвойств(ДополнительныеПараметры.Добавить(), Элемент) 
		КонецЦикла; 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПДФ(Команда)
	СформированныйПДФФайл = "";
	Режим = РежимДиалогаВыбораФайла.Сохранение;
	ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(Режим);
	ДиалогВыбораКаталога.МножественныйВыбор = Ложь;
	ДиалогВыбораКаталога.Заголовок = "Укажите имя файла";
	//ДиалогВыбораКаталога.Расширение = "pdf";
	ДиалогВыбораКаталога.Фильтр = "*.pdf";
	Если ДиалогВыбораКаталога.Выбрать() Тогда
		СформированныйПДФФайл = КонвертироватьHTMLвPDF(ДиалогВыбораКаталога.Каталог, ДиалогВыбораКаталога.ПолноеИмяФайла);		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция КонвертироватьHTMLвPDF(Каталог, ПолноеИмяФайла)
	ЭтоВременныйКаталог = Ложь;	
	//ИмяФайлаПДФ = "Present"+"_"+Строка(УникальныйИдентификатор)+".pdf";
	Файл_ = Новый Файл(ПолноеИмяФайла);
	ИмяФайлаПДФ = Файл_.Имя;
	//ВременныйКаталог = КаталогВременныхФайлов();
	ВременныйФайлХТМЛ = ""; //полное имя временного файла
	/////Создадим html файл///////////////////////////////////////////
	ТекстДок = Новый ТекстовыйДокумент;
	ТекстДок.УстановитьТекст(ТекстХТМЛ);
	
	Попытка
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("html");
		ТекстДок.Записать(ИмяВременногоФайла, КодировкаТекста.UTF8);
		//ВременныйФайлХТМЛ = ВременныйКаталог+"\"+ИмяФайлаПДФ;
	Исключение
		ВызватьИсключение;
	КонецПопытки;
	
	/////теперь конвертируем его в pdf  с помощью внешней программы//////
	//Программа хранится на сетевом диске и в реквизите справочника с типом ХранилищеЗначений
	//Если ее вдруг не окажется на сетевом диске, или диск будет не доступен то распакуем ее из Хранилища значений
	Файл = Новый Файл(ПутьКПрограмме+ИмяПрограммы);
	Если НЕ Файл.Существует() Тогда                                         
		Адрес = ПолучитьАдресПрограммыИзХранилищаЗначений(ИмяПрограммы);    
		ФайлПрограммы = ПолучитьИзВременногоХранилища(Адрес);               
		ФайлПрограммы.Записать(КаталогВременныхФайлов()+"\"+ИмяПрограммы);  
		ПутьКПрограмме = КаталогВременныхФайлов();                          
		ЭтоВременныйКаталог = Истина;                                       
	КонецЕсли;
	
	ВременныйФайлХТМЛ_ = "file:///"+СтрЗаменить(ИмяВременногоФайла,"\", "/");
	КомандаСистемы(ПутьКПрограмме+КомандаПрограммы+" "+ВременныйФайлХТМЛ_+" "+ПолноеИмяФайла);
	////убираем а собой мусор
	Попытка
		Если ЭтоВременныйКаталог Тогда
			УдалитьФайлы(ПутьКПрограмме+ИмяПрограммы);
		КонецЕсли;
		УдалитьФайлы(ИмяВременногоФайла);	
	Исключение
		ВызватьИсключение;
	КонецПопытки;
	Возврат ПолноеИмяФайла;
КонецФункции

&НаСервере
Функция ПолучитьАдресПрограммыИзХранилищаЗначений(ИмяПрограммы)
	Спр = Справочники.ХранилищеДвоичныхДанных.НайтиПоНаименованию(ИмяПрограммы);
	Темп = Спр.ХранилищеБинарныхДанных.Получить();
	Адрес = ПоместитьВоВременноеХранилище(Темп, УникальныйИдентификатор);
	Возврат Адрес;
КонецФункции

&НаКлиенте
Процедура ОтправитьНаЭлектроннуюПочту(Команда)
	Если СформированныйПДФФайл = "" Тогда
		СформированныйПДФФайл = КонвертироватьHTMLвPDF(КаталогВременныхФайлов(), ПолучитьИмяВременногоФайла("pdf"));		
	КонецЕсли;
	Кому = Новый Массив;
		Для Каждого Строка Из ДополнительныеПараметры Цикл 		
			Структура = Новый Структура("Партнер", Строка.Партнер);
			Если Найти(Строка.Почта, "@") Тогда 
				Структура.Вставить("Почта", Строка.Почта); 
			КонецЕсли; 
			
			Кому.Добавить(Структура); 
		КонецЦикла;
		//	
		//	// Добавим вложения
		//
		Файл = новый Файл(СформированныйПДФФайл);	
		Вложения = Новый Массив;
		Вложения.Добавить(Новый Структура("ИмяФайла, ПолноеИмяФайла", Файл.Имя, СформированныйПДФФайл));
		
		// Откроем письмо для отправки
		
		ОткрытьФорму("Документ.Письмо.Форма.Письмо2",Новый Структура("Кому, Вложения, УдалитьФайлыПослеОтправки", Кому, Вложения), ЭтаФорма,,,,Новый ОписаниеОповещения("ПослеОтправкиПисьма", ЭтаФорма, Новый Структура)); 			
КонецПроцедуры



&НаСервере
Процедура ПослеОтправкиПисьма(Результат, Параметры) Экспорт
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПутьКПрограмме = "Z:\temp\wkhtmltopdf\bin\";
	ВременныйКаталог = "Z:\temp\";
	ИмяПрограммы = "wkhtmltopdf.exe";
	КомандаПрограммы = "wkhtmltopdf";
	СформированныйПДФФайл = "";
КонецПроцедуры





