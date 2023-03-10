// Rarus tenkam 28.06.2022 mantis 18726 АПК + (Стандартные области)
#Область ОбработчикиСобытийФормы

// rarus tenkam 19.03.2019 mantis 13629 +++

////// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УправлениеДиалогомНаСервере();
	
	ТекДатаНачала = НачалоДня(ТекущаяДата());
	ТекДатаОкончания = КонецДня(ТекущаяДата());
	ПериодОтборОтправка.ДатаНачала = ТекДатаНачала;
	ПериодОтборОтправка.ДатаОкончания = ТекДатаОкончания;
	ПериодОтборПолучение.ДатаНачала = ТекДатаНачала;
	ПериодОтборПолучение.ДатаОкончания = ТекДатаОкончания;
	
	УстановитьОтборСписка(ТекДатаНачала, ТекДатаОкончания);
	
	// rarus tenkam 08.04.2019 mantis 14308 +++
	ЗаполнитьНастройкиПроверкиМетодов();
	// rarus tenkam 08.04.2019 mantis 14308 ---
	Scan_СборСтатистики.Scan_ПриОткрытииОбработки(РеквизитФормыВЗначение("Объект").Метаданные().Синоним); // Rarus tenkam 11.04.2022 mantis 18433 +

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ

&НаКлиенте
Процедура ВидЗапросаПриИзменении(Элемент)
	ИмяМетода = ПолучитьИмяПеречисления(ВидЗапроса);
	//rarus agar 13.03.2021 17373 ++
	//rarus agar 15.10.2020 15696 ++
	//Запрос1СДО = ВидЗапроса1СДО(ВидЗапроса);
	СтруктураВидЗапроса = ВидЗапроса1СДОПортала(ВидЗапроса);
	Запрос1СДО    = СтруктураВидЗапроса.Запрос1СДО;
	ЗапросПортала = СтруктураВидЗапроса.ЗапросПортала;
	//rarus agar 15.10.2020 15696 --
	//rarus agar 13.03.2021 17373 --
	ОбновитьТаблицуДополнительныхПолей();	
	УправлениеДиалогомНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьМетодПриИзменении(Элемент)
	УправлениеДиалогомНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	ТипПоля = ПолучитьТипПоля(Элементы.ДополнительныеПоля.ТекущиеДанные.Поле);
	
	Элемент.ПодчиненныеЭлементы.ДополнительныеПоляЗначение.ВыбиратьТип = Ложь;
	Элемент.ПодчиненныеЭлементы.ДополнительныеПоляЗначение.ОграничениеТипа = ТипПоля;
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтборОтправкаПриИзменении(Элемент)
	ДатаНачала = ?(ЗначениеЗаполнено(ПериодОтборОтправка.ДатаНачала), НачалоДня(ПериодОтборОтправка.ДатаНачала), Дата('00010101'));
	ДатаОкончания = ?(ЗначениеЗаполнено(ПериодОтборОтправка.ДатаОкончания), КонецДня(ПериодОтборОтправка.ДатаОкончания), Дата('39991231'));
	УстановитьОтборСписка(ДатаНачала, ДатаОкончания, Ложь, Истина)
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтборПриИзменении(Элемент)
	ДатаНачала = ?(ЗначениеЗаполнено(ПериодОтборПолучение.ДатаНачала), НачалоДня(ПериодОтборПолучение.ДатаНачала), Дата('00010101'));
	ДатаОкончания = ?(ЗначениеЗаполнено(ПериодОтборПолучение.ДатаОкончания), КонецДня(ПериодОтборПолучение.ДатаОкончания), Дата('39991231'));
	УстановитьОтборСписка(ДатаНачала, ДатаОкончания, Истина, Ложь)
КонецПроцедуры

// rarus tenkam 08.04.2019 mantis 14308 +++
&НаКлиенте
Процедура ПроверятьПриИзменении(Элемент)
	ТекДанные = Элементы.НастройкиПроверкиМетодов1БД.ТекущиеДанные;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ВидЗапроса", ТекДанные.ВидЗапроса);
	СтруктураДанных.Вставить("Проверять", ТекДанные.Проверять);

	ОбновитьНастройкуПроверкиВРегистре(СтруктураДанных);
