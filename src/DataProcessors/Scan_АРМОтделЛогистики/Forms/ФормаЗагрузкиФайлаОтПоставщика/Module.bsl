//rarus tenkam 20.06.2016 mantis 6926 ++
&НаКлиенте
Процедура КомандаОК(Команда)
	Если НЕ ЗначениеЗаполнено(ПутьКФайлу) Тогда
		//rarus FominskiyAS 19.04.2019  mantis 14191 +++
		//Сообщить("Файл не выбран!");
		Сообщить(Нстр("ru = 'Файл не выбран!'; en = 'The file is not selected!'"));
		//rarus FominskiyAS 19.04.2019  mantis 14191 ---
		Возврат;	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(CDD) Тогда
		//rarus FominskiyAS 19.04.2019  mantis 14191 +++
		//Сообщить("CDD не заполнена!");
        Сообщить(НСтр("ru = 'CDD не заполнена!'; en = 'CDD is not filled!'"));
		//rarus FominskiyAS 19.04.2019  mantis 14191 ---
		Возврат;	
	КонецЕсли;
	
	ПараметрыНастройки = Новый Структура;
	ПараметрыНастройки.Вставить("ПутьКФайлу", ПутьКФайлу);
	ПараметрыНастройки.Вставить("CDD", CDD);
	//rarus sergei 05.08.2016 mantis 6926 ++
	ПараметрыНастройки.Вставить("НомерСтроки",НомерПервойСтрокиДляЗагрузки);
	//rarus sergei 05.08.2016 mantis 6926 --
	//rarus tenkam 24.02.2017 mantis 8492 +++
	Если ЗначениеЗаполнено(МестоДоставки) Тогда
		ПараметрыНастройки.Вставить("МестоДоставки", МестоДоставки);
	КонецЕсли;
	//rarus tenkam 24.02.2017 mantis 8492 ---

	Закрыть(ПараметрыНастройки);
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Режим = РежимДиалогаВыбораФайла.Открытие; 
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим); 
	ДиалогОткрытияФайла.ПолноеИмяФайла = ""; 
	Фильтр = НСтр("ru = 'Таблица XLS (*.xls)|*.xls'"); 
	ДиалогОткрытияФайла.Фильтр = Фильтр; 
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь; 
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииДиалогаВыбораФайла", ЭтотОбъект);
	ДиалогОткрытияФайла.Показать(ОписаниеОповещения);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииДиалогаВыбораФайла(ВыбранныйФайл, Параметры) Экспорт
	
	Если ВыбранныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолноеИмяФайла = ВыбранныйФайл[0];
	ПутьКФайлу = ПолноеИмяФайла;

КонецПроцедуры
//rarus tenkam 20.06.2016 mantis 6926 --

//rarus sergei 05.08.2016 mantis 6926 ++
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НомерПервойСтрокиДляЗагрузки = 2;
КонецПроцедуры
//rarus sergei 05.08.2016 mantis 6926 --

