Disclaimer

Публичная оферта портала drom.ru запрещает использование автоматизированного извлечения информации портала без письменного разрешения ООО «Амаяма Авто».
Так что всё, описанное ниже, является вымыслом автора и никогда не применялось на практике, любые совпадения случайны и всё такое, я вас предупредил.
Преамбула

Такое дело, присматриваю я себе жоповозку автомобиль не спеша. А поскольку от автотемы я весьма далёк, да ладно, полный ноль по чесноку если, решил подойти к делу несколько заморочено, как умею. Вопрос первый, на который я попробую найти ответ — за сколько денег продают автомобиль?
Все расчёты и исходники скриптов выложены на GitHub, может пригодятся кому в образовательных целях. 1
Фабула 2

Основная идея состоит в том, чтобы по объявлениям о продаже авто в этих ваших интернетах найти “правильную” цену купли-продажи автомобиля. Ну и посмотреть, на что годится эта ваша алгебра и всякие модные machine learning штучки.

Что нужно сделать?
Получить набор данных (training set).
Обучить искусственный интеллект.
???
Profit!
Получение набора данных

Для получения набора данных я использую популярный сайт объявлений о продаже автомобилей drom.ru.
Быстрое гугление на тему, а нет ли у сайта какого-либо API, сразу показало, что такового нет, а значит, придется парсить html-страницы. Cложности возникают только если пытаться получить номера телефонов продавцов, но мне они как бы совсем не нужны, поэтому использую стандартный wget. Скачаю, например, актуальные объявления о продаже Toyota Caldina в Новосибирске:
   wget -r --no-parent http://novosibirsk.drom.ru/toyota/caldina/
где ключ -r задает рекурсивное скачивание, а –no-parent говорит не подниматься выше по иерархии каталогов.
Итого — 371 объявление. Если хочется посмотреть более старые объявления, нужно перейти на страницы архива, например, http://auto.drom.ru/archive/region54/toyota/caldina/
Парсинг данных

Накидал на коленке скрипт на python с использованием библиотеки BeatifulSoup. Поскольку я не настоящий сварщик, критика весьма приветствуется.
#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
    DromExpert Parser
    This script should read all html pages in a specific
    directory, extract data and write them to a plain text file.
    Single file is converted into one row.
    Headers of columns are:
    Price in rubles, Year, Brand, Model, Engine, Transmission, Drive,
    Mileage, Wheel, Optional, City, Advertisment number (ID), Date of publication.
