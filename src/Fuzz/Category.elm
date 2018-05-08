module Fuzz.Category exposing (andThenv1, andThenv2, andThenv3, mapv1, mapv2, mapv3)

{-| Fuzz.Category provides fuzz tests for common functions, like `map` and `andThen`.

@docs map

-}

import Expect
import Fuzz exposing (Fuzzer, char, list, string, tuple3)
import Fuzz.Opaque exposing (a, appendable, number)
import Test exposing (Test, describe, fuzz, fuzz2)



-- Semi-opaque types for use in functor tests. These types have to be comparable, appendable etc. so we cannot define our own unexported type, which would've made this completely opaque.


{-| A common function for data structures in elm is called `map`. It generally holds the form `(a -> b) -> T a -> T b` for some type `T`, such as `List` or `Set`. In mathematics, this is called a functor, and since it is a very common pattern in Elm, your code should follow this convention.
-}
mapv1 : ((number -> number) -> la -> la) -> (Fuzzer Float -> Fuzzer la) -> Test
mapv1 fmap afuzz =
  describe "test .map v1"
    [ fuzz (afuzz number) "make sure `map identity == identity`" <|
        \a -> a |> fmap identity |> toString |> Expect.equal (a |> identity |> toString)
    , fuzz (afuzz number) "make sure `map (f << g) == map f << map g`" <|
        let
          f a =
            a * 5

          g a =
            a + 2
        in
        \a -> a |> fmap (f << g) |> Expect.equal (a |> (fmap f << fmap g))
    ]


{-| Another version of the `map` test helper, with a new set of types.
-}
mapv2 : ((String -> String) -> la -> la) -> (Fuzzer String -> Fuzzer la) -> Test
mapv2 fmap afuzz =
  describe "test .map v2"
    [ fuzz (afuzz appendable) "make sure `map identity == identity`" <|
        \a -> a |> fmap identity |> toString |> Expect.equal (a |> identity |> toString)
    , fuzz (afuzz appendable) "make sure `map (f << g) == map f << map g`" <|
        let
          f a =
            a ++ "f"

          g a =
            a ++ "g"
        in
        \a -> a |> fmap (f << g) |> Expect.equal (a |> (fmap f << fmap g))
    ]


{-| A third version of the `map` test helper, with a third set of types.
-}
mapv3 : ((List Char -> List Char) -> la -> la) -> (Fuzzer (List Char) -> Fuzzer la) -> Test
mapv3 fmap afuzz =
  describe "test .map v3"
    [ fuzz (afuzz (list char)) "make sure `map identity == identity`" <|
        \a -> a |> fmap identity |> toString |> Expect.equal (a |> identity |> toString)
    , fuzz (afuzz (list char)) "make sure `map (f << g) == map f << map g`" <|
        let
          f a =
            a ++ [ 'x' ]

          g a =
            a ++ [ 'y' ]
        in
        \a -> a |> fmap (f << g) |> Expect.equal (a |> (fmap f << fmap g))
    ]



-- Monad laws in Haskell:
-- Left identity: return a >>= f ≡ f a
-- Right identity:	m >>= return ≡ m
-- Associativity: (m >>= f) >>= g ≡	m >>= (\x -> f x >>= g)
-- TODO: `andMap` and `andThen`
-- andThen
-- TODO: do we have a more Elm-like name for the `m` monad below?


{-| Monad laws in Elm:
Left identity: singleton a |> andThen f ≡ f a
Right identity: m |> andThen singleton ≡ m
Associativity: (m |> andThen f) |> andThen g ≡ m |> andThen (\x -> f x |> andThen g)
where m is anything with the same type as `singleton a`, and `f` and `g` are `(a -> a)` functions.
-}
andThenv1 : (number -> fa) -> ((number -> fa) -> fa -> fa) -> (Fuzzer Float -> Fuzzer fa) -> Test
andThenv1 singleton andThen afuzz =
  let
    f a =
      singleton (a + 7)

    g a =
      singleton (a * 3)

    thing =
      number

    m =
      afuzz thing
  in
  describe "andThenv1"
    [ fuzz thing "left identity" <|
        \a -> singleton a |> andThen f |> Expect.equal (f a)
    , fuzz2 thing m "right identity" <|
        \a m -> m |> andThen singleton |> Expect.equal m
    , fuzz2 thing m "associativity" <|
        \a m -> (m |> andThen f) |> andThen g |> Expect.equal (m |> andThen (\x -> f x |> andThen g))
    ]


andThenv2 : (String -> fa) -> ((String -> fa) -> fa -> fa) -> (Fuzzer String -> Fuzzer fa) -> Test
andThenv2 singleton andThen afuzz =
  let
    f a =
      singleton (a ++ "f")

    g a =
      singleton (a ++ "g")

    thing =
      string

    m =
      afuzz thing
  in
  describe "andThenv2"
    [ fuzz thing "left identity" <|
        \a -> singleton a |> andThen f |> Expect.equal (f a)
    , fuzz2 thing m "right identity" <|
        \a m -> m |> andThen singleton |> Expect.equal m
    , fuzz2 thing m "associativity" <|
        \a m -> (m |> andThen f) |> andThen g |> Expect.equal (m |> andThen (\x -> f x |> andThen g))
    ]


andThenv3 : (List Char -> fa) -> ((List Char -> fa) -> fa -> fa) -> (Fuzzer (List Char) -> Fuzzer fa) -> Test
andThenv3 singleton andThen afuzz =
  let
    f a =
      singleton (a ++ [ 'f' ])

    g a =
      singleton (a ++ [ 'g' ])

    thing =
      list char

    m =
      afuzz thing
  in
  describe "andThenv3"
    [ fuzz thing "left identity" <|
        \a -> singleton a |> andThen f |> Expect.equal (f a)
    , fuzz2 thing m "right identity" <|
        \a m -> m |> andThen singleton |> Expect.equal m
    , fuzz2 thing m "associativity" <|
        \a m -> (m |> andThen f) |> andThen g |> Expect.equal (m |> andThen (\x -> f x |> andThen g))
    ]
