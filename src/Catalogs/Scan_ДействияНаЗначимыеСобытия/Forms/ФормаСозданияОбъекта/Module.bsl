// Модуль формы элемента справочника "Действия на значимые события"


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура ОбработкаРезультатаОповещенияСформироватьНаименование(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
		
		// Обработаем событие в контексте сервера
		НаименованиеНачалоВыбораНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаРезультатаОповещенияСформироватьНаименование()

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура ОбработкаРезультатаОповещенияТипОбъекта(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
		
		// Обработаем событие в контексте сервера
		ТипОбъектаПриИзмененииНаСервере();
		
	ИначеЕсли РезультатОповещения = КодВозвратаДиалога.Нет Тогда
		
		Объект.ТипОбъекта = ТипОбъектаУст;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура ОбработкаРезультатаОповещенияЗаполнение(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если ДополнительныеПараметры = "ОчиститьПравила" Тогда
		
		Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
			
			// Очистим табличную часть "Соответствия"
			Объект.Соответствия.Очистить();
			
		КонецЕсли;
		
	ИначеЕсли ДополнительныеПараметры = "ОчиститьПравилаИЗаполнить" Тогда
		
		Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
			
			// Очистим табличную часть "Соответствия"
			Объект.Соответствия.Очистить();
			ЗаполнитьРеквизитамиНаСервере();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Производит настройку параметров выбора элементов управления диалога в зависимости от значений реквизитов объекта.
//
&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	// Вызываем общий обработчик события настройки параметров выбора
	//УправлениеДиалогомСправочникаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры // НастроитьПараметрыВыбораЭлементовФормы()

// Производит настройку параметров отображения элементов управления диалога в зависимости от значений реквизитов
// объекта.
//
&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	// Вызываем общий обработчик действия
	//УправлениеДиалогомСправочникаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Объект.ТипОбъекта) Тогда
		
		Элементы.Соответствия.Доступность = Истина;
		ПолноеИмяТипаОбъекта = Объект.ТипОбъекта.ПолноеИмя;
		
		// Сначала проверяем ввод на основании.
		ОбъектИсточник = ?(ЗначениеЗаполнено(Источник),Метаданные.НайтиПоПолномуИмени(Источник.ПолноеИмя),Неопределено);
		ОбъектТекущий  = Метаданные.НайтиПоПолномуИмени(Объект.ТипОбъекта.ПолноеИмя);
		
		// Проверяем возможность проведения.
		Если ОбъектТекущий=Неопределено Тогда
			Элементы.ПровестиДокумент.Видимость = Ложь;
		Иначе
			Если Объект.ТипОбъекта.Родитель.ПолноеИмя = "Документы" Тогда
				Проведение = ОбъектТекущий.Проведение;
				Если Проведение=Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
					Элементы.ПровестиДокумент.Видимость = Истина;
				Иначе
					Элементы.ПровестиДокумент.Видимость = Ложь;
					Объект.ПровестиДокумент = Ложь;
				КонецЕсли;
			Иначе
				Элементы.ПровестиДокумент.Видимость = Ложь;
				Объект.ПровестиДокумент = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Если (ОбъектИсточник=Неопределено) ИЛИ (ОбъектТекущий=Неопределено) Тогда
			Элементы.ЗадействоватьВводНаОсновании.Доступность = Ложь;
			Элементы.ЗаполнитьРеквизитыПоУмолчанию.Доступность = Ложь;
		ИначеЕсли НЕ ОбъектТекущий=Неопределено И НЕ ОбъектИсточник=Неопределено Тогда
			Если ОбъектТекущий.ВводитсяНаОсновании.Содержит(ОбъектИсточник) Тогда
				Элементы.ЗадействоватьВводНаОсновании.Доступность = Истина;
			Иначе
				Элементы.ЗадействоватьВводНаОсновании.Доступность = Ложь;
			КонецЕсли;
			
		Иначе
			Элементы.ЗадействоватьВводНаОсновании.Доступность = Ложь;
		КонецЕсли;
		
		// Теперь проверяем возможность заполнения реквизитов по-умолчанию.
		// Это возможно только для объектов ссылочного типа.
		Если Объект.ТипОбъекта.ЗначениеПустойСсылки = Неопределено Тогда
			Элементы.ЗаполнитьРеквизитыПоУмолчанию.Доступность = Ложь;
		Иначе
			Элементы.ЗаполнитьРеквизитыПоУмолчанию.Доступность = Истина;
		КонецЕсли;
		
	Иначе
		
		Элементы.ЗадействоватьВводНаОсновании.Доступность = Ложь;
		Элементы.ЗаполнитьРеквизитыПоУмолчанию.Доступность = Ложь;
		Элементы.ПровестиДокумент.Видимость = Ложь;
		Элементы.Соответствия.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры // УправлениеДиалогомНаСервере()

// Производит настройку блокировки элементов формы.
//
&НаСервере
Процедура БлокироватьЭлементыФормы()
	
	// Составим список элементов для блокировки
	СписокРеквизитов = Новый СписокЗначений();
	
	// Заблокируем элементы формы
	//УправлениеДиалогомСервер.БлокироватьЭлементыФормы(ЭтотОбъект,СписокРеквизитов);
	
КонецПроцедуры // БлокироватьЭлементыФормы()

// Обработчик события возникающего при нажатии программно добавленной кнопки в контексте сервера.
//
// Параметры:
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
&НаСервере
Процедура ОбработкаКомандыФормыНаСервере(ИмяКоманды, ПараметрыДействия = Неопределено)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаСервер.ОбработкаКомандыФормы(ЭтотОбъект, ИмяКоманды, ПараметрыДействия) Тогда
	//	Возврат;
	//КонецЕсли;
	
	// Обновим параметры выбора элементов формы
	НастроитьПараметрыВыбораЭлементовФормы();
	
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ОбработкаКомандыФормыНаСервере()

// Подключаемый обработчик, вызывающий общую процедуру для обработки команды панели действий.
// 
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура Подключаемый_ОбработкаКомандыФормы(Команда) Экспорт
	
	// Определим структуру параметров обработки текущего события
	ПараметрыДействия = Новый Структура;
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаКлиент.ОбработкаКомандыФормы(ЭтотОбъект, Команда, Объект, ЭтотОбъект.Окно, ПараметрыДействия) Тогда
	//	Возврат;
	//КонецЕсли;
	
	// Обработаем событие в контексте сервера
	ОбработкаКомандыФормыНаСервере(Команда.Имя, ПараметрыДействия);
	
	// Вызываем обработчик результата выполнения
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры // Подключаемый_ОбработкаКомандыФормы()

// Обработчик события возникающего при оповещении данной формы о прекращении работы подчиненной в контексте сервера.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаСервере
Процедура ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры=Неопределено)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаСервер.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
	//	Возврат;
	//КонецЕсли;
	
	// Обновим параметры выбора элементов формы
	НастроитьПараметрыВыбораЭлементовФормы();
	
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ОбработкаРезультатаОповещенияНаСервере()

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаОповещения(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	// Вызываем общий обработчик события в контексте клиента
	//Если НЕ УправлениеДиалогомСправочникаКлиент.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
	//	Возврат;
	//КонецЕсли;
	
	// Обработаем событие в контексте сервера
	ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры);
	
	// Вызываем обработчик результата выполнения
	ОбработкаРезультатаВыполненияДействия(РезультатОповещения);
	
КонецПроцедуры // Подключаемый_ОбработкаРезультатаОповещения()

// Отображает результат выполнения действия.
//
// Параметры:
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
&НаКлиенте
Процедура ОбработкаРезультатаВыполненияДействия(ПараметрыДействия)
	
	// Вызываем общий обработчик результата выполнения действия
	//УправлениеДиалогомСправочникаКлиент.ОбработкаРезультатаВыполненияДействия(ЭтотОбъект, ПараметрыДействия);
	
КонецПроцедуры // ОбработкаРезультатаВыполненияДействия()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Обработчик события возникающего на клиенте при выполнении команды "Очистить".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура Очистить(Команда)
	
	Если Объект.Соответствия.Количество()>0 Тогда
		
		// Формируем описание обработчика перехвата закрытия формы
		ОбработчикВопроса = Новый ОписаниеОповещения("ОбработкаРезультатаОповещенияЗаполнение", ЭтотОбъект, "ОчиститьПравила");
		
		// Формируем текст вопроса
		ТекстВопроса = НСтр("ru = 'Очистить табличную часть ""Правила заполнения""?'");
		
		// Получаем подтверждение операции от пользователя
		ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры //Очистить()

// Обработчик события возникающего на клиенте при выполнении команды "ЗаполнитьРеквизитами".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаСервере
Процедура ЗаполнитьРеквизитамиНаСервере()
	
	ДеревоРеквизитов = Scan_ЗначимыеСобытия.ПолучитьДеревоМетаданныхОбъекта(Объект.ТипОбъекта,,Ложь);
	Корень = ДеревоРеквизитов.Строки[0];
	Для каждого Строка ИЗ Корень.Строки Цикл
		
			НовоеПравило = Объект.Соответствия.Добавить();
			НовоеПравило.ПредставлениеРеквизита = Строка.Поле;
			НовоеПравило.РеквизитОбъекта = Строка.ИмяМетаданного;
			НовоеПравило.ВидПравила = ПредопределенноеЗначение("Перечисление.Scan_ВидыПравил.ТочноеЗначение");
			
			// Сохраняем тип выбранного значения
			ОписаниеТипа = Новый ОписаниеТипов(Строка.ТипМетаданного); 
			НовоеПравило.Правило = ОписаниеТипа.ПривестиЗначение(); 
			
		КонецЦикла;
	
	// Проверим возможно в качестве источника передана константа
	Если Корень.ВидМетаданного = "Константа" Тогда
		
		НовоеПравило = Объект.Соответствия.Добавить();
		НовоеПравило.ПредставлениеРеквизита = Корень.Поле;
		НовоеПравило.РеквизитОбъекта = Корень.ИмяМетаданного;
		НовоеПравило.ВидПравила = ПредопределенноеЗначение("Перечисление.Scan_ВидыПравил.ТочноеЗначение");
		
		// Сохраняем тип выбранного значения
		ОписаниеТипа = Новый ОписаниеТипов(Корень.ТипМетаданного); 
		НовоеПравило.Правило = ОписаниеТипа.ПривестиЗначение(); 
		
	КонецЕсли;
	
КонецПроцедуры //ЗаполнитьРеквизитамиНаСервере()

// Обработчик события возникающего на клиенте при выполнении команды "ЗаполнитьРеквизитами".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура ЗаполнитьРеквизитами(Команда)
	
	Если ПолноеИмяТипаОбъекта = "Константы" ИЛИ ПолноеИмяТипаОбъекта = "РегистрыСведений" Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Соответствия.Количество()>0 Тогда
		
		// Формируем описание обработчика перехвата закрытия формы
		ОбработчикВопроса = Новый ОписаниеОповещения("ОбработкаРезультатаОповещенияЗаполнение", ЭтотОбъект, "ОчиститьПравилаИЗаполнить");
		
		// Формируем текст вопроса
		ТекстВопроса = НСтр("ru = 'Табличная часть ""Правила заполнения"" будет очищена. Продолжить?'");
		
		// Получаем подтверждение операции от пользователя
		ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ЗаполнитьРеквизитамиНаСервере();
	КонецЕсли;
	
КонецПроцедуры //ЗаполнитьРеквизитами()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Обработчик события возникающего на клиенте при начале выбора данных реквизита "Наименование" в контексте сервера.
//
// Параметры:
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
&НаСервере
Процедура НаименованиеНачалоВыбораНаСервере(ПараметрыДействия=Неопределено)
	
	// Вызываем обработчик изменения данных объекта
	Справочники.Scan_ДействияНаЗначимыеСобытия.СформироватьНаименованиеПоУмолчанию(Объект,ПараметрыДействия);
	
КонецПроцедуры // НаименованиеНачалоВыбораНаСервере()

// Обработчик события возникающего на клиенте при начале выбора данных реквизита "Наименование".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура НаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ ПустаяСтрока(Объект.Наименование) Тогда
		
		// Формируем описание обработчика перехвата закрытия формы
		ОбработчикВопроса = Новый ОписаниеОповещения("ОбработкаРезультатаОповещенияСформироватьНаименование", ЭтотОбъект);
		
		// Формируем текст вопроса
		ТекстВопроса = НСтр("ru = 'Сформировать новое наименование?'");
		
		// Получаем подтверждение операции от пользователя
		ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		//Обработаем событие в контексте сервера
		НаименованиеНачалоВыбораНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры // НаименованиеНачалоВыбора()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Тип объекта" в контексте сервера.
//
// Параметры:
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
&НаСервере
Процедура ТипОбъектаПриИзмененииНаСервере(ПараметрыДействия=Неопределено)
	
	// Вызываем обработчик изменения данных объекта
	Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
		Справочники.Scan_ДействияНаЗначимыеСобытия.СформироватьНаименованиеПоУмолчанию(Объект,ПараметрыДействия);
	КонецЕсли;
	
	Объект.Соответствия.Очистить();
	ТипОбъектаУст = Объект.ТипОбъекта;
	
	Если ЗначениеЗаполнено(Объект.ТипОбъекта) Тогда
		
		ПолноеИмяТипаОбъекта = Объект.ТипОбъекта.ПолноеИмя;
		
		// Сначала проверяем ввод на основании.
		ОбъектИсточник = ?(ЗначениеЗаполнено(Источник),Метаданные.НайтиПоПолномуИмени(Источник.ПолноеИмя),Неопределено);
		ОбъектТекущий  = Метаданные.НайтиПоПолномуИмени(Объект.ТипОбъекта.ПолноеИмя);
		Если (ОбъектИсточник=Неопределено) ИЛИ (ОбъектТекущий=Неопределено) Тогда
			Объект.ЗадействоватьВводНаОсновании  = Ложь;
			Объект.ЗаполнитьРеквизитыПоУмолчанию = Ложь;
		КонецЕсли;
		
		Если НЕ ОбъектТекущий=Неопределено И НЕ ОбъектИсточник=Неопределено Тогда
			Если НЕ ОбъектТекущий.ВводитсяНаОсновании.Содержит(ОбъектИсточник) Тогда
				Объект.ЗадействоватьВводНаОсновании = Ложь;
			КонецЕсли;
		Иначе
			Объект.ЗадействоватьВводНаОсновании = Ложь;
		КонецЕсли;
		
		// Теперь проверяем возможность заполнения реквизитов по-умолчанию.
		// Это возможно только для объектов ссылочного типа.
		Если НЕ СсылочныйТипИсточника Тогда
			Объект.ЗаполнитьРеквизитыПоУмолчанию = Ложь;
		КонецЕсли;
		
		// Проверяем возможность проведения.
		Если ОбъектТекущий=Неопределено Тогда
			Объект.ПровестиДокумент = Ложь;
		ИначеЕсли Объект.ТипОбъекта.Родитель.ПолноеИмя = "Документы" Тогда
			Проведение = ОбъектТекущий.Проведение;
			Если НЕ Проведение=Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
				Объект.ПровестиДокумент = Ложь;
			КонецЕсли;
		Иначе
			Объект.ПровестиДокумент = Ложь;
		КонецЕсли;
		
	Иначе
		
		Объект.ЗадействоватьВводНаОсновании = Ложь;
		Объект.ЗаполнитьРеквизитыПоУмолчанию = Ложь;
		Объект.ПровестиДокумент = Ложь;
		
	КонецЕсли;
	
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ТипОбъектаПриИзмененииНаСервере()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Тип объекта".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ТипОбъектаУст) И НЕ ТипОбъектаУст = Объект.ТипОбъекта Тогда
		
		// Формируем описание обработчика перехвата закрытия формы
		ОбработчикВопроса = Новый ОписаниеОповещения("ОбработкаРезультатаОповещенияТипОбъекта", ЭтотОбъект);
		
		// Формируем текст вопроса
		ТекстВопроса = НСтр("ru = 'Смена типа объекта приведет к очистке таблицы <Правила заполнения>. Продолжить?'");
		
		// Получаем подтверждение операции от пользователя
		ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		// Обработаем событие в контексте сервера
		ТипОбъектаПриИзмененииНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры //ТипОбъектаПриИзменении()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Заполнить реквизиты по умолчанию" в контексте сервера.
//
// Параметры:
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
&НаСервере
Процедура ЗаполнитьРеквизитыПоУмолчаниюПриИзмененииНаСервере(ПараметрыДействия=Неопределено)
	
	// Вызываем обработчик изменения данных объекта
	Справочники.Scan_ДействияНаЗначимыеСобытия.ЗаполнитьРеквизитыПоУмолчаниюПриИзменении(Объект,ПараметрыДействия);
	
КонецПроцедуры // ЗаполнитьРеквизитыПоУмолчаниюПриИзмененииНаСервере()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Заполнить реквизиты по умолчанию".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура ЗаполнитьРеквизитыПоУмолчаниюПриИзменении(Элемент)
	
	// Обработаем событие в контексте сервера
	ЗаполнитьРеквизитыПоУмолчаниюПриИзмененииНаСервере();
	
КонецПроцедуры //ЗаполнитьРеквизитыПоУмолчаниюПриИзменении()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Заполнить реквизиты по умолчанию" в контексте сервера.
//
// Параметры:
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
&НаСервере
Процедура ЗадействоватьВводНаОснованииПриИзмененииНаСервере(ПараметрыДействия=Неопределено)
	
	// Вызываем обработчик изменения данных объекта
	Справочники.Scan_ДействияНаЗначимыеСобытия.ЗадействоватьВводНаОснованииПриИзменении(Объект,ПараметрыДействия);
	
КонецПроцедуры // ЗадействоватьВводНаОснованииПриИзмененииНаСервере()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Задействовать ввод на основании".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура ЗадействоватьВводНаОснованииПриИзменении(Элемент)
	
	// Обработаем событие в контексте сервера
	ЗадействоватьВводНаОснованииПриИзмененииНаСервере();
	
КонецПроцедуры //ЗадействоватьВводНаОснованииПриИзменении()


///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ТАБЛИЦЫ ФОРМЫ "СООТВЕТСТВИЯ"

// Обработчик события возникающего в момент нажатия кнопки выбора реквизита "Представление".
//
// Параметры:
//  Элемент              - ПолеФормы      - Элемент управления, в котором возникло данное событие.
//  ДанныеВыбора         - СписокЗначений - В обработчике можно сформировать и передать в этом параметре данные для выбора.
//  СтандартнаяОбработка - Булево         - данный параметр передается признак выполнения стандартной (системной) обработки события.
//
&НаКлиенте
Процедура СоответствияПредставлениеРеквизитаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Отказываемся от стандартной обработки события
	СтандартнаяОбработка = ЛОЖЬ;
	
	ТекущаяДанные = Элементы.Соответствия.ТекущиеДанные;
	
	// Сформируем параметры открытия
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Источник", Объект.ТипОбъекта);
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	
	// Получаем форму, производим ее настройку и открытие
	ОткрытьФорму("Справочник.Scan_ДействияНаЗначимыеСобытия.Форма.ВыборРеквизитаОбъекта", ПараметрыОткрытия,Элемент,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры // СоответствияПредставлениеРеквизитаНачалоВыбора()

// Обработчик события возникающего на клиенте при начале выбора данных реквизита "Представление".
//
// Параметры:
//  Элемент              - ПолеФормы - Элемент управления, в котором возникло данное событие.
//  ВыбранноеЗначение    - Выбранное значение.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
&НаКлиенте
Процедура СоответствияПредставлениеРеквизитаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Соответствия.ТекущиеДанные;
	
	// Сохраняем тип выбранного значения
	ОписаниеТипа = Новый ОписаниеТипов(ВыбранноеЗначение.ТипМетаданного); 
	
	ТекущиеДанные.Правило = ОписаниеТипа.ПривестиЗначение(); 
	ТекущиеДанные.ТипРеквизита = ОписаниеТипа.ПривестиЗначение(); 
	ТекущиеДанные.РеквизитОбъекта = ВыбранноеЗначение.ИмяМетаданного;
	ВыбранноеЗначение = ВыбранноеЗначение.Поле;
	
КонецПроцедуры // СоответствияПредставлениеРеквизитаОбработкаВыбора()

// Обработчик события возникающего в момент нажатия кнопки выбора реквизита "Правило".
//
// Параметры:
//  Элемент              - ПолеФормы      - Элемент управления, в котором возникло данное событие.
//  ДанныеВыбора         - СписокЗначений - В обработчике можно сформировать и передать в этом параметре данные для выбора.
//  СтандартнаяОбработка - Булево         - данный параметр передается признак выполнения стандартной (системной) обработки события.
//
&НаКлиенте
Процедура СоответствияПравилоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Соответствия.ТекущиеДанные;
	
	Если ТекущиеДанные.ВидПравила=ПредопределенноеЗначение("Перечисление.Scan_ВидыПравил.РеквизитОбъектаИсточника") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		// Сформируем параметры открытия
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Источник", Источник);
		ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
		
		// Получаем форму, производим ее настройку и открытие
		ОткрытьФорму("Справочник.Scan_ДействияНаЗначимыеСобытия.Форма.ВыборРеквизитаОбъекта", ПараметрыОткрытия,Элемент,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли ТекущиеДанные.ВидПравила=ПредопределенноеЗначение("Перечисление.Scan_ВидыПравил.ПроизвольныйКод") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		// Сформируем параметры открытия
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Источник", Объект.ТипОбъекта);
		ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
		ПараметрыОткрытия.Вставить("Текст", ?(ЗначениеЗаполнено(ТекущиеДанные.ПроизвольныйКод),ТекущиеДанные.ПроизвольныйКод,"Соответствия"));
		
		// Получаем форму, производим ее настройку и открытие
		ОткрытьФорму("Справочник.Scan_ДействияНаЗначимыеСобытия.Форма.РедакторВыражений", ПараметрыОткрытия, Элемент,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры //СоответствияПравилоНачалоВыбора()

// Обработчик события возникающего на клиенте при начале выбора данных реквизита "Правило".
//
// Параметры:
//  Элемент              - ПолеФормы - Элемент управления, в котором возникло данное событие.
//  ВыбранноеЗначение    - Выбранное значение.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
&НаКлиенте
Процедура СоответствияПравилоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Соответствия.ТекущиеДанные;
	
	Если ТекущиеДанные.ВидПравила=ПредопределенноеЗначение("Перечисление.Scan_ВидыПравил.ПроизвольныйКод") Тогда
		
		ТекущиеДанные.ПроизвольныйКод = ВыбранноеЗначение;
		ТекущиеДанные.ПутьКДанным = "";
		ВыбранноеЗначение = "<Произвольное выражение>";
		
	ИначеЕсли ТекущиеДанные.ВидПравила=ПредопределенноеЗначение("Перечисление.Scan_ВидыПравил.РеквизитОбъектаИсточника") Тогда
		
		// проверим соответствие типов
		Если НЕ ВыбранноеЗначение.ТипМетаданного.СодержитТип(ТипЗнч(ТекущиеДанные.Правило)) Тогда
			ВывестиСообщениеПол(НСтр("ru='Тип выбранного реквизита объекта-источника не соответствует типу реквизита создаваемого объекта!'"));
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
		
		ТекущиеДанные.ПутьКДанным = ВыбранноеЗначение.ИмяМетаданного;
		ВыбранноеЗначение = ВыбранноеЗначение.Поле + " (Владелец)";
		ТекущиеДанные.ПроизвольныйКод = "";
		
	КонецЕсли;
	
КонецПроцедуры //СоответствияПравилоОбработкаВыбора()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Вид правила".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура СоответствияВидПравилаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Соответствия.ТекущиеДанные;
	ТекущиеДанные.ПроизвольныйКод  = "";
	ТекущиеДанные.ПутьКДанным  = "";
	
	// Сохраняем тип выбранного значения
	Если НЕ ТекущиеДанные.ТипРеквизита = Неопределено Тогда
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(ТекущиеДанные.ТипРеквизита));
		ОписаниеТипа = Новый ОписаниеТипов(МассивТипов); 
		ТекущиеДанные.Правило = Неопределено;
		ТекущиеДанные.Правило = ОписаниеТипа.ПривестиЗначение(); 
	КонецЕсли;
	
КонецПроцедуры //СоответствияВидПравилаПриИзменении()

// Процедура-обработчик события "ПриНачалеРедактирования" таблицы "Соответствия"
//
&НаКлиенте
Процедура СоответствияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	СтрокаТабличнойЧасти = Элемент.ТекущиеДанные;
	
	Если НоваяСтрока И (НЕ Копирование) Тогда
		СтрокаТабличнойЧасти.ВидПравила = ПредопределенноеЗначение("Перечисление.Scan_ВидыПравил.ТочноеЗначение");
	КонецЕсли;
	
КонецПроцедуры //СоответствияПриНачалеРедактирования()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОСНОВНЫХ СОБЫТИЙ ФОРМЫ

// Обработчик события возникающего на сервере при создании формы.
//
// Параметры:
//  Отказ                - Булево - Признак отказа от создания формы.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаСервер.ПриСозданииНаСервере(ЭтотОбъект, Параметры, Отказ, СтандартнаяОбработка) Тогда
	//	Возврат;
	//КонецЕсли;
	
	Если Параметры.ДополнительныеПараметры.Свойство("Источник") Тогда
		Источник = Параметры.ДополнительныеПараметры.Источник;
		СсылочныйТипИсточника = НЕ (Источник.ЗначениеПустойСсылки = Неопределено);
	КонецЕсли;
	
	Если Параметры.Свойство("ВидДействия") Тогда
		Объект.ВидДействия = Параметры.ВидДействия;
		Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
			Справочники.Scan_ДействияНаЗначимыеСобытия.СформироватьНаименованиеПоУмолчанию(Объект);
		КонецЕсли;
	КонецЕсли;
	
	// Настроим возможные варианты для выбора вида правила
	Элементы.СоответствияВидПравила.СписокВыбора.Очистить();
	Элементы.СоответствияВидПравила.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.Scan_ВидыПравил.ТочноеЗначение"));
	Если СсылочныйТипИсточника Тогда
		Элементы.СоответствияВидПравила.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.Scan_ВидыПравил.РеквизитОбъектаИсточника"));
	КонецЕсли;
	Элементы.СоответствияВидПравила.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.Scan_ВидыПравил.ПроизвольныйКод"));
	
	ТипОбъектаУст = Объект.ТипОбъекта;
	
	// Настроим блокировку элементов формы
	БлокироватьЭлементыФормы();
	
	// Дальнейшие операции выпольняются только для новых объектов
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	// Обновим параметры выбора элементов формы
	НастроитьПараметрыВыбораЭлементовФормы();
	
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ПриСозданииНаСервере()

// Обработчик события возникающего на клиенте при открытии формы, до показа окна пользователю.
//
// Параметры:
//  Отказ - Булево - Признак отказа от создания формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаКлиент.ПриОткрытии(ЭтотОбъект, Отказ) Тогда
	//	Возврат;
	//КонецЕсли;
	
	// Настроим командную панель формы
	//ЗащищенныеФункцииКлиент.НастроитьЭлементФормыТабличнойЧасти(ЭтотОбъект,"Соответствия");
	
КонецПроцедуры // ПриОткрытии()

// Обработчик события возникающего на клиенте перед закрытием формы.
//
// Параметры:
//  Отказ                - Булево - Признак отказа от создания формы.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаКлиент.ПередЗакрытием(ЭтотОбъект, Отказ, СтандартнаяОбработка) Тогда
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры // ПередЗакрытием()

// Обработчик события возникающего на клиенте при закрытии формы.
//
&НаКлиенте
Процедура ПриЗакрытии()
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаКлиент.ПриЗакрытии(ЭтотОбъект) Тогда
	//	Возврат;
	//КонецЕсли;
	//
КонецПроцедуры // ПриЗакрытии()

// Обработчик события возникающего на клиенте при выборе объекта без привязки к элементу формы в контексте сервера.
//
// Параметры:
//  ВыбранноеЗначение - Произвольный - Результат выбора в подчиненной форме.
//  ИсточникВыбора    - Произвольный - Форма, в которой осуществлен выбор.
//
&НаСервере
Процедура ОбработкаВыбораНаСервере(ВыбранноеЗначение, ПараметрыДействия=Неопределено)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаСервер.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ПараметрыДействия) Тогда
	//	Возврат;
	//КонецЕсли;
	
	// Обновим параметры выбора элементов формы
	НастроитьПараметрыВыбораЭлементовФормы();
	
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ОбработкаВыбораНаСервере()

// Обработчик события возникающего на клиенте при выборе объекта без привязки к элементу формы.
//
// Параметры:
//  ВыбранноеЗначение - Произвольный - Результат выбора в подчиненной форме.
//  ИсточникВыбора    - Произвольный - Форма, в которой осуществлен выбор.
//
&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	// Определим структуру параметров обработки текущего события
	ПараметрыДействия = Новый Структура;
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Объект, ЭтотОбъект.Окно, ПараметрыДействия) Тогда
	//	Возврат;
	//КонецЕсли;
	
	// Обработаем событие в контексте сервера
	ОбработкаВыбораНаСервере(ВыбранноеЗначение, ПараметрыДействия);
	
	// Вызываем обработчик результата выполнения
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры // ОбработкаВыбора()

// Обработчик события возникающего на клиенте во всех формах при вызове метода Оповестить в контексте сервера.
//
// Параметры:
//  ИмяСобытия        - Строка    - Имя, идентифицирующее событие.
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
&НаСервере
Процедура ОбработкаОповещенияНаСервере(ИмяСобытия, ПараметрыДействия = Неопределено)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаСервер.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, ПараметрыДействия) Тогда
	//	Возврат;
	//КонецЕсли;
	
	// Если оповещение сводиться к выбору значения, то переходим в обработчик другого события
	Если ПараметрыДействия.Свойство("ВыбранноеЗначение") Тогда
		ОбработкаВыбораНаСервере(ПараметрыДействия.ВыбранноеЗначение, ПараметрыДействия);
		Возврат;
	КонецЕсли;
	
	// Обновим параметры выбора элементов формы
	НастроитьПараметрыВыбораЭлементовФормы();
	
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ОбработкаОповещенияНаСервере()

// Обработчик события возникающего на клиенте во всех формах при вызове метода Оповестить.
//
// Параметры:
//  ИмяСобытия - Строка       - Имя, идентифицирующее событие.
//  Параметр   - Произвольный - Параметр сообщения.
//  Источник   - Произвольный - Источник события.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Определим структуру параметров обработки текущего события
	ПараметрыДействия = Новый Структура;
	
	// Производим подготовку параметров события для обработки в контексте сервера
	//Если НЕ УправлениеДиалогомСправочникаКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник, ПараметрыДействия) Тогда
	//	Возврат;
	//КонецЕсли;
	
	// Обработаем событие в контексте сервера
	ОбработкаОповещенияНаСервере(ИмяСобытия, ПараметрыДействия);
	
	// Вызываем обработчик результата выполнения
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры // ОбработкаОповещения()

// Обработчик события возникающего на сервере при чтении данных объекта.
//
// Параметры:
//  ТекущийОбъект - СправочникОбъект - Объект, который будет прочитан.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект) Тогда
	//	Возврат;
	//КонецЕсли;
		
	// Настроим блокировку элементов формы
	БлокироватьЭлементыФормы();
	
	// Обновим параметры выбора элементов формы
	НастроитьПараметрыВыбораЭлементовФормы();
	
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ПриЧтенииНаСервере()

// Обработчик события возникающего на клиенте перед выполнением записи объекта из формы.
//
// Параметры:
//  Отказ           - Булево         - Признак отказа от записи.
//  ПараметрыЗаписи - Структура      - Структура, содержащая параметры записи.
//
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаКлиент.ПередЗаписью(ЭтотОбъект, Отказ ,ПараметрыЗаписи) Тогда
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры //ПередЗаписью()

// Обработчик события возникающего на сервере перед записью объекта.
//
// Параметры:
//  Отказ           - Булево           - Признак отказа от создания формы.
//  ТекущийОбъект   - СправочникОбъект - Записываемый объект.
//  ПараметрыЗаписи - Структура        - Структура, содержащая параметры записи.
//
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаСервер.ПередЗаписьюНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи) Тогда
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры // ПередЗаписьюНаСервере()

