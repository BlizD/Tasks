﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Перем ЭлементОтбораАвтор;
	//
	//ПолеКомпоновкиДанных_Автор = Новый ПолеКомпоновкиДанных("Автор");
	//Для каждого ЭлементОтбора из Список.Отбор.Элементы цикл
	//	Если ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновкиДанных_Автор Тогда
	//		ЭлементОтбораАвтор = ЭлементОтбора;	
	//	Конецесли;
	//Конеццикла;
	//Если ЭлементОтбораАвтор = Неопределено Тогда
	//	ЭлементОтбораАвтор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//	ЭлементОтбораАвтор.ЛевоеЗначение = ПолеКомпоновкиДанных_Автор;
	//Конецесли;
	//ЭлементОтбораАвтор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	//ЭлементОтбораАвтор.ПравоеЗначение = ПараметрыСеанса.ТекущийПользователь;
КонецПроцедуры
