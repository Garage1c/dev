﻿Процедура УстановитьРеквизитСпр(РеквУст, РеквДай, Изменился)
	
	Если Не ЗначениеЗаполнено(РеквУст) И РеквУст <> РеквДай Тогда
		Изменился = Истина;
		РеквУст = РеквДай; КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьИУстановитьСоответвияРеквизитовСправочникаРегиструНоНеЗаписывать(СпрОбъект, Запись, Изменился) Экспорт
	
	УстановитьРеквизитСпр(СпрОбъект.Поставщик, 				Запись.Контрагент, 			Изменился);
	УстановитьРеквизитСпр(СпрОбъект.АртикулПоставщика, 		Запись.АртикулПоставщика, 	Изменился);
	УстановитьРеквизитСпр(СпрОбъект.КомментарийПоставщика, 	Запись.Комментарий, 		Изменился);
	УстановитьРеквизитСпр(СпрОбъект.СрокПроизводства, 		Запись.СрокПроизводства, 	Изменился);
	УстановитьРеквизитСпр(СпрОбъект.СрокДоставки, 			Запись.СрокДоставки, 		Изменился);
	
КонецПроцедуры
