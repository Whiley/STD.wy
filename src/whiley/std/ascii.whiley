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

import std::integer
import std::array

// The ASCII standard (INCITS 4-1986[R2012]) defines a 7bit character
// encoding.
public type char is (int x) where 0 <= x && x <= 127

// Define the ASCII letter
public type letter is (int x) where ('a' <= x && x <= 'z') || ('A' <= x && x <= 'Z')

// Define the ASCII uppercase letter
public type uppercase is (int x) where ('A' <= x && x <= 'Z')

// Define the ASCII lowercase letter
public type lowercase is (int x) where ('a' <= x && x <= 'z')

// Define the ASCII digit
public type digit is (int x) where ('0' <= x && x <= '9')

// Define string as sequence of ASCII characters
public type string is char[]

// === CONTROL CHARACTERS ===

// Null character
public int NUL = 0

// Start of Header
public int SOH = 1

// Start of Text
public int STX = 2

// End of Text
public int ETX = 3

// End of Transmission
public int EOT = 4

// Enquiry
public int ENQ = 5

// Acknowledgment
public int ACK = 6

// Bell
public int BEL = 7

// Backspace
public int BS = 8

// Horizontal Tab
public int HT = 9

// Line Feed
public int LF = 10

// Vertical Tab
public int VT = 11

// Form Feed
public int FF = 12

// Carriage Return
public int CR = 13

// Shift Out
public int SO = 14

// Shift In
public int SI = 15

// Data Link Escape
public int DLE = 16

// Device Control 1
public int DC1 = 17

// Device Control 2
public int DC2 = 18

// Device Control 3
public int DC3 = 19

// Device Control 4
public int DC4 = 20

// Negative Acknowledgement
public int NAK = 21

// Synchronous Idle
public int SYN = 22

// End of Transmission Block
public int ETB = 23

// Cancel
public int CAN = 24

// End of Medium
public int EM = 25

// Substitute
public int SUB = 26

// Escape
public int ESC = 27

// File Separator
public int FS = 28

// Group Separator
public int GS = 29

// Record Separator
public int RS = 30

// Unit Separator
public int US = 31

// Delete
public int DEL = 127

// Convert an ASCII character into a byte.
public function to_byte(char v) -> byte:
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

// Convert an ASCII string into a list of bytes
public function to_bytes(string s) -> byte[]:
    byte[] r = [0b; |s|]
    int i = 0
    while i < |s| where i >= 0:
        r[i] = to_byte(s[i])
        i = i + 1
    return r

// Convert a list of bytes into an ASCII string
public function from_bytes(byte[] data) -> string:
    string r = [0; |data|]
    int i = 0
    while i < |data| where i >= 0:
        r[i] = integer::to_int(data[i])
        i = i + 1
    return r

public function is_upper_case(char c) -> bool:
    return 'A' <= c && c <= 'Z'

public function is_lower_case(char c) -> bool:
    return 'a' <= c && c <= 'z'

public function is_letter(char c) -> bool:
    return ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z')

public function is_digit(char c) -> bool:
    return '0' <= c && c <= '9'

public function is_whitespace(char c) -> bool:
    return c == ' ' || c == '\t' || c == '\n' || c == '\r'

public function to_string(int item) -> string:
    //
    bool sign
    // First, normalise item and record sign
    if item < 0:
       sign = false
       item = -item
    else:
       sign = true
    // Second, determine number of digits.  This is necessary to
    // avoid unnecessary dynamic memory allocatione    
    int tmp = item
    int digits = 0
    do:
        tmp = tmp / 10
        digits = digits + 1
    while tmp != 0
    // Finally write digits into resulting string
    string r = ['0';digits]
    do:
        int remainder = item % 10
        item = item / 10
        char digit = ('0' + remainder)
        digits = digits - 1
        r[digits] = digit
    while item != 0
    //
    if sign:
        return r
    else:
        // This could be optimised!
        return array::append("-",r)

/*
constant digits is [
    '0','1','2','3','4','5','6','7','8','9',
    'a','b','c','d','e','f','g','h'
]

// Convert an integer into a hex string
public function toHexString(int item) -> string:
    string r = ""
    int count = 0
    int i = item
    while i > 0:
        int v = i / 16
        int w = i % 16
        count = count + 1
        i = v
    //
    i = count
    while item > 0:
        i = i - 1    
        int v = item / 16
        int w = item % 16
        r[i] = digits[w]
        item = v
    //
    return r
*/

// parse a string representation of an integer value
public function parse_int(ascii::string input) -> int|null:
    //
    // first, check for negative number
    int start = 0
    bool negative

    if input[0] == '-':
        negative = true
        start = start + 1
    else:
        negative = false
    // now, parse remaining digits
    int r = 0
    int i = start
    while i < |input|:
        char c = input[i]
        r = r * 10
        if !ascii::is_digit(c):
            return null
        r = r + ((int) c - '0')
        i = i + 1
    // done
    if negative:
        return -r
    else:
        return r
