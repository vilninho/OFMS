//rarus tenkam 26.09.2016 mantis 6897 ++
&НаСервере
Процедура ОбновитьГруппыНаСервере()
	ИмяМетода = "GetListOfProductGroup";
	СообщениеОбОшибке = "";
	Отказ = Ложь;
	СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода);
	ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
	//ТекЭлементЗапрос = Scan_ВебСервисы.СформироватьСообщениеОбмена(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации); 
	ТекЭлементОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации);
	Если НЕ Отказ Тогда
		СсылкаПродукта = Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникГруппыПродуктов(ТекЭлементОтвет,Отказ,СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации,ИмяМетода);
	КонецЕсли;
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппы(Команда)
	ОбновитьГруппыНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УправлениеДиалогомНаСервере();
КонецПроцедуры

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	Элементы.ФормаГруппаИнтеграция.Видимость = Scan_ПраваИНастройки.Scan_Право("ОбменСПредставительством");
КонецПроцедуры
//rarus tenkam 26.09.2016 mantis 6897 --