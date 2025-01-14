﻿// Процедура добавляет стандартную форму в список форм
//
// Параметры :
//  Префикс - префикс имени формы
//  ПрефиксПредставления - префикс представления формы
//  МетаданныеФорм - коллекция метаданных форм
//  Картинка - картинка объекта метаданных
//  Список - список значений, в который помещается список имен форм
Процедура ПолучитьСписокФормИзСпискаМетаданныхФорм(Префикс, ПрефиксПредставления, МетаданныеФорм, Картинка, Список)
	
	Для каждого Форма Из МетаданныеФорм Цикл
		
		Список.Добавить(Префикс + ".Форма." + Форма.Имя, ПрефиксПредставления + "." + Форма.Синоним, Ложь, Картинка);
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура добавляет стандартную форму в список форм
//
// Параметры :
//  Префикс - префикс имени формы
//  ПрефиксПредставления - префикс представления формы
//  ОбъектМетаданных - объект метаданных, для которого получается форма
//  ИмяФормы - имя формы
//  ПредставлениеФормы - представление формы
//  Картинка - картинка объекта метаданных
//  Список - список значений, в который помещается список имен форм
Процедура ДобавитьСтандартнуюФорму(Префикс, ПрефиксПредставления, ОбъектМетаданных, ИмяФормы, ПредставлениеФормы, Картинка, Список)
	
	Если ОбъектМетаданных["Основная" + ИмяФормы] = Неопределено Тогда
		
		Список.Добавить(Префикс + "." + ИмяФормы, ПрефиксПредставления + "." + ПредставлениеФормы, Ложь, Картинка);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура получает список форм для списка объекта метаданных одного типа
//
// Параметры :
//  СписокОбъектовМетаданных - список объектов метаданных, для которых нужно получить список форм
//  ИмяОбъектаМетаданных - имя объекта метаданных
//  ПредставлениеОбъектаМетаданных - представление объекта метаданных
//  ИменаСтандартныхФорм - имена стандартных форм объекта метаданных
//  Картинка - картинка объекта метаданных
//  Список - список значений, в который помещается список имен форм
Процедура ПолучитьСписокФормОбъектаМетаданных(СписокОбъектовМетаданных, ИмяОбъектаМетаданных, ПредставлениеОбъектаМетаданных, ИменаСтандартныхФорм, Картинка, Список)
	
	Для каждого Объект Из СписокОбъектовМетаданных Цикл
		
		Префикс = ИмяОбъектаМетаданных + "." + Объект.Имя;
		ПрефиксПредставления = ПредставлениеОбъектаМетаданных + "." + Объект.Синоним;
		
		ПолучитьСписокФормИзСпискаМетаданныхФорм(Префикс, ПрефиксПредставления, Объект.Формы, Картинка, Список);
		
		Для каждого ИмяСтандартнойФормы Из ИменаСтандартныхФорм Цикл
			
			ДобавитьСтандартнуюФорму(Префикс, ПрефиксПредставления, Объект, ИмяСтандартнойФормы.Значение, ИмяСтандартнойФормы.Представление, Картинка, Список);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура получает список форм
