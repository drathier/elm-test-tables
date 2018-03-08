module Fuzz.Category exposing (..)

{-| Fuzz.Category provides fuzz tests for common functions, like `map`, `andMap` and `andThen`.
-}

import Expect
import Fuzz exposing (Fuzzer)
import Fuzz.Opaque exposing (a, number)
import Test exposing (Test, describe, fuzz)


functor name fmap afuzz =
  describe ("test " ++ name ++ ".map")
    [ fuzz (afuzz number) "make sure `map identity == identity`" <|
        \a -> a |> fmap identity |> toString |> Expect.equal (a |> identity |> toString)
    , fuzz (afuzz number) "make sure `map (f << g) == map f << map g`" <|
        let
          f a =
            a + 14

          g a =
            a + 12
        in
        \a -> a |> fmap (f << g) |> Expect.equal (a |> fmap f |> fmap g)
    ]
