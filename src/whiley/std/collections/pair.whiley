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

    

