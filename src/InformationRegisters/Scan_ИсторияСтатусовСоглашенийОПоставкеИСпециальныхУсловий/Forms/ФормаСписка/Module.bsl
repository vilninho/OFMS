&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//rarus vikhle 12.01.2021 mt 17056 +++
	Если НЕ Окно = Неопределено Тогда
		Для Каждого ТекущееОкно Из Окно.Содержимое Цикл
			Если ТекущееОкно.ИмяФормы = "Справочник.Scan_СоглашенияОПоставке.Форма.ФормаЭлемента" Тогда
				СписокСвязанныхОбъектов = Scan_ВспомогательныеФункцииСервер.ПолучитьСтруктуруПодчиненности(ТекущееОкно.Объект.Ссылка, "Основание", Истина); //rarus vikhle 06.10.2021 mt 18076 + 2й параметр
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
				                                                                        "ОбъектСтатуса",
				                                                                        СписокСвязанныхОбъектов,
				                                                                        ВидСравненияКомпоновкиДанных.ВСписке);
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;
	//rarus vikhle 12.01.2021 mt 17056 ---
КонецПроцедуры

