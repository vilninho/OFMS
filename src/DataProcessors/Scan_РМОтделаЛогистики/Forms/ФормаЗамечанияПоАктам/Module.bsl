//rarus tenkam 05.10.2017 mantis 9426 +++

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("МассивИзделий") Тогда
		СписокИзделий.ЗагрузитьЗначения(Параметры.МассивИзделий);
	КонецЕсли;
	СписокКодовНеисправностей = Элементы.ТабЗамечанияПоАктамКодНеисправностиКод.СписокВыбора;
	ПолучитьСписокКодовНеисправностей(СписокКодовНеисправностей);
	СписокКодовДефектов = Элементы.ТабЗамечанияПоАктамКодДефектаКод.СписокВыбора;
	ПолучитьСписокКодовДефектов(СписокКодовДефектов);
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	Если СписокИзделий.Количество() = 0 ИЛИ ТабЗамечанияПоАктам.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	//rarus tenkam 09.10.2017 mantis 9426 +++  
	Отказ = Ложь;
	Для Индекс = 0 по ТабЗамечанияПоАктам.Количество()-1 Цикл
		ТекСтрокаЗамечания = ТабЗамечанияПоАктам.Получить(Индекс);
		Если Не ЗначениеЗаполнено(ТекСтрокаЗамечания.ДатаОбнаружения) Тогда
			Сообщение = Новый СообщениеПользователю();
			//rarus FominskiyAS 24.04.2019  mantis 14191 +++
			//Сообщение.Текст = "В строке " + (Индекс + 1) + " не заполнена дата обнаружения";
			Сообщение.Текст = НСтр("ru = 'В строке '; en = 'In line '") + (Индекс + 1) + НСтр("ru = ' не заполнена дата обнаружения'; en = ' detection date is not filled'");
			//rarus FominskiyAS 24.04.2019  mantis 14191 --- 
			Сообщение.Поле = "ТабЗамечанияПоАктам[" + Индекс + "].ДатаОбнаружения";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла; 
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	//rarus tenkam 09.10.2017 mantis 9426 ---
	
	ЗаписатьЗамечанияВРегистр();
	СообщениеВывод = "Для изделий:" + Символы.ПС;
	
	Для Каждого ТекЭлемент Из СписокИзделий Цикл
		СообщениеВывод = СообщениеВывод + ТекЭлемент.Значение + Символы.ПС;
	КонецЦикла;
	СообщениеВывод = СообщениеВывод + " установлены замечания по актам.";
	Сообщить(СообщениеВывод);
КонецПроцедуры

&НаСервере
Процедура ЗаписатьЗамечанияВРегистр()
	Для Каждого ТекЭлемент Из СписокИзделий Цикл
		РегистрыСведений.Scan_ЗамечанияПоАктамПриемоПередачи.ДобавитьЗамечанияПоИзделиюВРегистр(ТекЭлемент.Значение,ТабЗамечанияПоАктам);
		СформироватьЗамечаниеИзделия(ТекЭлемент.Значение);	
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолучитьСписокКодовНеисправностей(СписокКодов)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_КодыНеисправныхДеталей.КодДетали КАК КодДетали
		|ИЗ
		|	Справочник.Scan_КодыНеисправныхДеталей КАК Scan_КодыНеисправныхДеталей
		|
		|СГРУППИРОВАТЬ ПО
		|	Scan_КодыНеисправныхДеталей.КодДетали
		|
		|УПОРЯДОЧИТЬ ПО
		|	КодДетали";
	
	РезультатЗапроса = Запрос.Выполнить();
	ТабКодов = РезультатЗапроса.Выгрузить();
	Если ТабКодов.Количество() <> 0 Тогда
		Для Каждого ТекКод Из ТабКодов Цикл
			СписокКодов.Добавить(ТекКод.КодДетали, ТекКод.КодДетали);
		КонецЦикла;		
	Иначе
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолучитьСписокКодовДефектов(СписокКодов)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_КодыДефектов.КодДефекта КАК КодДефекта
		|ИЗ
		|	Справочник.Scan_КодыДефектов КАК Scan_КодыДефектов
		|
		|СГРУППИРОВАТЬ ПО
		|	Scan_КодыДефектов.КодДефекта
		|
		|УПОРЯДОЧИТЬ ПО
		|	КодДефекта";
	
	РезультатЗапроса = Запрос.Выполнить();
	ТабКодов = РезультатЗапроса.Выгрузить();
	Если ТабКодов.Количество() <> 0 Тогда
		Для Каждого ТекКод Из ТабКодов Цикл
			СписокКодов.Добавить(ТекКод.КодДефекта, ТекКод.КодДефекта);
		КонецЦикла;		
	Иначе
		Возврат;
	КонецЕсли;
