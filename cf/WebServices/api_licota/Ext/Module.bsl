
Функция get_categories(guids = "", err = "")
	
	Возврат w1_Json.JSON(ApiLicota.ПолучитьКатегории(Новый Структура("guid_category", w1_Json.UnJSON(guids)), err), Истина);
		
КонецФункции
Функция get_products(guid_category = "", guids = "", begin_number = 0, end_number = 0, err = "")
	
	Возврат w1_Json.JSON(ApiLicota.ПолучитьТовары(Новый Структура("guid_category, ГуидыТоваров, НомерНачала, НомерОкончания", guid_category, w1_Json.UnJSON(guids), begin_number, end_number), err), Истина);
	
КонецФункции
Функция get_products_count(guid_category = "", err = "")
	
	Возврат w1_Json.JSON(ApiLicota.ПолучитьКоличествоТоваровВВыборке(Новый Структура("guid_category", guid_category), err));
	
КонецФункции
Функция get_warehouses(guids = "", err)
	
	Возврат w1_Json.JSON(ApiLicota.ПолучитьСклады(Новый Структура("guids", w1_Json.UnJSON(guids)),err), Истина);
	
КонецФункции

Функция get_article_categories(guids, err)
	
	Возврат w1_Json.JSON(ApiLicota.ПолучитьКатегорииСтатьи(Новый Структура("guid_article_category", w1_Json.UnJSON(guids)), err), Истина);
	
КонецФункции
Функция get_articles(guids, err)
	Возврат w1_Json.JSON(ApiLicota.ПолучитьСтатьи(Новый Структура("guid_article", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции

Функция get_properties(guids, err = "")
	
	Возврат w1_Json.JSON(ApiLicota.ПолучитьСвойстваНоменклатуры(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
	
КонецФункции

Функция get_users(guids, err)
	Возврат w1_Json.JSON(ApiLicota.ПолучитьПользователей(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции
Функция create_user(user, err)
	
	ЗаписьЖурналаРегистрации("ApiLicota.create_user", УровеньЖурналаРегистрации.Информация,,,"user=" + user);
	Возврат ApiLicota.СоздатьПользователя(user, err);
	
КонецФункции
Функция update_user(user, err)
	
	ЗаписьЖурналаРегистрации("ApiLicota.update_user", УровеньЖурналаРегистрации.Информация,,,"user=" + user);
	Возврат ApiLicota.ОбновитьПользователя(user, Неопределено, err);
	
КонецФункции
Функция delete_user(user_guid, err)
	
	Возврат ApiLicota.УдалитьПользователя(user_guid, err);
	
КонецФункции

Функция create_order(order, err)
	
	ЗаписьЖурналаРегистрации("ApiLicota.create_order", УровеньЖурналаРегистрации.Информация,,,"order=" + order);
	Возврат ApiLicota.ОбновитьЗаказ(order, err);
	
КонецФункции
Функция update_order(order, err)
	
	ЗаписьЖурналаРегистрации("ApiLicota.update_order", УровеньЖурналаРегистрации.Информация,,,"order=" + order);
	Возврат ApiLicota.ОбновитьЗаказ(order,, err);
	
КонецФункции
Функция delete_order(order, err)
	
	Возврат ApiLicota.УдалитьЗаказ(order, err);
	
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
	Возврат w1_Json.JSON(ApiLicota.ПолучитьЗаказы(Новый Структура("orders", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции

Функция get_images(guids, err)
	Возврат стрЗаменить(w1_Json.JSON(ApiLicota.ПолучитьКартинку(Новый Структура("guid_image", w1_Json.UnJSON(guids)),err), Истина),"\r\n", "");
КонецФункции

Функция get_payment_variants(guids, err)
	Возврат w1_Json.JSON(ApiLicota.ПолучитьВидыОплат(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции

Функция get_delivery_address(guids, err)
	Возврат w1_Json.JSON(ApiLicota.ПолучитьАдресаДоставки(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции
Функция create_delivery_address(delivery_address, err)
	ЗаписьЖурналаРегистрации("ApiLicota.create_adress", УровеньЖурналаРегистрации.Информация,,,"adress=" + delivery_address);
	Возврат ApiLicota.СоздатьАдрес(delivery_address, err);
КонецФункции
Функция update_delivery_address(delivery_address, err)
	ЗаписьЖурналаРегистрации("ApiLicota.update_adres", УровеньЖурналаРегистрации.Информация,,,"adress=" + delivery_address);
	Возврат ApiLicota.ОбновитьАдрес(delivery_address, err);
КонецФункции
Функция delete_delivery_address(delivery_address_guid, err)
	Возврат ApiLicota.УдалитьАдрес(delivery_address_guid, err);
КонецФункции

Функция create_check_available(check_available, err)
	ЗаписьЖурналаРегистрации("ApiLicota.check_available", УровеньЖурналаРегистрации.Информация,,,"check_available=" + check_available);
	Возврат ApiLicota.СоздатьЗапросНаУточнениеОстатка(check_available, err);
КонецФункции

Функция get_documents(guids, changesFromDate, err)
	Возврат w1_Json.JSON(ApiLicota.ПолучитьДокументы(Новый Структура("guids, changesFromDate", w1_Json.UnJSON(guids), changesFromDate),err), Истина);
КонецФункции

Функция get_external_images(guids, changesFromDate, err)
	Возврат w1_Json.JSON(ApiLicota.ПолучитьКартинки(Новый Структура("guids, changesFromDate", w1_Json.UnJSON(guids), changesFromDate),err), Истина);
КонецФункции

Функция get_actions(guids, err)
	Возврат w1_Json.JSON(ApiLicota.ПолучитьАкции(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции

Функция get_type_prices(guids, err)
	Возврат w1_Json.JSON(ApiLicota.ПолучитьТипыЦен(Новый Структура("guids", w1_Json.UnJSON(guids)), err), Истина);
КонецФункции





