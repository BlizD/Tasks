//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
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

#Область СлужебныйПрограммныйИнтерфейс

// Получает список из словаря с учетом установленной локализации
//
// Параметры:
//  ИмяРеализации - Строка - Имя реализации
//  ИмяСловаря - Строка - Имя словаря
//  КодЛокализации - Строка - Код локализации
//
// Возвращаемое значение:
//	ФиксированныйМассив из Строка
Функция Словарь(ИмяРеализации, ИмяСловаря, КодЛокализации) Экспорт
	Кодификатор = КодификаторСловаря(ИмяРеализации, ИмяСловаря, КодЛокализации);
	Возврат Новый ФиксированныйМассив(ЮТПодражательСлужебныйВызовСервера.ДанныеСловаря(Кодификатор));
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КодификаторСловаря(ИмяРеализации, ИмяСловаря, КодЛокализации)
	Возврат СтрШаблон(
		"ЮТ_СловарьПодражателя_%1_%2_%3",
		ИмяРеализации,
		ИмяСловаря,
		КодЛокализации
	);
КонецФункции

#КонецОбласти
