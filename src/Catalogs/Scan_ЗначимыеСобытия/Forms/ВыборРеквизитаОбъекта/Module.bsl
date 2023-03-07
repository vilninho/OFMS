// Модуль формы справочника "Значимые события"


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Процедура-обработчик команды "Выбрать"
//
&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбраннаяСтрока = Элементы.Поля.ТекущаяСтрока;
	ТекущиеДанныеСтроки = Элементы.Поля.ТекущиеДанные;
	Если ТекущиеДанныеСтроки=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Вызываем обработчик события
	ПоляВыбор(Элементы.Поля, ВыбраннаяСтрока, Элементы.ПоляПоле, ЛОЖЬ);
	
КонецПроцедуры // Выбрать()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура-обработчик события "Выбор" таблицы "Поля"
//
&НаКлиенте
Процедура ПоляВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// Отказываемся от стандартной обработки события
	СтандартнаяОбработка = ЛОЖЬ;
	
	// Обрабатываем в зависимости от типа строки
	Если Элемент.ТекущиеДанные.ЭтоГруппа Тогда
		Если Элементы.Поля.Развернут(ВыбраннаяСтрока) Тогда
			Элементы.Поля.Свернуть(ВыбраннаяСтрока);
		Иначе
			Элементы.Поля.Развернуть(ВыбраннаяСтрока);
		КонецЕсли;
	Иначе
		ОповеститьОВыборе(Элемент.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры // ПоляВыбор()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура-обработчик события "ПриСозданииНаСервере" Формы
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Источник") Тогда
		Источник = Параметры.Источник;
	КонецЕсли;
	
	ДеревоПолей = РеквизитФормыВЗначение("Поля");
	ДеревоПолей = Scan_ЗначимыеСобытия.ПолучитьДеревоМетаданныхОбъекта(Источник);
	ЗначениеВРеквизитФормы(ДеревоПолей, "Поля");
	
КонецПроцедуры // ПриСозданииНаСервере()


