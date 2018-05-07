module Fuzz.Category exposing (..)

{-| Fuzz.Category provides fuzz tests for common functions, like `map`, `andMap` and `andThen`.
-}

import Expect
import Fuzz exposing (Fuzzer)
import Fuzz.Opaque exposing (a, number)
import Fuzz.Roundtrip
import Test exposing (Test, describe, fuzz)



-- Semi-opaque types for use in functor tests. These types have to be comparable, appendable etc. so we cannot define our own unexported type, which would've made this completely opaque.


type alias Opaque a =
  ( String, a )


opaque a =
  ( "opaque-ish", a )


functor name fmap afuzz =
  describe ("test " ++ name ++ ".map")
    [ fuzz (afuzz (number |> Fuzz.map opaque)) "make sure `map identity == identity`" <|
        \a -> a |> fmap identity |> toString |> Expect.equal (a |> identity |> toString)
    , fuzz (afuzz (number |> Fuzz.map opaque)) "make sure `map (f << g) == map f << map g`" <|
        let
          f ( _, a ) =
            opaque (a + 14)

          g ( _, a ) =
            opaque (a + 12)
        in
        \a -> a |> fmap (f << g) |> Expect.equal (a |> fmap f |> fmap g)
    ]


{-| If we can translate values between two types without losing information, it's an isomorphism.

(`+3`, `-3`) is one example. (`Json.Encode.int`, `Json.Decode.int`) is another one, but (`toFloat`, `truncate`) isn't, because `truncate 2.0` and `truncate 2.1` both result in the same `Int`. (`exp n`, `logBase n`) is an isomorphism in mathematics, but not in Elm, because of floating point rounding errors.

-}
isomorphism : String -> Fuzzer a -> Fuzzer b -> (a -> b) -> (b -> a) -> Test
isomorphism name fa fb ab ba =
  describe ("isomorphism test for " ++ name)
    [ Fuzz.Roundtrip.roundtrip ("isomorphism " ++ name ++ " (1/2)") fa ab ba
    , Fuzz.Roundtrip.roundtrip ("isomorphism " ++ name ++ " (2/2)") fb ba ab
    ]
