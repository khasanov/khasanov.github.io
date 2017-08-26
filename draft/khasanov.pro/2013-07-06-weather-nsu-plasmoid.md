Плазмоид KDE для показа температуры около НГУ
=============================================

-Вы не скажете, сколько сейчас градусов ниже нуля?
(с) Операция «Ы»
Этим чудесным субботним утром я задумался: "а сколько же градусов на улице?". К счастью, в наш век интернета ответ получить легко даже без термометра под рукой. Например, есть такой ресурс, как weather.nsu.ru.
Но почему бы не иметь актуальную информацию на рабочем столе? Итак, сегодня мы напишем плазмоид KDE, который будет показывать температуру около Новосибирского Государственного Университета.
Выбор инструментов

Как написано здесь, команда KDE рекомендует использовать для написания плазмоидов QML, да и мне давно хотелось потрогать эту технологию. Как выяснилось, пока ещё плазма не поддерживает QtQuick 2, к сожалению. Поэтому сегодня придется обойтись только QtQuick 1.1
Разработка

QML мне показался очень похожим с виду на CSS, синтаксис интуитивно понятен и прост, так что без колебаний ринемся сразу в бой.
Логика

Спасибо разработчикам, ресурс по запросу weather.nsu.ru/xml_brief.php отдает xml следующего вида:

19.72
23.04

23.04


Согласно документации в QML есть элемент XmlListModel, который может сразу получить и распарсить данные. Клёво! Однако, модель работает с представлением, таким, как ListView, например. Но нам нужно всего-то лишь вывести текст, поэтому добавим элемент Text и его свойство text = temperature. Переменная temperature изменится после загрузки данных.
import QtQuick 1.1

Item {
    id: root
    width: 400; height: 400

    property real temperature: 0

    Text {
        anchors.centerIn: root
        text: temperature
    }

    XmlListModel {
        id: weatherModel
        source: "http://weather.nsu.ru/xml_brief.php"
        query: "/weather"

        XmlRole { name: "current"; query: "current/string()" }
        XmlRole { name: "average"; query: "average/string()" }

        onStatusChanged: {
            if (status == XmlListModel.Ready)
                temperature = get(0).current
        }
    }
}
Ок, но давайте обновлять значение каждые 15 минут, например. Да, я не сказал, что есть такая утилита qmlviewer, которая позволяет интерактивно просматривать получившийся результат. После изменения кода можно просто нажать F5 для обновления, прямо как в браузере.
    Timer {
        interval: 15*60*1000; running: true; repeat: true; // 15 min
        onTriggered: {
            weatherModel.reload()
        }
    }
Интерфейс

Половина работы сделана, осталось добавить немного дизайна. Давайте... э... поиграем шрифтами... Ну вот Comics Sans, например, прикольный шрифт :) Ну и там ещё чего-нибудь поменяем...
import QtQuick 1.1

Item {
    id: root
    width: 400; height: 400

    property real temperature: 0

    Rectangle {
        id: background
        anchors.fill: parent
        color: "black"

        Text {
            id: label
            anchors.centerIn: background
            textFormat: Text.RichText
            style: Text.Sunken
            font.family: "Comic Sans MS"
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 26
            color: "green"
            text: temperature + " °C"
        }
    }

    XmlListModel {
        id: weatherModel
        source: "http://weather.nsu.ru/xml_brief.php"
        query: "/weather"

        XmlRole { name: "current"; query: "current/string()" }
        XmlRole { name: "average"; query: "average/string()" }

        onStatusChanged: {
            if (status == XmlListModel.Ready)
                temperature = get(0).current
        }
    }

    Timer {
        interval: 15*60*1000; running: true; repeat: true; // 15 min
        onTriggered: {
            weatherModel.reload()
        }
    }
}
Класс! Хочется добавить логотип alma mater. Ух ты, надо же, универ проводит ребрендинг: новый сайт, к осени — новый логотип. Из предложенных работ понравился логотип, который в виде цветного круга, где каждый цвет — отдельный факультет. Ммм, а как разместить элементы по кругу? Гугл, выручай! Ага, находим решение.
import QtQuick 1.1

// see http://qt-project.org/wiki/Qt_Quick_Carousel

Path {
    id: p
    property real width: 200
    property real height: 200
    property real margin: 50
    property real cx: width / 2
    property real cy: height / 2
    property real rx: width / 2 - margin
    property real ry: height / 2 - margin
    property real mx: rx * magic
    property real my: ry * magic
    property real magic: 0.551784
    startX: p.cx; startY: p.cy + p.ry
    PathCubic { // second quadrant arc
        control1X: p.cx - p.mx; control1Y: p.cy + p.ry
        control2X: p.cx - p.rx; control2Y: p.cy + p.my
        x: p.cx - p.rx; y: p.cy
    }
    PathCubic { // third quadrant arc
        control1X: p.cx - p.rx; control1Y: p.cy - p.my
        control2X: p.cx - p.mx; control2Y: p.cy - p.ry
        x: p.cx; y: p.cy - p.ry
    }
    PathCubic { // forth quadrant arc
        control1X: p.cx + p.mx; control1Y: p.cy - p.ry
        control2X: p.cx + p.rx; control2Y: p.cy - p.my
        x: p.cx + p.rx; y: p.cy
    }
    PathCubic { // first quadrant arc
        control1X: p.cx + p.rx; control1Y: p.cy + p.my
        control2X: p.cx + p.mx; control2Y: p.cy + p.ry
        x: p.cx; y: p.cy + p.ry
    }
}
А теперь применим маленький чит — круг можно представить квадратом со скруглёнными уголками, если радиус скругления задать равным половине ширины квадрата. Цвета подбирал так: взял KColorChooser, значение цвета вставлял в http://www.color-hex.com/color/XXXXXX, далее смотрел, какой из "безопасных цветов" ему соответствует. Для градиента на том же сайте брал второе значение в разделах Shades и Tints. Вот что получилось:

Код:
import QtQuick 1.1

PathView {
    id: view
    width: 200
    height: 200
    model: colorModel
    delegate:
        Rectangle {
        width: parent.width < parent.height ? parent.width / 10 : parent.height / 10
        height: width
        radius: width * 2
        smooth: true
        gradient: Gradient {
            GradientStop { position: 0.0; color: color1 }
            GradientStop { position: 1.0; color: color2 }
        }
    }
    path: Ellipse {
        width: view.width
        height: view.height
    }

    ListModel {
        id: colorModel
        ListElement { color1 : "#ff8432"; color2: "#cc5100" }
        ListElement { color1 : "#add632"; color2: "#7aa300" }
        ListElement { color1 : "#d65bad"; color2: "#a3287a" }
        ListElement { color1 : "#a4c1a3"; color2: "#718e70" }
        ListElement { color1 : "#d65b5b"; color2: "#a32828" }
        ListElement { color1 : "#32adad"; color2: "#007a7a" }
        ListElement { color1 : "#845bad"; color2: "#51287a" }
        ListElement { color1 : "#adadd6"; color2: "#7a7aa3" }
        ListElement { color1 : "#ad3284"; color2: "#7a0051" }
        ListElement { color1 : "#32add6"; color2: "#007aa3" }
        ListElement { color1 : "#ffd632"; color2: "#cca300" }
        ListElement { color1 : "#5bad32"; color2: "#287a00" }
        ListElement { color1 : "#adadd6"; color2: "#7a7aa3" }
        ListElement { color1 : "#ad8432"; color2: "#7a5100" }
        ListElement { color1 : "#5b84ad"; color2: "#28517a" }
    }
}
Теперь добавим фон и ссылку на сайт:
import QtQuick 1.1

Item {
    id: root
    width: 400; height: 400

    property real temperature: 0

    Rectangle {
        id: background
        anchors.fill: parent
        color: "black"

        Text {
            id: head
            width: background.width
            anchors.bottom: logo.top

            textFormat: Text.RichText
            style: Text.Sunken
            font.family: "Comic Sans MS"
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            color: "#558ac0"
            smooth: true
            text: qsTr("Температура около НГУ")

            MouseArea {
                anchors.fill: head
                onClicked: Qt.openUrlExternally("http://weather.nsu.ru")
            }
        }

        LogoNSU {
            id: logo
            anchors.centerIn: background
            width: (root.width < root.height ? root.width : root.height) - 50
            height: width
        }

        Text {
            id: label
            anchors.centerIn: background
            textFormat: Text.RichText
            style: Text.Sunken
            font.family: "Comic Sans MS"
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 26
            color: "green"
            text: temperature + " °C"
        }
    }

    XmlListModel {
        id: weatherModel
        source: "http://weather.nsu.ru/xml_brief.php"
        query: "/weather"

        XmlRole { name: "current"; query: "current/string()" }
        XmlRole { name: "average"; query: "average/string()" }

        onStatusChanged: {
            if (status == XmlListModel.Ready)
                temperature = get(0).current
        }
    }

    Timer {
        interval: 15*60*1000; running: true; repeat: true; // 15 min
        onTriggered: {
            weatherModel.reload()
        }
    }
}
Создаём плазмоид

Для того, чтобы превратить наш код в плазмоид, необходимо всего лишь создать правильную структуру каталогов и написать .desktop-файл. Сделаем это
[Desktop Entry]
Name=weathernsu
Name[ru]=Погода около НГУ
Comment=KDE plasmoid that displays current temperature near Novosibirsk State University
Comment[ru]=KDE плазмоид, который показывает текущую температуру около Новосибирского Государственного Университета
Icon=weathernsu.png

X-Plasma-API=declarativeappletscript
X-Plasma-MainScript=ui/main.qml
X-Plasma-DefaultSize=400,400
 
X-KDE-PluginInfo-Author=Sergey A. Khasanov
X-KDE-PluginInfo-Email=s.a.khasanov@gmail.com
X-KDE-PluginInfo-Website=http://www.khasanov.pro
X-KDE-PluginInfo-Category=Environment and Weather
X-KDE-PluginInfo-Name=weathernsu
X-KDE-PluginInfo-Version=1.0
X-KDE-PluginInfo-Depends=
X-KDE-PluginInfo-License=MIT
X-KDE-PluginInfo-EnabledByDefault=true
X-KDE-ServiceTypes=Plasma/Applet
Type=Service
Установка

Можно воспользоваться утилитой plasmapkg
plasmapkg --install weathernsu
Либо использовать cmake, как обычно. Учтите, что по умолчанию используется /usr/local, ну или нет, не знаю, что там в этих ваших тысячах разных линуксов :) Видео установки:

Что получилось


Заключение

Что понравилось:

синтаксис QML
инкрементальная разработка (внес изменения в код, нажал F5)
Что не понравилось:

пока ещё мало примеров, ну или не знаю, где гуглить
приходится извращаться для получения простых вроде решений, по типу эллипса (видимо решается использованием QtQuick 2, где появились новые элементы и возможности)
В целом, хеллоуворды писать на QML довольно приятно и просто.
Исходники:

Исходники как обычно доступны на GitHub
