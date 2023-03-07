#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда // rarus tenkam 03.12.2021 АПК +	
#Область Интерфейс
	
// rarus tenkam 24.05.2019 mantis 14224 +++

// Функция записи параметров в регистр сведений
// Параметры
//  ТекСсылка – СправочникСсылка.Scan_ЗаказыНаЗавод – Заказ на завод
//  Значение   – Произвольный – Значение регистра сведений
//  ВидОбъекта – ПеречислениеСсылка.Scan_ДополнительнаяИнформацияПоЗаказамНаЗавод – 
//                 Описание вида значения регистра сведений
// Возвращаемое значение:
//   Булево   – ошибка записи значения
Функция ЗаписьЗначенияРегистраСведения(ТекСсылка, ОбъектКлючевойДаты, ТекЗначение, ВидКлючевойДаты, НаДату = Неопределено, УстановленаДатаПродажи = Ложь, Записывать = Ложь, ГУИДНакладной = Неопределено, НомерНакладной = Неопределено) Экспорт		// Rarus tenkam 13.08.2019 mantis 14427 + (добавлен аргумент УстановленаДатаПродажи) //rarus bonmak 18.05.2020 14375 добавил параметры ГУИД и номер накладной // Rarus tenkam 16.11.2021 mantis 18493 + Значение переименовано в ТекЗначение
	
	Отказ = Ложь;
	Если НЕ ЗначениеЗаполнено(ТекСсылка) Тогда
		Возврат Отказ;
	КонецЕсли;
	
	// Rarus tenkam 16.11.2021 mantis 18493 +++
	Если ТекЗначение = Неопределено Тогда
		Значение = Дата('00010101');
	Иначе
		Значение = ТекЗначение;
	КонецЕсли;
	// Rarus tenkam 16.11.2021 mantis 18493 ---
	
	// rarus tenkam 22.07.2019 mantis 14669 +++
	Если ТипЗнч(ТекСсылка) = Тип("СправочникСсылка.Scan_ЗаказыНаЗавод") И 
		ОбъектКлючевойДаты <> Перечисления.Scan_ОбъектыКлючевыхДат.ЗаказНаЗавод Тогда
		Возврат Отказ;
	КонецЕсли;
	
	Если ТипЗнч(ТекСсылка) = Тип("СправочникСсылка.Scan_Изделия") И 
		ОбъектКлючевойДаты <> Перечисления.Scan_ОбъектыКлючевыхДат.Изделие Тогда
		Возврат Отказ;
	КонецЕсли;
	// rarus tenkam 22.07.2019 mantis 14669 ---
		
	Если НаДату = Неопределено Тогда
		ДатаЗаписи = ТекущаяДата();
	Иначе
		ДатаЗаписи = НаДату;
	КонецЕсли; 
	
	Если НЕ Отказ Тогда
		//Чтение старого значения регистра
		СтруктураОтбора   = Новый Структура("Объект,ОбъектКлючевойДаты,ВидКлючевойДаты", ТекСсылка,ОбъектКлючевойДаты,ВидКлючевойДаты);
		СтруктураСведений = РегистрыСведений.Scan_КлючевыеДатыПроцессов.ПолучитьПоследнее(ДатаЗаписи, СтруктураОтбора);
		ЗначениеСтарое    = СтруктураСведений.Значение;
		Записывать        = Ложь;
		//Введено значение, а старое отсутствует
		Если ЗначениеЗаполнено(Значение) И (ЗначениеСтарое = Дата(1,1,1)) Тогда 
			Записывать = Истина; 
		КонецЕсли; 
		//Значение стерто, а старое значение было введено
		Если НЕ ЗначениеЗаполнено(Значение) И (ЗначениеСтарое <> Дата(1,1,1)) Тогда 
			Записывать = Истина; 
		КонецЕсли; 
		//Введено значение и было введено старое
		Если ЗначениеЗаполнено(Значение) И (ЗначениеСтарое <> Дата(1,1,1)) Тогда
			//Значение изменилось
			Если Значение <> ЗначениеСтарое Тогда 
				Записывать = Истина; 
			КонецЕсли; 
		КонецЕсли; 
		Если Записывать Тогда
			//Значение параметра изменилось
			ЗаписьРегСведений = РегистрыСведений.Scan_КлючевыеДатыПроцессов.СоздатьМенеджерЗаписи();
			ЗаписьРегСведений.Объект	  			= ТекСсылка;
			ЗаписьРегСведений.ОбъектКлючевойДаты	= ОбъектКлючевойДаты;
			ЗаписьРегСведений.ВидКлючевойДаты 		= ВидКлючевойДаты;
			ЗаписьРегСведений.Значение    			= Значение;
			ЗаписьРегСведений.Период     			= ДатаЗаписи;
			ЗаписьРегСведений.Пользователь 			= ПользователиКлиентСервер.АвторизованныйПользователь();
			//rarus bonmak 18.05.2020 14375 ++
			Если ГУИДНакладной <> Неопределено И НомерНакладной <> Неопределено Тогда
				ЗаписьРегСведений.GUIDНакладной1ДБ     	= ГУИДНакладной;
				ЗаписьРегСведений.НомерНакладной1ДБ     = НомерНакладной;
			КонецЕсли;
			//rarus bonmak 18.05.2020 14375 --
			Попытка
				ЗаписьРегСведений.Записать();
				
				// rarus tenkam 12.08.2019 mantis 14427 +++
				Если ВидКлючевойДаты = Перечисления.Scan_КлючевыеДаты.ПродуктВАрхиве Тогда
					// Обработаем признак продукт в архиве
					Если ЗначениеЗаполнено(ТекСсылка.IDExternalSystemProduct) Тогда
						
						ПараметрыФоновогоЗадания = Новый Массив;
						ПараметрыФоновогоЗадания.Добавить(ТекСсылка.IDExternalSystemProduct);
												
						Если ЗначениеСтарое = Дата(1,1,1) И Значение <> Дата(1,1,1) Тогда
							//Поместили в архив - установим TLMS = false
							ПараметрыФоновогоЗадания.Добавить(Ложь);
							ФоновыеЗадания.Выполнить("Scan_ВспомогательныеФункцииСервер.УстановитьПризнакTLMSВ1БД", ПараметрыФоновогоЗадания, Новый УникальныйИдентификатор, "Отправка отмены признака TLMS в 1БД");	
						ИначеЕсли ЗначениеСтарое <> Дата(1,1,1) И Значение = Дата(1,1,1) Тогда
							// Вернули из архива - установим TLMS = true
							ПараметрыФоновогоЗадания.Добавить(Истина);
							ФоновыеЗадания.Выполнить("Scan_ВспомогательныеФункцииСервер.УстановитьПризнакTLMSВ1БД", ПараметрыФоновогоЗадания, Новый УникальныйИдентификатор, "Установка признака TLMS = true в 1БД");		
						КонецЕсли;	// просто при смене даты ничего не делаем
					КонецЕсли;
					
				ИначеЕсли ВидКлючевойДаты = Перечисления.Scan_КлючевыеДаты.ДатаПродажиИзделия Тогда
					
					Если ЗначениеСтарое = Дата(1,1,1) И Значение <> Дата(1,1,1) Тогда
						// Установлена дата продажи изделия
						
						ИзделиеСсылка = РегистрыСведений.Scan_ВзаимосвязьИзделийИЗаказов.ПолучитьИзделиеПоЗаказу(ТекСсылка);
						
						// Установить дату передачи дилеру
						Scan_ВспомогательныеФункцииСервер.УстановитьДатуПередачиДилеру(ИзделиеСсылка);
						
						// Проверим, нужно ли исполнить заявки на продажу 3-му лицу без передачи ТК
						Scan_ВспомогательныеФункцииСервер.УстановитьИсполнениеЗаявкиНаПокупкуУПоставщикаИПродажуТретьемуЛицу(ИзделиеСсылка);
						Scan_ВспомогательныеФункцииСервер.УстановитьИсполнениеЗаявкиНаСнятиеСХраненияИПродажуТретьимЛицам(ИзделиеСсылка);
						Scan_ВспомогательныеФункцииСервер.УстановитьИсполнениеЗаявкиНаПродажуТретьемуЛицуоСкладаСканияРусь(ИзделиеСсылка);
						Scan_ВспомогательныеФункцииСервер.УстановитьИсполнениеЗаявокПродажиСПередачейТК(ИзделиеСсылка);		
						
						// Запишем появление даты продажи в регистр "Матрица хранения изделий"
						Если ЗначениеЗаполнено(ИзделиеСсылка) Тогда 			
							РегистрыСведений.Scan_МатрицаХраненияИзделий.ЗаписьДанныхВРегистр(ИзделиеСсылка, , Перечисления.Scan_КонтрольныеДатыХраненияИзделий.ДатаПродажиИзделия, Значение, , );
						КонецЕсли;
						
						
				
						
						
						//rarus BProg_Dekin 19.05.2020 mantis 0015999 ++ Статус заказа больше не используется
						//// Установим статус заказа
						//Если ЗначениеЗаполнено(ТекСсылка) Тогда
						//	//rarus bonmak 15.08.2019 14576 ++
						//	//Справочники.Scan_ЗаказыНаЗавод.УстановитьСтатусЗаказаНаЗавод(ТекСсылка, Перечисления.Scan_СтатусыЗаказовНаЗавод.SOLD);
						//	ОбъектЗаказНаЗавод = ТекСсылка.ПолучитьОбъект();
						//	ОбъектЗаказНаЗавод.СтатусЗаказаЛокальный = Справочники.Scan_ЛокальныеСтатусыЗаказовНаЗавод.SOLD;
						//	Попытка
						//		ОбъектЗаказНаЗавод.Записать();	
						//	Исключение
						//	КонецПопытки;	
						//	//rarus bonmak 15.08.2019 14576 --
						//КонецЕсли;
						//rarus BProg_Dekin 19.05.2020 mantis 0015999 --
						
						//rarus ozhnik 15888 04.09.2020 + 
						Справочники.Scan_СоглашенияОПоставке.УстановитьИсполнениеПоПродукту(ИзделиеСсылка, Значение, ВидКлючевойДаты); //rarus vikhle 22.03.2021 mt 17324
						//rarus ozhnik 15888 04.09.2020 -
						
						//rarus agar 24.06.2020 mantis 16055 ++
						Документы.Scan_ЗаявкаНаОтгрузку.УстановитьИсполнениеПоПродукту(ИзделиеСсылка, Значение, ВидКлючевойДаты); //rarus vikhle 22.03.2021 mt 17324
						//rarus agar 24.06.2020 mantis 16055 +-
						
						УстановленаДатаПродажи = Истина;
						
						Справочники.Scan_Изделия.ОбновитьКрайнююДатуУстраненияНедостатковИзделия(ИзделиеСсылка, Значение);	// rarus tenkam 03.02.2021 пересчет даты крайнего устранения недостатков при появлении даты продажи
					КонецЕсли;  		
				// rarus tenkam 16.04.2020 mantis 15797 +++
				ИначеЕсли ВидКлючевойДаты = Перечисления.Scan_КлючевыеДаты.FinishDate Тогда
					Если ЗначениеСтарое = Дата(1,1,1) И Значение <> Дата(1,1,1) Тогда
						// Возможно нужно создать поступление на склад (появилась Finish date)
						ТекИзделие = РегистрыСведений.Scan_ВзаимосвязьИзделийИЗаказов.ПолучитьИзделиеПоЗаказу(ТекСсылка);
						Если ЗначениеЗаполнено(ТекИзделие) Тогда
							Если НЕ Справочники.Scan_ЗаказыНаЗавод.ПоступлениеУжеЕсть(ТекИзделие, Значение) Тогда
								Документы.Scan_ДвижениеИзделий.СформироватьПоступлениеНаСклад(ТекИзделие, Значение);								
							КонецЕсли;				
						КонецЕсли;
					КонецЕсли;
					// rarus tenkam 16.04.2020 mantis 15797 ---
				//rarus agar 24.06.2020 mantis 16055 ++
				ИначеЕсли ВидКлючевойДаты = Перечисления.Scan_КлючевыеДаты.ДатаПродажиБУДилеру Тогда
					Если ЗначениеСтарое = Дата(1,1,1) И Значение <> Дата(1,1,1) Тогда
						//Документы.Scan_ЗаявкаНаОтгрузку.УстановитьИсполнениеПоПродукту(ТекСсылка, Значение); //rarus bonmak 17.08.2020 14375 перенес ниже
						//rarus bonmak 17.08.2020 14375 ++
						Если Scan_ПраваИНастройки.Scan_Право("ИспользоватьЗадачиСНакладными") Тогда
							//rarus bonmak 03.09.2020 14375 ++
							// Установить дату передачи дилеру
							Scan_ВспомогательныеФункцииСервер.УстановитьДатуПередачиДилеру(ТекСсылка);
							
							Scan_ВспомогательныеФункцииСервер.УстановитьИсполнениеЗаявкиНаПокупкуУПоставщикаИПродажуТретьемуЛицу(ТекСсылка);
							Scan_ВспомогательныеФункцииСервер.УстановитьИсполнениеЗаявкиНаСнятиеСХраненияИПродажуТретьимЛицам(ТекСсылка);
							Scan_ВспомогательныеФункцииСервер.УстановитьИсполнениеЗаявкиНаПродажуТретьемуЛицуоСкладаСканияРусь(ТекСсылка);
							Scan_ВспомогательныеФункцииСервер.УстановитьИсполнениеЗаявокПродажиСПередачейТК(ТекСсылка);		
						    //rarus bonmak 03.09.2020 14375 --
							Документы.Scan_ЗаявкаНаОтгрузку.УстановитьИсполнениеПоПродукту(ТекСсылка, Значение, ВидКлючевойДаты); //rarus vikhle 22.03.2021 mt 17324
							//rarus ozhnik 15888 04.09.2020 + 
							Справочники.Scan_СоглашенияОПоставке.УстановитьИсполнениеПоПродукту(ТекСсылка, Значение, ВидКлючевойДаты); //rarus vikhle 22.03.2021 mt 17324
							//rarus ozhnik 15888 04.09.2020 -
							РегистрыСведений.Scan_МатрицаХраненияИзделий.ЗаписьДанныхВРегистр(ТекСсылка, , Перечисления.Scan_КонтрольныеДатыХраненияИзделий.ДатаПродажиИзделия, Значение, , );
							
							Справочники.Scan_Изделия.ОбновитьКрайнююДатуУстраненияНедостатковИзделия(ИзделиеСсылка, Значение);	// rarus tenkam 03.02.2021 пересчет даты крайнего устранения недостатков при появлении даты продажи
						КонецЕсли;
						//rarus bonmak 17.08.2020 14375 --	
					КонецЕсли;
				//rarus agar 24.06.2020 mantis 16055 ++
				ИначеЕсли ВидКлючевойДаты = Перечисления.Scan_КлючевыеДаты.ДатаПродажиКлиенту 
				ИЛИ ВидКлючевойДаты = Перечисления.Scan_КлючевыеДаты.ДатаПродажиБУКлиенту Тогда //rarus bonmak 03.11.2020 14375 ++
					
					Если ЗначениеСтарое = Дата(1,1,1) И Значение <> Дата(1,1,1) Тогда
						ПрямаяПродажа = Scan_ВспомогательныеФункцииСервер.ПолучитьВидПродажи(ТекСсылка);						
						Если ПрямаяПродажа Тогда
							// Проверим, нужно ли исполнить заявки на продажу 3-му лицу
							//Прямая продажа - продажа конечному клиенту без участия дилера
							
							Если Тип("СправочникСсылка.Scan_Изделия") = ТипЗнч(ТекСсылка) Тогда
								ИзделиеСсылка = ТекСсылка;
							Иначе
								ИзделиеСсылка = РегистрыСведений.Scan_ВзаимосвязьИзделийИЗаказов.ПолучитьИзделиеПоЗаказу(ТекСсылка);
							КонецЕсли;
							Scan_ВспомогательныеФункцииСервер.УстановитьДатуПередачиДилеру(ИзделиеСсылка);
							Scan_ВспомогательныеФункцииСервер.УстановитьИсполнениеЗаявкиНаПокупкуУПоставщикаИПродажуТретьемуЛицу(ИзделиеСсылка, ПрямаяПродажа);
							Scan_ВспомогательныеФункцииСервер.УстановитьИсполнениеЗаявкиНаСнятиеСХраненияИПродажуТретьимЛицам(ИзделиеСсылка, ПрямаяПродажа);
							Scan_ВспомогательныеФункцииСервер.УстановитьИсполнениеЗаявкиНаПродажуТретьемуЛицуоСкладаСканияРусь(ИзделиеСсылка, ПрямаяПродажа);
							Scan_ВспомогательныеФункцииСервер.УстановитьИсполнениеЗаявокПродажиСПередачейТК(ИзделиеСсылка, ПрямаяПродажа);		
							
							// Запишем появление даты продажи в регистр "Матрица хранения изделий"
							Если ЗначениеЗаполнено(ИзделиеСсылка) Тогда 			
								РегистрыСведений.Scan_МатрицаХраненияИзделий.ЗаписьДанныхВРегистр(ИзделиеСсылка, , Перечисления.Scan_КонтрольныеДатыХраненияИзделий.ДатаПродажиИзделия, Значение, , );
							КонецЕсли;
							
							//rarus vikhle 10.03.2021 mt 17324 +++	
							Справочники.Scan_СоглашенияОПоставке.УстановитьИсполнениеПоПродукту(ИзделиеСсылка, Значение, ВидКлючевойДаты); //rarus vikhle 22.03.2021 mt 17324
							Документы.Scan_ЗаявкаНаОтгрузку.УстановитьИсполнениеПоПродукту(ИзделиеСсылка, Значение, ВидКлючевойДаты); //rarus vikhle 22.03.2021 mt 17324						
						    //rarus vikhle 10.03.2021 mt 17324 ---
						КонецЕсли;
						//Rarus bonmak 04.02.2022 18590 ++
						РегистрыСведений.Scan_КлючевыеДатыПроцессов.ЗаписьЗначенияРегистраСведения(ИзделиеСсылка, 
										Перечисления.Scan_ОбъектыКлючевыхДат.Изделие, Дата('00010101'),
										Перечисления.Scan_КлючевыеДаты.ВнутреннийРезервДилера);
						//Rarus bonmak 04.02.2022 18590 --
					КонецЕсли;
				//rarus bonmak 03.11.2020 14375 --
				// rarus tenkam 27.04.2021 mantis 17659 +++
				ИначеЕсли ВидКлючевойДаты = Перечисления.Scan_КлючевыеДаты.DD ИЛИ
					ВидКлючевойДаты = Перечисления.Scan_КлючевыеДаты.DD2 ИЛИ
					ВидКлючевойДаты = Перечисления.Scan_КлючевыеДаты.DDS Тогда
					
					ИзделиеСсылка = РегистрыСведений.Scan_ВзаимосвязьИзделийИЗаказов.ПолучитьИзделиеПоЗаказу(ТекСсылка);
					//Запишем в регистр
					РегистрыСведений.Scan_Обмен1БДОчередьПоОтправкеРеквизитов.ЗаписьЗначенияРегистраСведения(ИзделиеСсылка, Справочники.Scan_ВидыЗапроса.SetAdditionalProperty, Строка(ВидКлючевойДаты), Значение); //rarus bonmak 21.08.2020 16210 изменено с перечисления на справочник 	
					
					// rarus tenkam 27.04.2021 mantis 17659 ---
				КонецЕсли;
				// rarus tenkam 12.08.2019 mantis 14427 ---
			Исключение
				Сообщить(НСтр("ru = 'Ошибка записи ключевой даты в регистр сведений'"));
				Отказ = Истина;
			КонецПопытки; 
		КонецЕсли;
		//rarus pechek 20.04.2020 mantis 15943 +++
		Если Не Отказ Тогда
			Если Scan_ПраваИНастройки.Scan_Право("ЗаполнятьРегистрСводнаяИнформацияПоПродукту") Тогда
				ЗаказНаЗавод = Неопределено;
				Изделие = Неопределено;
				Если ТипЗнч(ТекСсылка) = Тип("СправочникСсылка.Scan_Изделия") Тогда
					Изделие = ТекСсылка;
					ЗаказНаЗавод = Изделие.ЗаказНаЗавод;	// rarus tenkam 28.08.2020 mantis 16468 +
				Иначе
					ЗаказНаЗавод = ТекСсылка;
				КонецЕсли;
				РегистрыСведений.Scan_СводнаяИнформацияПоПродукту.ЗаписьЗначенияРегистраСводнаяИнформацияПоПродукту(Изделие,ЗаказНаЗавод,ВидКлючевойДаты,Значение)
			КонецЕсли;
		КонецЕсли;
		//rarus pechek 20.04.2020 mantis 15943 --- 		
	КонецЕсли; 
		
	Возврат Отказ;
