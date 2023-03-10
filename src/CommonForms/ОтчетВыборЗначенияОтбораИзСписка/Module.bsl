
&НаКлиенте
Процедура КомандаОк(Команда)
	
	Закрыть(СписокЗначений);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ТипЗначения") Тогда
		Возврат;
	КонецЕсли;
	ЭтотОбъект.СписокЗначений.ТипЗначения       = Параметры.ТипЗначения;
	ЭтотОбъект.СписокЗначений.ДоступныеЗначения = Параметры.ДоступныеЗначения;
	Если ТипЗнч(Параметры.СписокВыбора) = Тип("СписокЗначений") Тогда
		ЭтотОбъект.СписокЗначений.ЗагрузитьЗначения(Параметры.СписокВыбора.ВыгрузитьЗначения());
	ИначеЕсли ЗначениеЗаполнено(Параметры.СписокВыбора) Тогда
		ЭтотОбъект.СписокЗначений.Добавить(Параметры.СписокВыбора);
	КонецЕсли;
	ТолькоГруппы                              = Параметры.ТолькоГруппы;
	
	МассивТипов = Параметры.ТипЗначения.Типы();
	Если МассивТипов.Количество()> 0 Тогда
		Если МассивТипов[0] = Тип("Строка") Тогда
			Элементы.СписокЗначенийЗначение.КнопкаВыбора = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗначенийЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ТолькоГруппы Тогда
		Элемент.ВыборГруппИЭлементов = ГруппыИЭлементы.Группы;
	КонецЕсли;
	
КонецПроцедуры
