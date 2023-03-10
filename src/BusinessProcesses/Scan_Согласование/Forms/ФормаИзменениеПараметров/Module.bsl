//Rarus bonmak 28.07.2022 18726 добавил области

#Область ДействияКомандныхПанелейФормы
 
&НаКлиенте
Процедура ОК(Команда)
	Если Модифицированность Тогда 
		ОчиститьСообщения();
		Попытка
			Записать();
			Закрыть(КодВозвратаДиалога.ОК);
		Исключение
			//rarus FominskiyAS 24.04.2019  mantis 14191 +++
			//Сообщить("Не удалось записать бизнес-процесс", СтатусСообщения.Внимание);
			Сообщить(НСтр("ru = 'Не удалось записать бизнес-процесс'; en = 'Could not write the business process'"), СтатусСообщения.Внимание);
			//rarus FominskiyAS 24.04.2019  mantis 14191 ---  
		КонецПопытки;
	Иначе
		Закрыть(КодВозвратаДиалога.ОК);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
 
#Область ОбработчикиСобытийЭлементовФормы 

&НаКлиенте
Процедура ПредметПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.Предмет) И (НЕ ЗначениеЗаполнено(Объект.Наименование) ИЛИ Объект.Наименование = "Согласовать ") Тогда 
		Объект.Наименование = "Согласовать """ + Объект.Предмет + """";
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВажностьПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВариантСогласованияПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("БизнесПроцессИзменен", Объект.Ссылка);
КонецПроцедуры

#КонецОбласти