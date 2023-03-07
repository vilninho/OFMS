#Область ОписаниеПеременных
// rarus bonmak 06.09.2021 mantis 18008  За основу взята обработка Scan_РМРегиональногоМенеджера

//rarus vikhle 05.06.2020 mt 15894 +++
&НаКлиенте
Перем мВыбраныСсылкиРаспределение;
// rarus agar 10.08.2020 15894 ++
&НаКлиенте
Перем мВыбраныСсылкиСвободныеНовые;
// rarus agar 10.08.2020 15894 --
&НаКлиенте
Перем мКритерииПоискаПоКоридору;

#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ГруппаДействияПоискРаспределение.Видимость	= Ложь;
	// rarus agar 10.08.2020 15894 ++
	Элементы.ГруппаДействияПоискСвободныеНовые.Видимость = Ложь;
	// rarus agar 10.08.2020 15894 --
	Элементы.ГруппаДействияПоискПродажи.Видимость = Ложь;
	Элементы.ГруппаДействияПоискВсеПродукты.Видимость = Ложь; //rarus vikhle 20.05.2021 mt 17661
	
	КритерийПоиска = Перечисления.Scan_КритерииПоискаАРМ.НомерИзделия;
	ТумблерПоиск = "0";	
	УправлениеДиалогом();
	
	БыстрыйДоступ = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	СотрудникПользователя = Scan_ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийПользователь, "Сотрудник");
	
	ВидДвигатели = Scan_ПраваИНастройки.Scan_Право("ВидПродуктаДвигатель");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокРаспределение, "ВидПродукта", ВидДвигатели, ВидСравненияКомпоновкиДанных.Равно,, Истина, БыстрыйДоступ, Строка(Новый УникальныйИдентификатор));
	// rarus agar 10.08.2020 15894 ++
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокСвободныеНовые, "ВидПродукта", ВидДвигатели, ВидСравненияКомпоновкиДанных.Равно,, Истина, БыстрыйДоступ, Строка(Новый УникальныйИдентификатор));
	// rarus agar 10.08.2020 15894 --
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПродажи, "ВидПродукта", ВидДвигатели, ВидСравненияКомпоновкиДанных.Равно,, Истина, БыстрыйДоступ, Строка(Новый УникальныйИдентификатор));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокВсеПродукты, "ВидПродукта", ВидДвигатели, ВидСравненияКомпоновкиДанных.Равно,, Истина, БыстрыйДоступ, Строка(Новый УникальныйИдентификатор));
		
	// rarus kabany 09.06.2021 17891 +++	
	СписокРаспределение.Параметры.УстановитьЗначениеПараметра("ТекДата", ТекущаяДатаСеанса()); // rarus kabany 29.06.2021 OFMS устранение ошибок Sonar Qube (АПК) // было: ТекущаяДата() 
	СписокСвободныеНовые.Параметры.УстановитьЗначениеПараметра("ТекДата", ТекущаяДатаСеанса()); // rarus kabany 29.06.2021 OFMS устранение ошибок Sonar Qube (АПК) // было: ТекущаяДата() 
	СписокПродажи.Параметры.УстановитьЗначениеПараметра("ТекДата", ТекущаяДатаСеанса()); // rarus kabany 29.06.2021 OFMS устранение ошибок Sonar Qube (АПК) // было: ТекущаяДата() 
	СписокВсеПродукты.Параметры.УстановитьЗначениеПараметра("ТекДата", ТекущаяДатаСеанса()); // rarus kabany 29.06.2021 OFMS устранение ошибок Sonar Qube (АПК) // было: ТекущаяДата() 
	// rarus kabany 09.06.2021 17891 ---

	//rarus agar 31.08.2020 15696 ++
	МассивТиповПродуктовНадстроекИУслуг = Справочники.Scan_ТипыПродуктов.ПолучитьТипыПродуктовНадстроекИУслуг();
	СписокРаспределение.Параметры.УстановитьЗначениеПараметра("МассивТиповПродуктовНадстроекИУслуг", МассивТиповПродуктовНадстроекИУслуг);
	СписокСвободныеНовые.Параметры.УстановитьЗначениеПараметра("МассивТиповПродуктовНадстроекИУслуг", МассивТиповПродуктовНадстроекИУслуг);
	СписокПродажи.Параметры.УстановитьЗначениеПараметра("МассивТиповПродуктовНадстроекИУслуг", МассивТиповПродуктовНадстроекИУслуг);
	//rarus agar 31.08.2020 15696 --
	
	//rarus vikhle 22.11.2021 mt 18694 +++
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(Справочники.Scan_СтатусыСоглашенийОПоставкеИСпециальныхУсловий.НеактуальноЕстьДС);
	МассивСтатусов.Добавить(Справочники.Scan_СтатусыСоглашенийОПоставкеИСпециальныхУсловий.СОП_Отменен);
	МассивСтатусов.Добавить(Справочники.Scan_СтатусыСоглашенийОПоставкеИСпециальныхУсловий.СОП_Расторгнут);
	МассивСтатусов.Добавить(Справочники.Scan_СтатусыСоглашенийОПоставкеИСпециальныхУсловий.Отказ);
	СпециальныеУсловия.Параметры.УстановитьЗначениеПараметра("СтатусыЗаявок",МассивСтатусов);
	//rarus vikhle 22.11.2021 mt 18694 ---
	Scan_СборСтатистики.Scan_ПриОткрытииОбработки(РеквизитФормыВЗначение("Объект").Метаданные().Синоним); // Rarus tenkam 11.04.2022 mantis 18433 +

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Scan_ВспомогательныеФункцииКлиент.ПроверитьПользователяПортала();	
	
	мВыбраныСсылкиРаспределение = Новый Массив;
	// rarus agar 10.08.2020 15894 ++
	мВыбраныСсылкиСвободныеНовые = Новый Массив;
	// rarus agar 10.08.2020 15894 --
	
	СписокРаспределение.Параметры.УстановитьЗначениеПараметра("мВыбраныСсылки", мВыбраныСсылкиРаспределение);
	// rarus agar 10.08.2020 15894 ++
	СписокСвободныеНовые.Параметры.УстановитьЗначениеПараметра("мВыбраныСсылки", мВыбраныСсылкиСвободныеНовые);
	// rarus agar 10.08.2020 15894 --
	
	мКритерииПоискаПоКоридору = ПолучитьМассивКритериевОтбораПоКоридоруЗначений(); 
	Элементы.ПолеОтбораПоКоридоруРаспределение.СписокВыбора.ЗагрузитьЗначения(мКритерииПоискаПоКоридору);
	// rarus agar 10.08.2020 15894 ++
	Элементы.ПолеОтбораПоКоридоруСвободныеНовые.СписокВыбора.ЗагрузитьЗначения(мКритерииПоискаПоКоридору);
	// rarus agar 10.08.2020 15894 --
	Элементы.ПолеОтбораПоКоридоруПродажи.СписокВыбора.ЗагрузитьЗначения(мКритерииПоискаПоКоридору);
	Элементы.ПолеОтбораПоКоридоруВсеПродукты.СписокВыбора.ЗагрузитьЗначения(мКритерииПоискаПоКоридору); //rarus vikhle 21.05.2021 mt 17661
	
	КоличествоПродуктовРаспределение = РассчитатьКоличествоСтрок("СписокРаспределение");
	КоличествоЗаказовРаспределение = РассчитатьКоличествоСтрок("СписокРаспределение", "ЗаказНаЗаводКоличество"); //rarus bonmak 01.09.2020 16505 изменил название элемента
	Элементы.СписокРаспределениеОбновитьКоличествоПродуктов.Заголовок = НСтр("ru = 'Количество продуктов:'; en = 'Products quantity:'") + КоличествоПродуктовРаспределение;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияЭлементовФормы

