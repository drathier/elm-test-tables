module Example exposing (appendables, comparables, opaques, positive, suite, tableTests)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string, pair)
import Fuzz.Opaque exposing (a, appendable, b, comparable)
import Test exposing (..)
import Test.Table exposing (..)


suite =
    describe "failure tests"
        [ describe "test that should fail in an ideal world, but edge cases are (very) hard to find"
            [ fuzz3 int int int "inputs don't sum to 4711" <|
                \a b c -> a + b + c |> Expect.notEqual 4711
            , fuzz int "input is not equal to 4711" <|
                \a -> a |> Expect.notEqual 4711
            , fuzz3 int int int "Expect things to not be equal" <|
                \a b c -> [ a, b, c ] |> Expect.notEqual [ b, c, a ]
            , fuzz2 int string "Expect string to not be the string representation of an int" <|
                \a b -> a |> String.fromInt |> Expect.notEqual b
            ]

        -- don't run the failing tests in normal operation; wait for elm-test to expose an expectToFail function
        -- , describe "those same tests, but now with explicit edge-cases"
        --     [ fuzzTable3 int int int "inputs don't sum to 4711" [ ( 4000, 700, 11 ) ] <|
        --         \a b c -> a + b + c |> Expect.notEqual 4711
        --     , fuzzTable int "input is not equal to 11147 with edge cases" [ 1, 3, 7, 6, 4711, 11147 ] <|
        --         \a -> a |> Expect.notEqual 11147
        --     , fuzzTable3
        --         int
        --         int
        --         int
        --         "Expect things to not be equal"
        --         [ ( 0, 0, 0 )
        --         , ( 0, 1, 2 )
        --         , ( 0, 3, 4 )
        --         , ( 0, 7, 8 )
        --         , ( 0, 9, 12 )
        --         ]
        --         (\a b c -> [ a, b, c ] |> Expect.notEqual [ b, c, a ])
        --     , fuzzTable2 int string "Expect string to not be numbers" [ ( 42, "42" ) ] <|
        --         \a b -> a |> String.fromInt |> Expect.notEqual b
        --     ]
        ]


positive : Test
positive =
    describe "tests with positive numbers"
        [ fuzz int "expect input to be positive" <|
            abs
                >> Expect.greaterThan -1
        , fuzz (pair int int) "expect sum to be positive" <|
            (\( a, b ) -> ( abs a, abs b ))
                >> (\( a, b ) -> a + b |> Expect.greaterThan -1)
        , fuzz2 int int "expect sum to be positive using a let binding" <|
            \ai bi ->
                let
                    a =
                        abs ai

                    b =
                        abs bi
                in
                a + b |> Expect.greaterThan -1
        ]


tableTests =
    describe "table tests"
        [ testTable3 "table test pythagorean triples"
            [ ( 3, 4, 5 )
            , ( 5, 12, 13 )
            , ( 6, 8, 10 )
            , ( 7, 24, 25 )
            , ( 8, 15, 17 )
            , ( 9, 12, 15 )
            , ( 9, 40, 41 )
            , ( 10, 24, 26 )
            , ( 12, 16, 20 )
            , ( 12, 35, 37 )
            , ( 14, 48, 50 )
            , ( 15, 20, 25 )
            , ( 15, 36, 39 )
            , ( 16, 30, 34 )
            , ( 18, 24, 30 )
            , ( 20, 21, 29 )
            , ( 21, 28, 35 )
            , ( 24, 32, 40 )
            , ( 24, 45, 51 )
            , ( 27, 36, 45 )
            , ( 30, 40, 50 )
            ]
            (\a b c -> (a * a) + (b * b) |> Expect.equal (c * c))
        ]


comparables =
    describe "comparable fuzzers"
        [ fuzz (list comparable) "comparable" <|
            \l ->
                let
                    _ =
                        List.sort l
                in
                Expect.onFail "Dummy test; this should compile" <|
                  Expect.equal True True

        -- dummy test; this shouldn't compile, because all comparable have distinct types
        -- , fuzz2 comparable comparable2 "does not compile" <|
        --     \a b -> a |> Expect.notEqual b
        ]


opaques =
    describe "opaque fuzzers"
        [ fuzz2 a b "always always returns the first argument" <|
            \a b -> always a b |> Expect.equal a
        , fuzz (list a) "reversing a list twice results in the original list" <|
            \lst -> lst |> List.reverse |> List.reverse |> Expect.equal lst
        ]


appendables =
    describe "appendable fuzzers"
        [ fuzz3 appendable appendable appendable "append is associative" <|
            \a b c -> ((a ++ b) ++ c) |> Expect.equal (a ++ (b ++ c))
        ]
