# DreamTeam2_5923

Вас приветсвует туториал по установке програмного обеспечания для работы с ультразвуковым радаром HC-SR04.
(Данное руководство актуально для Windows ОС)
__________________________________________________________________________________________________________

Команда разработки: *DreamTeam2*

По техническим вопросам, связанным с огранизацией проекта, обращаться на почту: 

- domrachevilya@mail.ru (И.К. Домрачев) - ответственный за организацию

или

- shemet162534@gmail.com или телеграмм - https://t.me/AEShemet (А.Е. Шемет) - специалист по технической поддержке 

__________________________________________________________________________________________________________

=====================================

Перед началом работы: 

1. Укажите свой последовательный порт. (если Вам не нужен графический вывод данных на экран - пропустите этот пункт)

~ Откройте проект на Arduino, расположенный в папке "main"

~ Подключите Радар к компьютеру

~ Перейдите во вспомогательную вкладку "Инструменты" -> "Порт", при удачном подключении, пункт «Порт» должен стать активным

~ Посмотрите название вашего порта и впишите его второй строчкой в файл "Settings and TelegramID" (по-умолчанию COM3)

~ Сохраните файл

=====================================

2. Уточните свой Телеграм-ID. (если Вы не хотите получать уведомления на Телеграм - пропустите 2 и 3 пункты)

~ Добавьте в свой телеграмм бота, прописав в поисковике Телеграма: @MyTelegramID_bot (выберите любого бота)

~ Нажмите на старт и дождитесь, когда бот пришлет Вам ID (пример: 476213596)

~ Впишите цифры вашего ID последней отдельной строчкой в файл "Settings and TelegramID"

~ Сохраните файл

=====================================

3. Укажите путь до директории.

Чтобы подключить функционал Телеграм-бота, осталось указать директорию, где находится Processing.

~ Перейдите в папку "ultrasonic_radar"

~ Скопируйте адрес к содержимому в этой папке (пример: C:\Users\ILYA\Desktop\ultrasonic_radar)

~ Полученный адрес вставьте с заменой в первую строчку файла "Settings and TelegramID" 

(формат разделителей менять не надо, при условии что Вы изпользуете Windows ОС - программа сама преобразует данный адрес для своего использования)

~ Сохраните файл

=====================================
__________________________________________________________________________________________________________

Спасибо, что выбрали нас!