&НаКлиенте
Процедура СписокРаспределениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОбработатьВыборСписка(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СписокСвободныеНовыеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) // rarus agar 10.08.2020 15894 +-
	ОбработатьВыборСписка(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СписокПродажиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОбработатьВыборСписка(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
КонецПроцедуры

//rarus vikhle 20.05.2021 mt 17661
&НаКлиенте
Процедура СписокВсеПродуктыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОбработатьВыборСписка(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
КонецПроцедуры
//rarus vikhle 20.05.2021 mt 17661 ---

&НаКлиенте
Процедура ПолеОтбораПоКоридоруРаспределениеПриИзменении(Элемент)
	ПолеОтбораПоКоридоруПриИзмененииУниверсальная(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПолеОтбораПоКоридоруСвободныеНовыеПриИзменении(Элемент) // rarus agar 10.08.2020 15894 +-
	ПолеОтбораПоКоридоруПриИзмененииУниверсальная(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПолеОтбораПоКоридоруПродажиПриИзменении(Элемент)
	ПолеОтбораПоКоридоруПриИзмененииУниверсальная(Элемент);
КонецПроцедуры

//rarus vikhle 20.05.2021 mt 17661 +++
&НаКлиенте
Процедура ПолеОтбораПоКоридоруВсеПродуктыПриИзменении(Элемент)
	ПолеОтбораПоКоридоруПриИзмененииУниверсальная(Элемент);
КонецПроцедуры
//rarus vikhle 20.05.2021 mt 17661 ---

&НаКлиенте
Процедура ТумблерПоискРаспределениеПриИзменении(Элемент)
	УправлениеДиалогом();
КонецПроцедуры

&НаКлиенте
Процедура ТумблерПоискСвободныеНовыеПриИзменении(Элемент) // rarus agar 10.08.2020 15894 +-
	УправлениеДиалогом();
КонецПроцедуры

&НаКлиенте
Процедура ТумблерПоискПродажиПриИзменении(Элемент)
	УправлениеДиалогом();
КонецПроцедуры

//rarus vikhle 21.05.2021 mt 17661 +++
&НаКлиенте
Процедура ТумблерПоискВсеПродуктыПриИзменении(Элемент)
	УправлениеДиалогом();
КонецПроцедуры
//rarus vikhle 21.05.2021 mt 17661 ---

#КонецОбласти

#Область Вспомогательные

&НаСервереБезКонтекста
Процедура ЗаявкиНаОтгрузкуПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки) //rarus pechek 25.06.2020 mantis 15894 +++
	
	ЧерныйЦвет = Новый Цвет(0,0,0);
	
	МассивСсылок = Строки.ПолучитьКлючи();
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	Scan_СтатусыЗаявокНаОтгрузку.Ссылка КАК Ссылка,
	|	Scan_СтатусыЗаявокНаОтгрузку.ЦветФона КАК ЦветФона,
	|	Scan_СтатусыЗаявокНаОтгрузку.ЦветТекста КАК ЦветТекста,
	|	Scan_СтатусыЗаявокНаОтгрузку.Шрифт КАК Шрифт
	|ИЗ
	|	Справочник.Scan_СтатусыЗаявокНаОтгрузку КАК Scan_СтатусыЗаявокНаОтгрузку";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	Scan_ЗаявкаНаОтгрузку.Ссылка КАК СсылкаДокумент
		|ИЗ
		|	Документ.Scan_ЗаявкаНаОтгрузку КАК Scan_ЗаявкаНаОтгрузку
		|ГДЕ
		|	Scan_ЗаявкаНаОтгрузку.Статус = &Статус
		|	И Scan_ЗаявкаНаОтгрузку.Ссылка В(&МассивСсылок)";
		
		Запрос.УстановитьПараметр("Статус",       Выборка.Ссылка);
		Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СтрокаСписка = Строки[ВыборкаДетальныеЗаписи.СсылкаДокумент];
			Для Каждого КолонкаСписка Из СтрокаСписка.Оформление Цикл
				ЦветФона = Выборка.ЦветФона.Получить();
				Если ЦветФона <> ЧерныйЦвет Тогда
					КолонкаСписка.Значение.УстановитьЗначениеПараметра("ЦветФона", ЦветФона);
				КонецЕсли;
				КолонкаСписка.Значение.УстановитьЗначениеПараметра("ЦветТекста", Выборка.ЦветТекста.Получить());
				КолонкаСписка.Значение.УстановитьЗначениеПараметра("Шрифт",      Выборка.Шрифт.Получить());
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьЛокальныйСтатусНаСервере (ВыбранныеИзделия, Статус)
	ЕстьОшибки = Ложь;
	Для Каждого Изделие Из ВыбранныеИзделия Цикл 
		// rarus kabany 19.07.2021 18027 ++
		Если Статус = ПредопределенноеЗначение("Справочник.Scan_ЛокальныеСтатусыПродуктов.OPEN") Тогда
			ЗаказНаЗаводСсылка = РегистрыСведений.Scan_ВзаимосвязьИзделийИЗаказов.ПолучитьЗаказПоИзделию(Изделие);
			Если ЗаказНаЗаводСсылка = Справочники.Scan_ЗаказыНаЗавод.ПустаяСсылка() Тогда
				Сообщить(СтрШаблон(Нстр("ru = 'Не удалось изменить локальный статус у %1, так как у данного продукта отсутствует заказ на завод';
				|en = 'Failed to change local status of %1, because this product does not have a factory order'"),
				Изделие.Наименование)); // rarus kabany 20.07.2021 18027 + исправление ошибки в тексте
				ЕстьОшибки = Истина;
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		// rarus kabany 19.07.2021 18027 --
		//rarus bonmak 18008 06.09.2021 ++ Добавил условие и отработку ЛОЖЬ
		Если Изделие.ТипПродукта.ВидПродукта = Scan_ПраваИНастройки.Scan_Право("ВидПродуктаДвигатель") Тогда 
			ТекОбъект = Изделие.ПолучитьОбъект();
			ТекОбъект.ЛокальныйСтатусПродукта = Статус;
			Попытка
				ТекОбъект.Записать();
			Исключение
				ЕстьОшибки = Истина;
				Сообщить(СтрШаблон(Нстр("ru = 'Не удалось изменить локальный статус у %1. %2';
				|en = 'Failed to change local status of %1. %2'"),
				Изделие.Наименование, ОписаниеОшибки()));
			КонецПопытки;
		Иначе
			Сообщить(СтрШаблон(Нстр("ru = 'Нельзя изменять локальный статус у %1, так как данный продукт не является двигателем';
			|en = 'Failed to change local status of %1, since this product is not an engine'"),
			Изделие.Наименование));
			ЕстьОшибки = Истина;
			Продолжить;
		КонецЕсли;
		//rarus bonmak 18008 06.09.2021 --

	КонецЦикла;
	Если НЕ ЕстьОшибки Тогда
		Сообщить(НСтр("ru = 'Локальный статус успешно изменен'; en = 'Local status successfully updated'"));
	КонецЕсли;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСсылкуНаПродукт(СтрокаРС)
	
	// rarus agar 03.11.2020 16010 ++
	ПродуктСсылка = Справочники.Scan_Изделия.ПустаяСсылка();
	Если ТипЗнч(СтрокаРС) = Тип("РегистрСведенийКлючЗаписи.Scan_СводнаяИнформацияПоПродукту") Тогда
		ПродуктСсылка = СтрокаРС.Продукт;
	КонецЕсли;
	// rarus agar 03.11.2020 16010 --
	
	Возврат ПродуктСсылка;
	
КонецФункции

&НаКлиенте
Функция ПолучитьМассивКритериевОтбораПоКоридоруЗначений()
	МассивКолонокОтбора = Новый Массив;
	МассивКолонокОтбора.Добавить("№ Заказа");
	//rarus pechek 15.06.2020 mantis 16201 +++
	МассивКолонокОтбора.Добавить("№ двигателя");
	//rarus pechek 15.06.2020 mantis 16201 ---
	МассивКолонокОтбора.Добавить("PDD");
	Возврат МассивКолонокОтбора;
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборСписка (Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ИмяСписка = Элемент.Имя;
	ИмяПоля = Поле.Имя;
	
	ПродуктСсылка = ПолучитьСсылкуНаПродукт(ВыбраннаяСтрока);
	Если ИмяПоля = "СписокРаспределениеФлаг" Тогда
		мИндекс = мВыбраныСсылкиРаспределение.Найти(ПродуктСсылка);
		Если мИндекс = Неопределено Тогда
			мВыбраныСсылкиРаспределение.Добавить(ПродуктСсылка);
		Иначе
			мВыбраныСсылкиРаспределение.Удалить(мИндекс);
		КонецЕсли;
		КоличествоВыбранныхРаспределение = мВыбраныСсылкиРаспределение.Количество();	
		СписокРаспределение.Параметры.УстановитьЗначениеПараметра("мВыбраныСсылки", мВыбраныСсылкиРаспределение);	
	ИначеЕсли ИмяПоля = "СписокСвободныеНовыеФлаг" Тогда
		мИндекс = мВыбраныСсылкиСвободныеНовые.Найти(ПродуктСсылка);
		Если мИндекс = Неопределено Тогда
			мВыбраныСсылкиСвободныеНовые.Добавить(ПродуктСсылка);
		Иначе
			мВыбраныСсылкиСвободныеНовые.Удалить(мИндекс);
		КонецЕсли;
		КоличествоВыбранныхСвободныеНовые = мВыбраныСсылкиСвободныеНовые.Количество();
		СписокСвободныеНовые.Параметры.УстановитьЗначениеПараметра("мВыбраныСсылки", мВыбраныСсылкиСвободныеНовые);
		// rarus agar 10.08.2020 15894 --	
		// rarus tenkam 24.05.2021 mantis 17722 +++
	ИначеЕсли Поле.Имя = "СписокПродажиЗаказНаЗакупку" Тогда
		ЗначениеСсылка = Элементы.СписокПродажи.ТекущиеДанные.СсылкаЗаказНаЗакупку;
		ПоказатьЗначение(, ЗначениеСсылка);
	ИначеЕсли Поле.Имя = "СписокПродажиСОП" 
		ИЛИ Поле.Имя = "СписокПродажиДоговорСОПДоп" Тогда
		ЗначениеСсылка = Scan_ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПродуктСсылка,"СоглашениеОПоставке");
		ПоказатьЗначение(, ЗначениеСсылка);
	ИначеЕсли Поле.Имя = "СписокПродажиДоговорСОП" Тогда
		ЗначениеСсылка = Scan_ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПродуктСсылка,"СОП");
		ПоказатьЗначение(, ЗначениеСсылка);
		// rarus tenkam 24.0054.2021 mantis 17722 ---   			
	Иначе
		ПоказатьЗначение(, ПродуктСсылка);	
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция РассчитатьКоличествоСтрок(ИмяСписка, ИмяЭлемента = "ПродуктКоличество") //rarus bonmak 01.09.2020 16505 изменил название элемента
	
	Схема = Элементы[ИмяСписка].ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы[ИмяСписка].ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаРезультат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	Если ТаблицаРезультат.Количество() = 0 Тогда
		Возврат 0;
	КонецЕсли;
	ТаблицаРезультат.Свернуть(ИмяЭлемента);
	Справочник = ?(ИмяЭлемента = "ПродуктКоличество", Справочники.Scan_Изделия, Справочники.Scan_ЗаказыНаЗавод); //rarus bonmak 01.09.2020 16505 изменил название элемента
	НайденнаяСтрока = ТаблицаРезультат.Найти(Справочник.ПустаяСсылка(), ИмяЭлемента);
	Если НайденнаяСтрока <> Неопределено Тогда
		ТаблицаРезультат.Удалить(НайденнаяСтрока);
	КонецЕсли;
	
	Возврат ТаблицаРезультат.Количество();
КонецФункции

&НаСервере
Функция СписокВТЗнаСервере(ИмяСтраницы)
	// rarus agar 10.08.2020 15894 ++
	ИмяСписка = ?(ИмяСтраницы = "Распределение", "СписокРаспределение", "СписокСвободныеНовые");
	Если ИмяСтраницы = "Распределение" Тогда
		ИмяСписка = "СписокРаспределение";
	ИначеЕсли ИмяСтраницы = "СвободныеНовые" Тогда
		ИмяСписка = "СписокСвободныеНовые";
	КонецЕсли;
	// rarus agar 10.08.2020 15894 --
	ТаблицаРезультат = ДинамическийСписокВТаблицуЗначений(Элементы[ИмяСписка]);
	КолонкаСсылок = ТаблицаРезультат.ВыгрузитьКолонку("Продукт");
	Возврат КолонкаСсылок;
КонецФункции

&НаСервере
Процедура УправлениеДиалогом()
	Если ТумблерПоиск = "0" Тогда
		Элементы.ГруппаОтборПоСпискуРаспределение.Видимость = Истина;
		Элементы.ГруппаОтборПоКоридоруЗначенийРаспределение.Видимость = Ложь;
		// rarus agar 10.08.2020 15894 ++
		Элементы.ГруппаОтборПоСпискуСвободныеНовые.Видимость = Истина;
		Элементы.ГруппаОтборПоКоридоруЗначенийСвободныеНовые.Видимость = Ложь;
		// rarus agar 10.08.2020 15894 --
		Элементы.ГруппаОтборПоСпискуПродажи.Видимость = Истина;
		Элементы.ГруппаОтборПоКоридоруЗначенийПродажи.Видимость = Ложь;
		//rarus vikhle 20.05.2021 mt 17661 +++
		Элементы.ГруппаОтборПоСпискуВсеПродукты.Видимость = Истина;
		Элементы.ГруппаОтборПоКоридоруЗначенийВсеПродукты.Видимость = Ложь;
		//rarus vikhle 20.05.2021 mt 17661 ---
		ПолеС = Неопределено;
		ПолеПо = Неопределено;
		ПолеОтбора = "";
	Иначе
		Элементы.ГруппаОтборПоСпискуРаспределение.Видимость = Ложь;
		Элементы.ГруппаОтборПоКоридоруЗначенийРаспределение.Видимость = Истина;
		// rarus agar 10.08.2020 15894 ++
		Элементы.ГруппаОтборПоСпискуСвободныеНовые.Видимость = Ложь;
		Элементы.ГруппаОтборПоКоридоруЗначенийСвободныеНовые.Видимость = Истина;
		// rarus agar 10.08.2020 15894 --
		Элементы.ГруппаОтборПоСпискуПродажи.Видимость = Ложь;
		Элементы.ГруппаОтборПоКоридоруЗначенийПродажи.Видимость = Истина;
		//rarus vikhle 20.05.2021 mt 17661 +++
		Элементы.ГруппаОтборПоСпискуВсеПродукты.Видимость = Ложь;
		Элементы.ГруппаОтборПоКоридоруЗначенийВсеПродукты.Видимость = Истина;
		//rarus vikhle 20.05.2021 mt 17661 ---
		ПолеВвода = "";
		КритерийПоиска = Перечисления.Scan_КритерииПоискаАРМ.ПустаяСсылка();
	КонецЕсли; 	
КонецПроцедуры

&НаСервере
Процедура ПоискПоКритериямНаСервере(Страница)
	ИмяСписка = "Список" + Страница;
	
	Если ТумблерПоиск = "0" Тогда  
		
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолеВвода, Символы.ПС, Истина);
		МассивПодстрокБезИзменений = Новый Массив;
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивПодстрокБезИзменений, МассивПодстрок, Истина);
		//преобразование массива, чтобы находить заказы по номеру без нулей
		Индекс = -1;
		Если КритерийПоиска = Перечисления.Scan_КритерииПоискаАРМ.НомерЗаказа Тогда
			Для Каждого ЭлементМассива Из МассивПодстрок Цикл
				Индекс = Индекс + 1;
				Если НЕ Лев(ЭлементМассива, 1) = "0" Тогда
					Попытка
						ЧислоСтроки = Число(ЭлементМассива);
					Исключение
						Продолжить;
					КонецПопытки;	
					КолВоЗнаковЧисло = СтрДлина(ЧислоСтроки);
					Для нПрефикса = 0 По (9 - КолВоЗнаковЧисло) Цикл  // 9-длина номера заказа  
						ЭлементМассива = "0" + ЭлементМассива;
					КонецЦикла;
					МассивПодстрок[Индекс] = ЭлементМассива;	
				КонецЕсли;
			КонецЦикла;
			//rarus pechek 19.06.2020 mantis 16201 +++
		ИначеЕсли КритерийПоиска = Перечисления.Scan_КритерииПоискаАРМ.НомерИзделия Тогда
			Для Каждого ЭлементМассива Из МассивПодстрок Цикл
				Индекс = Индекс + 1;
				Если НЕ Лев(ЭлементМассива, 1) = "0" Тогда
					Попытка
						ЧислоСтроки = Число(ЭлементМассива);
					Исключение
						Продолжить;
					КонецПопытки;	
					КолВоЗнаковЧисло = СтрДлина(ЧислоСтроки);
					Для нПрефикса = 0 По (7 - КолВоЗнаковЧисло) Цикл  // 7-длина номера шасси  
						ЭлементМассива = "0" + ЭлементМассива;
					КонецЦикла;
					МассивПодстрок[Индекс] = ЭлементМассива;
				КонецЕсли;
			КонецЦикла;
			//rarus pechek 19.06.2020 mantis 16201 ---
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивПодстрок, МассивПодстрокБезИзменений, Истина);
		
		Если КритерийПоиска = Перечисления.Scan_КритерииПоискаАРМ.НомерЗаказа Тогда
			ЛевоеЗначение = "ЗаказНаЗавод.Наименование";
		ИначеЕсли КритерийПоиска = Перечисления.Scan_КритерииПоискаАРМ.НомерИзделия Тогда
			ЛевоеЗначение = "Двигатель";   
		ИначеЕсли КритерийПоиска = Перечисления.Scan_КритерииПоискаАРМ.МодельПродукта Тогда
			ЛевоеЗначение = "Модель.Наименование";
		ИначеЕсли КритерийПоиска = Перечисления.Scan_КритерииПоискаАРМ.Дилер Тогда
			ЛевоеЗначение = "Дилер.Наименование";
		КонецЕсли;
		
		ОбъектНастройки = ЭтаФорма[ИмяСписка].КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы; 
		ОбъектНастройки.Очистить();
		
		НовыйОтбор = ОбъектНастройки.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.Использование  = Истина;
		НовыйОтбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ЛевоеЗначение);
		НовыйОтбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
		НовыйОтбор.ПравоеЗначение = МассивПодстрок;
	Иначе
		ОбъектНастройки =  ЭтаФорма[ИмяСписка].КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы;
		ОбъектНастройки.Очистить();
		
		// rarus tenkam 17.06.2020 mantis 16201 +++
		Если ПолеОтбора = "№ двигателя" Тогда
			ЛевоеЗначение = "Двигатель";
		ИначеЕсли ПолеОтбора = "№ Заказа" Тогда
			ЛевоеЗначение = "ЗаказНаЗавод.Наименование";
		Иначе
			ЛевоеЗначение = ПолеОтбора;
		КонецЕсли;
		
		Если ПолеОтбора = "№ двигателя" 
			ИЛИ ПолеОтбора = "№ Заказа" Тогда
			
			СообщениеОбОшибке = "";
			ОтборУстановлен = Scan_ОбщегоНазначенияКлиентСервер.УстановитьОтборДинамическогоСпискаПоНомеруОбъекта(ЭтаФорма[ИмяСписка], ЛевоеЗначение, ПолеС, ПолеПо,, СообщениеОбОшибке);
			Если НЕ ОтборУстановлен Тогда
				Сообщить(СообщениеОбОшибке);
			КонецЕсли;
		Иначе
			НовыйОтбор = ОбъектНастройки.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			НовыйОтбор.Использование  = Истина;
			НовыйОтбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ЛевоеЗначение);
			НовыйОтбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
			НовыйОтбор.ПравоеЗначение = ПолеС; 	
			
			НовыйОтбор = ОбъектНастройки.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			НовыйОтбор.Использование  = Истина;
			НовыйОтбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ЛевоеЗначение);
			НовыйОтбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
			НовыйОтбор.ПравоеЗначение = ПолеПо;	
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОтключитьПоискПоКритериямНаСервере(Страница)
	ИмяСписка = "Список" + Страница;
	ЭтаФорма[ИмяСписка].КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Очистить();
	ПолеВвода = "";
	ПолеС  = Неопределено;
	ПолеПо = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ПолеОтбораПоКоридоруПриИзмененииУниверсальная(Элемент) 
	МассивИменСтраниц = Новый Массив;
	МассивИменСтраниц.Добавить("Распределение");
	// rarus agar 10.08.2020 15894 ++
	МассивИменСтраниц.Добавить("СвободныеНовые");
	// rarus agar 10.08.2020 15894 --
	МассивИменСтраниц.Добавить("Продажи");
	МассивИменСтраниц.Добавить("ВсеПродукты"); //rarus vikhle 21.05.2021 mt 17661
	
	Для Каждого Страница Из МассивИменСтраниц Цикл
		ИмяПоляС = "ПолеС" + Страница;
		ИмяПоляПо = "ПолеПо" + Страница;
		Если Элемент.ТекстРедактирования = "№ Заказа" ИЛИ Элемент.ТекстРедактирования = "№ двигателя" Тогда  //rarus pechek 15.06.2020 mantis 16201 +++
			Элементы[ИмяПоляС].ОграничениеТипа = Новый ОписаниеТипов("Строка");
			Элементы[ИмяПоляПо].ОграничениеТипа = Новый ОписаниеТипов("Строка");
		Иначе
			Элементы[ИмяПоляС].ОграничениеТипа = Новый ОписаниеТипов("Дата");
			Элементы[ИмяПоляПо].ОграничениеТипа = Новый ОписаниеТипов("Дата");
		КонецЕсли;
	КонецЦикла;	
	ПолеС = Неопределено;
	ПолеПо = Неопределено;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьКоличествоПродуктов(Команда)
	
	ИмяСписка = "Список" + Элементы.Страницы.ТекущаяСтраница.Имя;
	ИмяКнопкиОбновленияКоличества = ИмяСписка + "ОбновитьКоличествоПродуктов";
	ИмяРеквизитаКоличествоПродуктов = "КоличествоПродуктов" + Элементы.Страницы.ТекущаяСтраница.Имя;
	ИмяРеквизитаКоличествоЗаказов = "КоличествоЗаказов" + Элементы.Страницы.ТекущаяСтраница.Имя; 
	
	ЭтаФорма[ИмяРеквизитаКоличествоПродуктов] = РассчитатьКоличествоСтрок(ИмяСписка);
	ЭтаФорма[ИмяРеквизитаКоличествоЗаказов] = РассчитатьКоличествоСтрок(ИмяСписка, "ЗаказНаЗаводКоличество"); //rarus bonmak 01.09.2020 16505 изменил название элемента
	Элементы[ИмяКнопкиОбновленияКоличества].Заголовок = НСтр("ru = 'Количество продуктов:'; en = 'Products quantity:'") + ЭтаФорма[ИмяРеквизитаКоличествоПродуктов];
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	ТЗ = СписокВТЗнаСервере(Элементы.Страницы.ТекущаяСтраница.Имя);
	Для Каждого СтрокаТЗ Из ТЗ Цикл
		Если Элементы.Страницы.ТекущаяСтраница.Имя = "Распределение" Тогда
			Если мВыбраныСсылкиРаспределение.Найти(СтрокаТЗ) = Неопределено Тогда
				мВыбраныСсылкиРаспределение.Добавить(СтрокаТЗ);
			КонецЕсли;
			КоличествоВыбранныхРаспределение = мВыбраныСсылкиРаспределение.Количество();
			СписокРаспределение.Параметры.УстановитьЗначениеПараметра("мВыбраныСсылки", мВыбраныСсылкиРаспределение);
			// rarus agar 10.08.2020 15894 ++
		ИначеЕсли Элементы.Страницы.ТекущаяСтраница.Имя = "СвободныеНовые" Тогда
			Если мВыбраныСсылкиСвободныеНовые.Найти(СтрокаТЗ) = Неопределено Тогда
				мВыбраныСсылкиСвободныеНовые.Добавить(СтрокаТЗ);
			КонецЕсли;
			КоличествоВыбранныхСвободныеНовые = мВыбраныСсылкиСвободныеНовые.Количество();
			СписокСвободныеНовые.Параметры.УстановитьЗначениеПараметра("мВыбраныСсылки", мВыбраныСсылкиСвободныеНовые);		
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Если Элементы.Страницы.ТекущаяСтраница.Имя = "Распределение" Тогда
		мВыбраныСсылкиРаспределение.Очистить();
		КоличествоВыбранныхРаспределение = мВыбраныСсылкиРаспределение.Количество();
		СписокРаспределение.Параметры.УстановитьЗначениеПараметра("мВыбраныСсылки", мВыбраныСсылкиРаспределение);
		// rarus agar 10.08.2020 15894 ++
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница.Имя = "СвободныеНовые" Тогда
		мВыбраныСсылкиСвободныеНовые.Очистить();
		КоличествоВыбранныхСвободныеНовые = мВыбраныСсылкиСвободныеНовые.Количество();
		СписокСвободныеНовые.Параметры.УстановитьЗначениеПараметра("мВыбраныСсылки", мВыбраныСсылкиСвободныеНовые);	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДействияИПоиск(Команда)
	ИмяСтраницы		=	Элементы.Страницы.ТекущаяСтраница.Имя; 
	ИмяГруппыОтбора =	"ГруппаДействияПоиск"	+	ИмяСтраницы;	 
	ИмяКнопкки 		= 	"Список" + ИмяСтраницы + "ДействияИПоиск";
	Элементы[ИмяГруппыОтбора].Видимость	= НЕ Элементы[ИмяГруппыОтбора].Видимость;
	Элементы[ИмяКнопкки].Пометка		= НЕ Элементы[ИмяКнопкки].Пометка;
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоКритериям(Команда)
	ИспользоватьЧислоВместоСтроки = Ложь;
	Если ТумблерПоиск = "0" Тогда 	
		Если НЕ ЗначениеЗаполнено(КритерийПоиска) Тогда
			Сообщить(НСтр("ru = 'Выберите критерий поиска!'; en = 'Select your search criteria!'"));
			Возврат;
		КонецЕсли;
		
		Если СокрЛП(ПолеВвода) = "" Тогда
			Сообщить(НСтр("ru = 'Список данных для поиска пустой!'; en = 'The search data list is empty!'"));
			Возврат;
		КонецЕсли;
	Иначе
		Если НЕ ЗначениеЗаполнено(ПолеОтбора) Тогда
			Сообщить(НСтр("ru = 'Выберите критерий поиска!'; en = 'Select your search criteria!'"));
			Возврат;
		КонецЕсли;
		
		Попытка
			ЧислоПолеС = Число(ПолеС);
			ЧислоПолеПо = Число(ПолеПо);
			ИспользоватьЧислоВместоСтроки = Истина;
		Исключение
			// Rarus tenkam 11.02.2022 АПК +++
			Сообщить(НСтр("ru = 'Неверные данные поиска!'; en = 'Wrong data!'"));
			Возврат;
		    // Rarus tenkam 11.02.2022 АПК ---
		КонецПопытки;
		
		Если ТипЗнч(ПолеПо)=ТипЗнч(ПолеС) И ПолеПо < ПолеС И НЕ ИспользоватьЧислоВместоСтроки Тогда
			Сообщить(НСтр("ru = 'Конечное значение коридора периода не может быть меньше начального!'; en = 'Final value cannot be lower that starting point of the period corridor!'"));
			Возврат;
		ИначеЕсли ИспользоватьЧислоВместоСтроки Тогда 	
			Если ЧислоПолеПо < ЧислоПолеС Тогда
				Сообщить(НСтр("ru = 'Конечное значение коридора периода не может быть меньше начального!'; en = 'Final value cannot be lower that starting point of the period corridor!'"));
				Возврат;
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;
	
	СнятьФлажки(Команды.СнятьФлажки); //rarus agar 22.03.2021 17501 +-
	
	ПоискПоКритериямНаСервере(Элементы.Страницы.ТекущаяСтраница.Имя);
КонецПроцедуры

//ИЗМЕНЕНИЕ ЛОКАЛЬНОГО СТАТУСА
&НаКлиенте
Процедура ИзменитьЛокальныйСтатус(Команда)	
	// rarus agar 15.02.2021 17225 ++	
	//rarus vikhle 16.02.2021 mt 17209 +++
	Если Не Scan_ПраваИНастройки.Scan_Право("РазрешатьИзменениеСтатусовПродуктов") Тогда
		ВывестиСообщениеПол(Нстр("ru = 'Нет права на изменение локальных статусов продуктов.'"));
		Возврат;
	КонецЕсли;	
	//rarus vikhle 16.02.2021 mt 17209 ---
	
	ТекущаяСтраница = Элементы.Страницы.ТекущаяСтраница.Имя;
	
	Если ТекущаяСтраница = "Распределение" Тогда
		ЛокальныйСтатус  = ЛокальныйСтатусРаспределение;
		ВыбранныеИзделия = мВыбраныСсылкиРаспределение;
		
		ТекстВопроса = Нстр("ru = 'Поменять статус с NEW на OPEN?'; en = 'Change status from NEW to OPEN?'");
	Иначе
		ЛокальныйСтатус  = ЛокальныйСтатусСвободныеНовые;
		ВыбранныеИзделия = мВыбраныСсылкиСвободныеНовые;
		
		ТекстВопроса = Нстр("ru = 'Поменять статус с OPEN на NEW?'; en = 'Change status from OPEN to NEW?'");
	КонецЕсли;
	
	Если ЛокальныйСтатус.Пустая() Тогда
		Сообщить(НСтр("ru = 'Не заполнен статус!'; en = 'Local status is not filled'"));
		Возврат;
	ИначеЕсли ВыбранныеИзделия.Количество() = 0 Тогда
		Сообщить(НСтр("ru = 'Не выбраны продукты!'; en = 'No products selected'"));
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЛокальныйСтатус",  ЛокальныйСтатус);
	ДополнительныеПараметры.Вставить("ВыбранныеИзделия", ВыбранныеИзделия);
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ИзменитьЛокальныйСтатусЗавершение", ЭтотОбъект, ДополнительныеПараметры), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	// rarus agar 15.02.2021 17225 --
	
