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

