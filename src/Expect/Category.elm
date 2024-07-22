module Expect.Category exposing (associative, commutative, idempotent, identityElement, zeroElement)

{-| Expect.Category provides expectations for common properties of binary functions, like `(a+b)+c = a+(b+c)` or `a+b = b+a`:

    fuzz3 int int int "+" <|
        \a b c ->
            { f = (+), a = a, b = b, c = c }
                |> Expect.all [ associative, commutative ]

These mathematical properties are actually quite useful, so try to follow a few of them for whatever data type you're building.


# How to use this module

The function signatures in this module are horrible. Sorry about that. Here's how I intend the functions to be used:

    fuzz3 int int int "+" <|
        \a b c ->
            { f = (+), a = a, b = b, c = c }
                |> Expect.all [ identityElement 0, associative, commutative ]

or

    fuzz3 appendable appendable appendable "++" <|
        \a b c ->
            { f = (++), a = a, b = b, c = c }
                |> Expect.all [ associative ]


# The properties to choose from

@docs associative, commutative, idempotent, identityElement, zeroElement

-}

import Expect exposing (Expectation)


{-| Associativity is the property that `(a ⊕ b) ⊕ c = a ⊕ (b ⊕ c)`, or `f (f a b) c = f a (f b c)`, for some infix operator `⊕`, or binary function `f`.

Notable examples include `+`, `*` and `max`, but note that float operations generally aren't associative.

-}
associative : { r | f : a -> a -> a, a : a, b : a, c : a } -> Expect.Expectation
associative { f, a, b, c } =
    f (f a b) c
        |> Expect.equal (f a (f b c))
        |> Expect.onFail "the given function is not associative; found a counter-example! (or the arguments are Float)"


{-| Commutativity is the property that `a ⊕ b = b ⊕ a`, or `f a b = f b a`, for some infix operator `⊕`, or binary function `f`.

Notable examples include `+`, `*` and `max`.

-}
commutative : { r | f : a -> a -> a, a : a, b : a } -> Expect.Expectation
commutative { f, a, b } =
    f a b
        |> Expect.equal (f b a)
        |> Expect.onFail "the given function is not commutative; found a counter-example! (or the arguments are Float)"


{-| Idempotence is the property that `a ⊕ a = a`, or `f a a = a`, for some infix operator `⊕`, or binary function `f`.

Notable examples include `Bitwise.or`, `Bitwise.and` and `max`.

-}
idempotent : { r | f : a -> a -> a, a : a } -> Expect.Expectation
idempotent { f, a } =
    a
        |> Expect.equal (f a a)
        |> Expect.onFail "the given function is not idempotent; found a counter-example! (or the arguments are Float)"


{-| The identity element is the element `e` such that `a ⊕ e = e ⊕ a = a`, or `f e a = f a e = a`, for some infix operator `⊕`, or binary function `f`.

Notable examples include `0` for `+`, `1` for `*` and `0` for `Bitwise.or`.

-}
identityElement : a -> { r | f : a -> a -> a, a : a } -> Expect.Expectation
identityElement identity { f, a } =
    ( f identity a, f a identity )
        |> Expect.equal ( a, a )
        |> Expect.onFail "the given element is not the identity element for the given function; found a counter-example! (or the arguments are Float)"


{-| The zero element is the element `0` such that `a ⊕ 0 = 0 ⊕ a = 0`, or `f 0 a = f a 0 = 0`, for some infix operator `⊕`, or binary function `f`.

Notable examples include `0` for `*`, `Infinity` for `max` and `0` for `Bitwise.and`.

-}
zeroElement : a -> { r | f : a -> a -> a, a : a } -> Expect.Expectation
zeroElement zero { f, a } =
    ( f zero a, f a zero )
        |> Expect.equal ( zero, zero )
        |> Expect.onFail "the given zero is not a zero element for the given function; found a counter-example! (or the arguments are Float)"



-- type check helpers; this should at least type check


all : { r | b : a, c : a, a : a, f : a -> a -> a } -> Expectation
all rec =
    -- not expecting this to be useful, just want to make sure it all type checks
    Expect.all
        [ associative, commutative, idempotent, identityElement rec.a, zeroElement rec.a ]
        rec
