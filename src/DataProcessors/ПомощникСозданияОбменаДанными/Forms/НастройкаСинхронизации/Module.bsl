///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	ИнициализироватьРеквизитыФормы();
	
	ИнициализироватьСвойстваФормы();
	
	УстановитьНачальноеОтображениеЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьТаблицуЭтаповНастройки();
	ОбновитьОтображениеТекущегоСостоянияНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаСуществует   = Ложь;
	НастройкаЗавершена = Ложь;
	
	Если ЗначениеЗаполнено(УзелОбмена) Тогда
		НастройкаЗавершена = НастройкаСинхронизацииЗавершена(УзелОбмена, СсылкаСуществует);
		Если Не СсылкаСуществует Тогда
			// Закрытие формы при удалении настройки синхронизации.
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(УзелОбмена)
		Или Не НастройкаЗавершена
		Или (НастройкаРИБ И Не ПродолжениеНастройкиВПодчиненномУзлеРИБ И Не НачальныйОбразСоздан(УзелОбмена))Тогда
		ТекстПредупреждения = НСтр("ru = 'Настройка синхронизации данных еще не завершена.
		|Завершить работу с помощником? Настройку можно будет продолжить позже.'");
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
			ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, "ЗакрытьФормуБезусловно");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		Оповестить("ЗакрытаФормаПомощникаСозданияОбменаДанными");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодробноеОписаниеСинхронизацииДанных(Команда)
	
	ОбменДаннымиКлиент.ОткрытьПодробноеОписаниеСинхронизации(ОписаниеВариантаНастройки.ПодробнаяИнформацияПоОбмену);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПараметрыПодключения(Команда)
	
	Если ЭтоОбменСПриложениемВСервисе
		И (Не НастройкаНовойСинхронизации
			Или Не ТекущийЭтапНастройки = "НастройкаПодключения") Тогда
		СтрокаПредупреждение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Настройка подключения к ""%1"" уже выполнена.
			|Редактирование параметров подключения не предусмотрено.'"), УзелОбмена);
		ПоказатьПредупреждение(, СтрокаПредупреждение);
		Возврат;
	КонецЕсли;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("НастроитьПараметрыПодключенияЗавершение", ЭтотОбъект);
	
	Если ОбменДаннымиСВнешнейСистемой Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОбменДаннымиСВнешнимиСистемами") Тогда
			Контекст = Новый Структура;
			Контекст.Вставить("ИдентификаторНастройки", ИдентификаторНастройки);
			Контекст.Вставить("ПараметрыПодключения", ПараметрыПодключенияВнешнейСистемы);
			Контекст.Вставить("Корреспондент", УзелОбмена);
			
			Если НастройкаНовойСинхронизации
				И ТекущийЭтапНастройки = "НастройкаПодключения" Тогда
				Контекст.Вставить("Режим", "НовоеПодключение");
			Иначе
				Контекст.Вставить("Режим", "РедактированиеПараметровПодключения");
			КонецЕсли;
			
			Отказ = Ложь;
			ИмяФормыПомощника  = "";
			ПараметрыПомощника = Новый Структура;
			
			МодульОбменДаннымиСВнешнимиСистемамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиСВнешнимиСистемамиКлиент");
			МодульОбменДаннымиСВнешнимиСистемамиКлиент.ПередНастройкойПараметровПодключения(
				Контекст, Отказ, ИмяФормыПомощника, ПараметрыПомощника);
			
			Если Не Отказ Тогда
				ОткрытьФорму(ИмяФормыПомощника,
					ПараметрыПомощника, ЭтотОбъект, , , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			КонецЕсли;
		КонецЕсли;
		Возврат;
	ИначеЕсли ТекущийЭтапНастройки = "НастройкаПодключения" Тогда
		ПараметрыПомощника = Новый Структура;
		ПараметрыПомощника.Вставить("ИмяПланаОбмена",         ИмяПланаОбмена);
		ПараметрыПомощника.Вставить("ИдентификаторНастройки", ИдентификаторНастройки);
		Если ПродолжениеНастройкиВПодчиненномУзлеРИБ Тогда
			ПараметрыПомощника.Вставить("ПродолжениеНастройкиВПодчиненномУзлеРИБ");
		КонецЕсли;
		
		ОткрытьФорму("Обработка.ПомощникСозданияОбменаДанными.Форма.НастройкаПодключения",
			ПараметрыПомощника, ЭтотОбъект, , , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		Отбор              = Новый Структура("Корреспондент", УзелОбмена);
		ЗначенияЗаполнения = Новый Структура("Корреспондент", УзелОбмена);
		
		ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор,
			ЗначенияЗаполнения, "НастройкиТранспортаОбменаДанными", ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьПодтверждениеПодключения(Команда)
	
	Если Не ОбменДаннымиСВнешнейСистемой
		Или ПолученыНастройкиXDTOКорреспондента(УзелОбмена) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Подключение подтверждено.'"));
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОбменДаннымиСВнешнимиСистемами") Тогда
		Контекст = Новый Структура;
		Контекст.Вставить("Режим",                  "ПодтверждениеПодключения");
		Контекст.Вставить("Корреспондент",          УзелОбмена);
		Контекст.Вставить("ИдентификаторНастройки", "ИдентификаторНастройки");
		Контекст.Вставить("ПараметрыПодключения",   ПараметрыПодключенияВнешнейСистемы);
		
		Отказ = Ложь;
		ИмяФормыПомощника  = "";
		ПараметрыПомощника = Новый Структура;
		
		МодульОбменДаннымиСВнешнимиСистемамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиСВнешнимиСистемамиКлиент");
		МодульОбменДаннымиСВнешнимиСистемамиКлиент.ПередНастройкойПараметровПодключения(
			Контекст, Отказ, ИмяФормыПомощника, ПараметрыПомощника);
		
		Если Не Отказ Тогда
			ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПолучитьПодтверждениеПодключенияЗавершение", ЭтотОбъект);
			ОткрытьФорму(ИмяФормыПомощника,
				ПараметрыПомощника, ЭтотОбъект, , , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПравилаОтправкиИПолученияДанных(Команда)
	
	ОповещениеПродолжения = Новый ОписаниеОповещения("НастроитьПравилаОтправкиИПолученияДанныхПродолжение", ЭтотОбъект);
	
	// Для плана обмена XDTO перед настройкой правил выгрузки и загрузки
	// должны быть получены настройки корреспондента.
	Если НастройкаXDTO Тогда
		ПрерватьНастройку = Ложь;
		ВыполнитьЗагрузкуНастроекXDTOПриНеобходимости(ПрерватьНастройку, ОповещениеПродолжения);
		
		Если ПрерватьНастройку Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ПродолжитьНастройку",            Истина);
	Результат.Вставить("ПолученыДанныеДляСопоставления", ПолученыДанныеДляСопоставления);
	
	ВыполнитьОбработкуОповещения(ОповещениеПродолжения, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНачальныйОбразРИБ(Команда)
	
	ПараметрыПомощника = Новый Структура("Ключ, Узел", УзелОбмена, УзелОбмена);
			
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("СоздатьНачальныйОбразРИБЗавершение", ЭтотОбъект);
	ОткрытьФорму(ИмяФормыСозданияНачальногоОбраза,
		ПараметрыПомощника, ЭтотОбъект, , , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСопоставлениеИЗагрузкуДанных(Команда)
	
	ОповещениеПродолжения = Новый ОписаниеОповещения("ВыполнитьСопоставлениеИЗагрузкуДанныхПродолжение", ЭтотОбъект);
	
	ПараметрыПомощника = Новый Структура;
	ПараметрыПомощника.Вставить("ОтправитьДанные",     Ложь);
	ПараметрыПомощника.Вставить("НастройкаРасписания", Ложь);
	
	Если ЭтоОбменСПриложениемВСервисе Тогда
		ПараметрыПомощника.Вставить("ОбластьДанныхКорреспондента", ОбластьДанныхКорреспондента);
	КонецЕсли;
	
	ВспомогательныеПараметры = Новый Структура;
	ВспомогательныеПараметры.Вставить("ПараметрыПомощника",  ПараметрыПомощника);
	ВспомогательныеПараметры.Вставить("ОповещениеОЗакрытии", ОповещениеПродолжения);
	
	ОбменДаннымиКлиент.ОткрытьПомощникСопоставленияОбъектовОбработкаКоманды(УзелОбмена,
		ЭтотОбъект, ВспомогательныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНачальнуюВыгрузкуДанных(Команда)
	
	ПараметрыПомощника = Новый Структура;
	ПараметрыПомощника.Вставить("УзелОбмена", УзелОбмена);
	ПараметрыПомощника.Вставить("НачальнаяВыгрузка");
	
	Если МодельСервиса Тогда
		ПараметрыПомощника.Вставить("ЭтоОбменСПриложениемВСервисе", ЭтоОбменСПриложениемВСервисе);
		ПараметрыПомощника.Вставить("ОбластьДанныхКорреспондента",  ОбластьДанныхКорреспондента);
	КонецЕсли;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыполнитьНачальнуюВыгрузкуДанныхЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.ПомощникИнтерактивногоОбменаДанными.Форма.ВыгрузкаДанныхДляСопоставления",
		ПараметрыПомощника, ЭтотОбъект, , , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция СостояниеНастройкиСинхронизации(УзелОбмена)
	
	Результат = Новый Структура;
	Результат.Вставить("НастройкаСинхронизацииЗавершена",           НастройкаСинхронизацииЗавершена(УзелОбмена));
	Результат.Вставить("НачальныйОбразСоздан",                      НачальныйОбразСоздан(УзелОбмена));
	Результат.Вставить("ПолученоСообщениеСДаннымиДляСопоставления", ОбменДаннымиСервер.ПолученоСообщениеСДаннымиДляСопоставления(УзелОбмена));
	Результат.Вставить("ПолученыНастройкиXDTOКорреспондента",       ПолученыНастройкиXDTOКорреспондента(УзелОбмена));
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолученыНастройкиXDTOКорреспондента(УзелОбмена)
	
	НастройкиКорреспондента = ОбменДаннымиXDTOСервер.ПоддерживаемыеОбъектыФорматаКорреспондента(УзелОбмена, "ОтправкаПолучение");
	
	Возврат НастройкиКорреспондента.Количество() > 0;
	
КонецФункции

&НаСервереБезКонтекста
Функция НачальныйОбразСоздан(УзелОбмена)
	
	Возврат РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.НачальныйОбразСоздан(УзелОбмена);
	
КонецФункции

&НаКлиенте
Процедура НастроитьПараметрыПодключенияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено
		И ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		
		Если РезультатЗакрытия.Свойство("УзелОбмена") Тогда
			УзелОбмена = РезультатЗакрытия.УзелОбмена;
			КлючУникальности = ИмяПланаОбмена + "_" + ИдентификаторНастройки + "_" + УзелОбмена.УникальныйИдентификатор();
			
			Если ОбменДаннымиСВнешнейСистемой Тогда
				ОбновитьПараметрыПодключенияВнешнейСистемы(УзелОбмена, ПараметрыПодключенияВнешнейСистемы);
			КонецЕсли;
		КонецЕсли;
		
		Если МодельСервиса Тогда
			РезультатЗакрытия.Свойство("ЭтоОбменСПриложениемВСервисе", ЭтоОбменСПриложениемВСервисе);
			РезультатЗакрытия.Свойство("ОбластьДанныхКорреспондента",  ОбластьДанныхКорреспондента);
		КонецЕсли;
		
		Если РезультатЗакрытия.Свойство("ЕстьДанныеДляСопоставления")
			И РезультатЗакрытия.ЕстьДанныеДляСопоставления Тогда
			ПолученыДанныеДляСопоставления = Истина;
		КонецЕсли;
		
		ЗаполнитьТаблицуЭтаповНастройки();
		ОбновитьОтображениеТекущегоСостоянияНастройки();
		
		Если ТекущийЭтапНастройки = "НастройкаПодключения" Тогда
			ПерейтиКСледующемуЭтапуНастройки();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьПараметрыПодключенияВнешнейСистемы(УзелОбмена, ПараметрыПодключенияВнешнейСистемы)
	
	ПараметрыПодключенияВнешнейСистемы = РегистрыСведений.НастройкиТранспортаОбменаДанными.НастройкиТранспортаВнешнейСистемы(УзелОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьПодтверждениеПодключенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ПолученыНастройкиXDTOКорреспондента(УзелОбмена) Тогда
		ПерейтиКСледующемуЭтапуНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуНастроекXDTOПриНеобходимости(ПрерватьНастройку, ОповещениеПродолжения)
	
	СостояниеНастройки = СостояниеНастройкиСинхронизации(УзелОбмена);
	Если Не СостояниеНастройки.НастройкаСинхронизацииЗавершена
		И Не СостояниеНастройки.ПолученыНастройкиXDTOКорреспондента Тогда
		
		ПараметрыЗагрузки = Новый Структура;
		ПараметрыЗагрузки.Вставить("УзелОбмена", УзелОбмена);
		
		ОткрытьФорму("Обработка.ПомощникСозданияОбменаДанными.Форма.ЗагрузкаНастроекXDTO",
			ПараметрыЗагрузки, ЭтотОбъект, , , , ОповещениеПродолжения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		ПрерватьНастройку = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПравилаОтправкиИПолученияДанныхПродолжение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) <> Тип("Структура")
		ИЛИ Не РезультатЗакрытия.ПродолжитьНастройку Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если РезультатЗакрытия.ПолученыДанныеДляСопоставления
		И Не ПолученыДанныеДляСопоставления Тогда
		ПолученыДанныеДляСопоставления = РезультатЗакрытия.ПолученыДанныеДляСопоставления;
	КонецЕсли;
	
	ЗаполнитьТаблицуЭтаповНастройки();
	ОбновитьОтображениеТекущегоСостоянияНастройки();
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("НастроитьПравилаОтправкиИПолученияДанныхЗавершение", ЭтотОбъект);
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("Корреспондент",          УзелОбмена);
	ПараметрыПроверки.Вставить("ИмяПланаОбмена",         ИмяПланаОбмена);
	ПараметрыПроверки.Вставить("ИдентификаторНастройки", ИдентификаторНастройки);
	
	НастройкаВыполнена = Ложь;
	ПередНастройкойСинхронизацииДанных(ПараметрыПроверки, НастройкаВыполнена, ИмяФормыПомощникаНастройкиСинхронизацииДанных);
	
	Если НастройкаВыполнена Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Настройка правил отправки и получения данных выполнена.'"));
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, Истина);
		Возврат;
	КонецЕсли;
	
	ПараметрыПомощника = Новый Структура;
	
	Если ПустаяСтрока(ИмяФормыПомощникаНастройкиСинхронизацииДанных) Тогда
		ПараметрыПомощника.Вставить("Ключ", УзелОбмена);
		ПараметрыПомощника.Вставить("ИмяФормыПомощника", "ПланОбмена.[ИмяПланаОбмена].ФормаОбъекта");
		
		ПараметрыПомощника.ИмяФормыПомощника = СтрЗаменить(ПараметрыПомощника.ИмяФормыПомощника,
			"[ИмяПланаОбмена]", ИмяПланаОбмена);
	Иначе
		ПараметрыПомощника.Вставить("УзелОбмена", УзелОбмена);
		ПараметрыПомощника.Вставить("ИмяФормыПомощника", ИмяФормыПомощникаНастройкиСинхронизацииДанных);
	КонецЕсли;
	
	ОткрытьФорму(ПараметрыПомощника.ИмяФормыПомощника,
		ПараметрыПомощника, ЭтотОбъект, , , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПравилаОтправкиИПолученияДанныхЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТекущийЭтапНастройки = "НастройкаПравил"
		И НастройкаСинхронизацииЗавершена(УзелОбмена) Тогда
		Оповестить("Запись_УзелПланаОбмена");
		Если ПродолжениеНастройкиВПодчиненномУзлеРИБ Тогда
			ОбновитьИнтерфейс();
		КонецЕсли;
		ПерейтиКСледующемуЭтапуНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСопоставлениеИЗагрузкуДанныхПродолжение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТекущийЭтапНастройки = "СопоставлениеИЗагрузка"
		И ВыполненаЗагрузкаДанныхДляСопоставления(УзелОбмена) Тогда
		ПерейтиКСледующемуЭтапуНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНачальныйОбразРИБЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТекущийЭтапНастройки = "НачальныйОбразРИБ"
		И НачальныйОбразСоздан(УзелОбмена) Тогда
		ПерейтиКСледующемуЭтапуНастройки();
	КонецЕсли;
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНачальнуюВыгрузкуДанныхЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТекущийЭтапНастройки = "НачальнаяВыгрузкаДанных"
		И РезультатЗакрытия = УзелОбмена Тогда
		ПерейтиКСледующемуЭтапуНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеТекущегоСостоянияНастройки()
	
	// Видимость элементов настройки.
	Для Каждого ЭтапНастройки Из ВсеЭтапыНастройки Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"Группа" + ЭтапНастройки.Ключ,
			"Видимость",
			ЭтапыНастройки.НайтиСтроки(Новый Структура("Название", ЭтапНастройки.Ключ)).Количество() > 0);
	КонецЦикла;
	
	Если ПустаяСтрока(ТекущийЭтапНастройки) Тогда
		// Все этапы завершены.
		Для Каждого ЭтапНастройки Из ЭтапыНастройки Цикл
			Элементы["Группа" + ЭтапНастройки.Название].Доступность = Истина;
			Элементы[ЭтапНастройки.Кнопка].Шрифт = ОбщегоНазначенияКлиент.ШрифтСтиля("КомандаПомощникаНастройкиСинхронизацииОбычнаяШрифт");
			
			// Зеленый флажок только для основных этапов настройки.
			Если ВсеЭтапыНастройки[ЭтапНастройки.Название] = "Основное" Тогда
				Элементы["Панель" + ЭтапНастройки.Название].ТекущаяСтраница = Элементы["Страница" + ЭтапНастройки.Название + "Успешно"];
			Иначе
				Элементы["Панель" + ЭтапНастройки.Название].ТекущаяСтраница = Элементы["Страница" + ЭтапНастройки.Название + "Пустой"];
			КонецЕсли;
		КонецЦикла;
	Иначе
		
		ТекущийЭтапНайден = Ложь;
		Для Каждого ЭтапНастройки Из ЭтапыНастройки Цикл
			Если ЭтапНастройки.Название = ТекущийЭтапНастройки Тогда
				Элементы["Группа" + ЭтапНастройки.Название].Доступность = Истина;
				Элементы["Панель" + ЭтапНастройки.Название].ТекущаяСтраница = Элементы["Страница" + ЭтапНастройки.Название + "Текущий"];
				Элементы[ЭтапНастройки.Кнопка].Шрифт = ОбщегоНазначенияКлиент.ШрифтСтиля("КомандаПомощникаНастройкиСинхронизацииВажнаяШрифт");
				ТекущийЭтапНайден = Истина;
			ИначеЕсли Не ТекущийЭтапНайден Тогда
				Элементы["Группа" + ЭтапНастройки.Название].Доступность = Истина;
				Элементы["Панель" + ЭтапНастройки.Название].ТекущаяСтраница = Элементы["Страница" + ЭтапНастройки.Название + "Успешно"];
				Элементы[ЭтапНастройки.Кнопка].Шрифт = ОбщегоНазначенияКлиент.ШрифтСтиля("КомандаПомощникаНастройкиСинхронизацииОбычнаяШрифт");
			Иначе
				Элементы["Группа" + ЭтапНастройки.Название].Доступность = Ложь;
				Элементы["Панель" + ЭтапНастройки.Название].ТекущаяСтраница = Элементы["Страница" + ЭтапНастройки.Название + "Пустой"];
				Элементы[ЭтапНастройки.Кнопка].Шрифт = ОбщегоНазначенияКлиент.ШрифтСтиля("КомандаПомощникаНастройкиСинхронизацииОбычнаяШрифт");
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ЭтапНастройки Из ВсеЭтапыНастройки Цикл
			СтрокиЭтапы = ЭтапыНастройки.НайтиСтроки(Новый Структура("Название", ЭтапНастройки.Ключ));
			Если СтрокиЭтапы.Количество() = 0 Тогда
				Элементы["Группа" + ЭтапНастройки.Ключ].Доступность = Ложь;
				Элементы["Панель" + ЭтапНастройки.Ключ].ТекущаяСтраница = Элементы["Страница" + ЭтапНастройки.Ключ + "Пустой"];
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСледующемуЭтапуНастройки()
	
	СледующаяСтрока = Неопределено;
	ТекущийЭтапНайден = Ложь;
	Для Каждого СтрокаЭтапыНастройки Из ЭтапыНастройки Цикл
		Если ТекущийЭтапНайден Тогда
			СледующаяСтрока = СтрокаЭтапыНастройки;
			Прервать;
		КонецЕсли;
		
		Если СтрокаЭтапыНастройки.Название = ТекущийЭтапНастройки Тогда
			ТекущийЭтапНайден = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если СледующаяСтрока <> Неопределено Тогда
		ТекущийЭтапНастройки = СледующаяСтрока.Название;
		
		Если ТекущийЭтапНастройки = "НастройкаПравил" Тогда
			ПараметрыПроверки = Новый Структура;
			ПараметрыПроверки.Вставить("Корреспондент",          УзелОбмена);
			ПараметрыПроверки.Вставить("ИмяПланаОбмена",         ИмяПланаОбмена);
			ПараметрыПроверки.Вставить("ИдентификаторНастройки", ИдентификаторНастройки);
			
			НастройкаВыполнена = НастройкаСинхронизацииЗавершена(УзелОбмена);
			Если Не НастройкаВыполнена Тогда
				Если Не НастройкаXDTO Или ПолученыНастройкиXDTOКорреспондента(УзелОбмена) Тогда
					ПередНастройкойСинхронизацииДанных(ПараметрыПроверки, НастройкаВыполнена, ИмяФормыПомощникаНастройкиСинхронизацииДанных);
				КонецЕсли;
			КонецЕсли;
			
			Если НастройкаВыполнена Тогда
				ПерейтиКСледующемуЭтапуНастройки();
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Если ВсеЭтапыНастройки[ТекущийЭтапНастройки] <> "Основное" Тогда
			ТекущийЭтапНастройки = "";
		КонецЕсли;
	Иначе
		ТекущийЭтапНастройки = "";
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбновитьОтображениеТекущегоСостоянияНастройки", 0.2, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкаСинхронизацииЗавершена(УзелОбмена, СсылкаСуществует = Ложь)
	
	СсылкаСуществует = ОбщегоНазначения.СсылкаСуществует(УзелОбмена);
	Возврат ОбменДаннымиСервер.НастройкаСинхронизацииЗавершена(УзелОбмена);
	
КонецФункции

&НаСервереБезКонтекста
Функция ВыполненаЗагрузкаДанныхДляСопоставления(УзелОбмена)
	
	Возврат Не ОбменДаннымиСервер.ПолученоСообщениеСДаннымиДляСопоставления(УзелОбмена);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПередНастройкойСинхронизацииДанных(ПараметрыПроверки, НастройкаВыполнена, ИмяФормыПомощника)
	
	Если ОбменДаннымиСервер.ЕстьАлгоритмМенеджераПланаОбмена("ПередНастройкойСинхронизацииДанных", ПараметрыПроверки.ИмяПланаОбмена) Тогда
		
		Контекст = Новый Структура;
		Контекст.Вставить("Корреспондент",          ПараметрыПроверки.Корреспондент);
		Контекст.Вставить("ИдентификаторНастройки", ПараметрыПроверки.ИдентификаторНастройки);
		Контекст.Вставить("НачальнаяНастройка",     Не НастройкаСинхронизацииЗавершена(ПараметрыПроверки.Корреспондент));
		
		ПланыОбмена[ПараметрыПроверки.ИмяПланаОбмена].ПередНастройкойСинхронизацииДанных(
			Контекст, НастройкаВыполнена, ИмяФормыПомощника);
		
		Если НастройкаВыполнена Тогда
			ОбменДаннымиСервер.ЗавершитьНастройкуСинхронизацииДанных(ПараметрыПроверки.Корреспондент);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#Область ИнициализацияФормыПриСоздании

&НаСервере
Процедура ИнициализироватьСвойстваФормы()
	
	Заголовок = ОписаниеВариантаНастройки.ЗаголовокПомощникаСозданияОбмена;
	
	Если ПустаяСтрока(Заголовок) Тогда
		Если НастройкаРИБ Тогда
			Заголовок = НСтр("ru = 'Настройка распределенной информационной базы'");
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Настройка синхронизации данных с ""%1""'"),
				ОписаниеВариантаНастройки.НаименованиеКорреспондента);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьРеквизитыФормы()
	
	Параметры.Свойство("ОписаниеВариантаНастройки",    ОписаниеВариантаНастройки);
	Параметры.Свойство("ОбменДаннымиСВнешнейСистемой", ОбменДаннымиСВнешнейСистемой);
	
	НастройкаНовойСинхронизации = Параметры.Свойство("НастройкаНовойСинхронизации");
	ПродолжениеНастройкиВПодчиненномУзлеРИБ = Параметры.Свойство("ПродолжениеНастройкиВПодчиненномУзлеРИБ");
	
	МодельСервиса = ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
	Если НастройкаНовойСинхронизации Тогда
		ИмяПланаОбмена         = Параметры.ИмяПланаОбмена;
		ИдентификаторНастройки = Параметры.ИдентификаторНастройки;
		
		Если ОбменДаннымиСВнешнейСистемой Тогда
			Параметры.Свойство("ПараметрыПодключенияВнешнейСистемы", ПараметрыПодключенияВнешнейСистемы);
		Иначе
			Если Не ПродолжениеНастройкиВПодчиненномУзлеРИБ Тогда
				Если ОбменДаннымиСервер.ЭтоПодчиненныйУзелРИБ() Тогда
					ИмяПланаОбменаРИБ = ОбменДаннымиСервер.ГлавныйУзел().Метаданные().Имя;
					
					ПродолжениеНастройкиВПодчиненномУзлеРИБ = (ИмяПланаОбмена = ИмяПланаОбменаРИБ)
						И Не Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Получить();
				КонецЕсли;
			КонецЕсли;
			
			Если ПродолжениеНастройкиВПодчиненномУзлеРИБ Тогда
				ОбменДаннымиСервер.ПриПродолженииНастройкиПодчиненногоУзлаРИБ();
				УзелОбмена = ОбменДаннымиСервер.ГлавныйУзел();
			КонецЕсли;
		КонецЕсли;
	Иначе
		УзелОбмена = Параметры.УзелОбмена;
		
		ИмяПланаОбмена         = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелОбмена);
		ИдентификаторНастройки = ОбменДаннымиСервер.СохраненныйВариантНастройкиУзлаПланаОбмена(УзелОбмена);
		
		Если МодельСервиса Тогда
			Параметры.Свойство("ОбластьДанныхКорреспондента",  ОбластьДанныхКорреспондента);
			Параметры.Свойство("ЭтоОбменСПриложениемВСервисе", ЭтоОбменСПриложениемВСервисе);
		КонецЕсли;
		
		Если ОбменДаннымиСВнешнейСистемой Тогда
			ОбновитьПараметрыПодключенияВнешнейСистемы(УзелОбмена, ПараметрыПодключенияВнешнейСистемы);
		КонецЕсли;
	КонецЕсли;
	
	Если ПродолжениеНастройкиВПодчиненномУзлеРИБ
		Или (Не ОбменДаннымиСВнешнейСистемой
			И ОписаниеВариантаНастройки = Неопределено) Тогда
		МодульПомощник = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
		ОписаниеВариантаНастройки = МодульПомощник.СтруктураОписанияВариантаНастройки();
		
		ЗначенияНастроекДляВарианта = ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена,
			"НаименованиеКонфигурацииКорреспондента,
			|ЗаголовокКомандыДляСозданияНовогоОбменаДанными,
			|ЗаголовокПомощникаСозданияОбмена,
			|КраткаяИнформацияПоОбмену,
			|ПодробнаяИнформацияПоОбмену",
			ИдентификаторНастройки);
			
		ЗаполнитьЗначенияСвойств(ОписаниеВариантаНастройки, ЗначенияНастроекДляВарианта);
		ОписаниеВариантаНастройки.НаименованиеКорреспондента = ЗначенияНастроекДляВарианта.НаименованиеКонфигурацииКорреспондента;
	КонецЕсли;
	
	ВидТранспорта = Неопределено;
	Если ЗначениеЗаполнено(УзелОбмена) Тогда
		НастройкаЗавершена = НастройкаСинхронизацииЗавершена(УзелОбмена);
		ВидТранспорта = РегистрыСведений.НастройкиТранспортаОбменаДанными.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелОбмена);
		ЕстьНастройкиТранспорта = ЗначениеЗаполнено(ВидТранспорта);
	КонецЕсли;
	
	РезервноеКопирование = Не МодельСервиса
		И Не ПродолжениеНастройкиВПодчиненномУзлеРИБ
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеИБ");
		
	Если РезервноеКопирование Тогда
		МодульРезервноеКопированиеИБСервер = ОбщегоНазначения.ОбщийМодуль("РезервноеКопированиеИБСервер");
		
		НавигационнаяСсылкаОбработкиРезервногоКопирования =
			МодульРезервноеКопированиеИБСервер.НавигационнаяСсылкаОбработкиРезервногоКопирования();
	КонецЕсли;
		
	НастройкаРИБ                  = ОбменДаннымиПовтИсп.ЭтоПланОбменаРаспределеннойИнформационнойБазы(ИмяПланаОбмена);
	НастройкаXDTO                 = ОбменДаннымиСервер.ЭтоПланОбменаXDTO(ИмяПланаОбмена);
	НастройкаУниверсальногоОбмена = ОбменДаннымиПовтИсп.ЭтоУзелСтандартногоОбменаДанными(ИмяПланаОбмена); // без правил конвертации
	
	ДоступнаИнтерактивнаяОтправка = Не НастройкаРИБ И Не НастройкаУниверсальногоОбмена;
	
	Если Не ОбменДаннымиСВнешнейСистемой Тогда
	
		Если НастройкаНовойСинхронизации
			Или НастройкаРИБ
			Или НастройкаУниверсальногоОбмена Тогда
			ПолученыДанныеДляСопоставления = Ложь;
		ИначеЕсли ЭтоОбменСПриложениемВСервисе Тогда
			ПолученыДанныеДляСопоставления = ОбменДаннымиСервер.ПолученоСообщениеСДаннымиДляСопоставления(УзелОбмена);
		Иначе
			Если ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.COM
				Или ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WS
				Или ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WSПассивныйРежим
				Или Не ЕстьНастройкиТранспорта Тогда
				ПолученыДанныеДляСопоставления = ОбменДаннымиСервер.ПолученоСообщениеСДаннымиДляСопоставления(УзелОбмена);
			Иначе
				ПолученыДанныеДляСопоставления = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗначенияНастроекДляВарианта = ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена,
		"ИмяФормыСозданияНачальногоОбраза,
		|ИмяФормыПомощникаНастройкиСинхронизацииДанных,
		|ПоддерживаетсяСопоставлениеДанных",
		ИдентификаторНастройки);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияНастроекДляВарианта);
	
	Если ПустаяСтрока(ИмяФормыСозданияНачальногоОбраза)
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		ИмяФормыСозданияНачальногоОбраза = "ОбщаяФорма.[ФормаСозданияНачальногоОбраза]";
		ИмяФормыСозданияНачальногоОбраза = СтрЗаменить(ИмяФормыСозданияНачальногоОбраза,
			"[ФормаСозданияНачальногоОбраза]", "СозданиеНачальногоОбразаСФайлами");
	КонецЕсли;
	
	ТекущийЭтапНастройки = "";
	Если НастройкаНовойСинхронизации Тогда
		ТекущийЭтапНастройки = "НастройкаПодключения";
	ИначеЕсли ОбменДаннымиСВнешнейСистемой
		И Не ПолученыНастройкиXDTOКорреспондента(УзелОбмена) Тогда
		ТекущийЭтапНастройки = "ПодтверждениеПодключения";
	ИначеЕсли Не НастройкаСинхронизацииЗавершена(УзелОбмена) Тогда
		ТекущийЭтапНастройки = "НастройкаПравил";
	ИначеЕсли НастройкаРИБ
		И Не ПродолжениеНастройкиВПодчиненномУзлеРИБ
		И Не НачальныйОбразСоздан(УзелОбмена) Тогда
		Если Не ПустаяСтрока(ИмяФормыСозданияНачальногоОбраза) Тогда
			ТекущийЭтапНастройки = "НачальныйОбразРИБ";
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(УзелОбмена) Тогда
		НомераСообщений = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(УзелОбмена, "НомерПринятого, НомерОтправленного");
		Если НомераСообщений.НомерПринятого = 0
			И НомераСообщений.НомерОтправленного = 0
			И ОбменДаннымиСервер.ПолученоСообщениеСДаннымиДляСопоставления(УзелОбмена) Тогда
			ТекущийЭтапНастройки = "СопоставлениеИЗагрузка";
		КонецЕсли;
	КонецЕсли;
	
	ВсеЭтапыНастройки = Новый Структура;
	ВсеЭтапыНастройки.Вставить("НастройкаПодключения",     "Основное");
	ВсеЭтапыНастройки.Вставить("ПодтверждениеПодключения", "Основное");
	ВсеЭтапыНастройки.Вставить("НастройкаПравил",          "Основное");
	ВсеЭтапыНастройки.Вставить("НачальныйОбразРИБ",        "Основное");
	ВсеЭтапыНастройки.Вставить("СопоставлениеИЗагрузка",   "Основное");
	ВсеЭтапыНастройки.Вставить("НачальнаяВыгрузкаДанных",  "Основное");
	
