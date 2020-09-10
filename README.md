# Whiley Standard Library (STD.wy)

This is the Whiley Standard Library which provides a supported set of
primitives for writing programs and interacting with the world.  The
modules of this library are nested in the `std` path.  They are:

- `std::array`.  This provides various functions for manipulating
  arrays in Whiley, such as `append()`, `index_of()`, `resize()`, etc.

- `std::ascii`.  This provides various functions for manipulating and
  decoding ASCII characters and strings, such as `decode()`,
  `is_digit()`, `is_whitespace()`, etc.

- `std::filesystem`.  This provides types and operations for reading
  and writing files, such as `File`, `open()`, etc.

- `std::integer`.  This provides various functions for parsing and
  converting integers to strings, such as `parse()`, `to_string()`,
  etc.

- `std::io`.  This provides various primitives for describing I/O
  streams, such as `reader` and `writer`, as well as for printing.

- `std::math`.  This provides various fundamental mathematical
  operations, such as `abs()`, `min()`, `max()`, etc.

- `std::option`.  This provides a standard container which either
  holds `Some` value or `None`.  This can be used to hold `null`
  values, and includes various useful operations (e.g. `map`,
  `filter`, etc).

- `std::collections::array_set`.  This provides a set implementation
  backed by an array which is suitable for arrays of modest size only,
  or those which are changed infrequently.

- `std::collections::hash`.  This provides a standard concept of a
  `hash` function as necessary for hash-based containers.

- `std::collections::hash_map`.  This provides a straightforward
  implementation of a hash map container.

- `std::collections::iterator`.  This provides a standard concept of
  an iterator, as necessary for iterating various containers.

- `std::collections::pair`.  This provides a simple pair container which includes
  various useful operations (e.g. `swap`, `map`, etc).

- `std::collections::vector`.  This provides a straightforward
  implementation of a resizeable array container.

At this stage, the library is very much a work-in-progress.  Several
other modules are scheduled for inclusion in the future:

- `std::utf8`.  This will provide various primitives for manipulating
  UTF-8 strings.

- `std::datetime`.  This will provide various primitives for
  manipulating dates and times.
