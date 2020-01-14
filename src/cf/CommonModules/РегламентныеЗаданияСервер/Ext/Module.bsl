﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Программный интерфейс для управления регламентными заданиями.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает задания очереди по заданному отбору.
// Возможно получение неконсистентных данных.
// Параметры:
//  Отбор - Структура, Массив - значения по которым, требуется отбирать задания. 
//  Возможные ключи структуры для ИБ в обычном режиме:
//   УникальныйИдентификатор
//   Ключ
//   Метаданные
//   Предопределенное
//   Использование
//   Наименование
//  Возможные ключи структуры для ИБ в режиме сервиса:
//   ОбластьДанных 
//   ИмяМетода
//   Идентификатор
//   СостояниеЗадания
//   Ключ
//   Шаблон
//   Использование
//  Так же может быть передан массив структур - описаний отбора со следующими ключами:
//   ВидСравнения - ВидСравнения - допустимыми значениями являются только.
//    ВидСравнения.Равно
//    ВидСравнения.НеРавно
//    ВидСравнения.ВСписке
//    ВидСравнения.НеВСписке
//   Значение - Значение отбора, для видов сравнения ВСписке и НеВСписке - массив значений.
//    Для видов сравнения  Равно / НеРавно - сами значения.
//  Все условия отбора объединяются по И.
// Возвращаемое значение:
//  ТаблицаЗначений - таблица найденных заданий. Колонки соответствуют параметрам заданий.
//
Функция НайтиЗадания(Знач Отбор) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			
			ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
			
			Если Отбор.Свойство("УникальныйИдентификатор") И НЕ Отбор.Свойство("Идентификатор") Тогда
				Отбор.Вставить("Идентификатор", Отбор.УникальныйИдентификатор);
			КонецЕсли;
			
			Отбор.Вставить("ОбластьДанных", ОбластьДанных);
			
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			
			Если Отбор.Свойство("Метаданные") Тогда
				Если  ТипЗнч(Отбор.Метаданные) = Тип("ОбъектМетаданных") Тогда
					Попытка
						Шаблон = МодульОчередьЗаданий.ШаблонПоИмени(Отбор.Метаданные.Имя);
						Отбор.Вставить("Шаблон", Шаблон);
					Исключение
						Отбор.Вставить("ИмяМетода", Отбор.Метаданные.ИмяМетода);
					КонецПопытки;
				Иначе
					МетаданныеРегламентноеЗадание = Метаданные.РегламентныеЗадания.Найти(Отбор.Метаданные);
					Если МетаданныеРегламентноеЗадание <> Неопределено Тогда
						Попытка
							Шаблон = МодульОчередьЗаданий.ШаблонПоИмени(МетаданныеРегламентноеЗадание.Имя);
							Отбор.Вставить("Шаблон", Шаблон);
						Исключение
							Отбор.Вставить("ИмяМетода", МетаданныеРегламентноеЗадание.ИмяМетода);
						КонецПопытки;
					КонецЕсли; 
				КонецЕсли;
			ИначеЕсли Отбор.Свойство("Идентификатор") 
				И (ТипЗнч(Отбор.Идентификатор) = Тип("УникальныйИдентификатор")
				ИЛИ ТипЗнч(Отбор.Идентификатор) = Тип("Строка")) Тогда
				
				Если ТипЗнч(Отбор.Идентификатор) = Тип("Строка") Тогда
					Отбор.Идентификатор = Новый УникальныйИдентификатор(Отбор.Идентификатор);
				КонецЕсли;
				
				МодульОчередьЗаданийСлужебный = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийСлужебный");
				СправочникДляЗадания = МодульОчередьЗаданийСлужебный.СправочникОчередьЗаданий();
				
				Если ОбщегоНазначенияПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
					МодульОчередьЗаданийСлужебныйРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийСлужебныйРазделениеДанных");
					ПереопределенныйСправочник = МодульОчередьЗаданийСлужебныйРазделениеДанных.ПриВыбореСправочникаДляЗадания(Отбор);
					Если ПереопределенныйСправочник <> Неопределено Тогда
						СправочникДляЗадания = ПереопределенныйСправочник;
					КонецЕсли;
				КонецЕсли;
				Отбор.Вставить("Идентификатор", СправочникДляЗадания.ПолучитьСсылку(Отбор.Идентификатор));
			КонецЕсли;
			
			Отбор.Удалить("Метаданные");
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(Отбор);
			
			Возврат СписокЗаданий;
			
		КонецЕсли;
	Иначе
		
		СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
		
		Возврат СписокЗаданий;
		
	КонецЕсли;
	
