﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Аутентификация = СтандартныеПодсистемыСервер.ПараметрыАутентификацииНаСайте();
	Если Аутентификация <> Неопределено Тогда
		Логин  = Аутентификация.Логин;
		Если ЗначениеЗаполнено(Аутентификация.Пароль) Тогда
			Пароль = ЭтотОбъект.УникальныйИдентификатор;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.ЗапомнитьПароль Тогда
		Элементы.ЗапомнитьПароль.Видимость = Ложь;
		ЗапомнитьПароль = Истина;
	Иначе
		ЗапомнитьПароль = Не ПустаяСтрока(Пароль);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПерейтиКРегистрацииНаСайтеНажатие(Элемент)
	
	ПерейтиПоНавигационнойСсылке("http://users.v8.1c.ru/");
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	ПарольИзменен = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьДанныеАутентификацииИПродолжить()
	
	Если ПустаяСтрока(Логин) И Не ПустаяСтрока(Пароль) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введите код пользователя для авторизации на сайте фирмы ""1С"".'"),, "Логин");
		Возврат;
	КонецЕсли;
		
	Если ПустаяСтрока(Логин) Тогда
		СохранитьДанныеАутентификации(Неопределено, Ложь, Ложь);
		Результат = КодВозвратаДиалога.Отмена;
	Иначе
		ОписаниеОшибки = "";
		ЛогинИПароль = Новый Структура("Логин,Пароль", Логин, Пароль);
		СохранитьДанныеАутентификации(ЛогинИПароль, ПарольИзменен, ЗапомнитьПароль, ОписаниеОшибки);
		
		Если НЕ ПустаяСтрока(ОписаниеОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки,, "Логин");
			Возврат;
		КонецЕсли;
		Результат = Новый Структура("Логин,Пароль", ЛогинИПароль.Логин, ЛогинИПароль.Пароль);
	КонецЕсли;
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СохранитьДанныеАутентификации(Аутентификация, ПарольИзменен, ЗапомнитьПароль, ОписаниеОшибки = "")
	
	Если Аутентификация = Неопределено Тогда
		СтандартныеПодсистемыСервер.СохранитьПараметрыАутентификацииНаСайте(Аутентификация);
		Возврат;
	КонецЕсли;
	
	Если НЕ ПарольИзменен Тогда
		ПредыдущаяАутентификация = СтандартныеПодсистемыСервер.ПараметрыАутентификацииНаСайте();
		Если ПредыдущаяАутентификация <> Неопределено Тогда
			Аутентификация.Пароль = ПредыдущаяАутентификация.Пароль;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗапомнитьПароль Тогда
		СтандартныеПодсистемыСервер.СохранитьПараметрыАутентификацииНаСайте(Аутентификация);
	Иначе
		АутентификацияДляСохранения  = Новый Структура("Логин, Пароль", Аутентификация.Логин, Неопределено);
		СтандартныеПодсистемыСервер.СохранитьПараметрыАутентификацииНаСайте(АутентификацияДляСохранения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
