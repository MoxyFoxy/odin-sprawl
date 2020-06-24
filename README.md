# Sprawl
Sprawl is a lightweight, optimized Odin library for dealing with n-dimensional slices

### Collaborators
- Tetralux (optimization)
- sci4me (optimization)



# Procedures
Sprawl has three group procedures, three main procedures, and several sub-procedures. The three main procedures (which are groups of several procedures) are: `sprawl`, `set`, and `bounds`.

## index
`index` is the core of this library. This allows you to access an n-dimensional slice given arrays and lengths.

This is under the `sprawl` procedure group.

### Example
Here's an example of getting an value at index (0, 3, 4, 1) where the size of the 4D array is (10, 10, 10, 10).

```
slice[sprawl([4]int{0, 3, 4, 1}, [4]int{10, 10, 10, 10})]
```

### 2d
`2d` is a sub-procedure of `index`. In code they are not related, but they are in concept. `spawl_2d` is built for only 2-dimensional slices.

This is under the `sprawl` procedure group.

#### Example
Let's say we have a 2D array of size (10, 11) (sizex, sizey). This is how we would access index (5, 6), 5 being x and 6 being y:

```
slice[sprawl(5, 6, 10)]
```

## elem
`elem` is an abstraction over `index` that allows you to get the element instead of the index. This is for purely aesthetic preference. `index` and `elem` are equally acceptable; the choice depends on the user.

This is under the `sprawl` procedure group.

### Example
The only difference between this and `index` is that you pass a pointer to the slice itself instead of calling `sprawl` inside of the slice. This is accessing the same index and slice as in the example under `index`.

```
sprawl(&slice, [4]int{0, 3, 4, 1}, [4]int{10, 10, 10, 10})
```

### elem_2d
This is like how `elem` is for `index`, except for `2d`.

This is under the `sprawl` procedure group.

#### Example
Just like in `2d`, let's say we have a 2D array of size (10, 11) (sizex, sizey). This is how we would access the element at index (5, 6), 5 being x and 6 being y:

```
sprawl(&slice, 5, 6, 10)
```

## create_slice
`create_slice` is another huge core part of the library. This procedure allows you to create an n-dimensional slice. It's called as if you were making a normal slice, except with lengths!

This is not under a procedure group.

### Example
Say I want to create the previously defined 10 x 10 x 10 x 10 slice. This is how you would achieve that:

```
slice := sprawl([4]int{10, 10, 10, 10}, int)
```

The second value is the type you want the slice to be. In this example, it's an int, therefore the type would be []int.

### NOTE
Since the slice created is made using `make`, please be sure to `delete` it! Garbage doesn't clean itself around here!

## \_set
This procedure allows you to set a specific index in a slice to a set value. This is essentially `elem` except with an extra `value` parameter. Why the \_ at the beginning? Read the note after this procedure to see why that is.

This is under the `set` procedure group.

### Example
Let's say we have a slice of size (10, 10, 10) and wish to set the element at index (5, 6, 7) to 12:

```
sprawl(&arr, [3]int{5, 6, 7], [3]int{10, 10, 10}, 12)
```

### \_set_2d
This is an extension of `_set` except in the format of a 2D slice.

This is under the `set` procedure group.

#### Example
Let's say we have a slice of size (10, 11) (sizex, sizey) and wish to set the element at index (5, 6), 5 being x, and 6 being y, to 12:

```
sprawl(&arr, 5, 6, 10, 12)
```

## \_bounds
This is the only exception to being under the umbrella of the `sprawl` procedure. This procedure is like this as its parameter types clash with `index`. Why the \_ at the beginning? This is so it can fit in the same procedure "namespace" as `_bounds_2d`. This procedure returns a boolean on whether or not an index is in bounds.

This is under the `bounds` procedure group.

### Example
Let's say we have a slice of size (10, 10, 10) and are trying to access (11, 11, 11) (which would return `false`):

```
bounds([3]int{11, 11, 11}, [3]int{10, 10, 10})
```

### \_bounds_2d
This is a 2-dimensional version of `bounds`.

This is under the `bounds` procedure group.

#### Example
Let's say we have a slice of size (10, 11) (sizex, sizey) and wish to see if index (5, 6) is in-bounds (which would return `true`):

```
bounds(5, 6, 10, 11)
```

# Formulae
The formulae for this library are as follows. If you are a mathematician and know a better way to write these formulae, let me know!

## g
g(n) = n of n * size of n-1 + n of n-1

## h
h(n) = n of n * size of n-1 x size of n-2 x ... x size1

## f (`sprawl`)
f(n1, n2, ..., n of n) = h(n) + h(n of n-1) + h(...) + h(n3) + g(n2)