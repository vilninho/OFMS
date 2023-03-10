//rarus tenkam 24.04.2019 mantis 14223 +++

// Модуль формы списка справочника "Заводские статусы заказа на завод (scania)"																									
																									
////////////////////////////////////////////////////////////////////////////////																									
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ																									


// Производит настройку параметров отображения элементов управления диалога в зависимости от значений реквизитов
// объекта.
//
&НаСервере
Процедура УправлениеДиалогомНаСервере()
	Элементы.ФормаГруппаИнтеграция.Видимость = Scan_ПраваИНастройки.Scan_Право("ОбменСПредставительством");
КонецПроцедуры
																									
////////////////////////////////////////////////////////////////////////////////																									
// ОБРАБОТЧИКИ СЛУЖЕБНОГО ПРОГРАММНОГО ИНТЕРФЕЙСА																									
																									
																									
////////////////////////////////////////////////////////////////////////////////																									
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ																									
																									
&НаСервере
Процедура ОбновитьСписокИз1БДНаСервере()
	ИмяМетода = "GetListOfStatuses";
	СообщениеОбОшибке = "";
	Отказ = Ложь;
	СтруктураПараметров = Scan_ВебСервисы.ПолучитьСтруктуруПараметровМетода(ИмяМетода);
	СтруктураПараметров.ВидСтатуса = "СтатусыЗаказовАМ";
	ИмяСобытияЖурналаРегистрации = "Веб-сервис." + ИмяМетода;
	ТекЭлементОтвет = Scan_ВебСервисы.ВызватьМетод(ИмяМетода, СтруктураПараметров, Отказ, ИмяСобытияЖурналаРегистрации);
	Если НЕ Отказ Тогда
		СсылкаПродукта = Scan_ВебСервисыРазборОтветов.РазборОтветаСправочникЗаводскиеСтатусы(ТекЭлементОтвет,Отказ,СообщениеОбОшибке,ИмяСобытияЖурналаРегистрации,ИмяМетода);
	КонецЕсли;
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокИз1БД(Команда)
	ОбновитьСписокИз1БДНаСервере();
КонецПроцедуры
																									
																									
////////////////////////////////////////////////////////////////////////////////																									
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ																									
																									
																									
////////////////////////////////////////////////////////////////////////////////																									
// ОБРАБОТЧИКИ ОСНОВНЫХ СОБЫТИЙ ФОРМЫ																									
																									
// Обработчик события возникающего на сервере при создании формы.																									
//																									
// Параметры:																									
//  Отказ                - Булево - Признак отказа от создания формы.																									
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.																									
//																									
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УправлениеДиалогомНаСервере();
КонецПроцедуры

																									
////////////////////////////////////////////////////////////////////////////////																									
// ОБРАБОТЧИКИ ОСНОВНЫХ СОБЫТИЙ СПИСКА ФОРМЫ																									
																									
////////////////////////////////////////////////////////////////////////////////																									
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ																									

//rarus tenkam 24.04.2019 mantis 14223 ---