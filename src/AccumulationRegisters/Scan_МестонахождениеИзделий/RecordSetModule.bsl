//rarus tenkam 05.03.2017 mantis 6897 +++
Процедура ПриЗаписи(Отказ, Замещение)
	//rarus tenkam 21.03.2017 mantis 9109 +++
	//Если ДополнительныеСвойства.Свойство("ОчисткаПередЗаписью") Тогда
	//	Возврат;
	//КонецЕсли;
	//rarus tenkam 21.03.2017 mantis 9109 ---
	
	Если Scan_ПраваИНастройки.Scan_Право("ОбменСПредставительством") И Scan_ПраваИНастройки.Scan_Право("ОбратныйОбменС1БД") Тогда		
		ТабЗначенийМестонахождениеИзделий = ЭтотОбъект.Выгрузить();
		ДокументСсылка = ЭтотОбъект.Отбор.Регистратор.Значение;
		
		//rarus tenkam 18.08.2017 mantis 10824 +++
		ПараметрыФоновогоЗадания = Новый Массив;
		СтруктураПараметровФЗ = Новый Структура;
		СтруктураПараметровФЗ.Вставить("ТабЗначенийМестонахождениеИзделий", ТабЗначенийМестонахождениеИзделий);
		СтруктураПараметровФЗ.Вставить("ДокументСсылка",ДокументСсылка);
		ПараметрыФоновогоЗадания.Добавить(СтруктураПараметровФЗ);
		
		// rarus tenkam 16.09.2020 mantis 16566 +++
		СтруктураОтбор = Новый Структура("ИмяМетода", "Scan_ВебСервисы.ОтправитьИзменениеМестонахождения");
		СтруктураОтбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
		МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(СтруктураОтбор);
		Если МассивФоновыхЗаданий.Количество() <> 0 Тогда
			ЗаданиеВыгрузки = МассивФоновыхЗаданий[0];
			ИдентификаторЗадания = ЗаданиеВыгрузки.УникальныйИдентификатор;
			Пока Истина Цикл
				//ФоновыеЗадания.ОжидатьЗавершения(МассивФоновыхЗаданий,3);
				ЗаданиеВыгрузки = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
				
				Если ЗаданиеВыгрузки <> Неопределено И ЗаданиеВыгрузки.Состояние = СостояниеФоновогоЗадания.Активно Тогда
					// продолжаем ждать завершения
					Продолжить;
				Иначе
					// фоновое задание завершено
					Прервать;
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;
		// rarus tenkam 16.09.2020 mantis 16566 ---
		
		ФоновыеЗадания.Выполнить("Scan_ВебСервисы.ОтправитьИзменениеМестонахождения", ПараметрыФоновогоЗадания, Новый УникальныйИдентификатор, "Отправка изменения местонахождения в 1БД");	
				
		//Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.Scan_ДвижениеИзделий") ИЛИ 
		//	ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.Scan_ЗаявкаПеревозчику") Тогда
		//	
		//	ИмяТЧ = "СоставЗаявки";
		//ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.Scan_ПеремещениеИзделий") Тогда 
		//	ИмяТЧ = "ИзделияДляПеремещения";	
		//КонецЕсли;
		//
		//Если ТабЗначенийМестонахождениеИзделий.Количество() = 0 Тогда
		//	// Документ распровели или аннулировали, передадим текущее местонахождение
		//	Для Каждого ТекСтрока Из ДокументСсылка[ИмяТЧ] Цикл
		//		Если НЕ ЗначениеЗаполнено(ТекСтрока.Изделие.IDExternalSystem) Тогда
		//			Продолжить;
		//		КонецЕсли;
		//		
		//		// Получим тек. местонахождение изделия
		//		ТекДанные = РегистрыНакопления.Scan_МестонахождениеИзделий.ПолучитьМестонахождениеИДатуПриходаИзделия(ТекСтрока.Изделие, ТекущаяДата());
		//		Если ТекДанные = Неопределено Тогда
		//			Продолжить;
		//		КонецЕсли;
		//		ТекМестонахождение = ТекДанные.МестоХранения;
		//		ТекДатаПрихода = ТекДанные.ДатаПрихода;	
		//		
		//		// Получим место хранения, которое было отправлено в 1БД
		//		ПоследниеДанныеПоИзделию = РегистрыСведений.Scan_Обмен1БДИсторияМестонахожденияИзделий.ПолучитьМестонахождение(ТекСтрока.Изделие,ТекущаяДата());
		//		//rarus tenkam 16.03.2017 mantis 7623 +++
		//		Если ПоследниеДанныеПоИзделию = Неопределено ИЛИ ПоследниеДанныеПоИзделию.Количество() = 0 Тогда
		//			ПоследнееОтправленноеМестонахождение = Неопределено;
		//		Иначе
		//			//rarus tenkam 16.03.2017 mantis 7623 ---
		//			ПоследнееОтправленноеМестонахождение = ПоследниеДанныеПоИзделию[0].МестоХранения;
		//		//rarus tenkam 16.03.2017 mantis 7623 +++
		//		КонецЕсли;
		//		//rarus tenkam 16.03.2017 mantis 7623 ---
		//		
		//		Если ТекМестонахождение <> ПоследнееОтправленноеМестонахождение Тогда
		//			// Возможно, это аннулирование или отмена проведения - отправим тек. местонахождение
		//			
		//			ИмяМетода = "SendProductActivityEvent";
		//			СообщениеОбОшибке = "";
		//			ОтказОбмена = Ложь;
		//			
		//			// Получим структуру данных
		//			СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода, Ложь);					
		//			
		//			СтруктураПараметров.Вставить("ВидСобытия", "ИзменениеМестонахождения");		//rarus tenkam 28.06.2017 mantis 9065 +
		//			СтруктураПараметров.Вставить("ДатаСобытия", ТекДатаПрихода);
		//			СтруктураПараметров.Вставить("GuidСобытияВВнешнейСистеме", Строка(ДокументСсылка.УникальныйИдентификатор()));
		//			
		//			ПричинаСобытия = "Отмена проведения / сторнирование документа " + Строка(ДокументСсылка);
		//			СтруктураПараметров.Вставить("ПричинаСобытия", ПричинаСобытия);
		//			
		//			СтруктураПараметров.Вставить("ТекстСобытия","ХО " + ДокументСсылка.ХозОперация.Наименование);
		//			СтруктураПараметров.Вставить("Пользователь",ПользователиКлиентСервер.ТекущийПользователь().Наименование);
		//			СтруктураПараметров.Вставить("ТСGUID",ТекСтрока.Изделие.IDExternalSystem);
		//			
		//			СтруктураПараметров.Вставить("НаименованиеМестаХранения", ТекМестонахождение.Наименование);
		//			
		//			ТипМестаХранения = Scan_ВспомогательныеФункцииСервер.ПолучитьТипМестаХранения(ТекМестонахождение);
		//			СтруктураПараметров.Вставить("ТипМестаХранения", ТипМестаХранения);
		//			
		//			СтруктураПараметров.Вставить("GUIDИсточника", Строка(ТекМестонахождение.УникальныйИдентификатор()));
		//			СтруктураПараметров.Вставить("КодИсточника", ТекМестонахождение.Код);
		//			
		//			Адрес = Scan_ВспомогательныеФункцииСервер.ПолучитьАдресМестаХранения(ТекМестонахождение);
		//			СтруктураПараметров.Вставить("Адрес", Адрес);
		//			
		//			//Отправим запрос в 1БД
		//			ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
		//			ТекЭлементОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, ОтказОбмена, ИмяСобытияЖурналаРегистрации);
		//			Если Не ОтказОбмена Тогда
		//				
		//				GuidСобытия1БД = Scan_ВебСервисыРазборОтветов.РазборОтветаОтправкиСобытия(ТекЭлементОтвет, ОтказОбмена, СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации, ИмяМетода); 
		//				
		//				//Запишем историю в регистр
		//				РегистрыСведений.Scan_Обмен1БДИсторияМестонахожденияИзделий.ЗаписьИстории(ТекСтрока.Изделие, ТекМестонахождение, ТекДатаПрихода, ДокументСсылка, GuidСобытия1БД);
		//			КонецЕсли;
		//		КонецЕсли;
		//	КонецЦикла;
		//Иначе
		//	//Есть движения документа
		//	Для Каждого ТекСтрока Из ТабЗначенийМестонахождениеИзделий Цикл
		//		Если НЕ ЗначениеЗаполнено(ТекСтрока.Изделие.IDExternalSystem) Тогда
		//			Продолжить;
		//		КонецЕсли;
		//		Если ТекСтрока.ВидДвижения = ВидДвиженияНакопления.Расход Тогда
		//			Продолжить;
		//		КонецЕсли;
		//		
		//		Если РегистрыСведений.Scan_Обмен1БДИсторияМестонахожденияИзделий.ТакаяЗаписьУжеЕсть(ТекСтрока.Изделие, ТекСтрока.МестоХранения, ТекСтрока.ДатаПрихода, ДокументСсылка) Тогда 
		//			Продолжить;
		//		КонецЕсли;
		//		
		//		ИмяМетода = "SendProductActivityEvent";
		//		СообщениеОбОшибке = "";
		//		ОтказОбмена = Ложь;
		//		
		//		// Получим структуру данных
		//		СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода, Ложь);					
		//		
		//		СтруктураПараметров.Вставить("ВидСобытия", "ИзменениеМестонахождения");		//rarus tenkam 28.06.2017 mantis 9065 +
		//		СтруктураПараметров.Вставить("ДатаСобытия", ТекСтрока.ДатаПрихода);
		//		СтруктураПараметров.Вставить("GuidСобытияВВнешнейСистеме", Строка(ДокументСсылка.УникальныйИдентификатор()));
		//		
		//		ПричинаСобытия = Строка(ДокументСсылка);
		//		СтруктураПараметров.Вставить("ПричинаСобытия", ПричинаСобытия);
		//		
		//		СтруктураПараметров.Вставить("ТекстСобытия","ХО " + ТекСтрока.ХозОперация.Наименование);
		//		СтруктураПараметров.Вставить("Пользователь",ТекСтрока.Пользователь.Наименование);
		//		СтруктураПараметров.Вставить("ТСGUID",ТекСтрока.Изделие.IDExternalSystem);
		//		
		//		СтруктураПараметров.Вставить("НаименованиеМестаХранения", ТекСтрока.МестоХранения.Наименование);
		//		
		//		ТипМестаХранения = Scan_ВспомогательныеФункцииСервер.ПолучитьТипМестаХранения(ТекСтрока.МестоХранения);
		//		СтруктураПараметров.Вставить("ТипМестаХранения", ТипМестаХранения);
		//		
		//		СтруктураПараметров.Вставить("GUIDИсточника", Строка(ТекСтрока.МестоХранения.УникальныйИдентификатор()));
		//		СтруктураПараметров.Вставить("КодИсточника", ТекСтрока.МестоХранения.Код);
		//		
		//		Адрес = Scan_ВспомогательныеФункцииСервер.ПолучитьАдресМестаХранения(ТекСтрока.МестоХранения);
		//		СтруктураПараметров.Вставить("Адрес", Адрес);
		//		
		//		//Отправим запрос в 1БД
		//		ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
		//		ТекЭлементОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, ОтказОбмена, ИмяСобытияЖурналаРегистрации);
		//		Если Не ОтказОбмена Тогда
		//			GuidСобытия1БД = Scan_ВебСервисыРазборОтветов.РазборОтветаОтправкиСобытия(ТекЭлементОтвет, ОтказОбмена, СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации, ИмяМетода); 
		//			
		//			//Запишем историю в регистр
		//			РегистрыСведений.Scan_Обмен1БДИсторияМестонахожденияИзделий.ЗаписьИстории(ТекСтрока.Изделие, ТекСтрока.МестоХранения, ТекСтрока.ДатаПрихода, ДокументСсылка, GuidСобытия1БД);
		//		КонецЕсли;
		//	КонецЦикла;
		//КонецЕсли;    		
	КонецЕсли;
	
	//rarus tenkam 14.11.2017 mantis 9427 +++
	ТабЗначенийМестонахождениеИзделий = ЭтотОбъект.Выгрузить();
	ДокументСсылка = ЭтотОбъект.Отбор.Регистратор.Значение;
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.Scan_ЗаявкаПеревозчику") Тогда
		ИмяТЧ = "СоставЗаявки";
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.Scan_ПеремещениеИзделий") Тогда 
		ИмяТЧ = "ИзделияДляПеремещения";
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.Scan_ДвижениеИзделий") Тогда  
		ИмяТЧ = "СоставЗаявки";	
	КонецЕсли;
	
	Если ТабЗначенийМестонахождениеИзделий.Количество() = 0 Тогда
		// Документ распровели или аннулировали
		//Для Каждого ТекСтрока Из ДокументСсылка[ИмяТЧ] Цикл
		//	Если НЕ ЗначениеЗаполнено(ТекСтрока.Изделие.IDExternalSystem) Тогда
		//		Продолжить;
		//	КонецЕсли;
		//КонецЦикла;
		
		НаборЗаписей = РегистрыСведений.Scan_МатрицаХраненияИзделий.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Документ.Установить(ДокументСсылка);
		Попытка
			НаборЗаписей.Записать();
		Исключение
		КонецПопытки;
		
		//rarus agar 12.03.2021 17428 ++
		Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.Scan_ЗаявкаПеревозчику") Тогда
			Для Каждого ТекСтрока Из ДокументСсылка.СоставЗаявки Цикл
				Если ЗначениеЗаполнено(ТекСтрока.ДатаДоставкиФакт)
					И ЗначениеЗаполнено(ДокументСсылка.МестоДоставки)
					И Не ДокументСсылка.МестоДоставки.Маршрут
					И ЗначениеЗаполнено(ДокументСсылка.МестоДоставки.Контрагент)
					И ДокументСсылка.МестоДоставки.Контрагент.Кузовостроитель
					И ДокументСсылка.МестоДоставки.Контрагент.Резидент // rarus agar 25.05.2021 17749 +-
					И ПустаяСтрока(ДокументСсылка.МестоДоставки.БуквенныйКод)
					Тогда
					ТекЗаказНаЗавод = РегистрыСведений.Scan_ВзаимосвязьИзделийИЗаказов.ПолучитьЗаказПоИзделию(ТекСтрока.Изделие);
					Если ЗначениеЗаполнено(ТекЗаказНаЗавод) Тогда
						ОбъектКлючевойДаты = ПредопределенноеЗначение("Перечисление.Scan_ОбъектыКлючевыхДат.ЗаказНаЗавод");
						ADDLBB = РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЧтениеЗначенияРегистраСведения(ТекЗаказНаЗавод, ОбъектКлючевойДаты, ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты.ADDLBB"));
						Если ЗначениеЗаполнено(ADDLBB) Тогда
							РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЗаписьЗначенияРегистраСведения(ТекЗаказНаЗавод, 
							ПредопределенноеЗначение("Перечисление.Scan_ОбъектыКлючевыхДат.ЗаказНаЗавод"), Дата(1,1,1), 
							ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты.ADDLBB"));
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.Scan_ПеремещениеИзделий") Тогда 
			Для Каждого ТекСтрока Из ДокументСсылка.ИзделияДляПеремещения Цикл
				Если ЗначениеЗаполнено(ТекСтрока.ДатаДоставки)
					И ЗначениеЗаполнено(ДокументСсылка.МестоДоставки)
					И Не ДокументСсылка.МестоДоставки.Маршрут
					И ЗначениеЗаполнено(ДокументСсылка.МестоДоставки.Контрагент)
					И ДокументСсылка.МестоДоставки.Контрагент.Кузовостроитель
					И ДокументСсылка.МестоДоставки.Контрагент.Резидент // rarus agar 25.05.2021 17749 +-
					И ПустаяСтрока(ДокументСсылка.МестоДоставки.БуквенныйКод)
					Тогда
					ТекЗаказНаЗавод = РегистрыСведений.Scan_ВзаимосвязьИзделийИЗаказов.ПолучитьЗаказПоИзделию(ТекСтрока.Изделие);
					Если ЗначениеЗаполнено(ТекЗаказНаЗавод) Тогда
						ОбъектКлючевойДаты = ПредопределенноеЗначение("Перечисление.Scan_ОбъектыКлючевыхДат.ЗаказНаЗавод");
						ADDLBB = РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЧтениеЗначенияРегистраСведения(ТекЗаказНаЗавод, ОбъектКлючевойДаты, ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты.ADDLBB"));
						Если ЗначениеЗаполнено(ADDLBB) Тогда
							РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЗаписьЗначенияРегистраСведения(ТекЗаказНаЗавод, 
							ПредопределенноеЗначение("Перечисление.Scan_ОбъектыКлючевыхДат.ЗаказНаЗавод"), Дата(1,1,1), 
							ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты.ADDLBB"));
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		//rarus agar 12.03.2021 17428 --
	Иначе
		//Есть движения документа
		Для Каждого ТекСтрока Из ТабЗначенийМестонахождениеИзделий Цикл
			// rarus tenkam 22.07.2019 mantis 14427 +++
			//ТекПродукт = РегистрыСведений.Scan_ВзаимосвязьИзделийПродуктовИЗаказов.ПолучитьПродуктПоИзделию(ТекСтрока.Изделие);
			//Если Не ЗначениеЗаполнено(ТекПродукт) Тогда
			//	Продолжить;
			//КонецЕсли;
			// rarus tenkam 22.07.2019 mantis 14427 ---
			//rarus bonmak 05.10.2020 16592 ++
			//Если (ТекСтрока.МестоХранения.ТипСклада = Перечисления.Scan_ТипыСклада.Хранение ИЛИ
			//	ТекСтрока.МестоХранения.ТипСклада = Перечисления.Scan_ТипыСклада.Производство ИЛИ
			//	ТекСтрока.МестоХранения.Код = "000000253") И
			//	НЕ ТекСтрока.МестоХранения.СкладПроизводителя Тогда
			Если ТекСтрока.МестоХранения.ФормироватьЧекЛисты Тогда
			//rarus bonmak 05.10.2020 16592 --
				
				Если ТекСтрока.ВидДвижения = ВидДвиженияНакопления.Расход Тогда
					// rarus tenkam 22.07.2019 mantis 14427 +++
					//РегистрыСведений.Scan_МатрицаХраненияИзделий.ЗаписьДанныхВРегистр(ТекПродукт, ТекСтрока.МестоХранения, Перечисления.Scan_КонтрольныеДатыХраненияИзделий.ДатаСнятияСХранения, ТекСтрока.ДатаПрихода, ТекСтрока.Период, ТекСтрока.Регистратор);
					РегистрыСведений.Scan_МатрицаХраненияИзделий.ЗаписьДанныхВРегистр(ТекСтрока.Изделие, ТекСтрока.МестоХранения, Перечисления.Scan_КонтрольныеДатыХраненияИзделий.ДатаСнятияСХранения, ТекСтрока.ДатаПрихода, ТекСтрока.Период, ТекСтрока.Регистратор);
					// rarus tenkam 22.07.2019 mantis 14427 ---
				ИначеЕсли ТекСтрока.ВидДвижения = ВидДвиженияНакопления.Приход Тогда
					// rarus tenkam 22.07.2019 mantis 14427 +++
					//РегистрыСведений.Scan_МатрицаХраненияИзделий.ЗаписьДанныхВРегистр(ТекПродукт, ТекСтрока.МестоХранения, Перечисления.Scan_КонтрольныеДатыХраненияИзделий.ДатаПостановкиНаХранение, ТекСтрока.ДатаПрихода, ТекСтрока.Период, ТекСтрока.Регистратор);
					РегистрыСведений.Scan_МатрицаХраненияИзделий.ЗаписьДанныхВРегистр(ТекСтрока.Изделие, ТекСтрока.МестоХранения, Перечисления.Scan_КонтрольныеДатыХраненияИзделий.ДатаПостановкиНаХранение, ТекСтрока.ДатаПрихода, ТекСтрока.Период, ТекСтрока.Регистратор);
					// rarus tenkam 22.07.2019 mantis 14427 ---	
				КонецЕсли;
			КонецЕсли;
			//rarus agar 12.03.2021 17428 ++
			Если  ТекСтрока.ВидДвижения = ВидДвиженияНакопления.Приход
				И ЗначениеЗаполнено(ТекСтрока.ДатаПрихода)
				И ЗначениеЗаполнено(ТекСтрока.МестоХранения)
				И Не ТекСтрока.МестоХранения.Маршрут
				И ЗначениеЗаполнено(ТекСтрока.МестоХранения.Контрагент)
				И ТекСтрока.МестоХранения.Контрагент.Кузовостроитель
				И ТекСтрока.МестоХранения.Контрагент.Резидент // rarus agar 25.05.2021 17749 +-
				И ПустаяСтрока(ТекСтрока.МестоХранения.БуквенныйКод)
				И  (ТекСтрока.ХозОперация = ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ПеремещениеИзделий") 
				Или ТекСтрока.ХозОперация = ПредопределенноеЗначение("Справочник.Scan_ХозяйственныеОперации.ЗаявкаПеревозчику"))
				Тогда
				ТекЗаказНаЗавод = РегистрыСведений.Scan_ВзаимосвязьИзделийИЗаказов.ПолучитьЗаказПоИзделию(ТекСтрока.Изделие);
				Если ЗначениеЗаполнено(ТекЗаказНаЗавод) Тогда
					РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЗаписьЗначенияРегистраСведения(ТекЗаказНаЗавод, 
					ПредопределенноеЗначение("Перечисление.Scan_ОбъектыКлючевыхДат.ЗаказНаЗавод"), ТекСтрока.ДатаПрихода, 
					ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты.ADDLBB"));
				КонецЕсли;
			КонецЕсли;
			//rarus agar 12.03.2021 17428 --
		КонецЦикла;
	КонецЕсли;	
	//rarus tenkam 14.11.2017 mantis 9426 --- 	
КонецПроцедуры
//rarus tenkam 05.03.2017 mantis 6897 ---

//rarus tenkam 21.03.2017 mantis 
Процедура ПроверитьКорректностьДвижений(Отказ)	
	ТабЗначенийМестонахождениеИзделий = ЭтотОбъект.Выгрузить();
	ДокументРегистратор = ЭтотОбъект.Отбор.Регистратор.Значение;
	Для Каждого ТекСтрока Из ТабЗначенийМестонахождениеИзделий Цикл
		Если ТекСтрока.ВидДвижения = ВидДвиженияНакопления.Расход Тогда
			Продолжить;
		КонецЕсли;
		//МассивРегистраторов = Новый Массив;
		МассивРегистраторов = РегистрыНакопления.Scan_МестонахождениеИзделий.ПолучитьРегистраторовДвижений(ТекСтрока.Изделие);
		Если МассивРегистраторов.Найти(ДокументРегистратор) <> Неопределено Тогда
			// Это перепроведение - проверять не будем
			Продолжить;
		КонецЕсли;
		КрайняяДатаПрихода = РегистрыНакопления.Scan_МестонахождениеИзделий.ПолучитьКрайнююДатуПрихода(ТекСтрока.Изделие);
		Если КрайняяДатаПрихода = Неопределено Тогда
			//Это первое движение изделия
			Продолжить;
		КонецЕсли;
		Если КрайняяДатаПрихода >= ТекСтрока.ДатаПрихода Тогда
			//Ошибка
			Отказ = Истина;
			// rarus tenkam 31.05.2019 mantis 14476 +++
			//СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось провести документ %4. Дата доставки изделия %1, указанная в документе (%2) меньше, чем крайняя дата доставки (%3)'"), ТекСтрока.Изделие, ТекСтрока.ДатаПрихода, КрайняяДатаПрихода, ДокументРегистратор);
			СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось провести документ %4. Дата доставки изделия %1, указанная в документе (%2) меньше, чем крайняя дата движений (%3)'"), ТекСтрока.Изделие, ТекСтрока.ДатаПрихода, КрайняяДатаПрихода, ДокументРегистратор);
			// rarus tenkam 31.05.2019 mantis 14476 ---
			ЗаписьЖурналаРегистрации("Контроль местонахождения изделия", УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);  
			Сообщить(СообщениеОбОшибке);	
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	ПроверитьКорректностьДвижений(Отказ);
КонецПроцедуры
//rarus tenkam 21.03.2017 mantis 