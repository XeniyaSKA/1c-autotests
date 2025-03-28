#language: ru

@tree
@1priority

Функционал: ОРД. Распоряжения


Переменные:
АдресатАвтотест = "Самара Александровна"  
АвторПроектаАвтотест1 = "Ксения Надеждовна"  
АвторПроектаАвтотест2 = "Ксения Надеждовна"  
ШаблонАвтотест1 = "Проект распоряжения в свободной форме"  
ШаблонАвтотест2 = "Распоряжение"  
ОрганизацияАвтотест = "НазваниеОрганизации"  
ПодписантАвтотест = "Ксения Надеждовна"  
ЗаголовокАвтотест = "Автотест. О проведении мероприятий"
СодержаниеАвтотест = "Автотест. Проект распоряжения в свободной форме"  
ВерхняяПапкаАвтотест = "Внутренний документооборот (СЗ и ОРД)" 


@createnewdocs
@T992
Сценарий: DO-000001. Проект распоряжения в свободной форме
// документ создатся с помощью экспортного сценария

    Пусть я создаю новый документ "ШаблонАвтотест1" из папки "ВерхняяПапкаАвтотест" под пользователем "АвторПроектаАвтотест1" по переданным таблицам с реквизитами		
        | 'ЗаголовокРеквизита' | 'ИмяРеквизита'                   | 'ЗначениеРеквизита'       |
        | 'Заголовок'          | 'Заголовок'                      | 'ЗаголовокАвтотест'       |
        | 'Содержание'         | 'Содержание'                     | 'СодержаниеАвтотест'      |
        | 'Организация'        | 'Организация'                    | 'ОрганизацияАвтотест'     |
        | 'Подписант'          | 'Подписал'                       | 'ПодписантАвтотест'       |
        | 'Срок не установлен' | 'втблСрокИсполненияНеУстановлен' | 'Истина'                  |
	
        // Согласующие
        | |

        // Лист ознакомления
        | 'Адресат'         |
        | 'АдресатАвтотест' |


@createnewdocs
@T993
Сценарий: DO-000005. Распоряжение
//документ создается на основании документа из сценария T992

    И я запускаю клиент под пользователем "АвторПроектаАвтотест2" с временным паролем
    И я открываю навигационную ссылку "$$СсылкаНаСозданныйДокумент$$"

* Создать карточку внутреннего документа
    И открылось окно '{ЗаголовокАвтотест} (Внутренний документ)'
    И я нажимаю на кнопку с именем 'СправочникВнутренниеДокументыСоздатьВнутреннийДокументНаОсновании'
    И открылось окно 'Создание нового внутреннего документа'
    И в таблице "СписокШаблонов" я разворачиваю строку с подчиненными:
        | 'Представление'        |
        | 'ВерхняяПапкаАвтотест' |
    И в таблице "СписокШаблонов" я перехожу к строке:
        | 'Представление'    |
        | 'ШаблонАвтотест2'  |
    И я нажимаю на кнопку с именем 'СоздатьПоШаблону'
    И открылось окно 'Внутренний документ (создание)'
    И я нажимаю на кнопку с именем 'ФормаЗаписать'
    И открылось окно '{ЗаголовокАвтотест} (Внутренний документ)'

* Прикрепить файл
    Если файл "$КаталогПроекта$/DO/СписокДляФайлов.txt" существует тогда
        Тогда я запоминаю строку "$КаталогПроекта$/DO/СписокДляФайлов.txt" в переменную "ПолноеИмяФайла"
    Иначе 
        И я вызываю исключение "Отсутствует файл для прикрепления"
    Если файл "$ПолноеИмяФайла$" содержит строки тогда
        |"{ШаблонАвтотест2}"|
        Тогда я буду выбирать внешний файл "$ПолноеИмяФайла$"
        И я перехожу к закладке с именем "СтраницаФайлы"
        И в таблице "ФайлыДобавленные" я нажимаю на кнопку с именем 'СоздатьДобавленныйФайл'
        Если открылось окно 'Важно!' тогда
            Тогда я нажимаю на кнопку с именем 'Button0'
            И открылось окно 'Создание нового файла'
            И я нажимаю на кнопку с именем 'ЗагрузитьСДиска'
        Если открылось окно 'Создание нового файла' тогда
            Тогда я нажимаю на кнопку с именем 'ЗагрузитьСДиска'

* Проверить наличие файла
    Если я перехожу к закладке с именем "СтраницаФайлы" тогда
        Тогда таблица "ФайлыСоздание" стала равной:
            |'Файл'          |'Оригинал'|
            |'ПолноеИмяФайла'|'Нет'     |

* Закрыть окна и TestClient автора
    И я закрываю текущее окно
    И я закрываю TestClient "АвторПроектаАвтотест2"


@process
@T995
Сценарий: Подписание Распоряжения
//обработка документа с помощью экспортного сценария
//сценарий обработки документа из сценария T993  

    И я выполняю процесс по документу "$$СсылкаНаСозданныйДокумент$$"
