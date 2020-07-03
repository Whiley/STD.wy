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

import std::array
import uint from std::integer

public type Vector<T> is {
    T[] items,
    uint length
} where length <= |items|

// =====================================================
// Constructors
// =====================================================

// Construct empty vector
public function Vector<T>() -> (Vector<T> r)
// Returned vector is empty
ensures r.length == 0:
    return {
        items: [],
        length: 0
    }

// Construct initialised vector
public function Vector<T>(T[] items) -> (Vector<T> r)
// Return contains matching number of items 
ensures r.length == |items|
// Return contains matching items
ensures array::equals<T>(items,r.items,0,|items|):
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

/**
 * Convert vector into an array.
 */
public function to_array<T>(Vector<T> vec) -> (T[] items)
// Size of returned array matches vector size
ensures |items| == vec.length
// Ensure returned items match those in vector
ensures array::equals<T>(vec.items,0,items,0,vec.length):
    // Slice up the array
    return array::slice<T>(vec.items,0,vec.length)

// =====================================================
// Mutators
// =====================================================

public function push<T>(Vector<T> vec, T item) -> (Vector<T> nvec)
// Vector size increased by exactly one
ensures nvec.length == vec.length + 1
// Original items unchanged in result
ensures array::equals<T>(vec.items,nvec.items,0,vec.length)
// New item added to end
ensures nvec.items[vec.length] == item:
    //
    if vec.length == |vec.items|:
        // vec is full so must resize
        int nlen = (vec.length*2)+1
        // double size of internal array
        vec.items = array::resize<T>(vec.items,nlen,item)
    else:
        // Add new item
        vec.items[vec.length] = item
    // Increase length by one
    vec.length = vec.length + 1        
    //
    return vec

public function push_all<T>(Vector<T> vec, T[] items) -> (Vector<T> nvec)
// Vector size increased by exactly one
ensures nvec.length == vec.length + |items|
// Original items unchanged in result
ensures array::equals<T>(vec.items,nvec.items,0,vec.length)
// New items added to end
ensures array::equals<T>(items,0,nvec.items,vec.length,|items|):
    //
    int len = vec.length + |items|
    // Sanity check inputs
    if |items| == 0:
        // Nothing to do
        return vec
    else if len > |vec.items|:
        // vec is full so must resize
        int nlen = (vec.length*2) + |items|
        // double size of internal array
        vec.items = array::resize<T>(vec.items,nlen,items[0])
    // Add new items
    vec.items = array::copy(items,0,vec.items,vec.length,|items|)
    // Increase length by number added
    vec.length = vec.length + |items|
    //
    return vec


/**
 * Pop an element off the "stack".
 */
public function pop<T>(Vector<T> vec) -> (Vector<T> nvec)
// Cannot pop item of empty vector
requires vec.length > 0
// Vector size decreased by exactly one
ensures nvec.length == vec.length - 1
// Original items unchanged in result
ensures array::equals<T>(vec.items,nvec.items,0,nvec.length):
    //
    vec.length = vec.length - 1
    //
    return vec

/**
 * Set ith element of vector
 */
public function set<T>(Vector<T> vec, int ith, T item) -> (Vector<T> result)
// Index must be within array bounds
requires ith >= 0 && ith < vec.length
// Length of vector unchanged
ensures vec.length == result.length
// All items below ith remain unchanged
ensures array::equals<T>(vec.items,result.items,0,ith)
// All items above ith remain unchanged
ensures array::equals<T>(vec.items,result.items,ith+1,result.length)
// Ith element assigned item
ensures result.items[ith] == item:
    // update element in question
    vec.items[ith] = item
    // done
    return vec

/**
 * Remove the ith element of a vector.  Observe that this takes time
 * linear in the size of the resulting vector.
 */
public function remove<T>(Vector<T> vec, uint ith) -> (Vector<T> result)
// Index must be within array bounds
requires ith >= 0 && ith < vec.length
// Length of vector reduced by one
ensures (vec.length - 1) == result.length
// All items below ith remain unchanged
ensures array::equals<T>(vec.items,result.items,0,ith)
// All items that were above ith remain unchanged
ensures array::equals<T>(vec.items,ith+1,result.items,ith,result.length-ith):
    // Remove item from underlying array
    T[] items = array::remove<T>(vec.items,ith)
    // Done
    return { items: items, length: vec.length - 1 }

/**
 * Swap two items (which may be the same) in a vector.  The resulting
 * vector is otherwise unchanged.
 */
public function swap<T>(Vector<T> vec, uint ith, uint jth) -> (Vector<T> result)
// Elements to be swap must be within bounds
requires ith < vec.length && jth < vec.length
// Result is same size as dest
ensures result.length == vec.length
// All elements except ith and jth are identical
ensures all { i in 0..vec.length | i == ith || i == jth || vec.items[i] == result.items[i] }
// ith and jth elements are inded swaped
ensures vec.items[ith] == result.items[jth] && vec.items[jth] == result.items[ith]:
    // Swap underling items
    vec.items = array::swap(vec.items,ith,jth)
    // Done
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

/**
 * Equality of vectors
 */
public property equals<T>(Vector<T> lhs, Vector<T> rhs)
// Vector lengths must be equal
where (lhs.length == rhs.length)
// Visible vector elements must be equal
where array::equals<T>(lhs.items,rhs.items,0,lhs.length)