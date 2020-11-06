#include <stddef.h>
#include <stdint.h>

typedef struct sprawlc_Array {
    size_t    size     ;

    void     *data     ;
    uint32_t  n_data   ;

    void     *lengths  ;
    uint32_t  n_lengths;

    void     *offsets  ;
    uint32_t  n_offsets;
} sprawlc_Array;

#define sprawlc_index(ndim, ...) \
    _sprawlc_index(ndim, sizeof ((uint32_t []){ __VA_ARGS__ }) / sizeof (uint32_t), (uint32_t []){ __VA_ARGS__ })
int  _sprawlc_index (sprawlc_Array *ndim, uint32_t n_indexes, void *indexes);

#define sprawlc_get(ndim, dest, ...) \
    _sprawlc_get(ndim, dest, sizeof ((uint32_t []){ __VA_ARGS__ }) / sizeof (uint32_t), (uint32_t []){ __VA_ARGS__ })
void _sprawlc_get   (sprawlc_Array *ndim, void *dest, uint32_t n_indexes, void *indexes);

#define sprawlc_set(ndim, src, ...) \
    _sprawlc_set(ndim, src, sizeof ((uint32_t []){ __VA_ARGS__ }) / sizeof (uint32_t), (uint32_t []){ __VA_ARGS__ })
void _sprawlc_set   (sprawlc_Array *ndim, void *src,  uint32_t n_indexes, void *indexes);

#define sprawlc_create(size, ...) \
    _sprawlc_create(size, sizeof ((uint32_t []){ __VA_ARGS__ }) / sizeof (uint32_t), (uint32_t []){ __VA_ARGS__ })
sprawlc_Array _sprawlc_create(size_t size, uint32_t n_dimensions, void *dimensions);