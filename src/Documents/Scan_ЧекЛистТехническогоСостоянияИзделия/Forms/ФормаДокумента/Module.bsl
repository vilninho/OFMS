

//rarus tenkam 28.09.2016 mantis 7183 ++
#Область ОбработчикиОсновныхСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ХозОперации ++
	Scan_ВспомогательныеФункцииСервер.ИнициализироватьМенюВыбораХозОперации(ЭтаФорма);
	
	// Вызываем общий обработчик события
	Если НЕ Scan_УправлениеДиалогомДокументаСервер.ПриСозданииНаСервере(ЭтотОбъект, Параметры, Отказ, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	// Обновим параметры выбора элементов формы
	НастроитьПараметрыВыбораЭлементовФормы();
	// ХозОперации --
	
	УправлениеДиалогомНаСервере();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		// Параметры документа ++
		ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь() ;
		Объект.Организация = ТекущийПользователь.Организация;
		Объект.ПодразделениеКомпании = ТекущийПользователь.ПодразделениеОрганизации;
		Объект.Автор = ТекущийПользователь;
		Объект.Менеджер = ТекущийПользователь;
		Объект.Дата = ТекущаяДата();
		Объект.ВалютаДокумента = Справочники.Валюты.НайтиПоКоду("643");
		//rarus vikhle 22.04.2020 mt 15695 +++	
		Scan_ВспомогательныеФункцииСервер.ЗаполнитьКомпаниюИКонтрагента(ТекущийПользователь,Объект.Компания,Объект.Контрагент);
		//rarus vikhle 22.04.2020 mt 15695 ---
		// Параметры документа --
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Изделие) Тогда
		УстановитьДатуПостановкиНаХранение();
	КонецЕсли;
	
	Если Объект.СписокРабот.Количество() <> 0 Тогда
		ЗаполнитьТаблицуСервисныхОпераций();
	КонецЕсли;
	
	// rarus tenkam 13.03.2018 mantis 12880 +++
	Если ЗначениеЗаполнено(Объект.ПричинаНевыполнения) Тогда
		Элементы.КТСВыполнен.Доступность = Ложь;
		Элементы.ТаблицаСервисныхОпераций.Доступность = Ложь;
	КонецЕсли;	
	// rarus tenkam 13.03.2018 mantis 12880 ---
	Scan_СборСтатистики.Scan_ПриОткрытии("Документы", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ПроверитьЗаполнениеПолей();
	ЗаписатьСервисныеОперацииВСписокРабот();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	УправлениеДиалогомНаСервере();	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	// Параметры документа ++
	Scan_УправлениеДиалогомДокументаСервер.ПриСохраненииДанныхВНастройкахНаСервере(ЭтотОбъект, Настройки);
	// Параметры документа --
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	// Параметры документа ++
	Scan_УправлениеДиалогомДокументаСервер.ПриЗагрузкеДанныхИзНастроекНаСервере(ЭтотОбъект, Настройки);
	// Параметры документа --
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Rarus tenkam 11.04.2022 mantis 18433 +++
	Если Объект.Ссылка.Пустая() Тогда
		Scan_СборСтатистики.Scan_ПередЗаписьюДокумента(РеквизитФормыВЗначение("Объект").Метаданные().Синоним, Истина, "Создание нового элемента");
	КонецЕсли;
	// Rarus tenkam 11.04.2022 mantis 18433 --- 
 КонецПроцедуры

#КонецОбласти

// ХозОперации ++
#Область ХозОперации
// Производит настройку параметров выбора элементов управления диалога в зависимости от значений реквизитов объекта.
//
&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	// Вызываем общий обработчик события настройки параметров выбора
	Scan_УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры // НастроитьПараметрыВыбораЭлементовФормы()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Хоз. операция" в контексте сервера.
//
// Параметры:
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
&НаСервере
Процедура ХозОперацияПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	// Вызываем обработчик изменения данных объекта
	Документы.Scan_ЧекЛистТехническогоСостоянияИзделия.ХозОперацияПриИзменении(Объект, ПараметрыДействия);
	
	// Обновим параметры выбора элементов формы
	НастроитьПараметрыВыбораЭлементовФормы();	
КонецПроцедуры // ХозОперацияПриИзмененииНаСервере()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Хоз. операция".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура ХозОперацияПриИзменении(Команда)                                                                                         
	// Вызываем общий обработчик события выбора одного из пунктов меню доступных хоз. операций
	Scan_УправлениеДиалогомДокументаКлиент.ОбработатьВыборХозОперации(Объект, Элементы, Команда.Имя);
	
	// Определим структуру параметров обработки текущего события
	ПараметрыДействия = Новый Структура;                     
	
	// Обработаем событие в контексте сервера
	ХозОперацияПриИзмененииНаСервере(ПараметрыДействия);

КонецПроцедуры // ХозОперацияПриИзменении()

#КонецОбласти
// ХозОперации --

// Параметры документа ++
#Область ПараметрыДокумента
&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаОповещения(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	// Обработаем событие в контексте сервера
	ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры);
КонецПроцедуры // Подключаемый_ОбработкаРезультатаОповещения()

&НаСервере
Процедура ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры=Неопределено)
	// Вызываем общий обработчик события
	Если НЕ Scan_УправлениеДиалогомДокументаСервер.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;

	// Обновим параметры выбора элементов формы
	НастроитьПараметрыВыбораЭлементовФормы();
	
