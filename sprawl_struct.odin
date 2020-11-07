package sprawl

import "core:intrinsics"
import "core:runtime"

Sprawl_Slice :: struct (T: typeid, NT: typeid) where intrinsics.type_is_integer(NT) {
    data   : []T,
    lengths: []NT,
    offsets: []NT,
}

// From here on, they shouldn't require the intrinsics integer check as the struct has that.

// Abstraction over `_index` and `_index_sliced` for the `Sprawl_Slice` struct
index :: inline proc (ndim: Sprawl_Slice($T, $NT), indexes: ..NT) -> NT {
    if (ndim.offsets == nil) {
        return _index(indexes, ndim.lengths);
    }

    else {
        return _index_sliced(indexes, ndim.lengths, ndim.offsets);
    }
}

// Abstraction over `_index_2d` and `_index_2d_sliced` for the `Sprawl_Slice` struct
index_2d :: inline proc (ndim: Sprawl_Slice($T, $NT), x, y: NT) -> NT {
    return _index_2d(x, y, ndim.lengths[0]);
}

// Gets the reference to an element
ref :: inline proc (ndim: Sprawl_Slice($T, $NT), indexes: ..NT) -> ^T {
    if (ndim.offsets == nil) {
        return transmute(^T) (cast(uintptr) &ndim.data[0] +
                              cast(uintptr) (_index(indexes, ndim.lengths) * size_of(T)));
    }

    else {
        return transmute(^T) (cast(uintptr) &ndim.data[0] +
                              cast(uintptr) (_index_sliced(indexes, ndim.lengths, ndim.offsets) * size_of(T)));
    }
}

// Gets the reference to an element in a 2D array
ref_2d :: inline proc (ndim: Sprawl_Slice($T, $NT), x, y: NT) -> ^T {
    return transmute(^T) (transmute(uintptr) &ndim.data[0] +
                          transmute(uintptr) (_index_2d(x, y, ndim.lengths) * size_of(T)));
}

// Abstraction over `_get` and `_get_sliced` for the `Sprawl_Slice` struct
get :: inline proc (ndim: Sprawl_Slice($T, $NT), indexes: ..NT) -> T {
    if (ndim.offsets == nil) {
        return _get(ndim.data, indexes, ndim.lengths);
    }

    else {
        return _get_sliced(ndim.data, indexes, ndim.lengths, ndim.offsets);
    }
}

// Abstraction over `_get_2d` and `_get_2d_sliced` for the `Sprawl_Slice` struct
get_2d :: inline proc (ndim: Sprawl_Slice($T, $NT), x, y: NT) -> T {
    if (ndim.offsets == nil) {
        return _get_2d(ndim.data, x, y, ndim.lengths[0]);
    }

    else {
        return _get_2d_sliced(ndim.data, x, y, ndim.lengths[0], ndim.offsets[0], ndim.offsets[1]);
    }
}

// Abstraction over `_set` and `_set_sliced` for the `Sprawl_Slice` struct
set :: inline proc (ndim: Sprawl_Slice($T, $NT), value: T, indexes: ..NT) {
    if (ndim.offsets == nil) {
        _set(ndim.data, indexes, ndim.lengths, value);
    }

    else {
        _set_sliced(ndim.data, indexes, ndim.lengths, ndim.offsets, value);
    }
}

// Abstraction over `_set_2d` and `_set_2d_sliced` for the `Sprawl_Slice` struct
set_2d :: inline proc (ndim: Sprawl_Slice($T, $NT), value: T, x, y: NT) {
    if (ndim.offsets == nil) {
        _set_2d(ndim.data, x, y, ndim.lengths[0], value);
    }

    else {
        _set_2d_sliced(ndim.data, x, y, ndim.lengths[0], ndim.offsets[0], ndim.offsets[1], value);
    }
}

// Abstraction over `_in_bounds` for the `Sprawl_Slice` struct
in_bounds :: inline proc (ndim: Sprawl_Slice($T, $NT), indexes: ..NT) -> bool {
    return _in_bounds(ndim.data, indexes, ndim.lengths);
}

// Abstraction over `_in_bounds_2d` for the `Sprawl_Slice` struct
in_bounds_2d :: inline proc (ndim: Sprawl_Slice($T, $NT), x, y: NT) -> bool {
    return _in_bounds_2d(ndim.data, x, y, ndim.lengths);
}

// Creates a `Sprawl_Slice` and initializes the sprawled slice
create :: inline proc ($T: typeid, lengths: ..$NT) -> Sprawl_Slice(T, NT) {
    ndim := Sprawl_Slice(T, NT) {
        create_slice(lengths, T),
        make([]NT, len(lengths)),
        nil,
    };

    copy_slice(ndim.lengths, lengths);

    return ndim;
}

