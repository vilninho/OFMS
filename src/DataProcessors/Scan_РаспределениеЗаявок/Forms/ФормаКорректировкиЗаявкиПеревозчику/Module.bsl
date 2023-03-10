//rarus sergei 09.09.2016 mantis 7167 ++
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтаФорма.АвтоЗаголовок = ЛОЖЬ;
	ЗаявкаПеревозчику = Параметры.ЗаявкаПеревозчику;
	ЭтаФорма.Заголовок = "Корректировка "+ ЗаявкаПеревозчику;
	//Заполняем Реквизиты формы из документа
	Перевозчик                      =  Параметры.ЗаявкаПеревозчику.Перевозчик;
	ДоговорСПеревозчиком            =  Параметры.ЗаявкаПеревозчику.ДоговорСПеревозчиком;
	СпособДоставкиИзделий           =  Параметры.ЗаявкаПеревозчику.СпособДоставкиИзделий;
	//ВозможностьПриемаВВыходныеДни   =  Параметры.ЗаявкаПеревозчику.ВозможностьПриемаВВыходныеДни; //rarus sergei 30.09.2016 mantis 7122 +
	
	//Отгрузка
	КомпанияОтправитель             =  Параметры.ЗаявкаПеревозчику.КомпанияОтправитель;
	МестоОтгрузки                   =  Параметры.ЗаявкаПеревозчику.МестоОтгрузки;
	ДатаПолучения                   =  Параметры.ЗаявкаПеревозчику.ДатаПолучения;
	ВремяПолучения                  = '00010101'+(Параметры.ЗаявкаПеревозчику.ДатаПолучения - НачалоДня(Параметры.ЗаявкаПеревозчику.ДатаПолучения));

	Для каждого строка Из Параметры.ЗаявкаПеревозчику.КонтактыОтправителя Цикл
		НоваяСтрока = КонтактыОтправителя.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,строка);
	КонецЦикла;
	
	//Доставка
	КомпанияПолучатель              =  Параметры.ЗаявкаПеревозчику.КомпанияПолучатель;
	МестоДоставки                   =  Параметры.ЗаявкаПеревозчику.МестоДоставки;
	ДатаДоставки                    =  Параметры.ЗаявкаПеревозчику.ДатаДоставки;
	ВремяДоставки                   =  '00010101'+(Параметры.ЗаявкаПеревозчику.ДатаДоставки - НачалоДня(Параметры.ЗаявкаПеревозчику.ДатаДоставки));
	Для каждого строка Из Параметры.ЗаявкаПеревозчику.КонтактыПолучателя Цикл
		НоваяСтрока = КонтактыПолучателя.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,строка);
	КонецЦикла;
	УстановитьАдрес();

КонецПроцедуры



&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();

КонецПроцедуры

&НаСервере
Функция ИзмененаКИОтправителя()
	Если КонтактыОтправителя.Количество() <> ЗаявкаПеревозчику.КонтактыОтправителя.Количество() Тогда
		Возврат Истина;
	Иначе
		Для каждого строка Из КонтактыОтправителя Цикл
			НайденныеСтроки = ЗаявкаПеревозчику.КонтактыОтправителя.НайтиСтроки(Новый Структура("КонтактноеЛицо",строка.КонтактноеЛицо));
			Если НайденныеСтроки.Количество() = 0 Тогда
				Возврат Истина;
			КонецЕсли; 
		
		КонецЦикла; 
		
	
	КонецЕсли; 
	Возврат ЛОЖЬ;

КонецФункции 

&НаСервере
Функция ИзмененаКИПолучателя()
	Если КонтактыПолучателя.Количество() <> ЗаявкаПеревозчику.КонтактыПолучателя.Количество() Тогда
		Возврат Истина;
	Иначе
		Для каждого строка Из КонтактыПолучателя Цикл
			НайденныеСтроки = ЗаявкаПеревозчику.КонтактыПолучателя.НайтиСтроки(Новый Структура("КонтактноеЛицо",строка.КонтактноеЛицо));
			Если НайденныеСтроки.Количество() = 0 Тогда
				Возврат Истина;
			КонецЕсли; 
		
		КонецЦикла; 
		
	
	КонецЕсли; 
	Возврат ЛОЖЬ;

	

КонецФункции 

&НаСервере
Функция РеквизитыИзменены()
	Если ЗаявкаПеревозчику.Перевозчик <>Перевозчик ИЛИ ЗаявкаПеревозчику.ДоговорСПеревозчиком <>ДоговорСПеревозчиком ИЛИ ЗаявкаПеревозчику.СпособДоставкиИзделий <>СпособДоставкиИзделий ИЛИ ЗаявкаПеревозчику.КомпанияОтправитель <>КомпанияОтправитель ИЛИ ЗаявкаПеревозчику.МестоОтгрузки <>МестоОтгрузки ИЛИ ЗаявкаПеревозчику.ДатаПолучения <>ДатаПолучения ИЛИ ЗаявкаПеревозчику.КомпанияПолучатель <>КомпанияПолучатель ИЛИ ЗаявкаПеревозчику.МестоДоставки <>МестоДоставки ИЛИ ЗаявкаПеревозчику.ДатаДоставки <>ДатаДоставки ИЛИ ИзмененаКИОтправителя() ИЛИ ИзмененаКИПолучателя() Тогда  //ИЛИ ЗаявкаПеревозчику.ВозможностьПриемаВВыходныеДни <>ВозможностьПриемаВВыходныеДни
		Возврат ИСТИНА;
	Иначе
		Возврат Ложь;
	КонецЕсли; 
	

КонецФункции 
 

&НаСервере
Процедура СкорректироватьДокумент()
	ДокументОбъект = ЗаявкаПеревозчику.ПолучитьОбъект();
	ДокументОбъект.Перевозчик                        = Перевозчик;
	ДокументОбъект.ДоговорСПеревозчиком              = ДоговорСПеревозчиком ;
	ДокументОбъект.СпособДоставкиИзделий             = СпособДоставкиИзделий;
	//ДокументОбъект.ВозможностьПриемаВВыходныеДни     = ВозможностьПриемаВВыходныеДни;   //rarus sergei 30.09.2016 mantis 7122 + пожелание заказчика к постановке
	ДокументОбъект.КомпанияОтправитель               = КомпанияОтправитель;
	ДокументОбъект.МестоОтгрузки                     = МестоОтгрузки ;
	ДокументОбъект.ДатаПолучения                     = ДатаПолучения ;
	ДокументОбъект.КомпанияПолучатель                = КомпанияПолучатель;
	ДокументОбъект.МестоДоставки                     = МестоДоставки;
	ДокументОбъект.ДатаДоставки                      = ДатаДоставки;
	ДокументОбъект.КонтактыОтправителя.Очистить();
	Для каждого строка Из КонтактыОтправителя Цикл
		НовыйСтрока = ДокументОбъект.КонтактыОтправителя.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйСтрока,строка);
	КонецЦикла; 
	ДокументОбъект.КонтактыПолучателя.Очистить();
	Для каждого строка Из КонтактыПолучателя Цикл
		НовыйСтрока = ДокументОбъект.КонтактыПолучателя.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйСтрока,строка);
	КонецЦикла; 	
	ДокументОбъект.Записать();
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	ДатаПолучения = НачалоДня(ЭтаФорма.ДатаПолучения) + (ЭтаФорма.ВремяПолучения - НачалоДня(ЭтаФорма.ВремяПолучения));
	ДатаДоставки = НачалоДня(ЭтаФорма.ДатаДоставки) + (ЭтаФорма.ВремяДоставки - НачалоДня(ЭтаФорма.ВремяДоставки));
	Если ДатаПолучения>=ДатаДоставки Тогда
		//rarus FominskiyAS 24.04.2019  mantis 14191 +++
		//Сообщить("Нельзя Изменить документ, так как дата доставки меньше даты получения");
		Сообщить(НСтр("ru = 'Нельзя Изменить документ, так как дата доставки меньше даты получения '; en = 'You can not edit a document, as the delivery date is less than the date of receipt'"));		
		//rarus FominskiyAS 24.04.2019  mantis 14191 ---  
		Возврат;
	КонецЕсли; 
	Если РеквизитыИзменены() Тогда
		СкорректироватьДокумент();
		
	
	КонецЕсли; 	
	//rarus FominskiyAS 24.04.2019  mantis 14191 +++
	//Сообщить("Изменена "+ ЗаявкаПеревозчику);
	Сообщить(НСтр("ru = 'Изменена '; en = 'Changed '")+ ЗаявкаПеревозчику);
	//rarus FominskiyAS 24.04.2019  mantis 14191 ---  
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеревозчикПриИзменении(Элемент)
	ПеревозчикПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПеревозчикПриИзмененииНаСервере()
	Если ЗначениеЗаполнено(ДоговорСПеревозчиком) и Перевозчик <> ДоговорСПеревозчиком.Владелец Тогда 
		ДоговорСПеревозчиком = Справочники.Scan_ДоговорыВзаиморасчетов.ПустаяСсылка();				
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ДоговорСПеревозчикомПриИзменении(Элемент)
	ДоговорСПеревозчикомПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДоговорСПеревозчикомПриИзмененииНаСервере()
		
	Если ЗначениеЗаполнено(Перевозчик) и Объект.ДоговорСПеревозчиком.Пустая() Тогда
		ПеревозчикПриИзмененииНаСервере()	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДоговорСПеревозчикомНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Перевозчик) Тогда			
		СтандартнаяОбработка = Ложь;
		ЗначениеОтбора = Новый Структура("Владелец", Перевозчик);
		ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
	    ПараметрыФормы.Вставить("Грузополучатель", Перевозчик);			
		Результат = ОткрытьФорму("Справочник.Scan_ДоговорыВзаиморасчетов.ФормаВыбора",ПараметрыФормы,Элементы.ДоговорСПеревозчиком); 
	КонецЕсли;

