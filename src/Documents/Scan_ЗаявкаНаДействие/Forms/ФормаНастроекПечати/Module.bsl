//rarus sergei 29.09.2016 mantis 7162 ++
&НаСервере
Процедура ЗаполнитьДопУсловияДоставки()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_ДополнительныеУсловияДоставки.Ссылка
	               |ИЗ
	               |	Справочник.Scan_ДополнительныеУсловияДоставки КАК Scan_ДополнительныеУсловияДоставки
	               |ГДЕ
	               |	Scan_ДополнительныеУсловияДоставки.ИспользоватьПоУмолчаниюВПФ = ИСТИНА
	               |	И Scan_ДополнительныеУсловияДоставки.ИспользованиеВДокументах.Документ = ЗНАЧЕНИЕ(Перечисление.Scan_ВидыДокументов.ЗаявкаНаДействие)";
	Результат = Запрос.Выполнить().Выгрузить();
	Для каждого Условие Из Результат Цикл
		НоваяСтрока = ДопУсловия.Добавить();
		НоваяСтрока.ДопУсловие = Условие.Ссылка;	
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДанныеДляПечати.ЗагрузитьЗначения(Параметры.ДанныеДляПечати);
	ЭтаФорма.Заголовок ="Настройка печати документа Заявка на Действие с хоз операцией "+ДанныеДляПечати[0].Значение.ХозОперация;
	ИмяМакета = Параметры.ПечатнаяФорма;
	Если ДанныеДляПечати[0].Значение.ХозОперация = Справочники.Scan_ХозяйственныеОперации.СнятиеСХраненияИПередачаВПроизводство ИЛИ
		ДанныеДляПечати[0].Значение.ХозОперация = Справочники.Scan_ХозяйственныеОперации.ПередачаВПроизводство Тогда
		Элементы.ВыводитьСпецификацииИзделий.Видимость = Ложь;	
	КонецЕсли; 
	Если ДанныеДляПечати[0].Значение.ХозОперация = Справочники.Scan_ХозяйственныеОперации.Доставка ИЛИ 
		//rarus tenkam 08.02.2017 mantis 8331 +++
		ДанныеДляПечати[0].Значение.ХозОперация = Справочники.Scan_ХозяйственныеОперации.ДоставкаИПостановкаНаХранение ИЛИ
		ДанныеДляПечати[0].Значение.ХозОперация = Справочники.Scan_ХозяйственныеОперации.ДоставкаИПередачаВПроизводство ИЛИ
		//rarus tenkam 08.02.2017 mantis 8331 ---
		ДанныеДляПечати[0].Значение.ХозОперация = Справочники.Scan_ХозяйственныеОперации.ПокупкаУПоставщикаИПередачаТК ИЛИ
		ДанныеДляПечати[0].Значение.ХозОперация = Справочники.Scan_ХозяйственныеОперации.ПокупкаУПоставщикаПродажаТретьемуЛицуИПередачаТК	ИЛИ
		ДанныеДляПечати[0].Значение.ХозОперация = Справочники.Scan_ХозяйственныеОперации.ПродажаТретьемуЛицуСоСкладаСканияРусьИПередачаТК ИЛИ 		//rarus tenkam 26.09.2017 mantis 10742 +
		ДанныеДляПечати[0].Значение.ХозОперация = Справочники.Scan_ХозяйственныеОперации.СнятиеСХраненияИПередачаТК ИЛИ
		ДанныеДляПечати[0].Значение.ХозОперация = Справочники.Scan_ХозяйственныеОперации.СнятиеСХраненияПродажаТретьемуЛицуИПередачаТК Тогда 
		Для каждого строка Из ДанныеДляПечати Цикл
			
			ВыборкаКорректировок = РегистрыСведений.Scan_КорректировкаИнформацииПоЗаявкам.ВыбратьПоРегистратору(строка.Значение);
			Пока ВыборкаКорректировок.Следующий() Цикл
				Если ВыборкаКорректировок.Перевозчик <> Справочники.Scan_Контрагенты.ПустаяСсылка() Тогда
					Если Перевозчики.Количество() = 0 Тогда 
						НоваяСтрока = Перевозчики.Добавить();
						НоваяСтрока.Перевозчик = ВыборкаКорректировок.Перевозчик;
						НоваяСтрока.ЗаявкаНаДействие = строка.Значение;
						НоваяСтрока.ЗаявкаПеревозчику = ВыборкаКорректировок.ЗаявкаПеревозчику;
						НоваяСтрока.ДоговорСПеревозчиком = ВыборкаКорректировок.ЗаявкаПеревозчику.ДоговорСПеревозчиком;
					Иначе
						ПараметрыОтбора = Новый Структура;
						ПараметрыОтбора.Вставить("ЗаявкаПеревозчику", ВыборкаКорректировок.ЗаявкаПеревозчику);
						НайденныеСтроки = Перевозчики.НайтиСтроки(ПараметрыОтбора);
						Если НайденныеСтроки.Количество() = 0 Тогда
							НоваяСтрока = Перевозчики.Добавить();
							НоваяСтрока.Перевозчик = ВыборкаКорректировок.Перевозчик;
							НоваяСтрока.ЗаявкаНаДействие = строка.Значение;
							НоваяСтрока.ЗаявкаПеревозчику = ВыборкаКорректировок.ЗаявкаПеревозчику;
							НоваяСтрока.ДоговорСПеревозчиком = ВыборкаКорректировок.ЗаявкаПеревозчику.ДоговорСПеревозчиком;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла; 
		КонецЦикла; 
		
		Если ДанныеДляПечати.Количество()>1 Тогда
			Элементы.ПеревозчикиЗаявкаНаДействие.Видимость = Истина;
		Иначе
			Элементы.ПеревозчикиЗаявкаНаДействие.Видимость = Ложь;
		КонецЕсли;
		Если Перевозчики.Количество() = 0 Тогда
			Элементы.Перевозчики.Видимость = Ложь;
		Иначе
			Элементы.Перевозчики.Видимость = Истина;	
		КонецЕсли; 
	Иначе
		Элементы.Перевозчики.Видимость = Ложь;	
	КонецЕсли;
	
	ЗаполнитьДопУсловияДоставки();
	НастройкаДопУсловий();
