#!/bin/sh
# скрипт для создания листа отчета (в векторном формате svg)
# требуется установленный imagemagick#

#чтобы узнать, какого размера лист A4 при dpi 90
#convert -page A4 -density 300 -units PixelsPerInch  text:/dev/null \
#          -format 'Page Size at %x = %w x %h pixels'  info:
#у меня получилось 744х1053, inkscape говорит, что A4 - это 744,09х1052,36 px или 210,0х297,0 мм
#буду ориентироваться на размеры inkscape, а вообще-то без разницы - он же векторный :)

############################################
#нивелировочные отметки дневной поверхности#
############################################

#Этап первый - чтение текстового файла с координатами

#!!!ВАЖНО!!! файл должен называться по номерам квадратов!!!
prefix_directory='/home/sir/temp/Ангара'
dir_input=$prefix_directory'/data' #директория с файлами данных
dir_output=$prefix_directory'/svg' #директория, куда будут складываться готовые svg-файлы
dir_temporary=$prefix_directory'/dir_temporary' #директория для временных служебных файлов

font_Arial_Black='/usr/share/fonts/truetype/msttcorefonts/Arial_Black.ttf' 
#проверка существования необходимых файлов и папок
cd $prefix_directory
if [ -d $dir_temporary ];
	then 
		echo "Очистка временной директории " $dir_temporary
		rm -r $dir_temporary
		mkdir $dir_temporary
		echo " -Ok"
	else
		echo "Создание временной директории " $dir_temporary
		mkdir $dir_temporary
		echo " -Ok"
 fi;

if [ -d $dir_output ];
	then 
		echo "Директория для создания отчета: " $dir_output " -Ок"
	else
		mkdir $dir_output
		echo "Директория для создания отчета: " $dir_output " -Ок"
fi;
 
if [ -d $dir_input ];
	then 
		cd $dir_input
	else
		echo "Директория с данными не найдена"
		exit;
 fi;

echo "Считаю координаты..."
cd $dir_input
for file in $dir_input/*; do #для каждого файла в директории
	if [ -e $file ];  #если файл существует
		then
			#вычисляем глобальные X и Y для части раскопа (из названия файла)
			xglobal=`echo "$file" | egrep -o [0-9]+ | head -c 3`
			yglobal=`echo "$file" | egrep -o [0-9]+ | tail -c 3`
			#разбираем файл построчно
			cat "$file" | (while read line; do
				xlocal=${line:0:3}
				ylocal=${line:4:3}
				zlocal=${line:7:5}
				#Пересчитываем xlocal и ylocal в координаты в пикселях
				xlocal=`expr $xlocal - $xglobal`
				ylocal=`expr $ylocal - $yglobal`				
				x_px=`expr $xlocal "*" 71` #поскольку картинка 355x355 px
				y_px=`expr 355 - $ylocal "*" 71`
				
				#для z по y на 8 px выше и на 6 левее
				zy_px=`expr $y_px - 8`
				zx_px=`expr $x_px + 6`
				xy_drawing=`echo text $x_px','$y_px "'+'"`
				z_drawing=`echo text $zx_px','$zy_px "'""$zlocal""'"`
				draw_xyz="$draw_xyz $xy_drawing $z_drawing"
				echo $draw_xyz > $dir_temporary/"$xglobal"_"$yglobal"
				done)
	echo "$xglobal"_"$yglobal" Done!
		else echo "Не найден файл с данными";
	fi;
done;

#Этап второй - рисуем
echo "Рисую..."
cd $dir_temporary
for file in $dir_temporary/*; do #для каждого файла в директории, где теперь есть данные для рисования
	xglobal=`echo "$file" | egrep -o [0-9]+ | head -c 3`
	yglobal=`echo "$file" | egrep -o [0-9]+ | tail -c 3`
	if [ -e "$file" ];
		then #рисуем
			cat "$file" | (while read line; do
			file_xyz_svg=$dir_output/"$xglobal"_"$yglobal"_xyz.svg #имя файла куда рисуем
			echo 'convert -size 355x355 xc:white -pointsize 11 -font /usr/share/fonts/truetype/msttcorefonts/Arial_Black.ttf -draw "fill black '"$line" \" "$file_xyz_svg" > file_xyz
			cat file_xyz
			chmod +x file_xyz
			./file_xyz
			echo $file_xyz_svg " -Done!"
			rm file_xyz
			done)
			
		else #рисуем высоты
			echo "Что-то не так..."
	fi;
	
done
rm -r $dir_temporary


exit 0
