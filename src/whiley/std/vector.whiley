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

import std::array

public type Vector<T> is {
    T[] items,
    int length
} where length <= |items|

// =====================================================
// Constructors
// =====================================================

// Construct empty vector
public function Vector<T>() -> Vector<T>:
    return {
        items: [],
        length: 0
    }

// Construct initialised vector
public function Vector<T>(T[] items) -> Vector<T>:
    return {
        items: items,
        length: |items|
    }

// =====================================================
// Accessors
// =====================================================

/**
 * Return the top element of vector
 */
public function top<T>(Vector<T> vec) -> T
// Cannot query top of empty vector
requires vec.length > 0:
    //
    return vec.items[vec.length-1]

/**
 * Return number of elements in vector
 */ 
public function size<T>(Vector<T> vec) -> (int r)
ensures r == vec.length:
    return vec.length

/**
 * Get ith element of vector
 */
public function get<T>(Vector<T> vec, int ith) -> (T item)
// Index must be within array bounds 
requires ith >= 0 && ith < vec.length
// Must return actual item from vector
ensures item == vec.items[ith]:
    //
    return vec.items[ith]
    
// =====================================================
// Mutators
// =====================================================

public function push<T>(Vector<T> vec, T item) -> Vector<T>:
    //
    if vec.length == |vec.items|:
        // vec is full so must resize
        int nlen = (vec.length*2)+1
        // double size of internal array
        vec.items = array::resize<T>(vec.items,nlen,item)
    else:
        vec.items[vec.length] = item
    //
    vec.length = vec.length + 1        
    //
    return vec

/**
 * Pop an element off the "stack".
 */
public function pop<T>(Vector<T> vec) -> (Vector<T> r)
// Cannot pop item of empty vector
requires vec.length > 0:
    //
    vec.length = vec.length - 1
    //
    return vec

/**
 * Set ith element of vector
 */
public function set<T>(Vector<T> vec, int ith, T item) -> (Vector<T> result)
// Index must be within array bounds
requires ith >= 0 && ith < |vec.items|:
    // update element in question
    vec.items[ith] = item
    // done
    return vec

/**
 * Clear the vector, removing all elements
 */
public function clear<T>(Vector<T> vec) -> (Vector<T> r)
// Must return empty vector
ensures r.length == 0:
    // reset internal length
    vec.length = 0
    // done
    return vec
