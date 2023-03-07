//rarus abrant 17.07.2017 mantis 9146 +++
&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	СуммаПриИзмененииНаСервере()
КонецПроцедуры

&НаСервере
Процедура СуммаПриИзмененииНаСервере()
	Если Запись.СтавкаНДС = Справочники.Scan_СтавкиНДС.БезНДС Тогда
		Запись.СуммаНДС = 0;
	ИначеЕсли Запись.СтавкаНДС = Справочники.Scan_СтавкиНДС.ОсновнаяСтавкаНДС Тогда
		// rarus tenkam 24.12.2018 mantis 13896 +++
		//Запись.СуммаНДС = Запись.Сумма*0.18;
		Запись.СуммаНДС = Запись.Сумма*(Справочники.Scan_СтавкиНДС.ОсновнаяСтавкаНДС.Ставка / 100);
		// rarus tenkam 24.12.2018 mantis 13896 ---
	КонецЕсли;
	Запись.СуммаСНДС = Запись.Сумма + Запись.СуммаНДС;
	Если Расстояние <> 0 Тогда
		// rarus tenkam 27.12.2018 mantis 13896 +++
		//Запись.Стоимость1Км = Запись.СуммаСНДС/Расстояние;
		Запись.Стоимость1Км = Запись.Сумма/Расстояние;
		// rarus tenkam 27.12.2018 mantis 13896 ---
	Иначе
		Запись.Стоимость1Км = 0;
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура СуммаСНДСПриИзменении(Элемент)
	СуммаСНДСПриИзмененииНаСервере()
КонецПроцедуры

&НаСервере
Процедура СуммаСНДСПриИзмененииНаСервере()
	Если Запись.СтавкаНДС = Справочники.Scan_СтавкиНДС.БезНДС Тогда
		Запись.Сумма = Запись.СуммаСНДС;
	ИначеЕсли Запись.СтавкаНДС = Справочники.Scan_СтавкиНДС.ОсновнаяСтавкаНДС Тогда
		// rarus tenkam 24.12.2018 mantis 13896 +++
		//Запись.Сумма = Запись.СуммаСНДС/1.18;
		Запись.Сумма = Запись.СуммаСНДС/(1 + Справочники.Scan_СтавкиНДС.ОсновнаяСтавкаНДС.Ставка / 100)
		// rarus tenkam 24.12.2018 mantis 13896 ---
	КонецЕсли;
	Запись.СуммаНДС = Запись.СуммаСНДС - Запись.Сумма;
	Если Расстояние <> 0 Тогда
		// rarus tenkam 27.12.2018 mantis 13896 +++
		//Запись.Стоимость1Км = Запись.СуммаСНДС/Расстояние;
		Запись.Стоимость1Км = Запись.Сумма/Расстояние;
		// rarus tenkam 27.12.2018 mantis 13896 ---	
	Иначе
		Запись.Стоимость1Км = 0;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Запись.АдресДоставки) И ЗначениеЗаполнено(Запись.АдресПолучения) Тогда
		Расстояние = ПолучитьРасстояние(Запись.АдресДоставки,Запись.АдресПолучения);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьРасстояние(АдресДоставки, АдресПолучения)
	
	РасстояниеМеждуАдресами = 0;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_РасстояниеМеждуАдресами.Расстояние
		|ИЗ
		|	РегистрСведений.Scan_РасстояниеМеждуАдресами КАК Scan_РасстояниеМеждуАдресами
		|ГДЕ
		|	(Scan_РасстояниеМеждуАдресами.АдресПолучения = &АдресПолучения
		|				И Scan_РасстояниеМеждуАдресами.АдресДоставки = &АдресДоставки
		|			ИЛИ Scan_РасстояниеМеждуАдресами.АдресДоставки = &АдресПолучения
		|				И Scan_РасстояниеМеждуАдресами.АдресПолучения = &АдресДоставки)";
	
	Запрос.УстановитьПараметр("АдресДоставки", АдресДоставки);
	Запрос.УстановитьПараметр("АдресПолучения", АдресПолучения);
	
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() > 0 Тогда
		РасстояниеМеждуАдресами = Результат[0].Расстояние; 
	КонецЕсли;
	
	Возврат РасстояниеМеждуАдресами;
	
КонецФункции

&НаКлиенте
Процедура АдресПолученияПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Запись.АдресДоставки) И ЗначениеЗаполнено(Запись.АдресПолучения) Тогда
		Расстояние = ПолучитьРасстояние(Запись.АдресДоставки,Запись.АдресПолучения);
	КонецЕсли;
	СуммаПриИзменении(Элемент);
КонецПроцедуры

//rarus abrant 17.07.2017 mantis 9146 ---