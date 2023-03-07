// Модуль формы списка справочника "Значимые события"


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//rarus sergei 11.11.2016 mantis 7163 ++
&НаСервере
Процедура СнятьАктивностьНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_ЗначимыеСобытия.Ссылка
	               |ИЗ
	               |	Справочник.Scan_ЗначимыеСобытия КАК Scan_ЗначимыеСобытия
	               |ГДЕ
	               |	Scan_ЗначимыеСобытия.Активность = ИСТИНА";
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбъектСправочника = Выборка.Ссылка.Получитьобъект();
			ОбъектСправочника.Активность = ЛОЖЬ;
			ОбъектСправочника.Записать();
		КонецЦикла;
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьАктивностьНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_ЗначимыеСобытия.Ссылка
	               |ИЗ
	               |	Справочник.Scan_ЗначимыеСобытия КАК Scan_ЗначимыеСобытия
	               |ГДЕ
	               |	Scan_ЗначимыеСобытия.Активность = ЛОЖЬ";
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбъектСправочника = Выборка.Ссылка.Получитьобъект();
			ОбъектСправочника.Активность = Истина;
			ОбъектСправочника.Записать();
		КонецЦикла;
		Элементы.Список.Обновить();
	КонецЕсли; 
КонецПроцедуры

//rarus sergei 11.11.2016 mantis 7163 --
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СЛУЖЕБНОГО ПРОГРАММНОГО ИНТЕРФЕЙСА

// Обработчик события возникающего при нажатии программно добавленной кнопки в контексте сервера.
//
// Параметры:
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
&НаСервере
Процедура ОбработкаКомандыФормыНаСервере(ИмяКоманды, ПараметрыДействия=Неопределено)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеСпискомСправочникаСервер.ОбработкаКомандыФормы(ЭтотОбъект, ИмяКоманды, ПараметрыДействия) Тогда
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры // ОбработкаКомандыФормыНаСервере()

// Обработчик события возникающего при нажатии программно добавленной кнопки.
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура Подключаемый_ОбработкаКомандыФормы(Команда) Экспорт
	
	// Определим структуру параметров обработки текущего события
	ПараметрыДействия = Новый Структура;
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеСпискомСправочникаКлиент.ОбработкаКомандыФормы(ЭтотОбъект, Команда, Элементы.Список.ТекущиеДанные, ЭтотОбъект.Окно, ПараметрыДействия) Тогда
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
	//Если НЕ УправлениеСпискомСправочникаСервер.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
	//	Возврат;
	//КонецЕсли;
	
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
	//Если НЕ УправлениеСпискомСправочникаКлиент.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
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
	//УправлениеСпискомСправочникаКлиент.ОбработкаРезультатаВыполненияДействия(ЭтотОбъект, ПараметрыДействия);
	
КонецПроцедуры // ОбработкаРезультатаВыполненияДействия()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ДИНАМИЧЕСКОГО СПИСКА ФОРМЫ

// Обработчик события возникающего на клиенте при двойном щелчке мыши (нажатии Enter) в ячейке таблицы "Список".
//
// Параметры:
//  Элемент              - ТаблицаФормы - Элемент управления, в котором возникло данное событие.
//  ВыбраннаяСтрока      - Ссылка       - Значение выбранной строки.
//  Поле                 - ПолеФормы    - Активное поле.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаКлиент.СписокВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры // СписокВыбор()

