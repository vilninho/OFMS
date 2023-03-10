
&НаКлиенте
Процедура ПоказыватьУволенныхПриИзменении(Элемент)
	
	Если ПоказыватьУволенных = Истина Тогда
		Список.Отбор.Элементы.Очистить();
		
		НовыйЦвет = Новый Цвет(240,165,165);

		ЭлементОформления = Список.УсловноеОформление.Элементы.Добавить();
		//
		//ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
		//ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
		
		ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ФлагУволен");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;
		ОтборЭлемента.Использование = Истина;
		
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", НовыйЦвет);

		ЭлементОформления.Использование = Истина;

	Иначе
		Список.Отбор.Элементы.Очистить();
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ФлагУволен");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Ложь;
		ЭлементОтбора.Использование = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Список.Отбор.Элементы.Очистить();
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ФлагУволен");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Ложь;
	ЭлементОтбора.Использование = Истина;
	
КонецПроцедуры
