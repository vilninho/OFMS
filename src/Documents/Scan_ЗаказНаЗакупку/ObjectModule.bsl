
Перем УдаленныеСтроки;

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ХозОперация = ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЛокальный" );
	
	Если  ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("ХозОперация")
		Тогда
		ХозОперация = ДанныеЗаполнения.ХозОперация;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Scan_ЗапросНаНадстройки") Тогда
		ПоставщикКомпания = ДанныеЗаполнения.Поставщик;
		ДокументОснование = ДанныеЗаполнения;
		
		ВидВзаимодействияПоставщик = Scan_ПраваИНастройки.Scan_Право("ВидВзаимодействияПоставщик");
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Компания",                   ПоставщикКомпания);
		Запрос.УстановитьПараметр("ВидВзаимодействияПоставщик", ВидВзаимодействияПоставщик);

		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Scan_ВзаимосвязьКомпанийСКонтрагентами.Контрагент КАК Контрагент,
		|	Scan_ВзаимосвязьКомпанийСКонтрагентами.Контрагент.Резидент КАК Резидент
		|ИЗ
		|	РегистрСведений.Scan_ВзаимосвязьКомпанийСКонтрагентами КАК Scan_ВзаимосвязьКомпанийСКонтрагентами
		|ГДЕ
		|	Scan_ВзаимосвязьКомпанийСКонтрагентами.Компания = &Компания
		|	И Scan_ВзаимосвязьКомпанийСКонтрагентами.ВидВзаимодействия = &ВидВзаимодействияПоставщик";
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Количество() = 1 Тогда
			Выборка.Следующий();
			Поставщик = Выборка.Контрагент;
			Если Не Выборка.Резидент Тогда
				ХозОперация = ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЕвро");
			КонецЕсли;
		КонецЕсли;
		
		// rarus agar 11.03.2022 18869 ++
		Если ХозОперация = ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЛокальный") Тогда
			СтавкаНДС = ПредопределенноеЗначение("Справочник.Scan_СтавкиНДС.ОсновнаяСтавкаНДС");
		ИначеЕсли ХозОперация = ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЕвро") Тогда
			СтавкаНДС = ПредопределенноеЗначение("Справочник.Scan_СтавкиНДС.БезНДС");
		КонецЕсли;
		// rarus agar 11.03.2022 18869 --
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СоглашениеОПоставке", ДанныеЗаполнения.СоглашениеОПоставке);
		Запрос.Текст = "ВЫБРАТЬ
		|	Scan_СоглашенияОПоставке.СтавкаНДС КАК СтавкаНДС
		|ИЗ
		|	Справочник.Scan_СоглашенияОПоставке КАК Scan_СоглашенияОПоставке
		|ГДЕ
		|	Scan_СоглашенияОПоставке.Ссылка = &СоглашениеОПоставке
		|	И Scan_СоглашенияОПоставке.СтавкаНДС <> ЗНАЧЕНИЕ(Справочник.Scan_СтавкиНДС.ПустаяСсылка)";
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Количество() = 1 Тогда
			Выборка.Следующий();
			СтавкаНДС = Выборка.СтавкаНДС;
		КонецЕсли;
		
		Для Каждого СтрокаЗапроса Из ДанныеЗаполнения.ТоварыУслугиРаботы Цикл
			НоваяСтрока = ПродуктыКЗаказу.Добавить();
			НоваяСтрока.ПродуктЗапросаНаНадстройку       = СтрокаЗапроса.ТоварУслуга;
			НоваяСтрока.МаркаПродуктаЗапросаНаНадстройки = СтрокаЗапроса.МаркаПродукта; //rarus agar 20.02.2021 17230 +-
			НоваяСтрока.Количество                       = СтрокаЗапроса.Количество;
			НоваяСтрока.Цена                             = СтрокаЗапроса.Цена;
			НоваяСтрока.Сумма                            = СтрокаЗапроса.Количество * СтрокаЗапроса.Цена;
			НоваяСтрока.СтавкаНДС                        = СтавкаНДС;
			НоваяСтрока.Валюта                           = СтрокаЗапроса.Валюта;
			НоваяСтрока.НомераЗаказов                    = СтрокаЗапроса.НомераЗаказов;
			НоваяСтрока.ИдентификаторСтрокиЗапроса       = СтрокаЗапроса.ИдентификаторСтроки; // rarus agar 01.04.2021 17545 +-
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	IDSystem                     = Неопределено;
	ДОНомерЗаказаНаЗакупку       = Неопределено;
	ДОДатаЗаказаНаЗакупку        = Неопределено;
	ДОСтатусЗаказаНаЗакупку      = Неопределено;
	ДОПроцессСогласованияЗапущен = Неопределено;
	BBНомерЗаказаНаЗакупку       = Неопределено;
	BBДатаОтправки               = Неопределено;
	BBДатаПолучения              = Неопределено;
	
КонецПроцедуры

// rarus agar 19.03.2021 17404 ++
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ПродуктыСНомерамиЗаказов = ПродуктыКЗаказу.Выгрузить(,"Продукт,НомераЗаказов");
	ПродуктыСНомерамиЗаказов.Свернуть("Продукт,НомераЗаказов");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПродуктыСНомерамиЗаказов", ПродуктыСНомерамиЗаказов);
	Запрос.УстановитьПараметр("ЗаказНаЗакупкуСсылка",     Ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	|	Scan_ЗаказНаЗакупкуПродуктыКЗаказу.Продукт КАК Продукт,
	|	Scan_ЗаказНаЗакупкуПродуктыКЗаказу.ДатаПоставки КАК ДатаПоставки,
	|	Scan_ЗаказНаЗакупкуПродуктыКЗаказу.НомераЗаказов КАК НомераЗаказов
	|ИЗ
	|	Документ.Scan_ЗаказНаЗакупку.ПродуктыКЗаказу КАК Scan_ЗаказНаЗакупкуПродуктыКЗаказу
	|ГДЕ
	|	Scan_ЗаказНаЗакупкуПродуктыКЗаказу.Ссылка = &ЗаказНаЗакупкуСсылка
	|	И НЕ (Scan_ЗаказНаЗакупкуПродуктыКЗаказу.Продукт, Scan_ЗаказНаЗакупкуПродуктыКЗаказу.НомераЗаказов) В (&ПродуктыСНомерамиЗаказов)";
	РезультатЗапроса = Запрос.Выполнить();
	
	УдаленныеСтроки = РезультатЗапроса.Выгрузить();
	
КонецПроцедуры
// rarus agar 19.03.2021 17404 --

Процедура ПриЗаписи(Отказ)
	
	ЗначенияКлючевыхДат   = Новый Соответствие; // rarus agar 19.03.2021 17404 +-
	НомераЗаказовТабЧасти = Новый Массив; // rarus agar 20.04.2021 17673 +-
	
	ЗаказыНаЗаводДляПисьмаОПорядковомНомере = Новый Массив; // Rarus tenkam 23.03.2022 mantis 18574 +
	
	Для Каждого СтрокаПродукта Из ПродуктыКЗаказу Цикл
		МассивНомеровЗаказов = СтрРазделить(СтрокаПродукта.НомераЗаказов, ",", Ложь);
		// rarus agar 20.04.2021 17673 ++
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НомераЗаказовТабЧасти, МассивНомеровЗаказов, Истина);
		// rarus agar 20.04.2021 17673 --
		Для Каждого НомерЗаказа Из МассивНомеровЗаказов Цикл
			ЗаказНаЗаводСсылка = Справочники.Scan_ЗаказыНаЗавод.НайтиПоНаименованию(НомерЗаказа, Истина);
			Если ЗаказНаЗаводСсылка.Пустая() Тогда
				Продолжить;
			КонецЕсли;
			
			// rarus agar 19.03.2021 17404 ++
			Если ПометкаУдаления Тогда
				ЗначениеКлючевыхДат = Дата(1,1,1);
			Иначе
				ЗначениеКлючевыхДат = СтрокаПродукта.ДатаПоставки;
			КонецЕсли;
			
			Если ЗначенияКлючевыхДат.Получить(ЗаказНаЗаводСсылка) = Неопределено Тогда
				ЗначенияКлючевыхДат.Вставить(ЗаказНаЗаводСсылка, ЗначениеКлючевыхДат);
			КонецЕсли;
			// rarus agar 19.03.2021 17404 --
			
			ЗаказНаЗаводОбъект = ЗаказНаЗаводСсылка.ПолучитьОбъект();
			
			// Rarus tenkam 23.02.2022 mantis 18574 +++
			ВЗаказеЕстьКузовостроители = Ложь;
			Для Каждого ТекСтрока Из ЗаказНаЗаводОбъект.ЗаказыНаЗакупку Цикл
				Если ТипЗнч(ТекСтрока.Кузовщик) = Тип("СправочникСсылка.Scan_Контрагенты") Тогда
					ЭтоКузовостроитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекСтрока.Кузовщик, "Кузовостроитель");
					Если ЭтоКузовостроитель Тогда
						ВЗаказеЕстьКузовостроители = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			// Rarus tenkam 23.02.2022 mantis 18574 ---
			
			НайденныеСтроки = ЗаказНаЗаводОбъект.ЗаказыНаЗакупку.НайтиСтроки(Новый Структура("ЗаказНаЗакупку", Ссылка));
			// rarus agar 25.06.2021 17892 ++
			Если ПометкаУдаления Тогда
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					ЗаказНаЗаводОбъект.ЗаказыНаЗакупку.Удалить(НайденнаяСтрока);
				КонецЦикла;
			Иначе
			// rarus agar 25.06.2021 17892 --
				Если НайденныеСтроки.Количество() = 0 Тогда
					НоваяСтрока = ЗаказНаЗаводОбъект.ЗаказыНаЗакупку.Добавить();
					НоваяСтрока.Кузовщик       = Поставщик;
					НоваяСтрока.ЗаказНаЗакупку = Ссылка;
					// Rarus tenkam 23.02.2022 mantis 18574 +++
					Если Поставщик.Кузовостроитель Тогда
						Если ВЗаказеЕстьКузовостроители Тогда
							ЗаказыНаЗаводДляПисьмаОПорядковомНомере.Добавить(ЗаказНаЗаводСсылка);
						Иначе
							НоваяСтрока.ПорядковыйНомер = 1;
						КонецЕсли;
					КонецЕсли;					
					// Rarus tenkam 23.02.2022 mantis 18574 ---
				Иначе
					Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
						Если НайденнаяСтрока.Кузовщик <> Поставщик Тогда
							НайденнаяСтрока.Кузовщик = Поставщик;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			// rarus agar 25.06.2021 17892 ++
			КонецЕсли;
			// rarus agar 25.06.2021 17892 --
			
			ТаблицаЗаказыНаЗакупку = ЗаказНаЗаводОбъект.ЗаказыНаЗакупку.Выгрузить();
			
			ТаблицаКузовщиков = ТаблицаЗаказыНаЗакупку.Скопировать(,"Кузовщик");
			ТаблицаКузовщиков.Свернуть("Кузовщик");
			
			КузовщикиПредставление = СтрСоединить(ТаблицаКузовщиков.ВыгрузитьКолонку("Кузовщик"), ",");
			Если ЗаказНаЗаводОбъект.КузовщикиПредставление <> КузовщикиПредставление Тогда
				ЗаказНаЗаводОбъект.КузовщикиПредставление = КузовщикиПредставление;
			КонецЕсли;
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ЗаказыНаЗакупку", ТаблицаЗаказыНаЗакупку.ВыгрузитьКолонку("ЗаказНаЗакупку"));
			Запрос.УстановитьПараметр("ТаблицаЗаказыНаЗакупку",ТаблицаЗаказыНаЗакупку);//rarus vikhle 11.02.2021 mt 17197
			Запрос.Текст = "ВЫБРАТЬ
			//rarus vikhle 12.02.2021 mt 17197 +++
			|	ТаблицаЗаказыНаЗакупку.ЗаказНаЗакупку КАК ЗаказНаЗакупку
			|ПОМЕСТИТЬ СтроковыеЗаказы
			|ИЗ
			|	&ТаблицаЗаказыНаЗакупку КАК ТаблицаЗаказыНаЗакупку
			|ГДЕ
			|	ТИПЗНАЧЕНИЯ(ТаблицаЗаказыНаЗакупку.ЗаказНаЗакупку) = ТИП(СТРОКА)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			//rarus vikhle 12.02.2021 mt 17197 ---
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ВЫБОР
			|		КОГДА Scan_ЗаказНаЗакупку.ХозОперация = ЗНАЧЕНИЕ(Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЛокальный)
			|			ТОГДА Scan_ЗаказНаЗакупку.ДОНомерЗаказаНаЗакупку
			|		КОГДА Scan_ЗаказНаЗакупку.ХозОперация = ЗНАЧЕНИЕ(Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЕвро)
			|			ТОГДА Scan_ЗаказНаЗакупку.BBНомерЗаказаНаЗакупку
			|		ИНАЧЕ """"
			|	КОНЕЦ КАК Номер
			|ИЗ
			|	Документ.Scan_ЗаказНаЗакупку КАК Scan_ЗаказНаЗакупку
			|ГДЕ
			|	Scan_ЗаказНаЗакупку.Ссылка В(&ЗаказыНаЗакупку)
			|	И ВЫБОР
			|			КОГДА Scan_ЗаказНаЗакупку.ХозОперация = ЗНАЧЕНИЕ(Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЛокальный)
			|				ТОГДА Scan_ЗаказНаЗакупку.ДОНомерЗаказаНаЗакупку
			|			КОГДА Scan_ЗаказНаЗакупку.ХозОперация = ЗНАЧЕНИЕ(Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЕвро)
			|				ТОГДА Scan_ЗаказНаЗакупку.BBНомерЗаказаНаЗакупку
			|			ИНАЧЕ """"
			|		КОНЕЦ <> """"
			//rarus vikhle 11.02.2021 mt 17197 +++
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	СтроковыеЗаказы.ЗаказНаЗакупку
			|ИЗ
			|	СтроковыеЗаказы КАК СтроковыеЗаказы
			//rarus vikhle 11.02.2021 mt 17197 ---
			|УПОРЯДОЧИТЬ ПО
			|	Номер";
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ЗаказыНаЗакупкуПредставление = СтрСоединить(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Номер"), ",");
			Если ЗаказНаЗаводОбъект.ЗаказыНаЗакупкуПредставление <> ЗаказыНаЗакупкуПредставление Тогда
				ЗаказНаЗаводОбъект.ЗаказыНаЗакупкуПредставление = ЗаказыНаЗакупкуПредставление;
			КонецЕсли;
			
			//rarus kabany 16.04.2021 17469 +++ // строковое преобразования для реквизита ЗаказыНаЗакупкуOFMSПредставление 
			МассивНомеровOFMS = ПолучитьНомераOFMS(ТаблицаЗаказыНаЗакупку);
			Если МассивНомеровOFMS <> Неопределено Тогда
				МассивНомеровOFMSБезНулей = Новый Массив;
				Для каждого номOFMS из МассивНомеровOFMS ЦИКЛ  
					МассивНомеровOFMSБезНулей.Добавить(ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(номOFMS,истина,истина));
				КонецЦикла;
				ЗаказыНаЗакупкуOFMSПредставление = СтрСоединить(МассивНомеровOFMSБезНулей, ","); 
				Если ЗаказНаЗаводОбъект.ЗаказыНаЗакупкуOFMSПредставление <> ЗаказыНаЗакупкуOFMSПредставление Тогда
					ЗаказНаЗаводОбъект.ЗаказыНаЗакупкуOFMSПредставление = ЗаказыНаЗакупкуOFMSПредставление;
				КонецЕсли;
			// rarus agar 25.06.2021 17892 ++
			ИначеЕсли ЗначениеЗаполнено(ЗаказНаЗаводОбъект.ЗаказыНаЗакупкуOFMSПредставление) Тогда
				ЗаказНаЗаводОбъект.ЗаказыНаЗакупкуOFMSПредставление = Неопределено;
			// rarus agar 25.06.2021 17892 --
			КонецЕсли;
			//rarus kabany 16.04.2021 17469 ---
			
			Если ЗаказНаЗаводОбъект.Модифицированность() Тогда
				Попытка
					ЗаказНаЗаводОбъект.Записать();
				Исключение
					Сообщить(СтрШаблон(НСтр("ru = 'Не удалось обновить взаимосвязь заказа на завод ""%1"" с заказом на закупку ""%2"".'; 
					                        |en = 'Failed to link оrder to the plant ""%1"" with purchase order ""%2"".'"), 
					                        СтрокаПродукта.ЗаказНаЗавод, Ссылка));
				КонецПопытки;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// rarus agar 19.03.2021 17404 ++
	Для Каждого УдаленнаяСтрока Из УдаленныеСтроки Цикл
		МассивНомеровЗаказов = СтрРазделить(УдаленнаяСтрока.НомераЗаказов, ",", Ложь);
		Для Каждого НомерЗаказа Из МассивНомеровЗаказов Цикл
			ЗаказНаЗаводСсылка = Справочники.Scan_ЗаказыНаЗавод.НайтиПоНаименованию(НомерЗаказа, Истина);
			Если ЗаказНаЗаводСсылка.Пустая() Тогда
				Продолжить;
			КонецЕсли;
			
			// В ситуации, когда в строке удалили номер заказа,
			// оставшиеся номера заказов строки попадают в удаленные строки
			Если ЗначенияКлючевыхДат.Получить(ЗаказНаЗаводСсылка) = Неопределено Тогда
				ЗначенияКлючевыхДат.Вставить(ЗаказНаЗаводСсылка, Дата(1,1,1));
			КонецЕсли;
			
			// rarus agar 20.04.2021 17673 ++
			Если НомераЗаказовТабЧасти.Найти(НомерЗаказа) = Неопределено Тогда
				ЗаказНаЗаводОбъект = ЗаказНаЗаводСсылка.ПолучитьОбъект();
				
				НайденныеСтроки = ЗаказНаЗаводОбъект.ЗаказыНаЗакупку.НайтиСтроки(Новый Структура("ЗаказНаЗакупку", Ссылка));
				Если НайденныеСтроки.Количество() <> 0 Тогда
					Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
						ЗаказНаЗаводОбъект.ЗаказыНаЗакупку.Удалить(НайденнаяСтрока);
					КонецЦикла;
					
					ТаблицаЗаказыНаЗакупку = ЗаказНаЗаводОбъект.ЗаказыНаЗакупку.Выгрузить();
					
					ТаблицаКузовщиков = ТаблицаЗаказыНаЗакупку.Скопировать(,"Кузовщик");
					ТаблицаКузовщиков.Свернуть("Кузовщик");
					
					КузовщикиПредставление = СтрСоединить(ТаблицаКузовщиков.ВыгрузитьКолонку("Кузовщик"), ",");
					Если ЗаказНаЗаводОбъект.КузовщикиПредставление <> КузовщикиПредставление Тогда
						ЗаказНаЗаводОбъект.КузовщикиПредставление = КузовщикиПредставление;
					КонецЕсли;
					
					Запрос = Новый Запрос;
					Запрос.УстановитьПараметр("ЗаказыНаЗакупку", ТаблицаЗаказыНаЗакупку.ВыгрузитьКолонку("ЗаказНаЗакупку"));
					Запрос.УстановитьПараметр("ТаблицаЗаказыНаЗакупку",ТаблицаЗаказыНаЗакупку);//rarus vikhle 11.02.2021 mt 17197
					Запрос.Текст = "ВЫБРАТЬ
					//rarus vikhle 12.02.2021 mt 17197 +++
					|	ТаблицаЗаказыНаЗакупку.ЗаказНаЗакупку КАК ЗаказНаЗакупку
					|ПОМЕСТИТЬ СтроковыеЗаказы
					|ИЗ
					|	&ТаблицаЗаказыНаЗакупку КАК ТаблицаЗаказыНаЗакупку
					|ГДЕ
					|	ТИПЗНАЧЕНИЯ(ТаблицаЗаказыНаЗакупку.ЗаказНаЗакупку) = ТИП(СТРОКА)
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					//rarus vikhle 12.02.2021 mt 17197 ---
					|ВЫБРАТЬ РАЗЛИЧНЫЕ
					|	ВЫБОР
					|		КОГДА Scan_ЗаказНаЗакупку.ХозОперация = ЗНАЧЕНИЕ(Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЛокальный)
					|			ТОГДА Scan_ЗаказНаЗакупку.ДОНомерЗаказаНаЗакупку
					|		КОГДА Scan_ЗаказНаЗакупку.ХозОперация = ЗНАЧЕНИЕ(Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЕвро)
					|			ТОГДА Scan_ЗаказНаЗакупку.BBНомерЗаказаНаЗакупку
					|		ИНАЧЕ """"
					|	КОНЕЦ КАК Номер
					|ИЗ
					|	Документ.Scan_ЗаказНаЗакупку КАК Scan_ЗаказНаЗакупку
					|ГДЕ
					|	Scan_ЗаказНаЗакупку.Ссылка В(&ЗаказыНаЗакупку)
					|	И ВЫБОР
					|			КОГДА Scan_ЗаказНаЗакупку.ХозОперация = ЗНАЧЕНИЕ(Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЛокальный)
					|				ТОГДА Scan_ЗаказНаЗакупку.ДОНомерЗаказаНаЗакупку
					|			КОГДА Scan_ЗаказНаЗакупку.ХозОперация = ЗНАЧЕНИЕ(Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЕвро)
					|				ТОГДА Scan_ЗаказНаЗакупку.BBНомерЗаказаНаЗакупку
					|			ИНАЧЕ """"
					|		КОНЕЦ <> """"
					//rarus vikhle 11.02.2021 mt 17197 +++
					|ОБЪЕДИНИТЬ ВСЕ
					|
					|ВЫБРАТЬ
					|	СтроковыеЗаказы.ЗаказНаЗакупку
					|ИЗ
					|	СтроковыеЗаказы КАК СтроковыеЗаказы
					//rarus vikhle 11.02.2021 mt 17197 ---
					|УПОРЯДОЧИТЬ ПО
					|	Номер";
					
					РезультатЗапроса = Запрос.Выполнить();
					
					ЗаказыНаЗакупкуПредставление = СтрСоединить(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Номер"), ",");
					Если ЗаказНаЗаводОбъект.ЗаказыНаЗакупкуПредставление <> ЗаказыНаЗакупкуПредставление Тогда
						ЗаказНаЗаводОбъект.ЗаказыНаЗакупкуПредставление = ЗаказыНаЗакупкуПредставление;
					КонецЕсли;
					
					//rarus kabany 20.04.2021 17469 +++ // строковое преобразования для реквизита ЗаказыНаЗакупкуOFMSПредставление 
					МассивНомеровOFMS = ПолучитьНомераOFMS(ТаблицаЗаказыНаЗакупку);
					Если МассивНомеровOFMS <> Неопределено Тогда
						МассивНомеровOFMSБезНулей = Новый Массив;
						Для каждого номOFMS из МассивНомеровOFMS ЦИКЛ  
							МассивНомеровOFMSБезНулей.Добавить(ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(номOFMS,истина,истина));
						КонецЦикла;
						ЗаказыНаЗакупкуOFMSПредставление = СтрСоединить(МассивНомеровOFMSБезНулей, ","); 
						Если ЗаказНаЗаводОбъект.ЗаказыНаЗакупкуOFMSПредставление <> ЗаказыНаЗакупкуOFMSПредставление Тогда
							ЗаказНаЗаводОбъект.ЗаказыНаЗакупкуOFMSПредставление = ЗаказыНаЗакупкуOFMSПредставление;
						КонецЕсли;
					// rarus agar 25.06.2021 17892 ++
					ИначеЕсли ЗначениеЗаполнено(ЗаказНаЗаводОбъект.ЗаказыНаЗакупкуOFMSПредставление) Тогда
						ЗаказНаЗаводОбъект.ЗаказыНаЗакупкуOFMSПредставление = Неопределено;
					// rarus agar 25.06.2021 17892 --
					КонецЕсли;
					//rarus kabany 20.04.2021 17469 ---
					
					Если ЗаказНаЗаводОбъект.Модифицированность() Тогда
						Попытка
							ЗаказНаЗаводОбъект.Записать();
						Исключение
							Сообщить(СтрШаблон(НСтр("ru = 'Не удалось удалить взаимосвязь заказа на завод ""%1"" с заказом на закупку ""%2"".'; 
							|en = 'Failed to link оrder to the plant ""%1"" with purchase order ""%2"".'"), 
							НомерЗаказа, Ссылка));
						КонецПопытки;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			// rarus agar 20.04.2021 17673 --
		КонецЦикла;
	КонецЦикла;
	
	ЭтоЗаказНаЗакупкуЕвро = ХозОперация = ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ЗаказНаЗакупкуЕвро");
	
	ОбъектКлючевойДаты   = ПредопределенноеЗначение("Перечисление.Scan_ОбъектыКлючевыхДат.ЗаказНаЗавод");
	ВидКлючевойДатыPODOD = ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты.PODOD");
	ВидКлючевойДатыEDD   = ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты.EDD");
	
	Для Каждого КлючИЗначение Из ЗначенияКлючевыхДат Цикл
		ЗаказНаЗаводСсылка   = КлючИЗначение.Ключ;
		ЗначениеКлючевойДаты = КлючИЗначение.Значение;
		
		ТекущееЗначениеКлючевойДаты = РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЧтениеЗначенияРегистраСведения(ЗаказНаЗаводСсылка, ОбъектКлючевойДаты, ВидКлючевойДатыPODOD);
		Если ЗначениеКлючевойДаты <> ТекущееЗначениеКлючевойДаты Тогда
			РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЗаписатьКлючевуюДатуОбъекта(ЗаказНаЗаводСсылка, ВидКлючевойДатыPODOD, ЗначениеКлючевойДаты);
		КонецЕсли;
		
		Если ЭтоЗаказНаЗакупкуЕвро Тогда
			ТекущееЗначениеКлючевойДаты = РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЧтениеЗначенияРегистраСведения(ЗаказНаЗаводСсылка, ОбъектКлючевойДаты, ВидКлючевойДатыEDD);
			Если ЗначениеКлючевойДаты <> ТекущееЗначениеКлючевойДаты Тогда
				РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЗаписатьКлючевуюДатуОбъекта(ЗаказНаЗаводСсылка, ВидКлючевойДатыEDD, ЗначениеКлючевойДаты);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	// rarus agar 19.03.2021 17404 --
	
	// Rarus tenkam 23.03.2022 mantis 18574 +++
	Если ЗаказыНаЗаводДляПисьмаОПорядковомНомере.Количество() <> 0 Тогда
		Если Scan_ПраваИНастройки.Scan_Право("ИспользоватьМеханизмШаблоновДляОтправкиПисем") Тогда
			РезультатОтправкиПисьма = Scan_ОтправкаПисемПоЭлектроннойПочте.ОтправитьПисьмоПоШаблонуИзПрава("ШаблонПисьмаОНеобходимостиЗаполнитьПорядковыйНомерКузовостроителя", ЗаказыНаЗаводДляПисьмаОПорядковомНомере); 
		КонецЕсли;	
	КонецЕсли;
	// Rarus tenkam 23.03.2022 mantis 18574 ---
	
КонецПроцедуры

//rarus kabany 19.04.2021 17469 +++
&НаСервере
Функция ПолучитьНомераOFMS(ТаблицаЗаказыНаЗакупку)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗаказыНаЗакупку", ТаблицаЗаказыНаЗакупку.ВыгрузитьКолонку("ЗаказНаЗакупку"));
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(Scan_ЗаказНаЗакупку.Номер, """") КАК НомерOFMS
	|ИЗ
	|	Документ.Scan_ЗаказНаЗакупку КАК Scan_ЗаказНаЗакупку
	|ГДЕ
	|	Scan_ЗаказНаЗакупку.Ссылка В(&ЗаказыНаЗакупку)
	// rarus agar 25.06.2021 17892 ++
	|	И НЕ Scan_ЗаказНаЗакупку.ПометкаУдаления
	// rarus agar 25.06.2021 17892 --
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерOFMS";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		МассивНомеровOFMS = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("НомерOFMS");  
		Возврат МассивНомеровOFMS;  //rarus kabany 19.04.2021 17469 +
	Иначе
		Возврат неопределено;
	КонецЕсли;
КонецФункции
//rarus kabany 19.04.2021 17469 ---




