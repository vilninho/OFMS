//Rarus bonmak 28.07.2022 18726 добавил области

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запись.Пользователь = Пользователи.ТекущийПользователь(); //Rarus bonmak 28.07.2022 18726 АПК ПользователиКлиентСервер.ТекущийПользователь();
КонецПроцедуры

#КонецОбласти