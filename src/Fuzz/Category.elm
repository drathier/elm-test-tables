module Fuzz.Category exposing (..)

{-| Fuzz.Category provides fuzz tests for common functions, like `map`, `andMap` and `andThen`.
-}

import Expect
import Fuzz exposing (Fuzzer, tuple3)
import Fuzz.Opaque exposing (a, number)
import Test exposing (Test, describe, fuzz)



-- Semi-opaque types for use in functor tests. These types have to be comparable, appendable etc. so we cannot define our own unexported type, which would've made this completely opaque.


type alias Opaque a =
  ( String, a )


opaque a =
  ( "opaque-ish", a )


map name fmap afuzz =
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
