﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.РежимОтладки Тогда
			
			ИдентификаторПланаОбмена = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.ПланыОбмена[Запись.ИмяПланаОбмена]);
			ИмяПрофиляБезопасности = РаботаВБезопасномРежимеСлужебный.РежимПодключенияВнешнегоМодуля(ИдентификаторПланаОбмена);
			
			Если ИмяПрофиляБезопасности <> Неопределено Тогда
				УстановитьБезопасныйРежим(ИмяПрофиляБезопасности);
			КонецЕсли;
			
			ЭтоФайловаяБаза = ОбщегоНазначения.ИнформационнаяБазаФайловая();
			
			Если Запись.РежимОтладкиВыгрузки Тогда
				
				ПроверитьСуществованиеФайлаВнешнейОбработки(Запись.ИмяФайлаОбработкиДляОтладкиВыгрузки, ЭтоФайловаяБаза, Отказ);
				
			КонецЕсли;
			
			Если Запись.РежимОтладкиЗагрузки Тогда
				
				ПроверитьСуществованиеФайлаВнешнейОбработки(Запись.ИмяФайлаОбработкиДляОтладкиЗагрузки, ЭтоФайловаяБаза, Отказ);
				
			КонецЕсли;
			
			Если Запись.РежимПротоколированияОбменаДанными Тогда
				
				ПроверитьДоступностьФайлаПротоколаОбмена(Запись.ИмяФайлаПротоколаОбмена, Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьСуществованиеФайлаВнешнейОбработки(ИмяПроверяемогоФайла, ЭтоФайловаяБаза, Отказ)
	
	СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяПроверяемогоФайла);
	ИмяФайла = СтруктураИмениФайла.ИмяБезРасширения;
	ИмяКаталогаПроверки	 = СтруктураИмениФайла.Путь;
	КаталогПроверки = Новый Файл(ИмяКаталогаПроверки);
	ФайлНаДиске = Новый Файл(ИмяПроверяемогоФайла);
	РасположениеКаталога = ? (ЭтоФайловаяБаза, НСтр("ru = 'на клиенте'"), НСтр("ru = 'на сервере'"));
	
	Если Не КаталогПроверки.Существует() Тогда
		
		СтрокаСообщения = НСтр("ru = 'Каталог ""%1"" не найден %2.'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ИмяКаталогаПроверки, РасположениеКаталога);
		Отказ = Истина;
		
	ИначеЕсли Не ФайлНаДиске.Существует() Тогда 
		
		СтрокаСообщения = НСтр("ru = 'Файл внешней обработки ""%1"" не найден %2.'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ИмяПроверяемогоФайла, РасположениеКаталога);
		Отказ = Истина;
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,,,, Отказ);
	
КонецПроцедуры

Процедура ПроверитьДоступностьФайлаПротоколаОбмена(ИмяФайлаПротоколаОбмена, Отказ)
	
	СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаПротоколаОбмена);
	ИмяКаталогаПроверки = СтруктураИмениФайла.Путь;
	КаталогПроверки = Новый Файл(ИмяКаталогаПроверки);
	ИмяФайлаПроверки = "test.tmp";
	
	Если Не КаталогПроверки.Существует() Тогда
		
		СтрокаСообщения = НСтр("ru = 'Каталог файла протокола обмена ""%1"" не найден.'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ИмяКаталогаПроверки);
		Отказ = Истина;
		
	ИначеЕсли Не СоздатьФайлПроверки(ИмяКаталогаПроверки, ИмяФайлаПроверки) Тогда
		
		СтрокаСообщения = НСтр("ru = 'Не удалось создать файл в папке протокола обмена: ""%1"".'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ИмяКаталогаПроверки);
		Отказ = Истина;
		
	ИначеЕсли Не УдалитьФайлПроверки(ИмяКаталогаПроверки, ИмяФайлаПроверки) Тогда
		
		СтрокаСообщения = НСтр("ru = 'Не удалось удалить файл в папке протокола обмена: ""%1"".'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ИмяКаталогаПроверки);
		Отказ = Истина;
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,,,, Отказ);
	
КонецПроцедуры

Функция СоздатьФайлПроверки(ИмяКаталогаПроверки, ИмяФайлаПроверки)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.ДобавитьСтроку(НСтр("ru = 'Временный файл проверки'"));
	
	Попытка
		ТекстовыйДокумент.Записать(ИмяКаталогаПроверки + "/" + ИмяФайлаПроверки);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция УдалитьФайлПроверки(ИмяКаталогаПроверки, ИмяФайлаПроверки)
	
	Попытка
		УдалитьФайлы(ИмяКаталогаПроверки, ИмяФайлаПроверки);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецЕсли