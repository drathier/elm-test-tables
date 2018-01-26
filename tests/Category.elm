module Category exposing (..)

import Array
import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, float, int, list, string, tuple)
import Fuzz.Category
import Fuzz.Opaque exposing (a, appendable, b, comparable, comparable2)
import Fuzz.Table exposing (..)
import Set
import Test exposing (..)
import Test.Table exposing (..)


suite : Test
suite =
  describe "tests"
    [ Fuzz.Category.map a List.map List.singleton "List"
    , Fuzz.Category.map a Array.map (Array.fromList << List.singleton) "Array"
    , Fuzz.Category.map a Maybe.map Just "Maybe"
    , Fuzz.Category.map a Result.map Ok "Result"
    , Fuzz.Category.map comparable Set.map Set.singleton "Set"
    ]

-- TODO: round trip tests!