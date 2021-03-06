﻿
Функция ИзменитьСпособОтображенияьНовости(ГуидСтрока, Отказ, ГуидПользователя) Экспорт
	
	НовостьСсылка = Документы.Новость.ПолучитьСсылку(Новый УникальныйИдентификатор(ГуидСтрока));
	
	Если НовостьСсылка.ПолучитьОбъект().Ссылка.Пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НовЗапись = РегистрыСведений.ОтказанныеНовости.СоздатьМенеджерЗаписи();
	
	НовЗапись.Новость 		= НовостьСсылка;
	НовЗапись.Пользователь 	= Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор(ГуидПользователя));
	НовЗапись.Период 		= ТекущаяДата();
	НовЗапись.Отказ 		= Отказ;
	
	Возврат ОбщиеФункции.ЗаписатьОбъектИСообщитьЕслиОшибка(НовЗапись);
	
КонецФункции

Функция ПолучитьОбъектПоГуидСтроке(Менеджер, СтрокаГуид) Экспорт
	
	Возврат Вычислить(Менеджер).ПолучитьСсылку(Новый УникальныйИдентификатор(СтрокаГуид));
	
КонецФункции
