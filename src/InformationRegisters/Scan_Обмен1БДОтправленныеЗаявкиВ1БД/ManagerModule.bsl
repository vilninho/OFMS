//rarus tenkam 16.02.2018 mantis 9428 +++ интеграция

Функция ДанныеПоДокументуОтправленыв1БД(ЗаявкаНаСервисныеРаботы) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_Обмен1БДОтправленныеЗаявкиВ1БД.GuidЗаявки1БД КАК GuidЗаявки1БД
		|ИЗ
		|	РегистрСведений.Scan_Обмен1БДОтправленныеЗаявкиВ1БД КАК Scan_Обмен1БДОтправленныеЗаявкиВ1БД
		|ГДЕ
		|	Scan_Обмен1БДОтправленныеЗаявкиВ1БД.ЗаявкаНаСервисныеРаботы = &ЗаявкаНаСервисныеРаботы";
	
	Запрос.УстановитьПараметр("ЗаявкаНаСервисныеРаботы", ЗаявкаНаСервисныеРаботы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат Истина;
	КонецЕсли;  
	
	Возврат Ложь;
	
КонецФункции

//rarus tenkam 16.02.2018 mantis 9428 --- интеграция
