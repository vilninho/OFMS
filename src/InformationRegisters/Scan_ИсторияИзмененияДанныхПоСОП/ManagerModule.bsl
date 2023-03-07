
//rarus vikhle 27.09.2021 АПК +- + инструкции и область
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура - Обработать данные по order intake
//
// Параметры:
//  ТаблицаЗаписей	 - ТаблицаЗначений	 - 
//  Период			 - Дата	 - 
//  ВосстановлениеЗаписей - Булево - Признак восстановления записей по стандартному OI
//
//Процедура ОбработатьДанныеДляOrderIntake(ТаблицаЗаписей, Период = Неопределено) Экспорт //rarus vikhle 05.09.2021 mt 18212 +++
Процедура ОбработатьДанныеДляOrderIntake(ТаблицаЗаписей, Период = Неопределено, ВосстановлениеЗаписей = Ложь) Экспорт // rarus agar 11.02.2022 17739
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МАКСИМУМ(КалендарныеГрафики.ДатаГрафика) КАК ДатаГрафика
		|ИЗ
		|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
		|ГДЕ
		|	КалендарныеГрафики.ДатаГрафика <= &ТекущаяДата
		|	И КалендарныеГрафики.Год = &Год
		|	И КалендарныеГрафики.ДеньВключенВГрафик = ИСТИНА";
	
	Запрос.УстановитьПараметр("Год",		 Год(Период));
	Запрос.УстановитьПараметр("ТекущаяДата", Период);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	РабочаяДата = ТекущаяДатаСеанса();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		РабочаяДата = ВыборкаДетальныеЗаписи.ДатаГрафика;
	КонецЦикла;
	РабочаяДата = НачалоДня(РабочаяДата);
	                   	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТЗ.Период КАК Период,
		|	ТЗ.Договор КАК Договор,
		|	ТЗ.Значение КАК Значение
		|ПОМЕСТИТЬ ВТ_ТЗ_Типизация
		|ИЗ
		|	&ТаблицаЗаписей КАК ТЗ
		|ГДЕ
		|	ТЗ.Значение В(&МассивЗначений)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Scan_СоставСоглашенийОПоставкеСрезПоследних.СоглашениеОПоставке.Договор КАК Договор,
		|	ВЫРАЗИТЬ(Scan_СоставСоглашенийОПоставкеСрезПоследних.Изделие КАК Справочник.Scan_Изделия) КАК Продукт
		|ПОМЕСТИТЬ ПродуктыСОП
		|ИЗ
		|	РегистрСведений.Scan_СоставСоглашенийОПоставке.СрезПоследних КАК Scan_СоставСоглашенийОПоставкеСрезПоследних
		|ГДЕ
		|	Scan_СоставСоглашенийОПоставкеСрезПоследних.СоглашениеОПоставке.Договор В
		|			(ВЫБРАТЬ
		|				ВТ_ТЗ_Типизация.Договор КАК Договор
		|			ИЗ
		|				ВТ_ТЗ_Типизация КАК ВТ_ТЗ_Типизация)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТЗ_Типизация.Период КАК Период,
		|	ВТ_ТЗ_Типизация.Договор КАК Договор,
		|	ВТ_ТЗ_Типизация.Значение КАК Значение,
		|	ЕСТЬNULL(ПродуктыСОП.Продукт, ЗНАЧЕНИЕ(Справочник.Scan_Изделия.ПустаяСсылка)) КАК Продукт
		|ПОМЕСТИТЬ ТЗ_Продукты
		|ИЗ
		|	ВТ_ТЗ_Типизация КАК ВТ_ТЗ_Типизация
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПродуктыСОП КАК ПродуктыСОП
		|		ПО ВТ_ТЗ_Типизация.Договор = ПродуктыСОП.Договор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТЗ_Продукты.Период КАК Период,
		|	ТЗ_Продукты.Договор КАК Договор,
		|	ТЗ_Продукты.Значение КАК Значение,
		|	ТЗ_Продукты.Продукт.ЗаказНаЗавод КАК ПродуктЗаказНаЗавод,
		//rarus vikhle 03.09.2021 mt 18212 +++
		|	ВЫРАЗИТЬ(Scan_ХарактеристикиЗаказовНаЗаводСрезПоследних.Значение КАК Перечисление.Scan_ТипыЗаказовНаЗавод) КАК ТипЗаказа
		//rarus vikhle 03.09.2021 mt 18212 ---
		|ПОМЕСТИТЬ ВТ_ТЗ
		|ИЗ
		|	ТЗ_Продукты КАК ТЗ_Продукты
		//rarus vikhle 03.09.2021 mt 18212 +++
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Scan_ХарактеристикиЗаказовНаЗавод.СрезПоследних(
		|				,
		|				Заказ В
		|						(ВЫБРАТЬ
		|							ТЗ_Продукты.Продукт.ЗаказНаЗавод КАК ПродуктЗаказНаЗавод
		|						ИЗ
		|							ТЗ_Продукты КАК ТЗ_Продукты)
		|					И Реквизит = ЗНАЧЕНИЕ(Перечисление.Scan_ДополнительнаяИнформацияПоЗаказамНаЗавод.ТипЗаказаНаЗавод)) КАК Scan_ХарактеристикиЗаказовНаЗаводСрезПоследних
		|		ПО ТЗ_Продукты.Продукт.ЗаказНаЗавод = Scan_ХарактеристикиЗаказовНаЗаводСрезПоследних.Заказ
		//rarus vikhle 03.09.2021 mt 18212 ---
		|ГДЕ
		|	ТЗ_Продукты.Продукт.БУ = ЛОЖЬ
		//rarus vikhle 03.09.2021 mt 18212 +++
		|	И ВЫРАЗИТЬ(Scan_ХарактеристикиЗаказовНаЗаводСрезПоследних.Значение КАК Перечисление.Scan_ТипыЗаказовНаЗавод) В (&ТипыЗаказаFirm)
		//rarus vikhle 03.09.2021 mt 18212 ---
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТЗ.Договор КАК Договор,
		|	ВТ_ТЗ.Период КАК ПериодБазовый,
		|	ВТ_ТЗ.Значение КАК ЗначениеБазовое,
		|	ВТ_ТЗ.ПродуктЗаказНаЗавод КАК ПродуктЗаказНаЗавод,
		|	Scan_OrderIntakeСрезПоследних.ЗаказНаЗавод КАК ЗаказНаЗавод,
		|	Scan_OrderIntakeСрезПоследних.Период КАК ПериодВнесенияОплаты,
		|	Scan_OrderIntakeСрезПоследних1.ЗаказНаЗавод КАК ЗаказНаЗавод1,
		|	Scan_OrderIntakeСрезПоследних1.Период КАК ПериодПодтверждениеЗавода,
		|	Scan_OrderIntakeСрезПоследних2.ЗаказНаЗавод КАК ЗаказНаЗавод2,
		|	Scan_OrderIntakeСрезПоследних2.Период КАК ПериодДатыРасторжения
		|ИЗ
		|	ВТ_ТЗ КАК ВТ_ТЗ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Scan_OrderIntake.СрезПоследних(, ВидДаты = ЗНАЧЕНИЕ(Перечисление.Scan_ДатыДляФормированияОтчетаOI.ВнесениеОплаты)) КАК Scan_OrderIntakeСрезПоследних
		|		ПО ВТ_ТЗ.ПродуктЗаказНаЗавод = Scan_OrderIntakeСрезПоследних.ЗаказНаЗавод
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Scan_OrderIntake.СрезПоследних(, ВидДаты = ЗНАЧЕНИЕ(Перечисление.Scan_ДатыДляФормированияОтчетаOI.ПодтверждениеЗавода)) КАК Scan_OrderIntakeСрезПоследних1
		|		ПО ВТ_ТЗ.ПродуктЗаказНаЗавод = Scan_OrderIntakeСрезПоследних1.ЗаказНаЗавод
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Scan_OrderIntake.СрезПоследних(, ВидДаты = ЗНАЧЕНИЕ(Перечисление.Scan_ДатыДляФормированияОтчетаOI.ДатаРасторжения)) КАК Scan_OrderIntakeСрезПоследних2
		|		ПО ВТ_ТЗ.ПродуктЗаказНаЗавод = Scan_OrderIntakeСрезПоследних2.ЗаказНаЗавод";
	//rarus vikhle 25.03.2021 mt 17526 ---
	
	Запрос.УстановитьПараметр("ТаблицаЗаписей", ТаблицаЗаписей);
	МассивЗначений = Новый Массив;
	МассивЗначений.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.Оплачено);
	МассивЗначений.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.ОплаченоЧастично);	
	МассивЗначений.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.ПредоплатаПолученаНесоответствуетГрафику);	
	МассивЗначений.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.ПредоплатаПолученаСоответствуетГрафику);
	МассивЗначений.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.ПредоплатаВнесенаПолностью);
	МассивЗначений.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.ОплаченоПолностью);	  	
	
	Запрос.УстановитьПараметр("МассивЗначений", МассивЗначений);
	//rarus vikhle 03.09.2021 mt 18212 +++
	ТипыЗаказаFirm = Перечисления.Scan_ТипыЗаказовНаЗавод.ТипыЗаказаFirm();
	Запрос.УстановитьПараметр("ТипыЗаказаFirm", ТипыЗаказаFirm);
	//rarus vikhle 03.09.2021 mt 18212 ---
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		//rarus vikhle 28.09.2021 mt 17739 +++
		//Если АльтернативныйРасчет Тогда
		//	ВидДилера = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Договор, "Компания.ВидДилера");
		//	Если ВидДилера <> Перечисления.Scan_ВидыДилеров.Собственный Тогда
		//		МенеджерЗаписи = РегистрыСведений.Scan_РасчетOrderIntake.СоздатьМенеджерЗаписи();
		//		МенеджерЗаписи.Период       = Период;
		//		МенеджерЗаписи.ЗаказНаЗавод = Выборка.ПродуктЗаказНаЗавод;
		//		МенеджерЗаписи.Событие      = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ВнесениеОплаты;
		//		МенеджерЗаписи.ДатаСобытия  = РабочаяДата;
		//		МенеджерЗаписи.Пользователь = ПараметрыСеанса.ТекущийПользователь;
		//		УстановитьПривилегированныйРежим(Истина);
		//		МенеджерЗаписи.Записать();
		//		УстановитьПривилегированныйРежим(Ложь);
		//	КонецЕсли;
		//КонецЕсли;
		//rarus vikhle 28.09.2021 mt 17739 ---
		
		Если не значениеЗаполнено(Выборка.ЗаказНаЗавод) Тогда // нет состояния "внесение оплаты", надо добавить
			
			НоваяЗапись = РегистрыСведений.Scan_OrderIntake.СоздатьМенеджерЗаписи();  
			НоваяЗапись.Период = РабочаяДата;
			НоваяЗапись.ВидДаты = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ВнесениеОплаты;
			НоваяЗапись.ЗаказНаЗавод = Выборка.ПродуктЗаказНаЗавод;
			НоваяЗапись.Прочитать();
			Если не НоваяЗапись.Выбран() Тогда
				НоваяЗапись.Период = РабочаяДата;
				НоваяЗапись.ВидДаты = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ВнесениеОплаты;
				НоваяЗапись.ЗаказНаЗавод = Выборка.ПродуктЗаказНаЗавод;
				НоваяЗапись.ИспользоватьВОтчетах = Истина; //rarus vikhle 21.03.2021 mt 17479
				НоваяЗапись.Пользователь = ПараметрыСеанса.ТекущийПользователь;	
				НоваяЗапись.Записать();
			КонецЕсли;
			
			Если значениеЗаполнено(Выборка.ЗаказНаЗавод1) Тогда // не было состояния "внесение оплаты", но было подтверждение завода, надо добавить статус Order Intake
				НоваяЗапись = РегистрыСведений.Scan_OrderIntake.СоздатьМенеджерЗаписи();  
				НоваяЗапись.Период = ?(РабочаяДата > Выборка.ПериодПодтверждениеЗавода,РабочаяДата, Выборка.ПериодПодтверждениеЗавода);
				НоваяЗапись.ВидДаты = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ДатаOrderIntake;
				НоваяЗапись.ЗаказНаЗавод = Выборка.ПродуктЗаказНаЗавод;
				НоваяЗапись.Прочитать();
				Если не НоваяЗапись.Выбран() Тогда
					НоваяЗапись.Период = ?(РабочаяДата > Выборка.ПериодПодтверждениеЗавода,РабочаяДата, Выборка.ПериодПодтверждениеЗавода);
					НоваяЗапись.ВидДаты = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ДатаOrderIntake;
					НоваяЗапись.ЗаказНаЗавод = Выборка.ПродуктЗаказНаЗавод;
					НоваяЗапись.ИспользоватьВОтчетах = Истина; //rarus vikhle 21.03.2021 mt 17479
					НоваяЗапись.Пользователь = ПараметрыСеанса.ТекущийПользователь;	
					НоваяЗапись.Записать();
				КонецЕсли;
			КонецЕсли; 	
			//rarus vikhle 28.09.2021 mt 17739 +++
			// rarus agar 15.09.2021 17739 ++
			//Если АльтернативныйРасчет Тогда
			//	ВидДилера = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Договор, "Компания.ВидДилера");
			//	Если ВидДилера <> Перечисления.Scan_ВидыДилеров.Собственный Тогда
			//		МенеджерЗаписи = РегистрыСведений.Scan_РасчетOrderIntake.СоздатьМенеджерЗаписи();
			//		МенеджерЗаписи.Период       = ТекущаяДатаСеанса();
			//		МенеджерЗаписи.ЗаказНаЗавод = Выборка.ПродуктЗаказНаЗавод;
			//		МенеджерЗаписи.Событие      = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ВнесениеОплаты;
			//		МенеджерЗаписи.ДатаСобытия  = РабочаяДата;
			//		МенеджерЗаписи.Пользователь = ПараметрыСеанса.ТекущийПользователь;
			//		УстановитьПривилегированныйРежим(Истина);
			//		МенеджерЗаписи.Записать();
			//		УстановитьПривилегированныйРежим(Ложь);
			//	КонецЕсли;
			//КонецЕсли;
			// rarus agar 15.09.2021 17739 --
			//rarus vikhle 28.09.2021 mt 17739 ---
		Иначе	// было состояние "внесение оплаты"
			// проверим было ли расторжение этого состояния, если да, то зафиксируем новое "внесение оплаты"
			Если значениеЗаполнено(Выборка.ЗаказНаЗавод2) Тогда
				Если Выборка.ПериодДатыРасторжения >= Выборка.ПериодВнесенияОплаты И 
					Выборка.ПериодДатыРасторжения <= РабочаяДата Тогда
					
					НоваяЗапись = РегистрыСведений.Scan_OrderIntake.СоздатьМенеджерЗаписи();  
					НоваяЗапись.Период = РабочаяДата;
					НоваяЗапись.ВидДаты = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ВнесениеОплаты;
					НоваяЗапись.ЗаказНаЗавод = Выборка.ПродуктЗаказНаЗавод;
					НоваяЗапись.Прочитать();
					Если не НоваяЗапись.Выбран() Тогда
						НоваяЗапись.Период = РабочаяДата;
						НоваяЗапись.ВидДаты = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ВнесениеОплаты;
						НоваяЗапись.ЗаказНаЗавод = Выборка.ПродуктЗаказНаЗавод;
						НоваяЗапись.ИспользоватьВОтчетах = Истина; //rarus vikhle 21.03.2021 mt 17479
						НоваяЗапись.Пользователь = ПараметрыСеанса.ТекущийПользователь;	
						НоваяЗапись.Записать();
					КонецЕсли;
					
					Если значениеЗаполнено(Выборка.ЗаказНаЗавод1) Тогда // зафиксировано "внесение оплаты", но ранее было подтверждение завода, надо добавить статус Order Intake
						НоваяЗапись = РегистрыСведений.Scan_OrderIntake.СоздатьМенеджерЗаписи(); 
						НоваяЗапись.Период = ?(РабочаяДата > Выборка.ПериодПодтверждениеЗавода,РабочаяДата, Выборка.ПериодПодтверждениеЗавода);
						НоваяЗапись.ВидДаты = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ДатаOrderIntake;
						НоваяЗапись.ЗаказНаЗавод = Выборка.ПродуктЗаказНаЗавод;
						НоваяЗапись.Прочитать();
						Если не НоваяЗапись.Выбран() Тогда
							НоваяЗапись.Период = ?(РабочаяДата > Выборка.ПериодПодтверждениеЗавода,РабочаяДата, Выборка.ПериодПодтверждениеЗавода);
							НоваяЗапись.ВидДаты = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ДатаOrderIntake;
							НоваяЗапись.ЗаказНаЗавод = Выборка.ПродуктЗаказНаЗавод;
							НоваяЗапись.ИспользоватьВОтчетах = Истина; //rarus vikhle 21.03.2021 mt 17479
							НоваяЗапись.Пользователь = ПараметрыСеанса.ТекущийПользователь;	
							НоваяЗапись.Записать();
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				//rarus vikhle 28.09.2021 mt 17739 +++
				// rarus agar 15.09.2021 17739 ++
				//Если АльтернативныйРасчет Тогда
				//	ВидДилера = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Договор, "Компания.ВидДилера");
				//	Если ВидДилера <> Перечисления.Scan_ВидыДилеров.Собственный Тогда
				//		МенеджерЗаписи = РегистрыСведений.Scan_РасчетOrderIntake.СоздатьМенеджерЗаписи();
				//		//МенеджерЗаписи.Период       = ТекущаяДатаСеанса();
				//		МенеджерЗаписи.Период       = Период; //rarus vikhle 07.09.2021 mt 18212
				//		МенеджерЗаписи.ЗаказНаЗавод = Выборка.ПродуктЗаказНаЗавод;
				//		МенеджерЗаписи.Событие      = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ВнесениеОплаты;
				//		МенеджерЗаписи.ДатаСобытия  = РабочаяДата;
				//		МенеджерЗаписи.Пользователь = ПараметрыСеанса.ТекущийПользователь;
				//		УстановитьПривилегированныйРежим(Истина);
				//		МенеджерЗаписи.Записать();
				//		УстановитьПривилегированныйРежим(Ложь);
				//	КонецЕсли;
				//КонецЕсли;
				// rarus agar 15.09.2021 17739 --
				//rarus vikhle 28.09.2021 mt 17739 ---
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;
	
	// rarus agar 29.12.2021 17739 ++
	АльтернативныйРасчет = Scan_ПраваИНастройки.Scan_Право("ИспользоватьАльтернативныйРасчетДатOrderIntake");
	Если АльтернативныйРасчет И Не ВосстановлениеЗаписей Тогда // rarus agar 11.02.2022 17739
		СтатусыНеОплачено = Новый Массив;
		СтатусыНеОплачено.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.НеОплачено);
		СтатусыНеОплачено.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.НеТребуется);
		СтатусыНеОплачено.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.ПредоплатаНеТребуется);
		СтатусыНеОплачено.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.ПредоплатаОтсутствует);
		
		СтатусыОплачено = Новый Массив;
		СтатусыОплачено.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.Оплачено);
		СтатусыОплачено.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.ОплаченоЧастично);
		СтатусыОплачено.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.ПредоплатаПолученаНесоответствуетГрафику);
		СтатусыОплачено.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.ПредоплатаПолученаСоответствуетГрафику);
		СтатусыОплачено.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.ПредоплатаВнесенаПолностью);
		СтатусыОплачено.Добавить(Перечисления.Scan_СтатусыОплатПоСОП.ОплаченоПолностью);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("П1", ТаблицаЗаписей);
		Запрос.Текст = "ВЫБРАТЬ
		|	ТаблицаНабораЗаписей.Период КАК Период,
		|	ВЫРАЗИТЬ(ТаблицаНабораЗаписей.Договор КАК Справочник.Scan_ДоговорыВзаиморасчетов) КАК Договор,
		|	ТаблицаНабораЗаписей.Значение КАК СтатусОплаты
		|ПОМЕСТИТЬ ВТ_СтатусОплаты
		|ИЗ
		|	&П1 КАК ТаблицаНабораЗаписей
		|ГДЕ
		|	ТаблицаНабораЗаписей.ВидЗначения = ЗНАЧЕНИЕ(Перечисление.Scan_ДополнительнаяИнформацияПоСОП.СтатусОплаты)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Scan_СоставСоглашенийОПоставкеСрезПоследних.СоглашениеОПоставке.Договор КАК Договор,
		|	ВЫРАЗИТЬ(Scan_СоставСоглашенийОПоставкеСрезПоследних.Изделие КАК Справочник.Scan_Изделия) КАК Продукт
		|ПОМЕСТИТЬ ВТ_ПродуктыСоглашения
		|ИЗ
		|	РегистрСведений.Scan_СоставСоглашенийОПоставке.СрезПоследних КАК Scan_СоставСоглашенийОПоставкеСрезПоследних
		|ГДЕ
		|	Scan_СоставСоглашенийОПоставкеСрезПоследних.СоглашениеОПоставке.Договор В
		|			(ВЫБРАТЬ
		|				ВТ_СтатусОплаты.Договор КАК Договор
		|			ИЗ
		|				ВТ_СтатусОплаты КАК ВТ_СтатусОплаты)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_СтатусОплаты.Период КАК Период,
		|	ВТ_СтатусОплаты.Договор КАК Договор,
		|	ВТ_СтатусОплаты.СтатусОплаты КАК СтатусОплаты,
		|	ЕСТЬNULL(ВТ_ПродуктыСоглашения.Продукт, ЗНАЧЕНИЕ(Справочник.Scan_Изделия.ПустаяСсылка)) КАК Продукт
		|ПОМЕСТИТЬ ВТ_Продукты
		|ИЗ
		|	ВТ_СтатусОплаты КАК ВТ_СтатусОплаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПродуктыСоглашения КАК ВТ_ПродуктыСоглашения
		|		ПО ВТ_СтатусОплаты.Договор = ВТ_ПродуктыСоглашения.Договор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Продукты.Период КАК Период,
		|	ВТ_Продукты.Договор КАК Договор,
		|	ВТ_Продукты.СтатусОплаты КАК СтатусОплаты,
		|	ВТ_Продукты.Продукт КАК Продукт,
		|	ВТ_Продукты.Продукт.ЗаказНаЗавод КАК ЗаказНаЗавод
		|ИЗ
		|	ВТ_Продукты КАК ВТ_Продукты
		|ГДЕ
		|	НЕ ВТ_Продукты.Продукт.БУ
		|	И ВТ_Продукты.Договор.Компания.ВидДилера <> ЗНАЧЕНИЕ(Перечисление.Scan_ВидыДилеров.Собственный)";
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если СтатусыОплачено.Найти(Выборка.СтатусОплаты) <> Неопределено Тогда
				Scan_OrderIntake.ЗарегистрироватьПоступлениеОплаты(Выборка.Период, Выборка.ЗаказНаЗавод);
			ИначеЕсли СтатусыНеОплачено.Найти(Выборка.СтатусОплаты) <> Неопределено Тогда
				Scan_OrderIntake.ЗарегистрироватьОтменуОплаты(Выборка.Период, Выборка.ЗаказНаЗавод);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	// rarus agar 29.12.2021 17739 --
	
КонецПроцедуры //rarus vikhle 05.09.2021 mt 18212 ---	


#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