КонецФункции

// Возвращает РегламентноеЗадание из информационной базы.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания 
//                           или имя метаданных предопределенного регламентного задания.
//                - РегламентноеЗадание - регламентное задание из которого нужно получить
//                  уникальный идентификатор для получения свежей копии регламентного задания.
// 
// Возвращаемое значение:
//  РегламентноеЗадание - прочитано из базы данных.
//
Функция Задание(Знач Идентификатор) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
			
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
			
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			
			Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
				Если Идентификатор.Предопределенное Тогда
					ПараметрыЗадания.Вставить("Шаблон", МодульОчередьЗаданий.ШаблонПоИмени(Идентификатор.Имя));
				Иначе
					ПараметрыЗадания.Вставить("ИмяМетода", Идентификатор.ИмяМетода);
				КонецЕсли; 
			ИначеЕсли ТипЗнч(Идентификатор) = Тип("УникальныйИдентификатор") Тогда
				МодульОчередьЗаданийСлужебный = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийСлужебный");
				СправочникДляЗадания = МодульОчередьЗаданийСлужебный.СправочникОчередьЗаданий();
				
				Если ОбщегоНазначенияПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
					МодульОчередьЗаданийСлужебныйРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийСлужебныйРазделениеДанных");
					ПереопределенныйСправочник = МодульОчередьЗаданийСлужебныйРазделениеДанных.ПриВыбореСправочникаДляЗадания(ПараметрыЗадания);
					Если ПереопределенныйСправочник <> Неопределено Тогда
						СправочникДляЗадания = ПереопределенныйСправочник;
					КонецЕсли;
				КонецЕсли;
				ПараметрыЗадания.Вставить("Идентификатор", СправочникДляЗадания.ПолучитьСсылку(Идентификатор));
				
			ИначеЕсли ТипЗнч(Идентификатор) = Тип("СтрокаТаблицыЗначений") Тогда
				Возврат Идентификатор;
			Иначе
				ПараметрыЗадания.Вставить("Идентификатор", Идентификатор);
			КонецЕсли;
			
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Для Каждого Задание Из СписокЗаданий Цикл
				РегламентноеЗадание = Задание;
				Прервать;
			КонецЦикла;
		КонецЕсли;
	Иначе
		
		Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
			Если Идентификатор.Предопределенное Тогда
				РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Идентификатор);
			Иначе
				СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Метаданные", Идентификатор));
				Если СписокЗаданий.Количество() > 0 Тогда
					РегламентноеЗадание = СписокЗаданий[0];
				КонецЕсли;
			КонецЕсли; 
		Иначе
			РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
		КонецЕсли;
	КонецЕсли;
	
	Возврат РегламентноеЗадание;
	
КонецФункции

