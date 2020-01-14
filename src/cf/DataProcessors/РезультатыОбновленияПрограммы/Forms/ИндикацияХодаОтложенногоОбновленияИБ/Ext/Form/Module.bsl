﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыПереопределяемый.ПриПолученииПоясненияДляРезультатовОбновленияПрограммы(ТекстПодсказки);
	
	Если Не ПустаяСтрока(ТекстПодсказки) Тогда
		Элементы.ИнформацияПодсказка.Заголовок = ТекстПодсказки;
		Элементы.ПодсказкаГдеНайтиЭтуФорму.Заголовок = ТекстПодсказки;
		Элементы.ИнформацияПодсказкаРасположениеФормы.Заголовок = ТекстПодсказки;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		
		Элементы.ГруппаПодсказкаПроПериодНаименьшейАктивностиПользователей.Видимость = Ложь;
		Элементы.ПодсказкаГдеНайтиЭтуФорму.Заголовок = 
			НСтр("ru = 'Ход обработки данных версии программы можно также проконтролировать из раздела
		               |""Информация"" на рабочем столе, команда ""Описание изменений программы"".'");
		
	КонецЕсли;
	
	// Зачитываем значение констант.
	СведенияОбОбновлении = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
	ПриоритетОбновления = ?(СведенияОбОбновлении.УправлениеОтложеннымОбновлением.Свойство("ФорсироватьОбновление"), "ОбработкаДанных", "РаботаПользователей");
	ВремяОкончанияОбновления = СведенияОбОбновлении.ВремяОкончанияОбновления;
	
	ВремяНачалаОтложенногоОбновления = СведенияОбОбновлении.ВремяНачалаОтложенногоОбновления;
	ВремяОкончаниеОтложенногоОбновления = СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	Если ЗначениеЗаполнено(ВремяОкончанияОбновления) Тогда
		Элементы.ИнформацияОбновлениеЗавершено.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ИнформацияОбновлениеЗавершено.Заголовок,
			Метаданные.Версия,
			Формат(ВремяОкончанияОбновления, "ДЛФ=D"),
			Формат(ВремяОкончанияОбновления, "ДЛФ=T"),
			СведенияОбОбновлении.ПродолжительностьОбновления);
	Иначе
		ЗаголовокОбновлениеЗавершено = НСтр("ru = 'Версия программы успешно обновлена на версию %1'");
		Элементы.ИнформацияОбновлениеЗавершено.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокОбновлениеЗавершено, Метаданные.Версия);
	КонецЕсли;
	
	Если СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления = Неопределено Тогда
		
		Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
			Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.СтатусОбновленияДляПользователя;
		Иначе
			
			Если Не ИБФайловая И СведенияОбОбновлении.ОтложенноеОбновлениеЗавершеноУспешно = Неопределено Тогда
				Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеВыполняется;
			Иначе
				Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеВФайловойБазе;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		ТекстСообщения = СообщениеОРезультатахОбновления(СведенияОбОбновлении);
		Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеЗавершено;
		
		СведенияОбОбновлении = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
		ШаблонЗаголовка = НСтр("ru = 'Дополнительные процедуры обработки данных завершены %1 в %2'");
		Элементы.ИнформацияОтложенноеОбновлениеЗавершено1.Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, 
			Формат(СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления, "ДЛФ=D"),
			Формат(СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления, "ДЛФ=T"));
		
	КонецЕсли;
	
	Если Не ИБФайловая Тогда
		ОбновлениеЗавершено = Ложь;
		ОбновитьИнформациюОХодеОбновления(СведенияОбОбновлении, ОбновлениеЗавершено);
		
		Если ОбновлениеЗавершено Тогда
			ОбновитьСтраницуОбновлениеЗавершено(СведенияОбОбновлении);
			Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеЗавершено;
			Возврат;
		КонецЕсли;
		
	Иначе
		Элементы.ИнформацияСтатусОбновления.Видимость = Ложь;
		Элементы.ИзменитьРасписание.Видимость         = Ложь;
	КонецЕсли;
	
	Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			Элементы.ГруппаНастройкаРасписания.Видимость = Ложь;
		Иначе
			Расписание = РегламентныеЗадания.НайтиПредопределенное(
				Метаданные.РегламентныеЗадания.ОтложенноеОбновлениеИБ).Расписание;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Элементы.ГиперссылкаОсновноеОбновление.Видимость = Ложь;
		Элементы.ПриоритетОбновления.Видимость           = Ложь;
	КонецЕсли;
	
	СкрытьЛишниеГруппыНаФорме(Параметры.ОткрытиеИзПанелиАдминистрирования);
	
	Элементы.ОткрытьСписокОтложенныхОбработчиков.Заголовок = ТекстСообщения;
	Элементы.ЗаголовокИнформации.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполняются дополнительные процедуры обработки данных на версию %1
			|Работа с этими данными временно ограничена'"), Метаданные.Версия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИБФайловая Тогда
		ПодключитьОбработчикОжидания("ПроверитьСтатусВыполненияОбработчиков", 15);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтложенноеОбновление" Тогда
		
		Если Не ИБФайловая Тогда
			Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеВыполняется;
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("ЗапуститьОтложенноеОбновление", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияСтатусОбновленияНажатие(Элемент)
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ОтложенныеОбработчики");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаОсновноеОбновлениеНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаНачала", ВремяНачалаОтложенногоОбновления);
	Если ВремяОкончаниеОтложенногоОбновления <> Неопределено Тогда
		ПараметрыФормы.Вставить("ДатаОкончания", ВремяОкончаниеОтложенногоОбновления);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриоритетОбновленияПриИзменении(Элемент)
	УстановитьПриоритетОбновления();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбновление(Команда)
	
	Если Не ИБФайловая Тогда
		Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеВыполняется;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ЗапуститьОтложенноеОбновление", 0.5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокОтложенныхОбработчиков(Команда)
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ОтложенныеОбработчики");
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписание(Команда)
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеПослеУстановкиРасписания", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьБлокировкуРегламентныхЗаданий(Команда)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		МодульСоединенияИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СоединенияИБКлиент");
		МодульСоединенияИБКлиент.ПриОткрытииФормыБлокировкиРаботыПользователей();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СкрытьЛишниеГруппыНаФорме(ОткрытиеИзПанелиАдминистрирования)
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь(, Истина);
	
	Если Не ЭтоПолноправныйПользователь Или ОткрытиеИзПанелиАдминистрирования Тогда
		КлючСохраненияПоложенияОкна = "ФормаДляОбычногоПользователя";
		
		Элементы.ГруппаПодсказкаРасположениеФормы.Видимость = Ложь;
		Элементы.ГруппаПодсказкаРасположениеФормыПриОбновлении.Видимость = Ложь;
		Элементы.ИнформацияПодсказкаРасположениеФормы.Видимость = Ложь;
		Элементы.ОтступОбновлениеЗавершено.Видимость = Ложь;
		
		Если Не Пользователи.РолиДоступны("ПросмотрЖурналаРегистрации") Тогда
			Элементы.ГиперссылкаОсновноеОбновление.Видимость = Ложь;
		КонецЕсли;
		
	Иначе
		КлючСохраненияПоложенияОкна = "ФормаДляАдминистратора";
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		Элементы.СнятьБлокировкуРегламентныхЗаданий.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПриоритетОбновления()
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.СведенияОбОбновленииИБ");
		Блокировка.Заблокировать();
		
		СведенияОбОбновлении = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
		Если ПриоритетОбновления = "ОбработкаДанных" Тогда
			СведенияОбОбновлении.УправлениеОтложеннымОбновлением.Вставить("ФорсироватьОбновление");
		Иначе
			СведенияОбОбновлении.УправлениеОтложеннымОбновлением.Удалить("ФорсироватьОбновление");
		КонецЕсли;
		
		ОбновлениеИнформационнойБазыСлужебный.ЗаписатьСведенияОбОбновленииИнформационнойБазы(СведенияОбОбновлении);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОтложенноеОбновление()
	
	ВыполнитьОбновлениеНаСервере();
	Если Не ИБФайловая Тогда
		ПодключитьОбработчикОжидания("ПроверитьСтатусВыполненияОбработчиков", 15);
		Возврат;
	КонецЕсли;
	
	Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеЗавершено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСтатусВыполненияОбработчиков()
	
	ОбновлениеЗавершено = Ложь;
	ПроверитьСтатусВыполненияОбработчиковНаСервере(ОбновлениеЗавершено);
	Если ОбновлениеЗавершено Тогда
		Элементы.СтатусОбновления.ТекущаяСтраница = Элементы.ОбновлениеЗавершено;
		ОтключитьОбработчикОжидания("ПроверитьСтатусВыполненияОбработчиков")
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСтатусВыполненияОбработчиковНаСервере(ОбновлениеЗавершено)
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
	Если СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления <> Неопределено Тогда
		ОбновлениеЗавершено = Истина;
	Иначе
		ОбновитьИнформациюОХодеОбновления(СведенияОбОбновлении, ОбновлениеЗавершено);
	КонецЕсли;
	
	Если ОбновлениеЗавершено = Истина Тогда
		ОбновитьСтраницуОбновлениеЗавершено(СведенияОбОбновлении);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОбновлениеНаСервере()
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
	
	СведенияОбОбновлении.ОтложенноеОбновлениеЗавершеноУспешно = Неопределено;
	СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления = Неопределено;
	Для Каждого СтрокаДереваБиблиотека Из СведенияОбОбновлении.ДеревоОбработчиков.Строки Цикл
		Для Каждого СтрокаДереваВерсия Из СтрокаДереваБиблиотека.Строки Цикл
			Для Каждого Обработчик Из СтрокаДереваВерсия.Строки Цикл
				Обработчик.ЧислоПопыток = 0;
				Если Обработчик.Статус = "Ошибка" Тогда
					Обработчик.СтатистикаВыполнения.Очистить();
					Обработчик.Статус = "НеВыполнено";
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого ЦиклОбновления Из СведенияОбОбновлении.ПланОтложенногоОбновления Цикл
		Если ЦиклОбновления.Свойство("ЗавершеноСОшибками") Тогда
			ЦиклОбновления.Удалить("ЗавершеноСОшибками");
		КонецЕсли;
	КонецЦикла;
	
	ОбновлениеИнформационнойБазыСлужебный.ЗаписатьСведенияОбОбновленииИнформационнойБазы(СведенияОбОбновлении);
	
	Если Не ИБФайловая Тогда
		
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			ОбновлениеИнформационнойБазыСлужебный.ПриВключенииОтложенногоОбновления(Истина);
		Иначе
			РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОтложенноеОбновлениеИБ);
			РегламентноеЗадание.Использование = Истина;
			РегламентноеЗадание.Записать();
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыСлужебный.ВыполнитьОтложенноеОбновлениеСейчас(Неопределено);
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
	ОбновитьСтраницуОбновлениеЗавершено(СведенияОбОбновлении);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтраницуОбновлениеЗавершено(СведенияОбОбновлении)
	
	ШаблонЗаголовка = НСтр("ru = 'Дополнительные процедуры обработки данных завершены %1 в %2'");
	ТекстСообщения = СообщениеОРезультатахОбновления(СведенияОбОбновлении);
	
	Элементы.ИнформацияОтложенноеОбновлениеЗавершено1.Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, 
			Формат(СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления, "ДЛФ=D"),
			Формат(СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления, "ДЛФ=T"));
	
	Элементы.ОткрытьСписокОтложенныхОбработчиков.Заголовок = ТекстСообщения;
	
	ВремяОкончаниеОтложенногоОбновления = СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления;
	