// Creates a constant-sized `Sprawl_Slice` and initializes it
create_const :: proc ($T: typeid, lengths: [$N]$NT) -> Sprawl_Slice(T, NT) {
    ndim := Sprawl_Slice(T, NT) {
        create_slice_const(lengths, T),
        make([]NT, N),
        nil,
    };

    copy_slice(ndim.lengths, lengths);

    return ndim;
}

// Creates a 2-dimensional `Sprawl_Slice` and initializes the sprawled slice
create_2d :: proc (sizex, sizey: $NT, $T: typeid) -> Sprawl_Slice(T, NT) {
    ndim := Sprawl_Slice(T, NT) {
        create_slice_2d(sizex, sizey, T),
        make([]NT, 2),
        nil
    };

    ndim.lengths[0] = sizex;
    ndim.lengths[1] = sizey;

    return ndim;
}

// Deletes a `Sprawl_Slice`'s slice
delete_slice :: inline proc (ndim: ^Sprawl_Slice($T, $NT)) {
    delete(ndim.data);
    delete(ndim.lengths);
    delete(ndim.offsets);
}

// Clones a `Sprawl_Slice`, including making clones of its slice data.
clone :: proc (ndim: Sprawl_Slice($T, $NT)) -> Sprawl_Slice(T, NT) {
    new_ndim := Sprawl_Slice(T, NT){make([]T, len(ndim.data)), ndim.lengths, nil};

    copy_slice(new_ndim.data, ndim.data);

    if (ndim.offsets != nil) {
        new_ndim.offsets = make([]NT, len(ndim.offsets));

        copy_slice(new_ndim.offsets, ndim.offsets);
    }

    return new_ndim;
}

// Clones a `Sprawl_Slice`'s `slices`, including making clones of the sliced data.
// This will take a lot longer that `clone` if the slice does not have offsets.
clone_slice :: proc (ndim: Sprawl_Slice($T, $NT)) -> Sprawl_Slice(T, NT) {
    if (ndim.offsets == nil) {
        return clone(ndim);
    }

    new_ndim := Sprawl_Slice(T, NT){nil, nil, nil};

    length     := len (ndim.lengths);
    dimensions := make([]NT, length);

    temp_lengths := make([]NT, length);

    i := 0;

    // This calculates how many dimensions should be dropped.
    // If their length is one, there is no reason to store the
    // lengths. In fact, it'll only cause issues.
    //
    // NOTE(F0x1fy):
    //     If your lengths are just one element, save yourself
    //     the hassle and turn it into a normal slice.
    //
    //     You get more functionality that way.
    //
    //     Plus, Sprawl does not work with slices lower than
    //     two dimensions.
    for len in 0..<length {
        if (ndim.lengths[len] > 1 || len == length - 1) {
            temp_lengths[i] = ndim.lengths[len];
            i += 1;
        }
    }

    copy_slice(new_ndim.lengths, temp_lengths);
    delete(temp_lengths);

    // This calculates the amount of data
    // needed by calculating the amount of
    // elements in the slice.
    data_size : NT = 1;

    for dim in 0..<length {
        data_size *= ndim.lengths[dim];
    }

    new_ndim.data = make([]T, data_size);

    i = 0;

    // Set everything to maximum value.
    for j in 0..<length {
        dimensions[j] = ndim.lengths[j] - 1;
    }

    slice_cloning: for {
        dim_iteration: for j in 0..<length {

            // The last element is a special case as 0 is valid for it,
            // but for everything else, make sure it's not 0.
            if (dimensions[length - j - 1] != (j > 0 ? 0 : -1)) {
                new_ndim.data[len(new_ndim.data) - i - 1] = _get_sliced(ndim.data, dimensions, ndim.lengths, ndim.offsets);

                // Reverse downward iteration.
                dimensions[length - j - 1] -= 1;
                i += 1;

                break dim_iteration;
            }

            // If it's at its lowest possible value, just set it back to its highest and move on.
            else {
                dimensions[length - j - 1] = ndim.lengths[length - j - 1] - 1;
            }

            if (j == length - 1) {
                break slice_cloning;
            }
        }
    }

    return new_ndim;
}

// Subslices a `Sprawl_Slice`. Does make a soft copy of the passed struct.
slice :: proc (ndim: Sprawl_Slice($T, $NT), off_lens: ..NT) -> Sprawl_Slice(T, NT) {
    new_ndim := ndim;

    new_ndim.lengths = make([]NT, len(off_lens) / 2);
    new_ndim.offsets = make([]NT, len(off_lens) / 2);

    copy_slice(new_ndim.offsets, off_lens[: len(off_lens) / 2  ]);
    copy_slice(new_ndim.lengths, off_lens[  len(off_lens) / 2 :]);

    return new_ndim;
}