// Обработчик события возникающего на клиенте при активизации строки списка с задержкой в контексте сервера.
//
&НаСервере
Процедура СписокПриАктивизацииСтрокиНаСервере()
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаСервер.СписокПриАктивизацииСтроки(ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры // СписокПриАктивизацииСтрокиНаСервере()

// Обработчик события возникающего на клиенте при активизации строки списка выполняемый с задержкой.
//
// Параметры:
//  Элемент - ТаблицаФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура Подключаемый_СписокПриАктивизацииСтроки()
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеСпискомСправочникаКлиент.СписокПриАктивизацииСтроки(ЭтотОбъект, Элементы.Список, ИСТИНА) Тогда
	//	Возврат;
	//КонецЕсли;
	
	// Обработаем событие в контексте сервера
	СписокПриАктивизацииСтрокиНаСервере();
	
КонецПроцедуры // Подключаемый_СписокПриАктивизацииСтроки()

// Обработчик события возникающего на клиенте при активизации строки списка.
//
// Параметры:
//  Элемент - ТаблицаФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаКлиент.СписокПриАктивизацииСтроки(ЭтотОбъект, Элемент);
	
КонецПроцедуры // СписокПриАктивизацииСтроки()

// Обработчик события возникающего на клиенте при активизации строки списка.
//
// Параметры:
//  Элемент - ТаблицаФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура СписокПриАктивизацииЯчейки(Элемент)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаКлиент.СписокПриАктивизацииЯчейки(ЭтотОбъект, Элемент);
	
КонецПроцедуры // СписокПриАктивизацииЯчейки()

// Обработчик события возникающего на клиенте перед добавления строки в таблицу "Список".
//
//  Элемент     - ПолеФормы    - Элемент управления, в котором возникло данное событие.
//  Отказ       - Булево       - Признак отказа от добавления объекта.
//  Копирование - Булево       - Определяет режим копирования.
//  Родитель    - Неопределено; СправочникСсылка.<Имя справочника>; ПланСчетовСсылка.<Имя плана счетов>
//                             - Ссылка на элемент, который будет использован при добавлении в качестве родителя. 
//  ЭтоГруппа   - Булево       - Признак добавления группы.
//  Параметр    - Произвольный - Параметр команды, выполняемой при добавлении строки в таблицу.
//
&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаКлиент.СписокПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа, Параметр);
	
КонецПроцедуры // СписокПередНачаломДобавления

// Обработчик события возникающего на клиенте перед началом изменения списка.
//
// Параметры:
//  Элемент - ТаблицаФормы - Элемент управления, в котором возникло данное событие.
//  Отказ   - Булево       - Признак отказа от действия.
//
&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаКлиент.СписокПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры // СписокПередНачаломИзменения()

// Обработчик события возникающего на клиенте после удаления строки списка.
//
// Параметры:
//  Элемент - ТаблицаФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаКлиент.СписокПослеУдаления(ЭтотОбъект, Элемент);
	
КонецПроцедуры // СписокПослеУдаления()

// Обработчик события возникающего на клиенте при изменении текущего родителя в режиме иерархического списка.
//
// Параметры:
//  Элемент - ТаблицаФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура СписокПриСменеТекущегоРодителя(Элемент)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаКлиент.СписокПриСменеТекущегоРодителя(ЭтотОбъект, Элемент);
	
КонецПроцедуры // СписокПриСменеТекущегоРодителя()

// Обработчик события возникающего при сохранении пользовательских настроек в контексте сервера.
// 
// Параметры:
//  Элемент   - ТаблицаФормы - Элемент управления, в котором возникло данное событие.
//  Настройки - ПользовательскиеНастройкиКомпоновкиДанных - Сохраняемые настройки. 
//
&НаСервере
Процедура СписокПриСохраненииПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаСервер.СписокПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры // СписокПриСохраненииПользовательскихНастроекНаСервере()

// Обработчик события возникающего при восстановлении пользовательских настроек в контексте сервера.
// 
// Параметры:
//  Элемент   - ТаблицаФормы - Элемент управления, в котором возникло данное событие.
//  Настройки - ПользовательскиеНастройкиКомпоновкиДанных - Восстанавливаемые настройки. 
//
&НаСервере
Процедура СписокПриЗагрузкеПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаСервер.СписокПриЗагрузкеПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры // СписокПриЗагрузкеПользовательскихНастроекНаСервере()

// Обработчик события возникающего на сервере при обновлении пользовательских настроек списка.
//
// Параметры:
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаСервер.СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры // СписокПриОбновленииСоставаПользовательскихНастроекНаСервере()

// Обработчик события возникающего на клиенте при движении курсора в поле приемнике данных.
//
// Параметры:
//  Элемент                 - ТаблицаФормы - Элемент управления, в котором возникло данное событие.
//  ПараметрыПеретаскивания - Содержит перетаскиваемое значение, тип действия и возможные действия при перетаскивании.
//  СтандартнаяОбработка    - Булево - В данный параметр передается признак выполнения системной обработки события.
//  Строка                  - Содержит порядковый номер строки или ссылку на текущий объект.
//  Поле                    - Поле, с которым связана данная колонка таблицы, над которой находится объект.
//
&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаКлиент.СписокПроверкаПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле);
	
КонецПроцедуры // СписокПроверкаПеретаскивания()

// Обработчик события возникающего на клиенте при окончании перетаскивания в поле-приемнике данных.
//
// Параметры:
//  Элемент                 - ТаблицаФормы - Элемент управления, в котором возникло данное событие.
//  ПараметрыПеретаскивания - Содержит перетаскиваемое значение, тип действия и возможные действия при перетаскивании.
//  СтандартнаяОбработка    - Булево - В данный параметр передается признак выполнения системной обработки события.
//  Строка                  - Содержит порядковый номер строки или ссылку на текущий объект.
//  Поле                    - Поле, с которым связана данная колонка таблицы, над которой находится объект.
//
&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаКлиент.СписокПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле);
	
КонецПроцедуры // СписокПеретаскивание()

//rarus sergei 11.11.2016 mantis 7163 ++
&НаКлиенте
Процедура СнятьАктивность(Команда)
	СнятьАктивностьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьАктивность(Команда)
	УстановитьАктивностьНаСервере();
КонецПроцедуры
//rarus sergei 11.11.2016 mantis 7163 --

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
	//Если НЕ УправлениеСпискомСправочникаСервер.ПриСозданииНаСервере(ЭтотОбъект, Параметры, Отказ, СтандартнаяОбработка) Тогда
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

// Обработчик события возникающего на клиенте при открытии формы, до показа окна пользователю.
//
// Параметры:
//  Отказ - Булево - Признак отказа от создания формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеСпискомСправочникаКлиент.ПриОткрытии(ЭтотОбъект, Отказ) Тогда
	//	Возврат;
	//КонецЕсли;
	
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
	//Если НЕ УправлениеСпискомСправочникаКлиент.ПередЗакрытием(ЭтотОбъект, Отказ, СтандартнаяОбработка) Тогда
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры // ПередЗакрытием()

// Обработчик события возникающего на клиенте при закрытии формы.
//
&НаКлиенте
Процедура ПриЗакрытии()
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеСпискомСправочникаКлиент.ПриЗакрытии(ЭтотОбъект) Тогда
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры // ПриЗакрытии()

// Обработчик события возникающего на клиенте во всех формах при вызове метода Оповестить в контексте сервера.
//
// Параметры:
//  ИмяСобытия        - Строка    - Имя, идентифицирующее событие.
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
&НаСервере
Процедура ОбработкаОповещенияНаСервере(ИмяСобытия, ПараметрыДействия)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеСпискомСправочникаСервер.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, ПараметрыДействия) Тогда
	//	Возврат;
	//КонецЕсли;
	
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
	//Если НЕ УправлениеСпискомСправочникаКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник, ПараметрыДействия) Тогда
	//	Возврат;
	//КонецЕсли;
	
	// Обработаем событие в контексте сервера
	ОбработкаОповещенияНаСервере(ИмяСобытия, ПараметрыДействия);
	
	// Вызываем обработчик результата выполнения
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);

КонецПроцедуры // ОбработкаОповещения()

// Обработчик события возникающего на клиенте при вызове метода ОповеститьОбАктивизации из формы-владельца.
//
// Параметры:
//  АктивныйОбъект - Произвольный     - Активный объект.
//  Источник       - УправляемаяФорма - Форма, источник сообщения.
//
&НаКлиенте
Процедура ОбработкаАктивизации(АктивныйОбъект, Источник)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеСпискомСправочникаКлиент.ОбработкаАктивизации(ЭтотОбъект, АктивныйОбъект, Источник) Тогда
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры // ОбработкаАктивизации()

// Обработчик события возникающего на клиенте при записи объекта в одной из подчиненных форм.
//
// Параметры:
//  НовыйОбъект          - Произвольный     - Добавленный в подчиненной форме объект.
//  Источник             - УправляемаяФорма - Форма, источник сообщения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	// Вызываем общий обработчик события
	//Если НЕ УправлениеСпискомСправочникаКлиент.ОбработкаЗаписиНового(ЭтотОбъект, НовыйОбъект, Источник, СтандартнаяОбработка) Тогда
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаписиНового()

// Обработчик события возникающего на сервере при сохранении значений реквизитов и настроек формы.
//
// Параметры:
//  Настройки - Соответствие - Значения сохраняемых реквизитов и настроек формы.
//
&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаСервер.ПриСохраненииДанныхВНастройкахНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры // ПриСохраненииДанныхВНастройкахНаСервере()

// Обработчик события возникающего на сервере при восстановлении значений реквизитов из сохраненных настроек формы.
//
// Параметры:
//  Настройки - Соответствие - Значения сохраненных реквизитов и настроек формы.
//
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Вызываем общий обработчик события
	//УправлениеСпискомСправочникаСервер.ПриЗагрузкеДанныхИзНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()




////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

