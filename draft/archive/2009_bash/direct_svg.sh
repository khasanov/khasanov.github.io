#!/bin/sh
# скрипт для создания листа отчета (в векторном формате svg)

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
			#разбираем файл
			cat "$file" | (while read line; do
				xlocal=`echo $line | awk '{print $1}'`
				ylocal=`echo $line | awk '{print $2}'`
				zlocal=`echo $line | awk '{print $3}'`
				#Пересчитываем xlocal и ylocal в координаты для рисования линий
				new_xlocal=$(($xlocal - $xglobal))
				new_ylocal=$(($ylocal - $yglobal))
				
				x_px=`echo 56.4399 + $new_xlocal "*" 20.0362 |bc -l`
				y_px=`echo 172.8320 - $new_ylocal "*" 20.0362|bc -l`
				
				x1=`echo $x_px + 2 |bc -l`
				x2=`echo $x_px - 2 |bc -l`
				y1=`echo $y_px + 2 |bc -l`
				y2=`echo $y_px - 2 |bc -l`
				
				#крестики
				echo '<line class="fil3 str6" x1="'"$x_px"'" y1="'"$y1"'" x2="'"$x_px"'" y2="'"$y2"'" />' >> $dir_temporary/$xglobal'_'$yglobal
				echo '<line class="fil3 str6" x1="'"$x1"'" y1="'"$y_px"'" x2="'"$x2"'" y2="'"$y_px"'" />' >> $dir_temporary/$xglobal'_'$yglobal
				#высоты
				echo '<text x="'`echo $x_px + 2|bc -l`'" y="'`echo $y_px - 2 |bc -l`'" class="fil4 fnt7">'"$zlocal"'</text>' >> $dir_temporary/$xglobal'_'$yglobal
				done)

	echo "$xglobal"_"$yglobal" Done!
		else echo "Не найден файл с данными";
	fi;
done;

echo "Рисую..."
for file in $dir_temporary/*; do
	xglobal=`echo "$file" | egrep -o [0-9]+ | head -c 3`
	yglobal=`echo "$file" | egrep -o [0-9]+ | tail -c 3`
	touch $dir_output/$xglobal'_'$yglobal.svg
	cat $prefix_directory/template.svg > $dir_output/$xglobal'_'$yglobal.svg
  echo '<text x="52.45" y="179.451"  class="fil2 fnt6">'"$xglobal"'</text>' >> $dir_output/$xglobal'_'$yglobal.svg
  echo '<text x="72.45" y="179.451"  class="fil2 fnt6">'"$(($xglobal+1))"'</text>' >> $dir_output/$xglobal'_'$yglobal.svg
  echo '<text x="92.45" y="179.451"  class="fil2 fnt6">'"$(($xglobal+2))"'</text>' >> $dir_output/$xglobal'_'$yglobal.svg
  echo '<text x="112.45" y="179.451"  class="fil2 fnt6">'"$(($xglobal+3))"'</text>' >> $dir_output/$xglobal'_'$yglobal.svg
  echo '<text x="132.45" y="179.451"  class="fil2 fnt6">'"$(($xglobal+4))"'</text>' >> $dir_output/$xglobal'_'$yglobal.svg
  echo '<text x="152.45" y="179.451"  class="fil2 fnt6">'"$(($xglobal+5))"'</text>' >> $dir_output/$xglobal'_'$yglobal.svg
  echo '<text x="48" y="173.551"  class="fil2 fnt6">'"$(($yglobal))"'</text>' >> $dir_output/$xglobal'_'$yglobal.svg
  echo '<text x="48" y="154.051"  class="fil2 fnt6">'"$(($yglobal+1))"'</text>' >> $dir_output/$xglobal'_'$yglobal.svg
  echo '<text x="48" y="134.051"  class="fil2 fnt6">'"$(($yglobal+2))"'</text>' >> $dir_output/$xglobal'_'$yglobal.svg
  echo '<text x="48" y="114.051"  class="fil2 fnt6">'"$(($yglobal+3))"'</text>' >> $dir_output/$xglobal'_'$yglobal.svg
  echo '<text x="48" y="94.151"  class="fil2 fnt6">'"$(($yglobal+4))"'</text>' >> $dir_output/$xglobal'_'$yglobal.svg
  echo '<text x="48" y="74.051"  class="fil2 fnt6">'"$(($yglobal+5))"'</text>' >> $dir_output/$xglobal'_'$yglobal.svg
	echo '<g>' >> $dir_output/$xglobal'_'$yglobal.svg
	cat $dir_temporary/$xglobal'_'$yglobal >> $dir_output/$xglobal'_'$yglobal.svg
	echo '</g></g>' >> $dir_output/$xglobal'_'$yglobal.svg
	echo '</svg>' >> $dir_output/$xglobal'_'$yglobal.svg	
done
rm -r $dir_temporary

exit 0
