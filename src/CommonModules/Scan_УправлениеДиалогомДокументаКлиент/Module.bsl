//rarus sergei 24.06.2016 mantis 6976 ++

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ФОРМЫ ДОКУМЕНТА

// Общий обработчик события выбора одного из пунктов меню доступных хоз. операций
// 
// Параметры:
//  Объект     - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  Элемент    - ПолеФормы            - Элемент управления, в котором возникло данное событие.
//  ИмяКоманды - Строка               - Имя команды, в которой возникло данное событие.
//
Процедура ОбработатьВыборХозОперации(Объект, Элементы, ИмяКоманды) Экспорт
	
	Объект.ХозОперация = ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации."+СтрЗаменить(ИмяКоманды, "ХозОперация", ""));
	
	Для каждого КнопкаОперации Из Элементы.ВыборХозОперации.ПодчиненныеЭлементы Цикл
		КнопкаОперации.Пометка = (КнопкаОперации.Имя=ИмяКоманды);
	КонецЦикла;
	
КонецПроцедуры // ОбработатьВыборХозОперации()

// Общий обработчик события возникающего при открытии настройки параметров документа.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма, в которой возникло событие.
//
Процедура НастроитьПараметрыДокумента(Форма, ПараметрыДействия = Неопределено) Экспорт
	
	// Формируем структуру параметров открытия вспомогательной формы
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Объект",                       Форма.Объект);
	ПараметрыФормы.Вставить("Операция",                     СокрЛП(Форма.Объект.ХозОперация));
	ПараметрыФормы.Вставить("ПоказыватьПараметрыДокумента", Форма.Элементы.ПараметрыДокумента.Видимость);
	ПараметрыФормы.Вставить("ТолькоПросмотр",               Форма.ТолькоПросмотр);
	
	//rarus BProg_Gladkov 01.12.2019 0014560 ++ 
	Если ЗначениеЗаполнено(ПараметрыДействия) тогда
		Для Каждого Элемент из ПараметрыДействия цикл
			ПараметрыФормы.Вставить(Элемент.Ключ, ПараметрыДействия[Элемент.Ключ]); 	
		КонецЦикла;
	КонецЕсли;	
	//rarus BProg_Gladkov 01.12.2019 0014560 -- 
	
	// Производим открытие формы параметров
	//Обработчик = Новый ОписаниеОповещения("НастроитьФорму", ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ОткрытьФорму("ОбщаяФорма.Scan_ПараметрыДокумента", ПараметрыФормы,Форма,,,, Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаОповещения", Форма, "ПараметрыДокумента"), Режим);
	
КонецПроцедуры // НастроитьПараметрыДокумента()

//Процедура НастроитьФорму(ПараметрыЗакрытия,Парам) Экспорт
//	Если ПараметрыЗакрытия = Неопределено Тогда
//		Возврат;
//	КонецЕсли;
//	Scan_УправлениеДиалогомДокументаСервер.ПараметрыДокументаПриИзменении(ПараметрыЗакрытия=Неопределено);	
//КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СЛУЖЕБНОГО ПРОГРАММНОГО ИНТЕРФЕЙСА

// Общий обработчик события выбора одного из пунктов меню доступных хоз. операций
// 
// Параметры:
//  Форма             - УправляемаяФорма          - Форма, в которой возникло событие.
//  Команда           - КомандаФормы              - Команда, в которой возникло данное событие.
//  Объект            - ДанныеФормыСтруктура      - Объект, для которого выполняется обработка события.
//  Окно              - ОкноКлиентскогоПриложения - Содержит окно, в котором требуется открыть форму.
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
Функция ОбработкаКомандыФормы(Форма, Команда, Объект, Окно=Неопределено, ПараметрыДействия=Неопределено) Экспорт
	
	// Обработаем в зависимости от выбранной команды
	Если Команда.Имя="НастроитьПараметрыДокумента" Тогда
		Scan_УправлениеДиалогомДокументаКлиент.НастроитьПараметрыДокумента(Форма, ПараметрыДействия); //rarus BProg_Gladkov 01.12.2019 0014560 +- Передал ПараметрыДействия в НастроитьПараметрыДокумента
	КонецЕсли;	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат ЛОЖЬ;
	
КонецФункции // ОбработкаКомандыФормы()


//rarus sergei 24.06.2016 mantis 6976 ++
