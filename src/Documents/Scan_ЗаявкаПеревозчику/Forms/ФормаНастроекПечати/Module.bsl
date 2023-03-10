//rarus sergei 28.09.2016 mantis 7160 ++
&НаСервере
Процедура ЗаполнитьДопУсловияДоставки()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_ДополнительныеУсловияДоставки.Ссылка
	               |ИЗ
	               |	Справочник.Scan_ДополнительныеУсловияДоставки КАК Scan_ДополнительныеУсловияДоставки
	               |ГДЕ
	               |	Scan_ДополнительныеУсловияДоставки.ИспользоватьПоУмолчаниюВПФ = ИСТИНА
	               |	И Scan_ДополнительныеУсловияДоставки.ИспользованиеВДокументах.Документ = ЗНАЧЕНИЕ(Перечисление.Scan_ВидыДокументов.ЗаявкаПеревозчику)";
	Результат = Запрос.Выполнить().Выгрузить();
	Для каждого Условие Из Результат Цикл
		НоваяСтрока = ДопУсловия.Добавить();
		НоваяСтрока.ДопУсловие = Условие.Ссылка;	
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДанныеДляПечати.ЗагрузитьЗначения(Параметры.ДанныеДляПечати);
	ЗаполнитьДопУсловияДоставки();
	НастройкаТаможенногоОФормленияИДопУсловий();
КонецПроцедуры


&НаСервере
Процедура НастройкаТаможенногоОФормленияИДопУсловий()
	Если ВыводитьТаможенноеОформление = Истина Тогда
		Элементы.ТОСтранаПрибытия.ТолькоПросмотр  = Ложь;
		Элементы.ТОСтранаОтправления.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.ТОСтранаПрибытия.ТолькоПросмотр  = Истина;
		Элементы.ТОСтранаОтправления.ТолькоПросмотр = Истина;	
	КонецЕсли;	
	Если ПоказыватьДопУсловия = ИСТИНА Тогда
		Элементы.ДопУсловия.Видимость = Истина;
	Иначе
		Элементы.ДопУсловия.Видимость = ЛОЖЬ;
	КонецЕсли; 
КонецПроцедуры


&НаКлиенте
Процедура ПоказыватьДопУсловияПриИзменении(Элемент)
	НастройкаТаможенногоОФормленияИДопУсловий();
КонецПроцедуры


&НаКлиенте
Процедура ВыводитьТаможенноеОформлениеПриИзменении(Элемент)
	НастройкаТаможенногоОФормленияИДопУсловий();
КонецПроцедуры


&НаКлиенте
Процедура КомандаОк(Команда)
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(    "Документ.Scan_ЗаявкаПеревозчику",        //Менеджер печати
                            "ПФ_MXL_ЗаявкаПеревозчику",            //Идентификатор
                            ПолучитьОбъектыДляПечати(),        //Объекты печати
                            ЭтотОбъект,                //Владелец формы - форма из которой вызывается печать
                            ПолучитьПараметрыПечати());        //Параметры печати - произвольные параметры для передачи в менеджер печати
	Закрыть();
КонецПроцедуры

&НаСервере
Функция ПолучитьОбъектыДляПечати()
    Массив = ДанныеДляПечати.ВыгрузитьЗначения();
    Возврат Массив;
КонецФункции

&НаСервере
Функция ПолучитьПараметрыПечати()
    
    ПараметрыПечати = Новый Структура;
    
    ПараметрыПечати.Вставить("ЗаголовокФормы", "Печатная форма");                    //Один из параметров, для формы "Печать документа".
                                                    //Указывает заголовок формы вывода печатной формы.
	ПараметрыПечати.Вставить("ВыводитьВесИзделий",           ВыводитьВесИзделий);
	ПараметрыПечати.Вставить("ВыводитьГруппировкиИзделий",   ВыводитьГруппировкиИзделий);
	ПараметрыПечати.Вставить("ВыводитьГХПродуктовИзделий",   ВыводитьГХПродуктовИзделий);
	ПараметрыПечати.Вставить("ВыводитьСпецификацииИзделий",  ВыводитьСпецификацииИзделий);
	ПараметрыПечати.Вставить("ВыводитьТаможенноеОформление", ВыводитьТаможенноеОформление);
	ПараметрыПечати.Вставить("ПоказыватьДопУсловия",         ПоказыватьДопУсловия);
	ПараметрыПечати.Вставить("ТОСтранаОтправления",          ТОСтранаОтправления);
	ПараметрыПечати.Вставить("ТОСтранаПрибытия",             ТОСтранаПрибытия);
	ПараметрыПечати.Вставить("ДопУсловия",                   ДопУсловия);
	// rarus agar 14.12.2022 19668 ++
	ПараметрыПечати.Вставить("ВыводитьЛоготип",              ВыводитьЛоготип);
	// rarus agar 14.12.2022 19668 --
    Возврат ПараметрыПечати;
    
КонецФункции
//rarus sergei 28.09.2016 mantis 7160 --