//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2025 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область ПрограммныйИнтерфейс

// Добавляет пояснение возникшей ошибки, которое будет добавлено в отчет.
// Используется перед выбросом исключения, чтобы добавить полезной информации об ошибке, но при этом не ломать стек.
// 
// Параметры:
//  Пояснение - Строка - Пояснение
Процедура ДобавитьПояснениеОшибки(Пояснение) Экспорт
	
	ЮТРегистрацияОшибокСлужебный.ДобавитьПояснениеОшибки(Пояснение);
	
КонецПроцедуры

// Фрмирует сообщение об ошибки.
// 
// Параметры:
//  Описание - Строка - Префикс текста ошибки
//  Ошибка - Строка, ИнформацияОбОшибке - Ошибка
// 
// Возвращаемое значение:
//  Строка
Функция ПредставлениеОшибки(Описание, Ошибка = Неопределено) Экспорт
	
	Возврат ЮТРегистрацияОшибокСлужебный.ПредставлениеОшибки(Описание, Ошибка);
	
КонецФункции

#КонецОбласти
