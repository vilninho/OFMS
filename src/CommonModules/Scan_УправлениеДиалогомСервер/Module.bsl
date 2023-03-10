//rarus sergei 28.06.2016 mantis 6976 ++

Процедура ОбновитьПараметрВыбора(ПараметрыВыбора, ИмяПараметра, ЗначениеПараметра) Экспорт
	
	Если ТипЗнч(ЗначениеПараметра)=Тип("Массив") Тогда
		НовыйПараметрВыбора = Новый ПараметрВыбора(ИмяПараметра, Новый ФиксированныйМассив(ЗначениеПараметра));
	Иначе
		НовыйПараметрВыбора = Новый ПараметрВыбора(ИмяПараметра, ЗначениеПараметра);
	КонецЕсли;
	
	ОбновитьФиксированныйМассивПараметровВыбора(ПараметрыВыбора, НовыйПараметрВыбора);
	
КонецПроцедуры // ОбновитьПараметрВыбора()

Процедура УдалитьПараметрВыбора(ПараметрыВыбора, ИмяПараметра) Экспорт
	
	ОбновитьФиксированныйМассивПараметровВыбора(ПараметрыВыбора, ИмяПараметра);
	
КонецПроцедуры // УдалитьПараметрВыбора()

Процедура ОбновитьФиксированныйМассивПараметровВыбора(КоллекцияПараметровВыбора, НовыйПараметрВыбора) Экспорт
	
	НоваяКоллекцияПараметров = Новый Массив;
	
	Если ТипЗнч(НовыйПараметрВыбора)=Тип("Строка") Тогда
		ИмяПараметра = НовыйПараметрВыбора;
	Иначе
		ИмяПараметра = НовыйПараметрВыбора.Имя;
		НоваяКоллекцияПараметров.Добавить(НовыйПараметрВыбора);
	КонецЕсли;
	
	Для Каждого ПараметрВыбора Из КоллекцияПараметровВыбора Цикл
		Если ПараметрВыбора.Имя=ИмяПараметра Тогда
			Продолжить;
		КонецЕсли;
		НоваяКоллекцияПараметров.Добавить(ПараметрВыбора);
	КонецЦикла;
	
	КоллекцияПараметровВыбора = Новый ФиксированныйМассив(НоваяКоллекцияПараметров);
	
КонецПроцедуры // ОбновитьФиксированныйМассивПараметровВыбора()


//Формирование условного обозначения для форм списка справочников и документов
//
//Параметры:
//Форма - УправляемаяФорма - ФормаСписка, в которой возникло событие, в списке должна присудствовать колонка с состоянием (статусом)
//Источник - Справочник с хранимыми значениями статусов (состояний) документа
//ПолеОтбора - Путь к данным в Списке
//ПолеЦвета - Наименование реквизита справочника, в котором хранится значение цвета
// ИсключаемыеПоля - Строка, поля которые не будут окрашены
Процедура СформироватьУсловноеОформление(Форма, Источник, ПолеОтбора = "Ссылка", ПолеЦвета = "Цвет", ИсключаемыеПоля = "", ДинамическийСписок = "Список", ПолеШрифт = "Шрифт") Экспорт
	
	Форма.УсловноеОформление.Элементы.Очистить();
	НаименованиеСправочника = "Справочник."+Строка(Источник.ПустаяСсылка().Метаданные().Имя);
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	Справочник.Ссылка,
	|	Справочник."+ПолеЦвета+" КАК Цвет
	|ИЗ
	|	"+НаименованиеСправочника+" КАК Справочник
	|	"+?(Источник.ПустаяСсылка().Метаданные().Иерархический = Истина, 
	"ГДЕ
	|	(Справочник.ЭтоГруппа = ЛОЖЬ)", "");
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ЭлементОформления = Форма.УсловноеОформление.Элементы.Добавить();
		
		// Создаем условие отбора
		ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(СтрШаблон("%1.%2", ДинамическийСписок, ПолеОтбора));
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
		//Значение для отбора
		ЭлементОтбора.ПравоеЗначение = Выборка.Ссылка;
		ЭлементОтбора.Использование = Истина;
		
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", Выборка.Цвет.Получить());
		ЭлементОформления.Использование = Истина;
		
		НайденныйЭлемент = Форма.Элементы.Найти(ДинамическийСписок);
		//оформление полей строки
		Если НайденныйЭлемент <> Неопределено Тогда
			Для каждого ПолеОформления Из НайденныйЭлемент.ПодчиненныеЭлементы Цикл
				Если Найти(ИсключаемыеПоля, ПолеОформления.Имя) = 0 Тогда
					ПолеДляОформления = ЭлементОформления.Поля.Элементы.Добавить();
					ПолеДляОформления.Поле = Новый ПолеКомпоновкиДанных(ПолеОформления.Имя);
					ПолеДляОформления.Использование = Истина;
					Если ТипЗнч(ПолеОформления) = Тип("ГруппаФормы") Тогда
						Для каждого ПолеОформленияГруппы Из ПолеОформления.ПодчиненныеЭлементы Цикл
							Если Найти(ИсключаемыеПоля, ПолеОформленияГруппы.Имя) = 0 Тогда
								ПолеДляОформленияГруппы = ЭлементОформления.Поля.Элементы.Добавить();
								ПолеДляОформленияГруппы.Поле = Новый ПолеКомпоновкиДанных(ПолеОформленияГруппы.Имя);
								ПолеДляОформленияГруппы.Использование = Истина;
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
//rarus sergei 28.06.2016 mantis 6976 --

