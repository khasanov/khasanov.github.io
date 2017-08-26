
 Emacs users boot with init=/usr/bin/emacs
 Avi Kivity

Что это?
 systemd  - замена SysVinit, Upstart, OpenRC и другигих init. Идеологически близка к launchd из макоси.
 D-Bus, AutoFS, cgroups, /run, замена bash-скриптов кодом на C и другие модные технологии во все поля.

Автор:
Lennart Poettering
(Все любят гипножа^w pulseaudio!)
Где почитать:
На английском
Статья Поттеринга
Страница проекта

На русском
Перевод статьи Поттеринга
Сравнение c Upstart и SysVinit
Статьи по администрированию
Установка в gentoo:
Ядро:
General setup  --->
     [*] Control Group support
Device Drivers --->
     Generic Driver Options  --->
          [*] Maintain a devtmpfs filesystem to mount at /dev
File systems  --->  
[*] Filesystem wide access notification

Дополнительные опции ядра:
File systems --->
    <M> Kernel automounter version 4 support (also supports v3)
Networking support --->
    Networking options --->
        TCP/IP networking --->
            <M> The IPv6 protocol

/boot/grub/grub.conf:
title=Gentoo with systemd
root (hd0,0)
kernel /vmlinuz root=/dev/sda5 init=/bin/systemd

/etc/portage/package.keywords:
sys-fs/udev ~amd64
sys-apps/systemd ~amd64

# ln -sf /proc/self/mounts /etc/mtab# emerge systemd
Настройка:
Основным элементом systemd являются модули (units), которые связаны между собой (Requires, Conflicts, Before, After, Wants) и имеют определенный тип.

Типы модулей:
service Традиционный демон, который может быть запущен, остановлен, перезапущен и перезагружен (start, stop, restart, reload).  Некоторые демоны (avahi, networkmanager, bluez, wpa_supplicant, consolekit) уже поддерживают systemd “из коробки”, для остальных в systemd оставлена возможность использовать традиционный SysV init-скрипт.
socket Сокет в файловой системе или сети. Каждый модуль типа “сокет” имеет соответствующий ему модуль “сервис”, который запускается при попытке установки соединения с сокетом или буфером FIFO. Пример: nscd.socket при установке соединения запускает nscd.service. 
device Устройство, описанное правилом udev. Можно использовать событие для устройства (появление/удаление) в качестве зависимости. Например, при появлении устройства bluetooth запускать bluetoothd.
mount systemd контролирует все точки монтирования файловых систем. В целях обратной совместимости поддерживается сбор информации о точках монтирования из /etc/fstab.
automount Для помеченных таким образом точек монтирования, монтирование выполняется только при обращении к ним.
target Аналог уровней исполнения (runlevels) из SystemV (см. таблицу ниже). Представляет собой группу служб, объединенных по функциональному назначению. Например, multi-user.target идентичен runlevel 5, а bluetooth.target приводит к инициализации подсистемы bluetooth (запуску bluetoothd и obexd).
snapshot Ссылка на другие модули. Снимки могут быть использованы для сохранения состояния и возможности отката назад состояния всех служб и модулей системы инициализации. Он, главным образом, предназначен для двух случаев. Первый, чтобы позволить пользователю временно перевести систему в какое-то специфичное состояние, например, однопользовательский режим с остановкой всех работающих сервисов, а затем легко вернуться в предыдущее состояние с одновременным запуском тех сервисов, которые были перед этим запущены. Второй вариант его использования - поддержка режима suspend: достаточно много сервисов не могут корректно работать с этой системой, и зачастую их лучше остановить перед засыпанием, а потом просто запустить.

SytemVinit
Runlevel
Systemd
Target
Notes
0
runlevel0.target, poweroff.target
Halt the system.
1, s, single
runlevel1.target, rescue.target
Single user mode.
2, 4
runlevel2.target, runlevel4.target, multi-user.target
User-defined/Site-specific runlevels. By default, identical to 3.
3
runlevel3.target, multi-user.target
Multi-user, non-graphical. Users can usually login via multiple consoles or via the network.
5
unlevel5.target, graphical.target
Multi-user, graphical. Usually has all the services of runlevel 3 plus a graphical login.
6
runlevel6.target, reboot.target
Reboot.
emergency
emergency.target
Emergency shell.

Конфигурационные файлы модулей имеют синтаксис схожий с файлами .desktop (.ini-формат). Доступные модули лежат в /lib/systemd/system и /etc/systemd/system (у последних приоритет выше). 

Готовые файлы настроек можно найти на
http://en.gentoo-wiki.com/wiki/Systemd и http://cgit.freedesktop.org/systemd/tree/units
Использование

Перечень запущенных сервисов:
# systemctl
или 
# systemctl list-units
Статус запущенного сервиса:
# systemctl status <service>
Запуск, остановка, перезапуск, перезагрузка сервиса:
# systemctl start|stop|restart|reload <service>
Включение или отключение автоматического запуска модуля при загрузке системы:
# systemctl enable|disable <service>
Замаскировать сервис (будет невозможно запустить даже вручную):
# ln -s /dev/null /etc/systemd/system/ntpd.service# systemctl daemon-reload
Несколько методов определения владельцев процессов:
# alias psc='ps xawf -eo pid,user,cgroup,args'# psc# ls /proc/$PID/cgroup
# tree -d /cgroup/systemd/ # systemd-cgls 
Запуск DE под systemd
# systemctl enable kdm.service
Изменение ранлевела по-умолчанию
# ln -sf /lib/systemd/system/multi-user.target /etc/systemd/system/default.target
Изменение текущего ранлевела
# systemctl isolate runlevel5.target
Добавить еще один getty
# ln -sf /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty9.service# systemctl daemon-reload# systemctl start getty@tty9.service
Убрать getty
# rm /etc/systemd/system/getty.target.wants/getty@tty5.service /etc/systemd/system/getty.target.wants/getty@tty6.service# systemctl daemon-reload# systemctl stop getty@tty5.service getty@tty6.service
GUI
Существует графический фронтэнд для настройки systemd на gtk.
