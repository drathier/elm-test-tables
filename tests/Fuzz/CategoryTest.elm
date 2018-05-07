module Fuzz.CategoryTest exposing (..)

import Array
import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, float, int, list, string, tuple)
import Fuzz.Category exposing (..)
import Fuzz.Opaque exposing (a, appendable, b, comparable, comparable2, numberRange)
import Set
import Test exposing (..)
import Test.Table exposing (..)


mapTests =
  describe "Functor laws"
    [ map "List" List.map Fuzz.list
    , map "Array" Array.map Fuzz.array
    , map "Maybe" Maybe.map Fuzz.maybe
    , map "Result" Result.map (Fuzz.result (Fuzz.constant <| Err "no"))
    , map "Set" Set.map (Fuzz.list >> Fuzz.map Set.fromList)
    ]
