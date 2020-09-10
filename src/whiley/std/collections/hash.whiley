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
package std::collections

import u32 from std::integer

// The general type of a hash function.
public type fn<T> is function(T)->(u32)

// Simple hash function for integers
public function hash(int x) -> u32:
    // eventually cast better here?
    u32 _x = (x+2147483648)
    return _x % 4294967295

// Simple hash function for booleans
public function hash(bool b) -> u32:
    if b:
        return 1
    else:
        return 0

// Simple hash function for integer arrays
public function hash(int[] xs) -> u32:
    u32 r = 0
    //
    for i in 0..|xs|:
        // NOTE: this is not good!    
        r = (r + hash(xs[i])) % 4294967295
    //
    return r

// Simple hash function for boolean arrays
public function hash(bool[] xs) -> u32:
    u32 r = 0
    //
    for i in 0..|xs|:
        // NOTE: this is not good!
        r = (r + hash(xs[i])) % 4294967295
    //
    return r