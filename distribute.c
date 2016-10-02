#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "computepi.h"

#define CLOCK_ID CLOCK_MONOTONIC_RAW
#define ONE_SEC 1000000000.0


int main(int argc, char const *argv[])
{
    struct timespec start = {0, 0};
    struct timespec end = {0, 0};

    if (argc < 4) return -1;

    int N = atoi(argv[1]);
    int population = atoi(argv[2]);
    int power_num = (atoi(argv[3]) < 0)?0:atoi(argv[3]);
    double maxt = -10000.0;
    double *timetable = malloc(population*sizeof(double));
    int *distribute;
    int i, j, dist_size, loop = 25;
    FILE *fout;

    for (i = 0; i < population; i++) {
        clock_gettime(CLOCK_ID, &start);
        for (j = 0; j < loop; j++) {
            compute_pi_baseline(N);
        }
        clock_gettime(CLOCK_ID, &end);
        // record elapsed time
        timetable[i] = (double) (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec)/ONE_SEC;

        // record max time
        if (maxt < timetable[i]) maxt = timetable[i];
    }

    // set precise unit for historgram
    i = 0;
    while (i < power_num) {
        maxt*= 10;
        ++i;
    }

    //printf("power of ten %d\n", power_num);

    // calloc distribute table
    dist_size = (int) maxt + 1;
    distribute = calloc( dist_size , sizeof(int));

    // historgram calculate
    for (i = 0; i < population; ++i) {
        for (j = 0; j < power_num; ++j)
            timetable[i]*=10;
        ++distribute[(int)timetable[i]];
    }

    fout = fopen("./result/distribute2.csv", "w");
    // output histogram
    for (i = 0; i < dist_size; ++i) {
        if (distribute[i])
            fprintf(fout, "%d, %d\n", i, distribute[i]);
        printf("%d,%d\n",i , distribute[i]);
    }
    fclose(fout);

    free(distribute);
    free(timetable);
    return 0;
}
