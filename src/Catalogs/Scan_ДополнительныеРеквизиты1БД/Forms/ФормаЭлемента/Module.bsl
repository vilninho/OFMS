
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка) //rarus bonmak 04.09.2019 14442 ++
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	Если Объект.Ссылка = Справочники.Scan_ДополнительныеРеквизиты1БД.ПустаяСсылка() Тогда
		ТекстОшибки = Нстр("ru = 'Запрещено добавление элементов справочника!'; en = 'It is forbidden to add directory entries!'");		
		Сообщить(ТекстОшибки);
		Отказ = Истина;
	КонецЕсли;
	УправлениеДиалогомНаСервере();
	Scan_СборСтатистики.Scan_ПриОткрытии("Справочники", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	

КонецПроцедуры //rarus bonmak 04.09.2019 14442 --

&НаСервере
Процедура УправлениеДиалогомНаСервере() //rarus bonmak 04.09.2019 14442 ++		
	Элементы.ТипДопРеквизитаOFMS.Доступность = РольДоступна("ПолныеПрава");
	Если ЗначениеЗаполнено(Объект.ДатаОбновления) Тогда
		ЭтаФорма.Прочитать();
		Элементы.ФормаОбновитьЭлемент.Заголовок = Объект.ДатаОбновления;
	КонецЕсли;
КонецПроцедуры //rarus bonmak 04.09.2019 14442 --

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) // Rarus tenkam 11.04.2022 mantis 18433 +++

	Если Объект.Ссылка.Пустая() Тогда
		Scan_СборСтатистики.Scan_ПередЗаписьюСправочника(РеквизитФормыВЗначение("Объект").Метаданные().Синоним, Истина, "Создание нового элемента");
	КонецЕсли;
КонецПроцедуры 	// Rarus tenkam 11.04.2022 mantis 18433 ---

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ОбновитьЭлементНаСервере() //rarus bonmak 04.09.2019 14442 ++
	Если ЗначениеЗаполнено(Объект.IDExternalSystem) Тогда
		СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(, Ложь);
		СтруктураПараметров.GUID = Объект.IDExternalSystem;
		Scan_ВебСервисыРазборОтветов.ВызватьМетод_GetAdditionalProperty(СтруктураПараметров);
		ЭтаФорма.Прочитать();
		УправлениеДиалогомНаСервере();
	КонецЕсли;
КонецПроцедуры //rarus bonmak 04.09.2019 14442 --

&НаКлиенте
Процедура ОбновитьЭлемент(Команда) //rarus bonmak 04.09.2019 14442 ++
	ОбновитьЭлементНаСервере();
КонецПроцедуры //rarus bonmak 04.09.2019 14442 --

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипДопРеквизитаOFMSНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка) //rarus bonmak 04.09.2019 14442 ++
	СтандартнаяОбработка = Ложь;
	СписокВыбора = ОбработатьСписокВыбора(); //rarus bonmak 17468 23.09.2021
	СписокВыбора.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("ОбработатьРезультатВыгрузки", ЭтотОбъект, ),"Выберите тип данных",);
КонецПроцедуры //rarus bonmak 04.09.2019 14442 --

&НаСервере
Функция ОбработатьСписокВыбора() //rarus bonmak 17468 23.09.2021 ++
	Возврат Справочники.Scan_ДополнительныеРеквизиты1БД.ПолучитьСписокВыбора();
КонецФункции //rarus bonmak 17468 23.09.2021 --

&НаКлиенте
Процедура ОбработатьРезультатВыгрузки(ВыбранныйЭлемент,ДополнительныеПараметры) Экспорт //rarus bonmak 04.09.2019 14442 ++    
	Если ВыбранныйЭлемент = Неопределено Тогда 
		Возврат;
	КонецЕсли;   
	
	УстановитьЗначениеРеквизитаНаСервере(ВыбранныйЭлемент.Значение);        
КонецПроцедуры //rarus bonmak 04.09.2019 14442 --

&НаСервере
Процедура УстановитьЗначениеРеквизитаНаСервере(Значение) //rarus bonmak 04.09.2019 14442 ++
	Объект.ТипДопРеквизитаOFMS = "";
	Объект.ТипДопРеквизитаOFMS = Значение;
	Объект.Пользователь = ПользователиСлужебный.АвторизованныйПользователь();
КонецПроцедуры //rarus bonmak 04.09.2019 14442 --

&НаКлиенте
Процедура ИспользуетсяВOFMSПриИзменении(Элемент) //rarus bonmak 04.09.2019 14442 ++
	УстановитьПользователяПриИзменении(); 
КонецПроцедуры //rarus bonmak 04.09.2019 14442 --

&НаКлиенте
Процедура ТипДопРеквизитаOFMSПриИзменении(Элемент) //rarus tenkam 18.09.2019 mantis 14442 +++
	УстановитьПользователяПриИзменении();
КонецПроцедуры //rarus tenkam 18.09.2019 mantis 14442 ---

&НаКлиенте
Процедура ИспользуетсяВOFMSДляОтправкиПриИзменении(Элемент) //rarus bonmak 17468 23.09.2021 ++
	УстановитьПользователяПриИзменении();
КонецПроцедуры //rarus bonmak 17468 23.09.2021 --

&НаСервере
Процедура УстановитьПользователяПриИзменении() //rarus bonmak 04.09.2019 14442 ++
	Объект.Пользователь = ПользователиСлужебный.АвторизованныйПользователь(); 
КонецПроцедуры //rarus bonmak 04.09.2019 14442 --


#КонецОбласти

#Область Удалить

//rarus bonmak 17468 23.09.2021 ++
//Вынес в модуль менеджера
//&НаСервере
//Функция ПолучитьСписокВыбора() //rarus bonmak 04.09.2019 14442 ++
//    СписокВыбора = Новый СписокЗначений;
//	Для Каждого СтрТип Из Метаданные.Справочники Цикл 
//		СписокВыбора.Добавить(СтрТип.Имя)
//	КонецЦикла;
//	
//	// rarus tenkam 25.09.2019 mantis 14442 +++
//	Для Каждого СтрТип Из Метаданные.РегистрыСведений Цикл 
//		СписокВыбора.Добавить(СтрТип.Имя)
//	КонецЦикла;
//	// rarus tenkam 25.09.2019 mantis 14442 ---
//	
//    Возврат СписокВыбора;   
//КонецФункции //rarus bonmak 04.09.2019 14442 --
//rarus bonmak 17468 23.09.2021 --

#КонецОбласти
