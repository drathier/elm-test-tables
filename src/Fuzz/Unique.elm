module Fuzz.Unique exposing (char, float, int, string)

{-| Fuzz.Unique contains fuzzers for built-in types but with a very low probability of ever generating two equal values. Perfect if you're filling up a `Set` from a `List` and want that `Set` to be the same size as the `List`, or you just want each value to be unique.

@docs int, float, string, char

-}

import Char
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int)
import Random.Pcg as Random exposing (Generator)
import Shrink exposing (Shrinker)
import Test exposing (Test)



-- Fuzzers


int =
  Fuzz.custom
    (Random.frequency
      [ ( 1, Random.int 0 (Random.maxInt - Random.minInt) )
      , ( 1, Random.int (Random.minInt - Random.maxInt) 0 )
      ]
    )
    Shrink.int


float =
  let
    generator =
      Random.frequency
        [ ( 1, Random.float 0 (toFloat <| Random.maxInt - Random.minInt) )
        , ( 1, Random.float (toFloat <| Random.minInt - Random.maxInt) 0 )
        ]
  in
  Fuzz.custom generator Shrink.float


string =
  let
    asciiGenerator : Generator String
    asciiGenerator =
      Random.int 100 1000
        |> Random.andThen (lengthString asciiCharGenerator)

    whitespaceGenerator : Generator String
    whitespaceGenerator =
      Random.int 100 1000
        |> Random.andThen (lengthString whitespaceCharGenerator)
  in
  Fuzz.custom
    (Random.frequency
      [ ( 9, asciiGenerator )
      , ( 1, whitespaceGenerator )
      ]
    )
    Shrink.string


char =
  Fuzz.custom asciiCharGenerator Shrink.character



-- Helpers


asciiCharGenerator : Generator Char
asciiCharGenerator =
  Random.map Char.fromCode (Random.int 32 0x0001F64F)


whitespaceCharGenerator : Generator Char
whitespaceCharGenerator =
  Random.sample [ ' ', '\t', '\n' ] |> Random.map (Maybe.withDefault ' ')


lengthString : Generator Char -> Int -> Generator String
lengthString charGenerator stringLength =
  Fuzz.list stringLength charGenerator
    |> Fuzz.map String.fromList
