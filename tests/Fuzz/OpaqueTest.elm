module Fuzz.OpaqueTest exposing (..)

import Expect
import Fuzz.Opaque exposing (..)
import Test exposing (describe, fuzz2, fuzz3)

a = 2
{-
appendables =
  describe "appendables"
    [ fuzz3 appendable appendable appendable "appendable" <|
        \a1 a2 a3 -> associative (++) ( a1, a2, a3 )
    , fuzz3 appendable2 appendable2 appendable2 "appendable2" <|
        \a1 a2 a3 -> associative (++) ( a1, a2, a3 )
    ]


comparables =
  describe "comparables"
    [ -- comparables
      fuzz2 comparable comparable "comparable" <|
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



   number
   number2

   numberRange
   numberRange2

   a
   b
   c
   d
   e
   f
   g
   h
   i
   j
   k
   l
   m
   n
   o
   p
   q
   r
   s
   t
   u
   v
   w
   x
   y
   z
-}
