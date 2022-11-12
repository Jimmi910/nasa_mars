// @strict-types

#Область ПрограммныйИнтерфейс

// Загрузка снимков за период.
// 
// Параметры:
//  ДатаНачала - Дата - Дата начала
//  ДатаОкончания - Дата - Дата окончания
//  АдресРезультатаФЗ - Строка - Адрес результата ФЗ
Процедура ЗагрузкаСнимковЗаПериод(ДатаНачала, ДатаОкончания, АдресРезультатаФЗ) Экспорт
	
	Рез = Новый Структура();
	Рез.Вставить("ВсегоСнимков", 1000000);
	Рез.Вставить("Обработано", 0);
	
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Код процедур и функций

#КонецОбласти
