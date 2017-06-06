
Функция get_categories(guid_category = "", err = "")
	
	Возврат w1_Json.JSON(api_dil.ПолучитьКатегории(Новый Структура("guid_category", guid_category), err), Истина);
		
КонецФункции
Функция get_products(guid_category = "", sku = "", begin_number = 0, end_number = 0, err = "")
	
	Возврат w1_Json.JSON(api_dil.ПолучитьТовары(Новый Структура("guid_category, Артикул, НомерНачала, НомерОкончания", guid_category, sku, begin_number, end_number), err), Истина);
	
КонецФункции
Функция get_products_count(guid_category = "", err = "")
	
	Возврат w1_Json.JSON(api_dil.ПолучитьКоличествоТоваровВВыборке(Новый Структура("guid_category", guid_category), err));
	
КонецФункции
Функция get_manufacturers(guid_manufacturer = "", err)
	
	Возврат w1_Json.JSON(api_dil.ПолучитьПроизводителей(Новый Структура("guid_manafacture", guid_manufacturer),err), Истина);
	
КонецФункции

Функция get_image(guid_image, err)
	
	Возврат стрЗаменить(w1_Json.JSON(api_dil.ПолучитьКартинку(Новый Структура("guid_image", guid_image),err), Истина),"\r\n", "");
	
КонецФункции

Функция get_article_categories(guid_article_category, err)
	
	Возврат w1_Json.JSON(api_dil.ПолучитьКатегорииСтатьи(Новый Структура("guid_article_category", guid_article_category), err), Истина);
	
КонецФункции
Функция get_article(guid_article_category, guid_article, err)
	
	Возврат w1_Json.JSON(api_dil.ПолучитьСтатьи(Новый Структура("guid_article_category, guid_article", guid_article_category, guid_article), err), Истина);
	
КонецФункции

Функция get_properties(err = "")
	
	Возврат w1_Json.JSON(api_dil.ПолучитьСвойстваНоменклатуры(Новый Структура, err), Истина);
	
КонецФункции

Функция get_discount_card(discount_card_number, err = "")
	
	Возврат w1_Json.JSON(api_dil.ПолучитьИнформационнуюКартуПоНомеру(Новый Структура("discount_card_number", discount_card_number), err), Истина);
	
КонецФункции

Функция get_discount_percents(err = "")
	
	Возврат w1_Json.JSON(api_dil.ПолучитьПорогиСкидок(err), Истина);
	
КонецФункции

Функция get_type_prices(err)
	
	Возврат w1_Json.JSON(api_dil.ПолучитьТипыЦен(err), Истина);
	
КонецФункции

Функция create_user(user, user_guid, err)
	
	ЗаписьЖурналаРегистрации("api_dil.create_user", УровеньЖурналаРегистрации.Информация,,,"user=" + user);
	Возврат api_dil.СоздатьПользователя(user, user_guid, err);
	
КонецФункции
Функция update_user(user, err)
	
	ЗаписьЖурналаРегистрации("api_dil.update_user", УровеньЖурналаРегистрации.Информация,,,"user=" + user);
	Возврат api_dil.ОбновитьПользователя(user,, err);
	
КонецФункции
Функция delete_user(user_guid, err)
	
	Возврат api_dil.УдалитьПользователя(user_guid, err);
	
КонецФункции

Функция create_adress(adress, adress_guid, err)
	
	ЗаписьЖурналаРегистрации("api_dil.create_adress", УровеньЖурналаРегистрации.Информация,,,"adress=" + adress);
	Возврат api_dil.СоздатьАдрес(adress, adress_guid, err);
	
КонецФункции
Функция update_adres(adress, err)
	
	ЗаписьЖурналаРегистрации("api_dil.update_adres", УровеньЖурналаРегистрации.Информация,,,"adress=" + adress);
	Возврат api_dil.ОбновитьАдрес(adress,, err);
	
КонецФункции
Функция delete_adress(adress_guid, err)
	
	Возврат api_dil.УдалитьАдрес(adress_guid, err);
	
КонецФункции

Функция create_order(order, order_guid, err)
	
	ЗаписьЖурналаРегистрации("api_dil.create_order", УровеньЖурналаРегистрации.Информация,,,"order=" + order);
	Возврат api_dil.СоздатьЗаказ(order, order_guid, err);
	
КонецФункции
Функция update_order(order, err)
	
	ЗаписьЖурналаРегистрации("api_dil.update_order", УровеньЖурналаРегистрации.Информация,,,"order=" + order);
	Возврат api_dil.ОбновитьЗаказ(order,, err);
	
КонецФункции
Функция delete_order(order_guid, err)
	
	Возврат api_dil.УдалитьЗаказ(order_guid, err);
	
КонецФункции
