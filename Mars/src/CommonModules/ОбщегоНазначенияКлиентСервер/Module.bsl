
#Область ПрограммныйИнтерфейс

// Сообщить пользователю.
// 
// Параметры:
//  ТекстСообщенияПользователю - Строка - Текст сообщения пользователю
//  КлючДанных - Строка, ЛюбаяСсылка  - Ключ данных
//  Поле - Строка - Поле
//  ПутьКДанным - Строка - Путь к данным
//  ЭтоОбъект - Булево - Это объект
Процедура СообщитьПользователю(
		Знач ТекстСообщенияПользователю,
		Знач КлючДанных = Неопределено,
		Знач Поле = "",
		Знач ПутьКДанным = "") Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	Сообщение.КлючДанных = КлючДанных;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
	
	Сообщение.Сообщить();
	
КонецПроцедуры

// Дополняет массив МассивПриемник значениями из массива МассивИсточник.
//
// Параметры:
//  МассивПриемник - Массив - массив, в который необходимо добавить значения.
//  МассивИсточник - Массив - массив значений для заполнения.
//  ТолькоУникальныеЗначения - Булево - если истина, то в массив будут включены только уникальные значения.
//
Процедура ДополнитьМассив(МассивПриемник, МассивИсточник, ТолькоУникальныеЗначения = Ложь) Экспорт
	
	Если ТолькоУникальныеЗначения Тогда
		
		УникальныеЗначения = Новый Соответствие;
		
		Для Каждого Значение Из МассивПриемник Цикл
			УникальныеЗначения.Вставить(Значение, Истина);
		КонецЦикла;
		
		Для Каждого Значение Из МассивИсточник Цикл
			Если УникальныеЗначения[Значение] = Неопределено Тогда
				МассивПриемник.Добавить(Значение);
				УникальныеЗначения.Вставить(Значение, Истина);
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		Для Каждого Значение Из МассивИсточник Цикл
			МассивПриемник.Добавить(Значение);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Разбирает строку URI на составные части и возвращает в виде структуры.
// На основе RFC 3986.
//
// Параметры:
//     СтрокаURI - Строка - ссылка на ресурс в формате:
//                          <схема>://<логин>:<пароль>@<хост>:<порт>/<путь>?<параметры>#<якорь>.
//
// Возвращаемое значение:
//     Структура - составные части URI согласно формату:
//         * Схема         - Строка.
//         * Логин         - Строка.
//         * Пароль        - Строка.
//         * ИмяСервера    - Строка - часть <хост>:<порт> входного параметра.
//         * Хост          - Строка.
//         * Порт          - Строка.
//         * ПутьНаСервере - Строка - часть <путь>?<параметры>#<якорь> входного параметра.
//
Функция СтруктураURI(Знач СтрокаURI) Экспорт
	
	СтрокаURI = СокрЛП(СтрокаURI);
	
	// схема
	Схема = "";
	Позиция = СтрНайти(СтрокаURI, "://");
	Если Позиция > 0 Тогда
		Схема = НРег(Лев(СтрокаURI, Позиция - 1));
		СтрокаURI = Сред(СтрокаURI, Позиция + 3);
	КонецЕсли;

	// Строка соединения и путь на сервере.
	СтрокаСоединения = СтрокаURI;
	ПутьНаСервере = "";
	Позиция = СтрНайти(СтрокаСоединения, "/");
	Если Позиция > 0 Тогда
		ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
		СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
	КонецЕсли;
		
	// Информация пользователя и имя сервера.
	СтрокаАвторизации = "";
	ИмяСервера = СтрокаСоединения;
	Позиция = СтрНайти(СтрокаСоединения, "@");
	Если Позиция > 0 Тогда
		СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
		ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
	КонецЕсли;
	
	// логин и пароль
	Логин = СтрокаАвторизации;
	Пароль = "";
	Позиция = СтрНайти(СтрокаАвторизации, ":");
	Если Позиция > 0 Тогда
		Логин = Лев(СтрокаАвторизации, Позиция - 1);
		Пароль = Сред(СтрокаАвторизации, Позиция + 1);
	КонецЕсли;
	
	// хост и порт
	Хост = ИмяСервера;
	Порт = "";
	Позиция = СтрНайти(ИмяСервера, ":");
	Если Позиция > 0 Тогда
		Хост = Лев(ИмяСервера, Позиция - 1);
		Порт = Сред(ИмяСервера, Позиция + 1);
		Если Не ТолькоЦифрыВСтроке(Порт) Тогда
			Порт = "";
		КонецЕсли;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Схема", Схема);
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("Хост", Хост);
	Результат.Вставить("Порт", ?(ПустаяСтрока(Порт), Неопределено, Число(Порт)));
	Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет, содержит ли строка только цифры.
//
// Параметры:
//  СтрокаПроверки          - Строка - Строка для проверки.
//  УчитыватьЛидирующиеНули - Булево - Флаг учета лидирующих нулей, если Истина, то ведущие нули пропускаются.
//  УчитыватьПробелы        - Булево - Флаг учета пробелов, если Истина, то пробелы при проверке игнорируются.
//
// Возвращаемое значение:
//   Булево - Истина - строка содержит только цифры или пустая, Ложь - строка содержит иные символы.
//
Функция ТолькоЦифрыВСтроке(Знач СтрокаПроверки, Знач УчитыватьЛидирующиеНули = Истина, Знач УчитыватьПробелы = Истина) 
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не УчитыватьПробелы Тогда
		СтрокаПроверки = СтрЗаменить(СтрокаПроверки, " ", "");
	КонецЕсли;
		
	Если ПустаяСтрока(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Не УчитыватьЛидирующиеНули Тогда
		Позиция = 1;
		// Взятие символа за границей строки возвращает пустую строку.
		Пока Сред(СтрокаПроверки, Позиция, 1) = "0" Цикл
			Позиция = Позиция + 1;
		КонецЦикла;
		СтрокаПроверки = Сред(СтрокаПроверки, Позиция);
	КонецЕсли;
	
	// Если содержит только цифры, то в результате замен должна быть получена пустая строка.
	// Проверять при помощи ПустаяСтрока нельзя, так как в исходной строке могут быть пробельные символы.
	Возврат СтрДлина(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( 
			СтрокаПроверки, "0", ""), "1", ""), "2", ""), "3", ""), "4", ""), "5", ""), "6", ""), "7", ""), "8", ""), "9", "")) = 0;
	
КонецФункции

#КонецОбласти