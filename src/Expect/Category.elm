module Expect.Category exposing (..)

{-| Expect.Category provides expectations for common properties of binary functions, like (a+b)+c = a+(b+c) and (a+b) = (b+a):

    fuzz3 int int int "+" <|
        \a b c -> { f = (+), a = a, b = b, c = c } |> Expect.all [ associative, commutative ]

-}

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, tuple3)
import Fuzz.Opaque exposing (a, number)
import Test exposing (Test, describe, fuzz)


associative : { r | f : a -> a -> a, a : a, b : a, c : a } -> Expect.Expectation
associative { f, a, b, c } =
  f (f a b) c |> Expect.equal (f a (f b c)) |> withErrorMsg "f is not associative"


commutative : { r | f : a -> a -> a, a : a, b : a } -> Expect.Expectation
commutative { f, a, b } =
  f a b |> Expect.equal (f b a) |> withErrorMsg "f is not commutative"


idempotent : { r | f : a -> a -> a, a : a } -> Expect.Expectation
idempotent { f, a } =
  a |> Expect.equal (f a a) |> withErrorMsg "f is not idempotent"



-- TODO: take an ext record as arg, so we can use Expect.all with these


all : { r | b : a, c : a, a : a, f : a -> a -> a } -> Expectation
all =
  -- not expecting this to be useful, just want to make sure it all type checks
  Expect.all
    [ associative, commutative, idempotent ]



-- helpers


withErrorMsg msg expectation =
  if expectation == Expect.pass then
    expectation

  else
    Expect.fail msg
