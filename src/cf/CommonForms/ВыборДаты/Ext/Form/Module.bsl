﻿&НаКлиенте
Перем ДействиеВыбрано;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ДействиеВыбрано = Ложь;
	
	НачальноеЗначение = Параметры.НачальноеЗначение;
	
	Если Не ЗначениеЗаполнено(НачальноеЗначение) Тогда
		НачальноеЗначение = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Параметры.Свойство("НачалоПериодаОтображения", Элементы.Календарь.НачалоПериодаОтображения);
	Параметры.Свойство("КонецПериодаОтображения", Элементы.Календарь.КонецПериодаОтображения);
	
	Календарь = НачальноеЗначение;
	
	Параметры.Свойство("Заголовок", Заголовок);
	
	Если Параметры.Свойство("ПоясняющийТекст") Тогда
		Элементы.ПоясняющийТекст.Заголовок = Параметры.ПоясняющийТекст;
	Иначе
		Элементы.ПоясняющийТекст.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ДействиеВыбрано <> Истина Тогда
		ОповеститьОВыборе(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура КалендарьВыбор(Элемент, ВыбраннаяДата)
	
	ДействиеВыбрано = Истина;
	ОповеститьОВыборе(ВыбраннаяДата);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыделенныеДаты = Элементы.Календарь.ВыделенныеДаты;
	
	Если ВыделенныеДаты.Количество() = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Дата не выбрана.'"));
		Возврат;
	КонецЕсли;
	
	ДействиеВыбрано = Истина;
	ОповеститьОВыборе(ВыделенныеДаты[0]);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ДействиеВыбрано = Истина;
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

#КонецОбласти

