**Выпущена версия 1.0.1.015 (Обновление от 15.01.2017)**

Изменения
* Добавлен справочник "Вопросы/Ответы". Чтобы включить данный функционал, необходимо зайти в "Настройки" и указать "Использовать вопросы и ответы";
* В справочник "Задачи" добавлена ТЧ: ИсторияСтатусов;
* #18 При переносе в статус архив не отправлять уведомления (УЗ 120);
* Исправление найденных ошибок:
    * #17 поправил ошибку при создании задач, если указаны отборы по доп.реквизитам;
    * №110 При переносе ветки задач в корень, то основная задача не меняетя у подчиненных задач.


**Выпущена версия 1.0.1.013 (Обновление от 29.12.2016)**

Изменения

* Реализована возможность указывать ЧасыФакт, ЧасыПлан, ЧасыКОплате. #5
Для этого необходимо включить в настройках опцию "Использовать учет времени". 
В этом случае в задачах появится отдельная закладка "Учет времени". В отчет по задачам также добавлены ресурсы "ЧасыПлан", "ЧасыФакт", "ЧасыКОплате";

* Реализована возможность указывать произвольный цвет для задач #11. Цвет можно указать в следующих объектах:
    * Задача
    * Спринт
    * ОсновнаяЗадача
    * Важность

Данные изменения выполнил @BUDIVAL, большое спасибо ему за это.
Если, Вам, тоже хочется сказать ему спасибо, 
то откройте его профиль на Инфостарт (http://infostart.ru/profile/90596/), выберите любую его публикацию и поставьте звезду.

**Выпущена версия 1.0.1.012 (Обновление от 13.12.2016)**

Изменения:

Теперь Канбан доска и отчет по задачам показывает только те задачи у которых реквизит "ПоказыватьВОтчетахИКанбанДоске" = Истина;
Исправление прав ролей по найденным ошибкам;

**Выпущена версия 1.0.1.011 (Обновление от 06.12.2016)**

Добавлены новые статусы задач:

"Запрос на добавление";
"К переносу в рабочую".


**Выпущена версия 1.0.1.010 (Обновление от 04.12.2016)**

Исправление прав и найденных ошибок.

Исправлена ошибка:

#9 Ошибка при попытке создания группы в справочнике Конфигурации

**Выпущен версия 1.0.1.009 (Обновление от 26.11.2016)**

Изменения:

- реализована возможность указывать дополнительные реквизиты и дополнительные свойства для задач;

Чтобы включить дополнительные реквизиты и свойства необходимо: 

1) Нажать Администрирование - Общие настройки - Установить признак "Дополнительные реквизиты и сведения"

2) добавить дополнительные реквизиты или свойства 

3) теперь дополнительные реквизиты будут показаны в задаче на закладке "Дополнительно". 

По дополнительным реквизитам и свойствам можно делать отборы на канбан доске, списке задач, отчеты по задачам.

- реализована возможность указывать заметки для задач.

Чтобы включить заметки необходимо:

1) Нажать Администрирование - Органайзер - Установить признак "Заметки"

2) теперь можно добавлять заметки к задачам.
 

**Выпущена версия "1.0.1.007" (Обновление от 15.11.2016)**

исправлены ошибки. Пора делать сервер сборок и писать тесты, прошу прощения у тех, кого ошибки затронули.


**Выпущена версия "1.0.1.006" (Обновление от 14.11.2016)**

исправлены ошибки. 

**Выпущена версия "1.0.1.005" изменения:**

Возможность следить за задачей, чтобы при изменении задачи дополнительно отправлялись уведомления тому, кто следит за задачей;
Проект на Github: https://github.com/BlizD/Tasks
Видео об изменениях https://youtu.be/eYvjlt5P0P4

**Выпущена версия "1.0.1.003" изменения (Обновление от 04.11.2016):**

Комментарии перенесены на первую закладку, теперь они могут выступать и в роли подзадач;
Реализована возможность ручного ввода информации об измененных объектах (выполнено пожелание пользователя).
Видео об изменениях https://youtu.be/xWbB6s4eL8o

**Выпущена версия "1.0.1.001" изменения (Обновление от 23.10.2016):**

Реализована возможность загрузки изменений из хранилища конфигурации 1с;
Добавлено регламентное задание «Загрузка изменений из хранилища» выполняется раз в сутки в 23:00.

**Выпущена версия "1.0.0.006" изменения(Обновление от 04.10.2016):**

При создании задач из канбан доски, реквизиты задачи заполняются из установленных отборов (выполнено пожелание пользователя);
Реализовано сохранение отборов и настроек для канбан доски. Если необходимо установить стандартные настройки, воспользуйтесь соответствующей кнопкой на закладке "Настройки" (выполнено пожелание пользователя).