КонецПроцедуры                                                                 

&НаКлиенте
Процедура ДоговорСПеревозчикомСоздание(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("Владелец", Перевозчик);
	ПараметрыСоздания.Вставить("Наименование",Элемент.ТекстРедактирования);  
	ОткрытьФорму("Справочник.Scan_ДоговорыВзаиморасчетов.ФормаОбъекта", ПараметрыСоздания, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ДоговорСПеревозчикомОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Флаг = ПроверитьДатуДоговора(ВыбранноеЗначение);
	Если Флаг Тогда
		СтандартнаяОбработка = Ложь;
		//rarus FominskiyAS 08.07.2019  mantis 14191 +++
		//Сообщить("Внимание! Дата окончания договора меньше или равна дате доставки");
		Сообщить(НСтр("ru = 'Внимание! Дата окончания договора меньше или равна дате доставки'; en = 'Attention! End date of the contract is less or equal to the delivery date'"));
		//rarus FominskiyAS 08.07.2019  mantis 14191 ---  	
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПроверитьДатуДоговора(Договор)
	ПросроченныйДоговор = Ложь;
	Если Договор.Бессрочный Тогда
		Возврат ПросроченныйДоговор;
	ИначеЕсли Договор.ДатаОкончания <= ДатаДоставки Тогда
		ПросроченныйДоговор = Истина;	
	КонецЕсли; 
	Возврат ПросроченныйДоговор;
КонецФункции


&НаКлиенте
Процедура КомпанияОтправительПриИзменении(Элемент)
	КомпанияОтправительПриИзмененииНаСервере();
КонецПроцедуры



&НаСервере
Процедура КомпанияОтправительПриИзмененииНаСервере()
	//rarus sergei 15.09.2016 mantis 7160 ++
	Если ЗначениеЗаполнено(КомпанияОтправитель) Тогда
		Если (ТипЗнч(КомпанияОтправитель)= Тип("СправочникСсылка.Scan_Контрагенты") И КомпанияОтправитель <> МестоОтгрузки.Контрагент) Тогда 
			//(ТипЗнч(КомпанияОтправитель)= Тип("СправочникСсылка.Scan_Дилеры") И КомпанияОтправитель.Контрагент <> МестоОтгрузки.Контрагент) Тогда		//rarus tenkam 24.10.2017 mantis 11439 +
			МестоОтгрузки = Справочники.Scan_МестаХранения.ПустаяСсылка();	
			УстановитьАдрес();
		КонецЕсли;
		Если КонтактыОтправителя.Количество()>0 Тогда
			Если (ТипЗнч(КомпанияОтправитель)= Тип("СправочникСсылка.Scan_Контрагенты") И КомпанияОтправитель <> КонтактыОтправителя[0].КонтактноеЛицо.Владелец) Тогда 
				//(ТипЗнч(КомпанияОтправитель)= Тип("СправочникСсылка.Scan_Дилеры") И КомпанияОтправитель.Контрагент <> КонтактыОтправителя[0].КонтактноеЛицо.Владелец) Тогда	//rarus tenkam 24.10.2017 mantis 11439 +
				КонтактыОтправителя.Очистить();	
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли;
	//rarus sergei 15.09.2016 mantis 7160 --

КонецПроцедуры


&НаКлиенте
Процедура МестоОтгрузкиПриИзменении(Элемент)
	МестоОтгрузкиПриИзмененииНаСервере();
	УстановитьАдрес();
КонецПроцедуры


&НаСервере                                                 	
Процедура УстановитьАдрес()
	Если ЗначениеЗаполнено(МестоОтгрузки) Тогда
		АдресОтгрузки = МестоОтгрузки.АдресСкладаФактический;
	КонецЕсли; 
	Если ЗначениеЗаполнено(МестоДоставки) Тогда
		АдресДоставки = МестоДоставки.АдресСкладаФактический;
	КонецЕсли; 	
КонецПроцедуры


&НаСервере
Процедура МестоОтгрузкиПриИзмененииНаСервере()
		
	Если НЕ МестоОтгрузки.Пустая() Тогда
		Если (НЕ ЗначениеЗаполнено(КомпанияОтправитель)) ИЛИ 
			//(ТипЗнч(КомпанияОтправитель)= Тип("СправочникСсылка.Scan_Дилеры") И КомпанияОтправитель.Контрагент <> МестоОтгрузки.Контрагент) ИЛИ	//rarus tenkam 24.10.2017 mantis 11439 +
			(ТипЗнч(КомпанияОтправитель)= Тип("СправочникСсылка.Scan_Контрагенты") И КомпанияОтправитель <> МестоОтгрузки.Контрагент) Тогда 
			КомпанияОтправитель = МестоОтгрузки.Контрагент;
			Если КонтактыОтправителя.Количество()>0 И МестоОтгрузки.Контрагент <> КонтактыОтправителя[0].КонтактноеЛицо.Владелец Тогда
				КонтактыОтправителя.Очистить();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	

КонецПроцедуры

&НаКлиенте
Процедура МестоОтгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗначениеОтбора = Новый Структура("Маршрут", ЛОЖЬ);
	Если ЗначениеЗаполнено(КомпанияОтправитель) Тогда
		//rarus sergei 15.09.2016 mantis 7160 ++
		Если  ТипЗнч(КомпанияОтправитель)= Тип("СправочникСсылка.Scan_Контрагенты") Тогда
			ЗначениеОтбора.Вставить("Контрагент",КомпанияОтправитель);
		Иначе
			Контрагент = ПолучитьВладельцаДоговора(КомпанияОтправитель);
			ЗначениеОтбора.Вставить("Контрагент",  Контрагент);
		КонецЕсли; 
		//rarus sergei 15.09.2016 mantis 7160 --
	КонецЕсли;
	ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
	Результат = ОткрытьФорму("Справочник.Scan_МестаХранения.ФормаВыбора",ПараметрыФормы,Элементы.МестоОтгрузки); 

КонецПроцедуры

&НаСервере
Функция ПолучитьВладельцаДоговора(Дилер)
	//rarus bonmak 15.04.2020 14456 ++
	//Владелец = Дилер.Контрагент;
	Владелец = РегистрыСведений.Scan_ВзаимосвязьКомпанийСКонтрагентами.ПолучитьДилераПоКомпании(Дилер);
	//rarus bonmak 15.04.2020 14456 --	
	Возврат Владелец;
	
КонецФункции

&НаКлиенте
Процедура КонтактыОтправителяКонтактноеЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(КомпанияОтправитель) Тогда
		
		СтандартнаяОбработка = Ложь;
		//rarus sergei 15.09.2016 mantis 7160 ++
		Если ТипЗнч(КомпанияОтправитель)= Тип("СправочникСсылка.Scan_Контрагенты") Тогда
			ЗначениеОтбора = Новый Структура("Владелец", КомпанияОтправитель);
		Иначе
			Владелец = ПолучитьВладельцаДоговора(КомпанияОтправитель);
			ЗначениеОтбора = Новый Структура("Владелец", Владелец);
		КонецЕсли;
		//rarus sergei 15.09.2016 mantis 7160 --
		
		ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
		Результат = ОткрытьФорму("Справочник.Scan_КонтактныеЛица.ФормаВыбора",ПараметрыФормы,Элементы.КонтактыОтправителяКонтактноеЛицо); 
		
		
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура КонтактыОтправителяКонтактноеЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	МассивСтрок=КонтактыОтправителя.НайтиСтроки(Новый Структура("КонтактноеЛицо",ВыбранноеЗначение));
	Если МассивСтрок.Количество()> 0 и МассивСтрок[0].НомерСтроки <>  ТекущийЭлемент.ТекущаяСтрока+1 Тогда
		СтандартнаяОбработка=Ложь;              
		Возврат; 
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	ИндексТекущейСтроки = КонтактыОтправителя.Индекс(Элементы.КонтактыОтправителя.ТекущиеДанные);
	КонтактыОтправителя.Удалить(ИндексТекущейСтроки);  
	ЗаполнитьКонтактнуюинформацию(ВыбранноеЗначение);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКонтактнуюинформацию(парам)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_КонтактныеЛицаКонтактнаяИнформация.Ссылка КАК КонтактноеЛицо,
	               |	Scan_КонтактныеЛицаКонтактнаяИнформация.Вид КАК ВидКонтактнойИнформации,
	               |	Scan_КонтактныеЛицаКонтактнаяИнформация.Представление КАК Представление
	               |ИЗ
	               |	Справочник.Scan_КонтактныеЛица.КонтактнаяИнформация КАК Scan_КонтактныеЛицаКонтактнаяИнформация
	               |ГДЕ
	               |	Scan_КонтактныеЛицаКонтактнаяИнформация.Ссылка.Ссылка = &Ссылка
	               |	И (Scan_КонтактныеЛицаКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	               |			ИЛИ Scan_КонтактныеЛицаКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))";
				  
	Запрос.УстановитьПараметр("Ссылка",парам);
	ТЗ=Запрос.Выполнить().Выгрузить();
	Для каждого строкаТЗ Из ТЗ Цикл 
		
		НоваяСтрока= КонтактыОтправителя.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,строкаТЗ);
	    
	КонецЦикла; 
	 //rarus sergei 15.09.2016 mantis 7160 ++

	Если НЕ ЗначениеЗаполнено(КомпанияОтправитель) Тогда 
		КомпанияОтправитель = Парам.Владелец;
		Если Парам.Владелец <> МестоОтгрузки.Контрагент Тогда
			МестоОтгрузки = Справочники.Scan_МестаХранения.ПустаяСсылка();	
			УстановитьАдрес();
		КонецЕсли;
	КонецЕсли;
	//rarus sergei 15.09.2016 mantis 7160 --

