//rarus tenkam 05.10.2016 mantis 7183 ++

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ФактическаяДатаДоставки = ТекущаяДата();
	РежимИзменения = "ТолькоСтрокиСпустойДатой";
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	Если ФактическаяДатаДоставки  > ТекущаяДата() Тогда
		Сообщить("Дата доставки больше, чем текущая дата!");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ФактическаяДатаДоставки) Тогда
		Сообщить("Дата фактической доставки не заполнена!");
		Возврат;
	КонецЕсли;
	
	НаВсеСтроки = (РежимИзменения = "ВсеСтроки");	
	ПараметрРежима = Новый Структура;
	ПараметрРежима.Вставить("НаВсеСтроки", НаВсеСтроки);
	ПараметрРежима.Вставить("ФактДата", ФактическаяДатаДоставки);
	Закрыть(ПараметрРежима);

КонецПроцедуры

//rarus tenkam 05.10.2016 mantis 7183 --