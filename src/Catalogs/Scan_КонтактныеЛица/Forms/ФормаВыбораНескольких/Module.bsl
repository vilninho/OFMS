// rarus tenkam 21.08.2017 mantis 11366 +++
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.ФормаОтобразитьВсеКонтактныеЛица.Видимость = (Список.Отбор.Элементы.Количество() <> 0);
	ЗаполнитьТаблицу();
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьВсеКонтактныеЛица(Команда)
	Элементы.ФормаОтобразитьВсеКонтактныеЛица.Пометка = НЕ Элементы.ФормаОтобразитьВсеКонтактныеЛица.Пометка;
	
	Если Элементы.ФормаОтобразитьВсеКонтактныеЛица.Пометка Тогда 
		//Если кнопка нажата
		Для Каждого ТекЭлементОтбора Из Список.Отбор.Элементы Цикл
			//rarus FominskiyAS 17.06.2019  mantis 14491 +++
			//ТекЭлементОтбора.Использование = Ложь;
			Если ТекЭлементОтбора.Представление <> "Поиск" тогда
				ТекЭлементОтбора.Использование = Ложь;
			КонецЕсли;
			//rarus FominskiyAS 17.06.2019  mantis 14491 ---
		КонецЦикла;
	Иначе
		Для Каждого ТекЭлементОтбора Из Список.Отбор.Элементы Цикл
			//rarus FominskiyAS 17.06.2019  mantis 14491 +++
			//ТекЭлементОтбора.Использование = Истина;
			Если ТекЭлементОтбора.Представление <> "Поиск" тогда
				ТекЭлементОтбора.Использование = Истина;
			КонецЕсли;
			//rarus FominskiyAS 17.06.2019  mantis 14491 ---
		КонецЦикла;	
	КонецЕсли;
	ЗаполнитьТаблицу();
	РассчитатьВсего();

КонецПроцедуры    


&НаСервере
Функция СписокВМассивНаСервере()
	
	//rarus FominskiyAS 07.06.2019  mantis 14491 +++
	Если СтрокаПоиска <>"" тогда
		
		Для Каждого ТекЭлементОтбора Из Список.Отбор.Элементы Цикл
			Если ТекЭлементОтбора.Представление = "Поиск" тогда
				Список.Отбор.Элементы.Удалить(ТекЭлементОтбора);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		ГруппаОтбора = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИЛИ;
		ГруппаОтбора.Представление = "Поиск";
		
		ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка.Наименование");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = СтрокаПоиска;
		
		ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка.Владелец.Наименование");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = СтрокаПоиска;
				
	Иначе 
		Для Каждого ТекЭлементОтбора Из Список.Отбор.Элементы Цикл
			Если ТекЭлементОтбора.Представление = "Поиск" тогда
			ТекЭлементОтбора.Использование = Ложь;	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	//rarus FominskiyAS 07.06.2019  mantis 14491 ---  	

    Схема = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
    Настройки = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	
    КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
    МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , ,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
    
    ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	
	
    
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
    ТаблицаРезультат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	КолонкаСсылок = ТаблицаРезультат.ВыгрузитьКолонку("Ссылка");
	Возврат КолонкаСсылок;

КонецФункции

&НаКлиенте
Процедура ЗаполнитьТаблицу()
	МассивВыбранных = ПолучитьВыбранныхКЛ();
	
	ТаблицаКонтактныхЛиц.Очистить();
	МассивКЛ = СписокВМассивНаСервере();
	
	Для Каждого ТекКЛ Из МассивКЛ Цикл
		НоваяСтрока = ТаблицаКонтактныхЛиц.Добавить();
		НоваяСтрока.КонтактноеЛицо = ТекКЛ;
		Если МассивВыбранных.Найти(ТекКЛ) <> Неопределено Тогда
			НоваяСтрока.Выбрать = Истина;
		КонецЕсли;			
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	Для Каждого ТекКЛ Из ТаблицаКонтактныхЛиц Цикл
		ТекКЛ.Выбрать = Ложь;
	КонецЦикла;	
	РассчитатьВсего();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	Для Каждого ТекКЛ Из ТаблицаКонтактныхЛиц Цикл
		ТекКЛ.Выбрать = Истина;
	КонецЦикла;
	РассчитатьВсего();
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьВсего()
	ВсегоВыбрано = ТаблицаКонтактныхЛиц.НайтиСтроки(Новый Структура("Выбрать", Истина)).Количество();
КонецПроцедуры

&НаСервере
Функция ПолучитьВыбранныхКЛ()
	ПараметрыОтбора = Новый Структура("Выбрать", Истина);
	Возврат ТаблицаКонтактныхЛиц.Выгрузить(ПараметрыОтбора,"КонтактноеЛицо").ВыгрузитьКолонку("КонтактноеЛицо");
КонецФункции


&НаКлиенте
Процедура СписокКонтактныхЛицВыбратьПриИзменении(Элемент)
	РассчитатьВсего();
КонецПроцедуры


&НаКлиенте
Процедура Выбрать(Команда)
	Если ВсегоВыбрано <> 0 Тогда
		ПараметрыОтбора = Новый Структура("Выбрать", Истина);
		Закрыть(ПолучитьВыбранныхКЛ());	
		
	Иначе
		Закрыть(КодВозвратаДиалога.Отмена);
	КонецЕсли;

КонецПроцедуры

//rarus FominskiyAS 07.06.2019  mantis 14491 +++
&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	ЗаполнитьТаблицу();
КонецПроцедуры
//rarus FominskiyAS 07.06.2019  mantis 14491 ---


// rarus tenkam 21.08.2017 mantis 11366 ---
