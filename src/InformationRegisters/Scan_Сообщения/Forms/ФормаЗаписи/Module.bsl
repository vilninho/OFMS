//Rarus bonmak 28.07.2022 18726 добавил области

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если параметры.Свойство("Объект") Тогда
		Запись.Объект = Параметры.Объект;
		Запись.Пользователь = ПараметрыСеанса.ТекущийПользователь;
		Запись.Период = ТекущаяДатаСеанса();
	Иначе
		ВызватьИсключение НСтр("ru = 'Добавление сообщений возможно только из заявки.'");//rarus vikhle 30.12.2020 mt 17034
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти