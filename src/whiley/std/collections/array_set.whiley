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
package std.collections

import std::collections::vector with Vector
import std::array
import equals from std::array
import contains from std::array

// Array set is vector where all visible elements unique
public type ArraySet<T> is (Vector<T> v)
// All elements up to length are unique
where array::unique_elements<T>(v.items,v.length)

/**
 * Construct empty array set.
 */
public function ArraySet<T>() -> (ArraySet<T> r)
// Returned array set is empty
ensures r.length == 0:
    return {length: 0, items:[]}

/**
 * Construct array set from set of unique items.
 */
public function ArraySet<T>(T[] items) -> (Vector<T> r)
// Initial set of items must be unique
requires array::unique_elements<T>(items,|items|)
// Return contains matching number of items 
ensures r.length == |items|
// Return contains matching items
ensures array::equals<T>(items,r.items,0,|items|):
    return vector::Vector<T>(items)

/**
 * Insert element into an array set
 */
public function insert<T>(ArraySet<T> set, T item) -> (ArraySet<T> r)
// At most one element inserted
ensures (r.length >= set.length) && (r.length <= (set.length+1))
// If item already contained, nothing changed
ensures contains<T>(set.items,item,0,set.length) <==> (r.length == set.length)
// All elements unchanged upto original length
ensures equals<T>(set.items,r.items,0,set.length)
// Inserted item may be at end
ensures (r.length == set.length) || (r.items[set.length] == item):
    //
    if contains<T>(set.items,item,0,set.length):
        // Item already contained, so do nothing
        return set
    else:
        // Item not contained, so add
        return (ArraySet<T>) vector::push<T>(set,item)

