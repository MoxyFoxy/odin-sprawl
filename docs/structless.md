# Structless
Sprawl has four group procedures and multiple other procedures and sub-procedures. The four main procedures (which are groups of procedures) are: `index`, `get`, `set`, and `in_bounds`.
This documentation does not take advantage of the `Sprawl_Slice` struct. To read up on this documentation, please click [here](sprawl_slice.md).

## \_index
`_index` is the core of this library. This allows you to access an n-dimensional slice given arrays and lengths.

### Example
Here's an example of getting an value at index (0, 3, 4, 1) where the size of the 4D array is (10, 10, 10, 10).

```
slice[_index([4]int{0, 3, 4, 1}, [4]int{10, 10, 10, 10})]
```

### \_index_2d
`_index_2d` a 2-dimensional variant of [_index](#_index) built for ONLY 2-dimensional slices. Meant to be a small performance gain over _index when using only 2-dimensional arrays.

#### Example
Let's say we have a 2D array of size (10, 11) (sizex, sizey). This is how we would access index (5, 6), 5 being x and 6 being y:

```
slice[_index_2d(5, 6, 10)]
```

## \_get
`_get` is an abstraction over [\_index](#_index) that allows you to get the element instead of the index. This is for purely aesthetic preference. `index` and `get` are equally acceptable; the choice depends on the user.

### Example
The only difference between this and [\_index](#_index) is that you pass the slice itself instead of calling `_index` inside of the slice. This is accessing the same index and slice as in the example under [\_index](#_index).

```
_get(slice, [4]int{0, 3, 4, 1}, [4]int{10, 10, 10, 10})
```

### \_get_2d
This is like how [\_get](#_get) is for [\_index](#_index), except for [\_index\_2d](#_index_2d).

#### Example
Just like in [\_index\_2d](#_index_2d), let's say we have a 2D array of size (10, 11) (sizex, sizey). This is how we would access the element at index (5, 6), 5 being x and 6 being y:

```
_get_2d(slice, 5, 6, 10)
```

## \_set
This procedure allows you to set a specific index in a slice to a set value. This is essentially [\_get](#_get) except with an extra `value` parameter.

### Example
Let's say we have a slice of size (10, 10, 10) and wish to set the element at index (5, 6, 7) to 12:

```
_set(arr, [3]int{5, 6, 7], [3]int{10, 10, 10}, 12)
```

### \_set_2d
This is an extension of [\_set](#_set) except in the format of a 2D slice.

#### Example
Let's say we have a slice of size (10, 11) (sizex, sizey) and wish to set the element at index (5, 6), 5 being x, and 6 being y, to 12:

```
_set_2d(arr, 5, 6, 10, 12)
```

## \_in_bounds
This procedure returns a boolean on whether or not an index is in bounds.

### Example
Let's say we have a slice of size (10, 10, 10) and are trying to access (11, 11, 11) (which would return `false`):

```
_in_bounds([3]int{11, 11, 11}, [3]int{10, 10, 10})
```

### \_in_bounds_2d
This is a 2-dimensional version of [\_in\_bounds](#_in_bounds).

#### Example
Let's say we have a slice of size (10, 11) (sizex, sizey) and wish to see if index (5, 6) is in-bounds (which would return `true`):

```
_in_bounds_2d(5, 6, 10, 11)
```

## create_slice
`create_slice` is another huge, core part of the library. This procedure allows you to create an n-dimensional slice. It's called as if you were making a normal slice, except with lengths!

### Example
Say I want to create the previously defined 10 x 10 x 10 x 10 slice. This is how you would achieve that:

```
slice := create_slice([4]int{10, 10, 10, 10}, int)
```

The second value is the type you want the slice to be. In this example, it's an int, therefore the type would be []int.

### NOTE
Since the slice created is made using `make`, please be sure to `delete` it! Garbage doesn't clean itself around here!

## create_slice_2d
`create_slice_2d` is a 2-dimensional version of `create_slice`. This procedure allows you to create a 2-dimensional slice.

### Example
Say I want to create a 5 x 5 slice. This is how you would achieve that:

```
slice := create_slice_2d(5, 5, int)
```

The second value is the type you want the slice to be. In this example, it's an int, therefore the type would be []int.

### NOTE
Since the slice created is made using `make`, please be sure to `delete` it! Garbage doesn't clean itself around here!