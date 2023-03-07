// Производит получение вида операции
Функция ПроверитьОсновнойДоговор(Договор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДоговорыВзаиморасчетов.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Scan_ДоговорыВзаиморасчетов КАК ДоговорыВзаиморасчетов
	               |ГДЕ
	               |	ДоговорыВзаиморасчетов.ВидДоговора = &ВидДоговора
	               |	И ДоговорыВзаиморасчетов.Основной = ИСТИНА
	               |	И ДоговорыВзаиморасчетов.ПометкаУдаления = ЛОЖЬ
	               |	И ДоговорыВзаиморасчетов.Ссылка <> &Ссылка
	               |	И ДоговорыВзаиморасчетов.Владелец = &Владелец
	               |	И ДоговорыВзаиморасчетов.Недействителен = ЛОЖЬ";	// rarus tenkam 04.08.2020 mantis 16401 +
	Запрос.УстановитьПараметр("ВидДоговора",Договор.ВидДоговора);
	Запрос.УстановитьПараметр("Владелец",Договор.Владелец);
	Запрос.УстановитьПараметр("Ссылка",Договор.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.Scan_ДоговорыВзаиморасчетов.ПустаяСсылка();
	КонецЕсли;
	
	
КонецФункции //ПроверитьОсновнойДоговор()

//rarus tenkam 20.06.2016 mantis 7104 ++

// Функция записи параметров в регистр сведений
// Параметры
//  Контрагент – СправочникСсылка.Scan_Контрагенты – Контрагент для которого за
//  СрокХранения   – Число,3 – Срок бесплатного хранения
// Возвращаемое значение:
//   Булево   – ошибка записи значения
Функция ЗаписьЗначенияРегистраСведения(Договор, СрокХранения, НаДату = Неопределено) Экспорт
	
	Отказ = Ложь;

	Если НаДату = Неопределено Тогда
		ДатаЗаписи = ТекущаяДата();
	Иначе
		ДатаЗаписи = НаДату;
	КонецЕсли; 
	
	Если НЕ Отказ Тогда
		//Чтение старого значения регистра
		СтруктураОтбора   = Новый Структура("Договор", Договор);
		СтруктураСведений = РегистрыСведений.Scan_СрокиБесплатногоХраненияПродуктовУПоставщиков.ПолучитьПоследнее(ДатаЗаписи, СтруктураОтбора);
		ЗначениеСтарое    = СтруктураСведений.СрокХранения;
		Записывать        = Ложь;
		
		Если ЗначениеСтарое = 0 Тогда
			//записи не было, либо была нулевая
			Если СрокХранения <> 0 Тогда
				Записывать = Истина;	
			КонецЕсли;
		Иначе
			Если СрокХранения <> ЗначениеСтарое Тогда 
				//значение изменилось
				Записывать = Истина; 
			КонецЕсли;	
		КонецЕсли;
		
		Если Записывать Тогда
			//Значение параметра изменилось
			ЗаписьРегСведений = РегистрыСведений.Scan_СрокиБесплатногоХраненияПродуктовУПоставщиков.СоздатьМенеджерЗаписи();
			ЗаписьРегСведений.Договор	 = Договор;
			ЗаписьРегСведений.Контрагент 	 = Договор.Владелец;
			ЗаписьРегСведений.СрокХранения	 = СрокХранения;
			ЗаписьРегСведений.Пользователь	 = ПользователиКлиентСервер.ТекущийПользователь();
			ЗаписьРегСведений.Период		 = ДатаЗаписи;
			Попытка
				ЗаписьРегСведений.Записать();
			Исключение
				//rarus FominskiyAS 19.04.2019  mantis 14191 +++
				//Сообщить(НСтр("ru = 'Ошибка записи срока хранения в регистр сведений'"));
				Сообщить(НСтр("ru = 'Ошибка записи срока хранения в регистр сведений'; en = 'Storage period was not saved'"));
				//rarus FominskiyAS 19.04.2019  mantis 14191 ---  
				Отказ = Истина;
			КонецПопытки; 
		КонецЕсли; 
	КонецЕсли; 
		
	Возврат Отказ;
КонецФункции // ЗаписьЗначенияРегистраСведения()

// Функция чтения параметров в регистр сведений
// Параметры
//  Контрагент – СправочникСсылка.Scan_Контрагенты – Конрагент для которого за
// Возвращаемое значение:
//   Булево   – ошибка записи значения
Функция ЧтениеЗначенияРегистраСведения(Договор, НаДату = Неопределено) Экспорт
	Если НаДату = Неопределено Тогда
		ДатаЗаписи = Неопределено;
	Иначе
		//ДатаЗаписи = НачалоДня(НаДату);
		ДатаЗаписи = НаДату;
	КонецЕсли;
	СтруктураОтбора   = Новый Структура("Договор", Договор);
	СтруктураСведений = РегистрыСведений.Scan_СрокиБесплатногоХраненияПродуктовУПоставщиков.ПолучитьПоследнее(ДатаЗаписи, СтруктураОтбора);
	Возврат СтруктураСведений.Значение;
КонецФункции

//rarus tenkam 20.06.2016 mantis 7104 --
//rarus bonmak 09.08.2021 16834 ++
//rarus sergei 08.08.2016 mantis 7092 ++
//Процедура РассчитатьСуммуПродуажиПродукта(Договор,НомерСтроки) Экспорт

//	Договор.СпецификацияКСОП[НомерСтроки-1].СОП_СуммаПродажиБезНДС = Договор.СпецификацияКСОП[НомерСтроки-1].СОП_Количество*Договор.СпецификацияКСОП[НомерСтроки-1].СОП_ЦенаПродажиБезНДС;	

//КонецПроцедуры
//rarus bonmak 09.08.2021 16834 --
//rarus bonmak 09.08.2021 16834 ++
//Процедура РассчитатьСуммыПоСОП(Договор) Экспорт

//	Если Договор.ВидДоговора = Перечисления.Scan_ВидыДоговоров.Соглашение Тогда
//	
//		Если Договор.СпецификацияКСОП.Количество() > 0  Тогда
//			Договор.СОП_СуммаПоСОПБезНДС = 0;
//			Договор.СОП_СебестоимостьСуммаБезНДС = 0;
//			Договор.СОП_СебестоимостьСумма = 0;
//			Для каждого строка Из Договор.СпецификацияКСОП Цикл
//			
//				Договор.СОП_СуммаПоСОПБезНДС = Договор.СОП_СуммаПоСОПБезНДС + строка.СОП_СуммаПродажиБезНДС;
//			    Договор.СОП_СебестоимостьСуммаБезНДС = Договор.СОП_СебестоимостьСуммаБезНДС + строка.СОП_СебестоимостьБезНДС;
//				Договор.СОП_СебестоимостьСумма = Договор.СОП_СебестоимостьСумма + строка.СОП_Себестоимость;
//			КонецЦикла; 
//			
//		
//		КонецЕсли; 	
//	
//	КонецЕсли; 	

//КонецПроцедуры  
//rarus bonmak 09.08.2021 16834 --
// Функция чтения параметров в регистр сведений
// Параметры
//  Договор – СправочникСсылка.Договорывзаиморасчетов – Договор, по которому делается запись
//  ВидЗначения – ПеречислениеСсылка.Scan_ДополнительнаяинформацияПоСОП – 
//                 Описание вида значения регистра сведений
// Возвращаемое значение:
//   Булево   – ошибка записи значения
//rarus bonmak 28.08.2019 14430 ++
//Функция ЧтениеЗначенияРегистраСведенияИсторияПоСОП(Договор,Контрагент,ОсновнойДоговор, Продукт, ВидЗначения, НаДату = Неопределено) Экспорт
//	Если НаДату = Неопределено Тогда
//		ДатаЗаписи = Неопределено;
//	Иначе
//		//ДатаЗаписи = НачалоДня(НаДату);
//		ДатаЗаписи = НаДату;
//	КонецЕсли;
//	СтруктураОтбора   = Новый Структура("Договор,Контрагент,ОсновнойДоговор,Продукт, ВидЗначения", Договор,Контрагент,ОсновнойДоговор,Продукт, ВидЗначения);
//	СтруктураСведений = РегистрыСведений.Scan_ИсторияПоСОП.ПолучитьПоследнее(ДатаЗаписи, СтруктураОтбора);
//	
//	Возврат СтруктураСведений.Значение;
//КонецФункции
//rarus bonmak 28.08.2019 14430 --

//rarus sergei 08.08.2016 mantis 7092 --

//rarus sergei 03.10.2016 mantis 7162 ++
Функция ПолучитьДоговорХранения(Владелец) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_ДоговорыВзаиморасчетов.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Scan_ДоговорыВзаиморасчетов КАК Scan_ДоговорыВзаиморасчетов
	               |ГДЕ
	               |	Scan_ДоговорыВзаиморасчетов.Владелец = &Владелец
	               |	И Scan_ДоговорыВзаиморасчетов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.Scan_ВидыДоговоров.Хранения)
	               |	И Scan_ДоговорыВзаиморасчетов.Недействителен = ЛОЖЬ";	// rarus tenkam 04.08.2020 mantis 16401 +	
	Запрос.УстановитьПараметр("Владелец",Владелец);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Справочники.Scan_ДоговорыВзаиморасчетов.ПустаяСсылка();
	Иначе 
		ВыборкаДоговор = Результат.Выбрать();
		Пока ВыборкаДоговор.Следующий() Цикл
			Возврат ВыборкаДоговор.Ссылка;
		КонецЦикла;
	КонецЕсли; 
КонецФункции 

Функция ПолучитьДоговорПодряда(Владелец) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_ДоговорыВзаиморасчетов.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Scan_ДоговорыВзаиморасчетов КАК Scan_ДоговорыВзаиморасчетов
	               |ГДЕ
	               |	Scan_ДоговорыВзаиморасчетов.Владелец = &Владелец
	               |	И Scan_ДоговорыВзаиморасчетов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.Scan_ВидыДоговоров.Подряда)
	               |	И Scan_ДоговорыВзаиморасчетов.Недействителен = ЛОЖЬ";	// rarus tenkam 04.08.2020 mantis 16401 +
	Запрос.УстановитьПараметр("Владелец",Владелец);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Справочники.Scan_ДоговорыВзаиморасчетов.ПустаяСсылка();
	Иначе 
		ВыборкаДоговор = Результат.Выбрать();
		Пока ВыборкаДоговор.Следующий() Цикл
			Возврат ВыборкаДоговор.Ссылка;
		КонецЦикла;
	КонецЕсли; 
