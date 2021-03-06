﻿
// ОБРАБОТЧИКИ СОБЫТИЙ СВЯЗАННЫХ С ТАБЛИЦЕЙ КОНТАКТНОЙ ИНФОРМАЦИИ НА ФОРМАХ

// Событие НачалоВыбора в колонке Представление таблицы контактной информации
Процедура ПредставлениеНачалоВыбора(Форма, Ссылка, Модифицированность, СтандартнаяОбработка) Экспорт
	
	// ссылка - какие данные открыть. данные будут записаны для ТекущиеДанные.Объект
	
	ТекущиеДанные 	= Форма.Элементы.КонтактнаяИнформация.ТекущиеДанные;
	ОткрытьФорму("ОбщаяФорма.ФормаКонтактнойИнформации", Новый Структура("Объект, Вид, ID, ИдентификаторСтроки", Ссылка, ТекущиеДанные.Вид, ТекущиеДанные.ID, Форма.Элементы.КонтактнаяИнформация.ТекущаяСтрока), Форма);

КонецПроцедуры

// Событие ПриНачалеРедактирования в таблице КонтактнаяИнформация на форме
Процедура ПриНачалеРедактирования(Форма, Ссылка, НоваяСтрока, Копирование) Экспорт
	
	Если НоваяСтрока Тогда
		ТекущиеДанные 	= Форма.Элементы.КонтактнаяИнформация.ТекущиеДанные;
		ТекущиеДанные.ID = Строка(Новый УникальныйИдентификатор);  
		ТекущиеДанные.Объект = Ссылка; 		
	КонецЕсли;

КонецПроцедуры

Функция ПриИзменении(Форма) Экспорт
	
	
КонецФункции

Процедура ПередУдалением(Форма, Ссылка, Отказ) экспорт
	
	ТекущиеДанные 	= Форма.Элементы.КонтактнаяИнформация.ТекущиеДанные;
    Отказ = НЕ УправлениеКонтактнойИнформацией.УдалитьЗаписьКонтактнойИнформации(ТекущиеДанные.Объект, ТекущиеДанные.Вид, ТекущиеДанные.ID);
	
КонецПроцедуры