"""

import os
from BeautifulSoup import BeautifulSoup

html_directory = "./novosibirsk.drom.ru/toyota/caldina/"
output_file = "./caldina.txt"
data = u""
delimiter = "\t"

def read_file(filePath):
    """ 
       Reads the file and returns its contents as a string.
    """
    try:
        f = open(filePath, "r")
    except IOError:
        print "Could not open file ", filePath

    html = f.read()

    try:
        f.close()
    except IOError:
        print "Could not close file ", filePath

    return html

def write_file(fileContent):
    """
        Gets the contents and writes it to a file.
    """
    try:
        f = open(output_file, "w")
    except IOError:
        print "Could not open file ", output_file

    f.write(fileContent)

    try:
        f.close()
    except IOError:
        print "Could not close file ", output_file


def parse_file(filePath):
    """
        Read advertisement and extract data to the string
    """
    car_price = car_year = car_brand = car_model = car_engine = car_transmission = car_drive = car_mileage = car_wheel = car_optional = adv_city = adv_id = adv_date = u"null"
    columns = []

    soup = BeautifulSoup(read_file(filePath))

    adv_id = os.path.basename(filePath)[:-5]  # cut-off last 5 characters (".html")
    adv_date = soup.find('p', attrs={'class':'autoNum'}).string.split()[-1]
    car_price = soup.find('div', attrs={'class':'price'}).contents[0].string.replace(' ', '')[:-4]

    tmp = soup.findAll('h3')
    if tmp[0].string == u"Автомобиль продан!":
        car_year = tmp[1].string.split()[-2]
        car_brand = tmp[1].string.split()[0]
        car_model = tmp[1].string.split()[1][:-1]
    else:
        car_year = tmp[0].string.split()[-2]
        car_brand = tmp[0].string.split()[0]
        car_model = tmp[0].string.split()[1][:-1]

    for l in soup.findAll('span', attrs={'class':'label'}):
        if l.next == u"Двигатель:":
            car_engine = l.next.next
        if l.next == u"Трансмиссия:":
            car_transmission = l.next.next
        if l.next == u"Привод:":
            car_drive = l.next.next
        if l.next == u"Пробег, км:":
            car_mileage = l.next.next
        if l.next == u"Руль:":
            car_wheel = l.next.next
        if l.next == u"Дополнительно:":
            car_optional = l.next.next
        if l.next == u"Город:":
            adv_city = l.next.next

    columns.append(car_price)
    columns.append(car_year)
    columns.append(car_brand)
    columns.append(car_model)
    columns.append(car_engine)
    columns.append(car_transmission)
    columns.append(car_drive)
    columns.append(car_mileage)
    columns.append(car_wheel)
    columns.append(car_optional)
    columns.append(adv_city)
    columns.append(adv_id)
    columns.append(adv_date)

    result = u""
    for i in columns:
        result += i + delimiter

    return result + "\n"


if  __name__ ==  "__main__":
    extension = ".html"
    filesList = [fileName for fileName in os.listdir(html_directory) if fileName.lower().endswith(extension)]

    counter = 0;
    for fileName in filesList:
        print "Processing ", fileName
        ad = parse_file(os.path.join(html_directory, fileName))
        data += ad
        counter += 1

    write_file(data.encode("utf-8"))
    print "Total ", counter, " ads processed."
Ок, получившийся файл caldina.txt почти хорош для дальнейшего использования, но есть нюанс — некоторые личности зачем-то пишут цену в долларах, или после продажи пишут цену 0 или явно нереальную (999999 руб, например). Так что я просто выкинул эти объявления, всего 18 штук.
Визуализация

Набор чисел в файле — это конечно хорошо, но не очень наглядно. Давайте загоним данные в octave и посмотрим, например, на график зависимости цены от года выпуска. Вот код на octave.
function plotData(x, y)
%PLOTDATA Plots the data points x and y into a new figure 
%   PLOTDATA(x,y) plots the data points and gives the figure axes labels of
%   price and year.

figure;                                  % open a new figure window
plot(x, y, 'rx', 'MarkerSize', 8);       % Plot the data
ylabel('Price');                         % Set the y-axis label
xlabel('Year');                          % Set the x-axis label
end

%% Initialization
clear ; close all; clc

%% Plotting training data
fprintf('Plotting Data ...\n')
data = load("./caldina.csv");             % read comma separated data
Y = data(:, 1);                           % price
X = data(:, 2);                           % year
m = length(Y);                            % number of training examples
plotData(X, Y);
print -dpng caldina1.png                  % save figure as png
fprintf('Program paused. Press enter to continue.\n');
pause;
Вот так выглядит график. 
Supervised learning

Настало время на основе данных восстановить зависимость, т.е. построить алгоритм, способный для любого набора параметров выдать достаточно точный ответ, чего этот набор стоит?
Если выписать параметры в виде таблички и добавить в начале еще одну колонку, получится примерно следующее:
x0
x1 (Year)
...
...
xn (Price)
1
2007
...
...
596000
1
1993
...
...
160000
1
1995
...
...
185000
1
...
...
...
...
1
1999
...
...
239000
Теперь $$X = \begin{pmatrix} 1 & 2007 & ... \\ 1 & 1993 & ... \\ 1 & 1995 & ... \\ ... & ... & ... \\ 1 & 1999 & ... \end{pmatrix}  ,  Y = \begin{pmatrix} 596000 \\ 160000 \\ 185000 \\ ... \\ 239000 \end{pmatrix}$$
Для получения зависимости цены от года использую линейную регрессию с одной переменной.
Основной смысл — минимизировать функцию стоимости
$$J(\Theta)=\frac{1}{2m}\sum\limits_{i=0}^m(h_\theta(x_i)-y_i)^2$$ , где гипотеза представлена линейной моделью $$h_\theta(x) = \Theta^Tx = \Theta_0 + \Theta_1x_1$$ Добавим в код на octave следующее:
%% Theta
X = [ones(m, 1), data(:,2)];             % Add a column of ones to x
theta = pinv(X'*X)*X'*Y;                 % initialize fitting parameters

% print theta to screen
fprintf('%f %f \n', theta(1), theta(2));

% Plot the linear fit
hold on;                                 % keep previous plot visible
plot(X(:,2), X*theta, '-')
legend('Training data', 'Linear regression')
print -dpng sprinter_carib_lr.png
hold off                                 % don't overlay any more plots on this figure
Вот так выглядит гипотеза для предыдущего набора данных. 
А теперь предскажем цену, например, для 1994 года.
% Predict price for year 1994
predict = [1, 1994] *theta;
fprintf('For year = 1994, we predict a price of %f\n', predict);
fprintf('Program paused. Press enter to continue.\n');
pause;   
For year = 1994, we predict a price of 149869.908315
Заключение

Итак, мы научились предсказывать цену автомобиля по году его выпуска для конкретной модели в конкретном регионе.
Для получения более точной модели следующим шагом будет использование линейной регрессии с несколькими переменными.
Всех с пятницей и спасибо за рыбу.
1 Потому что в коммерческих их использовать нельзя, да и наверное, бесполезно, т.к. профессиональные продаваны скорее всего имеют свежие сведения еще до того, как "вкусный" вариант появится на сайте, ну или нет. Но на месте владельцев сайта, я бы имел свой маленький карманный такой дополнительный бизнес, заработал кучу бабок, а потом, ну не знаю, катался с шлюхами по стране... wait, oh shi...
2 Да-да, никакой такой "амбулы"!
