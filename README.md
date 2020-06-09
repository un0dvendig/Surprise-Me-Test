# Surprise-Me-Test
Test task for Suprise Me

## Описание
 1. Задание оценивается условно из 2 частей:
    - Дизайн основного экрана и двух дополнительных модальных.
    - Логика переходов и работа с сетью.
 2. Допускается использование сторонних библиотек.
 3. Минимальная версия iOS - 11.0, минимальная версия Swift - 4.2.
 
### Окна
  1. Основной экран `[см.макеты]`:
     - Картинку можно взять любую, но с загрузкой из интернета (например: [изображение](https://app.surprizeme.ru/media/store/1186_i1KaYnj_8DuYTzc.jpg)).
     - Должна быть сущность пользователя с его id, именем, телефоном и почтой. Можно также подставить любые заглушки.
     - При клике на флаг страны должен открываться пикер страны.
     - После того, как ввели телефон и нажали на кнопку "Confirm", нужно выполнять запрос и открывать следующий экран.
     - При нажатии на "Sign in as another person" нужно немного поменять лейаут `[см.макеты]`.
  2. Экран выбора страны `[см.макеты]`:
     - Должен соответствовать макеты.
     - Должно быть поле поиска по имени страны или коду.
     - Должен закрываться свайпом вниз.
  3. Экран ввода кода из СМС `[см.макеты]`:
     - Должен соответствовать макету.
     - Номер должен подставляться из основного экрана (из сущности юзера).
     - Должны быть разрешены только цифры для ввода в поле.
     - После ввода 4 цифр (и по кнопке "Send again") окно должно закрываться.

### Работа с сетью
  1. Нужно отправлять POST запрос с данными пользователя на адрес (https://webhook.site/4e88daa3-ddc5-436e-9659-993660603103) и с телом JSON вида {"id": USER_ID, "phone": USER_PHONE}

### Макеты
#### Оригинальные макеты
| Основной Экран | Другой лейаут | Выбор страны | Ввод кода |
| --- | --- | --- | --- |
| ![Main screen](https://github.com/un0dvendig/Surprise-Me-Test/blob/assets/1%20step%402x.jpg) | ![Different layout](https://github.com/un0dvendig/Surprise-Me-Test/blob/assets/not%20you%20sign%20in%20email%402x.jpg) | ![Country picker](https://github.com/un0dvendig/Surprise-Me-Test/blob/assets/country%20code%402x.jpg) | ![Code entry](https://github.com/un0dvendig/Surprise-Me-Test/blob/assets/Code%402x.jpg) |

#### Отрефакторенные макеты
| Другой лейаут | Выбор способа ввода |
| --- | --- |
|  |  |

#### App flow
| Оригинальные макеты | Отрефакторенные макеты |
| --- | --- |
|  |  |

## Screenshots
| Main screen | Country Picker | Code entry |
| --- | --- | --- | 
|  |  |  | 

| Different layout | Another sign in methods |
| --- | --- |
|  |  |

## Used libraries
  1. [CountryPicker](https://github.com/SURYAKANTSHARMA/CountryPicker)
  2. [KAPinField](https://github.com/kirualex/KAPinField)

## Run manual
 1. Clone or download this repo.
 2. Run `pod install` from the project folder.
 3. Open `Surprise Me Test.xcworkspace` and run the project on selected device or simulator.
 
 ## Credits
 Icons by [8icons](https://icons8.com).
 
 ## TODO
  - [X] Complete *layout change*
  - [X] Add unit tests
     - [X] Add more unit tests
  - [X] Add UI tests
     - [X] Add more UI tests
  - [ ] Complete Readme.md
     - [X] Add screenshots
     - [ ] Add refactored interface layouts
     - [ ] Add app flows
     - [ ] Add real screenshots
  - [ ] Fix visual bugs for iPhone 5/5S
