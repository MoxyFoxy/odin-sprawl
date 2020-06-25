package sprawl

import "core:intrinsics"
import "core:fmt"

// Made with help from:
//   - Tetralux (optimization)
//   - sci4me (optimization)
//
// Original code made by F0x1fy
//
// Have optimizations you'd like to share?
// Make a pull request and explain the optimization!
//
// Formulae:
//   - g: - Calculates the offset value
//      | g(l, i) = i_1 \cdot l_0 + i_0
//   - h: - Calculates the raw dimensions
//      | h(l, n, i, j) = i_{n - j - 1} \cdot \prod_{k = 0}^{n - j - 2} l_k
//   - f: - Iteratively adds the h values for every index, then adds g
//      | f(l, n, i) = \sum_{j = 0}^{n - 3} (h(l_j, i, j)) + g(l, i)
//
// F expanded:
// | f(l, n, i) = \sum_{j = 0}^{n - 3} \left(i_{n - j - 1} \cdot \prod_{k = 0}^{n - j - 2} l_k\right) + i_1 \cdot l_0 + i_0
//
// Simplified formula:
//   - index * size + offset

index :: proc {
    _index,
    struct_index,
};

index_2d :: proc {
    _index_2d,
    struct_index_2d,
};

get :: proc {
    _get,
    struct_get,
};

get_2d :: proc {
    _get_2d,
    struct_get_2d,
};

// Returns index from specified indexes and lengths: slice[index(indexes, lengths)]
_index :: proc (indexes, lengths: []$NT) -> NT                       where intrinsics.type_is_integer(NT) {

    // This is formula g
    output := indexes[1] * lengths[0] + indexes[0];

    // Iterate every value except the last two
    for i in 0..<len(indexes) - 2 {
        mul := NT(1);

        // Multiply the lengths together, up to the count of i - 1
        for j in 0..<len(lengths) - i - 1 {
            mul *= lengths[j];
        }

        // This is formula h
        output += indexes[len(indexes) - i - 1] * mul;
    }

    return output;
}

// Returns index from x, y, and sizex for a 2D array
_index_2d :: inline proc (x, y, sizex: $NT) -> NT                    where intrinsics.type_is_integer(NT) {
    return y * sizex + x;
}

// Returns element instead of index: get(slice, indexes, lengths)
_get :: inline proc (array: []$T, indexes, lengths: []$NT) -> T      where intrinsics.type_is_integer(NT) {
    return array[_index(indexes, lengths)];
}

// Returns element instead of index: get_2d(slice, y, x, sizex)
_get_2d :: inline proc (array: []$T, x, y, sizex: $NT) -> T          where intrinsics.type_is_integer(NT) {
    return array[_index_2d(x, y, sizex)];
}

// Sets an index to a specific value
_set :: inline proc (array: []$T, indexes, lengths: []$NT, value: T) where intrinsics.type_is_integer(NT) {
    array[_index(indexes, lengths)] = value;
}

// Sets an index to a specific value in a 2D slice
_set_2d :: inline proc (array: []$T, x, y, sizex: $NT, value: T)     where intrinsics.type_is_integer(NT) {
    array[y * sizex + x] = value;
}

// Checks if an index is in-bounds
_in_bounds :: proc (indexes, lengths: []$NT) -> bool                 where intrinsics.type_is_integer(NT) {
    mul_i := 1;
    mul_s := 1;

    for i in 0..<len(indexes) {
        mul_i *= indexes[i];
        mul_s *= lengths[i];
    }

    return mul_i < mul_s;
}

// Check if an index is in-bounds in a 2D slice
_in_bounds_2d :: inline proc (x, y, sizex, sizey: $NT) -> bool       where intrinsics.type_is_integer(NT) {
    return y * sizex + x < sizex * sizey;
}

// Creates a sprawled slice. NOTE: made with `make`. Be sure to `delete` it!
create_slice :: proc (lengths: []$NT, $T: typeid) -> []T             where intrinsics.type_is_integer(NT) {
    mul := 1;

    for i in 0..<len(lengths) {
        mul *= lengths[i];
    }

    return make([]T, mul);
}

// Creates a sprawled slice. NOTE: made with `make`. Be sure to `delete` it!
create_slice_const :: proc (lengths: [$N]$NT, $T: typeid) -> []T       where intrinsics.type_is_integer(NT) {
    mul := 1;

    for i in 0..<N {
        mul *= lengths[i];
    }

    return make([]T, mul);
}

// Creates a 2-dimensional sprawled slice. NOTE: made with `make`. Be sure to `delete` it!
create_slice_2d :: proc (sizex, sizey: $NT, $T: typeid) -> []T       where intrinsics.type_is_integer(NT) {
    return make([]T, sizex * sizey);
}