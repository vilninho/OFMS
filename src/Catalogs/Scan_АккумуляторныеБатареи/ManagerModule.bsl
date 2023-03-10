// rarus tenkam 08.02.2018 mantis 12721 +++
Функция НетАКБ(Изделие, ПорядокАКБ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_АккумуляторныеБатареи.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Scan_АккумуляторныеБатареи КАК Scan_АккумуляторныеБатареи
		|ГДЕ
		|	Scan_АккумуляторныеБатареи.Изделие = &Изделие
		|	И Scan_АккумуляторныеБатареи.ПорядокАКБ = &ПорядокАКБ
		|	И Scan_АккумуляторныеБатареи.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Изделие", Изделие);
	Запрос.УстановитьПараметр("ПорядокАКБ", ПорядокАКБ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
	
КонецФункции

Функция ПолучитьАКБ(Изделие, ПорядокАКБ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Scan_АккумуляторныеБатареи.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Scan_АккумуляторныеБатареи КАК Scan_АккумуляторныеБатареи
		|ГДЕ
		|	Scan_АккумуляторныеБатареи.Изделие = &Изделие
		|	И Scan_АккумуляторныеБатареи.ПорядокАКБ = &ПорядокАКБ
		|	И Scan_АккумуляторныеБатареи.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Изделие", Изделие);
	Запрос.УстановитьПараметр("ПорядокАКБ", ПорядокАКБ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;
	Возврат Справочники.Scan_АккумуляторныеБатареи.ПустаяСсылка();
	
КонецФункции
// rarus tenkam 08.02.2018 mantis 12721 ---