///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("Служебный");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяИБ");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяСервиса");
	НеРедактируемыеРеквизиты.Добавить("СвойстваПользователяИБ");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ИСТИНА
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЭтоАвторизованныйПользователь(Ссылка)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульСозданиеНаОсновании = ОбщегоНазначения.ОбщийМодуль("СозданиеНаОсновании");
		Возврат МодульСозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Справочники.Пользователи);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
	
	Если НЕ Параметры.Отбор.Свойство("Служебный") Тогда
		Параметры.Отбор.Вставить("Служебный", Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы = "ФормаВыбора" ИЛИ Параметры.Свойство("РежимВыбора") Тогда
		
		ВыбраннаяФормаПоУмолчанию = ВыбраннаяФорма;
		ПользователиПереопределяемый.ПриОпределенииФормыВыбораПользователей(ВыбраннаяФорма, Параметры);
	    Если ВыбраннаяФормаПоУмолчанию <> ВыбраннаяФорма Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	СписокПользователей = ПользователиСлужебный.ПользователиДляВключенияВосстановленияПароля();
	
	Если СписокПользователей.Количество() > 0 Тогда
		ВключитьСтандартныеНастройкиВосстановленияПароля();
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, СписокПользователей);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	ПользовательСсылка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.Пользователи");
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	СписокОшибок = Новый Массив;
	
	Пока ПользовательСсылка.Следующий() Цикл
		Результат = ПользователиСлужебный.ОбновитьПочтуДляВосстановленияПароля(ПользовательСсылка.Ссылка);
		
		Если Результат.Статус = "Ошибка" Тогда
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			СписокОшибок.Добавить(Результат.ТекстОшибки);
		Иначе
			ОбъектовОбработано = ОбъектовОбработано + 1;
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ПользовательСсылка.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.Пользователи");
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось обработать некоторых пользователей (пропущены): %1
			|%2'"), ПроблемныхОбъектов, СтрСоединить(СписокОшибок, Символы.ПС));
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.Пользователи,,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию обработала очередную порцию пользователей: %1'"),
			ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

Процедура ВключитьСтандартныеНастройкиВосстановленияПароля()
	
	Настройки = ПользователиСлужебный.НастройкиВосстановленияПароля();
	
	Если Настройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Настройки.СпособВосстановленияПароля = ПользователиСлужебный.СпособВосстановленияПароляПользователяИнформационнойБазы("ОтправкаКодаПодтвержденияЧерезСтандартныйСервис");
	ПользователиСлужебный.УстановитьНастройкиВосстановленияПароля(Настройки);
	
КонецПроцедуры

// rarus agar 03.06.2021 16927 ++

// Функция записи параметров в регистр сведений
// Параметры
//  Пользователь - СправочникСсылка.Пользователи - Пользователь для которого за
//  Сотрудник   - СправочникСсылка.Scan_Сотрудники - Значение регистра сведений
//  Подразделение - СправочникСсылка.Scan_Подразделения - Значение регистра сведений
//  Организация   - СправочникСсылка.Организации - Значение регистра сведений
// Возвращаемое значение:
//   Булево   - ошибка записи значения
Функция ЗаписьЗначенияРегистраСведения(Сотрудник, Пользователь, Подразделение, Организация) Экспорт
	
	Отказ = Ложь;
	
	// возможны 2 случая:
	// 1 - поменялся какой-то из ресурсов - перезапишем запись по сотруднику
	// 2 - поменялся сотрудник - перезапишем запись по сотруднику, удалим запись со старым сотрудником
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_СведенияОСотрудниках.Сотрудник,
	               |	Scan_СведенияОСотрудниках.Пользователь,
	               |	Scan_СведенияОСотрудниках.Должность,
	               |	Scan_СведенияОСотрудниках.Подразделение,
	               |	Scan_СведенияОСотрудниках.Организация
	               |ИЗ
	               |	РегистрСведений.Scan_СведенияОСотрудниках КАК Scan_СведенияОСотрудниках
	               |ГДЕ
	               |	Scan_СведенияОСотрудниках.Пользователь = &ПользовательСсылка";
	Запрос.УстановитьПараметр("ПользовательСсылка", Пользователь);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		НаборЗаписей = РегистрыСведений.Scan_СведенияОСотрудниках.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Сотрудник.Установить(Выборка.Сотрудник);
		НаборЗаписей.Записать();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		НаборЗаписей = РегистрыСведений.Scan_СведенияОСотрудниках.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Сотрудник.Установить(Сотрудник);
		//НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
		НаборЗаписей.Прочитать();
		
		НоваяЗапись = НаборЗаписей.Добавить();
		
		НоваяЗапись.Сотрудник = Сотрудник;
		НоваяЗапись.Пользователь = Пользователь;
		НоваяЗапись.Должность = Сотрудник.Должность;
		НоваяЗапись.Подразделение = Подразделение;
		НоваяЗапись.Организация = Организация;
		
		// rarus agar 29.06.2021 АПК ++
		//НоваяЗапись.ПользовательАвтор = ПользователиКлиентСервер.ТекущийПользователь();
		НоваяЗапись.ПользовательАвтор = Пользователи.ТекущийПользователь();
		// rarus agar 29.06.2021 АПК --
		
		НаборЗаписей.Записать();
	КонецЕсли;
	Возврат Отказ;
КонецФункции // ЗаписьЗначенияРегистраСведения()
// rarus agar 03.06.2021 16927 --

#КонецОбласти

#КонецЕсли
