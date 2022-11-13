
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АпиКлюч = Константы.АпиКлюч.Получить();
	АпиКлючЗаполнен = Не ПустаяСтрока(АпиКлюч);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не АпиКлючЗаполнен Тогда
		ОткрытьФорму("ОбщаяФорма.ФормаКонстант");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Заполните api ключ'"));
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	ЗаполнитьЗначенияСвойств(Объект, Период);
	СборосИндикаторов();
	Элементы.ЗагрузитьСнимкиЗаПериод.Доступность = Истина;
	Элементы.ГруппаИндикаторы.Видимость = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьСнимкиЗаПериод(Команда)
	
	СборосИндикаторов();
		
	ПустаяДата = Дата("00010101");
	Если Объект.ДатаНачала = ПустаяДата 
		Или Объект.ДатаОкончания = ПустаяДата
		Или (Объект.ДатаОкончания < Объект.ДатаНачала) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не верно указан период'"), "Период", "Объект");
		Возврат;
		
	КонецЕсли;
	КлючФоновогоЗадания = Строка(Новый УникальныйИдентификатор());
	АдресРезультата = ПоместитьВоВременноеХранилище(ПустаяДата, УникальныйИдентификатор);
	
	ЗагрузитьСнимкиЗаПериодСервер(Объект.ДатаНачала, Объект.ДатаОкончания, КлючФоновогоЗадания, АдресРезультата);
	
	Элементы.ГруппаИндикаторы.Видимость = Истина;
	ПодключитьОбработчикОжидания("ОжиданиеЗавершенияЗагрузкиСнимков", 3);
	
	Элементы.ЗагрузитьСнимкиЗаПериод.Доступность = Ложь;
	Элементы.Период.Доступность = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Загрузить снимки за период сервер.
// 
// Параметры:
//  ДатаНачала - Дата - Дата начала
//  ДатаОкончания - Дата - Дата окончания
//  Ключ - Строка - Ключ
//  АдресРезультата - Строка - Адрес результата
&НаСервереБезКонтекста
Процедура ЗагрузитьСнимкиЗаПериодСервер(ДатаНачала, ДатаОкончания, Ключ, АдресРезультата)
		
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ДатаНачала);
	ПараметрыЗадания.Добавить(ДатаОкончания);
	ПараметрыЗадания.Добавить(АдресРезультата);
	
	ИмяЗадания = "Загрузка снимков марсаходов за период с " + Строка(ДатаНачала) + " по " + Строка(ДатаОкончания);
	
	ФоновыеЗадания.Выполнить("МодульФоновыхЗаданийСервер.ЗагрузкаСнимковЗаПериод",
		ПараметрыЗадания, Ключ, ИмяЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОжиданиеЗавершенияЗагрузкиСнимков() Экспорт
	
	РезультатФоновойЗагрузки = РезультатВыполненияФоновойЗагрузки(КлючФоновогоЗадания);
	
	Если РезультатФоновойЗагрузки.Завершено Тогда
		Элементы.Период.Доступность = Истина;
		Элементы.ЗагрузитьСнимкиЗаПериод.Доступность = Истина;
		
		ИндикаторОбработкиДанных = Элементы.ИндикаторОбработкиДанных.МаксимальноеЗначение;
		
		ОтключитьОбработчикОжидания("ОжиданиеЗавершенияЗагрузкиСнимков");
		
		РезультатЗагрузки = ПолучитьИзВременногоХранилища(АдресРезультата);
		
		Если ПустаяСтрока(РезультатФоновойЗагрузки.ТекстОшибки) Тогда
			ИндикаторыВГалочку();
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатФоновойЗагрузки.ТекстОшибки);
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого ТекущееСообщение Из РезультатФоновойЗагрузки.МассивСообщений Цикл
		
		СтруктураСообщения = ЗначениеИзСтрокиВнутрСервер(ТекущееСообщение.Текст);
		
		Если СтруктураСообщения.ПолучениеДанных Тогда
			РезультатПолученияДанных(СтруктураСообщения);
		КонецЕсли;
		
		Если СтруктураСообщения.ОбработкаДанных Тогда
			РезультатОбработкиДанных(СтруктураСообщения);
		КонецЕсли;
		
		Если СтруктураСообщения.ЗагрузкаФото Тогда
			РезультатЗагрузкиФото(СтруктураСообщения);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПолученияДанных(СтруктураСообщения)
	
	Элементы.ИндикаторПолученияДанных.МаксимальноеЗначение = СтруктураСообщения.ВсегоДат;
	ИндикаторПолученияДанных = СтруктураСообщения.ОбработаноДат;
	
	Если СтруктураСообщения.ВсегоДат = ИндикаторПолученияДанных Тогда
		Элементы.БубликОжиданияПолучения.Картинка = БиблиотекаКартинок.ОформлениеФлажок;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкиДанных(СтруктураСообщения)
	
	Если СтруктураСообщения.ВсегоСнимков > 0 Тогда
		Элементы.ИндикаторОбработкиДанных.МаксимальноеЗначение = СтруктураСообщения.ВсегоСнимков;

		Элементы.ИндикаторОбработкиДанных.Подсказка = "Обработано " + СтруктураСообщения.Обработано + " из "
			+ СтруктураСообщения.ВсегоСнимков;
	КонецЕсли;
	
	ИндикаторОбработкиДанных = СтруктураСообщения.Обработано;
	
	Если СтруктураСообщения.ВсегоСнимков = ИндикаторОбработкиДанных Тогда
		Элементы.БубликОжиданияОбработки.Картинка = БиблиотекаКартинок.ОформлениеФлажок;
	КонецЕсли;
	
	Если Не ПустаяСтрока(СтруктураСообщения.ТекстОшибки) Тогда
		Элементы.БубликОжиданияОбработки.Картинка = БиблиотекаКартинок.ОформлениеКрест;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтруктураСообщения.ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатЗагрузкиФото(СтруктураСообщения)
	
	Элементы.ИндикаторЗагрузкиФото.МаксимальноеЗначение = СтруктураСообщения.ВсегоФотоКЗагрузке;
	ИндикаторЗагрузкиФото = СтруктураСообщения.ФотоЗагружено;
	
	Если СтруктураСообщения.ВсегоДат = ИндикаторПолученияДанных Тогда
		Элементы.БубликОжиданияЗагрузкиФото.Картинка = БиблиотекаКартинок.ОформлениеФлажок;
	КонецЕсли;
	
