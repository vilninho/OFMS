//rarus tenkam 07.09.2017 mantis 9425 +++

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("МассивИзделий") Тогда
		НаДату = ТекущаяДата();
		ЗаполнитьАКБ(Параметры.МассивИзделий);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАКБ(МассивИзделий)
	ХарактеристикиАКБ.Очистить();
	
	Для Каждого ТекИзделие Из МассивИзделий Цикл
		ПорядокАКБ = 1;
		НоваяСтрока = ХарактеристикиАКБ.Добавить(); 		
		ТекАКБ = ПолучитьАКБИзделия(ТекИзделие, 1);
		НоваяСтрока.АКБ = ТекАКБ;
		НоваяСтрока.Изделие = ТекИзделие;
		НоваяСтрока.ПорядокАКБ = ПорядокАКБ;
		Если ЗначениеЗаполнено(ТекАКБ) Тогда
			НоваяСтрока.НомерАКБ = ТекАКБ.НомерАКБ;
		КонецЕсли;
		
		ПорядокАКБ = 2;
		НоваяСтрока = ХарактеристикиАКБ.Добавить(); 		
		ТекАКБ = ПолучитьАКБИзделия(ТекИзделие, 2);
		НоваяСтрока.АКБ = ТекАКБ;
		НоваяСтрока.Изделие = ТекИзделие;
		НоваяСтрока.ПорядокАКБ = ПорядокАКБ;
		Если ЗначениеЗаполнено(ТекАКБ) Тогда
			НоваяСтрока.НомерАКБ = ТекАКБ.НомерАКБ;
		КонецЕсли;
	КонецЦикла;
	
	//МассивАКБ = ПолучитьАКБИзделий(МассивИзделий);
	//Для Каждого ТекАКБ Из МассивАКБ Цикл
	//	НоваяСтрока = ХарактеристикиАКБ.Добавить();
	//	НоваяСтрока.АКБ = ТекАКБ.АКБ;
	//	НоваяСтрока.Изделие = ТекАКБ.Изделие;
	//	НоваяСтрока.НомерАКБ = ТекАКБ.НомерАКБ;
	//	НоваяСтрока.ПорядокАКБ = ТекАКБ.ПорядокАКБ;		
	//КонецЦикла;
КонецПроцедуры
//rarus bonmak 09.08.2021 16834 ++
//&НаСервереБезКонтекста
//Функция ПолучитьАКБИзделий(МассивИзделий)
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	Scan_АккумуляторныеБатареи.Ссылка КАК Ссылка,
//		|	Scan_АккумуляторныеБатареи.Изделие КАК Изделие
//		|ИЗ
//		|	Справочник.Scan_АккумуляторныеБатареи КАК Scan_АккумуляторныеБатареи
//		|ГДЕ
//		|	Scan_АккумуляторныеБатареи.Изделие В(&МассивИзделий)
//		|	И Scan_АккумуляторныеБатареи.ПометкаУдаления = ЛОЖЬ";
//	Запрос.УстановитьПараметр("МассивИзделий", МассивИзделий);  	
//	РезультатЗапроса = Запрос.Выполнить(); 
//	ТаблицаАКБ = РезультатЗапроса.Выгрузить();
//	МассивАКБ = Новый Массив;
//	Для Каждого ТекСтрока Из ТаблицаАКБ Цикл
//		СтруктураАКБ = Новый Структура;
//		СтруктураАКБ.Вставить("АКБ", ТекСтрока.Ссылка);
//		СтруктураАКБ.Вставить("Изделие", ТекСтрока.Изделие); 		
//		МассивАКБ.Добавить(СтруктураАКБ);
//	КонецЦикла;
//	Возврат МассивАКБ;

//КонецФункции
//rarus bonmak 09.08.2021 16834 --

