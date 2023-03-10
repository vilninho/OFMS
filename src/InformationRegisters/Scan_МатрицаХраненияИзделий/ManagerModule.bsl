//rarus tenkam 15.11.2017 mantis 9427 +++

// rarus tenkam 22.07.2019 mantis 14427 +++
//Функция ЗаписьДанныхВРегистр(Продукт, МестоХранения, Реквизит, Значение, Период = Неопределено, Документ = Неопределено) Экспорт
Функция ЗаписьДанныхВРегистр(Изделие, МестоХранения, Реквизит, Значение, Период = Неопределено, Документ = Неопределено) Экспорт	
// rarus tenkam 22.07.2019 mantis 14427 --- 
	
	// rarus tenkam 09.08.2019 mantis 14427 +++
	//Продукт = РегистрыСведений.Scan_ВзаимосвязьИзделийПродуктовИЗаказов.ПолучитьПродуктПоИзделию(Изделие);		// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +
	// rarus tenkam 09.08.2019 mantis 14427 ---	
	ВсеОк = Истина;
	
	Если Период = Неопределено Тогда
		ДатаЗаписи = ТекущаяДата();
	Иначе
		ДатаЗаписи = Период;
	КонецЕсли; 
	
	//Чтение старого значения регистра
	
	НаборЗаписей = РегистрыСведений.Scan_МатрицаХраненияИзделий.СоздатьНаборЗаписей();
	// rarus tenkam 22.07.2019 mantis 14427 +++  
	//НаборЗаписей.Отбор.Продукт.Установить(Продукт);		// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +
	НаборЗаписей.Отбор.Изделие.Установить(Изделие);	
	// rarus tenkam 22.07.2019 mantis 14427 ---
	НаборЗаписей.Отбор.МестоХранения.Установить(МестоХранения);
	НаборЗаписей.Отбор.Реквизит.Установить(Реквизит);
	
	Если ЗначениеЗаполнено(Документ) Тогда
		НаборЗаписей.Отбор.Документ.Установить(Документ);
	КонецЕсли;    		
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		НоваяЗапись = НаборЗаписей.Добавить();
		// rarus tenkam 22.07.2019 mantis 14427 +++	
		//НоваяЗапись.Продукт = Продукт;		// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +
		НоваяЗапись.Изделие = Изделие;
		// rarus tenkam 22.07.2019 mantis 14427 +++  
		НоваяЗапись.МестоХранения = МестоХранения;
		НоваяЗапись.Реквизит = Реквизит;
		НоваяЗапись.Значение = Значение;
		НоваяЗапись.Период   = ДатаЗаписи;
		Если ЗначениеЗаполнено(Документ) Тогда
			НоваяЗапись.Документ = Документ;
		КонецЕсли; 
		НоваяЗапись.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();		
	Иначе
		ТекЗапись = НаборЗаписей[0];
		Если Документ <> Неопределено Тогда
			Если ТекЗапись.Значение <> Значение Тогда
				ТекЗапись.Значение = Значение;
				ТекЗапись.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
			КонецЕсли;
		Иначе
			НоваяЗапись = НаборЗаписей.Добавить();
			// rarus tenkam 22.07.2019 mantis 14427 +++	
			//НоваяЗапись.Продукт = Продукт;		// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +
			НоваяЗапись.Изделие = Изделие;
			// rarus tenkam 22.07.2019 mantis 14427 +++  
			НоваяЗапись.МестоХранения = МестоХранения;
			НоваяЗапись.Реквизит = Реквизит;
			НоваяЗапись.Значение = Значение;
			НоваяЗапись.Период   = ДатаЗаписи;
			Если ЗначениеЗаполнено(Документ) Тогда
				НоваяЗапись.Документ = Документ;
			КонецЕсли; 
			НоваяЗапись.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();	
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		НаборЗаписей.Записать();
		ВсеОк = Истина;
	Исключение
		//rarus FominskiyAS 24.04.2019  mantis 14191 +++
		//Сообщить(НСтр("ru = 'Ошибка записи данных в матрицу хранения изделий'"));
		Сообщить(НСтр("ru = 'Ошибка записи данных в матрицу хранения продуктов'; en = 'Action failed '"));
		//rarus FominskiyAS 24.04.2019  mantis 14191 ---  
		ВсеОк = Ложь;
	КонецПопытки;
	
	Возврат ВсеОк;

