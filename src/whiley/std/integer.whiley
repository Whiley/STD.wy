// Copyright (c) 2011, David J. Pearce (djp@ecs.vuw.ac.nz)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//    * Neither the name of the <organization> nor the
//      names of its contributors may be used to endorse or promote products
//      derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL DAVID J. PEARCE BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

package std

import std::ascii
import char from std::ascii // NEEDED FOR A COMPILER BUG

// THIS MODULE IS TO BE DEPRECATED

/**
 * Represents all signed integers representable in 8bits
 * of space in the two's complement representation.
 */
public type i8 is (int x)
    where x >=-128 && x <= 127

/**
 * Represents all signed integers representable in 16bits
 * of space in the two's complement representation.
 */
public type i16 is (int x)
    where x >=-32768 && x <= 32768

/**
 * Represents all signed integers representable in 32bits
 * of space in the two's complement representation.
 */
public type i32 is (int x)
    where x >=-2147483648 && x <= 2147483647

/**
 * Represents all signed integers representable in 64bits
 * of space in the two's complement representation.
 */
public type i64 is (int x)
    where x >= -9223372036854775808 && x <= 9223372036854775807

/**
 * Represents all unsigned integers representable in 8bits
 * of space.
 */
public type u8 is (int x)
    where x >=0 && x <= 255

/**
 * Represents all unsigned integers representable in 16bits
 * of space.
 */
public type u16 is (int x)
    where x >= 0 && x <= 65535

/**
 * Represents all unsigned integers representable in 32bits
 * of space.
 */
public type u32 is (int x)
    where x >= 0 && x <= 4294967295

/**
 * Represents all unsigned integers representable in 64bits
 * of space.
 */
public type u64 is (int x)
    where x >= 0 && x <= 18446744073709551615

/**
 * Represents all possible unsigned integers.
 */
public type uint is (int x) where x >= 0

public type nat is (int x) where x >= 0

// public function toString(int item) -> string:
//     return Any.toString(item)

// convert an integer into an unsigned byte
public function toUnsignedByte(u8 v) -> byte:
    //
    byte mask = 0b00000001
    byte r = 0b
    int i = 0
    while i < 8:
        if (v % 2) == 1:
            r = r | mask
        v = v / 2
        mask = mask << 1
        i = i + 1
    return r

// Convert a signed integer into a single byte
public function toSignedByte(i8 v) -> byte:
    //
    if v < 0:
        v = v + 256
    return toUnsignedByte(v)


// convert a byte into a string
public function toString(byte b) -> ascii::string:
    ascii::string r = [0; 'b']
    int i = 0
    while i < 8:
        if (b & 0b00000001) == 0b00000001:
            r[7-i] = '1'
        else:
            r[7-i] = '0'
        b = b >> 1
        i = i + 1
    return r

// Convert a byte into an unsigned int.  This assumes a little endian
// encoding.
public function toUnsignedInt(byte b) -> u8:
    int r = 0
    int base = 1
    while b != 0b:
        if (b & 0b00000001) == 0b00000001:
            r = r + base
        b = b >> 1
        base = base * 2
    return r

// Convert a byte array into an unsigned int assuming a little endian
// form for both individual bytes, and the array as a whole
public function toUnsignedInt(byte[] bytes) -> uint:
    int val = 0
    int base = 1
    int i = 0
    while i < |bytes|:
        int v = toUnsignedInt(bytes[i]) * base
        val = val + v
        base = base * 256
        i = i + 1
    return val

// Convert a byte into an unsigned int.  This assumes a little endian
// encoding.
public function toInt(byte b) -> int:
    int r = 0
    int base = 1
    while b != 0b:
        if (b & 0b00000001) == 0b00000001:
            r = r + base
        b = b >> 1
        base = base * 2
    // finally, add the sign
    if r >= 128:
        return -(256-r)
    else:
        return r

// Convert a byte array into a signed int assuming a little endian
// form for both individual bytes, and the array as a whole
public function toInt(byte[] bytes) -> int:
    int val = 0
    int base = 1
    int i = 0
    while i < |bytes|:
        int v = toUnsignedInt(bytes[i]) * base
        val = val + v
        base = base * 256
        i = i + 1
    // finally, add the sign
    if val >= (base/2):
        return -(base-val)
    else:
        return val
