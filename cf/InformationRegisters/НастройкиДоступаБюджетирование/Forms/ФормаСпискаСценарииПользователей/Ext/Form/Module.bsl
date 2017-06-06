﻿
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Параметры_ = Новый Структура;
	Параметры_.Вставить("Сценарий", Элемент.ТекущиеДанные.Сценарий);
    Параметры_.Вставить("Пользователь", Элемент.ТекущиеДанные.Пользователь);
	
	Если  Не ЗначениеЗаполнено(Элемент.ТекущиеДанные.Пользователь) Тогда
		ДатаЗапретаРедактирования=ДатаЗапретаРедактирования (Элемент.ТекущиеДанные.Сценарий);			
		Параметры_.Вставить("ДатаЗапретаРЕдактирования", ДатаЗапретаРедактирования);
	КонецЕСли;	

    ФормаВыбора = ПолучитьФорму("РегистрСведений.НастройкиДоступаБюджетирование.Форма.ФормаСценарийПользователя", Параметры_);
    ФормаВыбора.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПолныйСписок(Команда)
	ФормаВыбора = ПолучитьФорму("РегистрСведений.НастройкиДоступаБюджетирование.Форма.ФормаСписка");
	ФормаВыбора.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСценарийПользователя(Команда)
	ФормаВыбора = ПолучитьФорму("РегистрСведений.НастройкиДоступаБюджетирование.Форма.ФормаСценарийПользователя");
    ФормаВыбора.Открыть();
КонецПроцедуры

&НаСервере
Функция ДатаЗапретаРедактирования (Сценарий)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиДоступаБюджетирование.ОбъектДоступа
	|ИЗ
	|	РегистрСведений.НастройкиДоступаБюджетирование КАК НастройкиДоступаБюджетирование
	|ГДЕ
	|	НастройкиДоступаБюджетирование.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	И НастройкиДоступаБюджетирование.Сценарий = &Сценарий";
	
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	
	РезультатЗапросаДата = Запрос.Выполнить();
	
	
	ВыборкаДетальныеЗаписи = РезультатЗапросаДата.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Возврат ВыборкаДетальныеЗаписи.ОбъектДоступа;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

