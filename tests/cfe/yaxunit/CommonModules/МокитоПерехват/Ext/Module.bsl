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

#Область ПрограммныйИнтерфейс

// Анализ вызова.
// 
// Параметры:
//  Объект - Произвольный
//  ИмяМетода - Произвольный
//  ПараметрыМетода - Произвольный
//  ПрерватьВыполнение - Произвольный
// 
// Возвращаемое значение:
//  Произвольный - Подменный результат работы метода
Функция АнализВызова(Объект, ИмяМетода, ПараметрыМетода, ПрерватьВыполнение) Экспорт
	
	Возврат МокитоСлужебный.АнализВызова(Объект, ИмяМетода, ПараметрыМетода, ПрерватьВыполнение);
	
КонецФункции

#КонецОбласти