КонецПроцедуры

&НаКлиенте
Функция ДобавитьЭтапНастройки(Название, Кнопка)
	
	СтрокаЭтап = ЭтапыНастройки.Добавить();
	СтрокаЭтап.Название     = Название;
	СтрокаЭтап.Кнопка       = Кнопка;
	
	Возврат СтрокаЭтап;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТаблицуЭтаповНастройки()
	
	ЭтапыНастройки.Очистить();
	
	Если ЕстьНастройкиТранспорта
		Или НастройкаНовойСинхронизации Тогда
		ДобавитьЭтапНастройки("НастройкаПодключения", "НастроитьПараметрыПодключения");
	КонецЕсли;
	
	Если ОбменДаннымиСВнешнейСистемой Тогда
		ДобавитьЭтапНастройки("ПодтверждениеПодключения", "ПолучитьПодтверждениеПодключения");
	КонецЕсли;
	
	ДобавитьЭтапНастройки("НастройкаПравил", "НастроитьПравилаОтправкиИПолучения");
	
	Если ОбменДаннымиСВнешнейСистемой Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкаРИБ
		И Не ПродолжениеНастройкиВПодчиненномУзлеРИБ
		И Не ПустаяСтрока(ИмяФормыСозданияНачальногоОбраза) Тогда
		ДобавитьЭтапНастройки("НачальныйОбразРИБ", "СоздатьНачальныйОбразРИБ");
	КонецЕсли;
	
	Если Не НастройкаРИБ
		И Не НастройкаУниверсальногоОбмена
		И ПолученыДанныеДляСопоставления
		И ПоддерживаетсяСопоставлениеДанных <> Ложь Тогда
		
		ДобавитьЭтапНастройки("СопоставлениеИЗагрузка", "ВыполнитьСопоставлениеИЗагрузкуДанных");
		
	КонецЕсли;
	
	Если ДоступнаИнтерактивнаяОтправка
		И (ЕстьНастройкиТранспорта
			Или НастройкаНовойСинхронизации) Тогда
		ДобавитьЭтапНастройки("НачальнаяВыгрузкаДанных", "ВыполнитьНачальнуюВыгрузкуДанных");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНачальноеОтображениеЭлементовФормы()
	
	Элементы.ДекорацияКраткаяИнформацияПоОбменуНадпись.Заголовок = ОписаниеВариантаНастройки.КраткаяИнформацияПоОбмену;
	Элементы.ПодробноеОписаниеСинхронизацииДанных.Видимость = ЗначениеЗаполнено(ОписаниеВариантаНастройки.ПодробнаяИнформацияПоОбмену);
	Элементы.ГруппаРезервноеКопирование.Видимость = РезервноеКопирование;
	Элементы.ПолучитьПодтверждениеПодключения.РасширеннаяПодсказка.Заголовок = СтрЗаменить(
		Элементы.ПолучитьПодтверждениеПодключения.РасширеннаяПодсказка.Заголовок,
		"%НаименованиеКорреспондента%",
		ОписаниеВариантаНастройки.НаименованиеКорреспондента);
		
	Если РезервноеКопирование Тогда
		Элементы.ДекорацияРезервноеКопированиеНадпись.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = 'Перед началом настройки новой синхронизации данных рекомендуется <a href=""%1"">создать резервную копию данных</a>.'"),
			НавигационнаяСсылкаОбработкиРезервногоКопирования);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти