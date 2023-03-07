//rarus FominskiyAS 12.08.2019  mantis 14760 +++

// Формирует печатные формы
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр).
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной
//                                                            параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной
//                                            параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
		МодульУправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
				КоллекцияПечатныхФорм,"СервисныеОперацииПриКТС", НСтр("ru = 'Сервисные операции при КТС'"),
				ПечатьПФ_MXL_СервисныеОперацииПриКТС(ПараметрыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьПФ_MXL_СервисныеОперацииПриКТС(ПараметрыПодготовкиПечатнойФормы) Экспорт
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.КлючПараметровПечати = "ПФ_MXL_СервисныеОперацииПриКТС";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Scan_ЧекЛистТехническогоСостоянияИзделия.ПФ_MXL_СервисныеОперацииПриКТС");
	
	Для Каждого Элемент из ПараметрыПодготовкиПечатнойФормы.МассивОбъектов цикл 
	Документ = Элемент;
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрокаПервая = Макет.ПолучитьОбласть("СтрокаПервая");
	ОбластьСтрокаВложенная = Макет.ПолучитьОбласть("СтрокаВложенная");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	//Заполним шапку
	
	ОбластьШапка.Параметры.КоличествоДней = НРег(ЧислоПрописью(Документ.СрокКТС,,"день,дня,дней,м,,,,,0"));
	ТабличныйДокумент.Вывести(ОбластьШапка);
	
	//Заполним строки
	
	НомерСтроки = 1;
	НомерВложеннойСтроки = 1;
	//МассивБукв = ПолучитьМассивБукв();
	
	СтараяПерваяСтрока = Неопределено;
	ВерхняяСтрокаДерева = Неопределено;
	Для Каждого ТекСтрокаОбъекта Из Документ.СервисныеОперацииПакета Цикл
		ОбластьСтрокаПервая.Параметры.НомерСтроки = НомерСтроки;
		ОбластьСтрокаПервая.Параметры.Работы = ТекСтрокаОбъекта.СервиснаяОперацияПакета;			
		НомерСтроки = НомерСтроки + 1;
		ТабличныйДокумент.Вывести(ОбластьСтрокаПервая);
		СоставляющиеСервисныхОпераций(ТекСтрокаОбъекта.СервиснаяОперацияПакета,ОбластьСтрокаВложенная,ТабличныйДокумент);
	КонецЦикла; 	
	
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура СоставляющиеСервисныхОпераций(СервиснаяОперацияПакета,ОбластьСтрокаВложенная,ТабличныйДокумент)
	
	МассивБукв = ПолучитьМассивБукв();
	НомерВложеннойСтроки = 1;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_СоставляющиеСервисныхОпераций.Ссылка КАК Ссылка,
		|	Scan_СоставляющиеСервисныхОпераций.Наименование КАК Наименование
		|ИЗ
		|	Справочник.Scan_СоставляющиеСервисныхОпераций КАК Scan_СоставляющиеСервисныхОпераций
		|ГДЕ
		|	Scan_СоставляющиеСервисныхОпераций.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", СервиснаяОперацияПакета);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОбластьСтрокаВложенная.Параметры.НомерСтроки = МассивБукв[НомерВложеннойСтроки];
		ОбластьСтрокаВложенная.Параметры.Составляющая = ВыборкаДетальныеЗаписи.Наименование;			
		НомерВложеннойСтроки = НомерВложеннойСтроки + 1;
		ТабличныйДокумент.Вывести(ОбластьСтрокаВложенная);
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьМассивБукв() Экспорт
	МассивБукв = Новый Массив;
	
	МассивБукв.Добавить("0");
	МассивБукв.Добавить("а");
	МассивБукв.Добавить("б");
	МассивБукв.Добавить("в");
	МассивБукв.Добавить("г");
	МассивБукв.Добавить("д"); 	
	МассивБукв.Добавить("е");
	МассивБукв.Добавить("ж");
	МассивБукв.Добавить("з");
	МассивБукв.Добавить("и");
	МассивБукв.Добавить("к");
	МассивБукв.Добавить("л");
	МассивБукв.Добавить("м");
	МассивБукв.Добавить("н");
	МассивБукв.Добавить("о"); 	
	МассивБукв.Добавить("п");
	МассивБукв.Добавить("р");
	МассивБукв.Добавить("с");
	МассивБукв.Добавить("т");
	МассивБукв.Добавить("у");
	МассивБукв.Добавить("ф");
	МассивБукв.Добавить("х");
	МассивБукв.Добавить("ц");
	МассивБукв.Добавить("ч");
	МассивБукв.Добавить("ш");
	МассивБукв.Добавить("э"); 
	МассивБукв.Добавить("ю"); 
	МассивБукв.Добавить("я");
	
	Возврат МассивБукв;
КонецФункции

//rarus FominskiyAS 12.08.2019  mantis 14760 ---  