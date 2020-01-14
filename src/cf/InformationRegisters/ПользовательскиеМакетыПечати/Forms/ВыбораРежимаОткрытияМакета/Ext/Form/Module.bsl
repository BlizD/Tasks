﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Значение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкаОткрытияМакетов", 
		"СпрашиватьРежимОткрытияМакета");
	
	Если Значение = Неопределено Тогда
		БольшеНеСпрашивать = Ложь;
	Иначе
		БольшеНеСпрашивать = НЕ Значение;
	КонецЕсли;
	
	Значение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкаОткрытияМакетов", 
		"РежимОткрытияМакетаПросмотр");
	
	Если Значение = Неопределено Тогда
		КакОткрывать = 0;
	Иначе
		Если Значение Тогда
			КакОткрывать = 0;
		Иначе
			КакОткрывать = 1;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СпрашиватьРежимОткрытияМакета = НЕ БольшеНеСпрашивать;
	РежимОткрытияМакетаПросмотр = ?(КакОткрывать = 0, Истина, Ложь);
	
	СохранитьНастройкиРежимаОткрытияМакета(СпрашиватьРежимОткрытияМакета, РежимОткрытияМакетаПросмотр);
	
	ОповеститьОВыборе(Новый Структура("БольшеНеСпрашивать, РежимОткрытияПросмотр",
							БольшеНеСпрашивать,
							РежимОткрытияМакетаПросмотр) );
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СохранитьНастройкиРежимаОткрытияМакета(СпрашиватьРежимОткрытияМакета, РежимОткрытияМакетаПросмотр)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"НастройкаОткрытияМакетов", 
		"СпрашиватьРежимОткрытияМакета", 
		СпрашиватьРежимОткрытияМакета);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"НастройкаОткрытияМакетов", 
		"РежимОткрытияМакетаПросмотр", 
		РежимОткрытияМакетаПросмотр);
	
КонецПроцедуры

#КонецОбласти
