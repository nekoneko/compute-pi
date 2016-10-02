CC = gcc
CFLAGS = -O0 -std=gnu99 -Wall -fopenmp -mavx
CFLAGS2 = -O0 -std=gnu99 -Wall -fopenmp -g
EXECUTABLE = \
	time_test_baseline time_test_openmp_2 time_test_openmp_4 \
	time_test_avx time_test_avxunroll \
	benchmark_clock_gettime benchmark_clock \
	error_rate distribute

OUT_DIR = result

ifeq ($(strip $(NON_AVX)),1)
NONAVX_FLAGS = -DNON_AVX
CFLAGS2 += $(NONAVX_FLAGS)
endif

BNECH_MARK = benchmark_clock_gettime

ifeq ($(strip $(CLOCK)),1) 
BNECH_MARK = benchmark_clock
endif

default: computepi.o
	$(CC) $(CFLAGS) computepi.o time_test.c -DBASELINE -o time_test_baseline
	$(CC) $(CFLAGS) computepi.o time_test.c -DOPENMP_2 -o time_test_openmp_2
	$(CC) $(CFLAGS) computepi.o time_test.c -DOPENMP_4 -o time_test_openmp_4
	$(CC) $(CFLAGS) computepi.o time_test.c -DAVX -o time_test_avx
	$(CC) $(CFLAGS) computepi.o time_test.c -DAVXUNROLL -o time_test_avxunroll
	$(CC) $(CFLAGS) computepi.o benchmark_clock_gettime.c -o benchmark_clock_gettime
	$(CC) $(CFLAGS2) computepi.o benchmark_clock.c -o benchmark_clock

nonavx:
	$(CC) -c $(CFLAGS2) computepi.c -o computepi.o
	$(CC) $(CFLAGS2) computepi.o time_test.c -DBASELINE -o time_test_baseline
	$(CC) $(CFLAGS2) computepi.o time_test.c -DOPENMP_2 -o time_test_openmp_2
	$(CC) $(CFLAGS2) computepi.o time_test.c -DOPENMP_4 -o time_test_openmp_4
	$(CC) $(CFLAGS2) computepi.o benchmark_clock_gettime.c -o benchmark_clock_gettime
	$(CC) $(CFLAGS2) computepi.o benchmark_clock.c -o benchmark_clock

errorrate:
	$(CC) -c $(CFLAGS2) computepi.c -o computepi.o
	$(CC) $(CFLAGS2) computepi.o error_rate.c -o error_rate

distr:
	$(CC) -c $(CFLAGS2) computepi.c -o computepi.o
	$(CC) $(CFLAGS2) computepi.o distribute.c -o distribute
	

.PHONY: clean default nonavx errorrate distr

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

check: default
	time ./time_test_baseline
	time ./time_test_openmp_2
	time ./time_test_openmp_4
	time ./time_test_avx
	time ./time_test_avxunroll

gencsv:
	for j in 10000 1000 100; do \
		echo $$j; \
		for i in `seq 1000 $$j 100000`; do \
			printf "%d," $$i; \
			./$(BNECH_MARK) $$i; \
		done > ./$(OUT_DIR)/$$j.csv; \
	done

generrorcsv: errorrate
	for i in `seq 1000000 100000 100000000`; do \
		printf "%d," $$i; \
		./error_rate $$i; \
	done > ./$(OUT_DIR)/error_rate.csv

gendistricsv: distr
	./distribute 100000 1000 5 > ./$(OUT_DIR)/distribute.csv

plot: gencsv
	for j in 10000 1000 100; do \
		gnuplot -e "datafile='$(OUT_DIR)/$$j.csv'; outputfile='$(OUT_DIR)/$$j.png'" \
			./scripts/compute-pi.gp ; \
	done

ploterror: generrorcsv
	gnuplot ./scripts/error_rate.gp

plotdistri: gendistricsv
	gnuplot ./scripts/distribute.gp

clean:
	rm -f $(EXECUTABLE) *.o *.s result_clock_gettime.csv result/*
