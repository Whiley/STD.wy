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

public type Pair<S,T> is { S first, T second }

/**
 * Construct a new pair
 */
public function Pair<S,T>(S first, T second) -> (Pair<S,T> r)
// Pair constructed from given items
ensures r.first == first && r.second == second:
    //
    return {first: first, second: second}

/**
 * Swap elements of a pair
 */
public function swap<S,T>(Pair<S,T> p) -> (Pair<T,S> r)
// Ensure elements are swapped
ensures r.first == p.second && r.second == p.first:
    //
    return {first: p.second, second: p.first}

/**
 * Map elements of a pair from one type to another
 */
public function map<S,T>(Pair<S,S> pair, function(S)->(T) fn) -> Pair<T,T>:
    return {
        first: fn(pair.first),
        second: fn(pair.second)
    }

/**
 * Map elements of a pair from one type to another
 */
public function map_1st<S,T,U>(Pair<S,T> pair, function(S)->(U) fn) -> Pair<U,T>:
    return {
        first: fn(pair.first),
        second: pair.second
    }

/**
 * Map elements of a pair from one type to another
 */
public function map_2nd<S,T,U>(Pair<S,T> pair, function(T)->(U) fn) -> Pair<S,U>:
    return {
        first: pair.first,
        second: fn(pair.second)
    }

    

