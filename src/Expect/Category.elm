module Expect.Category exposing (..)

{-| Expect.Category provides expectations for common properties of binary functions, like (a+b)+c = a+(b+c) and (a+b) = (b+a):

    fuzz3 int int int "+" <|
        \a b c -> { f = (+), a = a, b = b, c = c } |> Expect.all [ associative, commutative ]

-}

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, tuple3)
import Fuzz.Opaque exposing (a, number)
import Test exposing (Test, describe, fuzz)


{-| Associativity is the property that `f (f a b) c = f a (f b c)` or `(a + b) + c = a + (b + c)`.
Notable examples include `+`, `*` and `max`, but note that float operations generally aren't associative.
-}
associative : { r | f : a -> a -> a, a : a, b : a, c : a } -> Expect.Expectation
associative { f, a, b, c } =
  f (f a b) c |> Expect.equal (f a (f b c)) |> withErrorMsg "f is not associative"


{-| Commutativity is the property that `f a b = f b a` or `a + b = b + a`.
Notable examples include `+`, `*` and `max`.
-}
commutative : { r | f : a -> a -> a, a : a, b : a } -> Expect.Expectation
commutative { f, a, b } =
  f a b |> Expect.equal (f b a) |> withErrorMsg "f is not commutative"


{-| Idempotence is the property that `f a a = a` or `a + a = a`.
Notable examples include `Bitwise.or`, `Bitwise.and` and `max`.
-}
idempotent : { r | f : a -> a -> a, a : a } -> Expect.Expectation
idempotent { f, a } =
  a |> Expect.equal (f a a) |> withErrorMsg "f is not idempotent"


{-| The identity element is the element e such that `f e a = f a e = a` or `a + e = e + a = a`.
Notable examples include `0` for `+`, `1` for `*` and `0` for `Bitwise.or`.
-}
identityElement : a -> { r | f : a -> a -> a, a : a } -> Expect.Expectation
identityElement identity { f, a } =
  ( f identity a, f a identity )
    |> Expect.equal ( a, a )
    |> withErrorMsg ("`" ++ toString identity ++ "` is not an identity element for f when paired with `" ++ toString a ++ "` (" ++ toString (f identity a) ++ ", " ++ toString (f a identity) ++ ")")


{-| The zero element is the element 0 such that `f 0 a = f a 0 = 0` or `a * 0 = 0 * a = 0`.
Notable examples include `0` for `*`, `Infinity` for `max` and `0` for `Bitwise.and`.
-}
zeroElement : a -> { r | f : a -> a -> a, a : a } -> Expect.Expectation
zeroElement zero { f, a } =
  ( f zero a, f a zero )
    |> Expect.equal ( zero, zero )
    |> withErrorMsg ("`" ++ toString zero ++ "` is not a zero element for f when paired with `" ++ toString a ++ "` (" ++ toString (f zero a) ++ ", " ++ toString (f a zero) ++ ")")



-- TODO: take an ext record as arg, so we can use Expect.all with these


all : { r | b : a, c : a, a : a, f : a -> a -> a } -> Expectation
all rec =
  -- not expecting this to be useful, just want to make sure it all type checks
  Expect.all
    [ associative, commutative, idempotent, identityElement rec.a, zeroElement rec.a ]
    rec



-- helpers


withErrorMsg msg expectation =
  if expectation == Expect.pass then
    expectation

  else
    Expect.fail msg
