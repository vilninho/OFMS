///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Отправляет сообщение пользователям от другого пользователя. 
// Если между пользователями не было обсуждения,
// то будет создано отображаемое обсуждение.
//
// Выбрасывает исключение, если не удалось отправить сообщение.
//
// Параметры: 
//   Автор - СправочникСсылка.Пользователи
//         - ПользовательСистемыВзаимодействия
//   Получатели - Массив из СправочникСсылка.Пользователи
//              - Массив из ПользовательСистемыВзаимодействия
//   Сообщение - см. ОписаниеСообщения.
//   ОбсуждениеКонтекст - ЛюбаяСсылка - сообщение будет отправлено в контекстное обсуждение.
//                      - ИдентификаторОбсужденияСистемыВзаимодействия - сообщение будет отправлено в указанное обсуждение.
//                      - Неопределено - сообщение будет отправлено в негрупповое обсуждение между автором и получателем.
//
// Пример:
// Сообщение = Обсуждения.ОписаниеСообщения("Привет, мир!");
// Получатель = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Администратор);
// Обсуждения.ОтправитьСообщение(Пользователи.ТекущийПользователь(), Получатель, Сообщение);
//
Процедура ОтправитьСообщение(Знач Автор, Знач Получатели, Сообщение, ОбсуждениеКонтекст = Неопределено) Экспорт
	
	Если ТипЗнч(Автор) <> Тип("ПользовательСистемыВзаимодействия") Тогда
		Автор = ПользовательСистемыВзаимодействия(Автор);
	КонецЕсли;
	
	Если Автор = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Не указан автор сообщения'");
	КонецЕсли;
	
	Если Получатели.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru='Не указаны получатели сообщения'");
	КонецЕсли;
	
	ПолучателиПользователиИБ = ТипЗнч(Получатели[0]) = Тип("СправочникСсылка.Пользователи");
	Если ПолучателиПользователиИБ Тогда
		Получатели = ПользователиСистемыВзаимодействия(Получатели);
	КонецЕсли;
	
	Если ОбсуждениеКонтекст <> Неопределено 
			И ТипЗнч(ОбсуждениеКонтекст) <> Тип("ИдентификаторОбсужденияСистемыВзаимодействия") Тогда
			
		Если НЕ ЗначениеЗаполнено(ОбсуждениеКонтекст) Тогда
			ВызватьИсключение НСтр("ru='Передан пустой контекст обсуждения.'");
		КонецЕсли;
		
		Контекст = Новый КонтекстОбсужденияСистемыВзаимодействия(ПолучитьНавигационнуюСсылку(ОбсуждениеКонтекст));
		Отбор = Новый ОтборОбсужденийСистемыВзаимодействия;
		Отбор.КонтекстОбсуждения = Контекст;
		Отбор.ТекущийПользовательЯвляетсяУчастником = Ложь;
		Отбор.Отображаемое = Истина;
		Отбор.КонтекстноеОбсуждение = Истина;
		Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждения(Отбор);
		Если Обсуждение.Количество() = 0 Тогда
			Обсуждение = СистемаВзаимодействия.СоздатьОбсуждение();
			Обсуждение.КонтекстОбсуждения = Контекст;
			Обсуждение.Отображаемое = Истина;
			Обсуждение.Заголовок = Строка(ОбсуждениеКонтекст);
			Обсуждение.Записать();
		Иначе 
			Обсуждение = Обсуждение[0];
		КонецЕсли;

		ИдентификаторОбсуждения = Обсуждение.Идентификатор;
		
	ИначеЕсли ОбсуждениеКонтекст = Неопределено Тогда
		
		Если Получатели.Количество() = 1 Тогда
			Участник = ЭлементСоответствия(Получатели, 0).Значение;
			Обсуждение = НеГрупповоеОбсуждениеМеждуПользователями(Автор.Идентификатор, Участник.Идентификатор);
		Иначе	
			Обсуждение = СистемаВзаимодействия.СоздатьОбсуждение();
			Обсуждение.Заголовок = Сообщение.Текст;
			Обсуждение.Отображаемое = Истина;
			Обсуждение.Групповое = Истина;
			Обсуждение.Участники.Добавить(Автор.Идентификатор);
 			ДобавитьПолучателей(Обсуждение.Участники, Получатели);
			Обсуждение.Записать();
		КонецЕсли;
		
		ИдентификаторОбсуждения = Обсуждение.Идентификатор;
		
	Иначе
		
		ИдентификаторОбсуждения = ОбсуждениеКонтекст;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СообщениеСВ = СообщениеИзОписания(
					Автор,
					ИдентификаторОбсуждения,
					Получатели,
					Сообщение);
	СообщениеСВ.Записать();
	
