
//rarus agar 13.04.2021 17622 ++
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтображениеФиксированногоОтбора();
	
КонецПроцедуры

&НаСервере
Процедура ОтображениеФиксированногоОтбора()
	
	ПредставлениеОбъекта = Метаданные.Справочники.Scan_ВидыТахографов.ПредставлениеОбъекта;
	ПредставлениеОтбора  = Scan_ВспомогательныеФункцииСервер.ПолучитьПредставлениеОтбораФормыВыбора(ЭтотОбъект, ПредставлениеОбъекта);
	
	Если Не ПустаяСтрока(ПредставлениеОтбора) Тогда
		ФиксированныйОтборПредставление = ПредставлениеОтбора;
		
		Элементы.ФиксированныйОтборПредставление.Видимость = Истина;
		Элементы.ФиксированныйОтборПредставление.Высота    = СтрЧислоСтрок(ПредставлениеОтбора);
	КонецЕсли;
	
КонецПроцедуры
//rarus agar 13.04.2021 17622 --