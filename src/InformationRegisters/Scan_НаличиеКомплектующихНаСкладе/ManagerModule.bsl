//rarus tenkam 11.12.2017 mantis 11952 +++
Функция ПолучитьКоличество(Комплектующие) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(Scan_НаличиеКомплектующихНаСкладе.Количество) КАК Количество
		|ИЗ
		|	РегистрСведений.Scan_НаличиеКомплектующихНаСкладе КАК Scan_НаличиеКомплектующихНаСкладе
		|ГДЕ
		|	Scan_НаличиеКомплектующихНаСкладе.Комплектующие = &Комплектующие";
	
	Запрос.УстановитьПараметр("Комплектующие", Комплектующие);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Количество;
	КонецЕсли;
	
	Возврат 0;	
КонецФункции

Функция ЗаписатьКоличество(Комплектующие, Количество, Склад) Экспорт
	НаборЗаписей = РегистрыСведений.Scan_НаличиеКомплектующихНаСкладе.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Комплектующие.Установить(Комплектующие);
	НаборЗаписей.Отбор.Склад.Установить(Склад); 
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Комплектующие = Комплектующие;
	НоваяЗапись.Количество = Количество;
	НоваяЗапись.Склад = Склад;
	НоваяЗапись.ДатаПолученияОстатков = ТекущаяДатаСеанса();
	НоваяЗапись.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Попытка
		НаборЗаписей.Записать();
	Исключение 
		Возврат Ложь;
	КонецПопытки;
	Возврат Истина;
	
КонецФункции

Функция ОчиститьКоличество(Комплектующие, Количество) Экспорт
	НаборЗаписей = РегистрыСведений.Scan_НаличиеКомплектующихНаСкладе.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Комплектующие.Установить(Комплектующие);
		
	Попытка
		НаборЗаписей.Записать();
	Исключение 
		Возврат Ложь;
	КонецПопытки;
	Возврат Истина;
	
КонецФункции


//rarus tenkam 11.12.2017 mantis 11952 ---