// Добавляет новое задание в очередь или как регламентное.
// 
// Параметры: 
//  ПараметрыЗадания - Структура - Параметры добавляемого задания, возможные ключи:
//   Использование
//   Метаданные - обязательно для указания.
//   Параметры
//   Ключ
//   ИнтервалПовтораПриАварийномЗавершении.
//   Расписание
//   КоличествоПовторовПриАварийномЗавершении.
//
// Возвращаемое значение: 
//  РегламентноеЗадание, СправочникСсылка.ОчередьЗаданий, СправочникСсылка.ОчередьЗаданийОбластейДанных - Идентификатор добавленного задания.
// 
Функция ДобавитьЗадание(ПараметрыЗадания) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
			
			ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
			МетаданныеЗадания = ПараметрыЗадания.Метаданные;
			ИмяМетода = МетаданныеЗадания.ИмяМетода;
			ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
			
			ПараметрыЗадания.Удалить("Метаданные");
			ПараметрыЗадания.Удалить("Наименование");
			
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			Задание = МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(Новый Структура("Идентификатор", Задание));
			Для Каждого Задание Из СписокЗаданий Цикл
				Возврат Задание;
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		
		МетаданныеЗадания = ПараметрыЗадания.Метаданные;
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(МетаданныеЗадания);
		
		Если ПараметрыЗадания.Свойство("Наименование") Тогда
			Задание.Наименование = ПараметрыЗадания.Наименование;
		Иначе
			Задание.Наименование = МетаданныеЗадания.Наименование;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("Использование") Тогда
			Задание.Использование = ПараметрыЗадания.Использование;
		Иначе
			Задание.Использование = МетаданныеЗадания.Использование;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("Ключ") Тогда
			Задание.Ключ = ПараметрыЗадания.Ключ;
		Иначе
			Задание.Ключ = МетаданныеЗадания.Ключ;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("ИмяПользователя") Тогда
			Задание.ИмяПользователя = ПараметрыЗадания.ИмяПользователя;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("ИнтервалПовтораПриАварийномЗавершении") Тогда
			Задание.ИнтервалПовтораПриАварийномЗавершении = ПараметрыЗадания.ИнтервалПовтораПриАварийномЗавершении;
		Иначе
			Задание.ИнтервалПовтораПриАварийномЗавершении = МетаданныеЗадания.ИнтервалПовтораПриАварийномЗавершении;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("КоличествоПовторовПриАварийномЗавершении") Тогда
			Задание.КоличествоПовторовПриАварийномЗавершении = ПараметрыЗадания.КоличествоПовторовПриАварийномЗавершении;
		Иначе
			Задание.КоличествоПовторовПриАварийномЗавершении = МетаданныеЗадания.КоличествоПовторовПриАварийномЗавершении;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("Параметры") Тогда
			Задание.Параметры = ПараметрыЗадания.Параметры;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("Расписание") Тогда
			Задание.Расписание = ПараметрыЗадания.Расписание;
		КонецЕсли;
		
		Задание.Записать();
		
	КонецЕсли;
	
	Возврат Задание;
	
КонецФункции

// Удаляет РегламентноеЗадание из информационной базы.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  не предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание, которое нужно получить
//                  уникальный идентификатор для получения свежей копии регламентного задания.
//
Процедура УдалитьЗадание(Знач Идентификатор) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
			
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
			
			Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
				ИмяМетода = Идентификатор.ИмяМетода;
				ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
			ИначеЕсли ТипЗнч(Идентификатор) = Тип("УникальныйИдентификатор") Тогда
				МодульОчередьЗаданийСлужебный = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийСлужебный");
				СправочникДляЗадания = МодульОчередьЗаданийСлужебный.СправочникОчередьЗаданий();
				
				Если ОбщегоНазначенияПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
					МодульОчередьЗаданийСлужебныйРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийСлужебныйРазделениеДанных");
					ПереопределенныйСправочник = МодульОчередьЗаданийСлужебныйРазделениеДанных.ПриВыбореСправочникаДляЗадания(ПараметрыЗадания);
					Если ПереопределенныйСправочник <> Неопределено Тогда
						СправочникДляЗадания = ПереопределенныйСправочник;
					КонецЕсли;
				КонецЕсли;
				
				ПараметрыЗадания.Вставить("Идентификатор", СправочникДляЗадания.ПолучитьСсылку(Идентификатор));
				
			ИначеЕсли ТипЗнч(Идентификатор) = Тип("СтрокаТаблицыЗначений") Тогда
				
				МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
				МодульОчередьЗаданий.УдалитьЗадание(Идентификатор.Идентификатор);
				Возврат;
				
			Иначе
				ПараметрыЗадания.Вставить("Идентификатор", Идентификатор);
			КонецЕсли;
			
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Для Каждого Задание Из СписокЗаданий Цикл
				МодульОчередьЗаданий.УдалитьЗадание(Задание.Идентификатор);
			КонецЦикла;
		КонецЕсли;
	Иначе
		Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И Идентификатор.Предопределенное Тогда
			ВызватьИсключение( НСтр("ru = 'Предопределенное регламентное задание удалить невозможно.'") );
		ИначеЕсли ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И НЕ Идентификатор.Предопределенное Тогда
			СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Метаданные", Идентификатор));
			Для каждого РегламентноеЗадание Из СписокЗаданий Цикл
				РегламентноеЗадание.Удалить();
			КонецЦикла; 
		Иначе
			РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
			Если РегламентноеЗадание <> Неопределено Тогда
				РегламентноеЗадание.Удалить();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Изменяет задание с указанным идентификатором.
