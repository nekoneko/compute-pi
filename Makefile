CC = gcc
CFLAGS = -O0 -std=gnu99 -Wall -fopenmp -mavx
EXECUTABLE = \
	time_test_baseline time_test_openmp_2 time_test_openmp_4 \
	time_test_avx time_test_avxunroll \
	benchmark_clock_gettime

OUT_DIR = result

default: computepi.o
	$(CC) $(CFLAGS) computepi.o time_test.c -DBASELINE -o time_test_baseline
	$(CC) $(CFLAGS) computepi.o time_test.c -DOPENMP_2 -o time_test_openmp_2
	$(CC) $(CFLAGS) computepi.o time_test.c -DOPENMP_4 -o time_test_openmp_4
	$(CC) $(CFLAGS) computepi.o time_test.c -DAVX -o time_test_avx
	$(CC) $(CFLAGS) computepi.o time_test.c -DAVXUNROLL -o time_test_avxunroll
	$(CC) $(CFLAGS) computepi.o benchmark_clock_gettime.c -o benchmark_clock_gettime

.PHONY: clean default

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@ 

check: default
	time ./time_test_baseline
	time ./time_test_openmp_2
	time ./time_test_openmp_4
	time ./time_test_avx
	time ./time_test_avxunroll

gencsv: default
	for j in 10000 1000 100; do \
		echo $$j; \
		for i in `seq 1000 $$j 100000`; do \
			printf "%d," $$i; \
			./benchmark_clock_gettime $$i; \
		done > ./$(OUT_DIR)/$$j.csv; \
	done

plot: gencsv
	for j in 10000 1000 100; do \
		gnuplot -e "datafile='$(OUT_DIR)/$$j.csv'; outputfile='$(OUT_DIR)/$$j.png'" \
			./scripts/compute-pi.gp ; \
	done

clean:
	rm -f $(EXECUTABLE) *.o *.s result_clock_gettime.csv result/*
