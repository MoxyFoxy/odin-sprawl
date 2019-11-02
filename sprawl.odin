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
g :: proc(n, size, offset: $T) -> T {
    return u64(n * size + offset);
}

@private
// For purely documentation and mathematical purposes
h :: proc(n: $T, sizes: []T) -> T {
    return u64(n) * mul(sizes);
}

// Public namespace for sprawl
sprawl :: proc {
    sprawl_index,
    sprawl_elem,
    sprawl_create,
};

// Returns index from specified indexes and sizes: slice[sprawl(indexes, sizes)]
sprawl_index :: inline proc(indexes, sizes: [$N]$T) -> T {

    // This is formula g
    output := indexes[1] * sizes[0] + indexes[0];

    // Iterate every value except the last two
    inline for i in 0..<len(indexes) - 2 {
        mul := T(1);

        // Multiply the sizes together, up to the count of i - 1
        for j in 0..<len(sizes) - i - 1 {
            mul *= sizes[j];
        }

        // This is formula h
        output += indexes[len(indexes) - i - 1] * mul;
    }

    return output;
}

// Returns element instead of index: sprawl(slice, indexes, sizes)
sprawl_elem :: inline proc(array: ^[]$R, indexes, sizes: [$N]$T) -> R {
    return array[sprawl_index(indexes, sizes)];
}

// Creates a sprawled slice. NOTE: made with `make`. Be sure to `delete` it!
sprawl_create :: inline proc(sizes: [$N]$T, $type: typeid) -> []type {
    mul := 1;

    inline for i in 0..len(sizes) - 1 {
        mul *= sizes[i];
    }

    return make([]type, mul);
}