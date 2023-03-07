// rarus tenkam 05.08.2020 mantis 16181 +++

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
		
		Scan_ВспомогательныеФункцииСервер.ЗаполнитьКомпаниюИКонтрагента(ТекущийПользователь,Объект.Компания,Объект.Контрагент);
		// Параметры документа --
		
		Если НЕ ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
			Объект.ХозОперация = Справочники.Scan_ХозяйственныеОперации.УстановкаПлановыхЦенПродуктов;
		КонецЕсли;
		ТаблицаРучныхСоставляющих.Загрузить(Документы.Scan_УстановкаПлановыхЦенПродукта.ПолучитьТаблицуРучныхСоставляющихСкидкиНаценки(,Объект.ДокументОснование));
	Иначе 	
		ТаблицаРучныхСоставляющих.Загрузить(Документы.Scan_УстановкаПлановыхЦенПродукта.ПолучитьТаблицуРучныхСоставляющихСкидкиНаценки(,Объект.Ссылка));
	КонецЕсли;
	Scan_СборСтатистики.Scan_ПриОткрытии("Документы", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	

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

// Обработчик события возникающего на клиенте при изменении данных реквизита "Хоз. операция".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура ХозОперацияПриИзменении(Команда)                                                                                         
	// Вызываем общий обработчик события выбора одного из пунктов меню доступных хоз. операций
	Scan_УправлениеДиалогомДокументаКлиент.ОбработатьВыборХозОперации(Объект, Элементы, Команда.Имя);
	
	// Обработаем событие в контексте сервера
	НастроитьПараметрыВыбораЭлементовФормы();

	ОбновитьЗаголовокФормы();
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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

&НаКлиенте
Процедура ОбновитьЗаголовокФормы()
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 %2 от %3'; en = '%1 %2 dated %3'"),
		Объект.ХозОперация, Объект.Номер, Объект.Дата);
	Иначе
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (создание)'; en = '%1 (new)'"),
		Объект.ХозОперация);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

//////////////////////////////////////////////////////////////////////////////
//// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ

#Область ОбработчикиСобытийРеквизитов

&НаКлиенте
Процедура СкидкиНаценкиЦенаСНДСПриИзменении(Элемент)
	ТекДанные = Элементы.СкидкиНаценки.ТекущиеДанные;
	Если Текданные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗначениеСтавки = ПолучитьСтавкуНДС(ТекДанные.СтавкаНДС);	
	
	ПараметрыОтбора = Новый Структура("СоставляющаяЦены", ТекДанные.СоставляющаяЦены); 
	СтрокиСоставляющей = ТаблицаРучныхСоставляющих.НайтиСтроки(ПараметрыОтбора);
	Если СтрокиСоставляющей.Количество() <> 0 Тогда
		СтрокаСоставляющей = СтрокиСоставляющей[0];
		СтрокаСоставляющей.ЦенаСНДС = ТекДанные.ЦенаСНДС;
		Если ТекДанные.СоставляющаяЦены = ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.ПроцентДрайва") Тогда
			СтрокаСоставляющей.ЦенаБезНДС = ТекДанные.ЦенаСНДС;	
		Иначе
			СтрокаСоставляющей.ЦенаБезНДС = 100 * ТекДанные.ЦенаСНДС / (100 + ЗначениеСтавки);
		КонецЕсли;
		СтрокаСоставляющей.Пользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
		СтрокаСоставляющей.Источник = Неопределено; 
		
		ОбновитьЦены(); 		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СкидкиНаценкиЦенаБезНДСПриИзменении(Элемент)
	ТекДанные = Элементы.СкидкиНаценки.ТекущиеДанные;
	Если Текданные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗначениеСтавки = ПолучитьСтавкуНДС(ТекДанные.СтавкаНДС);	
	
	ПараметрыОтбора = Новый Структура("СоставляющаяЦены", ТекДанные.СоставляющаяЦены); 
	СтрокиСоставляющей = ТаблицаРучныхСоставляющих.НайтиСтроки(ПараметрыОтбора);
	Если СтрокиСоставляющей.Количество() <> 0 Тогда
		СтрокаСоставляющей = СтрокиСоставляющей[0];
		СтрокаСоставляющей.ЦенаБезНДС = ТекДанные.ЦенаБезНДС;
		Если ТекДанные.СоставляющаяЦены = ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.ПроцентДрайва") Тогда
			СтрокаСоставляющей.ЦенаСНДС = ТекДанные.ЦенаБезНДС;	
		Иначе
			СтрокаСоставляющей.ЦенаСНДС = ТекДанные.ЦенаБезНДС * ЗначениеСтавки / 100;
		КонецЕсли;
		СтрокаСоставляющей.Пользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
		СтрокаСоставляющей.Источник = Неопределено; 
		
		ОбновитьЦены(); 		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СкидкиНаценкиСтавкаНДСПриИзменении(Элемент)
	ТекДанные = Элементы.СкидкиНаценки.ТекущиеДанные;
	Если Текданные = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ПараметрыОтбора = Новый Структура("СоставляющаяЦены", ТекДанные.СоставляющаяЦены); 
	СтрокиСоставляющей = ТаблицаРучныхСоставляющих.НайтиСтроки(ПараметрыОтбора);
	Если СтрокиСоставляющей.Количество() <> 0 Тогда
		СтрокаСоставляющей = СтрокиСоставляющей[0];
		СтрокаСоставляющей.СтавкаНДС = ТекДанные.СтавкаНДС;
		ЗначениеСтавки = ПолучитьСтавкуНДС(ТекДанные.СтавкаНДС);	
		СтрокаСоставляющей.ЦенаСНДС = ТекДанные.ЦенаСНДС;
		Если ТекДанные.СоставляющаяЦены = ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.ПроцентДрайва") Тогда
			СтрокаСоставляющей.ЦенаБезНДС = ТекДанные.ЦенаСНДС;	
		Иначе
			СтрокаСоставляющей.ЦенаБезНДС = 100 * ТекДанные.ЦенаСНДС / (100 + ЗначениеСтавки);
		КонецЕсли;
		СтрокаСоставляющей.Пользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
		СтрокаСоставляющей.Источник = Неопределено; 
		
		ОбновитьЦены(); 		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СкидкиНаценкиПриАктивизацииЯчейки(Элемент)
	ТекДанные = Элементы.СкидкиНаценки.ТекущиеДанные;
	Если Текданные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Элемент.ТекущийЭлемент.Имя = "СкидкиНаценкиЦенаСНДС" ИЛИ
		Элемент.ТекущийЭлемент.Имя = "СкидкиНаценкиЦенаБезНДС" ИЛИ
		Элемент.ТекущийЭлемент.Имя = "СкидкиНаценкиСтавкаНДС" Тогда
		
		Если ТекДанные.СоставляющаяЦены = ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.ПроцентДрайва") ИЛИ
			ТекДанные.СоставляющаяЦены = ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.ЦенаДилера") ИЛИ          		
			ТекДанные.СоставляющаяЦены = ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.ЦенаКлиента") ИЛИ          		
			ТекДанные.СоставляющаяЦены = ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.СУRetailPrice") ИЛИ 		
			ТекДанные.СоставляющаяЦены = ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.СУDealerNet") ИЛИ           		
			ТекДанные.СоставляющаяЦены = ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.Компенсация") ИЛИ          		
			ТекДанные.СоставляющаяЦены = ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.ЛогистическиеЗатраты") ИЛИ
			ТекДанные.СоставляющаяЦены = ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.ИзменениеСпецификацииПоИнициативеЗавода") ИЛИ	// rarus tenkam 16.04.2021 mantis 17648 +
			ТекДанные.СоставляющаяЦены = ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.ЦенаПоВалютнойОговорке") Тогда	// rarus tenkam 01.04.2021 mantis 17419 +
			Элемент.ТекущийЭлемент.ТолькоПросмотр = Ложь;
		Иначе
			Элемент.ТекущийЭлемент.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

