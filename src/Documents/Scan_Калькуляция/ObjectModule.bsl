
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Scan_Калькуляция") Тогда
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		
		ХозОперация = ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.РасчетОтПрайсЛиста");
		
		//rarus agar 26.10.2020 15690 ++
		// Закомментировал, т.к. для вводимого на основании документа ХО - Расчет от прайс-листа
		// Группа ГруппаПараметрыПрайсЛиста не отображается
		//ИдентификаторПрайсЛиста = ДанныеЗаполнения.ИдентификаторПрайсЛиста;
		//НаименованиеПрайсЛиста  = ДанныеЗаполнения.НаименованиеПрайсЛиста;
		//ДействуетСДаты          = ДанныеЗаполнения.ДействуетСДаты;
		//ДействуетСPartPeriod    = ДанныеЗаполнения.ДействуетСPartPeriod;
		//rarus agar 26.10.2020 15690 --
		
		НерасчетныеСоставляющие.Загрузить(ДанныеЗаполнения.НерасчетныеСоставляющие.Выгрузить());
		РасчетныеСоставляющие.Загрузить(ДанныеЗаполнения.РасчетныеСоставляющие.Выгрузить());
		СтандартныеСпецификации.Загрузить(ДанныеЗаполнения.СтандартныеСпецификации.Выгрузить());
	Иначе
		ХозОперация = ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ИзменениеСтатейПрайсЛиста");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ДействуетСPartPeriod) Тогда 
		Отказ = РегистрыСведений.Scan_ИнформацияПоPartPeriod.ПроверитьПартПериод(ДействуетСPartPeriod);
		Если Отказ Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	//rarus agar 14.05.2020  15466 Доп1 ++
	Если  ЗначениеЗаполнено(ДействуетСДаты)
		И ЗначениеЗаполнено(ДействуетСPartPeriod)
		И Не Scan_ЦенообразованиеСервер.ДатаСоответствуетPartPeriod(ДействуетСДаты, ДействуетСPartPeriod) 
		Тогда
		Сообщить(НСтр("ru = 'Указанный Part Period не соответствует дате начала действия'; en = 'The Part Period does not match the From Date'"));
		Отказ = Истина;
	КонецЕсли;
	//rarus agar 14.05.2020  15466 Доп1 --
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ПометкаУдаления Тогда
		Статус = ПредопределенноеЗначение("Справочник.Scan_СтатусыКалькуляций.РасчетАннулирован");
	КонецЕсли;
	
КонецПроцедуры
