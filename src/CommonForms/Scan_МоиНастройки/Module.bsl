
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	//Если Не Пользователи.РолиДоступны("ИзменениеМакетовПечатныхФорм") Тогда
	//	Элементы.ЗадатьДействиеПриВыбореМакетаПечатнойФормы.Видимость = Ложь;
	//КонецЕсли;
	
	ЭтоВебКлиент = ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
	
	//ВыполнитьПроверкуПравДоступа("СохранениеДанныхПользователя", Метаданные);
	//
	//ПредлагатьПерейтиНаСайтПриЗапуске = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	//	"ОбщиеНастройкиПользователя", 
	//	"ПредлагатьПерейтиНаСайтПриЗапуске",
	//	Ложь);

	// СтандартныеПодсистемы.БазоваяФункциональность
	Если ЭтоВебКлиент Тогда
		Элементы.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы.Видимость = Ложь;
	Иначе
		Элементы.ГруппаУстановитьРасширениеРаботыСФайламиНаКлиенте.Видимость = Ложь;
	КонецЕсли;
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	
	//// Определение текущей настройки рабочей даты.
	//rarus FominskiyAS 07.03.2019  mantis 13863 +++
	ЗначениеРабочейДаты = ОбщегоНазначения.РабочаяДатаПользователя();
	Если ЗначениеЗаполнено(ЗначениеРабочейДаты) Тогда
		ИспользоватьТекущуюДатуКомпьютера = 0;
	Иначе
		ИспользоватьТекущуюДатуКомпьютера = 1;
		Элементы.ЗначениеРабочейДаты.Доступность = Ложь;
	КонецЕсли;
	//rarus FominskiyAS 07.03.2019  mantis 13863 ---

	
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.Пользователи
	//ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	//Если ПравоДоступа("Просмотр", Метаданные.НайтиПоТипу(ТипЗнч(ТекущийПользователь))) Тогда
	//	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	//	Элементы.СведенияОПользователе.Заголовок = АвторизованныйПользователь;
	//Иначе
	//	Элементы.ГруппаУчетнаяЗапись.Видимость = Ложь;
	//КонецЕсли;
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.РаботаСФайлами
	СпрашиватьРежимРедактированияПриОткрытииФайла = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов",
		"СпрашиватьРежимРедактированияПриОткрытииФайла",
		Истина);
	
	ДействиеПоДвойномуЩелчкуМыши = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов",
		"ДействиеПоДвойномуЩелчкуМыши",
		Перечисления.ДействияСФайламиПоДвойномуЩелчку.ОткрыватьФайл);
	
	СпособСравненияВерсийФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСравненияФайлов",
		"СпособСравненияВерсийФайлов",
		Перечисления.СпособыСравненияВерсийФайлов.ПустаяСсылка());
	
	ПоказыватьПодсказкиПриРедактированииФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьПодсказкиПриРедактированииФайлов",
		Ложь);
	
	ПоказыватьИнформациюЧтоФайлНеБылИзменен = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьИнформациюЧтоФайлНеБылИзменен",
		Ложь);
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы",
		Истина);
	
	ПоказыватьКолонкуРазмер = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьКолонкуРазмер",
		Ложь);
	
	// Заполнение настроек открытия файлов.
	СтрокаНастройки = НастройкиОткрытияФайлов.Добавить();
	СтрокаНастройки.ТипФайла = Перечисления.ТипыФайловДляВстроенногоРедактора.ТекстовыеФайлы;
	
	СтрокаНастройки.Расширение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов\ТекстовыеФайлы",
		"Расширение",
		"TXT XML INI");
	
	СтрокаНастройки.СпособОткрытия = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов\ТекстовыеФайлы",
		"СпособОткрытия",
		Перечисления.СпособыОткрытияФайлаНаПросмотр.ВоВстроенномРедакторе);
	
	Если ЭтоВебКлиент Тогда
		Элементы.ПоказыватьЗанятыеФайлыПриЗавершенииРаботы.Видимость      = Ложь;
	КонецЕсли;
	
	Если ЭтоВебКлиент Или ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Элементы.НастройкаСканирования.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	//// СтандартныеПодсистемы.ЭлектроннаяПодпись
	//Элементы.НастройкиЭлектроннойПодписиИШифрования.Видимость =
	//	ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	//// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись
	
	//Элементы.ГруппаИнтеграция1СБухфон.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьИнтеграцию1СБухфон");
	
	Scan_СборСтатистики.Scan_ПриОткрытииФормы(ЭтотОбъект.ИмяФормы); // Rarus tenkam 11.04.2022 mantis 18433 +

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
#Если ВебКлиент Тогда	
	НапоминатьОбУстановкеРасширенияРаботыСФайлами = ОбщегоНазначенияКлиент.ПредлагатьУстановкуРасширенияРаботыСФайлами();
	ОбновитьГруппуУстановкиРасширенияРаботыСФайлами();
#КонецЕсли	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьОповещение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// Страница Главное

