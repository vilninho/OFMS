
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтображениеФиксированногоОтбора(); //rarus vikhle 11.11.2021 18471 +++
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//rarus vikhle 11.11.2021 18471 +++
&НаСервере
Процедура ОтображениеФиксированногоОтбора()
	
	ПредставлениеОбъекта = Метаданные.Справочники.Scan_КоммерческиеПредложения.ПредставлениеОбъекта;
	ПредставлениеОтбора  = Scan_ВспомогательныеФункцииСервер.ПолучитьПредставлениеОтбораФормыВыбора(ЭтотОбъект, ПредставлениеОбъекта);
	
	Если Не ПустаяСтрока(ПредставлениеОтбора) Тогда
		ФиксированныйОтборПредставление = ПредставлениеОтбора;
		
		Элементы.ФиксированныйОтборПредставление.Видимость = Истина;
		Элементы.ФиксированныйОтборПредставление.Высота    = СтрЧислоСтрок(ПредставлениеОтбора);
	КонецЕсли;
	
КонецПроцедуры
//rarus vikhle 11.11.2021 18471 ---

#КонецОбласти