КонецПроцедуры 

&НаКлиенте
Процедура СформироватьЗамечаниеСтроки(ТекСтрока)
	Если ЗначениеЗаполнено(ТекСтрока.КодНеисправнойДетали) И ЗначениеЗаполнено(ТекСтрока.КодДефекта) Тогда
		Элементы.ТабЗамечанияПоАктамЗамечание.ТолькоПросмотр = Истина;
		Если ТекСтрока.КодНеисправнойДетали = ПредопределенноеЗначение("Справочник.Scan_КодыНеисправныхДеталей.Прочее") И
			ТекСтрока.КодДефекта = ПредопределенноеЗначение("Справочник.Scan_КодыДефектов.Прочее") Тогда
			
			Элементы.ТабЗамечанияПоАктамЗамечание.ТолькоПросмотр = Ложь;
			ТекСтрока.Замечание = ""; 
			Элементы.ТабЗамечанияПоАктамЗамечание.ПодсказкаВвода = "Текст произвольного замечания";
		Иначе
			ТекСтрока.Замечание = Строка(ТекСтрока.КодНеисправнойДетали) + " - " + ТекСтрока.КодДефекта;
			Элементы.ТабЗамечанияПоАктамЗамечание.ПодсказкаВвода = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьНеисправностьПоКоду(Код);
	Если НЕ ЗначениеЗаполнено(Код) Тогда
		Возврат Справочники.Scan_КодыНеисправныхДеталей.ПустаяСсылка();
	Иначе
		Возврат Справочники.Scan_КодыНеисправныхДеталей.НайтиПоРеквизиту("КодДетали", Код);	
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьКодПоНеисправности(Неисправность);
	Если НЕ ЗначениеЗаполнено(Неисправность) Тогда
		Возврат "";
	Иначе
		Возврат Неисправность.КодДетали;	
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьДефектПоКоду(Код);
	Если НЕ ЗначениеЗаполнено(Код) Тогда
		Возврат Справочники.Scan_КодыДефектов.ПустаяСсылка();
	Иначе
		Возврат Справочники.Scan_КодыДефектов.НайтиПоРеквизиту("КодДефекта", Код);	
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьКодПоДефекту(Дефект);
	Если НЕ ЗначениеЗаполнено(Дефект) Тогда
		Возврат "";
	Иначе
		Возврат Дефект.КодДефекта;	
	КонецЕсли;
КонецФункции   

&НаКлиенте
Процедура ТабЗамечанияПоАктамПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ТекСтрока = Элемент.ТекущиеДанные;
	
	Если НоваяСтрока И СокрЛП(ТекСтрока.МестоОбнаружения) = "" И СокрЛП(ТекСтрока.Замечание) = "" Тогда
		//удалим пустую строчку                        
		ТабЗамечанияПоАктам.Удалить(ТекСтрока);
		Возврат;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ТабЗамечанияПоАктамКодНеисправностиКодПриИзменении(Элемент)
	ТекДанные = Элементы.ТабЗамечанияПоАктам.ТекущиеДанные;
	
	ТекДанные.КодНеисправнойДетали = ПолучитьНеисправностьПоКоду(ТекДанные.КодНеисправностиКод);
	СформироватьЗамечаниеСтроки(ТекДанные);
КонецПроцедуры

&НаКлиенте
Процедура ТабЗамечанияПоАктамКодНеисправнойДеталиПриИзменении(Элемент)
	ТекДанные = Элементы.ТабЗамечанияПоАктам.ТекущиеДанные;
	
	ТекДанные.КодНеисправностиКод = ПолучитьКодПоНеисправности(ТекДанные.КодНеисправнойДетали);
	СформироватьЗамечаниеСтроки(ТекДанные);
КонецПроцедуры

&НаКлиенте
Процедура ТабЗамечанияПоАктамКодДефектаКодПриИзменении(Элемент)
	ТекДанные = Элементы.ТабЗамечанияПоАктам.ТекущиеДанные;
	
	ТекДанные.КодДефекта = ПолучитьДефектПоКоду(ТекДанные.КодДефектаКод);
	СформироватьЗамечаниеСтроки(ТекДанные);

КонецПроцедуры

&НаКлиенте
Процедура ТабЗамечанияПоАктамКодДефектаПриИзменении(Элемент)
	ТекДанные = Элементы.ТабЗамечанияПоАктам.ТекущиеДанные;
	
	ТекДанные.КодДефектаКод = ПолучитьКодПоДефекту(ТекДанные.КодДефекта);
	СформироватьЗамечаниеСтроки(ТекДанные);
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепитьФото(Команда)
	// rarus tenkam 10.04.2019 mantis 14195 +++

	//ВыбранныеФайлы = Новый Массив;
	//
	//ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	//ВыборФайла.МножественныйВыбор = Истина;
	//ВыборФайла.Заголовок = НСтр("ru = 'Выбор файла'");
	//ВыборФайла.Фильтр = НСтр("ru = 'Все файлы'") + " (*.*)|*.*";
	//	
	//Если ВыборФайла.Выбрать() Тогда
	//	ВыбранныеФайлы = ВыборФайла.ВыбранныеФайлы;
	//КонецЕсли;
	//
	//Если ВыбранныеФайлы.Количество() <> 0 Тогда
	//	ДопПараметры = Новый Структура;
	//	ДопПараметры.Вставить("ИдентификаторФормы", ЭтаФорма.УникальныйИдентификатор);
	//	ДопПараметры.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", Истина);
	//	ДопПараметры.Вставить("ВыбранныеФайлы", ВыбранныеФайлы);
	//	
	//	Для Каждого ТекЭлемент Из СписокИзделий Цикл
	//		ДопПараметры.Вставить("ВладелецФайла", ТекЭлемент.Значение);
	//		ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлыРасширениеПредложено", ПрисоединенныеФайлыСлужебныйКлиент, ДопПараметры);
	//		ФайловыеФункцииСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	//	КонецЦикла;		
	//КонецЕсли;
	
	РаботаСФайламиКлиент.ДобавитьФайлы(СписокИзделий.ВыгрузитьЗначения(), ЭтаФорма.УникальныйИдентификатор, , );
	
	// rarus tenkam 10.04.2019 mantis 14195 --- 
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СформироватьЗамечаниеИзделия(ИзделиеСсылка)
	
	ТабЗамечанияПоАктам = РегистрыСведений.Scan_ЗамечанияПоАктамПриемоПередачи.ПолучитьЗамечанияПоИзделиюИзРегистра(ИзделиеСсылка);
	
	ВремЗамечание = "";
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Устранено", Ложь);
	НайденныеСтроки = ТабЗамечанияПоАктам.НайтиСтроки(ПараметрыОтбора);
	Для Каждого СтрокаЗамечания Из НайденныеСтроки Цикл
		Если ВремЗамечание = "" Тогда
			ВремЗамечание = СокрЛП(СтрокаЗамечания.Замечание) + ?(ЗначениеЗаполнено(СтрокаЗамечания.Количество)," (" + СтрокаЗамечания.Количество + ")", "");
		Иначе
			ВремЗамечание = ВремЗамечание + ", " + СокрЛП(СтрокаЗамечания.Замечание) + ?(ЗначениеЗаполнено(СтрокаЗамечания.Количество)," (" + СтрокаЗамечания.Количество + ")", "");
		КонецЕсли;  		
	КонецЦикла;
	
	Если ВремЗамечание = "" Тогда
		ВремЗамечание = "НОРМА";
	КонецЕсли;
	
	Если ВремЗамечание <> ИзделиеСсылка.Замечание Тогда
		ИзделиеОбъект = ИзделиеСсылка.ПолучитьОбъект();
		ИзделиеОбъект.Замечание = ВремЗамечание;
		ИзделиеОбъект.Записать();
	КонецЕсли;
КонецПроцедуры
//rarus tenkam 05.10.2017 mantis 9426 ---