КонецПроцедуры

&НаСервере
Функция СообщениеОРезультатахОбновления(СведенияОбОбновлении)
	
	СписокОбработчиков = СведенияОбОбновлении.ДеревоОбработчиков;
	УспешноВыполненоОбработчиков = 0;
	ВсегоОбработчиков            = 0;
	Для Каждого СтрокаДереваБиблиотека Из СведенияОбОбновлении.ДеревоОбработчиков.Строки Цикл
		Для Каждого СтрокаДереваВерсия Из СтрокаДереваБиблиотека.Строки Цикл
			ВсегоОбработчиков = ВсегоОбработчиков + СтрокаДереваВерсия.Строки.Количество();
			Для Каждого Обработчик Из СтрокаДереваВерсия.Строки Цикл
				
				Если Обработчик.Статус = "Выполнено" Тогда
					УспешноВыполненоОбработчиков = УспешноВыполненоОбработчиков + 1;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Если ВсегоОбработчиков = УспешноВыполненоОбработчиков Тогда
		
		Если ВсегоОбработчиков = 0 Тогда
			Элементы.ИнформацияОтложенныеОбработчикиОтсутствуют.Видимость = Истина;
			Элементы.ГруппаПереходКСпискуОтложенныхОбработчиков.Видимость = Ложь;
			ТекстСообщения = "";
		Иначе
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Все процедуры обновления выполнены успешно (%1)'"), УспешноВыполненоОбработчиков);
		КонецЕсли;
		Элементы.КартинкаИнформация1.Картинка = БиблиотекаКартинок.Успешно32;
	Иначе
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не все процедуры удалось выполнить (выполнено %1 из %2)'"), 
			УспешноВыполненоОбработчиков, ВсегоОбработчиков);
		Элементы.КартинкаИнформация1.Картинка = БиблиотекаКартинок.Ошибка32;
	КонецЕсли;
	Возврат ТекстСообщения;
	