// В случае вызова в транзакции на задание устанавливается объектная блокировка.
// 
// Параметры: 
//  Идентификатор - СправочникСсылка.ОчередьЗаданий, СправочникСсылка.ОчередьЗаданийОбластейДанных - Идентификатор задания
//  ПараметрыЗадания - Структура - Параметры, которые следует установить заданию, 
//   возможные ключи:
//   Использование
//   Параметры
//   Ключ
//   ИнтервалПовтораПриАварийномЗавершении.
//   Расписание
//   КоличествоПовторовПриАварийномЗавершении.
//   
//   В случае если задание создано на основе шаблона или предопределенное, могут быть указаны
//   только следующие ключи: Использование.
// 
Процедура ИзменитьЗадание(Знач Идентификатор, Знач ПараметрыЗадания) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			
			ПараметрыПоиска = Новый Структура;
			
			ПараметрыЗадания.Удалить("Наименование");
			Если ПараметрыЗадания.Количество() = 0 Тогда
				Возврат;
			КонецЕсли; 
			
			ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
			ПараметрыПоиска.Вставить("ОбластьДанных", ОбластьДанных);
			
			Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
				ИмяМетода = Идентификатор.ИмяМетода;
				ПараметрыПоиска.Вставить("ИмяМетода", ИмяМетода);
				
				// Если рег.задание предопределенное и есть шаблон очереди - можно изменять только "Использование".
				Если Идентификатор.Предопределенное Тогда
					
					Шаблоны = Новый Массив;
					МодульОчередьЗаданийПереопределяемый = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийПереопределяемый");
					МодульОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов(Шаблоны);
					
					Если Шаблоны.Найти(Идентификатор.Имя) <> Неопределено 
						И (ПараметрыЗадания.Количество() > 1 
						ИЛИ НЕ ПараметрыЗадания.Свойство("Использование")) Тогда
						
						Для каждого ПараметрЗадания Из ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ПараметрыЗадания) Цикл
							
							Если ПараметрЗадания.Ключ = "Использование" Тогда
								Продолжить;
							КонецЕсли;
							
							ПараметрыЗадания.Удалить(ПараметрЗадания.Ключ);
						КонецЦикла;
					КонецЕсли;
				КонецЕсли;
				
			ИначеЕсли ТипЗнч(Идентификатор) = Тип("УникальныйИдентификатор") Тогда
				МодульОчередьЗаданийСлужебный = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийСлужебный");
				СправочникДляЗадания = МодульОчередьЗаданийСлужебный.СправочникОчередьЗаданий();
				
				Если ОбщегоНазначенияПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
					МодульОчередьЗаданийСлужебныйРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийСлужебныйРазделениеДанных");
					ПереопределенныйСправочник = МодульОчередьЗаданийСлужебныйРазделениеДанных.ПриВыбореСправочникаДляЗадания(ПараметрыПоиска);
					Если ПереопределенныйСправочник <> Неопределено Тогда
						СправочникДляЗадания = ПереопределенныйСправочник;
					КонецЕсли;
				КонецЕсли;
				
				ПараметрыПоиска.Вставить("Идентификатор", СправочникДляЗадания.ПолучитьСсылку(Идентификатор));
				
			ИначеЕсли ТипЗнч(Идентификатор) = Тип("СтрокаТаблицыЗначений") Тогда
				
				Если ЗначениеЗаполнено(Идентификатор.Шаблон)
					И (ПараметрыЗадания.Количество() > 1 
					ИЛИ НЕ ПараметрыЗадания.Свойство("Использование")) Тогда
					
					Для Каждого ПараметрЗадания Из ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ПараметрыЗадания) Цикл
						
						Если ПараметрЗадания.Ключ = "Использование" Тогда
							Продолжить;
						КонецЕсли;
						
						ПараметрыЗадания.Удалить(ПараметрЗадания.Ключ);
					КонецЦикла;
				КонецЕсли;
				
				Если ПараметрыЗадания.Количество() = 0 Тогда
					Возврат;
				КонецЕсли;
				
				МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
				МодульОчередьЗаданий.ИзменитьЗадание(Идентификатор.Идентификатор, ПараметрыЗадания);
				Возврат;
				
			Иначе
				ПараметрыПоиска.Вставить("Идентификатор", Идентификатор);
			КонецЕсли;
			
			Если ПараметрыЗадания.Количество() = 0 Тогда
				Возврат;
			КонецЕсли;
			
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыПоиска);
			Для Каждого Задание Из СписокЗаданий Цикл
				МодульОчередьЗаданий.ИзменитьЗадание(Задание.Идентификатор, ПараметрыЗадания);
			КонецЦикла;
		КонецЕсли;
		
	Иначе
		
		Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
		Если Задание <> Неопределено Тогда
			
			Если ПараметрыЗадания.Свойство("Наименование") Тогда
				Задание.Наименование = ПараметрыЗадания.Наименование;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("Использование") Тогда
				Задание.Использование = ПараметрыЗадания.Использование;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("Ключ") Тогда
				Задание.Ключ = ПараметрыЗадания.Ключ;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("ИмяПользователя") Тогда
				Задание.ИмяПользователя = ПараметрыЗадания.ИмяПользователя;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("ИнтервалПовтораПриАварийномЗавершении") Тогда
				Задание.ИнтервалПовтораПриАварийномЗавершении = ПараметрыЗадания.ИнтервалПовтораПриАварийномЗавершении;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("КоличествоПовторовПриАварийномЗавершении") Тогда
				Задание.КоличествоПовторовПриАварийномЗавершении = ПараметрыЗадания.КоличествоПовторовПриАварийномЗавершении;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("Параметры") Тогда
				Задание.Параметры = ПараметрыЗадания.Параметры;
			КонецЕсли;
			
			Если ПараметрыЗадания.Свойство("Расписание") Тогда
				Задание.Расписание = ПараметрыЗадания.Расписание;
			КонецЕсли;
			
			Задание.Записать();
		
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает уникальный идентификатор регламентного задания.
//  Перед вызовом требуется иметь право Администрирования или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
// Возвращаемое значение:
//  УникальныйИдентификатор - УИ объекта регламентного задания.
// 
Функция УникальныйИдентификатор(Знач Идентификатор) Экспорт
	
	Если ТипЗнч(Идентификатор) = Тип("УникальныйИдентификатор") Тогда
		Возврат Идентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Возврат Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Возврат Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		ПараметрыЗадания = Новый Структура;
		
		ИдентификаторТипЗнч = ТипЗнч(Идентификатор);
		
		Если ИдентификаторТипЗнч = Тип("ОбъектМетаданных") Тогда
			ИмяМетода = Идентификатор.ИмяМетода;
			ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
		ИначеЕсли ИдентификаторТипЗнч = Тип("СтрокаТаблицыЗначений") Тогда
			Возврат Идентификатор.Идентификатор.УникальныйИдентификатор();
		ИначеЕсли ОбщегоНазначения.ЭтоСсылка(ИдентификаторТипЗнч) Тогда
			Возврат Идентификатор.УникальныйИдентификатор();
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
		ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Для Каждого Задание Из СписокЗаданий Цикл
				Возврат Задание.Идентификатор.УникальныйИдентификатор();
			КонецЦикла;
		КонецЕсли;
	Иначе
		Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И Идентификатор.Предопределенное Тогда
			Возврат РегламентныеЗадания.НайтиПредопределенное(Идентификатор).УникальныйИдентификатор;
		ИначеЕсли ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И НЕ Идентификатор.Предопределенное Тогда
			СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Метаданные", Идентификатор));
			Для каждого РегламентноеЗадание Из СписокЗаданий Цикл
				Возврат РегламентноеЗадание.УникальныйИдентификатор;
			КонецЦикла; 
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции без поддержки модели сервиса.