//rarus tenkam 30.12.2016 mantis 8223 ++

//Формирование условного обозначения для форм элемента справочников и документов
//
//Параметры:
//Форма - УправляемаяФорма - ФормаЭлемента, в которой возникло событие, в поле должно установиться оформление (статус)
//Источник - Справочник с хранимыми значениями статусов (состояний) документа
//ПолеОтбора - Имя поля отбора
//ПолеЦвета - Наименование реквизита справочника, в котором хранится значение цвета
//ПолеШрифт - Наименование реквизита справочника, в котором хранится значение шрифта
//ПолеЦветТекста - Наименование реквизита справочника, в котором хранится значение цвета текста
Процедура СформироватьУсловноеОформлениеЭлемента(Форма, ПолеСтатуса = "СтатусЗаявки", ЗначениеПоля, ПолеЦвета = "Цвет", ПолеШрифт = "Шрифт", ПолеЦветТекста = "ЦветТекста") Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	Scan_СтатусыЗаявокНаДействие.Ссылка,
	|	Scan_СтатусыЗаявокНаДействие.Цвет,
	|	Scan_СтатусыЗаявокНаДействие.Шрифт,
	|	Scan_СтатусыЗаявокНаДействие.ЦветТекста
	|ИЗ
	|	Справочник.Scan_СтатусыЗаявокНаДействие КАК Scan_СтатусыЗаявокНаДействие
	|ГДЕ
	|	Scan_СтатусыЗаявокНаДействие.Ссылка = &ЗначениеПоля";
	Запрос.УстановитьПараметр("ЗначениеПоля", ЗначениеПоля);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		НайденныйЭлемент = Форма.Элементы.Найти(ПолеСтатуса);
		Если НайденныйЭлемент <> Неопределено Тогда
			НайденныйЭлемент.ЦветФона = Выборка.Цвет.Получить();
			Шрифт = ?(Выборка.Шрифт.Получить() = Неопределено, Новый Шрифт("Авто",8), Выборка.Шрифт.Получить());
			ЦветТекста = ?(Выборка.ЦветТекста.Получить() = Неопределено, Новый Цвет(51,51,51), Выборка.ЦветТекста.Получить());
				
			НайденныйЭлемент.Шрифт =  Шрифт;
			НайденныйЭлемент.ЦветТекста =  ЦветТекста;		
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
//rarus tenkam 30.12.2016 mantis 8223 --

//rarus sergei 12.09.2016 mantis 7160 ++

// Возвращает метаданные объекта, которому принадлежит переданная форма.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма, для которой производиться получение обекта описания метаданных.
//
Функция ПолучитьМетаданныеОбъектаФормы(Форма) Экспорт
	
	// Произведем разложение переданного имени на составляющие
	ЭлементыИмениОбъекта = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Форма.ИмяФормы, ".");
	
	// Формируем полное имя объекта метаданных
	ПолноеИмя = ЭлементыИмениОбъекта[0]+"."+ЭлементыИмениОбъекта[1];
	
	// Получаем объект описания метаданных по переданному имени
	Возврат Метаданные.НайтиПоПолномуИмени(ПолноеИмя);
	
КонецФункции // ПолучитьМетаданныеОбъектаФормы()

//rarus sergei 12.09.2016 mantis 7160 --

//rarus sergei 28.06.2016 mantis 7160 ++
// Функция возвращает расширенное представление объекта по переданному имени метаданных.
//
Функция ПредставлениеОбъект(Объект) Экспорт
	
	// Получим метаданные переданного объекта
	Если ТипЗнч(Объект)=Тип("УправляемаяФорма") Тогда
		ОбъектМетаданных = ПолучитьМетаданныеОбъектаФормы(Объект);
	ИначеЕсли ТипЗнч(Объект)=Тип("ОбъектМетаданных") Тогда
		ОбъектМетаданных = Объект;
	Иначе
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(Объект));
	КонецЕсли;
	
	// Некоторые свойства представления могут не существовать для объектов данного типа
	Представления = Новый Структура("РасширенноеПредставлениеОбъекта,ПредставлениеОбъекта");
	ЗаполнитьЗначенияСвойств(Представления, ОбъектМетаданных);
	
	// Проверим какое из свойств представления заполнено
	Если НЕ ПустаяСтрока(Представления.РасширенноеПредставлениеОбъекта) Тогда
		Возврат Представления.РасширенноеПредставлениеОбъекта;
		
	ИначеЕсли НЕ ПустаяСтрока(Представления.ПредставлениеОбъекта) Тогда
		Возврат Представления.ПредставлениеОбъекта;
		
	Иначе
		Возврат ОбъектМетаданных.Представление();
	КонецЕсли;
	
КонецФункции // ПредставлениеОбъект()
//rarus sergei 28.06.2016 mantis 7160 --



//rarus sergei 31.10.2016 mantis 7163 ++


// Универсальная функция используется для обращения к серверу, выполнения не нем произвольного запроса и возврата результата работы
//
Функция ВыполнитьПроизвольныйЗапрос(ТекстЗапроса, ИмяПоля=Неопределено, ПараметрыЗапроса=Неопределено, ПерваяСтрока=ЛОЖЬ) Экспорт
	
	// Создаем объект запроса
	Запрос = Новый Запрос(ТекстЗапроса);
	
	// Производим установку параметров
	Если НЕ ПараметрыЗапроса=Неопределено Тогда
		Для каждого Параметр Из ПараметрыЗапроса Цикл
			Запрос.УстановитьПараметр(Параметр.Ключ, Параметр.Значение);
		КонецЦикла;
	КонецЕсли;
	
	// Выполняем запрос
	ТаблицаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
	
	// Получаем интересующую строку таблицы результата запроса
	Если ПерваяСтрока Тогда
		Если ТаблицаРезультатаЗапроса.Количество() = 0 Тогда
			Возврат Неопределено;
		Иначе
			СтрокаТаблицыЗначений = ТаблицаРезультатаЗапроса.Получить(0);
		КонецЕсли;
	КонецЕсли;
	
	// Возвращаем результат работы запроса
	Если ИмяПоля=Неопределено Тогда
		
		// Создаем массив строк результата запроса
		МассивРезультатаЗапроса = Новый Массив();
		
		// Формируем список реквизитов строки
		ИменаКолонок = "";
		Для каждого КолонкаТаблицыЗначений Из ТаблицаРезультатаЗапроса.Колонки Цикл
			ИменаКолонок = ИменаКолонок + "," + КолонкаТаблицыЗначений.Имя;
		КонецЦикла;
		ИменаКолонок = Сред(ИменаКолонок,2);
		
		// Обработаем в зависимости от режима
		Если ПерваяСтрока Тогда
			
			// Создаем и заполняем объект для хранения данных строки
			РеквизитыСтроки = Новый Структура(ИменаКолонок);
			ЗаполнитьЗначенияСвойств(РеквизитыСтроки, СтрокаТаблицыЗначений);
			
			// Возвращаем данные строки
			Возврат РеквизитыСтроки;
			
		Иначе
			
			// Заполняем массив данными из таблицы значений
			Для каждого СтрокаТаблицыЗначений Из ТаблицаРезультатаЗапроса Цикл
				
				// Создаем и заполняем объект для хранения данных строки
				РеквизитыСтроки = Новый Структура(ИменаКолонок);
				ЗаполнитьЗначенияСвойств(РеквизитыСтроки, СтрокаТаблицыЗначений);
				
				// Помещаем данные строки в массив
				МассивРезультатаЗапроса.Добавить(РеквизитыСтроки);
				
			КонецЦикла;
			
			// Возвращаем массив строк результата запроса
			Возврат МассивРезультатаЗапроса;
			
		КонецЕсли;
		
	Иначе
		
		// Обработаем в зависимости от режима
		Если ПерваяСтрока Тогда
			Возврат СтрокаТаблицыЗначений[ИмяПоля];
		Иначе
			Возврат ТаблицаРезультатаЗапроса.ВыгрузитьКолонку(ИмяПоля);
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции // ВыполнитьПроизвольныйЗапрос()

// Функция возвращает расширенное представление списка для переданного объекта.
//
Функция ПредставлениеСпискаОбъектов(Объект) Экспорт
	
	// Получим метаданные переданного объекта
	Если ТипЗнч(Объект)=Тип("УправляемаяФорма") Тогда
		ОбъектМетаданных = ПолучитьМетаданныеОбъектаФормы(Объект);
	ИначеЕсли ТипЗнч(Объект)=Тип("ОбъектМетаданных") Тогда
		ОбъектМетаданных = Объект;
	Иначе
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(Объект));
	КонецЕсли;
	
	// Некоторые свойства представления могут не существовать для объектов данного типа
	Представления = Новый Структура("РасширенноеПредставлениеСписка,ПредставлениеСписка");
	ЗаполнитьЗначенияСвойств(Представления, ОбъектМетаданных);
	
	// Проверим какое из свойств представления заполнено
	Если НЕ ПустаяСтрока(Представления.РасширенноеПредставлениеСписка) Тогда
		Возврат Представления.РасширенноеПредставлениеСписка;
		
	ИначеЕсли НЕ ПустаяСтрока(Представления.ПредставлениеСписка) Тогда
		Возврат Представления.ПредставлениеСписка;
		
	Иначе
		Возврат ОбъектМетаданных.Представление();
	КонецЕсли;
	
КонецФункции // ПредставлениеСпискаОбъектов()

