#include <stddef.h>
#include <stdint.h>

typedef struct sprawlc_Slice {
    size_t    size     ;

    void     *data     ;
    uint32_t  n_data   ;

    void     *lengths  ;
    uint32_t  n_lengths;

    void     *offsets  ;
    uint32_t  n_offsets;
} sprawlc_Slice;

#define sprawlc_index(ndim, ...) \
    _sprawlc_index(ndim, sizeof ((uint32_t []){ __VA_ARGS__ }) / sizeof (uint32_t), (uint32_t []){ __VA_ARGS__ })
int  _sprawlc_index (sprawlc_Slice *ndim, uint32_t n_indexes, void *indexes);

#define sprawlc_get(ndim, dest, ...) \
    _sprawlc_get(ndim, dest, sizeof ((uint32_t []){ __VA_ARGS__ }) / sizeof (uint32_t), (uint32_t []){ __VA_ARGS__ })
void _sprawlc_get   (sprawlc_Slice *ndim, void *dest, uint32_t n_indexes, void *indexes);

#define sprawlc_set(ndim, src, ...) \
    _sprawlc_set(ndim, src, sizeof ((uint32_t []){ __VA_ARGS__ }) / sizeof (uint32_t), (uint32_t []){ __VA_ARGS__ })
void _sprawlc_set   (sprawlc_Slice *ndim, void *src,  uint32_t n_indexes, void *indexes);

#define sprawlc_ref(ndim, src, ...) \
    _sprawlc_ref(ndim, src, sizeof ((uint32_t []){ __VA_ARGS__ }) / sizeof (uint32_t), (uint32_t []){ __VA_ARGS__ })
void *_sprawlc_ref  (sprawlc_Slice *ndim, void *src,  uint32_t n_indexes, void *indexes);

#define sprawlc_create(size, ...) \
    _sprawlc_create(size, sizeof ((uint32_t []){ __VA_ARGS__ }) / sizeof (uint32_t), (uint32_t []){ __VA_ARGS__ })
sprawlc_Slice _sprawlc_create(size_t size, uint32_t n_dimensions, void *dimensions);