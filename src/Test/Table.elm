module Test.Table exposing (testTable, testTable2, testTable3)

{-| `Test.Table` provides tools for writing table-driven tests. Only use `Test.Table` if you have a bunch of similar test cases that can all be reasonably described as a group. If you can, use `Fuzz.Table` instead.

    testTable3 "pythagorean triples"
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

#TestTable

@docs testTable, testTable2, testTable3

-}

import Expect exposing (Expectation)
import Formatting
import Fuzz exposing (Fuzzer, int)
import Test exposing (Test)



-- Table tests


{-| Test a list of inputs. Please use `Fuzz.Table.fuzzTable` instead if you can.
-}
testTable :
    String
    -> List a
    -> (a -> Expectation)
    -> Test
testTable description edgeCases getExpectation =
    Test.describe description <|
        List.indexedMap
            (\index input ->
                Test.test
                    (tableRowDesc index)
                    (\() -> getExpectation input)
            )
            edgeCases


{-| Test a list of inputs. Please use `Fuzz.Table.fuzzTable2` instead if you can.
-}
testTable2 :
    String
    -> List ( a, b )
    -> (a -> b -> Expectation)
    -> Test
testTable2 description edgeCases getExpectation =
    Test.describe description <|
        List.indexedMap
            (\index ( a, b ) ->
                Test.test
                    (tableRowDesc index)
                    (\() -> getExpectation a b)
            )
            edgeCases


{-| Test a list of inputs. Please use `Fuzz.Table.fuzzTable3` instead if you can.
-}
testTable3 :
    String
    -> List ( a, b, c )
    -> (a -> b -> c -> Expectation)
    -> Test
testTable3 description edgeCases getExpectation =
    Test.describe description <|
        List.indexedMap
            (\index ( a, b, c ) ->
                Test.test
                    (tableRowDesc index)
                    (\() -> getExpectation a b c)
            )
            edgeCases



-- helpers


tableRowDesc index =
    String.fromInt (index + 1) ++ Formatting.ordinalIndicator (index + 1) ++ " table test row"