КонецПроцедуры

// rarus agar 15.02.2021 17225 ++
&НаКлиенте
Процедура ИзменитьЛокальныйСтатусЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ИзменитьЛокальныйСтатусНаСервере(ДополнительныеПараметры.ВыбранныеИзделия, ДополнительныеПараметры.ЛокальныйСтатус);
		СнятьФлажки(Команды.Найти("СнятьФлажки"));
		ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.Scan_СводнаяИнформацияПоПродукту"));
	КонецЕсли;
	
КонецПроцедуры
// rarus agar 15.02.2021 17225 --

//ОТКРЫТИЕ ОТЧЕТОВ
&НаКлиенте
Процедура ОткрытьDeliveriesReport(Команда)
	ОткрытьФорму("Отчет.Scan_DeliveriesReport.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьOrderBookStatistics(Команда)
	ОткрытьФорму("Отчет.Scan_OrderBookStatistics.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьOrderDeviation(Команда)
	ОткрытьФорму("Отчет.Scan_OrderDeviation.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьOrderIntakeAndOrderBook(Команда)
	ОткрытьФорму("Отчет.Scan_OrderIntakeAndOrderBook.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьOrderIntake(Команда)
	ОткрытьФорму("Отчет.Scan_OrderIntake.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсторияПеремещенийИзделий(Команда)
	ОткрытьФорму("Отчет.Scan_ИсторияПеремещенийИзделий.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьПоискПоКритериям(Команда)
	ОтключитьПоискПоКритериямНаСервере(Элементы.Страницы.ТекущаяСтраница.Имя);
КонецПроцедуры

//rarus vikhle 26.08.2020 mt 16274 +++
&НаКлиенте
Процедура ОткрытьСписокОтгрузок(Команда)
	ОткрытьФорму("Отчет.Scan_СписокОтгрузок.Форма");
КонецПроцедуры
//rarus vikhle 26.08.2020 mt 16274 ---

//rarus kabany 26.04.2021 17666 +++
&НаКлиенте
Процедура ОткрытьОтчетПлановыеЦеныПродажиШасси(Команда)
	ОткрытьФорму("Отчет.Scan_ОтчетПоПлановымЦенамПродажиШасси.Форма");
КонецПроцедуры
//rarus kabany 26.04.2021 17666 ---

&НаКлиенте
Процедура ОткрытьМониторПродаж(Команда) //rarus bonmak 16459 07.12.2020 ++
	ОткрытьФорму("Обработка.Scan_МониторыПродаж.Форма",,,,,,, РежимОткрытияОкнаФормы.Независимый);
КонецПроцедуры //rarus bonmak 16459 07.12.2020 --

//МОНИТОРЫ

&НаКлиенте
Процедура ПерейтиВМонитор(Команда)//rarus pechek 25.06.2020 mantis 15894 +++
	
	МассивВыбранныхСтрок = Элементы.ЗаявкиНаОтгрузку.ВыделенныеСтроки;
	
	Если МассивВыбранныхСтрок.Количество() = 0 Тогда
		ДатаОтгрузки = ОбщегоНазначенияКлиент.ДатаСеанса();
	ИначеЕсли МассивВыбранныхСтрок.Количество() > 1 Тогда
		Сообщить(НСтр("ru = 'Выберите один документ'; en = 'Select one document'"));                            
		Возврат;
	Иначе
		ДатаОтгрузки = Элементы.ЗаявкиНаОтгрузку.ТекущиеДанные.ДатаОтгрузки;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("ДатаОтгрузки", ДатаОтгрузки);
	ОткрытьФорму("Обработка.Scan_МониторБронированияОтгрузок.Форма",ПараметрыОткрытия,,,,,, РежимОткрытияОкнаФормы.Независимый);
КонецПроцедуры

// Взаимодействия
&НаКлиенте
Процедура ОткрытьВзаимодействия(Команда) //rarus vikhle 13.10.2021 mt 17995 +++
	
	ОткрытьФорму("ЖурналДокументов.Взаимодействия.Форма.ФормаСписка");
	
КонецПроцедуры //rarus vikhle 13.10.2021 mt 17995 ---

#КонецОбласти