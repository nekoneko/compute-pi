reset
set xlabel 'N'
set ylabel 'error_rate %'
set logscale y
set format y '%.6e'
set grid
set style fill solid
set title 'pi error rate'
set datafile separator ","
set term png enhanced font 'Verdana,10'
set output './result/error_rate.png'

plot './result/error_rate.csv' using 1:2:xtic(100) with line lw 1 title 'baseline', 
#'' using 1:3 with line lw 1 title 'openmp\_2', \
#'' using 1:4 with line lw 1 title 'openmp\_4'