КонецПроцедуры

&НаКлиенте
Процедура КомпанияПолучательПриИзменении(Элемент)
	ОчиститьМестоДоставки();
	КомпанияПолучательПриИзмененииНаСервере();
КонецПроцедуры


&НаСервере
Процедура ОчиститьМестоДоставки()
	МестоДоставки = Справочники.Scan_МестаХранения.ПустаяСсылка();	
КонецПроцедуры



&НаСервере
Процедура КомпанияПолучательПриИзмененииНаСервере()
	
	Если КонтактыПолучателя.Количество()>0 И КомпанияПолучатель <> КонтактыПолучателя[0].КонтактноеЛицо.Владелец Тогда 
		КонтактыПолучателя.Очистить();				
	КонецЕсли; 
	

КонецПроцедуры

&НаКлиенте
Процедура МестоДоставкиПриИзменении(Элемент)
	МестоДоставкиПриИзмененииНаСервере();
	УстановитьАдрес();
КонецПроцедуры

&НаСервере
Процедура МестоДоставкиПриИзмененииНаСервере()
	Если (НЕ ЗначениеЗаполнено(КомпанияПолучатель) ИЛИ КомпанияПолучатель <> МестоДоставки.Контрагент) И
		НЕ МестоДоставки.Пустая() Тогда
		КомпанияПолучатель = МестоДоставки.Контрагент;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура МестоДоставкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗначениеОтбора = Новый Структура("Маршрут", ЛОЖЬ);
	Если ЗначениеЗаполнено(КомпанияОтправитель) Тогда
		ЗначениеОтбора.Вставить("Контрагент",КомпанияПолучатель);
	КонецЕсли;
	ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
	Результат = ОткрытьФорму("Справочник.Scan_МестаХранения.ФормаВыбора",ПараметрыФормы,Элементы.МестоДоставки); 

