﻿
&НаКлиенте
Процедура ИмяКомпьютераОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	#Если НЕ ВебКлиент Тогда
		Объект[Элемент.Имя] = ИмяКомпьютера();
	#КонецЕсли
	
КонецПроцедуры
