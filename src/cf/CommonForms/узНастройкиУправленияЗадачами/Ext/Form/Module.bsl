﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	узИспользоватьУчетВремени = Константы.узИспользоватьУчетВремени.Получить();
	узИспользоватьВопросыИОтветы = Константы.узИспользоватьВопросыИОтветы.Получить();
	узИспользоватьСвоиЦветаДляЗадач = Константы.узИспользоватьСвоиЦветаДляЗадач.Получить();
	узРегистрироватьАктивностьПользователей = Константы.узРегистрироватьАктивностьПользователей.Получить();
	узПоказыватьАктивностьПользователяНаРабочемСтоле = Константы.узПоказыватьАктивностьПользователяНаРабочемСтоле.Получить();
	
	ВыполнитьЛокализацию();
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЛокализацию()
	МассивКодовСообщений = Новый Массив();
	МассивКодовСообщений.Добавить(66);//Настройки основные
	
	РегистрыСведений.узСловарь.ВыполнитьЛокализацию(Элементы,МассивКодовСообщений);
КонецПроцедуры //ВыполнитьЛокализацию()

&НаКлиенте
Процедура узИспользоватьУчетВремениПриИзменении(Элемент)
	узИспользоватьУчетВремениПриИзмененииНаСервере();	
	ОбновитьИнтерфейс();
КонецПроцедуры

&НаСервере
Процедура узИспользоватьУчетВремениПриИзмененииНаСервере()
	Константы.узИспользоватьУчетВремени.Установить(узИспользоватьУчетВремени);
КонецПроцедуры 

&НаСервере
Процедура узИспользоватьВопросыИОтветыПриИзмененииНаСервере()
	Константы.узИспользоватьВопросыИОтветы.Установить(узИспользоватьВопросыИОтветы);
КонецПроцедуры

&НаКлиенте
Процедура узИспользоватьВопросыИОтветыПриИзменении(Элемент)
	узИспользоватьВопросыИОтветыПриИзмененииНаСервере();
	ОбновитьИнтерфейс();
КонецПроцедуры

&НаКлиенте
Процедура узИспользоватьСвоиЦветаДляЗадачПриИзменении(Элемент)
	узИспользоватьСвоиЦветаДляЗадачПриИзмененииНаСервере();	
	ОбновитьИнтерфейс();
	Оповестить("Константа.ИспользоватьСвоиЦветаДляЗадач.Записана");
КонецПроцедуры

&НаСервере
Процедура узИспользоватьСвоиЦветаДляЗадачПриИзмененииНаСервере()
	Константы.узИспользоватьСвоиЦветаДляЗадач.Установить(узИспользоватьСвоиЦветаДляЗадач);	
КонецПроцедуры 

&НаКлиенте
Процедура КонстантыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаСервере
Процедура узПоказыватьАктивностьПользователяНаРабочемСтолеПриИзмененииНаСервере()
	Константы.узПоказыватьАктивностьПользователяНаРабочемСтоле.Установить(узПоказыватьАктивностьПользователяНаРабочемСтоле);
КонецПроцедуры

&НаКлиенте
Процедура узПоказыватьАктивностьПользователяНаРабочемСтолеПриИзменении(Элемент)
	узПоказыватьАктивностьПользователяНаРабочемСтолеПриИзмененииНаСервере();
	ОбновитьИнтерфейс();
КонецПроцедуры

&НаСервере
Процедура узРегистрироватьАктивностьПользователейПриИзмененииНаСервере()
	Константы.узПоказыватьАктивностьПользователяНаРабочемСтоле.Установить(узПоказыватьАктивностьПользователяНаРабочемСтоле);
	Константы.узРегистрироватьАктивностьПользователей.Установить(узРегистрироватьАктивностьПользователей);
КонецПроцедуры

&НаКлиенте
Процедура узРегистрироватьАктивностьПользователейПриИзменении(Элемент)
	Если узРегистрироватьАктивностьПользователей = Ложь Тогда
		узПоказыватьАктивностьПользователяНаРабочемСтоле = Ложь;
	Конецесли;
	узРегистрироватьАктивностьПользователейПриИзмененииНаСервере();
	ОбновитьИнтерфейс();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
КонецПроцедуры
