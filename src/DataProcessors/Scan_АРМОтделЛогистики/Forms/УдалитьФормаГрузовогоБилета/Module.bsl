//rarus sergei 12.10.2016 mantis 6925 ++ (доп. постановка) 
&НаКлиенте
Процедура КомандаОК(Команда)
	ПараметрыГрузовогоБилета = Новый Структура;
	ПараметрыГрузовогоБилета.Вставить("НомерГрузовогоБилета", СокрЛП(НомерГрузовогоБилета));	//rarus tenkam 10.05.2017 mantis 9608 + (сокрЛП)
	ПараметрыГрузовогоБилета.Вставить("ДатаГрузовогоБилета", ДатаГрузовогоБилета);

	Закрыть(ПараметрыГрузовогоБилета);
КонецПроцедуры
//rarus sergei 12.10.2016 mantis 6925 --