
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг) Тогда
		
        КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
        КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
        КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(Метаданные.Документы.РеализацияТоваровУслуг);
        КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции


Процедура ПриОпределенииНастроекПечати(НастройкиОбъекта) Экспорт	
	НастройкиОбъекта.ПриДобавленииКомандПечати = Истина;
КонецПроцедуры

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// АктОбОказанныхУслугах
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктОбОказанныхУслугах";
	КомандаПечати.Представление = НСтр("ru = 'Акт об оказанных услугах'");
	КомандаПечати.Порядок = 5;

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АктОбОказанныхУслугах");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьАкта(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт об оказанных услугах'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РеализацияТоваровУслуг.ПФ_MXL_АктОбОказанныхУслугах";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
 
#Область СлужебныеПроцедурыИФункции

Функция ПечатьАкта(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_АктОбОказанныхУслугах";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияТоваровУслуг.ПФ_MXL_АктОбОказанныхУслугах");

	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			 //Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВывестиЗаголовок(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		ВывестиУслуги(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		ВывестиПодвал(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		 //В табличном документе необходимо задать имя области, в которую был 
		 //выведен объект. Нужно для возможности печати комплектов документов.
        УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
            НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);		
		
	КонецЦикла;	
		
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьДанныеДокументов(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РеализацияТоваровУслуг.Ссылка,
	               |	РеализацияТоваровУслуг.Дата,
	               |	РеализацияТоваровУслуг.Номер,
	               |	РеализацияТоваровУслуг.Контрагент,
	               |	РеализацияТоваровУслуг.Организация,
	               |	РеализацияТоваровУслуг.Договор,
	               |	РеализацияТоваровУслуг.СуммаДокумента,
	               |	РеализацияТоваровУслуг.Услуги.(
	               |		Ссылка,
	               |		Номенклатура,
	               |		Количество,
	               |		Цена,
	               |		Сумма,
	               |		НомерСтроки)
	               |ИЗ
	               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	               |ГДЕ
	               |	РеализацияТоваровУслуг.Ссылка В (&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Процедура ВывестиЗаголовок(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьЗаголовокДокумента = Макет.ПолучитьОбласть("Шапка");
	
	ДанныеПечати = Новый Структура;
	
	ШаблонЗаголовка = "Акт об указанных услугах № %1 от %2";
	ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка,
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер),
		Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
	ДанныеПечати.Вставить("ТекстШапки", ТекстЗаголовка);
	ДанныеПечати.Вставить("Контрагент", ДанныеДокументов.Организация);
	ДанныеПечати.Вставить("Организация", ДанныеДокументов.Контрагент);
	ДанныеПечати.Вставить("Договор", ДанныеДокументов.Договор);
	
	ОбластьЗаголовокДокумента.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьЗаголовокДокумента);
	
КонецПроцедуры

Процедура ВывестиУслуги(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаТаблицы");
	ОбластьИтого = Макет.ПолучитьОбласть("ИтогоКОплате");
	ОбластьИтогоПрописью = Макет.ПолучитьОбласть("ИтогоПрописью");
	
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);

	ВыборкаУслуги = ДанныеДокументов.Услуги.Выбрать();
	Пока ВыборкаУслуги.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(ВыборкаУслуги);
		ТабличныйДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("Всего", ДанныеДокументов.СуммаДокумента);
	ДанныеПечати.Вставить("СуммаПрописью",ЧислоПрописью(ДанныеДокументов.СуммаДокумента, ,"рубль, рубля, рублей, м, копейка, копейки, копеек, ж"));

	ОбластьИтого.Параметры.Заполнить(ДанныеПечати);
	ОбластьИтогоПрописью.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьИтого);
	ТабличныйДокумент.Вывести(ОбластьИтогоПрописью);
	
КонецПроцедуры

Процедура ВывестиПодвал(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");

	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
КонецПроцедуры
#КонецОбласти
#КонецЕсли