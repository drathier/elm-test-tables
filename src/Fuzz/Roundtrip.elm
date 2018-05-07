module Fuzz.Roundtrip exposing (..)

{-| Fuzz.Roundtrip provides a fuzz helper for roundtrip tests, such as encoding and decoding Json.
-}

import Expect
import Fuzz exposing (Fuzzer)
import Fuzz.Opaque exposing (a, number)
import Test exposing (Test, describe, fuzz)


roundtrip : String -> Fuzzer a -> (a -> b) -> (b -> a) -> Test
roundtrip name afuzz there back =
  fuzz afuzz ("roundtrip tests for " ++ name) <|
    \a -> a |> there |> back |> Expect.equal a
