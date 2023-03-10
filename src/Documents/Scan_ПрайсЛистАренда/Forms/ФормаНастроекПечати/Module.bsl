
#Область ОбработчикиСобытийФормы
// rarus vikhle 08.12.2021 m 18340 +++
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПрайсЛист = Параметры.ДанныеДляПечати;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Scan_ПрайсЛистАрендаПрисоединенныеФайлы.Ссылка КАК Файл,
	               |	Scan_ПрайсЛистАрендаПрисоединенныеФайлы.Расширение КАК Расширение
	               |ИЗ
	               |	Справочник.Scan_ПрайсЛистАрендаПрисоединенныеФайлы КАК Scan_ПрайсЛистАрендаПрисоединенныеФайлы
	               |ГДЕ
	               |	Scan_ПрайсЛистАрендаПрисоединенныеФайлы.ВладелецФайла = &ПрайсЛист
	               |	И Scan_ПрайсЛистАрендаПрисоединенныеФайлы.Расширение В(&РасширенияКартинок)
	               |	И НЕ Scan_ПрайсЛистАрендаПрисоединенныеФайлы.ПометкаУдаления";
	РасширенияКартинок = Новый Массив;
	РасширенияКартинок.Добавить("bmp");
	РасширенияКартинок.Добавить("jpeg");
	РасширенияКартинок.Добавить("jpg");
	РасширенияКартинок.Добавить("png");
	
	Запрос.УстановитьПараметр("ПрайсЛист", ПрайсЛист);
	Запрос.УстановитьПараметр("РасширенияКартинок", РасширенияКартинок);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Файлы.Добавить(), Выборка);	
	КонецЦикла;	
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтображатьПревьюПриИзменении(Элемент)
	
	Если ОтображатьПревью Тогда 
		ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
		Если НЕ ТекущиеДанные = Неопределено Тогда
			АдресКартинки = ПолучитьКартинку(ТекущиеДанные.Файл, УникальныйИдентификатор);	
		КонецЕсли;	
	Иначе	
		АдресКартинки = "";
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПриАктивизацииСтроки(Элемент)
	
	Если ОтображатьПревью Тогда
		ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
		Если НЕ ТекущиеДанные = Неопределено Тогда
			АдресКартинки = ПолучитьКартинку(ТекущиеДанные.Файл, УникальныйИдентификатор); 
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	МассивФайлов = МассивФайлов();
	ПараметрыПечати = Новый Структура("МассивФайлов", МассивФайлов());
	
	Если Файлы.Количество() <> 0 И МассивФайлов.Количество() = 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаПечати", ЭтотОбъект, ПараметрыПечати);
		ПоказатьВопрос(ОписаниеОповещения, Нстр("ru = 'Не выбрано ни 1 изображение, продолжить?'"), РежимДиалогаВопрос.ДаНет);
		Возврат;
	ИначеЕсли МассивФайлов.Количество() > 4 Тогда 	
		ВывестиСообщениеПол(Нстр("ru = 'В печатной форме может отображаться максимум 4 изображения'"));
		Возврат;	
	Иначе
		ПечатьПродолжение(ПараметрыПечати);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Команда)
	
	Для Каждого СтрокаТЗ Из Файлы Цикл
		СтрокаТЗ.Флаг = Истина;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	
	Для Каждого СтрокаТЗ Из Файлы Цикл
		СтрокаТЗ.Флаг = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция МассивФайлов()
	
	ФайлыТЗ = РеквизитФормыВЗначение("Файлы");
	Отбор = Новый Структура("Флаг", Истина);
	ВыбранныеСтроки = Файлы.НайтиСтроки(Отбор);
	МассивФайлов = ОбщегоНазначения.ВыгрузитьКолонку(ВыбранныеСтроки, "Файл");
	
	Возврат МассивФайлов;
		
КонецФункции

&НаКлиенте
Процедура ПослеВопросаПечати(Результат, ПараметрыПечати) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПечатьПродолжение(ПараметрыПечати);
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПечатьПродолжение(ПараметрыПечати)
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.Scan_ПрайсЛистАренда",       
													"ПФ_MXL_ПрайсЛистАренда",           
													ПрайсЛист,       
													ЭтотОбъект,
													ПараметрыПечати);
	Закрыть();
	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ПолучитьКартинку(Файл, УникальныйИдентификатор) //rarus vikhle 24.12.2021 апк убрал экспорт 
	
	Возврат РаботаСФайламиСлужебный.НавигационнойСсылкиФайла(Файл, УникальныйИдентификатор);
	
КонецФункции	

// rarus vikhle 08.12.2021 m 18340 ---
#КонецОбласти

