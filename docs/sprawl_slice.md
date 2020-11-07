# Sprawl_Slice
The `Sprawl_Slice` is an abstraction over the [base Sprawl library](../sprawl.odin).
This will help to make your code cleaner and easier to understand, removing about half of the messy slice construction you need to do.

## index
`index` is an abstraction over [\_index](structless.md#_index). This one isn't used for access, however. This is used just to get what the index count is at a specific offset in case you need it.

This is under the `index` procedure group.

### Example
Here's an example of getting the index of (0, 3, 4, 1). The size of the array is (10, 10, 10, 10) (for reference).

```
index(slice, 0, 3, 4, 1)
```

Isn't this much cleaner than [the alternative](structless.md#_index)?

## index_2d
`index_2d` is an abstraction over [\_index_2d](structless.md#_index_2d). Just like [index](#index), this isn't meant to be used for access. This is used for getting the index at a specific 2-dimensional offset.

### Example
For this example, let's use a 2D array of size (10, 11). This is how we would get the index at (5, 6):

```
index_2d(slice, 5, 6)
```

## ref
`ref` returns a pointer to the element. This is not an abstraction over anything.

### Example
Here's how you would get a reference using the same example from [iindex](#index):

```
ref(slice, 0, 3, 4, 1)
```

## ref_2d
`ref_2d` is the same as `[ref](#ref)`, but for a 2-dimensional slice.

```
ref_2d(slice, 5, 6)
```

## get
`get` is the real accessor. This is an abstraction over [\_get](structless.md#_get). `get` allows you to access an element at a specific index within the slice.

### Example
Here's how you would do the same example from [index](#index) (same code except for the procedure name):

```
get(slice, 0, 3, 4, 1)
```

## get_2d
`get_2d` is just like how [index](#get) is for [\_get](structless.md#_get), except for [\_get\_2d](structless.md#_get_2d).

### Example
Here's the same example from [index](#index_2d), except using `get_2d`:

```
get_2d(slice, 5, 6)
```

## set
`set` is an abstraction over [\_set](structless.md#_set). This is used to set the value of specific elements inside of the `Sprawl_Struct`.

### Example
Let's say we have a slice of size (10, 10, 10) and wish to set the element at index (5, 6, 7) to 12:

```
set(slice, 12, 5, 6, 7)
```

## set_2d
`set_2d` is just like how [set](#set) is for [\_set](structless.md#_set), except for [\_set\_2d](structless.md#_set_2d).

### Example
Let's say we have a slice of size (10, 11) and wish to set the element at index (5, 6) to 12:

```
set_2d(slice, 5, 6, 12)
```

## in_bounds
`in_bounds` is an abstraction over [\_in\_bounds](structless.md#_in_bounds). Checks to see whether a specified index is in bounds or not within the slice.

### Example
Let's say we have a slice of size (10, 10, 10) and are trying to access (11, 11, 11) (which should return `false`):

```
in_bounds(slice, 10, 10, 10)
```

## in_bounds_2d
`in_bounds_2d` is an abstraction over [\_in\_bounds\_2d](structless.md#_in_bounds_2d). It works just the same as [in_bounds](#in_bounds) does, except in two dimensions.

### Example
Let's say we have a slice of size (10, 11) and wish to see if index (5, 6) is in-bounds (which would return `true`):

```
in_bounds_2d(slice, 5, 6)
```

## create
`create` is a huge, core part of the library. This procedure allows you to create and initialize a `Sprawl_Slice`.

### Example
Let's say we want to create a sprawled slice of ints that is 4x4x4x4. This is how that could be achieved:

```
slice := create(int, 4, 4, 4, 4)
```

## create_const
`create_const` allows you to create a `Sprawl_Slice` using constant arrays.

### Example
Let's try to create a 10 x 10 x 10 x 10 slice using a constant array:

```
slice := create_const(int, [4]int{10, 10, 10, 10})
```

## create_2d
`create_2d` allows for the creation and initialization of a `Sprawl_Slice` using two dimensions.

### Example:
Let's try to create a 5 x 5 slice. This is how that could be achieved:

```
slice := create_2d(5, 5, int)
```

## delete_slice
Since a `Sprawl_Slice` is not just a normal slice, I decided to create a deletion procedure which just calls `delete` on the data, lengths, and offsets.

### Example
```
delete_slice(slice)
```

## clone
`clone` copies/clones the give `Sprawl_Slice` into a new one. This calls `copy_slice` on the `Sprawl_Slice.slice`.

### Example
```
new_slice := clone(slice)
```

## clone_slice
`clone_slice` does more than just clone everything over. This accounts for the offsets and lengths and will only copy over data usable in the slice. That means subslices will ONLY have the data they can use. This will remove any lengths of 1 except for the last as there is only one dimension and there is no need for a length to be there. Note that this WILL not clone the offsets as there is nothing to offset.

This is a pretty expensive procedure to use often. Use it with caution.

### Example
```
new_slice := clone_slice(subslice)
```