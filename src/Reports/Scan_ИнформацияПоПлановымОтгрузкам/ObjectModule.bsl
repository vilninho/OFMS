
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	//rarus vikhle 02.09.2020 16274 +++
	
	//Формирование заголовка отчета в зависимости от заданого периода
	ПараметрЗаголовокОтчета = КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("Заголовок"); 
	Если НЕ ПараметрЗаголовокОтчета = Неопределено Тогда
		ПараметрЗаголовокОтчета.Использование = Истина;
		ПараметрЗаголовокОтчета.Значение = "Информация по плановым отгрузкам(Scania)";
		
		ИсполняемыеНастройки = КомпоновщикНастроек.ПолучитьНастройки(); 
		ПараметрПериод = ИсполняемыеНастройки.ПараметрыДанных.Элементы.Найти("СтандартныйПериод"); 
		Если НЕ ПараметрПериод = Неопределено Тогда
			ДатаНачала = ПараметрПериод.Значение.ДатаНачала;
			ДатаОкончания = ПараметрПериод.Значение.ДатаОкончания;
			Если ДатаНачала <> Дата(1,1,1) И ДатаОкончания <> Дата(1,1,1) И ДатаНачала <> НачалоДня(ДатаОкончания) Тогда
				ПараметрЗаголовокОтчета.Значение = ПараметрЗаголовокОтчета.Значение + " с " + Формат(ДатаНачала,"ДФ=dd.MM.yyyy") + " по " 
													+ Формат(ДатаОкончания,"ДФ=dd.MM.yyyy");  	
			ИначеЕсли ДатаНачала = Дата(1,1,1) И ДатаОкончания <> Дата(1,1,1) Тогда   	
				ПараметрЗаголовокОтчета.Значение = ПараметрЗаголовокОтчета.Значение + " по " + Формат(ДатаОкончания,"ДФ=dd.MM.yyyy");	
			ИначеЕсли ДатаНачала <> Дата(1,1,1) И ДатаОкончания = Дата(1,1,1) Тогда   	
				ПараметрЗаголовокОтчета.Значение = ПараметрЗаголовокОтчета.Значение + " с " + Формат(ДатаНачала,"ДФ=dd.MM.yyyy") 
													+ " по " + Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy");	
			ИначеЕсли ДатаНачала = НачалоДня(ДатаОкончания) И ДатаНачала <> Дата(1,1,1) И ДатаОкончания <> Дата(1,1,1) Тогда 	
				ПараметрЗаголовокОтчета.Значение = ПараметрЗаголовокОтчета.Значение + " на " +  Формат(ДатаНачала,"ДФ=dd.MM.yyyy"); 	
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;
	
	//rarus vikhle 02.09.2020 16274 ---	
КонецПроцедуры
