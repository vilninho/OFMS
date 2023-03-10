//rarus tenkam 18.11.2017 9427 7183 ++

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ЭтоНовый() Тогда
		ДатаСоздания = ТекущаяДата();
		Автор = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	ЭтотОбъект.ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтотОбъект.ЭтоНовый());

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//rarus vikhle 14.07.2021 m 17459 +++
	Если ПометкаУдаления Тогда
		НаборЗаписей = РегистрыСведений.Scan_МатрицаХраненияИзделий.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Документ.Установить(Ссылка);
		
		Попытка
			НаборЗаписей.Записать();
		Исключение
			Сообщить(НСтр("ru = 'Ошибка записи данных в матрицу хранения продуктов'; en = 'Action failed '"));
			Отказ = Истина;
		КонецПопытки;
	КонецЕсли;	
	//rarus vikhle 14.07.2021 m 17459 ---
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если ЗначениеЗаполнено(ПлановаяДатаВыполненияКТС) Тогда
		// rarus tenkam 27.06.2019 mantis 14427 +++			
		//ТекПродукт = РегистрыСведений.Scan_ВзаимосвязьИзделийПродуктовИЗаказов.ПолучитьПродуктПоИзделию(Изделие);		// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +
		// rarus tenkam 27.06.2019 mantis 14427 ---			
		НаборЗаписей = РегистрыСведений.Scan_МатрицаХраненияИзделий.СоздатьНаборЗаписей();
		// rarus tenkam 27.06.2019 mantis 14427 +++			
		//НаборЗаписей.Отбор.Продукт.Установить(ТекПродукт);		// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +
		НаборЗаписей.Отбор.Изделие.Установить(Изделие);
		// rarus tenkam 27.06.2019 mantis 14427 ---			
		НаборЗаписей.Отбор.МестоХранения.Установить(МестоХранения);
		НаборЗаписей.Отбор.Реквизит.Установить(Перечисления.Scan_КонтрольныеДатыХраненияИзделий.ДатаВыполненияКТСПлан);	
		НаборЗаписей.Отбор.Документ.Установить(Ссылка);
		НаборЗаписей.Прочитать(); 			
		
		Если НаборЗаписей.Количество() = 0 Тогда
			НоваяЗапись = НаборЗаписей.Добавить();
			// rarus tenkam 27.06.2019 mantis 14427 +++			
			//НоваяЗапись.Продукт = ТекПродукт;	// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +
			НоваяЗапись.Изделие = Изделие;
			// rarus tenkam 27.06.2019 mantis 14427 ---			
			НоваяЗапись.МестоХранения = МестоХранения;
			НоваяЗапись.Реквизит = Перечисления.Scan_КонтрольныеДатыХраненияИзделий.ДатаВыполненияКТСПлан;
			НоваяЗапись.Значение = ПлановаяДатаВыполненияКТС;
			НоваяЗапись.Период   = ТекущаяДата();
			НоваяЗапись.Документ = Ссылка;
			НоваяЗапись.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();		
		Иначе
			ТекЗапись = НаборЗаписей[0];				
			Если ТекЗапись.Значение <> ПлановаяДатаВыполненияКТС Тогда
				ТекЗапись.Значение = ПлановаяДатаВыполненияКТС;
				ТекЗапись.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
			КонецЕсли;
		КонецЕсли;
		
		Попытка
			НаборЗаписей.Записать();
		Исключение
			//rarus FominskiyAS 08.07.2019  mantis 14191 +++
			//Сообщить(НСтр("ru = 'Ошибка записи данных в матрицу хранения изделий'"));
			Сообщить(НСтр("ru = 'Ошибка записи данных в матрицу хранения продуктов'; en = 'Action failed '"));
			//rarus FominskiyAS 08.07.2019  mantis 14191 ---
			Отказ = Истина;
		КонецПопытки;
	КонецЕсли;
	Если КТСВыполнен Тогда
		Если ЗначениеЗаполнено(ФактическаяДатаВыполненияКТС) Тогда
			// rarus tenkam 27.06.2019 mantis 14427 +++
			//ТекПродукт = РегистрыСведений.Scan_ВзаимосвязьИзделийПродуктовИЗаказов.ПолучитьПродуктПоИзделию(Изделие);		// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +
			// rarus tenkam 27.06.2019 mantis 14427 ---
			
			НаборЗаписей = РегистрыСведений.Scan_МатрицаХраненияИзделий.СоздатьНаборЗаписей();
			
			// rarus tenkam 27.06.2019 mantis 14427 +++			
			//НаборЗаписей.Отбор.Продукт.Установить(ТекПродукт);		// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +
			НаборЗаписей.Отбор.Изделие.Установить(Изделие);
			// rarus tenkam 27.06.2019 mantis 14427 ---
			
			НаборЗаписей.Отбор.МестоХранения.Установить(МестоХранения);
			НаборЗаписей.Отбор.Реквизит.Установить(Перечисления.Scan_КонтрольныеДатыХраненияИзделий.ДатаВыполненияКТСФакт);	
			НаборЗаписей.Отбор.Документ.Установить(Ссылка);
			НаборЗаписей.Прочитать(); 			
			
			Если НаборЗаписей.Количество() = 0 Тогда
				НоваяЗапись = НаборЗаписей.Добавить();
				// rarus tenkam 27.06.2019 mantis 14427 +++			
				//НоваяЗапись.Продукт = ТекПродукт; 	// rarus tenkam 22.07.2019 mantis 14662 + раскомментировано, удалить по 14430 +
				НоваяЗапись.Изделие = Изделие;
				// rarus tenkam 27.06.2019 mantis 14427 ---
			
				НоваяЗапись.МестоХранения = МестоХранения;
				НоваяЗапись.Реквизит = Перечисления.Scan_КонтрольныеДатыХраненияИзделий.ДатаВыполненияКТСФакт;
				НоваяЗапись.Значение = ФактическаяДатаВыполненияКТС;
				НоваяЗапись.Период   = ТекущаяДата();
				НоваяЗапись.Документ = Ссылка;
				НоваяЗапись.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();		
			Иначе
				ТекЗапись = НаборЗаписей[0];				
				Если ТекЗапись.Значение <> ФактическаяДатаВыполненияКТС Тогда
					ТекЗапись.Значение = ФактическаяДатаВыполненияКТС;
					ТекЗапись.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
				КонецЕсли;
			КонецЕсли;
			
			Попытка
				НаборЗаписей.Записать();
			Исключение
				//rarus FominskiyAS 08.07.2019  mantis 14191 +++
				//Сообщить(НСтр("ru = 'Ошибка записи данных в матрицу хранения изделий'"));
				Сообщить(НСтр("ru = 'Ошибка записи данных в матрицу хранения продуктов'; en = 'Action failed '"));
				//rarus FominskiyAS 08.07.2019  mantis 14191 ---
				Отказ = Истина;
			КонецПопытки;
		КонецЕсли;	
		
		Если НЕ Отказ Тогда
			Если ЗначениеЗаполнено(ОказаннаяУслуга) И ЗначениеЗаполнено(ОбщаяСтоимостьУслуги) Тогда
				// регистр Scan_РеестрОказанныхУслуг
				Движения.Scan_РеестрОказанныхУслуг.Записывать = Истина;
				Движение = Движения.Scan_РеестрОказанныхУслуг.Добавить();
				Движение.Регистратор = Ссылка;
				Движение.Изделие = Изделие;
				Движение.Контрагент = Исполнитель;
				Движение.ДоговорКонтрагента = ДоговорСИсполнителем;
				Движение.НоменклатураУслуги = ОказаннаяУслуга;
				
				Движение.СтавкаНДС = ДоговорСИсполнителем.СтавкаНДС;
				Если ДоговорСИсполнителем.ВключаетНДС Тогда
					СуммаНДС = ОбщаяСтоимостьУслуги * ДоговорСИсполнителем.СтавкаНДС.Ставка / (100 + ДоговорСИсполнителем.СтавкаНДС.Ставка);
					СуммаРегистра = ОбщаяСтоимостьУслуги - СуммаНДС;
				Иначе
					СуммаНДС = ОбщаяСтоимостьУслуги * ДоговорСИсполнителем.СтавкаНДС.Ставка / 100; 
					СуммаРегистра = ОбщаяСтоимостьУслуги;
				КонецЕсли;
				Движение.СуммаНДС = СуммаНДС; 				
				Движение.Сумма = СуммаРегистра;
				Движение.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
				
				ГруппаИзделия =  Изделие.ТипПродукта.ВидПродукта.ГруппаПродукта;
				Если ГруппаИзделия = Справочники.Scan_ГруппыПродуктов.ТранспортныеСредства Тогда
					ЛогТип = Изделие.ТипПродуктаЛогистический;
					КолФормула = Изделие.МодельПродукта.КолеснаяФормула;
				Иначе 
					ЛогТип = Справочники.Scan_ТипыПродуктовЛогистика.ПустаяСсылка();
					КолФормула = Справочники.Scan_КолесныеФормулыИзделий.ПустаяСсылка();
				КонецЕсли;
				Движение.ГруппаПродукта = ГруппаИзделия;
				Движение.ЛогистическийТип = ЛогТип;
				Движение.КолеснаяФормула = КолФормула;
				Движение.ДатаДоставкиФакт = ФактическаяДатаВыполненияКТС; 
				
			КонецЕсли;
			
			// rarus tenkam 08.02.2018 mantis 12721 +++
			// Данные по АКБ
			ВСоставеЕстьАКБ1 = Ложь;
			ВСоставеЕстьАКБ2 = Ложь;
			Если Документы.Scan_ЧекЛистТехническогоСостоянияИзделия.ЕстьПроверкаУровняЗаряженностиАКБ(Ссылка, ВСоставеЕстьАКБ1, ВСоставеЕстьАКБ2) Тогда
				
				Если ВСоставеЕстьАКБ1 Тогда
					АКБИзделия1 = Справочники.Scan_АккумуляторныеБатареи.ПолучитьАКБ(Изделие, 1);
					Если ЗначениеЗаполнено(АКБИзделия1) Тогда
						
						СтруктураХарактеристикБыло = Новый Структура;
						СтруктураХарактеристикСтало = Новый Структура;
						
						СоответствиеХарактеристикБыло = Новый Соответствие;
						СоответствиеХарактеристикСтало = Новый Соответствие;
						Для Каждого ТекСтрока Из СписокРабот Цикл
							Если ТекСтрока.Составляющая.Код = "100000001" И ТекСтрока.Составляющая.Наименование = "Емкость" Тогда
								СтруктураХарактеристикБыло.Вставить("Емкость", ТекСтрока.РезультатБыло);
								СтруктураХарактеристикСтало.Вставить("Емкость", ТекСтрока.РезультатСтало);
							ИначеЕсли ТекСтрока.Составляющая.Код = "100000002" И ТекСтрока.Составляющая.Наименование = "Плотность" Тогда 
								СтруктураХарактеристикБыло.Вставить("Плотность", ТекСтрока.РезультатБыло);
								СтруктураХарактеристикСтало.Вставить("Плотность", ТекСтрока.РезультатСтало);
							ИначеЕсли ТекСтрока.Составляющая.Код = "100000003" И ТекСтрока.Составляющая.Наименование = "Пусковой ток" Тогда 
								СтруктураХарактеристикБыло.Вставить("ПусковойТок", ТекСтрока.РезультатБыло);
								СтруктураХарактеристикСтало.Вставить("ПусковойТок", ТекСтрока.РезультатСтало);
								
							ИначеЕсли ТекСтрока.Составляющая.Код = "100000004" И ТекСтрока.Составляющая.Наименование = "Напряжение без нагрузки" Тогда 
								СтруктураХарактеристикБыло.Вставить("НапряжениеБезНагрузки", ТекСтрока.РезультатБыло);
								СтруктураХарактеристикСтало.Вставить("НапряжениеБезНагрузки", ТекСтрока.РезультатСтало);
								
							ИначеЕсли ТекСтрока.Составляющая.Код = "100000005" И ТекСтрока.Составляющая.Наименование = "Напряжение под нагрузкой" Тогда 
								СтруктураХарактеристикБыло.Вставить("НапряжениеПодНагрузкой", ТекСтрока.РезультатБыло);
								СтруктураХарактеристикСтало.Вставить("НапряжениеПодНагрузкой", ТекСтрока.РезультатСтало);
								
							КонецЕсли;
						КонецЦикла;
						
						СоответствиеХарактеристикБыло.Вставить("Емкость", СтруктураХарактеристикБыло.Емкость);
						СоответствиеХарактеристикБыло.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.Плотность"), СтруктураХарактеристикБыло.Плотность);
						СоответствиеХарактеристикБыло.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.ПусковойТок"), СтруктураХарактеристикБыло.ПусковойТок);
						СоответствиеХарактеристикБыло.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.НапряжениеБезНагрузки"), СтруктураХарактеристикБыло.НапряжениеБезНагрузки);
						СоответствиеХарактеристикБыло.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.НапряжениеПодНагрузкой"), СтруктураХарактеристикБыло.НапряжениеПодНагрузкой);
						СостояниеБыло = Справочники.Scan_СостоянияАКБ.ПолучитьСостояниеПоХарактеристикам(СоответствиеХарактеристикБыло);
						СтруктураХарактеристикБыло.Вставить("Состояние", СостояниеБыло);
						
						СоответствиеХарактеристикСтало.Вставить("Емкость", СтруктураХарактеристикСтало.Емкость);
						СоответствиеХарактеристикСтало.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.Плотность"), СтруктураХарактеристикСтало.Плотность);
						СоответствиеХарактеристикСтало.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.ПусковойТок"), СтруктураХарактеристикСтало.ПусковойТок);
						СоответствиеХарактеристикСтало.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.НапряжениеБезНагрузки"), СтруктураХарактеристикСтало.НапряжениеБезНагрузки);
						СоответствиеХарактеристикСтало.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.НапряжениеПодНагрузкой"), СтруктураХарактеристикСтало.НапряжениеПодНагрузкой);
						СостояниеСтало = Справочники.Scan_СостоянияАКБ.ПолучитьСостояниеПоХарактеристикам(СоответствиеХарактеристикСтало);
						СтруктураХарактеристикСтало.Вставить("Состояние", СостояниеСтало);
						
						РегистрыСведений.Scan_ДанныеПоАКБИзделий.ЗаписатьХарактеристикиАКБ(АКБИзделия1, Изделие,СтруктураХарактеристикБыло, ФактическаяДатаВыполненияКТС);
						РегистрыСведений.Scan_ДанныеПоАКБИзделий.ЗаписатьХарактеристикиАКБ(АКБИзделия1, Изделие,СтруктураХарактеристикСтало, ФактическаяДатаВыполненияКТС + 4*60*60);
					КонецЕсли;
					
				КонецЕсли;
				
				Если ВСоставеЕстьАКБ2 Тогда
					АКБИзделия2 = Справочники.Scan_АккумуляторныеБатареи.ПолучитьАКБ(Изделие, 2);
					Если ЗначениеЗаполнено(АКБИзделия2) Тогда
						
						СтруктураХарактеристикБыло = Новый Структура;
						СтруктураХарактеристикСтало = Новый Структура;
						
						СоответствиеХарактеристикБыло = Новый Соответствие;
						СоответствиеХарактеристикСтало = Новый Соответствие;
						Для Каждого ТекСтрока Из СписокРабот Цикл
							Если ТекСтрока.Составляющая.Код = "200000001" И ТекСтрока.Составляющая.Наименование = "Емкость" Тогда
								СтруктураХарактеристикБыло.Вставить("Емкость", ТекСтрока.РезультатБыло);
								СтруктураХарактеристикСтало.Вставить("Емкость", ТекСтрока.РезультатСтало);
							ИначеЕсли ТекСтрока.Составляющая.Код = "200000002" И ТекСтрока.Составляющая.Наименование = "Плотность" Тогда 
								СтруктураХарактеристикБыло.Вставить("Плотность", ТекСтрока.РезультатБыло);
								СтруктураХарактеристикСтало.Вставить("Плотность", ТекСтрока.РезультатСтало);
							ИначеЕсли ТекСтрока.Составляющая.Код = "200000003" И ТекСтрока.Составляющая.Наименование = "Пусковой ток" Тогда 
								СтруктураХарактеристикБыло.Вставить("ПусковойТок", ТекСтрока.РезультатБыло);
								СтруктураХарактеристикСтало.Вставить("ПусковойТок", ТекСтрока.РезультатСтало);
								
							ИначеЕсли ТекСтрока.Составляющая.Код = "200000004" И ТекСтрока.Составляющая.Наименование = "Напряжение без нагрузки" Тогда 
								СтруктураХарактеристикБыло.Вставить("НапряжениеБезНагрузки", ТекСтрока.РезультатБыло);
								СтруктураХарактеристикСтало.Вставить("НапряжениеБезНагрузки", ТекСтрока.РезультатСтало);
								
							ИначеЕсли ТекСтрока.Составляющая.Код = "200000005" И ТекСтрока.Составляющая.Наименование = "Напряжение под нагрузкой" Тогда 
								СтруктураХарактеристикБыло.Вставить("НапряжениеПодНагрузкой", ТекСтрока.РезультатБыло);
								СтруктураХарактеристикСтало.Вставить("НапряжениеПодНагрузкой", ТекСтрока.РезультатСтало);
								
							КонецЕсли;
						КонецЦикла;
						
						СоответствиеХарактеристикБыло.Вставить("Емкость", СтруктураХарактеристикБыло.Емкость);
						СоответствиеХарактеристикБыло.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.Плотность"), СтруктураХарактеристикБыло.Плотность);	// rarus tenkam 14.03.2018 mantis 12900 + (были перепутаны плотность и пусковой ток) 
						СоответствиеХарактеристикБыло.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.ПусковойТок"), СтруктураХарактеристикБыло.ПусковойТок);	// rarus tenkam 14.03.2018 mantis 12900 + (были перепутаны плотность и пусковой ток) 
						СоответствиеХарактеристикБыло.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.НапряжениеБезНагрузки"), СтруктураХарактеристикБыло.НапряжениеБезНагрузки);
						СоответствиеХарактеристикБыло.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.НапряжениеПодНагрузкой"), СтруктураХарактеристикБыло.НапряжениеПодНагрузкой);
						СостояниеБыло = Справочники.Scan_СостоянияАКБ.ПолучитьСостояниеПоХарактеристикам(СоответствиеХарактеристикБыло);
						СтруктураХарактеристикБыло.Вставить("Состояние", СостояниеБыло);
						
						СоответствиеХарактеристикСтало.Вставить("Емкость", СтруктураХарактеристикСтало.Емкость);
						СоответствиеХарактеристикСтало.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.Плотность"), СтруктураХарактеристикСтало.Плотность);	// rarus tenkam 14.03.2018 mantis 12900 + (были перепутаны плотность и пусковой ток)  
						СоответствиеХарактеристикСтало.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.ПусковойТок"), СтруктураХарактеристикСтало.ПусковойТок);	// rarus tenkam 14.03.2018 mantis 12900 + (были перепутаны плотность и пусковой ток) 
						СоответствиеХарактеристикСтало.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.НапряжениеБезНагрузки"), СтруктураХарактеристикСтало.НапряжениеБезНагрузки);
						СоответствиеХарактеристикСтало.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.НапряжениеПодНагрузкой"), СтруктураХарактеристикСтало.НапряжениеПодНагрузкой);
						СостояниеСтало = Справочники.Scan_СостоянияАКБ.ПолучитьСостояниеПоХарактеристикам(СоответствиеХарактеристикСтало);
						// rarus tenkam 14.03.2018 mantis 12900 +++
						//СтруктураХарактеристикСтало.Вставить("Состояние", СостояниеБыло);
						СтруктураХарактеристикСтало.Вставить("Состояние", СостояниеСтало);
						// rarus tenkam 14.03.2018 mantis 12900 ---
						
						РегистрыСведений.Scan_ДанныеПоАКБИзделий.ЗаписатьХарактеристикиАКБ(АКБИзделия2, Изделие,СтруктураХарактеристикБыло, ФактическаяДатаВыполненияКТС);
						РегистрыСведений.Scan_ДанныеПоАКБИзделий.ЗаписатьХарактеристикиАКБ(АКБИзделия2, Изделие,СтруктураХарактеристикСтало, ФактическаяДатаВыполненияКТС + 4*60*60);
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;				
			// rarus tenkam 08.02.2018 mantis 12721 ---
		КонецЕсли;
	КонецЕсли;
				
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	СтарыйЧекЛист = Документы.Scan_ЧекЛистТехническогоСостоянияИзделия.ПолучитьАктуальныйЧекЛист(Изделие, Ссылка);
	Если ЗначениеЗаполнено(СтарыйЧекЛист) Тогда
		Отказ = Истина;
		Сообщить("Для продукта " + Изделие + " уже есть чек лист технического состояния: " + СтарыйЧекЛист);
	КонецЕсли;	
	
	// Проверка на заполнение табличной части
	Если ЗначениеЗаполнено(ФактическаяДатаВыполненияКТС) И ЗначениеЗаполнено(Изделие) И ЗначениеЗаполнено(МестоХранения) Тогда
		ДатаПостановкиНаХранение = РегистрыСведений.Scan_МатрицаХраненияИзделий.ПолучитьДатуПостановкиНаХранение(Изделие, МестоХранения, Ссылка, ПлановаяДатаВыполненияКТС);
		
		Если ФактическаяДатаВыполненияКТС <= ДатаПостановкиНаХранение Тогда
			
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Дата выполнения КТС (факт) не может быть меньше или равна дате постановки на хранение";
			Сообщение.Поле = "ФактическаяДатаВыполненияКТС";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
			
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ) // rarus tenkam 28.07.2021 mantis 17459 ++
	НаборЗаписей = РегистрыСведений.Scan_МатрицаХраненияИзделий.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Изделие.Установить(Изделие);
	НаборЗаписей.Отбор.МестоХранения.Установить(МестоХранения);
	НаборЗаписей.Отбор.Документ.Установить(Ссылка);
	НаборЗаписей.Записать(); 		
КонецПроцедуры // rarus tenkam 28.07.2021 mantis 17459 --

