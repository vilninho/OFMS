//Rarus bonmak 28.07.2022 18726 добавил области

#Область ОбработчикиСобытийФормы

// rarus tenkam 13.08.2019 mantis 14427 +++
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Запись.Пользователь = ПолучитьТекущегоПользователя();
	Запись.ДатаИзмененияСвязи = ТекущаяДата();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьТекущегоПользователя()
	Возврат Пользователи.АвторизованныйПользователь(); //Rarus bonmak 28.07.2022 18726 АПК ПользователиКлиентСервер.АвторизованныйПользователь()
КонецФункции
// rarus tenkam 13.08.2019 mantis 14427 ---

#КонецОбласти