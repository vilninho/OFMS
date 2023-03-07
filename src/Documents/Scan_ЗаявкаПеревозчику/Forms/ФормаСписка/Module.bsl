//rarus sergei 30.09.2016 mantis 7122 ++
&НаКлиенте
Процедура ПодтвержденаПеревозчиком(Команда)
	МассивВыбранныхСтрок = Элементы.Список.ВыделенныеСтроки;
	Если МассивВыбранныхСтрок.Количество() = 0 Тогда
		Сообщить("Не выбран ни один документ");                                                                       
		Возврат;
	ИначеЕсли МассивВыбранныхСтрок.Количество() > 1 Тогда
		Сообщить("Выберите один документ");                            
	Иначе
		ПодтвержденаПеревозчикомНаСервере(МассивВыбранныхСтрок[0]);
	КонецЕсли;
	Элементы.Список.Обновить();    //rarus sergei 06.10.2016 mantis 7609 +
КонецПроцедуры                                              

&НаСервере
Процедура ПодтвержденаПеревозчикомНаСервере(ЗаявкаПеревозчику)
	//rarus tenkam 23.12.2016 mantis 8216 ++ (перенесла внутрь процедуры)
	//Если ЗаявкаПеревозчику.Сторнирован = Истина Тогда
	//	Сообщить("Нельзя изменять сторнированный документ");
	//	Возврат;
	//Иначе
	//rarus tenkam 23.12.2016 mantis 8216 --
		//rarus tenkam 05.10.2016 mantis 7183 ++
		СообщениеОбОшибке = "";
		ВсеОк = Документы.Scan_ЗаявкаПеревозчику.УстановитьПодтверждениеПеревозчиком(ЗаявкаПеревозчику, СообщениеОбОшибке);
		Если НЕ ВсеОк И ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
			Сообщить(СообщениеОбОшибке);
		Иначе
			//rarus tenkam 14.10.2016 mantis 7688 ++
			Сообщить("У документа " + ЗаявкаПеревозчику.Номер + " от " + ТекущаяДата() + " установлен признак подтверждена.");
			//Сообщить("У документа " + ЗаявкаПеревозчику + " установлен признак подтверждена.");
			//rarus tenkam 14.10.2016 mantis 7688 --
		КонецЕсли;
		
		//Если ЗаявкаПеревозчику.ПодтвержденаПеревозчиком = ЛОЖЬ Тогда
		//	УстановитьПривилегированныйРежим(Истина);
		//	ДокОбъект = ЗаявкаПеревозчику.ПолучитьОбъект();
		//	ДокОбъект.ПодтвержденаПеревозчиком = Истина;
		//	ДокОбъект.СтатусЗаявки = Справочники.Scan_СтатусыЗаявокНаДействие.Подтверждена;
		//	ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		//	Для каждого строкаТЧ Из ДокОбъект.СоставЗаявки Цикл
		//		Scan_ВспомогательныеФункцииСервер.НастроитьСтатусДокументаЗаявкаНаДествие(строкаТЧ.ЗаявкаНаДействие);
		//	КонецЦикла; 
		//	Сообщить("У документа "+ДокОбъект.Ссылка +" установлен признак подтверждена");
		//КонецЕсли;
		//rarus tenkam 05.10.2016 mantis 7183 --
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СнятьПодтверждение(Команда)
	МассивВыбранныхСтрок = Элементы.Список.ВыделенныеСтроки;
	Если МассивВыбранныхСтрок.Количество() = 0 Тогда
		Сообщить("Не выбран ни один документ");                                                                       
		Возврат;
	ИначеЕсли МассивВыбранныхСтрок.Количество() > 1 Тогда
		Сообщить("Выберите один документ");                            
	Иначе
		СнятьПодтверждениеНаСервере(МассивВыбранныхСтрок[0]);
	КонецЕсли;
	Элементы.Список.Обновить();  //rarus sergei 06.10.2016 mantis 7609 +
КонецПроцедуры