КонецФункции 

//rarus sergei 03.10.2016 mantis 7162 --

// rarus tenkam 28.06.2019 mantis 14427 +++

////rarus tenkam 16.11.2016 mantis 7092 ++

////Функция возвращает массив ссылок на СОПы, в табличной части которых есть указанный продукт
//Функция ПолучитьСписокСОП(ПродуктСсылка) Экспорт
//	Если НЕ ЗначениеЗаполнено(ПродуктСсылка) Тогда
//		Возврат Неопределено;
//	КонецЕсли;
//	
//	МассивСОП = Новый Массив;
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	Scan_ДоговорыВзаиморасчетовСпецификацияКСОП.Ссылка
//		|ИЗ
//		|	Справочник.Scan_ДоговорыВзаиморасчетов.СпецификацияКСОП КАК Scan_ДоговорыВзаиморасчетовСпецификацияКСОП
//		|ГДЕ
//		|	Scan_ДоговорыВзаиморасчетовСпецификацияКСОП.СОП_Продукт = &ПродуктСсылка";
//	
//	Запрос.УстановитьПараметр("ПродуктСсылка", ПродуктСсылка);	
//	РезультатЗапроса = Запрос.Выполнить();
//	ТаблицаРезультат = РезультатЗапроса.Выгрузить();
//		
//	Если ТаблицаРезультат.Количество() <> 0 Тогда
//		МассивСОП = ТаблицаРезультат.ВыгрузитьКолонку("Ссылка");
//	КонецЕсли;	
//	Возврат МассивСОП;
//КонецФункции

