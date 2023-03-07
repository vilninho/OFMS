//rarus tenkam 21.10.2016 mantis 6897 ++
&НаКлиенте
Процедура СоздатьКонтрагента(Команда)
	Обработчик = Новый ОписаниеОповещения("ОбработатьИНН", ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
	ОткрытьФорму("Справочник.Scan_Контрагенты.Форма.ФормаИНН",,,,,, Обработчик, Режим);
КонецПроцедуры

//Описание оповещения о закрытии формы подбора по ИНН
&НаКлиенте
Процедура ОбработатьИНН(ЗначениеВозвр, Параметры) Экспорт
	Если ЗначениеВозвр = Неопределено ИЛИ
		ЗначениеВозвр = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеВозвр.Свойство("ИНН") И ЗначениеВозвр.Свойство("Резидент") Тогда		//rarus tenkam 22.12.2016 mantis 8207 + 
		Если ЗначениеВозвр.Резидент Тогда //rarus bonmak 15.04.2020 14456 добавил условие и отработку истина
			НайденныйКонтрагент =  ТакойКонтрагентУжеЕсть(ЗначениеВозвр.ИНН, ЗначениеВозвр.КПП);	
		Иначе	
			НайденныйКонтрагент =  ТакойКонтрагентУжеЕсть(ЗначениеВозвр.ИНН);
		КонецЕсли;
		Если НайденныйКонтрагент <> Неопределено Тогда
			//rarus FominskiyAS 19.04.2019  mantis 14191 +++
			//Сообщить("Контрагент с таким ИНН уже есть в базе!");
			Сообщить(НСтр("ru = 'Контрагент с таким ИНН уже есть в базе!'; en = 'Counteragent with same INN (tax number) already exists!'"));
			//rarus FominskiyAS 19.04.2019  mantis 14191 ---  
			Элементы.Список.ТекущаяСтрока = НайденныйКонтрагент;
			//НайденныйКонтрагент = Справочники.Scan_Контрагенты.СоздатьЭлемент();
			ПараметрыФормы = Новый Структура("Ключ", НайденныйКонтрагент);
			ОткрытьФорму("Справочник.Scan_Контрагенты.ФормаОбъекта",ПараметрыФормы);
			Возврат;
		Иначе
			//rarus bonmak 15.04.2020 14456 ++
			//	ПараметрыСоздания = Новый Структура;
			//	ПараметрыСоздания.Вставить("ИНН", ЗначениеВозвр.ИНН);
			//	ПараметрыСоздания.Вставить("Родитель", Элементы.Список.ТекущийРодитель);
			//	ПараметрыСоздания.Вставить("Резидент", ЗначениеВозвр.Резидент);	//rarus tenkam 22.12.2016 mantis 8207 +
			//
			//	ОткрытьФорму("Справочник.Scan_Контрагенты.Форма.ФормаЭлемента",ПараметрыСоздания);
			
			ИмяМетода = "GetListOfContragents";
			СообщениеОбОшибке = "";
			Отказ = Ложь;
			СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода, Истина);
			СтруктураПараметров.Вставить("ИНН", ЗначениеВозвр.ИНН);
			Если ЗначениеВозвр.Резидент Тогда
				СтруктураПараметров.Вставить("КПП", ЗначениеВозвр.КПП);
			КонецЕсли;
			ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
			ТекЭлементОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации);
			Если НЕ Отказ Тогда
				ГруппаКонтрагента = ВернутьПапкуКлиенты(); //rarus bonmak 26.01.2021 17092
				СсылкаЭлемента = Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникКонтрагенты(ТекЭлементОтвет,Отказ,СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации,ИмяМетода, ГруппаКонтрагента);
			КонецЕсли;
			
			Если Отказ Тогда
				Сообщить(НСтр("ru = 'По заданным отборам контрагент не найден. Просьба обратиться к администратору 1БД для создания контрагента в 1ДБ'; en = 'No counterparty was found for the given selections. Please contact the administrator of 1BD to create a counterparty in 1DB'"));
			Иначе
				//rarus bonmak 24.09.2020 14456 ++
				Если ЗначениеВозвр.Резидент Тогда 
					НайденныйКонтрагент =  ТакойКонтрагентУжеЕсть(ЗначениеВозвр.ИНН, ЗначениеВозвр.КПП);	
				Иначе	
					НайденныйКонтрагент =  ТакойКонтрагентУжеЕсть(ЗначениеВозвр.ИНН);
				КонецЕсли;
				Элементы.Список.Обновить();
				Элементы.Список.ТекущаяСтрока = НайденныйКонтрагент;
				//ПараметрыФормы = Новый Структура("Ключ", НайденныйКонтрагент);
				//ОткрытьФорму("Справочник.Scan_Контрагенты.ФормаОбъекта",ПараметрыФормы);
				//rarus bonmak 24.09.2020 14456 --
			КонецЕсли;
			//rarus bonmak 15.04.2020 14456 --
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ВернутьПапкуКлиенты() //rarus bonmak 26.01.2021 17092 ++
	Возврат Справочники.Scan_Контрагенты.Клиенты;	
