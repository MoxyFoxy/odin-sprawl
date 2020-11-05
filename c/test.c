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

    int o = 0;
    uint32_t p = 0;

    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            for (int k = 0; k < 2; k++) {
                for (int l = 0; l < 2; l++) {
                    for (int m = 0; m < 2; m++) {
                        for (int n = 0; n < 2; n++) {
                            sprawlc_set(&arr, &o, i, j, k, l, m, n);
                            sprawlc_get(&arr, &p, i, j, k, l, m, n);
                            printf("%d ", p);
                            o += 1;
                        }
                        printf("\n");
                    }
                    printf("\n");
                }
            }
        }
    }

    for (int i = 0; i < arr.n_data; i++) {
        if (i != 0)
            printf(", ");

        printf("%d", *((uint32_t *)(arr.data + i * sizeof(uint32_t))));
    }
    printf("\n");
}