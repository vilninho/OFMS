//rarus tenkam 06.09.2017 mantis 9425 +++

Функция ПолучитьХарактеристикиАКБ(АКБСсылка, НаДату = Неопределено) Экспорт
Если Не ЗначениеЗаполнено(НаДату) Тогда
		ДатаЗаписи = ТекущаяДата();
	Иначе
		ДатаЗаписи = НаДату;
	КонецЕсли;
	СтруктураСведений = Неопределено;
	//СтруктураОтбора   = Новый Структура("АКБ, Изделие", АКБСсылка, АКБСсылка.Изделие);
	//СтруктураСведений = РегистрыСведений.Scan_ДанныеПоАКБИзделий.ПолучитьПоследнее(ДатаЗаписи, СтруктураОтбора);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_ДанныеПоАКБИзделийСрезПоследних.Период КАК ДатаИзменения,
		|	Scan_ДанныеПоАКБИзделийСрезПоследних.ПусковойТок КАК ПусковойТок,
		|	Scan_ДанныеПоАКБИзделийСрезПоследних.Плотность КАК Плотность,
		|	Scan_ДанныеПоАКБИзделийСрезПоследних.НапряжениеБезНагрузки КАК НапряжениеБезНагрузки,
		|	Scan_ДанныеПоАКБИзделийСрезПоследних.НапряжениеПодНагрузкой КАК НапряжениеПодНагрузкой,
		|	Scan_ДанныеПоАКБИзделийСрезПоследних.Емкость КАК Емкость,
		|	Scan_ДанныеПоАКБИзделийСрезПоследних.Состояние КАК Состояние
		|ИЗ
		|	РегистрСведений.Scan_ДанныеПоАКБИзделий.СрезПоследних(
		|			&ДатаЗаписи,
		|			АКБ = &АКБСсылка
		|				И Изделие = &Изделие) КАК Scan_ДанныеПоАКБИзделийСрезПоследних";
	
	Запрос.УстановитьПараметр("АКБСсылка", АКБСсылка);
	Запрос.УстановитьПараметр("ДатаЗаписи", ДатаЗаписи);
	Запрос.УстановитьПараметр("Изделие", АКБСсылка.Изделие);
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		СтруктураСведений = Новый Структура;
		СтруктураСведений.Вставить("ДатаИзменения", ВыборкаДетальныеЗаписи.ДатаИзменения);
		СтруктураСведений.Вставить("ПусковойТок", ВыборкаДетальныеЗаписи.ПусковойТок);
		СтруктураСведений.Вставить("Плотность", ВыборкаДетальныеЗаписи.Плотность);
		СтруктураСведений.Вставить("НапряжениеБезНагрузки", ВыборкаДетальныеЗаписи.НапряжениеБезНагрузки);
		СтруктураСведений.Вставить("НапряжениеПодНагрузкой", ВыборкаДетальныеЗаписи.НапряжениеПодНагрузкой);
		СтруктураСведений.Вставить("Емкость", ВыборкаДетальныеЗаписи.Емкость);
		СтруктураСведений.Вставить("Состояние", ВыборкаДетальныеЗаписи.Состояние); 		
	КонецЕсли;;

	Возврат СтруктураСведений; 		
КонецФункции

