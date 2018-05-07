module Expect.CategoryTest exposing (..)

import Expect
import Expect.Category exposing (..)
import Fuzz exposing (int, intRange)
import Fuzz.Opaque exposing (number, numberRange)
import Test exposing (describe, fuzz3)


test =
  describe "test some built-in things"
    [ fuzz3 int int int "+" <|
        \a b c -> { f = (+), a = a, b = b, c = c } |> Expect.all [ associative, commutative ]
    , fuzz3 (intRange -14 27) (intRange -14 27) (intRange -14 27) "*" <|
        -- limit numbers to avoid overflow
        \a b c -> { f = (*), a = a, b = b, c = c } |> Expect.all [ associative, commutative ]
    , fuzz3 number number number "max" <|
        \a b c -> { f = max, a = a, b = b, c = c } |> Expect.all [ associative, commutative, idempotent ]
    , fuzz3 number number number "min" <|
        \a b c -> { f = min, a = a, b = b, c = c } |> Expect.all [ associative, commutative, idempotent ]
    ]
