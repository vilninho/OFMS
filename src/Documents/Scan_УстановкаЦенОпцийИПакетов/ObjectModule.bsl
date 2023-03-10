
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Scan_ЦеныКомпонентовСпецификаций.Записывать = Истина;
	
	ТипЗначенияЦеныСумма   = ПредопределенноеЗначение("Перечисление.Scan_ТипыЗначенийЦены.Сумма");
	
	ТипЦенDistrNet    = ПредопределенноеЗначение("Справочник.Scan_ТипыЦен.ЦенаDistrNet");
	ТипЦенDealerNet   = ПредопределенноеЗначение("Справочник.Scan_ТипыЦен.ЦенаDealerNet");
	ТипЦенRetailPrice = ПредопределенноеЗначение("Справочник.Scan_ТипыЦен.ЦенаRetailPrice");
	
	Для Каждого СтрокаОпции Из ЭтотОбъект.ОпцииПродуктов Цикл
		Если СтрокаОпции.ЦенаDistrNet <> 0 Тогда
			Движение = Движения.Scan_ЦеныКомпонентовСпецификаций.Добавить();
			Движение.Период                  = СтрокаОпции.ДействуетСДаты;
			Движение.ИдентификаторПрайсЛиста = ЭтотОбъект.ИдентификаторПрайсЛиста;
			Движение.ДействуетСPartPeriod    = СтрокаОпции.ДействуетСPartPeriod;
			Движение.ТипЦен                  = ТипЦенDistrNet;
			Движение.Опции                   = СтрокаОпции.Опция;
			Движение.Цена                    = СтрокаОпции.ЦенаDistrNet;
			Движение.ЦенаРегл                = СтрокаОпции.ЦенаDistrNet;
			Движение.ТипЗначенияЦены         = ТипЗначенияЦеныСумма;
			Движение.Файл                    = СтрокаОпции.Файл;
		КонецЕсли;
		
		Если СтрокаОпции.ЦенаDealerNet <> 0 Тогда
			Движение = Движения.Scan_ЦеныКомпонентовСпецификаций.Добавить();
			Движение.Период                  = СтрокаОпции.ДействуетСДаты;
			Движение.ИдентификаторПрайсЛиста = ЭтотОбъект.ИдентификаторПрайсЛиста;
			Движение.ДействуетСPartPeriod    = СтрокаОпции.ДействуетСPartPeriod;
			Движение.ТипЦен                  = ТипЦенDealerNet;
			Движение.Опции                   = СтрокаОпции.Опция;
			Движение.Цена                    = СтрокаОпции.ЦенаDealerNet;
			Движение.ЦенаРегл                = СтрокаОпции.ЦенаDealerNet;
			Движение.ТипЗначенияЦены         = ТипЗначенияЦеныСумма;
			Движение.Файл                    = СтрокаОпции.Файл;
		КонецЕсли;
		
		Если СтрокаОпции.ЦенаRetailPrice <> 0 Тогда
			Движение = Движения.Scan_ЦеныКомпонентовСпецификаций.Добавить();
			Движение.Период                  = СтрокаОпции.ДействуетСДаты;
			Движение.ИдентификаторПрайсЛиста = ЭтотОбъект.ИдентификаторПрайсЛиста;
			Движение.ДействуетСPartPeriod    = СтрокаОпции.ДействуетСPartPeriod;
			Движение.ТипЦен                  = ТипЦенRetailPrice;
			Движение.Опции                   = СтрокаОпции.Опция;
			Движение.Цена                    = СтрокаОпции.ЦенаRetailPrice;
			Движение.ЦенаРегл                = СтрокаОпции.ЦенаRetailPrice;
			Движение.ТипЗначенияЦены         = ТипЗначенияЦеныСумма;
			Движение.Файл                    = СтрокаОпции.Файл;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаПакета Из ЭтотОбъект.ЦеновыеПакеты Цикл
		Если СтрокаПакета.ЦенаDistrNet <> 0 Тогда
			Движение = Движения.Scan_ЦеныКомпонентовСпецификаций.Добавить();
			// rarus agar 30.04.2021 17322 ++
			Если ЗначениеЗаполнено(СтрокаПакета.ДействуетСДаты) Тогда
				Движение.Период              = СтрокаПакета.ДействуетСДаты;
			Иначе
				Движение.Период              = Дата;
			КонецЕсли;
			// rarus agar 30.04.2021 17322 --
			Движение.ИдентификаторПрайсЛиста = ЭтотОбъект.ИдентификаторПрайсЛиста;
			Движение.ДействуетСPartPeriod    = СтрокаПакета.ДействуетСPartPeriod;
			Движение.ТипЦен                  = ТипЦенDistrNet;
			Движение.Опции                   = СтрокаПакета.ЦеновойПакет;
			Движение.Цена                    = СтрокаПакета.ЦенаDistrNet;
			Движение.ЦенаРегл                = СтрокаПакета.ЦенаDistrNet;
			Движение.ТипЗначенияЦены         = СтрокаПакета.ТипЗначенияЦены;
			Движение.Файл                    = СтрокаПакета.Файл;
			// rarus agar 07.06.2021 17322 ++
			Движение.ДействуетДоДаты         = СтрокаПакета.ДействуетДоДаты;
			Движение.ДействуетДоPartPeriod   = СтрокаПакета.ДействуетДоPartPeriod;
			// rarus agar 07.06.2021 17322 --
		КонецЕсли;
		
		Если СтрокаПакета.ЦенаDealerNet <> 0 Тогда
			Движение = Движения.Scan_ЦеныКомпонентовСпецификаций.Добавить();
			// rarus agar 30.04.2021 17322 ++
			Если ЗначениеЗаполнено(СтрокаПакета.ДействуетСДаты) Тогда
				Движение.Период              = СтрокаПакета.ДействуетСДаты;
			Иначе
				Движение.Период              = Дата;
			КонецЕсли;
			// rarus agar 30.04.2021 17322 --
			Движение.ИдентификаторПрайсЛиста = ЭтотОбъект.ИдентификаторПрайсЛиста;
			Движение.ТипЦен                  = ТипЦенDealerNet;
			Движение.Опции                   = СтрокаПакета.ЦеновойПакет;
			Движение.Цена                    = СтрокаПакета.ЦенаDealerNet;
			Движение.ЦенаРегл                = СтрокаПакета.ЦенаDealerNet;
			Движение.ТипЗначенияЦены         = СтрокаПакета.ТипЗначенияЦены;
			Движение.Файл                    = СтрокаПакета.Файл;
			// rarus agar 07.06.2021 17322 ++
			Движение.ДействуетДоДаты         = СтрокаПакета.ДействуетДоДаты;
			Движение.ДействуетДоPartPeriod   = СтрокаПакета.ДействуетДоPartPeriod;
			// rarus agar 07.06.2021 17322 --
		КонецЕсли;
		
		Если СтрокаПакета.ЦенаRetailPrice <> 0 Тогда
			Движение = Движения.Scan_ЦеныКомпонентовСпецификаций.Добавить();
			// rarus agar 30.04.2021 17322 ++
			Если ЗначениеЗаполнено(СтрокаПакета.ДействуетСДаты) Тогда
				Движение.Период              = СтрокаПакета.ДействуетСДаты;
			Иначе
				Движение.Период              = Дата;
			КонецЕсли;
			// rarus agar 30.04.2021 17322 --
			Движение.ИдентификаторПрайсЛиста = ЭтотОбъект.ИдентификаторПрайсЛиста;
			Движение.ТипЦен                  = ТипЦенRetailPrice;
			Движение.Опции                   = СтрокаПакета.ЦеновойПакет;
			Движение.Цена                    = СтрокаПакета.ЦенаRetailPrice;
			Движение.ЦенаРегл                = СтрокаПакета.ЦенаRetailPrice;
			Движение.ТипЗначенияЦены         = СтрокаПакета.ТипЗначенияЦены;
			Движение.Файл                    = СтрокаПакета.Файл;
			// rarus agar 07.06.2021 17322 ++
			Движение.ДействуетДоДаты         = СтрокаПакета.ДействуетДоДаты;
			Движение.ДействуетДоPartPeriod   = СтрокаПакета.ДействуетДоPartPeriod;
			// rarus agar 07.06.2021 17322 --
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого СтрокаОпцииПродуктов Из ОпцииПродуктов Цикл
		Если  ЗначениеЗаполнено(СтрокаОпцииПродуктов.ДействуетСДаты)
			И ЗначениеЗаполнено(СтрокаОпцииПродуктов.ДействуетСPartPeriod)
			И Не Scan_ЦенообразованиеСервер.ДатаСоответствуетPartPeriod(СтрокаОпцииПродуктов.ДействуетСДаты, СтрокаОпцииПродуктов.ДействуетСPartPeriod) 
			Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Указанный в строке № %1 Part Period не соответствует дате начала действия'; en = 'The Part Period does not match the From Date in line # %1'"),
		                                    СтрокаОпцииПродуктов.НомерСтроки);
			Сообщить(ТекстСообщения);
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	
	// rarus agar 30.04.2021 17322 ++
	Для Каждого СтрокаЦеновогоПакета Из ЦеновыеПакеты Цикл
		Если     ЗначениеЗаполнено(СтрокаЦеновогоПакета.ЦенаDistrNet)
			И Не ЗначениеЗаполнено(СтрокаЦеновогоПакета.ДействуетСPartPeriod)
			Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'В строке № %1 не указан Part Period'; en = 'The Part Period does not filled in line # %1'"),
											СтрокаЦеновогоПакета.НомерСтроки);
			Сообщить(ТекстСообщения);
			Отказ = Истина;
		КонецЕсли;
		Если     (ЗначениеЗаполнено(СтрокаЦеновогоПакета.ЦенаDealerNet) Или ЗначениеЗаполнено(СтрокаЦеновогоПакета.ЦенаRetailPrice))
			И Не ЗначениеЗаполнено(СтрокаЦеновогоПакета.ДействуетСДаты)
			Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'В строке № %1 не указана дата начала действия'; en = 'The From date does not filled in line # %1'"),
											СтрокаЦеновогоПакета.НомерСтроки);
			Сообщить(ТекстСообщения);
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	// rarus agar 30.04.2021 17322 --
	
КонецПроцедуры
