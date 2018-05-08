module Fuzz.Json exposing (..)

{-| Fuzz.Json lets you test your json encoders and decoders.

@docs roundtrip
-}

import Expect
import Fuzz exposing (Fuzzer)
import Json.Decode
import Json.Encode
import Test exposing (Test)

{-| Roundtrip takes a fuzzer, a json encoder, a json decoder, and sees if an encode/decode cycle succeeds without losing any data. -}
roundtrip : String -> Fuzzer a -> (a -> Json.Encode.Value) -> Json.Decode.Decoder a -> Test
roundtrip name fuzz encode decode =
  Test.fuzz fuzz ("json roundtrip tests for " ++ name) <|
    \a -> a |> encode |> Json.Encode.encode 0 |> Json.Decode.decodeString decode |> Expect.equal (Ok a)