КонецФункции 

Функция ПолучитьДатуПостановкиНаХранение(ИзделиеСсылка, МестоХранения = Неопределено, ДокументСсылка = Неопределено, ПлановаяДатаВыполненияКТС = Неопределено) Экспорт

	Если НЕ ЗначениеЗаполнено(ИзделиеСсылка) Тогда
		Возврат Дата('00010101');
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МАКСИМУМ(Scan_МатрицаХраненияИзделий.Значение) КАК ДатаПостановкиНаХранение,
		// rarus tenkam 22.07.2019 mantis 14427 +++
		//|	Scan_МатрицаХраненияИзделий.Продукт.Изделие КАК ПродуктИзделие
		|	Scan_МатрицаХраненияИзделий.Изделие КАК ПродуктИзделие
		// rarus tenkam 22.07.2019 mantis 14427 +++
		|ИЗ
		|	РегистрСведений.Scan_МатрицаХраненияИзделий КАК Scan_МатрицаХраненияИзделий
		|ГДЕ
		|	(Scan_МатрицаХраненияИзделий.Реквизит = ЗНАЧЕНИЕ(Перечисление.Scan_КонтрольныеДатыХраненияИзделий.ДатаПостановкиНаХранение)
		|			ИЛИ Scan_МатрицаХраненияИзделий.Реквизит = ЗНАЧЕНИЕ(Перечисление.Scan_КонтрольныеДатыХраненияИзделий.ДатаВыполненияКТСФакт))
		// rarus tenkam 22.07.2019 mantis 14427 +++
		//|	И Scan_МатрицаХраненияИзделий.Продукт.Изделие = &ИзделиеСсылка // rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +
		|	И Scan_МатрицаХраненияИзделий.Изделие = &ИзделиеСсылка 		// rarus tenkam 22.07.2019 mantis 14427 + должно быть закомментировано по 14662
		// rarus tenkam 22.07.2019 mantis 14427 ---
		|	//УсловиеМестаХранения
		|	//УсловиеДокумента
		|	//УсловиеПлановойДаты 
		|
		|СГРУППИРОВАТЬ ПО
		// rarus tenkam 22.07.2019 mantis 14427 +++
		//|	Scan_МатрицаХраненияИзделий.Продукт.Изделие";
		|	Scan_МатрицаХраненияИзделий.Изделие";
		// rarus tenkam 22.07.2019 mantis 14427 ---
		
	Запрос.УстановитьПараметр("ИзделиеСсылка", ИзделиеСсылка);
	Если ЗначениеЗаполнено(МестоХранения) ТОгда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//УсловиеМестаХранения", "И Scan_МатрицаХраненияИзделий.МестоХранения = &МестоХранения");
		Запрос.УстановитьПараметр("МестоХранения", МестоХранения);
	КонецЕсли;
	
	// rarus tenkam 27.02.2018 mantis 12844 ++
	//Если ЗначениеЗаполнено(МестоХранения) ТОгда
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
	// rarus tenkam 27.02.2018 mantis 12844 ---	
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//УсловиеДокумента", "И Scan_МатрицаХраненияИзделий.Документ <> &ДокументСсылка");
		Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПлановаяДатаВыполненияКТС) ТОгда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//УсловиеПлановойДаты", "И Scan_МатрицаХраненияИзделий.Значение <= &ПлановаяДатаВыполненияКТС");
		Запрос.УстановитьПараметр("ПлановаяДатаВыполненияКТС", ПлановаяДатаВыполненияКТС);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.ДатаПостановкиНаХранение;
	КонецЕсли;
	
	Возврат Дата('00010101');	
	
КонецФункции

//rarus tenkam 15.11.2017 mantis 9427 ---