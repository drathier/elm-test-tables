module Expect.Category exposing (associative, commutative, idempotent, identityElement, zeroElement)

{-| Expect.Category provides expectations for common properties of binary functions, like `(a+b)+c = a+(b+c)` or `a+b = b+a`:

    fuzz3 int int int "+" <|
        \a b c -> { f = (+), a = a, b = b, c = c }
            |> Expect.all [ associative, commutative ]

These mathematical properties are actually quite useful, so try to follow a few of them for whatever data type you're building.


# How to use this module

The function signatures in this module are horrible. Sorry about that. Here's how I intend the functions to be used:

    fuzz3 int int int "+" <|
        \a b c -> { f = (+), a = a, b = b, c = c }
            |> Expect.all [ identityElement 0, associative, commutative ]

or

    fuzz3 appendable appendable appendable "++" <|
        \a b c -> { f = (++), a = a, b = b, c = c }
            |> Expect.all [ associative ]

or

    fuzz3 number number number "max" <|
        \a b c -> { f = max, a = a, b = b, c = c }
            |> Expect.all [ zeroElement (1 / 0), identityElement (-1 / 0), associative, commutative, idempotent ]


# The properties to choose from

@docs associative, commutative, idempotent, identityElement, zeroElement

-}

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, tuple3)
import Fuzz.Opaque exposing (a, number)
import Test exposing (Test, describe, fuzz)


{-| Associativity is the property that `(a ⊕ b) ⊕ c = a ⊕ (b ⊕ c)`, or `f (f a b) c = f a (f b c)`, for some infix operator `⊕`, or binary function `f`.

Notable examples include `+`, `*` and `max`, but note that float operations generally aren't associative.
-}
associative : { r | f : a -> a -> a, a : a, b : a, c : a } -> Expect.Expectation
associative { f, a, b, c } =
  f (f a b) c |> Expect.equal (f a (f b c)) |> withErrorMsg "f is not associative"


{-| Commutativity is the property that `a ⊕ b = b ⊕ a`, or `f a b = f b a`, for some infix operator `⊕`, or binary function `f`.

Notable examples include `+`, `*` and `max`.
-}
commutative : { r | f : a -> a -> a, a : a, b : a } -> Expect.Expectation
commutative { f, a, b } =
  f a b |> Expect.equal (f b a) |> withErrorMsg "f is not commutative"


{-| Idempotence is the property that `a ⊕ a = a`, or `f a a = a`, for some infix operator `⊕`, or binary function `f`.

Notable examples include `Bitwise.or`, `Bitwise.and` and `max`.
-}
idempotent : { r | f : a -> a -> a, a : a } -> Expect.Expectation
idempotent { f, a } =
  a |> Expect.equal (f a a) |> withErrorMsg "f is not idempotent"


{-| The identity element is the element `e` such that `a ⊕ e = e ⊕ a = a`, or `f e a = f a e = a`, for some infix operator `⊕`, or binary function `f`.

Notable examples include `0` for `+`, `1` for `*` and `0` for `Bitwise.or`.
-}
identityElement : a -> { r | f : a -> a -> a, a : a } -> Expect.Expectation
identityElement identity { f, a } =
  ( f identity a, f a identity )
    |> Expect.equal ( a, a )
    |> withErrorMsg ("`" ++ toString identity ++ "` is not an identity element for f when paired with `" ++ toString a ++ "` (" ++ toString (f identity a) ++ ", " ++ toString (f a identity) ++ ")")


{-| The zero element is the element `0` such that `a ⊕ 0 = 0 ⊕ a = 0`, or `f 0 a = f a 0 = 0`, for some infix operator `⊕`, or binary function `f`.

Notable examples include `0` for `*`, `Infinity` for `max` and `0` for `Bitwise.and`.
-}
zeroElement : a -> { r | f : a -> a -> a, a : a } -> Expect.Expectation
zeroElement zero { f, a } =
  ( f zero a, f a zero )
    |> Expect.equal ( zero, zero )
    |> withErrorMsg ("`" ++ toString zero ++ "` is not a zero element for f when paired with `" ++ toString a ++ "` (" ++ toString (f zero a) ++ ", " ++ toString (f a zero) ++ ")")



-- type check helpers; this should at least type check


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
