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

#Если Сервер Тогда

#Область ОписаниеПеременных

//@skip-check object-module-export-variable
Var HTTPMethod Export;
//@skip-check object-module-export-variable
Var BaseURL Export;
//@skip-check object-module-export-variable
Var Headers Export;
//@skip-check object-module-export-variable
Var RelativeURL Export;
//@skip-check object-module-export-variable
Var URLParameters Export;
//@skip-check object-module-export-variable
Var QueryOptions Export;

Var Body;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Возвращает тело HTTP-запроса в виде двоичных данных.
// Преобразует тело запроса, если оно было установлено как строка.
// Если тело не установлено, возвращает пустые двоичные данные.
//
// Возвращаемое значение:
//  ДвоичныеДанные - Тело запроса в виде двоичных данных.
//
// Пример:
//  Запрос = ЮТест.Данные().HTTPСервисЗапрос();
//  Запрос.УстановитьТелоКакСтроку("Тестовые данные");
//  ДанныеКакБайты = Запрос.GetBodyAsBinaryData();
//  // ДанныеКакБайты теперь содержит двоичные данные строки "Тестовые данные"
//
Function GetBodyAsBinaryData() Export
	
	BodyType = TypeOf(Body);
	
	If Body = Undefined Then
		Return GetBinaryDataFromBase64String("");
	ElsIf BodyType = Type("BinaryData") Then
		Return Body;
	ElsIf BodyType = Type("String") Then
		Return GetBinaryDataFromString(Body);
	EndIf;
	
EndFunction

// Возвращает тело HTTP-запроса как поток для чтения.
// Удобно использовать для работы с большими объемами данных.
//
// Возвращаемое значение:
//  Поток - Тело запроса, представленное в виде потока.
//
// Пример:
//  Запрос = ЮТест.Данные().HTTPСервисЗапрос();
//  Запрос.УстановитьТелоКакДвоичныеДанные(МоиДвоичныеДанные);
//  ПотокТела = Запрос.GetBodyAsStream();
//  Пока ПотокТела.Прочитать(...) > 0 Цикл
//    // чтение данных из потока
//  КонецЦикла;
//  ПотокТела.Закрыть();
//
Function GetBodyAsStream() Export
	
	Return GetBodyAsBinaryData().OpenStreamForRead();
	
EndFunction

// Возвращает тело HTTP-запроса как строку.
// Позволяет указать кодировку для корректного преобразования двоичных данных в строку.
// Если тело изначально было строкой, возвращает его без изменений.
// Если тело не установлено, возвращает пустую строку.
//
// Параметры:
//  Encoding - КодировкаТекста, Строка, Неопределено - Кодировка для преобразования тела в строку.
//             Можно указать объект КодировкаТекста (например, КодировкаТекста.UTF8)
//             или имя кодировки строкой (например, "UTF-8").
//             Если Неопределено, используется кодировка по умолчанию (UTF-8).
//
// Возвращаемое значение:
//  Строка - Тело запроса в виде строки.
//
// Пример:
//  Запрос = ЮТест.Данные().HTTPСервисЗапрос();
//  ДвоичныеДанныеИзФайла = ПолучитьДвоичныеДанныеИзСтроки("Данные в windows-1251", КодировкаТекста.ANSI);
//  Запрос.УстановитьТелоКакДвоичныеДанные(ДвоичныеДанныеИзФайла);
//  ТекстовоеПредставление = Запрос.GetBodyAsString("windows-1251");
//  // ТекстовоеПредставление будет содержать "Данные в windows-1251"
//
Function GetBodyAsString(Encoding = Undefined) Export
	
	BodyType = TypeOf(Body);
	
	If Body = Undefined Then
		Return "";
	ElsIf BodyType = Тип("BinaryData") Then
		Return GetStringFromBinaryData(Body, Encoding);
	ElsIf BodyType = Тип("String") Then
		Return Body;
	EndIf;
	
EndFunction

// Устанавливает тело HTTP-запроса из двоичных данных.
// Если тело запроса было ранее установлено в другом формате (например, строка), оно будет заменено.
//
// Параметры:
//  Data - ДвоичныеДанные - Двоичные данные, которые будут установлены как тело запроса.
//
// Возвращаемое значение:
//  DataProcessors.ЮТHTTPServiceRequest - Текущий объект запроса для возможности цепочки вызовов.
//
// Пример:
//  Запрос = ЮТест.Данные().HTTPСервисЗапрос();
//  ФайлДанных = Новый Файл("C:\payload.bin");
//  Запрос.УстановитьТелоКакДвоичныеДанные(ФайлДанных.ПолучитьДвоичныеДанные());
//
Function УстановитьТелоКакДвоичныеДанные(Data) Export
	
	Body = Data;
	Return ThisObject;
	
