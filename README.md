# Whiley Standard Library (STD.wy)

This is the Whiley Standard Library which provides a supported set of
primitives for writing programs and interacting with the world.  The
modules of this library are nested in the `std` path.  They are:

- `std::array`.  This provides various functions for manipulating
  arrays in Whiley, such as `append()`, `index_of()`, `resize()`, etc.

- `std::ascii`.  This provides various functions for manipulating and
  decoding ASCII characters and strings, such as `decode()`,
  `is_digit()`, `is_whitespace()`, etc.

- `std::collection`.  This provides various fundamental collection
  classes, such as `hash_map`, `vector`, etc.

- `std::filesystem`.  This provides types and operations for reading
  and writing files, such as `File`, `open()`, etc.

- `std::integer`.  This provides various functions for parsing and
  converting integers to strings, such as `parse()`, `to_string()`,
  etc.

- `std::io`.  This provides various primitives for describing I/O
  streams, such as `reader` and `writer`, as well as for printing.

- `std::math`.  This provides various fundamental mathematical
  operations, such as `abs()`, `min()`, `max()`, etc.

At this stage, the library is very much a work-in-progress.  Several
other modules are scheduled for inclusion in the future:

- `std::utf8`.  This will provide various primitives for manipulating
  UTF-8 strings.

- `std::datetime`.  This will provide various primitives for
  manipulating dates and times.
