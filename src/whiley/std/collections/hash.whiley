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
package std::collections

import u32 from std::int

// The general type of a hash function.
public type fn<T> is function(T)->(u32)

// Simple hash function for integers
public function hash(int x) -> u32:
    // eventually cast better here?
    u32 _x = (x+2147483648) % 4294967295
    return _x 

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
