
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Scan_Калькуляция") Тогда
		ДокументОснование       = ДанныеЗаполнения.Ссылка;
		ИдентификаторПрайсЛиста = ДанныеЗаполнения.ИдентификаторПрайсЛиста;
		НаименованиеПрайсЛиста  = ДанныеЗаполнения.НаименованиеПрайсЛиста;
		ДатаВступленияВСилу     = ДанныеЗаполнения.ДействуетСДаты;
	КонецЕсли;
	
КонецПроцедуры
