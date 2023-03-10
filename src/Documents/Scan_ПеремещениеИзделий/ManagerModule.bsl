//rarus tenkam 24.02.2017 mantis 8492 +++
Функция СформироватьЗаписатьПеремещение(МестоДоставки, ДатаДоставки, МассивПродуктов) Экспорт
	
	НовоеПеремещение = Документы.Scan_ПеремещениеИзделий.СоздатьДокумент();
	НовоеПеремещение.ХозОперация = Справочники.Scan_ХозяйственныеОперации.ПеремещениеИзделий;
	НовоеПеремещение.МестоДоставки = МестоДоставки;
	
	// rarus tenkam 15.08.2019 mantis 14427  +++
	//Для Каждого ТекПродукт Из МассивПродуктов Цикл
	//	НоваяСтрока = НовоеПеремещение.ИзделияДляПеремещения.Добавить();
	//	НоваяСтрока.Изделие = ТекПродукт.Изделие;
	//КонецЦикла;
	//	
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	Scan_Продукты.Ссылка КАК Продукт,
	//	|	Scan_Продукты.Изделие,
	//	|	Scan_Продукты.ЗаказНаЗавод,
	//	|	ЕСТЬNULL(Scan_Продукты.Изделие.МестоПроизводства, ЗНАЧЕНИЕ(Справочник.Scan_МестаХранения.ПустаяСсылка)) КАК МестоПроизводства,
	//	|	ЕСТЬNULL(Scan_Продукты.ЗаказНаЗавод.CDDПоставщик, ДАТАВРЕМЯ(1, 1, 1)) КАК CDDПоставщик,
	//	|	ЕСТЬNULL(Scan_Продукты.ЗаказНаЗавод.ПродуктДатаГотовности, ДАТАВРЕМЯ(1, 1, 1)) КАК ПродуктДатаГотовности
	//	|ИЗ
	//	|	Справочник.Scan_Продукты КАК Scan_Продукты
	//	|ГДЕ
	//	|	Scan_Продукты.Ссылка В (&МассивПродуктов)";
	//
	//Запрос.УстановитьПараметр("МассивПродуктов", МассивПродуктов);
	//
	//ТабРезультат = Запрос.Выполнить().Выгрузить();
	//Для Каждого ТекСтрока Из ТабРезультат Цикл
	
	Для Каждого ТекИзделие Из МассивПродуктов Цикл
		НоваяСтрока = НовоеПеремещение.ИзделияДляПеремещения.Добавить();
		НоваяСтрока.Изделие = ТекИзделие;
	КонецЦикла;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_Изделия.Ссылка КАК Изделие,
		|	Scan_Изделия.ЗаказНаЗавод,
		|	ЕСТЬNULL(Scan_Изделия.МестоПроизводства, ЗНАЧЕНИЕ(Справочник.Scan_МестаХранения.ПустаяСсылка)) КАК МестоПроизводства
		//rarus BProg_Gladkov 20.11.2019 0014452 ++ Ключевые даты перенесены в регистр.
		//|	ЕСТЬNULL(Scan_Изделия.ЗаказНаЗавод.CDDПоставщик, ДАТАВРЕМЯ(1, 1, 1)) КАК CDDПоставщик,
		//|	ЕСТЬNULL(Scan_Изделия.ЗаказНаЗавод.ПродуктДатаГотовности, ДАТАВРЕМЯ(1, 1, 1)) КАК ПродуктДатаГотовности
		//rarus BProg_Gladkov 20.11.2019 0014452 -- 
		|ИЗ
		|	Справочник.Scan_Изделия КАК Scan_Изделия
		|ГДЕ
		|	Scan_Изделия.Ссылка В (&МассивПродуктов)";
	
	Запрос.УстановитьПараметр("МассивПродуктов", МассивПродуктов);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ТекСтрока = ВыборкаДетальныеЗаписи;
	// rarus tenkam 15.08.2019 mantis 14427 ---	
		//rarus tenkam 21.03.2017 mantis 9061 +++
		Если ТекСтрока.МестоПроизводства = Справочники.Scan_МестаХранения.ПустаяСсылка() Тогда
			Продолжить;
		КонецЕсли;
		//rarus tenkam 21.03.2017 mantis 9061 ---
		
		Если НовоеПеремещение.МестоОтгрузки <> ТекСтрока.МестоПроизводства Тогда
			НовоеПеремещение.МестоОтгрузки = ТекСтрока.МестоПроизводства;
		КонецЕсли;
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Изделие", ТекСтрока.Изделие);
		НайденныеСтроки = НовоеПеремещение.ИзделияДляПеремещения.НайтиСтроки(ПараметрыОтбора);
		
		Если НайденныеСтроки.Количество() = 0 Тогда
			НоваяСтрока = НовоеПеремещение.ИзделияДляПеремещения.Добавить();
			НоваяСтрока.Изделие = ТекСтрока.Изделие;
		Иначе
			НоваяСтрока = НайденныеСтроки[0];
		КонецЕсли;
		
		НоваяСтрока.ДатаПолучения = РегистрыСведений.Scan_КлючевыеДатыПроцессов.КлючеваяДата(ТекСтрока.ЗаказНаЗавод, "FinishDate") + 1; //rarus BProg_Gladkov 20.11.2019 0014452 +- ключевые даты перенесены в регистр.
		НоваяСтрока.ДатаДоставки = ДатаДоставки; 
		
	КонецЦикла;
	НовоеПеремещение.Комментарий = "Документ создан автоматически.";
	Попытка
		НовоеПеремещение.Записать(РежимЗаписиДокумента.Запись);	
		Возврат НовоеПеремещение.Ссылка;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции
//rarus tenkam 24.02.2017 mantis 8492 ---

//rarus tenkam 23.03.2017 mantis 7179 +++
Функция УстановитьCDDфакт(ПеремещениеОбъект) Экспорт
	// rarus tenkam 13.06.2018 mantis 13160 +++
	ЭтоСкладПроизводителя = (ПеремещениеОбъект.МестоОтгрузки.ТипСклада = Перечисления.Scan_ТипыСклада.Производство И 
		ПеремещениеОбъект.МестоОтгрузки.СкладПроизводителя);
	ЭтоЗарубежныйКузовостроитель = (ПеремещениеОбъект.МестоОтгрузки.ТипСклада = Перечисления.Scan_ТипыСклада.АдресДоставки И 
		ПеремещениеОбъект.МестоОтгрузки.ЗарубежныйКузовостроитель);
		
	//Если ПеремещениеОбъект.МестоОтгрузки.ТипСклада = Перечисления.Scan_ТипыСклада.Производство И 
	//	ПеремещениеОбъект.МестоОтгрузки.СкладПроизводителя Тогда
	Если ЭтоСкладПроизводителя ИЛИ ЭтоЗарубежныйКузовостроитель Тогда

	// rarus tenkam 13.06.2018 mantis 13160 --- 	
		Для Каждого ТекСтрока Из ПеремещениеОбъект.ИзделияДляПеремещения Цикл
			// rarus tenkam 05.08.2019 mantis 14427 +++
			//ТекЗаказ = РегистрыСведений.Scan_ВзаимосвязьИзделийПродуктовИЗаказов.ПолучитьЗаказПоИзделию(ТекСтрока.Изделие);
			ТекЗаказ = РегистрыСведений.Scan_ВзаимосвязьИзделийИЗаказов.ПолучитьЗаказПоИзделию(ТекСтрока.Изделие);
			// rarus tenkam 05.08.2019 mantis 14427 ---
			// rarus tenkam 13.06.2018 mantis 13160 +++
			//Если ЗначениеЗаполнено(ТекЗаказ) И НЕ ЗначениеЗаполнено(ТекЗаказ.ПортСПБ) Тогда
			Если ЗначениеЗаполнено(ТекЗаказ) Тогда
				//rarus BProg_Dekin 13.11.2019 0014452 ++ Реквизит "ПортСПБ" удален
				//ПортСПБ = ТекЗаказ.ПортСПБ;
				ПортСПБ = РегистрыСведений.Scan_КлючевыеДатыПроцессов.КлючеваяДата(ТекЗаказ, "ПортСПБ"); 
				Если НЕ ЗначениеЗаполнено(ПортСПБ) ИЛИ (ЗначениеЗаполнено(ПортСПБ) И ЭтоЗарубежныйКузовостроитель) Тогда
					//// rarus tenkam 13.06.2018 mantis 13160 ---
					//ТекЗаказОбъект = ТекЗаказ.ПолучитьОбъект();
					// ТекЗаказОбъект.ПортСПБ = ТекСтрока.ДатаДоставки;
					//Попытка
					//	ТекЗаказОбъект.Записать();
					//	
					//	// rarus tenkam 31.05.2019 mantis 14224 +++
					//	// Запишем ключевую дату
					//	РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЗаписьЗначенияРегистраСведения(ТекЗаказОбъект.Ссылка, 
					//							Перечисления.Scan_ОбъектыКлючевыхДат.ЗаказНаЗавод, ТекСтрока.ДатаДоставки,
					//							Перечисления.Scan_КлючевыеДаты.ПортСПБ, ТекущаяДата());			
					//	// rarus tenkam 31.05.2019 mantis 14224 ---
					//Исключение
					//	Сообщить("Не удалось установить дату CDD факт. в заказе " + ТекЗаказ + " по причине: " + ИнформацияОбОшибке());
					//КонецПопытки;
					
					Отказ = Ложь;
					РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЗаписатьКлючевуюДатуОбъекта(ТекЗаказ, "ПортСПБ", ТекСтрока.ДатаДоставки,, Отказ);
					Если Отказ тогда
						ШаблонОшибки = Нстр("ru = 'Не удалось установить дату CDD факт в заказе %1'; en = 'Failed to set аctual CDD date in order %1'");
						Сообщить(СтрШаблон(ШаблонОшибки, ТекЗаказ));
					КонецЕсли;
				КонецЕсли;		// rarus tenkam 13.06.2018 mantis 13160 +
				//rarus BProg_Dekin 13.11.2019 0014452 --
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецФункции

Функция ОчиститьCDDфакт(ПеремещениеОбъект) Экспорт
	Если ПеремещениеОбъект.МестоОтгрузки.ТипСклада = Перечисления.Scan_ТипыСклада.Производство И 
		ПеремещениеОбъект.МестоОтгрузки.СкладПроизводителя Тогда
		Для Каждого ТекСтрока Из ПеремещениеОбъект.ИзделияДляПеремещения Цикл
			// rarus tenkam 05.08.2019 mantis 14427 +++
			//ТекЗаказ = РегистрыСведений.Scan_ВзаимосвязьИзделийПродуктовИЗаказов.ПолучитьЗаказПоИзделию(ТекСтрока.Изделие);
			ТекЗаказ = РегистрыСведений.Scan_ВзаимосвязьИзделийИЗаказов.ПолучитьЗаказПоИзделию(ТекСтрока.Изделие);
			// rarus tenkam 05.08.2019 mantis 14427 ---
			
			
			//rarus BProg_Dekin 13.11.2019 0014452 ++ Реквизит "ПортСПБ" удален.
			//ПортСПБ = ТекЗаказ.ПортСПБ;
			ПортСПБ = РегистрыСведений.Scan_КлючевыеДатыПроцессов.КлючеваяДата(ТекЗаказ, "ПортСПБ"); 
			Если ЗначениеЗаполнено(ТекЗаказ) И ЗначениеЗаполнено(ПортСПБ) Тогда
			//	ТекЗаказОбъект = ТекЗаказ.ПолучитьОбъект();
			//	ТекЗаказОбъект.ПортСПБ = Дата('00010101');
			//	Попытка
			//		ТекЗаказОбъект.Записать();
			//		
			//		// rarus tenkam 31.05.2019 mantis 14224 +++
			//		// Запишем ключевую дату
			//		РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЗаписьЗначенияРегистраСведения(ТекЗаказОбъект.Ссылка, 
			//		Перечисления.Scan_ОбъектыКлючевыхДат.ЗаказНаЗавод, Дата('00010101'),
			//		Перечисления.Scan_КлючевыеДаты.ПортСПБ, ТекущаяДата());			
			//		// rarus tenkam 31.05.2019 mantis 14224 ---
			//	Исключение
			//		Сообщить("Не удалось установить очистить CDD факт. в заказе " + ТекЗаказ + " по причине: " + ИнформацияОбОшибке());
			//	КонецПопытки;
			
				Отказ = Ложь;
				РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЗаписатьКлючевуюДатуОбъекта(ТекЗаказ, "ПортСПБ", ТекСтрока.ДатаДоставки,, Отказ);
				Если Отказ тогда
					ШаблонОшибки = Нстр("ru = 'Не удалось очистить дату CDD факт в заказе %1.'; en = 'Failed to clean аctual CDD date in order %1.'");
					Сообщить(СтрШаблон(ШаблонОшибки, ТекЗаказ));
				КонецЕсли;
			КонецЕсли;
			//rarus BProg_Dekin 13.11.2019 0014452 --
		КонецЦикла;
	КонецЕсли;
КонецФункции

//rarus tenkam 23.03.2017 mantis 7179 ---