КонецПроцедуры
// rarus tenkam 08.04.2019 mantis 14308 ---

#КонецОбласти

#Область ОбработчикиКомандФормы

////// КОМАНДЫ

&НаКлиенте
Процедура ОбновитьНастройкиПроверки(Команда) // rarus tenkam 08.04.2019 mantis 14308 +
	ЗаполнитьНастройкиПроверкиМетодов();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗапрос(Команда)
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		СтруктураПараметров = Новый Структура;
		Для Каждого СтрокаДопПолей Из ДополнительныеПоля Цикл
			СтруктураПараметров.Вставить(СтрокаДопПолей.Поле, СтрокаДопПолей.Значение);
		КонецЦикла;
		Отказ = Ложь;
		
		//rarus agar 15.10.2020 15696 ++
		Если Запрос1СДО Тогда
			ТекДокЗапрос = СформироватьТекстЗапроса1СДО(ИмяМетода, СтруктураПараметров);
		//rarus agar 13.03.2021 17373 ++
		ИначеЕсли ЗапросПортала Тогда
			ТекДокЗапрос = СформироватьТекстЗапросаПортала(ИмяМетода, СтруктураПараметров);
		//rarus agar 13.03.2021 17373 --
		Иначе
			СообщениеОбмена = Scan_ВебСервисы.СформироватьСообщениеОбмена(ИмяМетода, СтруктураПараметров, Отказ, "Веб-сервис." + ИмяМетода);
			ТекДокЗапрос = СообщениеОбмена;
			
			// rarus tenkam 24.09.2020 mantis 16181 +++
			Если (ИмяМетода = "CreateSOP" ИЛИ ИмяМетода = "SetSOP") И СтруктураПараметров.Свойство("КодДоговора") И ЗначениеЗаполнено(СтруктураПараметров.КодДоговора) Тогда
				ТекДокЗапрос = СформироватьТекстCreateSetSOP(СтруктураПараметров.КодДоговора, ИмяМетода);			
			ИначеЕсли ИмяМетода = "SetSOP" Тогда
				
			КонецЕсли;
			// rarus tenkam 24.09.2020 mantis 16181 ---
		КонецЕсли;
		//rarus agar 15.10.2020 15696 --
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОтвет(Команда)
	Отказ = Ложь;

	Если ИспользоватьМетод Тогда
		Если ЗначениеЗаполнено(ИмяМетода) Тогда
			СтруктураПараметров = Новый Структура;
			Для Каждого СтрокаДопПолей Из ДополнительныеПоля Цикл
				СтруктураПараметров.Вставить(СтрокаДопПолей.Поле, СтрокаДопПолей.Значение);
			КонецЦикла;
			
			//rarus agar 15.10.2020 15696 ++
			Если Запрос1СДО Тогда
				ТекДокОтвет = ВызватьМетод1СДО(ИмяМетода, СтруктураПараметров);
			//rarus agar 13.03.2021 17373 ++
			ИначеЕсли ЗапросПортала Тогда
				ТекДокОтвет = ВызватьМетодПортала(ИмяМетода, СтруктураПараметров);
			//rarus agar 13.03.2021 17373 --
			Иначе
				ТекДокОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, Отказ, "Веб-сервис." + ИмяМетода, ТекДокЗапрос); 
			КонецЕсли;
			//rarus agar 15.10.2020 15696 --
		КонецЕсли;
	Иначе
		ТекДокОтвет = Scan_ВебСервисы.ВызватьМетод("Неопределено", СтруктураПараметров, Отказ, "Веб-сервис." + ИмяМетода, ТекДокЗапрос);		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура РазобратьОтветТестНаСервере()
	Если СокрЛП(ТекДокОтвет) = "" Тогда
		Возврат;
	КонецЕсли;
	Отказ = Ложь;	
	СообщениеОбОшибке = "";
	Если ИмяМетода = "GetListOfProductMark" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникМаркиПродуктов(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);	
	ИначеЕсли ИмяМетода = "GetProductMark" Тогда 
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникМаркиПродуктов(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);	
	ИначеЕсли ИмяМетода = "GetListOfProductGroup" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникГруппыПродуктов(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetProductGroup" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникГруппыПродуктов(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetListOfProductType" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникВидыПродуктов(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);	
	ИначеЕсли ИмяМетода = "GetProductType" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникВидыПродуктов(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);	
	ИначеЕсли ИмяМетода = "GetListOfProductSubType" Тогда
		// rarus tenkam 19.09.2019 mantis 14442 +++
		//Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникТипыПродуктов(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникТипы(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
		// rarus tenkam 19.09.2019 mantis 14442 ---	
	ИначеЕсли ИмяМетода = "GetProductSubType" Тогда
		// rarus tenkam 19.09.2019 mantis 14442 +++
		//Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникТипыПродуктов(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникТипы(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
		// rarus tenkam 19.09.2019 mantis 14442 ---	
	//rarus bonmak 14.04.2020 15891 ++
	//ИначеЕсли ИмяМетода = "GetListOfManufacturers" Тогда
	//	Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникПроизводителиМарок(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	//ИначеЕсли ИмяМетода = "GetManufacturers" Тогда
	//	Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникПроизводителиМарок(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	//rarus bonmak 14.04.2020 15891 --
	ИначеЕсли ИмяМетода = "GetListOfProductModel" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникМоделиПродуктов(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetProductModel" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникМоделиПродуктов(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetListOfChassis" Тогда
		//rarus bonmak 09.08.2021 16834 Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникИзделия(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetChassis" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтвета_GetChassis(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetListOfEngines" Тогда
		//rarus bonmak 09.08.2021 16834 Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникИзделия(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetEngines" Тогда
		//rarus bonmak 09.08.2021 16834 Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникИзделия(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	//rarus bonmak 15.04.2020 14456 ++	
	//ИначеЕсли ИмяМетода = "GetListOfDealers" Тогда
	//	Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникДилеры(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	//ИначеЕсли ИмяМетода = "GetDealers" Тогда
	//	Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникДилеры(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetCompany" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаКомпании(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	//rarus bonmak 15.04.2020 14456 --
	ИначеЕсли ИмяМетода = "GetListOfContragents" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникКонтрагенты(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);	
	ИначеЕсли ИмяМетода = "GetContragents" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникКонтрагенты(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);	
	ИначеЕсли ИмяМетода = "GetListOfProduct" Тогда
		//rarus bonmak 09.08.2021 16834 Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникПродукты(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetProduct" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтвета_GetProduct(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetListOfCommercialOffers" Тогда
	ИначеЕсли ИмяМетода = "GetProductCommercialOffers" Тогда
	ИначеЕсли ИмяМетода = "GetListOfOrderToDelivery" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникЗаказыНаЗавод(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);	
	ИначеЕсли ИмяМетода = "GetOrderToDelivery" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникЗаказыНаЗавод(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);	
	// rarus tenkam 09.09.2019 mantis 14841 +++	
	//ИначеЕсли ИмяМетода = "GetListOfSpecifications" Тогда
	//	Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникСпецификацииПродуктов(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetSpecification" Тогда //rarus bonmak 08.10.2019 14177 ++
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникВерсииСпецификацииПродуктов(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);	
		//rarus bonmak 08.10.2019 14177 --
		// rarus tenkam 09.09.2019 mantis 14841 ---	
	ИначеЕсли ИмяМетода = "GetListOfStatuses" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникЗаводскиеСтатусы(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetListOfSOP" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникДоговорыВзаиморасчетовСОП(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);	
	ИначеЕсли ИмяМетода = "GetSOP" Тогда
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникДоговорыВзаиморасчетовСОП(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);	
	ИначеЕсли ИмяМетода = "GetListOfCompanyType" Тогда //rarus BProg_Dekin 18.02.2020 mantis 0014456 +-
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникФормыКомпаний(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetListOfCompanyGroup" Тогда //rarus BProg_Dekin 18.02.2020 mantis 0014456 +-
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникГруппыКомпаний(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetListOfDealerType" Тогда //rarus BProg_Dekin 18.02.2020 mantis 0014456 +-
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникТипыДилеров(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetListOfCooperationType" Тогда //rarus BProg_Dekin 18.02.2020 mantis 0014456 +-
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникВидыВзаимодействий(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetListOfSpecificationViewType" Тогда //rarus BProg_Dekin 16.03.2020 mantis 0014177 +-
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникВидыПредставленийСпецификаций(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetListOfSpecificationView" Тогда //rarus BProg_Dekin 16.03.2020 mantis 0014177 +-
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникПредставленияСпецификаций(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
	ИначеЕсли ИмяМетода = "GetSpecificationView" Тогда //rarus BProg_Dekin 16.03.2020 mantis 0014177 +-
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникИерархияОпцийПредставленийСпецификации(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);
		//rarus ozhnik 15888 10.06.2020 + 
	ИначеЕсли ИмяМетода = "GetListOfRegions" Тогда //rarus bonmak 07.01.2021 16625 ++
		Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникРегионы(ТекДокОтвет, Отказ, СообщениеОбОшибке, "Веб-сервис." + ИмяМетода, ИмяМетода);	
	//rarus bonmak 07.01.2021 16625 --	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазобратьОтветТест(Команда)
	РазобратьОтветТестНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗапрос(Команда)
	Если Не ЗначениеЗаполнено(ВидЗапроса) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Вид запроса не заполнен'; en = 'Empty field'");
		Сообщение.Поле = "ВидЗапроса";
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	Scan_ВебСервисыПроверкаМетодов.ПроверитьМетод(ВидЗапроса);
	Элементы.ПроверкаМетодовОбменаС1БД.Обновить();
КонецПроцедуры

//// Обновление списков

&НаКлиенте
Процедура ОбновитьПолучения(Команда)
	Элементы.НезагруженныеОбъекты.Обновить();
	Элементы.РегистрацияОбмена1БД.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	Элементы.ОтправленныеСобытия.Обновить();
	Элементы.НеотправленныеСобытия.Обновить();
	//Элементы.ДанныеДляОтправки.Обновить(); //rarus bonmak 09.08.2021 16834 
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции


///// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ И ПРОЦЕДУРЫ

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	//Если ИспользоватьМетод Тогда
	//Элементы.ГруппаСтраницы.ТекущаяСтраница = ?(ИспользоватьМетод, Элементы.ГруппаПоля, Элементы.ГруппаЗапрос);
	Элементы.ВидЗапроса.Доступность = ИспользоватьМетод;
	Элементы.ГруппаДопПоля.Видимость = ИспользоватьМетод;
	//Элементы.ТекДокЗапрос.ТолькоПросмотр = ИспользоватьМетод;
	//rarus agar 15.10.2020 15696 ++
	//Элементы.ПроверитьЗапрос.Доступность = ИспользоватьМетод;
	//Элементы.ПроверитьЗапрос.Доступность = ИспользоватьМетод И Не ВидЗапроса.Запрос1СДО;
	Элементы.ПроверитьЗапрос.Доступность = ИспользоватьМетод И Не ВидЗапроса.Запрос1СДО И Не ВидЗапроса.ЗапросПортала; //rarus agar 13.03.2021 17373 +- 
	//rarus agar 15.10.2020 15696 --
	Элементы.СформироватьЗапрос.Доступность = ИспользоватьМетод;
	//rarus agar 15.10.2020 15696 ++
	//Элементы.РазобратьОтветТест.Доступность = ИспользоватьМетод;
	//Элементы.РазобратьОтветТест.Доступность = ИспользоватьМетод И Не ВидЗапроса.Запрос1СДО;
	Элементы.РазобратьОтветТест.Доступность = ИспользоватьМетод И Не ВидЗапроса.Запрос1СДО И Не ВидЗапроса.ЗапросПортала; //rarus agar 13.03.2021 17373 +- 
	//rarus agar 15.10.2020 15696 --
	
	ТекДокЗапрос = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТаблицуДополнительныхПолей() 
	ДополнительныеПоля.Очистить();
	ЭтоСписок = (СтрНайти(ИмяМетода, "ListOf") <> 0);
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров = ПолучитьСтруктуру(ИмяМетода, ЭтоСписок);
	
	Для Каждого ЭлементСтруктуры Из СтруктураПараметров Цикл
		НоваяСтрока = ДополнительныеПоля.Добавить();
		НоваяСтрока.Поле = ЭлементСтруктуры.Ключ;
	
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТипПоля(Поле)
	
	Если Поле = "DeletionMark" Тогда
		ТипПоля = Новый ОписаниеТипов("Булево");
	ИначеЕсли Поле = "ДатаИзменения" ИЛИ Поле = "ДатаНачала" ИЛИ Поле = "ДатаОкончания" ИЛИ 
		Поле = "ДатаСобытия" ИЛИ Поле = "ДатаОкончанияОСАГО" ИЛИ Поле = "СрокУстраненияНедостатковДата" ИЛИ
		Поле = "DD" ИЛИ Поле = "DD2" ИЛИ Поле = "DDS" ИЛИ Поле = "Период" Тогда	// rarus tenkam 28.04.2021 mantis 17659 +
		
		ТипПоля = Новый ОписаниеТипов("Дата");
	ИначеЕсли  Поле = "СрокУстранениеНедостатковДни" Тогда
		ТипПоля = Новый ОписаниеТипов("Число");	
	Иначе
		ТипПоля = Новый ОписаниеТипов("Строка");
	КонецЕсли;
	
	Возврат ТипПоля;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСтруктуру(ИмяМетодаWS, ЭтоСписок)	
	СтруктураНовая = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетодаWS, ЭтоСписок);
	Возврат СтруктураНовая;
КонецФункции

&НаСервереБезКонтекста
//Получает текстовое наименование справочника
Функция ПолучитьИмяПеречисления(ВидЗапроса)
	Если ЗначениеЗаполнено(ВидЗапроса) Тогда
		//rarus bonmak 21.08.2020 16210 ++
		//ЗначениеПеречисления = ВидЗапроса;		
		//ИмяПеречисления = ЗначениеПеречисления.Метаданные().Имя;		
		//ИндексЗначенияПеречисления = Перечисления[ИмяПеречисления].Индекс(ЗначениеПеречисления);		
		//ИмяЗначенияПеречисления = Метаданные.Перечисления[ИмяПеречисления].ЗначенияПеречисления[ИндексЗначенияПеречисления].Имя;
		ИмяЗначенияПеречисления = ВидЗапроса.ИмяПредопределенныхДанных;
		//rarus bonmak 21.08.2020 16210 --
	Иначе
		ИмяЗначенияПеречисления = "";
	КонецЕсли;
	Возврат ИмяЗначенияПеречисления;
	
КонецФункции

//rarus agar 15.10.2020 15696 ++

&НаСервереБезКонтекста
//rarus agar 13.03.2021 17373 ++
//Функция ВидЗапроса1СДО(ВидЗапроса)
Функция ВидЗапроса1СДОПортала(ВидЗапроса)
//rarus agar 13.03.2021 17373 --
	
	СтруктураВидЗапроса = Новый Структура;
	СтруктураВидЗапроса.Вставить("Запрос1СДО",    ВидЗапроса.Запрос1СДО);
	СтруктураВидЗапроса.Вставить("ЗапросПортала", ВидЗапроса.ЗапросПортала);
	
	Возврат СтруктураВидЗапроса;
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьТекстЗапроса1СДО(ИмяМетода, ПараметрыВызова)
	
	ТекстЗапроса = "";
	ОбъектXDTO   = Неопределено;
	
	Прокси = Scan_ВебСервисы.ПолучитьПрокси1СДО();
	
	Если ИмяМетода = "setPurchaseOrder" Тогда
		ПродуктыКЗаказу = Новый ТаблицаЗначений;
		ПродуктыКЗаказу.Колонки.Добавить("ИдентификаторПродукта");
		ПродуктыКЗаказу.Колонки.Добавить("Наименование");
		ПродуктыКЗаказу.Колонки.Добавить("ДатаПоставки");
		ПродуктыКЗаказу.Колонки.Добавить("Количество");
		ПродуктыКЗаказу.Колонки.Добавить("Цена");
		ПродуктыКЗаказу.Колонки.Добавить("КодВалюты");
		ПродуктыКЗаказу.Колонки.Добавить("СтавкаНДС");
		ПродуктыКЗаказу.Колонки.Добавить("КомментарийДляПоставщика");
		ПродуктыКЗаказу.Колонки.Добавить("КомментарийВнутренний");
		
		НоваяСтрока = ПродуктыКЗаказу.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПараметрыВызова);
		
		ПараметрыВызова.Вставить("ПродуктыКЗаказу", ПродуктыКЗаказу);
		
		ОбъектXDTO = Scan_ВебСервисыРазборОтветов.ПолучитьЗаказНаЗакупкуXDTO(Прокси, ПараметрыВызова);
	ИначеЕсли ИмяМетода = "GetListDogovorov" Тогда
		ОбъектXDTO = Scan_ВебСервисыРазборОтветов.ПолучитьКонтрагентаXDTO(Прокси, ПараметрыВызова);
	КонецЕсли;
		
	ТекстЗапроса = Scan_ВебСервисы.СформироватьТекстЗапроса1СДО(ИмяМетода, Прокси, ПараметрыВызова, ОбъектXDTO);
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВызватьМетод1СДО(ИмяМетода, ПараметрыВызова)
	
	ОтветСервиса = "";
	
	Отказ             = Ложь;
	СообщениеОбОшибке = "";
	
	Прокси = Scan_ВебСервисы.ПолучитьПрокси1СДО();
	
	Если    ИмяМетода = "setPurchaseOrder" 
		Или ИмяМетода = "SetPurchaseOrder" 
		Тогда
		ПродуктыКЗаказу = Новый ТаблицаЗначений;
		ПродуктыКЗаказу.Колонки.Добавить("ИдентификаторПродукта");
		ПродуктыКЗаказу.Колонки.Добавить("Наименование");
		ПродуктыКЗаказу.Колонки.Добавить("ТипПродукта");
		ПродуктыКЗаказу.Колонки.Добавить("ДатаПоставки");
		ПродуктыКЗаказу.Колонки.Добавить("Количество");
		ПродуктыКЗаказу.Колонки.Добавить("Цена");
		ПродуктыКЗаказу.Колонки.Добавить("КодВалюты");
		ПродуктыКЗаказу.Колонки.Добавить("СтавкаНДС");
		ПродуктыКЗаказу.Колонки.Добавить("КомментарийДляПоставщика");
		ПродуктыКЗаказу.Колонки.Добавить("КомментарийВнутренний");
		
		НоваяСтрока = ПродуктыКЗаказу.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПараметрыВызова);
		
		ПараметрыВызова.Вставить("ПродуктыКЗаказу", ПродуктыКЗаказу);
		
		ОтветСервиса = Scan_ВебСервисыРазборОтветов.ВызватьМетод1СДО_setPurchaseOrder(Прокси, ПараметрыВызова, Отказ, СообщениеОбОшибке);
	ИначеЕсли ИмяМетода = "setPurchaseOrderApproval" 
		Или   ИмяМетода = "SetPurchaseOrderApproval" 
		Тогда
		ОтветСервиса = Scan_ВебСервисыРазборОтветов.ВызватьМетод1СДО_setPurchaseOrderApproval(Прокси, ПараметрыВызова, Отказ, СообщениеОбОшибке);
	ИначеЕсли ИмяМетода = "GetOrderStatus" Тогда
		ОтветСервиса = Scan_ВебСервисыРазборОтветов.ВызватьМетод1СДО_GetOrderStatus(Прокси, ПараметрыВызова, Отказ, СообщениеОбОшибке);
	ИначеЕсли ИмяМетода = "GetListOfCostCenters" Тогда
		ОтветСервиса = Scan_ВебСервисыРазборОтветов.ВызватьМетод1СДО_GetListOfCostCenters(Прокси, ПараметрыВызова, Отказ, СообщениеОбОшибке);
	ИначеЕсли ИмяМетода = "GetListContragent" Тогда
		ОтветСервиса = Scan_ВебСервисыРазборОтветов.ВызватьМетод1СДО_GetListContragent(Прокси, ПараметрыВызова, Отказ, СообщениеОбОшибке);
	ИначеЕсли ИмяМетода = "GetListDogovorov" Тогда
		ОтветСервиса = Scan_ВебСервисыРазборОтветов.ВызватьМетод1СДО_GetListDogovorov(Прокси, ПараметрыВызова, Отказ, СообщениеОбОшибке);
	ИначеЕсли ИмяМетода = "GetListOfCategories" Тогда
		ОтветСервиса = Scan_ВебСервисыРазборОтветов.ВызватьМетод1СДО_GetListOfCategories(Прокси, ПараметрыВызова, Отказ, СообщениеОбОшибке);
	ИначеЕсли ИмяМетода = "GetListOfDeliveries" Тогда
		ОтветСервиса = Scan_ВебСервисыРазборОтветов.ВызватьМетод1СДО_GetListOfDeliveries(Прокси, ПараметрыВызова, Отказ, СообщениеОбОшибке);
	КонецЕсли;
	
	Возврат Scan_ВебСервисы.ПолучитьТекстОтвета1СДО(Прокси, ОтветСервиса);
	
КонецФункции
//rarus agar 15.10.2020 15696 --

//rarus agar 13.03.2021 17373 ++
&НаСервереБезКонтекста
Функция СформироватьТекстЗапросаПортала(ИмяМетода, ПараметрыВызова)
	
	Возврат Scan_ВебСервисы.СформироватьТекстЗапросаПортала(ПараметрыВызова);
	
КонецФункции

&НаСервереБезКонтекста
Функция ВызватьМетодПортала(ИмяМетода, ПараметрыВызова)
	
	Если ИмяМетода = "GetUser" Тогда
		ИмяМетодаWS = "getUser";
		
		СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетодаПортала(ИмяМетодаWS);
		СтруктураПараметров.Вставить("id", ПараметрыВызова.ИдентификаторПользователя);
	ИначеЕсли ИмяМетода = "AddUpdateUser" Тогда
		ИмяМетодаWS = "addUpdateUser";
		
		СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетодаПортала(ИмяМетодаWS);
		СтруктураПараметров.Вставить("tokenofms", ПараметрыВызова.Токен);
		СтруктураПараметров.Вставить("id",        ПараметрыВызова.ИдентификаторПользователя);
	ИначеЕсли ИмяМетода = "CheckUserTokenIsOnline" Тогда
		ИмяМетодаWS = "checkUserTokenIsOnline";
		
		СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетодаПортала(ИмяМетодаWS);
		СтруктураПараметров.Вставить("login", ПараметрыВызова.Логин);
		СтруктураПараметров.Вставить("token", ПараметрыВызова.Токен);
	КонецЕсли;
	
	Отказ = Ложь;
	ИмяСобытияЖурналаРегистрации = "Веб-сервис портала." + ИмяМетодаWS;
	ТекстОтвета = "";
	
	РезультатВызова = Scan_ВебСервисы.ВызовВебСервисаПортала(ИмяМетодаWS,СтруктураПараметров,Отказ,ИмяСобытияЖурналаРегистрации);
	
	Если ТипЗнч(РезультатВызова) = Тип("Структура") Тогда
		ФрагментыТекстаОтвета = Новый Массив;
		
		Для Каждого КлючИЗначение Из РезультатВызова Цикл
			СтрокаПараметра = ""+ КлючИЗначение.Ключ +": "+ КлючИЗначение.Значение;
			ФрагментыТекстаОтвета.Добавить(СтрокаПараметра);
		КонецЦикла;
		
		ТекстОтвета = СтрСоединить(ФрагментыТекстаОтвета, Символы.ПС);
	Иначе
		ТекстОтвета = РезультатВызова;
	КонецЕсли;
	
	Возврат ТекстОтвета;
	
КонецФункции
//rarus agar 13.03.2021 17373 --

&НаСервере
Процедура УстановитьОтборСписка(ДатаНачала, ДатаОкончания, СписокПолучения = Истина, СписокОтправки = Истина)
	
	Если СписокПолучения Тогда		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(НезагруженныеОбъекты,"Период",);
		СозданнаяГруппа = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(НезагруженныеОбъекты.Отбор.Элементы, "ТекГруппаИ",ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СозданнаяГруппа, "Период",ВидСравненияКомпоновкиДанных.БольшеИлиРавно, ДатаНачала,,Истина,,);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СозданнаяГруппа, "Период",ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, ДатаОкончания,,Истина,,);
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(РегистрацияОбмена1БД,"Период",);
		СозданнаяГруппа = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(РегистрацияОбмена1БД.Отбор.Элементы, "ТекГруппаИ",ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СозданнаяГруппа, "Период",ВидСравненияКомпоновкиДанных.БольшеИлиРавно, ДатаНачала,,Истина,,);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СозданнаяГруппа, "Период",ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, ДатаОкончания,,Истина,,);
		
	КонецЕсли;
	
	Если СписокОтправки Тогда		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ОтправленныеСобытия,"ДатаИзменения",);
		СозданнаяГруппа = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ОтправленныеСобытия.Отбор.Элементы, "ТекГруппаИ",ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СозданнаяГруппа, "ДатаИзменения",ВидСравненияКомпоновкиДанных.БольшеИлиРавно, ДатаНачала,,Истина,,);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СозданнаяГруппа, "ДатаИзменения",ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, ДатаОкончания,,Истина,,);
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(НеотправленныеСобытия,"ДатаИзменения",);
		СозданнаяГруппа = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(НеотправленныеСобытия.Отбор.Элементы, "ТекГруппаИ",ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СозданнаяГруппа, "ДатаИзменения",ВидСравненияКомпоновкиДанных.БольшеИлиРавно, ДатаНачала,,Истина,,);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СозданнаяГруппа, "ДатаИзменения",ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, ДатаОкончания,,Истина,,);
		//rarus bonmak 09.08.2021 16834 ++
		//ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ДанныеДляОтправки,"ДатаИзменения",);
		//СозданнаяГруппа = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ДанныеДляОтправки.Отбор.Элементы, "ТекГруппаИ",ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		//ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СозданнаяГруппа, "ДатаИзменения",ВидСравненияКомпоновкиДанных.БольшеИлиРавно, ДатаНачала,,Истина,,);
		//ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СозданнаяГруппа, "ДатаИзменения",ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, ДатаОкончания,,Истина,,);
		//rarus bonmak 09.08.2021 16834 --
	КонецЕсли;
	