&НаСервере
Процедура СнятьПодтверждениеНаСервере(ЗаявкаПеревозчику)
	//rarus tenkam 23.12.2016 mantis 8216 ++ (перенесла внутрь процедуры)
	//Если ЗаявкаПеревозчику.Сторнирован = Истина Тогда
	//	Сообщить("Нельзя изменять сторнированный документ");
	//	Возврат;
	//Иначе
	//rarus tenkam 23.12.2016 mantis 8216 --
		//rarus tenkam 05.10.2016 mantis 7183 ++
		СообщениеОбОшибке = "";
		ВсеОк = Документы.Scan_ЗаявкаПеревозчику.СнятьПодтверждениеПеревозчиком(ЗаявкаПеревозчику, СообщениеОбОшибке);
		Если НЕ ВсеОк Тогда
			Сообщить(СообщениеОбОшибке);
		Иначе
			//rarus tenkam 14.10.2016 mantis 7688 ++
			Сообщить("У документа " + ЗаявкаПеревозчику.Номер + " от " + ТекущаяДата() + " снят признак подтверждена.");
			//Сообщить("У документа " + ЗаявкаПеревозчику + " снят признак подтверждена.");	
			//rarus tenkam 14.10.2016 mantis 7688 --
		КонецЕсли;
		
		//Если ЗаявкаПеревозчику.ПодтвержденаПеревозчиком = Истина Тогда
		//	УстановитьПривилегированныйРежим(Истина);
		//	ДокОбъект = ЗаявкаПеревозчику.ПолучитьОбъект();
		//	ДокОбъект.ПодтвержденаПеревозчиком = ЛОЖЬ;
		//	ДокОбъект.СтатусЗаявки = Справочники.Scan_СтатусыЗаявокНаДействие.ВРаботе;
		//	ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		//	Для каждого строкаТЧ Из ДокОбъект.СоставЗаявки Цикл
		//		//Изменяем статус у документа заявка на действие
		//		Scan_ВспомогательныеФункцииСервер.НастроитьСтатусДокументаЗаявкаНаДествие(строкаТЧ.ЗаявкаНаДействие);
		//	КонецЦикла; 
		//	Сообщить("У документа "+ДокОбъект.Ссылка +" снят признак подтверждена");
		//КонецЕсли;
		//rarus tenkam 05.10.2016 mantis 7183 --
	//КонецЕсли;
КонецПроцедуры

//rarus sergei 13.10.2016 mantis 7167 ++

