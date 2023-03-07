
&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = ПолучитьОрганизацию();
	КонецЕсли;
	
	УстановитьОтбор();
	ОбновитьЗаголовок();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьОтбор();
	ОбновитьЗаголовок();
КонецПроцедуры

&НаСервере
Функция ПолучитьОрганизацию()
	//Организация = Scan_ОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ПользователиКлиентСервер.ТекущийПользователь(), 
	//	"ОсновнаяОрганизация");	
	ТекПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Возврат ТекПользователь.Организация;
КонецФункции

&НаКлиенте
Процедура УстановитьОтбор()
	Scan_ОбщегоНазначенияКлиент.УстановитьОтборУСписка(Список.Отбор, Новый ПолеКомпоновкиДанных("Владелец"), Организация, 
		ВидСравненияКомпоновкиДанных.Равно);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовок()
	//rarus FominskiyAS 24.04.2019  mantis 14191 +++
	//Заголовок = "Список подразделений организации """ + Scan_ОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(Организация,"Наименование") + """";
	Заголовок = НСтр("ru = 'Список подразделений организации ""'; en = 'Organization structure ""'") + Scan_ОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(Организация,"Наименование") + """";
	//rarus FominskiyAS 24.04.2019  mantis 14191 ---  	
КонецПроцедуры
