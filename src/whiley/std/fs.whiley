// Copyright 2015 The Whiley Project Developers
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
package std

import std::ascii

public type uint is (int x) where x >= 0

// ====================================================
// File I/O
// ====================================================

public type File is {
    // Read all bytes of this file in one go.
    method read_all() -> byte[],

    // Reads at most a given number of bytes from the file.  This
    // operation may block if the number requested is greater than that
    // available.
    method read(uint) -> byte[],

    // Writes a given list of bytes to the output stream.
    method write(byte[]) -> uint,

    // Flush this output stream thereby forcing those items written
    // thus far to the output device.
    method flush(),

    // Check whether the end-of-stream has been reached and, hence,
    // that there are no further bytes which can be read.
    method has_more() -> bool,

    // Closes this file reader thereby releasin any resources
    // associated with it.
    method close(),

    // Return the number of bytes which can be safely read without
    // blocking.
    method available() -> uint
}

public final rwMode READONLY = 0
public final rwMode READWRITE = 1

public type rwMode is (int x) where (x == 0) || (x == 1)

// Create a file object for reading / writing
public native method open(ascii::string fileName, rwMode mode) -> File
