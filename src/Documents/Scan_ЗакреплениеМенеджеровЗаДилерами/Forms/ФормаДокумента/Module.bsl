#Область ОбработчикиСобытийФормы

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
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		// Параметры документа ++
		ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь() ;
		Объект.Организация = ТекущийПользователь.Организация;
		Объект.ПодразделениеКомпании = ТекущийПользователь.ПодразделениеОрганизации;
		Объект.Автор = ТекущийПользователь;
		Объект.Менеджер = ТекущийПользователь;
		Объект.Дата = ТекущаяДатаСеанса(); //Rarus bonmak 01.08.2022 18726 АПК было ТекущаяДата()
		Объект.ВалютаДокумента = Справочники.Валюты.НайтиПоКоду("643");
		//rarus vikhle 22.04.2020 mt 15695 +++	
		Scan_ВспомогательныеФункцииСервер.ЗаполнитьКомпаниюИКонтрагента(ТекущийПользователь,Объект.Компания,Объект.Контрагент);
		//rarus vikhle 22.04.2020 mt 15695 ---
		// Параметры документа --
		//rarus bonmak 07.01.2021 16625 ++
		Объект.ПодписантВПФ = Scan_ПраваИНастройки.Scan_Право("ПодписантПФДокументаЗакреплениеМенеджеровЗаДилерами");
		//rarus bonmak 07.01.2021 16625 --
	КонецЕсли;
	
	УправлениеДиалогомНаСервере();	
	Scan_СборСтатистики.Scan_ПриОткрытии("Документы", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	

КонецПроцедуры	

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Scan_ВспомогательныеФункцииКлиент.ПроверитьПользователяПортала();//rarus vikhle 07.05.2020 mt 15695 
	ОбновитьЗаголовокФормы();
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект); //rarus bonmak 07.01.2021 16625
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	// Вызываем общий обработчик события
	Scan_УправлениеДиалогомДокументаСервер.ПриСохраненииДанныхВНастройкахНаСервере(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	// Вызываем общий обработчик события
	Scan_УправлениеДиалогомДокументаСервер.ПриЗагрузкеДанныхИзНастроекНаСервере(ЭтотОбъект, Настройки);	
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

#Область СлужебныеПроцедурыИФункции

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
	УправлениеДиалогомНаСервере();
КонецПроцедуры // ХозОперацияПриИзменении()

&НаКлиенте
Процедура ОбновитьЗаголовокФормы()
	//Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
	//	Заголовок = Строка(Объект.Ссылка) + ". (" + Строка(Объект.ХозОперация)+ ")";
	//Иначе
	//	Заголовок = Строка(Объект.ХозОперация) + " (создание)";
	//КонецЕсли;
КонецПроцедуры

#КонецОбласти
// ХозОперации --

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
	Scan_УправлениеДиалогомДокументаКлиент.НастроитьПараметрыДокумента(ЭтотОбъект, ПараметрыДействия_НастроитьПараметрыДокумента());
КонецПроцедуры

// Обработчик события возникающего при нажатии программно добавленной кнопки.
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура Подключаемый_ОбработкаКомандыФормы(Команда) Экспорт
	// Определим структуру параметров обработки текущего события
	Если Команда.Имя="НастроитьПараметрыДокумента" Тогда
		ПараметрыДействия = ПараметрыДействия_НастроитьПараметрыДокумента();
	иначе
		ПараметрыДействия = Новый Структура;
	КонецЕсли;
	
	// Вызываем общий обработчик события
	Если НЕ Scan_УправлениеДиалогомДокументаКлиент.ОбработкаКомандыФормы(ЭтотОбъект, Команда, Объект, ЭтотОбъект.Окно, ПараметрыДействия) Тогда
		Возврат;
	КонецЕсли;
	УправлениеДиалогомНаСервере();
КонецПроцедуры // Подключаемый_ОбработкаКомандыФормы()

#КонецОбласти

#Область ВспомогательныеФункции


&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
КонецПроцедуры


&НаКлиенте
Функция ПараметрыДействия_НастроитьПараметрыДокумента()
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ЗапретитьИзменение_ВалютаДокумента", Истина);
	Возврат ПараметрыДействия;
КонецФункции

&НаСервере
Процедура ОтветственныеМенеджерыДилерПриИзмененииНаСервере()
	
	// Получим данные текущей строки табличной части
	ТекущиеДанные = Объект.ОтветственныеМенеджеры.НайтиПоИдентификатору(Элементы.ОтветственныеМенеджеры.ТекущаяСтрока);
	
	Если ТекущиеДанные.Дилер = Справочники.Scan_Компании.СканияРусь Тогда
	
	Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	Scan_Сотрудники.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Scan_Сотрудники КАК Scan_Сотрудники
			|ГДЕ
			|	Scan_Сотрудники.МенеджерСканияРусь = ИСТИНА
			|	И Scan_Сотрудники.ФлагУволен = ЛОЖЬ
			|	И Scan_Сотрудники.ПометкаУдаления = ЛОЖЬ";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() ТОгда
			ТекущиеДанные.Менеджер = ВыборкаДетальныеЗаписи.Ссылка;
		КонецЕсли;      
		
	КонецЕсли;
	
		
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныеМенеджерыДилерПриИзменении(Элемент)
	ОтветственныеМенеджерыДилерПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект) //rarus bonmak 07.01.2021 16625 ++
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры //rarus bonmak 07.01.2021 16625 --

//rarus vikhle 15.04.2021 mt 17484 +++
&НаКлиенте
Процедура ОтветственныеМенеджерыДилерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтветственныеМенеджерыДилерОбработкаВыбораПродолжение",ЭтотОбъект,ВыбранноеЗначение);
	// rarus agar 21.04.2021 17484 ++
	// Надо учитывать признак "Дилер", иначе нельзя выбрать просто компанию
	//Scan_ВспомогательныеФункцииКлиент.ПроверитьАктивностьВыбраннойКомпании(ВыбранноеЗначение,ОписаниеОповещения,СтандартнаяОбработка,Ложь);
	Scan_ВспомогательныеФункцииКлиент.ПроверитьАктивностьВыбраннойКомпании(ВыбранноеЗначение,ОписаниеОповещения,СтандартнаяОбработка);
	// rarus agar 21.04.2021 17484 --
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныеМенеджерыДилерОбработкаВыбораПродолжение(Результат, ВыбраннаяКомпания) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Элементы.ОтветственныеМенеджеры.ТекущиеДанные.Дилер = ВыбраннаяКомпания;
		ОтветственныеМенеджерыДилерПриИзменении(Элементы.ОтветственныеМенеджерыДилер);	
	Иначе
		Элементы.ОтветственныеМенеджеры.ТекущиеДанные.Дилер = Неопределено;	
	КонецЕсли;
	
КонецПроцедуры	
//rarus vikhle 15.04.2021 mt 17484 ---

#КонецОбласти
