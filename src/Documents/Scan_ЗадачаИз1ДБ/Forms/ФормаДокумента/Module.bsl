// Rarus tenkam 28.06.2022 mantis 18726 АПК + (Стандартные области)
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Scan_СборСтатистики.Scan_ПриОткрытии("Документы", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	
КонецПроцедуры

// Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Код процедур и функций
#КонецОбласти
