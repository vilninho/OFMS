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
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,
		"ИмяФайла, ИдентификаторДокументооборота, АдресЗапросаНаСертификат, АдресСертификата,"
		+ "АдресКорневогоСертификата, АдресОтветаСервиса, СостояниеОбработкиЗаявления,"
		+ "ДатаОбновленияСостояния, СостояниеОбработкиЗаявленияАктуально");
	
	Если Параметры.СостояниеЗаявления <> Перечисления.СостоянияЗаявленияНаВыпускСертификата.Исполнено Тогда
		Элементы.ДекорацияСертификаты.Видимость = Ложь;
		Элементы.ДекорацияИнформацияДляПоддержки.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = 'В случае ошибки обратитесь в службу поддержки фирмы ""1С"", предоставив <a href = ""ИнформацияДляПоддержки"">техническую информацию о возникшей проблеме</a>.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияСертификатыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭлектроннаяПодписьСлужебныйКлиент.СохранитьСертификат(
		Неопределено,
		?(НавигационнаяСсылка = "Сертификат", АдресСертификата, АдресКорневогоСертификата),
		?(НавигационнаяСсылка = "Сертификат", ИмяФайла, НСтр("ru = 'Корневой сертификат'")));
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнформацияДляПоддержкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не СостояниеОбработкиЗаявленияАктуально Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Для сбора технической информации о возникшей проблеме необходимо обновить состояние заявления.'"));
		Возврат;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.СохранитьФайл(
		Неопределено, АдресАрхиваИнформацииДляПоддержки(), "service_info.zip");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция АдресАрхиваИнформацииДляПоддержки()
	
	АрхивИнформации = Новый ЗаписьZipФайла();
	
	ВременныеФайлы = Новый Массив;
	ВременныеФайлы.Добавить(ПолучитьИмяВременногоФайла("txt"));
	
	ТекстСостояния = Новый ТекстовыйДокумент;
	ТекстСостояния.ДобавитьСтроку(НСтр("ru = 'Идентификатор документооборота'")
		+ ": " + Строка(ИдентификаторДокументооборота));
	ТекстСостояния.ДобавитьСтроку(НСтр("ru = 'Состояние обработки заявления'")
		+ " (" + Формат(ДатаОбновленияСостояния, "ДЛФ=DT") + ")"
		+ ":" + Символы.ПС + СостояниеОбработкиЗаявления + Символы.ПС);
	
	ДобавитьДанныеВАрхив(АрхивИнформации, АдресЗапросаНаСертификат, "p10", ВременныеФайлы, ТекстСостояния,
		НСтр("ru = 'Запрос на сертификат'"));
	ДобавитьДанныеВАрхив(АрхивИнформации, АдресОтветаСервиса, "zip", ВременныеФайлы, ТекстСостояния,
		НСтр("ru = 'Ответ сервиса 1С: Подпись'"));
	ДобавитьДанныеВАрхив(АрхивИнформации, АдресКорневогоСертификата, "cer", ВременныеФайлы, ТекстСостояния,
		НСтр("ru = 'Полученный корневой сертификат'"));
	ДобавитьДанныеВАрхив(АрхивИнформации, АдресСертификата, "cer", ВременныеФайлы, ТекстСостояния,
		НСтр("ru = 'Полученный сертификат'"));
	
	ТекстСостояния.Записать(ВременныеФайлы[0]);
	АрхивИнформации.Добавить(ВременныеФайлы[0]);
	
	АдресАрхива = ПоместитьВоВременноеХранилище(АрхивИнформации.ПолучитьДвоичныеДанные());
	
	Для Каждого ВременныйФайл Из ВременныеФайлы Цикл
		ФайловаяСистема.УдалитьВременныйФайл(ВременныйФайл);
	КонецЦикла;
	
	Возврат АдресАрхива;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ДобавитьДанныеВАрхив(Архив, АдресДанных, Расширение, ВременныеФайлы, ТекстСостояния, ПредставлениеДанных)
	
	Если Не ЗначениеЗаполнено(АдресДанных) Тогда
		Возврат;
	КонецЕсли;
	
	Данные = ПолучитьИзВременногоХранилища(АдресДанных);
	Если ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда
		
		ФайлДанных = ПолучитьИмяВременногоФайла(Расширение);
		Данные.Записать(ФайлДанных);
		
		Архив.Добавить(ФайлДанных);
		ВременныеФайлы.Добавить(ФайлДанных);
		
	Иначе
		ТекстСостояния.ДобавитьСтроку(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось добавить %1. Данные во временном хранилище содержат тип %2.'"),
			ПредставлениеДанных, Строка(ТипЗнч(Данные))));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
