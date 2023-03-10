
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Продукт            = Параметры.Продукт;
	ОбъектКлючевойДаты = ПредопределенноеЗначение("Перечисление.Scan_ОбъектыКлючевыхДат.Изделие");
	
	ЗаполнитьСписокВыбораВидаКлючевойДаты();
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Если ЗначениеЗаполнено(НовоеЗначение) Тогда
		ЗаписатьНаСервере();
	Иначе
		ТекущееЗначение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	ЕстьОшибки = РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЗаписьЗначенияРегистраСведения(Продукт, ОбъектКлючевойДаты, НовоеЗначение, ВидКлючевойДаты);
	
	Если Не ЕстьОшибки Тогда
		ВидКлючевойДатыПриИзмененииНаСервере();
		НовоеЗначение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораВидаКлючевойДаты()
	
	ДоступныеКлючевыеДаты = Новый Массив;
	
	КлючевыеДатыПродукта = Перечисления.Scan_КлючевыеДаты.ПолучитьМассивПеречисленийПоОбъекту(ОбъектКлючевойДаты);
	
	Для Каждого КлючеваяДатаПродукта Из КлючевыеДатыПродукта Цикл
		Если КлючеваяДатаПродукта = ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты.ПродуктВАрхиве") Тогда
			Если Scan_ПраваИНастройки.Scan_Право("РазрешатьРедактироватьДатуПродуктВАрхиве") Тогда
				ДоступныеКлючевыеДаты.Добавить(КлючеваяДатаПродукта);
			КонецЕсли;
		Иначе
			Если    КлючеваяДатаПродукта = ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты.ДатаПередачиБУИзделияДилеру") 
				Или КлючеваяДатаПродукта = ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты.ДатаПоступленияИзделияНаСклад")
				Или КлючеваяДатаПродукта = ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты.ДатаПоступленияИзделияБУНаСклад") 
				Тогда
			Иначе
				ДоступныеКлючевыеДаты.Добавить(КлючеваяДатаПродукта);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ВидКлючевойДаты.СписокВыбора.ЗагрузитьЗначения(ДоступныеКлючевыеДаты);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидКлючевойДатыПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ВидКлючевойДаты) Тогда
		ВидКлючевойДатыПриИзмененииНаСервере();
	Иначе
		ТекущееЗначение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВидКлючевойДатыПриИзмененииНаСервере()
	
	ТекущееЗначение = РегистрыСведений.Scan_КлючевыеДатыПроцессов.КлючеваяДата(Продукт, ВидКлючевойДаты);
	
КонецПроцедуры