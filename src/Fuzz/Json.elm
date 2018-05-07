module Fuzz.Json exposing (..)

import Expect
import Fuzz exposing (Fuzzer)
import Json.Decode
import Json.Encode
import Test exposing (Test)



{- Fuzz.Json lets you test your Json encoders / decoders. -}


roundtrip : String -> Fuzzer a -> (a -> Json.Encode.Value) -> Json.Decode.Decoder a -> Test
roundtrip name fuzz encode decode =
  Test.fuzz fuzz ("json roundtrip tests for " ++ name) <|
    \a -> a |> encode |> Json.Encode.encode 0 |> Json.Decode.decodeString decode |> Expect.equal (Ok a)