////rarus tenkam 16.11.2016 mantis 7092 --

//rarus tenkam 27.10.2017 mantis 10204 +++
//rarus bonmak 26.08.2019 14430 ++
//Процедура УдалитьПродуктИзСОП(СОПСсылка, ПродуктСсылка) Экспорт
//	Если НЕ ЗначениеЗаполнено(СОПСсылка) ИЛИ НЕ ЗначениеЗаполнено(ПродуктСсылка) Тогда
//		Возврат;
//	КонецЕсли;
//	СОПОбъект = СОПСсылка.ПолучитьОбъект();
//	НайденнаяСтрока = СОПОбъект.СпецификацияКСОП.Найти(ПродуктСсылка,"СОП_Продукт");
//	Если НайденнаяСтрока <> Неопределено Тогда
//		СОПОбъект.СпецификацияКСОП.Удалить(НайденнаяСтрока);
//	// rarus tenkam 30.07.2019 mantis 14695 +++	
//	Иначе
//		Возврат;
//	// rarus tenkam 30.07.2019 mantis 14695 ---
//	КонецЕсли;
//	Попытка
//		СОПОбъект.Записать();
//	Исключение
//	КонецПопытки; 
//КонецПроцедуры
//rarus bonmak 26.08.2019 14430 --
//rarus tenkam 27.10.2017 mantis 10204 ---

