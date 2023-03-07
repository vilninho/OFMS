
Процедура ПроверкиПередСтартом(Отказ)
	//на всякий случай проверим заполнен ли предмет
	Если НЕ ЗначениеЗаполнено(Предмет) Тогда
		Scan_ОбщегоНазначенияСервер.СообщитьОбОшибке(,"Не указан предмет согласования!",,,, Отказ);
		Возврат;
	КонецЕсли;
	
	//rarus agar 14.07.2020  15690 ++
	Если ТипЗнч(Предмет) = Тип("ДокументСсылка.Scan_Калькуляция") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	Scan_Согласование.Ссылка КАК Ссылка
		|ИЗ
		|	БизнесПроцесс.Scan_Согласование КАК Scan_Согласование
		|ГДЕ
		|	((Scan_Согласование.Стартован И НЕ Scan_Согласование.Завершен)
		|	ИЛИ (Scan_Согласование.Завершен И Scan_Согласование.РезультатСогласования = ЗНАЧЕНИЕ(Перечисление.Scan_РезультатыСогласования.Согласовано)))
		|	И Scan_Согласование.Предмет = &Предмет
		|	И НЕ Scan_Согласование.ПометкаУдаления";
	Иначе
		//rarus agar 14.07.2020  15690 --
		//теперь проверим, есть ли другие согласования по этому предмету. Если уже есть, то откажемся от старта
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Scan_Согласование.Ссылка
		|ИЗ
		|	БизнесПроцесс.Scan_Согласование КАК Scan_Согласование
		|ГДЕ
		|	Scan_Согласование.Стартован
		|	И Scan_Согласование.Предмет = &Предмет
		|	И НЕ Scan_Согласование.ПометкаУдаления");
	КонецЕсли; //rarus agar 14.07.2020  15690 +-
	Запрос.УстановитьПараметр("Предмет", Предмет);
	Рез = Запрос.Выполнить();
	Если НЕ Рез.Пустой() Тогда
		Scan_ОбщегоНазначенияСервер.СообщитьОбОшибке(,"Выбранный предмет согласования уже на согласовании или согласован!",,,, Отказ);
		Возврат;
	КонецЕсли;
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Обработчики событий бизнес-процесса