КонецПроцедуры // ОбработкаРезультатаОповещенияНаСервере()

// Обработчик события возникающего на клиенте при открытии параметров документа.
//
// Параметры:
//  Элемент              - ТаблицаФормы   - Элемент управления, в котором возникло данное событие.
//  ДанныеВыбора         - СписокЗначений - Список возможных значений для выбора, которые будет показан.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
&НаКлиенте
Процедура ПараметрыДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)	
	// Отказываемся от стандартной обработки события
	СтандартнаяОбработка = ЛОЖЬ;
	
	// Открываем форму расширенного редактирования параметров документа
	Scan_УправлениеДиалогомДокументаКлиент.НастроитьПараметрыДокумента(ЭтотОбъект);	
КонецПроцедуры // ПараметрыДокументаНачалоВыбора()

// Обработчик события возникающего на клиенте при открытии параметров документа.
//
// Параметры:
//  Элемент              - ТаблицаФормы - Элемент управления, в котором возникло данное событие.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
&НаКлиенте
Процедура ПараметрыДокументаОткрытие(Элемент, СтандартнаяОбработка)
	// Отказываемся от стандартной обработки события
	СтандартнаяОбработка = ЛОЖЬ;
	
	// Открываем форму расширенного редактирования параметров документа
	Scan_УправлениеДиалогомДокументаКлиент.НастроитьПараметрыДокумента(ЭтотОбъект);
КонецПроцедуры

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
	Если НЕ Scan_УправлениеДиалогомДокументаКлиент.ОбработкаКомандыФормы(ЭтотОбъект, Команда, Объект, ЭтотОбъект.Окно, ПараметрыДействия) Тогда
		Возврат;
	КонецЕсли	
КонецПроцедуры // Подключаемый_ОбработкаКомандыФормы()
#КонецОбласти
// Параметры документа --
#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