&НаКлиенте
Процедура АннулироватьЗаявкуПеревозчику(Команда)
	МассивВыделенныхСтрок = Элементы.Список.ВыделенныеСтроки;
	Если МассивВыделенныхСтрок.Количество() = 0 Тогда
		Сообщить("Не выбрана ни одна заявка"); 
		Возврат;                                
	ИначеЕсли МассивВыделенныхСтрок.Количество()>1 Тогда
		Сообщить("Выберите одну Заявку");
		Возврат;
	Иначе
		АннулироватьЗаявкуПеревозчикуНаСервере(МассивВыделенныхСтрок[0]);
		Элементы.Список.Обновить();
		Оповестить("ОбновитьСписокЗаявокНаДействие");  //rarus sergei 02.12.2016 mantis 8057 +
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура АннулироватьЗаявкуПеревозчикуНаСервере(ЗаявкаПеревозчику);
		
		//rarus tenkam 28.04.2017 mantis 9559 +++
		//Если ЗаявкаПеревозчику.ПодтвержденаПеревозчиком = Истина Тогда 
		//	Сообщить("Не удалось установить пометку на удаление для документа "+ЗаявкаПеревозчику.Ссылка+ ", так как документ подтвержден перевозчиком"); 
		//ИначеЕсли ЗаявкаПеревозчику.СтатусЗаявки = Справочники.Scan_СтатусыЗаявокНаДействие.Аннулирована Тогда
		//	Сообщить("Не удалось установить пометку на удаление для документа "+ЗаявкаПеревозчику.Ссылка+ ", так как документ аннулирован");	
		//Иначе
		//	УстановитьПривилегированныйРежим(Истина);
		//	ДокОбъект = ЗаявкаПеревозчику.ПолучитьОбъект();
		//	ДокОбъект.ПометкаУдаления = Истина;
		//	ДокОбъект.СтатусЗаявки = Справочники.Scan_СтатусыЗаявокНаДействие.Аннулирована;
		//	ДокОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		//КонецЕсли; 
		Если ЗаявкаПеревозчику.ПометкаУдаления И ЗаявкаПеревозчику.СтатусЗаявки = Справочники.Scan_СтатусыЗаявокНаДействие.Аннулирована Тогда
			//для исправления ошибок по старому коду
			УстановитьПривилегированныйРежим(Истина);
			ДокОбъект = ЗаявкаПеревозчику.ПолучитьОбъект();
			ДокОбъект.ПометкаУдаления = Ложь;
			ДокОбъект.Сторнирован = Истина;
			ДокОбъект.СтатусЗаявки = Справочники.Scan_СтатусыЗаявокНаДействие.Аннулирована;
			ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		КонецЕсли;
	
		Если ЗаявкаПеревозчику.Сторнирован Тогда
			Сообщить("Документ " + ЗаявкаПеревозчику.Ссылка + " уже аннулирован!");
		ИначеЕсли ЗаявкаПеревозчику.СтатусЗаявки = Справочники.Scan_СтатусыЗаявокНаДействие.Исполнена Тогда
			Сообщить("Не удалось аннулировать документ " + ЗаявкаПеревозчику.Ссылка + ", т.к. он исполнен!");
		ИначеЕсли ЗаявкаПеревозчику.ПодтвержденаПеревозчиком Тогда
			Сообщить("Не удалось аннулировать документ " + ЗаявкаПеревозчику.Ссылка + ", т.к. он подтвержден перевозчиком!");
		Иначе	
			Scan_ВспомогательныеФункцииСервер.СторнироватьДокумент(ЗаявкаПеревозчику);	
			Scan_ВспомогательныеФункцииСервер.СформироватьНапоминаниеОбАннулировании(ЗаявкаПеревозчику);
		КонецЕсли;   				
	   //rarus tenkam 28.04.2017 mantis 9559 ---
КонецПроцедуры

//rarus sergei 13.10.2016 mantis 7167 --

//rarus tenkam 28.11.2017 mantis 10885 +++

////Формирование условного обозначения для форм списка справочников и документов
////
////Параметры:
////Форма - УправляемаяФорма - ФормаСписка, в которой возникло событие
////Отображает цвет строки соответствующего вида
////
//&НаСервере
//Процедура СформироватьУсловноеОформление()
//	//Обновление условного оформления строк в ТЧ
//	СправочникМенеджер = Справочники.Scan_СтатусыЗаявокНаДействие;
//	Scan_УправлениеДиалогомСервер.СформироватьУсловноеОформление(ЭтаФорма, СправочникМенеджер,"СтатусЗаявки");
//КонецПроцедуры

//&НаСервере
//Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//	//формирование условного оформления строк списка
//	СформироватьУсловноеОформление();

//КонецПроцедуры

//&НаКлиенте
//Процедура СписокПриИзменении(Элемент)
//	//формирование условного оформления строк списка
//	СформироватьУсловноеОформление();

//КонецПроцедуры
//rarus tenkam 28.11.2017 mantis 10885 ---
//rarus sergei 30.09.2016 mantis 7122 --

//rarus sergei 12.10.2016 mantis 7165 ++
///ФОРМИРОВАНИЕ ВЫГРУЗКИ ЗАЯВКИ ПЕРЕВОЗЧИКУ

