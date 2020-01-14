﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки", процедуры и функции по управлению
// регламентными заданиями.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает новое регламентное задание в информационной базе.
//
// Параметры:
//  Наименование - строка, наименование регламентного задания.
//
// Возвращаемое значение: РегламентноеЗадание.
//
Функция СоздатьНовоеЗадание(Знач Наименование) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ДополнительныеОтчетыИОбработкиВМоделиСервиса") Тогда
		МодульДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса");
		Возврат МодульДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса.СоздатьНовоеЗадание();
	КонецЕсли;
	
	Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание("ЗапускДополнительныхОбработок");
	Задание.Использование = Ложь;
	Задание.Наименование  = Наименование;
	Задание.Записать();
	
	Возврат Задание;
	
КонецФункции

// Возвращает идентификатор регламентного задания (для сохранения в данных информационной базы).
//
// Задание - РегламентноеЗадание.
//
// Возвращаемое значение: УникальныйИдентификатор.
//
Функция ПолучитьИдентификаторЗадания(Знач Задание) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ДополнительныеОтчетыИОбработкиВМоделиСервиса") Тогда
		МодульДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса");
		Возврат МодульДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса.ПолучитьИдентификаторЗадания(Задание);
	КонецЕсли;
	
	Возврат Задание.УникальныйИдентификатор;
	
КонецФункции

// Устанавливает параметры регламентного задания.
//
// Параметры:
//  Задание - РегламентноеЗадание,
//  Использование - булево, флаг использования регламентного задания,
//  Наименование - строка, наименование регламентного задания,
//  Параметры - Массив(Произвольный), параметры регламентного задания,
//  Расписание - РасписаниеРегламентногоЗадания.
//
Процедура УстановитьПараметрыЗадания(Задание, Использование, Наименование, Параметры, Расписание) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ДополнительныеОтчетыИОбработкиВМоделиСервиса") Тогда
		МодульДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса");
		МодульДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса.УстановитьПараметрыЗадания(Задание, Использование, Параметры, Расписание);
		Возврат;
	КонецЕсли;
	
	Задание.Использование = Использование;
	Задание.Наименование  = Наименование;
	Задание.Параметры     = Параметры;
	Задание.Расписание    = Расписание;
	
	Задание.Записать();
	
КонецПроцедуры

// Возвращает параметры регламентного задания.
//
// Параметры:
//  Задание - РегламентноеЗадание.
//
// Возвращаемое значение: Структура, ключи:
//  Использование - булево, флаг использования регламентного задания,
//  Наименование - строка, наименование регламентного задания,
//  Параметры - Массив(Произвольный), параметры регламентного задания,
//  Расписание - РасписаниеРегламентногоЗадания.
//
Функция ПолучитьПараметрыЗадания(Знач Задание) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ДополнительныеОтчетыИОбработкиВМоделиСервиса") Тогда
		МодульДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса");
		Возврат МодульДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса.ПолучитьПараметрыЗадания(Задание);
	КонецЕсли;
	
	Результат = Новый Структура();
	Результат.Вставить("Использование", Задание.Использование);
	Результат.Вставить("Наименование", Задание.Наименование);
	Результат.Вставить("Параметры", Задание.Параметры);
	Результат.Вставить("Расписание", Задание.Расписание);
	
	Возврат Результат;
	
КонецФункции

// Выполняет поиск задания по идентификатору (предположительно, сохраненному в данных
// информационной базы).
//
// Параметры: Идентификатор - УникальныйИдентификатор.
//
// Возвращаемое значение: РегламентноеЗадание.
//
Функция НайтиЗадание(Знач Идентификатор) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ДополнительныеОтчетыИОбработкиВМоделиСервиса") Тогда
		МодульДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса");
		Возврат МодульДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса.НайтиЗадание(Идентификатор);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	
	Возврат Задание;
	
КонецФункции

// Удаляет регламентное задание из информационной базы.
//
// Параметры:
// Задание - РегламентноеЗадание.
//
Процедура УдалитьЗадание(Знач Задание) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ДополнительныеОтчетыИОбработкиВМоделиСервиса") Тогда
		МодульДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса");
		МодульДополнительныеОтчетыИОбработкиРегламентныеЗаданияВМоделиСервиса.УдалитьЗадание(Задание);
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Задание) = Тип("РегламентноеЗадание") Тогда
		Задание.Удалить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