// Обработчик события возникающего на сервере после записи объекта и после завершения транзакции.
//
// Параметры:
//  ТекущийОбъект   - СправочникОбъект - Записываемый объект.
//  ПараметрыЗаписи - Структура        - Структура, содержащая параметры записи.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаСервер.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи) Тогда
	//	Возврат;
	//КонецЕсли;
	 	
	// Настроим блокировку элементов формы
	БлокироватьЭлементыФормы();
	
	// Обновим параметры выбора элементов формы
	НастроитьПараметрыВыбораЭлементовФормы();
	
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ПослеЗаписиНаСервере()

// Обработчик события возникающего на клиенте после записи объекта и после завершения транзакции.
//
// Параметры:
//  ПараметрыЗаписи - Структура - Структура, содержащая параметры записи.
//
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаКлиент.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи) Тогда
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры // ПослеЗаписи()

// Обработчик события возникающего на сервере при необходимости проверки заполнения реквизитов при записи в форме.
//
// Параметры:
//  Отказ                - Булево - Признак отказа от создания формы.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеДиалогомСправочникаСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполненияНаСервере()

// Обработчик события возникающего на сервере при сохранении значений реквизитов и настроек формы.
//
// Параметры:
//  Настройки - Соответствие - Значения сохраняемых реквизитов и настроек формы.
//
&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	// Вызываем общий обработчик события
	//УправлениеДиалогомСправочникаСервер.ПриСохраненииДанныхВНастройкахНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры // ПриСохраненииДанныхВНастройкахНаСервере()

// Обработчик события возникающего на сервере при восстановлении значений реквизитов из сохраненных настроек формы.
//
// Параметры:
//  Настройки - Соответствие - Значения сохраненных реквизитов и настроек формы.
//
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Вызываем общий обработчик события
	//УправлениеДиалогомСправочникаСервер.ПриЗагрузкеДанныхИзНастроекНаСервере(ЭтотОбъект, Настройки);
	
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()


////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ


