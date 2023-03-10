// rarus tenkam 01.08.2019 mantis 14427 +++

функция ЗаписатьЗначенияРСВзаимосвязьИзделийИЗаказов(Изделие, ЗаказНаЗавод, НаДату) Экспорт
	
	Отказ = Ложь;
	
	Если НаДату = Неопределено Тогда
		ДатаЗаписи = ТекущаяДата();
	Иначе
		ДатаЗаписи = НаДату;
	КонецЕсли; 
	
	Если НЕ Отказ Тогда
		//Чтение старого значения регистра
		СтруктураОтбора   = Новый Структура("Изделие", Изделие);
		СтруктураСведений = РегистрыСведений.Scan_ВзаимосвязьИзделийИЗаказов.ПолучитьПоследнее(ДатаЗаписи, СтруктураОтбора);
		ЗаказСтарый		  = СтруктураСведений.ЗаказНаЗавод;
		Записывать        = Ложь;
		//Введено заказ, а старое отсутствует
		Если ЗначениеЗаполнено(ЗаказНаЗавод) И НЕ ЗначениеЗаполнено(ЗаказСтарый) Тогда 
			Записывать = Истина; 
		КонецЕсли; 
		//заказ стерто, а старое заказ было введено
		Если НЕ ЗначениеЗаполнено(ЗаказНаЗавод) И ЗначениеЗаполнено(ЗаказСтарый) Тогда 
			Записывать = Истина; 
		КонецЕсли; 
		
		//Введен заказ и был введен старый
		Если ЗначениеЗаполнено(ЗаказНаЗавод) И ЗначениеЗаполнено(ЗаказСтарый) Тогда
			//Значение изменилось
			Если ЗаказНаЗавод <> ЗаказСтарый Тогда 
				Записывать = Истина; 
			КонецЕсли; 
		КонецЕсли; 
		
		Если Записывать Тогда
			//Значение изменилось
			ЗаписьРегСведений = РегистрыСведений.Scan_ВзаимосвязьИзделийИЗаказов.СоздатьМенеджерЗаписи();
			ЗаписьРегСведений.Изделие 		= Изделие;
			ЗаписьРегСведений.ЗаказНаЗавод  = ЗаказНаЗавод;
			ЗаписьРегСведений.Период        = ДатаЗаписи;
			ЗаписьРегСведений.Пользователь  = ПользователиКлиентСервер.ТекущийПользователь();
			
			Попытка
				ЗаписьРегСведений.Записать();
			Исключение
				Сообщить(НСтр("ru = 'Ошибка записи данных в регистр сведений'; en = 'Action failed'"));
				Отказ = Истина;
			КонецПопытки; 
		КонецЕсли; 
	КонецЕсли; 
	
	Возврат Отказ;
	
КонецФункции

Функция ПолучитьИзделиеПоЗаказу(ЗаказНаЗавод) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_ВзаимосвязьИзделийИЗаказовСрезПоследних.Изделие,
	               |	Scan_ВзаимосвязьИзделийИЗаказовСрезПоследних.ЗаказНаЗавод
	               |ИЗ
	               |	РегистрСведений.Scan_ВзаимосвязьИзделийИЗаказов.СрезПоследних(, ) КАК Scan_ВзаимосвязьИзделийИЗаказовСрезПоследних
	               |ГДЕ
	               |	Scan_ВзаимосвязьИзделийИЗаказовСрезПоследних.ЗаказНаЗавод = &ЗаказНаЗавод";
	Запрос.УстановитьПараметр("ЗаказНаЗавод", ЗаказНаЗавод);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Изделие;
	Иначе
		Возврат Справочники.Scan_Изделия.ПустаяСсылка();
	КонецЕсли;
КонецФункции

Функция ПолучитьЗаказПоИзделию(Изделие) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_ВзаимосвязьИзделийИЗаказовСрезПоследних.Изделие,
	               |	Scan_ВзаимосвязьИзделийИЗаказовСрезПоследних.ЗаказНаЗавод
	               |ИЗ
	               |	РегистрСведений.Scan_ВзаимосвязьИзделийИЗаказов.СрезПоследних(, ) КАК Scan_ВзаимосвязьИзделийИЗаказовСрезПоследних
	               |ГДЕ
	               |	Scan_ВзаимосвязьИзделийИЗаказовСрезПоследних.Изделие = &Изделие";
	Запрос.УстановитьПараметр("Изделие", Изделие);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ЗаказНаЗавод;
	Иначе
		Возврат Справочники.Scan_ЗаказыНаЗавод.ПустаяСсылка();
	КонецЕсли;
КонецФункции

// rarus tenkam 01.08.2019 mantis 14427 ---
