// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Загрузить снимки за период.
// 
// Параметры:
//  ДатаНачала - Дата - Дата начала
//  ДатаОкончания - Дата - Дата окончания
// 
// Возвращаемое значение:
//  Соответствие из см. ВызовАпиСервисаСервер.ФотографииЗаДату
Функция ЗагрузитьСнимкиЗаПериод(ДатаНачала, ДатаОкончания) Экспорт
	
	МассивЗагружаемыхДат = МассивДатИзИнтервала(ДатаНачала, ДатаОкончания);
	
	ПолученыеДанныеЗаВсеДаты = Новый Соответствие();
	
	Для Каждого ТекущаяДата Из МассивЗагружаемыхДат Цикл
		
		ДанныеЗаДату = ЗагрузитьСнимкиЗаДату(ТекущаяДата);
		
		ПолученыеДанныеЗаВсеДаты.Вставить(Формат(ТекущаяДата, "ДФ=yyyy-MM-dd;"), ДанныеЗаДату);
		
	КонецЦикла;
	
	Возврат ПолученыеДанныеЗаВсеДаты;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс


// Обработать полученые данные снимков.
// 
// Параметры:
//  ДанныеСнимковЗаПериод - Соответствие из см. ВызовАпиСервисаСервер.ФотографииЗаДату - Данные к обработке
// 
// Возвращаемое значение:
//  Структура - Обработать полученые данные снимков:
// * ВсегоСнимков - Число -
// * Обработано - Число -
// * НовыеФото - Число -
// * НовыеКамеры - Число -
// * НовыеМарсоходы - Число -
// * Завершено - Булево -
// * ТекстОшибки - Строка -
Функция ОбработатьПолученыеДанныеСнимков(ДанныеСнимковЗаПериод) Экспорт
	
	Результат = СтруктураПроцессаОбработкиДанных();
	
	Результат.ВсегоСнимков = ВсегоСнимков(ДанныеСнимковЗаПериод);
	
	СообщитьПромежуточныйРезультатЗагрузки(Результат);
	
	Для Каждого ДанныеОдногоДня Из ДанныеСнимковЗаПериод Цикл
		
		ОбработаноЗаДень = ОбработатьДанныеСнимковЗаДень(ДанныеОдногоДня);
		
		Результат.Обработано = Результат.Обработано + ОбработаноЗаДень.Обработано;
		Результат.НовыеФото = Результат.НовыеФото + ОбработаноЗаДень.НовыеФото;
		Результат.НовыеКамеры = Результат.НовыеКамеры + ОбработаноЗаДень.НовыеКамеры;
		Результат.НовыеМарсоходы = Результат.НовыеМарсоходы + ОбработаноЗаДень.НовыеМарсоходы;
		Результат.ТекстОшибки = Результат.ТекстОшибки + ОбработаноЗаДень.ТекстОшибки;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОбработатьДанныеСнимковЗаДень(ДанныеОдногоДня)
	
	Результат = СтруктураПроцессаОбработкиДанных();
	Результат.Удалить("ВсегоСнимков");
	
	Для Каждого ДанныеФотографии Из ДанныеОдногоДня.photos Цикл
		
		
		Результат.Обработано = Результат.Обработано + 1;
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Структура процесса обработки данных.
// 
// Возвращаемое значение:
//  Структура - Структура процесса обработки данных:
// * ВсегоСнимков - Число -
// * Обработано - Число -
// * НовыеФото - Число -
// * НовыеКамеры - Число -
// * НовыеМарсоходы - Число -
// * Завершено - Булево -
// * ТекстОшибки - Строка -
Функция СтруктураПроцессаОбработкиДанных() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ВсегоСнимков", 0);
	Результат.Вставить("Обработано", 0);
	Результат.Вставить("НовыеФото", 0);
	Результат.Вставить("НовыеКамеры", 0);
	Результат.Вставить("НовыеМарсоходы", 0);
	Результат.Вставить("Завершено", 	Ложь);
	Результат.Вставить("ТекстОшибки", 	"");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Загрузить снимки за дату.
// 
// Параметры:
//  ТекущаяДата - Дата - Текущая дата
// 
// Возвращаемое значение:
//  см. ВызовАпиСервисаСервер.ФотографииЗаДату
Функция ЗагрузитьСнимкиЗаДату(ТекущаяДата)
	
	Возврат ВызовАпиСервисаСервер.ФотографииЗаДату(ТекущаяДата);
	
КонецФункции

// Всего снимков.
// 
// Параметры:
//  ДанныеСнимковЗаПериод - Соответствие из см. ВызовАпиСервисаСервер.ФотографииЗаДату
// 
// Возвращаемое значение:
//  Число - Всего снимков
Функция ВсегоСнимков(ДанныеСнимковЗаПериод)
	
	Всего = 0;
	
	Для Каждого СнимкиЗадату Из ДанныеСнимковЗаПериод Цикл
		
		Всего = Всего + СнимкиЗадату.photos.Количество();
		
	КонецЦикла;
	
	Возврат Всего;
	
КонецФункции




Процедура СообщитьПромежуточныйРезультатЗагрузки(Результат)
	Сообщение = ЗначениеВСтрокуВнутр(Результат);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение);
КонецПроцедуры

// Массив дат из интервала.
// 
// Параметры:
//  НачалоПериода - Дата - Начало периода
//  КонецПериода - Дата - Конец периода
// 
// Возвращаемое значение:
//  Массив из Дата
Функция МассивДатИзИнтервала(НачалоПериода, КонецПериода) 

	Запрос = Новый Запрос;
	Запрос.Текст = ТексЗапросаДляИнтервалаДат();

	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);

	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();
	МассивДат = Новый Массив();
	
	Пока Выборка.Следующий() Цикл
		Дата = Выборка.Период; // Дата
		МассивДат.Добавить(Дата);
	КонецЦикла;
	
	Возврат МассивДат;
	
КонецФункции

Функция ТексЗапросаДляИнтервалаДат()
	Возврат "ВЫБРАТЬ
			|	0 КАК Ключ
			|ПОМЕСТИТЬ Порядки
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	1
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	2
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	3
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	4
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	5
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	6
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	7
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	8
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	9
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(&НачалоПериода, ДЕНЬ), ДЕНЬ, П1.Ключ + П2.Ключ * 10 + П3.Ключ * 100) КАК Период
			|ИЗ
			|	Порядки КАК П1
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Порядки КАК П2
			|		ПО (ИСТИНА)
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Порядки КАК П3
			|		ПО (ИСТИНА)
			|ГДЕ
			|	П1.Ключ + П2.Ключ * 10 + П3.Ключ * 100 <= РАЗНОСТЬДАТ(&НачалоПериода, &КонецПериода, ДЕНЬ)
			|
			|УПОРЯДОЧИТЬ ПО
			|	Период";
КонецФункции

#КонецОбласти

#КонецЕсли
