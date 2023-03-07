//rarus tenkam 03.06.2016 mantis 7023 ++
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	//rarus bonmak 04.09.2019 14442 ++
	Если Объект.Ссылка = Справочники.Scan_ТипыПродуктов.ПустаяСсылка() Тогда
		ТекстОшибки = Нстр("ru = 'Запрещено добавление элементов справочника!'; en = 'It is forbidden to add directory entries!'");		
		Сообщить(ТекстОшибки);
		Отказ = Истина;
	КонецЕсли;
	//rarus bonmak 04.09.2019 14442 --
	УправлениеДиалогомНаСервере();
	Scan_СборСтатистики.Scan_ПриОткрытии("Справочники", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	

КонецПроцедуры

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	// rarus tenkam 04.10.2019 mantis 14442 +++ удаление предопределенных групп
	//Если Объект.Родитель = Справочники.Scan_ТипыПродуктов.ТипыПродуктовМаркетинговые Тогда
	//	Элементы.ВидПродукта.Видимость = Ложь;
	//	Объект.ВидПродукта = Справочники.Scan_ВидыПродуктов.ПустаяСсылка();
	//	
	//	Элементы.ВидПродуктаГруппаПродукта.Видимость = Ложь;
	//Иначе
	//Элементы.ВидПродукта.Видимость = Истина;
	//Элементы.ВидПродуктаГруппаПродукта.Видимость = Истина;	
	//КонецЕсли;
	// rarus tenkam 04.10.2019 mantis 14442 ---
	
	//rarus tenkam 27.09.2016 mantis 6897 ++
	Элементы.ФормаГруппаИнтеграция.Видимость = Scan_ПраваИНастройки.Scan_Право("ОбменСПредставительством");

	Элементы.ФормаОбновитьЭлемент.Доступность = (ЗначениеЗаполнено(Объект.IDExternalSystem));
	
	Если ЗначениеЗаполнено(Объект.ДатаОбновления) Тогда
		Элементы.ФормаОбновитьЭлемент.Заголовок = Объект.ДатаОбновления;
	КонецЕсли;
	//rarus tenkam 27.09.2016 mantis 6897 --
	
КонецПроцедуры

&НаКлиенте
Процедура РодительПриИзменении(Элемент)
	УправлениеДиалогомНаСервере();
КонецПроцедуры
//rarus tenkam 03.06.2016 mantis 7023 -- 

//rarus tenkam 27.09.2016 mantis 6897 ++
&НаСервере
Процедура ОбновитьЭлементНаСервере()
	Если НЕ ЗначениеЗаполнено(Объект.IDExternalSystem) Тогда
		//Создан вручную
	Иначе
		// rarus tenkam 18.09.2019 mantis 14442 +++ Раскомментировала
		////rarus bonmak 04.09.2019 14442 ++
		////данный метод не подходит, нового нет
		ИмяМетода = "GetProductSubType";
		СообщениеОбОшибке = "";
		Отказ = Ложь;
		СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода ,Ложь);
		СтруктураПараметров.Вставить("GUID", Объект.IDExternalSystem);
		ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
		//ТекЭлементЗапрос = Scan_ВебСервисы.СформироватьСообщениеОбмена(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации); 
		ТекЭлементОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации);
		Если НЕ Отказ Тогда
			// rarus tenkam 19.09.2019 mantis 14442 +++
			//СсылкаПродукта = Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникТипыПродуктов(ТекЭлементОтвет,Отказ,СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации,ИмяМетода);
			ТекСсылка = Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникТипы(ТекЭлементОтвет,Отказ,СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации,ИмяМетода,"Scan_ТипыПродуктов");
			// rarus tenkam 19.09.2019 mantis 14442 ---	
		КонецЕсли;
		////rarus bonmak 04.09.2019 14442 --
		// rarus tenkam 18.09.2019 mantis 14442 --- Раскомментировала
			
		ЭтаФорма.Прочитать();
		УправлениеДиалогомНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЭлемент(Команда)
	ОбновитьЭлементНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) // Rarus tenkam 11.04.2022 mantis 18433 +++

	Если Объект.Ссылка.Пустая() Тогда
		Scan_СборСтатистики.Scan_ПередЗаписьюСправочника(РеквизитФормыВЗначение("Объект").Метаданные().Синоним, Истина, "Создание нового элемента");
	КонецЕсли;
КонецПроцедуры 	// Rarus tenkam 11.04.2022 mantis 18433 --- 
//rarus tenkam 27.09.2016 mantis 6897 --

