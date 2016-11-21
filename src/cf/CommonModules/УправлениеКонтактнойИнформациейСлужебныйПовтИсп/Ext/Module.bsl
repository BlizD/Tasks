////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контактная информация".
// 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Определяет наличие доступности подсистемы АдресныйКлассификатор и наличие записей о регионах в регистре сведений
// АдресныеОбъекты.
//
Функция АдресныйКлассификаторДоступен() Экспорт
	ЕстьКлассификатор = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор");
	Если ЕстьКлассификатор И НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		МодульАдресныйКлассификаторСлужебный = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификаторСлужебный");
		ЕстьКлассификатор = МодульАдресныйКлассификаторСлужебный.ПроверитьНачальноеЗаполнение();
	КонецЕсли;
	
	Возврат ЕстьКлассификатор;
КонецФункции

// Преобразование для сравнения двух строк XML.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_ТаблицаЗначенийРазличияXML() Экспорт
	Преобразователь = Новый ПреобразованиеXSL;
	
	// Пространство имен должно быть пустым!
	Преобразователь.ЗагрузитьИзСтроки("
		|<xsl:stylesheet version=""1.0""
		|  xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""
		|  xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""
		|  xmlns:xs=""http://www.w3.org/2001/XMLSchema""
		|
		|  xmlns:str=""http://exslt.org/strings""
		|  xmlns:exsl=""http://exslt.org/common""
		|
		|  extension-element-prefixes=""str exsl""
		|>
		|<xsl:output method=""xml"" omit-xml-declaration=""yes"" indent=""yes"" encoding=""utf-8""/>
		|" + XSLT_ШаблоныСтроковыхФункций() + "
		|" + XSLT_ШаблоныФункцийXPath() + "
		|
		|  <!-- parce tree elements to xpath-value -->
		|  <xsl:template match=""node()"" mode=""action"">
		|    
		|    <xsl:variable name=""text"">
		|      <xsl:call-template name=""str-trim-all"">
		|        <xsl:with-param name=""str"" select=""text()"" />
		|      </xsl:call-template>
		|    </xsl:variable>
		|
		|    <xsl:if test=""$text!=''"">
		|      <xsl:element name=""item"">
		|        <xsl:attribute name=""path"">
		|          <xsl:variable name=""tmp-path"">
		|            <xsl:call-template name=""build-path"" />
		|          </xsl:variable>
		|          <xsl:value-of select=""substring($tmp-path, 6)"" /> <!-- pass '/dn/f' or '/dn/s' -->
		|        </xsl:attribute>
		|        <xsl:attribute name=""value"">
		|          <xsl:value-of select=""text()"" />
		|        </xsl:attribute>
		|      </xsl:element>
		|    </xsl:if>
		|
		|    <xsl:apply-templates select=""@* | node()"" mode=""action""/>
		|  </xsl:template>
		|
		|  <!-- parce tree attributes to xpath-value -->
		|  <xsl:template match=""@*"" mode=""action"">
		|    <xsl:element name=""item"">
		|      <xsl:attribute name=""path"">
		|          <xsl:variable name=""tmp-path"">
		|            <xsl:call-template name=""build-path"" />
		|          </xsl:variable>
		|          <xsl:value-of select=""substring($tmp-path, 6)"" /> <!-- pass '/dn/f' or '/dn/s' -->
		|      </xsl:attribute>
		|      <xsl:attribute name=""value"">
		|        <xsl:value-of select=""."" />
		|      </xsl:attribute>
		|    </xsl:element>
		|  </xsl:template>
		|
		|  <!-- main -->
		|  <xsl:variable name=""dummy"">
		|    <xsl:element name=""first"">
		|      <xsl:apply-templates select=""/dn/f"" mode=""action"" />
		|    </xsl:element> 
		|    <xsl:element name=""second"">
		|      <xsl:apply-templates select=""/dn/s"" mode=""action"" />
		|    </xsl:element>
		|  </xsl:variable>
		|  <xsl:variable name=""dummy-nodeset"" select=""exsl:node-set($dummy)"" />
		|  <xsl:variable name=""first-items"" select=""$dummy-nodeset/first/item"" />
		|  <xsl:variable name=""second-items"" select=""$dummy-nodeset/second/item"" />
		|
		|  <xsl:template match=""/"">
		|    
		|    <!-- first vs second -->
		|    <xsl:variable name=""first-second"">
		|      <xsl:for-each select=""$first-items"">
		|        <xsl:call-template name=""compare"">
		|          <xsl:with-param name=""check"" select=""$second-items"" />
		|        </xsl:call-template>
		|      </xsl:for-each>
		|    </xsl:variable>
		|    <xsl:variable name=""first-second-nodeset"" select=""exsl:node-set($first-second)"" />
		|
		|    <!-- second vs first without doubles -->
		|    <xsl:variable name=""doubles"" select=""$first-second-nodeset/item"" />
		|    <xsl:variable name=""second-first"">
		|      <xsl:for-each select=""$second-items"">
		|        <xsl:call-template name=""compare"">
		|          <xsl:with-param name=""check"" select=""$first-items"" />
		|          <xsl:with-param name=""doubles"" select=""$doubles"" />
		|        </xsl:call-template>
		|      </xsl:for-each>
		|    </xsl:variable>
		|      
		|    <!-- result -->
		|    <ValueTable xmlns=""http://v8.1c.ru/8.1/data/core"" xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xsi:type=""ValueTable"">
		|      <column>
		|        <Name xsi:type=""xs:string"">Путь</Name>
		|        <ValueType>
		|           <Type>xs:string</Type>
		|           <StringQualifiers><Length>0</Length><AllowedLength>Variable</AllowedLength></StringQualifiers>
		|        </ValueType>
		|      </column>
		|      <column>
		|        <Name xsi:type=""xs:string"">Значение1</Name>
		|        <ValueType>
		|           <Type>xs:string</Type>
		|           <StringQualifiers><Length>0</Length><AllowedLength>Variable</AllowedLength></StringQualifiers>
		|        </ValueType>
		|      </column>
		|      <column>
		|        <Name xsi:type=""xs:string"">Значение2</Name>
		|        <ValueType>
		|           <Type>xs:string</Type>
		|           <StringQualifiers><Length>0</Length><AllowedLength>Variable</AllowedLength></StringQualifiers>
		|        </ValueType>
		|      </column>
		|
		|      <xsl:for-each select=""$first-second-nodeset/item | exsl:node-set($second-first)/item"">
		|        <xsl:element name=""row"">
		|           <xsl:element name=""Value"">
		|             <xsl:value-of select=""@path""/>
		|           </xsl:element>
		|           <xsl:element name=""Value"">
		|             <xsl:value-of select=""@value1""/>
		|           </xsl:element>
		|           <xsl:element name=""Value"">
		|             <xsl:value-of select=""@value2""/>
		|           </xsl:element>
		|        </xsl:element>
		|      </xsl:for-each>
		|
		|    </ValueTable>
		|
		|  </xsl:template>
		|  <!-- /main -->
		|
		|  <!-- compare sub -->
		|  <xsl:template name=""compare"">
		|    <xsl:param name=""check"" />
		|    <xsl:param name=""doubles"" select=""/.."" />
		|    
		|    <xsl:variable name=""path""  select=""@path""/>
		|    <xsl:variable name=""value"" select=""@value""/>
		|    <xsl:variable name=""diff""  select=""$check[@path=$path]""/>
		|    <xsl:choose>
		|      <xsl:when test=""count($diff)=0"">
		|        <xsl:if test=""count($doubles[@path=$path and @value1='' and @value2=$value])=0"">
		|          <xsl:element name=""item"">
		|            <xsl:attribute name=""path"">   <xsl:value-of select=""$path""/> </xsl:attribute>
		|            <xsl:attribute name=""value1""> <xsl:value-of select=""$value""/> </xsl:attribute>
		|            <xsl:attribute name=""value2"" />
		|          </xsl:element>
		|        </xsl:if>
		|      </xsl:when>
		|      <xsl:otherwise>
		|
		|        <xsl:for-each select=""$diff[@value!=$value]"">
		|            <xsl:variable name=""diff-value"" select=""@value""/>
		|            <xsl:if test=""count($doubles[@path=$path and @value1=$diff-value and @value2=$value])=0"">
		|              <xsl:element name=""item"">
		|                <xsl:attribute name=""path"">   <xsl:value-of select=""$path""/>  </xsl:attribute>
		|                <xsl:attribute name=""value1""> <xsl:value-of select=""$value""/> </xsl:attribute>
		|                <xsl:attribute name=""value2""> <xsl:value-of select=""@value""/> </xsl:attribute>
		|              </xsl:element>
		|            </xsl:if>
		|        </xsl:for-each>
		|      </xsl:otherwise>
		|    </xsl:choose>
		|  </xsl:template>
		|  
		|</xsl:stylesheet>
		|");
		
	Возврат Преобразователь;
КонецФункции

// Преобразование для текста с парами Ключ=Значение, разделенных переносами строк (см формат адреса) в XML.
// В случае повторных ключей все включаются в результат, но при десериализации будет использован 
// последний (особенность работы сериализатора платформы).
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_СтрокаКлючЗначениеВСтруктуру() Экспорт
	Преобразователь = Новый ПреобразованиеXSL;
	Преобразователь.ЗагрузитьИзСтроки("
		|<xsl:stylesheet version=""1.0""
		|  xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""
		|  xmlns:str=""http://exslt.org/strings""
		|  extension-element-prefixes=""str""
		|>
		|<xsl:output method=""xml"" omit-xml-declaration=""yes"" indent=""yes"" encoding=""utf-8""/>
		|" + XSLT_ШаблоныСтроковыхФункций() + "
		|
		|  <xsl:template match=""ExternalParamNode"">
		|
		|    <xsl:variable name=""source"">
		|      <xsl:call-template name=""str-replace-all"">
		|        <xsl:with-param name=""str"" select=""."" />
		|        <xsl:with-param name=""search-for"" select=""'&#10;&#09;'"" />
		|        <xsl:with-param name=""replace-by"" select=""'&#13;'"" />
		|      </xsl:call-template>
		|    </xsl:variable>
		|
		|    <Structure xmlns=""http://v8.1c.ru/8.1/data/core"" xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:type=""Structure"">
		|
		|     <xsl:for-each select=""str:tokenize($source, '&#10;')"" >
		|       <xsl:if test=""contains(., '=')"">
		|
		|         <xsl:element name=""Property"">
		|           <xsl:attribute name=""name"" >
		|             <xsl:call-template name=""str-trim-all"">
		|               <xsl:with-param name=""str"" select=""substring-before(., '=')"" />
		|             </xsl:call-template>
		|           </xsl:attribute>
		|
		|           <Value xsi:type=""xs:string"">
		|             <xsl:call-template name=""str-replace-all"">
		|               <xsl:with-param name=""str"" select=""substring-after(., '=')"" />
		|               <xsl:with-param name=""search-for"" select=""'&#13;'"" />
		|               <xsl:with-param name=""replace-by"" select=""'&#10;'"" />
		|             </xsl:call-template>
		|           </Value>
		|
		|         </xsl:element>
		|
		|       </xsl:if>
		|     </xsl:for-each>
		|
		|    </Structure>
		|
		|  </xsl:template>
		|
		|</xsl:stylesheet>
		|");

	Возврат Преобразователь;
КонецФункции

// Преобразование для списка значений в структуру. Представление преобразуется в ключ.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_СписокЗначенийВСтруктуру() Экспорт
	Преобразователь = Новый ПреобразованиеXSL;
	Преобразователь.ЗагрузитьИзСтроки("
		|<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""
		|  xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""
		|  xmlns:tns=""http://v8.1c.ru/8.1/data/core""
		|  xmlns=""http://v8.1c.ru/8.1/data/core""
		|>
		|<xsl:output method=""xml"" omit-xml-declaration=""yes"" indent=""yes"" encoding=""utf-8""/>
		|" + XSLT_ШаблоныСтроковыхФункций() + "
		|
		|  <xsl:template match=""/"">
		|    <Structure xmlns=""http://v8.1c.ru/8.1/data/core"" xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:type=""Structure"">
		|      <xsl:apply-templates select=""//tns:ValueListType/tns:item"" />
		|    </Structure >
		|  </xsl:template>
		|
		|  <xsl:template match=""//tns:ValueListType/tns:item"">
		|    <xsl:element name=""Property"">
		|      <xsl:attribute name=""name"">
		|        <xsl:call-template name=""str-trim-all"">
		|          <xsl:with-param name=""str"" select=""tns:presentation"" />
		|        </xsl:call-template>
		|      </xsl:attribute>
		|
		|      <xsl:element name=""Value"">
		|        <xsl:attribute name=""xsi:type"">
		|          <xsl:value-of select=""tns:value/@xsi:type""/>  
		|        </xsl:attribute>
		|        <xsl:value-of select=""tns:value""/>  
		|      </xsl:element>
		|
		|    </xsl:element>
		|</xsl:template>
		|
		|</xsl:stylesheet>
		|");
	Возврат Преобразователь;
КонецФункции

// Преобразование для соответствия в структуру. Ключ преобразуется в ключ, значение - в значение.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_СоответствиеВСтруктуру() Экспорт
	Преобразователь = Новый ПреобразованиеXSL;
	Преобразователь.ЗагрузитьИзСтроки("
		|<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""
		|  xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""
		|  xmlns:tns=""http://v8.1c.ru/8.1/data/core""
		|  xmlns=""http://v8.1c.ru/8.1/data/core""
		|>
		|<xsl:output method=""xml"" omit-xml-declaration=""yes"" indent=""yes"" encoding=""utf-8""/>
		|" + XSLT_ШаблоныСтроковыхФункций() + "
		|
		|  <xsl:template match=""/"">
		|    <Structure xmlns=""http://v8.1c.ru/8.1/data/core"" xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:type=""Structure"">
		|      <xsl:apply-templates select=""//tns:Map/tns:pair"" />
		|    </Structure >
		|  </xsl:template>
		|  
		|  <xsl:template match=""//tns:Map/tns:pair"">
		|  <xsl:element name=""Property"">
		|    <xsl:attribute name=""name"">
		|      <xsl:call-template name=""str-trim-all"">
		|        <xsl:with-param name=""str"" select=""tns:Key"" />
		|      </xsl:call-template>
		|    </xsl:attribute>
		|  
		|    <xsl:element name=""Value"">
		|      <xsl:attribute name=""xsi:type"">
		|        <xsl:value-of select=""tns:Value/@xsi:type""/>  
		|      </xsl:attribute>
		|        <xsl:value-of select=""tns:Value""/>  
		|      </xsl:element>
		|  
		|    </xsl:element>
		|  </xsl:template>
		|
		|</xsl:stylesheet>
		|");
	Возврат Преобразователь;
КонецФункции

// Убирает описание <?xml...> для включения внутрь другого XML.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_УдалитьОписаниеXML() Экспорт
	Преобразователь = Новый ПреобразованиеXSL;
	Преобразователь.ЗагрузитьИзСтроки("
		|<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform"">
		|<xsl:output method=""xml"" omit-xml-declaration=""yes"" indent=""yes"" encoding=""utf-8""/>
		|  <xsl:template match=""node() | @*"">
		|    <xsl:copy>
		|      <xsl:apply-templates select=""node() | @*"" />
		|    </xsl:copy>
		|  </xsl:template>
		|</xsl:stylesheet>
		|");
	Возврат Преобразователь;
КонецФункции

// Преобразование для контактной информации в виде XML (см пакет XDTO КонтактнаяИнформация) в перечисление
// ТипКонтактнойИнформации.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_ТипКонтактнойИнформацииПоСтрокеXML() Экспорт
	Преобразователь = Новый ПреобразованиеXSL;
	Преобразователь.ЗагрузитьИзСтроки("
		|<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""
		|  xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""
		|  xmlns:ci=""http://www.v8.1c.ru/ssl/contactinfo""
		|>
		|  <xsl:output method=""xml"" omit-xml-declaration=""yes"" indent=""yes"" encoding=""utf-8""/>
		|
		|  <xsl:template match=""/"">
		|    <EnumRef.ТипыКонтактнойИнформации xmlns=""http://v8.1c.ru/8.1/data/enterprise/current-config"" xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:type=""EnumRef.ТипыКонтактнойИнформации"">
		|      <xsl:call-template name=""enum-by-type"" >
		|        <xsl:with-param name=""type"" select=""ci:КонтактнаяИнформация/ci:Состав/@xsi:type"" />
		|      </xsl:call-template>
		|    </EnumRef.ТипыКонтактнойИнформации>
		|  </xsl:template>
		|
		|  <xsl:template name=""enum-by-type"">
		|    <xsl:param name=""type"" />
		|    <xsl:choose>
		|      <xsl:when test=""$type='Адрес'"">
		|        <xsl:text>Адрес</xsl:text>
		|      </xsl:when>
		|      <xsl:when test=""$type='НомерТелефона'"">
		|        <xsl:text>Телефон</xsl:text>
		|      </xsl:when>
		|      <xsl:when test=""$type='НомерФакса'"">
		|        <xsl:text>Факс</xsl:text>
		|      </xsl:when>
		|      <xsl:when test=""$type='ЭлектроннаяПочта'"">
		|        <xsl:text>АдресЭлектроннойПочты</xsl:text>
		|      </xsl:when>
		|      <xsl:when test=""$type='ВебСайт'"">
		|        <xsl:text>ВебСтраница</xsl:text>
		|      </xsl:when>
		|      <xsl:when test=""$type='Прочее'"">
		|        <xsl:text>Другое</xsl:text>
		|      </xsl:when>
		|    </xsl:choose>
		|  </xsl:template>
		|
		|</xsl:stylesheet>
		|");
	Возврат Преобразователь;
КонецФункции

// Преобразование для таблицы различий XML в зависимости от типа контактной информации.
//
// Параметры:
//    ТипКонтактнойИнформации - Строка, ПеречислениеСсылка.ТипыКонтактнойИнформации - имя или значение перечисления.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_ИнтерпретацияРазличияXMLКонтактнойИнформации(Знач ТипКонтактнойИнформации) Экспорт
	
	Если ТипЗнч(ТипКонтактнойИнформации) <> Тип("Строка") Тогда
		ТипКонтактнойИнформации = ТипКонтактнойИнформации.Метаданные().Имя;
	КонецЕсли;
	
	Преобразователь = Новый ПреобразованиеXSL;
	Преобразователь.ЗагрузитьИзСтроки("
		|<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""
		|  xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""
		|  xmlns:ci=""http://www.v8.1c.ru/ssl/contactinfo""
		|>
		|<xsl:output method=""xml"" omit-xml-declaration=""yes"" indent=""yes"" encoding=""utf-8""/>
		|  <xsl:param name=""target-type"" select=""'" + ТипКонтактнойИнформации + "'""/>
		|
		|  <xsl:template match=""/"">
		|    <xsl:choose>
		|      <xsl:when test=""$target-type='Адрес'"">
		|         <xsl:apply-templates select=""."" mode=""action-address""/>
		|      </xsl:when>
		|      <xsl:otherwise>
		|         <xsl:apply-templates select=""."" mode=""action-copy""/>
		|      </xsl:otherwise>
		|    </xsl:choose>
		|  </xsl:template>
		|
		|  <xsl:template match=""node() | @*"" mode=""action-copy"">
		|    <xsl:copy>
		|      <xsl:apply-templates select=""node() | @*"" mode=""action-copy""/>
		|    </xsl:copy>
		|  </xsl:template>
		|
		|  <xsl:template match=""node() | @*"" mode=""action-address"">
		|    <xsl:copy>
		|      <xsl:apply-templates select=""node() | @*"" mode=""action-address""/>
		|    </xsl:copy>
		|  </xsl:template>
		|
		|</xsl:stylesheet>
		|");
	Возврат Преобразователь;
КонецФункции

// Возвращает преобразователь XSL для конвертации структуры в контактную информацию в виде XML.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_ПреобразованиеXSL() Экспорт
	
	КодыДополнительныхАдресныхЭлементов = Новый ТекстовыйДокумент;
	Для Каждого ДополнительныйАдресныйЭлемент Из УправлениеКонтактнойИнформациейКлиентСервер.ТипыОбъектовАдресацииАдресаРФ() Цикл
		КодыДополнительныхАдресныхЭлементов.ДобавитьСтроку("<data:item data:title=""" + ДополнительныйАдресныйЭлемент.Наименование + """>" + ДополнительныйАдресныйЭлемент.Код + "</data:item>");
	КонецЦикла;
	
	КодыРегионов = Новый ТекстовыйДокумент;
	ВсеРегионы = УправлениеКонтактнойИнформациейСлужебный.ВсеРегионы();
	Если ВсеРегионы <> Неопределено Тогда
		Для Каждого Строка Из ВсеРегионы Цикл
			КодыРегионов.ДобавитьСтроку("<data:item data:code=""" + Формат(Строка.КодСубъектаРФ, "ЧН=; ЧГ=") + """>" 
				+ Строка.Представление + "</data:item>");
		КонецЦикла;
	КонецЕсли;
	
	Преобразователь = Новый ПреобразованиеXSL;
	Преобразователь.ЗагрузитьИзСтроки("
		|<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""
		|  xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""
		|  xmlns:xs=""http://www.w3.org/2001/XMLSchema""
		|  xmlns:tns=""http://v8.1c.ru/8.1/data/core""
		|  xmlns=""http://www.v8.1c.ru/ssl/contactinfo"" 
		|
		|  xmlns:data=""http://www.v8.1c.ru/ssl/contactinfo""
		|
		|  xmlns:exsl=""http://exslt.org/common""
		|  extension-element-prefixes=""exsl""
		|  exclude-result-prefixes=""data tns""
		|>
		|<xsl:output method=""xml"" omit-xml-declaration=""yes"" indent=""yes"" encoding=""utf-8""/>
		|  " + XSLT_ШаблоныСтроковыхФункций() + "
		|  
		|  <xsl:variable name=""local-country"">РОССИЯ</xsl:variable>
		|
		|  <xsl:variable name=""presentation"" select=""tns:Structure/tns:Property[@name='Представление']/tns:Value/text()"" />
		|  
		|  <xsl:template match=""/"">
		|    <КонтактнаяИнформация>
		|
		|      <xsl:attribute name=""Представление"">
		|        <xsl:value-of select=""$presentation""/>
		|      </xsl:attribute> 
		|      <xsl:element name=""Комментарий"">
		|       <xsl:value-of select=""tns:Structure/tns:Property[@name='Комментарий']/tns:Value/text()""/>
		|      </xsl:element>
		|
		|      <xsl:element name=""Состав"">
		|        <xsl:attribute name=""xsi:type"">Адрес</xsl:attribute>
		|        <xsl:variable name=""country"" select=""tns:Structure/tns:Property[@name='Страна']/tns:Value/text()""></xsl:variable>
		|        <xsl:variable name=""country-upper"">
		|          <xsl:call-template name=""str-upper"">
		|            <xsl:with-param name=""str"" select=""$country"" />
		|          </xsl:call-template>
		|        </xsl:variable>
		|
		|        <xsl:attribute name=""Страна"">
		|          <xsl:choose>
		|            <xsl:when test=""0=count($country)"">
		|              <xsl:value-of select=""$local-country"" />
		|            </xsl:when>
		|            <xsl:otherwise>
		|              <xsl:value-of select=""$country"" />
		|            </xsl:otherwise> 
		|          </xsl:choose>
		|        </xsl:attribute>
		|
		|        <xsl:choose>
		|          <xsl:when test=""0=count($country)"">
		|            <xsl:apply-templates select=""/"" mode=""domestic"" />
		|          </xsl:when>
		|          <xsl:when test=""$country-upper=$local-country"">
		|            <xsl:apply-templates select=""/"" mode=""domestic"" />
		|          </xsl:when>
		|          <xsl:otherwise>
		|            <xsl:apply-templates select=""/"" mode=""foreign"" />
		|          </xsl:otherwise> 
		|        </xsl:choose>
		|
		|      </xsl:element>
		|    </КонтактнаяИнформация>
		|  </xsl:template>
		|  
		|  <xsl:template match=""/"" mode=""foreign"">
		|    <xsl:element name=""Состав"">
		|      <xsl:attribute name=""xsi:type"">xs:string</xsl:attribute>
		|
		|      <xsl:variable name=""value"" select=""tns:Structure/tns:Property[@name='Значение']/tns:Value/text()"" />        
		|      <xsl:choose>
		|        <xsl:when test=""0=count($value)"">
		|          <xsl:value-of select=""$presentation"" />
		|        </xsl:when>
		|        <xsl:otherwise>
		|          <xsl:value-of select=""$value"" />
		|        </xsl:otherwise> 
		|      </xsl:choose>
		|    
		|    </xsl:element>
		|  </xsl:template>
		|  
		|  <xsl:template match=""/"" mode=""domestic"">
		|    <xsl:element name=""Состав"">
		|      <xsl:attribute name=""xsi:type"">АдресРФ</xsl:attribute>
		|    
		|      <xsl:element name=""СубъектРФ"">
		|        <xsl:variable name=""value"" select=""tns:Structure/tns:Property[@name='Регион']/tns:Value/text()"" />
		|
		|        <xsl:choose>
		|          <xsl:when test=""0=count($value)"">
		|            <xsl:variable name=""regioncode"" select=""tns:Structure/tns:Property[@name='КодРегиона']/tns:Value/text()""/>
		|            <xsl:variable name=""regiontitle"" select=""$enum-regioncode-nodes/data:item[@data:code=number($regioncode)]"" />
		|              <xsl:if test=""0!=count($regiontitle)"">
		|                <xsl:value-of select=""$regiontitle""/>
		|              </xsl:if>
		|          </xsl:when>
		|          <xsl:otherwise>
		|            <xsl:value-of select=""$value"" />
		|          </xsl:otherwise> 
		|        </xsl:choose>
		|
		|      </xsl:element>
		|   
		|      <xsl:element name=""Округ"">
		|        <xsl:value-of select=""tns:Structure/tns:Property[@name='Округ']/tns:Value/text()""/>
		|      </xsl:element>
		|
		|      <xsl:element name=""СвРайМО"">
		|        <xsl:element name=""Район"">
		|          <xsl:value-of select=""tns:Structure/tns:Property[@name='Район']/tns:Value/text()""/>
		|        </xsl:element>
		|      </xsl:element>
		|  
		|      <xsl:element name=""Город"">
		|        <xsl:value-of select=""tns:Structure/tns:Property[@name='Город']/tns:Value/text()""/>
		|      </xsl:element>
		|    
		|      <xsl:element name=""ВнутригРайон"">
		|        <xsl:value-of select=""tns:Structure/tns:Property[@name='ВнутригРайон']/tns:Value/text()""/>
		|      </xsl:element>
		|
		|      <xsl:element name=""НаселПункт"">
		|        <xsl:value-of select=""tns:Structure/tns:Property[@name='НаселенныйПункт']/tns:Value/text()""/>
		|      </xsl:element>
		|
		|      <xsl:element name=""Улица"">
		|        <xsl:value-of select=""tns:Structure/tns:Property[@name='Улица']/tns:Value/text()""/>
		|      </xsl:element>
		|
		|      <xsl:variable name=""index"" select=""tns:Structure/tns:Property[@name='Индекс']/tns:Value/text()"" />
		|      <xsl:if test=""0!=count($index)"">
		|        <xsl:element name=""ДопАдрЭл"">
		|          <xsl:attribute name=""ТипАдрЭл"">" + УправлениеКонтактнойИнформациейКлиентСервер.КодСериализацииПочтовогоИндекса() + "</xsl:attribute>
		|          <xsl:attribute name=""Значение""><xsl:value-of select=""$index""/></xsl:attribute>
		|        </xsl:element>
		|      </xsl:if>
		|
		|      <xsl:call-template name=""add-elem-number"">
		|        <xsl:with-param name=""source"" select=""tns:Structure/tns:Property[@name='ТипДома']/tns:Value/text()"" />
		|        <xsl:with-param name=""defsrc"" select=""'Дом'"" />
		|        <xsl:with-param name=""value""  select=""tns:Structure/tns:Property[@name='Дом']/tns:Value/text()"" />
		|      </xsl:call-template>
		|
		|      <xsl:call-template name=""add-elem-number"">
		|        <xsl:with-param name=""source"" select=""tns:Structure/tns:Property[@name='ТипКорпуса']/tns:Value/text()"" />
		|        <xsl:with-param name=""defsrc"" select=""'Корпус'"" />
		|        <xsl:with-param name=""value""  select=""tns:Structure/tns:Property[@name='Корпус']/tns:Value/text()"" />
		|      </xsl:call-template>
		|
		|      <xsl:call-template name=""add-elem-number"">
		|        <xsl:with-param name=""source"" select=""tns:Structure/tns:Property[@name='ТипКвартиры']/tns:Value/text()"" />
		|        <xsl:with-param name=""defsrc"" select=""'Квартира'"" />
		|        <xsl:with-param name=""value""  select=""tns:Structure/tns:Property[@name='Квартира']/tns:Value/text()"" />
		|      </xsl:call-template>
		|    
		|    </xsl:element>
		|  </xsl:template>
		|
		|  <xsl:param name=""enum-codevalue"">
		|" + КодыДополнительныхАдресныхЭлементов.ПолучитьТекст() + "
		|  </xsl:param>
		|  <xsl:variable name=""enum-codevalue-nodes"" select=""exsl:node-set($enum-codevalue)"" />
		|
		|  <xsl:param name=""enum-regioncode"">
		|" + КодыРегионов.ПолучитьТекст() + "
		|  </xsl:param>
		|  <xsl:variable name=""enum-regioncode-nodes"" select=""exsl:node-set($enum-regioncode)"" />
		|  
		|  <xsl:template name=""add-elem-number"">
		|    <xsl:param name=""source"" />
		|    <xsl:param name=""defsrc"" />
		|    <xsl:param name=""value"" />
		|
		|    <xsl:if test=""0!=count($value)"">
		|
		|      <xsl:choose>
		|        <xsl:when test=""0!=count($source)"">
		|          <xsl:variable name=""type-code"" select=""$enum-codevalue-nodes/data:item[@data:title=$source]"" />
		|          <xsl:element name=""ДопАдрЭл"">
		|            <xsl:element name=""Номер"">
		|              <xsl:attribute name=""Тип""><xsl:value-of select=""$type-code"" /></xsl:attribute>
		|              <xsl:attribute name=""Значение""><xsl:value-of select=""$value""/></xsl:attribute>
		|            </xsl:element>
		|          </xsl:element>
		|
		|        </xsl:when>
		|        <xsl:otherwise>
		|          <xsl:variable name=""type-code"" select=""$enum-codevalue-nodes/data:item[@data:title=$defsrc]"" />
		|          <xsl:element name=""ДопАдрЭл"">
		|            <xsl:element name=""Номер"">
		|              <xsl:attribute name=""Тип""><xsl:value-of select=""$type-code"" /></xsl:attribute>
		|              <xsl:attribute name=""Значение""><xsl:value-of select=""$value""/></xsl:attribute>
		|            </xsl:element>
		|          </xsl:element>
		|
		|        </xsl:otherwise>
		|      </xsl:choose>
		|
		|    </xsl:if>
		|  
		|  </xsl:template>
		|  
		|</xsl:stylesheet>
		|");
	Возврат Преобразователь;
КонецФункции

// Преобразует сериализованную структуру в контактную информацию в виде XML.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_СтруктураВАдресЭлектроннойПочты() Экспорт
	Возврат XSLT_СтруктураВСтроковыйСостав("ЭлектроннаяПочта");
КонецФункции

// Преобразует сериализованную структуру в контактную информацию в виде XML.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_СтруктураВВебСтраницу() Экспорт
	Возврат XSLT_СтруктураВСтроковыйСостав("ВебСайт");
КонецФункции

// Преобразует сериализованную структуру в контактную информацию в виде XML.
//
Функция XSLT_СтруктураВТелефон() Экспорт
	Возврат XSLT_СтруктураВТелефонФакс("НомерТелефона");
КонецФункции

// Преобразует сериализованную структуру в контактную информацию в виде XML.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_СтруктураВФакс() Экспорт
	Возврат XSLT_СтруктураВТелефонФакс("НомерФакса");
КонецФункции

// Преобразует сериализованную структуру в контактную информацию в виде XML.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_СтруктураВДругое() Экспорт
	Возврат XSLT_СтруктураВСтроковыйСостав("Прочее");
КонецФункции

// Общее преобразование сериализованной структуры в контактную информацию в виде XML простого типа.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_СтруктураВСтроковыйСостав(Знач ИмяXDTOТипа)
	Преобразователь = Новый ПреобразованиеXSL;
	Преобразователь.ЗагрузитьИзСтроки("
		|<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""
		|  xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""
		|  xmlns:tns=""http://v8.1c.ru/8.1/data/core""
		|  xmlns=""http://www.v8.1c.ru/ssl/contactinfo"" 
		|>
		|<xsl:output method=""xml"" omit-xml-declaration=""yes"" indent=""yes"" encoding=""utf-8""/>
		|
		|<xsl:template match=""/"">
		|  
		|  <xsl:element name=""КонтактнаяИнформация"">
		|  
		|  <xsl:attribute name=""Представление"">
		|    <xsl:value-of select=""tns:Structure/tns:Property[@name='Представление']/tns:Value/text()""/>
		|  </xsl:attribute> 
		|  <xsl:element name=""Комментарий"">
		|    <xsl:value-of select=""tns:Structure/tns:Property[@name='Комментарий']/tns:Value/text()""/>
		|  </xsl:element>
		|  
		|  <xsl:element name=""Состав"">
		|    <xsl:attribute name=""xsi:type"">" + ИмяXDTOТипа + "</xsl:attribute>
		|    <xsl:attribute name=""Значение"">
		|    <xsl:choose>
		|      <xsl:when test=""0=count(tns:Structure/tns:Property[@name='Значение'])"">
		|      <xsl:value-of select=""tns:Structure/tns:Property[@name='Представление']/tns:Value/text()""/>
		|      </xsl:when>
		|      <xsl:otherwise>
		|      <xsl:value-of select=""tns:Structure/tns:Property[@name='Значение']/tns:Value/text()""/>
		|      </xsl:otherwise>
		|    </xsl:choose>
		|    </xsl:attribute>
		|    
		|  </xsl:element>
		|  </xsl:element>
		|  
		|</xsl:template>
		|</xsl:stylesheet>
		|");
	Возврат Преобразователь;
КонецФункции

// Общее преобразование для телефона и факса.
//
// Возвращаемое значение:
//     ПреобразованиеXSL  - подготовленный объект.
//
Функция XSLT_СтруктураВТелефонФакс(Знач ИмяXDTOТипа)
	Преобразователь = Новый ПреобразованиеXSL;
	Преобразователь.ЗагрузитьИзСтроки("
		|<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""
		|  xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""
		|  xmlns:tns=""http://v8.1c.ru/8.1/data/core""
		|  xmlns=""http://www.v8.1c.ru/ssl/contactinfo"" 
		|>
		|<xsl:output method=""xml"" omit-xml-declaration=""yes"" indent=""yes"" encoding=""utf-8""/>
		|  <xsl:template match=""/"">
		|
		|    <xsl:element name=""КонтактнаяИнформация"">
		|
		|      <xsl:attribute name=""Представление"">
		|        <xsl:value-of select=""tns:Structure/tns:Property[@name='Представление']/tns:Value/text()""/>
		|      </xsl:attribute> 
		|      <xsl:element name=""Комментарий"">
		|        <xsl:value-of select=""tns:Structure/tns:Property[@name='Комментарий']/tns:Value/text()""/>
		|      </xsl:element>
		|      <xsl:element name=""Состав"">
		|        <xsl:attribute name=""xsi:type"">" + ИмяXDTOТипа + "</xsl:attribute>
		|
		|        <xsl:attribute name=""КодСтраны"">
		|          <xsl:value-of select=""tns:Structure/tns:Property[@name='КодСтраны']/tns:Value/text()""/>
		|        </xsl:attribute> 
		|        <xsl:attribute name=""КодГорода"">
		|          <xsl:value-of select=""tns:Structure/tns:Property[@name='КодГорода']/tns:Value/text()""/>
		|        </xsl:attribute> 
		|        <xsl:attribute name=""Номер"">
		|          <xsl:value-of select=""tns:Structure/tns:Property[@name='НомерТелефона']/tns:Value/text()""/>
		|        </xsl:attribute> 
		|        <xsl:attribute name=""Добавочный"">
		|          <xsl:value-of select=""tns:Structure/tns:Property[@name='Добавочный']/tns:Value/text()""/>
		|        </xsl:attribute> 
		|
		|      </xsl:element>
		|    </xsl:element>
		|
		|  </xsl:template>
		|</xsl:stylesheet>
		|");
	Возврат Преобразователь;
КонецФункции

// Фрагмент XSL с процедурами для обработки строк.
//
// Возвращаемое значение:
//     Строка - фрагмент XML для использования в преобразовании.
//
Функция XSLT_ШаблоныСтроковыхФункций()
	Возврат "
		|<!-- string functions -->
		|
		|  <xsl:template name=""str-trim-left"">
		|    <xsl:param name=""str"" />
		|    <xsl:variable name=""head"" select=""substring($str, 1, 1)""/>
		|    <xsl:variable name=""tail"" select=""substring($str, 2)""/>
		|    <xsl:choose>
		|      <xsl:when test=""(string-length($str) > 0) and (string-length(normalize-space($head)) = 0)"">
		|        <xsl:call-template name=""str-trim-left"">
		|          <xsl:with-param name=""str"" select=""$tail""/>
		|        </xsl:call-template>
		|      </xsl:when>
		|      <xsl:otherwise>
		|        <xsl:value-of select=""$str""/>
		|      </xsl:otherwise>
		|    </xsl:choose>
		|  </xsl:template>
		|
		|  <xsl:template name=""str-trim-right"">
		|    <xsl:param name=""str"" />
		|    <xsl:variable name=""head"" select=""substring($str, 1, string-length($str) - 1)""/>
		|    <xsl:variable name=""tail"" select=""substring($str, string-length($str))""/>
		|    <xsl:choose>
		|      <xsl:when test=""(string-length($str) > 0) and (string-length(normalize-space($tail)) = 0)"">
		|        <xsl:call-template name=""str-trim-right"">
		|          <xsl:with-param name=""str"" select=""$head""/>
		|        </xsl:call-template>
		|      </xsl:when>
		|      <xsl:otherwise>
		|        <xsl:value-of select=""$str""/>
		|      </xsl:otherwise>
		|    </xsl:choose>
		|  </xsl:template>
		|
		|  <xsl:template name=""str-trim-all"">
		|    <xsl:param name=""str"" />
		|      <xsl:call-template name=""str-trim-right"">
		|        <xsl:with-param name=""str"">
		|          <xsl:call-template name=""str-trim-left"">
		|            <xsl:with-param name=""str"" select=""$str""/>
		|          </xsl:call-template>
		|      </xsl:with-param>
		|    </xsl:call-template>
		|  </xsl:template>
		|
		|  <xsl:template name=""str-replace-all"">
		|    <xsl:param name=""str"" />
		|    <xsl:param name=""search-for"" />
		|    <xsl:param name=""replace-by"" />
		|    <xsl:choose>
		|      <xsl:when test=""contains($str, $search-for)"">
		|        <xsl:value-of select=""substring-before($str, $search-for)"" />
		|        <xsl:value-of select=""$replace-by"" />
		|        <xsl:call-template name=""str-replace-all"">
		|          <xsl:with-param name=""str"" select=""substring-after($str, $search-for)"" />
		|          <xsl:with-param name=""search-for"" select=""$search-for"" />
		|          <xsl:with-param name=""replace-by"" select=""$replace-by"" />
		|        </xsl:call-template>
		|      </xsl:when>
		|      <xsl:otherwise>
		|        <xsl:value-of select=""$str"" />
		|      </xsl:otherwise>
		|    </xsl:choose>
		|  </xsl:template>
		|
		|  <xsl:param name=""alpha-low"" select=""'абвгдеёжзийклмнопрстуфхцчшщыъьэюяabcdefghijklmnopqrstuvwxyz'"" />
		|  <xsl:param name=""alpha-up""  select=""'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЪЬЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZ'"" />
		|
		|  <xsl:template name=""str-upper"">
		|    <xsl:param name=""str"" />
		|    <xsl:value-of select=""translate($str, $alpha-low, $alpha-up)""/>
		|  </xsl:template>
		|
		|  <xsl:template name=""str-lower"">
		|    <xsl:param name=""str"" />
		|    <xsl:value-of select=""translate($str, alpha-up, $alpha-low)"" />
		|  </xsl:template>
		|
		|<!-- /string functions -->
		|";
КонецФункции

// Фрагмент XSL с процедурами для работы с xpath.
//
// Возвращаемое значение:
//     Строка - фрагмент XML для использования в преобразовании.
//
Функция XSLT_ШаблоныФункцийXPath()
	Возврат "
		|<!-- path functions -->
		|
		|  <xsl:template name=""build-path"">
		|  <xsl:variable name=""node"" select="".""/>
		|
		|    <xsl:for-each select=""$node | $node/ancestor-or-self::node()[..]"">
		|      <xsl:choose>
		|        <!-- element -->
		|        <xsl:when test=""self::*"">
		|            <xsl:value-of select=""'/'""/>
		|            <xsl:value-of select=""name()""/>
		|            <xsl:variable name=""thisPosition"" select=""count(preceding-sibling::*[name(current()) = name()])""/>
		|            <xsl:variable name=""numFollowing"" select=""count(following-sibling::*[name(current()) = name()])""/>
		|            <xsl:if test=""$thisPosition + $numFollowing > 0"">
		|              <xsl:value-of select=""concat('[', $thisPosition +1, ']')""/>
		|            </xsl:if>
		|        </xsl:when>
		|        <xsl:otherwise>
		|          <!-- not element -->
		|          <xsl:choose>
		|            <!-- attribute -->
		|            <xsl:when test=""count(. | ../@*) = count(../@*)"">
		|                <xsl:value-of select=""'/'""/>
		|                <xsl:value-of select=""concat('@',name())""/>
		|            </xsl:when>
		|            <!-- text- -->
		|            <xsl:when test=""self::text()"">
		|                <xsl:value-of select=""'/'""/>
		|                <xsl:value-of select=""'text()'""/>
		|                <xsl:variable name=""thisPosition"" select=""count(preceding-sibling::text())""/>
		|                <xsl:variable name=""numFollowing"" select=""count(following-sibling::text())""/>
		|                <xsl:if test=""$thisPosition + $numFollowing > 0""> 
		|                  <xsl:value-of select=""concat('[', $thisPosition +1, ']')""/>
		|                </xsl:if>
		|            </xsl:when>
		|            <!-- processing instruction -->
		|            <xsl:when test=""self::processing-instruction()"">
		|                <xsl:value-of select=""'/'""/>
		|                <xsl:value-of select=""'processing-instruction()'""/>
		|                <xsl:variable name=""thisPosition"" select=""count(preceding-sibling::processing-instruction())""/>
		|                <xsl:variable name=""numFollowing"" select=""count(following-sibling::processing-instruction())""/>
		|                <xsl:if test=""$thisPosition + $numFollowing > 0"">
		|                  <xsl:value-of select=""concat('[', $thisPosition +1, ']')""/>
		|                </xsl:if>
		|            </xsl:when>
		|            <!-- comment -->
		|            <xsl:when test=""self::comment()"">
		|                <xsl:value-of select=""'/'""/>
		|                <xsl:value-of select=""'comment()'""/>
		|                <xsl:variable name=""thisPosition"" select=""count(preceding-sibling::comment())""/>
		|                <xsl:variable name=""numFollowing"" select=""count(following-sibling::comment())""/>
		|                <xsl:if test=""$thisPosition + $numFollowing > 0"">
		|                  <xsl:value-of select=""concat('[', $thisPosition +1, ']')""/>
		|                </xsl:if>
		|            </xsl:when>
		|            <!-- namespace -->
		|            <xsl:when test=""count(. | ../namespace::*) = count(../namespace::*)"">
		|              <xsl:variable name=""ap"">'</xsl:variable>
		|              <xsl:value-of select=""'/'""/>
		|                <xsl:value-of select=""concat('namespace::*','[local-name() = ', $ap, local-name(), $ap, ']')""/>
		|            </xsl:when>
		|          </xsl:choose>
		|        </xsl:otherwise>
		|      </xsl:choose>
		|    </xsl:for-each>
		|
		|  </xsl:template>
		|
		|<!-- /path functions -->
		|";
КонецФункции

#КонецОбласти
