module Fuzz.Table exposing (fuzzTable, fuzzTable2, fuzzTable3)

{-| Fuzz.Table allows you to run fuzzers with known edge-cases. It'll run a fuzzer just like normal, but in addition, you can give it a list of inputs to try first.

Next time you have a test that only fails once in a blue moon, like this one:

    fuzz int "input is not equal to 11147" <|
        \a -> a |> Expect.notEqual 11147

you can replace it with a `fuzzTable` and add that edge case, so that elm-test will try that edge case on each test run from now on:

    fuzzTable int "input is not equal to 11147" [ 11147 ] <|
        \a -> a |> Expect.notEqual 11147

Then that particular bug will never make it through your tests again!

# FuzzTable

@docs fuzzTable, fuzzTable2, fuzzTable3

-}

import Expect exposing (Expectation)
import Formatting
import Fuzz exposing (Fuzzer, int)
import Test exposing (Test)



-- Fuzzers


{-| Run a fuzzer just like normal, but first run a supplied list of edge cases.
-}
fuzzTable :
    Fuzzer a
    -> String
    -> List a
    -> (a -> Expectation)
    -> Test
fuzzTable fuzzer description edgeCases getExpectation =
    Test.describe description <|
        Test.fuzz fuzzer "fuzz" getExpectation
            :: List.indexedMap
                (\index input ->
                    Test.test
                        (edgeDesc index)
                        (\() -> getExpectation input)
                )
                edgeCases


{-| Run a 2-fuzzer just like normal, but first run a supplied list of edge cases.
-}
fuzzTable2 :
    Fuzzer a
    -> Fuzzer b
    -> String
    -> List ( a, b )
    -> (a -> b -> Expectation)
    -> Test
fuzzTable2 afuzz bfuzz description edgeCases getExpectation =
    Test.describe description <|
        Test.fuzz2 afuzz bfuzz "fuzz" getExpectation
            :: List.indexedMap
                (\index ( a, b ) ->
                    Test.test
                        (edgeDesc index)
                        (\() -> getExpectation a b)
                )
                edgeCases


{-| Run a 3-fuzzer just like normal, but first run a supplied list of edge cases.
-}
fuzzTable3 :
    Fuzzer a
    -> Fuzzer b
    -> Fuzzer c
    -> String
    -> List ( a, b, c )
    -> (a -> b -> c -> Expectation)
    -> Test
fuzzTable3 afuzz bfuzz cfuzz description edgeCases getExpectation =
    Test.describe description <|
        Test.fuzz3 afuzz bfuzz cfuzz "fuzz" getExpectation
            :: List.indexedMap
                (\index ( a, b, c ) ->
                    Test.test
                        (edgeDesc index)
                        (\() -> getExpectation a b c)
                )
                edgeCases



-- helpers


edgeDesc index =
    String.fromInt (index + 1) ++ Formatting.ordinalIndicator (index + 1) ++ " edge case"
