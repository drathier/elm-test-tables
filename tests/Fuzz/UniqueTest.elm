module Fuzz.UniqueTest exposing (testChar, testComparable, testFloat, testInt, testString)

import Array
import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, list)
import Fuzz.Category exposing (..)
import Fuzz.Opaque.Unique exposing (a, appendable, b, comparable)
import Fuzz.Unique exposing (char, float, int, string)
import Set
import Test exposing (..)
import Test.Table exposing (..)


testInt =
    fuzz (list int) "list of unique int" <| \v -> v |> Set.fromList |> Set.size |> Expect.equal (List.length v)


testComparable =
    fuzz (list comparable) "list of unique comparable" <| \v -> v |> Set.fromList |> Set.size |> Expect.equal (List.length v)


testFloat =
    fuzz (list float) "list of unique float" <| \v -> v |> Set.fromList |> Set.size |> Expect.equal (List.length v)


testString =
    fuzz (list string) "list of unique string" <| \v -> v |> Set.fromList |> Set.size |> Expect.equal (List.length v)


testChar =
    -- using a whole list (400 elements) of unique char has quite a high collision chance, since there are only ~113k valid unicode code points to choose from.
    fuzz3 char char char "triple of unique char" <| \a b c -> Set.fromList [ a, b, c ] |> Set.size |> Expect.equal 3
