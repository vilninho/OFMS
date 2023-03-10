// rarus tenkam 11.07.2018 mantis 13195 +++
Функция ЗаписьЗначенияПоИсторииИзменений(Документ, Изделие, Реквизит, Значение, НаДату = Неопределено) Экспорт
	
	Отказ = Ложь;
	
	Если НаДату = Неопределено Тогда
		ДатаЗаписи = ТекущаяДата();
	Иначе
		ДатаЗаписи = НаДату;
	КонецЕсли; 
	
	Если НЕ Отказ Тогда
		//Чтение старого значения регистра
		СтруктураОтбора   = Новый Структура("Документ,Изделие,Реквизит", Документ,Изделие,Реквизит);
		СтруктураСведений = РегистрыСведений.Scan_ИсторияИзмененияДанныхЗаявкиПеревозчику.ПолучитьПоследнее(ДатаЗаписи, СтруктураОтбора);
		ЗначениеСтарое    = СтруктураСведений.Значение;
		Записывать        = Ложь;
		//Введено значение, а старое отсутствует
		Если ЗначениеЗаполнено(Значение) И ЗначениеСтарое = Неопределено Тогда 
			Записывать = Истина; 
		КонецЕсли; 
		//Значение стерто, а старое значение было введено
		Если НЕ ЗначениеЗаполнено(Значение) И ЗначениеСтарое <> Неопределено Тогда 
			Записывать = Истина; 
		КонецЕсли; 
		//Введено значение и было введено старое
		Если ЗначениеЗаполнено(Значение) И ЗначениеСтарое <> Неопределено Тогда
			//Значение изменилось
			Если Значение <> ЗначениеСтарое Тогда 
				Записывать = Истина; 
			КонецЕсли; 
		КонецЕсли; 
		Если Записывать Тогда
			//Значение параметра изменилось
			ЗаписьРегСведений = РегистрыСведений.Scan_ИсторияИзмененияДанныхЗаявкиПеревозчику.СоздатьМенеджерЗаписи();
			ЗаписьРегСведений.Документ	  = Документ;
			ЗаписьРегСведений.Изделие	  = Изделие;
			ЗаписьРегСведений.Реквизит = Реквизит;
			ЗаписьРегСведений.Значение    = Значение;
			ЗаписьРегСведений.Период      = ДатаЗаписи;
			ЗаписьРегСведений.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
			
			Попытка
				ЗаписьРегСведений.Записать();
			Исключение
				//rarus FominskiyAS 24.04.2019  mantis 14191 +++
				//Сообщить(НСтр("ru = 'Ошибка записи параметра заявки перевозчику в регистр сведений'"));
				Сообщить(НСтр("ru = 'Ошибка записи параметра заявки перевозчику в регистр сведений'; en = 'Action failed'"));
				//rarus FominskiyAS 24.04.2019  mantis 14191 ---  
				Отказ = Истина;
			КонецПопытки; 
		КонецЕсли; 
	КонецЕсли; 
		
	Возврат Отказ;
КонецФункции // ЗаписьЗначенияРегистраСведения()

// rarus tenkam 11.07.2018 mantis 13195 ---