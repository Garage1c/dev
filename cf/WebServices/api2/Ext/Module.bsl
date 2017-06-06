
Функция get_categories(guids = "", err = "")
	
	Возврат w1_Json.JSON(API2.ПолучитьКатегории(Новый Структура("guid_category", w1_Json.UnJSON(guids)), err), Истина);
		
КонецФункции
Функция get_products(guid_category = "", guids = "", begin_number = 0, end_number = 0, err = "")
	
	Возврат w1_Json.JSON(API2.ПолучитьТовары(Новый Структура("guid_category, ГуидыТоваров, НомерНачала, НомерОкончания", guid_category, w1_Json.UnJSON(guids), begin_number, end_number), err), Истина);
	
КонецФункции
Функция get_products_count(guid_category = "", err = "")
	
	Возврат w1_Json.JSON(API2.ПолучитьКоличествоТоваровВВыборке(Новый Структура("guid_category", guid_category), err));
	
КонецФункции
Функция get_manufacturers(guids = "", err)
	
	Возврат w1_Json.JSON(API2.ПолучитьПроизводителей(Новый Структура("guid_manafacture", w1_Json.UnJSON(guids)),err), Истина);
	
КонецФункции
Функция get_warehouses(guids = "", err)
	
	Возврат w1_Json.JSON(API2.ПолучитьСклады(Новый Структура("guids", w1_Json.UnJSON(guids)),err), Истина);
	
КонецФункции

Функция get_article_categories(guids, err)
	
	Возврат w1_Json.JSON(API2.ПолучитьКатегорииСтатьи(Новый Структура("guid_article_category", w1_Json.UnJSON(guids)), err), Истина);
	
