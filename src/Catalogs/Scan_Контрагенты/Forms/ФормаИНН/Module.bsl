//rarus tenkam 21.10.2016 mantis 6897 ++
&НаКлиенте
Процедура Создать(Команда)
	ПараметрыЗакрытия = Новый Структура;
	//rarus bonmak 15.04.2020 14456 ++
	Если Резидент Тогда
		Если НЕ ЗначениеЗаполнено(СокрЛП(КПП)) Тогда
			Сообщить(НСтр("ru = 'КПП не заполнен!'; en = 'KPP (tax number) is empty!'"));
			Возврат;
		КонецЕсли;	
	КонецЕсли;
	//rarus bonmak 15.04.2020 14456 --
	Если НЕ ЗначениеЗаполнено(СокрЛП(ИНН)) Тогда
		//rarus FominskiyAS 19.04.2019  mantis 14191 +++
		//Сообщить("ИНН не заполнен!");
		Сообщить(НСтр("ru = 'ИНН не заполнен!'; en = 'INN (tax number) is empty!'"));
		//rarus FominskiyAS 19.04.2019  mantis 14191 ---  
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия.Вставить("ИНН", ИНН);
	Если Резидент Тогда //rarus bonmak 15.04.2020 14456 ++
		ПараметрыЗакрытия.Вставить("КПП", КПП); 
	КонецЕсли; //rarus bonmak 15.04.2020 14456 --
	ПараметрыЗакрытия.Вставить("Резидент",  Резидент);	//rarus tenkam 22.12.2016 mantis 8207 +
	
	Закрыть(ПараметрыЗакрытия);
КонецПроцедуры
//rarus tenkam 21.10.2016 mantis 6897 --

//rarus tenkam 22.12.2016 mantis 8207 ++
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Резидент = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РезидентПриИзменении(Элемент) //rarus bonmak 15.04.2020 14456 ++
	Элементы.КПП.Доступность = Резидент;
	КПП = "";
КонецПроцедуры //rarus bonmak 15.04.2020 14456 --
//rarus tenkam 22.12.2016 mantis 8207 --