&НаКлиенте
Процедура ПрикрепитьФайл(Команда)
	Документ = Объект.Ссылка;
	
	// rarus tenkam 10.04.2019 mantis 14195 +++
	//ВыбранныеФайлы = Новый Массив;
	//
	//ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	//ВыборФайла.МножественныйВыбор = Истина;
	//ВыборФайла.Заголовок = НСтр("ru = 'Выбор файла'");
	//ВыборФайла.Фильтр = НСтр("ru = 'Все файлы'") + " (*.*)|*.*";
	//Если ВыборФайла.Выбрать() Тогда
	//	ВыбранныеФайлы = ВыборФайла.ВыбранныеФайлы;
	//КонецЕсли;
	//
	//Если ВыбранныеФайлы.Количество() <> 0 Тогда
	//	ДопПараметры = Новый Структура;
	//	ДопПараметры.Вставить("ИдентификаторФормы", ЭтаФорма.УникальныйИдентификатор);
	//	ДопПараметры.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", Истина);
	//	ДопПараметры.Вставить("ВыбранныеФайлы", ВыбранныеФайлы);
	//	ДопПараметры.Вставить("ВладелецФайла", Документ);
	//	
	//	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлыРасширениеПредложено", ПрисоединенныеФайлыСлужебныйКлиент, ДопПараметры);
	//	ФайловыеФункцииСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);	
	//	
	//	ПараметрыФормы = Новый Структура;
	//	ПараметрыФормы.Вставить("ВладелецФайла",  Документ);
	//	ПараметрыФормы.Вставить("ТолькоПросмотр", ЭтаФорма.ТолькоПросмотр);
	//	// rarus tenkam 14.03.2019 mantis 14220 +++ 
	//	//ОткрытьФорму("ОбщаяФорма.ПрисоединенныеФайлы", ПараметрыФормы, ЭтаФорма, Истина, ЭтаФорма.Окно);
	//	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыФормы, ЭтаФорма, Истина, ЭтаФорма.Окно);
	//	// rarus tenkam 14.03.2019 mantis 14220 ---
	//КонецЕсли;	
	
	РаботаСФайламиКлиент.ДобавитьФайлы(Документ, ЭтаФорма.УникальныйИдентификатор, , );
	
	// rarus tenkam 10.04.2019 mantis 14195 ---

КонецПроцедуры

&НаКлиенте
Процедура СнятьПодтверждение(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Сообщить("Документ не записан!");
		Возврат;
	КонецЕсли;

	Если ЭтотОбъект.Модифицированность Тогда
		Сообщить("Документ был изменен. Для снятия признака выполнения КТС его надо записать!");
		Возврат;
	КонецЕсли;
	СнятьПодтверждениеНаСервере(Объект.Ссылка);
	ЭтаФорма.Прочитать();
	УправлениеДиалогомНаСервере();
КонецПроцедуры

&НаСервере
Процедура СнятьПодтверждениеНаСервере(ДокументСсылка)
	СообщениеОбОшибке = "";
	ВсеОк = Документы.Scan_ЧекЛистТехническогоСостоянияИзделия.СнятьПодтверждениеКТС(ДокументСсылка, СообщениеОбОшибке);
	Если НЕ ВсеОк Тогда
		Сообщить(СообщениеОбОшибке);
	Иначе
		Сообщить("У документа " + ДокументСсылка.Номер + " от " + ТекущаяДата() + " снят признак ""КТС выполнен"".");
		УправлениеДиалогомНаСервере();
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	Если Объект.КТСВыполнен Тогда
		Элементы.ГруппаВсеПоля.ТолькоПросмотр = Истина;
	Иначе
		Элементы.ГруппаВсеПоля.ТолькоПросмотр = Ложь;		
	КонецЕсли;
	
	//
КонецПроцедуры

&НаСервере
Процедура УстановитьДатуПостановкиНаХранение()	
	// rarus tenkam 27.02.2018 mantis 12844 +++
	//ДатаПостановкиНаХранение = РегистрыСведений.Scan_МатрицаХраненияИзделий.ПолучитьДатуПостановкиНаХранение(Объект.Изделие,,,Объект.ПлановаяДатаВыполненияКТС);
	ДатаПостановкиНаХранение = РегистрыСведений.Scan_МатрицаХраненияИзделий.ПолучитьДатуПостановкиНаХранение(Объект.Изделие,Объект.МестоХранения,Объект.Ссылка,Объект.ПлановаяДатаВыполненияКТС);
	// rarus tenkam 27.02.2018 mantis 12844 ---	
КонецПроцедуры

&НаСервере
Процедура УстановитьПлановуюДатуВыполненияКТС()
	Если ЗначениеЗаполнено(ДатаПостановкиНаХранение) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_СрокиВыполненияКонтроляТехническогоCостоянияСрезПоследних.СрокКТС КАК СрокКТС
		|ИЗ
		|	РегистрСведений.Scan_СрокиВыполненияКонтроляТехническогоCостояния.СрезПоследних(&НаДату, ЛогистическийТип = &ЛогистическийТип) КАК Scan_СрокиВыполненияКонтроляТехническогоCостоянияСрезПоследних";
		
		Запрос.УстановитьПараметр("ЛогистическийТип", Объект.Изделие.ТипПродуктаЛогистический);
		Запрос.УстановитьПараметр("НаДату", ТекущаяДата());
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			Объект.ПлановаяДатаВыполненияКТС = ДатаПостановкиНаХранение + ВыборкаДетальныеЗаписи.СрокКТС*24*60*60;
		КонецЕсли;
	Иначе
		Объект.ПлановаяДатаВыполненияКТС = Дата('00010101');	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнениеПолей()
	ВсеЗаполнено = Истина;
	
	Если Не ЗначениеЗаполнено(Объект.Изделие) Тогда
		ВсеЗаполнено = Ложь;
	КонецЕсли;
	
	Если ВсеЗаполнено И Не ЗначениеЗаполнено(Объект.МестоХранения) Тогда
		ВсеЗаполнено = Ложь;
	КонецЕсли;
	
	Если ВсеЗаполнено И Не ЗначениеЗаполнено(Объект.Исполнитель) Тогда
		ВсеЗаполнено = Ложь;
	КонецЕсли;
	Если ВсеЗаполнено И Не ЗначениеЗаполнено(Объект.ДоговорСИсполнителем) Тогда
		ВсеЗаполнено = Ложь;
	КонецЕсли;
	Если ВсеЗаполнено И Не ЗначениеЗаполнено(Объект.ПлановаяДатаВыполненияКТС) Тогда
		ВсеЗаполнено = Ложь;
	КонецЕсли;
	Если ВсеЗаполнено И Не ЗначениеЗаполнено(Объект.ФактическаяДатаВыполненияКТС) Тогда
		ВсеЗаполнено = Ложь;
	КонецЕсли;
	
	Если ВсеЗаполнено Тогда		
		ТекДерево = РеквизитФормыВЗначение("ТаблицаСервисныхОпераций");
		//ЭлементыДерева = ТекДерево.ПолучитьЭлементы();
		
		ЭтоПервыйЧекЛист = ЭтоПервыйЧекЛист(Объект.Ссылка);
		
		Для Каждого ТекСтрока Из ТекДерево.Строки Цикл
			
			// rarus tenkam 20.02.2018 mantis 12721 +++
			Если ТекСтрока.СервиснаяОперацияМаркер = Справочники.Scan_СервисныеОперации.ПроверитьУровеньЗаряженностиАккумуляторныхБатареи1 ИЛИ
				ТекСтрока.СервиснаяОперацияМаркер = Справочники.Scan_СервисныеОперации.ПроверитьУровеньЗаряженностиАккумуляторныхБатареи2 Тогда
				Продолжить;
			КонецЕсли;
			// rarus tenkam 20.02.2018 mantis 12721 ---					
			
			Если НЕ ЗначениеЗаполнено(СокрЛП(ТекСтрока.РезультатСтало)) Тогда
				ВсеЗаполнено = Ложь;
				Прервать;
			КонецЕсли;
			
			Если НЕ ЭтоПервыйЧекЛист Тогда
				Если НЕ ЗначениеЗаполнено(СокрЛП(ТекСтрока.РезультатБыло)) Тогда
					ВсеЗаполнено = Ложь;
					Прервать;
				КонецЕсли; 				
			КонецЕсли; 			
			
			Для Каждого ТекСтрокаВложенная Из ТекСтрока.Строки Цикл
					
				Если НЕ ЗначениеЗаполнено(СокрЛП(ТекСтрокаВложенная.РезультатСтало)) Тогда
					ВсеЗаполнено = Ложь;
					Прервать;
				КонецЕсли;
				
				Если НЕ ЭтоПервыйЧекЛист Тогда
					
					Если НЕ ЗначениеЗаполнено(СокрЛП(ТекСтрокаВложенная.РезультатБыло)) Тогда 
						ВсеЗаполнено = Ложь;
						Прервать;
					КонецЕсли;
				КонецЕсли;

			КонецЦикла;
		КонецЦикла;
		
		// rarus tenkam 20.02.2018 mantis 12721 +++
		Для Каждого ТекСтрока Из ТекДерево.Строки Цикл
			         			
			Если ВсеЗаполнено И 
				(ТекСтрока.СервиснаяОперацияМаркер = Справочники.Scan_СервисныеОперации.ПроверитьУровеньЗаряженностиАккумуляторныхБатареи1 ИЛИ
				ТекСтрока.СервиснаяОперацияМаркер = Справочники.Scan_СервисныеОперации.ПроверитьУровеньЗаряженностиАккумуляторныхБатареи2) Тогда 				
				
				ХотяБыОднаХарактеристикаАКБЗаполнена = Ложь;
				Для Каждого ТекСтрокаВложенная Из ТекСтрока.Строки Цикл
					
					// Емкость обязательно должна быть заполнена
					Если  ТекСтрокаВложенная.Составляющая.Наименование = "Емкость" И (ТекСтрокаВложенная.Составляющая.Код = "100000001"  ИЛИ ТекСтрокаВложенная.Составляющая.Код = "200000001") Тогда 
						Если НЕ ЗначениеЗаполнено(ТекСтрокаВложенная.РезультатСтало) Тогда
							ВсеЗаполнено = Ложь;
							Прервать;
						КонецЕсли;
						
						Если НЕ ЭтоПервыйЧекЛист Тогда								
							Если НЕ ЗначениеЗаполнено(ТекСтрокаВложенная.РезультатБыло) Тогда 
								ВсеЗаполнено = Ложь;
								Прервать;
							КонецЕсли;
						КонецЕсли;
						
					Иначе
						// Проверим остальные характеристики
						Если НЕ ХотяБыОднаХарактеристикаАКБЗаполнена Тогда
							РезСтало = Ложь;
							РезБыло = Ложь;
							
							Если ЗначениеЗаполнено(ТекСтрокаВложенная.РезультатСтало) Тогда
								РезСтало = Истина;
							КонецЕсли;
							
							Если НЕ ЭтоПервыйЧекЛист Тогда								
								Если ЗначениеЗаполнено(ТекСтрокаВложенная.РезультатБыло) Тогда 
									РезБыло = Истина;
								КонецЕсли;
							Иначе
								РезБыло = Истина;
							КонецЕсли;
							
							Если РезБыло И РезСтало Тогда
								ХотяБыОднаХарактеристикаАКБЗаполнена = Истина;
								Прервать;
							КонецЕсли;
						КонецЕсли; 						
					КонецЕсли;  					
					
				КонецЦикла;
				Если НЕ ХотяБыОднаХарактеристикаАКБЗаполнена Тогда
					ВсеЗаполнено = Ложь;
					Прервать;
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
		// rarus tenkam 20.02.2018 mantis 12721 ---
	КонецЕсли;
	
	Объект.КТСВыполнен = ВсеЗаполнено;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуСервисныхОпераций()
	ТекДерево = РеквизитФормыВЗначение("ТаблицаСервисныхОпераций");
	СтараяПерваяСтрока = Неопределено;
	ВерхняяСтрокаДерева = Неопределено;
	Для Каждого ТекСтрокаОбъекта Из Объект.СписокРабот Цикл
		Если Не ЗначениеЗаполнено(ТекСтрокаОбъекта.Составляющая) Тогда
			НоваяСтрока = ТекДерево.Строки.Добавить();
			НоваяСтрока.СервиснаяОперацияМаркер = ТекСтрокаОбъекта.Работы;
			НоваяСтрока.СервиснаяОперация = ТекСтрокаОбъекта.Работы;
			НоваяСтрока.РезультатБыло = ТекСтрокаОбъекта.РезультатБыло;
			НоваяСтрока.РезультатСтало = ТекСтрокаОбъекта.РезультатСтало;
			НоваяСтрока.Идентификатор = ТекСтрокаОбъекта.ПолучитьИдентификатор();
		Иначе
			Если СтараяПерваяСтрока <> ТекСтрокаОбъекта.Работы Тогда
				ЭтоПерваяСтрока = Истина;
			Иначе
				ЭтоПерваяСтрока = Ложь;
			КонецЕсли;
			
			Если ЭтоПерваяСтрока Тогда
				НоваяСтрока = ТекДерево.Строки.Добавить();
				НоваяСтрока.СервиснаяОперацияМаркер = ТекСтрокаОбъекта.Работы;
				НоваяСтрока.СервиснаяОперация = ТекСтрокаОбъекта.Работы;
				НоваяСтрока.РезультатБыло = "___";
				НоваяСтрока.РезультатСтало = "___";
				СтараяПерваяСтрока = ТекСтрокаОбъекта.Работы;
				ВерхняяСтрокаДерева = НоваяСтрока; 
				НоваяСтрока.Идентификатор = Неопределено;
			КонецЕсли;
			Если ЗначениеЗаполнено(ВерхняяСтрокаДерева) Тогда
				НоваяСтрока = ВерхняяСтрокаДерева.Строки.Добавить();
				НоваяСтрока.СервиснаяОперацияМаркер = ТекСтрокаОбъекта.Работы;
				НоваяСтрока.Составляющая = ТекСтрокаОбъекта.Составляющая;
				НоваяСтрока.РезультатБыло = ТекСтрокаОбъекта.РезультатБыло;
				НоваяСтрока.РезультатСтало = ТекСтрокаОбъекта.РезультатСтало;
				НоваяСтрока.Идентификатор = ТекСтрокаОбъекта.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ЗначениеВРеквизитФормы(ТекДерево, "ТаблицаСервисныхОпераций");
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСервисныеОперацииВСписокРабот()
	ТекДерево = РеквизитФормыВЗначение("ТаблицаСервисныхОпераций");
	
	Для Каждого ТекСтрока Из ТекДерево.Строки Цикл
		// rarus tenkam 25.06.2018 mantis 13242 +++
		//Если ЗначениеЗаполнено(ТекСтрока.Идентификатор) Тогда
		Если НЕ ТекСтрока.РезультатБыло = "___" Тогда	
		// rarus tenkam 25.06.2018 mantis 13242 ---
			НайденнаяСтрока = Объект.СписокРабот.НайтиПоИдентификатору(ТекСтрока.Идентификатор);
			НайденнаяСтрока.РезультатБыло = ТекСтрока.РезультатБыло;
			НайденнаяСтрока.РезультатСтало = ТекСтрока.РезультатСтало;
		Иначе
			Для Каждого ТекСтрокаВложенная Из ТекСтрока.Строки Цикл
				НайденнаяСтрока = Объект.СписокРабот.НайтиПоИдентификатору(ТекСтрокаВложенная.Идентификатор);
				НайденнаяСтрока.РезультатБыло = ТекСтрокаВложенная.РезультатБыло;
				НайденнаяСтрока.РезультатСтало = ТекСтрокаВложенная.РезультатСтало;
			КонецЦикла;			
		КонецЕсли;		
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоПервыйЧекЛист(ЧекЛистСсылка)
	Если НЕ ЗначениеЗаполнено(ЧекЛистСсылка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +++
	//// rarus tenkam 27.06.2019 mantis 14427 +++			
	//ТекПродукт = РегистрыСведений.Scan_ВзаимосвязьИзделийПродуктовИЗаказов.ПолучитьПродуктПоИзделию(ЧекЛистСсылка.Изделие);
	//Если НЕ ЗначениеЗаполнено(ТекПродукт) Тогда
	//	Возврат Ложь;
	//КонецЕсли;
	//// rarus tenkam 27.06.2019 mantis 14427 ---
	// rarus tenkam 22.07.2019 mantis 14662 + удалить по 14430 ---
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Scan_МатрицаХраненияИзделийСрезПоследних.Реквизит КАК Реквизит,
		|	Scan_МатрицаХраненияИзделийСрезПоследних.Документ КАК Документ,
		|	Scan_МатрицаХраненияИзделийСрезПоследних.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.Scan_МатрицаХраненияИзделий.СрезПоследних(
		|			,
		|			МестоХранения = &МестоХранения
		|				И Значение < &ДатаПлан
		// rarus tenkam 27.06.2019 mantis 14427 +++			
		//|				И Продукт = &Продукт) КАК Scan_МатрицаХраненияИзделийСрезПоследних 	// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +
		|				И Изделие = &Изделие) КАК Scan_МатрицаХраненияИзделийСрезПоследних
		// rarus tenkam 27.06.2019 mantis 14427 ---			
		|
		|УПОРЯДОЧИТЬ ПО
		|	Значение УБЫВ";
	
	Запрос.УстановитьПараметр("ДатаПлан", ЧекЛистСсылка.ПлановаяДатаВыполненияКТС);
	Запрос.УстановитьПараметр("МестоХранения", ЧекЛистСсылка.МестоХранения);
	// rarus tenkam 27.06.2019 mantis 14427 +++			
	//Запрос.УстановитьПараметр("Продукт", ТекПродукт);	// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +	
	Запрос.УстановитьПараметр("Изделие", ЧекЛистСсылка.Изделие);	
	// rarus tenkam 27.06.2019 mantis 14427 +++			
			
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Если ВыборкаДетальныеЗаписи.Реквизит = Перечисления.Scan_КонтрольныеДатыХраненияИзделий.ДатаПостановкиНаХранение Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
////// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	ПроверитьЗаполнениеПолей();  	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорСИсполнителемПриИзменении(Элемент)
	ПроверитьЗаполнениеПолей();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСервисныхОперацийПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ПроверитьЗаполнениеПолей();
КонецПроцедуры

&НаКлиенте
Процедура ИзделиеПриИзменении(Элемент)
	ПроверитьЗаполнениеПолей();
	УстановитьДатуПостановкиНаХранение();
	УстановитьПлановуюДатуВыполненияКТС();
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияПриИзменении(Элемент)
	ПроверитьЗаполнениеПолей();
КонецПроцедуры

&НаКлиенте
Процедура ФактическаяДатаВыполненияКТСПриИзменении(Элемент)
	ПроверитьЗаполнениеПолей();
КонецПроцедуры 

&НаКлиенте
Процедура ДоговорСИсполнителемНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)	
	Если ЗначениеЗаполнено(Объект.Исполнитель) Тогда
		ТекКонтрагент = ПолучитьКонтрагентаИсполнителя(Объект.Исполнитель);
		СтандартнаяОбработка = Ложь; 		
		ЗначениеОтбора = Новый Структура("Владелец", ТекКонтрагент); 		
		ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
		Результат = ОткрытьФорму("Справочник.Scan_ДоговорыВзаиморасчетов.ФормаВыбора", ПараметрыФормы, Элементы.ДоговорСИсполнителем);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКонтрагентаИсполнителя(ИсполнительСсылка)
	//rarus bonmak 15.04.2020 14456 ++
	//Возврат ?(ТипЗнч(ИсполнительСсылка) = Тип("СправочникСсылка.Scan_Компании"),ИсполнительСсылка.Контрагент, ИсполнительСсылка); //rarus bonmak 04.12.2019 14456 изменил наименование справочника	
	Возврат ?(ТипЗнч(ИсполнительСсылка) = Тип("СправочникСсылка.Scan_Компании"),РегистрыСведений.Scan_ВзаимосвязьКомпанийСКонтрагентами.ПолучитьДилераПоКомпании(ИсполнительСсылка), ИсполнительСсылка); 
	//rarus bonmak 15.04.2020 14456 --
КонецФункции
//rarus tenkam 18.11.2017 mantis 9427 ---

//rarus tenkam 07.02.2018 mantis 12721 +++
&НаКлиенте
Процедура ТаблицаСервисныхОперацийПередНачаломИзменения(Элемент, Отказ)
	ТекСтрока = Элементы.ТаблицаСервисныхОпераций.ТекущиеДанные;
	ТипПоля = ТипСоставляющей(ТекСтрока.Составляющая);
	
	Элементы.ТаблицаСервисныхОперацийРезультатБыло.ВыбиратьТип = Ложь;
	Элементы.ТаблицаСервисныхОперацийРезультатБыло.ОграничениеТипа = ТипПоля;
	
	Элементы.ТаблицаСервисныхОперацийРезультатСтало.ВыбиратьТип = Ложь;
	Элементы.ТаблицаСервисныхОперацийРезультатСтало.ОграничениеТипа = ТипПоля;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТипСоставляющей(ТекСоставляющая) 
	
	Если ТекСоставляющая.Владелец = ПредопределенноеЗначение("Справочник.Scan_СервисныеОперации.ПроверитьУровеньЗаряженностиАккумуляторныхБатареи1") ИЛИ
		ТекСоставляющая.Владелец = ПредопределенноеЗначение("Справочник.Scan_СервисныеОперации.ПроверитьУровеньЗаряженностиАккумуляторныхБатареи2") Тогда
		Если ТекСоставляющая.Наименование = "Емкость" И (ТекСоставляющая.Код = "100000001"  ИЛИ ТекСоставляющая.Код = "200000001") Тогда 
			ТипПоля = Новый ОписаниеТипов("СправочникСсылка.Scan_ЕмкостиАКБ");     			
		Иначе
			ТипПоля = Новый ОписаниеТипов("Число");
		КонецЕсли;
	Иначе
		ТипПоля = Новый ОписаниеТипов("Строка");	 
	КонецЕсли;
	
	Возврат ТипПоля;
	
КонецФункции
//rarus tenkam 07.02.2018 mantis 12721 ---

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

//rarus vikhle 06.04.2021 mt 17484 +++
&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИсполнительОбработкаВыбораПродолжение",ЭтотОбъект,ВыбранноеЗначение); //rarus vikhle 15.04.2021 mt 17484
	Scan_ВспомогательныеФункцииКлиент.ПроверитьАктивностьВыбраннойКомпании(ВыбранноеЗначение,ОписаниеОповещения,СтандартнаяОбработка);
	
КонецПроцедуры
//rarus vikhle 06.04.2021 mt 17484 ---

//rarus vikhle 15.04.2021 mt 17484 +++
&НаКлиенте
Процедура ИсполнительОбработкаВыбораПродолжение(Результат, ВыбраннаяКомпания) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Исполнитель = ВыбраннаяКомпания;
	Иначе
		Объект.Исполнитель = Неопределено;	
	КонецЕсли;
	
	ИсполнительПриИзменении(Элементы.Исполнитель);
	
КонецПроцедуры

//rarus vikhle 15.04.2021 mt 17484 ---

#КонецОбласти
