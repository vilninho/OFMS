
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Scan_ДоговорыВзаиморасчетов.Ссылка КАК Договор
	|ИЗ
	|	Справочник.Scan_ДоговорыВзаиморасчетов КАК Scan_ДоговорыВзаиморасчетов
	|ГДЕ
	|	Scan_ДоговорыВзаиморасчетов.ДОIDExternalSystem = &ИдентификаторДоговораДО";
	
	ПараметрыВызова = Новый Структура;
	ПараметрыВызова.Вставить("ИдентификаторКонтрагента", Параметры.ИдентификаторКонтрагента);
	
	ОтветСервиса = Scan_ВебСервисы.ВызовВебСервиса1СДО("GetListDogovorov", ПараметрыВызова, Отказ);
	
	Если Не Отказ Тогда
		Для Каждого СтруктураДоговора Из ОтветСервиса Цикл
			НоваяСтрока = СписокДоговоров.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураДоговора);
			
			Запрос.УстановитьПараметр("ИдентификаторДоговораДО", СтруктураДоговора.Идентификатор);
			РезультатЗапроса = Запрос.Выполнить();
			
			Если Не РезультатЗапроса.Пустой() Тогда
				Выборка = РезультатЗапроса.Выбрать();
				Выборка.Следующий();
				
				НоваяСтрока.Договор = Выборка.Договор;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Сообщить(ОтветСервиса);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДоговор(Команда)
	
	ДанныеДоговора = Элементы.СписокДоговоров.ТекущиеДанные;
	
	Если ДанныеДоговора= Неопределено Тогда
		Сообщить(НСтр("ru = 'Выберите строку списка!'; en = 'Select the line of the list!'"));
		Возврат;
	КонецЕсли;
	
	// rarus agar 09.02.2022 18761 ++
	//СтруктураДоговора = Новый Структура("Наименование,Идентификатор,Номер,Дата,ДатаНачала,ДатаОкончания,УсловияПоставки,УсловияОплаты,Договор");
	СтруктураДоговора = Новый Структура("Наименование,Идентификатор,Номер,Дата,ДатаНачала,ДатаОкончания,УсловияПоставки,УсловияОплаты,Договор,Бессрочный");
	// rarus agar 09.02.2022 18761 --
	
	ЗаполнитьЗначенияСвойств(СтруктураДоговора, ДанныеДоговора);
	
	Закрыть(СтруктураДоговора);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДоговоровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьДоговор(Команды.Найти("ВыбратьДоговор"));
	
КонецПроцедуры


