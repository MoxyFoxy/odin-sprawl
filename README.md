# Sprawl
Sprawl is a lightweight, optimized Odin library for dealing with n-dimensional slices

# Procedures
Sprawl has three main procedures, all linked under the name `sprawl`!

## sprawl_index
`sprawl_index` is the core of this library. This allows you to access an n-dimensional slice given arrays and sizes.

### Example
Here's an example of getting an value at index (0, 3, 4, 1) where the size of the 4D array is (10, 10, 10, 10).

```
slice[sprawl([4]int{0, 3, 4, 1}, [4]int{10, 10, 10, 10})]
```

## sprawl_elem
`sprawl_elem` is an abstraction over `sprawl_index` that allows you to get the element instead of the index. This is for purely aesthetic preference. `sprawl_index` and `sprawl_elem` are equally acceptable; the choice depends on the user.

### Example
The only difference between this and `sprawl_index` is that you pass the slice itself instead of calling `sprawl` inside of the slice. This is accessing the same index and slice as in the example under `sprawl_index`.

```
sprawl(slice, [4]int{0, 3, 4, 1}, [4]int{10, 10, 10, 10})
```

## sprawl_create
`sprawl_create` is another huge core part of the library. This procedure allows you to create an n-dimensional slice. It's called as if you were making a normal slice, except with sizes!

### Example
Say I want to create the previously defined 10 x 10 x 10 x 10 slice. This is how you would achieve that:

```
slice := sprawl([4]int{10, 10, 10, 10}, int)
```

The second value is the type you want the slice to be. In this example, it's an int, therefore the type would be []int.

### NOTE
Since the slice created is made using `make`, please be sure to `delete` it! Garbage doesn't clean itself around here!

# Formulae
The formulae for this library are as follows. If you are a mathetician and know a better way to write these formulae, let me know!

## g
g(n) = n of n * size of n-1 + n of n-1

## h
h(n) = n of n * size of n-1 x size of n-2 x ... x size1

## f (`sprawl`)
f(n1, n2, ..., n of n) = h(n) + h(n of n-1) + h(...) + h(n3) + g(n2)