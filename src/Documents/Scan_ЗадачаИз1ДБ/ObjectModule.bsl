
Процедура ОбработкаПроведения(Отказ, Режим) //rarus bonmak 18.05.2020 14375 ++
	// регистр Scan_ИсторияПоступленийИПродажПродуктов
	Движения.Scan_ИсторияПоступленийИПродажПродуктов.Записывать = Истина;
	Для Каждого ТекСтрокаПродукты Из Продукты Цикл
		Движение = Движения.Scan_ИсторияПоступленийИПродажПродуктов.Добавить();
		Движение.Продукт = ТекСтрокаПродукты.Продукт;
		Движение.Задача1БД = Ссылка;
	КонецЦикла;
КонецПроцедуры //rarus bonmak 18.05.2020 14375 --
