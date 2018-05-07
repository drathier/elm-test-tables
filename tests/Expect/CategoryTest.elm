module Expect.CategoryTest exposing (..)

import Bitwise
import Expect
import Expect.Category exposing (..)
import Fuzz exposing (float, floatRange, int, intRange, list, string)
import Fuzz.Opaque exposing (appendable, appendable2, number, numberRange)
import Test exposing (describe, fuzz3)


test =
  describe "test some built-in things"
    [ describe "+"
        [ fuzz3 int int int "+ int" <|
            \a b c -> { f = (+), a = a, b = b, c = c } |> Expect.all [ identityElement 0, associative, commutative ]
        , fuzz3 float float float "+ float" <|
            \a b c -> { f = (+), a = a, b = b, c = c } |> Expect.all [ identityElement 0, commutative ]
        ]
    , describe "++"
        [ fuzz3 appendable appendable appendable "++ appendable" <|
            \a b c -> { f = (++), a = a, b = b, c = c } |> Expect.all [ associative ]
        , fuzz3 appendable2 appendable2 appendable2 "++ appendable2" <|
            \a b c -> { f = (++), a = a, b = b, c = c } |> Expect.all [ associative ]
        , fuzz3 string string string "++ string" <|
            \a b c -> { f = (++), a = a, b = b, c = c } |> Expect.all [ identityElement "", associative ]
        , fuzz3 (list int) (list int) (list int) "++ list int" <|
            \a b c -> { f = (++), a = a, b = b, c = c } |> Expect.all [ identityElement [], associative ]
        ]
    , describe "*"
        [ fuzz3 (intRange -14 27) (intRange -14 27) (intRange -14 27) "* int" <|
            -- limit numbers to avoid multiplicative overflow
            \a b c -> { f = (*), a = a, b = b, c = c } |> Expect.all [ zeroElement 0, identityElement 1, associative, commutative ]
        , fuzz3 (floatRange -14 27) (floatRange -14 27) (floatRange -14 27) "* float" <|
            -- limit numbers to avoid multiplicative overflow
            \a b c -> { f = (*), a = a, b = b, c = c } |> Expect.all [ zeroElement 0, identityElement 1, commutative ]
        ]
    , describe "min/max"
        [ fuzz3 number number number "max" <|
            \a b c -> { f = max, a = a, b = b, c = c } |> Expect.all [ zeroElement (1 / 0), identityElement (-1 / 0), associative, commutative, idempotent ]
        , fuzz3 number number number "min" <|
            \a b c -> { f = min, a = a, b = b, c = c } |> Expect.all [ zeroElement (-1 / 0), identityElement (1 / 0), associative, commutative, idempotent ]
        ]
    ]


bitwiseTests =
  describe "Bitwise"
    [ fuzz3 int int int "Bitwise.and" <|
        \a b c ->
          { f = \a b -> Bitwise.and a b |> bound32
          , a = bound32 a
          , b = bound32 b
          , c = bound32 c
          }
            |> Expect.all [ zeroElement 0, identityElement 0xFFFFFFFF, associative, commutative, idempotent ]
    , fuzz3 int int int "Bitwise.or" <|
        \a b c ->
          { f = \a b -> Bitwise.or a b |> bound32
          , a = bound32 a
          , b = bound32 b
          , c = bound32 c
          }
            |> Expect.all [ zeroElement 0xFFFFFFFF, identityElement 0, associative, commutative, idempotent ]
    , fuzz3 int int int "Bitwise.xor" <|
        \a b c ->
          { f = \a b -> Bitwise.xor a b |> bound32
          , a = bound32 a
          , b = bound32 b
          , c = bound32 c
          }
            |> Expect.all [ identityElement 0, associative, commutative ]
    ]


bound32 =
  Bitwise.shiftRightZfBy 0
