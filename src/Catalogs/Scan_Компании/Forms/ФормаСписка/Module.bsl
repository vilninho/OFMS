//rarus tenkam 18.10.2016 mantis 6897 ++
&НаСервере
Процедура ОбновитьДилеровНаСервере()
	//rarus bonmak 15.04.2020 14456 ++
	//ИмяМетода = "GetListOfDealers";
	//СообщениеОбОшибке = "";
	//Отказ = Ложь;
	//СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода);
	//ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
	////ТекЭлементЗапрос = Scan_ВебСервисы.СформироватьСообщениеОбмена(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации); 
	//ТекЭлементОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации);
	//Если НЕ Отказ Тогда
	//	СсылкаЭлемента = Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникДилеры(ТекЭлементОтвет,Отказ,СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации,ИмяМетода);
	//КонецЕсли;
	ВыборкаСправочника = Справочники.Scan_ВидыВзаимодействий.Выбрать();
	Пока ВыборкаСправочника.Следующий() Цикл
		Если НЕ ПустаяСтрока(ВыборкаСправочника.IDExternalSystem) Тогда
			ДопПараметры = Новый Структура;
			ДопПараметры.Вставить("ВидВзаимодействия", ВыборкаСправочника.IDExternalSystem);
			Scan_ВебСервисыРазборОтветов.ВызватьМетод_GetListOfCompany(ДопПараметры);
		КонецЕсли;
	КонецЦикла;
	//rarus bonmak 15.04.2020 14456 --
	Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДилеров(Команда)
	ОбновитьДилеровНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УправлениеДиалогомНаСервере();
КонецПроцедуры

//rarus vikhle 07.05.2020 mt 15695 +++
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Scan_ВспомогательныеФункцииКлиент.ПроверитьПользователяПортала();
КонецПроцедуры
//rarus vikhle 07.05.2020 mt 15695 ---


&НаСервере
Процедура УправлениеДиалогомНаСервере()
	Элементы.ФормаГруппаИнтеграция.Видимость = Scan_ПраваИНастройки.Scan_Право("ОбменСПредставительством");
КонецПроцедуры


//rarus tenkam 18.10.2016 mantis 6897 --