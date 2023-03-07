//rarus sergei 09.09.2016 mantis 7167 ++
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтаФорма.АвтоЗаголовок = ЛОЖЬ;
	ЗаявкаНаДействие = Параметры.ЗаявкаНаДействие;
	ЭтаФорма.Заголовок = "Корректировка Заявки на Действие "+ ЗаявкаНаДействие;
	МестоДоставки = Параметры.ЗаявкаНаДействие.МестоДоставки;
	ДатаДоставкиПлановая = Параметры.ЗаявкаНаДействие.ДатаДоставкиПлановая;
	СпособДоставки = Параметры.ЗаявкаНаДействие.СпособДоставки;
	ПриемВВыходныеИПраздничные = Параметры.ЗаявкаНаДействие.ПриемВВыходныеИПраздничные;
	Грузополучатель = Параметры.ЗаявкаНаДействие.Грузополучатель;
	Договор = Параметры.ЗаявкаНаДействие.Договор;
	Для каждого строка Из Параметры.ЗаявкаНаДействие.КонтактныеЛица Цикл
		НоваяСтрока = КонтактныеЛица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,строка);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура МестоДоставкиПриИзменении(Элемент)
	МестоДоставкиПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура МестоДоставкиПриИзмененииНаСервере()
	Если (НЕ ЗначениеЗаполнено(Грузополучатель) ИЛИ Грузополучатель <> МестоДоставки.Контрагент) И
		НЕ МестоДоставки.Пустая() Тогда
		Грузополучатель = МестоДоставки.Контрагент;
		ГрузополучательПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура МестоДоставкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
			
	//Если ЗначениеЗаполнено(Объект.МодельПродукта) Тогда	
		СтандартнаяОбработка = Ложь;
		ЗначениеОтбора = Новый Структура("Маршрут", ЛОЖЬ);
		Если ЗначениеЗаполнено(Грузополучатель) Тогда
			ЗначениеОтбора.Вставить("Контрагент",Грузополучатель);
		КонецЕсли;
		ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
	    Результат = ОткрытьФорму("Справочник.Scan_МестаХранения.ФормаВыбора",ПараметрыФормы,Элементы.МестоДоставки); 
	//КонецЕсли;
	

КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	ОчиститьМестоДоставки();
	ГрузополучательПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОчиститьМестоДоставки()
	МестоДоставки = Справочники.Scan_МестаХранения.ПустаяСсылка();	
КонецПроцедуры


&НаСервере
Процедура ГрузополучательПриИзмененииНаСервере()
	Если ЗначениеЗаполнено(Договор) и Грузополучатель <> Договор.Владелец Тогда 
		
		Договор = Справочники.Scan_ДоговорыВзаиморасчетов.ПустаяСсылка();
		КонтактныеЛица.Очистить();				
	
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	ДоговорПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДоговорПриИзмененииНаСервере()
	//rarus pechek 03.04.2020 mantis 15672 +++
	//Если ЗначениеЗаполнено(Договор) Тогда
	//Для каждого строка Из Договор.КонтактныеЛицаПоДоговору Цикл
	//	МассивНайденныхСтрок = КонтактныеЛица.НайтиСтроки(Новый Структура("КонтактноеЛицо",строка.КонтактноеЛицо));
	//	
	//	Если МассивНайденныхСтрок.Количество()= 0 Тогда
	//		ЗаполнитьКонтактнуюинформацию(строка.КонтактноеЛицо);
	//	КонецЕсли;	
	//КонецЦикла;  					
	//КонецЕсли;
	//rarus pechek 03.04.2020 mantis 15672 ---
	Если ЗначениеЗаполнено(Грузополучатель) и Договор.Пустая() Тогда
		ГрузополучательПриИзмененииНаСервере()	
	КонецЕсли;

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
		
		НоваяСтрока=КонтактныеЛица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,строкаТЗ);
	    
	КонецЦикла; 
	Если НЕ ЗначениеЗаполнено(Грузополучатель) Тогда 
		Грузополучатель = Парам.Владелец;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДоговорНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Грузополучатель) Тогда			
		СтандартнаяОбработка = Ложь;
		ЗначениеОтбора = Новый Структура("Владелец", Грузополучатель);
		ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
	    ПараметрыФормы.Вставить("Грузополучатель", Грузополучатель);			
		Результат = ОткрытьФорму("Справочник.Scan_ДоговорыВзаиморасчетов.ФормаВыбора",ПараметрыФормы,Элементы.Договор); 
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДоговорСоздание(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("Владелец", Грузополучатель);
	ПараметрыСоздания.Вставить("Наименование",Элемент.ТекстРедактирования);  
	ОткрытьФорму("Справочник.Scan_ДоговорыВзаиморасчетов.ФормаОбъекта", ПараметрыСоздания, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура КонтактныеЛицаКонтактноеЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Грузополучатель) Тогда
	
		СтандартнаяОбработка = Ложь;
		ЗначениеОтбора = Новый Структура("Владелец", Грузополучатель);
		ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
	    Результат = ОткрытьФорму("Справочник.Scan_КонтактныеЛица.ФормаВыбора",ПараметрыФормы,Элементы.КонтактныеЛицаКонтактноеЛицо); 
	
	
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура КонтактныеЛицаКонтактноеЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	МассивСтрок=КонтактныеЛица.НайтиСтроки(Новый Структура("КонтактноеЛицо",ВыбранноеЗначение));
	Если МассивСтрок.Количество()> 0 и МассивСтрок[0].НомерСтроки <>  ТекущийЭлемент.ТекущаяСтрока+1 Тогда
		СтандартнаяОбработка=Ложь;              
		Возврат; 
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	ИндексТекущейСтроки = КонтактныеЛица.Индекс(Элементы.КонтактныеЛица.ТекущиеДанные);
	КонтактныеЛица.Удалить(ИндексТекущейСтроки);  
	ЗаполнитьКонтактнуюинформацию(ВыбранноеЗначение);

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ЗаявкаНаДействие",ЗаявкаНаДействие);
	ПараметрыЗакрытия.Вставить("МестоДоставки",МестоДоставки);
	ПараметрыЗакрытия.Вставить("ДатаДоставкиПлановая",ДатаДоставкиПлановая);
	ПараметрыЗакрытия.Вставить("СпособДоставки",СпособДоставки);
	ПараметрыЗакрытия.Вставить("ПриемВВыходныеИПраздничные",ПриемВВыходныеИПраздничные);
	ПараметрыЗакрытия.Вставить("Грузополучатель",Грузополучатель);
	ПараметрыЗакрытия.Вставить("Договор",Договор);
	ПараметрыЗакрытия.Вставить("КонтактныеЛица",КонтактныеЛица);
                        
	Закрыть(ПараметрыЗакрытия);

КонецПроцедуры
//rarus sergei 09.09.2016 mantis 7167 --