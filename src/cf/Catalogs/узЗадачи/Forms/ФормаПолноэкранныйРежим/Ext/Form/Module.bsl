﻿
&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	РезультатЗакрытия = Новый Структура();
	РезультатЗакрытия.Вставить("ФорматированныйТекст",ФорматированныйТекст);
	Закрыть(РезультатЗакрытия);	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПолноэкранныйРежим(Команда)
	РезультатЗакрытия = Новый Структура();
	РезультатЗакрытия.Вставить("ФорматированныйТекст",ФорматированныйТекст);
	Закрыть(РезультатЗакрытия);	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ФорматированныйТекст = Параметры.ФорматированныйТекст;
	Заголовок = Параметры.ЗаголовокФормы;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//WSHShell = Новый COMОбъект("WScript.Shell");
	//WSHShell.SendKeys("%");
	//WSHShell.SendKeys("{LEFT}{LEFT}{ENTER}");
КонецПроцедуры

