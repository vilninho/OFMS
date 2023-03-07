
// Возвращает предопределенную структуру действий
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Функция ПолучитьПараметрыДействия(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	Если ПараметрыДействия=Неопределено Тогда
		ПараметрыДействия = Новый Структура;
	КонецЕсли;
	
	// Производим добавление параметров расширяемых контекст обработки событий объекта
	//ПараметрыДействия.Вставить("ОбъектЗаполнен", Объект.СоставЗаявки.Количество() > 0);
	
	Возврат ПараметрыДействия;
	
КонецФункции // ПолучитьПараметрыДействия()

// Обработчик события возникающего при изменении данных реквизита "Хоз. операция".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ХозОперацияПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	
	// Вызываем общий обработчик события
	
КонецПроцедуры // ХозОперацияПриИзменении()

Функция ПолучитьКоличествоРабочихДней(ГодПланирования,МесяцПланирования) Экспорт	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(ЕСТЬNULL(КалендарныеГрафики.ДатаГрафика, 0)) КАК КоличествоРабочихДней
	               |ИЗ
	               |	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	               |ГДЕ
	               |	КалендарныеГрафики.ДеньВключенВГрафик
	               |	И КалендарныеГрафики.Год = &ГодПланирования
	               |	И МЕСЯЦ(КалендарныеГрафики.ДатаГрафика) = &МесяцПланирования";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ГодПланирования",ГодПланирования);
	Запрос.УстановитьПараметр("МесяцПланирования",МесяцПланирования);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.КоличествоРабочихДней;
КонецФункции