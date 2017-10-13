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
				
				xy_drawing=`echo text $x_px','$y_px "'+'"`
				z_drawing=`echo text $x_px','$y_px "'""$zlocal""'"`
				draw_xy="$draw_xy $xy_drawing"
				draw_z="$draw_z $z_drawing"
				echo $draw_xy > $dir_temporary/"$xglobal"_"$yglobal"
				echo $draw_z > $dir_temporary/"$xglobal"_"$yglobal"_z
				done)
	echo "$xglobal"_"$yglobal" Done!
		else echo "Не найден файл с данными";
	fi;
done;

#Этап второй - рисуем
echo "Рисую..."
cd $dir_temporary
for file in $dir_temporary/*; do #для каждого файла в директории, где теперь есть данные для рисования
	test_z=`echo "$file" | egrep -o [z]`
	xglobal=`echo "$file" | egrep -o [0-9]+ | head -c 3`
	yglobal=`echo "$file" | egrep -o [0-9]+ | tail -c 3`
	if [ -e "$file" ] && [ "$test_z" != "z" ];  #если файл существует и не с отметками высот
		then #рисуем крестики
			cat "$file" | (while read line; do
			file_xy_svg=$dir_output/"$xglobal"_"$yglobal"_xy.svg #имя файла куда рисуем
			echo 'convert -size 355x355 xc:white -draw "fill black '"$line" \" "$file_xy_svg" > file_xy
			chmod +x file_xy
			./file_xy
			echo $file_xy_svg " -Done!"
			rm file_xy
			done)
			
		else #рисуем высоты
			cat "$file" | (while read line; do 
			file_z_svg=$dir_output/"$xglobal"_"$yglobal"_z.svg
			echo 'convert -size 355x355 xc:white -pointsize 9 -draw "fill black '"$line" \" "$file_z_svg" > file_z
			chmod +x file_z
			./file_z
			echo $file_z_svg " -Done!"
			rm file_z
			done)
	fi;
	
done
rm -r $dir_temporary


exit 0
