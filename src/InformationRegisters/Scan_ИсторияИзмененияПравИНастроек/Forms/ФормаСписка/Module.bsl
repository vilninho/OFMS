
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ РольДоступна("АдминистраторСистемы") ИЛИ НЕ РольДоступна("ПолныеПрава")тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры
