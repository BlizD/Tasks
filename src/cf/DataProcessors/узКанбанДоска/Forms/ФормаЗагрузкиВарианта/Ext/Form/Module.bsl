﻿
#Область ОбработчикиСобытийФормы

// [+] #283 Мальков М.В. 2023-01-30
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ИнициализироватьФормуНаСервере(Отказ, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// [+] #283 Мальков М.В. 2023-01-30
&НаКлиенте
Процедура СписокВариантовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры    

// [+] #283 Мальков М.В. 2023-01-30
&НаКлиенте
Процедура СписокВариантовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ЗагрузитьНаКлиенте();
КонецПроцедуры

// [+] #283 Мальков М.В. 2023-01-30
&НаКлиенте
Процедура УдалитьВариантКоманда(Команда)
	
	ТекущиеДанные 	= Элементы.СписокВариантов.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда 
		УдалитьВариантНаСервере(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// [+] #283 Мальков М.В. 2023-01-30
&НаКлиенте
Процедура ЗагрузитьКоманда(Команда)
	ЗагрузитьНаКлиенте();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// [+] #283 Мальков М.В. 2023-01-30
&НаСервере
Процедура ИнициализироватьФормуНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ОсновнойКлючВарианта", ОсновнойКлючВарианта);
	
	СписокВариантов = Обработки.узКанбанДоска.ПолучитьСписокВариантов(ОсновнойКлючВарианта);
	
КонецПроцедуры

// [+] #283 Мальков М.В. 2023-01-30
&НаКлиенте
Процедура ЗагрузитьНаКлиенте()
		
	ТекущиеДанные 	= Элементы.СписокВариантов.ТекущиеДанные;
	Вариант			= "";
	
	Если ТекущиеДанные <> Неопределено Тогда 
		Вариант = ТекущиеДанные.Значение;	
	КонецЕсли;	
	
	Закрыть(Вариант);

КонецПроцедуры

// [+] #283 Мальков М.В. 2023-01-30
&НаСервере
Процедура УдалитьВариантНаСервере(ТекущиеДанные)
	
	Пользователь	= Пользователи.ТекущийПользователь();
	
	ХранилищеОбщихНастроек.Удалить(ТекущиеДанные.Значение, ТекущиеДанные.Значение, "" + Пользователь);
	СписокВариантов = Обработки.узКанбанДоска.ПолучитьСписокВариантов(ОсновнойКлючВарианта);

КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти