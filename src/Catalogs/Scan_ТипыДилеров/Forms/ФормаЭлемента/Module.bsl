
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)//rarus bonmak 04.12.2019 14456 ++
	//После реализации интеграции раскомментировать (bonmak)
	//Если Объект.Ссылка.Пустая() Тогда
	//	ТекстОшибки = Нстр("ru = 'Запрещено добавление элементов справочника!'; en = 'It is forbidden to add directory entries!'");		
	//	Сообщить(ТекстОшибки);
	//	Отказ = Истина;
	//КонецЕсли;
	УправлениеДиалогомНаСервере();
	Scan_СборСтатистики.Scan_ПриОткрытии("Справочники", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	

КонецПроцедуры //rarus bonmak 04.12.2019 14456 --

&НаСервере
Процедура УправлениеДиалогомНаСервере() //rarus bonmak 04.12.2019 14456 ++		
	//rarus BProg_Dekin 20.02.2020 mantis 0014456 ++ Заблокировал, так как кнопка обновления удалена из формы
	//Если ЗначениеЗаполнено(Объект.ДатаОбновления) Тогда
	//	ЭтаФорма.Прочитать();
	//	Элементы.ФормаОбновитьЭлемент.Заголовок = Объект.ДатаОбновления;
	//КонецЕсли;
	//rarus BProg_Dekin 20.02.2020 mantis 0014456 --
КонецПроцедуры //rarus bonmak 04.12.2019 14456 --

&НаСервере
Процедура ОбновитьЭлементНаСервере() //rarus bonmak 04.12.2019 14456 ++
	//При реализации интеграции изменить (bonmak)
	//Если ЗначениеЗаполнено(Объект.IDExternalSystem) Тогда
	//	СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(, Ложь);
	//	СтруктураПараметров.GUID = Объект.IDExternalSystem;
	//	Scan_ВебСервисыРазборОтветов.ВызватьМетод_GetAdditionalProperty(СтруктураПараметров);
	//	ЭтаФорма.Прочитать();
	//	УправлениеДиалогомНаСервере();
	//КонецЕсли;
КонецПроцедуры //rarus bonmak 04.12.2019 14456 --

&НаКлиенте
Процедура ОбновитьЭлемент(Команда) //rarus bonmak 04.12.2019 14456 ++
	ОбновитьЭлементНаСервере();
КонецПроцедуры //rarus bonmak 04.12.2019 14456 --
  
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) // Rarus tenkam 11.04.2022 mantis 18433 +++

	Если Объект.Ссылка.Пустая() Тогда
		Scan_СборСтатистики.Scan_ПередЗаписьюСправочника(РеквизитФормыВЗначение("Объект").Метаданные().Синоним, Истина, "Создание нового элемента");
	КонецЕсли;
КонецПроцедуры 	// Rarus tenkam 11.04.2022 mantis 18433 --- 