//rarus tenkam 12.07.2017 mantis 10271 +++

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Объект.Ссылка = Справочники.Scan_КодыАдресовДоставки.PORTSTP Тогда
			Элементы.МестоХранения.Видимость = Ложь;
			МассивМестХранения = РегистрыСведений.Scan_СоответствиеКодовАдресовДоставки.ПолучитьМестоХранения(Объект.Ссылка);
			Для Каждого ТекМесто Из МассивМестХранения Цикл
				НовоеМесто = МестаХранения.Добавить();
				НовоеМесто.МестоХранения = ТекМесто;
			КонецЦикла;
		Иначе
			Элементы.МестаХранения.Видимость = Ложь;
			МестоХранения = РегистрыСведений.Scan_СоответствиеКодовАдресовДоставки.ПолучитьМестоХранения(Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;	
	Scan_СборСтатистики.Scan_ПриОткрытии("Справочники", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	

КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗначениеОтбора = Новый Структура("Маршрут", ЛОЖЬ);
	ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
	Результат = ОткрытьФорму("Справочник.Scan_МестаХранения.ФормаВыбора",ПараметрыФормы,Элементы.МестоХранения);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Если Объект.Ссылка = Справочники.Scan_КодыАдресовДоставки.PORTSTP Тогда
		Для Каждого ТекМесто Из МестаХранения Цикл
			РегистрыСведений.Scan_СоответствиеКодовАдресовДоставки.ЗаписатьСоответствие(ТекМесто.МестоХранения, ТекущийОбъект.Ссылка);
		КонецЦикла;
	Иначе
		РегистрыСведений.Scan_СоответствиеКодовАдресовДоставки.ЗаписатьСоответствие(МестоХранения, ТекущийОбъект.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	СообщениеОбОшибке = "";
	Если ТекущийОбъект.Ссылка = Справочники.Scan_КодыАдресовДоставки.PORTSTP Тогда
		Для Каждого ТекМесто Из МестаХранения Цикл
			Отказ = НЕ РегистрыСведений.Scan_СоответствиеКодовАдресовДоставки.ПроверитьКорректностьСоответствияПоКоду(ТекМесто.МестоХранения, ТекущийОбъект.Ссылка, СообщениеОбОшибке); 		
			Если Отказ Тогда
				Сообщить(СообщениеОбОшибке);
			КонецЕсли;	
		КонецЦикла;
	Иначе
		
		Отказ = НЕ РегистрыСведений.Scan_СоответствиеКодовАдресовДоставки.ПроверитьКорректностьСоответствияПоКоду(МестоХранения, ТекущийОбъект.Ссылка, СообщениеОбОшибке); 		
		Если Отказ Тогда
			Сообщить(СообщениеОбОшибке);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МестаХраненияМестоХраненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗначениеОтбора = Новый Структура("Маршрут", ЛОЖЬ);
	ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
	Результат = ОткрытьФорму("Справочник.Scan_МестаХранения.ФормаВыбора",ПараметрыФормы,Элементы.МестаХраненияМестоХранения);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Rarus tenkam 11.04.2022 mantis 18433 +++
	Если Объект.Ссылка.Пустая() Тогда
		Scan_СборСтатистики.Scan_ПередЗаписьюСправочника(РеквизитФормыВЗначение("Объект").Метаданные().Синоним, Истина, "Создание нового элемента");
	КонецЕсли;
	// Rarus tenkam 11.04.2022 mantis 18433 --- 
КонецПроцедуры

//rarus tenkam 12.07.2017 mantis 10271 ---