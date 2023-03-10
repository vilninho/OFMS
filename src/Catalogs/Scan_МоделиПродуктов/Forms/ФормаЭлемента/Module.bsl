//rarus tenkam 03.06.2016 mantis 7009 ++
&НаКлиенте
Процедура НаименованиеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	Объект.Наименование = ВРег(Текст);
	
	УбратьПробелыВНаименовании();
	Если НЕ ЭтоМодельТС Тогда
		ДобавитьЧетвертыйПробел();
	КонецЕсли;
КонецПроцедуры
//rarus tenkam 03.06.2016 mantis 7009 --

//rarus tenkam 07.06.2016 mantis 6913 ++ 
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Параметры.Ключ.Пустая() Тогда
		//Это новый объект
		ЭтоМодельТС = Истина;
	Иначе
		ЭтоМодельТС = ПоНаименованиюЭтоМодельТС();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПоНаименованиюЭтоМодельТС() 
	Если Сред(Объект.Наименование, 5, 1) = " " Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;		
КонецФункции

&НаКлиенте
Процедура УбратьПробелыВНаименовании()
	Объект.Наименование = ВРег(СтрЗаменить(Объект.Наименование," ","")); 
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЧетвертыйПробел()
	СимволыСлева = Лев(Объект.Наименование,4);
	СимволыСправа = Прав(Объект.Наименование, СтрДлина(Объект.Наименование) - 4);
	Объект.Наименование = СимволыСлева + " " + СимволыСправа;
КонецПроцедуры

&НаКлиенте
Процедура ЭтоМодельТСПриИзменении(Элемент)
	УбратьПробелыВНаименовании();
	Если НЕ ЭтоМодельТС Тогда
		ДобавитьЧетвертыйПробел();
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

//rarus tenkam 07.06.2016 mantis 6913 --

//rarus tenkam 18.10.2016 mantis 6897 ++
&НаСервере
Процедура ОбновитьЭлементНаСервере()
	Если НЕ ЗначениеЗаполнено(Объект.IDExternalSystem) Тогда
		//Создан вручную
	Иначе
		ИмяМетода = "GetProductModel";
		СообщениеОбОшибке = "";
		Отказ = Ложь;
		СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода ,Ложь);
		СтруктураПараметров.Вставить("GUID", Объект.IDExternalSystem);
		ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
		//ТекЭлементЗапрос = Scan_ВебСервисы.СформироватьСообщениеОбмена(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации); 
		ТекЭлементОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации);
		Если НЕ Отказ Тогда
			СсылкаПродукта = Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникМоделиПродуктов(ТекЭлементОтвет,Отказ,СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации,ИмяМетода);
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
	ОграничитьДоступностьФормыПриОткрытииИзРабочегоМестаДилера(); //rarus pechek 16.06.2020 mantis 16201
	Scan_СборСтатистики.Scan_ПриОткрытии("Справочники", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	Элементы.ФормаГруппаИнтеграция.Видимость = Scan_ПраваИНастройки.Scan_Право("ОбменСПредставительством");
	Элементы.ФормаОбновитьЭлемент.Доступность = (ЗначениеЗаполнено(Объект.IDExternalSystem));
	Элементы.ЭтоМодельТС.Доступность = ПравоДоступа("Редактирование",Метаданные.Справочники.Scan_МоделиПродуктов);//rarus vikhle 26.05.2021 m 17543
	
	Если ЗначениеЗаполнено(Объект.ДатаОбновления) Тогда
		Элементы.ФормаОбновитьЭлемент.Заголовок = Объект.ДатаОбновления;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОграничитьДоступностьФормыПриОткрытииИзРабочегоМестаДилера() 
	//rarus pechek 16.06.2020 mantis 16201 +++
	Если НЕ Параметры.ФормаОткрытаИзРабочегоМестаДилера Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ДекорацияФормы") ИЛИ Элемент = Элементы.ФормаПеречитать Тогда
			Продолжить;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Элемент.Имя, "Доступность", Ложь);
	КонецЦикла; 	
	КоманднаяПанель.Доступность = Ложь;
	//rarus pechek 16.06.2020 mantis 16201 ---
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) // Rarus tenkam 11.04.2022 mantis 18433 +++

	Если Объект.Ссылка.Пустая() Тогда
		Scan_СборСтатистики.Scan_ПередЗаписьюСправочника(РеквизитФормыВЗначение("Объект").Метаданные().Синоним, Истина, "Создание нового элемента");
	КонецЕсли;
КонецПроцедуры 	// Rarus tenkam 11.04.2022 mantis 18433 ---


//rarus tenkam 18.10.2016 mantis 6897 --