КонецПроцедуры

// Отправляет сообщение всем участникам неконтекстного обсуждения.
// Если обсуждение контекстное, то будет отправление сообщение без адресатов.
//
// Выбрасывает исключение, если не удалось отправить сообщение.
//
// Параметры: 
//   Автор - СправочникСсылка.Пользователи
//         - ПользовательСистемыВзаимодействия
//   Сообщение - см. ОписаниеСообщения.
//   ОбсуждениеКонтекст - ЛюбаяСсылка - сообщение будет отправлено в контекстное обсуждение.
//                      - ИдентификаторОбсужденияСистемыВзаимодействия - сообщение будет отправлено в указанное обсуждение.
//
// Пример:
// Сообщение = Обсуждения.ОписаниеСообщения("Привет, мир!");
// Обсуждения.ОтправитьУведомление(Пользователи.ТекущийПользователь(), Сообщение, ЗаказКлиента);
//
Процедура ОтправитьУведомление(Знач Автор, Сообщение, ОбсуждениеКонтекст) Экспорт

	Если ТипЗнч(Автор) <> Тип("ПользовательСистемыВзаимодействия") Тогда
		Автор = ПользовательСистемыВзаимодействия(Автор);
	КонецЕсли;
	
	Если Автор = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Не указан автор сообщения'");
	КонецЕсли;
	
	Получатели = Новый Массив;
	
	Если ОбсуждениеКонтекст <> Неопределено 
			И ТипЗнч(ОбсуждениеКонтекст) <> Тип("ИдентификаторОбсужденияСистемыВзаимодействия") Тогда
			
		Если НЕ ЗначениеЗаполнено(ОбсуждениеКонтекст) Тогда
			ВызватьИсключение НСтр("ru='Передан пустой контекст обсуждения.'");
		КонецЕсли;	
		
		Контекст = Новый КонтекстОбсужденияСистемыВзаимодействия(ПолучитьНавигационнуюСсылку(ОбсуждениеКонтекст));
		Отбор = Новый ОтборОбсужденийСистемыВзаимодействия;
		Отбор.КонтекстноеОбсуждение = Истина;
		Отбор.КонтекстОбсуждения = Контекст;
		Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждения(Отбор);
		Если Обсуждение.Количество() = 0 Тогда
			Обсуждение = СистемаВзаимодействия.СоздатьОбсуждение();
			Обсуждение.КонтекстОбсуждения = Контекст;
			Обсуждение.Групповое = Истина;
			Обсуждение.Отображаемое = Истина;
			Обсуждение.Заголовок = Строка(ОбсуждениеКонтекст);
			Обсуждение.Записать();
		Иначе 
			Обсуждение = Обсуждение[0];
		КонецЕсли;
		
		ИдентификаторОбсуждения = Обсуждение.Идентификатор;
		Получатели = Обсуждение.Участники;
		
	ИначеЕсли ОбсуждениеКонтекст = Неопределено Тогда
		
		ВызватьИсключение НСтр("ru='Не указан идентификатор обсуждения или контекст.'");
		
	Иначе
		
		ИдентификаторОбсуждения = ОбсуждениеКонтекст;
		Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждение(ИдентификаторОбсуждения);
		Получатели = Обсуждение.Участники;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СообщениеСВ = СообщениеИзОписания(
					Автор,
					ИдентификаторОбсуждения,
					Получатели,
					Сообщение);
	СообщениеСВ.Записать();

КонецПроцедуры

// Возвращает Истина, если база зарегистрирована в системе Взаимодействия.
//
// Возвращаемое значение:
//   Булево
//
Функция СистемаВзаимодействийПодключена() Экспорт
	Если ОбсужденияСлужебный.Заблокированы() Тогда 
		Возврат Ложь;
	КонецЕсли;

	Возврат СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
КонецФункции

