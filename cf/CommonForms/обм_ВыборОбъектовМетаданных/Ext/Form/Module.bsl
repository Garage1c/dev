﻿///////////////////////////////////////////////////////////////////////////////
//                      БЛОК ОБРАБОТЧИКОВ СОБЫТИЙ                            //
///////////////////////////////////////////////////////////////////////////////

&НаСервере
// Процедура обработчик события ПриСозданииНаСервере формы
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтборМетаданныеЗаполнить();
	
	// silber {
	
	Если Не Параметры.МножественныйВыбор Тогда
		
		ЭтаФорма.ПоложениеКоманднойПанели 	= ПоложениеКоманднойПанелиФормы.Нет;
		Элементы.Отбирать.Видимость 		= Ложь;
		
	КонецЕсли;
	
	// } silber
	
КонецПроцедуры

&НаКлиенте
// Процедура обработчик события нажатия на кнопку формы "Выбрать"
//
Процедура ВыбратьВыполнить()
	
	ВыбранныеМетаданные.Очистить();
	ПолучениеДанных();
	
	Оповестить("ВыборОбъектовМетаданных", ВыбранныеМетаданные, Параметры.УникальныйИдентификаторИсточник);
	
	// silber {
	
	ОповеститьОВыборе(ВыбранноеМетаданное);
	
	Если Открыта() Тогда
		
	// } silber
	
		Закрыть(ВыбранноеМетаданное);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события нажатия на кнопку формы "Закрыть"
// 
Процедура ЗакрытьВыполнить()
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
// Процедура обработчик события нажатия на поле "Отбирать" дерева формы
// 
Процедура ОтбиратьПриИзменении(Элемент)

	ТекущиеДанные = ТекущийЭлемент.ТекущиеДанные;
	Если ТекущиеДанные.Отбирать = 2 Тогда
		ТекущиеДанные.Отбирать = 0;
	КонецЕсли;
	Родитель = ТекущиеДанные.ПолучитьРодителя();
	УстановитьФлажки(ТекущиеДанные.Отбирать, ТекущиеДанные.ПолучитьЭлементы());
	УстановитьФлажкиРодителя(ТекущиеДанные.Отбирать, Родитель);

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
//                      БЛОК ВСПОМОГАТЕЛЬНЫЙ ФУНКЦИЙ                         //
///////////////////////////////////////////////////////////////////////////////

&НаСервере
// Процедура заполняет дерево значений объектов конфигурации.
// Если список значений "Параметры.ВыбранныеМетаданные" не пуст дерево будет сформировано 
// на основе переданного списка типов объектов метаданных
//
Процедура ОтборМетаданныеЗаполнить()
	
	ТабОбъектыМетаданных = Новый ТаблицаЗначений;
	ТабОбъектыМетаданных.Колонки.Добавить("Имя");
	ТабОбъектыМетаданных.Колонки.Добавить("Синоним");
	ТабОбъектыМетаданных.Колонки.Добавить("Картинка");
	ТабОбъектыМетаданных.Колонки.Добавить("КартинкаОбъекта");
	ТабОбъектыМетаданных.Колонки.Добавить("Корень");
	
	ТабОбъектыМетаданных_НоваяСтрока("Подсистемы", 						"Подсистемы", 						35, 36, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ОбщиеМодули", 					"Общие модули", 					37, 38, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ПараметрыСеанса", 				"Параметры сеанса", 				39, 40, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("Роли", 							"Роли", 							41, 42, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ПланыОбмена", 					"Планы обмена", 					43, 44, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("КритерииОтбора", 					"Критерии отбора", 					45, 46, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ПодпискиНаСобытия", 				"Подписки на события", 				47, 48, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("РегламентныеЗадания", 			"Регламентные задания", 			49, 50, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ФункциональныеОпции", 			"Функциональные опции", 			51, 52, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ПараметрыФункциональныхОпций", 	"Параметры функциональных опций", 	53, 54, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ХранилищаНастроек", 				"Хранилища настроек", 				55, 56, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ОбщиеФормы", 						"Общие формы", 						57, 58, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ОбщиеКоманды", 					"Общие команды", 					59, 60, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ГруппыКоманд", 					"Группы команд", 					61, 62, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("Интерфейсы", 						"Интерфейсы", 						63, 64, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ОбщиеМакеты", 					"Общие макеты", 					65, 66, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ОбщиеКартинки", 					"Общие картинки", 					67, 68, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ПакетыXDTO", 						"XDTO-пакеты", 						69, 70, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("WebСервисы", 						"Web-сервисы", 						71, 72, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("WSСсылки", 						"WS-ссылки", 						73, 74, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("Стили", 							"Стили", 							75, 76, Ложь, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("Языки", 							"Языки", 							77, 78, Ложь, ТабОбъектыМетаданных);
	
	ТабОбъектыМетаданных_НоваяСтрока("Константы", 						"Константы", 						БиблиотекаКартинок.Константа, БиблиотекаКартинок.Константа, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("Справочники", 					"Справочники", 						БиблиотекаКартинок.Справочник, БиблиотекаКартинок.Справочник, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("Документы", 						"Документы", 						БиблиотекаКартинок.Документ,БиблиотекаКартинок.ДокументОбъект, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ЖурналыДокументов", 				"Журналы документов", 				БиблиотекаКартинок.ЖурналДокументов, БиблиотекаКартинок.ЖурналДокументов, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("Перечисления", 					"Перечисления", 					БиблиотекаКартинок.Перечисление, БиблиотекаКартинок.Перечисление, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("Отчеты", 							"Отчеты", 							БиблиотекаКартинок.Отчет, БиблиотекаКартинок.Отчет, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("Обработки", 						"Обработки", 						БиблиотекаКартинок.Обработка, БиблиотекаКартинок.Обработка, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ПланыВидовХарактеристик", 		"Планы видов характеристик", 		БиблиотекаКартинок.ПланВидовХарактеристик, БиблиотекаКартинок.ПланВидовХарактеристикОбъект, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ПланыСчетов", 					"Планы счетов", 					БиблиотекаКартинок.ПланСчетов, БиблиотекаКартинок.ПланСчетовОбъект, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("ПланыВидовРасчета", 				"Планы видов характеристик", 		БиблиотекаКартинок.ПланВидовХарактеристик, БиблиотекаКартинок.ПланВидовХарактеристикОбъект, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("РегистрыСведений", 				"Регистры сведений", 				БиблиотекаКартинок.РегистрСведений, БиблиотекаКартинок.РегистрСведений, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("РегистрыНакопления", 				"Регистры накопления", 				БиблиотекаКартинок.РегистрНакопления, БиблиотекаКартинок.РегистрНакопления, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("РегистрыБухгалтерии", 			"Регистры бухгалтерии", 			БиблиотекаКартинок.РегистрБухгалтерии, БиблиотекаКартинок.РегистрБухгалтерии, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("РегистрыРасчета", 				"Регистры расчета", 				БиблиотекаКартинок.РегистрРасчета, БиблиотекаКартинок.РегистрРасчета, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("БизнесПроцессы", 					"Бизнес-процессы", 					БиблиотекаКартинок.БизнесПроцесс, БиблиотекаКартинок.БизнесПроцессОбъект, Истина, ТабОбъектыМетаданных);
	ТабОбъектыМетаданных_НоваяСтрока("Задачи", 							"Задачи", 							БиблиотекаКартинок.Задача, БиблиотекаКартинок.ЗадачаОбъект, Истина, ТабОбъектыМетаданных);
	
	// Создаем корневой элемент - представление как имя конфигурации
	Корень = НоваяСтрокаДерева(Метаданные.Имя, Метаданные.Синоним, 79, ОтборМетаданные);
	
	// Если в форму передан список типов объектов метаданных, которые нужно отобразить
	// то создаем дерево на основе этого списка
	Если Параметры.ВыбранныеМетаданные.Количество() > 0 Тогда
		Для Каждого ТекЭлемент ИЗ Параметры.ВыбранныеМетаданные Цикл
			текСтрока = ТабОбъектыМетаданных.Найти(ТекЭлемент.Значение,"Имя");
			Если НЕ текСтрока = Неопределено Тогда
				ВыводКоллекцииОбъектовМетаданных(текСтрока.Имя, текСтрока.Синоним, текСтрока.Картинка,
				                                 текСтрока.КартинкаОбъекта, 
												 Корень, 
												 ?(текСтрока.Имя="Подсистемы", Метаданные.Подсистемы, Неопределено));
			КонецЕсли;
		КонецЦикла;
	Иначе
		КореньОбщие = НоваяСтрокаДерева("Общие", "Общие", 0, Корень);
		Для каждого текСтрока ИЗ ТабОбъектыМетаданных Цикл
			ВыводКоллекцииОбъектовМетаданных(текСтрока.Имя, текСтрока.Синоним, текСтрока.Картинка,
			                                 текСтрока.КартинкаОбъекта,
			                                 ?(текСтрока.Корень,Корень, КореньОбщие),
											 ?(текСтрока.Имя="Подсистемы", Метаданные.Подсистемы, Неопределено));
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Функция, добавляющая одну строку в дерево значений формы - дерево,
// а так же заполняющая полный набор строк из метаданных по переданному параметру
// Если параметр Подсистемы заполнен, то вызывается рекурсивно из за того,
// что подсистемы могут содержать подсистемы
// Парметры:
// Имя           - имя родительского элемента
// Синоним       - синоним родительского элемента
// Картинка      - код картинки родительского элемента
// КартинкаОбъекта - код картинки подэлемента
// Родитель      - ссылка на элемента дерева значений который является корнем
//                 для добавляемого элемента
// Подсистемы    - если заполнен то содержит значение Метаданные.Подсистемы
//                 т.е. коллекцию элементов
// 
// Возвращаемое значение:
// 
//
Функция ВыводКоллекцииОбъектовМетаданных(Имя, Синоним, Картинка, КартинкаОбъекта,
                                         Родитель=Неопределено,
                                         Подсистемы=Неопределено)
	
	НоваяСтрока = НоваяСтрокаДерева(Имя, Синоним, Картинка, Родитель);
	
	Если Подсистемы = Неопределено Тогда
		Для каждого ЭлементКоллекцииМетаданных ИЗ Метаданные[Имя] Цикл
			НоваяСтрокаДерева(ЭлементКоллекцииМетаданных.Имя,
			                  ЭлементКоллекцииМетаданных.Синоним,
							  КартинкаОбъекта,
							  НоваяСтрока
							  // silber {
							  , 
							  ЭлементКоллекцииМетаданных
							  // } silber
							  );
		КонецЦикла;
	Иначе	
		Для каждого ЭлементКоллекцииМетаданных ИЗ Подсистемы Цикл
			ВыводКоллекцииОбъектовМетаданных(ЭлементКоллекцииМетаданных.Имя,
			                                 ЭлементКоллекцииМетаданных.Синоним, Картинка,
			                                 КартинкаОбъекта,
			                                 НоваяСтрока,
			                                 ЭлементКоллекцииМетаданных.Подсистемы);
		КонецЦикла;
	КонецЕсли;
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
// Добавляет новую строку в дерево формы
// Имя           - имя элемента
// Синоним       - синоним элемента
// Картинка      - код картинки
// Родитель      - элемент дерева значений формы, от которого отращивается
//                 новая ветка
// Возвращаемое значение:
// ДанныеФормыЭлементДерево - отрощенная ветвь дерева
//
Функция НоваяСтрокаДерева(Имя, Синоним, Картинка, Родитель
	// silber {
	, МетаОбъект = Неопределено
	// } silber
	)

	ТекЭлементы = Родитель.ПолучитьЭлементы();
	НоваяСтрока = ТекЭлементы.Добавить();
	НоваяСтрока.Объект 				= Имя;
	НоваяСтрока.ОбъектПредставление = ?(ЗначениеЗаполнено(Синоним), Синоним, Имя);
	НоваяСтрока.Картинка 			= Картинка;
	
		// silber {
	
	Если МетаОбъект <> Неопределено Тогда
		
		НоваяСтрока.стрМетаданных = МетаОбъект.ПолноеИмя();
			
	КонецЕсли;
	
	// } silber

	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
// Добавляет новую строку в таблицу значений видов объектов метаданных
// конфигурации
//
// Параметры:
// Имя           - имя объекта метаданных или вида объекта метаданных
// Синоним       - синоним объекта метаданных
// Картинка      - картинка поставленная в соответствие объекту метаданных
//                 или виду объекта метаданных
// Корень        - признак того, что текущий элемент содержит подэлементы
//
Процедура ТабОбъектыМетаданных_НоваяСтрока(Имя, Синоним, Картинка, КартинкаОбъекта, Корень, Таб)
		
	НоваяСтрока = Таб.Добавить();
	НоваяСтрока.Имя 			= Имя;
	НоваяСтрока.Синоним 		= Синоним;
	НоваяСтрока.Картинка 		= Картинка;
	НоваяСтрока.КартинкаОбъекта = КартинкаОбъекта;
	НоваяСтрока.Корень 			= Корень;
		
КонецПроцедуры

&НаКлиенте
// Устанаваливает флажки у родителя элемента
//
Процедура УстановитьФлажкиРодителя(Отбирать, Родитель)

	Если НЕ Родитель = Неопределено Тогда
		Если НЕ Отбирать = 2 Тогда
			ТекЭлементы = Родитель.ПолучитьЭлементы();
			Для Каждого ТекЭлемент ИЗ ТекЭлементы Цикл
				Результат = ТекЭлемент.Отбирать;
				Если Результат <> Отбирать Тогда
					Результат = 2;
					Прервать;
				КонецЕсли; 
			КонецЦикла;
		Иначе
			Результат = 2;
		КонецЕсли;
		Родитель.Отбирать = Результат;

		УстановитьФлажкиРодителя(Результат, Родитель.ПолучитьРодителя());
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Процедура рекурсивно устанавливает/сбрасывает флажки для ветви метаданных "Элементы"
//
// Параметры:
// Отбирать      - Булево, устанавливаемое значение соответствующего реквизита дерева
// Элементы      - ДанныеФормыКоллекцияЭлементовДерева 
//
Процедура УстановитьФлажки(Отбирать, Элементы)

	Для Каждого ТекЭлемент ИЗ Элементы Цикл
		ТекЭлемент.Отбирать = Отбирать;
		УстановитьФлажки(Отбирать, ТекЭлемент.ПолучитьЭлементы());
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
// Процедура для заполнения списка выбранных элементов дерева
// Рекурсивно просматривает все дерево элементов и в случае, если элемент
// выбран формирует его полное наименование (включая путь к элементу)
//
// Родитель      - ДанныеФормыЭлементДерева
//
Процедура ПолучениеДанных(Родитель = Неопределено)
	
	Корень = ОтборМетаданные.ПолучитьЭлементы()[0];
	
	Если Родитель = Неопределено Тогда
		Родитель = ОтборМетаданные;
	КонецЕсли;
	
	ТекЭлементы = Родитель.ПолучитьЭлементы();
	
	Для Каждого ТекЭлемент ИЗ ТекЭлементы Цикл
		Родитель = ТекЭлемент.ПолучитьРодителя();
		Если НЕ (Родитель = Неопределено ИЛИ Родитель.Объект = "Общие" ИЛИ Родитель = Корень) 
		     И ТекЭлемент.Отбирать И ТекЭлемент.ПолучитьЭлементы().Количество() = 0 Тогда
			Префикс = "";
			Пока НЕ (Родитель = Неопределено ИЛИ Родитель.Объект = "Общие" ИЛИ Родитель = Корень) Цикл
				Префикс = Родитель.Объект + "." + Префикс;
				Родитель = Родитель.ПолучитьРодителя();
			КонецЦикла;
			ВыбранныеМетаданные.Добавить(Префикс + ТекЭлемент.Объект);
		КонецЕсли;
		ПолучениеДанных(ТекЭлемент);
	КонецЦикла;
	
КонецПроцедуры

// silber {

&НаКлиенте
Процедура ОтборМетаданныеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбранноеМетаданное = Элемент.ТекущиеДанные.стрМетаданных;
	ВыбратьВыполнить();
	
КонецПроцедуры


// } silber