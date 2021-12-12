﻿
//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ 
// 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Ключ.Пустая() И НЕ Параметры.ЗначениеКопирования.Пустая() Тогда
		// при копировании очищаем имя файла, чтобы не возникало иллюзии, что содержимое файла тоже скопируется
		Объект.ИмяФайла = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Объект.ИмяФайла = "" Тогда
		Предупреждение("Не выбран файл!");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлСДискаИЗаписать()
	Перем ВыбранноеИмя;
	Перем АдресВременногоХранилища;
	НовыйОбъект = Объект.Ссылка.Пустая();
	Если ПоместитьФайл(АдресВременногоХранилища, "", ВыбранноеИмя, Истина) Тогда
		Объект.ИмяФайла = ВыбранноеИмя;
		ПоместитьФайлОбъекта(АдресВременногоХранилища);
		Если НовыйОбъект Тогда
			ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Добавление);
		КонецЕсли;			
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлИСохранитьНаДиск()
	
	Если Объект.Ссылка.Пустая() Тогда
		Предупреждение(НСтр("ru = 'Данные не записаны'", "ru"));
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.ИмяФайла) Тогда
		Предупреждение(НСтр("ru = 'Имя не задано'", "ru"));
		Возврат;
	КонецЕсли;
	
	Адрес = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "ДанныеФайла");
	ПолучитьФайл(Адрес, Объект.ИмяФайла, Истина);
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ Команд криптографии 
// 

