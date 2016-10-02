#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "computepi.h"

#define CLOCK_ID CLOCK_MONOTONIC_RAW
#define ONE_SEC 1000000000.0

int main(int argc, char const *argv[])
{
    struct timespec start = {0, 0};
    struct timespec end = {0, 0};
    double *timetable;
    double total, mean, dev, lower, upper, size;

    if (argc < 3) return -1;

    int N = atoi(argv[1]);
    int i, j, loop = 25;
    double population = atoi(argv[2]);

    if (population < 2) return -1;

    // Baseline
    total = 0;
    timetable = malloc(population*sizeof(double));
    for (j = 0; j < population; ++j) {
        clock_gettime(CLOCK_ID, &start);
        for(i = 0; i < loop; i++) {
            compute_pi_baseline(N);
        }
        clock_gettime(CLOCK_ID, &end);
        timetable[i] = (double) (end.tv_sec - start.tv_sec) \
                       + (end.tv_nsec - start.tv_nsec)/ONE_SEC;
        total += timetable[i];
    }
    mean = total / population;
    printf("origin : %lf\n", mean);

    // standard deviation
    total = 0;
    for (j = 0; j < population; ++j) {
        total += (timetable[i] - mean)*(timetable[i] - mean);
    }
    total /= (population-1);
    dev = sqrt(total);

    lower = mean - 2*dev;
    upper = mean + 2*dev;

    total = 0;
    size = 0;
    for (j = 0; j < population; ++j) {
        if ((lower < timetable[i]) && (upper > timetable[i])) {
            total += timetable[i];
            ++size;
        }
    }
    mean = total / size;

    printf("95 of CI : %lf\n", mean);
    return 0;
}
