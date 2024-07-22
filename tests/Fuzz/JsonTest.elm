module Fuzz.JsonTest exposing (roundtripTests)

import Fuzz exposing (Fuzzer)
import Fuzz.Json exposing (roundtrip)
import Json.Decode
import Json.Encode
import Test exposing (..)


roundtripTests =
    describe "json roundtrip tests"
        [ roundtrip "int encode/decode" Fuzz.int Json.Encode.int Json.Decode.int
        , roundtrip "float encode/decode" Fuzz.niceFloat Json.Encode.float Json.Decode.float
        , roundtrip "string encode/decode" Fuzz.string Json.Encode.string Json.Decode.string
        , roundtrip "bool encode/decode" Fuzz.bool Json.Encode.bool Json.Decode.bool
        ]
