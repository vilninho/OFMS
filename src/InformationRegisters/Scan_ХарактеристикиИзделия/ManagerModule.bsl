
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	#Область ПрограммныйИнтерфейс
	
	// Процедура - Обработать данные для order intake
	//
	// Параметры:
	//  ТаблицаЗаписей	 - ТаблицаЗначений	 - 
	//  Период			 - Дата	 - 
	//
	Процедура ОбработатьДанныеДляOrderIntake(ТаблицаЗаписей, Период = Неопределено) Экспорт
		
		АльтернативныйРасчет = Scan_ПраваИНастройки.Scan_Право("ИспользоватьАльтернативныйРасчетДатOrderIntake");
		Если АльтернативныйРасчет Тогда
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("П1", ТаблицаЗаписей);
			Запрос.Текст = "ВЫБРАТЬ
			|	ТаблицаНабораЗаписей.Период КАК Период,
			|	ВЫРАЗИТЬ(ТаблицаНабораЗаписей.Значение КАК Справочник.Scan_ЛокальныеСтатусыПродуктов) КАК ЛокальныйСтатусПродукта,
			|	ТаблицаНабораЗаписей.Изделие КАК Продукт
			|ПОМЕСТИТЬ ВТ_ЛокальныйСтатусПродукта
			|ИЗ
			|	&П1 КАК ТаблицаНабораЗаписей
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВТ_ЛокальныйСтатусПродукта.Период КАК Период,
			|	ВТ_ЛокальныйСтатусПродукта.ЛокальныйСтатусПродукта КАК ЛокальныйСтатусПродукта,
			|	ВТ_ЛокальныйСтатусПродукта.Продукт КАК Продукт
			|ИЗ
			|	ВТ_ЛокальныйСтатусПродукта КАК ВТ_ЛокальныйСтатусПродукта";
			РезультатЗапроса = Запрос.Выполнить();
			
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Следующий() Тогда
				Если Выборка.ЛокальныйСтатусПродукта = ПредопределенноеЗначение("Справочник.Scan_ЛокальныеСтатусыПродуктов.DELETED") Тогда
					Scan_OrderIntake.ЗарегистрироватьЛокальныйCтатусПродуктаDELETED(Выборка.Период,, Выборка.Продукт);
				Иначе
					Scan_OrderIntake.ЗарегистрироватьЛокальныйCтатусПродуктаНеDELETED(Выборка.Период,, Выборка.Продукт);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецПроцедуры
	
	#КонецОбласти
	
#Иначе
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли