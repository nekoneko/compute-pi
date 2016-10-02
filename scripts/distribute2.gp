reset
set ylabel 'count'
set xlabel 'time * 100000'
set grid
set style fill solid
set boxwidth 1 absolute
set title 'distribute'
set datafile separator ","
set term png enhanced font 'Verdana,10'
set output './result/dis2.png'

plot './result/distribute2.csv' using 1:2 with boxes title 'baseline'