//
// Параметры :
//  Список - список значений, в который помещается список имен форм
Процедура ПолучитьСписокФорм(Список) Экспорт
	
	Для каждого Форма Из Метаданные.ОбщиеФормы Цикл
		
		Список.Добавить("ОбщаяФорма." + Форма.Имя, НСтр("ru ='Общая форма.'", "ru") + Форма.Синоним, Ложь, БиблиотекаКартинок.Форма);
		
	КонецЦикла;

	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаОбъекта", НСтр("ru ='Форма объекта'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаГруппы", НСтр("ru ='Форма группы'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаСписка", НСтр("ru ='Форма списка'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаДляВыбора", НСтр("ru ='Форма выбора'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаДляВыбораГруппы", "Форма выбора группы");
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.Справочники, "Справочник", НСтр("ru ='Справочник'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.Справочник, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("Форма", НСтр("ru ='Форма'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.КритерииОтбора, "КритерийОтбора", НСтр("ru ='Критерий отбора'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.КритерийОтбора, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаСохранения", НСтр("ru ='Форма сохранения'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаЗагрузки", НСтр("ru ='Форма выбора'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.ХранилищаНастроек, "ХранилищеНастроек", НСтр("ru ='Хранилище настроек'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.ХранилищеНастроек, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаОбъекта", НСтр("ru ='Форма объекта'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаСписка", НСтр("ru ='Форма списка'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаДляВыбора", НСтр("ru ='Форма выбора'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.Документы, "Документ", НСтр("ru ='Документ'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.Документ, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("Форма", НСтр("ru ='Форма'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.ЖурналыДокументов, "ЖурналДокументов", НСтр("ru ='Журнал документов'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.ЖурналДокументов, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаСписка", НСтр("ru ='Форма списка'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаДляВыбора", НСтр("ru ='Форма выбора'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.Перечисления, "Перечисление", НСтр("ru ='Перечисление'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.Перечисление, Список);

	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("Форма", НСтр("ru ='Форма'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаНастроек", НСтр("ru ='Форма настроек'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаВарианта", НСтр("ru ='Форма варианта'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.Отчеты, "Отчет", НСтр("ru ='Отчет'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.Отчет, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("Форма", НСтр("ru ='Форма'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.Обработки, "Обработка", НСтр("ru ='Обработка'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.Обработка, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаЗаписи", НСтр("ru ='Форма записи'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаСписка", НСтр("ru ='Форма списка'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.РегистрыСведений, "РегистрСведений", НСтр("ru ='Регистр сведений'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.РегистрСведений, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаСписка", НСтр("ru ='Форма списка'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.РегистрыНакопления, "РегистрНакопления", НСтр("ru ='Регистр накопления'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.РегистрНакопления, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаОбъекта", НСтр("ru ='Форма объекта'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаГруппы", НСтр("ru ='Форма группы'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаСписка", НСтр("ru ='Форма списка'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаДляВыбора", НСтр("ru ='Форма выбора'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаДляВыбораГруппы", НСтр("ru ='Форма выбора группы'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.ПланыВидовХарактеристик, "ПланВидовХарактеристик", НСтр("ru ='План видов характеристик'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.ПланВидовХарактеристик, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаОбъекта", НСтр("ru ='Форма объекта'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаСписка", НСтр("ru ='Форма списка'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаДляВыбора", НСтр("ru ='Форма выбора'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.ПланыСчетов, "ПланСчетов", НСтр("ru ='План счетов'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.ПланСчетов, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаСписка", НСтр("ru ='Форма списка'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.РегистрыБухгалтерии, "РегистрБухгалтерии", НСтр("ru ='Регистр бухгалтерии'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.РегистрБухгалтерии, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаОбъекта", НСтр("ru ='Форма объекта'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаСписка", НСтр("ru ='Форма списка'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаДляВыбора", НСтр("ru ='Форма выбора'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.ПланыВидовРасчета, "ПланВидовРасчета", НСтр("ru ='План видов расчета'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.ПланВидовРасчета, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаСписка", НСтр("ru ='Форма списка'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.РегистрыРасчета, "РегистрРасчета", НСтр("ru ='Регистр расчета'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.РегистрРасчета, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаОбъекта", НСтр("ru ='Форма объекта'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаСписка", НСтр("ru ='Форма списка'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаДляВыбора", НСтр("ru ='Форма выбора'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.БизнесПроцессы, "БизнесПроцесс", НСтр("ru ='Бизнес процесс'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.БизнесПроцесс, Список);
	
	ИменаСтандартныхФорм = Новый СписокЗначений;
	ИменаСтандартныхФорм.Добавить("ФормаОбъекта", НСтр("ru ='Форма объекта'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаСписка", НСтр("ru ='Форма списка'", "ru"));
	ИменаСтандартныхФорм.Добавить("ФормаДляВыбора", НСтр("ru ='Форма выбора'", "ru"));
	ПолучитьСписокФормОбъектаМетаданных(Метаданные.Задачи, "Задача", НСтр("ru ='Задача'", "ru"), ИменаСтандартныхФорм, БиблиотекаКартинок.Задача, Список);
	
КонецПроцедуры

// Процедура получает список сохраненных настроек для переданных форм
//
// Параметры :
//  СписокФорм - список форм, для которых нужно получить список настроек
//  Пользователь - имя пользователя, настройки форм которого нужно получить
//  СписокФормССохраненнымиНастройками - список значений в который будут добавлены настройки форм.
Процедура ПолучитьСписокСохраненныхНастроек(СписокФорм, Пользователь, СписокФормССохраненнымиНастройками) Экспорт
	
	Для каждого Элемент Из СписокФорм Цикл
		
		Описание = ХранилищеСистемныхНастроек.ПолучитьОписание(Элемент.Значение + "/НастройкиФормы", , Пользователь);
		Если Описание <> Неопределено Тогда
			
			СписокФормССохраненнымиНастройками.Добавить(Элемент.Значение, Элемент.Представление, Элемент.Пометка, Элемент.Картинка);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура позволяет скопировать настройки форм от одного пользователя другому
//
// Параметры :
//  ПользовательИсточник - имя пользователя, настройки форм которого копируются
//  ПользователиПриемник - имя пользователя которому копируются настройки форм
//  МассивНастроекДляКопирования - имена форм, настройки которых нужно скопировать
Процедура СкопироватьНастройкиФорм(ПользовательИсточник, ПользователиПриемник, МассивНастроекДляКопирования) Экспорт
	
	Для каждого Элемент Из МассивНастроекДляКопирования Цикл
		
		Настройка = ХранилищеСистемныхНастроек.Загрузить(Элемент + "/НастройкиФормы", "", , ПользовательИсточник);
		
		Если Настройка <> Неопределено Тогда
			
			Для каждого ПользовательПриемник Из ПользователиПриемник Цикл
				
				ХранилищеСистемныхНастроек.Сохранить(Элемент + "/НастройкиФормы", "", Настройка, , ПользовательПриемник);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура позволяет удалить настройки форм
//
// Параметры :
//  Пользователь - имя пользователя, настройки форм которого удаляются
//  МассивНастроекДляУдаления - имена форм, настройки которых нужно удалить
Процедура УдалитьНастройкиФорм(Пользователь, МассивНастроекДляУдаления) Экспорт
	
	Для каждого Элемент Из МассивНастроекДляУдаления Цикл
		
		ХранилищеСистемныхНастроек.Удалить(Элемент + "/НастройкиФормы", "", Пользователь);
		
	КонецЦикла;
	
КонецПроцедуры
	
