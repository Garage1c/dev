﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПользовательскиеНастройки = ПолучитьПользовательскиеНастройкиОтчета("АнализЗадолженностиПоОтгрузкам");
    УстановитьЗначениеПользовательскойНастройки(ПользовательскиеНастройки,	"Заказ" , Неопределено, Ложь);
    УстановитьЗначениеПользовательскойНастройки(ПользовательскиеНастройки,	"Контрагент" , ПараметрКоманды, Истина);
	
    ПараметрыФормыХ = Новый Структура("СформироватьПриОткрытии, Отбор, ПользовательскиеНастройки, КлючВарианта", Истина, , ПользовательскиеНастройки, "ДляРасшифровки");

    ОткрытьФорму("Отчет.АнализЗадолженностиПоОтгрузкам.Форма", ПараметрыФормыХ, ПараметрыВыполненияКоманды.Источник);	
	
	////Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("Контрагент",ПараметрКоманды );
	//ОткрытьФорму("Отчет.АнализЗадолженностиПоОтгрузкам.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

&НаСервере
Функция ПолучитьПользовательскиеНастройкиОтчета(ИмяОтчета)
    Возврат Отчеты[ИмяОтчета].Создать().КомпоновщикНастроек.ПользовательскиеНастройки;
КонецФункции

&НаСервере
Процедура УстановитьЗначениеПользовательскойНастройки(Настройки, Имя, Значение, Использование = Истина)
    Для Каждого Элемент Из Настройки.Элементы Цикл
        Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
            Если Строка(Элемент.Параметр) = Имя Тогда
                Элемент.Значение = Значение;
                Элемент.Использование = Использование;
            КонецЕсли;
        КонецЕсли;
    КонецЦикла;
КонецПроцедуры
