//rarus tenkam 09.08.2017 mantis 10589 +++
Функция ПолучитьСтоимостьТарифаПоПакету(ПакетУслуг, ДатаДоставки, АдресПолучения, АдресДоставки, СпособДоставки, ЛогистическийТип, КолеснаяФормула) Экспорт
	СтоимостьДоставки = 0;
	
	АктуальныеУслуги = Новый ТаблицаЗначений;
	АктуальныеУслуги.Колонки.Добавить("Выбрать");
	АктуальныеУслуги.Колонки.Добавить("Услуга");
	АктуальныеУслуги.Колонки.Добавить("Стоимость");

	// Получим полную и льготные услуги
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Scan_МатрицаТарифовДляДилеровПоДоставкеИзделийСрезПоследних.УслугаПакета КАК Услуга,
	|	Scan_МатрицаТарифовДляДилеровПоДоставкеИзделийСрезПоследних.Стоимость
	|ИЗ
	|	РегистрСведений.Scan_МатрицаТарифовДляДилеровПоДоставкеИзделий.СрезПоследних(
	|			&ДатаДоставки,
	|			СпособДоставки = &СпособДоставки
	|				И АдресДоставки = &АдресДоставки
	|				И АдресПолучения = &АдресПолучения
	|				И КолеснаяФормула = &КолеснаяФормула
	|				И ЛогистическийТип = &ЛогистическийТип) КАК Scan_МатрицаТарифовДляДилеровПоДоставкеИзделийСрезПоследних";
	Запрос.УстановитьПараметр("АдресДоставки", АдресДоставки);
	Запрос.УстановитьПараметр("АдресПолучения", АдресПолучения);
	Запрос.УстановитьПараметр("ДатаДоставки", ДатаДоставки);
	Запрос.УстановитьПараметр("КолеснаяФормула", КолеснаяФормула);
	Запрос.УстановитьПараметр("ЛогистическийТип", ЛогистическийТип);
	Запрос.УстановитьПараметр("СпособДоставки", СпособДоставки);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НоваяУслуга = АктуальныеУслуги.Добавить();
		НоваяУслуга.Услуга = ВыборкаДетальныеЗаписи.Услуга;
		НоваяУслуга.Стоимость = ВыборкаДетальныеЗаписи.Стоимость;
		НоваяУслуга.Выбрать = Ложь;
	КонецЦикла;

	// Получим основную и доп. услуги	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних.Услуга,
	|	Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних.Стоимость,
	|	Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних.ОсновнаяУслуга
	|ИЗ
	|	РегистрСведений.Scan_СтоимостьУслугДляРасчетаСтоимостиДоставки.СрезПоследних(
	|			&ДатаДоставки,
	|			Услуга <> ЗНАЧЕНИЕ(Справочник.Scan_НоменклатураУслуг.УслугаПлатон)) КАК Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних";	
	Запрос.УстановитьПараметр("ДатаДоставки", ДатаДоставки);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НоваяУслуга = АктуальныеУслуги.Добавить();
		НоваяУслуга.Услуга = ВыборкаДетальныеЗаписи.Услуга;
		// rarus tenkam 24.12.2018 mantis 13896 +++    		
		//НоваяУслуга.Стоимость = ?(ВыборкаДетальныеЗаписи.ОсновнаяУслуга, ВыборкаДетальныеЗаписи.Стоимость * 1.18, ВыборкаДетальныеЗаписи.Стоимость);		
		НоваяУслуга.Стоимость = ?(ВыборкаДетальныеЗаписи.ОсновнаяУслуга, ВыборкаДетальныеЗаписи.Стоимость * (1 + Справочники.Scan_СтавкиНДС.ОсновнаяСтавкаНДС.Ставка / 100), ВыборкаДетальныеЗаписи.Стоимость);
		// rarus tenkam 24.12.2018 mantis 13896 ---
		НоваяУслуга.Выбрать = Ложь;	
	КонецЦикла;
	
	// Получим Платона
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних.Услуга,
	|	Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних.Стоимость
	|ИЗ
	|	РегистрСведений.Scan_СтоимостьУслугДляРасчетаСтоимостиДоставки.СрезПоследних(
	|			&ДатаДоставки,
	|			Услуга = ЗНАЧЕНИЕ(Справочник.Scan_НоменклатураУслуг.УслугаПлатон)
	|				И СпособДоставки = &СпособДоставки
	|				И АдресПолучения = &АдресПолучения
	|				И АдресДоставки = &АдресДоставки) КАК Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних";	
	Запрос.УстановитьПараметр("ДатаДоставки", ДатаДоставки);
	Запрос.УстановитьПараметр("СпособДоставки", СпособДоставки);
	Запрос.УстановитьПараметр("АдресПолучения", АдресПолучения);
	Запрос.УстановитьПараметр("АдресДоставки", АдресДоставки);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		НоваяУслуга = АктуальныеУслуги.Добавить();
		НоваяУслуга.Услуга = ВыборкаДетальныеЗаписи.Услуга;
		НоваяУслуга.Стоимость = ВыборкаДетальныеЗаписи.Стоимость;
		НоваяУслуга.Выбрать = Ложь;
	КонецЕсли;
	
	// Получим ОСАГО
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних.Услуга,
	|	Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних.Стоимость
	|ИЗ
	|	РегистрСведений.Scan_СтоимостьУслугДляРасчетаСтоимостиДоставки.СрезПоследних(
	|			&ДатаДоставки,
	|			Услуга = ЗНАЧЕНИЕ(Справочник.Scan_НоменклатураУслуг.ПолисОСАГО)
	|				И СпособДоставки = &СпособДоставки) КАК Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних";	
	Запрос.УстановитьПараметр("ДатаДоставки", ДатаДоставки);
	Запрос.УстановитьПараметр("СпособДоставки", СпособДоставки);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		НоваяУслуга = АктуальныеУслуги.Добавить();
		НоваяУслуга.Услуга = ВыборкаДетальныеЗаписи.Услуга;
		НоваяУслуга.Стоимость = ВыборкаДетальныеЗаписи.Стоимость;
		НоваяУслуга.Выбрать = Ложь;
	КонецЕсли;
	
	// Получим Получение транзитных номеров
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних.Услуга,
	|	Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних.Стоимость
	|ИЗ
	|	РегистрСведений.Scan_СтоимостьУслугДляРасчетаСтоимостиДоставки.СрезПоследних(
	|			&ДатаДоставки,
	|			Услуга = ЗНАЧЕНИЕ(Справочник.Scan_НоменклатураУслуг.ПолучениеТранзитныхНомеров)
	|				И СпособДоставки = &СпособДоставки) КАК Scan_СтоимостьУслугДляРасчетаСтоимостиДоставкиСрезПоследних";	
	Запрос.УстановитьПараметр("ДатаДоставки", ДатаДоставки);
	Запрос.УстановитьПараметр("СпособДоставки", СпособДоставки);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		НоваяУслуга = АктуальныеУслуги.Добавить();
		НоваяУслуга.Услуга = ВыборкаДетальныеЗаписи.Услуга;
		НоваяУслуга.Стоимость = ВыборкаДетальныеЗаписи.Стоимость;
		НоваяУслуга.Выбрать = Ложь;
	КонецЕсли;       	
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Услуга");
	Для Каждого ТекУслуга Из ПакетУслуг.СоставУслугПакета Цикл
		СтруктураПоиска.Услуга = ТекУслуга.Услуга;
		НайденныеСтроки = АктуальныеУслуги.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСтроки.Количество() <> 0 Тогда
			НайденнаяУслуга = НайденныеСтроки[0];
			НайденнаяУслуга.Выбрать = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ТекСтрокаУслуги Из АктуальныеУслуги Цикл
		Если ТекСтрокаУслуги.Выбрать Тогда
			СтоимостьДоставки = СтоимостьДоставки + ТекСтрокаУслуги.Стоимость;
		КонецЕсли;
	КонецЦикла;
	Возврат СтоимостьДоставки;

КонецФункции
//rarus tenkam 09.08.2017 mantis 10589 ---