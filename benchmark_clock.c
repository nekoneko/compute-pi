#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "computepi.h"

int main(int argc, char const *argv[])
{
    clock_t start_tm = 0;
    clock_t end_tm = 0;

    if (argc < 2) return -1;

    int N = atoi(argv[1]);
    int i, loop = 25;


    // Baseline
    start_tm = clock();
    for(i = 0; i < loop; i++) {
        compute_pi_baseline(N);
    }
    end_tm = clock();
    printf("%lf,", (double) (end_tm - start_tm) / CLOCKS_PER_SEC);


    // OpenMP with 2 threads
    start_tm = clock();
    for(i = 0; i < loop; i++) {
        compute_pi_openmp(N, 2);
    }
    end_tm = clock();
    printf("%lf,", (double) (end_tm - start_tm) / CLOCKS_PER_SEC);


    // OpenMP with 4 threads
    start_tm = clock();
    for(i = 0; i < loop; i++) {
        compute_pi_openmp(N, 4);
    }
    end_tm = clock();
    printf("%lf,", (double) (end_tm - start_tm) / CLOCKS_PER_SEC);


#if !defined(NON_AVX)
    // AVX SIMD
    start_tm = clock();
    for(i = 0; i < loop; i++) {
        compute_pi_avx(N);
    }
    end_tm = clock();
    printf("%lf,", (double) (end_tm - start_tm) / CLOCKS_PER_SEC);


    // AVX SIMD + Loop unrolling
    start_tm = clock();
    for(i = 0; i < loop; i++) {
        compute_pi_avx_unroll(N);
    }
    end_tm = clock();
    printf("%lf,", (double) (end_tm - start_tm) / CLOCKS_PER_SEC);
#endif

    printf("\n");

    return 0;
}