//&НаКлиенте
//Процедура СведенияОПользователе(Команда)
//	
//	ПоказатьЗначение(, АвторизованныйПользователь);
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ПерсональнаяНастройкаПроксиСервера(Команда)
//	
//	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", Новый Структура("НастройкаПроксиНаКлиенте", Истина));
//	
//КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиенте(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуУстановкиРасширенияРаботыСФайлами()
	Оповещение = Новый ОписаниеОповещения("ОбновитьГруппуУстановкиРасширенияРаботыСФайламиЗавершение", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуУстановкиРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	Элементы.ГруппаСтраницы.ТекущаяСтраница = ?(Подключено, Элементы.ГруппаРасширениеРаботыСФайламиУстановлено, 
		Элементы.ГруппаРасширениеРаботыСФайламиНеУстановлено);
КонецПроцедуры

//&НаКлиенте
//Процедура ОбновитьИнтерфейсПрограммы(Команда)
//	
//	ОбновитьПовторноИспользуемыеЗначения();
//	ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
//	ПоказатьОповещениеПользователя(НСтр("ru = 'Интерфейс программы'"),, 
//		НСтр("ru = 'Настройки интерфейса программы применены'"));
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ИспользоватьТекущуюДатуКомпьютераПриИзменении(Элемент)

//	Если ИспользоватьТекущуюДатуКомпьютера = 1 Тогда
//		ЗначениеРабочейДаты = '0001-01-01';
//	Иначе
//		ЗначениеРабочейДаты = ТекущаяДата();
//	КонецЕсли;
//	Элементы.ЗначениеРабочейДаты.Доступность = ИспользоватьТекущуюДатуКомпьютера = 0;
//	Модифицированность = Истина;
//	
//КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница Органайзер

////////////////////////////////////////////////////////////////////////////////
// Страница Печать

//&НаКлиенте
//Процедура ЗадатьДействиеПриВыбореМакетаПечатнойФормы(Команда)
//	
//	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ВыбораРежимаОткрытияМакета");
//	
//КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница РаботаСФайлами

&НаКлиенте
Процедура НастройкаРабочегоКаталога(Команда)
	
	РаботаСФайламиКлиент.ОткрытьФормуНастройкиРабочегоКаталога();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСканирования(Команда)
	
	// rarus agar 21.05.2021 16927 ++
	//ФайловыеФункцииКлиент.ОткрытьФормуНастройкиСканирования();
	РаботаСФайламиКлиент.ОткрытьФормуНастройкиСканирования();
	// rarus agar 21.05.2021 16927 ++
	
КонецПроцедуры

//&НаКлиенте
//Процедура НастройкиЭлектроннойПодписиИШифрования(Команда)
//	
//	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования();
//	
//КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПараметрыКлиента = Новый Структура;
#Если ВебКлиент Тогда
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ПараметрыКлиента.Вставить("ИдентификаторКлиента", СистемнаяИнформация.ИдентификаторКлиента);
		
	ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьУстановкуРасширенияРаботыСФайлами"] = НапоминатьОбУстановкеРасширенияРаботыСФайлами;
#КонецЕсли
	
	ЗаписатьНастройкиНаСервере(ПараметрыКлиента);
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьОповещение(Результат, Неопределен) Экспорт
	ЗаписатьИЗакрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение(ДополнительныеПараметры) Экспорт
	
	ОбновитьГруппуУстановкиРасширенияРаботыСФайлами();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиНаСервере(ПараметрыКлиента)
	// Рабочая дата.
	Если ИспользоватьТекущуюДатуКомпьютера = 1 Тогда
		ЗначениеРабочейДатыДляСохранения = '0001-01-01';
	Иначе
		ЗначениеРабочейДатыДляСохранения = ЗначениеРабочейДаты;
	КонецЕсли;
	ОбщегоНазначения.УстановитьРабочуюДатуПользователя(ЗначениеРабочейДатыДляСохранения);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	СохранитьСвойстваКоллекции("ОбщиеНастройкиПользователя", ЭтотОбъект,
		"ПредлагатьПерейтиНаСайтПриЗапуске,
		|ЗапрашиватьПодтверждениеПриЗавершенииПрограммы");
	Если ПараметрыКлиента.Свойство("ИдентификаторКлиента") Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами",
			ПараметрыКлиента.ИдентификаторКлиента,
			НапоминатьОбУстановкеРасширенияРаботыСФайлами);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.РаботаСФайлами
	СохранитьСвойстваКоллекции("НастройкиОткрытияФайлов", ЭтотОбъект,
		"ДействиеПоДвойномуЩелчкуМыши,
		|СпрашиватьРежимРедактированияПриОткрытииФайла");
	СохранитьСвойстваКоллекции("НастройкиПрограммы", ЭтотОбъект,
		"ПоказыватьПодсказкиПриРедактированииФайлов,
		|ПоказыватьЗанятыеФайлыПриЗавершенииРаботы,
		|ПоказыватьКолонкуРазмер,
		|ПоказыватьИнформациюЧтоФайлНеБылИзменен");
	СохранитьСвойстваКоллекции("НастройкиСравненияФайлов", ЭтотОбъект,
		"СпособСравненияВерсийФайлов");
	Если НастройкиОткрытияФайлов.Количество() >= 1 Тогда
		СохранитьСвойстваКоллекции("НастройкиОткрытияФайлов\ТекстовыеФайлы", НастройкиОткрытияФайлов[0],
			"Расширение,
			|СпособОткрытия");
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

&НаСервере
Процедура СохранитьСвойстваКоллекции(КлючОбъекта, Коллекция, ИменаРеквизитов)
	СтруктураРеквизитов = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Коллекция);
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура СведенияОПользователе(Команда)
	
	ПоказатьЗначение(, АвторизованныйПользователь);
	
КонецПроцедуры