КонецФункции // ЗаписьЗначенияРегистраСведения()

// Функция чтения параметров в регистр сведений
// Параметры
//  ТекСсылка – СправочникСсылка.Scan_ЗаказыНаЗавод – Заказ на завод
//  ВидОбъекта – ПеречислениеСсылка.Scan_ДополнительнаяИнформацияПоЗаказамНаЗавод – 
//                 Описание вида значения регистра сведений
// Возвращаемое значение:
//   Булево   – ошибка записи значения
Функция ЧтениеЗначенияРегистраСведения(ТекСсылка, ОбъектКлючевойДаты, ВидКлючевойДаты, НаДату = Неопределено) Экспорт
	Если НЕ ЗначениеЗаполнено(ТекСсылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НаДату = Неопределено Тогда
		ДатаЗаписи = Неопределено;
	Иначе
		//ДатаЗаписи = НачалоДня(НаДату);
		ДатаЗаписи = НаДату;
	КонецЕсли;
	СтруктураОтбора   = Новый Структура("Объект, ОбъектКлючевойДаты, ВидКлючевойДаты", ТекСсылка, ОбъектКлючевойДаты, ВидКлючевойДаты);
	СтруктураСведений = РегистрыСведений.Scan_КлючевыеДатыПроцессов.ПолучитьПоследнее(ДатаЗаписи, СтруктураОтбора);
	Возврат СтруктураСведений.Значение;
КонецФункции

// rarus tenkam 24.05.2019 mantis 14224 ---

// rarus BProg_Gladkov 19.11.2019 0014452 ++ Ключевые даты перенесены в регистр. Добавлен инетерфейс для работы с ключевыми датами объекта.

// Функция - Ключевые даты объектов
//
// Параметры:
//  Объекты	 - Массив	- Массив ссылок на объекты.
//  Период	 - Дата 	- Дата на которую необходимо прочитать данные. Если НЕ указано - считываются текущие значения.
// 
// Возвращаемое значение:
// Соответсвие - Ключ содержит ссылку на объект, а значение - структуру в которой находятся ключевые даты.
//
Функция КлючевыеДатыОбъектов(Объекты, Период = Неопределено) Экспорт
	КлючевыеДатыОбъектов = Новый Соответствие;
	
	Выборка = ВыборкаКлючевыхДатОбъекта(Объекты, Период);
	
	Для Каждого Объект из Объекты цикл
		КлючевыеДатыОбъекта = Новый_КлючевыеДатыОбъекта(Объект);
		
		Выборка.Сбросить();
		Отбор = Новый Структура("Объект", Объект);
		
		Пока Выборка.НайтиСледующий(Отбор) Цикл
		ИмяВидаКлючевойДаты = XMLСтрока(Выборка.ВидКлючевойДаты);
			Если КлючевыеДатыОбъекта.Свойство(ИмяВидаКлючевойДаты) тогда
				КлючевыеДатыОбъекта[ИмяВидаКлючевойДаты] = Выборка.Значение;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ ЗначениеЗаполнено(КлючевыеДатыОбъекта) тогда
			КлючевыеДатыОбъекта = Новый_КлючевыеДатыОбъекта(Объект);
		КонецЕсли;
		
		КлючевыеДатыОбъектов.Вставить(КлючевыеДатыОбъекта);
	КонецЦикла;
	
	Возврат КлючевыеДатыОбъектов;
КонецФункции

// Функция - Ключевые даты объекта
//
// Параметры:
//  Объект	 - Ссылка - Ссылка на объект.
//  Период	 - Дата 	- Дата на которую необходимо прочитать данные. Если НЕ указано - считываются текущие значения.
// 
// Возвращаемое значение:
// Структура - Содержит ключевые даты.
//
Функция КлючевыеДатыОбъекта(Объект, Период = Неопределено) Экспорт
	КлючевыеДатыОбъекта = Новый_КлючевыеДатыОбъекта(Объект);
	Если НЕ ЗначениеЗаполнено(Объект) тогда
		Возврат КлючевыеДатыОбъекта;
	КонецЕсли;
	
	Выборка = ВыборкаКлючевыхДатОбъекта(Объект, Период);
	Пока Выборка.Следующий() Цикл
		ИмяВидаКлючевойДаты = XMLСтрока(Выборка.ВидКлючевойДаты);
		Если КлючевыеДатыОбъекта.Свойство(ИмяВидаКлючевойДаты) тогда
			КлючевыеДатыОбъекта[ИмяВидаКлючевойДаты] = Выборка.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат КлючевыеДатыОбъекта;
КонецФункции

Функция КлючеваяДата(Объект, ВидКлючевойДаты, Период = Неопределено) Экспорт
	ВидКлючевойДатыСсыдка = ВидКлючевойДатыСсылка(ВидКлючевойДаты);
	
	КлючеваяДата = ЧтениеЗначенияРегистраСведения(Объект, ОбъектКлючевойДаты(Объект), ВидКлючевойДатыСсыдка, Период);
	Если НЕ ЗначениеЗаполнено(КлючеваяДата) тогда
		КлючеваяДата = Дата(1,1,1);
	КонецЕсли;
	
	Возврат КлючеваяДата;
КонецФункции

// Процедура - Записать ключевые даты объекта
//	Записывает измененные ключевые даты.
//
// Параметры:
//  Объект	 		- Ссылка 	- Ссылка на объект.
//  КлючевыеДаты 	- Структура	- содерит ключевые даты.
//  Период	 		- Дата 		- Дата на которую необходимо прочитать данные. Если НЕ указано - считываются текущие значения.
//  Отказ	 		- Булево 	- Возвращает Отказ, если запись НЕ выполнена.
//
Процедура ЗаписатьКлючевыеДатыОбъекта(Объект, КлючевыеДаты, Период = Неопределено, Отказ = Ложь) Экспорт
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	ОбъектКлючевойДаты = ОбъектКлючевойДаты(Объект);
	
	Для каждого Элемент Из КлючевыеДаты Цикл
		ВидКлючевойДаты = ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты." + Элемент.Ключ);
		
		Отказ = ЗаписьЗначенияРегистраСведения(Объект, ОбъектКлючевойДаты, Элемент.Значение, ВидКлючевойДаты, Период);
		Если Отказ тогда
			Возврат;
		КонецЕсли;
	КонецЦикла; 
КонецПроцедуры

// Процедура - Записать ключевую дату объекта
//	Записывает измененные ключевые даты.
//
// Параметры:
//  Объект	 		- Ссылка 	- Ссылка на объект.
//  ВидКлючевойДаты - ПеречисленияСсылка.Scan_КлючевыеДаты - вид ключевой даты.
//  Период	 		- Дата 		- Дата на которую необходимо прочитать данные. Если НЕ указано - считываются текущие значения.
//  Отказ	 		- Булево 	- Возвращает Отказ, если запись НЕ выполнена.
//
Процедура ЗаписатьКлючевуюДатуОбъекта(Объект, ВидКлючевойДаты, Значение, Период = Неопределено, Отказ = Ложь) Экспорт
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	ВидКлючевойДатыСсыдка = ВидКлючевойДатыСсылка(ВидКлючевойДаты);
	
	ОбъектКлючевойДаты = ОбъектКлючевойДаты(Объект);
	Отказ = ЗаписьЗначенияРегистраСведения(Объект, ОбъектКлючевойДаты, Значение, ВидКлючевойДатыСсыдка, Период);
КонецПроцедуры

//rarus BProg_Gladkov 19.11.2019 0014452 -- 

Функция ЧтениеЗначенияРегистраСведенияСПериодом (ПериодОтбора, СтруктураОтбора) Экспорт //rarus bonmak 18.05.2020 14375 ++
	СтруктураОтвета = Новый Структура;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Scan_КлючевыеДатыПроцессовСрезПоследних.Период КАК Период,
	|	Scan_КлючевыеДатыПроцессовСрезПоследних.Значение КАК Значение
	|ИЗ
	|	РегистрСведений.Scan_КлючевыеДатыПроцессов.СрезПоследних(
	|			&Период,
	|			ВидКлючевойДаты = &ВидКлючевойДаты
	|				И ОбъектКлючевойДаты = &ОбъектКлючевойДаты
	|				И Объект = &Объект) КАК Scan_КлючевыеДатыПроцессовСрезПоследних";
	
	Запрос.УстановитьПараметр("ВидКлючевойДаты", СтруктураОтбора.ВидКлючевойДаты);
	Запрос.УстановитьПараметр("Объект", СтруктураОтбора.Объект);
	Запрос.УстановитьПараметр("ОбъектКлючевойДаты", СтруктураОтбора.ОбъектКлючевойДаты);
	Запрос.УстановитьПараметр("Период", ПериодОтбора);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		СтруктураОтвета.Вставить("Значение", Дата(1,1,1));
		СтруктураОтвета.Вставить("Период", ТекущаяДата());
	Иначе
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		СтруктураОтвета.Вставить("Значение", ВыборкаДетальныеЗаписи.Значение);
		СтруктураОтвета.Вставить("Период", ВыборкаДетальныеЗаписи.Период);
	КонецЕсли;
	
	Возврат СтруктураОтвета;
КонецФункции //rarus bonmak 18.05.2020 14375 --

// Процедура - Обработать данные по order intake
//
// Параметры:
//  ТаблицаЗаписей	 - ТаблицаЗначений	 - 
//  Период			 - Дата	 - 
//
//Процедура ОбработатьДанныеДляOrderIntake(ТаблицаЗаписей) Экспорт //rarus vikhle 05.09.2021 mt 18212 +++
Процедура ОбработатьДанныеДляOrderIntake(ТаблицаЗаписей, ВосстановлениеЗаписей = Ложь) Экспорт // rarus agar 11.02.2022 17739
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТЗ.ОбъектКлючевойДаты КАК ОбъектКлючевойДаты,
		|	ВЫРАЗИТЬ(ТЗ.Объект КАК Справочник.Scan_ЗаказыНаЗавод) КАК Объект,
		|	ТЗ.видКлючевойДаты КАК ВидКлючевойДаты,
		|	ТЗ.Значение КАК Значение
		|ПОМЕСТИТЬ ВТ_ТЗ_Типизация
		|ИЗ
		|	&ТаблицаЗаписей КАК ТЗ
		|ГДЕ
		|	(ТЗ.видКлючевойДаты = ЗНАЧЕНИЕ(Перечисление.Scan_КлючевыеДаты.ДатаПродажиИзделия)
		|			ИЛИ ТЗ.видКлючевойДаты = ЗНАЧЕНИЕ(Перечисление.Scan_КлючевыеДаты.ДатаПродажиКлиенту))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		// rarus vikhle 03.09.2021 mt 18212 +++
		|ВЫБРАТЬ
		|	ВТ_ТЗ_Типизация.ОбъектКлючевойДаты КАК ОбъектКлючевойДаты,
		|	ВТ_ТЗ_Типизация.Объект КАК Объект,
		|	ВТ_ТЗ_Типизация.ВидКлючевойДаты КАК ВидКлючевойДаты,
		|	ВТ_ТЗ_Типизация.Значение КАК Значение,
		|	ВЫРАЗИТЬ(Scan_ХарактеристикиЗаказовНаЗаводСрезПоследних.Значение КАК Перечисление.Scan_ТипыЗаказовНаЗавод) КАК ТипЗаказа
		|ПОМЕСТИТЬ ВТ_СТипомЗаказа
		|ИЗ
		|	ВТ_ТЗ_Типизация КАК ВТ_ТЗ_Типизация
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Scan_ХарактеристикиЗаказовНаЗавод.СрезПоследних(
		|				,
		|				Заказ В
		|						(ВЫБРАТЬ
		|							ВТ_ТЗ_Типизация.Объект КАК Объект
		|						ИЗ
		|							ВТ_ТЗ_Типизация КАК ВТ_ТЗ_Типизация)
		|					И Реквизит = ЗНАЧЕНИЕ(Перечисление.Scan_ДополнительнаяИнформацияПоЗаказамНаЗавод.ТипЗаказаНаЗавод)) КАК Scan_ХарактеристикиЗаказовНаЗаводСрезПоследних
		|		ПО ВТ_ТЗ_Типизация.Объект = Scan_ХарактеристикиЗаказовНаЗаводСрезПоследних.Заказ
		|ГДЕ
		|	ВЫРАЗИТЬ(Scan_ХарактеристикиЗаказовНаЗаводСрезПоследних.Значение КАК Перечисление.Scan_ТипыЗаказовНаЗавод) В (&ТипыЗаказаFirm)
		|;
		// rarus vikhle 03.09.2021 mt 18212 ---
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_СТипомЗаказа.ОбъектКлючевойДаты КАК ОбъектКлючевойДаты,
		|	ВЫБОР
		|		КОГДА Scan_СоставСоглашенийОПоставкеСрезПоследних.СоглашениеОПоставке ЕСТЬ NULL
		|				ИЛИ Scan_СоставСоглашенийОПоставкеСрезПоследних.СоглашениеОПоставке = ЗНАЧЕНИЕ(Справочник.Scan_СоглашенияОПоставке.ПустаяСсылка)
		|			ТОГДА ВЫБОР
		|					КОГДА Scan_Изделия.СОП.Компания.ВидДилера = ЗНАЧЕНИЕ(Перечисление.Scan_ВидыДилеров.Собственный)
		|						ТОГДА ВТ_СТипомЗаказа.Объект
		|					ИНАЧЕ NULL
		|				КОНЕЦ
		|		ИНАЧЕ ВЫБОР
		|				КОГДА Scan_СоставСоглашенийОПоставкеСрезПоследних.СоглашениеОПоставке.Дилер.ВидДилера = ЗНАЧЕНИЕ(Перечисление.Scan_ВидыДилеров.Собственный)
		|					ТОГДА ВТ_СТипомЗаказа.Объект
		|				ИНАЧЕ NULL
		|			КОНЕЦ
		|	КОНЕЦ КАК Объект,
		|	ВТ_СТипомЗаказа.ВидКлючевойДаты КАК ВидКлючевойДаты,
		|	ВТ_СТипомЗаказа.Значение КАК Значение
		|ПОМЕСТИТЬ ТаблицаДатаПродажиКлиенту
		|ИЗ
		|	ВТ_СТипомЗаказа КАК ВТ_СТипомЗаказа
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Scan_Изделия КАК Scan_Изделия
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Scan_СоставСоглашенийОПоставке.СрезПоследних(
		|					,
		|					Изделие.ЗаказНаЗавод В
		|						(ВЫБРАТЬ
		|							ВТ_СТипомЗаказа.Объект
		|						ИЗ
		|							ВТ_СТипомЗаказа КАК ВТ_СТипомЗаказа
		|						ГДЕ
		|							ВТ_СТипомЗаказа.ВидКлючевойДаты = ЗНАЧЕНИЕ(Перечисление.Scan_КлючевыеДаты.ДатаПродажиКлиенту))) КАК Scan_СоставСоглашенийОПоставкеСрезПоследних
		|			ПО Scan_Изделия.Ссылка = Scan_СоставСоглашенийОПоставкеСрезПоследних.Изделие
		|		ПО ВТ_СТипомЗаказа.Объект = Scan_Изделия.ЗаказНаЗавод
		|ГДЕ
		|	ВТ_СТипомЗаказа.ВидКлючевойДаты = ЗНАЧЕНИЕ(Перечисление.Scan_КлючевыеДаты.ДатаПродажиКлиенту)
		|	И НЕ Scan_Изделия.БУ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТЗ.ОбъектКлючевойДаты КАК ОбъектКлючевойДаты,
		|	ВТ_ТЗ.Объект КАК Объект,
		|	ВТ_ТЗ.ВидКлючевойДаты КАК ВидКлючевойДаты,
		|	ВТ_ТЗ.Значение КАК Значение
		|ПОМЕСТИТЬ ВТ_ТЗ
		|ИЗ
		|	ВТ_СТипомЗаказа КАК ВТ_ТЗ
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Scan_Изделия КАК Scan_Изделия
		|		ПО ВТ_ТЗ.Объект = Scan_Изделия.ЗаказНаЗавод
		|ГДЕ
		|	(Scan_Изделия.Ссылка ЕСТЬ NULL
		|			ИЛИ Scan_Изделия.БУ = ЛОЖЬ)
		|	И ВТ_ТЗ.ВидКлючевойДаты = ЗНАЧЕНИЕ(Перечисление.Scan_КлючевыеДаты.ДатаПродажиИзделия)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТаблицаДатаПродажиКлиенту.ОбъектКлючевойДаты,
		|	ТаблицаДатаПродажиКлиенту.Объект,
		|	ТаблицаДатаПродажиКлиенту.ВидКлючевойДаты,
		|	ТаблицаДатаПродажиКлиенту.Значение
		|ИЗ
		|	ТаблицаДатаПродажиКлиенту КАК ТаблицаДатаПродажиКлиенту
		|ГДЕ
		|	ТаблицаДатаПродажиКлиенту.Объект ЕСТЬ НЕ NULL 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТЗ.ОбъектКлючевойДаты КАК ОбъектКлючевойДаты,
		|	ВТ_ТЗ.Объект КАК Объект,
		|	ВТ_ТЗ.ВидКлючевойДаты КАК ВидКлючевойДаты,
		|	ВТ_ТЗ.Значение КАК Значение,
		|	Scan_OrderIntakeСрезПоследних.ЗаказНаЗавод КАК ЗаказНаЗавод,
		|	Scan_OrderIntakeСрезПоследних1.ЗаказНаЗавод КАК ЗаказНаЗавод1
		|ИЗ
		|	ВТ_ТЗ КАК ВТ_ТЗ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Scan_OrderIntake.СрезПоследних(, ВидДаты = ЗНАЧЕНИЕ(Перечисление.Scan_ДатыДляФормированияОтчетаOI.ДатаОтгрузки)) КАК Scan_OrderIntakeСрезПоследних
		|		ПО ВТ_ТЗ.Объект = Scan_OrderIntakeСрезПоследних.ЗаказНаЗавод
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Scan_OrderIntake.СрезПоследних(, ВидДаты = ЗНАЧЕНИЕ(Перечисление.Scan_ДатыДляФормированияОтчетаOI.ДатаOrderIntake)) КАК Scan_OrderIntakeСрезПоследних1
		|		ПО ВТ_ТЗ.Объект = Scan_OrderIntakeСрезПоследних1.ЗаказНаЗавод";
		// rarus agar 11.10.2021 17739 ++
		//|ГДЕ
		//|	Scan_OrderIntakeСрезПоследних.ЗаказНаЗавод ЕСТЬ NULL";
		// rarus agar 11.10.2021 17739 --
	
	Запрос.УстановитьПараметр("ТаблицаЗаписей",ТаблицаЗаписей);	
	//rarus vikhle 03.09.2021 mt 18212 +++
	ТипыЗаказаFirm = Перечисления.Scan_ТипыЗаказовНаЗавод.ТипыЗаказаFirm();
	Запрос.УстановитьПараметр("ТипыЗаказаFirm", ТипыЗаказаFirm);
	//rarus vikhle 03.09.2021 mt 18212 ---
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	// rarus agar 15.09.2021 17739 ++
	//АльтернативныйРасчет = Scan_ПраваИНастройки.Scan_Право("ИспользоватьАльтернативныйРасчетДатOrderIntake");
	// rarus agar 15.09.2021 17739 --
	
	Пока Выборка.Следующий() Цикл
		//rarus vikhle 28.09.2021 mt 17739 +++
		//Если АльтернативныйРасчет Тогда
		//	МенеджерЗаписи = РегистрыСведений.Scan_РасчетOrderIntake.СоздатьМенеджерЗаписи();
		//	МенеджерЗаписи.Период       = ТекущаяДатаСеанса();
		//	МенеджерЗаписи.ЗаказНаЗавод = Выборка.Объект;
		//	// rarus agar 11.10.2021 17739 ++
		//	Если Выборка.Значение = Дата(1,1,1) Тогда
		//		МенеджерЗаписи.Событие      = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ОтменаОтгрузки;
		//		МенеджерЗаписи.ДатаСобытия  = ТекущаяДатаСеанса();
		//	Иначе
		//		МенеджерЗаписи.Событие      = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ДатаОтгрузки;
		//		МенеджерЗаписи.ДатаСобытия  = Выборка.Значение;
		//	КонецЕсли;
		//	// rarus agar 11.10.2021 17739 --
		//	МенеджерЗаписи.Пользователь = ПараметрыСеанса.ТекущийПользователь;
		//	УстановитьПривилегированныйРежим(Истина);
		//	МенеджерЗаписи.Записать();
		//	УстановитьПривилегированныйРежим(Ложь);
		//КонецЕсли;
		//rarus vikhle 28.09.2021 mt 17739 ---
		
		Если не значениеЗаполнено(Выборка.ЗаказНаЗавод) Тогда // нет состояния "Дата отгрузки", надо добавить
			//rarus ozhnik 15907 30.03.2020 + 
			Если Выборка.Значение = Дата(1, 1, 1) Тогда
				//пришла пустая дата, необходимо очистить значение
				НаборЗаписейOrderIntake =  РегистрыСведений.Scan_OrderIntake.СоздатьНаборЗаписей();
				НаборЗаписейOrderIntake.Отбор.ЗаказНаЗавод.Установить(Выборка.Объект);
				НаборЗаписейOrderIntake.Отбор.ВидДаты.Установить(Перечисления.Scan_ДатыДляФормированияОтчетаOI.ДатаОтгрузки);
				НаборЗаписейOrderIntake.Записать();        				
			Иначе
				// дата заполнена, выполняется штатный алгоритм
				//rarus ozhnik 15907 30.03.2020 -
				НоваяЗапись =  РегистрыСведений.Scan_OrderIntake.СоздатьМенеджерЗаписи();
				НоваяЗапись.Период = Выборка.Значение;
				НоваяЗапись.ВидДаты = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ДатаОтгрузки;
				НоваяЗапись.ЗаказНаЗавод = Выборка.Объект;
				НоваяЗапись.Прочитать();
				Если Не НоваяЗапись.Выбран() Тогда
					НоваяЗапись.Период = Выборка.Значение;
					НоваяЗапись.ВидДаты = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ДатаОтгрузки;
					НоваяЗапись.ЗаказНаЗавод = Выборка.Объект;
					НоваяЗапись.ИспользоватьВОтчетах = Истина; //rarus vikhle 21.03.2021 mt 17479
					НоваяЗапись.Пользователь = ПараметрыСеанса.ТекущийПользователь;	
					НоваяЗапись.Записать();
				КонецЕсли;
				Если не значениеЗаполнено(Выборка.ЗаказНаЗавод1) Тогда // не было состояния "Order Intake", но есть Дата отгрузки, надо добавить статус Order Intake
					НоваяЗапись =  РегистрыСведений.Scan_OrderIntake.СоздатьМенеджерЗаписи();
					НоваяЗапись.Период = Выборка.Значение;
					НоваяЗапись.ВидДаты = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ДатаOrderIntake;
					НоваяЗапись.ЗаказНаЗавод = Выборка.Объект;
					НоваяЗапись.Прочитать();
					Если Не НоваяЗапись.Выбран() Тогда
						НоваяЗапись.Период = Выборка.Значение;
						НоваяЗапись.ВидДаты = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ДатаOrderIntake;
						НоваяЗапись.ЗаказНаЗавод = Выборка.Объект;
						НоваяЗапись.ИспользоватьВОтчетах = Истина; //rarus vikhle 21.03.2021 mt 17479
						НоваяЗапись.Пользователь = ПараметрыСеанса.ТекущийПользователь;
						НоваяЗапись.Записать();
					КонецЕсли;
				КонецЕсли;
				//rarus vikhle 28.09.2021 mt 17739 +++
				// rarus agar 15.09.2021 17739 ++
				//Если АльтернативныйРасчет Тогда
				//	МенеджерЗаписи = РегистрыСведений.Scan_РасчетOrderIntake.СоздатьМенеджерЗаписи();
				//	МенеджерЗаписи.Период       = ТекущаяДатаСеанса();
				//	МенеджерЗаписи.ЗаказНаЗавод = Выборка.Объект;
				//	МенеджерЗаписи.Событие      = Перечисления.Scan_ДатыДляФормированияОтчетаOI.ДатаОтгрузки;
				//	МенеджерЗаписи.ДатаСобытия  = Выборка.Значение;
				//	МенеджерЗаписи.Пользователь = ПараметрыСеанса.ТекущийПользователь;
				//	УстановитьПривилегированныйРежим(Истина);
				//	МенеджерЗаписи.Записать();
				//	УстановитьПривилегированныйРежим(Ложь);
				//КонецЕсли;
				// rarus agar 15.09.2021 17739 --
				//rarus vikhle 28.09.2021 mt 17739 ---
			КонецЕсли; //rarus ozhnik 15907 30.03.2020 + 
		КонецЕсли;
	КонецЦикла;
	
	// rarus agar 29.12.2021 17739 ++
	АльтернативныйРасчет = Scan_ПраваИНастройки.Scan_Право("ИспользоватьАльтернативныйРасчетДатOrderIntake");
	Если АльтернативныйРасчет И Не ВосстановлениеЗаписей Тогда // rarus agar 11.02.2022 17739
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("П1", ТаблицаЗаписей);
		Запрос.Текст = "ВЫБРАТЬ
		|	ТаблицаЗаписей.ОбъектКлючевойДаты КАК ОбъектКлючевойДаты,
		|	ВЫРАЗИТЬ(ТаблицаЗаписей.Объект КАК Справочник.Scan_ЗаказыНаЗавод) КАК Объект,
		|	ТаблицаЗаписей.ВидКлючевойДаты КАК ВидКлючевойДаты,
		|	ТаблицаЗаписей.Значение КАК Значение
		|ПОМЕСТИТЬ ВТ_ТаблицаЗаписей
		|ИЗ
		|	&П1 КАК ТаблицаЗаписей
		|ГДЕ
		|	(ТаблицаЗаписей.ВидКлючевойДаты = ЗНАЧЕНИЕ(Перечисление.Scan_КлючевыеДаты.ДатаПродажиИзделия)
		|			ИЛИ ТаблицаЗаписей.ВидКлючевойДаты = ЗНАЧЕНИЕ(Перечисление.Scan_КлючевыеДаты.ДатаПродажиКлиенту))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТаблицаЗаписей.ОбъектКлючевойДаты КАК ОбъектКлючевойДаты,
		|	ВЫБОР
		|		КОГДА Scan_СоставСоглашенийОПоставкеСрезПоследних.СоглашениеОПоставке ЕСТЬ NULL
		|				ИЛИ Scan_СоставСоглашенийОПоставкеСрезПоследних.СоглашениеОПоставке = ЗНАЧЕНИЕ(Справочник.Scan_СоглашенияОПоставке.ПустаяСсылка)
		|			ТОГДА ВЫБОР
		|					КОГДА Scan_Изделия.СОП.Компания.ВидДилера = ЗНАЧЕНИЕ(Перечисление.Scan_ВидыДилеров.Собственный)
		|						ТОГДА ВТ_ТаблицаЗаписей.Объект
		|					ИНАЧЕ NULL
		|				КОНЕЦ
		|		ИНАЧЕ ВЫБОР
		|				КОГДА Scan_СоставСоглашенийОПоставкеСрезПоследних.СоглашениеОПоставке.Дилер.ВидДилера = ЗНАЧЕНИЕ(Перечисление.Scan_ВидыДилеров.Собственный)
		|					ТОГДА ВТ_ТаблицаЗаписей.Объект
		|				ИНАЧЕ NULL
		|			КОНЕЦ
		|	КОНЕЦ КАК Объект,
		|	ВТ_ТаблицаЗаписей.ВидКлючевойДаты КАК ВидКлючевойДаты,
		|	ВТ_ТаблицаЗаписей.Значение КАК Значение
		|ПОМЕСТИТЬ ВТ_ДатаПродажиКлиенту
		|ИЗ
		|	ВТ_ТаблицаЗаписей КАК ВТ_ТаблицаЗаписей
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Scan_Изделия КАК Scan_Изделия
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Scan_СоставСоглашенийОПоставке.СрезПоследних(
		|					,
		|					Изделие.ЗаказНаЗавод В
		|						(ВЫБРАТЬ
		|							ВТ_ТаблицаЗаписей.Объект
		|						ИЗ
		|							ВТ_ТаблицаЗаписей КАК ВТ_ТаблицаЗаписей
		|						ГДЕ
		|							ВТ_ТаблицаЗаписей.ВидКлючевойДаты = ЗНАЧЕНИЕ(Перечисление.Scan_КлючевыеДаты.ДатаПродажиКлиенту))) КАК Scan_СоставСоглашенийОПоставкеСрезПоследних
		|			ПО Scan_Изделия.Ссылка = Scan_СоставСоглашенийОПоставкеСрезПоследних.Изделие
		|		ПО ВТ_ТаблицаЗаписей.Объект = Scan_Изделия.ЗаказНаЗавод
		|ГДЕ
		|	ВТ_ТаблицаЗаписей.ВидКлючевойДаты = ЗНАЧЕНИЕ(Перечисление.Scan_КлючевыеДаты.ДатаПродажиКлиенту)
		|	И НЕ Scan_Изделия.БУ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТаблицаЗаписей.ОбъектКлючевойДаты КАК ОбъектКлючевойДаты,
		|	ВТ_ТаблицаЗаписей.Объект КАК Объект,
		|	ВТ_ТаблицаЗаписей.ВидКлючевойДаты КАК ВидКлючевойДаты,
		|	ВТ_ТаблицаЗаписей.Значение КАК Значение
		|ПОМЕСТИТЬ ВТ_ДатыПродажи
		|ИЗ
		|	ВТ_ТаблицаЗаписей КАК ВТ_ТаблицаЗаписей
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Scan_Изделия КАК Scan_Изделия
		|		ПО ВТ_ТаблицаЗаписей.Объект = Scan_Изделия.ЗаказНаЗавод
		|ГДЕ
		|	(Scan_Изделия.Ссылка ЕСТЬ NULL
		|			ИЛИ НЕ Scan_Изделия.БУ)
		|	И ВТ_ТаблицаЗаписей.ВидКлючевойДаты = ЗНАЧЕНИЕ(Перечисление.Scan_КлючевыеДаты.ДатаПродажиИзделия)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТ_ДатаПродажиКлиенту.ОбъектКлючевойДаты,
		|	ВТ_ДатаПродажиКлиенту.Объект,
		|	ВТ_ДатаПродажиКлиенту.ВидКлючевойДаты,
		|	ВТ_ДатаПродажиКлиенту.Значение
		|ИЗ
		|	ВТ_ДатаПродажиКлиенту КАК ВТ_ДатаПродажиКлиенту
		|ГДЕ
		|	ВТ_ДатаПродажиКлиенту.Объект ЕСТЬ НЕ NULL 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ДатыПродажи.ОбъектКлючевойДаты КАК ОбъектКлючевойДаты,
		|	ВТ_ДатыПродажи.Объект КАК Объект,
		|	ВТ_ДатыПродажи.ВидКлючевойДаты КАК ВидКлючевойДаты,
		|	ВТ_ДатыПродажи.Значение КАК ДатаПродажи
		|ИЗ
		|	ВТ_ДатыПродажи КАК ВТ_ДатыПродажи";
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.ДатаПродажи = Дата(1, 1, 1) Тогда
				Scan_OrderIntake.ЗарегистрироватьОтменуОтгрузки(ТекущаяДатаСеанса(), Выборка.Объект);
			Иначе
				Scan_OrderIntake.ЗарегистрироватьОтгрузку(Выборка.ДатаПродажи, Выборка.Объект);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	// rarus agar 29.12.2021 17739 --
	
КонецПроцедуры	//rarus vikhle 05.09.2021 mt 18212 ---

#КонецОбласти 

#Область Служебные

Функция Новый_КлючевыеДатыОбъекта(Объект)
	КлючевыеДатыОбъекта = Новый Структура;
	
	ОбъектКлючевойДаты = ОбъектКлючевойДаты(Объект);
	ВидыКлючевыхДатОбъекта = Перечисления.Scan_КлючевыеДаты.ПолучитьМассивПеречисленийПоОбъекту(ОбъектКлючевойДаты);
	
	Для каждого ВидКлючевойДаты из ВидыКлючевыхДатОбъекта цикл
		ИмяВидаКлючевойДаты = XMLСтрока(ВидКлючевойДаты);
		КлючевыеДатыОбъекта.Вставить(ИмяВидаКлючевойДаты, Дата(1,1,1));
	КонецЦикла;
	
	Возврат КлючевыеДатыОбъекта;
КонецФункции

Функция ВыборкаКлючевыхДатОбъекта(Объекты, Период = Неопределено)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Объекты", Объекты);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_КлючевыеДатыПроцессовСрезПоследних.Объект КАК Объект,
	               |	Scan_КлючевыеДатыПроцессовСрезПоследних.ВидКлючевойДаты КАК ВидКлючевойДаты,
	               |	Scan_КлючевыеДатыПроцессовСрезПоследних.Значение КАК Значение
	               |ИЗ
	               |	РегистрСведений.Scan_КлючевыеДатыПроцессов.СрезПоследних(&Период, Объект В (&Объекты)) КАК Scan_КлючевыеДатыПроцессовСрезПоследних";
	Если ЗначениеЗаполнено(Период) тогда
		Запрос.УстановитьПараметр("Период", Период);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Период", "");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка;
КонецФункции

Функция ОбъектКлючевойДаты(Объект)
	ТипОбъекта = ТипЗнч(Объект);
	
	Если ТипОбъекта = Тип("СправочникСсылка.Scan_ЗаказыНаЗавод") тогда
		ОбъектКлючевойДаты = Перечисления.Scan_ОбъектыКлючевыхДат.ЗаказНаЗавод;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.Scan_Изделия") тогда
		ОбъектКлючевойДаты = Перечисления.Scan_ОбъектыКлючевыхДат.Изделие;
	Иначе
		ВызватьИсключение "Ключевые даты не могут быть установлены для объекта типа " + ТипОбъекта;
	КонецЕсли;
	
	Возврат ОбъектКлючевойДаты;
КонецФункции

Функция ВидКлючевойДатыСсылка(ВидКлючевойДаты)
	Если ТипЗнч(ВидКлючевойДаты) = Тип("Строка") тогда
		ВидКлючевойДатыСсылка = ПредопределенноеЗначение("Перечисление.Scan_КлючевыеДаты." + ВидКлючевойДаты);
	Иначе
		ВидКлючевойДатыСсылка = ВидКлючевойДаты
	КонецЕсли;
	
	Возврат ВидКлючевойДатыСсылка; 
КонецФункции
#КонецОбласти 

#КонецЕсли
