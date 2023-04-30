#include "transpose.h"
#include <stdio.h>

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

void print(int n, int *mat) {
    printf("\n");
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++)
            printf("%8d ", mat[i + j * n]);
        printf("\n");
    }
}

void transpose_blocking(int n, int blocksize, int *dst, int *src) {
    
    int cnt = n / blocksize;

    for (int i = 0; i < cnt; i++) {
        for (int j = 0; j < cnt; j++) {
            for (int x = 0; x < blocksize; x++) {
                for (int y = 0; y < blocksize; y++) {
                    dst[i * blocksize + x + j * blocksize * n + y * n] = 
                    src[j * blocksize + y + i * blocksize * n + x * n];
                }
            }
        }
    }

    for (int x = cnt * blocksize; x < n; x++) {
        for (int y = 0; y < cnt * blocksize; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }

    for (int x = 0; x < cnt * blocksize; x++) {
        for (int y = cnt * blocksize; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }

    for (int x = cnt * blocksize; x < n; x++) {
        for (int y = cnt * blocksize; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
    // print(n, dst);

    return;
}

void transpose_blocking2(int n, int blocksize, int *dst, int *src) {
    int cnt = n / blocksize;

    for (int i = 0; i < cnt; i++) {
        for (int j = 0; j < cnt; j++) {
            for (int x = 0; x < blocksize; x++) {
                for (int y = 0; y < blocksize; y++) {
                    dst[i * blocksize + x + j * blocksize * n + y * n] = 
                    src[j * blocksize + y + i * blocksize * n + x * n];
                }
            }
        }
    }

    for (int i = 0; i < cnt; i++) {
        for (int x = 0; x < blocksize; x++) {
            for (int y = cnt * blocksize; y < n; y++) {
                dst[i * blocksize + x + y * n] = src[y + (i * blocksize + x) * n];
            }
        }
    }

    for (int j = 0; j < cnt; j++) {
        for (int y = 0; y < blocksize; y++) {
            for (int x = cnt * blocksize; x < n; x++) {
                dst[x + y * n + j * blocksize * n] = src[y + j * blocksize + x * n];
            }
        }
    }

    for (int x = cnt * blocksize; x < n; x++) {
        for (int y = cnt * blocksize; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
    // print(n, dst);

    return;
}
