module Fuzz.Opaque.UniqueTests exposing (appendables, comparables, expectDuplicateFreeList, opaques)

import Expect
import Expect.Category exposing (associative, identityElement)
import Fuzz exposing (int, list)
import Fuzz.Opaque.Unique exposing (..)
import Set
import Test exposing (describe, fuzz, fuzz2, fuzz3, test)



-- These tests are just for type checking


appendables =
    describe "appendables"
        [ fuzz (list appendable) "appendable" expectDuplicateFreeList
        ]


comparables =
    describe "comparables"
        [ fuzz (list comparable) "comparable" expectDuplicateFreeList
        , fuzz (list comparable2) "comparable2" expectDuplicateFreeList
        , fuzz (list comparable3) "comparable3" expectDuplicateFreeList
        ]


opaques =
    describe "opaques"
        [ fuzz (list a) "a" expectDuplicateFreeList
        , fuzz (list b) "b" expectDuplicateFreeList
        , fuzz (list c) "c" expectDuplicateFreeList
        , fuzz (list d) "d" expectDuplicateFreeList
        , fuzz (list Fuzz.Opaque.Unique.e) "e" expectDuplicateFreeList
        , fuzz (list f) "f" expectDuplicateFreeList
        , fuzz (list g) "g" expectDuplicateFreeList
        , fuzz (list h) "h" expectDuplicateFreeList
        , fuzz (list i) "i" expectDuplicateFreeList
        , fuzz (list j) "j" expectDuplicateFreeList
        , fuzz (list k) "k" expectDuplicateFreeList
        , fuzz (list l) "l" expectDuplicateFreeList
        , fuzz (list m) "m" expectDuplicateFreeList
        , fuzz (list n) "n" expectDuplicateFreeList
        , fuzz (list o) "o" expectDuplicateFreeList
        , fuzz (list p) "p" expectDuplicateFreeList
        , fuzz (list q) "q" expectDuplicateFreeList
        , fuzz (list r) "r" expectDuplicateFreeList
        , fuzz (list s) "s" expectDuplicateFreeList
        , fuzz (list t) "t" expectDuplicateFreeList
        , fuzz (list u) "u" expectDuplicateFreeList
        , fuzz (list v) "v" expectDuplicateFreeList
        , fuzz (list w) "w" expectDuplicateFreeList
        , fuzz (list x) "x" expectDuplicateFreeList
        , fuzz (list y) "y" expectDuplicateFreeList
        , fuzz (list z) "z" expectDuplicateFreeList
        ]



-- expectDuplicateFreeListTest =
--   test "asdf" (\_ -> expectDuplicateFreeList [ 1, 2, 3, 1, 5, 6 ])


expectDuplicateFreeList lst =
    case lst of
        x :: xs ->
            if List.member x xs then
                Expect.fail "found a duplicate element"

            else
                expectDuplicateFreeList xs

        [] ->
            Expect.pass
