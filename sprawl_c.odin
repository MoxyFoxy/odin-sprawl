package sprawl

import "core:fmt"

// This encompasses everything in the file.
// Hence, from here on, though it goes against
// common style, everything will start with 0 indent.
//
// If you want c-compatibility within Sprawl, make sure to
// define `CCOMPAT` to `true`.
//
// TODO(F0x): Once Odin allows for compiling to big-endian,
//            add an endianness `when` check.
when #config(CCOMPAT, false) {

import "core:runtime"

sprawlc_Array :: struct {
    size     : u64,
    data     : rawptr, // [] byte
    n_data   : u32,
    lengths  : rawptr, // [] u32
    n_lengths: u32,
    offsets  : rawptr, // [] u32
    n_offsets: u32
}

// Converts a c-compatible array to an Odin u32 array.
ccompat_arr_to_u32arr :: inline proc "c" (arr: rawptr, len: u32) -> [] u32 {
    return transmute([]u32) runtime.Raw_Slice{
                                arr,
                      cast(int) len,
    };
}

@export
@(link_name="_sprawlc_index")
sprawlc_index :: proc "c" (ndim: ^sprawlc_Array, n_indexes: u32, indexes: rawptr) -> u32 {
    indexes := ccompat_arr_to_u32arr(indexes,      n_indexes);
    lengths := ccompat_arr_to_u32arr(ndim.lengths, ndim.n_lengths);

    context = runtime.default_context();

    fmt.print("Indexes: ");
    fmt.println(indexes);

    fmt.print("Lengths: ");
    fmt.println(lengths);

    if (ndim.offsets == nil) {
        return _index(indexes, lengths);
    }

    else {
        offsets := ccompat_arr_to_u32arr(ndim.offsets, ndim.n_offsets);

        return _index_sliced(indexes, lengths, offsets);
    }
}

@export
@(link_name="_sprawlc_get")
sprawlc_get :: proc "c" (ndim: ^sprawlc_Array, dest: rawptr, n_indexes: u32, indexes: rawptr) {
    indexes := ccompat_arr_to_u32arr(indexes,      n_indexes);
    lengths := ccompat_arr_to_u32arr(ndim.lengths, ndim.n_lengths);

    context = runtime.default_context();

    fmt.print("Indexes: ");
    fmt.println(indexes);

    fmt.print("Lengths: ");
    fmt.println(lengths);

    src: uintptr = transmute(uintptr) ndim;

    if (ndim.offsets == nil) {
        src += cast(uintptr) (cast(u64) _index(indexes, lengths) * ndim.size);
    }

    else {
        offsets := ccompat_arr_to_u32arr(ndim.offsets, ndim.n_offsets);

        src += cast(uintptr) (cast(u64) _index_sliced(indexes, lengths, offsets) * ndim.size);
    }

    runtime.mem_copy(dest, transmute(rawptr) src, cast(int) ndim.size);
}

@export
@(link_name="_sprawlc_set")
sprawlc_set :: proc "c" (ndim: ^sprawlc_Array, src: rawptr, n_indexes: u32, indexes: rawptr) {
    context = runtime.default_context();
    fmt.println("Got here");
    indexes := ccompat_arr_to_u32arr(indexes,      n_indexes);
    lengths := ccompat_arr_to_u32arr(ndim.lengths, ndim.n_lengths);

    fmt.println("Got here");

    fmt.print("Indexes: ");
    fmt.println(indexes);

    fmt.print("Lengths: ");
    fmt.println(lengths);

    dest: uintptr = transmute(uintptr) ndim;

    if (ndim.offsets == nil) {
        dest += cast(uintptr) (cast(u64) _index(indexes, lengths) * ndim.size);
    }

    else {
        offsets := ccompat_arr_to_u32arr(ndim.offsets, ndim.n_offsets);

        dest += cast(uintptr) (cast(u64) _index_sliced(indexes, lengths, offsets) * ndim.size);
    }

    runtime.mem_copy(transmute(rawptr) dest, src, cast(int) ndim.size);
}

}