// Возвращает использование регламентного задания.
//  Перед вызовом требуется иметь право Администрирования или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
// Возвращаемое значение:
//  Булево - если Истина, регламентное задание используется.
// 
Функция РегламентноеЗаданиеИспользуется(Знач Идентификатор) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Возврат Задание.Использование;
	
КонецФункции

// Возвращает расписание регламентного задания.
//  Перед вызовом требуется иметь право Администрирования или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
//  ВСтруктуре    - Булево - если Истина, тогда расписание будет преобразовано
//                  в структуру, которую можно передать на клиент.
// 
// Возвращаемое значение:
//  РасписаниеРегламентногоЗадания, Структура - структура содержит те же свойства, что и расписание.
// 
Функция РасписаниеРегламентногоЗадания(Знач Идентификатор, Знач ВСтруктуре = Ложь) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Если ВСтруктуре Тогда
		Возврат ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Задание.Расписание);
	КонецЕсли;
	
	Возврат Задание.Расписание;
	
КонецФункции

// Устанавливает использование регламентного задания.
//  Перед вызовом требуется иметь право Администрирования или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
// Использование  - Булево - значение использования которое нужно установить.
// 
Процедура УстановитьИспользованиеРегламентногоЗадания(Знач Идентификатор, Знач Использование) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Если Задание.Использование <> Использование Тогда
		Задание.Использование = Использование;
	КонецЕсли;
	
	Задание.Записать();
	
