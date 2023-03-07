///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Запись.РазмерДанных = ВерсионированиеОбъектов.РазмерДанных(Запись.ВерсияОбъекта);
		
		ДанныеВерсии = Запись.ВерсияОбъекта.Получить();
		Запись.ЕстьДанныеВерсии = ДанныеВерсии <> Неопределено;
		
		Если ПустаяСтрока(Запись.КонтрольнаяСумма) И Запись.ЕстьДанныеВерсии Тогда
			Запись.КонтрольнаяСумма = ВерсионированиеОбъектов.КонтрольнаяСумма(ДанныеВерсии);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли