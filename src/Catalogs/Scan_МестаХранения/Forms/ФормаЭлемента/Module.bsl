Перем ИзмененыеРеквизиты; 	//rarus bonmak 02.12.2019 14375 

&НаСервере
Процедура СкладПроизводителяПриИзмененииНаСервере() //rarus bonmak 05.10.2020 16592 ++
	Если НЕ Объект.Маршрут Тогда
		Если Объект.СкладПроизводителя Тогда
			Объект.ФормироватьЧекЛисты = Ложь;
		Иначе
			Если (Объект.ТипСклада = Перечисления.Scan_ТипыСклада.Производство ИЛИ 
				Объект.ТипСклада = Перечисления.Scan_ТипыСклада.Хранение) И
				НЕ Объект.ЗарубежныйКузовостроитель И НЕ Объект.СкладПроизводителя Тогда
				Объект.ФормироватьЧекЛисты = Истина;
			Иначе
				Объект.ФормироватьЧекЛисты = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры //rarus bonmak 05.10.2020 16592 --

&НаКлиенте
Процедура СкладПроизводителяПриИзменении(Элемент) //rarus bonmak 05.10.2020 16592 ++
	СкладПроизводителяПриИзмененииНаСервере();
КонецПроцедуры //rarus bonmak 05.10.2020 16592 --

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	//rarus tenkam 09.03.2017 (update) +++
	Если Параметры.Свойство("Контрагент") Тогда 
		//rarus bonmak 03.06.2020 16165 ++
		//rarus bonmak 15.04.2020 14456 ++
		Объект.Контрагент = Параметры.Контрагент; 
		//rarus bonmak 15.04.2020 14456 --
		//rarus bonmak 03.06.2020 16165 --
	КонецЕсли;
	//rarus tenkam 09.03.2017 ---
	
	//rarus tenkam 05.10.2016 mantis 7183 ++
	Если Параметры.Свойство("СоздатьМаршрут") Тогда
		Объект.Маршрут = Истина;
		Объект.Родитель = Справочники.Scan_МестаХранения.Маршруты;
	КонецЕсли;

	//rarus tenkam 05.10.2016 mantis 7183 --
	
	//rarus sergei 12.12.2016 mantis 8057 ++
	Если ЗначениеЗаполнено(Объект.Ссылка) И Объект.Маршрут =  ЛОЖЬ Тогда
		ЗаполнитьКЛПоКонтрагенту();
		КодАдресаДоставки = РегистрыСведений.Scan_СоответствиеКодовАдресовДоставки.ПолучитьКодАдресаДоставки(Объект.Ссылка);	//rarus tenkam 27.07.2017 mantis 10271 +
	КонецЕсли; 
	//rarus sergei 12.12.2016 mantis 8057 --
	
	Если Параметры.Ключ.Пустая() Тогда
		//новый элемент
		//rarus tenkam 05.10.2016 mantis 7183 ++
		Если Параметры.Свойство("СоздатьМаршрут") Тогда
			Объект.Маршрут = Истина;
			Объект.Родитель = Справочники.Scan_МестаХранения.Маршруты;
			Если Параметры.Свойство("ИсходныйПункт") Тогда
				Объект.ИсходныйПункт = Параметры.ИсходныйПункт;
			КонецЕсли;
			Если Параметры.Свойство("КонечныйПункт") Тогда
				Объект.КонечныйПункт = Параметры.КонечныйПункт;
			КонецЕсли;
			СформироватьНаименование();
			УправлениеДиалогомНаСервере();
			ПолучитьСрокиДоставки();	
			Элементы.Маршрут.Доступность = Ложь;
		Иначе
		//rarus tenkam 05.10.2016 mantis 7183 --
			
			Элементы.Маршрут.Доступность = Истина;
			Если НЕ ЗначениеЗаполнено(Объект.Родитель) Тогда
				Объект.Родитель = Справочники.Scan_МестаХранения.МестаХранения;
			КонецЕсли;
			Объект.Маршрут = (Объект.Родитель = Справочники.Scan_МестаХранения.Маршруты);
			Объект.НеЗапрещатьПеремещениеМестаХранения = Истина; // Rarus tenkam 07.12.2021 mantis 18622 +
		КонецЕсли;	//rarus tenkam 05.10.2016 mantis 7183 +
	Иначе
		Элементы.Маршрут.Доступность = Ложь;
		НаименованиеСтарое = Объект.Наименование;
	КонецЕсли;
	
	//rarus tenkam 05.10.2016 mantis ++
	Если Объект.СрокиДоставки.Количество() = 0  Тогда
		ЗаполнитьСрокиДоставки();
	КонецЕсли;
	//rarus tenkam 05.10.2016 mantis --
	
	//rarus abrant 06.06.2017 mantis 9146 +++
	Элементы.Расстояние.Видимость = Ложь; //нужно будет вернуть обратно после проверки!!
	Если Объект.Маршрут Тогда
		Элементы.Расстояние.Видимость = Истина;
		Расстояние = ПолучитьРасстояниеМеждуАдресами();
	Иначе
		Элементы.Расстояние.Видимость = Ложь;
	КонецЕсли;
	//rarus abrant 06.06.2017 mantis 9146 ---

	УправлениеДиалогомНаСервере();
	Scan_СборСтатистики.Scan_ПриОткрытии("Справочники", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Scan_ВспомогательныеФункцииКлиент.ПроверитьПользователяПортала();//rarus vikhle 07.05.2020 mt 15695
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	//найдем маршрут с такими же конечными и исходными пунктами 
	Если Объект.Маршрут Тогда
		Если Объект.ИсходныйПункт = Объект.КонечныйПункт Тогда
			Отказ = Истина;
			//rarus FominskiyAS 19.04.2019  mantis 14191 +++
			//Сообщить("Исходный и конечный пункт маршрута совпадают!");
			Сообщить(НСтр("ru = 'Исходный и конечный пункт маршрута совпадают!'; en = 'Starting point matches with the final destination!'"));
			//rarus FominskiyAS 19.04.2019  mantis 14191 ---  
		КонецЕсли;
	
		Если ТакойМаршрутУжеСуществует() Тогда
			
			Отказ = Истина;
			//rarus FominskiyAS 19.04.2019  mantis 14191 +++
			//Сообщить("Маршрут с таким исходным и конечным пунктом уже существует!");
			Сообщить(НСтр("ru = 'Маршрут с таким исходным и конечным пунктом уже существует!'; en = 'Same route already exists!'"));
			//rarus FominskiyAS 19.04.2019  mantis 14191 ---  
		КонецЕсли;
		
	КонецЕсли;
	
	//rarus bonmak 02.12.2019 14375 ++
	ИзмененыеРеквизиты = Ложь;
	Если НЕ Отказ Тогда
		Если НЕ Объект.ЭтоГруппа Тогда
			Если Объект.Ссылка["Наименование"] <> Объект.Наименование ИЛИ Объект.Ссылка["Код"] <> Объект.Код ИЛИ Объект.Ссылка["АдресСкладаЛогистический"] <> Объект.АдресСкладаЛогистический 
				ИЛИ Объект.Ссылка["ТипСклада"] <> Объект.ТипСклада 
				//rarus bonmak 15.04.2020 14456 ИЛИ Объект.Ссылка["Контрагент"] <> Объект.Контрагент 
				ИЛИ Объект.Ссылка["ИсходныйПункт"] <> Объект.ИсходныйПункт 
				ИЛИ Объект.Ссылка["КонечныйПункт"] <> Объект.КонечныйПункт ИЛИ Объект.Ссылка["СкладПроизводителя"] <> Объект.СкладПроизводителя 
				ИЛИ Объект.Ссылка["Маршрут"] <> Объект.Маршрут ИЛИ Объект.Ссылка["ПометкаУдаления"] <> Объект.ПометкаУдаления 
				ИЛИ Объект.Ссылка["Недействительный"] <> Объект.Недействительный  Тогда //rarus pechek 06.05.2020 mantis 15981
				ИзмененыеРеквизиты = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	//rarus bonmak 02.12.2019 14375 --
	// Rarus tenkam 11.04.2022 mantis 18433 +++
	Если Объект.Ссылка.Пустая() Тогда
		Scan_СборСтатистики.Scan_ПередЗаписьюСправочника(РеквизитФормыВЗначение("Объект").Метаданные().Синоним, Истина, "Создание нового элемента");
	КонецЕсли;
	// Rarus tenkam 11.04.2022 mantis 18433 --- 
  
КонецПроцедуры

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	Если Объект.Маршрут Тогда
		Элементы.ГруппаХарактеристикиМаршрута.Видимость = Истина;
		Элементы.ГруппаХарактеристикиПлощадки.Видимость = Ложь;
		Элементы.ДекорацияВнимание.Видимость = Ложь;
		Элементы.ГруппаКонтактныеЛицаКонтрагента.Видимость = Ложь; //rarus sergei 12.12.2016 mantis 8057 +
		
		Если ЗначениеЗаполнено(Объект.ИсходныйПункт) Тогда
			Элементы.ДекорацияАдресОтгрузки.Видимость = Истина;
			Элементы.ДекорацияАдресОтгрузки.Заголовок = Объект.ИсходныйПункт.АдресСкладаФактический;
		Иначе
			Элементы.ДекорацияАдресОтгрузки.Видимость = Ложь;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.КонечныйПункт) Тогда
			Элементы.ДекорацияАдресДоставки.Видимость = Истина;
			Элементы.ДекорацияАдресДоставки.Заголовок = Объект.КонечныйПункт.АдресСкладаФактический;
		Иначе
			Элементы.ДекорацияАдресДоставки.Видимость = Ложь;
		КонецЕсли;
		
		//// rarus tenkam 18.04.2018 mantis 12888 +++
		//Элементы.Наименование.ТолькоПросмотр = Ложь;		
		//// rarus tenkam 18.04.2018 mantis 12888 ---
		
	Иначе
		Элементы.ГруппаХарактеристикиМаршрута.Видимость = Ложь;
		Элементы.ГруппаХарактеристикиПлощадки.Видимость = Истина;
		Элементы.ДекорацияВнимание.Видимость = Истина;
		Элементы.ГруппаКонтактныеЛицаКонтрагента.Видимость = Истина; //rarus sergei 12.12.2016 mantis 8057 +
		//rarus tenkam 15.03.2017 mantis 7623 +++
		Если ЗначениеЗаполнено(Объект.ДатаОбновления) И Объект.ТипСклада = Перечисления.Scan_ТипыСклада.Производство И Объект.СкладПроизводителя Тогда
			//Это место производста из 1БД
			Элементы.Наименование.Доступность = Ложь;
		КонецЕсли;
		//rarus tenkam 15.03.2017 mantis 7623 ---
		
		//// rarus tenkam 18.04.2018 mantis 12888 +++
		//Элементы.Наименование.ТолькоПросмотр = Истина;		
		//// rarus tenkam 18.04.2018 mantis 12888 ---

		// rarus tenkam 09.10.2019 mantis 15026 +++		
		Элементы.БуквенныйКод.ТолькоПросмотр = НЕ Объект.СкладПроизводителя;
		// rarus tenkam 09.10.2019 mantis 15026 ---
		//rarus bonmak 05.10.2020 16592 ++		
		Элементы.ФормироватьЧекЛисты.ТолькоПросмотр = НЕ Scan_ПраваИНастройки.Scan_Право("РазрешитьРедактироватьФормироватьЧекЛисты");
		//rarus bonmak 05.10.2020 16592 --
	КонецЕсли;
	
		
КонецПроцедуры // УправлениеДиалогомНаСервере()

&НаКлиенте
Процедура МаршрутПриИзменении(Элемент)
	УправлениеДиалогомНаСервере();
	МаршрутПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура МаршрутПриИзмененииНаСервере()
	Если Объект.Маршрут Тогда
		Объект.Родитель = Справочники.Scan_МестаХранения.Маршруты;
		 
		Объект.Контрагент = Справочники.Scan_Контрагенты.ПустаяСсылка();//rarus bonmak 15.04.2020 14456 //rarus bonmak 03.06.2020 16165 
		Объект.АдресСкладаФактический = "";
		Объект.КоличествоПродуктовНаПлощадке = 0;
		Объект.АдресСкладаЛогистический = Справочники.Scan_АдресаХранения.ПустаяСсылка();	//rarus tenkam 28.09.2016 mantis 7161 +
		ЗаполнитьСрокиДоставки();	//rarus tenkam 05.10.2016 mantis 7161 +
		//rarus abrant 16.06.2017 mantis 9146 +++
		//нужно будет вернуть обратно после проверки!!
		Элементы.Расстояние.Видимость = Истина;
		Расстояние = ПолучитьРасстояниеМеждуАдресами();
		//rarus abrant 16.06.2017 mantis 9146 ---
	Иначе
		Объект.Родитель = Справочники.Scan_МестаХранения.МестаХранения;	
		Объект.ИсходныйПункт = Справочники.Scan_МестаХранения.ПустаяСсылка();
		Объект.КонечныйПункт = Справочники.Scan_МестаХранения.ПустаяСсылка();
		Объект.СрокиДоставки.Очистить();	//rarus tenkam 05.10.2016 mantis 7161 +
		
		//нужно будет вернуть обратно после проверки!!
		Элементы.Расстояние.Видимость = Ложь; //rarus abrant 16.06.2017 mantis 9146 +
		
	КонецЕсли;
	Объект.Наименование = "";
КонецПроцедуры

&НаСервере
Процедура СформироватьНаименование()
	Объект.Наименование = Объект.ИсходныйПункт.Наименование + " - " + Объект.КонечныйПункт.Наименование;	
КонецПроцедуры

&НаКлиенте
Процедура ИсходныйПунктПриИзменении(Элемент)
	СформироватьНаименование();
	УправлениеДиалогомНаСервере();
	ПолучитьСрокиДоставки();	//rarus tenkam 05.10.2016 mantis 7161 +
	//rarus abrant 06.06.2017 mantis 9146 +++
	Расстояние = ПолучитьРасстояниеМеждуАдресами();  //нужно будет вернуть обратно после проверки!!
	//rarus abrant 06.06.2017 mantis 9146 ---
КонецПроцедуры

&НаКлиенте
Процедура КонечныйПунктПриИзменении(Элемент)
	СформироватьНаименование();
	УправлениеДиалогомНаСервере();
	ПолучитьСрокиДоставки();	//rarus tenkam 05.10.2016 mantis 7161 +
	//rarus abrant 06.06.2017 mantis 9146 +++
	Расстояние = ПолучитьРасстояниеМеждуАдресами();  //нужно будет вернуть обратно после проверки!!
	//rarus abrant 06.06.2017 mantis 9146 ---
КонецПроцедуры

//rarus sergei 12.12.2016 mantis 8057 ++
&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	//rarus bonmak 15.04.2020 14456 ++
	//rarus bonmak 03.06.2020 16165 ++
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ЗаполнитьКЛПоКонтрагенту();	
	КонецЕсли;
	//rarus bonmak 03.06.2020 16165 --
	//rarus bonmak 15.04.2020 14456 --
	//rarus abrant 11.04.2017 7164 +++
	//Объект.СтанцияДилера = NULL;
	//rarus abrant 11.04.2017 7164 ---
КонецПроцедуры
//rarus sergei 12.12.2016 mantis 8057 --

&НаСервере
Функция ТакойМаршрутУжеСуществует()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Scan_МестаХранения.Ссылка,
	|	Scan_МестаХранения.ИсходныйПункт,
	|	Scan_МестаХранения.КонечныйПункт
	|ИЗ
	|	Справочник.Scan_МестаХранения КАК Scan_МестаХранения
	|ГДЕ
	|	Scan_МестаХранения.Маршрут = ИСТИНА
	|	И Scan_МестаХранения.ИсходныйПункт = &ИсхПункт
	|	И Scan_МестаХранения.КонечныйПункт = &КонПункт";
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Запрос.Текст = Запрос.Текст + " И Scan_МестаХранения.Ссылка <> &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ИсхПункт", Объект.ИсходныйПункт);
	Запрос.УстановитьПараметр("КонПункт", Объект.КонечныйПункт);
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат Выборка.Следующий();
	
КонецФункции

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Если НЕ Объект.Маршрут И НаименованиеСтарое <> Объект.Наименование Тогда
		ИзменитьНаименованиеМаршрутов();	
	КонецЕсли;
	
	//rarus tenkam 28.09.2016 mantis 7161 ++
	АдресИсходный = Объект.ИсходныйПункт.АдресСкладаЛогистический;
	АдресКонечный = Объект.КонечныйПункт.АдресСкладаЛогистический;
	
	Если Объект.Маршрут И ЗначениеЗаполнено(АдресИсходный) И ЗначениеЗаполнено(АдресКонечный) Тогда
		Для Каждого СтрокаСпособа Из Объект.СрокиДоставки Цикл
			Справочники.Scan_МестаХранения.ЗаписьЗначенияРСМатрицаСроковДоставкиИзделий(АдресИсходный, АдресКонечный, СтрокаСпособа.СпособДоставки,СтрокаСпособа.СрокДоставки);
		КонецЦикла;
	КонецЕсли;
	//rarus tenkam 28.09.2016 mantis 7161 --
	Если Объект.Маршрут = ЛОЖЬ Тогда
		МассивКЛ = Новый Массив;
		Для каждого строкаТЧ Из КонтактныеЛицаКонтрагента Цикл
			Если строкаТЧ.Активность = Истина Тогда
				//rarus pechek 2.04.2020 15672 +++
				//МассивКЛ.Добавить(строкаТЧ.КонтактноеЛицо);
				МассивКЛ.Добавить(Новый Структура("КонтактноеЛицо,ДоступностьВПФ",строкаТЧ.КонтактноеЛицо,строкаТЧ.ДоступностьВПФ));
				//rarus pechek 2.04.2020 15672 ---
			КонецЕсли; 
		КонецЦикла; 
		Справочники.Scan_МестаХранения.ЗаписьЗначенияРегистраСведения(Объект.Ссылка,МассивКЛ);
	КонецЕсли;
	//rarus abrant 06.06.2017 mantis 9146 +++
	//нужно будет вернуть обратно после проверки!!
	Если Объект.Маршрут И Расстояние > 0 Тогда
		//rarus tenkam 10.08.2017 mantis 10589 +++
		СтруктураОтбора = Новый Структура("АдресПолучения", Объект.ИсходныйПункт.АдресСкладаЛогистический);
		СтруктураОтбора.Вставить("АдресДоставки", Объект.КонечныйПункт.АдресСкладаЛогистический);
		СтруктураСведений = РегистрыСведений.Scan_РасстояниеМеждуАдресами.Получить(СтруктураОтбора);
		СтароеРасстояние = СтруктураСведений.Расстояние;
		Если СтароеРасстояние <> Расстояние Тогда
		//rarus tenkam 10.08.2017 mantis 10589 ---
			МенеджерЗаписи = РегистрыСведений.Scan_РасстояниеМеждуАдресами.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.АдресПолучения 	= Объект.ИсходныйПункт.АдресСкладаЛогистический;
			МенеджерЗаписи.АдресДоставки 	= Объект.КонечныйПункт.АдресСкладаЛогистический;
			МенеджерЗаписи.Расстояние 		= Расстояние;
			МенеджерЗаписи.Пользователь 	= ПользователиКлиентСервер.ТекущийПользователь();
			МенеджерЗаписи.Записать();
			//для симметрии добавим расстояние в другую сторону
			МенеджерЗаписи = РегистрыСведений.Scan_РасстояниеМеждуАдресами.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.АдресПолучения 	= Объект.КонечныйПункт.АдресСкладаЛогистический;
			МенеджерЗаписи.АдресДоставки 	= Объект.ИсходныйПункт.АдресСкладаЛогистический;
			МенеджерЗаписи.Расстояние 		= Расстояние;
			МенеджерЗаписи.Пользователь 	= ПользователиКлиентСервер.ТекущийПользователь();
			МенеджерЗаписи.Записать();
			//rarus tenkam 10.08.2017 mantis 10589 +++
			//rarus FominskiyAS 19.04.2019  mantis 14191 +++
			//Сообщить("Запущен фоновый пересчет тарифов.");
			Сообщить(НСтр("ru = 'Запущен фоновый пересчет тарифов.'; en = 'Tariff recalculation'"));
			//rarus FominskiyAS 19.04.2019  mantis 14191 ---  
			ПараметрыФоновогоЗадания = Новый Массив;
			ПараметрыФоновогоЗадания.Добавить("Изменение расстояния между адресами");
			ФоновыеЗадания.Выполнить("Scan_Тарифы.ПолныйПересчет", ПараметрыФоновогоЗадания, Новый УникальныйИдентификатор,	"Полный пересчет");
		КонецЕсли;
		//Сообщить("Было внесено изменение Расстояния. Необходимо произвести перерасчет Тарифов доставки для дилеров",СтатусСообщения.ОченьВажное);
		//rarus tenkam 10.08.2017 mantis 10589 ---	
	КонецЕсли;
	//rarus abrant 06.06.2017 mantis 9146 ---
	
	//rarus bonmak 02.12.2019 14375 ++
	Если ИзмененыеРеквизиты Тогда		
		ПараметрыФоновогоЗадания = Новый Массив;
		ПараметрыФоновогоЗадания.Добавить(Объект.Ссылка);
		ФоновыеЗадания.Выполнить("Scan_ВспомогательныеФункцииСервер.ОтправитьДанныеПоМестамХраненияВ1БД", ПараметрыФоновогоЗадания, Новый УникальныйИдентификатор, "Изменение места хранения");	
	КонеЦесли;
	//rarus bonmak 02.12.2019 14375 --
КонецПроцедуры

&НаСервере
Процедура ИзменитьНаименованиеМаршрутов()
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_МестаХранения.Ссылка
	               |ИЗ
	               |	Справочник.Scan_МестаХранения КАК Scan_МестаХранения
	               |ГДЕ
	               |	Scan_МестаХранения.Маршрут = ИСТИНА
	               |	И (Scan_МестаХранения.ИсходныйПункт = &МестоХранения
	               |			ИЛИ Scan_МестаХранения.КонечныйПункт = &МестоХранения)";
	Запрос.УстановитьПараметр("МестоХранения", Объект.Ссылка);
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() <> 0 Тогда
		Для Каждого СтрокаРезультата Из Результат Цикл
			МаршрутСсылка = СтрокаРезультата.Ссылка;
			МаршрутОбъект = МаршрутСсылка.ПолучитьОбъект();
			МаршрутОбъект.Наименование = МаршрутОбъект.ИсходныйПункт.Наименование + " - " + МаршрутОбъект.КонечныйПункт.Наименование; 
			МаршрутОбъект.Записать();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

//rarus tenkam 05.10.2016 mantis 7161 ++
&НаСервере
Процедура ПолучитьСрокиДоставки()
	АдресИсходный = Объект.ИсходныйПункт.АдресСкладаЛогистический;
	АдресКонечный = Объект.КонечныйПункт.АдресСкладаЛогистический;
	Для Каждого СтрокаСпособа Из Объект.СрокиДоставки Цикл
		СрокДоставки = Справочники.Scan_МестаХранения.ПолучитьСрокДоставки(АдресИсходный, АдресКонечный, СтрокаСпособа.СпособДоставки);
		Если СрокДоставки <> Неопределено Тогда
			СтрокаСпособа.СрокДоставки = СрокДоставки;
		Иначе
			СтрокаСпособа.СрокДоставки = 0;	
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСрокиДоставки() 
	Объект.СрокиДоставки.Очистить();
	Для Сч = 0 По Перечисления.Scan_СпособыДоставкиПродуктов.Количество()-1 Цикл
		НоваяСтрока = Объект.СрокиДоставки.Добавить();
		НоваяСтрока.СпособДоставки = Перечисления.Scan_СпособыДоставкиПродуктов.Получить(Сч);
		АдресИсходный = Объект.ИсходныйПункт.АдресСкладаЛогистический;
		АдресКонечный = Объект.КонечныйПункт.АдресСкладаЛогистический;
		Если ЗначениеЗаполнено(АдресИсходный) И	ЗначениеЗаполнено(АдресКонечный) Тогда
			НоваяСтрока.СрокДоставки = Справочники.Scan_МестаХранения.ПолучитьСрокДоставки(АдресИсходный, АдресКонечный, НоваяСтрока.СпособДоставки);
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