// rarus tenkam 28.06.2019 mantis 14427 14430 раскомментировать

//Функция возвращает массив ссылок на СОПы, в табличной части которых есть указанное изделие
Функция ПолучитьСписокСОП(ИзделиеСсылка) Экспорт
	Если НЕ ЗначениеЗаполнено(ИзделиеСсылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МассивСОП = Новый Массив;
	Если Scan_ПраваИНастройки.Scan_Право("ИспользоватьНовыйАлгоритмСозданияДоговоров") Тогда //rarus bonmak 25.03.2021 17443 ++	
		Возврат МассивСОП;
	КонецЕсли; //rarus bonmak 25.03.2021 17443 --
	//rarus bonmak 09.08.2021 16834 ++
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	Scan_ДоговорыВзаиморасчетовСпецификацияКСОП.Ссылка
	//	|ИЗ
	//	|	Справочник.Scan_ДоговорыВзаиморасчетов.СпецификацияКСОП КАК Scan_ДоговорыВзаиморасчетовСпецификацияКСОП
	//	|ГДЕ
	//	|	Scan_ДоговорыВзаиморасчетовСпецификацияКСОП.СОП_Изделие = &ИзделиеСсылка";
	//
	//Запрос.УстановитьПараметр("ИзделиеСсылка", ИзделиеСсылка);	
	//РезультатЗапроса = Запрос.Выполнить();
	//ТаблицаРезультат = РезультатЗапроса.Выгрузить();
	//	
	//Если ТаблицаРезультат.Количество() <> 0 Тогда
	//	МассивСОП = ТаблицаРезультат.ВыгрузитьКолонку("Ссылка");
	//КонецЕсли;
	//rarus bonmak 09.08.2021 16834 --
	Возврат МассивСОП;
КонецФункции

//rarus bonmak 09.08.2021 16834 ++
//Процедура УдалитьИзделиеИзСОП(СОПСсылка, ИзделиеСсылка) Экспорт
//	Если НЕ ЗначениеЗаполнено(СОПСсылка) ИЛИ НЕ ЗначениеЗаполнено(ИзделиеСсылка) Тогда
//		Возврат;
//	КонецЕсли;
//	СОПОбъект = СОПСсылка.ПолучитьОбъект();
//	НайденнаяСтрока = СОПОбъект.СпецификацияКСОП.Найти(ИзделиеСсылка,"СОП_Изделие");
//	Если НайденнаяСтрока <> Неопределено Тогда
//		СОПОбъект.СпецификацияКСОП.Удалить(НайденнаяСтрока);
//	// rarus tenkam 30.07.2019 mantis 14695 +++	
//	Иначе
//		Возврат;	
//	// rarus tenkam 30.07.2019 mantis 14695 ---
//	КонецЕсли;
//	Попытка
//		СОПОбъект.Записать();
//	Исключение
//	КонецПопытки; 
//КонецПроцедуры
// rarus tenkam 28.06.2019 mantis 14427 ---
//rarus bonmak 09.08.2021 16834 --
Функция СоздатьДоговорВ1БД(СОПДоговорСсылка, СоглашениеОПоставкеСсылка = Неопределено) Экспорт // rarus tenkam 21.09.2020 mntis 16181 +++
	Если Scan_ПраваИНастройки.Scan_Право("ОбменСПредставительством") И Scan_ПраваИНастройки.Scan_Право("ОбратныйОбменС1БД") И
		Scan_ПраваИНастройки.Scan_Право("ИспользоватьНовыйАлгоритмСозданияДоговоров") Тогда
		Отказ = Ложь;
		СообщениеОбОшибке = "";
		
		Если ЗначениеЗаполнено(СОПДоговорСсылка.IDExternalSystem) Тогда
			// rarus tenkam 31.12.2020 mantis 17053 +++
			Если НЕ ЗначениеЗаполнено(СоглашениеОПоставкеСсылка) Тогда
				СоглашениеОПоставкеСсылка = Справочники.Scan_СоглашенияОПоставке.НайтиСоглашениеОПоставкеПоДоговору(СОПДоговорСсылка);
			КонецЕсли;
			СтруктураПараметров = Scan_ВебСервисыРазборОтветов.СОППолучитьСтруктуруДанныхДляОтправкив1БД(СОПДоговорСсылка, СоглашениеОПоставкеСсылка, "SetSOP");
			Возврат ИзменитьДоговорВ1БД(СтруктураПараметров, СОПДоговорСсылка, СоглашениеОПоставкеСсылка);
			
			//ВывестиСообщениеПол(НСтр("ru = 'Ошибка создания договора в 1БД <%1>. IDExternalSystem уже заполнен: %2'"),,,,, СОПДоговорСсылка, СОПДоговорСсылка.IDExternalSystem);
			//Возврат Ложь;	
			// rarus tenkam 31.12.2020 mantis 17053 ---
		КонецЕсли;
		
		//Rarus bonmak 18405 26.11.2021 ++
		//Сначала выполним метод GetListOfSop на предмет, если договор уже был создан ранее.
		IDExternalSystemСОП = ПолучитьGUIDДоговора(СОПДоговорСсылка, Отказ);
		//Если ОТКАЗ = Истина, тогда возникла ошибка при которой нельзя продолжать, количество договоров вернулось больше одного или возникли другие ошибки
		//Если IDExternalSystemСОП заполнен, то договор создан в 1БД ранее, просто запишем GUID в договор OFMS
        //Если IDExternalSystemСОП не заполнен и ОТКАЗ = Ложь, то вернулось сообщение, что такого договора нет или другое служебное сообщение
		Если НЕ Отказ И НЕ ЗначениеЗаполнено(IDExternalSystemСОП) Тогда
			//Вернулось сообщение, что такого договора нет, продолжаем и выполняем метод CreateSOP
			// Отправим в 1БД запрос на создание договора
			IDExternalSystemСОП = Scan_ВебСервисыРазборОтветов.ВызватьМетод_CreateSOP(СОПДоговорСсылка, СоглашениеОПоставкеСсылка, Отказ, СообщениеОбОшибке);
		КонецЕсли;
		//Rarus bonmak 18405 26.11.2021 --
		
		//Rarus bonmak 18405 26.11.2021 ++
		//Перенесено выше
		// Отправим в 1БД запрос на создание договора
		//IDExternalSystemСОП = Scan_ВебСервисыРазборОтветов.ВызватьМетод_CreateSOP(СОПДоговорСсылка, СоглашениеОПоставкеСсылка, Отказ, СообщениеОбОшибке);
		//Rarus bonmak 18405 26.11.2021 --
		
		Если НЕ Отказ Тогда
			Если НЕ ЗначениеЗаполнено(IDExternalSystemСОП) Тогда
				// Запишем в очередь отправки
				РегистрыСведений.Scan_Обмен1БДОчередьПоОтправкеРеквизитов.ЗаписьЗначенияРегистраСведения(СОПДоговорСсылка, Справочники.Scan_ВидыЗапроса.CreateSOP, "Ссылка", СОПДоговорСсылка);
				ВывестиСообщениеПол(НСтр("ru = 'Обмен прошел некорректно. Текст сообщения обмена с 1БД: <%1>. Данные записаны в очередь отправки.'"),,,,, СообщениеОбОшибке);
				Возврат Ложь;
			КонецЕсли;
			
			// Запишем полученный GUID в договор
			ВсеОК = ЗаписатьIDExternalSystemВДоговор(СОПДоговорСсылка, IDExternalSystemСОП);
			Если НЕ ВсеОК Тогда
				ВывестиСообщениеПол(НСтр("ru = 'Не удалось записать ID External System <%1> в договор <%2>'"),,,,, IDExternalSystemСОП, СОПДоговорСсылка);	
			КонецЕсли;
			Возврат ВсеОК;
		Иначе
			// Запишем в очередь отправки
			РегистрыСведений.Scan_Обмен1БДОчередьПоОтправкеРеквизитов.ЗаписьЗначенияРегистраСведения(СОПДоговорСсылка, Справочники.Scan_ВидыЗапроса.CreateSOP, "Ссылка", СОПДоговорСсылка);
			СообщениеОбОшибке = НСтр("ru = 'Договор не отправлен в 1БД. Данные записаны в очередь отправки. Проверьте заполнение данных по условиям оплаты:" + Символы.ПС + "Вид оплаты" + Символы.ПС + "%" + Символы.ПС + "руб.'");
			ВывестиСообщениеПол(СообщениеОбОшибке);
			//ВывестиСообщениеПол(НСтр("ru = 'Ошибка создания договора в 1БД <%1>. Ошибка: <%2>. Данные записаны в очередь отправки.'"),,,,, СОПДоговорСсылка, СообщениеОбОшибке);
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	Возврат Истина;

КонецФункции	// rarus tenkam 21.09.2020 mantis 16181 ---

Функция ПолучитьGUIDДоговора(СОПДоговорСсылка, Отказ) //Rarus bonmak 18405 26.11.2021 ++
	ИмяМетода = "GetListOfSOP";
	СообщениеОбОшибке = "";
	GUIDДоговора = Неопределено;
	СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода);
	СтруктураПараметров["НомерДоговора"] = СОПДоговорСсылка.НомерДоговора;
	ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
	ТекЭлементОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации);
	Если НЕ Отказ Тогда
		GUIDДоговора = Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникДоговорыВзаиморасчетовСОП(ТекЭлементОтвет,Отказ,СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации,ИмяМетода, Истина);		
	КонецЕсли;
	Возврат GUIDДоговора; 	
КонецФункции //Rarus bonmak 18405 26.11.2021 --

Функция ЗаписатьIDExternalSystemВДоговор(СОПДоговорСсылка, IDExternalSystem) Экспорт // rarus tenkam 07.09.2020 mantis 16181 +++	 
	Если НЕ ЗначениеЗаполнено(IDExternalSystem) Тогда
		ВывестиСообщениеПол(НСтр("ru = 'IDExternalSystem не заполнен. Возможно, идентификатор не вернуся из 1БД.'"),,,,);
		Возврат Ложь;		
	КонецЕсли;
	
	ДоговорОбъект = СОПДоговорСсылка.ПолучитьОбъект();
	ДоговорОбъект.IDExternalSystem = IDExternalSystem;
	Попытка
		ДоговорОбъект.Записать();
		Возврат Истина;
	Исключение
		ВывестиСообщениеПол(НСтр("ru = 'Ошибка заполнения IDExternalSystem в договоре <%1>: %2'"),,,,, ДоговорОбъект, ОписаниеОшибки());
		Возврат Ложь;	
	КонецПопытки; 
КонецФункции	// rarus tenkam 07.09.2020 mantis 16181 ---

Функция ИзменитьДоговорВ1БД(СтруктураПараметров, СОПДоговорСсылка, СоглашениеОПоставкеСсылка = Неопределено) Экспорт // rarus tenkam 21.09.2020 mntis 16181 +++
	Если Scan_ПраваИНастройки.Scan_Право("ОбменСПредставительством") И Scan_ПраваИНастройки.Scan_Право("ОбратныйОбменС1БД") И
		Scan_ПраваИНастройки.Scan_Право("ИспользоватьНовыйАлгоритмСозданияДоговоров") Тогда
		Отказ = Ложь;
		СообщениеОбОшибке = "";
		// Отправим в 1БД запрос на изменение договора
		IDExternalSystemСОП = Scan_ВебСервисыРазборОтветов.ВызватьМетод_SetSOP(СтруктураПараметров, СОПДоговорСсылка, СоглашениеОПоставкеСсылка, Отказ, СообщениеОбОшибке);
		
		Если НЕ Отказ Тогда
			Возврат Истина;
		ИначеЕсли Отказ И ЗначениеЗаполнено(IDExternalSystemСОП) Тогда
			Для Каждого ТекПараметр Из СтруктураПараметров Цикл
				Если ТекПараметр.Ключ = "Продукты" Тогда
					Продолжить;
				КонецЕсли;
				// Запишем в очередь отправки
				РегистрыСведений.Scan_Обмен1БДОчередьПоОтправкеРеквизитов.ЗаписьЗначенияРегистраСведения(СОПДоговорСсылка, Справочники.Scan_ВидыЗапроса.SetSOP, ТекПараметр.Ключ, ТекПараметр.Значение);
			КонецЦикла;
			
			ВывестиСообщениеПол(НСтр("ru = 'Ошибка изменения договора в 1БД <%1>. Данные записаны в очередь отправки: %2'"),,,,, СОПДоговорСсылка, СообщениеОбОшибке);
			Возврат Ложь;
		ИначеЕсли Отказ И IDExternalSystemСОП = Неопределено Тогда
			ВывестиСообщениеПол(НСтр("ru = 'Данные не могут быть отправлены в 1БД, договор: <%1>. %2'"),,,,, СОПДоговорСсылка, СообщениеОбОшибке);
			Возврат Ложь; 			
		КонецЕсли;
	КонецЕсли;
	Возврат Истина;

