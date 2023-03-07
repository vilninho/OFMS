// rarus tenkam 07.08.2017 mantis 10589 +++
&НаСервере
Процедура ПересчитатьТарифыНаСервере()
	//rarus FominskiyAS 19.04.2019  mantis 14191 +++
	//Сообщить("Запущен фоновый пересчет тарифов.");
	Сообщить(НСтр("ru = 'Запущен фоновый пересчет тарифов.'; en = 'Tariff recalculation'"));
	//rarus FominskiyAS 19.04.2019  mantis 14191 ---  
	ПараметрыФоновогоЗадания = Новый Массив;
	//ПараметрыФоновогоЗадания.Добавить("Форма списка тарифов"); // rarus tenkam 31.08.2021 mantis 17628 +
	ФоновыеЗадания.Выполнить("Scan_Тарифы.ПолныйПересчет", ПараметрыФоновогоЗадания, Новый УникальныйИдентификатор,	"Полный пересчет");
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьТарифы(Команда)
	ПересчитатьТарифыНаСервере();
КонецПроцедуры
// rarus tenkam 07.08.2017 mantis 10589 ---
