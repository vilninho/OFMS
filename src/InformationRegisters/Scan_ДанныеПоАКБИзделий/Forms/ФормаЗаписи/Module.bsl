// rarus tenkam 14.03.2018 mantis 12900 +++

&НаКлиенте
Процедура ХарактеристикаПриИзменении(Элемент)
	СоответствиеХарактеристик = Новый Соответствие;
	СоответствиеХарактеристик.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.ПусковойТок"), Запись.ПусковойТок);
	СоответствиеХарактеристик.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.Плотность"), Запись.Плотность);
	СоответствиеХарактеристик.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.НапряжениеБезНагрузки"), Запись.НапряжениеБезНагрузки);
	СоответствиеХарактеристик.Вставить(ПредопределенноеЗначение("Перечисление.Scan_ХарактеристикиАКБ.НапряжениеПодНагрузкой"), Запись.НапряжениеПодНагрузкой);
	СоответствиеХарактеристик.Вставить("Емкость", Запись.Емкость);
	Запись.Состояние = ПолучитьСостояние(СоответствиеХарактеристик);
КонецПроцедуры

&НаСервереБезКОнтекста
Функция ПолучитьСостояние(СоответствиеХарактеристик)
	Возврат Справочники.Scan_СостоянияАКБ.ПолучитьСостояниеПоХарактеристикам(СоответствиеХарактеристик);	
КонецФункции

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
КонецПроцедуры   

// rarus tenkam 14.03.2018 mantis 12900 ---
