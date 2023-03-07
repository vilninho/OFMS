//rarus tenkam 01.09.2017 mantis 9425 +++
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбъектТекущий = РеквизитФормыВЗначение("Объект");
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Цвет = ОбъектТекущий.Цвет.Получить();	
	Иначе
		// Задаем начальный цвет статусу
		Цвет = Новый Цвет(255,255,255);
		ОбъектТекущий.Цвет = Новый ХранилищеЗначения(Цвет);
	КонецЕсли;       
	ЗаполнитьХарактеристики();
	
	СписокВидовСравнения = Новый СписокЗначений;	
	СписокВидовСравнения.Вставить(0,Перечисления.Scan_ВидСравнения.Больше);
	СписокВидовСравнения.Вставить(0,Перечисления.Scan_ВидСравнения.БольшеИлиРавно);	
	Элементы.ХарактеристикиАКБВидСравненияПравый.СписокВыбора.ДоступныеЗначения = СписокВидовСравнения;	
	СписокВидовСравнения.Вставить(0,Перечисления.Scan_ВидСравнения.Равно);
	Элементы.ХарактеристикиАКБВидСравненияЛевый.СписокВыбора.ДоступныеЗначения = СписокВидовСравнения;
	Scan_СборСтатистики.Scan_ПриОткрытии("Справочники", РеквизитФормыВЗначение("Объект").Метаданные().Синоним);	

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	//сохраняем цвет
	ОбъектТекущий = РеквизитФормыВЗначение("Объект");
	ОбъектТекущий.Цвет = Новый ХранилищеЗначения(Цвет);
	ОбъектТекущий.ОбменДанными.Загрузка = Истина;
	Попытка
		ОбъектТекущий.Записать();
	Исключение
	КонецПопытки;
	//rarus anch 21.09.2017 mantis +++
    ЭтаФорма.Прочитать();
	//rarus anch 21.09.2017 mantis ---

КонецПроцедуры                      

&НаСервере
Процедура ЗаполнитьХарактеристики()
	ТабХарактеристик = Новый ТаблицаЗначений;
	ТабХарактеристик.Колонки.Добавить("Характеристика");
	ТабХарактеристик.Колонки.Добавить("Емкость");

	// Получим все возможные емкости
	МассивЕмкостей = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_ЕмкостиАКБ.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Scan_ЕмкостиАКБ КАК Scan_ЕмкостиАКБ
		|ГДЕ
		|	Scan_ЕмкостиАКБ.ПометкаУдаления = ЛОЖЬ";
	ВсеЕмкости = Запрос.Выполнить().Выгрузить();
	Если ВсеЕмкости.Количество()<> 0 Тогда
		МассивЕмкостей = ВсеЕмкости.ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
	// Получим все возможные характеристики
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_ХарактеристикиАКБ.Ссылка КАК Ссылка
		|ИЗ
		|	Перечисление.Scan_ХарактеристикиАКБ КАК Scan_ХарактеристикиАКБ";
	
	ВсеХарактеристики = Запрос.Выполнить().Выгрузить();
	
	//Получим временную таблицу
	Для Каждого ТекХарактеристика Из ВсеХарактеристики Цикл
		Если ТекХарактеристика.Ссылка = Перечисления.Scan_ХарактеристикиАКБ.ПусковойТок Тогда
			Для Каждого ТекЕмкость Из МассивЕмкостей Цикл
				НоваяСтрока = ТабХарактеристик.Добавить();
				НоваяСтрока.Характеристика = ТекХарактеристика.Ссылка;
				НоваяСтрока.Емкость = ТекЕмкость;
			КонецЦикла;   
		Иначе
			НоваяСтрока = ТабХарактеристик.Добавить();
			НоваяСтрока.Характеристика = ТекХарактеристика.Ссылка;
			НоваяСтрока.Емкость = Справочники.Scan_ЕмкостиАКБ.ПустаяСсылка();	
		КонецЕсли;      			
	КонецЦикла;
	
	//Заполним таблицу характеристик
	Для Каждого ТекСтрока Из ТабХарактеристик Цикл
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("Характеристика", ТекСтрока.Характеристика);
		ПараметрыПоиска.Вставить("Емкость", ТекСтрока.Емкость);
		
		НайденныеСтроки = Объект.ХарактеристикиАКБ.НайтиСтроки(ПараметрыПоиска);
		// Добавим новую строку
		Если НайденныеСтроки.Количество() = 0 Тогда
			НоваяСтрока = Объект.ХарактеристикиАКБ.Добавить();
			НоваяСтрока.Характеристика = ТекСтрока.Характеристика;
			НоваяСтрока.Емкость = ТекСтрока.Емкость;
		КонецЕсли;
	КонецЦикла;   	
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиАКБПриАктивизацииЯчейки(Элемент)
	Если Элемент.ТекущиеДанные.Характеристика = ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.ПусковойТок") Тогда
		Элементы.ХарактеристикиАКБЕмкость.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.ХарактеристикиАКБЕмкость.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.ВидСравненияЛевый = ПредопределенноеЗначение("Перечисление.Scan_ВидСравнения.Равно") Тогда
		Элементы.ХарактеристикиАКБВидСравненияПравый.ТолькоПросмотр = Истина;
		Элементы.ХарактеристикиАКБПраваяГраница.ТолькоПросмотр = Истина;
	Иначе
		Элементы.ХарактеристикиАКБВидСравненияПравый.ТолькоПросмотр = Ложь;
		Элементы.ХарактеристикиАКБПраваяГраница.ТолькоПросмотр = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиАКБВидСравненияЛевыйПриИзменении(Элемент)
	Если Элементы.ХарактеристикиАКБ.ТекущиеДанные.ВидСравненияЛевый = ПредопределенноеЗначение("Перечисление.Scan_ВидСравнения.Равно") Тогда
		Элементы.ХарактеристикиАКБ.ТекущиеДанные.ВидСравненияПравый = ПредопределенноеЗначение("Перечисление.Scan_ВидСравнения.ПустаяСсылка");
		Элементы.ХарактеристикиАКБ.ТекущиеДанные.ПраваяГраница = 0;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Для Каждого ТекСтрока Из Объект.ХарактеристикиАКБ Цикл
		Если ЗначениеЗаполнено(ТекСтрока.ВидСравненияЛевый) И НЕ ЗначениеЗаполнено(ТекСтрока.ЛеваяГраница) Тогда
			ТекСтрока.ВидСравненияЛевый = ПредопределенноеЗначение("Перечисление.Scan_ВидСравнения.ПустаяСсылка");
		КонецЕсли;
		Если ЗначениеЗаполнено(ТекСтрока.ВидСравненияПравый) И НЕ ЗначениеЗаполнено(ТекСтрока.ПраваяГраница) Тогда
			ТекСтрока.ВидСравненияПравый = ПредопределенноеЗначение("Перечисление.Scan_ВидСравнения.ПустаяСсылка");
		КонецЕсли; 	
	КонецЦикла;  	 	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) // Rarus tenkam 11.04.2022 mantis 18433 +++

	Если Объект.Ссылка.Пустая() Тогда
		Scan_СборСтатистики.Scan_ПередЗаписьюСправочника(РеквизитФормыВЗначение("Объект").Метаданные().Синоним, Истина, "Создание нового элемента");
	КонецЕсли;
КонецПроцедуры 	// Rarus tenkam 11.04.2022 mantis 18433 --- 

//rarus tenkam 01.09.2017 mantis 9425 ---