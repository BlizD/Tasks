﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Серверные процедуры и функции общего назначения:
// - Поддержка профилей безопасности.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при проверке возможности использования профилей безопасности.
//
// Параметры:
//  Отказ - Булево - если конфигурация не адаптирована к использованию
//   профилей безопасности, значение параметра в данной процедуры необходимо
//   установить равным Истина.
//
Процедура ПриПроверкеВозможностиИспользованияПрофилейБезопасности(Отказ) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при проверке возможности настройки профилей безопасности.
//
// Параметры:
//  Отказ - Булево. Если для информационной базы недоступно использование профилей безопасности -
//    значение данного параметра нужно установить равным Истина.
//
Процедура ПриПроверкеВозможностиНастройкиПрофилейБезопасности(Отказ) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при включении использования для информационной базы профилей безопасности.
//
Процедура ПриВключенииИспользованияПрофилейБезопасности() Экспорт
	
	
	
КонецПроцедуры

// Заполняет перечень запросов внешних разрешений, которые обязательно должны быть предоставлены
// при создании информационной базы или обновлении программы.
//
// Параметры:
//  ЗапросыРазрешений - Массив - список значений, возвращенных функцией.
//                      РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов().
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при создании запроса разрешений на использование внешних ресурсов.
//
// Параметры:
//  ПрограммныйМодуль - ЛюбаяСсылка - ссылка на объект информационной базы, представляющий программный
//    модуль, для которого выполняется запрос разрешений,
//  Владелец - ЛюбаяСсылка - ссылка на объект информационной базы, представляющий объект-владелец запрашиваемых
//    разрешений на использование внешних ресурсов,
//  РежимЗамещения - Булево - флаг замещения ранее предоставленных разрешений по владельцу,
//  ДобавляемыеРазрешения - Массив(ОбъектXDTO) - массив добавляемых разрешений,
//  УдаляемыеРазрешения - Массив(ОбъектXDTO) - массив удаляемых разрешений,
//  СтандартнаяОбработка - Булево, флаг выполнения стандартной обработки создания запроса на использование
//    внешних ресурсов.
//  Результат - УникальныйИдентификатор - идентификатор запроса (в том случае, если внутри обработчика
//    значение параметра СтандартнаяОбработка установлено в значение Ложь).
//
Процедура ПриЗапросеРазрешенийНаИспользованиеВнешнихРесурсов(Знач ПрограммныйМодуль, Знач Владелец, Знач РежимЗамещения, 
	Знач ДобавляемыеРазрешения, Знач УдаляемыеРазрешения, СтандартнаяОбработка, Результат) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при запросе создания профиля безопасности.
//
// Параметры:
//  ПрограммныйМодуль - ЛюбаяСсылка - ссылка на объект информационной базы, представляющий программный
//    модуль, для которого выполняется запрос разрешений,
//  СтандартнаяОбработка - Булево, флаг выполнения стандартной обработки,
//  Результат - УникальныйИдентификатор - идентификатор запроса (в том случае, если внутри обработчика
//    значение параметра СтандартнаяОбработка установлено в значение Ложь).
//
Процедура ПриЗапросеСозданияПрофиляБезопасности(Знач ПрограммныйМодуль, СтандартнаяОбработка, Результат) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при запросе удаления профиля безопасности.
//
// Параметры:
//  ПрограммныйМодуль - ЛюбаяСсылка - ссылка на объект информационной базы, представляющий программный
//    модуль, для которого выполняется запрос разрешений,
//  СтандартнаяОбработка - Булево, флаг выполнения стандартной обработки,
//  Результат - УникальныйИдентификатор - идентификатор запроса (в том случае, если внутри обработчика
//    значение параметра СтандартнаяОбработка установлено в значение Ложь).
//
Процедура ПриЗапросеУдаленияПрофиляБезопасности(Знач ПрограммныйМодуль, СтандартнаяОбработка, Результат) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при подключении внешнего модуля. В теле процедуры-обработчика может быть изменен
// безопасный режим, в котором будет выполняться подключение.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка - ссылка на объект информационной базы, представляющий подключаемый
//    внешний модуль,
//  БезопасныйРежим - ОпределяемыйТип.БезопасныйРежим - безопасный режим, в котором внешний
//    модуль будет подключен к информационной базе. Может быть изменен внутри данной процедуры.
//
Процедура ПриПодключенииВнешнегоМодуля(Знач ВнешнийМодуль, БезопасныйРежим) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти