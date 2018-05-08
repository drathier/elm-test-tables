module Fuzz.OpaqueTest exposing (..)

import Expect
import Expect.Category exposing (associative, identityElement)
import Fuzz.Opaque exposing (..)
import Test exposing (describe, fuzz, fuzz2, fuzz3)



-- These tests are just for type checking


appendables =
  describe "appendables"
    [ fuzz3 appendable appendable appendable "++ appendable" <|
        \a b c -> a ++ b |> always Expect.pass
    , fuzz3 appendable2 appendable2 appendable2 "++ appendable2" <|
        \a b c -> a ++ b |> always Expect.pass
    ]


comparables =
  describe "comparables"
    [ fuzz2 comparable comparable "comparable" <|
        \a b -> a < b |> always Expect.pass
    , fuzz2 comparable2 comparable2 "comparable2" <|
        \a b -> a < b |> always Expect.pass
    , fuzz2 comparable3 comparable3 "comparable3" <|
        \a b -> a < b |> always Expect.pass
    , fuzz2 comparable4 comparable4 "comparable4" <|
        \a b -> a < b |> always Expect.pass
    , fuzz2 comparable5 comparable5 "comparable5" <|
        \a b -> a < b |> always Expect.pass
    ]


numbers =
  describe "numbers"
    [ fuzz2 number number "number" <|
        \a b -> a + b |> always Expect.pass
    , fuzz2 number2 number2 "number2" <|
        \a b -> a + b |> always Expect.pass
    ]


numberRanges =
  describe "numberRanges"
    [ fuzz2 number number "numberRange" <|
        \a b -> a + b |> always Expect.pass
    , fuzz2 number2 number2 "numberRange2" <|
        \a b -> a + b |> always Expect.pass
    ]


opaques =
  describe "opaques"
    [ fuzz a "a" <| \a -> a |> Expect.equal a
    , fuzz b "b" <| \a -> a |> Expect.equal a
    , fuzz c "c" <| \a -> a |> Expect.equal a
    , fuzz d "d" <| \a -> a |> Expect.equal a
    , fuzz Fuzz.Opaque.e "e" <| \a -> a |> Expect.equal a
    , fuzz f "f" <| \a -> a |> Expect.equal a
    , fuzz g "g" <| \a -> a |> Expect.equal a
    , fuzz h "h" <| \a -> a |> Expect.equal a
    , fuzz i "i" <| \a -> a |> Expect.equal a
    , fuzz j "j" <| \a -> a |> Expect.equal a
    , fuzz k "k" <| \a -> a |> Expect.equal a
    , fuzz l "l" <| \a -> a |> Expect.equal a
    , fuzz m "m" <| \a -> a |> Expect.equal a
    , fuzz n "n" <| \a -> a |> Expect.equal a
    , fuzz o "o" <| \a -> a |> Expect.equal a
    , fuzz p "p" <| \a -> a |> Expect.equal a
    , fuzz q "q" <| \a -> a |> Expect.equal a
    , fuzz r "r" <| \a -> a |> Expect.equal a
    , fuzz s "s" <| \a -> a |> Expect.equal a
    , fuzz t "t" <| \a -> a |> Expect.equal a
    , fuzz u "u" <| \a -> a |> Expect.equal a
    , fuzz v "v" <| \a -> a |> Expect.equal a
    , fuzz w "w" <| \a -> a |> Expect.equal a
    , fuzz x "x" <| \a -> a |> Expect.equal a
    , fuzz y "y" <| \a -> a |> Expect.equal a
    , fuzz z "z" <| \a -> a |> Expect.equal a
    ]