КонецФункции //rarus bonmak 26.01.2021 17092 --

// Функция проверяет, существует ли в базе контрагент с указанным ИНН
&НаСервереБезКонтекста
Функция ТакойКонтрагентУжеЕсть(ЗначениеПоискаИНН, ЗначениеПоискаКПП = Неопределено)
	//rarus bonmak 15.04.2020 14456 ++	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Scan_Контрагенты.Ссылка КАК КонтрагентСсылка
	|ИЗ
	|	Справочник.Scan_Контрагенты КАК Scan_Контрагенты
	|ГДЕ
	|	Scan_Контрагенты.ИНН = &ИНН
	|	И (Scan_Контрагенты.КПП = &КПП
	|			ИЛИ ИСТИНА)";
	
	Запрос.УстановитьПараметр("ИНН", ЗначениеПоискаИНН);
	Запрос.УстановитьПараметр("КПП", ЗначениеПоискаКПП);
	
	РезультатЗапроса = Запрос.Выполнить();
	//rarus bonmak 24.09.2020 14456 ++
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	//rarus bonmak 24.09.2020 14456 --
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	НайденныйКонтрагент = ВыборкаДетальныеЗаписи.КонтрагентСсылка; 		
	
	//rarus bonmak 24.09.2020 14456 ++
	//НайденныйКонтрагент = Справочники.Scan_Контрагенты.НайтиПоРеквизиту("ИНН", ЗначениеПоиска);
	//rarus bonmak 15.04.2020 14456 --	
	//Если НайденныйКонтрагент = Справочники.Scan_Контрагенты.ПустаяСсылка() Тогда
	//	Возврат Неопределено;
	//Иначе
	Возврат НайденныйКонтрагент;
	//КонецЕсли;
	//rarus bonmak 24.09.2020 14456 --
КонецФункции

//rarus tenkam 21.10.2016 mantis 6897 --

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//rarus vikhle 22.12.2020 mt 16997 +++
	Если Параметры.Свойство("УстановитьРежимОтображенияСписок") Тогда
		УстановитьРежимОтображенияСписок = Истина;
	КонецЕсли;	
	//rarus vikhle 22.12.2020 mt 16997 ---
	
	//rarus agar 13.04.2021 17622 ++
	ОтображениеФиксированногоОтбора();
	//rarus agar 13.04.2021 17622 ++
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//rarus vikhle 22.12.2020 mt 16997 +++
	Если УстановитьРежимОтображенияСписок Тогда
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;	
	КонецЕсли;	
	//rarus vikhle 22.12.2020 mt 16997 ---
КонецПроцедуры

//rarus agar 13.04.2021 17622 ++
&НаСервере
Процедура ОтображениеФиксированногоОтбора()
	
	ПредставлениеОбъекта = Метаданные.Справочники.Scan_Контрагенты.ПредставлениеОбъекта;
	ПредставлениеОтбора  = Scan_ВспомогательныеФункцииСервер.ПолучитьПредставлениеОтбораФормыВыбора(ЭтотОбъект, ПредставлениеОбъекта);
	
	Если Не ПустаяСтрока(ПредставлениеОтбора) Тогда
		ФиксированныйОтборПредставление = ПредставлениеОтбора;
		
		Элементы.ФиксированныйОтборПредставление.Видимость = Истина;
		Элементы.ФиксированныйОтборПредставление.Высота    = СтрЧислоСтрок(ПредставлениеОтбора);
	КонецЕсли;
	
КонецПроцедуры
//rarus agar 13.04.2021 17622 --