//rarus sergei 20.09.2016 mantis 7167 ++
&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("МассивВыбранныхСтрок") Тогда
		ВыбранныеСтроки.ЗагрузитьЗначения(Параметры.МассивВыбранныхСтрок);
		//rarus sergei 07.10.2016 mantis 7629 ++
		МестоДоставки = ПолучитьМестоДоставки(ВыбранныеСтроки);
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МестоДоставки");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = МестоДоставки;
		//rarus sergei 07.10.2016 mantis 7629 --
		//rarus sergei 27.10.2016 mantis 7629 ++
		МестоОтгрузки = ПолучитьМестоОтгрузки(ВыбранныеСтроки);
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МестоОтгрузки");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = МестоОтгрузки;
		//rarus sergei 27.10.2016 mantis 7629 --
		//rarus sergei 03.11.2016 mantis 7629 ++
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодтвержденаПеревозчиком");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = Ложь;
		//rarus sergei 03.11.2016 mantis 7629 --
	КонецЕсли;
	
	//rarus FominskiyAS 27.02.2019  mantis 13863 +++
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	//rarus FominskiyAS 27.02.2019  mantis 13863 ---
	
КонецПроцедуры

//rarus sergei 07.10.2016 mantis 7629 ++
&НаСервере
Функция ПолучитьМестоДоставки(ВыбранныеИзделия)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_КорректировкаИнформацииПоЗаявкам.МестоДоставки
	               |ИЗ
	               |	РегистрСведений.Scan_КорректировкаИнформацииПоЗаявкам КАК Scan_КорректировкаИнформацииПоЗаявкам
	               |ГДЕ
	               |	Scan_КорректировкаИнформацииПоЗаявкам.GuidСтроки В(&СписокСсылок)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Scan_КорректировкаИнформацииПоЗаявкам.МестоДоставки";
	Запрос.УстановитьПараметр("СписокСсылок", ВыбранныеИзделия);
	ТЗ = Запрос.Выполнить().Выгрузить();
	МестоДоставки = ТЗ[0].МестоДоставки;
	Возврат МестоДоставки;
КонецФункции
//rarus sergei 07.10.2016 mantis 7629 --

//rarus sergei 27.10.2016 mantis 7629 ++
&НаСервере
Функция ПолучитьМестоОтгрузки(ВыбранныеИзделия)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_КорректировкаИнформацииПоЗаявкам.ЗаявкаНаДействие.МестоПолучения
	               |ИЗ
	               |	РегистрСведений.Scan_КорректировкаИнформацииПоЗаявкам КАК Scan_КорректировкаИнформацииПоЗаявкам
	               |ГДЕ
	               |	Scan_КорректировкаИнформацииПоЗаявкам.GuidСтроки В(&СписокСсылок)";
	Запрос.УстановитьПараметр("СписокСсылок", ВыбранныеИзделия);
	ТЗ = Запрос.Выполнить().Выгрузить();
	МестоПолучения = ТЗ[0].ЗаявкаНаДействиеМестоПолучения;
	Возврат МестоПолучения;
КонецФункции
//rarus sergei 27.10.2016 mantis 7629 --
&НаКлиенте
Процедура Добавить(Команда)
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество()>1 Или ВыделенныеСтроки.Количество() = 0 Тогда
		Сообщить("Выберите одну заявку перевозчику");
		Возврат;
	ИначеЕсли  НЕ ПроверитьУсловиеДобавленияЗаявок(ВыделенныеСтроки[0]) ИЛИ ДокументПодтвержден(ВыделенныеСтроки[0]) Тогда
		Возврат;
	КонецЕсли;
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ЗаявкаПеревозчику",ВыделенныеСтроки[0]);
	Закрыть(ПараметрыЗакрытия);
КонецПроцедуры

&НаСервере
Функция ДокументПодтвержден(ЗаявкаПеревозчику)
	Если ЗаявкаПеревозчику.ПодтвержденаПеревозчиком = Истина Тогда
		Сообщить("Нельзя добавить Продукты в Заявку Перевозчику, которая уже подтверждена");
		Возврат Истина;
	Иначе
		Возврат Ложь;
		
	
	КонецЕсли; 	
КонецФункции

&НаСервере
Функция ПроверитьУсловиеДобавленияЗаявок(ЗаявкаПеревозчику)
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ
	              |	Scan_КорректировкаИнформацииПоЗаявкам.ДатаДоставкиПлан,
	              |	Scan_КорректировкаИнформацииПоЗаявкам.Грузополучатель,
	              |	Scan_КорректировкаИнформацииПоЗаявкам.МестоДоставки,
	              |	Scan_КорректировкаИнформацииПоЗаявкам.СпособДоставки,
	              |	Scan_КорректировкаИнформацииПоЗаявкам.ПриемВВыходныеДни
	              |ИЗ
	              |	РегистрСведений.Scan_КорректировкаИнформацииПоЗаявкам КАК Scan_КорректировкаИнформацииПоЗаявкам
	              |ГДЕ
	              |	Scan_КорректировкаИнформацииПоЗаявкам.GuidСтроки = &ВыбраннаяСтрока";
	Запрос.УстановитьПараметр("ВыбраннаяСтрока",ВыбранныеСтроки[0].Значение);
	ТЗ= Запрос.Выполнить().Выгрузить();
	//Если ТЗ[0].ДатаДоставкиПлан <> НачалоДня(ЗаявкаПеревозчику.ДатаДоставки) Тогда
	Если НачалоДня(ТЗ[0].ДатаДоставкиПлан) <> НачалоДня(ЗаявкаПеревозчику.ДатаДоставки) Тогда // RARUS sergei 7670 баг (Дата доставки стала со временем в документе Заявка на Действие) 
		Сообщить("Нельзя добавить выбранные продукты в "+ЗаявкаПеревозчику+", так как у документа и продуктов разная дата доставки");
		Возврат Ложь;
	КонецЕсли; 
	Если ТЗ[0].Грузополучатель <> ЗаявкаПеревозчику.КомпанияПолучатель Тогда
		Сообщить("Нельзя добавить выбранные продукты в "+ЗаявкаПеревозчику+", так как у документа и продуктов отличается Грузополучатель");
		Возврат Ложь;
	КонецЕсли; 
	Если ТЗ[0].МестоДоставки <> ЗаявкаПеревозчику.МестоДоставки Тогда
		Сообщить("Нельзя добавить выбранные продукты в "+ЗаявкаПеревозчику+", так как у документа и продуктов отличается место доставки");
		Возврат Ложь;
	КонецЕсли; 
	Если ТЗ[0].СпособДоставки <> ЗаявкаПеревозчику.СпособДоставкиИзделий Тогда
		Сообщить("Нельзя добавить выбранные продукты в "+ЗаявкаПеревозчику+", так как у документа и продуктов отличается способ доставки");
		Возврат Ложь;
	КонецЕсли; 
	//rarus sergei 30.09.2016 mantis 7122 ++
	//Если ТЗ[0].ПриемВВыходныеДни <> ЗаявкаПеревозчику.ВозможностьПриемаВВыходныеДни Тогда
	//	Сообщить("Нельзя добавить выбранные изделия в "+ЗаявкаПеревозчику+", так как у документа и изделий отличается возможность приема в выходные дни");
	//	Возврат Ложь;
	//КонецЕсли; 
	//rarus sergei 30.09.2016 mantis 7122 --

	Возврат Истина;
КонецФункции // ()
//rarus sergei 20.09.2016 mantis 7167 --


//rarus FominskiyAS 27.02.2019  mantis 13863 +++

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//rarus FominskiyAS 27.02.2019  mantis 13863 ---