КонецФункции
Функция get_articles(guids, err)
	Возврат w1_Json.JSON(API2.ПолучитьСтатьи(Новый Структура("guid_article", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции

Функция get_properties(guids, err = "")
	
	Возврат w1_Json.JSON(API2.ПолучитьСвойстваНоменклатуры(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
	
КонецФункции

Функция get_discount_card(discount_card_number, err = "")
	
	ЗаписьЖурналаРегистрации("API2.get_discount_card", УровеньЖурналаРегистрации.Информация,,,"сard=" + discount_card_number);
	Возврат w1_Json.JSON(API2.ПолучитьИнформационнуюКартуПоНомеру(Новый Структура("discount_card_number", w1_Json.UnJSON(discount_card_number, , "строка")), err), Истина);
	
КонецФункции

Функция get_discount_percents(guids, err = "")
	
	Возврат w1_Json.JSON(API2.ПолучитьПорогиСкидок(Новый Структура("guids", w1_Json.UnJSON(guids)),err), Истина);
	
КонецФункции

Функция get_type_prices(guids, err)
	
	Возврат w1_Json.JSON(API2.ПолучитьТипыЦен(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
	
КонецФункции

Функция get_users(guids, err)
	Возврат w1_Json.JSON(API2.ПолучитьПользователей(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции
Функция create_user(user, err)
	
	ЗаписьЖурналаРегистрации("API2.create_user", УровеньЖурналаРегистрации.Информация,,,"user=" + user);
	Возврат API2.СоздатьПользователя(user, err);
	
КонецФункции
Функция update_user(user, err)
	
	ЗаписьЖурналаРегистрации("API2.update_user", УровеньЖурналаРегистрации.Информация,,,"user=" + user);
	Возврат API2.ОбновитьПользователя(user, Неопределено, err);
	
КонецФункции
Функция delete_user(user_guid, err)
	
	Возврат API2.УдалитьПользователя(user_guid, err);
	
КонецФункции

Функция create_order(order, err)
	
	ЗаписьЖурналаРегистрации("API2.create_order", УровеньЖурналаРегистрации.Информация,,,"order=" + order);
	Возврат API2.ОбновитьЗаказ(order, err);
	
КонецФункции
Функция update_order(order, err)
	
	ЗаписьЖурналаРегистрации("API2.update_order", УровеньЖурналаРегистрации.Информация,,,"order=" + order);
	Возврат API2.ОбновитьЗаказ(order,err,,Истина);
	
КонецФункции
Функция delete_order(order, err)
	
	Возврат API2.УдалитьЗаказ(order, err);
	
КонецФункции

Функция Request1CWebTable(Request1C, ТableData)
	
    Запрос = Новый Запрос;
    ТableData = "";
    Сериализатор = Новый СериализаторXDTO(ФабрикаXDTO);
    ТекстЗапроса = Сериализатор.ПрочитатьXDTO(Request1C);
    Запрос.Текст = ТекстЗапроса;

    //Результат - таблица значений
    Попытка
        ТабЗапроса = Запрос.Выполнить().Выгрузить();
    Исключение
        ЗаписьЖурналаРегистрации("Request1C",,,,Строка(Request1C) + " !!! "+ОписаниеОшибки());
        Возврат Ложь;
    Конецпопытки;

    //строка заголовка
    ТableData = "";
    Для каждого колонка Из ТабЗапроса.Колонки Цикл
        ТableData = ТableData +  ""+ СокрЛП(колонка.Заголовок) + "";
    КонецЦикла;
    ТableData = ТableData +  "";

    //таблица данных
    ТableData = ТableData +  "";
    Для строка=0 По ТабЗапроса.Количество()-1 Цикл
        ТableData = ТableData +  "";
        Для кол=0 По ТабЗапроса.колонки.Количество()-1 Цикл
            ТableData = ТableData + ""+ Строка(ТабЗапроса[строка][кол]) + "";
        КонецЦикла;
        ТableData = ТableData +  "";
    КонецЦикла;
    ТableData = ТableData + "";
    ТабЗапроса = 0;
    Возврат Истина;

КонецФункции

Функция get_analogs_product(guids, err)
	Возврат w1_Json.JSON(API2.ПолучитьАналогиТоваров(Новый Структура("ИдентификаторыТоваров", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции
Функция get_related_products(guids, err)
	Возврат w1_Json.JSON(API2.ПолучитьСопутствующиеТовары(Новый Структура("ИдентификаторыТоваров", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции

Функция get_levels(users, err)
	Возврат w1_Json.JSON(API2.УровниСкидокПользователей(Новый Структура("ИдентификаторыПользователей", w1_Json.UnJSON(users)), err), Истина);
КонецФункции

Функция get_products_list(list_name, err)
	Если list_name = "offers" Тогда
		ИмяПризнака = "Акция";
	ИначеЕсли list_name = "latest" Тогда
		ИмяПризнака = "Новинка";
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ Ссылка, sorting_weight ИЗ Справочник.Номенклатура ГДЕ ПометкаУдаления = ЛОЖЬ И ВыгружатьНаСайт = ИСТИНА И " + ИмяПризнака + " = ИСТИНА
	|");
	
	МассивГуидов = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивГуидов.Добавить(Новый Структура("guid, sorting_weight", XMLСтрока(Выборка.Ссылка), Выборка.sorting_weight));
	КонецЦикла;
	
	Возврат w1_Json.JSON(МассивГуидов, Истина);
КонецФункции

Функция get_orders(guids, err)
	Возврат w1_Json.JSON(API2.ПолучитьЗаказы(Новый Структура("orders", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции

Функция get_images(guids, err)
	Возврат стрЗаменить(w1_Json.JSON(API2.ПолучитьКартинку(Новый Структура("guid_image", w1_Json.UnJSON(guids)),err), Истина),"\r\n", "");
КонецФункции

Функция get_payment_variants(guids, err)
	Возврат w1_Json.JSON(API2.ПолучитьВидыОплат(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции

Функция get_severstal_limits(guids, err)
	Возврат w1_Json.JSON(API2.ПолучитьЛимитыСеверстали(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции

Функция get_delivery_address(guids, err)
	Возврат w1_Json.JSON(API2.ПолучитьАдресаДоставки(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции
Функция create_delivery_address(delivery_address, err)
	ЗаписьЖурналаРегистрации("API2.create_adress", УровеньЖурналаРегистрации.Информация,,,"adress=" + delivery_address);
	Возврат API2.СоздатьАдрес(delivery_address, err);
КонецФункции
Функция update_delivery_address(delivery_address, err)
	ЗаписьЖурналаРегистрации("API2.update_adres", УровеньЖурналаРегистрации.Информация,,,"adress=" + delivery_address);
	Возврат API2.ОбновитьАдрес(delivery_address, err);
КонецФункции
Функция delete_delivery_address(delivery_address_guid, err)
	Возврат API2.УдалитьАдрес(Новый Структура("guid", w1_Json.UnJSON(delivery_address_guid)), err);
КонецФункции

Функция get_actions(guids, err)
	Возврат w1_Json.JSON(API2.ПолучитьАкции(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции

Функция create_check_available(check_available, err)
	ЗаписьЖурналаРегистрации("API2.check_available", УровеньЖурналаРегистрации.Информация,,,"check_available=" + check_available);
	Возврат API2.СоздатьЗапросНаУточнениеОстатка(check_available, err);
КонецФункции

Функция get_documents(guids, changesFromDate, err)
	Возврат w1_Json.JSON(API2.ПолучитьДокументы(Новый Структура("guids, changesFromDate", w1_Json.UnJSON(guids), changesFromDate),err), Истина);
КонецФункции

Функция get_external_images(guids, changesFromDate, err)
	Возврат w1_Json.JSON(API2.ПолучитьКартинки(Новый Структура("guids, changesFromDate", w1_Json.UnJSON(guids), changesFromDate),err), Истина);
КонецФункции

Функция create_file_extend(externalfile, err)
ЗаписьЖурналаРегистрации("API2.create_file_extend", УровеньЖурналаРегистрации.Информация,,,"externalfile=" + externalfile);
	Возврат API2.СоздатьФайл(externalfile, err);
	// Возврат Истина; 

КонецФункции

Функция get_externalfile(guids, changesFromDate, err)
	//Возврат w1_Json.JSON(API2.ПолучитьФайлЗаказа(Новый Структура("guids, changesFromDate", w1_Json.UnJSON(guids), changesFromDate),err), Истина);
 Возврат Истина; 
КонецФункции

Функция payment_order(order, err)
	
	ЗаписьЖурналаРегистрации("API2.payment_order", УровеньЖурналаРегистрации.Информация,,,"order=" + order);
	Возврат w1_Json.JSON36(API2_Оплаты.ОплатаПоЗаказу(order, err));
	
КонецФункции

Функция create_reconcile(reconcile, err)
	
	ЗаписьЖурналаРегистрации("API2.create_reconcile", УровеньЖурналаРегистрации.Информация,,,"reconcile=" + reconcile);
	Возврат w1_Json.JSON36(API2.СоздатьЗапросНаСогласованиеТовара(reconcile, err));
	//Возврат Истина;
КонецФункции

Функция get_reconcile(guids, err)
	
	Возврат w1_Json.JSON(API2.ПолучитьЗапросНаСогласование(Новый Структура("guid_reconcile", w1_Json.UnJSON(guids)), err), Истина);
	             
КонецФункции

Функция get_managers(guids, err)
	Возврат w1_Json.JSON(API2.ПолучитьМенеджеров(Новый Структура("guid_manager", w1_Json.UnJSON(guids)),err), Истина);

КонецФункции






