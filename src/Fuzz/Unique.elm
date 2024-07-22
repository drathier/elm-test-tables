module Fuzz.Unique exposing (int, float, string, char)

{-| Fuzz.Unique contains fuzzers for built-in types, but with a very low probability of ever generating two equal values. Perfect if you're filling up a `Set comparable` from a `List comparable` and want that `Set` to be the same size as the `List`, or you just want each value to be unique.

@docs int, float, string, char

-}

import Char
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int)
import Random exposing (Generator)
import Random.Extra as Random
import Test exposing (Test)



-- Fuzzers


{-| -}
int : Fuzzer Int
int =
    Fuzz.fromGenerator
        (Random.frequency
            ( 1, Random.int 0 (Random.maxInt - Random.minInt) )
            [ ( 1, Random.int (Random.minInt - Random.maxInt) 0 )
            ]
        )



{-| -}
float : Fuzzer Float
float =
    let
        generator =
            Random.frequency
                ( 1, Random.float 0 (toFloat <| Random.maxInt - Random.minInt) )
                [ ( 1, Random.float (toFloat <| Random.minInt - Random.maxInt) 0 )
                ]
    in
    Fuzz.fromGenerator generator


{-| -}
string : Fuzzer String
string =
    let
        asciiGenerator : Generator String
        asciiGenerator =
            Random.int 100 1000
                |> Random.andThen (lengthString charGenerator)
    in
    Fuzz.fromGenerator asciiGenerator


{-| Note: there are only ~113k possible unicode characters, so the probability of at least one duplicate `Char` in a `list char` is actually pretty high.
-}
char : Fuzzer Char
char =
    Fuzz.fromGenerator charGenerator



-- Helpers


charGenerator : Generator Char
charGenerator =
    (Random.int 32 0x0010FFFF
        |> Random.map
            (\v ->
                if 0x00011000 <= v && v <= 0x0001FFFF then
                    -- skip invalid unicode code points; these are reserved for utf-18
                    v - (0x0001FFFF - 0x00011000)

                else
                    v
            )
    )
        |> Random.map Char.fromCode


whitespaceCharGenerator : Generator Char
whitespaceCharGenerator =
    Random.sample [ ' ', '\t', '\n' ] |> Random.map (Maybe.withDefault ' ')


lengthString : Generator Char -> Int -> Generator String
lengthString charGen stringLength =
    Random.list stringLength charGen
        |> Random.map String.fromList