Функция ЗаписатьХарактеристикиАКБ(АКБСсылка, Изделие, СтруктураХарактеристик, НаДату = Неопределено) Экспорт
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(НаДату) Тогда
		ДатаЗаписи = ТекущаяДата();
	Иначе
		ДатаЗаписи = НаДату;
	КонецЕсли; 
	
	ПусковойТок				= СтруктураХарактеристик.ПусковойТок;
	Плотность    			= СтруктураХарактеристик.Плотность;
	НапряжениеБезНагрузки	= СтруктураХарактеристик.НапряжениеБезНагрузки;
	НапряжениеПодНагрузкой  = СтруктураХарактеристик.НапряжениеПодНагрузкой;
	Емкость    				= СтруктураХарактеристик.Емкость;
	Состояние  				= СтруктураХарактеристик.Состояние;
	
	Если НЕ Отказ Тогда
		//Чтение старого значения регистра
		СтруктураОтбора   = Новый Структура("АКБ,Изделие", АКБСсылка, Изделие);
		СтруктураСведений = РегистрыСведений.Scan_ДанныеПоАКБИзделий.ПолучитьПоследнее(ДатаЗаписи, СтруктураОтбора);
		
		ПусковойТокСтарое				= СтруктураСведений.ПусковойТок;
		ПлотностьСтарое    				= СтруктураСведений.Плотность;
		НапряжениеБезНагрузкиСтарое		= СтруктураСведений.НапряжениеБезНагрузки;
		НапряжениеПодНагрузкойСтарое    = СтруктураСведений.НапряжениеПодНагрузкой;
		ЕмкостьСтарое    				= СтруктураСведений.Емкость;
		СостояниеСтарое    				= СтруктураСведений.Состояние;
		
		Записывать = Ложь;
		//Введено значение, а старое отсутствует
		Если (ЗначениеЗаполнено(ПусковойТок) И НЕ ЗначениеЗаполнено(ПусковойТокСтарое)) ИЛИ
			(ЗначениеЗаполнено(Плотность) И НЕ ЗначениеЗаполнено(ПлотностьСтарое)) ИЛИ
			(ЗначениеЗаполнено(НапряжениеБезНагрузки) И НЕ ЗначениеЗаполнено(НапряжениеБезНагрузкиСтарое)) ИЛИ
			(ЗначениеЗаполнено(НапряжениеПодНагрузкой) И НЕ ЗначениеЗаполнено(НапряжениеПодНагрузкойСтарое)) ИЛИ
			(ЗначениеЗаполнено(Емкость) И НЕ ЗначениеЗаполнено(ЕмкостьСтарое)) ИЛИ
			(ЗначениеЗаполнено(Состояние) И НЕ ЗначениеЗаполнено(СостояниеСтарое)) Тогда 
			Записывать = Истина; 
		КонецЕсли; 
		//Значение стерто, а старое значение было введено
		Если (НЕ ЗначениеЗаполнено(ПусковойТок) И ЗначениеЗаполнено(ПусковойТокСтарое)) ИЛИ
			(НЕ ЗначениеЗаполнено(Плотность) И ЗначениеЗаполнено(ПлотностьСтарое)) ИЛИ
			(НЕ ЗначениеЗаполнено(НапряжениеБезНагрузки) И ЗначениеЗаполнено(НапряжениеБезНагрузкиСтарое)) ИЛИ
			(НЕ ЗначениеЗаполнено(НапряжениеПодНагрузкой) И ЗначениеЗаполнено(НапряжениеПодНагрузкойСтарое)) ИЛИ
			(НЕ ЗначениеЗаполнено(Емкость) И ЗначениеЗаполнено(ЕмкостьСтарое)) ИЛИ
			(НЕ ЗначениеЗаполнено(Состояние) И ЗначениеЗаполнено(СостояниеСтарое)) Тогда 
			Записывать = Истина; 
		КонецЕсли; 
		//Введено значение и было введено старое
		Если (ЗначениеЗаполнено(ПусковойТок) И ЗначениеЗаполнено(ПусковойТокСтарое)) ИЛИ 
			(ЗначениеЗаполнено(Плотность) И ЗначениеЗаполнено(ПлотностьСтарое)) ИЛИ
			(ЗначениеЗаполнено(НапряжениеБезНагрузки) И ЗначениеЗаполнено(НапряжениеБезНагрузкиСтарое)) ИЛИ
			(ЗначениеЗаполнено(НапряжениеПодНагрузкой) И ЗначениеЗаполнено(НапряжениеПодНагрузкойСтарое)) ИЛИ
			(ЗначениеЗаполнено(Емкость) И ЗначениеЗаполнено(ЕмкостьСтарое)) ИЛИ
			(ЗначениеЗаполнено(Состояние) И ЗначениеЗаполнено(СостояниеСтарое)) Тогда
			// rarus tenkam 27.02.2018 mantis 12849 +++
			////Значение изменилось
			//Если ПусковойТок <> ПусковойТокСтарое ИЛИ
			//	Плотность <> ПлотностьСтарое ИЛИ
			//	НапряжениеБезНагрузки <> НапряжениеБезНагрузкиСтарое ИЛИ
			//	НапряжениеПодНагрузкой <> НапряжениеПодНагрузкойСтарое ИЛИ
			//	Емкость <> ЕмкостьСтарое ИЛИ
			//	Состояние <> СостояниеСтарое Тогда
			//	
			// rarus tenkam 27.02.2018 mantis 12849 ---
				Записывать = Истина; 
			//КонецЕсли;		// rarus tenkam 27.02.2018 mantis 12849 + 
		КонецЕсли; 
		Если Записывать Тогда
			//Значение параметра изменилось
			ЗаписьРегСведений = РегистрыСведений.Scan_ДанныеПоАКБИзделий.СоздатьМенеджерЗаписи();
			ЗаписьРегСведений.АКБ	 					 = АКБСсылка;
			ЗаписьРегСведений.Изделие					 = Изделие;
			ЗаписьРегСведений.ПусковойТок  				 = ПусковойТок;
			ЗаписьРегСведений.Плотность    				 = Плотность;
			ЗаписьРегСведений.НапряжениеБезНагрузки   	 = НапряжениеБезНагрузки;
			ЗаписьРегСведений.НапряжениеПодНагрузкой     = НапряжениеПодНагрузкой;
			ЗаписьРегСведений.Емкость   				 = Емкость;
			ЗаписьРегСведений.Состояние   				 = Состояние;
			
			ЗаписьРегСведений.Период     				 = ДатаЗаписи;
			ЗаписьРегСведений.Пользователь 				 = ПользователиКлиентСервер.ТекущийПользователь(); 			
			Попытка
				ЗаписьРегСведений.Записать();
			Исключение
				//rarus FominskiyAS 24.04.2019  mantis 14191 +++
				//Сообщить(НСтр("ru = 'Ошибка записи параметра АКБ в регистр сведений'"));
				Сообщить(НСтр("ru = 'Ошибка записи параметра АКБ в регистр сведений'; en = 'Action failed'"));
				//rarus FominskiyAS 24.04.2019  mantis 14191 ---  
				Отказ = Истина;
			КонецПопытки; 
		КонецЕсли; 
	КонецЕсли; 
		
	Возврат Отказ;
КонецФункции // ЗаписьЗначенияРегистраСведения()
//rarus tenkam 06.09.2017 mantis 9425 ---