Процедура ПриКопировании(ОбъектКопирования)
	Дата = ТекущаяДата();
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	НомерИтерации = 0;
	РезультатыСогласования.Очистить();
	РезультатыОзнакомлений.Очистить();
	ДатаНачала = '00010101';
	ДатаЗавершения = '00010101';
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//rarus sergei 09.09.2016 mantis 7167 ++
	Если ЭтоНовый() Тогда
		Дата = ТекущаяДата();
		Автор = ПользователиКлиентСервер.ТекущийПользователь();
		//Важность = Перечисления.Scan_Важность.Средняя;
		НомерИтерации = 0;
		//ВариантСогласования = Перечисления.Scan_ВариантыСогласования.Последовательно;
	КонецЕсли;	
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Scan_ЗаявкаНаДействие") Тогда
		//ГруппаИсполнителей = Scan_ПраваИНастройки.Scan_ПолучитьПраваИНастройкиПользователя(ДанныеЗаполнения.Организация, ПланыВидовХарактеристик.Scan_ПраваИНастройки.ЗаявкаНаДействиеГруппаИсполнителейСогласованияПоУмолчанию);
		ШаблонСогласования = Scan_ПраваИНастройки.Scan_ПолучитьПраваИНастройкиПользователя(ДанныеЗаполнения.Организация, ПланыВидовХарактеристик.Scan_ПраваИНастройки.ЗаявкаНаДействиеШаблонСогласования);
		//rarus bonmak 09.08.2021 16834 ++
		//ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Scan_ЗаявкаПеревозчику") Тогда
		//ШаблонСогласования = Scan_ПраваИНастройки.Scan_ПолучитьПраваИНастройкиПользователя(ДанныеЗаполнения.Организация, ПланыВидовХарактеристик.Scan_ПраваИНастройки.ЗаявкаПеревозчикуШаблонСогласования);
		//rarus bonmak 09.08.2021 16834 --
		//rarus sergei 09.09.2016 mantis 7167 --
		
	//rarus BProg_Gladkov 04.05.2020 0015962 ++ ОбработкаЗаполнения для ДокументСсылка.Scan_Калькуляция
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Scan_Калькуляция") Тогда
		ШаблонСогласования = Scan_ПраваИНастройки.Scan_ПолучитьПраваИНастройкиПользователя(ДанныеЗаполнения.Организация, ПланыВидовХарактеристик.Scan_ПраваИНастройки.КалькуляцияШаблонСогласования);
	//rarus BProg_Gladkov 04.05.2020 0015962 -- 
		
	//	ГруппаИсполнителей = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДанныеЗаполнения.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ВыбытиеИзЭксплуатацииГруппаИсполнителейСогласованияПоУмолчанию);
	//ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатЗаявкаНаРасходованиеДС") Тогда
	//	ГруппаИсполнителей = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДанныеЗаполнения.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ЗаявкаНаРасходованиеДСГруппаИсполнителейСогласованияПоУмолчанию);
	//ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатУстановкаПрейскурантовТС") Тогда
	//	ГруппаИсполнителей = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДанныеЗаполнения.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.УстановкаПрейскурантовТСГруппаИсполнителейСогласованияПоУмолчанию);
	//ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатУстановкаТарифовЗП") Тогда
	//	ГруппаИсполнителей = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДанныеЗаполнения.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.УстановкаТарифовЗПГруппаИсполнителейСогласованияПоУмолчанию);
	//ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатПеремещениеТСиОборудования") Тогда
	//	ГруппаИсполнителей = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДанныеЗаполнения.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ПеремещениеТСИОборудованияГруппаИсполнителейСогласованияПоУмолчанию);
	КонецЕсли;
	Если ЗначениеЗаполнено(ШаблонСогласования) Тогда
		ЗаполнитьПоШаблону(ШаблонСогласования)		
	КонецЕсли; 
	
	//Если ЗначениеЗаполнено(ГруппаИсполнителей) Тогда
	//	Для Каждого ТекСтрока Из ГруппаИсполнителей.Пользователи Цикл
	//		НоваяСтрока = Исполнители.Добавить();
	//		НоваяСтрока.Исполнитель = ТекСтрока.Пользователь;
	//	КонецЦикла;
	//КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		Предмет = ДанныеЗаполнения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Предмет) и Не ЗначениеЗаполнено(ШаблонСогласования.НаименованиеБизнесПроцесса)Тогда 
		Наименование = "Согласовать """ + Строка(Предмет) + """"; 
	КонецЕсли;	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если НЕ ПометкаУдаления И Ссылка.ПометкаУдаления Тогда
		ВосстановитьСостоянияБизнесПроцесса();
	КонецЕсли;
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элементов карты маршрута

Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	ПроверкиПередСтартом(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ДатаНачала = ТекущаяДата();
	Записать();
КонецПроцедуры

Процедура ПодготовкаОбработка(ТочкаМаршрутаБизнесПроцесса)
	УстановитьПривилегированныйРежим(Истина);
	
	НомерИтерации = НомерИтерации + 1;
	ПовторитьСогласование = Ложь;
	Если ВариантСогласования = Перечисления.Scan_ВариантыСогласования.Последовательно Тогда 
		Для Каждого Строка Из Исполнители Цикл
			Строка.Пройден = Ложь;
		КонецЦикла;	
	КонецЕсли;	
	
	Записать();
КонецПроцедуры

Процедура НаправлятьВсемСразуПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = (ВариантСогласования = Перечисления.Scan_ВариантыСогласования.Параллельно);
	
КонецПроцедуры

Процедура СогласоватьПараллельноПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Для Каждого Строка Из Исполнители Цикл
		Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
		Задача.Дата  	= ТекущаяДата();
		Задача.Автор 	= Автор;
		Задача.Описание = Описание;
		Задача.Предмет 	= Предмет;
		Задача.Важность = Важность;
		
		Задача.Наименование  = Наименование;
		Задача.БизнесПроцесс = ЭтотОбъект.Ссылка;
		Задача.ТочкаМаршрута = ТочкаМаршрутаБизнесПроцесса;
		
		Если ЗначениеЗаполнено(СрокИсполнения) Тогда 
			Задача.СрокИсполнения = Задача.Дата + СрокИсполнения * 24 * 3600;
		Иначе	
			Задача.СрокИсполнения = '00010101';
		КонецЕсли;	
		
		Если ТипЗнч(Строка.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
			Задача.Исполнитель = Строка.Исполнитель;
		Иначе	
			Задача.РольИсполнителя = Строка.Исполнитель;
			// rarus tenkam 26.11.2018 mantis 13672 +++
			//Задача.ОсновнойОбъектАдресации = Строка.ОсновнойОбъектАдресации;
			//Задача.ДополнительныйОбъектАдресации = Строка.ДополнительныйОбъектАдресации;
			// rarus tenkam 26.11.2018 mantis 13672 ---
		КонецЕсли;	
		
		Задача.Записать();

		Scan_СогласованиеДокументов.ОтправитьЭлектронныеПисьма(Задача); //rarus BProg_Gladkov 30.12.2019 0015117 +- //rarus BProg_Gladkov 30.04.2020 0015962 +- Перенес в модуль Scan_СогласованиеДокументов
		
		ФормируемыеЗадачи.Добавить(Задача);
		
		НоваяСтрока = РезультатыСогласования.Добавить();
		НоваяСтрока.НомерИтерации 	  = НомерИтерации;
		НоваяСтрока.ЗадачаИсполнителя = Задача.Ссылка;
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	Записать();
	
КонецПроцедуры

Процедура СогласоватьПоследовательноПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Для Каждого Строка Из Исполнители Цикл
		Если Строка.Пройден Тогда
			Продолжить;
		КонецЕсли;	
			
		Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
		Задача.Дата 	= ТекущаяДата();
		Задача.Автор 	= Автор;
		Задача.Описание = Описание;
		Задача.Предмет 	= Предмет;
		Задача.Важность = Важность;
		
		Задача.Наименование  = Наименование;
		Задача.БизнесПроцесс = ЭтотОбъект.Ссылка;
		Задача.ТочкаМаршрута = ТочкаМаршрутаБизнесПроцесса;
		
		Если ЗначениеЗаполнено(СрокИсполнения) Тогда 
			Задача.СрокИсполнения = Задача.Дата + СрокИсполнения * 24 * 3600;
		Иначе	
			Задача.СрокИсполнения = '00010101';
		КонецЕсли;	
		
		//rarus BProg_Gladkov 30.12.2019 0015117 +++
		Если ТипЗнч(Строка.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
			Задача.Исполнитель = Строка.Исполнитель;
		Иначе	
			Задача.РольИсполнителя = Строка.Исполнитель;
		КонецЕсли;	
		//rarus BProg_Gladkov 30.12.2019 0015117 ---
		
		
		Задача.Записать();
		
		Scan_СогласованиеДокументов.ОтправитьЭлектронныеПисьма(Задача); //rarus BProg_Gladkov 30.12.2019 0015117 +- //rarus BProg_Gladkov 30.04.2020 0015962 +- Перенес в модуль Scan_СогласованиеДокументов

		ФормируемыеЗадачи.Добавить(Задача);
		
		УстановитьПривилегированныйРежим(Истина);
		НоваяСтрока = РезультатыСогласования.Добавить();
		НоваяСтрока.НомерИтерации 	  = НомерИтерации;
		НоваяСтрока.ЗадачаИсполнителя = Задача.Ссылка;
		Записать();
		
		Прервать;
	КонецЦикла;
КонецПроцедуры

Процедура СогласоватьПоследовательноПередВыполнением(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого Строка Из Исполнители Цикл
		Если Не Строка.Пройден Тогда
			Если Строка.Исполнитель = Задача.Исполнитель 
				ИЛИ  Строка.Исполнитель = Задача.РольИсполнителя //rarus BProg_Gladkov 30.12.2019 0015117 +-	
			Тогда
				Строка.Пройден = Истина;
				Записать();
				Прервать;
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

Процедура УсловиеОбходЗавершен(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	ПараметрыОтбора = Новый Структура("НомерИтерации, РезультатСогласования", НомерИтерации, Перечисления.Scan_РезультатыСогласования.НеСогласовано);
	РезультатНеСогласовано = РезультатыСогласования.НайтиСтроки(ПараметрыОтбора);
	
	Если (Исполнители.Найти(Ложь, "Пройден") = Неопределено) Или (РезультатНеСогласовано.Количество() > 0) Тогда 
		Результат = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаРезультатаОбработка(ТочкаМаршрутаБизнесПроцесса)
	УстановитьПривилегированныйРежим(Истина);
	
	// результат согласования
	Если РезультатыСогласования.Количество() > 0 Тогда
		РезультатСогласования = Перечисления.Scan_РезультатыСогласования.Согласовано;
		Для Каждого Элемент Из РезультатыСогласования Цикл
			Если Элемент.НомерИтерации = НомерИтерации Тогда
				Если Элемент.РезультатСогласования = Перечисления.Scan_РезультатыСогласования.НеСогласовано Тогда 
					РезультатСогласования = Перечисления.Scan_РезультатыСогласования.НеСогласовано;
					Прервать;
				КонецЕсли;	
				
				Если Элемент.РезультатСогласования = Перечисления.Scan_РезультатыСогласования.СогласованоСЗамечаниями Тогда 
					РезультатСогласования = Перечисления.Scan_РезультатыСогласования.СогласованоСЗамечаниями;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;	
	
	Записать();
	
	//Если ЗначениеЗаполнено(Предмет) Тогда 
	//	Если РезультатСогласования = Перечисления.уатРезультатыСогласования.НеСогласовано Тогда 
	//		Состояние = Перечисления.уатСостоянияДокументов.НеСогласован;
	//	Иначе	
	//		Состояние = Перечисления.уатСостоянияДокументов.Согласован;
	//	КонецЕсли;	
	//КонецЕсли;
КонецПроцедуры

Процедура ОзнакомитьсяПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// для вложенного бп
	Если ЗначениеЗаполнено(ВедущаяЗадача) Тогда
		Если РезультатСогласования <> Перечисления.Scan_РезультатыСогласования.НеСогласовано Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;	
	
	Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
	Задача.Дата  	= ТекущаяДата();
	Задача.Автор 	= Автор;
	Задача.Описание = Описание;
	Задача.Предмет 	= Предмет;
	Задача.Важность = Важность;
	
	Задача.Исполнитель 	  = Автор;
	Задача.СрокИсполнения = '00010101'; 
	Задача.БизнесПроцесс  = Ссылка;
	Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
	
	Если ЗначениеЗаполнено(Предмет) Тогда 
		Задача.Наименование = "Ознакомиться с результатом согласования """ + Строка(Предмет) + """";
	Иначе
		Задача.Наименование = "Ознакомиться с результатом согласования: " + Наименование;
	КонецЕсли;	
	
	Задача.Записать();
	ФормируемыеЗадачи.Добавить(Задача);
	
	УстановитьПривилегированныйРежим(Истина);
	НоваяСтрока = РезультатыОзнакомлений.Добавить();
	НоваяСтрока.НомерИтерации 	  = НомерИтерации;
	НоваяСтрока.ЗадачаИсполнителя = Задача.Ссылка;
	Записать();
	
КонецПроцедуры

Процедура ПовторитьСогласованиеПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = ПовторитьСогласование;
	
КонецПроцедуры

Процедура ОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	ДатаЗавершения = ТекущаяДата();
	Записать();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры

// Процедура выполняет заполнение объекта бизнес-процесса данными из шаблона
//
Процедура ЗаполнитьПоШаблону(ШаблонБизнесПроцесса) Экспорт
	Шаблон = ШаблонБизнесПроцесса;
	
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.НаименованиеБизнесПроцесса) Тогда 
		Наименование = ШаблонБизнесПроцесса.НаименованиеБизнесПроцесса;
	КонецЕсли;
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.Описание) Тогда 
		Описание = ШаблонБизнесПроцесса.Описание;
	КонецЕсли;
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.Важность) Тогда 
		Важность = ШаблонБизнесПроцесса.Важность;
	КонецЕсли;
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.СрокИсполнения) Тогда
		СрокИсполнения = ШаблонБизнесПроцесса.СрокИсполнения;
	КонецЕсли;
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.ВариантСогласования) Тогда
		ВариантСогласования = ШаблонБизнесПроцесса.ВариантСогласования;
	КонецЕсли;
	
	// заполнение исполнителей
	Исполнители.Очистить();
	Для Каждого Строка Из ШаблонБизнесПроцесса.Исполнители Цикл
		НоваяСтрока = Исполнители.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;	
КонецПроцедуры	

Процедура ВосстановитьСостоянияБизнесПроцесса()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СогласованиеРезультатыСогласования.НомерИтерации,
	|	МИНИМУМ(СогласованиеРезультатыСогласования.ЗадачаИсполнителя.Дата) КАК ПерваяЗадача,
	|	МАКСИМУМ(СогласованиеРезультатыСогласования.ЗадачаИсполнителя.ДатаИсполнения) КАК ПоследняяЗадача
	|ИЗ
	|	БизнесПроцесс.Scan_Согласование.РезультатыСогласования КАК СогласованиеРезультатыСогласования
	|ГДЕ
	|	СогласованиеРезультатыСогласования.Ссылка = &ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	СогласованиеРезультатыСогласования.НомерИтерации";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	ДатыЗадач = Запрос.Выполнить().Выгрузить();
	
	
	Для Инд = 1 По НомерИтерации Цикл
		СтрокаДаты = ДатыЗадач.Найти(Инд, "НомерИтерации");
		
		ЗадачиИтерации = РезультатыСогласования.НайтиСтроки(Новый Структура("НомерИтерации", Инд));
		
		ИтерацияЗавершена = Истина;
		Для Каждого Строка Из ЗадачиИтерации Цикл
			Если Не Строка.ЗадачаИсполнителя.Выполнена Тогда 
				ИтерацияЗавершена = Ложь;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		
		//Если ИтерацияЗавершена Тогда 
		//	СостояниеИтерации = Перечисления.уатСостоянияДокументов.Согласован;
		//	Для Каждого Строка Из ЗадачиИтерации Цикл
		//		Если Строка.РезультатСогласования = Перечисления.уатРезультатыСогласования.НеСогласовано Тогда 
		//			СостояниеИтерации = Перечисления.СостоянияДокументов.НеСогласован;
		//			Прервать;
		//		КонецЕсли;	
		//	КонецЦикла;	
		//КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры	