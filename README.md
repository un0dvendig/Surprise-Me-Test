# Surprise-Me-Test
Test task for Suprise Me

## Описание
 1. Задание оценивается условно из 2 частей:
    - Дизайн основного экрана и двух дополнительных модальных.
    - Логика переходов и работа с сетью.
 2. Допускается использование сторонних библиотек.
 3. Минимальная версия iOS - 11.0, минимальная версия Swift - 4.2.
 
### Окна
  1. Основной экран:
     - Картинку можно взять любую, но с загрузкой из интернета (например: https://app.surprizeme.ru/media/store/1186_i1KaYnj_8DuYTzc.jpg).
     - Должна быть сущность пользователя с его id, именем, телефоном и почтой. Можно также подставить любые заглушки.
     - При клике на флаг страны должен открываться пикер страны.
     - После того, как ввели телефон и нажали на кнопку "Confirm", нужно выполнять запрос и открывать следующий экран.
     - При нажатии на "Sign in as another person" нужно немного поменять лейаут на такой макет.
  2. Экран выбора страны:
     - Должен соответствовать макеты.
     - Должно быть поле поиска по имени страны или коду.
     - Должен закрываться свайпом вниз.
  3. Экран ввода кода из СМС:
     - Должен соответствовать макету.
     - Номер должен подставляться из основного экрана (из сущности юзера).
     - Должны быть разрешены только цифры для ввода в поле.
     - После ввода 4 цифр (и по кнопке "Send again") окно должно закрываться.

### Работа с сетью
  1. Нужно отправлять POST запрос с данными пользователя на адрес (https://webhook.site/4e88daa3-ddc5-436e-9659-993660603103) и с телом JSON вида {"id": USER_ID, "phone": USER_PHONE}

## Used libraries
  1. [CountryPicker](https://github.com/SURYAKANTSHARMA/CountryPicker)
  2. [KAPinField](https://github.com/kirualex/KAPinField)

## Run manual

 1. Clone or download this repo.
 2. Run `pod install` from the project folder.
 3. Open `Surprise Me Test.xcworkspace` and run the project on selected device or simulator.
 
 ## TODO
 
  - [X] Complete *layout change*
  - [X] Add unit tests
  - [ ] **UPD:** Add more unit tests
  - [X] Add UI tests
  - [ ] **UPD:** Add more UI tests
  - [ ] Complete Readme.md
