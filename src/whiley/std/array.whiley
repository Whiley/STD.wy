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

import uint from std::integer

// ===================================================================
// Properties
// ===================================================================

// Check if two arrays equal for a given subrange
public property equals<T>(T[] lhs, T[] rhs, int start, int end)
// Arrays must be big enough to hold subrange
where |lhs| >= end && |rhs| >= end
// All items in subrange match
where all { i in start..end | lhs[i] == rhs[i] }

public property contains<T>(T[] lhs, T item, int start, int end)
// Some index in given range contains item
where some { i in start..end | lhs[i] == item }

// Ensure all elements in an array (upto a given point) are unique
property unique_elements<T>(T[] items, int end)
// All items upto end are unique
where all { i in 0..end, j in (i+1)..end | items[i] != items[j] }

// ===================================================================
// Queries
// ===================================================================

// find first index in list which matches character.  If no match,
// then return null.
public function first_index_of<T>(T[] items, T item) -> (int|null index)
// If int returned, element at this position matches item
ensures index is int ==> items[index] == item
// If int returned, element at this position is first match
ensures index is int ==> all { i in 0 .. index | items[i] != item }
// If null returned, no element in items matches item
ensures index is null ==> all { i in 0 .. |items| | items[i] != item }:
    //
    return first_index_of(items,item,0)

// find first index after a given start point in list which matches character.
// If no match, then return null.
public function first_index_of<T>(T[] items, T item, int start) -> (int|null index)
// Starting point cannot be negative
requires start >= 0 && start <= |items|
// If int returned, element at this position matches item
ensures index is int ==> items[index] == item
// If int returned, element at this position is first match
ensures index is int ==> all { i in start .. index | items[i] != item }
// If null returned, no element in items matches item
ensures index is null ==> all { i in start .. |items| | items[i] != item }:
    //
    int i = start
    //
    while i < |items|
    // i is positive
    where i >= 0
    // No element seen so far matches item
    where all { j in start .. i | items[j] != item }:
        //
        if items[i] == item:
            return i
        i = i + 1
    //
    return null

// find last index in list which matches character.  If no match,
// then return null.
public function last_index_of<T>(T[] items, T item) -> (int|null index)
// If int returned, element at this position matches item
ensures index is int ==> items[index] == item
// If int returned, element at this position is last match
ensures index is int ==> all { i in (index+1) .. |items| | items[i] != item }
// If null returned, no element in items matches item
ensures index is null ==> all { i in 0 .. |items| | items[i] != item }:
    //
    int i = |items|
    //
    while i > 0
    where i <= |items|
    // No element seen so far matches item
    where all { j in i..|items| | items[j] != item }:
        //
        i = i - 1
        if items[i] == item:
            return i
    //
    return null

// ===================================================================
// Mutators
// ===================================================================

// replace all occurrences of "old" with "new" in list "items".
public function replace<T>(T[] items, T old, T n) -> (T[] r)
// Every position in items matching old replaced with n
ensures all { i in 0..|items| | (items[i] == old) ==> r[i] == n }
// Every other position remains the same
ensures all { i in 0..|items| | (items[i] != old) ==> r[i] == items[i] }
// Size of resulting array remains the same
ensures |items| == |r|:
    //
    int i = 0
    T[] oldItems = items // ghost
    //
    while i < |items|
    where i >= 0 && |items| == |oldItems|
    where all { k in 0..i | (oldItems[k] == old) ==> (items[k] == n) }
    where all { k in 0..|items| | (oldItems[k] != old) ==> (items[k] == oldItems[k]) }:
        if oldItems[i] == old:
            items[i] = n
        i = i + 1
    //
    return items

// Extract slice of items array between start and up to (but not including) end.
public function slice<T>(T[] items, int start, int end) -> (T[] r)
// Given region to slice must make sense
requires start >= 0 && start <= end && end <= |items|
// Size of slice determined by difference between start and end
ensures |r| == (end - start)
// Items returned in slice match those in region from start
ensures all { i in 0..|r| | items[i+start] == r[i] }:
    //
    if start == end:
        return []
    else:    
        T[] nitems = [items[0]; end-start]
        return copy(items,start,nitems,0,|nitems|)

