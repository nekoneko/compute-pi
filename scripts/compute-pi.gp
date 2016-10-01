reset
if (!exists("datafile")) datafile="result_clock_gettime.csv"
if (!exists("outputfile")) outputfile="clock_gettime.png"
set xlabel 'N'
set ylabel 'time(sec)'
set grid
set style fill solid
set title 'clock\_gettime'
set datafile separator ","
set term png enhanced font 'Verdana,10'
set output outputfile

plot datafile using 1:2 with line lw 1 title 'baseline', \
'' using 1:3 with line lw 1 title 'openmp_2', \
'' using 1:4 with line lw 1 title 'openmp_4', \
'' using 1:5 with line lw 1 title 'avx', \
'' using 1:6 with line lw 1 title 'avxunroll'
