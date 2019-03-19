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

// ===========================================================================
// Stack
// ===========================================================================
public type Stack<T> is {
    T[] items,
    int length
}

public function Stack<T>(int max, T item) -> Stack<T>:
    return {
        items: [item; max],
        length: 0
    }

public function size<T>(Stack<T> stack) -> int:
    return stack.length

/**
 * Return the top element of the "stack".
 */
public function top<T>(Stack<T> stack) -> T:
    //
    return stack.items[stack.length-1]


/**
 * Push an element onto the "stack".
 */
public function push<T>(Stack<T> stack, T element) -> (Stack<T> r):
    //
    stack.items[stack.length] = element
    stack.length = stack.length + 1
    return stack

/**
 * Pop an element off the "stack".
 */
public function pop<T>(Stack<T> stack) -> (Stack<T> r):
    //
    stack.length = stack.length - 1
    //
    return stack

// ===========================================================================
// Vector
// ===========================================================================

public type Vector<T> is {
    T[] items,
    int length
} where length <= |items|

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

public function length<T>(Vector<T> vec) -> (int r)
ensures r == vec.length:
    return vec.length

public function add<T>(Vector<T> vec, T item) -> Vector<T>:
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

public function set<T>(Vector<T> vec, int index, T item) -> (Vector<T> result)
// Index must be within array bounds
requires index >= 0 && index < |vec.items|:
    // update element in question
    vec.items[index] = item
    // done
    return vec

public function get<T>(Vector<T> vec, int index) -> (T item)
// Index must be within array bounds 
requires index >= 0 && index < vec.length
// Must return actual item from vector
ensures item == vec.items[index]:
    //
    return vec.items[index]