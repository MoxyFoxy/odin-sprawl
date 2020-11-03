package sprawl

import "core:intrinsics"

Sprawl_Array :: struct (T: typeid, NT: typeid) where intrinsics.type_is_integer(NT) {
    data   : []T,
    lengths: []NT,
    offsets: []NT,
}

// From here on, they shouldn't require the intrinsics integer check as the struct has that.

// Abstraction over `_index` and `_index_sliced` for the `Sprawl_Array` struct
index :: inline proc (ndim: Sprawl_Array($T, $NT), indexes: ..NT) -> NT {
    if (ndim.slices == nil) {
        return _index(indexes, ndim.lengths);
    }

    else {
        return _index_sliced(indexes, ndim.lengths, ndim.offsets);
    }
}

// Abstraction over `_index_2d` and `_index_2d_sliced` for the `Sprawl_Array` struct
index_2d :: inline proc (ndim: Sprawl_Array($T, $NT), x, y: NT) -> NT {
    return _index_2d(x, y, ndim.lengths[0]);
}

// Abstraction over `_get` and `_get_sliced` for the `Sprawl_Array` struct
get :: inline proc (ndim: Sprawl_Array($T, $NT), indexes: ..NT) -> T {
    if (ndim.offsets == nil) {
        return _get(ndim.data, indexes, ndim.lengths);
    }

    else {
        return _get_sliced(ndim.data, indexes, ndim.lengths, ndim.offsets);
    }
}

// Abstraction over `_get_2d` and `_get_2d_sliced` for the `Sprawl_Array` struct
get_2d :: inline proc (ndim: Sprawl_Array($T, $NT), x, y: NT) -> T {
    if (ndim.offsets == nil) {
        return _get_2d(ndim.data, x, y, ndim.lengths[0]);
    }

    else {
        return _get_2d_sliced(ndim.data, x, y, ndim.lengths[0], ndim.offsets[0], ndim.offsets[1]);
    }
}

// Abstraction over `_set` and `_set_sliced` for the `Sprawl_Array` struct
set :: inline proc (ndim: Sprawl_Array($T, $NT), value: T, indexes: ..NT) {
    if (ndim.offsets == nil) {
        _set(ndim.data, indexes, ndim.lengths, value);
    }

    else {
        _set_sliced(ndim.data, indexes, ndim.lengths, ndim.offsets, value);
    }
}

// Abstraction over `_set_2d` and `_set_2d_sliced` for the `Sprawl_Array` struct
set_2d :: inline proc (ndim: Sprawl_Array($T, $NT), value: T, indexes: ..NT) {
    if (ndim.offsets == nil) {
        _set_2d(ndim.data, x, y, ndim.lengths[0], value);
    }

    else {
        _set_2d_sliced(ndim.data, x, y, ndim.lengths[0], ndim.offsets[0], ndim.offsets[1], value);
    }
}

// Abstraction over `_in_bounds` for the `Sprawl_Array` struct
in_bounds :: inline proc (ndim: Sprawl_Array($T, $NT), indexes: ..NT) -> bool {
    return _in_bounds(ndim.data, indexes, ndim.lengths);
}

// Abstraction over `_in_bounds_2d` for the `Sprawl_Array` struct
in_bounds_2d :: inline proc (ndim: Sprawl_Array($T, $NT), x, y: NT) -> bool {
    return _in_bounds_2d(ndim.data, x, y, ndim.lengths);
}

// Creates a `Sprawl_Array` and initializes the sprawled slice
create :: inline proc ($T: typeid, lengths: ..$NT) -> Sprawl_Array(T, NT) {
    ndim := Sprawl_Array(T, NT) {
        create_slice(lengths, T),
        make([]NT, len(lengths)),
        nil,
    };

    copy_slice(ndim.lengths, lengths);

    return ndim;
}

// Creates a constant-sized `Sprawl_Array` and initializes it
create_const :: proc ($T: typeid, lengths: [$N]$NT) -> Sprawl_Array(T, NT) {
    ndim := Sprawl_Array(T, NT) {
        create_slice_const(lengths, T),
        make([]NT, N),
        nil,
    };

    copy_slice(ndim.lengths, lengths);

    return ndim;
}

// Creates a 2-dimensional `Sprawl_Array` and initializes the sprawled slice
create_2d :: proc (sizex, sizey: $NT, $T: typeid) -> Sprawl_Array(T, NT) {
    ndim := Sprawl_Array(T, NT) {
        create_slice_2d(sizex, sizey, T),
        make([]NT, 2),
        nil
    };

    ndim.lengths[0] = sizex;
    ndim.lengths[1] = sizey;

    return ndim;
}

// Deletes a `Sprawl_Array`'s slice
delete :: inline proc (ndim: ^Sprawl_Array($T, $NT)) {
    delete(ndim.data);
}

// Clones a `Sprawl_Array`, including making clones of its slice data.
clone :: proc (ndim: Sprawl_Array($T, $NT)) -> Sprawl_Array(T, NT) {
    new_ndim := Sprawl_Array(nil, ndim.length, nil);
    copy_slice(new_ndim.data, ndim.data);

    if (ndim.slices == nil) {
        copy_slice(new_ndim.slices, ndim.slices);
    }

    return new_ndim;
}

// Clones a `Sprawl_Array`'s `slices`, including making clones of the sliced data.
clone_slice :: proc (ndim: Sprawl_Array($T, $NT)) -> Sprawl_Array(T, NT) {
    new_ndim := Sprawl_Array(nil, ndim.length, nil);
    copy_slice(new_ndim.data, ndim.data);

    return new_ndim;
}

// Subslices a `Sprawl_Array`. Does make a soft copy of the passed struct.
slice :: proc (ndim: Sprawl_Array($T, $NT), off_lens: ..NT) -> Sprawl_Array(T, NT) {
    new_ndim := ndim;

    new_ndim.lengths = make([]NT, len(off_lens) / 2);
    new_ndim.offsets = make([]NT, len(off_lens) / 2);

    copy_slice(new_ndim.offsets, off_lens[: len(off_lens) / 2  ]);
    copy_slice(new_ndim.lengths, off_lens[  len(off_lens) / 2 :]);

    return new_ndim;
}