﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Если Не ДополнительныеСвойства.Свойство("ПропуститьОбновлениеВерсииДатЗапретаИзменения") Тогда
			ДатыЗапретаИзмененияСлужебный.ОбновитьВерсиюДатЗапретаИзмененияПриЗагрузкеДанных(ЭтотОбъект);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("ПропуститьОбновлениеВерсииДатЗапретаИзменения") Тогда
		ДатыЗапретаИзмененияСлужебный.ОбновитьВерсиюДатЗапретаИзменения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