КонецПроцедуры

// rarus tenkam 08.04.2019 mantis 14308 +++
&НаСервере
Процедура ЗаполнитьНастройкиПроверкиМетодов()
	НастройкиПроверкиМетодов1БД.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_ВидыЗапроса.Ссылка КАК ВидЗапроса,
		|	ЕСТЬNULL(Scan_Обмен1БДНастройкиПроверкиМетодов.Проверять, ЛОЖЬ) КАК Проверять
		|ИЗ
		//rarus bonmak 21.08.2020 16210 изменено с перечисления на справочник
		|	Справочник.Scan_ВидыЗапроса КАК Scan_ВидыЗапроса
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Scan_Обмен1БДНастройкиПроверкиМетодов КАК Scan_Обмен1БДНастройкиПроверкиМетодов
		|		ПО Scan_ВидыЗапроса.Ссылка = Scan_Обмен1БДНастройкиПроверкиМетодов.ВидЗапроса";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаТЗ = НастройкиПроверкиМетодов1БД.Добавить();	
		ЗаполнитьЗначенияСвойств(СтрокаТЗ,ВыборкаДетальныеЗаписи);
	КонецЦикла;
	
КонецПроцедуры   

&НаСервере
Процедура ОбновитьНастройкуПроверкиВРегистре(ДанныеСтроки)
	
	НаборЗаписей = РегистрыСведений.Scan_Обмен1БДНастройкиПроверкиМетодов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ВидЗапроса.Установить(ДанныеСтроки.ВидЗапроса);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	
	НоваяЗапись.ВидЗапроса = ДанныеСтроки.ВидЗапроса;
	НоваяЗапись.Проверять = ДанныеСтроки.Проверять;
	НоваяЗапись.Пользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// rarus tenkam 08.04.2019 mantis 14308 ---
&НаСервереБезКонтекста
Функция СформироватьТекстCreateSetSOP(КодДоговора, ИмяМетода)
	НайденныйДоговор = Справочники.Scan_ДоговорыВзаиморасчетов.НайтиПоКоду(КодДоговора);
	Если ЗначениеЗаполнено(НайденныйДоговор) Тогда
		Отказ = Ложь;
		СтруктураПараметров = Scan_ВебСервисыРазборОтветов.СОППолучитьСтруктуруДанныхДляОтправкив1БД(НайденныйДоговор, , ИмяМетода);
		СообщениеОбмена = Scan_ВебСервисы.СформироватьСообщениеОбмена(ИмяМетода, СтруктураПараметров, Отказ, "Веб-сервис.CreateSOP");
		Возврат СообщениеОбмена;  			
	КонецЕсли;
	Возврат "";
КонецФункции

#КонецОбласти
