
//rarus agar 04.12.2020 16691 ++
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Продукт") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ИзделиеТС", Параметры.Продукт, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	КонецЕсли;
	
КонецПроцедуры
//rarus agar 04.12.2020 16691 --