КонецФункции

&НаСервере
Процедура ОбновитьИнформациюОХодеОбновления(СведенияОбОбновлении, ОбновлениеЗавершено = Ложь)
	
	ВыполненоОбработчиков = 0;
	ВсегоОбработчиков     = 0;
	Для Каждого СтрокаДереваБиблиотека Из СведенияОбОбновлении.ДеревоОбработчиков.Строки Цикл
		Для Каждого СтрокаДереваВерсия Из СтрокаДереваБиблиотека.Строки Цикл
			ВсегоОбработчиков = ВсегоОбработчиков + СтрокаДереваВерсия.Строки.Количество();
			Для Каждого Обработчик Из СтрокаДереваВерсия.Строки Цикл
				
				Если Обработчик.Статус = "Выполнено" Тогда
					ВыполненоОбработчиков = ВыполненоОбработчиков + 1;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Если ВсегоОбработчиков = 0 Тогда
		ОбновлениеЗавершено = Истина;
	КонецЕсли;
	
	Элементы.ИнформацияСтатусОбновления.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполнено: %1 из %2'"),
		ВыполненоОбработчиков,
		ВсегоОбработчиков);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРасписаниеОтложенногоОбновления(НовоеРасписание)
	
	РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОтложенноеОбновлениеИБ);
	РегламентноеЗадание.Расписание = НовоеРасписание;
	РегламентноеЗадание.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеПослеУстановкиРасписания(НовоеРасписание, ДополнительныеПараметры) Экспорт
	
	Если НовоеРасписание <> Неопределено Тогда
		Если НовоеРасписание.ПериодПовтораВТечениеДня = 0 Тогда
			Оповещение = Новый ОписаниеОповещения("ИзменитьРасписаниеПослеВопроса", ЭтотОбъект, НовоеРасписание);
			
			КнопкиВопроса = Новый СписокЗначений;
			КнопкиВопроса.Добавить("НастроитьРасписание", НСтр("ru = 'Настроить расписание'"));
			КнопкиВопроса.Добавить("РекомендуемыеНастройки", НСтр("ru = 'Установить рекомендуемые настройки'"));
			
			ТекстСообщения = НСтр("ru = 'Дополнительные процедуры обработки данных выполняются небольшими порциями,
				|поэтому для их корректной работы необходимо обязательно задать интервал повтора после завершения.
				|
				|Для этого в окне настройки расписания необходимо перейти на вкладку ""Дневное""
				|и заполнить поле ""Повторять через"".'");
			ПоказатьВопрос(Оповещение, ТекстСообщения, КнопкиВопроса,, "НастроитьРасписание");
		Иначе
			УстановитьРасписаниеОтложенногоОбновления(НовоеРасписание);
		КонецЕсли;
	КонецЕсли;
	
	Расписание = НовоеРасписание;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеПослеВопроса(Результат, НовоеРасписание) Экспорт
	
	Если Результат = "РекомендуемыеНастройки" Тогда
		НовоеРасписание.ПериодПовтораВТечениеДня = 60;
		НовоеРасписание.ПаузаПовтора = 60;
		УстановитьРасписаниеОтложенногоОбновления(НовоеРасписание);
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеПослеУстановкиРасписания", ЭтотОбъект);
		Диалог = Новый ДиалогРасписанияРегламентногоЗадания(НовоеРасписание);
		Диалог.Показать(ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
