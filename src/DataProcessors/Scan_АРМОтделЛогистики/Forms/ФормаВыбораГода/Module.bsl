//rarus tenkam 16.06.2016 mantis 6925 ++
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ГодStatistics = Год(ТекущаяДата());
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	// rarus tenkam 09.04.2019 mantis 14195 +++
	
	Оповещение = Новый ОписаниеОповещения("ПослеПодключенияРасширения", ЭтотОбъект);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение);
	
	//ПараметрНастройки = Новый Структура;
	//ПараметрНастройки.Вставить("ГодStatistics", ГодStatistics);

	//Закрыть(ПараметрНастройки);
	// rarus tenkam 09.04.2019 mantis 14195 ---
КонецПроцедуры
//rarus tenkam 16.06.2016 mantis 6925 --

// rarus tenkam 09.04.2019 mantis 14195 +++  
&НаКлиенте
Процедура ПослеПодключенияРасширения(Результат, ДополнительныеПараметры) Экспорт
	ПараметрНастройки = Новый Структура;
	ПараметрНастройки.Вставить("ГодStatistics", ГодStatistics);

	Закрыть(ПараметрНастройки);
КонецПроцедуры  
// rarus tenkam 09.04.2019 mantis 14195 ---
