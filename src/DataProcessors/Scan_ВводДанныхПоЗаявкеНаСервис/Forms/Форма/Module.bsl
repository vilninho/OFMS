
&НаКлиенте
Процедура Отменить(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ТекущаяСтраница = ТекущаяСтраница + 1;
	ПоказатьТекущуюСтраницу();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ТекущаяСтраница = ТекущаяСтраница - 1;
	ПоказатьТекущуюСтраницу();
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СоздатьЗаявкуНаСервис();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИОткрыть(Команда)
	
	Документ = СоздатьЗаявкуНаСервис();
	
	ОткрытьФорму("Документ.Scan_ЗаявкаНаСервисныеРаботы.ФормаОбъекта", Новый Структура("Ключ", Документ));
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция СоздатьЗаявкуНаСервис()

	НовыйДокумент = Документы.Scan_ЗаявкаНаСервисныеРаботы.СоздатьДокумент();
	
	НовыйДокумент.Заполнить(ДокументОснование);
	
	РезультатИзделий = Обработки.Scan_ВводДанныхПоЗаявкеНаСервис.РезультатИзделийПоЗаявке(ДокументОснование,ИзделияИзАРМ);
	
	// Таблица Шаг 1
	Для каждого Строка Из Работы Цикл
		
		Если Не РезультатИзделий.Пустой() Тогда
			
			Выборка = РезультатИзделий.Выбрать();
			
			Пока Выборка.Следующий() Цикл
			
				НоваяСтрока = НовыйДокумент.СоставЗаявки.Добавить();
				НоваяСтрока.Изделие 	= Выборка.Изделие;
				НоваяСтрока.Тахограф 	= Строка.Тахограф;
				НоваяСтрока.Работа 		= Строка.Работа;	
			
			КонецЦикла;
			     			
		Иначе
			
			// Если нет изделий в заявке на действие
			НоваяСтрока = НовыйДокумент.СоставЗаявки.Добавить();
			НоваяСтрока.Работа 	= Строка.Работа;
			НоваяСтрока.Тахограф 	= Строка.Тахограф;
			
		КонецЕсли;
				
	КонецЦикла;
	
	// Таблица Шаг 2
	Для каждого Строка Из РаботыНаИзделиях Цикл
		
		Если ТипЗнч(Строка.СписокЗначений) = Тип("СписокЗначений") Тогда
			
			Для каждого СтрокаИзделия Из Строка.СписокЗначений Цикл
					
			    НоваяСтрока = НовыйДокумент.СоставЗаявки.Добавить();
				НоваяСтрока.Изделие 	= СтрокаИзделия.Значение;
				НоваяСтрока.Тахограф 	= Строка.Тахограф;
				НоваяСтрока.Работа 		= Строка.Работа;
		
			КонецЦикла;	
			
		КонецЕсли;	
				
	КонецЦикла;

	НовыйДокумент.ПлановаяДатаВыполнения = ПлановаяДатаВыполненияРабот;
	
	//rarus tenkam 05.02.2018 mantis 9428 +++ bug
	//НовыйДокумент.ДатаНачалаРабот = ЗаявкаНаДействие.ДатаДоставкиПлановая;
	//НовыйДокумент.МестоПроведенияРабот = ЗаявкаНаДействие.МестоДоставки;
	
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.Scan_ЗаявкаНаДействие") Тогда
			НовыйДокумент.ДатаНачалаРабот = ДокументОснование.ДатаДоставкиПлановая;
			НовыйДокумент.МестоПроведенияРабот = ДокументОснование.МестоДоставки;	
		ИначеЕсли ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.Scan_ЗаявкаПеревозчику") Тогда
			НовыйДокумент.ДатаНачалаРабот = ДокументОснование.ДатаДоставки;
			НовыйДокумент.МестоПроведенияРабот = ДокументОснование.МестоДоставки;
		КонецЕсли;
	ИначеЕсли ИзделияИзАРМ.Количество() <> 0 Тогда
		
		ТекДанные = РегистрыНакопления.Scan_МестонахождениеИзделий.ПолучитьМестонахождениеИДатуПриходаИзделия(ИзделияИзАРМ[0].Изделие, ТекущаяДата());
		Если ТекДанные <> Неопределено Тогда
			НовыйДокумент.МестоПроведенияРабот = ТекДанные.МестоХранения;
		КонецЕсли;
	КонецЕсли;
	
	//rarus tenkam 05.02.2018 mantis 9438 ---
	
	
	Документы.Scan_ЗаявкаНаСервисныеРаботы.ПервоначальноеЗаполнение(НовыйДокумент);
	
	Попытка		//rarus tenkam 12.02.2018 mantis 9428 +
		НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
		
		Сообщение = Новый СообщениеПользователю;
		//rarus FominskiyAS 19.04.2019  mantis 14191 +++
		//Сообщение.Текст = "Создан документ " + НовыйДокумент.Ссылка; 
		Сообщение.Текст = НСтр("ru = 'Создан документ  '; en = 'Create a document '") + НовыйДокумент.Ссылка; 
		//rarus FominskiyAS 19.04.2019  mantis 14191 ---  
		Сообщение.Сообщить();
		
		Возврат НовыйДокумент.Ссылка;
	// rarus tenkam 12.02.2018 mantis 9428 +++
	Исключение
		Сообщение = Новый СообщениеПользователю;
		//rarus FominskiyAS 25.04.2019  mantis 14191 +++
		//Сообщение.Текст = "Не удалось создать документ. Проверьте корректность данных.";
		Сообщение.Текст = НСтр("ru = 'Не удалось создать документ. Проверьте корректность данных.'; en = 'Unable to create a document. Check the correctness of the data.'");
		//rarus FominskiyAS 25.04.2019  mantis 14191 ---  
		Сообщение.Сообщить();	
		Возврат Неопределено;
	КонецПопытки;	
	// rarus tenkam 12.02.2018 mantis 9428 ---
		
	
КонецФункции

&НаКлиенте
Процедура ПоказатьТекущуюСтраницу()
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы["ГруппаШаг" + ТекущаяСтраница];
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ПараметрКоманды) Тогда
	
		ДокументОснование = Параметры.ПараметрКоманды;
		
	Иначе
		Если Параметры.Свойство("Изделия") Тогда //rarus bonmak 12.12.2019 15505 добавил условие
			Если ТипЗнч(Параметры.Изделия) = Тип("Массив") Тогда //rarus bonmak 29.07.2019 14427 переименовал переменные
				
				Для каждого СтрокаИзделия Из Параметры.Изделия Цикл //rarus bonmak 29.07.2019 14427 переименовал переменные
					
					НоваяСтрока = ИзделияИзАРМ.Добавить();	
					НоваяСтрока.Изделие = СтрокаИзделия.Ссылка;
					
					
				КонецЦикла;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	//rarus tenkam 28.11.2017 mantis 9428 +++
	//НоваяСтрока = Работы.Добавить();
	//НоваяСтрока.Работа = Справочники.Scan_ВидыСервисныхРабот.ПредпродажнаяПодготовка;
	//
	//НоваяСтрока = Работы.Добавить();
	//НоваяСтрока.Работа = Справочники.Scan_ВидыСервисныхРабот.УстановкаТахографа;
	//rarus tenkam 28.11.2017 mantis 9428 ---
	Scan_СборСтатистики.Scan_ПриОткрытииОбработки(РеквизитФормыВЗначение("Объект").Метаданные().Синоним); // Rarus tenkam 11.04.2022 mantis 18433 +

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекущаяСтраница = 1;
	ПоказатьТекущуюСтраницу();
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыНаИзделияхИзделиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбратьИзделие(СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыНаИзделияхИзделиеЗавершениеВыбора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт 
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("СписокЗначений") Тогда
	
		Если ТипЗнч(ДополнительныеПараметры) <> Тип("Структура") Тогда
			
			Сообщение = Новый СообщениеПользователю;
			//rarus FominskiyAS 25.04.2019  mantis 14191 +++
			//Сообщение.Текст = "Не смогли определить номер текущей строки!";
			Сообщение.Текст = НСтр("ru = 'Не смогли определить номер текущей строки!'; en = 'Could not determine current line number!'");
			//rarus FominskiyAS 25.04.2019  mantis 14191 ---  
			Сообщение.Сообщить();
			Возврат;
		
		КонецЕсли;		
		
		СтрокаИзделия = РаботыНаИзделиях.Получить(ДополнительныеПараметры.НомерСтроки);
		СтрокаИзделия.СписокЗначений = РезультатЗакрытия;
		СтрокаИзделия.Изделие = ПредставлениеИзделий(СтрокаИзделия.СписокЗначений);
		
	КонецЕсли;		
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредставлениеИзделий(СписокЗначений)

	СтрокаПредставления = "";
	
	Для каждого СтрокаИзделия Из СписокЗначений Цикл
	
		СтрокаПредставления = СтрокаПредставления + СтрокаИзделия.Значение.VIN + ";";	
	
	КонецЦикла;
	
	Возврат СтрокаПредставления;
	
КонецФункции

&НаКлиенте
Процедура РаботыНаИзделияхИзделиеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ВыбратьИзделие(СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзделие(СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	СтрокаИзделия = Элементы.РаботыНаИзделиях.ТекущиеДанные;
	
	ОткрытьФорму("Обработка.Scan_ВводДанныхПоЗаявкеНаСервис.Форма.ФормаВыбораИзделий", 
						Новый Структура("СписокИзделий,ДокументОснование,ИзделияИзАРМ", СтрокаИзделия.СписокЗначений, ДокументОснование,ИзделияИзАРМ), 
						ЭтаФорма, УникальныйИдентификатор, , ,
						Новый ОписаниеОповещения("РаботыНаИзделияхИзделиеЗавершениеВыбора", ЭтаФорма, 
														Новый Структура("НомерСтроки", Элементы.РаботыНаИзделиях.ТекущаяСтрока)));

КонецПроцедуры

&НаКлиенте
Процедура РаботыПриАктивизацииЯчейки(Элемент)

	Элемент.ТекущийЭлемент.ТолькоПросмотр =
		Элемент.ТекущийЭлемент.Имя = "РаботыТахограф"
			И Элемент.ТекущиеДанные.Работа <> ПредопределенноеЗначение("Справочник.Scan_ВидыСервисныхРабот.УстановкаТахографа");	
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыНаИзделияхПриАктивизацииЯчейки(Элемент)
	
	Элемент.ТекущийЭлемент.ТолькоПросмотр =
		Элемент.ТекущийЭлемент.Имя = "РаботыНаИзделияхТахограф"
			И Элемент.ТекущиеДанные.Работа <> ПредопределенноеЗначение("Справочник.Scan_ВидыСервисныхРабот.УстановкаТахографа");
	
КонецПроцедуры

// rarus tenkam 21.03.2018 mantis 9428 +++
&НаКлиенте
Процедура РаботыРаботаПриИзменении(Элемент)
	Если Элементы.Работы.ТекущиеДанные.Работа = ПредопределенноеЗначение("Справочник.Scan_ВидыСервисныхРабот.УстановкаТахографа") Тогда
		Элементы.Работы.ТекущиеДанные.Тахограф = ПредопределенноеЗначение("Справочник.Scan_ВидыТахографов.Штрих");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РаботыНаИзделияхРаботаПриИзменении(Элемент)
	Если Элементы.РаботыНаИзделиях.ТекущиеДанные.Работа = ПредопределенноеЗначение("Справочник.Scan_ВидыСервисныхРабот.УстановкаТахографа") Тогда
		Элементы.РаботыНаИзделиях.ТекущиеДанные.Тахограф = ПредопределенноеЗначение("Справочник.Scan_ВидыТахографов.Штрих");
	КонецЕсли;
КонецПроцедуры     

// rarus tenkam 21.03.2018 mantis 9428 ---