public function append<T>(T[] lhs, T[] rhs) -> (T[] r)
// Resulting array exactly size of s1 and s2 together 
ensures |r| == |lhs| + |rhs|
// Elements of lhs are stored first in result
ensures all { k in 0..|lhs| | r[k] == lhs[k] }
// Elemnts of rhs are stored after those of lhs
ensures all { k in 0..|rhs| | r[k+|lhs|] == rhs[k] }:
    //
    if |lhs| == 0:
        return rhs
    else:
        // resize array
        T[] rs = resize<T>(lhs, |lhs| + |rhs|, lhs[0])
        // copy over new items
        return copy(rhs,0,rs,|lhs|,|rhs|)

public function append<T>(T[] items, T item) -> (T[] r)
// Every item from original array is retained
ensures all { k in 0..|items| | r[k] == items[k] }
// Last item in result matches item appended
ensures r[|items|] == item
// Size of array is one larger than original
ensures |r| == |items|+1:
    //
    T[] nitems = [item; |items| + 1]
    int i = 0
    //
    while i < |items| 
    where i >= 0 && i <= |items| && |nitems| == |items|+1
    where all { k in 0..i | nitems[k] == items[k] }:
        nitems[i] = items[i]
        i = i + 1
    //
    return nitems

public function append<T>(T item, T[] items) -> (T[] r)
// Every item from original array is retained
ensures all { k in 0..|items| | r[k+1] == items[k] }
// First item in result matches item appended
ensures r[0] == item
// Size of array is one larger than original
ensures |r| == |items|+1:
    //
    T[] nitems = [item; |items| + 1]
    int i = 0
    //
    while i < |items| 
    where i >= 0 && i <= |items| && |nitems| == |items|+1
    where all { k in 0..i | nitems[k+1] == items[k] }:
        nitems[i+1] = items[i]
        i = i + 1 
    //
    return nitems

public function resize<T>(T[] src, int size) -> (T[] result)
// Cannot create an array of negative size
requires size >= 0 && size <= |src|
// Resulting array must have desired size
ensures |result| == size
// All elements must be copied over if increasing in size
ensures all { k in 0..size | result[k] == src[k] }:
    //    
    if |src| == 0:
        // handle empty array case
        return src
    else:
        result = [src[0]; size]
        int i = 0
        // copy what we can over
        while i < size:
            result[i] = src[i]
            i = i + 1
        //
        return result

public function resize<T>(T[] items, int size, T item) -> (T[] result)
// Required size cannot be negative
requires size >= 0
// Resulting array must have desired size
ensures |result| == size
// All elements must be copied over if increasing in size
ensures (|items| <= size) ==> all { k in 0..|items| | result[k] == items[k] }
// Must fill upper part of result with default item
ensures (|items| <= size) ==> all { k in |items|..size | result[k] == item }
// As many elements as possible must be copied if decreasing in size
ensures (|items| > size) ==> all { k in 0..size | result[k] == items[k] }:
    //
    T[] nitems = [item; size]    
    int i = 0
    // copy first part
    while i < size && i < |items|
    where i >= 0 && |nitems| == size
    // All elements up to i match as before
    where all { j in 0..i | nitems[j] == items[j] }
    // All elements above size match item
    where size >= |items| ==> all { j in |items| .. size | nitems[j] == item}:
        nitems[i] = items[i]
        i = i + 1
    //
    return nitems

public function copy<T>(T[] src, uint srcStart, T[] dest, uint destStart, uint length) -> (T[] result)
// Source array must contain enough elements to be copied
requires (srcStart + length) <= |src|
// Destination array must have enough space for copied elements
requires (destStart + length) <= |dest|
// Result is same size as dest
ensures |result| == |dest|
// All elements before copied region are same
ensures all { i in 0 .. destStart | dest[i] == result[i] }
// All elements in copied region match src
ensures all { i in 0 .. length | src[i+srcStart] == result[i+destStart] }
// All elements above copied region are same
ensures all { i in (destStart+length) .. |dest| | dest[i] == result[i] }:
    //
    int i = srcStart
    int j = destStart
    int srcEnd = srcStart + length
    //
    while i < srcEnd:
        dest[j] = src[i]
        i = i + 1
        j = j + 1
    //
    return dest