// Возвращает Истина, если база зарегистрирована в системе Взаимодействия,
// есть хотя бы один зарегистрированный пользователь.
//
// Возвращаемое значение:
//   Булево
//
Функция ОбсужденияДоступны() Экспорт
	Возврат ОбсужденияСлужебный.Подключены();
КонецФункции

// Формирует соответствие между идентификаторами пользователей системы взаимодействия
// и элементами справочника Пользователи.
//
// Параметры:
//   ПользователиСистемыВзаимодействия - Массив из ИдентификаторПользователяСистемыВзаимодействия
//                                     - КоллекцияИдентификаторовПользователейСистемыВзаимодействия 
// 
// Возвращаемое значение:
//   Соответствие из КлючИЗначение:
//   * Ключ - ИдентификаторПользователяСистемыВзаимодействия
//   * Значение - см. ПользовательИнформационнойБазы
//
Функция ПользователиИнформационнойБазы(ПользователиСистемыВзаимодействия)Экспорт
	ТипыВходныхПараметров = Новый Массив;
	ТипыВходныхПараметров.Добавить(Тип("КоллекцияИдентификаторовПользователейСистемыВзаимодействия"));
	ТипыВходныхПараметров.Добавить(Тип("Массив"));
 	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ПользователиИнформационнойБазы",
 		"ПользователиСистемыВзаимодействия",
 		ПользователиСистемыВзаимодействия,
 		ТипыВходныхПараметров);

	Результат = Новый Соответствие;
	Ошибки = Новый Массив;
	Для каждого Идентификатор Из ПользователиСистемыВзаимодействия Цикл
		Попытка
			Результат.Вставить(Идентификатор, ПользовательИнформационнойБазы(Идентификатор));
		Исключение
			Ошибки.Добавить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Результат.Вставить(Идентификатор, Неопределено);
		КонецПопытки;
	КонецЦикла;
	
	Если Ошибки.Количество() > 0 Тогда
	
		ЗаписьЖурналаРегистрации(ОбсужденияСлужебный.СобытиеЖурналаРегистрации(
			НСтр("ru='Пользователи информационной базы'", ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,,,
			СтрСоединить(Ошибки, Символы.ПС + Символы.ПС));
	
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Выполняет поиск элемента справочника Пользователи по идентификатору пользователя Системы Взаимодействия.
//
// Выбрасывает исключение, если пользователь не был найден.
//
// Параметры:
//   ПользовательСистемыВзаимодействия - ИдентификаторПользователяСистемыВзаимодействия.
//
// Возвращаемое значение:
//   СправочникСсылка.Пользователи
//
Функция ПользовательИнформационнойБазы(ПользовательСистемыВзаимодействия) Экспорт
	Результат = Неопределено;
	
	ПользовательСВ = СистемаВзаимодействия.ПолучитьПользователя(ПользовательСистемыВзаимодействия);
	Результат = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ПользовательСВ.ИдентификаторПользователяИнформационнойБазы);
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		
		ШаблонОшибки = НСтр("ru='Не удалось получить пользователя информационной базы по идентификатору пользователя системы взаимодействия (%1)'");
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки, Строка(ПользовательСистемыВзаимодействия));
		ВызватьИсключение ОписаниеОшибки;
		
	КонецЕсли;	
	
	Возврат Результат;
КонецФункции

