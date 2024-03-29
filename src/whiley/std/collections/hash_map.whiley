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

import u32, uint from std::int
import string from std::ascii
import std::option with Option
import std::collections::pair with Pair
import std::collections::vector with Vector
import std::collections::hash
import std::collections::iterator with Iterator

public type HashMap<S,T> is {
    // Cache of map length
    int length,
    // Array of buckets
    Vector<Pair<S,T> >[] buckets,
    // Hashing function
    hash::fn<S> hasher
} where |buckets| > 0

/**
 * Construct empty hash map for integer keys
 */
public function HashMap<T>() -> (HashMap<int,T> r):
    return HashMap<int,T>(&hash::hash(int))

/**
 * Construct empty hash map for boolean keys
 */
public function HashMap<T>() -> (HashMap<bool,T> r):
    return HashMap<bool,T>(&hash::hash(bool))

/**
 * Construct empty hash map for string keys
 */
public function HashMap<T>() -> (HashMap<string,T> r):
    return HashMap<string,T>(&hash::hash(int[]))

/**
 * Construct empty hash map
 */
public function HashMap<S,T>(hash::fn<S> hasher) -> (HashMap<S,T> r)
// Empty hash map
ensures r.length == 0:
    // Construct initial bucket
    Vector<Pair<S,T> > init = Vector()
    // Initially have 10 buckets
    return { length: 0, buckets:[init; 10], hasher: hasher }

/**
 * Check whether a given key is contained within this map.
 */ 
public function contains<S,T>(HashMap<S,T> map, S key) -> (bool r):
    // Determine target bucket
    u32 index = map.hasher(key) % |map.buckets|
    // Extract relevant bucket    
    Vector<Pair<S,T> > bucket = map.buckets[index]
    // Iterate bucket!
    for i in 0..vector::size(bucket):
        Pair<S,T> ith = vector::get(bucket,i)
        if ith.first == key:
            return true
    // Nothing found
    return false

/**
 * Check whether a given key is contained within this map.
 */ 
public function get<S,T>(HashMap<S,T> map, S key) -> (Option<T> r):
    // Determine target bucket
    u32 index = map.hasher(key) % |map.buckets|
    // Extract relevant bucket    
    Vector<Pair<S,T> > bucket = map.buckets[index]
    // Iterate bucket!
    for i in 0..vector::size(bucket):
        Pair<S,T> ith = vector::get(bucket,i)
        if ith.first == key:
            return option::Some(ith.second)
    // Nothing found
    return option::None

/**
 * Insert a new key/value pair into the hash map.  If the key is
 * already mapped to something, this is discarded.
 */
public function insert<S,T>(HashMap<S,T> map, S key, T value) -> (HashMap<S,T> r)
// Size of map can only increase
ensures r.length >= map.length:
    // Determine target bucket
    u32 index = map.hasher(key) % |map.buckets|
    // Extract relevant bucket
    Vector<Pair<S,T> > bucket = map.buckets[index]
    // Check whether key already contained
    for i in 0..vector::size(bucket):
        Pair<S,T> ith = vector::get(bucket,i)
        if ith.first == key:
            // Found match
            map.buckets[index] = vector::set(bucket,i,Pair(key,value))
            // Done
            return map
    // No existing mapping, so create one
    map.buckets[index] = vector::push(bucket,Pair(key,value))
    // Increase the length cache
    map.length = map.length + 1
    // Done
    return map

unsafe public function to_array<S,T>(HashMap<S,T> map) -> (Pair<S,T>[] result)
// Resulting array has same items as map
ensures |result| == map.length:
    // Find first value
    (uint b, uint i) = advance<S,T>(map,0,0)
    // Check whether anything found
    if b >= |map.buckets|:
        return []
    else:
        // Extract first item
        Pair<S,T> first = vector::get(map.buckets[b],i)
        // Construct resulting array
        Pair<S,T>[] items = [first; map.length]
        // Iterate remaining items
        for j in 1 .. |items|:
            // Find ith item
            (b,i) = advance<S,T>(map,b,i+1)
            items[j] = vector::get(map.buckets[b],i)            
        // Done
        return items

/**
 * Get an iterator over the key/value pairs held in this map
 */
public function iterator<S,T>(HashMap<S,T> map) -> Iterator<Pair<S,T> >:
    // Find first value
    (uint b, uint i) = advance<S,T>(map,0,0)
    // Done
    return {
       get: &( -> get(map,b,i)),
       next: &( -> next(map,b,i))
    }

// ====================================================================
// Helpers
// ====================================================================

private function get<S,T>(HashMap<S,T> map, uint bucket, uint index) -> Option<Pair<S,T> >:
    // NOTE: following unsafe core required because of limitation with
    // lambda preconditions in iterator constructor above.   
    assume bucket >= |map.buckets| || index < vector::size(map.buckets[bucket])
    // Check whether found something
    if bucket < |map.buckets|:
        // Matched an item
        return option::Some(vector::get(map.buckets[bucket],index))
    else:
        // Nothing left
        return option::None

private function next<S,T>(HashMap<S,T> map, uint bucket, uint index) -> Iterator<Pair<S,T> >:
    // Find nearest value
    (uint b, uint i) = advance(map,bucket,index+1)
    // Construct iterator
    return {
       get: &( -> get(map,b,i)),
       next: &( -> next(map,b,i))
    }

// Find next valid entry
private function advance<S,T>(HashMap<S,T> map, uint bucket, uint index) -> (uint b, uint i)
// Either nothing left, or a valid bucket index
ensures b >= |map.buckets| || i < vector::size(map.buckets[b]):
    if bucket < |map.buckets|:
        // Check whether found entry
        if index < vector::size(map.buckets[bucket]):
            return (bucket,index)
        else:
            // Use recursion (for now)
            return advance<S,T>(map,bucket+1,0)
    else:
        // No more entries
        return (|map.buckets|,0)