// Производит добавление в форму реквизитов в соответсвии с переданной коллекцией.
//
// Параметры:
//  Форма - УправляемаяФорма  - Форма, в которую производиться добавление реквизитов.
//
Процедура ДобавитьРеквизитыФормы(Форма, Реквизиты) Экспорт
	
	// Проверяем целесообразность дальнейших операций
	Если Реквизиты.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	// Производим создание дополнительных реквизитов формы
	ПереченьНовыхРеквизитов = Новый Массив();
	Для каждого Реквизит Из Реквизиты Цикл
		ТипыРеквизита = Новый Массив();
		ТипыРеквизита.Добавить(ТипЗнч(Реквизит.Значение));
		ПереченьНовыхРеквизитов.Добавить(Новый РеквизитФормы(Реквизит.Ключ, Новый ОписаниеТипов(ТипыРеквизита)));
	КонецЦикла;
	Форма.ИзменитьРеквизиты(ПереченьНовыхРеквизитов);
	
	// Производим заполнение новых реквизит данными
	ЗаполнитьЗначенияСвойств(Форма, Реквизиты);
	
КонецПроцедуры // ДобавитьРеквизитыФормы()

// Процедура устанавливает признак запрета открытия формы документа из обработки ввода на основании.
//
Процедура ЗапретитьОткрытиеФормыОбъекта(ЭтотОбъект, ТексСообщения) Экспорт
	
	ВывестиСообщениеПол(ТексСообщения, ЭтотОбъект, "!ОтменитьОткрытие",, Истина);
	
КонецПроцедуры // ЗапретитьОткрытиеФормыОбъекта)

// Процедура проверки сообщений пользователю и определения соотояния отказа
//
Функция ПроверитьВозможностьОткрытияФормыОбъекта(Форма, Отказ=ЛОЖЬ) Экспорт
	
	СообщенияПользователю = ПолучитьСообщенияПользователю();
	
	Для Каждого Сообщение Из СообщенияПользователю Цикл
		Если Сообщение.Поле="!ОтменитьОткрытие" Тогда
			Отказ = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат (НЕ Отказ);
	
КонецФункции // ПроверитьВозможностьОткрытияФормыОбъекта()

