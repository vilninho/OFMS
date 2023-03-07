#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_ПечатныйПрайсЛист";
	КомандаПечати.Представление = НСтр("ru = 'Печать'");
	КомандаПечати.ПроверкаПроведенияПередПечатью    = Ложь;
	КомандаПечати.ТребуетсяРасширениеРаботыСФайлами = Истина;
	КомандаПечати.Порядок = 85;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр).
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной
//                                                            параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной
//                                            параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ПечатныйПрайсЛист") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ПФ_MXL_ПечатныйПрайсЛист",
		"Печатный прайс-лист",
		ПечатьПФ_MXL_ПечатныйПрайсЛист(МассивОбъектов, ОбъектыПечати,, ПараметрыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьДанныеПечати(Знач МассивДокументов, Знач МассивИменМакетов) Экспорт
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для вызова из дополнительной печатной формы.

Функция ПечатьПФ_MXL_ПечатныйПрайсЛист(МассивОбъектов, ОбъектыПечати, ИмяМакета = "ПФ_MXL_ПечатныйПрайсЛист", ПараметрыПечати) Экспорт
	
	Scan_СборСтатистики.Scan_Печать(ИмяМакета); // Rarus tenkam 11.04.2022 mantis 18433 +
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Если МассивОбъектов.Количество() = 1 Тогда
		//ТабличныйДокумент.ИспользуемоеИмяФайла = "ПечатныйПрайсЛист "+ Scan_Печать.ПолучитьНомерДляПечати(МассивОбъектов[0]);
		ТабличныйДокумент.ИспользуемоеИмяФайла = МассивОбъектов[0].НаименованиеПрайсЛиста;
	КонецЕсли;
	
	ТабличныйДокумент.КлючПараметровПечати = "ПФ_MXL_ПечатныйПрайсЛист";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Scan_ПечатныйПрайсЛист.ПФ_MXL_ПечатныйПрайсЛист");
	
	Для Каждого ДокументСсылка Из МассивОбъектов Цикл
		Для Каждого РазделДляПечати Из ПараметрыПечати.РазделыДляПечати Цикл
			Если Не РазделДляПечати.Пометка Тогда
				Продолжить;
			КонецЕсли;
			
			НайденнаяСтрокаРаздела = ДокументСсылка.РазделыПрайсЛиста.Найти(РазделДляПечати.Значение, "Наименование");
			Если НайденнаяСтрокаРаздела = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ОбластьКолонтитулВерхний = Макет.ПолучитьОбласть("КолонтитулВерхний");
			ОбластьКолонтитулВерхний.Параметры.ДатаВступленияВСилу = ДокументСсылка.ДатаВступленияВСилу;
			ТабличныйДокумент.Вывести(ОбластьКолонтитулВерхний);
			
			ОбластьЗаголовокРаздела = Макет.ПолучитьОбласть("ЗаголовокРаздела");
			ОбластьЗаголовокРаздела.Параметры.ЗаголовокРаздела = РазделДляПечати.Значение;
			ТабличныйДокумент.Вывести(ОбластьЗаголовокРаздела);
			
			//ОбластьСтрокаРазделаКолонкаОтступ = Макет.ПолучитьОбласть("ШапкаРаздела|КолонкаОтступ");
			//ТабличныйДокумент.Вывести(ОбластьСтрокаРазделаКолонкаОтступ);
			
			ОбластьШапкаРазделаКолонкаСпецификация = Макет.ПолучитьОбласть("ШапкаРаздела|КолонкаСпецификация");
			ВыведеннаяОбласть = ТабличныйДокумент.Присоединить(ОбластьШапкаРазделаКолонкаСпецификация);
			
			ОбластьШапкаРазделаКолонкаЦенаДляКлиента = Макет.ПолучитьОбласть("ШапкаРаздела|КолонкаЦенаДляКлиента");
			
			НайденныеСтрокиШкалыЦен = ДокументСсылка.ШкалаЦен.НайтиСтроки(Новый Структура("ИдентификаторРаздела", НайденнаяСтрокаРаздела.ИдентификаторРаздела));
			Для Каждого НайденнаяСтрокаШкалыЦен Из НайденныеСтрокиШкалыЦен Цикл
				ОбластьШапкаРазделаКолонкаЦенаДляКлиента.Параметры.НаименованиеШагаШкалы = НайденнаяСтрокаШкалыЦен.Наименование;
				ПрисоединеннаяОбласть = ТабличныйДокумент.Присоединить(ОбластьШапкаРазделаКолонкаЦенаДляКлиента);
			КонецЦикла;
			
			ОбластьЦенДляКлиентаВерх  = ВыведеннаяОбласть.Верх;
			ОбластьЦенДляКлиентаНиз   = ОбластьЦенДляКлиентаВерх;
			ОбластьЦенДляКлиентаЛево  = ВыведеннаяОбласть.Право+1;
			ОбластьЦенДляКлиентаПраво = ПрисоединеннаяОбласть.Право;
			
			ОбластьДляОбъединения = ТабличныйДокумент.Область(ОбластьЦенДляКлиентаВерх, ОбластьЦенДляКлиентаЛево, ОбластьЦенДляКлиентаНиз, ОбластьЦенДляКлиентаПраво);
			ОбластьДляОбъединения.Объединить();
			
			СчетчикСтрок = 0;
			
			НайденныеСтрокиСпецификаций = ДокументСсылка.СтандартныеСпецификации.НайтиСтроки(Новый Структура("ИдентификаторРаздела", НайденнаяСтрокаРаздела.ИдентификаторРаздела));
			Для Каждого СтрокаСпецификации Из НайденныеСтрокиСпецификаций Цикл
				//ОбластьСтрокаРазделаКолонкаОтступ = Макет.ПолучитьОбласть("СтрокаРаздела|КолонкаОтступ");
				//ТабличныйДокумент.Вывести(ОбластьСтрокаРазделаКолонкаОтступ);
				
				СчетчикСтрок = СчетчикСтрок + 1;
				
				Если СчетчикСтрок%2 = 0 Тогда
					ЦветФона = Новый Цвет(255,255,255);
				Иначе
					ЦветФона = Новый Цвет(200,201,199);
				КонецЕсли;
				
				//ОбластьСтрокаРазделаКолонкаСпецификация = Макет.ПолучитьОбласть("СтрокаРаздела|КолонкаСпецификация");
				ОбластьСтрокаРазделаКолонкаСпецификация = Макет.ПолучитьОбласть("СтрокаРаздела|КолонкаСпецификация");
				ОбластьСтрокаРазделаКолонкаСпецификация.Параметры.НомерСпецификации = СтрокаСпецификации.СтандартнаяСпецификация.НомерСпецификации;
				ОбластьСтрокаРазделаКолонкаСпецификация.Параметры.ОписаниеСпецификации = СтрокаСпецификации.СтандартнаяСпецификация.ОписаниеСпецификации;
				ОбластьСтрокаРазделаКолонкаСпецификация.Параметры.ЦенаДляДилера = СтрокаСпецификации.ЦенаДляДилераОкр;
				
				ПрисоединеннаяОбласть = ТабличныйДокумент.Вывести(ОбластьСтрокаРазделаКолонкаСпецификация);
				ПрисоединеннаяОбласть.ЦветФона = ЦветФона;
				
				НайденныеСтрокиЦенДляКлиента = ДокументСсылка.ЦеныДляКлиента.НайтиСтроки(Новый Структура("ИдентификаторСпецификации", СтрокаСпецификации.ИдентификаторСпецификации));
				Для Каждого СтрокаЦеныДляКлиента Из НайденныеСтрокиЦенДляКлиента Цикл
					ОбластьСтрокаРазделаКолонкаЦенаДляКлиента = Макет.ПолучитьОбласть("СтрокаРаздела|КолонкаЦенаДляКлиента");
					ОбластьСтрокаРазделаКолонкаЦенаДляКлиента.Параметры.ЦенаДляКлиента = СтрокаЦеныДляКлиента.ЦенаДляКлиента;
					
					ПрисоединеннаяОбласть = ТабличныйДокумент.Присоединить(ОбластьСтрокаРазделаКолонкаЦенаДляКлиента);
					ПрисоединеннаяОбласть.ЦветФона = ЦветФона;
				КонецЦикла;
			КонецЦикла;
			
			ОбластьПодвалРаздела = Макет.ПолучитьОбласть("ПодвалРаздела");
			ОбластьПодвалРаздела.Параметры.ПояснениеРаздела = НайденнаяСтрокаРаздела.Пояснение;
			ТабличныйДокумент.Вывести(ОбластьПодвалРаздела);
			
			ОбластьСтрокаЗаполнения = Макет.ПолучитьОбласть("СтрокаЗаполнения");
			ОбластьКолонтитулНижний = Макет.ПолучитьОбласть("КолонтитулНижний");
			ОбластьКолонтитулНижний.Параметры.Пояснение = ДокументСсылка.Пояснение;
			
			МассивОбластей = Новый Массив;
			МассивОбластей.Добавить(ОбластьСтрокаЗаполнения);
			МассивОбластей.Добавить(ОбластьКолонтитулНижний);
			Пока ТабличныйДокумент.ПроверитьВывод(МассивОбластей) Цикл
				ТабличныйДокумент.Вывести(ОбластьСтрокаЗаполнения);
			КонецЦикла;
			
			ОбластьКолонтитулНижний = Макет.ПолучитьОбласть("КолонтитулНижний");
			ОбластьКолонтитулНижний.Параметры.Пояснение = ДокументСсылка.Пояснение;
			ТабличныйДокумент.Вывести(ОбластьКолонтитулНижний);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли
