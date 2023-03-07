&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка) //rarus bonmak 08.10.2019 14177 ++
	//rarus ozhnik 16453 08.09.2020 + 	
	Если параметры.свойство("СоглашениеОПоставке") Тогда
		ЗаполнитьСписокВерсийПоПараметрам(Параметры.СоглашениеОПоставке, Параметры.СпециальныеУсловия);
	КонецЕсли; 	
	//rarus ozhnik 16453 08.09.2020 -
	Scan_СборСтатистики.Scan_ПриОткрытииОтчета(РеквизитФормыВЗначение("Отчет").Метаданные().Синоним); // Rarus tenkam 11.04.2022 mantis 18433 +
КонецПроцедуры //rarus bonmak 08.10.2019 14177 --

&НаСервере
Функция ПолучитьПервоеСоглашениеОПоставке(СоглашениеОПоставке) //rarus bonmak 16453 23.10.2020 ++
	//получаем первый элемент основание
	ЗначениеРеквизита = СоглашениеОПоставке.Основание;
	Если ЗначениеЗаполнено(ЗначениеРеквизита)
		И ЗначениеРеквизита <> СоглашениеОПоставке Тогда
		ЗначениеРеквизита = ПолучитьПервоеСоглашениеОПоставке(ЗначениеРеквизита);
	Иначе
		ЗначениеРеквизита = СоглашениеОПоставке;
	КонецЕсли;	
	Возврат ЗначениеРеквизита;
КонецФункции //rarus bonmak 16453 23.10.2020 --

&НаКлиенте
Процедура ПриОткрытии(Отказ) //rarus bonmak 08.10.2019 14177 ++
	Если ЭтотОбъект.ВладелецФормы <> Неопределено Тогда 
		ЭтотОбъект.Изделие = ЭтотОбъект.ВладелецФормы.ЭтаФорма.ЭтотОбъект.Объект.Ссылка;
		ЗаполнитьСписокВерсий();
	КонецЕсли;
КонецПроцедуры //rarus bonmak 08.10.2019 14177 --

&НаСервере
Процедура ЗаполнитьСписокВерсий() //rarus bonmak 08.10.2019 14177 ++
	ЭтотОбъект.СписокВерсий.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_ВерсииСпецификаций.Спецификация КАК Спецификация,
		|	Scan_ВерсииСпецификаций.ВидСпецификации КАК ВидСпецификации,
		|	Scan_ВерсииСпецификаций.Версия КАК Версия,
		|	Scan_ВерсииСпецификаций.Опции КАК Опции
		|ИЗ
		|	РегистрСведений.Scan_ВерсииСпецификаций КАК Scan_ВерсииСпецификаций
		|ГДЕ
		|	Scan_ВерсииСпецификаций.Спецификация.Владелец.Изделие = &Изделие";
	
	Запрос.УстановитьПараметр("Изделие", ЭтотОбъект.Изделие);
	
	РезультатЗапроса = Запрос.Выполнить();
		
	ЭтотОбъект.СписокВерсий.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры //rarus bonmak 08.10.2019 14177 --

