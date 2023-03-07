
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОПОЛНИТЕЛЬНЫХ МЕТОДОВ ОБЪЕКТА

// Возвращает структуру обязательных / уникальных реквизитов элемента
// Если ДляЭлемента = Истина, возвращаемая структура содержит реквизиты для проверки элемента
// Если ДляГруппы = Истина, аналогично для группы
// Возвращаемая структура содержит строковые идентификаторы реквизитов или вложенные структуры для табличных частей
// Для реквизита значение структуры содержит число 1-Обязательный, 3-Уникальный
Функция ПолучитьОбязательныеРеквизиты(ДляЭлемента = Истина, ДляГруппы = Ложь) Экспорт
	ОбязательныеРеквизиты = Новый Структура();
	ОбязательныеРеквизиты.Вставить("Код", 1);
	ОбязательныеРеквизиты.Вставить("Наименование", 3);	
	Если ДляЭлемента Тогда
		ОбязательныеРеквизиты.Вставить("Назначение", 1);
	КонецЕсли;                                         	
	Возврат ОбязательныеРеквизиты;
КонецФункции

// Функция проверяет, допустимо ли изменение объекта
// Возвращает Истина, если изменения возможны, ложь иначе
// Если изменения доступны частично, возвращает ложь и структуру блокируемых на изменение реквизитов,
Функция ДоступностьИзменения(БлокироватьРеквизиты = Неопределено) Экспорт
	// Для этой ПВХ доступны только признак Право/Настройка и Значение по умолчанию
	БлокироватьРеквизиты = Новый Структура();
	БлокироватьРеквизиты.Вставить("Код", 1);
	БлокироватьРеквизиты.Вставить("Наименование", 1);
	БлокироватьРеквизиты.Вставить("Назначение", 1);
	Возврат Ложь;
КонецФункции


// Проверяет корректность заполнения объекта.
// Возвращает Истина если все заполнено корректно и Ложь иначе.
// В случае некорректного заполнения формирует строку описанием возникших ошибок "Ошибки"
// На вход может быть передана структура ДопРеквизиты с дополнительными реквизитами для проверки
// может управляться булевыми флагами выполняемых проверок Заполнение, Уникальность
// (могут быть и другие необязательные)
// Обычно выполняется универсальным обработчиком, но могут быть добавлены доп. проверки
Функция ПроверитьКорректность(Ошибки="", ДопРеквизиты=Неопределено, Заполнение=Истина, Уникальность=Истина) Экспорт
	Возврат Scan_ПраваИНастройки.Scan_ПроверитьКорректность(ЭтотОбъект, Ошибки, ДопРеквизиты, Заполнение, Уникальность);
КонецФункции