КонецПроцедуры

&НаКлиенте
Процедура КонтактыПолучателяКонтактноеЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(КомпанияПолучатель) Тогда
	
		СтандартнаяОбработка = Ложь;
		ЗначениеОтбора = Новый Структура("Владелец", КомпанияПолучатель);
		ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
	    Результат = ОткрытьФорму("Справочник.Scan_КонтактныеЛица.ФормаВыбора",ПараметрыФормы,Элементы.КонтактыПолучателяКонтактноеЛицо); 
	
	
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура КонтактыПолучателяКонтактноеЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	МассивСтрок = КонтактыПолучателя.НайтиСтроки(Новый Структура("КонтактноеЛицо",ВыбранноеЗначение));
	Если МассивСтрок.Количество()> 0 и МассивСтрок[0].НомерСтроки <>  ТекущийЭлемент.ТекущаяСтрока+1 Тогда
		СтандартнаяОбработка=Ложь;              
		Возврат; 
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	ИндексТекущейСтроки = КонтактыПолучателя.Индекс(Элементы.КонтактыПолучателя.ТекущиеДанные);
	Объект.КонтактыПолучателя.Удалить(ИндексТекущейСтроки);  
	ЗаполнитьКонтактнуюинформациюПолучателя(ВыбранноеЗначение);

