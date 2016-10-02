reset
set ylabel 'count'
set xlabel 'time * 100000'
set grid
set style fill solid
set title 'distribute'
set datafile separator ","
set term png enhanced font 'Verdana,10'
set output './result/dis.png'

plot './result/distribute.csv' using 1:2 with line title 'distribute'
