//формирует список, состоящий из всех реквизитов указанного справочника
//
Функция СформироватьСписокРеквизитов(ИмяСправочника)Экспорт 
	СписокРеквизитов = Новый Массив();
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени("Справочник."+ИмяСправочника);
	Если ОбъектМетаданных <> Неопределено Тогда
		//Для Каждого СтандартныйРеквизит ИЗ ОбъектМетаданных.СтандартныеРеквизиты Цикл
		//	//СписокРеквизитов.Добавить(СтандартныйРеквизит.Имя,СтандартныйРеквизит.Имя);
		//	СписокРеквизитов.Добавить(СтандартныйРеквизит.Имя);
		//КонецЦикла;	
		Для Каждого Реквизит ИЗ ОбъектМетаданных.Реквизиты Цикл
			//СписокРеквизитов.Добавить(Реквизит.Имя,Реквизит.Синоним);
			СписокРеквизитов.Добавить(Реквизит.Имя);
			
		КонецЦикла;	
	КонецЕсли;
	Возврат СписокРеквизитов;
КонецФункции //СформироватьСписокРеквизитов()
