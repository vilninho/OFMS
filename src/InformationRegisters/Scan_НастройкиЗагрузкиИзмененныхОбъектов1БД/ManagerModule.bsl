#Область Интерфейс

// Функция записи параметров в регистр сведений
// Параметры:
//  ВидКлючевойДаты - ПеречислениеСсылка.Scan_КлючевыеДаты – вид ключевой даты
//	ЗначенияРесурсов - Строка табличной части, структура и т.д - Коллекция, к значениям которой можно обратиться через точку
// Возвращаемое значение:
//   Булево   – ошибка записи значения
Функция ЗаписьЗначенияРегистраСведения(ТипОбъекта, ЗначенияРесурсов) Экспорт  //rarus bonmak 09.01.2020 15279 ++
	
	Отказ = Ложь;
	Если НЕ ЗначениеЗаполнено(ТипОбъекта) Тогда
		Отказ = Истина;
		Возврат Отказ;
	КонецЕсли;
		
	МенеджерЗаписи = РегистрыСведений.Scan_НастройкиЗагрузкиИзмененныхОбъектов1БД.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ТипИзменяемыхОбъектов	  		= ТипОбъекта;
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ЗначенияРесурсов);
	
	Попытка
		МенеджерЗаписи.Записать();  
	Исключение
		Сообщить(ОписаниеОшибки());
		Отказ = Истина;
	КонецПопытки; 
		
	Возврат Отказ;
КонецФункции //rarus bonmak 09.01.2020 15279 --

// Функция - Получить нстройки
//
// Параметры:
//  ОбъектКлючевыхДат	 - ПеречислениеСсылка.Scan_ОбъектыКлючевыхДат - 
// 
// Возвращаемое значение:
// ТаблицаЗначений  - Таблица в строках которой указаны настройки для ключевых дат. 
//
Функция ПолучитьНастройки() Экспорт //rarus bonmak 09.01.2020 15279 ++
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗначениеПоУмолчанию", 	Ложь);
	Запрос.Текст = "ВЫБРАТЬ
	|	Scan_ТипыИзмененныхОбъектов1БД.Ссылка КАК ТипИзменяемыхОбъектов,
	|	ЕСТЬNULL(Scan_НастройкиЗагрузкиИзмененныхОбъектов1БД.Загружать, &ЗначениеПоУмолчанию) КАК Загружать,
	//rarus agar 07.09.2020 16452 ++
	|	ЕСТЬNULL(Scan_НастройкиЗагрузкиИзмененныхОбъектов1БД.Порядок, 0) КАК Порядок
	//rarus agar 07.09.2020 16452 --
	|ИЗ
	|	Перечисление.Scan_ТипыИзмененныхОбъектов1БД КАК Scan_ТипыИзмененныхОбъектов1БД
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Scan_НастройкиЗагрузкиИзмененныхОбъектов1БД КАК Scan_НастройкиЗагрузкиИзмененныхОбъектов1БД
	|		ПО Scan_ТипыИзмененныхОбъектов1БД.Ссылка = Scan_НастройкиЗагрузкиИзмененныхОбъектов1БД.ТипИзменяемыхОбъектов
	|
	//rarus agar 07.09.2020 16452 ++
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	//rarus agar 07.09.2020 16452 --
	Настройки = Запрос.Выполнить().Выгрузить();
	Возврат Настройки;
КонецФункции //rarus bonmak 09.01.2020 15279 --

#КонецОбласти 
