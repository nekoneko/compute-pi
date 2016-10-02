#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "computepi.h"

#define PI acos(-1)
#define ERROR_RATE(pi) \
	(pi > PI) ? ((pi-PI)/PI) : ((PI-pi)/PI)

int main(int argc, char const *argv[])
{
    if (argc < 2) return -1;

    double pi;

    int i = atoi(argv[1]);

    // Baseline
    pi = compute_pi_baseline(i);
    printf("%e,", ERROR_RATE(pi));

    // OpenMP with 2 threads
    pi = compute_pi_openmp(i, 2);
    printf("%e,", ERROR_RATE(pi));

    // OpenMP with 4 threads
    pi = compute_pi_openmp(i, 4);
    printf("%e,", ERROR_RATE(pi));

#if !defined(NON_AVX)
    printf(",");

    // AVX SIMD
    pi = compute_pi_avx(i);
    printf("%e,", ERROR_RATE(pi));

    // AVX SIMD + Loop unrolling
    pi = compute_pi_avx_unroll(i);
    printf("%e", ERROR_RATE(pi));
#endif
    printf("\n");

    return 0;
}
