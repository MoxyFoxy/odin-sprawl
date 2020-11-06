#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "sprawlc.h"

sprawlc_Array _sprawlc_create(size_t size, uint32_t n_dimensions, void *dimensions) {
    uint32_t data_size = 1;

    for (int i = 0; i < n_dimensions; i++) {
        data_size *= *((uint32_t *)(dimensions + i * size));
    }

    sprawlc_Array ndim = {
        size,

        malloc(data_size * size),
        data_size,

        malloc(n_dimensions * size),
        n_dimensions,

        NULL,
        0
    };

    printf("size: %d\n", ndim.size);

    memcpy(ndim.lengths, dimensions, n_dimensions * size);

    return ndim;
}