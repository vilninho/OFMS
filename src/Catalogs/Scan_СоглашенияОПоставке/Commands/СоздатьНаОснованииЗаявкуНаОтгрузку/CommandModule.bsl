
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//rarus vikhle 16.09.2020 mt 16526 +++
	ПараметрыФормы = Новый Структура("ТекущееСоглашениеОПоставке",ПараметрКоманды);
	ОткрытьФорму("Справочник.Scan_СоглашенияОПоставке.Форма.ФормаНастройкиВводаЗаявкиНаОтгрузкуНаОсновании", ПараметрыФормы, 
					ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, 
					ПараметрыВыполненияКоманды.НавигационнаяСсылка,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	//rarus vikhle 16.09.2020 mt 16526 ---
КонецПроцедуры
