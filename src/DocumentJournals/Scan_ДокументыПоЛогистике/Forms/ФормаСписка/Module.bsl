//Формирование условного обозначения для форм списка справочников и документов
//
//Параметры:
//Форма - УправляемаяФорма - ФормаСписка, в которой возникло событие
//Отображает цвет строки соответствующего вида
//
&НаСервере
Процедура СформироватьУсловноеОформление()
	
	//Обновление условного оформления строк в ТЧ
	СправочникМенеджер = Справочники.Scan_СтатусыЗаявокНаДействие;
	Scan_УправлениеДиалогомСервер.СформироватьУсловноеОформление(ЭтаФорма, СправочникМенеджер,"СтатусЗаявки");
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//формирование условного оформления строк списка
	СформироватьУсловноеОформление();

КонецПроцедуры