//rarus tenkam 05.10.2016 mantis 7161 --

//rarus sergei 12.12.2016 mantis 8057 ++
&НаСервере
Процедура ЗаполнитьКЛПоКонтрагенту()
	КонтактныеЛицаКонтрагента.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_КонтактныеЛица.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Scan_КонтактныеЛица КАК Scan_КонтактныеЛица
	               |ГДЕ
	               |	Scan_КонтактныеЛица.Владелец = &КонтрагентСсылка
				   |//rarus abrant 15.11.2017 mantis 12037 +++
	               |	И Scan_КонтактныеЛица.Недействителен = ЛОЖЬ
				   |//rarus abrant 15.11.2017 mantis 12037 ---";
	//rarus bonmak 15.04.2020 14456 ++
	//rarus bonmak 03.06.2020 16165 ++
	Запрос.УстановитьПараметр("КонтрагентСсылка", Объект.Контрагент);
	//Запрос.УстановитьПараметр("КонтрагентСсылка", Объект.СтанцияДилера);
	//rarus bonmak 03.06.2020 16165 --
	//rarus bonmak 15.04.2020 14456 --
	ТаблицаКЛ = Запрос.Выполнить().Выгрузить();
	Для каждого строкаКЛ Из ТаблицаКЛ Цикл
		НоваяСтрока = КонтактныеЛицаКонтрагента.Добавить();
		НоваяСтрока.КонтактноеЛицо =  строкаКЛ.Ссылка;
	КонецЦикла;  
	Если ЗначениеЗаполнено(Объект.Ссылка) И КонтактныеЛицаКонтрагента.Количество()>0 Тогда
		МассивКЛ = РегистрыСведений.Scan_ВзаимосвязьКонтактныхЛицИМестХранения.ПолучитьКонтактныхЛицПоМестуХранения(Объект.Ссылка);	
		Для каждого ЭлементМассива Из МассивКЛ Цикл
			ПараметрыОтбора = Новый Структура("КонтактноеЛицо",ЭлементМассива.КонтактноеЛицо);
			НайденныеСтроки = КонтактныеЛицаКонтрагента.НайтиСтроки(ПараметрыОтбора);
			Если НайденныеСтроки.Количество()>0 Тогда
				НайденныеСтроки[0].Активность = Истина;
				//rarus pechek 2.04.2020 15672 +++
				НайденныеСтроки[0].ДоступностьВПФ = ЭлементМассива.ДоступностьВПФ;
				//rarus pechek 2.04.2020 15672 ---
			КонецЕсли;
		КонецЦикла; 
	КонецЕсли; 
КонецПроцедуры

//rarus sergei 12.12.2016 mantis 8057 --

//rarus abrant 11.04.2017 7164 +++
&НаСервереБезКонтекста
Функция ПолучитьКонтрагентаПоСтанцииДилера(СтанцияДилера)
	//rarus bonmak 15.04.2020 14456 ++
	//rarus bonmak 03.06.2020 16165 ++
	Контрагент = СтанцияДилера.Контрагент;
	//Контрагент = РегистрыСведений.Scan_ВзаимосвязьКомпанийСКонтрагентами.ПолучитьДилераПоКомпании(СтанцияДилера);
	//rarus bonmak 03.06.2020 16165 --
	//rarus bonmak 15.04.2020 14456 --
	Возврат Контрагент;
КонецФункции

&НаКлиенте
Процедура СтанцияДилераНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Объект.Контрагент = ПолучитьПустуюСсылкуКонтрагента() Тогда
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьСтанциюДилера", ЭтотОбъект);
		//ОткрытьФорму("Справочник.Scan_Компании.ФормаВыбора",,ЭтаФорма,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); //rarus bonmak 04.12.2019 14456 изменил наименование справочника
		ОткрытьФорму("Справочник.Scan_Компании.ФормаВыбора",,Элемент,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);//rarus vikhle 15.04.2021 mt 17484 изменил владельца
		СтандартнаяОбработка = Ложь;
	Иначе
		//rarus bonmak 28.05.2020 14456 ++
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Ссылка", ПолучитьСписокКомпаний(Объект.Контрагент));
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(НовыйПараметр);
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.СтанцияДилера.ПараметрыВыбора = НовыеПараметры;
		//rarus bonmak 28.05.2020 14456 --
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПустуюСсылкуКонтрагента ()
	Возврат Справочники.Scan_Контрагенты.ПустаяСсылка()
КонецФункции

