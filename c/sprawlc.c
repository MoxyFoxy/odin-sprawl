#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include "sprawlc.h"

sprawlc_Array _sprawlc_create(size_t size, uint32_t n_dimensions, void *dimensions) {
    sprawlc_Array ndim = {
        size,

        malloc(n_dimensions * size),
        n_dimensions * size,

        malloc(n_dimensions),
        n_dimensions,

        NULL,
        0
    };

    memcpy(ndim.lengths, dimensions, n_dimensions);

    return ndim;
}