&НаКлиенте
Процедура ВыгрузитьЗаявкуТК(Команда)
	МассивВыбранныхСтрок = Элементы.Список.ВыделенныеСтроки;
	Если МассивВыбранныхСтрок.Количество() = 0 Тогда
		Сообщить("Не выбран ни один документ");                                                                       
		Возврат;
	ИначеЕсли МассивВыбранныхСтрок.Количество() > 1 Тогда
		Сообщить("Выберите один документ"); 
		Возврат;
	Иначе
		ИмяФайла = ПолучитьИмяФайла(МассивВыбранныхСтрок[0]);
		// rarus tenkam 18.04.2019 mantis 14195 +++
		
		//ПутьКФайлу = ПолучитьПутьКФайлуВыгрузки(ИмяФайла);
		//Если ПутьКФайлу = "" Тогда
		//	Сообщить("Путь сохранения не выбран!");
		//	Возврат;	
		//КонецЕсли;	
		//ТабДокумент = ПолучитьТабДокументТранспортнойКомпании();
		//СохранитьДанныеВExcel(ТабДокумент, ПутьКФайлу);

		// Вызываем диалог выбора файла для сохранения XLS-таблицы
		Режим = РежимДиалогаВыбораФайла.Сохранение;
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		Текст = "ru = ""Таблица XLS""; en = ""XLS table""";
		Фильтр = НСтр(Текст)+"(*.xls)|*.xls";
		ДиалогОткрытияФайла.Фильтр = Фильтр;
		ДиалогОткрытияФайла.Заголовок = "Выберите путь для сохранения";
		ДиалогОткрытияФайла.ПолноеИмяФайла = ИмяФайла;
		
		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("ИмяФайла", ИмяФайла);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииДиалогаВыбораФайла", ЭтотОбъект, ДопПараметры);
		ДиалогОткрытияФайла.Показать(ОписаниеОповещения);	   		
		// rarus tenkam 18.04.2019 mantis 14195 ---
		
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИмяФайла(ЗаявкаПеревозчику)
	ИмяФайла = Строка(ЗаявкаПеревозчику.Перевозчик)+" заявка № "+ Строка(ЗаявкаПеревозчику.Номер) +" от "+Строка(Формат(ЗаявкаПеревозчику.Дата,"ДЛФ=D"));
	Возврат ИмяФайла;
КонецФункции
// rarus tenkam 18.04.2019 mantis 14195 ---

&НаСервере
Функция ПолучитьТабДокументТранспортнойКомпании()
	МассивВыбранныхСтрок = Элементы.Список.ВыделенныеСтроки;
	ЗаявкаПеревозчику = МассивВыбранныхСтрок[0];
	ТаблицаСохранение = Новый ТабличныйДокумент;
	Макет = Документы.Scan_ЗаявкаПеревозчику.ПолучитьМакет("ЗаявкаТК");
	Scan_СборСтатистики.Scan_Печать("ЗаявкаТК"); // Rarus tenkam 11.04.2022 mantis 18433 +
	
	ОбластьШапка = Макет.ПолучитьОбласть("ОбластьШапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("ОбластьСтрока");

	ТаблицаСохранение.Вывести(ОбластьШапка);
	Для Каждого Стр Из ЗаявкаПеревозчику.СоставЗаявки Цикл
		ОбластьСтрока.Параметры.НомерСтроки= Стр.НомерСтроки; //rarus sergei 17.10.2016 mantis 7165 +
		ОбластьСтрока.Параметры.НомерЗаявки = ЗаявкаПеревозчику.Номер;
		ОбластьСтрока.Параметры.НомерШасси = Стр.Изделие.НомерИзделия;
		ТаблицаСохранение.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	Возврат ТаблицаСохранение;

КонецФункции


&НаКлиенте
Процедура СохранитьДанныеВExcel(ТаблицаСохранение, ПутьКФайлу)
	ТаблицаСохранение.Записать(ПутьКФайлу, ТипФайлаТабличногоДокумента.XLS);
	//rarus FominskiyAS 21.04.2019  mantis 14191 +++
	//Сообщить("Данные выгружены в файл " + ПутьКФайлу);
	Сообщить(НСтр("ru = 'Данные выгружены в файл '; en = 'Data uploaded into the file '") + ПутьКФайлу);
	//rarus FominskiyAS 21.04.2019  mantis 14191 --- 
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ЗАГРУЗКА ДАННЫХ ОТ ТК

&НаКлиенте
Процедура ЗагрузитьДанныеОтТК(Команда)
	МассивВыбранныхСтрок = Элементы.Список.ВыделенныеСтроки;
	Если МассивВыбранныхСтрок.Количество() = 0 Тогда
		Сообщить("Не выбран ни один документ");                                                                       
		Возврат;
	ИначеЕсли МассивВыбранныхСтрок.Количество() > 1 Тогда
		Сообщить("Выберите один документ"); 
		Возврат;
	ИначеЕсли ПроверитьВыбраннуюЗаявку(МассивВыбранныхСтрок[0]) Тогда
		Возврат;
	Иначе
		
		Обработчик = Новый ОписаниеОповещения("ЗагрузитьВыбранныйФайл", ЭтотОбъект);
		ОткрытьФорму("Документ.Scan_ЗаявкаПеревозчику.Форма.ФормаЗагрузкиДанныхОтТК",, ЭтотОбъект,,,,Обработчик, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВыбраннуюЗаявку(ЗаявкаПеревозчику)
	//rarus sergei 17.10.2016 mantis 7166 ++
	Если ЗаявкаПеревозчику.ПодтвержденаПеревозчиком = Ложь Тогда
	    Сообщить("Нельзя загрузить файл от транспортной компании для документа, неподтвержденного перевозчиком");
		Возврат Истина;
	КонецЕсли; 
	Если НЕ ЗначениеЗаполнено(ЗаявкаПеревозчику.ДатаУходаФакт) Тогда
	    Сообщить("Не удалось загрузить файл. У документа не установлена ""дата ухода (факт)""");
		Возврат Истина;	
	КонецЕсли; 
	//rarus sergei 17.10.2016 mantis 7166 --
	Если ЗаявкаПеревозчику.Сторнирован Тогда
		Сообщить("Нельзя загрузить данные от транспортной компании для сторнированной заявки");
		Возврат Истина;
	КонецЕсли;
	Если ЗаявкаПеревозчику.Исполнена = Истина Тогда
	    Сообщить("Нельзя загрузить данные от транспортной компании для исполненой заявки");
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура ЗагрузитьВыбранныйФайл(ЗначенияВыбранныхПараметров, Параметры) Экспорт	  
	Если ЗначенияВыбранныхПараметров = Неопределено ИЛИ
		ЗначенияВыбранныхПараметров = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	//rarus FominskiyAS 19.04.2019  mantis 14191 +++
	//Сообщить("Начата загрузка файла"+" "+ТекущаяДата());
	Сообщить(Нстр("ru = 'Начата загрузка файла'; en = 'Downloading'")+" "+ТекущаяДата());
	//rarus FominskiyAS 19.04.2019  mantis 14191 ---

	ДвоичныеДанные=Новый ДвоичныеДанные(ЗначенияВыбранныхПараметров.ПутьКФайлу);
    Адрес= ПоместитьВоВременноеХранилище(ДвоичныеДанные, Новый УникальныйИдентификатор);
	
	ПрочитатьТабличныйДокумент(Адрес);	
	//rarus FominskiyAS 19.04.2019  mantis 14191 +++
	//Сообщить("Загрузка файла завершена"+" "+ТекущаяДата());
	Сообщить(Нстр("ru = 'Загрузка файла завершена'; en = 'Completed'")+" "+ТекущаяДата());
	//rarus FominskiyAS 19.04.2019  mantis 14191 ---

		

КонецПроцедуры

&НаСервере

Процедура ПрочитатьТабличныйДокумент(Адрес) 
	МассивВыбранныхСтрок = Элементы.Список.ВыделенныеСтроки;
	ЗаявкаПеревозчику = МассивВыбранныхСтрок[0].ПолучитьОбъект();
	ДокументИзменен = Ложь;
	ФайлПриемник = ПолучитьИмяВременногоФайла("xls");
	ДанныеХранилища = ПолучитьИзВременногоХранилища(Адрес);
	ДанныеХранилища.Записать(ФайлПриемник);
	ТабДокумент = Новый ТабличныйДокумент;
	Попытка
		ТабДокумент.Прочитать(ФайлПриемник, СпособЧтенияЗначенийТабличногоДокумента.Значение); 
	Исключение
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Внимание);
	КонецПопытки;
	Попытка
		УдалитьФайлы(ФайлПриемник);
	Исключение
	КонецПопытки;
	КолвоСтрокДокумента = ТабДокумент.ВысотаТаблицы; 
	НомерНачальнойСтроки = 7;
	Если ТабДокумент.Область("R"+СтрЗаменить(7, Символы.НПП, "") + "C2").Текст = "" ИЛИ СтрЗаменить(ТабДокумент.Область("R"+СтрЗаменить(7, Символы.НПП, "") + "C2").Текст,Символы.НПП,"") <> ЗаявкаПеревозчику.Номер Тогда
		Сообщить("Ошибка. Номер заявки не совпадает с загружаемым номером из файла");
		Возврат;
	Иначе
		//rarus sergei 17.10.2016 mantis 7166 ++
		Для нСтрока=НомерНачальнойСтроки ПО КолвоСтрокДокумента Цикл
			Если ЗначениеЗаполнено(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C4").Текст) И ЗначениеЗаполнено(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C5").Текст) И ЗначениеЗаполнено(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C6").Текст) И ЗначениеЗаполнено(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C7").Текст) Тогда
				
				ДатаДоставкиФакт = СоединитьДатуИВремя(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C6").Значение,ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C7").Значение);
				ДатаПолученияФакт = СоединитьДатуИВремя(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C4").Значение,ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C5").Значение);
				
				Если ДатаДоставкиФакт > ТекущаяДата() Тогда
					Сообщить("Не удалось загрузить файл от транспортной компании, так как в строке "+ ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C1").Текст +" дата доставки больше, чем текущая дата!");
					Возврат;				
				КонецЕсли;                                                                        
				Если ДатаДоставкиФакт <= ДатаПолученияФакт Тогда
					Сообщить("Не удалось загрузить файл от транспортной компании, так как дата доставки должна быть больше даты получения!");
					Возврат;
				КонецЕсли; 
			КонецЕсли;
			//rarus sergei 19.10.2016 mantis 7166 --
		КонецЦикла;
		//rarus sergei 17.10.2016 mantis 7166 --
		Для нСтрока=НомерНачальнойСтроки ПО КолвоСтрокДокумента Цикл
			//НомерШасси = ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C3").Текст;
			//rarus sergei 11.11.2016 mantis 7166 ++
			НомерШасси =СтрЗаменить(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C3").Текст,Символы.НПП,"");
			Если НЕ ЗначениеЗаполнено(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C4").Текст) Тогда 
				Сообщить("Внимание! В загружаемом файле для продукта № "+НомерШасси +" не заполнена дата фактического получения. Строка не будет загружена");
				Продолжить;
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C5").Текст) Тогда
				Сообщить("Внимание! В загружаемом файле для продукта № "+НомерШасси +" не заполнено время фактического получения. Строка не будет загружена");
				Продолжить;	
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C6").Текст) Тогда
				Сообщить("Внимание! В загружаемом файле для продукта № "+НомерШасси +" не заполнена дата фактической доставки. Строка не будет загружена");
				Продолжить;	
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C7").Текст) Тогда
				Сообщить("Внимание! В загружаемом файле для продукта № "+НомерШасси +" не заполнено время фактической доставки. Строка не будет загружена");
				Продолжить;	
			КонецЕсли;
			//rarus sergei 11.11.2016 mantis 7166 --
			
			ДатаДоставкиФакт = СоединитьДатуИВремя(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C6").Значение,ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C7").Значение);
			ДатаПолученияФакт = СоединитьДатуИВремя(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C4").Значение,ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C5").Значение);
			
			Изделие = ПолучитьИзделиеПоШасси(НомерШасси);
			Если Изделие = Справочники.Scan_Изделия.ПустаяСсылка() Тогда
				Сообщить("Шасси с № "+НомерШасси+" не найдено в справочнике ""Продукты""");
				Продолжить;	
			КонецЕсли; 
			ВыборкаСоставЗаявки = ЗаявкаПеревозчику.СоставЗаявки;
			МассивНайденныхСтрок = ВыборкаСоставЗаявки.НайтиСтроки(Новый Структура("Изделие",Изделие));
			Если НЕ ЗначениеЗаполнено(МассивНайденныхСтрок) Тогда
				Сообщить("В данной заявке шасси с № "+НомерШасси +" нет");
				Продолжить;
			КонецЕсли; 
			Если ДатаПолученияФакт <> МассивНайденныхСтрок[0].ДатаУходаФакт Тогда
				//ДатаПолученияФакт = НачалоДня(ДатаПолученияФакт)+12*60*60;
				МассивНайденныхСтрок[0].ДатаУходаФакт = ДатаПолученияФакт;
				ДокументИзменен = Истина;
			КонецЕсли; 
			Если ЗначениеЗаполнено(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C6").Текст) и ЗначениеЗаполнено(ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C7").Текст) Тогда
				Если ЗначениеЗаполнено(ДатаДоставкиФакт) И ДатаДоставкиФакт <> МассивНайденныхСтрок[0].ДатаДоставкиФакт Тогда
					//ДатаДоставкиФакт = НачалоДня(ДатаДоставкиФакт)+12*60*60;
					МассивНайденныхСтрок[0].ДатаДоставкиФакт = ДатаДоставкиФакт;
					ДокументИзменен = Истина;
				КонецЕсли;
			КонецЕсли;
			КомментарийТК = ТабДокумент.Область("R"+СтрЗаменить(нСтрока, Символы.НПП, "") + "C8").Текст; 
			Если КомментарийТК <> "" Тогда	
				МассивНайденныхСтрок[0].КомментарииТК = КомментарийТК;	
				ДокументИзменен = Истина;
			КонецЕсли; 
		КонецЦикла;
		Если ДокументИзменен = Истина Тогда
			
			ТекИсполнена = Истина;
			Для Каждого СтрокаИзделий Из ЗаявкаПеревозчику.СоставЗаявки Цикл
				Если НЕ ЗначениеЗаполнено(СтрокаИзделий.ДатаДоставкиФакт) Тогда
					ТекИсполнена = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			ЗаявкаПеревозчику.Исполнена = ТекИсполнена;	
			
			Если ЗаявкаПеревозчику.Исполнена Тогда
				ЗаявкаПеревозчику.СтатусЗаявки = Справочники.Scan_СтатусыЗаявокНаДействие.Исполнена;
			ИначеЕсли ЗаявкаПеревозчику.ПодтвержденаПеревозчиком Тогда
				ЗаявкаПеревозчику.СтатусЗаявки = Справочники.Scan_СтатусыЗаявокНаДействие.Подтверждена; 
			ИначеЕсли ЗаявкаПеревозчику.Сторнирован Тогда
				ЗаявкаПеревозчику.СтатусЗаявки = Справочники.Scan_СтатусыЗаявокНаДействие.Аннулирована;
			Иначе
				ЗаявкаПеревозчику.СтатусЗаявки = Справочники.Scan_СтатусыЗаявокНаДействие.ВРаботе;	
			КонецЕсли;
			
			
			Попытка
				ЗаявкаПеревозчику.Записать(РежимЗаписиДокумента.Проведение);	
			Исключение
				Сообщить("Не удалось записать документ """ + ЗаявкаПеревозчику + """!
				|" + ОписаниеОшибки());
				
			КонецПопытки;
			Элементы.Список.Обновить();
		КонецЕсли; 

	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьИзделиеПоШасси(НомерШасси)
	//Попытка
	//СсылкаНомерШасси = Формат(Число(НомерШасси), "ЧГ=");
	//Исключение
	//КонецПопытки;
	СсылкаНаИзделие=Справочники.Scan_Изделия.НайтиПоРеквизиту("НомерИзделия",НомерШасси);
	Возврат СсылкаНаИзделие;	
КонецФункции
//rarus sergei 12.10.2016 mantis 7165 --

&НаСервере
Функция СоединитьДатуИВремя(Дата, Время) Экспорт
 
  ДатаСтрока  = Формат(Дата, "ДФ=""ггггММдд""");
  ВремяСтрока = Формат(Время, "ДФ=""ЧЧммсс""");
  Результат  = Дата(ДатаСтрока + ВремяСтрока);
 
  Возврат Результат;
 
КонецФункции

//rarus sergei 02.12.2016 mantis 8057 ++
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	 Если ИмяСобытия = "ОбновитьСписокЗаявокПеревозчику" Тогда 
            Элементы.Список.Обновить(); 
     КонецЕсли;
КонецПроцедуры
//rarus sergei 02.12.2016 mantis 8057 --

//rarus tenkam 28.11.2017 mantis 10885 +++
&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	Справочник.Ссылка,
	|	Справочник.Цвет КАК Цвет
	|ИЗ
	|	Справочник.Scan_СтатусыЗаявокНаДействие КАК Справочник";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Scan_ЗаявкаПеревозчику.Ссылка КАК СсылкаДокумент
			|ИЗ
			|	Документ.Scan_ЗаявкаПеревозчику КАК Scan_ЗаявкаПеревозчику
			|ГДЕ
			|	Scan_ЗаявкаПеревозчику.СтатусЗаявки = &СтатусЗаявки
			|	И Scan_ЗаявкаПеревозчику.Ссылка В(&Строки)";
		
		Запрос.УстановитьПараметр("СтатусЗаявки", Выборка.Ссылка);
		Запрос.УстановитьПараметр("Строки", Строки.ПолучитьКлючи());
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СтрокаСписка = Строки[ВыборкаДетальныеЗаписи.СсылкаДокумент];
			Для Каждого КолонкаСписка Из СтрокаСписка.Оформление Цикл
				КолонкаСписка.Значение.УстановитьЗначениеПараметра("ЦветФона", Выборка.Цвет.Получить());
			КонецЦикла;
		КонецЦикла;
		
	КонецЦикла;
КонецПроцедуры
//rarus tenkam 29.11.2017 mantis 10885 ---

//rarus FominskiyAS 27.02.2019  mantis 13863 +++

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Scan_ВспомогательныеФункцииКлиент.ПроверитьПользователяПортала();//rarus vikhle 07.05.2020 mt 15695
КонецПроцедуры

//&НаКлиенте
//Функция ПолучитьПутьКФайлуВыгрузки(ПолноеИмяФайла)
//	
//	// Вызываем диалог выбора файла для сохранения XLS-таблицы
//	Режим = РежимДиалогаВыбораФайла.Сохранение;
//	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
//	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
//	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
//	Текст = "ru = ""Таблица XLS""; en = ""XLS table""";
//	Фильтр = НСтр(Текст)+"(*.xls)|*.xls";
//	ДиалогОткрытияФайла.Фильтр = Фильтр;
//	ДиалогОткрытияФайла.Заголовок = "Выберите путь для сохранения";
//	ДиалогОткрытияФайла.ПолноеИмяФайла = ПолноеИмяФайла;
//	
//	Если ДиалогОткрытияФайла.Выбрать() Тогда
//		Возврат ДиалогОткрытияФайла.ПолноеИмяФайла;
//	Иначе
//		Возврат "";
//	КонецЕсли;	
//КонецФункции

&НаКлиенте
Процедура ПриЗавершенииДиалогаВыбораФайла(ВыбранныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИмяФайла = ДополнительныеПараметры.ИмяФайла; 
	
	ПолноеИмяФайла = ВыбранныйФайл[0];
	ПутьКФайлу = ПолноеИмяФайла;
	
	Если ПутьКФайлу = "" Тогда
		//rarus FominskiyAS 08.07.2019  mantis 14191 +++
		//Сообщить("Путь сохранения не выбран!");
		Сообщить(НСтр("ru = 'Путь сохранения не выбран!'; en = 'Way of saving does not selected!'"));
		//rarus FominskiyAS 08.07.2019  mantis 14191 --- 
		Возврат;	
	КонецЕсли;	
	ТабДокумент = ПолучитьТабДокументТранспортнойКомпании();
	СохранитьДанныеВExcel(ТабДокумент, ПутьКФайлу);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//rarus FominskiyAS 27.02.2019  mantis 13863 ---