&НаСервере
Функция ПолучитьСписокКомпаний(фКонтрагент) //rarus bonmak 28.05.2020 14456 ++
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_ВзаимосвязьКомпанийСКонтрагентами.Компания КАК Компания
		|ИЗ
		|	РегистрСведений.Scan_ВзаимосвязьКомпанийСКонтрагентами КАК Scan_ВзаимосвязьКомпанийСКонтрагентами
		|ГДЕ
		|	Scan_ВзаимосвязьКомпанийСКонтрагентами.Контрагент = &Контрагент";
	
	Запрос.УстановитьПараметр("Контрагент", фКонтрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Компания");
КонецФункции //rarus bonmak 28.05.2020 14456 --

&НаКлиенте
Процедура ЗаполнитьСтанциюДилера (Результат, Параметры) Экспорт
	Объект.СтанцияДилера = Результат;
	Объект.Контрагент = ПолучитьКонтрагентаПоСтанцииДилера(Объект.СтанцияДилера); //rarus bonmak 15.04.2020 14456 //rarus bonmak 03.06.2020 16165 
КонецПроцедуры
//rarus abrant 11.04.2017 7164 ---

//rarus abrant 06.06.2017 mantis 9146 +++
&НаСервере
Функция ПолучитьРасстояниеМеждуАдресами()
	
	ИскомоеРасстояние = 0;	
	
	Если Объект.КонечныйПункт.АдресСкладаЛогистический <> Справочники.Scan_АдресаХранения.ПустаяСсылка() И
		 Объект.ИсходныйПункт.АдресСкладаЛогистический <> Справочники.Scan_АдресаХранения.ПустаяСсылка() Тогда
		 
		 	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Scan_РасстояниеМеждуАдресами.Расстояние
			|ИЗ
			|	РегистрСведений.Scan_РасстояниеМеждуАдресами КАК Scan_РасстояниеМеждуАдресами
			|ГДЕ
			|	(Scan_РасстояниеМеждуАдресами.АдресПолучения = &АдресПолучателя
			|				И Scan_РасстояниеМеждуАдресами.АдресДоставки = &АдресДоставки
			|			ИЛИ Scan_РасстояниеМеждуАдресами.АдресПолучения = &АдресДоставки
			|				И Scan_РасстояниеМеждуАдресами.АдресДоставки = &АдресПолучателя)";
		
		Запрос.УстановитьПараметр("АдресДоставки", 		Объект.КонечныйПункт.АдресСкладаЛогистический);
		Запрос.УстановитьПараметр("АдресПолучателя", 	Объект.ИсходныйПункт.АдресСкладаЛогистический);
		
		Если Запрос.Выполнить().Выгрузить().Количество() > 0 Тогда 
			ИскомоеРасстояние = Запрос.Выполнить().Выгрузить()[0].Расстояние;
		КонецЕсли;	
	КонецЕсли;
	
	Возврат ИскомоеРасстояние;
	
КонецФункции

&НаКлиенте
Процедура РасстояниеПриИзменении(Элемент)
	Если НЕ РасстояниеПриИзмененииНаСервере()Тогда
		//rarus FominskiyAS 19.04.2019  mantis 14191 +++
		//Сообщить("Пожалуйста, укажите Пункт отправления и Пункт прибытия.");
		Сообщить(НСтр("ru = 'Пожалуйста, укажите Пункт отправления и Пункт прибытия.'; en = 'Please enter the departure and arrival point.'"));
		//rarus FominskiyAS 19.04.2019  mantis 14191 ---  
		Расстояние = 0;
		Возврат;
	КонецЕсли;		
КонецПроцедуры

&НаСервере
Функция РасстояниеПриИзмененииНаСервере()
	Если Объект.КонечныйПункт.АдресСкладаЛогистический <> Справочники.Scan_АдресаХранения.ПустаяСсылка() И
		 Объект.ИсходныйПункт.АдресСкладаЛогистический <> Справочники.Scan_АдресаХранения.ПустаяСсылка() Тогда
		 
		ВсеОК = Истина;
	Иначе
		ВсеОК = Ложь;
	КонецЕсли;
	Возврат ВсеОК;
КонецФункции
//rarus abrant 06.06.2017 mantis 9146 ---

// rarus tenkam 13.04.2018 mantis 12888 +++ 
&НаКлиенте
Процедура КраткоеНаименованиеТипСкладаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.КраткоеНаименование) И ЗначениеЗаполнено(Объект.ТипСклада) Тогда
		Объект.Наименование = СокрЛП(Объект.КраткоеНаименование) + " " + нРег(Объект.ТипСклада);	
	КонецЕсли;
	//rarus bonmak 05.10.2020 16592 ++
	КраткоеНаименованиеТипСкладаПриИзмененииНаСервере();
	//rarus bonmak 05.10.2020 16592 --
	
КонецПроцедуры

&НаСервере
Процедура КраткоеНаименованиеТипСкладаПриИзмененииНаСервере() //rarus bonmak 05.10.2020 16592 ++
	Если (Объект.ТипСклада = Перечисления.Scan_ТипыСклада.Производство ИЛИ 
		Объект.ТипСклада = Перечисления.Scan_ТипыСклада.Хранение) И
		НЕ Объект.ЗарубежныйКузовостроитель И НЕ Объект.СкладПроизводителя Тогда
		Объект.ФормироватьЧекЛисты = Истина;
	Иначе
		Объект.ФормироватьЧекЛисты = Ложь;
	КонецЕсли;
