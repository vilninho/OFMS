// Обработчик события возникающего при изменении данных реквизита "Флаг уволен".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ФлагУволенПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	Если Объект.ФлагУволен Тогда
		Если НЕ ЗначениеЗаполнено(Объект.ДатаУвольнения) Тогда
			Объект.ДатаУвольнения = ТекущаяДата();
		КонецЕсли; 
	Иначе
		Если ЗначениеЗаполнено(Объект.ДатаУвольнения) Тогда
			Объект.ДатаУвольнения = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ФлагУволенПриИзменении()
