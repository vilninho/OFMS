//rarus BProg_Dekin 31.10.2019 mantis 0014452 +- Добалена форма.

#Область ОбработчикиСобытийФормы 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбъектКлючевойДаты = Перечисления.Scan_ОбъектыКлючевыхДат.ЗаказНаЗавод;
	НастройкиИзРегистра = РегистрыСведений.Scan_НастройкиКлючевыхДатЗаказаНаЗаводПоГруппамДат.ПолучитьНастройки(Перечисления.Scan_ОбъектыКлючевыхДат.ЗаказНаЗавод);
	НастройкиКлючевыхДат.Загрузить(НастройкиИзРегистра);
	
	Scan_СборСтатистики.Scan_ПриОткрытииФормы(ЭтотОбъект.ИмяФормы); // Rarus tenkam 11.04.2022 mantis 18433 +

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы 

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ЗаписатьИЗакрытьПослеПодтверждения();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьПослеПодтверждения", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьПослеПодтверждения(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	Отказ = Ложь;
	ЗаписатьНаСервере(Отказ);
	
	Если НЕ Отказ тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере(Отказ)
	Для Каждого Строка Из НастройкиКлючевыхДат Цикл
		Отказ = РегистрыСведений.Scan_НастройкиКлючевыхДатЗаказаНаЗаводПоГруппамДат.ЗаписьЗначенияРегистраСведения(Строка.КлючеваяДата, Строка);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
