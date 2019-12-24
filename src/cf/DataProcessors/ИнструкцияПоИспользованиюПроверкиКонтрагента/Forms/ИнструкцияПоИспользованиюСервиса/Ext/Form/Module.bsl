
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеСервиса = ПолучитьОбщийМакет("ИнструкцияПоПроверкеКонтрагентов").ПолучитьТекст();
	
	Если НЕ ПроверкаКонтрагентов.ТестовыйРежимРаботыСервисаЗавершился() Тогда
		ОписаниеСервиса = СтрЗаменить(ОписаниеСервиса, "<!--сообщение про тестовый режим-->",  
			"<DIV><P style=""BORDER-LEFT-WIDTH: 0px; BORDER-RIGHT-WIDTH: 0px; WIDTH: 1462px; WHITE-SPACE: normal; BORDER-BOTTOM-WIDTH: 0px; 
			|WORD-SPACING: 0px; TEXT-TRANSFORM: none; COLOR: rgb(0,0,0); PADDING-BOTTOM: 15px; PADDING-TOP: 15px; FONT: 13px Verdana; 
			|PADDING-LEFT: 15px; LETTER-SPACING: normal; PADDING-RIGHT: 15px; BORDER-TOP-WIDTH: 0px; BACKGROUND-COLOR: rgb(255,238,238); 
			|TEXT-INDENT: 0px; -webkit-text-stroke-width: 0px""><FONT size=2><STRONG>ВАЖНО!<BR></STRONG>В настоящее время сервис ФНС функционирует в тестовом режиме.</FONT> </P></DIV>");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти