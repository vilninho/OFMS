
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Взаимодействия"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

//Возвращает текст запроса, отбирающего контакты (участников) предмета взаимодействия.
//Используется, если в конфигурации определен хотя бы один предмет взаимодействий.
//
//Параметры:
//  ПомещатьВоВременнуюТаблицу - Булево - признак того, что результат выполнения запроса 
//                                        необходимо поместить во временную таблицу.
//  ИмяТаблицы                 - Строка - имя таблицы предмета взаимодействий, в котором будет выполнен поиск.
//
Функция ПолучитьТекстЗапросаПоискКонтактовПоПредмету(
	ПомещатьВоВременнуюТаблицу,
	ИмяТаблицы,
	Объединить = Ложь) Экспорт
	
	//+РАРУС Сформируем запрос по контактам предпета взаимодействия
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяТаблицы);
	ПустаяСсылка    = МенеджерОбъекта.ПустаяСсылка();
	
	Попытка
		Возврат МенеджерОбъекта.ПолучитьТекстЗапросаПоКонтактам(ПустаяСсылка, ?(НЕ ПомещатьВоВременнуюТаблицу, "", Символы.ПС + "ПОМЕСТИТЬ табКонтакты"), Объединить, ЛОЖЬ);
	Исключение
		//rarus tenkam 03.11.2016 СМЕНА РЕЛИЗА ОШИБКА ++
		//// Вызываем общий обработчик действия
		//Возврат УправлениеДиалогомСервер.ПолучитьТекстЗапросаПоКонтактам(ПустаяСсылка, ?(НЕ ПомещатьВоВременнуюТаблицу, "", Символы.ПС + "ПОМЕСТИТЬ табКонтакты"), Объединить, ЛОЖЬ);
		//rarus tenkam 03.11.2016 СМЕНА РЕЛИЗА ОШИБКА --
	КонецПопытки;
	//-РАРУС
	
КонецФункции

//Возможность переопределить владельца присоединенных файлов для письма.
//Такая необходимость может возникнуть например при массовых рассылках. В этом случае имеет смысл 
//хранить одни и те же присоединенные файлы в одном месте, а не тиражировать их на все письма рассылки.
//
//Параметры
//  Письмо  - ДокументСсылка, ДокументОбъект - документ электронное письмо для которого необходимо получить вложения.
//
//Возвращаемое значение:
//  Структура,Неопределено  - Неопределено, если присоединенные файлы хранятся при письме.
//                            Структура, если присоединенные файлы хранятся в другом объекте. Формат структуры:
//                              - Владелец - владелец присоединенных файлов,
//                              - ИмяСправочникаПрисоединенныеФайлы - имя объекта метаданных присоединенных файлов.
//
Функция ПолучитьДанныеОбъектаМетаданныхПрисоединенныхФайловПисьма(Письмо) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти



//Возвращает важность Интернет почтового сообщения в зависимости от переданного значения
//перечисления ВариантыВажностиВзаимодействия.
//
//Параметры
//  ВажностьВзаимодействия - Перечисление.ВариантыВажностиВзаимодействия
//
//Возвращаемое значение:
//  ВажностьИнтернетПочтовогоСообщения
//
Функция ПолучитьВажность(ВажностьВзаимодействия) Экспорт
	
	Если ВажностьВзаимодействия = Перечисления.Scan_Важность.Высокая Тогда
		Возврат ВажностьИнтернетПочтовогоСообщения.Высокая;
	ИначеЕсли ВажностьВзаимодействия = Перечисления.Scan_Важность.Низкая Тогда
		Возврат ВажностьИнтернетПочтовогоСообщения.Низкая;
	Иначе
		Возврат ВажностьИнтернетПочтовогоСообщения.Обычная;
	КонецЕсли;
	
КонецФункции
