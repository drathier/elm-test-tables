module Fuzz.Preprocess exposing (..)

{-| In order to preprocess inputs before they enter the fuzz function, it would be useful to have a function like this:

    preprocess : (a -> a) -> (a -> Expect.Expectation) -> a -> Expect.Expectation

Luckily, this exactly matches forward function composition:

    (>>) : (a -> b) -> (b -> c) -> a -> c

So use that instead, like this:

    fuzz int "expect input to be positive" <|
        abs >> \a -> a + 1 |> Expect.greaterThan 0

But if you want multiple inputs, it's a bit trickier. We have two easy options. Either, use tuples:

    fuzz (tuple (int, int)) "expect sum to be positive" <|
        (\( a, b ) -> ( abs a, abs b ))
            >> (\( a, b ) -> a + b |> Expect.greaterThan 0)

Or, use a let-binding:

    fuzz2 int int "expect sum to be positive" <|
        \a b ->
            let
                a =
                    abs a

                b =
                    abs b
            in
            a + b |> Expect.greaterThan 0

-}

import Expect


{-| -}
preprocess : (a -> a) -> (a -> Expect.Expectation) -> a -> Expect.Expectation
preprocess =
  (>>)

