
&НаКлиенте
Процедура ПрикрепитьЗаказНаряд(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() <> 0 Тогда
		// rarus tenkam 10.04.2019 mantis 14195 +++
		
		//ВыбранныеФайлы = Новый Массив;
		//
		//ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		//ВыборФайла.МножественныйВыбор = Истина;
		//ВыборФайла.Заголовок = НСтр("ru = 'Выбор файла'");
		//ВыборФайла.Фильтр = НСтр("ru = 'Все файлы'") + " (*.*)|*.*";
		//Если ВыборФайла.Выбрать() Тогда
		//	ВыбранныеФайлы = ВыборФайла.ВыбранныеФайлы;
		//КонецЕсли;
		//
		//Если ВыбранныеФайлы.Количество() <> 0 Тогда
		//	ДопПараметры = Новый Структура;
		//	ДопПараметры.Вставить("ИдентификаторФормы", ЭтаФорма.УникальныйИдентификатор);
		//	ДопПараметры.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", Истина);
		//	ДопПараметры.Вставить("ВыбранныеФайлы", ВыбранныеФайлы);
		//	
		//	Для Каждого ТекДокумент Из Элементы.Список.ВыделенныеСтроки Цикл
		//		ДопПараметры.Вставить("ВладелецФайла", ТекДокумент);
		//		ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлыРасширениеПредложено", ПрисоединенныеФайлыСлужебныйКлиент, ДопПараметры);
		//		ФайловыеФункцииСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
		//	КонецЦикла;		
		//КонецЕсли;
		
		РаботаСФайламиКлиент.ДобавитьФайлы(Элементы.Список.ВыделенныеСтроки, ЭтаФорма.УникальныйИдентификатор, , );
	
		// rarus tenkam 10.04.2019 mantis 14195 ---

		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//формирование условного оформления строк списка
	СформироватьУсловноеОформление();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

//Формирование условного обозначения для форм списка справочников и документов
//
//Параметры:
//Форма - УправляемаяФорма - ФормаСписка, в которой возникло событие
//Отображает цвет строки соответствующего вида
//
&НаСервере
Процедура СформироватьУсловноеОформление()
	
	//Обновление условного оформления строк в ТЧ
	СправочникМенеджер = Справочники.Scan_СтатусыЗаявокНаРаботы;
	Scan_УправлениеДиалогомСервер.СформироватьУсловноеОформление(ЭтаФорма, СправочникМенеджер,"Статус");
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаявкаНаСервисныеРаботыАннулирована" Тогда
	
		Элементы.Список.Обновить();	
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АннулироватьДокумент(Команда)
	
	Документ = Элементы.Список.ТекущаяСтрока;
	
	Если ЗначениеЗаполнено(Документ) Тогда
	
		ПоказатьВопрос(Новый ОписаниеОповещения("ПоказатьВопросЗавершение", ЭтотОбъект, Документ), "Вы уверены что требуется аннулирование документа " + Документ + "?", РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт 

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
	
		Ссылка = АннулироватьДокументСервер(ДополнительныеПараметры);
		
		Оповестить("ЗаявкаНаСервисныеРаботыАннулирована", Ссылка);
	
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция АннулироватьДокументСервер(ДополнительныеПараметры)

	Возврат Документы.Scan_ЗаявкаНаСервисныеРаботы.АннулироватьДокумент(ДополнительныеПараметры);	

КонецФункции

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