&НаКлиенте
Процедура Подписать(Команда)
	// Получает на клиента
	// Подписывает
	// Помещает на сервер файл и подпись
	Если Не ПодключитьРасширениеРаботыСКриптографией() Тогда
		Сообщить(НСтр("ru = 'Для требуемой операции необходимо установить расширение работы с криптографией'", "ru"));
		Возврат;
	КонецЕсли;
	Данные = ПолучитьДанныеФайла();
	Если Данные.Количество() = 0 Тогда
		Предупреждение(НСтр("ru = 'Нет данных файла!!!'", "ru"), 10);
		Возврат;
	КонецЕсли;
	ФайлДвоичныеДанные = Данные[0];
	Данные.Удалить(0);
	ПараметрыФормы = Новый СписокЗначений;
	ПараметрыФормы.Добавить(ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты);
	Сертификат = ПолучитьСписокСертификатов(ПараметрыФормы, Ложь);
	Если Сертификат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	МенеджерКриптографии = Новый МенеджерКриптографии("", "", 75);
	// проверяем, что этим сертификатом файл еще не подписан
	Для Каждого ЭЦПДвоичныеДанные Из Данные Цикл
		СертификатыПодписей = МенеджерКриптографии.ПолучитьСертификатыИзПодписи(ЭЦПДвоичныеДанные);
		Для Каждого СертификатПодписи Из СертификатыПодписей Цикл
			Если Сертификат = СертификатПодписи Тогда 
				Предупреждение(НСтр("ru = 'Этим сертификатом файл уже подписан'", "ru"), 10);
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	// подписываем
	Если Не ВводПароля(МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу) Тогда
		Возврат;
	КонецЕсли;

	НоваяПодпись = МенеджерКриптографии.Подписать(ФайлДвоичныеДанные, Сертификат);

	Данные.Добавить(НоваяПодпись);
	// Сохраняем на сервере, использование пустой строки избавляет
	// от необходимости передавать обратно файл на сервер - он не менялся
	ЗаписатьДанныеФайла("", Данные);
	ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Изменение);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодпись(Команда)
	// Подписи проверяем на сервере
	Если ПроверитьПодписьНаСервере() Тогда 
		Сообщение = НСтр("ru = 'Успешное завершение проверки ЭЦП'", "ru");
		Предупреждение(Сообщение, 3);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьЗашифрованныйНаСервер(Команда)
	Если Не ПодключитьРасширениеРаботыСКриптографией() Тогда
		Сообщить(НСтр("ru = 'Для требуемой операции необходимо установить расширение работы с криптографией'", "ru"));
		Возврат;
	КонецЕсли;

	// выбор файла на диске, который нужно зашифровать и сохранить на сервере
	НовыйОбъект = Объект.Ссылка.Пустая();
	МенеджерКриптографии = Новый МенеджерКриптографии("", "", 75);
	АдресФайлаДляШифрования = Неопределено;
	// если не подключено расширение работы с файлами, операция выполняется
	// неоптимально, увеличивается трафик с сервером и снижается защищенность
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Если Не Диалог.Выбрать() Тогда
			Возврат;
		КонецЕсли;
		АдресФайлаДляШифрования = Диалог.ВыбранныеФайлы[0];
		ФайлДляШифрования = Новый Файл(АдресФайлаДляШифрования);
		Объект.ИмяФайла = ФайлДляШифрования.Имя;
		ИсходныеДанныеДляШифрования = АдресФайлаДляШифрования;
	Иначе
		ВыбранноеИмя = "";
		Если Не ПоместитьФайл(АдресФайлаДляШифрования, "", ВыбранноеИмя, Истина) Тогда
			Возврат;
		КонецЕсли;	
		ФайлДляШифрования = Новый Файл(ВыбранноеИмя);
		Объект.ИмяФайла = ФайлДляШифрования.Имя;
		ИсходныеДанныеДляШифрования = ПолучитьИзВременногоХранилища(АдресФайлаДляШифрования);
	КонецЕсли;
	
	// Формируем список сертификатов, которыми можно будет файл расшифровать
	ПараметрыФормы = Новый СписокЗначений;
	ПараметрыФормы.Добавить(ТипХранилищаСертификатовКриптографии.СертификатыПолучателей);
	ПараметрыФормы.Добавить(ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты);
	Сертификаты = ПолучитьСписокСертификатов(ПараметрыФормы, Истина);
	Если Сертификаты = Неопределено Или Сертификаты.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	// шифруем для выбранных сертификатов
	ЗашифрованныйДвоичныеДанные = МенеджерКриптографии.Зашифровать(ИсходныеДанныеДляШифрования, Сертификаты);
	Объект.Зашифрован = Истина;
	
	// Сохраняем на сервере
	ЗаписатьДанныеФайла(ЗашифрованныйДвоичныеДанные, Новый Массив);
	Если НовыйОбъект Тогда
		ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Добавление);
	Иначе
		ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Изменение);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЗашифроватьНаСервере(ДанныеСертификатов, ТекстОшибки)
	Сертификаты = Новый Массив();
	Для Каждого ДанныеСертификата Из ДанныеСертификатов Цикл
		Сертификаты.Добавить(Новый СертификатКриптографии(ДанныеСертификата));
	КонецЦикла;
	
	МенеджерКриптографии = Новый МенеджерКриптографии("", "", 75);
	Данные = ПолучитьДанныеФайла();
	Если Данные.Количество() = 0 Тогда
		ТекстОшибки = НСтр("ru = 'Нет данных файла!!!'", "ru");
		Возврат Ложь;
	КонецЕсли;
	ФайлДвоичныеДанные = Данные[0];
	Данные.Удалить(0);
	
	// шифруем
	ЗашифрованныйДвоичныеДанные = МенеджерКриптографии.Зашифровать(ФайлДвоичныеДанные, Сертификаты);

	// Сохраняем на сервере
	Объект.Зашифрован = Истина;
	ЗаписатьДанныеФайла(ЗашифрованныйДвоичныеДанные, Данные);
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура Зашифровать(Команда)
	Перем ТекстОшибки;
	Если Не ПодключитьРасширениеРаботыСКриптографией() Тогда
		Сообщить(НСтр("ru = 'Для требуемой операции необходимо установить расширение работы с Криптографией'", "ru"));
		Возврат;
	КонецЕсли;
	
	Если Объект.Зашифрован Тогда
		Сообщить(НСтр("ru = 'Файл уже зашифрован'", "ru"));
		Возврат;
	КонецЕсли;
	
	Если Объект.Подписан Тогда
		Сообщить(НСтр("ru = 'Файл подписан, операция шифрования запрещена'", "ru"));
		Возврат;
	КонецЕсли;
	
	// Формируем список сертификатов, которыми можно будет файл расшифровать
	ПараметрыФормы = Новый СписокЗначений;
	ПараметрыФормы.Добавить(ТипХранилищаСертификатовКриптографии.СертификатыПолучателей);
	ПараметрыФормы.Добавить(ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты);
	Сертификаты = ПолучитьСписокСертификатов(ПараметрыФормы, Истина);
	Если Сертификаты = Неопределено Или Сертификаты.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	НовыйОбъект = Объект.Ссылка.Пустая();
	
	ДанныеСертификатов = Новый Массив();
	Для Каждого Сертификат Из Сертификаты Цикл
		ДанныеСертификатов.Добавить(Сертификат.Выгрузить());
	КонецЦикла;
	
	Результат = ЗашифроватьНаСервере(ДанныеСертификатов, ТекстОшибки);
	
	Если Не Результат Тогда
		Сообщить(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Если НовыйОбъект Тогда
		ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Добавление);
	Иначе
		ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Изменение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСРасшифровкой(Команда)
	// Получить на клиента
	// Расшифровать
	// Если двоичные данные, то передать на сервер
	// Поместить в файл
	Если Не ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Контрагенты") Тогда 
		Сообщение = НСтр("ru = 'Расшифровать возможно только файлы контрагентов'", "ru");
		Сообщить(Сообщение);
		Возврат;
	КонецЕсли;
	Если Не ПодключитьРасширениеРаботыСКриптографией() Тогда
		Сообщить(НСтр("ru = 'Для требуемой операции необходимо установить расширение работы с криптографией'", "ru"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Данные = ПолучитьДанныеФайла();
	Если Данные.Количество() = 0 Тогда
		Сообщить(НСтр("ru = 'Нет данных файла!!!'", "ru"));
		Возврат;
	КонецЕсли;
	ФайлДвоичныеДанные = Данные[0];
	Данные.Удалить(0);
	МенеджерКриптографии = Новый МенеджерКриптографии("", "", 75);
	Если Не ВводПароля(МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу) Тогда
		Возврат;
	КонецЕсли;
	// сохранение расшифрованного в файловой системе клиента
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		Диалог.ПолноеИмяФайла = Объект.ИмяФайла;
		Если Не Диалог.Выбрать() Тогда
			Возврат;
		КонецЕсли;

		МенеджерКриптографии.Расшифровать(ФайлДвоичныеДанные, Диалог.ВыбранныеФайлы[0]);

	Иначе
		РасшифрованныйДвоичныеДанные = МенеджерКриптографии.Расшифровать(ФайлДвоичныеДанные);
		
		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(РасшифрованныйДвоичныеДанные, УникальныйИдентификатор);
		ИмяФайла = Объект.ИмяФайла;
		ПолучитьФайл(АдресВоВременномХранилище, ИмяФайла, Истина);
	КонецЕсли;
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ПРОЦЕДУРЫ И ФУНКЦИИ 
// 

// процедура проверяет подписи
// - возращает Истина, если все подписи прошли проверку
&НаСервере
Функция ПроверитьПодписьНаСервере()
	Данные = ПолучитьДанныеФайла();
	Если Данные.Количество() = 0 Тогда
		Сообщить(НСтр("ru = 'Нет данных файла!!!'", "ru"));
		Возврат Ложь;
	КонецЕсли;
	ФайлДвоичныеДанные = Данные[0];
	Данные.Удалить(0);
	Если Данные.Количество() = 0 Тогда
		Сообщение = НСтр("ru = 'Файл никем не подписан'", "ru");
		Сообщить(Сообщение);
		Возврат Ложь;
	КонецЕсли;
	МенеджерКриптографии = Новый МенеджерКриптографии("", "", 75);
	Для Каждого ЭЦПДвоичныеДанные Из Данные Цикл
		МенеджерКриптографии.ПроверитьПодпись(ФайлДвоичныеДанные, ЭЦПДвоичныеДанные);
	КонецЦикла;
	Возврат Истина;
КонецФункции

// процедура сохраняет на сервере файл, и, при наличии, файлы ЭЦП
&НаСервере
Процедура ЗаписатьДанныеФайла(ФайлДвоичныеДанные, ЭЦПДвоичныеДанные)
	ЭлементСправочника = РеквизитФормыВЗначение("Объект");
	// ДанныеФайла меняем, только если переданы двоичные ланные
	Если ТипЗнч(ФайлДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
		ЭлементСправочника.ДанныеФайла = Новый ХранилищеЗначения(ФайлДвоичныеДанные, Новый СжатиеДанных());
	КонецЕсли;

	ЭлементСправочника.Подпись = Новый ХранилищеЗначения(ЭЦПДвоичныеДанные, Новый СжатиеДанных());
	
	ЭлементСправочника.Записать();
	Модифицированность = Ложь;
	ЗначениеВРеквизитФормы(ЭлементСправочника, "Объект");     
	
КонецПроцедуры	

// процедура получает с сервера в виде массива двоичных данных файлы, первым идет
// файл, затем, при наличии, файлы ЭЦП
&НаСервере
Функция ПолучитьДанныеФайла()
	Данные = Новый Массив;
	ЭлементСправочника = РеквизитФормыВЗначение("Объект");
	ФайлДвоичныеДанные = ЭлементСправочника.ДанныеФайла.Получить();
	Если ТипЗнч(ФайлДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
		Данные.Добавить(ФайлДвоичныеДанные);
		ФайлыЭЦП = ЭлементСправочника.Подпись.Получить();
		Если ТипЗнч(ФайлыЭЦП) = Тип("Массив") Тогда
			Для Каждого ФайлЭЦП Из ФайлыЭЦП Цикл
				Если ТипЗнч(ФайлЭЦП) = Тип("ДвоичныеДанные") Тогда
					Данные.Добавить(ФайлЭЦП);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Данные;
КонецФункции
	
// Формирование (интерактивное) списка сертификатов криптографии
// ПараметрыВыбора - список типов хранилищ, сертификаты которых могут участвовать в выборе
// МножественныйВыбор
&НаКлиенте
Функция ПолучитьСписокСертификатов(ПараметрыВыбора, МножественныйВыбор)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("МножественныйВыбор", МножественныйВыбор);
	ФормаСпискаСертификатов = ПолучитьФорму("Справочник.ХранимыеФайлы.Форма.СписокСертификатов", ПараметрыФормы);
	ФормаСпискаСертификатов.Установка(ПараметрыВыбора);
	Если ФормаСпискаСертификатов.ОткрытьМодально() = КодВозвратаДиалога.ОК Тогда
		Возврат ФормаСпискаСертификатов.ПолучитьРезультатВыбора();
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Процедура извлекает данные объекта из временного хранилища, 
// производит модификацию элемента справочника и записывает его.
// 
// Параметры: 
//  АдресВременногоХранилища – Строка – адрес временного хранилища. 
// 
// Возвращаемое значение: 
//  Нет.
&НаСервере
Процедура ПоместитьФайлОбъекта(АдресВременногоХранилища)
	ЭлементСправочника = РеквизитФормыВЗначение("Объект");
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	ЭлементСправочника.ДанныеФайла = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных());
	Файл = Новый Файл(ЭлементСправочника.ИмяФайла);
	ЭлементСправочника.ИмяФайла = Файл.Имя;
	ЭлементСправочника.Подпись = Новый ХранилищеЗначения(Неопределено, Новый СжатиеДанных());
	ЭлементСправочника.Зашифрован = Ложь;
	ЭлементСправочника.Подписан = Ложь;
	ЭлементСправочника.Записать();
	Модифицированность = Ложь;
	УдалитьИзВременногоХранилища(АдресВременногоХранилища);
	ЗначениеВРеквизитФормы(ЭлементСправочника, "Объект");     
КонецПроцедуры

// интерактивный ввод пароля доступа к закрытому ключу сертификата криптографии
// возвращает введенный пароль в параметре вызова Пароль
// возращает Истина, если пароль введен
&НаКлиенте
Функция ВводПароля(Пароль)
	Вернуть = Ложь;
	ФормаПароля = ПолучитьФорму("Справочник.ХранимыеФайлы.Форма.ФормаПароля");
	ФормаПароля.Пароль = Пароль;
	Если ФормаПароля.ОткрытьМодально() = КодВозвратаДиалога.ОК Тогда
		Пароль = ФормаПароля.Пароль;
		Вернуть = Истина;
	КонецЕсли;
	
	Возврат Вернуть;
КонецФункции     