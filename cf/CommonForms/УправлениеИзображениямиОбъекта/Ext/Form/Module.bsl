﻿
&НаСервере
Процедура ОбновитьТекущееИзображение()
	
	Картинка = Элементы.СписокФайлов.ТекущиеДанные.Картинка;
	
	//Картинка = РаботаСИзображениями.ПолучитьКартинку(Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловПриАктивизацииСтроки(Элемент)
	
	ОбновитьТекущееИзображение();
	
КонецПроцедуры
