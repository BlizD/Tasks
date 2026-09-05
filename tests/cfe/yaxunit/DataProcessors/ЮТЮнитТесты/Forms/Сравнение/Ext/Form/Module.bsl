//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2023 BIA-Technologies Limited Liability Company
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

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекстСтраницы = Обработки.ЮТЮнитТесты.ПолучитьМакет("СравнениеOld").ПолучитьТекст();
	
	ТекстСтраницы = СтрЗаменить(ТекстСтраницы, "ИсходныйТекст", Параметры.ОжидаемоеЗначение);
	ТекстСтраницы = СтрЗаменить(ТекстСтраницы, "СравниваемыйТекст", Параметры.ФактическоеЗначение);
	
	АдресСтраницы = ПоместитьВоВременноеХранилище(ПолучитьДвоичныеДанныеИзСтроки(ТекстСтраницы), УникальныйИдентификатор);
	Скрипт = СтрШаблон("%1/%2", ПолучитьНавигационнуюСсылкуИнформационнойБазы(), АдресСтраницы); 
	
КонецПроцедуры

#КонецОбласти