КонецПроцедуры


&НаСервере
Процедура НастройкаДопУсловий()
	Если ПоказыватьДопУсловия = ИСТИНА Тогда
		Элементы.ДопУсловия.Видимость = Истина;
	Иначе
		Элементы.ДопУсловия.Видимость = ЛОЖЬ;
	КонецЕсли; 
КонецПроцедуры


&НаКлиенте
Процедура ПоказыватьДопУсловияПриИзменении(Элемент)
	НастройкаДопУсловий();
КонецПроцедуры


&НаКлиенте
Процедура КомандаОк(Команда) 
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(    "Документ.Scan_ЗаявкаНаДействие",        //Менеджер печати
                            ИмяМакета,            //Идентификатор
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
	Если Элементы.Перевозчики.Видимость = Истина Тогда
		ПараметрыПечати.Вставить("ТаблицаПеревозчиков",Перевозчики);
	КонецЕсли;	
	ПараметрыПечати.Вставить("ЗаголовокФормы", "Печатная форма");                    //Один из параметров, для формы "Печать документа".
                                                    								 //Указывает заголовок формы вывода печатной формы.
																			 
	ПараметрыПечати.Вставить("ВыводитьСпецификацииИзделий",  ВыводитьСпецификацииИзделий);
	ПараметрыПечати.Вставить("ПоказыватьДопУсловия",         ПоказыватьДопУсловия);
	ПараметрыПечати.Вставить("ДопУсловия",                   ДопУсловия);
	// rarus agar 14.12.2022 19668 ++
	ПараметрыПечати.Вставить("ВыводитьЛоготип",              ВыводитьЛоготип);
	// rarus agar 14.12.2022 19668 --
    Возврат ПараметрыПечати;
    
КонецФункции

//rarus sergei 29.09.2016 mantis 7162 --