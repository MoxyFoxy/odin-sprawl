package sprawl

import "core:intrinsics"

Sprawl_Slice :: struct (T: typeid, NT: typeid) where intrinsics.type_is_integer(NT) {
    slice  : []T,
    lengths: []NT,
}

// From here on, they shouldn't require the intrinsics integer check as the struct has that.

// Abstraction over `index` for the `Sprawl_Slice` struct
struct_index :: inline proc (ndim: Sprawl_Slice($T, $NT), indexes: []NT) -> NT {
    return _index(indexes, ndim.lengths);
}

// Abstraction over `index_2d` for the `Sprawl_Slice` struct
struct_index_2d :: inline proc (ndim: Sprawl_Slice($T, $NT), x, y: NT) -> NT {
    return _index_2d(x, y, ndim.lengths[0]);
}

// Abstraction over `_get` for the `Sprawl_Slice` struct
struct_get :: inline proc (ndim: Sprawl_Slice($T, $NT), indexes: []NT) -> T {
    return _get(ndim.slice, indexes, ndim.lengths);
}

// Abstraction over `_get_2d` for the `Sprawl_Slice` struct
struct_get_2d :: inline proc (ndim: Sprawl_Slice($T, $NT), x, y: NT) -> T {
    return _get_2d(ndim.slice, x, y, ndim.lengths[0]);
}

// Abstraction over `_set` for the `Sprawl_Slice` struct
struct_set :: inline proc (ndim: Sprawl_Slice($T, $NT), indexes: []NT, value: T) {
    _set(ndim.slice, indexes, ndim.lengths, value);
}

// Abstraction over `_set_2d` for the `Sprawl_Slice` struct
struct_set_2d :: inline proc (ndim: Sprawl_Slice($T, $NT), x, y: NT, value: T) {
    _set_2d(ndim.slice, x, y, ndim.lengths[0], value);
}

// Abstraction over `_in_bounds` for the `Sprawl_Slice` struct
struct_in_bounds :: inline proc (ndim: Sprawl_Slice($T, $NT), indexes: []NT) -> bool {
    return _in_bounds(ndim.slice, indexes, ndim.lengths);
}

// Abstraction over `_in_bounds_2d` for the `Sprawl_Slice` struct
struct_in_bounds_2d :: inline proc (ndim: Sprawl_Slice($T, $NT), x, y: NT) -> bool {
    return _in_bounds(ndim.slice, x, y, ndim.lengths);
}

// Creates a `Sprawl_Slice` and initializes the sprawled slice
create_sprawl :: inline proc (lengths: []$NT, $T: typeid) -> Sprawl_Slice(T, NT) {
    return Sprawl_Slice(T, NT) {
        create_slice(lengths, T),
        lengths,
    };
}

// Creates a constant-sized `Sprawl_Slice` and initializes it
create_sprawl_const :: proc (lengths: [$N]$NT, $T: typeid) -> Sprawl_Slice(T, NT) {
    ndim := Sprawl_Slice(T, NT) {
        create_slice_const(lengths, T),
        make([]NT, N),
    };

    for n in 0..<N {
        ndim.lengths[n] = lengths[n];
    }

    return ndim;
}

// Creates a 2-dimensional `Sprawl_Slice` and initializes the sprawled slice
create_sprawl_2d :: proc (sizex, sizey: $NT, $T: typeid) -> Sprawl_Slice(T, NT) {
    ndim := Sprawl_Slice(T, NT) {
        create_slice_2d(sizex, sizey, T),
        make([]NT, 2),
    };

    ndim.lengths[0] = sizex;
    ndim.lengths[1] = sizey;

    return ndim;
}

// Deletes a `Sprawl_Slice`'s slice
delete_sprawl :: inline proc (ndim: ^Sprawl_Slice($T, $NT)) {
    delete(ndim.slice);
}

// Copies/clones a `Sprawl_Slice`, including its slice data
copy_sprawl :: inline proc (ndim: Sprawl_Slice($T, $NT)) {
    new_ndim := Sprawl_Slice(nil, ndim.length);
    copy_slice(new_ndim.slice, ndim.slice);
}