&НаСервере
Процедура ЗаполнитьСписокВерсийПоПараметрам(СоглашениеОПоставке, СпециальныеУсловия) //rarus ozhnik 16453 08.09.2020 + 
	ЭтотОбъект.СписокВерсий.Очистить();
	
	//rarus bonmak 16453 23.10.2020 ++
	ПервоеСоглашениеОПоставке = ПолучитьПервоеСоглашениеОПоставке(СоглашениеОПоставке);	
	//rarus bonmak 16453 23.10.2020 --			
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_СоглашенияОПоставке.КоммерческоеПредложениеSPORT КАК КоммерческоеПредложениеSPORT,
		|	Scan_СоглашенияОПоставке.IDПродуктаКП КАК IDПродуктаКП,
		|	Scan_КоммерческиеПредложенияПродуктыКП.Спецификация КАК Спецификация,
		//rarus bonmak 16453 23.10.2020 ++
		//|	Scan_СоглашенияОПоставке.Ссылка КАК ОбъектИспользования
		|	&СсылкаСОППервое КАК ОбъектИспользования
		//rarus bonmak 16453 23.10.2020 --
		|ПОМЕСТИТЬ ВТ_Спецификации
		|ИЗ
		|	Справочник.Scan_СоглашенияОПоставке КАК Scan_СоглашенияОПоставке
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Scan_КоммерческиеПредложения.ПродуктыКП КАК Scan_КоммерческиеПредложенияПродуктыКП
		|		ПО Scan_СоглашенияОПоставке.КоммерческоеПредложениеSPORT = Scan_КоммерческиеПредложенияПродуктыКП.Ссылка
		|			И Scan_СоглашенияОПоставке.IDПродуктаКП = Scan_КоммерческиеПредложенияПродуктыКП.IDПродуктаКП
		|ГДЕ
		|	Scan_СоглашенияОПоставке.Ссылка = &СсылкаСОП
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Scan_СпециальныеУсловия.КоммерческоеПредложениеSPORT,
		|	Scan_СпециальныеУсловия.IDПродуктаКП,
		|	Scan_КоммерческиеПредложенияПродуктыКП.Спецификация,
		|	Scan_СпециальныеУсловия.Ссылка
		|ИЗ
		|	Справочник.Scan_СпециальныеУсловия КАК Scan_СпециальныеУсловия
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Scan_КоммерческиеПредложения.ПродуктыКП КАК Scan_КоммерческиеПредложенияПродуктыКП
		|		ПО Scan_СпециальныеУсловия.КоммерческоеПредложениеSPORT = Scan_КоммерческиеПредложенияПродуктыКП.Ссылка
		|			И Scan_СпециальныеУсловия.IDПродуктаКП = Scan_КоммерческиеПредложенияПродуктыКП.IDПродуктаКП
		|ГДЕ
		|	Scan_СпециальныеУсловия.Ссылка = &СсылкаСУ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Спецификации.КоммерческоеПредложениеSPORT КАК КоммерческоеПредложениеSPORT,
		|	ВТ_Спецификации.IDПродуктаКП КАК IDПродуктаКП,
		|	ВТ_Спецификации.Спецификация КАК Спецификация,
		|	ВТ_Спецификации.ОбъектИспользования КАК ОбъектИспользования,
		|	Scan_ВерсииБазовыхСпецификацийИспользование.Ссылка КАК ВерсияБазовойСпецификации,
		|	Scan_ВерсииБазовыхСпецификацийИспользование.ВерсияСпецификации КАК ВерсияСпецификации
		|ПОМЕСТИТЬ ВТ_ВерсииБазовыхСпецификации
		|ИЗ
		|	ВТ_Спецификации КАК ВТ_Спецификации
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Scan_ВерсииБазовыхСпецификаций.Использование КАК Scan_ВерсииБазовыхСпецификацийИспользование
		|		ПО ВТ_Спецификации.ОбъектИспользования = Scan_ВерсииБазовыхСпецификацийИспользование.ОбъектИспользования
		|ГДЕ
		|	Scan_ВерсииБазовыхСпецификацийИспользование.Ссылка.ВидСпецификации = &ВидСпецификации
		//rarus bonmak 16453 23.10.2020 ++
		|   И Scan_ВерсииБазовыхСпецификацийИспользование.Ссылка.Владелец.Изделие = ЗНАЧЕНИЕ(Справочник.Scan_Изделия.ПустаяСсылка)
		//rarus bonmak 16453 23.10.2020 --
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ВерсииБазовыхСпецификации.КоммерческоеПредложениеSPORT КАК КоммерческоеПредложениеSPORT,
		|	ВТ_ВерсииБазовыхСпецификации.IDПродуктаКП КАК IDПродуктаКП,
		|	ВТ_ВерсииБазовыхСпецификации.Спецификация КАК СпецификацияПродукта,
		|	ВТ_ВерсииБазовыхСпецификации.ОбъектИспользования КАК Объект,
		|	ВТ_ВерсииБазовыхСпецификации.ВерсияБазовойСпецификации КАК ВерсияБазовойСпецификации,
		|	ВТ_ВерсииБазовыхСпецификации.ВерсияСпецификации КАК ВерсияСпецификации,
		|	Scan_ВерсииСпецификаций.Спецификация КАК Спецификация,
		|	Scan_ВерсииСпецификаций.ВидСпецификации КАК ВидСпецификации,
		|	Scan_ВерсииСпецификаций.Версия КАК Версия,
		|	Scan_ВерсииСпецификаций.Опции КАК Опции
		|ИЗ
		|	ВТ_ВерсииБазовыхСпецификации КАК ВТ_ВерсииБазовыхСпецификации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Scan_ВерсииСпецификаций КАК Scan_ВерсииСпецификаций
		|		ПО ВТ_ВерсииБазовыхСпецификации.ВерсияБазовойСпецификации = Scan_ВерсииСпецификаций.Спецификация
		|			И ВТ_ВерсииБазовыхСпецификации.ВерсияСпецификации = Scan_ВерсииСпецификаций.Версия";
	
	Запрос.УстановитьПараметр("СсылкаСОП", СоглашениеОПоставке);
	Запрос.УстановитьПараметр("СсылкаСУ", СпециальныеУсловия);
	Запрос.УстановитьПараметр("СсылкаСОППервое", ПервоеСоглашениеОПоставке); //rarus bonmak 16453 23.10.2020

	Запрос.УстановитьПараметр("ВидСпецификации", Справочники.Scan_ВидыСпецификацийПродуктов.SPORTСпецификация);
	
	РезультатЗапроса = Запрос.Выполнить();	
	ЭтотОбъект.СписокВерсий.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры //rarus ozhnik 16453 08.09.2020 -

&НаКлиенте
Процедура СписокВерсийФлагПриИзменении(Элемент) //rarus bonmak 08.10.2019 14177 ++

	Если Элементы.СписокВерсий.ТекущиеДанные.Флаг Тогда
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Флаг", Истина);
		НайденныеСтроки = ЭтотОбъект.СписокВерсий.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() = 3 Тогда
			Элементы.СписокВерсий.ТекущиеДанные.Флаг = Ложь;
			Сообщить(НСтр("ru = 'Нельзя выбирать больше 2-х версий'; en = 'You cannot select more than 2 versions'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры //rarus bonmak 08.10.2019 14177 --

&НаКлиенте 
Процедура СформироватьОтчет(Команда) //rarus bonmak 08.10.2019 14177 ++ 	
	//Сформируем отчет
	СформироватьОтчетНаСервере(Результат); 
	// Чтобы не писалось «Отчет не сформирован…» 
	Элементы.Результат.ОтображениеСостояния.Видимость = Ложь; 
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать; 
КонецПроцедуры //rarus bonmak 08.10.2019 14177 --

&НаСервере 
Процедура СформироватьОтчетНаСервере(ТаблДок) //rarus bonmak 08.10.2019 14177 ++
	СтандартнаяОбработка = Ложь;
	Если ЭтотОбъект.СписокВерсий.Количество() < 2 Тогда
		Сообщить(НСтр("ru = 'Не выбраны версии для сравнения'; en = 'No versions to compare'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Флаг", Истина);
	НайденныеСтроки = ЭтотОбъект.СписокВерсий.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтроки.Количество() < 2 Тогда
		Сообщить(НСтр("ru = 'Необходимо выбрать 2 версии для сравнения'; en = 'You must select 2 versions to compare'"));
		Возврат;
	КонецЕсли;

	Опции1 = НайденныеСтроки[0].Опции;
	Опции2 = НайденныеСтроки[1].Опции;
	ОпцииВерсия1 = Справочники.Scan_ВерсииБазовыхСпецификаций.РазобратьСтрокуОпций(Опции1);
	ОпцииВерсия2 = Справочники.Scan_ВерсииБазовыхСпецификаций.РазобратьСтрокуОпций(Опции2);
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Версия1.Опция КАК Опция
		|ПОМЕСТИТЬ ТабВерсия1
		|ИЗ
		|	&Версия1 КАК Версия1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Версия2.Опция КАК Опция
		|ПОМЕСТИТЬ ТабВерсия2
		|ИЗ
		|	&Версия2 КАК Версия2
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабВерсия1.Опция.код КАК ОпцияВариант1,
		|	ТабВерсия2.Опция.код КАК ОпцияВариант2,
		|	ТабВерсия1.Опция.Наименование КАК Наименование1,
		|	ТабВерсия2.Опция.Наименование КАК Наименование2,
		|	ЕСТЬNULL(ТабВерсия1.Опция.Родитель.Код, ТабВерсия2.Опция.Родитель.Код) КАК Семейство
		|ИЗ
		|	ТабВерсия1 КАК ТабВерсия1
		|		ПОЛНОЕ СОЕДИНЕНИЕ ТабВерсия2 КАК ТабВерсия2
		|		ПО ТабВерсия1.Опция.Родитель = ТабВерсия2.Опция.Родитель"
		+ Символы.ПС + ?(ЭтотОбъект.ТолькоОтличия, 
			"ГДЕ
			|ВЫБОР
			|КОГДА ЕСТЬNULL(ТабВерсия2.Опция, Значение(Справочник.Scan_ОпцииПродуктов.ПустаяСсылка)) <> ЕСТЬNULL(ТабВерсия1.Опция, Значение(Справочник.Scan_ОпцииПродуктов.ПустаяСсылка))
			|ТОГДА ИСТИНА
			|ИНАЧЕ ЛОЖЬ
			|КОНЕЦ", "") +"
		|
		|УПОРЯДОЧИТЬ ПО
		|	Семейство";
		
	Запрос.Параметры.Вставить("Версия1",ОпцииВерсия1);
	Запрос.Параметры.Вставить("Версия2",ОпцииВерсия2);
	РезультатЗапроса = Запрос.Выполнить();
	
	тзОпции = РезультатЗапроса.Выгрузить();
			
	ОбъектОтчет = РеквизитФормыВЗначение("Отчет"); 

	СхемаКомпоновкиДанных = ОбъектОтчет.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	КомпоновщикНастроекДанных = Новый КомпоновщикНастроекКомпоновкиДанных; 
	КомпоновщикНастроекДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных)); 
	КомпоновщикНастроекДанных.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию); 
	КомпоновщикНастроекДанных.ЗагрузитьПользовательскиеНастройки(Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);

	НастройкиОСКД = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	//rarus bonmak 16453 23.10.2020 ++
	Если ЗначениеЗаполнено(НайденныеСтроки[0].Объект) Тогда
		НаименованиеВерсии1 = "Вариант 1 - " + НайденныеСтроки[0].Объект; 
		НаименованиеВерсии2 = "Вариант 2 - " + НайденныеСтроки[1].Объект; 
		НастройкиОСКД.ПараметрыДанных.УстановитьЗначениеПараметра("Версия1",НаименованиеВерсии1);
		НастройкиОСКД.ПараметрыДанных.УстановитьЗначениеПараметра("Версия2",НаименованиеВерсии2);
	Иначе
		НаименованиеВерсии1 = "Вариант 1 - " + НайденныеСтроки[0].ВидСпецификации + ", версия " + НайденныеСтроки[0].Версия; 
		НаименованиеВерсии2 = "Вариант 2 - " + НайденныеСтроки[1].ВидСпецификации + ", версия " + НайденныеСтроки[1].Версия; 
		НастройкиОСКД.ПараметрыДанных.УстановитьЗначениеПараметра("Версия1",НаименованиеВерсии1);
		НастройкиОСКД.ПараметрыДанных.УстановитьЗначениеПараметра("Версия2",НаименованиеВерсии2);
	КонецЕсли;
	//rarus bonmak 16453 23.10.2020 --
		
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОСКД);
	
	ВнешнийНаборДанных = Новый Структура("ТабОпций", тзОпции);
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешнийНаборДанных);
	
	ТаблДок.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТаблДок);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

КонецПроцедуры //rarus bonmak 08.10.2019 14177 --


&НаКлиенте
Процедура ИзделиеПриИзменении(Элемент) //rarus bonmak 08.10.2019 14177 ++
	Если ЭтотОбъект.Изделие <> Неопределено Тогда 
		ЗаполнитьСписокВерсий();
	КонецЕсли;
КонецПроцедуры //rarus bonmak 08.10.2019 14177 --

