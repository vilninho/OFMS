//rarus tenkam 27.09.2016 mantis 6897 ++
&НаСервере
Процедура ОбновитьЭлементНаСервере()
	Если НЕ ЗначениеЗаполнено(Объект.IDExternalSystem) Тогда
		//Создан вручную
	Иначе
		ИмяМетода = "GetProductSubType";
		СообщениеОбОшибке = "";
		Отказ = Ложь;
		СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода ,Ложь);
		СтруктураПараметров.Вставить("GUID", Объект.IDExternalSystem);
		ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
		ТекЭлементОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации);
		Если НЕ Отказ Тогда
			// rarus tenkam 19.09.2019 mantis 14442 +++
			//СсылкаПродукта = Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникТипыПродуктов(ТекЭлементОтвет,Отказ,СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации,ИмяМетода);
			ТекСсылка = Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникТипы(ТекЭлементОтвет,Отказ,СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации,ИмяМетода,"Scan_ТипыПродуктовЛогистика");
			// rarus tenkam 19.09.2019 mantis 14442 ---	
		КонецЕсли;
		ЭтаФорма.Прочитать();
		УправлениеДиалогомНаСервере(); 
	КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЭлемент(Команда)
	ОбновитьЭлементНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	УправлениеДиалогомНаСервере();
	Scan_СборСтатистики.Scan_ПриОткрытии("Справочники", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	

КонецПроцедуры

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	Элементы.ФормаГруппаИнтеграция.Видимость = Scan_ПраваИНастройки.Scan_Право("ОбменСПредставительством");
	Элементы.ФормаОбновитьЭлемент.Доступность = (ЗначениеЗаполнено(Объект.IDExternalSystem));
	
	Если ЗначениеЗаполнено(Объект.ДатаОбновления) Тогда
		Элементы.ФормаОбновитьЭлемент.Заголовок = Объект.ДатаОбновления;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) // Rarus tenkam 11.04.2022 mantis 18433 +++

	Если Объект.Ссылка.Пустая() Тогда
		Scan_СборСтатистики.Scan_ПередЗаписьюСправочника(РеквизитФормыВЗначение("Объект").Метаданные().Синоним, Истина, "Создание нового элемента");
	КонецЕсли;
КонецПроцедуры 	// Rarus tenkam 11.04.2022 mantis 18433 --- 

//rarus tenkam 27.09.2016 mantis 6897 --