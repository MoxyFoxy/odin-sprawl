package sprawl

// Made in collaboration with:
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
//      | g(n) = n of n * size of n-1 + n of n-1
//   - h: - Calculates the raw dimensions
//      | h(n) = n of n * size of n-1 x size of n-2 x ... x size1
//   - f: - Iteratively adds the h values for every index, then adds g
//      | f(n1, n2, ..., n of n) = h(n) + h(n of n-1) + h(...) + h(n3) + g(n2)
//
// Simplified formula:
//   - index * size + offset

@private
// For purely documentation and mathematical purposes
g :: proc (n, size, offset: $NT) -> NT where intrinsics.type_is_integer(NT) {
    return u64(n * size + offset);
}

@private
// For purely documentation and mathematical purposes
h :: proc (n: $NT, lengths: []NT) -> NT where intrinsics.type_is_integer(NT) {
    return u64(n) * mul(lengths);
}



// Public namespace for sprawl
sprawl :: proc {
    index,
    index_2d,
    elem,
    elem_2d,
};

// Umbrella procedure for setting values
set :: proc {
    _set,
    _set_2d,
};

// Umbrella procedure for bounds-checking
bounds :: proc {
    _bounds,
    _bounds_2d,
};



// Returns index from specified indexes and lengths: slice[sprawl(indexes, lengths)]
index :: proc (indexes, lengths: [$N]$NT) -> NT                        where intrinsics.type_is_integer(NT) {

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
index_2d :: inline proc (x, y, sizex: $NT) -> NT                       where intrinsics.type_is_integer(NT) {
    return y * sizex + x;
}

// Returns element instead of index: sprawl(slice, indexes, lengths)
elem :: inline proc (array: []$T, indexes, lengths: [$N]$NT) -> T      where intrinsics.type_is_integer(NT) {
    return array[index(indexes, lengths)];
}

// Returns element instead of index: sprawl(slice, y, x, sizex)
elem_2d :: inline proc (array: []$T, x, y, sizex: $NT) -> T            where intrinsics.type_is_integer(NT) {
    return array[2d(x, y, sizex)];
}

// Creates a sprawled slice. NOTE: made with `make`. Be sure to `delete` it!
create_slice :: proc (lengths: [$N]$NT, $T: typeid) -> []T             where intrinsics.type_is_integer(NT) {
    mul := 1;

    for i in 0..len(lengths) - 1 {
        mul *= lengths[i];
    }

    return make([]T, mul);
}

// Sets an index to a specific value
_set :: inline proc (array: []$T, indexes, lengths: [$N]$NT, value: T) where intrinsics.type_is_integer(NT) {
    array[sprawl(indexes, lengths)] = value;
}

// Sets an index to a specific value in a 2D slice
_set_2d :: inline proc (array: []$T, x, y, sizex: $NT, value: T)       where intrinsics.type_is_integer(NT) {
    array[y * sizex + x] = value;
}

// Checks if an index is in-bounds
_bounds :: proc (indexes, lengths: [$N]$NT) -> bool                    where intrinsics.type_is_integer(NT) {
    mul_i := 1;
    mul_s := 1;

    for i in 0..<len(indexes) {
        mul_i *= indexes[i];
        mul_s *= lengths[i];
    }

    return mul_i < mul_s;
}

// Check if an index is in-bounds in a 2D slice
_bounds_2d :: inline proc (x, y, sizex, sizey: $NT) -> bool            where intrinsics.type_is_integer(NT) {
    return y * sizex + x < sizex * sizey;
}