
&НаСервере
Процедура ОбновитьЭлементНаСервере() //rarus tenkam 11.09.2019 14442 ++
	Если ЗначениеЗаполнено(Объект.IDExternalSystem) Тогда
		ИмяМетода = "GetProductSubType";
		СообщениеОбОшибке = "";
		Отказ = Ложь;
		СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода ,Ложь);
		СтруктураПараметров.Вставить("GUID", Объект.IDExternalSystem);
		ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
		ТекЭлементОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации);
		Если НЕ Отказ Тогда
			ТекСсылка = Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникТипы(ТекЭлементОтвет,Отказ,СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации,ИмяМетода,"Scan_ТипыГИБДД");
		КонецЕсли;
		
		ЭтаФорма.Прочитать();
		УправлениеДиалогомНаСервере();
	КонецЕсли
КонецПроцедуры //rarus tenkam 11.09.2019 14442 --

&НаКлиенте
Процедура ОбновитьЭлемент(Команда) //rarus tenkam 11.09.2019 14442 ++
	ОбновитьЭлементНаСервере();
КонецПроцедуры //rarus tenkam 11.09.2019 14442 --

&НаСервере
Процедура УправлениеДиалогомНаСервере() //rarus tenkam 11.09.2019 14442 ++	
	Элементы.ФормаОбновитьЭлемент.Доступность = (ЗначениеЗаполнено(Объект.IDExternalSystem));

	Если ЗначениеЗаполнено(Объект.ДатаОбновления) Тогда
		Элементы.ФормаОбновитьЭлемент.Заголовок = Объект.ДатаОбновления;
	КонецЕсли;
	
КонецПроцедуры //rarus tenkam 11.09.2019 14442 --

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка) //rarus tenkam 11.09.2019 14442 ++
	Если Объект.Ссылка = Справочники.Scan_МаркетинговыеТипыПродуктов.ПустаяСсылка() Тогда
		ТекстОшибки = Нстр("ru = 'Запрещено добавление элементов справочника!'; en = 'It is forbidden to add directory entries!'");		
		Сообщить(ТекстОшибки);
		Отказ = Истина;
	КонецЕсли;
	УправлениеДиалогомНаСервере();
	Scan_СборСтатистики.Scan_ПриОткрытии("Справочники", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	

КонецПроцедуры //rarus tenkam 11.09.2019 14442 --
  
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) // Rarus tenkam 11.04.2022 mantis 18433 +++

	Если Объект.Ссылка.Пустая() Тогда
		Scan_СборСтатистики.Scan_ПередЗаписьюСправочника(РеквизитФормыВЗначение("Объект").Метаданные().Синоним, Истина, "Создание нового элемента");
	КонецЕсли;
КонецПроцедуры 	// Rarus tenkam 11.04.2022 mantis 18433 --- 
