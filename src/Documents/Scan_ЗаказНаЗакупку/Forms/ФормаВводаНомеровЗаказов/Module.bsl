
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("НомераЗаказов") Тогда
		Для Каждого ЭлементНомераЗаказа Из Параметры.НомераЗаказов Цикл
			НоваяСтрока = НомераЗаказов.Добавить();
			НоваяСтрока.НомерЗаказа  = ЭлементНомераЗаказа.Значение;
			НоваяСтрока.ЗаказНаЗавод = Справочники.Scan_ЗаказыНаЗавод.НайтиПоНаименованию(ЭлементНомераЗаказа.Значение, Истина);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	
	Закрыть(ПоместитьНомераЗаказовНаСервере());
	
КонецПроцедуры

&НаСервере
Функция ПоместитьНомераЗаказовНаСервере()
	
	НомераЗаказовТаблицаЗначений = ДанныеФормыВЗначение(НомераЗаказов,Тип("ТаблицаЗначений"));
	
	Возврат ПоместитьВоВременноеХранилище(НомераЗаказовТаблицаЗначений.ВыгрузитьКолонку("НомерЗаказа"), Новый УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПоДиапазону(Команда)
	
	Если ПустаяСтрока(ПервыйНомер) Тогда
		ПервыйНомерЧисло = 0;
	Иначе
		ПервыйНомерЧисло = Число(ПервыйНомер);
	КонецЕсли;
	
	Если ПустаяСтрока(ПоследнийНомер) Тогда
		ПоследнийНомерЧисло = 0;
	Иначе
		ПоследнийНомерЧисло = Число(ПоследнийНомер);
	КонецЕсли;
	
	Если     ПервыйНомерЧисло = 0
		Или  ПоследнийНомерЧисло = 0
		Или (ПоследнийНомерЧисло < ПервыйНомерЧисло)
		Тогда
		Сообщить(Нстр("ru = 'Необходимо указать корректный диапазон номеров!'; en = 'You must specify the correct range of numbers!'"));
		Возврат;
	КонецЕсли;
	
	Если ПоследнийНомерЧисло - ПервыйНомерЧисло > 100 Тогда
		Сообщить(Нстр("ru = 'Диапазон должен содержать не более 100 номеров!'; en = 'The range of numbers must contain no more than 100 numbers!'"));
		Возврат;
	КонецЕсли;
	
	Если НомераЗаказов.Количество() > 0 Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоДиапазонуЗавершение", ЭтотОбъект),
		Нстр("ru = 'Очистить таблицу номеров заказов перед заполнением?'; en = 'Clear order number table before filling?'"), РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		ЗаполнитьТаблицуНомеровЗаказовПоДиапазону();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДиапазонуЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		НомераЗаказов.Очистить();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуНомеровЗаказовПоДиапазону();
	
	Сообщить(Нстр("ru = 'Заполнение выполнено.'; en = 'Completed'"));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуНомеровЗаказовПоДиапазону()
	
	ПервыйНомерЧисло    = Число(ПервыйНомер);
	ПоследнийНомерЧисло = Число(ПоследнийНомер);
	
	Счетчик = ПервыйНомерЧисло;
	
	Пока Счетчик <= ПоследнийНомерЧисло Цикл
		СчетчикСтрокой = Строка(Формат(Счетчик,"ЧГ=0"));
		
		КолВоЗнаковЧисло = СтрДлина(СчетчикСтрокой);
		Для нПрефикса = 1 По (9 - КолВоЗнаковЧисло) Цикл
			СчетчикСтрокой = "0" + СчетчикСтрокой;
		КонецЦикла;
		
		ЗаказНаЗаводСсылка = ПолучитьЗаказНаЗавод(СчетчикСтрокой);
		
		Если ЗаказНаЗаводСсылка.Пустая() Тогда
			Счетчик = Счетчик + 1;
			Продолжить;
		КонецЕсли;
		
		НайденныеСтроки = НомераЗаказов.НайтиСтроки(Новый Структура("ЗаказНаЗавод", ЗаказНаЗаводСсылка));
		Если НайденныеСтроки.Количество() = 0 Тогда
			НоваяСтрока = НомераЗаказов.Добавить();
			НоваяСтрока.ЗаказНаЗавод = ЗаказНаЗаводСсылка;
			НоваяСтрока.НомерЗаказа  = СчетчикСтрокой; 
		КонецЕсли;
		
		Счетчик = Счетчик + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗаказНаЗавод(НомерЗаказа)
	
	Возврат Справочники.Scan_ЗаказыНаЗавод.НайтиПоНаименованию(НомерЗаказа, Истина);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьИзБуфера(Команда)
	
	Если НомераЗаказов.Количество() > 0 Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьИзБуфераФрагмент", ЭтотОбъект),
		Нстр("ru = 'Очистить таблицу номеров заказов перед заполнением?'; en = 'Clear order number table before filling?'"), РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		ОткрытьФормуЗаполненияИзБуфера();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзБуфераФрагмент(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		НомераЗаказов.Очистить();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИзБуфераЗавершение();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзБуфераЗавершение()
	
	ОткрытьФормуЗаполненияИзБуфера();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЗаполненияИзБуфера()
	
	Обработчик = Новый ОписаниеОповещения("ЗаполнитьТаблицуНомеровЗаказовИзБуфера", ЭтотОбъект);
	
	ПараметрыЗаполнения = Новый Структура;
	ОткрытьФорму("Документ.Scan_ЗапросНаНадстройки.Форма.ФормаИмпорта", ПараметрыЗаполнения, ЭтотОбъект,,,, Обработчик, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуНомеровЗаказовИзБуфера(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого НомерИзБуфера Из РезультатЗакрытия Цикл
		НомерИзБуфераСтрокой = Строка(Формат(НомерИзБуфера,"ЧГ=0"));
		
		Попытка
			ЧислоСтроки = Число(НомерИзБуфераСтрокой);
			НомерЗаказаЧисло  = Истина;
		Исключение 
			НомерЗаказаЧисло  = Ложь;
		КонецПопытки;
		
		НомерЗаказа = НомерИзБуфераСтрокой;
		Если НомерЗаказаЧисло Тогда
			КолВоЗнаковЧисло = СтрДлина(НомерИзБуфераСтрокой);
			Для нПрефикса = 1 По (9 - КолВоЗнаковЧисло) Цикл
				НомерЗаказа = "0" + НомерЗаказа;
			КонецЦикла;
		КонецЕсли;
		
		ЗаказНаЗаводСсылка = ПолучитьЗаказНаЗавод(НомерЗаказа);
		
		Если ЗаказНаЗаводСсылка.Пустая() Тогда
			Продолжить;
		КонецЕсли;
		
		НайденныеСтроки = НомераЗаказов.НайтиСтроки(Новый Структура("ЗаказНаЗавод", ЗаказНаЗаводСсылка));
		Если НайденныеСтроки.Количество() = 0 Тогда
			НоваяСтрока = НомераЗаказов.Добавить();
			НоваяСтрока.ЗаказНаЗавод = ЗаказНаЗаводСсылка;
			НоваяСтрока.НомерЗаказа  = НомерЗаказа;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура НомераЗаказовНомерЗаказаПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.НомераЗаказов.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ДанныеСтроки.ЗаказНаЗавод) Тогда
		ДанныеСтроки.НомерЗаказа = СокрЛП(ДанныеСтроки.ЗаказНаЗавод);
	Иначе
		ДанныеСтроки.НомерЗаказа = "";
	КонецЕсли;
	
КонецПроцедуры