&НаСервереБезКонтекста
Функция ПолучитьАКБИзделия(ИзделиеСсылка, ПорядокАКБ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_АккумуляторныеБатареи.Ссылка КАК Ссылка,
		|	Scan_АккумуляторныеБатареи.Изделие КАК Изделие
		|ИЗ
		|	Справочник.Scan_АккумуляторныеБатареи КАК Scan_АккумуляторныеБатареи
		|ГДЕ
		|	Scan_АккумуляторныеБатареи.Изделие = &ИзделиеСсылка
		|	И Scan_АккумуляторныеБатареи.ПометкаУдаления = ЛОЖЬ
		|	И Scan_АккумуляторныеБатареи.ПорядокАКБ = &ПорядокАКБ";
	Запрос.УстановитьПараметр("ИзделиеСсылка", ИзделиеСсылка);
	Запрос.УстановитьПараметр("ПорядокАКБ", ПорядокАКБ);
	РезультатЗапроса = Запрос.Выполнить(); 
	ВыборкаРезультата = РезультатЗапроса.Выбрать();
	
	Если ВыборкаРезультата.Следующий() Тогда
		Возврат ВыборкаРезультата.Ссылка;	
	КонецЕсли;
	Возврат Справочники.Scan_СостоянияАКБ.ПустаяСсылка();

КонецФункции

&НаКлиенте
Процедура ХарактеристикиАКБПараметрПриИзменении(Элемент)
	СоответствиеХарактеристик = Новый Соответствие;
	СоответствиеХарактеристик.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.ПусковойТок"), Элементы.ХарактеристикиАКБ.ТекущиеДанные.ПусковойТок);
	СоответствиеХарактеристик.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.Плотность"),  Элементы.ХарактеристикиАКБ.ТекущиеДанные.Плотность);
	СоответствиеХарактеристик.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.НапряжениеБезНагрузки"),  Элементы.ХарактеристикиАКБ.ТекущиеДанные.НапряжениеБезНагрузки);
	СоответствиеХарактеристик.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.НапряжениеПодНагрузкой"),  Элементы.ХарактеристикиАКБ.ТекущиеДанные.НапряжениеПодНагрузкой);
	СоответствиеХарактеристик.Вставить("Емкость",  Элементы.ХарактеристикиАКБ.ТекущиеДанные.Емкость);
	Элементы.ХарактеристикиАКБ.ТекущиеДанные.Состояние = ПолучитьСостояние(СоответствиеХарактеристик);
	ОбновлениеУсловногоОформленияСтрок();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСостояние(СоответствиеХарактеристик)
	Возврат Справочники.Scan_СостоянияАКБ.ПолучитьСостояниеПоХарактеристикам(СоответствиеХарактеристик);	
КонецФункции

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	СообщениеОЗаписи = "";
	МассивСтрокДляУдаления = Новый Массив;
	Для Каждого ТекАКБ Из ХарактеристикиАКБ Цикл
		
		// Если АКБ нет, то запишем
		//Если НЕ ЗначениеЗаполнено(ТекАКБ.АКБ) И ЗначениеЗаполнено(ТекАКБ.НомерАКБ) Тогда
		Если НЕ ЗначениеЗаполнено(ТекАКБ.АКБ) Тогда
			НоваяАКБ = Справочники.Scan_АккумуляторныеБатареи.СоздатьЭлемент();
			НоваяАКБ.НомерАКБ = ТекАКБ.НомерАКБ;
			НоваяАКБ.Изделие = ТекАКБ.Изделие;
			НоваяАКБ.ПорядокАКБ = ТекАКБ.ПорядокАКБ;
			НоваяАКБ.Наименование = ТекАКБ.Изделие.НомерИзделия + ", АКБ " + ТекАКБ.ПорядокАКБ + ", " + ТекАКБ.НомерАКБ;;
			Попытка
				НоваяАКБ.Записать();			
				ТекАКБ.АКБ = НоваяАКБ.Ссылка;
				//rarus FominskiyAS 24.04.2019  mantis 14191 +++
				//Сообщить("Создан новый элемент " + НоваяАКБ.Наименование);
				Сообщить(НСтр("ru = 'Создан новый элемент '; en = 'New item created '") + НоваяАКБ.Наименование);
				//rarus FominskiyAS 24.04.2019  mantis 14191 ---  
			Исключение
				Продолжить;
			КонецПопытки;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ТекАКБ.Состояние) Тогда
			Продолжить;
		КонецЕсли;             
		
		СтруктураХарактеристик = Новый Структура;
		СтруктураХарактеристик.Вставить("ПусковойТок", ТекАКБ.ПусковойТок);
		СтруктураХарактеристик.Вставить("Плотность", ТекАКБ.Плотность);
		СтруктураХарактеристик.Вставить("НапряжениеБезНагрузки", ТекАКБ.НапряжениеБезНагрузки);
		СтруктураХарактеристик.Вставить("НапряжениеПодНагрузкой", ТекАКБ.НапряжениеПодНагрузкой);
		СтруктураХарактеристик.Вставить("Емкость", ТекАКБ.Емкость);
		СтруктураХарактеристик.Вставить("Состояние", ТекАКБ.Состояние);
		РегистрыСведений.Scan_ДанныеПоАКБИзделий.ЗаписатьХарактеристикиАКБ(ТекАКБ.АКБ ,ТекАКБ.Изделие,СтруктураХарактеристик, НаДату);
		СообщениеОЗаписи = СообщениеОЗаписи + ТекАКБ.АКБ + Символы.ПС;
		МассивСтрокДляУдаления.Добавить(ТекАКБ);
	КонецЦикла;
	Если ЗначениеЗаполнено(СокрЛП(СообщениеОЗаписи)) Тогда
		//rarus FominskiyAS 24.04.2019  mantis 14191 +++
		//Сообщить("Записаны данные по АКБ:" + Символы.ПС + СообщениеОЗаписи);
		Сообщить(НСтр("ru = 'Записаны данные по АКБ: '; en = 'Battery data saved: '") + Символы.ПС + СообщениеОЗаписи);
		//rarus FominskiyAS 24.04.2019  mantis 14191 ---   		
	КонецЕсли;
	
	Для Каждого Строка Из МассивСтрокДляУдаления Цикл
		ХарактеристикиАКБ.Удалить(Строка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновлениеУсловногоОформленияСтрок()
	СправочникМенеджер = Справочники.Scan_СостоянияАКБ;
	Scan_УправлениеДиалогомСервер.СформироватьУсловноеОформление(ЭтаФорма, СправочникМенеджер,"Состояние",,,"ХарактеристикиАКБ");
КонецПроцедуры 

&НаКлиенте
Процедура ХарактеристикиАКБПриАктивизацииСтроки(Элемент)
	Если Элементы.ХарактеристикиАКБ.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Элементы.ХарактеристикиАКБ.ТекущиеДанные.АКБ) Тогда
		Элементы.ХарактеристикиАКБНомерАКБ.ТолькоПросмотр = Истина;
	Иначе
		Элементы.ХарактеристикиАКБНомерАКБ.ТолькоПросмотр = Ложь;	
	КонецЕсли;
КонецПроцедуры

//rarus tenkam 07.09.2017 mantis 9425 ---
