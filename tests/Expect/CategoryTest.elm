module Expect.CategoryTest exposing (bitwiseTests, bound32, intMax, intMin, test)

import Bitwise
import Expect
import Expect.Category exposing (..)
import Fuzz exposing (float, floatRange, int, intRange, list, string)
import Fuzz.Opaque exposing (appendable, appendable2)
import Test exposing (describe, fuzz3)


test =
    describe "test some built-in things"
        [ describe "+"
            [ fuzz3 int int int "+ int" <|
                \a b c -> { f = (+), a = a, b = b, c = c } |> Expect.all [ identityElement 0, associative, commutative ]
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
            ]
        , describe "min/max"
            [ fuzz3 int int int "max" <|
                \a b c ->
                    { f = max, a = a, b = b, c = c }
                        |> Expect.all [ zeroElement intMax, identityElement intMin, associative, commutative, idempotent ]
            , fuzz3 int int int "min" <|
                \a b c -> { f = min, a = a, b = b, c = c } |> Expect.all [ zeroElement intMin, identityElement intMax, associative, commutative, idempotent ]
            ]
        ]


intMin =
    -(2 ^ 32)


intMax =
    2 ^ 32 - 1


bitwiseTests =
    describe "Bitwise"
        [ fuzz3 int int int "Bitwise.and" <|
            \a b c ->
                { f = \x y -> Bitwise.and x y |> bound32
                , a = bound32 a
                , b = bound32 b
                , c = bound32 c
                }
                    |> Expect.all [ zeroElement 0, identityElement 0xFFFFFFFF, associative, commutative, idempotent ]
        , fuzz3 int int int "Bitwise.or" <|
            \a b c ->
                { f = \x y -> Bitwise.or x y |> bound32
                , a = bound32 a
                , b = bound32 b
                , c = bound32 c
                }
                    |> Expect.all [ zeroElement 0xFFFFFFFF, identityElement 0, associative, commutative, idempotent ]
        , fuzz3 int int int "Bitwise.xor" <|
            \a b c ->
                { f = \x y -> Bitwise.xor x y |> bound32
                , a = bound32 a
                , b = bound32 b
                , c = bound32 c
                }
                    |> Expect.all [ identityElement 0, associative, commutative ]
        ]


bound32 =
    Bitwise.shiftRightZfBy 0
