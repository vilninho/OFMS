//rarus tenkam 29.12.2016 mantis 7708 ++
&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	ВыборкаПараметров = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	Для Каждого ТекЭлемент Из ВыборкаПараметров Цикл
		Если ТипЗнч(ТекЭлемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если ТекЭлемент.Параметр = Новый ПараметрКомпоновкиДанных("ТекДата") Тогда
				ТекЭлемент.Значение = ТекущаяДата();	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Scan_СборСтатистики.Scan_ПриОткрытииОтчета(РеквизитФормыВЗначение("Отчет").Метаданные().Синоним); // Rarus tenkam 11.04.2022 mantis 18433 +

КонецПроцедуры
//rarus tenkam 29.12.2016 mantis 7708 --