
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЭтаФорма.Элементы.Список.Отображение = ОтображениеТаблицы.Список;
КонецПроцедуры

//rarus agar 13.04.2021 17622 ++
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,"Родитель",ПредопределенноеЗначение("Справочник.Scan_МестаХранения.МестаХраненияАдресаКлиентов"), ВидСравненияКомпоновкиДанных.НеРавно, "Родитель", ,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,); // Rarus tenkam 08.11.2021 mantis 17140 +
	ОтображениеФиксированногоОтбора();
	
КонецПроцедуры

&НаСервере
Процедура ОтображениеФиксированногоОтбора()
	
	ПредставлениеОбъекта = Метаданные.Справочники.Scan_МестаХранения.ПредставлениеОбъекта;
	ПредставлениеОтбора  = Scan_ВспомогательныеФункцииСервер.ПолучитьПредставлениеОтбораФормыВыбора(ЭтотОбъект, ПредставлениеОбъекта);
	
	Если Не ПустаяСтрока(ПредставлениеОтбора) Тогда
		ФиксированныйОтборПредставление = ПредставлениеОтбора;
		
		Элементы.ФиксированныйОтборПредставление.Видимость = Истина;
		Элементы.ФиксированныйОтборПредставление.Высота    = СтрЧислоСтрок(ПредставлениеОтбора);
	КонецЕсли;
	
КонецПроцедуры
//rarus agar 13.04.2021 17622 --



