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
	
	УстановитьВидимостьЭлементовФормы();
	
	Если ЗначениеЗаполнено(Запись.ВидТранспортаСообщенийОбменаПоУмолчанию) Тогда
		
		ИмяСтраницы = "НастройкиТранспорта[ВидТранспорта]";
		ИмяСтраницы = СтрЗаменить(ИмяСтраницы, "[ВидТранспорта]"
		, ОбщегоНазначения.ИмяЗначенияПеречисления(Запись.ВидТранспортаСообщенийОбменаПоУмолчанию));
		
		Если Элементы[ИмяСтраницы].Видимость Тогда
			
			Элементы.СтраницыВидовТранспорта.ТекущаяСтраница = Элементы[ИмяСтраницы];
			
		КонецЕсли;
	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.КонечнаяТочкаКорреспондента) Тогда
		УстановитьПривилегированныйРежим(Истина);
		Пароли = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.КонечнаяТочкаКорреспондента, "FTPСоединениеПарольОбластейДанных, ПарольАрхиваСообщенияОбменаОбластейДанных");
		FTPСоединениеПароль = ?(ЗначениеЗаполнено(Пароли.FTPСоединениеПарольОбластейДанных), ЭтотОбъект.УникальныйИдентификатор, "");
		ПарольАрхиваСообщенияОбмена = ?(ЗначениеЗаполнено(Пароли.ПарольАрхиваСообщенияОбменаОбластейДанных), ЭтотОбъект.УникальныйИдентификатор, "");
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьПривилегированныйРежим(Истина);
	Если FTPСоединениеПарольИзменен Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.КонечнаяТочкаКорреспондента, FTPСоединениеПароль, "FTPСоединениеПарольОбластейДанных");
	КонецЕсли;
	Если ПарольАрхиваСообщенияОбменаИзменен Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.КонечнаяТочкаКорреспондента, ПарольАрхиваСообщенияОбмена, "ПарольАрхиваСообщенияОбменаОбластейДанных");
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура FILEКаталогОбменаИнформациейНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайловогоКаталога(Запись, "FILEКаталогОбменаИнформацией", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура FILEКаталогОбменаИнформациейОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(Запись, "FILEКаталогОбменаИнформацией", СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольАрхиваСообщенияОбменаПриИзменении(Элемент)
	ПарольАрхиваСообщенияОбменаИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура FTPСоединениеПарольПриИзменении(Элемент)
	FTPСоединениеПарольИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПарольАрхиваСообщенияОбмена1ПриИзменении(Элемент)
	ПарольАрхиваСообщенияОбменаИзменен = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьПодключениеFILE(Команда)
	
	ПроверитьПодключение("FILE");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеFTP(Команда)
	
	ПроверитьПодключение("FTP");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьПодключение(ВидТранспортаСтрокой)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	ПроверитьПодключениеНаСервере(Отказ, ВидТранспортаСтрокой);
	
	ТекстПредупреждения = ?(Отказ, НСтр("ru = 'Не удалось установить подключение.'"), НСтр("ru = 'Подключение успешно установлено.'"));
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеНаСервере(Отказ, ВидТранспортаСтрокой)
	
	ОбменДаннымиСервер.ПроверитьПодключениеОбработкиТранспортаСообщенийОбмена(Отказ, Запись, Перечисления.ВидыТранспортаСообщенийОбмена[ВидТранспортаСтрокой]);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	
	ИспользуемыеТранспорты = Новый Массив;
	ИспользуемыеТранспорты.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	ИспользуемыеТранспорты.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	
	Элементы.ВидТранспортаСообщенийОбменаПоУмолчанию.СписокВыбора.Очистить();
	
	Для Каждого Элемент Из ИспользуемыеТранспорты Цикл
		
		Элементы.ВидТранспортаСообщенийОбменаПоУмолчанию.СписокВыбора.Добавить(Элемент, Строка(Элемент));
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