КонецПроцедуры //rarus bonmak 05.10.2020 16592 --

//rarus pechek 2.04.2020 15672 +++
&НаКлиенте
Процедура КонтактныеЛицаКонтрагентаПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Если Не Элемент.ТекущиеДанные.Активность И Элемент.ТекущийЭлемент.Имя = "КонтактныеЛицаКонтрагентаДоступностьВПФ" Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Модифицированность = Истина; //rarus pechek 10.04.2020 mantis 15672
КонецПроцедуры
//rarus pechek 2.04.2020 15672 ---
//rarus pechek 10.04.2020 mantis 15672 +++
&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Модифицированность Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
КонецПроцедуры
//rarus pechek 10.04.2020 mantis 15672 ---
//rarus pechek 10.04.2020 mantis 15672 +++
&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПараметрыЗаписи = Новый Структура();
		ПараметрыЗаписи.Вставить("Закрыть", Истина);
		Если Записать(ПараметрыЗаписи) Тогда
			Закрыть();
		КонецЕсли;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;  	
КонецПроцедуры

&НаСервере
Процедура ЗарубежныйКузовостроительПриИзмененииНаСервере() //rarus bonmak 05.10.2020 16592 ++
	Если НЕ Объект.Маршрут Тогда
		Если Объект.ЗарубежныйКузовостроитель Тогда
			Объект.ФормироватьЧекЛисты = Ложь;
		Иначе
			Если (Объект.ТипСклада = Перечисления.Scan_ТипыСклада.Производство ИЛИ 
				Объект.ТипСклада = Перечисления.Scan_ТипыСклада.Хранение) И
				НЕ Объект.ЗарубежныйКузовостроитель И НЕ Объект.СкладПроизводителя Тогда
				Объект.ФормироватьЧекЛисты = Истина;
			Иначе
				Объект.ФормироватьЧекЛисты = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры //rarus bonmak 05.10.2020 16592 --

&НаКлиенте
Процедура ЗарубежныйКузовостроительПриИзменении(Элемент) //rarus bonmak 05.10.2020 16592 ++
	ЗарубежныйКузовостроительПриИзмененииНаСервере();
КонецПроцедуры //rarus bonmak 05.10.2020 16592 --

//rarus pechek 10.04.2020 mantis 15672 ---

// rarus tenkam 13.04.2018 mantis 12888 ---

//rarus vikhle 06.04.2021 mt 17484 +++
&НаКлиенте
Процедура СтанцияДилераОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СтанцияДилераОбработкаВыбораПродолжение",ЭтотОбъект,ВыбранноеЗначение); //rarus vikhle 15.04.2021 mt 17484
	Scan_ВспомогательныеФункцииКлиент.ПроверитьАктивностьВыбраннойКомпании(ВыбранноеЗначение,ОписаниеОповещения,СтандартнаяОбработка);
	
КонецПроцедуры
//rarus vikhle 06.04.2021 mt 17484 ---

//rarus vikhle 06.04.2021 mt 17484 +++
&НаКлиенте
Процедура СтанцияДилераОбработкаВыбораПродолжение(Результат, ВыбраннаяКомпания) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.СтанцияДилера = ВыбраннаяКомпания;
	Иначе
		Объект.СтанцияДилера = Неопределено;	
	КонецЕсли;
		
КонецПроцедуры
//rarus vikhle 06.04.2021 mt 17484 ---

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи) // Rarus tenkam 07.12.2021 mantis 18622 +++
	Если НЕ ПараметрыЗаписи.Свойство("НеЗапрещатьПеремещениеМестаХранения")
	   И НЕ ЗначениеЗаполнено(Объект.Ссылка) И НЕ Объект.Маршрут 
	   И Объект.НеЗапрещатьПеремещениеМестаХранения Тогда
	
		Отказ = Истина;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПослеОтветаНаВопросНеЗапрещатьПеремещениеМестаХранения", ЭтотОбъект, ПараметрыЗаписи),
			НСтр("ru = 'Место хранения будет участвовать в автоматическом перемещении между папками с площадками и адресами клиентов. Продолжить?'"),
			РежимДиалогаВопрос.ДаНет,
			,
			,
			НСтр("ru = 'Запись нового места хранения'"));
		Возврат;
	КонецЕсли;
КонецПроцедуры // Rarus tenkam 07.12.2021 mantis 18622 ---

&НаКлиенте
Процедура ПослеОтветаНаВопросНеЗапрещатьПеремещениеМестаХранения(Ответ, ПараметрыЗаписи) Экспорт // Rarus tenkam 07.12.2021 mantis 18622 +++
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПараметрыЗаписи.Вставить("НеЗапрещатьПеремещениеМестаХранения");
		Записать(ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры // Rarus tenkam 07.12.2021 mantis 18622 ---


ИзмененыеРеквизиты = Ложь; //rarus bonmak 02.12.2019 14375
