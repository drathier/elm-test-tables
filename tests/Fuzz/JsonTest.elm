module Fuzz.JsonTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, float, int, list, string, tuple)
import Fuzz.Category exposing (..)
import Fuzz.Json exposing (roundtrip)
import Fuzz.Opaque exposing (a, appendable, b, comparable, comparable2, numberRange)
import Fuzz.Table exposing (..)
import Json.Decode
import Json.Encode
import Test exposing (..)
import Test.Table exposing (..)


roundtripTests =
  describe "json rountrip tests"
    [ roundtrip "int encode/decode" Fuzz.int Json.Encode.int Json.Decode.int
    , roundtrip "float encode/decode" Fuzz.float Json.Encode.float Json.Decode.float
    , roundtrip "string encode/decode" Fuzz.string Json.Encode.string Json.Decode.string
    , roundtrip "bool encode/decode" Fuzz.bool Json.Encode.bool Json.Decode.bool
    ]
