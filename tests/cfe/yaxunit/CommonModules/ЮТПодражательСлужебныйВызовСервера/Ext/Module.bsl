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

// Данные словаря.
//
// Параметры:
//  Кодификатор - Строка - Имя словаря в метаданных
//
// Возвращаемое значение:
//  ФиксированныйМассив из Строка
Функция ДанныеСловаря(Кодификатор) Экспорт
	Если Метаданные.ОбщиеМакеты.Найти(Кодификатор) = Неопределено Тогда
		ВызватьИсключение СтрШаблон("Словарь с именем (%1) не найден", Кодификатор);
	КонецЕсли;
	
	Макет = ПолучитьОбщийМакет(Кодификатор);
	Возврат СтрРазделить(Макет.ПолучитьТекст(), Символы.ПС, Ложь);
	
КонецФункции

#КонецОбласти
