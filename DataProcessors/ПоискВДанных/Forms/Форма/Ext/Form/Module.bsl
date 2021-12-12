﻿// Процедура выполняет полнотекстовый поиск
&НаСервере
Процедура ИскатьВыполнитьСервер(Направление) Экспорт
	
	// В Демо-конфигурации перед поиском обновляем индекс
	// В реальных конфигурациях следует избегать такого подхода, т.к. это 
	// может привести к существенному замедлению поиска
	Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить 
		И НЕ ПолнотекстовыйПоиск.ИндексАктуален() Тогда
		
		РаботаСПолнотекстовымПоиском.ПолноеОбновлениеИндексаПолнотекстовогоПоиска();
		
	КонецЕсли;	
	
	РазмерПорции = 20; 
	
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска, РазмерПорции);
	
	Если Направление = 0 Тогда
		СписокПоиска.ПерваяЧасть();      
	ИначеЕсли Направление = -1 Тогда
		СписокПоиска.ПредыдущаяЧасть(ТекущаяПозиция);      
	ИначеЕсли Направление = 1 Тогда
		СписокПоиска.СледующаяЧасть(ТекущаяПозиция);      
	КонецЕсли;        	
	
	РезультатыПоиска.Очистить();
	Для каждого Результат Из СписокПоиска Цикл
		РезультатыПоиска.Добавить(Результат.Значение);
	КонецЦикла; 	
	
	HTMLТекст = СписокПоиска.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.HTMLТекст);
	
	HTMLТекст = СтрЗаменить(HTMLТекст, "<td>", "<td><font face=""Arial"" size=""2"">");
	HTMLТекст = СтрЗаменить(HTMLТекст, "<td valign=top width=1>", "<td valign=top width=1><font face=""Arial"" size=""1"">");
	HTMLТекст = СтрЗаменить(HTMLТекст, "<body>", "<body topmargin=0 leftmargin=0>");
	HTMLТекст = СтрЗаменить(HTMLТекст, "</td>", "</font></td>");
	HTMLТекст = СтрЗаменить(HTMLТекст, "<b>", "");
	HTMLТекст = СтрЗаменить(HTMLТекст, "</b>", "");
	
	ТекущаяПозиция = СписокПоиска.НачальнаяПозиция();
	ПолноеКоличество = СписокПоиска.ПолноеКоличество();       	
	
	Если РезультатыПоиска.Количество() <> 0 Тогда
		ПоказаныРезультатыСПо = 
			НСтр("ru ='Показаны '", "ru") + 
			Строка(ТекущаяПозиция + 1) + " - " +  
			Строка(ТекущаяПозиция + РезультатыПоиска.Количество()) + 
			НСтр("ru =' из '", "ru") + Строка(ПолноеКоличество);
			
		Элементы.Далее.Доступность = (ПолноеКоличество - ТекущаяПозиция) > РезультатыПоиска.Количество();
		Элементы.Назад.Доступность = (ТекущаяПозиция > 0);
	Иначе
		ПоказаныРезультатыСПо = НСтр("ru = 'Не найдено'", "ru");
		Элементы.Далее.Доступность = Ложь;
		Элементы.Назад.Доступность = Ложь;
	КонецЕсли;
	
	СохраненнаяСтрока = Элементы.ПолеВводаПоиска.СписокВыбора.НайтиПоЗначению(СтрокаПоиска);
	Если СохраненнаяСтрока <> Неопределено Тогда
		Элементы.ПолеВводаПоиска.СписокВыбора.Удалить(СохраненнаяСтрока);
	КонецЕсли;
		
	Элементы.ПолеВводаПоиска.СписокВыбора.Вставить(0, СтрокаПоиска);
	Строки = Элементы.ПолеВводаПоиска.СписокВыбора.ВыгрузитьЗначения();
		
	ХранилищеОбщихНастроек.Сохранить("ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска", , Строки);
КонецПроцедуры
        
// Обработка команды Найти
&НаКлиенте
Процедура ИскатьВыполнить()
	Искать(0);
КонецПроцедуры

// Обработчик команды Назад
&НаКлиенте
Процедура НазадВыполнить()
	Искать(-1);
КонецПроцедуры

// Обработчик команды Далее
&НаКлиенте
Процедура ДалееВыполнить()
	Искать(1);
КонецПроцедуры

// Процедура поиска, получение и отображение результата
&НаКлиенте
Процедура Искать(Направление)
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		Предупреждение(НСтр("ru = 'Не задана строка поиска.'", "ru"));
		Возврат;
	КонецЕсли;
	
	ИскатьВыполнитьСервер(Направление);
КонецПроцедуры

// находит символ в строке с конца
Функция НайтиСимволСКонца(Знач СтрокаВся, Знач ОдинСимвол)
	Перем ТекущаяПозиция;

	НачальнаяПозиция = 1; 
	ДлинаСтроки = СтрДлина(СтрокаВся);
	
	Для ТекущаяПозиция = 1 По СтрДлина(СтрокаВся) Цикл
		РеальнаяПозиция = ДлинаСтроки - ТекущаяПозиция + 1;
		ТекущийСимвол = Сред(СтрокаВся, РеальнаяПозиция, 1);
		Если ТекущийСимвол = ОдинСимвол Тогда
			Возврат РеальнаяПозиция;
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат 0;
КонецФункции

&НаКлиенте
Процедура HTMLТекстПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	ЭлементHTML = ДанныеСобытия.Anchor;
	
	Если ЭлементHTML = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если (ЭлементHTML.id = "FullTextSearchListItem") Тогда
		частьURL = ЭлементHTML.pathName;
		позиция = НайтиСимволСКонца(частьURL, "/");
		Если позиция <> 0 Тогда
			частьURL = Сред(частьURL, позиция + 1);
			НомерВСписке = Число(частьURL);
			ВыбраннаяСтрока = РезультатыПоиска[НомерВСписке].Значение;
			ОткрытьЗначение(ВыбраннаяСтрока);
		КонецЕсли;		
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() <> РежимПолнотекстовогоПоиска.Разрешить Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Использование полнотекстового поиска не разрешено. Вы можете включить его в диалоге ""Управление полнотекстовым поиском""'", "ru");
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	ПоказаныРезультатыСПо = НСтр("ru = 'Введите строку поиска'", "ru");
	ТекущаяПозиция = 0;
	
	Элементы.Далее.Доступность = Ложь;
	Элементы.Назад.Доступность = Ложь;
	
	Массив = ХранилищеОбщихНастроек.Загрузить("ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска");
	
	Если Массив <> Неопределено Тогда
		Элементы.ПолеВводаПоиска.СписокВыбора.ЗагрузитьЗначения(Массив);
	КонецЕсли;	
КонецПроцедуры
