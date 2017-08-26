Как запустить Google SketchUp 8 под gentoo на Optimus-видеокарте
================================================================

Начнем с тривиальных вещей — нужен wine. Это просто:
 # emerge -av wine
 Приложение запускается, но перед инициализацией главного окна вываливается с сообщением “SketchUp was unable to initialize OpenGL”
 И нет, чтобы сразу на http://wiki.winehq.org/GoogleSketchup залезть, нет же, линуксоид всегда знает в чем дело :)

А мысль была о том, что требуется хардварное ускорение, т.е. надо запинать nVidia Optimus.
Сказано — сделано. Лезем на http://en.gentoo-wiki.com/wiki/X.Org/nVidia_Optimus
# emerge -av x11-drivers/nvidia-drivers
# emerge -av x11-drivers/xf86-video-intel
# eselect opengl set xorg-x11 (ну так оно и было)
Создаем /etc/X11/xorg.conf (и это в 2012 году-то!)

Section "Module" 
    Disable        "dri"
EndSection

Section "ServerFlags"
    Option "AllowEmptyInput" "no"
EndSection

Section "Monitor"
    Identifier "Monitor0"
    VendorName     "Unknown"
    ModelName      "Unknown"
    HorizSync       28.0 - 73.0
    VertRefresh     43.0 - 72.0
    Option         "DPMS"
EndSection

Section "Device"
    Identifier     "Device1"
    Driver         "intel"
    VendorName     "onboard"
    BusID          "PCI:0:2:0"
    #Screen         1
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "Device1"
    Monitor        "Monitor0"
    DefaultDepth    24
    SubSection     "Display"
        Depth       24
    EndSubSection
EndSection

Создаем конфиг для второго сервера, который будет работать на нвидии.
/etc/X11/xorg.nvidia.conf

Section "DRI"
        Mode 0666
EndSection

Section "ServerLayout"
    Identifier     "Layout0"
    Screen         "Screen1"
    Option         "AutoAddDevices" "false"
EndSection

Section "Module"
        Load  "dbe"
        Load  "extmod"
        Load  "glx"
        Load  "record"
        Load  "freetype"
        Load  "type1"
EndSection

Section "Files"
EndSection

Section "Device"
    Identifier     "Device1"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BusID          "PCI:01:00:0"
    Option         "IgnoreEDID"
    Option         "ConnectedMonitor" "CRT-0"
EndSection

Section "Screen"
    Identifier     "Screen1"
    Device         "Device1"
    Monitor        "Monitor0"
    DefaultDepth    24
    SubSection     "Display"
        Depth       24
    EndSubSection
EndSection


Section "Extensions"
Option "Composite" "Enable"
EndSection

Section "Monitor"
    Identifier "Monitor0"
    VendorName     "Unknown"
    ModelName      "Unknown"
    HorizSync       28.0 - 73.0
    VertRefresh     43.0 - 72.0
    Option         "DPMS"
EndSection

Пробуем запустить...
# X -ac -config /etc/X11/xorg.nvidia.conf -sharevts -modulepath /usr/lib/opengl/nvidia,/usr/lib/xorg/modules -nolisten tcp -noreset :1 vt9
… и обламываемся, поскольку ядро юзает нвидивский фреймбуфер (зачем, кстати?)
Ок, отрубаем эту фигню:

-> Device Drivers
  -> Graphics support
     -> Support for frame buffer devices
         < > nVidia Framebuffer Support

Пересобираем ядро, запускаем систему с ним, пробуем еще раз запустить вторые иксы... и снова облом. В ядре еще включено nouveau, только не там, где Graphics support, а там, где

-> Device Drivers
   -> Staging drivers
      < > Nouveau (nVidia) cards

Еще раз пересобираем ядро, ребутимся.

Запиливаем инит-скрипт /etc/init.d/optimus

#!/sbin/runscript

depend()
{
        need xdm
        after xdm
}

start()
{
        ebegin "Starting Optimus X Server"                                                                                                                                                    
                                                                                                                                                                                                
        export LD_LIBRARY_PATH="/usr/lib/opengl/nvidia/lib:${LD_LIBRARY_PATH}"

        start-stop-daemon --start --background --pidfile /tmp/.X1-lock --exec /usr/bin/X \
            -- -ac -config /etc/X11/xorg.nvidia.conf -sharevts -modulepath /usr/lib/opengl/nvidia,/usr/lib/xorg/modules -nolisten tcp -noreset :1 vt9

        eend $?
}

stop()
{
        ebegin "Stopping Optimus X Server"

        start-stop-daemon --stop --exec /usr/bin/X \
            --pidfile /tmp/.X1-lock

        eend $?
}
Делаем его исполняемым
# chmod +x /etc/init.d/optimus
И запускаем:
# /etc/init.d/optimus start
И о чудо, оно работает! Но как запускать на нем приложения?
Тырим 64-битный rpm с http://sourceforge.net/projects/virtualgl/files/VirtualGL/

Ставим rpm2targz:
# emerge -av app-arch/rpm2targz
Распаковываем, ставим в систему по-слакварному и обновляем кэш библиотек:
$ rpm2tar VirtualGL-*.rpm && tar xvf VirtualGL-*.tar# cp -r opt usr / && ldconfig
Создаем конфиг /etc/default/optimus
# VirtualGL Defaults

# Display for the nVidia X Server
VGL_DISPLAY=:1

# Image transport xv|yuv
VGL_COMPRESS=xv

# Readback mode
VGL_READBACK=fbo

# Logging
VGL_LOG=/var/log/vgl.log

И запиливаем исполняемый файл /usr/local/bin/optirun

#!/bin/bash

if [ ! -f /tmp/.X1-lock ]; then
        echo "Optimus X Server is not running!"
        exit 1
fi

source /etc/default/optimus

export VGL_READBACK
export VGL_LOG
vglrun -c $VGL_COMPRESS -d $VGL_DISPLAY -ld /usr/lib/opengl/nvidia/lib "$@"

# chmod +x /usr/local/bin/optirun
Проверяем:
sergey@devil~/VirtualGL $ glxgears297 frames in 5.0 seconds = 59.275 FPS299 frames in 5.0 seconds = 59.680 FPS
sergey@devil~/VirtualGL $ optirun glxgears4012 frames in 5.0 seconds = 802.314 FPS4365 frames in 5.0 seconds = 872.931 FPS

Ура, оптимус работает.

Запускаем SketchUp...
$ optirun wine .wine/drive_c/Program\ Files/Google/Google\ SketchUp\ 8/SketchUp.exe
… и куй-то там, та же ошибка :)

Надо запустить regedit и поправить в реестре [HKEY_CURRENT_USER\Software\Google\SketchUp6\GLConfig\Display] значение  "HW_OK" на 1.

Вот теперь все работает.