EndFunction

// Устанавливает тело HTTP-запроса из строки.
// Если тело запроса было ранее установлено в другом формате (например, двоичные данные), оно будет заменено.
//
// Параметры:
//  String - Строка - Строковое представление тела запроса.
//
// Возвращаемое значение:
//  DataProcessors.ЮТHTTPServiceRequest - Текущий объект запроса для возможности цепочки вызовов.
//
// Пример:
//  Запрос = ЮТест.Данные().HTTPСервисЗапрос();
//  Запрос.УстановитьТелоКакСтроку("<soap:Envelope>...</soap:Envelope>");
//
Function УстановитьТелоКакСтроку(String) Export
	
	Body = String;
	Return ThisObject;
	
EndFunction

// Устанавливает тело HTTP-запроса как строку JSON, сериализуя переданные данные.
// Сериализует предоставленные данные (например, Структура, Массив, Соответствие) в формат JSON
// и устанавливает результат как тело запроса. Если тело было установлено ранее, оно заменяется.
// Рекомендуется также установить заголовок "Content-Type" в "application/json".
//
// Параметры:
//  Data - Произвольный - Данные для сериализации в JSON (например, Структура, Массив, Соответствие).
//
// Возвращаемое значение:
//  DataProcessors.ЮТHTTPServiceRequest - Текущий объект запроса для возможности цепочки вызовов.
//
// Пример:
//  Запрос = ЮТест.Данные().HTTPСервисЗапрос();
//  СтруктураДляJSON = Новый Структура("ключ, значение", "тест", 123);
//  Запрос.УстановитьТелоКакСтрокуJSON(СтруктураДляJSON)
//    .ДобавитьЗаголовок("Content-Type", "application/json");
//
Function УстановитьТелоКакСтрокуJSON(Data) Export
	
	JSONWriter = Новый JSONWriter();
	JSONWriter.SetString();
	WriteJSON(JSONWriter, Data);
	
	Body = JSONWriter.Close();
	
	Return ThisObject;
	
EndFunction

// Добавляет HTTP-заголовок к запросу.
// Если заголовок с указанным именем уже существует, его значение будет перезаписано новым.
//
// Параметры:
//  HeaderName - Строка - Имя HTTP-заголовка (например, "Content-Type", "Authorization", "Accept").
//  Value - Строка - Значение HTTP-заголовка.
//
// Возвращаемое значение:
//  DataProcessors.ЮТHTTPServiceRequest - Текущий объект запроса для возможности цепочки вызовов.
//
// Пример:
//  Запрос = ЮТест.Данные().HTTPСервисЗапрос();
//  Запрос.ДобавитьЗаголовок("Accept", "application/xml")
//         .ДобавитьЗаголовок("X-Custom-Header", "MyValue");
//
Function ДобавитьЗаголовок(HeaderName, Value) Export
	
	Headers.Insert(HeaderName, Value);
	Return ThisObject;
	
EndFunction

// Добавляет параметр в строку запроса (query string).
// Параметры URL (query parameters) добавляются к URL после символа "?" и разделяются символом "&".
// Например, для URL "http://example.com/api/items" добавление параметра "filter" со значением "active"
// сформирует URL "http://example.com/api/items?filter=active".
//
// Параметры:
//  ParameterName - Строка - Имя параметра строки запроса (например, "filter", "limit", "page").
//  Value - Строка - Значение параметра строки запроса.
//
// Возвращаемое значение:
//  DataProcessors.ЮТHTTPServiceRequest - Текущий объект запроса для возможности цепочки вызовов.
//
// Пример:
//  Запрос = ЮТест.Данные().HTTPСервисЗапрос();
//  Запрос.БазовыйURL("http://example.com/api/items")
//         .ДобавитьПараметрЗапроса("filter", "active")
//         .ДобавитьПараметрЗапроса("limit", "10");
//  // Сформированный URL будет примерно: http://example.com/api/items?filter=active&limit=10
//
Function ДобавитьПараметрЗапроса(ParameterName, Value) Export
	
	QueryOptions.Insert(ParameterName, Value);
	Return ThisObject;
	
EndFunction

// Добавляет параметр для подстановки в путь URL (path parameter).
// Используется для формирования URL с динамическими сегментами пути.
// Имена параметров должны соответствовать плейсхолдерам, указанным в ОтносительныйURL
// (например, если ОтносительныйURL = "/users/{userId}/posts/{postId}", то имена параметров
// должны быть "userId" и "postId" без фигурных скобок).
//
// Параметры:
//  ParameterName - Строка - Имя параметра пути (должно совпадать с плейсхолдером в ОтносительныйURL, без фигурных скобок).
//  Value - Строка - Значение параметра пути для подстановки в URL.
//
// Возвращаемое значение:
//  DataProcessors.ЮТHTTPServiceRequest - Текущий объект запроса для возможности цепочки вызовов.
//
// Пример:
//  Запрос = ЮТест.Данные().HTTPСервисЗапрос();
//  Запрос.БазовыйURL("http://api.example.com")
//         .ОтносительныйURL("/orders/{orderId}/items/{itemId}")
//         .ДобавитьПараметрURL("orderId", "12345")
//         .ДобавитьПараметрURL("itemId", "ABC");
//  // Сформированный URL будет: http://api.example.com/orders/12345/items/ABC
//
Function ДобавитьПараметрURL(ParameterName, Value) Export
	
	URLParameters.Insert(ParameterName, Value);
	Return ThisObject;
	
EndFunction

// Устанавливает HTTP-метод для запроса.
// Определяет тип выполняемого запроса (например, GET для получения данных, POST для создания, PUT для обновления).
//
// Параметры:
//  Value - Строка - Имя HTTP-метода (например, "GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "OPTIONS").
//
// Возвращаемое значение:
//  DataProcessors.ЮТHTTPServiceRequest - Текущий объект запроса для возможности цепочки вызовов.
//
// Пример:
//  Запрос = ЮТест.Данные().HTTPСервисЗапрос();
//  Запрос.Метод("POST");
//
Function Метод(Value) Export
	
	HTTPMethod = Value;
	Return ThisObject;
	
EndFunction

// Устанавливает базовый URL для HTTP-запроса.
// Базовый URL представляет собой основную часть адреса (схема, хост, порт, начальный путь),
// к которой будет добавляться относительный URL (заданный через ОтносительныйURL())
// и параметры запроса (заданные через ДобавитьПараметрЗапроса()).
//
// Параметры:
//  Value - Строка - Базовый URL (например, "http://localhost:8080/api", "https://services.example.com/v1").
//                   Не должен заканчиваться на "/".
//
// Возвращаемое значение:
//  DataProcessors.ЮТHTTPServiceRequest - Текущий объект запроса для возможности цепочки вызовов.
//
// Пример:
//  Запрос = ЮТест.Данные().HTTPСервисЗапрос();
//  Запрос.БазовыйURL("https://api.example.com/production");
//
Function БазовыйURL(Value) Export
	
	BaseURL = Value;
	Return ThisObject;
	
EndFunction

// Устанавливает относительный URL (путь) для HTTP-запроса.
// Этот путь будет добавлен к базовому URL, установленному через БазовыйURL().
// Относительный URL может содержать плейсхолдеры для параметров пути (например, "/resource/{id}"),
// значения для которых задаются с помощью ДобавитьПараметрURL().
//
// Параметры:
//  Value - Строка - Относительный URL (например, "/users", "/items/{itemId}/details").
//                   Должен начинаться с "/".
//
// Возвращаемое значение:
//  DataProcessors.ЮТHTTPServiceRequest - Текущий объект запроса для возможности цепочки вызовов.
//
// Пример:
//  Запрос = ЮТест.Данные().HTTPСервисЗапрос();
//  Запрос.БазовыйURL("http://server.com/api").ОтносительныйURL("/data/export");
//  // Полный URL будет: http://server.com/api/data/export
//
Function ОтносительныйURL(Value) Export
	
	RelativeURL = Value;
	Return ThisObject;
	
EndFunction

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура Initialize()
	
	HTTPMethod = "GET";
	BaseURL = "";
	Headers = New Map();
	RelativeURL = "";
	URLParameters = New Map();
	QueryOptions = New Map();
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

Initialize();

#КонецОбласти

#КонецЕсли