// Формирует соответствие между элементами справочника Пользователи
// и идентификаторами пользователей системы взаимодействия.
//  
// Если пользователь не найден, то будет попытка создать пользователя системы взаимодействия.
// Если пользователь не найден и при создании нового пользователя было выброшено исключение,
// то возвращается Неопределено.
//
// Параметры:
//   ПользователиИнформационнойБазы - Массив из СправочникСсылка.Пользователи
// 
// Возвращаемое значение:
//   Соответствие из КлючИЗначение:
//   * Ключ - СправочникСсылка.Пользователи
//   * Значение - см. ПользовательСистемыВзаимодействия
//
Функция ПользователиСистемыВзаимодействия(ПользователиИнформационнойБазы) Экспорт
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"ПользователиСистемыВзаимодействия",
 		"ПользователиИнформационнойБазы",
 		ПользователиИнформационнойБазы,
 		Тип("Массив"));
	
	Результат = Новый Соответствие;
	Ошибки = Новый Массив;

	Для каждого Пользователь Из ПользователиИнформационнойБазы Цикл
		
		Попытка
			Результат.Вставить(Пользователь, ПользовательСистемыВзаимодействия(Пользователь));
		Исключение
			Ошибки.Добавить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Результат.Вставить(Пользователь, Неопределено);
		КонецПопытки;
		
	КонецЦикла;
	
	Если Ошибки.Количество() > 0 Тогда
		
		ЗаписьЖурналаРегистрации(ОбсужденияСлужебный.СобытиеЖурналаРегистрации(
			НСтр("ru='ПользователиСистемыВзаимодействия'", ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,,,
			СтрСоединить(Ошибки, Символы.ПС));
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Получает идентификатор пользователя системы взаимодействия.
// Если пользователь не найден, то будет выполнена попытка создать нового пользователя.
// 
// Выбрасывает исключение, если:
// - не удалось получить идентификатор пользователя информационной базы;
// - не удалось создать пользователя системы Взаимодействия.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи
//               - СправочникОбъект.Пользователи
//
// Возвращаемое значение:
//   ПользовательСистемыВзаимодействия
//
Функция ПользовательСистемыВзаимодействия(Пользователь) Экспорт
	Результат = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	ИдентификаторПользователяИнформационнойБазы = ?(ТипЗнч(Пользователь) = Тип("СправочникОбъект.Пользователи"),
		Пользователь.ИдентификаторПользователяИБ,
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Пользователь, "ИдентификаторПользователяИБ"));
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не ЗначениеЗаполнено(ИдентификаторПользователяИнформационнойБазы) Тогда
		ШаблонОшибки = НСтр("ru='Не удалось получить идентификатор пользователя (%1)'");
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонОшибки,
			Строка(Пользователь));
			
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
	ОшибкаПолучениеИдентификатораСВ = "";
			
	Попытка
		ИдентификаторПользователяСВ = СистемаВзаимодействия.ПолучитьИдентификаторПользователя(
			ИдентификаторПользователяИнформационнойБазы);
		Результат = СистемаВзаимодействия.ПолучитьПользователя(ИдентификаторПользователяСВ);
	Исключение
		ОшибкаПолучениеИдентификатораСВ = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Если Результат = Неопределено Тогда
		
		Попытка
			УстановитьПривилегированныйРежим(Истина);
			Результат = НовыйПользовательСистемыВзаимодействия(Пользователь);
			УстановитьПривилегированныйРежим(Ложь);
		Исключение
			Ошибка = ИнформацияОбОшибке();
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='При создании пользователя %1 произошла ошибка.'"),
					Пользователь);
			ОписаниеОшибки = ОписаниеОшибки + Символы.ПС + ОшибкаПолучениеИдентификатораСВ
				+ Символы.ПС + ПодробноеПредставлениеОшибки(Ошибка);
			ЗаписьЖурналаРегистрации(ОбсужденияСлужебный.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,,,
				ОписаниеОшибки);
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Обновляет дополнительную информацию пользователя системы взаимодействия.
// Например, телефон и адрес электронной почты.
// Если пользователь системы взаимодействия еще не создан, то будет создан новый пользователь
// системы взаимодействия.
//
// Выбрасывает исключение, если обновить пользователя системы взаимодействия не удалось.
//
// Параметры:
//   Пользователь - СправочникСсылка.Пользователи
//                - СправочникОбъект.Пользователи
//
Процедура ОбновитьПользователяВСистемеВзаимодействия(Пользователь) Экспорт
	
	Если Не СистемаВзаимодействийПодключена() Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ПользовательСВ = ПользовательСистемыВзаимодействия(Пользователь);
		ОписаниеПользователя = ОписаниеПользователя(Пользователь);
		ОбновитьОписаниеПользователяВСистемеВзаимодействия(
			ПользовательСВ,
			ОписаниеПользователя);
	Исключение
		ОписаниеОшибки = НСтр("ru='Не удалось обновить пользователя системы взаимодействия.'");
		Ошибка = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(ОбсужденияСлужебный.СобытиеЖурналаРегистрации(
			НСтр("ru='Обновить описание в системе взаимодействия'", ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,
			Пользователь.Метаданные(),
			Пользователь.Ссылка,
			ОписаниеОшибки + Символы.ПС + ПодробноеПредставлениеОшибки(Ошибка));
	КонецПопытки;
	
КонецПроцедуры

// Формирует описание сообщение для отправки сообщения через процедуры
// и функции подсистемы Обсуждения.
//
// Параметры:
//   Текст - Строка - текст сообщения системы Взаимодействия
//         - ФорматированнаяСтрока
//
// Возвращаемое значение:
//   Структура:
//   * Текст - ФорматированнаяСтрока
//   * Вложения - Массив из см. ОписаниеВложения
//   * Данные - Неопределено - см. синтакс-помощник СообщениеСистемыВзаимодействия
//   * Действия - СписокЗначений - см. синтакс-помощник СообщениеСистемыВзаимодействия
//
Функция ОписаниеСообщения(Знач Текст) Экспорт
	Описание = Новый Структура;
	
	Если ТипЗнч(Текст) = Тип("Строка") Тогда
		Текст = Новый ФорматированнаяСтрока(Текст);
	КонецЕсли;
	
	Описание.Вставить("Текст", Текст);
	Описание.Вставить("Вложения", Новый Массив);
	Описание.Вставить("Данные", Неопределено);
	Описание.Вставить("Действия", Новый СписокЗначений);
	Возврат Описание;
КонецФункции

// Формирует описание вложения для отправки сообщения через процедуры
// и функции подсистемы Обсуждения.
//
// Параметры:
//   Поток - Поток - поток, из которого будет создано вложение системы Взаимодействия.
//         - ПотокВПамяти
//         - ФайловыйПоток
//   Наименование - Строка
// 
// Возвращаемое значение:
//   Структура:
//   * Поток - Поток - поток, из которого будет создано вложение системы взаимодействия.
// 			- ПотокВПамяти
// 			- ФайловыйПоток
//   * Наименование - Строка
//   * ТипСодержимого - Строка
//   * Отображаемое - Булево - значение по умолчанию Истина
//
Функция ОписаниеВложения(Поток, Наименование) Экспорт

	Описание = Новый Структура;
	Описание.Вставить("Поток", Поток);
	Описание.Вставить("Наименование", Наименование);
	Описание.Вставить("ТипСодержимого", "");
	Описание.Вставить("Отображаемое", Истина);
	Возврат Описание;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьОписаниеПользователяВСистемеВзаимодействия(ПользовательСВ, ОписаниеПользователя)
	
	Фотография = ОписаниеПользователя.Фотография;
	Если Фотография <> Неопределено Тогда
		ПользовательСВ.Картинка = Новый Картинка(Фотография);
	КонецЕсли;
	
	ПользовательСВ.АдресЭлектроннойПочты = ОписаниеПользователя.АдресЭлектроннойПочты;
	ПользовательСВ.НомерТелефона = ОписаниеПользователя.Телефон;
	ПользовательСВ.Заблокирован = ОписаниеПользователя.Недействителен ИЛИ ОписаниеПользователя.ПометкаУдаления;
	
	УстановитьПривилегированныйРежим(Истина);
	ПользовательСВ.Записать();
	
КонецПроцедуры

// Создает нового пользователя системы взаимодействий и заполняет его данными пользователя
// информационной базы.
//
// Выбрасывает исключение, если не удалось создать нового пользователя системы Взаимодействия.
//
// Параметры:
//   Пользователь - СправочникСсылка.Пользователи - пользователь, для которого будет создан
//													пользователь системы взаимодействия.
// Возвращаемое значение:
//   ПользовательСистемыВзаимодействия
//
Функция НовыйПользовательСистемыВзаимодействия(Пользователь)
	ОписаниеПользователя = ОписаниеПользователя(Пользователь);
	
	Если НЕ ЗначениеЗаполнено(ОписаниеПользователя.ИдентификаторПользователяИБ) Тогда
		ВызватьИсключение НСтр("ru='Не существует пользователь информационной базы'");
	КонецЕсли;
	
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
		ОписаниеПользователя.ИдентификаторПользователяИБ);
	ПользовательСВ = СистемаВзаимодействия.СоздатьПользователя(ПользовательИБ);
	
	ОбновитьОписаниеПользователяВСистемеВзаимодействия(ПользовательСВ, ОписаниеПользователя);
	
	Возврат ПользовательСВ;
КонецФункции

Функция ОписаниеПользователя(Пользователь)
	Возврат ПользователиСлужебный.ОписаниеПользователя(Пользователь);
КонецФункции

// Параметры:
//  ПолучателиПриемник	 - КоллекцияИдентификаторовПользователейСистемыВзаимодействия
//  ПолучателиИсточник	 - Соответствие
//                    	 - Массив из ПользовательСистемыВзаимодействия
//
Процедура ДобавитьПолучателей(ПолучателиПриемник, ПолучателиИсточник)
	
	Если ПолучателиИсточник.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПолучателиПользователиИБ = ТипЗнч(ПолучателиИсточник) = Тип("Соответствие") 
		ИЛИ (ТипЗнч(ПолучателиИсточник) = Тип("Массив") 
			И ТипЗнч(ПолучателиИсточник[0]) = Тип("СправочникСсылка.Пользователи"));
	
	Если ПолучателиПользователиИБ Тогда
		Для каждого Получатель Из ПолучателиИсточник Цикл
			
			Если Получатель.Значение <> Неопределено Тогда
				ПолучателиПриемник.Добавить(Получатель.Значение.Идентификатор);
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе	
		Для каждого Получатель Из ПолучателиИсточник Цикл // ИдентификаторПользователяСистемыВзаимодействия, ПользовательСистемыВзаимодействия 
			Если ТипЗнч(Получатель) = Тип("ИдентификаторПользователяСистемыВзаимодействия") Тогда
				ПолучателиПриемник.Добавить(Получатель);
			Иначе	
				ПолучателиПриемник.Добавить(Получатель.Идентификатор);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Функция ЭлементСоответствия(Соответствие, Индекс)

	Сч = 0;
	Для каждого КлючЗначение Из Соответствие Цикл
		Если Сч = Индекс Тогда
			Возврат КлючЗначение;
		КонецЕсли;
		Сч = Сч + 1;
	КонецЦикла;
	
	Возврат Неопределено;

КонецФункции

// Параметры:
//  Автор	 - ИдентификаторПользователяСистемыВзаимодействия
//  Участник - ИдентификаторПользователяСистемыВзаимодействия
// 
// Возвращаемое значение:
//    ОбсуждениеСистемыВзаимодействия
//
Функция НеГрупповоеОбсуждениеМеждуПользователями(Автор, Участник)
	Обсуждение = Неопределено;
	
	Отбор = Новый ОтборОбсужденийСистемыВзаимодействия;
	Отбор.КонтекстноеОбсуждение = Ложь;
	Отбор.Групповое = Ложь;
	НайденныеОбсуждения = СистемаВзаимодействия.ПолучитьОбсуждения(Отбор);
	
	Для каждого ОтобранноеОбсуждение Из НайденныеОбсуждения Цикл
		Если ОтобранноеОбсуждение.Участники.Содержит(Участник) 
				И ОтобранноеОбсуждение.Участники.Содержит(Автор) Тогда
			
			Обсуждение = ОтобранноеОбсуждение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Обсуждение = Неопределено Тогда
		Обсуждение = СистемаВзаимодействия.СоздатьОбсуждение();
		Обсуждение.Отображаемое = Истина;
		Обсуждение.Групповое = Ложь;
		Обсуждение.Участники.Добавить(Автор);
		Обсуждение.Участники.Добавить(Участник);
		Обсуждение.Записать();
	КонецЕсли;
	
	Возврат Обсуждение;
КонецФункции

Функция СообщениеИзОписания(Автор, ИдентификаторОбсуждения, Получатели, Сообщение)
	
	СообщениеСВ = СистемаВзаимодействия.СоздатьСообщение(ИдентификаторОбсуждения);
	СообщениеСВ.Автор = Автор.Идентификатор;
	СообщениеСВ.Текст = Сообщение.Текст;
	СообщениеСВ.Данные = Сообщение.Данные;
	Для каждого Действие Из Сообщение.Действия Цикл
		СообщениеСВ.Действия.Добавить(Действие.Значение, Действие.Представление);
	КонецЦикла;
	
	ДобавитьПолучателей(СообщениеСВ.Получатели, Получатели);
	
	Для каждого Вложение Из Сообщение.Вложения Цикл
		СообщениеСВ.Вложения.Добавить(Вложение.Поток,
		Вложение.Имя,
		Вложение.ТипСодержимого,
		Вложение.Отображаемое);
	КонецЦикла;
	Возврат СообщениеСВ;

КонецФункции

#КонецОбласти