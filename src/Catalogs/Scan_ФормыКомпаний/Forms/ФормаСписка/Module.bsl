&НаСервере
Процедура ОбновитьЭлементНаСервере() 
	//rarus BProg_Dekin 18.02.2020 mantis 0014456 ++
	ИмяМетода 			= "GetListOfCompanyType";
	СообщениеОбОшибке 	= "";
	Отказ 				= Ложь;
	СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода);
	
	ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
	ТекстОтвета = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации);
	Если НЕ Отказ Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникФормыКомпаний(ТекстОтвета, Отказ, СообщениеОбОшибке, ИмяСобытияЖурналаРегистрации, ИмяМетода);
	КонецЕсли;
	Элементы.Список.Обновить();
	//rarus BProg_Dekin 18.02.2020 mantis 0014456 --
КонецПроцедуры 

&НаКлиенте
Процедура ОбновитьЭлемент(Команда) //rarus bonmak 04.12.2019 14456 ++
	ОбновитьЭлементНаСервере();
КонецПроцедуры //rarus bonmak 04.12.2019 14456 --
