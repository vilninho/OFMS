&НаСервере
Процедура ОбновитыТипыНаСервере()
	ИмяМетода = "GetListOfProductTypeSPORT";
	СообщениеОбОшибке = "";
	Отказ = Ложь;
	СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода);
	ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
	ТекЭлементОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации);
	Если НЕ Отказ Тогда
		СсылкаПродукта = Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникТипыПродуктовКПSPORT(ТекЭлементОтвет,Отказ,СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации,ИмяМетода);
	КонецЕсли;
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитыТипы(Команда)
	ОбновитыТипыНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УправлениеДиалогомНаСервере();
КонецПроцедуры

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
КонецПроцедуры