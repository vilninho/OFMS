#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// Вызываем общий обработчик события
	Если Не Scan_УправлениеДиалогомДокументаСервер.ПриСозданииНаСервере(ЭтотОбъект, Параметры, Отказ, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьПараметрыДокумента();
		
		//rarus agar 20.02.2021 17230 ++
		ТребованияСсылка = Scan_ПраваИНастройки.Scan_Право("ТребованияПоОформлениюЗапросаНаНадстройки");
		Если ЗначениеЗаполнено(ТребованияСсылка) Тогда
			ТекстТребований = ТребованияСсылка.ТекстТребований.Получить();
		КонецЕсли;
		//rarus agar 20.02.2021 17230 --
	КонецЕсли;
	
	Если  Объект.Ссылка.Пустая()
		И Параметры.Свойство("ЗаказыНаЗавод")
		Тогда
		ЗаполнитьСоставЗапроса(Параметры);
	КонецЕсли;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ЗаполнитьЗаказыНаЗакупку();
	КонецЕсли;
	
	УправлениеДиалогомНаСервере();
	Scan_СборСтатистики.Scan_ПриОткрытии("Документы", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	

КонецПроцедуры

// Обработчик события возникающего на сервере при сохранении значений реквизитов и настроек формы.
//
// Параметры:
//  Настройки - Соответствие - Значения сохраняемых реквизитов и настроек формы.
//
&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	// Вызываем общий обработчик события
	Scan_УправлениеДиалогомДокументаСервер.ПриСохраненииДанныхВНастройкахНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

// Обработчик события возникающего на сервере при восстановлении значений реквизитов из сохраненных настроек формы.
//
// Параметры:
//  Настройки - Соответствие - Значения сохраненных реквизитов и настроек формы.
//
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Вызываем общий обработчик события
	Scan_УправлениеДиалогомДокументаСервер.ПриЗагрузкеДанныхИзНастроекНаСервере(ЭтотОбъект, Настройки);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьЗаказаНаЗакупку" Тогда
		ЗаполнитьЗаказыНаЗакупку();
	КонецЕсли;
	
КонецПроцедуры

//rarus agar 20.02.2021 17230 ++
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТребованияСсылка = Scan_ПраваИНастройки.Scan_Право("ТребованияПоОформлениюЗапросаНаНадстройки");
	Если ЗначениеЗаполнено(ТребованияСсылка) Тогда
		ТекстТребований = ТребованияСсылка.ТекстТребований.Получить();
	КонецЕсли;
	
КонецПроцедуры
//rarus agar 20.02.2021 17230 --

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Rarus tenkam 11.04.2022 mantis 18433 +++
	Если Объект.Ссылка.Пустая() Тогда
		Scan_СборСтатистики.Scan_ПередЗаписьюДокумента(РеквизитФормыВЗначение("Объект").Метаданные().Синоним, Истина, "Создание нового элемента");
	КонецЕсли;
	// Rarus tenkam 11.04.2022 mantis 18433 --- 
КонецПроцедуры

#КонецОбласти

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

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СоглашениеОПоставкеПриИзменении(Элемент)
	
	СоглашениеОПоставкеПриИзмененииНаСервере();
	
КонецПроцедуры

//rarus vikhle 15.04.2021 mt 17484 +++
&НаКлиенте
Процедура ПоставщикОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоставщикОбработкаВыбораПродолжение",ЭтотОбъект,ВыбранноеЗначение);
	// rarus agar 21.04.2021 17484 ++
	// Надо учитывать признак "Дилер", иначе нельзя выбрать просто компанию
	//Scan_ВспомогательныеФункцииКлиент.ПроверитьАктивностьВыбраннойКомпании(ВыбранноеЗначение,ОписаниеОповещения,СтандартнаяОбработка,Ложь);
	Scan_ВспомогательныеФункцииКлиент.ПроверитьАктивностьВыбраннойКомпании(ВыбранноеЗначение,ОписаниеОповещения,СтандартнаяОбработка);
	// rarus agar 21.04.2021 17484 --
	
КонецПроцедуры
//rarus vikhle 15.04.2021 mt 17484 ---

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

&НаКлиенте
Процедура ТоварыУслугиРаботыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТоварыУслугиРаботыЗаполнитьНовуюСтрокуНаСервере(Элементы.ТоварыУслугиРаботы.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУслугиРаботыНомераЗаказовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИдентификаторСтроки", Элементы.ТоварыУслугиРаботы.ТекущаяСтрока);
	
	Обработчик = Новый ОписаниеОповещения("ЗаполнитьНомераЗаказовВСтроке", ЭтотОбъект, ДополнительныеПараметры);
	
	СписокНомеровЗаказов = Новый СписокЗначений;
	МассивНомеровЗаказов = СтрРазделить(Элементы.ТоварыУслугиРаботы.ТекущиеДанные.НомераЗаказов, ",", Ложь);
	Для Каждого НомерЗаказа Из МассивНомеровЗаказов Цикл
		СписокНомеровЗаказов.Добавить(НомерЗаказа);
	КонецЦикла;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("НомераЗаказов", СписокНомеровЗаказов);
	
	ОткрытьФорму("Документ.Scan_ЗапросНаНадстройки.Форма.ФормаВводаНомеровЗаказов", ПараметрыОткрытия, ЭтотОбъект,,,, Обработчик, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

//rarus vikhle 15.04.2021 mt 17484 +++
&НаКлиенте
Процедура ТоварыУслугиРаботыДилерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ТоварыУслугиРаботыДилерОбработкаВыбораПродолжение",ЭтотОбъект,ВыбранноеЗначение);
	Scan_ВспомогательныеФункцииКлиент.ПроверитьАктивностьВыбраннойКомпании(ВыбранноеЗначение,ОписаниеОповещения,СтандартнаяОбработка,Ложь);
	
КонецПроцедуры
//rarus vikhle 15.04.2021 mt 17484 ---

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПараметрыДокумента()
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Объект.Автор                 = ТекущийПользователь;
	Объект.ВалютаДокумента       = Справочники.Валюты.НайтиПоКоду("643");
	Объект.ДатаСоздания          = ТекущаяДата();
	Объект.Дата                  = ТекущаяДата();
	Объект.Менеджер              = ТекущийПользователь;
	Объект.Организация           = ТекущийПользователь.Организация;
	Объект.ПодразделениеКомпании = ТекущийПользователь.ПодразделениеОрганизации;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	// Вызываем общий обработчик события настройки параметров выбора
	Scan_УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры // НастроитьПараметрыВыбораЭлементовФормы()

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	
	
КонецПроцедуры

&НаСервере
Процедура ТоварыУслугиРаботыЗаполнитьНовуюСтрокуНаСервере(ИдентификаторСтроки)
	
	СтрокаТаблицы = Объект.ТоварыУслугиРаботы.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если СтрокаТаблицы <> Неопределено Тогда
		// rarus agar 01.04.2021 17545 ++
		СтрокаТаблицы.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
		// rarus agar 01.04.2021 17545 --
		
		Если СтрокаТаблицы.Количество = 0 Тогда
			СтрокаТаблицы.Количество = 1;
		КонецЕсли;
		Если СтрокаТаблицы.Валюта.Пустая() Тогда
			СтрокаТаблицы.Валюта = Объект.ВалютаДокумента;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.СоглашениеОПоставке) Тогда
			Возврат;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СоглашениеОПоставке", Объект.СоглашениеОПоставке);
		Запрос.Текст = "ВЫБРАТЬ
		|	Scan_СоглашенияОПоставке.Дилер КАК Дилер
		|ИЗ
		|	Справочник.Scan_СоглашенияОПоставке КАК Scan_СоглашенияОПоставке
		|ГДЕ
		|	Scan_СоглашенияОПоставке.Ссылка = &СоглашениеОПоставке
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Scan_ВзаимосвязьИзделийИЗаказовСрезПоследних.ЗаказНаЗавод КАК ЗаказНаЗавод
		|ИЗ
		|	РегистрСведений.Scan_ВзаимосвязьИзделийИЗаказов.СрезПоследних(
		|			,
		|			Изделие В
		|				(ВЫБРАТЬ
		|					Справочник.Scan_СоглашенияОПоставке.СписокПродуктов.Продукт
		|				ИЗ
		|					Справочник.Scan_СоглашенияОПоставке.СписокПродуктов
		|				ГДЕ
		|					Справочник.Scan_СоглашенияОПоставке.СписокПродуктов.Ссылка = &СоглашениеОПоставке)) КАК Scan_ВзаимосвязьИзделийИЗаказовСрезПоследних";
		РезультатыЗапроса = Запрос.ВыполнитьПакет();
		
		Если СтрокаТаблицы.Дилер.Пустая() Тогда
			Если Не РезультатыЗапроса[0].Пустой() Тогда
				Выборка = РезультатыЗапроса[0].Выбрать();
				Выборка.Следующий();
				
				СтрокаТаблицы.Дилер = Выборка.Дилер;
			КонецЕсли;
		КонецЕсли;
		
		Если ПустаяСтрока(СтрокаТаблицы.НомераЗаказов) Тогда
			Если Не РезультатыЗапроса[1].Пустой() Тогда
				ТаблицаРезультата = РезультатыЗапроса[1].Выгрузить();
				
				СтрокаТаблицы.НомераЗаказов = СтрСоединить(ТаблицаРезультата.ВыгрузитьКолонку("ЗаказНаЗавод"), ",");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНомераЗаказовВСтроке(АдресНомеровЗаказов, ДополнительныеПараметры) Экспорт
	
	Попытка
		ВыбранныеНомераЗаказов = ПолучитьИзВременногоХранилища(АдресНомеровЗаказов);
	Исключение
		Возврат;
	КонецПопытки;
	
	СтрокаТаблицы = Объект.ТоварыУслугиРаботы.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
	СтрокаТаблицы.НомераЗаказов = СтрСоединить(ВыбранныеНомераЗаказов, ",");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСоставЗапроса(ПараметрыЗаполнения)
	
	ГруппироватьЗаказы = Ложь;
	
	Если ПараметрыЗаполнения.Свойство("ГруппироватьЗаказы") Тогда 
		ГруппироватьЗаказы = ПараметрыЗаполнения.ГруппироватьЗаказы;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗаказыНаЗавод", ПараметрыЗаполнения.ЗаказыНаЗавод);
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Scan_ЗаказыНаЗавод.Наименование КАК НомерЗаказа
	|ИЗ
	|	Справочник.Scan_ЗаказыНаЗавод КАК Scan_ЗаказыНаЗавод
	|ГДЕ
	|	Scan_ЗаказыНаЗавод.Ссылка В(&ЗаказыНаЗавод)";
	РезультатЗапроса = Запрос.Выполнить();
	
	НомераЗаказовНаЗавод = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("НомерЗаказа");
	
	Если ГруппироватьЗаказы Тогда
		НоваяСтрока = Объект.ТоварыУслугиРаботы.Добавить();
		НоваяСтрока.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор); // rarus agar 01.04.2021 17545 +-
		НоваяСтрока.Количество          = НомераЗаказовНаЗавод.Количество();
		НоваяСтрока.НомераЗаказов       = СтрСоединить(НомераЗаказовНаЗавод, ",");
	Иначе
		Для Каждого НомерЗаказаНаЗавод Из НомераЗаказовНаЗавод Цикл
			НоваяСтрока = Объект.ТоварыУслугиРаботы.Добавить();
			НоваяСтрока.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор); // rarus agar 01.04.2021 17545 +-
			НоваяСтрока.Количество          = 1;
			НоваяСтрока.НомераЗаказов       = НомерЗаказаНаЗавод;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗаказыНаЗакупку()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗапросНаНадстройки", Объект.Ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	|	Scan_ЗаказНаЗакупку.Ссылка КАК ЗаказНаЗакупку,
	|	Scan_ЗаказНаЗакупку.Поставщик КАК Поставщик
	|ИЗ
	|	Документ.Scan_ЗаказНаЗакупку КАК Scan_ЗаказНаЗакупку
	|ГДЕ
	|	Scan_ЗаказНаЗакупку.ДокументОснование = &ЗапросНаНадстройки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЗаказыНаЗакупку.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура СоглашениеОПоставкеПриИзмененииНаСервере()
	
	Если Объект.СоглашениеОПоставке.Пустая() Тогда
		Объект.Поставщик = Неопределено;
		Возврат;
	КонецЕсли;
	
	ВидВзаимодействияПоставщик = Scan_ПраваИНастройки.Scan_Право("ВидВзаимодействияПоставщик");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Компания",                   Объект.СоглашениеОПоставке.Кузовостроитель);
	Запрос.УстановитьПараметр("ВидВзаимодействияПоставщик", ВидВзаимодействияПоставщик);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	Scan_ВзаимосвязьКомпанийСКонтрагентами.Контрагент КАК Контрагент
	|ИЗ
	|	РегистрСведений.Scan_ВзаимосвязьКомпанийСКонтрагентами КАК Scan_ВзаимосвязьКомпанийСКонтрагентами
	|ГДЕ
	|	Scan_ВзаимосвязьКомпанийСКонтрагентами.Компания = &Компания
	|	И Scan_ВзаимосвязьКомпанийСКонтрагентами.ВидВзаимодействия = &ВидВзаимодействияПоставщик";
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Объект.Поставщик = Выборка.Контрагент;
	
	Для Каждого СтрокаСостава Из Объект.ТоварыУслугиРаботы Цикл
		ТоварыУслугиРаботыЗаполнитьНовуюСтрокуНаСервере(СтрокаСостава.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

//rarus vikhle 15.04.2021 mt 17484 +++
&НаКлиенте
Процедура ПоставщикОбработкаВыбораПродолжение(Результат, ВыбраннаяКомпания) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Поставщик = ВыбраннаяКомпания;
	Иначе
		Объект.Поставщик = Неопределено;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУслугиРаботыДилерОбработкаВыбораПродолжение(Результат, ВыбраннаяКомпания) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Элементы.ТоварыУслугиРаботы.ТекущиеДанные.Дилер = ВыбраннаяКомпания;
	Иначе
		Элементы.ТоварыУслугиРаботы.ТекущиеДанные.Дилер = Неопределено;	
	КонецЕсли;
	
КонецПроцедуры

//rarus vikhle 15.04.2021 mt 17484 ---

#КонецОбласти
