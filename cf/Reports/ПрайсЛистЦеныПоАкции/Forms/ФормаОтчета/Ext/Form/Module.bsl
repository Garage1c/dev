﻿
&НаКлиенте
Процедура ВПочту(Команда)
	
	ОткрытьФорму("Документ.Письмо.Форма.Письмо2", 
			Новый Структура("ИмяТабличногоДокумента, ТабличныйДокумент, УдалитьФайлыПослеОтправки, ТипФайлаВложения, РасширениеФайлаВложения", 
									"прайс-лист_" + формат(ТекущаяДата(),"ДФ=yyyy-MM-dd"), 
									Результат, 
									Истина,
									ТипФайлаТабличногоДокумента.XLS97,
									"xls"));
КонецПроцедуры
