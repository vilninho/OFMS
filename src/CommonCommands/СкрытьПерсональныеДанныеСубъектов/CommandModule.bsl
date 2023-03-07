///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыВопроса = ЗащитаПерсональныхДанныхВызовСервера.ПараметрыВопросаПодтвержденияСкрытия(ПараметрКоманды);
	
	Субъекты = ПараметрыВопроса.Субъекты;
	Если Субъекты.Количество() > 0 Тогда
		
		Оповещение = Новый ОписаниеОповещения("ОбработкаКомандыЗавершение", ЭтотОбъект, Субъекты);
		ПоказатьВопрос(Оповещение, ПараметрыВопроса.ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаКомандыЗавершение(Результат, Субъекты) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ЗащитаПерсональныхДанныхВызовСервера.СкрытьПерсональныеДанныеСубъектов(Субъекты, Истина);
		Оповестить("СкрытыПерсональныеДанные");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

