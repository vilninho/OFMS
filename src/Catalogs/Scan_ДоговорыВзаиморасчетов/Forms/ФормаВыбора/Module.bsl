
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//rarus sergei 12.08.2016 mantis 7092 ++	
	Если Параметры.Свойство("ОсновнойДоговор") Тогда	
		Если Параметры.ОсновнойДоговор = Истина Тогда
			ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидДоговора");
			// rarus tenkam 30.12.2020 mantis 16934 +++
			//ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
			// rarus tenkam 30.12.2020 mantis 16934 ---
			ЭлементОтбора.Использование = Истина;
			ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			// rarus tenkam 30.12.2020 mantis 16934 +++
			//ЭлементОтбора.ПравоеЗначение = Перечисления.Scan_ВидыДоговоров.Соглашение ;
			МассивЗначений = Новый Массив;
			МассивЗначений.Добавить(Перечисления.Scan_ВидыДоговоров.Соглашение);
			МассивЗначений.Добавить(Перечисления.Scan_ВидыДоговоров.ДопСоглашениеКСОП);
			ЭлементОтбора.ПравоеЗначение = МассивЗначений;
			// rarus tenkam 30.12.2020 mantis 16934 ---
			ЭлементОтбора.Представление = "Вид договора";//rarus agar 13.04.2021 17622 +-
			Если Параметры.Свойство("ОтборПоВладельцу") Тогда
				
				ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				ЭлементОтбора.Использование = Истина;
				ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
				ЭлементОтбора.ПравоеЗначение = Параметры.ОтборПоВладельцу.Владелец ;
				ЭлементОтбора.Представление = "Владелец договора";//rarus agar 13.04.2021 17622 +-
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	//rarus sergei 12.08.2016 mantis 7092 --
	
	//rarus tenkam 24.01.2018 mantis 12676 +++
	
	ГруппаОтбора = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ПравоеЗначение = ТекущаяДатаСеанса();  	
	ЭлементОтбора.Представление = "Дата окончания";//rarus agar 13.04.2021 17622 +-
	
	ЭлементОтбора2 = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора2.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания");
	ЭлементОтбора2.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора2.Использование = Истина;
	ЭлементОтбора2.ПравоеЗначение = Дата('00010101');
	ЭлементОтбора2.Представление = "Дата окончания";//rarus agar 13.04.2021 17622 +-
	//rarus tenkam 25.01.2018 mantis 12676 ---
	
	//rarus agar 14.09.2020 15696 ++
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		Владелец = Параметры.Отбор.Владелец;
		Если ЗначениеЗаполнено(Владелец) Тогда
			ИдентификаторВладельца = Владелец.IDExternalSystem;
		КонецЕсли;
	КонецЕсли;
	//rarus agar 14.09.2020 15696 --
	
	// rarus tenkam 30.12.2020 mantis 16934 +++
	Если Параметры.Отбор.Свойство("ВидыДоговора") Тогда
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидДоговора");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.Использование = Истина;
		
		ЭлементОтбора.ПравоеЗначение = Параметры.Отбор.ВидыДоговора;
		
		ЭлементОтбора.Представление = "Вид договора";//rarus agar 13.04.2021 17622 +-
		
		Параметры.Отбор.Удалить("ВидыДоговора");
	КонецЕсли;
	// rarus tenkam 30.12.2020 mantis 16934 ---
	
	//rarus agar 13.04.2021 17622 ++
	ОтображениеФиксированногоОтбора();
	//rarus agar 13.04.2021 17622 --
	
КонецПроцедуры

//rarus agar 14.09.2020 15696 ++
&НаКлиенте
Процедура ПолучитьИзДО(Команда)
	
	Если Не ЗначениеЗаполнено(ИдентификаторВладельца) Тогда
		Сообщить(НСтр("ru = 'Отсутствует идентификатор у контрагента-владельца договора!'; en = 'The contract owner ID is empty!'"));
		Возврат;
	Иначе
		Оповещение = Новый ОписаниеОповещения("ПослеПолученияДоговораИзДО",ЭтотОбъект);
		ОткрытьФорму("Справочник.Scan_ДоговорыВзаиморасчетов.Форма.ФормаПолученияИзДО",Новый Структура("ИдентификаторКонтрагента", ИдентификаторВладельца),,,,,Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияДоговораИзДО(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
		СоздатьОбновитьДоговорПоДаннымДО(РезультатЗакрытия);
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьОбновитьДоговорПоДаннымДО(ДанныеДоговораДО)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", ДанныеДоговораДО.Идентификатор);
	Запрос.Текст = "ВЫБРАТЬ
	|	Scan_ДоговорыВзаиморасчетов.Ссылка КАК Договор
	|ИЗ
	|	Справочник.Scan_ДоговорыВзаиморасчетов КАК Scan_ДоговорыВзаиморасчетов
	|ГДЕ
	|	Scan_ДоговорыВзаиморасчетов.ДОIDExternalSystem = &Идентификатор";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		ДоговорВзаиморасчетовОбъект = Выборка.Договор.ПолучитьОбъект();
		
		Если ДоговорВзаиморасчетовОбъект.Наименование <> ДанныеДоговораДО.Наименование Тогда
			ДоговорВзаиморасчетовОбъект.Наименование = ДанныеДоговораДО.Наименование;
		КонецЕсли;
		Если ДоговорВзаиморасчетовОбъект.НомерДоговора <> ДанныеДоговораДО.Номер Тогда
			ДоговорВзаиморасчетовОбъект.НомерДоговора = ДанныеДоговораДО.Номер;
		КонецЕсли;
		Если ДоговорВзаиморасчетовОбъект.ДатаНачала <> ДанныеДоговораДО.ДатаНачала Тогда
			ДоговорВзаиморасчетовОбъект.ДатаНачала = ДанныеДоговораДО.ДатаНачала;
		КонецЕсли;
		Если ДоговорВзаиморасчетовОбъект.ДатаОкончания <> ДанныеДоговораДО.ДатаОкончания Тогда
			ДоговорВзаиморасчетовОбъект.ДатаОкончания = ДанныеДоговораДО.ДатаОкончания;
		КонецЕсли;
		Если ДоговорВзаиморасчетовОбъект.ДОНаименованиеДоговора <> ДанныеДоговораДО.Наименование Тогда
			ДоговорВзаиморасчетовОбъект.ДОНаименованиеДоговора = ДанныеДоговораДО.Наименование;
		КонецЕсли;
		Если ДоговорВзаиморасчетовОбъект.ДОУсловияПоставки <> ДанныеДоговораДО.УсловияПоставки Тогда
			ДоговорВзаиморасчетовОбъект.ДОУсловияПоставки = ДанныеДоговораДО.УсловияПоставки;
		КонецЕсли;
		Если ДоговорВзаиморасчетовОбъект.ДОУсловияОплаты <> ДанныеДоговораДО.УсловияОплаты Тогда
			ДоговорВзаиморасчетовОбъект.ДОУсловияОплаты = ДанныеДоговораДО.УсловияОплаты;
		КонецЕсли;
		Если ДоговорВзаиморасчетовОбъект.ДОДатаДоговора <> ДанныеДоговораДО.Дата Тогда
			ДоговорВзаиморасчетовОбъект.ДОДатаДоговора = ДанныеДоговораДО.Дата;
		КонецЕсли;
		// rarus agar 09.02.2022 18761 ++
		Если ДоговорВзаиморасчетовОбъект.Бессрочный <> ДанныеДоговораДО.Бессрочный Тогда
			ДоговорВзаиморасчетовОбъект.Бессрочный = ДанныеДоговораДО.Бессрочный;
		КонецЕсли;
		// rarus agar 09.02.2022 18761 --
		
		Если ДоговорВзаиморасчетовОбъект.Модифицированность() Тогда
			ДоговорВзаиморасчетовОбъект.ДОДатаОбновления = ТекущаяДатаСеанса();
			Попытка
				ДоговорВзаиморасчетовОбъект.Записать();
				Сообщить(НСтр("ru = 'Договор успешно обновлен.'; en = 'The contract has been successfully updated.'"));
			Исключение 
				Сообщить(НСтр("ru = 'Не удалось обновить договор!'; en = 'Failed to update a contract!'"));
			КонецПопытки;
		Иначе
			Сообщить(НСтр("ru = 'Обновление договора не требуется.'; en = 'Updating the contract is not required.'"));
		КонецЕсли;
	Иначе
		ДоговорВзаиморасчетовОбъект = Справочники.Scan_ДоговорыВзаиморасчетов.СоздатьЭлемент();
		ДоговорВзаиморасчетовОбъект.Владелец               = Владелец;
		ДоговорВзаиморасчетовОбъект.Наименование           = ДанныеДоговораДО.Наименование;
		ДоговорВзаиморасчетовОбъект.ВидДоговора            = Перечисления.Scan_ВидыДоговоров.СПоставщиком;
		ДоговорВзаиморасчетовОбъект.НомерДоговора          = ДанныеДоговораДО.Номер;
		ДоговорВзаиморасчетовОбъект.ДатаНачала             = ДанныеДоговораДО.ДатаНачала;
		ДоговорВзаиморасчетовОбъект.ДатаОкончания          = ДанныеДоговораДО.ДатаОкончания;
		ДоговорВзаиморасчетовОбъект.ДОНаименованиеДоговора = ДанныеДоговораДО.Наименование;
		ДоговорВзаиморасчетовОбъект.ДОУсловияПоставки      = ДанныеДоговораДО.УсловияПоставки;
		ДоговорВзаиморасчетовОбъект.ДОУсловияОплаты        = ДанныеДоговораДО.УсловияОплаты;
		ДоговорВзаиморасчетовОбъект.ДОIDExternalSystem     = ДанныеДоговораДО.Идентификатор;
		ДоговорВзаиморасчетовОбъект.ДОДатаДоговора         = ДанныеДоговораДО.Дата;
		ДоговорВзаиморасчетовОбъект.ДОДоговорПолученИз1СДО = Истина;
		ДоговорВзаиморасчетовОбъект.ДОДатаОбновления       = ТекущаяДатаСеанса();
		// rarus agar 09.02.2022 18761 ++
		ДоговорВзаиморасчетовОбъект.Бессрочный             = ДанныеДоговораДО.Бессрочный;
		// rarus agar 09.02.2022 18761 --
		
		Попытка
			ДоговорВзаиморасчетовОбъект.Записать();
			Сообщить(НСтр("ru = 'Договор успешно создан.'; en = 'The contract has been successfully created.'"));
		Исключение 
			Сообщить(НСтр("ru = 'Не удалось создать договор!'; en = 'Failed to create a contract!'"));
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры
//rarus agar 14.09.2020 15696 --

//rarus agar 13.04.2021 17622 ++
&НаСервере
Процедура ОтображениеФиксированногоОтбора()
	
	ПредставлениеОбъекта = Метаданные.Справочники.Scan_ДоговорыВзаиморасчетов.ПредставлениеОбъекта;
	ПредставлениеОтбора  = Scan_ВспомогательныеФункцииСервер.ПолучитьПредставлениеОтбораФормыВыбора(ЭтотОбъект, ПредставлениеОбъекта);
	
	Если Не ПустаяСтрока(ПредставлениеОтбора) Тогда
		ФиксированныйОтборПредставление = ПредставлениеОтбора;
		
		Элементы.ФиксированныйОтборПредставление.Видимость = Истина;
		Элементы.ФиксированныйОтборПредставление.Высота    = СтрЧислоСтрок(ПредставлениеОтбора);
	КонецЕсли;
	
КонецПроцедуры
//rarus agar 13.04.2021 17622 --
