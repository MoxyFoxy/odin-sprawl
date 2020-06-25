# Sprawl_Slice
The `Sprawl_Slice` is an abstraction over the [base Sprawl library](../sprawl.odin).
This will help to make your code cleaner and easier to understand, removing about half of the messy slice construction you need to do.

## struct_index
`struct_index` is an abstraction over [\_index](structless.md#_index). This one isn't used for access, however. This is used just to get what the index count is at a specific offset in case you need it.

This is under the `index` procedure group.

### Example
Here's an example of getting the index of (0, 3, 4, 1). The size of the array is (10, 10, 10, 10) (for reference).

```
index(slice, [4]int{0, 3, 4, 1})
```

Isn't this much cleaner than [the alternative](structless.md#_index)?

## struct_index_2d
`struct_index_2d` is an abstraction over [\_index_2d](structless.md#_index_2d). Just like [struct_index](#struct_index), this isn't meant to be used for access. This is used for getting the index at a specific 2-dimensional offset.

This is under the `index_2d` procedure group.

### Example
For this example, let's use a 2D array of size (10, 11). This is how we would get the index at (5, 6):

```
index_2d(slice, 5, 6)
```

## struct_get
`struct_get` is the real accessor. This is an abstraction over [\_get](structless.md#_get). `struct_get` allows you to access an element at a specific index within the slice.

This is under the `get` procedure group.

### Example
Here's how you would do the same example from [struct_index](#struct_index) (same code except for the procedure name):

```
get(slice, [4]int{0, 3, 4, 1})
```

## struct_get_2d
`struct_get_2d` is just like how [struct_index](#struct_get) is for [\_get](structless.md#_get), except for [\_get\_2d](structless.md#_get_2d).

This is under the `get_2d` procedure group.

### Example
Here's the same example from [struct_index](#struct_index_2d), except using `struct_get_2d`:

```
get_2d(slice, 5, 6)
```

## struct_set
`struct_set` is an abstraction over [\_set](structless.md#_set). This is used to set the value of specific elements inside of the `Sprawl_Struct`.

This is under the `set` procedure group.

### Example
Let's say we have a slice of size (10, 10, 10) and wish to set the element at index (5, 6, 7) to 12:

```
set(slice, [3]int{5, 6, 7}, 12)
```

## struct_set_2d
`struct_set_2d` is just like how [struct_set](#struct_set) is for [\_set](structless.md#_set), except for [\_set\_2d](structless.md#_set_2d).

This is under the `set_2d` procedure group.

### Example
Let's say we have a slice of size (10, 11) and wish to set the element at index (5, 6) to 12:

```
set_2d(slice, 5, 6, 12)
```

## struct_in_bounds
`struct_in_bounds` is an abstraction over [\_in\_bounds](structless.md#_in_bounds). Checks to see whether a specified index is in bounds or not within the slice.

This is under the `in_bounds` procedure group.

### Example
Let's say we have a slice of size (10, 10, 10) and are trying to access (11, 11, 11) (which should return `false`):

```
in_bounds(slice, [3]int{10, 10, 10})
```

## struct_in_bounds_2d
`struct_in_bounds_2d` is an abstraction over [\_in\_bounds\_2d](structless.md#_in_bounds_2d). It works just the same as [struct_in_bounds](#struct_in_bounds) does, except in two dimensions.

This is under the `in_bounds_2d` procedure group.

### Example
Let's say we have a slice of size (10, 11) and wish to see if index (5, 6) is in-bounds (which would return `true`):

```
in_bounds_2d(slice, 5, 6)
```

## create_sprawl
`create_sprawl` is a huge, core part of the library. This procedure allows you to create and initialize a `Sprawl_Slice`.

This is not under a procedure group.

### Example
Let's say we want to create a sprawled slice of ints using a pre-allocated slice. This is how that could be achieved:

```
slice := create_sprawl(lengths, int)
```

## create_sprawl_const
`create_sprawl_const` allows you to create a `Sprawl_Slice` using constant arrays.

This is not under a procedure group.

### Example
Let's try to create a 10 x 10 x 10 x 10 slice using a constant array:

```
slice := create_sprawl_const([4]{10, 10, 10, 10}, int)
```

## create_sprawl_2d
`create_sprawl_2d` allows for the creation and initialization of a `Sprawl_Slice` using two dimensions.

This is not under a procedure group.

### Example:
Let's try to create a 5 x 5 slice. This is how that could be achieved:

```
slice := create_sprawl_2d(5, 5, int)
```

## delete_sprawl
Since a `Sprawl_Slice` is not just a normal slice, I decided to create a deletion procedure which just calls `delete(ndim.slice)`.

### Example
```
delete_sprawl(slice)
```

## copy_sprawl
`copy_sprawl` copies/clones the give `Sprawl_Slice` into a new one. This calls `copy_slice` on the `Sprawl_Slice.slice`.

### Example
```
new_slice := copy_sprawl(slice)
```