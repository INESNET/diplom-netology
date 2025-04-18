#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.Сотрудник,
		|	СУММА(ВКМ_ВзаиморасчетыССотрудникамиОстатки.СуммаОстаток) КАК Сумма,
		|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.Подразделение
		|ИЗ
		|	РегистрНакопления.ВКМ_ВзаиморасчетыССотрудниками.Остатки(&Период,) КАК ВКМ_ВзаиморасчетыССотрудникамиОстатки
		|СГРУППИРОВАТЬ ПО
		|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.Сотрудник,
		|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.Подразделение";
	
	Запрос.УстановитьПараметр("Период", Новый МоментВремени(Объект.Дата));
	
	РезультатЗапроса = Запрос.Выполнить();
    Объект.Выплаты.Очистить();
    Объект.Выплаты.Загрузить(РезультатЗапроса.Выгрузить());
    
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ДатаПриИзмененииНаСервере();
КонецПроцедуры
#КонецОбласти