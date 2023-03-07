//////////////////////////////////////////////////////////////////
////        ФУНКЦИИ РАБОТЫ ПРАВАМИ И НАСТРОЙКАМИ
//////////////////////////////////////////////////////////////////  

// Стандартная процедура проверки корректности заполнения элемента
// по заполнению обязательных реквизитов и уникальности уникальных индексированных
//
//  ЭтотОбъект -объект для проверки
//  Ошибки - ошибки в объекте,строкой
//  ДопРеквизиты - список дополнительных реквизитов для проверки
//  Заполнение - требование заполнения
//  Уникальность - требование уникальности
//
Функция Scan_ПроверитьКорректность(ЭтотОбъект, Ошибки = "", ДопРеквизиты = Неопределено, Заполнение = Истина,
		Уникальность = Истина) Экспорт
	Результат=Истина;
	//Если НЕ Scan_Право("ПроверкаЗаполненияСправочниковИДокументов", ЭтотОбъект.Права) Тогда
	//	Возврат Результат;
	//КонецЕсли; 
	
	// Определимся это элемент или группа (для плана счетов всегда элемент)
	Попытка  ЭтоГруппа = ЭтотОбъект.ЭтоГруппа;
	Исключение ЭтоГруппа = Ложь;
	КонецПопытки;
	// сначала получим список обязательных у нашего объекта....
	Реквизиты = ЭтотОбъект.ПолучитьОбязательныеРеквизиты(НЕ ЭтоГруппа, ЭтоГруппа);
	// и его метаданные
	ЭтотОбъектМетаданные = ЭтотОбъект.Метаданные();
	
	// добавим дополнительные реквизиты
	Если ДопРеквизиты <> Неопределено Тогда
		Для каждого ДопРеквизит Из ДопРеквизиты Цикл
			Реквизиты.Вставить(ДопРеквизит.Ключ, ДопРеквизит.Значение);
		КонецЦикла;
	КонецЕсли;
	
	// Проверим установим заранее владельца, чтобы ниже в циклах этим не заниматься
	ЭтоСправочник = Ложь; Владелец = НЕОПРЕДЕЛЕНО;
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ЭтотОбъект.Ссылка)) Тогда // Владелец только у справочников бывает
		ЭтоСправочник = Истина;
		Если НЕ Scan_ОбщегоНазначения.Scan_ЗначениеНеЗаполнено(ЭтотОбъект.Владелец) Тогда
			Владелец = ЭтотОбъект.Владелец;
		КонецЕсли;
	КонецЕсли;
	
	// пройдемся по списку реквизитов с проверкой
	Для каждого Реквизит Из Реквизиты Цикл
		Если ТипЗнч(Реквизит.Значение) = Тип("Структура") Тогда
			// проверяем табличную часть
			ТабличнаяЧасть = ЭтотОбъект[Реквизит.Ключ];
			СписокНайденныхДублей = Новый СписокЗначений();
			// идем по табличной части
			Для каждого СтрокаТаблицы Из ТабличнаяЧасть Цикл
				// создадим структуру отбора для проверки уникальности реквизитов
				Если Уникальность Тогда СтруктураОтбора = Новый Структура(); КонецЕсли;
				// переберем обязательные реквизиты
				Для каждого РеквизитТаблицы Из Реквизит.Значение Цикл
					Если (Заполнение) И (РеквизитТаблицы.Значение <> 2) И (РеквизитТаблицы.Значение > 0) 
							И Scan_ОбщегоНазначения.Scan_ЗначениеНеЗаполнено(СтрокаТаблицы[РеквизитТаблицы.Ключ]) Тогда
						Результат = Ложь;
						Ошибки = Ошибки + "Таблица <" + Scan_ПолучитьСинонимРеквизита(ЭтотОбъектМетаданные, , Реквизит.Ключ) + 
							"> значение колонки <" + Scan_ПолучитьСинонимРеквизита(ЭтотОбъектМетаданные, РеквизитТаблицы.Ключ, 
							Реквизит.Ключ) + "> не заполнено ! Строка номер " + СокрЛП(СтрокаТаблицы.НомерСтроки) + Символы.ПС;
						Продолжить; // Если реквизит таблицы не заполнен, проверять его уникальность нет смысла
					КонецЕсли;
					// заполним структуру отбора для проверки уникальности реквизитов
					Если Уникальность И РеквизитТаблицы.Значение > 1 Тогда
						СтруктураОтбора.Вставить(СокрЛП(РеквизитТаблицы.Ключ), СтрокаТаблицы[РеквизитТаблицы.Ключ]);
					КонецЕсли;
				КонецЦикла;
				// проверка уникальности
				Если Уникальность И СтруктураОтбора.Количество() > 0 
						И СписокНайденныхДублей.НайтиПоЗначению(СтрокаТаблицы) = Неопределено Тогда
					// поищем строки удовлетворяющие структуре отбора
					НайденныеСтроки = ТабличнаяЧасть.НайтиСтроки(СтруктураОтбора);
					// если нашли и их больше 1, то строки не уникальные
					Если НайденныеСтроки.Количество() > 1 Тогда
						// добавим строку в список найденных дублей, что бы не сообщать о ней еще раз
						Результат = Ложь;
						ДублирующиесяСтроки = ""; 
						// выведем строку сообщения...
						Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл 
							ДублирующиесяСтроки = ДублирующиесяСтроки + "," + СокрЛП(НайденнаяСтрока.НомерСтроки);
							// добавим строку в список найденных дублей, что бы не сообщать о ней еще раз
							СписокНайденныхДублей.Добавить(НайденнаяСтрока);
						КонецЦикла;
						СтрокаРеквизитов = "";
						Для каждого РеквизитТаблицы Из СтруктураОтбора Цикл
							СтрокаРеквизитов = СтрокаРеквизитов + ?(ПустаяСтрока(СтрокаРеквизитов), "", ",") + 
								РеквизитТаблицы.Ключ;
						КонецЦикла;
						Ошибки = Ошибки + "Таблица <" + Scan_ПолучитьСинонимРеквизита(ЭтотОбъектМетаданные, , Реквизит.Ключ) +
							"> значения колонки <" + Scan_ПолучитьСинонимРеквизита(ЭтотОбъектМетаданные, РеквизитТаблицы.Ключ, 
							Реквизит.Ключ) + "> не уникальны ! Строки: " + Сред(ДублирующиесяСтроки, 2) + Символы.ПС;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
		Иначе // обычный реквизит справочника / ПВХ (не табличная часть)
			// Сначала проверим заполнение (параметры структуры 1 или 3)
			Если Заполнение 
				и ((Реквизит.Значение = 1) или (Реквизит.Значение = 3) или (Реквизит.Значение = Неопределено))
				и Scan_ОбщегоНазначения.Scan_ЗначениеНеЗаполнено(ЭтотОбъект[Реквизит.Ключ]) Тогда
				Результат = Ложь;
				Ошибки = Ошибки + "Реквизит """ + Scan_ПолучитьСинонимРеквизита(ЭтотОбъектМетаданные,Реквизит.Ключ) + 
					""" не заполнен !" + Символы.ПС;
				Продолжить; // Если реквизит не заполнен, проверять его уникальность нет смысла
			КонецЕсли;
			// Теперь проверим уникальность (параметры структуры 2 или 3)
			// проверку сделаем прямым сравнением (а не >2) во избежание ошибки при не числовом типе значения.
			Если (Уникальность) и ((Реквизит.Значение = 2)ИЛИ(Реквизит.Значение = 3)) Тогда
				ИмяОбъекта = ЭтотОбъект.Метаданные().Имя;
				Если Метаданные.Справочники.Найти(ИмяОбъекта) <> Неопределено Тогда
					//имеем справочник
					Менеджер = Справочники[ЭтотОбъект.Метаданные().Имя];
				ИначеЕсли Метаданные.ПланыВидовХарактеристик.Найти(ИмяОбъекта) <> Неопределено Тогда
					//имеем ПВХ
					Менеджер = ПланыВидовХарактеристик[ЭтотОбъект.Метаданные().Имя];
				ИначеЕсли Метаданные.ПланыВидовРасчета.Найти(ИмяОбъекта) <> Неопределено Тогда
					//имеем ПВР
					Менеджер = ПланыВидовРасчета[ЭтотОбъект.Метаданные().Имя];
				Иначе
					//имеем ... ничего не имеем
				КонецЕсли;
				
				Если Реквизит.Ключ = "Наименование" Тогда
					Если ЭтоСправочник Тогда
						НайденнаяСсылка = Менеджер.НайтиПоНаименованию(ЭтотОбъект.Наименование, Истина, , Владелец);
					Иначе
						НайденнаяСсылка = Менеджер.НайтиПоНаименованию(ЭтотОбъект.Наименование, Истина);
					КонецЕсли;
				ИначеЕсли Реквизит.Ключ = "Код" Тогда
					Если ЭтоСправочник Тогда
						НайденнаяСсылка = Менеджер.НайтиПоКоду(ЭтотОбъект.Код, , , Владелец);
					Иначе
						НайденнаяСсылка = Менеджер.НайтиПоКоду(ЭтотОбъект.Код);
					КонецЕсли;
				Иначе // реквизит
					Если ЭтоСправочник Тогда
						НайденнаяСсылка = Менеджер.НайтиПоРеквизиту(Реквизит.Ключ, ЭтотОбъект[Реквизит.Ключ], , Владелец);
					Иначе
						НайденнаяСсылка = Менеджер.НайтиПоРеквизиту(Реквизит.Ключ, ЭтотОбъект[Реквизит.Ключ]);
					КонецЕсли;
				КонецЕсли;
				
				Если (НЕ Scan_ОбщегоНазначения.Scan_ЗначениеНеЗаполнено(НайденнаяСсылка)) и (НайденнаяСсылка<>ЭтотОбъект.Ссылка) Тогда
					Результат=Ложь;
					Ошибки =  Ошибки + "Реквизит """ + Scan_ПолучитьСинонимРеквизита(ЭтотОбъектМетаданные, Реквизит.Ключ) +
						""" не уникален !";
					Если Не Scan_ОбщегоНазначения.Scan_ЗначениеНеЗаполнено(Владелец) Тогда
						Ошибки = Ошибки + " (В пределах владельца: " + СокрЛП(Владелец) + ")";
					КонецЕсли;
					Ошибки = Ошибки + Символы.ПС;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Функция получает синоним реквизита в шапке или табличной части
//
// Параметры:
//  ЭтотОбъектМетаданные - объект синоним реквизита которого необходимо получить
//  ИмяРеквизита - Имя реквизита синоним которого необходимо получить
//  ИмяТабличнойЧасти - имя табличной части для реквизита которой необходимо 
//                 получить синоним
//
// Возвращаемое значение%
//  Синоним реквизита.
Функция Scan_ПолучитьСинонимРеквизита(ЭтотОбъектМетаданные, ИмяРеквизита="", ИмяТабличнойЧасти="") Экспорт
	Если ТипЗнч(ЭтотОбъектМетаданные) <> Тип("ОбъектМетаданных") Тогда
		ЭтотОбъектМетаданные = ЭтотОбъектМетаданные.Метаданные();
	КонецЕсли; 
	СинонимРеквизита = ИмяРеквизита;
	Если ПустаяСтрока(ИмяТабличнойЧасти) Тогда
		Реквизит = ЭтотОбъектМетаданные.Реквизиты.Найти(ИмяРеквизита);
	Иначе
		Если ПустаяСтрока(ИмяРеквизита) Тогда
			Реквизит = ЭтотОбъектМетаданные.ТабличныеЧасти.Найти(ИмяТабличнойЧасти);
		Иначе
			Реквизит = ЭтотОбъектМетаданные.ТабличныеЧасти[ИмяТабличнойЧасти].Реквизиты.Найти(ИмяРеквизита);
		КонецЕсли;
	КонецЕсли; 
	Если Реквизит <> Неопределено Тогда
		СинонимРеквизита=Реквизит.Синоним;
	КонецЕсли; 
	Возврат СинонимРеквизита;
КонецФункции // Scan_ПолучитьСинонимРеквизита()

// Преобразование имени права в ссылку на ПВХ 
// Так же поддерживается идентификация по коду ПВХ
// Параметры
//  Право – Строка, Число, ссылка на ПВХ ПраваИНастройки – имя или ссылка права
// Возвращаемое значение:
//   ссылка на ПВХ ПраваИНастройки или Неопределено для недопустимого имени ПВХ
Функция Scan_ПолучитьСсылкуПВХПравИНастроек(Право) Экспорт
	ТипЗначения = ТипЗнч(Право);
	
	Если ТипЗначения = Тип("ПланВидовХарактеристикСсылка.Scan_ПраваИНастройки") Тогда
		//Если право уже является ссылкой - вернем ее
		Возврат Право;
		
	ИначеЕсли ТипЗначения = Тип("Строка") Тогда
		// Если право задано в виде имени - преобразуем его в ссылку на ПВХ
		// Если такого предопределенного элемента нет. Попробуем найти добавленный по наименованию
		Попытка		Возврат ПланыВидовХарактеристик.Scan_ПраваИНастройки[СокрЛП(Право)];
		Исключение	Возврат ПланыВидовХарактеристик.Scan_ПраваИНастройки.НайтиПоНаименованию(СокрЛП(Право), Истина);
		КонецПопытки; 
		
	ИначеЕсли ТипЗначения = Тип("Число") Тогда
		// Возможно, хотя и не рекомендуется использовать поиск по коду ПВХ
		Возврат ПланыВидовХарактеристик.Scan_ПраваИНастройки.НайтиПоКоду(Право);
		
	Иначе Возврат ПланыВидовХарактеристик.Scan_ПраваИНастройки.ПустаяСсылка();
		
	КонецЕсли;
КонецФункции

// Получить значение права по имени или значению
// Параметры:
//	ЗначенияПрав - список прав (типа соответствие), в котором надо произвести  
//	  поиск значения конкретного права (в этот параметр обычно будет передаваться 
//    глобальная переменная "глПраваУАТ", в которой кэшируются права пользователя)
//	Право - строка с именем или ссылка на ПВХ ПраваИНастройки искомого права
// Возвращаемое значение:   значение запрошенного права 
Функция Scan_Право(Право, ЗначенияПрав = Неопределено) Экспорт
	
	Результат = Неопределено;
	
	Если НЕ (ЗначенияПрав = Неопределено) Тогда
		// Если это дополнительное право доступа справочников или документов
		Если (ТипЗнч(Право) = Тип("Строка")) И Найти(Право, "Значения Право доступа") > 0 Тогда
			Возврат ЗначенияПрав[Право];
		КонецЕсли;
		// кеш с правами передан, попытаемся получить нужное право из него напрямую.
		ПравоСсылка = Scan_ПолучитьСсылкуПВХПравИНастроек(Право);
		Если Scan_ОбщегоНазначения.Scan_ЗначениеНеЗаполнено(ПравоСсылка) Тогда
			// Такого права нет в системе - явная ошибка. Нужен специалист
			//rarus FominskiyAS 25.04.2019  mantis 14191 +++
			//Сообщить("Неизвестное право: " + Право, СтатусСообщения.Важное);
			Сообщить(НСтр("ru = 'Неизвестное право: '; en = 'Unknown right: '") + Право, СтатусСообщения.Важное);
			//rarus FominskiyAS 25.04.2019  mantis 14191 ---  
		Иначе
			Результат = ЗначенияПрав[ПравоСсылка];
		КонецЕсли;
	Иначе
		// Кэш прав не передан (вероятно мы на сервере), значит придется запрашивать данные из БД
		// Момент тонкий - чтобы не писать разные функции получения прав в кэш
		// и точечного получения, вызовем стандартную функцию с фильтром по праву.
		
		//rarus FominskiyAS 28.02.2019  mantis 13863 +++
		//Пользователь = ПараметрыСеанса.ТекущийПользователь;
		Пользователь = ПользователиСлужебный.АвторизованныйПользователь();
		//rarus FominskiyAS 28.02.2019  mantis 13863 ---
		
		
		
		// Получаем ссылку на ПВХ по ее имени
		ПравоСсылка = Scan_ПолучитьСсылкуПВХПравИНастроек(Право);
		Если Scan_ОбщегоНазначения.Scan_ЗначениеНеЗаполнено(ПравоСсылка) Тогда
			// Такого права нет в системе - явная ошибка. Нужен специалист
			//rarus FominskiyAS 25.04.2019  mantis 14191 +++
			//Сообщить("Неизвестное право: " + Право, СтатусСообщения.Важное);
			Сообщить(НСтр("ru = 'Неизвестное право: '; en = 'Unknown right: '") + Право, СтатусСообщения.Важное);
			//rarus FominskiyAS 25.04.2019  mantis 14191 --- 
			//Результат = Неопределено;
		Иначе
			Результат = Scan_ПолучитьПраваИНастройкиПользователя(Пользователь, ПравоСсылка);
		КонецЕсли;
	КонецЕсли;
	// 
	Возврат(Результат);
	
КонецФункции

// Получает текущие значение прав и настроек для пользователя
// из регистра ПраваИНастройки. Кроме пользователя так же может фигурировать
// подразделение, организация, компания (пустая ссылка)
// Объект - ссылка на пользователя (или другой объект) для которого собрать права
// ТолькоЭтоПраво - ссылка на элемент ПВХ, если задан то накладывается фильтр для
// получения значения только именно этого права, по умолчанию НЕОПРЕДЕЛЕНО (все права)
// Возвращаемое значение: -Соответствие (в ключе ссылка на элемент ПВХ, а в значении оно и есть)
// 						   если параметр ТолькоЭтоПраво был не задан (неопределен), 
//						  -иначе возвращается текущее значение запрошенного права
// для группы прав доступа к справочникам и документам формируются записи соответствия вида:
// Ключ: "Значения <Имя права>"
// Значение: Соответствие, где ключ - значение доступа, значение - флаг доступа
//
Функция Scan_ПолучитьПраваИНастройкиПользователя(Знач Объект = Неопределено, Знач ПравоНастройка = Неопределено, Знач ВозвращатьЗначениеПоУмолчанию = Истина) Экспорт
	ТекПользователь = Пользователи.ТекущийПользователь();

	Если Объект = Неопределено Тогда
		Объект = ТекПользователь;
	КонецЕсли;
	
	// если выполняется запрос ПИН не текуего пользователя то значения прав берем не из кэша а сразу запросом из базы
	// сделано в целях запрета доступности получения чужих прав и настроек
	Если ТипЗнч(Объект) = Тип("СправочникСсылка.Пользователи") Тогда
		СоотвВсеПИН = Scan_ПраваИНастройкиПовтИсп.ПолучитьЗначенияВсехПравНастроек(Объект);
	Иначе
		СоотвВсеПИН = Scan_ПраваИНастройкиПовтИсп.ПолучитьЗначенияВсехПравНастроек(ТекПользователь);
	КонецЕсли;
	
	// выбор всех прав и настроек
	Если ПравоНастройка = Неопределено Тогда
		РезПИН = Новый Соответствие;
		Для Каждого ТекПН Из СоотвВсеПИН Цикл
			ЗначПН = Scan_ПолучитьПраваИНастройкиПользователя(Объект, ТекПН.Ключ);
			РезПИН.Вставить(ТекПН.Ключ, ЗначПН);
		КонецЦикла;
		Возврат РезПИН;
	КонецЕсли;
	
	ЭтоНастройкиПравДоступаДокИСпр = (Найти(ПравоНастройка, "Значения Право доступа") > 0);
	
	Если ТипЗнч(ПравоНастройка) = Тип("Строка") И (НЕ ЭтоНастройкиПравДоступаДокИСпр) Тогда
		ПравоНастройка = ПланыВидовХарактеристик.Scan_ПраваИНастройки[ПравоНастройка];
	КонецЕсли;
	
	СоотвПН = СоотвВсеПИН.Получить(ПравоНастройка);
	Если СоотвПН = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Объект) = Тип("Структура") Тогда
		//добавляем блок для прав и настроек, которые могут быть "многоэтажными", то есть
		//существовать для нескольких видов объекта, например, ВидПЛ может быть указан и для пользователя,
		// и для подразделения, и для организации
		ТекПользователь = Неопределено;
		ТекПодразделение = Неопределено;
		ТекОрганизация = Неопределено;
		Объект.Свойство("Пользователь", ТекПользователь);
		Объект.Свойство("Подразделение", ТекПодразделение);
		Объект.Свойство("Организация", ТекОрганизация);
		
		// rarus agar 28.12.2022 19668 ++
		ТекОрганизация = Справочники.Организации.НайтиПоКоду("000000001");
		// rarus agar 28.12.2022 19668 --
		
		ЗначениеПН = Неопределено;
		//для пользователя
		Если ЗначениеЗаполнено(ТекПользователь) Тогда
			ЗначениеПН = СоотвПН.Получить(ТекПользователь);
		КонецЕсли;
		//для подразделения
		Если НЕ ЗначениеЗаполнено(ЗначениеПН) И ТипЗнч(ЗначениеПН) <> Тип("Булево") И ЗначениеЗаполнено(ТекПодразделение) Тогда
			ЗначениеПН = СоотвПН.Получить(ТекПодразделение);
		КонецЕсли;
		//для организации
		Если НЕ ЗначениеЗаполнено(ЗначениеПН) И ТипЗнч(ЗначениеПН) <> Тип("Булево") И ЗначениеЗаполнено(ТекОрганизация) Тогда
			ЗначениеПН = СоотвПН.Получить(ТекОрганизация);
		КонецЕсли;
		
		//значение настройки по умолчанию
		Если НЕ ЗначениеЗаполнено(ЗначениеПН) И ТипЗнч(ЗначениеПН) <> Тип("Булево") Тогда
			ЗначениеПН = СоотвПН.Получить("ЗначениеПоУмолчанию");
		КонецЕсли;
		
		Возврат ЗначениеПН;
		
	ИначеЕсли ЭтоНастройкиПравДоступаДокИСпр Тогда
		Возврат СоотвПН;
		
	Иначе
		Если ТипЗнч(Объект) = Тип("СправочникСсылка.Пользователи") Тогда
			Если ПравоНастройка.Назначение = Перечисления.Scan_НазначениеПравИНастроек.Организация Тогда
				// rarus agar 28.12.2022 19668 ++
				//ЗначениеПН = СоотвПН.Получить(Объект.Организация);
				ТекОрганизация = Справочники.Организации.НайтиПоКоду("000000001");
				Если ЗначениеЗаполнено(ТекОрганизация) Тогда
					ЗначениеПН = СоотвПН.Получить(ТекОрганизация);
				Иначе
					ЗначениеПН = СоотвПН.Получить(Объект.Организация);
				КонецЕсли;
				// rarus agar 28.12.2022 19668 --
			ИначеЕсли ПравоНастройка.Назначение = Перечисления.Scan_НазначениеПравИНастроек.Подразделение Тогда
				ЗначениеПН = СоотвПН.Получить(Объект.ПодразделениеОрганизации);
			ИначеЕсли ПравоНастройка.Назначение = Перечисления.Scan_НазначениеПравИНастроек.Пользователь Тогда
				ЗначениеПН = СоотвПН.Получить(Объект);
			КонецЕсли;
		Иначе
			ЗначениеПН = СоотвПН.Получить(Объект);
		КонецЕсли;
					
		Если НЕ ЗначениеЗаполнено(ЗначениеПН) И ТипЗнч(ЗначениеПН) <> Тип("Булево") Тогда
			ЗначениеПН = СоотвПН.Получить("ЗначениеПоУмолчанию");
		КонецЕсли;
		
		Возврат ЗначениеПН;
		
	КонецЕсли;
	
КонецФункции // Scan_ПолучитьПраваИНастройкиПользователя()

// Проверяет документы на право редактирования, чтения или доступности текущего
// вида документа, а так же на право, если оно установлено, редактирования или
// чтения объекта текущего вида документа, по автору или подразделению компании
//Параметры:
//  Объект - текущий ДокументОбъект. Обязательный для заполнения.
//  Отказ - результат работы процедуры, т.е. определяет текущую доступность данного объекта
//  ЭтаФорма - форма текущего объекта. Передается для проверки на редактирование или чтение 
//  объекта и соответственно для разрешения или запрещения редактирования формы объекта.
//  ЗначенияПрав - Кеш прав текущего пользователя. тип соответствие.
Процедура Scan_ПроверкаПраваДоступаКДокументам(Объект, Отказ, ЭтаФорма = Неопределено, 
		ЗначенияПрав = Неопределено) Экспорт
	
	//если уже отказ, то не проверяем
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Scan_Право("Право доступа " + Объект.Метаданные().Имя, ЗначенияПрав);
	
	Если Результат = Перечисления.Scan_ВидыПравДляДокументов.РедактированиеВсе Тогда
		//если редактируем, то ничего не делаем
	ИначеЕсли Результат = Перечисления.Scan_ВидыПравДляДокументов.НетДоступа Тогда
		//rarus FominskiyAS 19.04.2019  mantis 14191 +++
		//Сообщить("Нет доступа к объектам вида "  + Объект.Метаданные().Представление(), СтатусСообщения.Важное);
		Сообщить(Нстр("ru = 'Нет доступа к объектам вида '; en = 'No access to the objects '")  + Объект.Метаданные().Представление(), СтатусСообщения.Важное);
		//rarus FominskiyAS 19.04.2019 mantis 14191 ---
		Отказ = Истина;
	ИначеЕсли Результат = Перечисления.Scan_ВидыПравДляДокументов.ЧтениеВсе тогда
		// ЧТЕНИЕ
		//rarus FominskiyAS 19.04.2019  mantis 14191 +++
		//Сообщить("Нет прав на редактирование объектов вида "  + Объект.Метаданные().Представление(), СтатусСообщения.Важное);
		Сообщить(Нстр("ru = 'Нет прав на редактирование объектов вида '; en = 'No permission to edit view objects '")+ Объект.Метаданные().Представление(), СтатусСообщения.Важное);
		//rarus FominskiyAS 19.04.2019  mantis 14191 ---
		// проверка на редактирование или просмотр объекта
		Если ЭтаФорма = Неопределено Тогда
			Отказ = Истина;
		Иначе
			ЭтаФорма.ТолькоПросмотр = Истина;
		КонецЕсли;
	ИначеЕсли Результат = Перечисления.Scan_ВидыПравДляДокументов.РедактированиеПоПользователям Тогда
		//получаем значения доступа
		ТекПользователь = ПользователиКлиентСервер.ТекущийПользователь();
		Если НЕ Объект.ЭтоНовый() И ТекПользователь <> Объект.Ответственный Тогда
			Если ЗначенияПрав = Неопределено Тогда
				ЗначенияПрав = Scan_ПолучитьПраваИНастройкиПользователя(ТекПользователь);
			КонецЕсли;
			
			Результат = Неопределено;
			ЗначениеДоступа = Scan_Право("Значения Право доступа " + Объект.Метаданные().Имя, ЗначенияПрав);
			Если ЗначениеДоступа <> Неопределено Тогда
				Результат = ЗначениеДоступа[Объект.Ответственный];
			КонецЕсли;
			Если (Результат = Неопределено) ИЛИ (Не Результат) Тогда
				//rarus FominskiyAS 19.04.2019  mantis 14191 +++
				//Сообщить("Нет прав на редактирование объектов вида "  + Объект.Метаданные().Представление() + " по автору: " +
				Сообщить(Нстр("ru = 'Нет прав на редактирование объектов вида '; en = 'No permission to edit view objects '")  + Объект.Метаданные().Представление() + Нстр("ru = ' по автору: '; en = ' by Author: '") +
				//rarus FominskiyAS 19.04.2019  mantis 14191 ---
							 
				Объект.Ответственный, СтатусСообщения.Важное);
				Если ЭтаФорма = Неопределено Тогда
					Отказ = Истина;
				Иначе
					ЭтаФорма.ТолькоПросмотр = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	Иначе //можно все
		
	КонецЕсли;
КонецПроцедуры

// Проверяет справочники на право редактирования, чтения или доступности текущего
// вида справочника, а так же на право, если оно установлено, редактирования или
// чтения объекта текущего вида справочника, по ближайшему родителю, на которое
// установлено данное право  
//Параметры:
//  Объект - текущий СправочникОбъект. Обязательный для заполнения.
//  Отказ - результат работы процедуры, т.е. определяет текущую доступность данного объекта
//  ЭтаФорма - форма текущего объекта. Передается для проверки на редактирование или чтение 
//  объекта при открытии формы.
//  ЗначенияПрав - Соответствие, Кеш прав текущего пользователя.
Процедура Scan_ПроверкаПраваДоступаКСправочникам(Объект, Отказ, ЭтаФорма = Неопределено, ЗначенияПрав = Неопределено) Экспорт
	
	//если уже Отказ, то и проверять не надо
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	//если не справочник, то и делать нечего
	Если НЕ Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(Объект.Ссылка)) Тогда	
		Возврат;
	КонецЕсли;
	
	Результат = Scan_Право("Право доступа " + Объект.Метаданные().Имя, ЗначенияПрав);
	
	Если Результат = Перечисления.Scan_ВидыПравДляСправочников.Редактирование Тогда
		// РЕДАКТИРОВАНИЕ 
	ИначеЕсли Результат = Перечисления.Scan_ВидыПравДляСправочников.НетДоступа Тогда
		//rarus FominskiyAS 19.04.2019  mantis 14191 +++
		//Сообщить("Нет доступа к объектам вида "  + Объект.Метаданные().Представление(), СтатусСообщения.Важное);
		Сообщить(Нстр("ru = 'Нет доступа к объектам вида '; en = 'No access to the objects '")  + Объект.Метаданные().Представление(), СтатусСообщения.Важное);
		//rarus FominskiyAS 19.04.2019 mantis 14191 ---
		Отказ=Истина;
	ИначеЕсли Результат = Перечисления.Scan_ВидыПравДляСправочников.Чтение Тогда
		// ЧТЕНИЕ
		
		//rarus FominskiyAS 19.04.2019  mantis 14191 +++
		//Сообщить("Нет прав на редактирование объектов вида "  + Объект.Метаданные().Представление(), СтатусСообщения.Важное);
		Сообщить(Нстр("ru = 'Нет прав на редактирование объектов вида '; en = 'No permission to edit view objects '")+ Объект.Метаданные().Представление(), СтатусСообщения.Важное);
		//rarus FominskiyAS 19.04.2019  mantis 14191 ---

		// проверка на редактирование или просмотр объекта
		Если ЭтаФорма = Неопределено Тогда 
			Отказ = Истина; 
		Иначе 
			ЭтаФорма.ТолькоПросмотр = Истина; 
		КонецЕсли;
	ИначеЕсли Результат = Перечисления.Scan_ВидыПравДляСправочников.РедактированиеПоГруппам Тогда
		Если ЗначенияПрав = Неопределено Тогда
			ЗначенияПрав = Scan_ПолучитьПраваИНастройкиПользователя(ПользователиКлиентСервер.ТекущийПользователь());
		КонецЕсли;
				
		СоответствиеГруппДоступа = Scan_Право("Значения Право доступа " + Объект.Метаданные().Имя, ЗначенияПрав);
		Если СоответствиеГруппДоступа = Неопределено Тогда 
			// ЧТЕНИЕ
			
			//rarus FominskiyAS 19.04.2019  mantis 14191 +++
			//Сообщить("Нет прав на редактирование объектов вида " +
			Сообщить(Нстр("ru = 'Нет прав на редактирование объектов вида '; en = 'No permission to edit view objects '")+
			//rarus FominskiyAS 19.04.2019  mantis 14191 ---                                                              
			
			Объект.Метаданные().Представление(), СтатусСообщения.Важное);
			// проверка на редактирование или просмотр объекта
			Если ЭтаФорма = Неопределено Тогда 
				Отказ = Истина; 
			Иначе 
				ЭтаФорма.ТолькоПросмотр  =Истина; 
			КонецЕсли;
		Иначе //если не в корне, то определяем по дереву доступа
			Если (Объект.ЭтоГруппа) и (НЕ Объект.Ссылка.Пустая())  Тогда
				Родитель = Объект.Ссылка;
			Иначе
				Родитель = Объект.Родитель;
			КонецЕсли;
			//если родитель пустой, то уровня нет
			Попытка Уровень = Родитель.Уровень() Исключение Уровень = 0 КонецПопытки;
			//получаем для текущего уровня
			ЗначениеДоступа = СоответствиеГруппДоступа[Родитель];
			// Перебираем всех родителей объекта, пока не находим
			// любое значение доступности
			Для Ном=1 по Уровень Цикл
				Если ЗначениеДоступа <> Неопределено Тогда
					Прервать;
				КонецЕсли;
				Родитель = Родитель.Родитель;
				ЗначениеДоступа = СоответствиеГруппДоступа[Родитель];
			КонецЦикла;
			
			//или нашли значение доступа, или вышли из цикла, ничего не найдя
			Если (ЗначениеДоступа = Неопределено) ИЛИ (НЕ ЗначениеДоступа) Тогда
				Если Родитель.Пустая() Тогда
					стрРодитель = "корня"
				Иначе
					стрРодитель = "группы " + СокрЛП(Родитель);
				КонецЕсли;
				//rarus FominskiyAS 19.04.2019  mantis 14191 +++
				Сообщить(Нстр("ru = 'Нет прав на редактирование '; en = 'No permission to edit '") + стрРодитель + Нстр("ru = '  объектов вида '; en = ' view objects '")  + Объект.Метаданные().Представление(),
				//rarus FominskiyAS 19.04.2019  mantis 14191 ---
				СтатусСообщения.Важное);
				// проверка на редактирование или просмотр объекта
				Если ЭтаФорма = Неопределено Тогда 
					Отказ = Истина; 
				Иначе 
					ЭтаФорма.ТолькоПросмотр = Истина; 
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;	
	//если значения права нет, то можно редактировать
КонецПроцедуры

// rarus tenkam 30.11.2016 mantis 7750 ++

// Возвращает массив объектов, у которых право/настройка равно значению
// Параметры:
//  ПравоНастройка	 - Строка, ПланВидовХарактеристикСсылка.Scan_ПраваИНастройки - строка с именем или ссылка на ПВХ ПраваИНастройки искомого права
//  Значение		 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция Scan_ПолучитьМассивОбъектовПоЗначению(ПравоНастройка, Значение) Экспорт 
	ПравоНастройкаСсылка = Scan_ПолучитьСсылкуПВХПравИНастроек(ПравоНастройка);
	Если Scan_ОбщегоНазначения.Scan_ЗначениеНеЗаполнено(ПравоНастройкаСсылка) Тогда
		// Такого права нет в системе - явная ошибка. Нужен специалист
		//rarus FominskiyAS 25.04.2019  mantis 14191 +++
		//Сообщить("Неизвестное право: " + ПравоНастройка, СтатусСообщения.Важное);
		Сообщить(НСтр("ru = 'Неизвестное право: '; en = 'Unknown right: '") + ПравоНастройка, СтатусСообщения.Важное);
		//rarus FominskiyAS 25.04.2019  mantis 14191 --- 
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_ПраваИНастройки.Объект
		|ИЗ
		|	РегистрСведений.Scan_ПраваИНастройки КАК Scan_ПраваИНастройки
		|ГДЕ
		|	Scan_ПраваИНастройки.Значение = &Значение
		|	И Scan_ПраваИНастройки.ПравоНастройка = &ПравоНастройкаСсылка";
		
		Запрос.УстановитьПараметр("Значение", Значение);
		Запрос.УстановитьПараметр("ПравоНастройкаСсылка", ПравоНастройкаСсылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		МассивОбъектов = Новый Массив;
		Если НЕ РезультатЗапроса.Пустой() Тогда
			МассивОбъектов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Объект");
		КонецЕсли;
		
		Возврат МассивОбъектов;	
	КонецЕсли;
	
КонецФункции
//rarus tenkam 30.11.2016 mantis 7750 --

//rarus sergei 22.11.2016 mantis 6965 ++
Функция ПолучитьОбъектыПоПравамИНастройкам(Назначение = Неопределено, ПравоНастройка, Значение = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	Scan_ПраваИНастройки.Объект,
	             |	Scan_ПраваИНастройки.Значение
	             |ИЗ
	             |	РегистрСведений.Scan_ПраваИНастройки КАК Scan_ПраваИНастройки
	             |ГДЕ
	             |	&ЗначениеПрава
	             |	И Scan_ПраваИНастройки.ПравоНастройка = &ПравоНастройкаСсылка";
	             //|	И &УсловиеНазначения";
	Если Значение<> Неопределено Тогда
		Запрос.Текст =СтрЗаменить(Запрос.Текст,"&ЗначениеПрава","Scan_ПраваИНастройки.Значение = &ЗначениеСсылка");
		Запрос.УстановитьПараметр("ЗначениеСсылка", Значение);
	Иначе
		Запрос.Текст =СтрЗаменить(Запрос.Текст,"&ЗначениеПрава","Истина");
	КонецЕсли; 	
	ПравоНастройкаСсылка = Scan_ПолучитьСсылкуПВХПравИНастроек(ПравоНастройка);
	Если ПравоНастройкаСсылка =Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	//Если Назначение<> Неопределено Тогда
	//	Запрос.Текст =СтрЗаменить(Запрос.Текст,"&УсловиеНазначения","Scan_ПраваИНастройки.Объект = &Назначение");
	//	Запрос.УстановитьПараметр("Назначение", Назначение);
	//Иначе
	//	Запрос.Текст =СтрЗаменить(Запрос.Текст,"&УсловиеНазначения","Истина")
	//КонецЕсли; 
	
	Запрос.УстановитьПараметр("ПравоНастройкаСсылка", ПравоНастройкаСсылка);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		ТЗ = Результат.Выгрузить();
		Возврат ТЗ;
	КонецЕсли; 
КонецФункции
//rarus sergei 22.11.2016 mantis 6965 --

//rarus tenkam 06.10.2017 mantis 11198 +++
Процедура УдалитьПраваИНастройкиОбъекта(Объект, Отказ = Ложь, Ошибки = "") Экспорт
	
	НаборЗаписей = РегистрыСведений.Scan_ПраваИНастройки.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Объект.Установить(Объект);
	НаборЗаписей.Записать();

КонецПроцедуры
//rarus tenkam 06.10.2017 mantis 11198 ---

Процедура УдалитьПраво(Код) Экспорт //rarus BProg_Gladkov 04.05.2020 0015962 +-
	Ссылка = ПланыВидовХарактеристик.Scan_ПраваИНастройки.НайтиПоКоду(Код);
	Если НЕ ЗначениеЗаполнено(Ссылка) тогда
		Возврат;
	КонецЕсли;
	
	Если Ссылка.Предопределенный тогда
		ВызватьИсключение СтрШаблон("Удаление предопределенного права ""%1"" запрещено.", Ссылка);
	КонецЕсли;
	
	Объект = Ссылка.ПолучитьОбъект();
	Объект.Удалить();
	
	//Записи в регистрах будут удалены автоматически (используются ведещие измерения).
КонецПроцедуры