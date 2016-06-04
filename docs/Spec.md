**Задача:** 

Разработать небольшое приложение, которое будет получать список друзей
пользователя в социальной сети [vk.com](http://vk.com/) после
авторизации.

*Требования к приложению:*

• При входе в приложение предлагать пользователю авторизоваться через
vk;

• После авторизации отобразить список друзей;

• Содержимое ячейки с другом: фамилия, имя, город, университет

• Аватарки загружать асинхронно;

• в списке необходимо реализовать возможность обновления данных
(Pull-to-refresh);

• в списке необходимо реализовать возможность поиска друга (любое из
вхождение по параметрам имя, фамилия, город или университету);

• при клике на ячейку открывать Detail Controller, на котором необходимо
отобразить список групп выбранного пользователя;

• особое внимание уделить быстродействию;

• приложение должно поддерживать iOS 7;

• приложение должно одинаково “хорошо” отображаться на всех устройствах,
интерфейс нужно проектировать с использованием Autolayout и/или Size
Classes.

*Примечания:*

• архитектура приложения на ваше усмотрение;

• кешировать данные не обязательно;

• приложение не должно использовать DEPRECATED методы.

• Используемые методы не требуют авторизации, она нужна для определения
user\_id.

iOS SDK <https://vk.com/dev/ios_sdk>

Список методов: <https://vk.com/dev/methods> 