КонецПроцедуры


&НаСервере
Процедура ЗаполнитьКонтактнуюинформациюПолучателя(парам)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_КонтактныеЛицаКонтактнаяИнформация.Ссылка КАК КонтактноеЛицо,
	               |	Scan_КонтактныеЛицаКонтактнаяИнформация.Вид КАК ВидКонтактнойИнформации,
	               |	Scan_КонтактныеЛицаКонтактнаяИнформация.Представление КАК Представление
	               |ИЗ
	               |	Справочник.Scan_КонтактныеЛица.КонтактнаяИнформация КАК Scan_КонтактныеЛицаКонтактнаяИнформация
	               |ГДЕ
	               |	Scan_КонтактныеЛицаКонтактнаяИнформация.Ссылка.Ссылка = &Ссылка
	               |	И (Scan_КонтактныеЛицаКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	               |			ИЛИ Scan_КонтактныеЛицаКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))";
				  
	Запрос.УстановитьПараметр("Ссылка",парам);
	ТЗ=Запрос.Выполнить().Выгрузить();
	Для каждого строкаТЗ Из ТЗ Цикл 
		
		НоваяСтрока = КонтактыПолучателя.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,строкаТЗ);
	    
	КонецЦикла; 
	Если НЕ ЗначениеЗаполнено(КомпанияПолучатель) Тогда 
		КомпанияПолучатель = Парам.Владелец;
	КонецЕсли;
КонецПроцедуры


//rarus sergei 09.09.2016 mantis 7167 --
