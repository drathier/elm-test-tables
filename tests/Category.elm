module Category exposing (..)

import Array
import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, float, int, list, string, tuple)
import Fuzz.Category
import Fuzz.Opaque exposing (a, appendable, b, comparable, comparable2)
import Fuzz.Roundtrip
import Fuzz.Table exposing (..)
import Set
import Test exposing (..)
import Test.Table exposing (..)


functors =
  describe "Functor laws"
    [ Fuzz.Category.functor "List" List.map Fuzz.list
    , Fuzz.Category.functor "Array" Array.map Fuzz.array
    , Fuzz.Category.functor "Maybe" Maybe.map Fuzz.maybe
    , Fuzz.Category.functor "Result" Result.map (Fuzz.result (Fuzz.constant <| Err "no"))
    , Fuzz.Category.functor "Set" Set.map (Fuzz.list >> Fuzz.map Set.fromList)
    ]


{-| If we can translate values between two types without losing information, it's an isomorphism.

(`+3`, `-3`) is one example. (`Json.Encode.int`, `Json.Decode.int`) is another one, but (`toFloat`, `truncate`) isn't, because `truncate 2.0` and `truncate 2.1` both result in the same `Int`.

-}
isomorphism : String -> Fuzzer a -> Fuzzer b -> (a -> b) -> (b -> a) -> Test
isomorphism name fa fb ab ba =
  describe ("isomorphism test for" ++ name)
    [ Fuzz.Roundtrip.roundtrip name fa ab ba
    , Fuzz.Roundtrip.roundtrip name fb ba ab
    ]
