// Составляет списов возможноых хозоперация для объекта.
//
Функция ПолучитьСписокХозОпераций(Объект) Экспорт

	// rarus tenkam 13.09.2018 mantis 13477 +++
	ВариантСортировки = Scan_ПраваИНастройки.Scan_Право("ВариантСортировкиХозяйственныхОпераций");	
	Если Не ЗначениеЗаполнено(ВариантСортировки) Тогда
		ТекстУпорядочивания = " УПОРЯДОЧИТЬ ПО ХозОперации.Наименование";
	Иначе
		Если ВариантСортировки = Перечисления.Scan_ВариантыСортировкиХО.ПоНаименованию Тогда
			ТекстУпорядочивания = " УПОРЯДОЧИТЬ ПО ХозОперации.Наименование";	
		ИначеЕсли ВариантСортировки = Перечисления.Scan_ВариантыСортировкиХО.ПоКоду Тогда
			ТекстУпорядочивания = " УПОРЯДОЧИТЬ ПО ХозОперации.Код";
		ИначеЕсли ВариантСортировки = Перечисления.Scan_ВариантыСортировкиХО.ПоПорядковомуНомеру Тогда
			ТекстУпорядочивания = " УПОРЯДОЧИТЬ ПО ХозОперации.ПорядковыйНомер,	Наименование";	
		КонецЕсли;  		
	КонецЕсли;		
	// rarus tenkam 13.09.2018 mantis 13477 ---
	
	СписокХозОпераций = Новый СписокЗначений;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХозОперации.ИмяПредопределенныхДанных КАК Имя,
	|	ХозОперации.Наименование
	|ИЗ
	|	Справочник.Scan_ХозяйственныеОперации КАК ХозОперации
	|ГДЕ
	|	ХозОперации.ПометкаУдаления = ЛОЖЬ
	|	И ХозОперации.ЭтоГруппа = ЛОЖЬ
	|	И ХозОперации.Родитель = &Родитель";
	//|	//УсловиеКорректировки  //rarus sergei 03.10.2016 mantis 7162 +
	// rarus tenkam 13.09.2018 mantis 13477 +++
	//|
	//|УПОРЯДОЧИТЬ ПО
	//|	ХозОперации.Код";  	
	Запрос.Текст = Запрос.Текст + ТекстУпорядочивания;
	// rarus tenkam 13.09.2018 mantis 13477 ---
	
	Если ТипЗнч(Объект)= Тип("ДокументСсылка.Scan_ЗаявкаНаДействие") Тогда
		//rarus sergei 03.10.2016 mantis 7162 ++

		//rarus sergei 09.09.2016 mantis 7167 ++
		//Запрос.Текст = СтрЗаменить(Запрос.Текст, "//УсловиеКорректировки", "И ХозОперации.Ссылка <> &Корректировка");		//rarus tenkam 29.09.2016 mantis 7183 +
		//
		//Если Объект.ХозОперация = Справочники.Scan_ХозяйственныеОперации.ЗаявкаНаДействиеКорректировка Тогда
		//	СписокХозОпераций.Добавить(Справочники.Scan_ХозяйственныеОперации.ПолучитьИмяПредопределенного(Справочники.Scan_ХозяйственныеОперации.ЗаявкаНаДействиеКорректировка),Справочники.Scan_ХозяйственныеОперации.ЗаявкаНаДействиеКорректировка);
		//	СписокХозОпераций[0].Пометка = Истина;
		//	Возврат СписокХозОпераций;
		//Иначе
		//	Запрос.УстановитьПараметр("Родитель",ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументЗаявкаНаДействие"));
		//	Запрос.УстановитьПараметр("Корректировка",ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ЗаявкаНаДействиеКорректировка"));
		//КонецЕсли;
		//rarus sergei 03.10.2016 mantis 7162 --
		Запрос.УстановитьПараметр("Родитель",ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументЗаявкаНаДействие"));  //rarus sergei 03.10.2016 mantis 7162 +
		
	ИначеЕсли ТипЗнч(Объект)= Тип("ДокументСсылка.Scan_ЗаявкаПеревозчику") Тогда
		//rarus sergei 03.10.2016 mantis 7162 ++
		//Запрос.Текст = СтрЗаменить(Запрос.Текст, "//УсловиеКорректировки", "И ХозОперации.Ссылка <> &Корректировка");		//rarus tenkam 29.09.2016 mantis 7183 +
		//
		//Если Объект.ХозОперация = Справочники.Scan_ХозяйственныеОперации.ЗаявкаПеревозчикуКорректировка Тогда
		//	СписокХозОпераций.Добавить(Справочники.Scan_ХозяйственныеОперации.ПолучитьИмяПредопределенного(Справочники.Scan_ХозяйственныеОперации.ЗаявкаПеревозчикуКорректировка),Справочники.Scan_ХозяйственныеОперации.ЗаявкаПеревозчикуКорректировка);
		//	СписокХозОпераций[0].Пометка = Истина;
		//	Возврат СписокХозОпераций;
		//Иначе
		//	Запрос.УстановитьПараметр("Родитель",ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументЗаявкаПеревозчику"));
		//	Запрос.УстановитьПараметр("Корректировка",ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ЗаявкаПеревозчикуКорректировка"));
		//КонецЕсли;
		//rarus sergei 03.10.2016 mantis 7162 --
		//rarus sergei 09.09.2016 mantis 7167 --
	//rarus tenkam 29.09.2016 mantis 7183 ++
		Запрос.УстановитьПараметр("Родитель",ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументЗаявкаПеревозчику")); //rarus sergei 03.10.2016 mantis 7162 +
	ИначеЕсли ТипЗнч(Объект)= Тип("ДокументСсылка.Scan_ДвижениеИзделий") Тогда
		Запрос.УстановитьПараметр("Родитель",ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументДвижениеИзделий"));
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_ПеремещениеИзделий") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументПеремещениеИзделий"));
	//rarus tenkam 29.09.2016 mantis 7183 --
	//rarus tenkam 18.11.2017 mantis 9427 +++
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_ЧекЛистТехническогоСостоянияИзделия") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументЧекЛистТехническогоСостоянияИзделия"));
	//rarus tenkam 18.11.2017 mantis 9427 ---
	//rarus tenkam 30.11.2017 mantis 11952 +++
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_ЗаявкаНаКомплектующие") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументЗаявкаНаКомплектующие"));
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_ПоступлениеКомплектующих") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументПоступлениеКомплектующих"));
	//rarus tenkam 30.11.2017 mantis 11952 --- 
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_ИзменениеЦен") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументИзменениеЦен"));
	//rarus tenkam 13.12.2017 mantis 13736 --- 
	//rarus pechek 27.12.2019 mantis 15409 +++ 
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_УстановкаПланаПоОтгрузкам") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументУстановкаПланаПоОтгрузкам"));
	//rarus pechek 27.12.2019 mantis 15409 ---
	//rarus ozhnik 05.01.2020 14927 ++
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_УстановкаПланаПоOrderIntake") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументУстановкаПланаПоOrderIntake"));
	//rarus ozhnik 05.01.2020 14927 ++
	//rarus ozhnik 08.01.2020 14927 ++
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_ЗакреплениеМенеджеровЗаДилерами") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументЗакреплениеМенеджеровЗаДилерами"));
	//rarus ozhnik 05.01.2020 14927 ++
	//rarus agar 05.03.2020 15467 ++
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_Калькуляция") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументКалькуляция"));
	//rarus agar 05.03.2020 15467 --
	//rarus tenkam 05.08.2020 mantis 16181 +++
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_УстановкаПлановыхЦенПродукта") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументУстановкаПлановыхЦенПродуктов"));
	//rarus tenkam 05.08.2020 mantis 16181 ---
	//rarus vikhle 13.11.2020 mt 16638 +++
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_УстановкаЦенКомпонентов") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументУстановкаЦенКомпонентов"));
	//rarus vikhle 13.11.2020 mt 16638 ---
	//rarus agar 22.12.2020 16968 ++
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_ЗаказНаЗакупку") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументЗаказНаЗакупку"));
	//rarus agar 22.12.2020 16968 --
	// rarus tenkam 16.06.2021 mantis 17742 +++
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_ЗакреплениеМенеджеровДепартаментаПродажАвтобусовЗаДилерами") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ДокументЗакреплениеМенеджеровДепартаментаПродажАвтобусовЗаДилерами"));
	// rarus tenkam 16.06.2021 mantis 17742 ---	
	//rarus vikhle 16.11.2021 m 18340 +++ 
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Scan_ПрайсЛистАренда") Тогда
		Запрос.УстановитьПараметр("Родитель", ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ПрайсЛистАренда"));
	//rarus vikhle 16.11.2021 m 18340 ---
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокХозОпераций.Добавить(Выборка.Имя, Выборка.Наименование);
	КонецЦикла;
	
	Если СписокХозОпераций.Количество()> 0 Тогда
		СписокХозОпераций[0].Пометка = Истина;
	КонецЕсли;
	
	Возврат СписокХозОпераций;
	
КонецФункции // ПолучитьСписокХозОпераций()
