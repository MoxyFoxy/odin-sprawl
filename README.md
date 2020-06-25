# Sprawl
Sprawl is a lightweight, optimized Odin library for dealing with n-dimensional slices without indirection.

To read up on the base library, please read [Structless](docs/structless.md).
To read up on the library using `Sprawl_Slice` (an abstraction), please read [Sprawl_Slice](docs/sprawl_slice.md). Note this abstracts everything in [Structless](docs/structless.md) and essentially replaces it.

### Collaborators
- Tetralux (optimization)
- sci4me (optimization)

# Formulae
The variables and parameters are as follows:
| `l` - `lengths`
| `i` - `indexes`
| `n` - length of `lengths` and `indexes` (they are the same)
| `j` - iterator
| `k` - iterator

The formulae are 0-based. The upper values on the summation and multiplication are inclusive, hence why they are one lower than how they appear in the code.
The formulae for this library are as follows.

## g
![formula g](blob/master/images/eq_g.png)
LaTeX: `g(l, i) = i_1 \cdot l_0 + i_0`

## h
![formula h](blob/master/images/eq_h.png)
LaTeX: `h(l, n, i, j) = i_{n - j - 1} \cdot \prod_{k = 0}^{n - j - 2} l_k`

## f ([\_index](blob/master/sprawl.odin#L50))
![formula f](blob/master/images/eq_f.png)
LaTeX: `f(l, n, i) = \sum_{j = 0}^{n - 3} (h(l_j, i, j)) + g(l, i)`

## Expanded
![expanded formula](blob/master/images/eq_expanded.png)
LaTeX: `f(l, n, i) = \sum_{j = 0}^{n - 3} \left(i_{n - j - 1} \cdot \prod_{k = 0}^{n - j - 2} l_k\right) + i_1 \cdot l_0 + i_0`