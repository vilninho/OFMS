Процедура УдалитьВсеЭлементыСправочникаПоВладельцу(Владелец) Экспорт //rarus BProg_Dekin 18.03.2020 mantis 0014177 +-
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.Текст = "ВЫБРАТЬ Ссылка ИЗ Справочник.Scan_ИерархияОпцийПредставленийСпецификации ГДЕ Владелец = &Владелец";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектДляУдаления = Выборка.Ссылка.ПолучитьОбъект();
		Если ОбъектДляУдаления = Неопределено Тогда
			Продолжить;	
		КонецЕсли;
		
		ОбъектДляУдаления.Удалить();
	КонецЦикла;
КонецПроцедуры