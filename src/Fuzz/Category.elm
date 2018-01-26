module Fuzz.Category exposing (..)

{-| Fuzz.Category provides fuzz tests for common functions, like `map`, `andMap` and `andThen`.
-}

import Expect
import Fuzz exposing (Fuzzer)
import Fuzz.Opaque exposing (a)
import Test exposing (Test, describe, fuzz)



-- Exported test suites
-- map :
--   ((a -> b) -> container -> container)
--   -> (a -> container)
--   -> String
--   -> Test


map afuzz fmap return name =
  describe ("test " ++ name ++ ".map")
    [ fuzz afuzz "make sure `map identity == identity`" <|
        \a -> return a |> fmap identity |> Expect.equal (return a |> identity)

    -- , fuzz a "make sure `map (f << g) == map f << map g`" <|
    --     \a -> a |> map (f << g) |> Expect.equal (a |> map f |> map g)
    ]



-- Helpers


type A a
  = A a


type B b
  = B b


f a =
  A a


g a =
  B a