КонецПроцедуры

// Устанавливает расписание регламентного задания.
//  Перед вызовом требуется иметь право Администрирования или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
//  Расписание    - РасписаниеРегламентногоЗадания - расписание.
//                - Структура - значение возвращаемое функцией РасписаниеВСтруктуру
//                  общего модуля ОбщегоНазначенияКлиентСервер.
// 
Процедура УстановитьРасписаниеРегламентногоЗадания(Знач Идентификатор, Знач Расписание) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Если ТипЗнч(Расписание) = Тип("РасписаниеРегламентногоЗадания") Тогда
		Задание.Расписание = Расписание;
	Иначе
		Задание.Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание);
	КонецЕсли;
	
	Задание.Записать();
	
КонецПроцедуры

// Возвращает РегламентноеЗадание из информационной базы.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание из которого нужно получить
//                  уникальный идентификатор для получения свежей копии регламентного задания.
// 
// Возвращаемое значение:
//  РегламентноеЗадание - прочитано из базы данных.
//
Функция ПолучитьРегламентноеЗадание(Знач Идентификатор) Экспорт
	
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
		РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Идентификатор);
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	КонецЕсли;
	
	Если РегламентноеЗадание = Неопределено Тогда
		ВызватьИсключение( НСтр("ru = 'Регламентное задание не найдено.
		                              |Возможно, оно удалено другим пользователем.'") );
	КонецЕсли;
	
	Возврат РегламентноеЗадание;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции.

// Возвращает признак установленной блокировки работы с внешними ресурсами.
//
// Возвращаемое значение:
//   Булево   - Истина, если работа с внешними ресурсами заблокирована.
//
Функция РаботаСВнешнимиРесурсамиЗаблокирована() Экспорт
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		МодульРегламентныеЗаданияСлужебный = ОбщегоНазначения.ОбщийМодуль("РегламентныеЗаданияСлужебный");
		Возврат МодульРегламентныеЗаданияСлужебный.РаботаСВнешнимиРесурсамиЗаблокирована();
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

// Разрешает работу с внешними ресурсами.
//
Процедура РазблокироватьРаботуСВнешнимиРесурсами() Экспорт
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		МодульРегламентныеЗаданияСлужебный = ОбщегоНазначения.ОбщийМодуль("РегламентныеЗаданияСлужебный");
		МодульРегламентныеЗаданияСлужебный.РазрешитьРаботуСВнешнимиРесурсами();
	КонецЕсли;
КонецПроцедуры

// Запрещает работу с внешними ресурсами.
//
Процедура ЗаблокироватьРаботуСВнешнимиРесурсами() Экспорт
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		МодульРегламентныеЗаданияСлужебный = ОбщегоНазначения.ОбщийМодуль("РегламентныеЗаданияСлужебный");
		МодульРегламентныеЗаданияСлужебный.ЗапретитьРаботуСВнешнимиРесурсами();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывает исключение, если у пользователя нет права администрирования.
Процедура ВызватьИсключениеЕслиНетПраваАдминистрирования()
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
			ВызватьИсключение НСтр("ru = 'Нарушение прав доступа.'");
		КонецЕсли;
	Иначе
		Если НЕ ПривилегированныйРежим() Тогда
			ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти