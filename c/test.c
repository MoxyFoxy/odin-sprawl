#include <stdio.h>

#include "sprawlc.h"
/*
main :: proc () {
    sprawl_arr := create(int, 2, 2, 2, 2, 2, 2);

    o := 0;

    for i in 0..<2 {
        for j in 0..<2 {
            for k in 0..<2 {
                for l in 0..<2 {
                    for m in 0..<2 {
                        for n in 0..<2 {
                            set(sprawl_arr, o, i, j, k, l, m, n);
                            fmt.print(ref(sprawl_arr, i, j, k, l, m, n)^);
                            fmt.print(" ");
                            o += 1;
                        }
                        fmt.println();
                    }
                    fmt.println();
                }
            }
        }
    }

    fmt.println(sprawl_arr.data);
}
*/
int main () {
    sprawlc_Array arr;

    arr = sprawlc_create(sizeof(uint32_t), 2, 2, 2, 2, 2, 2);

    uint32_t o = 0;
    uint32_t p = 0;
    uint32_t q = 0;

    printf("[");

    for (uint32_t i = 0; i < 2; i++) {
        for (uint32_t j = 0; j < 2; j++) {
            for (uint32_t k = 0; k < 2; k++) {
                for (uint32_t l = 0; l < 2; l++) {
                    for (uint32_t m = 0; m < 2; m++) {
                        for (uint32_t n = 0; n < 2; n++) {
                            sprawlc_set(&arr, &o, i, j, k, l, m, n);

                            if (i + j + k + l + m + n != 0) {
                                printf(", ");
                            }

                            printf("i: %d\n", i);
                            printf("j: %d\n", j);
                            printf("k: %d\n", k);
                            printf("l: %d\n", l);
                            printf("m: %d\n", m);
                            printf("n: %d\n", n);

                            sprawlc_get(&arr, &p, i, j, k, l, m, n);

                            printf("%d", p);
                            o += 1;
                            q += 1;
                        }
                    }
                }
            }
        }
    }

    printf("]\n");

    printf("[");

    for (uint32_t i = 0; i < arr.n_data; i++) {
        if (i != 0)
            printf(", ");

        printf("%d", *((uint32_t *)(arr.data + i * arr.size)));
    }

    printf("]\n");

    printf("[");

    for (uint32_t i = 0; i < arr.n_data; i++) {
        if (i != 0)
            printf(", ");

        printf("%d", *((uint32_t *)(arr.data + i * arr.size)));
    }

    printf("]\n");

    printf("q: %d\n", q);
}