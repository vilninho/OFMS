//Rarus bonmak 28.07.2022 18726 добавил области

#Область ОбработчикиСобытийФормы

//rarus vikhle 23.06.2020 mt 15888 +++
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТаблицаНачальная = ПолучитьИзВременногоХранилища(Параметры.АдресВременногоХранилища);
	ОбъектНастройки = Параметры.ОбъектНастройки;
	
	Если ОбъектНастройки = "Scan_СоглашенияОПоставке" Тогда
		//rarus vikhle 12.08.2021 mt 17834 +++
		Если Параметры.ТипЗаявки = Перечисления.Scan_ТипыСоглашенийОПоставке.ЗаявкаНаСОПSRU Тогда
			ТаблицаИменЭлементов = Справочники.Scan_СоглашенияОПоставке.ПолучитьСписокЭлементовДляНастройки(Параметры.ТипЗаявки);
			
			ТипСоглашенияОПоставке = Параметры.ТипЗаявки;
			Элементы.ТипСоглашенияОПоставке.СписокВыбора.Добавить(Перечисления.Scan_ТипыСоглашенийОПоставке.ЗаявкаНаСОПSRU);
		Иначе
			ТаблицаИменЭлементов = Справочники.Scan_СоглашенияОПоставке.ПолучитьСписокЭлементовДляНастройки();	
			
			Элементы.ТипСоглашенияОПоставке.СписокВыбора.Добавить(Перечисления.Scan_ТипыСоглашенийОПоставке.ЗаявкаНаСклад);
			Элементы.ТипСоглашенияОПоставке.СписокВыбора.Добавить(Перечисления.Scan_ТипыСоглашенийОПоставке.ЗаявкаНаСОП);
		КонецЕсли;
		//rarus vikhle 12.08.2021 mt 17834 ---
		Статус = Справочники.Scan_СтатусыСоглашенийОПоставкеИСпециальныхУсловий.ПустаяСсылка();
		Элементы.ХозОперация.ТолькоПросмотр = Истина;
	ИначеЕсли ОбъектНастройки = "Scan_СпециальныеУсловия" Тогда 
		ТаблицаИменЭлементов = Справочники.Scan_СпециальныеУсловия.ПолучитьСписокЭлементовДляНастройки();
		Статус = Справочники.Scan_СтатусыСоглашенийОПоставкеИСпециальныхУсловий.ПустаяСсылка();
		Элементы.ХозОперация.ТолькоПросмотр = Истина;
		Элементы.ТипСоглашенияОПоставке.ТолькоПросмотр = Истина;	
	ИначеЕсли ОбъектНастройки = "Scan_Калькуляция" Тогда
		ТаблицаИменЭлементов = Документы.Scan_Калькуляция.ПолучитьСписокЭлементовДляНастройки();
		Статус = Справочники.Scan_СтатусыКалькуляций.ПустаяСсылка();
		Элементы.ТипСоглашенияОПоставке.ТолькоПросмотр = Истина;
	ИначеЕсли ОбъектНастройки = "Scan_ЗаявкаНаОтгрузку" Тогда
		ТаблицаИменЭлементов = Документы.Scan_ЗаявкаНаОтгрузку.ПолучитьСписокЭлементовДляНастройки();
		Статус = Справочники.Scan_СтатусыЗаявокНаОтгрузку.ПустаяСсылка();
		Элементы.ТипСоглашенияОПоставке.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	//Добавление необходимых имен элементов формы, которых нет в наборе-источнике 
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаИменЭлементов.ИмяЭлемента КАК ИмяЭлемента
	               |ПОМЕСТИТЬ ТаблицаИменЭлементов
	               |ИЗ
	               |	&ТаблицаИменЭлементов КАК ТаблицаИменЭлементов
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТаблицаНачальная.ИмяЭлемента КАК ИмяЭлемента
	               |ПОМЕСТИТЬ ТаблицаНачальная
	               |ИЗ
	               |	&ТаблицаНачальная КАК ТаблицаНачальная
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТаблицаИменЭлементов.ИмяЭлемента КАК ИмяЭлемента
	               |ИЗ
	               |	ТаблицаИменЭлементов КАК ТаблицаИменЭлементов
	               |ГДЕ
	               |	НЕ ТаблицаИменЭлементов.ИмяЭлемента В
	               |				(ВЫБРАТЬ
	               |					ТаблицаНачальная.ИмяЭлемента
	               |				ИЗ
	               |					ТаблицаНачальная)";
	Запрос.УстановитьПараметр("ТаблицаНачальная",ТаблицаНачальная);
	Запрос.УстановитьПараметр("ТаблицаИменЭлементов",ТаблицаИменЭлементов);
	ТаблицаНовыхЭлементов = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из ТаблицаНовыхЭлементов Цикл
		НоваяСтрока = ТаблицаНачальная.Добавить();
		НоваяСтрока.ИмяЭлемента = СтрокаТаблицы.ИмяЭлемента;
		НоваяСтрока.Видимость 	= Ложь;
		НоваяСтрока.Доступность = Ложь;
	КонецЦикла;
		
	ТаблицаЭлементов.Загрузить(ТаблицаНачальная);	

