Настройка wi-fi на ноутбуке Acer Extensa 5220 под Ubuntu
========================================================

Наконец-то понял, в чем дело -- надо выгрузить нетокорые модули из ядра, так что
# rmmod b43
# rmmod ssb
# rmmod ndiswrapper
# modprobe ssb

Спасибо https://help.ubuntu.com/community/WifiDocs/Driver/bcm43xx/Feisty_No-Fluff#Hardy Bug Fix

Теперь лампочка и горит, и выключается/включается по кнопке.
Осталось поднять беспроводную сеть :)

ну, это оказалось вообще элементарно:
сначала режим бук-к-буку
# iwconfig eth1 mode ad-hoc
# iwconfig eth1 essid sir
# ifconfig eth1 192.168.1.1

#iwconfig eth1
eth1 IEEE 802.11b ESSID:"sir"
Mode:Ad-Hoc Frequency:2.462 GHz Cell: D2:EC:8A:77:90:81
Bit Rate=11 Mb/s Tx-Power:32 dBm
RTS thr:2347 B Fragment thr:2346 B
Power Management:off
Link Quality:81/100 Signal level:-44 dBm Noise level:-96 dBm
Rx invalid nwid:0 Rx invalid crypt:0 Rx invalid frag:0
Tx excessive retries:0 Invalid misc:0 Missed beacon:0

второму буку 192.168.1.2
пингуется :) по самбе видится :)