КонецПроцедуры

// Результат выполнения фоновой загрузки.
// 
// Параметры:
//  Ключ - Строка - Ключ
// 
// Возвращаемое значение:
//  Структура - Результат выполнения фоновой загрузки:
// * Завершено - Булево -
// * ТекстОшибки - Строка -
// * МассивСообщений - Массив -
&НаСервереБезКонтекста
Функция РезультатВыполненияФоновойЗагрузки(Ключ)
	
	Результат = Новый Структура();;
	Результат.Вставить("Завершено", Ложь);
	Результат.Вставить("ТекстОшибки", "");
	Результат.Вставить("МассивСообщений", Новый Массив());
	
	Отбор = Новый Структура("Ключ", Ключ);
	МассивЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	
	Если МассивЗаданий.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Задание = МассивЗаданий[0];
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.Завершено Тогда
		Результат.Завершено = Истина;
	ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		Результат.Завершено = Истина;
		Результат.ТекстОшибки = Задание.ИнформацияОбОшибке.Описание;
	Иначе
		Результат.Завершено = Ложь;
	КонецЕсли;
	
	Результат.МассивСообщений = Задание.ПолучитьСообщенияПользователю(Истина);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗначениеИзСтрокиВнутрСервер(Текст)
	Возврат ЗначениеИзСтрокиВнутр(Текст);
КонецФункции

&НаКлиенте
Процедура СборосИндикаторов()
	ИндикаторЗагрузкиФото = 0;
	ИндикаторОбработкиДанных = 0;
	ИндикаторПолученияДанных = 0;
	Элементы.БубликОжиданияПолучения.Картинка = БиблиотекаКартинок.ДлительнаяОперация16;
	Элементы.БубликОжиданияОбработки.Картинка = БиблиотекаКартинок.ДлительнаяОперация16;
	Элементы.БубликОжиданияЗагрузкиФото.Картинка = БиблиотекаКартинок.ДлительнаяОперация16;
КонецПроцедуры

&НаКлиенте
Процедура ИндикаторыВГалочку()
	Элементы.БубликОжиданияПолучения.Картинка = БиблиотекаКартинок.ОформлениеФлажок;
	Элементы.БубликОжиданияОбработки.Картинка = БиблиотекаКартинок.ОформлениеФлажок;
	Элементы.БубликОжиданияЗагрузкиФото.Картинка = БиблиотекаКартинок.ОформлениеФлажок;
КонецПроцедуры
#КонецОбласти