КонецПроцедуры

#КонецОбласти

#Область СлужебныеФункцииИПроцедуры

&НаКлиенте
Процедура СоздатьНабор(Команда)
	
	Если ЗначениеЗаполнено(Статус) И ЗначениеЗаполнено(РольИсполнителя)
		И (ЗначениеЗаполнено(ТипСоглашенияОПоставке) ИЛИ ОбъектНастройки <> "Scan_СоглашенияОПоставке") Тогда
			Если СуществуютЗаписи() Тогда
				Оповещение = Новый ОписаниеОповещения("ПослеПредупреждения",ЭтотОбъект);
				ПоказатьВопрос(Оповещение,"Для указанных параметров существуют записи, они будут заменены, продолжить?",
							РежимДиалогаВопрос.ДаНет);	
			Иначе
				СоздатьНаборНаСервере();	
				ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.Scan_ПараметрыВидимостиОбъектов"));	
			КонецЕсли;	
	Иначе
		Сообщить("Не заполнены необходимые поля");		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьНаборНаСервере()
		
	НаборЗаписей = РегистрыСведений.Scan_ПараметрыВидимостиОбъектов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Статус.Установить(Статус);
	НаборЗаписей.Отбор.РольИсполнителя.Установить(РольИсполнителя);
	НаборЗаписей.Отбор.ТипСоглашенияОПоставке.Установить(ТипСоглашенияОПоставке);
	НаборЗаписей.Отбор.ОбъектНастройки.Установить(ОбъектНастройки);
	НаборЗаписей.Отбор.ХозОперация.Установить(ХозОперация);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	Для Каждого Элемент Из ТаблицаЭлементов Цикл
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.ОбъектНастройки        = ОбъектНастройки;
		НоваяЗапись.РольИсполнителя        = РольИсполнителя;
		НоваяЗапись.Статус                 = Статус;
		НоваяЗапись.ТипСоглашенияОПоставке = ТипСоглашенияОПоставке;
		НоваяЗапись.ХозОперация            = ХозОперация;
		НоваяЗапись.ИмяЭлемента            = Элемент.ИмяЭлемента;
		НоваяЗапись.Видимость              = Элемент.Видимость;
		НоваяЗапись.Доступность            = Элемент.Доступность;
		//rarus agar 15.07.2020  16055 ++
		НоваяЗапись.РучноеИзменение        = Истина;
		//rarus agar 15.07.2020  16055 --
	КонецЦикла;
	
	Попытка
		НаборЗаписей.Записать();
		Сообщить("Набор успешно создан");
	Исключение
		Сообщить("Не удалось создать набор записей");
	КонецПопытки;	
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеПредупреждения(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
    	СоздатьНаборНаСервере();
		ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.Scan_ПараметрыВидимостиОбъектов"));
	КонецЕсли;		
	
КонецПроцедуры

&НаСервере
Функция СуществуютЗаписи()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_ПараметрыВидимостиОбъектов.ОбъектНастройки КАК ОбъектНастройки,
	               |	Scan_ПараметрыВидимостиОбъектов.РольИсполнителя КАК РольИсполнителя,
	               |	Scan_ПараметрыВидимостиОбъектов.ТипСоглашенияОПоставке КАК ТипСоглашенияОПоставке,
	               |	Scan_ПараметрыВидимостиОбъектов.Статус КАК Статус,
	               |	Scan_ПараметрыВидимостиОбъектов.ИмяЭлемента КАК ИмяЭлемента,
	               |	Scan_ПараметрыВидимостиОбъектов.ХозОперация КАК ХозОперация,
	               |	Scan_ПараметрыВидимостиОбъектов.Видимость КАК Видимость,
	               |	Scan_ПараметрыВидимостиОбъектов.Доступность КАК Доступность
	               |ИЗ
	               |	РегистрСведений.Scan_ПараметрыВидимостиОбъектов КАК Scan_ПараметрыВидимостиОбъектов
	               |ГДЕ
	               |	Scan_ПараметрыВидимостиОбъектов.ОбъектНастройки = &ОбъектНастройки
	               |	И Scan_ПараметрыВидимостиОбъектов.РольИсполнителя = &РольИсполнителя
	               |	И Scan_ПараметрыВидимостиОбъектов.ТипСоглашенияОПоставке = &ТипСоглашенияОПоставке
	               |	И Scan_ПараметрыВидимостиОбъектов.Статус = &Статус
	               |	И Scan_ПараметрыВидимостиОбъектов.ХозОперация = &ХозОперация";
	Запрос.УстановитьПараметр("ОбъектНастройки",ОбъектНастройки);
	Запрос.УстановитьПараметр("РольИсполнителя",РольИсполнителя);
	Запрос.УстановитьПараметр("ТипСоглашенияОПоставке",ТипСоглашенияОПоставке);
	Запрос.УстановитьПараметр("Статус",Статус);
	Запрос.УстановитьПараметр("ХозОперация",ХозОперация);
	РезультатЗапроса = Запрос.Выполнить();	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтатусНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	//пустой массив для обнуления отборов в параметре выбор
	МассивПараметров = Новый Массив();
	ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	Элемент.ПараметрыВыбора = ПараметрыВыбора;
	
	Если ОбъектНастройки = "Scan_СоглашенияОПоставке" Тогда   
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ИспользуетсяВСоглашенииОПоставке", Истина));
		Если ТипСоглашенияОПоставке = ПредопределенноеЗначение("Перечисление.Scan_ТипыСоглашенийОПоставке.ЗаявкаНаСклад") Тогда
			МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ИспользуетсяВТипеЗаявкаНаСклад", Истина));
		ИначеЕсли ТипСоглашенияОПоставке = ПредопределенноеЗначение("Перечисление.Scan_ТипыСоглашенийОПоставке.ЗаявкаНаСОП") Тогда
			МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ИспользуетсяВТипеЗаявкаНаСОП", Истина));
		//rarus vikhle 05.08.2021 mt 17834 +++	
		ИначеЕсли ТипСоглашенияОПоставке = ПредопределенноеЗначение("Перечисление.Scan_ТипыСоглашенийОПоставке.ЗаявкаНаСОПSRU") Тогда
			МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ИспользуетсяВТипеЗаявкаНаСОПSRU", Истина));	
		КонецЕсли;	
		//rarus vikhle 05.08.2021 mt 17834 ---
		ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
		Элемент.ПараметрыВыбора = ПараметрыВыбора;	
	ИначеЕсли ОбъектНастройки = "Scan_СпециальныеУсловия"	Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ИспользуетсяВСпециальныхУсловиях", Истина));
		ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
		Элемент.ПараметрыВыбора = ПараметрыВыбора;		
	КонецЕсли;
	
КонецПроцедуры
//rarus vikhle 23.06.2020 mt 15888 ---

#КонецОбласти