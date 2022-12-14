// @strict-types

#Область ПрограммныйИнтерфейс

// Фотографии за дату.
// 
// Параметры:
//  Дата - Дата - Дата за которую получаем фото
// 
// Возвращаемое значение:
//  Структура - Фотографии за дату:
// * photos - Массив из см. СтруктураФотографииМарсохода
Функция ФотографииЗаДату(Дата) Экспорт
	
	api_key = ОбщегоНазначенияСерверПовтИсп.ПолучитьАпиКлюч();
	
	СтруктураФотографий = Новый Структура;
	
	МассивФото = Новый Массив;
	МассивФото.Добавить(СтруктураФотографииМарсохода());
	
	СтруктураФотографий.Вставить("photos", МассивФото);
	
	Соединение = Новый HTTPСоединение("api.nasa.gov", , , , , , Новый ЗащищенноеСоединениеOpenSSL);
	
	АдресРесурса = "mars-photos/api/v1/rovers/curiosity/photos?earth_date={Дата}&api_key={api_key}";
	
	АдресРесурса = СтрЗаменить(АдресРесурса, "{Дата}", Формат(Дата, "ДФ=yyyy-MM-dd;"));
	АдресРесурса = СтрЗаменить(АдресРесурса, "{api_key}", api_key);
	
	Запрос = Новый HTTPЗапрос(АдресРесурса);
	
	Ответ = Соединение.Получить(Запрос);
	СтрокаОтвета = Ответ.ПолучитьТелоКакСтроку();
	Если Ответ.КодСостояния = 200 Тогда
		СтруктураОтвета = JSONСтрокаВОбъект(СтрокаОтвета);
		ЗаполнитьЗначенияСвойств(СтруктураФотографий, СтруктураОтвета);
	Иначе
		ЗаписьЖурналаРегистрации("Ошибка запроса фото", УровеньЖурналаРегистрации.Ошибка, , , 
			"Ответ: " + СтрокаОтвета + Символы.ПС + "Адрес запроса: " + АдресРесурса);
	КонецЕсли;
	
	Возврат СтруктураФотографий;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Структура фотографии Марсохода.
// 
// Возвращаемое значение:
//  Структура - Фотографии за дату:
//	 * id - Число - ИД фотографии
//	 * sol - Число - Марсианский сол
//	 * camera - см. СтруктураКамерыМарсохода
//	 * img_src - Строка - URL адрес фотографии
//	 * earth_date - Дата - Земная дата фотографии
//	 * rover - см. СтруктураМарсохода
// 
Функция СтруктураФотографииМарсохода()
	
	СтруктураФотографий = Новый Структура;
	СтруктураФотографий.Вставить("id", 0);
	СтруктураФотографий.Вставить("sol", 0);
	СтруктураФотографий.Вставить("camera", СтруктураКамерыМарсохода());
	СтруктураФотографий.Вставить("img_src", "");
	СтруктураФотографий.Вставить("earth_date", Дата("00010101"));
	СтруктураФотографий.Вставить("rover", СтруктураМарсохода());
	
	Возврат СтруктураФотографий;
	
КонецФункции

// Структура камеры Марсохода.
// 
// Возвращаемое значение:
//  Структура - Камеры Марсохода:
//	 * id - Число - ИД камеры
//	 * name - Строка - Имя камеры
//	 * rover_id - Число - ИД Марсохода
//	 * full_name - Строка - Полное имя камеры
// 
Функция СтруктураКамерыМарсохода()
		
	СтруктураКамеры = Новый Структура();
	СтруктураКамеры.Вставить("id", 0);
	СтруктураКамеры.Вставить("name", "");
	СтруктураКамеры.Вставить("rover_id", 0);
	СтруктураКамеры.Вставить("full_name", "");
	
	Возврат СтруктураКамеры;
	
КонецФункции

// Структура Марсохода.
// 
// Возвращаемое значение:
//  Структура - Марсохода за дату:
//	 * id - Число - ИД Марсохода
//	 * name - Строка - Имя Марсохода
//	 * landing_date - Дата - Дата призимления Марсохода
//	 * launch_date - Дата - Дата запуска Марсохода
//	 * status - Строка - Статус Марсохода
// 
Функция СтруктураМарсохода()
	
	ПустаяДата = Дата("00010101");
	
	СтруктураМарсохода = Новый Структура();
	СтруктураМарсохода.Вставить("id", 0);
	СтруктураМарсохода.Вставить("name", "");
	СтруктураМарсохода.Вставить("landing_date", ПустаяДата);
	СтруктураМарсохода.Вставить("launch_date", ПустаяДата);
	СтруктураМарсохода.Вставить("status", "");
	
	Возврат СтруктураМарсохода;
	
КонецФункции

// JSONСтрока в объект.
// 
// Параметры:
//  Строка - Строка - Строка
// 
// Возвращаемое значение:
//  Произвольный - JSONСтрока в объект
Функция JSONСтрокаВОбъект(Строка)
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(Строка);
	
	Возврат ПрочитатьJSON(Чтение);
	
КонецФункции


#КонецОбласти
