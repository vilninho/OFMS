//rarus tenkam 04.10.2019 mantis 14442 +++

////rarus tenkam 03.06.2016 mantis 7009 ++
//Процедура ЗаписатьСоставВРегистр(ТС,Прицеп) Экспорт
//	
//	//Вдруг к прицепу уже прикреплено ТС
//	ПрикрепленноеТС = ТСПрикрепленноеКПрицепу(Прицеп);
//	
//	Если НЕ ЗначениеЗаполнено(ТС) Тогда
//		//Поле ТС не заполнено - 1.Связь удалили - открепляем, 2.У прицепа нет связи - ничего не делаем
//		Если ЗначениеЗаполнено(ПрикрепленноеТС) Тогда
//			//Открепляем
//			НаборЗаписей = РегистрыСведений.Scan_ВзаимосвязьИзделий.СоздатьНаборЗаписей();
//			НаборЗаписей.Отбор.ИзделиеТС.Установить(ПрикрепленноеТС);
//			НаборЗаписей.Записать();
//		Иначе
//			Возврат;
//		КонецЕсли;
//	ИначеЕсли НЕ ЗначениеЗаполнено(Прицеп) Тогда
//		//Поле Прицеп не заполнено - 1.Связь удалили или ее не было - открепляем
//		НаборЗаписей = РегистрыСведений.Scan_ВзаимосвязьИзделий.СоздатьНаборЗаписей();
//	    НаборЗаписей.Отбор.ИзделиеТС.Установить(ТС);
//		НаборЗаписей.Записать();
//	Иначе
//		//Оба поля "ТС" и "Прицеп" заполнены: 
//		//1. Это карточка прицепа, ТС поменялось - Запишем новую запись, старую удалим.
//		//2. Это карточка ТС, Запишем новую запись
//		
//		Если ЗначениеЗаполнено(ПрикрепленноеТС) И ПрикрепленноеТС <> ТС Тогда
//			//Удалим старую запись 
//			НаборЗаписей = РегистрыСведений.Scan_ВзаимосвязьИзделий.СоздатьНаборЗаписей();
//			НаборЗаписей.Отбор.ИзделиеТС.Установить(ПрикрепленноеТС);
//			НаборЗаписей.Записать();
//		КонецЕсли;
//		
//		//Запишем новую запись
//		НаборЗаписей = РегистрыСведений.Scan_ВзаимосвязьИзделий.СоздатьНаборЗаписей();
//		НаборЗаписей.Отбор.ИзделиеТС.Установить(ТС);
//		НоваяЗапись = НаборЗаписей.Добавить();
//		
//		НоваяЗапись.ИзделиеТС = ТС;
//		НоваяЗапись.ИзделиеПрицепнаяТехника = Прицеп;
//		НоваяЗапись.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
//		НаборЗаписей.Записать();
//			
//	КонецЕсли;
//	
//КонецПроцедуры

//Функция ТСПрикрепленноеКПрицепу(Прицеп) Экспорт
//	Запрос = Новый Запрос;
//	Запрос.Текст = "ВЫБРАТЬ
//	               |	Scan_ВзаимосвязьИзделий.ИзделиеТС 
//	               |ИЗ
//	               |	РегистрСведений.Scan_ВзаимосвязьИзделий КАК Scan_ВзаимосвязьИзделий
//	               |ГДЕ
//	               |	Scan_ВзаимосвязьИзделий.ИзделиеПрицепнаяТехника = &Прицеп";
//	Запрос.УстановитьПараметр("Прицеп", Прицеп);
//	Выборка = Запрос.Выполнить().Выбрать();
//	Если Выборка.Следующий() Тогда
//		Возврат Выборка.ИзделиеТС;
//	Иначе
//		Возврат Справочники.Scan_Изделия.ПустаяСсылка();
//	КонецЕсли;
//	
//КонецФункции

//Функция ПрицепПрикрепленныйКТС(ТС) Экспорт
//	Запрос = Новый Запрос;
//	Запрос.Текст = "ВЫБРАТЬ
//	               |	Scan_ВзаимосвязьИзделий.ИзделиеПрицепнаяТехника 
//	               |ИЗ
//	               |	РегистрСведений.Scan_ВзаимосвязьИзделий КАК Scan_ВзаимосвязьИзделий
//	               |ГДЕ
//	               |	Scan_ВзаимосвязьИзделий.ИзделиеТС = &ТС";
//	Запрос.УстановитьПараметр("ТС", ТС);
//	Выборка = Запрос.Выполнить().Выбрать();
//	Если Выборка.Следующий() Тогда
//		Возврат Выборка.ИзделиеПрицепнаяТехника;
//	Иначе
//		Возврат Справочники.Scan_Изделия.ПустаяСсылка();
//	КонецЕсли;
//	
//КонецФункции
////rarus tenkam 03.06.2016 mantis 7009 --
//rarus tenkam 04.10.2019 mantis 14442 ---