// Используеся в механизме взаимодействий. Формирует текст запроса по контактам предмета взаимодействия.
//
// Параметры:
//  Ссылка                - Ссылка  - Содержит ссылку на передаваемый объект метаданных.
//  ТекстВременнаяТаблица - Строка  - Строка в которой может находиться часть текста запроса, которая отвечает за
//                                    помещение результата запроса во временную таблицу.
//  Объединить            - Булево  - Признак который указывает на режим формирования запроса. В случае, если данный
//                                    параметр имеет значение Истина, то формируемый в функции запрос являются частью
//                                    другого запроса и должен начинаться с конструкции ОБЪЕДИНИТЬ.
//  ТолькоОсновныеКонтакты - Булево - Признак который указывает на необходимость выводв только основных контактов.
//  ПоляОсновные           - Строка - Список основных полей поска контактов.
//  ПоляДополнительные     - Строка - Список дополнительных полей поска контактов.
//
// Возвращаемое значение:
//  Строка - Возращаемая сторка содержащая в себе текст запроса по контактам предмета взаимодействий.
//
Функция ПолучитьТекстЗапросаПоКонтактам(Ссылка, ТекстВременнаяТаблица = "", Объединить = ЛОЖЬ,ТолькоОсновныеКонтакты = ИСТИНА, ПоляОсновные = "", ПоляДополнительные = "") Экспорт
	
	// Получим имя таблицы
	ИмяТаблицы = Ссылка.Метаданные().ПолноеИмя();
	
	// Сформируем список необходимых полей
	Если НЕ ТолькоОсновныеКонтакты И ЗначениеЗаполнено(ПоляДополнительные) Тогда
		ПоляОсновные = ПоляОсновные +"," + ПоляДополнительные;
	КонецЕсли;
		
	СписокПолей = Новый Структура(ПоляОсновные);
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяТаблицы);
	
	Если НЕ ТолькоОсновныеКонтакты Тогда
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизит(ОбъектМетаданных,"Автор") Тогда
			СписокПолей.Вставить("Автор");
		КонецЕсли;
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизит(ОбъектМетаданных,"Менеджер") Тогда
			СписокПолей.Вставить("Менеджер");
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизит(ОбъектМетаданных,"Контрагент") Тогда
		СписокПолей.Вставить("Контрагент");
	КонецЕсли;
	
	// Сформируем текст запроса
	ТекстЗапроса = "";
	ТекстПроРазрешенные = ?(Объединить,""," РАЗРЕШЕННЫЕ");
	ТекстОбъединить = "";
	ШаблонУсловияНаСсылки = Scan_Взаимодействия.ПолучитьШаблонУсловияНаСсылкиКонтактовДляЗапроса();
	МассивОписанияТиповКонтактов = Scan_ВзаимодействияКлиентСервер.ПолучитьМассивОписанияВозможныхКонтактов();
	ШаблонУсловияПустойСсылки =  "НЕ Таблица.%ИмяПоля% = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)";
	
	Для каждого ЭлементМассиваОписания Из МассивОписанияТиповКонтактов Цикл
		Если ЭлементМассиваОписания.Имя = "Пользователи" Тогда
			Продолжить;
		Иначе
			ШаблонУсловияПустойСсылки = ШаблонУсловияПустойСсылки + "
			|И НЕ Таблица.%ИмяПоля% = ЗНАЧЕНИЕ(Справочник." + ЭлементМассиваОписания.Имя + ".ПустаяСсылка)";
		КонецЕсли;
	КонецЦикла;

	Для Каждого Поле Из СписокПолей Цикл
		ИмяПоля = Поле.Ключ;
		УсловиеНаСсылки = СтрЗаменить(ШаблонУсловияНаСсылки, "%ИмяПоля%", ИмяПоля);
		УсловиеПустойСсылки = СтрЗаменить(ШаблонУсловияПустойСсылки, "%ИмяПоля%", ИмяПоля);
		ТекстЗапроса = ТекстЗапроса + (ТекстОбъединить +  
		"ВЫБРАТЬ" + ТекстПроРазрешенные + " РАЗЛИЧНЫЕ
		|	Таблица." + ИмяПоля + " КАК Контакт
		|" + ТекстВременнаяТаблица + "ИЗ
		|" + ИмяТаблицы + " КАК Таблица
		|	ГДЕ
		|     Таблица.Ссылка = &Предмет
		|     И " + УсловиеПустойСсылки);
		ТекстПроРазрешенные = "";
		ТекстВременнаяТаблица = "";
		ТекстОбъединить = "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|";
		
	КонецЦикла;
	
	Если Объединить Тогда
		ТекстЗапроса = "
		| ОБЪЕДИНИТЬ
		|" + ТекстЗапроса;
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции // ПолучитьТекстЗапросаПоКонтактам()

// Используеся в механизме взаимодействий. Формирует список контактов предмета взаимодействия.
//
// Параметры:
//  Ссылка - Ссылка - Содержит ссылку на передаваемый объект метаданных.
//
// Возвращаемое значение:
//  Массив - Возращаемый массив содержащий в себе перечень контактов предмета взаимодействий.
//
Функция ПолучитьКонтактыВзаимодействий(Ссылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ссылка);
	Запрос = Новый Запрос;
	Попытка
		Запрос.Текст = МенеджерОбъекта.ПолучитьТекстЗапросаПоКонтактам(Ссылка);
	Исключение
		Запрос.Текст = Scan_УправлениеДиалогомСервер.ПолучитьТекстЗапросаПоКонтактам(Ссылка);
	КонецПопытки;
	Запрос.УстановитьПараметр("Предмет",Ссылка);
	
	НачатьТранзакцию();
	Попытка
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			Результат = Неопределено;
		Иначе
			Результат = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Контакт");
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции // ПолучитьКонтактыВзаимодействий()

//Функция возвращает индекс картинки для переданного объекта метаданных
Функция ПолучитьИндексКартинкиВидаОбъектаМетаданных(ОбъектМетаданных) Экспорт
	Индекс = 0;
	Если ОбщегоНазначения.ЭтоСправочник(ОбъектМетаданных) Тогда
		Индекс = 4;
	ИначеЕсли ОбщегоНазначения.ЭтоДокумент(ОбъектМетаданных) Тогда
		Индекс = 5;
	ИначеЕсли ОбщегоНазначения.ЭтоПеречисление(ОбъектМетаданных) Тогда
		Индекс = 7;
	ИначеЕсли ОбщегоНазначения.ЭтоПланОбмена(ОбъектМетаданных) Тогда
		Индекс = 10;
	ИначеЕсли ОбщегоНазначения.ЭтоПланВидовХарактеристик(ОбъектМетаданных) Тогда
		Индекс = 11;
	ИначеЕсли ОбщегоНазначения.ЭтоБизнесПроцесс(ОбъектМетаданных) Тогда
		Индекс = 18;
	ИначеЕсли ОбщегоНазначения.ЭтоЗадача(ОбъектМетаданных) Тогда
		Индекс = 19;
	ИначеЕсли ОбщегоНазначения.ЭтоПланСчетов(ОбъектМетаданных) Тогда
		Индекс = 12;
	ИначеЕсли ОбщегоНазначения.ЭтоПланВидовРасчета(ОбъектМетаданных) Тогда
		Индекс = 13;
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрСведений(ОбъектМетаданных) Тогда
		Индекс = 14;
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрНакопления(ОбъектМетаданных) Тогда
		Индекс = 15;
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрБухгалтерии(ОбъектМетаданных) Тогда
		Индекс = 16;
	ИначеЕсли ОбщегоНазначения.ЭтоРегистрРасчета(ОбъектМетаданных) Тогда
		Индекс = 17;
	ИначеЕсли ОбщегоНазначения.ЭтоКонстанта(ОбъектМетаданных) Тогда
		Индекс = 3;
	ИначеЕсли ОбщегоНазначения.ЭтоЖурналДокументов(ОбъектМетаданных) Тогда
		Индекс = 6;
	КонецЕсли;
	
	Возврат Индекс;
КонецФункции

// Добавляет перечень объектов в ПараметрыДействия для оповещения динамических списков после окончания действия.
//
// Параметры:
//  ОбъектОповещения  - Произвольный - Объект, который будут обновлены в динамических списках (ссылки или типы).
//  ПараметрыДействия - Структура    - Набор параметров, в который будут записаны параметры оповещения.
//
Процедура ДобавитьОповещениеДинамическихСписков(ОбъектОповещения, ПараметрыДействия) Экспорт
	
	// Проверяем тип параметров действия.
	Если НЕ ТипЗнч(ПараметрыДействия) = Тип("Структура") Тогда
		ПараметрыДействия = Новый Структура;
	КонецЕсли;
	
	// Проверяем наличие необходимого свойства в структуре.
	Если НЕ ПараметрыДействия.Свойство("ОповещениеДинамическихСписков") Тогда
		ПараметрыДействия.Вставить("ОповещениеДинамическихСписков", Новый Структура("Использование, СсылкаИлиТип", Истина, Новый Массив));
	КонецЕсли;
	
	// Взводим флаг необходимости оповещения.
	ПараметрыДействия.ОповещениеДинамическихСписков.Использование = Истина;
	
	// Проверяем тип свойства с перечнем объектов в структуре.
	Если НЕ ТипЗнч(ПараметрыДействия.ОповещениеДинамическихСписков.СсылкаИлиТип)=Тип("Массив") Тогда
		
		// Запоминаем старое значение.
		ПредыдущееЗначениеСсылкаИлиТип = ПараметрыДействия.ОповещениеДинамическихСписков.СсылкаИлиТип;
		
		// Приводим тип свойства с перечнем объектов к массиву.
		ПараметрыДействия.ОповещениеДинамическихСписков.СсылкаИлиТип = Новый Массив;
		
		// Если было передано одиночное значение, добавляем его в массив объектов.
		Если ЗначениеЗаполнено(ПредыдущееЗначениеСсылкаИлиТип) Тогда
			ПараметрыДействия.ОповещениеДинамическихСписков.СсылкаИлиТип.Добавить(ПредыдущееЗначениеСсылкаИлиТип);
		КонецЕсли;
		
	КонецЕсли;
	
	// Добавляем в массив объекты для их оповещения
	ПараметрыДействия.ОповещениеДинамическихСписков.СсылкаИлиТип.Добавить(ОбъектОповещения);
	
КонецПроцедуры // ДобавитьОповещениеДинамическихСписков()

// Добавляет свойство в ПараметрыДействия для оповещения открытых форм после окончания действия.
//
// Параметры:
//  ИмяСобытия  -  Строка - Имя события. Может быть использовано для идентификации сообщений принимающими их формами.
//  Параметр    -  Произвольный - Параметр сообщения. Могут быть переданы любые необходимые данные.
//  Источник    -  Произвольный - Источник события. Например, в качестве источника может быть указана другая форма.
//  ПараметрыДействия  - Структура - Набор параметров, в который будут записаны параметры оповещения.
//
Процедура ДобавитьОповещениеФорм(ИмяСобытия, Параметр=Неопределено, Источник=Неопределено, ПараметрыДействия=Неопределено) Экспорт
	
	// Проверяем тип параметров действия.
	Если НЕ ТипЗнч(ПараметрыДействия) = Тип("Структура") Тогда
		ПараметрыДействия = Новый Структура;
	КонецЕсли;
	
	// Проверяем наличие необходимого свойства в структуре.
	Если НЕ ПараметрыДействия.Свойство("ОповещениеФорм") Тогда
		ПараметрыДействия.Вставить("ОповещениеФорм", Новый Массив);
		
	ИначеЕсли ТипЗнч(ПараметрыДействия.ОповещениеФорм)=Тип("Структура") Тогда
		
		// Преобразовываем структуру в массив структур.
		ОповещениеФорм = ПараметрыДействия.ОповещениеФорм;
		
		ПараметрыДействия.ОповещениеФорм = Новый Массив;
		ПараметрыДействия.ОповещениеФорм.Добавить(ОповещениеФорм);
		
	КонецЕсли;
	
	// Добавляем новое оповещение в массив структур.
	НовоеОповещениеФорм = Новый Структура("Использование,ИмяСобытия,Параметр,Источник", Истина, ИмяСобытия,Параметр,Источник);
	ПараметрыДействия.ОповещениеФорм.Добавить(НовоеОповещениеФорм);
	
КонецПроцедуры // ДобавитьОповещениеФорм()

// Проверяет наличие у объекта дополнительной формы редактирования и возвращает ее полное имя
//
Функция ПолучитьИмяФормаОбъектаПоСсылке(СсылкаНаОбъект) Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(СсылкаНаОбъект));
	
	Если ОбъектМетаданных=Неопределено Тогда
		Возврат Неопределено;
		
	ИначеЕсли (Метаданные.Справочники.Содержит(ОбъектМетаданных) ИЛИ Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектМетаданных)) И СсылкаНаОбъект.ЭтоГруппа Тогда
		Возврат ОбъектМетаданных.ПолноеИмя() + ".ФормаГруппы";
		
	Иначе
		Возврат ОбъектМетаданных.ПолноеИмя() + ".ФормаОбъекта";
	КонецЕсли;
	
КонецФункции // ПолучитьИмяФормаОбъектаПоСсылке()

// Проверяет наличие у объекта дополнительной формы редактирования и возвращает ее полное имя
//
Функция ПолучитьИмяДополнительнойФормыОбъекта(Объект) Экспорт
	
	// Получаем объект метаданных переданной ссылки
	Если ТипЗнч(Объект) = Тип("Строка") Тогда
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(Объект);
	Иначе
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(Объект));
	КонецЕсли;
	
	Если ОбъектМетаданных.ОсновнаяФормаОбъекта <> Неопределено Тогда
		// Найдем "дополнительную" среди подчиненных форм объекта
		ДополнительнаяФорма = ОбъектМетаданных.Формы.Найти(ОбъектМетаданных.ОсновнаяФормаОбъекта.Имя + "Дополнительная")
	Иначе
		ДополнительнаяФорма = Неопределено;
	КонецЕсли;
		
	// Возвращаем полное имя формы, по которому можно будет произвести ее открытие
	Возврат ?(ДополнительнаяФорма = Неопределено, "", ДополнительнаяФорма.ПолноеИмя());
	
КонецФункции // ПолучитьИмяДополнительнойФормыОбъекта()

Функция ОбновитьЗначенияРеквизитовОбъектаПоСсылке(СсылкаНаОбъект, ДанныеОбъекта, РежимПроведения, РежимЗагрузки) Экспорт
	
	// Получим объект базы данных и произведем обновление его данных
	Объект = СсылкаНаОбъект.ПолучитьОбъект();
	ЗаполнитьЗначенияСвойств(Объект, ДанныеОбъекта);
	
	// Установим режим упрощенной записи объекта
	Если РежимЗагрузки Тогда
		Объект.ОбменДанными.Загрузка = ИСТИНА;
	КонецЕсли;
	
	// Производим запись объекта
	Попытка
		Объект.Записать();
	Исключение
		Информация = ИнформацияОбОшибке();
	КонецПопытки;
	
КонецФункции // ОбновитьЗначенияРеквизитовОбъектаПоСсылке()

// В данной функции при необходимости формируется массив строковых представлений предметов взаимодействий
// Используется, если в конфигурации определен хотя бы один предмет взаимодействий.
//
// Возвращаемое значение:
//   Булево   - массив строковых представлений возможных предметов взаимодействий.
//
Функция ПолучитьМассивТиповПредметов() Экспорт
	
	МассивТиповПредметов = Новый Массив;
	Для каждого Тип ИЗ Метаданные.ОпределяемыеТипы.ВзаимодействияПредмет.Тип.Типы() Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		МассивТиповПредметов.Добавить("ДокументСсылка."+ ОбъектМетаданных.Имя+"");
	КонецЦикла;
	
	Возврат МассивТиповПредметов;
	
КонецФункции // ПолучитьМассивТиповПредметов()

// Дополняет описания возможных типов контактов.
// Используется, если в конфигурации определен хотя бы один тип контактов взаимодействий,
// помимо справочника Пользователи.
//
// Возвращаемые :
//   Массив  - массив структур, в котором описываются возможные типы контактов.
//              Каждая структура содержит описание одного типа контактов.   
//              Описание полей структуры см. в комментарии к функции
//              ДобавитьЭлементМассиваОписанияВозможныхТиповКонтактов общего модуля
//              ВзаимодействияКлиентСервер.
//
Процедура ДополнитьМассивОписанияВозможныхКонтактов(МассивВозможныеКонтакты) Экспорт
	
	Для каждого Тип ИЗ Метаданные.ОпределяемыеТипы.ВзаимодействияКонтакт.Тип.Типы() Цикл
		Если Тип = Тип("СправочникСсылка.СтроковыеКонтактыВзаимодействий") Тогда
			Продолжить;
		Иначе
			ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
			ЕстьВладелец = ОбъектМетаданных.Владельцы.Количество()>0;
			Scan_ВзаимодействияКлиентСервер.ДобавитьЭлементМассиваОписанияВозможныхТиповКонтактов(МассивВозможныеКонтакты,Тип,Истина,""+ ОбъектМетаданных.Имя +"",""+ПредставлениеСпискаОбъектов(ОбъектМетаданных)+"",ОбъектМетаданных.Иерархический,ЕстьВладелец,"",Истина,"");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ДополнитьМассивОписанияВозможныхКонтактов()

// Обработчик события возникающего возникающего на сервере при окончании перетаскивания в поле-приемнике данных.
//
// Параметры:
//  ПараметрыДействия - Структура - Значение, которое было указано при создании объекта описания оповещения.
//
Процедура СписокПеретаскиваниНаСервере(ПараметрыДействия) Экспорт
	
	Попытка
		Если ТипЗнч(ПараметрыДействия.Элемент)=Тип("Массив") И ПараметрыДействия.Элемент.Количество() > 1 Тогда
			
			Для Каждого Строка ИЗ ПараметрыДействия.Элемент Цикл
				Элемент = Строка.ПолучитьОбъект();
				Элемент.Родитель = ПараметрыДействия.Приемник;
				Элемент.Записать();
			КонецЦикла;
			
		ИначеЕсли ТипЗнч(ПараметрыДействия.Элемент)=Тип("Массив") И ПараметрыДействия.Элемент.Количество() = 1 Тогда
			
			Элемент = ПараметрыДействия.Элемент[0].ПолучитьОбъект();
			Элемент.Родитель = ПараметрыДействия.Приемник;
			Элемент.Записать();
			
		ИначеЕсли ТипЗнч(ПараметрыДействия.Элемент) = Тип("СправочникСсылка.Карточки") Тогда
			
			Справочники.Карточки.ЗаполнитьВидКарточки(ПараметрыДействия.Элемент, ПараметрыДействия.Приемник);
			
		Иначе
			
			Элемент = ПараметрыДействия.Элемент.ПолучитьОбъект();
			Элемент.Родитель = ПараметрыДействия.Приемник;
			Элемент.Записать();
			
		КонецЕсли;
		
	Исключение
		
		ТекстОшибки=ИнформацияОбОшибке();
		Если ТекстОшибки.Причина.Описание="Зацикливание уровней!" ИЛИ ТекстОшибки.Причина.Описание="Нарушение прав доступа!" Тогда
			ВывестиСообщениеПол(ТекстОшибки.Причина.Описание);
		Иначе
			ВызватьИсключение;
		КонецЕсли;
		
	КонецПопытки;
	
КонецПроцедуры // СписокПеретаскиваниНаСервере()

// Выполняет проверку возможности проведения документа
//
Функция ПроведениеРазрешено(Знач Ссылка) Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка));
	
	Возврат (ОбъектМетаданных.Проведение=Метаданные.СвойстваОбъектов.Проведение.Разрешить);
	
КонецФункции // ПроведениеРазрешено()

// Выполняет проведение документа
//
Функция ПровестиДокумент(Знач Ссылка) Экспорт
	
	// Очень узкий функционал, возможно расширение и переименование
	
	Объект = Ссылка.ПолучитьОбъект();
	
	Попытка
		Объект.Записать(РежимЗаписиДокумента.Проведение);
		Возврат ИСТИНА;
	Исключение
		ПричинаОшибки(Объект);
		Возврат ЛОЖЬ;
	КонецПопытки;
	
КонецФункции // ПровестиДокумент()


// Используется только для упрощения процесса отладки, не предполагается обработка события внутри процедуры.
//
Процедура ПричинаОшибки(Знач Параметр1=Неопределено, Знач Параметр2=Неопределено, Знач Параметр3=Неопределено, Знач Параметр4=Неопределено, Знач Параметр5=Неопределено, Знач Параметр6=Неопределено, Знач Параметр7=Неопределено, Знач Параметр8=Неопределено, Знач Параметр9=Неопределено) Экспорт
	
	Информация = ИнформацияОбОшибке();
	
	#Если Сервер Тогда
		Сообщения = ПолучитьСообщенияПользователю(ЛОЖЬ);
	#КонецЕсли
	
	ТочкаОстанова = ИСТИНА;
	
КонецПроцедуры // ПричинаОшибки()


// Выполняет свертку таблицы по заданному реквизиту
//
Функция СвернутьТаблицуЗначенийПоРеквизиту(ТаблицаРеквизитыДокументов, ИмяРеквизита) Экспорт
	
	Таблица = ТаблицаРеквизитыДокументов.Скопировать();
	Таблица.Свернуть(ИмяРеквизита);
	Возврат Таблица;
	
КонецФункции // СвернутьТаблицуЗначенийПоРеквизиту()

// Возвращает модуль числа
//
// Параметры:
//  Х – Число - Исходное число
// Возвращаемое значение:
//  Число – модуль исходного числа
//
Функция ПолучитьМодульЧисла(Икс) Экспорт
	
	Возврат ?(Икс >= 0, Икс, -Икс);
	
КонецФункции // ПолучитьМодульЧисла()

// Возвращает тип истинного объекта по данным формы
//
Функция ПолучитьТипОбъектаПоДаннымФормы(Объект) Экспорт
	
	Возврат ИзXMLТипа(СтрЗаменить(XMLТипЗнч(Объект.Ссылка).ИмяТипа, "Ref.", "Object."), "");
	
КонецФункции // ПолучитьТипОбъектаПоДаннымФормы()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ОБЩЕГО НАЗНАЧЕНИЯ


//rarus sergei 31.10.2016 mantis 7163 --