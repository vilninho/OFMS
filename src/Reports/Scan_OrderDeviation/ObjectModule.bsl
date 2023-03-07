#Область Механизм_Подключения_Дополнительного_Отчета

// Для внутреннего использования. Сведения для регистрации отчета.
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид",             "ДополнительныйОтчет"); // Варианты: "ДополнительнаяОбработка", "ДополнительныйОтчет", 
																			 // "ЗаполнениеОбъекта", "Отчет", "ПечатнаяФорма", "СозданиеСвязанныхОбъектов" 
	
	ПараметрыРегистрации.Вставить("Наименование",    "Внешний отчет: " + Метаданные().Синоним);
	ПараметрыРегистрации.Вставить("Версия",          "<Версия>");     // версия внешнего тчета.
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);           // если ИСТИНА, то выводится конфигураторская ошибка в типовой реализации,
																	  // связанная с ограничениями при использовании компоненты в механизмах внешних отчетов и обработок.
	ПараметрыРегистрации.Вставить("Информация",      "<Информация>");
	ПараметрыРегистрации.Вставить("ВерсияБСП",       "2.4.6.62");     // не ниже какой версии БСП подерживается обработка
	
	// Команды формирования отчета:
	ТаблицаКоманд = Новый ТаблицаЗначений;
	ТаблицаКоманд.Колонки.Добавить("Представление",         Новый ОписаниеТипов("Строка"));
	ТаблицаКоманд.Колонки.Добавить("Идентификатор",         Новый ОписаниеТипов("Строка"));
	ТаблицаКоманд.Колонки.Добавить("Использование",         Новый ОписаниеТипов("Строка"));
	ТаблицаКоманд.Колонки.Добавить("ПоказыватьОповещение",  Новый ОписаниеТипов("Булево"));
	ТаблицаКоманд.Колонки.Добавить("Модификатор",           Новый ОписаниеТипов("Строка"));
	
	// для Платежных документов:
	ДобавитьКоманду(ТаблицаКоманд,
					"" + ПараметрыРегистрации.Наименование,
					"" + ПараметрыРегистрации.Наименование,
					"ОткрытиеФормы",	//Использование.  Варианты: "ОткрытиеФормы", "ВызовКлиентскогоМетода", "ВызовСерверногоМетода".
					Ложь,				//Показывать оповещение. Варианты Истина, Ложь.
					"");				//Модификатор.
	
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции // СведенияОВнешнейОбработке()

// Добавляет команды в таблицу.
Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")

	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление        = Представление;
	НоваяКоманда.Идентификатор        = Идентификатор;
	НоваяКоманда.Использование        = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор          = Модификатор;

КонецПроцедуры // ДобавитьКоманду()

// Выполнение команд для нефайловой базы.
// ИдентификаторКоманды - вызываемая команда: "СформироватьОтчет".
Процедура ВыполнитьКоманду(ИдентификаторКоманды, ПараметрыКоманды) Экспорт
	
	Выполнить(ИдентификаторКоманды + "(ПараметрыКоманды.ПараметрыОтчета, ПараметрыКоманды.АдресХранилища)");
	
	ПараметрыКоманды.Вставить("ЗаданиеВыполнено",     Истина);
	ПараметрыКоманды.Вставить("ИдентификаторЗадания", Неопределено);
	
КонецПроцедуры


#КонецОбласти // Механизм_Подключения_Дополнительного_Отчета


Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	//КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();    
	//
	//
	//МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, 
	//КомпоновщикНастроек.ПолучитьНастройки(),ДанныеРасшифровки,,Тип("ГенераторМакетаКомпоновкиДанных"),Истина);
	//
	//
	//// Инициализация процессора компоновки
	//ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	//ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных,,ДанныеРасшифровки,Истина);
	//
	//ТабличныйДокументРезультата = Новый ТабличныйДокумент;
	//
	//// Получение результата
	//ПроцессорВыводаРезультатаКомпоновкиДанных = Новый 
	//ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	//
	//ПроцессорВыводаРезультатаКомпоновкиДанных.УстановитьДокумент(ТабличныйДокументРезультата);
	//ПроцессорВыводаРезультатаКомпоновкиДанных.Вывести(ПроцессорКомпоновкиДанных);
КонецПроцедуры