КонецФункции	// rarus tenkam 21.09.2020 mantis 16181 ---

Функция РасторгнутьДоговор(ДоговорСсылка, ДатаРасторжения) Экспорт		// rarus tenkam 03.11.2020 mantis 16759 +++
	
	Если НЕ ЗначениеЗаполнено(ДоговорСсылка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДоговорОбъект = ДоговорСсылка.ПолучитьОбъект();
	
	ДоговорОбъект.Расторгнут = Истина;
	ДоговорОбъект.ДатаРасторжения = ДатаРасторжения;
	
	Попытка
		ДоговорОбъект.Записать();
	Исключение
		ВывестиСообщениеПол(НСтр("ru = 'Ошибка расторжения договора <%1>. Ошибка: %2'"),,,,, ДоговорОбъект, ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	Возврат Истина;
КонецФункции	// rarus tenkam 03.11.2020 mantis 16759 ---

Функция ЗаписьЗначенияРегистраСведенияИсторияИзмененияДанныхПоСОП(Договор,Значение,ВидЗначения,НаДату = Неопределено) Экспорт	// rarus tenkam 09.11.2020 mantis 16759 +++ 
	
	Отказ = Ложь;
	
	Если НаДату = Неопределено Тогда
		ДатаЗаписи = ТекущаяДата();
	Иначе
		ДатаЗаписи = НаДату;
	КонецЕсли; 
	
	Если НЕ Отказ Тогда
		//Чтение старого значения регистра
		СтруктураОтбора   = Новый Структура("Договор,ВидЗначения", Договор,ВидЗначения);
		СтруктураСведений = РегистрыСведений.Scan_ИсторияИзмененияДанныхПоСОП.ПолучитьПоследнее(ДатаЗаписи, СтруктураОтбора);
		ЗначениеСтарое    = СтруктураСведений.Значение;
		Записывать        = Ложь;
		//Введено значение, а старое отсутствует
		Если ЗначениеЗаполнено(Значение) И ЗначениеСтарое = Неопределено Тогда 
			Записывать = Истина; 
		КонецЕсли; 
		//Значение стерто, а старое значение было введено
		Если НЕ ЗначениеЗаполнено(Значение) И ЗначениеСтарое <> Неопределено Тогда
			Если (ТипЗнч(Значение) = Тип("Дата") И ЗначениеСтарое = Дата('00010101')) ИЛИ
				(ТипЗнч(Значение) = Тип("Строка") И ЗначениеСтарое = "") ИЛИ
				(ТипЗнч(Значение) = Тип("Булево") И ЗначениеСтарое = Ложь) Тогда
				Записывать = Ложь;
			Иначе
				Записывать = Истина; 
			КонецЕсли;
		КонецЕсли; 
		//Введено значение и было введено старое
		Если ЗначениеЗаполнено(Значение) И ЗначениеСтарое <> Неопределено Тогда
			//Значение изменилось
			Если Значение <> ЗначениеСтарое Тогда 
				Записывать = Истина; 
			КонецЕсли; 
		КонецЕсли; 
		Если Записывать Тогда
			//Значение параметра изменилось
			ЗаписьРегСведений = РегистрыСведений.Scan_ИсторияИзмененияДанныхПоСОП.СоздатьМенеджерЗаписи();
			ЗаписьРегСведений.Договор	      = Договор;
			
			ЗаписьРегСведений.ВидЗначения     = ВидЗначения;
			ЗаписьРегСведений.Значение        = Значение;
			ЗаписьРегСведений.Период          = ДатаЗаписи;
			ЗаписьРегСведений.Пользователь    = ПользователиКлиентСервер.ТекущийПользователь();
			
			Попытка
				ЗаписьРегСведений.Записать();
			Исключение
				Сообщить(НСтр("ru = 'Ошибка записи параметра договора СОП в регистр сведений'; en = 'Subject of the contract was not saved'"));
				Сообщить(ОписаниеОшибки());
				Отказ = Истина;
			КонецПопытки; 
		КонецЕсли; 
	КонецЕсли; 
		
	Возврат Отказ;
КонецФункции	// rarus tenkam 09.11.2020 mantis 16759 ---

Функция ДоговорыПодчинены(Договор1, Договор2) Экспорт // rarus tenkam 09.08.2021 mantis 18059 +++
	МассивДоговоровОснований = Новый Массив;
	МассивДоговоровОснований.Добавить(Договор1);
	ДобавитьДоговорОснованиеВМассив(Договор1, МассивДоговоровОснований);
	Если МассивДоговоровОснований.Найти(Договор2) <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	МассивДоговоровОснований2 = Новый Массив;
	МассивДоговоровОснований2.Добавить(Договор2);
	ДобавитьДоговорОснованиеВМассив(Договор2, МассивДоговоровОснований2);
	Если МассивДоговоровОснований2.Найти(Договор1) <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;	
КонецФункции // rarus tenkam 09.08.2021 mantis 18059 ---

Процедура ДобавитьДоговорОснованиеВМассив(Договор, МассивДоговоровОснований) Экспорт // rarus tenkam 09.08.2021 mantis 18059 +++
	ДоговорОснование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ДоговорОснование");
	Если ЗначениеЗаполнено(ДоговорОснование) Тогда	
		МассивДоговоровОснований.Добавить(ДоговорОснование);
		ДобавитьДоговорОснованиеВМассив(ДоговорОснование,МассивДоговоровОснований);
	КонецЕсли;
	Возврат;
КонецПроцедуры // rarus tenkam 09.08.2021 mantis 18059 ---

Функция СоздатьДоговорСОП(Дилер, СтавкаНДС) Экспорт //rarus vikhle 21.10.2021 mt 18076 +++
	
	КонтрагентДилера = РегистрыСведений.Scan_ВзаимосвязьКомпанийСКонтрагентами.ПолучитьДилераПоКомпании(Дилер);
	
	Если НЕ ЗначениеЗаполнено(КонтрагентДилера) Тогда
		ВывестиСообщениеПол(Нстр("ru = 'Не задан Контрагент дилера. Создание договора невозможно.'"));
		Возврат Неопределено;
	КонецЕсли;
	
	ДоговорОбъект = Справочники.Scan_ДоговорыВзаиморасчетов.СоздатьЭлемент();
	ДоговорОбъект.УстановитьНовыйКод();
	ДоговорОбъект.Наименование = СтрЗаменить(Формат(Строка(Год(ТекущаяДатаСеанса())), "ЧГ=0"), Символы.НПП,"") + "-" + ДоговорОбъект.Код; //rarus vikhle 22.10.2021 АПК ТекущаяДатаСеанса()
	ДоговорОбъект.Компания = Дилер;
	ДоговорОбъект.Владелец = КонтрагентДилера;
	ДоговорОбъект.ВидДоговора = Перечисления.Scan_ВидыДоговоров.Соглашение;
	ДоговорОбъект.СОП_СтатусОплаты = Перечисления.Scan_СтатусыОплатПоСОП.НеОплачено;
	ДоговорОбъект.ВалютаВзаиморасчетов = Справочники.Валюты.НайтиПоКоду("643");
	ДоговорОбъект.СтавкаНДС = СтавкаНДС;
	
	ДоговорОбъект.ЗаполнитьДанныеНумерацииСОП();
		
	ДоговорОбъект.Записать();
		
	Возврат ДоговорОбъект.Ссылка;
	
КонецФункции //rarus vikhle 21.10.2021 mt 18076 ---	