//////////////////////////////////////////////////////////////////////////////
//// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ

#Область ВспомогательныеФункции

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) ИЛИ НЕ Объект.Проведен Тогда
		Элементы.СкидкиНаценки.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.СкидкиНаценки.ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтавкуНДС(СтавкаНДС)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтавкаНДС,"Ставка");	
КонецФункции

&НаСервере
Процедура ОбновитьЦены()
	ТЗРучныхСоставляющих = ДанныеФормыВЗначение(ТаблицаРучныхСоставляющих,Тип("ТаблицаЗначений"));
	ТаблицаСоставляющих = Документы.Scan_УстановкаПлановыхЦенПродукта.РассчитатьПолнуюТаблицуСоставляющих(ТЗРучныхСоставляющих);
	
	Объект.СкидкиНаценки.Очистить();
	Для Каждого ТекСоставляющая Из ТаблицаСоставляющих Цикл
		Если ЗначениеЗаполнено(ТекСоставляющая.ЦенаСНДС) Тогда
			
			НоваяСтрока = Объект.СкидкиНаценки.Добавить();
			НоваяСтрока.СоставляющаяЦены = ТекСоставляющая.СоставляющаяЦены;
			НоваяСтрока.ЦенаСНДС = ТекСоставляющая.ЦенаСНДС;
			НоваяСтрока.ЦенаБезНДС = ТекСоставляющая.ЦенаБезНДС;
			НоваяСтрока.СтавкаНДС = ТекСоставляющая.СтавкаНДС;
			НоваяСтрока.Пользователь = ТекСоставляющая.Пользователь;
			НоваяСтрока.Источник = ТекСоставляющая.Источник;
			НоваяСтрока.Комментарий = ТекСоставляющая.Комментарий;	// rarus tenkam 16.04.2021 mantis 17648 +
		
		КонецЕсли;
	КонецЦикла;
	
	НайденнаяСтрока = ТаблицаСоставляющих.Найти(ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.ЦенаDealerNetСоСкидкой"), "СоставляющаяЦены");
	Если НайденнаяСтрока <> Неопределено Тогда
		Объект.ЦенаDealerNetСоСкидкой = НайденнаяСтрока.ЦенаСНДС;
	КонецЕсли;
	
	НайденнаяСтрока = ТаблицаСоставляющих.Найти(ПредопределенноеЗначение("Справочник.Scan_СоставляющиеРасчетаЦеныПродуктов.ЦенаRetailPriceСоСкидкой"), "СоставляющаяЦены");
	Если НайденнаяСтрока <> Неопределено Тогда
		Объект.ЦенаRetailPriceСоСкидкой = НайденнаяСтрока.ЦенаСНДС;
	КонецЕсли;  
	
КонецПроцедуры
#КонецОбласти

//////////////////////////////////////////////////////////////////////////////
//// ОБРАБОТЧИКИ КОМАНД ФОРМЫ


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Scan_ВспомогательныеФункцииКлиент.ПроверитьПользователяПортала();
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбновитьЗаголовокФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОбновитьЗаголовокФормы();
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

// rarus tenkam 05.08.2020 mantis 16181 ---