// Заполняет ПВХ ПраваИНастройки значениями по умолчанию
// из макета "НастройкиПоУмолчанию"
// Уровень настройки также берется из этого макета, поэтому там все
// элементы должны быть прописаны. Причем если тип значения является
// каким-либо перечислением также необходимо указать значение по
// умолчанию (указанием идентификатора конкретного значения)
// !!! Для элементов-групп ПВХ в первой колонке макета имя не указывать!
// Процедура не использует окружение этого объекта (и его модуля) и может
// быть перенесена в любое место конфигурации
Процедура ИнициализироватьПраваИНастройки() Экспорт
	
	ЧислоОшибок = 0; // счетчик ошибок при загрузке прав и настроек
	ВсеПеречисления = Перечисления.ТипВсеСсылки();	// Описание типов для проверки перечислений
	ВсеСправочники  = Справочники.ТипВсеСсылки();   // Описание типов для проверки значений-справочников
	
	// Получим макет настроек по умолчанию
	ИмяМакета = "НастройкиПоУмолчанию";
	Макет = ПланыВидовХарактеристик.Scan_ПраваИНастройки.ПолучитьМакет(Метаданные.ПланыВидовХарактеристик.Scan_ПраваИНастройки.Макеты[ИмяМакета]);
	Если Макет = Неопределено Тогда
		Сообщение = "Не обнаружен макет """ + ИмяМакета + """ с правами и настройками пользователя по умолчанию.
		|Права не могут быть загружены. Обратитесь к администратору базы данных.";
		Сообщить(Сообщение, СтатусСообщения.ОченьВажное); 
		Возврат;
	КонецЕсли;
	
	// По всем строкам макета
	Для НомерСтроки = 1 По Макет.ВысотаТаблицы Цикл
		
		// Считаем из макета Имя, Наименование, Код, ФлагЭтоНастройка, Назначение и значение по умолчанию
		// флаги НастройкаКомпании, НастройкаОрганизации, НастройкаПодразделения, НастройкаПользователя
		ИмяЭлемПВХ 				   = СокрЛП(Макет.Область(НомерСтроки, 1).Текст);
		СтрНаименование			   = СокрЛП(Макет.Область(НомерСтроки, 2).Текст);
		СтрКод       			   = СокрЛП(Макет.Область(НомерСтроки, 3).Текст);
		СтрНазначение 			   = СокрЛП(Макет.Область(НомерСтроки, 4).Текст);
		СтрЭтоНастройка			   = СокрЛП(Макет.Область(НомерСтроки, 5).Текст);
		СтрПоУмолчанию 			   = СокрЛП(Макет.Область(НомерСтроки ,6).Текст);
		//СтрНастройкаКомпании 	   = СокрЛП(Макет.Область(НомерСтроки ,7).Текст);
		СтрНастройкаОрганизации    = СокрЛП(Макет.Область(НомерСтроки ,9).Текст);
		СтрНастройкаПодразделения  = СокрЛП(Макет.Область(НомерСтроки ,10).Текст);
		СтрНастройкаПользователя   = СокрЛП(Макет.Область(НомерСтроки ,11).Текст);
		
		#Если Клиент Тогда
			Состояние ("Настройка прав: " + Наименование);
		#КонецЕсли
		
		Если ПустаяСтрока(ИмяЭлемПВХ) Тогда
			// ДЛЯ ИЗМЕНЕНИЯ пока платформа не позволяет обратиться к предопределенной группе по имени
			// поэтому в макете для групп имя не заполняем и при загрузке такие строки с пустым именем пропускам
			Продолжить;
		КонецЕсли;
		
		// попытаемся найти и получить ссылку на элемент ПВХ
		СсылкаПВХправ = Scan_ПраваИНастройки.Scan_ПолучитьСсылкуПВХПравИНастроек(ИмяЭлемПВХ);
		// проверим что нашли
		Если Scan_ОбщегоНазначения.Scan_ЗначениеНеЗаполнено(СсылкаПВХправ) Тогда 
			ЧислоОшибок = ЧислоОшибок + 1;
			//rarus FominskiyAS 08.07.2019  mantis 14191 +++
			//Сообщить("Ошибка при загрузке прав: в строке " + НомерСтроки + " макета <" + ИмяМакета + 
			//	"> указан элемент отсутствующий в ПВХ ""Права и настройки"""+ " (" + ИмяЭлемПВХ + ")", 
			//	СтатусСообщения.Важное);
			Если ТекущийЯзык()="en" тогда
				Сообщить("Action failed", СтатусСообщения.Важное);
			иначе
				Сообщить("Ошибка при загрузке прав: в строке " + НомерСтроки + " макета <" + ИмяМакета + 
				"> указан элемент отсутствующий в ПВХ ""Права и настройки"""+ " (" + ИмяЭлемПВХ + ")", 
				СтатусСообщения.Важное);	
			КонецЕсли;
			//rarus FominskiyAS 08.07.2019  mantis 14191 ---  
			Продолжить; 
		ИначеЕсли СсылкаПВХправ.ЭтоГруппа Тогда
			Продолжить; // группы только для удобства отображения, хотя пока они все равно игнорируются
		КонецЕсли;
		
		// Проведем необходимые преобразования типов полученных значений
		// Получим признак настройки
		СтрЭтоНастройка 		   = Булево(СтрЭтоНастройка);
		//СтрНастройкаКомпании 	   = Булево(СтрНастройкаКомпании);
		СтрНастройкаОрганизации    = Булево(СтрНастройкаОрганизации);
		СтрНастройкаПодразделения  = Булево(СтрНастройкаПодразделения);
		СтрНастройкаПользователя   = Булево(СтрНастройкаПользователя);
		
		// Определим назначение
		Попытка		
			СтрНазначение = Перечисления.Scan_НазначениеПравИНастроек[СтрНазначение];
		Исключение	
			СтрНазначение = Перечисления.Scan_НазначениеПравИНастроек.Пользователь;
			СтрНастройкаПользователя = Истина;
		КонецПопытки;
		// Определим значение по умолчанию
		ОписаниеТипов =	СсылкаПВХправ.ТипЗначения;	// получим описание доступных типов для текущего права/настройки
		ТипЗнач = ОписаниеТипов.Типы().Получить(0);	// получим первый (и единственный) попавшийся из типов доступных для элемента
		// Сначала постараемся преобразовать к нужному типу, а особые типы (перечисления/справочники) обработаем ниже
		ЗнчПоУмолчанию = ОписаниеТипов.ПривестиЗначение(СтрПоУмолчанию);
		// если тип принадлежит к классу перечислений то...
		Если ВсеПеречисления.СодержитТип(ТипЗнач) Тогда
			//то попробуем получить конкретный элемент перечисления
			Перечисление = Новый (ТипЗнач);
			ИмяПеречисления = Перечисление.Метаданные().Имя;
			Попытка	
				Если ПустаяСтрока(СтрПоУмолчанию) Тогда
					ЗнчПоУмолчанию = Неопределено;
				Иначе
					ЗнчПоУмолчанию = Перечисления[ИмяПеречисления][СтрПоУмолчанию];
				КонецЕсли; 
			Исключение	// заполнили в макете некорректно, установим пустышку и поругаемся
				ЧислоОшибок = ЧислоОшибок + 1;
								
				//rarus FominskiyAS 08.07.2019  mantis 14191 +++
				//Сообщить("Ошибка при загрузке права <" + СсылкаПВХправ + "> в строке " + НомерСтроки + " макета <" + 
				//ИмяМакета + "> некорректное значение по умолчанию <" + СтрПоУмолчанию + ">", СтатусСообщения.Важное);
				Если ТекущийЯзык()="en" тогда
					Сообщить("Action failed", СтатусСообщения.Важное);
				иначе
					Сообщить("Ошибка при загрузке права <" + СсылкаПВХправ + "> в строке " + НомерСтроки + " макета <" + 
					ИмяМакета + "> некорректное значение по умолчанию <" + СтрПоУмолчанию + ">", СтатусСообщения.Важное);	
				КонецЕсли;
				//rarus FominskiyAS 08.07.2019  mantis 14191 --- 
				 				
				ЗнчПоУмолчанию = СсылкаПВХправ.ЗначениеПоУмолчанию;
			КонецПопытки;
			// если тип принадлежит к справочникам
		ИначеЕсли ВсеСправочники.СодержитТип(ТипЗнач) Тогда
			//то попробуем найти и получить значение справочника-ссылки
			ЗнчПоУмолчанию = СокрЛП(СтрПоУмолчанию);
			Если СтрДлина(ЗнчПоУмолчанию) > 0 Тогда
				СПР = Новый(ТипЗнач);
				СпрМетаданные  = СПР.Метаданные();
				ИмяСправочника = СпрМетаданные.Имя;
				Попытка
					СпрМенеджер = Справочники[ИмяСправочника];
				Исключение
					СпрМенеджер = Неопределено;
				КонецПопытки; 
				// 
				Если СпрМенеджер = Неопределено Тогда
					СпрЭлемент = Неопределено
				Иначе
					Попытка // поиск в предопределенных элементах
						СпрЭлемент = СпрМенеджер[ЗнчПоУмолчанию];
					Исключение
						СпрЭлемент = Неопределено;
					КонецПопытки;
					
					Если СпрЭлемент = Неопределено ИЛИ СпрЭлемент.Пустая() Тогда
						Попытка // попробуем найти по именованию
							СпрЭлемент = СпрМенеджер.НайтиПоНаименованию(ЗнчПоУмолчанию, Истина);
						Исключение
							СпрЭлемент = Неопределено;
						КонецПопытки;
					КонецЕсли;
					Если (СпрЭлемент = Неопределено ИЛИ СпрЭлемент.Пустая()) И (СпрМетаданные.ДлинаКода > 0) Тогда
						Попытка // последняя попытка поиска (по коду)
							Если Найти(ЗнчПоУмолчанию, "/") > 0 Тогда // полный код
								СпрЭлемент = СпрМенеджер.НайтиПоКоду(ЗнчПоУмолчанию, Истина);
							Иначе
								// проверим на тип кода
								ТипКода = Тип(СПР.Метаданные().ТипКода);
								Если ТипКода = Тип("Строка") Тогда
									// если строковый то нужно "подогнать" его длину
									Если СтрДлина(ЗнчПоУмолчанию) > СпрМетаданные.ДлинаКода Тогда
										ЗнчПоУмолчанию = Прав(ЗнчПоУмолчанию, СпрМетаданные.ДлинаКода);
									Иначе
										Пока СтрДлина(ЗнчПоУмолчанию) < СпрМетаданные.ДлинаКода Цикл
											ЗнчПоУмолчанию = "0" + ЗнчПоУмолчанию;	
										КонецЦикла;
									КонецЕсли;
								Иначе // а если тип не строка то преобразуем 
									ЗнчПоУмолчанию=ТипКода.ПривестиЗначение(ЗнчПоУмолчанию);
								КонецЕсли;
								// теперь еще раз попробуем найти элемент
								СпрЭлемент = СпрМенеджер.НайтиПоКоду(ЗнчПоУмолчанию, Ложь);
							КонецЕсли;
						Исключение
							СпрЭлемент = Неопределено;
						КонецПопытки;
					КонецЕсли;			
				КонецЕсли;
				// проверим получилось ли найти элемент по умолчанию
				Если СпрЭлемент=Неопределено ИЛИ СпрЭлемент.Пустая() Тогда
										
					//rarus FominskiyAS 08.07.2019  mantis 14191 +++
					//Сообщить("Ошибка при загрузке права <" + СсылкаПВХправ + "> в строке " + НомерСтроки + " макета <" + 
					//ИмяМакета + "> некорректное значение по умолчанию <" + СтрПоУмолчанию+">", СтатусСообщения.Важное);
					Если ТекущийЯзык()="en" тогда
						Сообщить("Action failed", СтатусСообщения.Важное);
					иначе
						Сообщить("Ошибка при загрузке права <" + СсылкаПВХправ + "> в строке " + НомерСтроки + " макета <" + 
						ИмяМакета + "> некорректное значение по умолчанию <" + СтрПоУмолчанию+">", СтатусСообщения.Важное);
					КонецЕсли;
					//rarus FominskiyAS 08.07.2019  mantis 14191 --- 
					
					ЗнчПоУмолчанию = СсылкаПВХправ.ЗначениеПоУмолчанию;
				Иначе
					ЗнчПоУмолчанию = СпрЭлемент.Ссылка;
				КонецЕсли;
			Иначе
				ЗнчПоУмолчанию = СсылкаПВХправ.ЗначениеПоУмолчанию;
			КонецЕсли;
		КонецЕсли;
		
		// Проверим все ли реквизиты в ПВХ установлены как и в макете		
		Если (СсылкаПВХправ.Назначение <> СтрНазначение) 
			ИЛИ (СсылкаПВХправ.ЭтоНастройка <> СтрЭтоНастройка) 
			ИЛИ (СсылкаПВХправ.ЗначениеПоУмолчанию <> ЗнчПоУмолчанию)
			ИЛИ (СсылкаПВХправ.Наименование <> СтрНаименование) 
			ИЛИ (СокрЛП(СсылкаПВХправ.Код) <> СтрКод)
			//ИЛИ (СсылкаПВХправ.НастройкаКомпании <> СтрНастройкаКомпании)
			ИЛИ (СсылкаПВХправ.НастройкаОрганизации <> СтрНастройкаОрганизации)
			ИЛИ (СсылкаПВХправ.НастройкаПодразделения <> СтрНастройкаПодразделения)
			ИЛИ (СсылкаПВХправ.НастройкаПользователя <> СтрНастройкаПользователя) Тогда
			// Переустановим значения реквизитов в ПВХ согласно значениям в макете
			Сообщение = "";
			ОбъектПВХправ = СсылкаПВХправ.ПолучитьОбъект(); 
			
			Если НЕ ПустаяСтрока(СтрКод) Тогда	
				ОбъектПВХправ.Код =	СтрКод;	
			КонецЕсли;
			ОбъектПВХправ.Наименование 	         = СтрНаименование;
			ОбъектПВХправ.Назначение 	         = СтрНазначение;
			ОбъектПВХправ.ЭтоНастройка 	         = СтрЭтоНастройка;
			ОбъектПВХправ.ЗначениеПоУмолчанию    = ЗнчПоУмолчанию;
			//ОбъектПВХправ.НастройкаКомпании      = СтрНастройкаКомпании;
			ОбъектПВХправ.НастройкаОрганизации   = СтрНастройкаОрганизации;
			ОбъектПВХправ.НастройкаПодразделения = СтрНастройкаПодразделения;
			ОбъектПВХправ.НастройкаПользователя  = СтрНастройкаПользователя;
			
			// попытаемся сохранить изменения реквизитов элемента ПВХ				
			Попытка
				// при обновлении конфигурации возможна ситуация дублирования наименования с предопределенным элементом
				// постараемся ее отработать путем поиска и переименования устаревшего элемента
				СтарыйЭлемент = ПланыВидовХарактеристик.Scan_ПраваИНастройки.НайтиПоНаименованию(СтрНаименование, Истина);
				Если (НЕ СтарыйЭлемент.Пустая()) И (СтарыйЭлемент.Ссылка <> ОбъектПВХправ.Ссылка) Тогда
					СтарыйОбъект = СтарыйЭлемент.ПолучитьОбъект();
					СтарыйОбъект.Наименование = "УСТАРЕЛ " + СтарыйОбъект.Наименование;
					СтарыйОбъект.Записать();
					//rarus FominskiyAS 08.07.2019  mantis 14191 +++
					//Сообщить("Необходима проверка настроек права <" + СтрНаименование + ">", СтатусСообщения.Важное);
					Сообщить(НСтр("ru = 'Необходима проверка настроек права <'; en = 'Please check authorization rights <'") + СтрНаименование + ">", СтатусСообщения.Важное);
					//rarus FominskiyAS 08.07.2019  mantis 14191 ---  
				КонецЕсли;
				// теперь попробуем записать 
				ОбъектПВХправ.Записать();
				//rarus FominskiyAS 08.07.2019  mantis 14191 +++
				//Сообщить("Обновлено право <" + СсылкаПВХправ + ">", СтатусСообщения.Информация);
				Сообщить(НСтр("ru = 'Обновлено право <'; en = 'right UPDATED <'") + СсылкаПВХправ + ">", СтатусСообщения.Информация);
				//rarus FominskiyAS 08.07.2019  mantis 14191 ---  
			Исключение
				//rarus FominskiyAS 08.07.2019  mantis 14191 +++
				//Сообщить("Право <" + СсылкаПВХправ + "> для строки " + НомерСтроки + " макета <" + ИмяМакета + 
				//"> не обновлено.
				//|Ошибка: " + ОписаниеОшибки(), СтатусСообщения.Внимание); 
				Сообщить(НСтр("ru = 'Право <'; en = 'The right <'") + СсылкаПВХправ + НСтр("ru = '> для строки '; en = '> to the layout line '") + НомерСтроки + НСтр("ru = ' макета <'; en = '<'") + ИмяМакета + 
				НСтр("ru = '> не обновлено.'; en = '> not updated.'")+"
				|"+НСтр("ru = 'Ошибка:'; en = 'Error:'") + ОписаниеОшибки(), СтатусСообщения.Внимание); 
				//rarus FominskiyAS 08.07.2019  mantis 14191 ---  
			КонецПопытки;
		КонецЕсли;
		
	КонецЦикла; // по строкам макета
КонецПроцедуры


// Процедура проверяет существование правил доступа для каждого вида объекта справочников и документов.
// В случае, если значение по умолчанию не найдено, создает новое.
// В случае, если справочник отсутствует (удалили), то помечает на удаление элемент ПВХ, а записи
//	регистра прав доступа удаляет.
Процедура ПроверитьПраваДоступа() Экспорт
	
	// Права доступа проверяются только в центральной ИБ
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если Клиент Тогда
		Состояние("Проверка правил настройки доступа ...");
	#КонецЕсли
	
	Менеджер = ПланыВидовХарактеристик.Scan_ПраваИНастройки;
	
	ГруппаРодительСправочники = Менеджер.ПраваДоступаСправочников.Ссылка;
	Выборка = Менеджер.Выбрать(ГруппаРодительСправочники);
	СправочникиЗаполнены = Выборка.Следующий();
	ПрефиксКода = Лев(ГруппаРодительСправочники.Код, 2);
	
	СтараяГруппа = ГруппаРодительСправочники;
	Запрос = Новый Запрос();
	Запрос.Текст = 	"ВЫБРАТЬ 
	|	ПраваИНастройки.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовХарактеристик.Scan_ПраваИНастройки КАК ПраваИНастройки
	|ГДЕ 
	|	ПраваИНастройки.ЭтоГруппа = &Истина И
	|   ПраваИНастройки.Родитель = &Родитель И
	|   ПраваИНастройки.Предопределенный = &Ложь И
	|   ПраваИНастройки.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Истина",       Истина);
	Запрос.УстановитьПараметр("Ложь",         Ложь);
	Запрос.УстановитьПараметр("Родитель",     Менеджер.Справочники.Ссылка);
	Запрос.УстановитьПараметр("Наименование", "ПРАВА ДОСТУПА СПРАВОЧНИКОВ");
	
	РезЗапроса = Запрос.Выполнить();
	Если НЕ РезЗапроса.Пустой() Тогда
		Выборка = РезЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			СтараяГруппа = Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ СправочникиЗаполнены Тогда
		Выборка = Менеджер.Выбрать(СтараяГруппа);
		СправочникиЗаполнены = Выборка.Следующий();
	КонецЕсли;
	ИскатьСтарые = ?(ГруппаРодительСправочники = СтараяГруппа, Ложь, Истина);
	
	Для Каждого ТекСтрока Из Метаданные.Справочники Цикл
		Если ТекСтрока = Неопределено Тогда Продолжить; КонецЕсли;
		
		Имя = ТекСтрока.Имя;
		Поз = Найти(Имя, "уат");
		Если НЕ Поз = 1  Тогда Продолжить; КонецЕсли;
		
		ВидыПравДляСправочников = Перечисления.Scan_ВидыПравДляСправочников.Редактирование; 
		
		МенеджерЗаписи = ПланыВидовХарактеристик.Scan_ПраваИНастройки;
		
		ТекСсылка = МенеджерЗаписи.НайтиПоНаименованию("Право доступа " + Имя, Истина, ГруппаРодительСправочники);
		Если ТекСсылка.Пустая() и ИскатьСтарые Тогда
			ТекСсылка = МенеджерЗаписи.НайтиПоНаименованию("Право доступа " + Имя, Истина, СтараяГруппа);
		КонецЕсли;
		
		ЕстьИзменения = Ложь;
		Если ТекСсылка.Пустая() Тогда
			МассивТипов = Новый Массив(1);
			МассивТипов[0] = ТипЗнч(ВидыПравДляСправочников);
			
			ТекОбъект = МенеджерЗаписи.СоздатьЭлемент();
			ТекОбъект.Наименование = "Право доступа " + Имя;
			ТекОбъект.ТипЗначения  = Новый ОписаниеТипов(МассивТипов);
			ТекОбъект.Назначение   = Перечисления.Scan_НазначениеПравИНастроек.Пользователь;
			ТекОбъект.НастройкаПользователя = Истина;
			ТекОбъект.ЭтоНастройка = Ложь;
			
			ЕстьИзменения = Истина;
			
		Иначе
			ТекОбъект = ТекСсылка.ПолучитьОбъект();
			Если НЕ ТекОбъект.НастройкаПользователя Тогда
				ТекОбъект.НастройкаПользователя = Истина;						
				ЕстьИзменения = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ТекОбъект.Родитель <> ГруппаРодительСправочники 
			ИЛИ ТекОбъект.ЗначениеПоУмолчанию <> ВидыПравДляСправочников Тогда
			ТекОбъект.Родитель            = ГруппаРодительСправочники;
			ТекОбъект.ЗначениеПоУмолчанию = ВидыПравДляСправочников;
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		Если Лев(ТекОбъект.Код, 2) <> ПрефиксКода Тогда
			ТекОбъект.УстановитьНовыйКод(ПрефиксКода);
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		Если ЕстьИзменения Тогда
			ТекОбъект.Записать();
		КонецЕсли;
		
		Если ТекОбъект.ЭтоНовый() и СправочникиЗаполнены Тогда
			//rarus FominskiyAS 08.07.2019  mantis 14191 +++
			//Сообщить("ВНИМАНИЕ! Обнаружен новый объект, включенный в состав плана обмена!
			//|Необходимо отредактировать настройку доступа 
			//|для вида объектов: """ + ТекСтрока.Представление() + """!", СтатусСообщения.Внимание);
			Сообщить(НСтр("ru = 'ВНИМАНИЕ! Обнаружен новый объект, включенный в состав плана обмена!'; en = 'ATTENTION! New object found'")+"
			|Необходимо отредактировать настройку доступа 
			|для вида объектов: """ + ТекСтрока.Представление() + """!", СтатусСообщения.Внимание);
			//rarus FominskiyAS 08.07.2019  mantis 14191 ---  
		КонецЕсли;
	КонецЦикла;	
	
	// Удалим старую группу, созданную программно
	Если ИскатьСтарые и НЕ СтараяГруппа.Пустая() Тогда
		Попытка
			СтараяГруппа.ПолучитьОбъект().УстановитьПометкуУдаления(Истина, Истина);	
			//rarus FominskiyAS 08.07.2019  mantis 14191 +++
			//Сообщить("ВНИМАНИЕ! Установлена пометка удаления не используемой группы: """ + СтараяГруппа + """
			//|плана видов характеристик ""Права и настройки""!
			//|Произведите удаление помеченных объектов!", СтатусСообщения.Внимание);
			Сообщить(НСтр("ru = 'ВНИМАНИЕ! Установлена пометка удаления не используемой группы: ""'; en = 'ATTENTION! Unused group is marked as to be deleted:'") + СтараяГруппа + """
			|плана видов характеристик ""Права и настройки""!
			|Произведите удаление помеченных объектов!", СтатусСообщения.Внимание);
			//rarus FominskiyAS 08.07.2019  mantis 14191 ---  		
		Исключение КонецПопытки;
	КонецЕсли;
	
	// Теперь заполним префиксацию по умолчанию для документов
	ГруппаРодительДокументы = Менеджер.ПраваДоступаДокументов.Ссылка;
	Выборка = Менеджер.Выбрать(ГруппаРодительДокументы);
	ДокументыЗаполнены = Выборка.Следующий();
	ПрефиксКода = Лев(ГруппаРодительДокументы.Код, 2);
	
	СтараяГруппа = ГруппаРодительДокументы;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 	"ВЫБРАТЬ 
	|	ПраваИНастройки.Ссылка КАК Ссылка
	|ИЗ 
	|	ПланВидовХарактеристик.Scan_ПраваИНастройки КАК ПраваИНастройки
	|ГДЕ 
	|	ПраваИНастройки.ЭтоГруппа = &Истина И
	|   ПраваИНастройки.Родитель = &Родитель И
	|   ПраваИНастройки.Предопределенный = &Ложь И
	|   ПраваИНастройки.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Истина",       Истина);
	Запрос.УстановитьПараметр("Ложь",         Ложь);
	Запрос.УстановитьПараметр("Родитель",     Менеджер.Документы.Ссылка);
	Запрос.УстановитьПараметр("Наименование", "ПРАВА ДОСТУПА ДОКУМЕНТОВ");
	
	РезЗапроса = Запрос.Выполнить();
	Если НЕ РезЗапроса.Пустой() Тогда
		Выборка = РезЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			СтараяГруппа = Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ДокументыЗаполнены Тогда
		Выборка = Менеджер.Выбрать(СтараяГруппа);
		ДокументыЗаполнены = Выборка.Следующий();
	КонецЕсли;
	ИскатьСтарые = ?(ГруппаРодительДокументы = СтараяГруппа, Ложь, Истина);
	
	Для Каждого ТекСтрока Из Метаданные.Документы Цикл
		Если ТекСтрока = Неопределено Тогда Продолжить; КонецЕсли;
		
		Имя = ТекСтрока.Имя;
		Поз = Найти(Имя, "уат");
		Если НЕ Поз = 1  Тогда Продолжить; КонецЕсли;
		ВидыПравДляДокументов = Перечисления.Scan_ВидыПравДляДокументов.РедактированиеВсе;
		
		МенеджерЗаписи = ПланыВидовХарактеристик.Scan_ПраваИНастройки;
		
		ТекСсылка = МенеджерЗаписи.НайтиПоНаименованию("Право доступа " + Имя, Истина, ГруппаРодительДокументы);
		Если ТекСсылка.Пустая() и ИскатьСтарые Тогда
			ТекСсылка = МенеджерЗаписи.НайтиПоНаименованию("Право доступа " + Имя, Истина, СтараяГруппа);
		КонецЕсли;
		
		ЕстьИзменения = Ложь;
		Если ТекСсылка.Пустая() Тогда
			МассивТипов = Новый Массив(1);
			МассивТипов[0] = ТипЗнч(ВидыПравДляДокументов);
			
			ТекОбъект = МенеджерЗаписи.СоздатьЭлемент();
			ТекОбъект.Наименование = "Право доступа " + Имя;
			ТекОбъект.ТипЗначения  = Новый ОписаниеТипов(МассивТипов);
			ТекОбъект.Назначение   = Перечисления.Scan_НазначениеПравИНастроек.Пользователь;
			ТекОбъект.НастройкаПользователя = Истина;			
			ТекОбъект.ЭтоНастройка = Ложь;
			
			ЕстьИзменения = Истина;
			
		Иначе
			ТекОбъект = ТекСсылка.ПолучитьОбъект();
			Если НЕ ТекОбъект.НастройкаПользователя Тогда
				ТекОбъект.НастройкаПользователя = Истина;						
				ЕстьИзменения = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ТекОбъект.Родитель <> ГруппаРодительДокументы 
			ИЛИ ТекОбъект.ЗначениеПоУмолчанию <> ВидыПравДляДокументов Тогда
			ТекОбъект.Родитель            = ГруппаРодительДокументы;
			ТекОбъект.ЗначениеПоУмолчанию = ВидыПравДляДокументов;
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		Если Лев(ТекОбъект.Код, 2) <> ПрефиксКода Тогда
			ТекОбъект.УстановитьНовыйКод(ПрефиксКода);
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		Если ЕстьИзменения Тогда
			ТекОбъект.Записать();
		КонецЕсли;
		
		Если ТекОбъект.ЭтоНовый() и ДокументыЗаполнены Тогда
						
			//rarus FominskiyAS 08.07.2019  mantis 14191 +++
			//Сообщить("ВНИМАНИЕ! Обнаружен новый объект, включенный в состав плана обмена!
			//|Необходимо отредактировать настройку доступа
			//|для вида объектов: """ + ТекСтрока.Представление() + """!", СтатусСообщения.Внимание);
			Сообщить(НСтр("ru = 'ВНИМАНИЕ! Обнаружен новый объект, включенный в состав плана обмена!'; en = 'ATTENTION! New object found'")+"
			|Необходимо отредактировать настройку доступа
			|для вида объектов: """ + ТекСтрока.Представление() + """!", СтатусСообщения.Внимание);
			//rarus FominskiyAS 08.07.2019  mantis 14191 ---
			
			
		КонецЕсли;
	КонецЦикла;
	
	// Удалим старую группу, созданную программно
	Если ИскатьСтарые и НЕ СтараяГруппа.Пустая() Тогда
		Попытка
			СтараяГруппа.ПолучитьОбъект().УстановитьПометкуУдаления(Истина, Истина);	
			//rarus FominskiyAS 08.07.2019  mantis 14191 +++
			//Сообщить("ВНИМАНИЕ! Установлена пометка удаления не используемой группы: """ + СтараяГруппа + """
			//|плана видов характеристик ""Права и настройки""!
			//|Произведите удаление помеченных объектов!", СтатусСообщения.Внимание);
			Сообщить(НСтр("ru = 'ВНИМАНИЕ! Установлена пометка удаления не используемой группы: ""'; en = 'ATTENTION! Unused group is marked as to be deleted:'") + СтараяГруппа + """
			|плана видов характеристик ""Права и настройки""!
			|Произведите удаление помеченных объектов!", СтатусСообщения.Внимание);
			//rarus FominskiyAS 08.07.2019  mantis 14191 ---  		
		Исключение КонецПопытки;
	КонецЕсли;
	
	Если НЕ СправочникиЗаполнены Тогда
		//rarus FominskiyAS 08.07.2019  mantis 14191 +++
		//Сообщить("ВНИМАНИЕ! Произведено первичное заполнение правил настройки доступа справочников!", 
		//	СтатусСообщения.Внимание);
		Сообщить(НСтр("ru = 'ВНИМАНИЕ! Произведено первичное заполнение правил настройки доступа справочников!'; en = 'ATTENTION! Initial filling of access settings rules'"), 
		СтатусСообщения.Внимание);
		//rarus FominskiyAS 08.07.2019  mantis 14191 ---  	
	КонецЕсли;
	Если НЕ ДокументыЗаполнены Тогда
		Сообщить("ВНИМАНИЕ! Произведено первичное заполнение правил настройки доступа документов!", 
		СтатусСообщения.Внимание);
	КонецЕсли;
	
	// Удаление прав доступа для отсутствующих справочников и документов
	ГруппаРодительСправочники = ПланыВидовХарактеристик.Scan_ПраваИНастройки.ПраваДоступаСправочников;
	ВыборкаПВХСправ = ПланыВидовХарактеристик.Scan_ПраваИНастройки.Выбрать(ГруппаРодительСправочники);
	Пока ВыборкаПВХСправ.Следующий() Цикл
		ИмяСпр = Сред(ВыборкаПВХСправ.Наименование, СтрДлина("Право доступа ")+1);
		Если Метаданные.Справочники.Найти(ИмяСпр) = Неопределено Тогда
			Попытка
				НаборЗап = РегистрыСведений.Scan_ПраваИНастройки.СоздатьНаборЗаписей();
				НаборЗап.Отбор.ПравоНастройка.Установить(ВыборкаПВХСправ.Ссылка);
				НаборЗап.Записать();
				
				Если НЕ ВыборкаПВХСправ.ПометкаУдаления Тогда
					ВыборкаПВХСправ.ПолучитьОбъект().УстановитьПометкуУдаления(Истина, Истина);
					//rarus FominskiyAS 08.07.2019  mantis 14191 +++
					//Сообщить("Удалено право доступа несуществующего справочника <" + ИмяСпр + ">!", СтатусСообщения.Внимание);
					Если ТекущийЯзык()="en" тогда
						Сообщить("Access removed", СтатусСообщения.Внимание);
					Иначе
						Сообщить("Удалено право доступа несуществующего справочника <" + ИмяСпр + ">!", СтатусСообщения.Внимание);
					КонецЕсли;
					//rarus FominskiyAS 08.07.2019  mantis 14191 ---  
				КонецЕсли;
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	ГруппаРодительДокументы = ПланыВидовХарактеристик.Scan_ПраваИНастройки.ПраваДоступаДокументов;
	ВыборкаПВХДокум = ПланыВидовХарактеристик.Scan_ПраваИНастройки.Выбрать(ГруппаРодительДокументы);
	Пока ВыборкаПВХДокум.Следующий() Цикл
		ИмяДок = Сред(ВыборкаПВХДокум.Наименование, СтрДлина("Право доступа ")+1);
		Если Метаданные.Документы.Найти(ИмяДок) = Неопределено Тогда
			Попытка
				НаборЗап = РегистрыСведений.Scan_ПраваИНастройки.СоздатьНаборЗаписей();
				НаборЗап.Отбор.ПравоНастройка.Установить(ВыборкаПВХДокум.Ссылка);
				НаборЗап.Записать();
				
				Если НЕ ВыборкаПВХДокум.ПометкаУдаления Тогда
					ВыборкаПВХДокум.ПолучитьОбъект().УстановитьПометкуУдаления(Истина, Истина);
					//rarus FominskiyAS 08.07.2019  mantis 14191 +++
					//Сообщить("Удалено право доступа несуществующего документа <" + ИмяДок + ">!", СтатусСообщения.Внимание);
					Если ТекущийЯзык()="en" тогда
						Сообщить("Access removed", СтатусСообщения.Внимание);
					Иначе
						Сообщить("Удалено право доступа несуществующего документа <" + ИмяДок + ">!", СтатусСообщения.Внимание);
					КонецЕсли;
					//rarus FominskiyAS 08.07.2019  mantis 14191 ---  

				КонецЕсли;
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ ОБЪЕКТА

// Стандартный обработчик ПередЗаписью элемента справочника
Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		//Если ЭтотОбъект.Ссылка = ПланыВидовХарактеристик.уатПраваИНастройки.ОсновнойВрач
		//	ИЛИ ЭтотОбъект.Ссылка = ПланыВидовХарактеристик.уатПраваИНастройки.ОсновнойДиспетчер
		//	ИЛИ ЭтотОбъект.Ссылка = ПланыВидовХарактеристик.уатПраваИНастройки.ОсновнойМеханик Тогда
		//	Возврат;
		//КонецЕсли;
		
		Если ПометкаУдаления Тогда 
			Возврат;
		КонецЕсли;
		
		// Проверим ограничение по типам, т.к. поддерживается строго один тип для каждого элемента
		Если (ЭтотОбъект.ТипЗначения.Типы().Количество() <> 1) и (НЕ ЭтотОбъект.ЭтоГруппа) Тогда
			Отказ = Истина;
			//rarus FominskiyAS 08.07.2019  mantis 14191 +++
			//Сообщить("Должен быть указан единственный тип возможных значений! Запись элемента <"+СокрЛП(ЭтотОбъект)+"> отменена!");
			Если ТекущийЯзык()="en" тогда
				Сообщить("Action failed");
			иначе
				Сообщить("Должен быть указан единственный тип возможных значений! Запись элемента <"+СокрЛП(ЭтотОбъект)+"> отменена!");
			КонецЕсли;
			//rarus FominskiyAS 08.07.2019  mantis 14191 ---  
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
