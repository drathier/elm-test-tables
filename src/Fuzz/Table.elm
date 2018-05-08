module Fuzz.Table exposing (fuzzTable, fuzzTable2, fuzzTable3, fuzzTable4, fuzzTable5)

{-| Fuzz.Table allows you to run fuzzers with known edge-cases. It'll run a fuzzer just like normal, but in addition, you can give it a list of inputs to try first.

If you ever find a bug with a fuzz test, add the input to the list to make sure you never get a regression for that bug!

@docs fuzzTable, fuzzTable2, fuzzTable3, fuzzTable4, fuzzTable5

-}

import Expect exposing (Expectation)
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
              (edgeDesc index input)
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
              (edgeDesc index ( a, b ))
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
              (edgeDesc index ( a, b, c ))
              (\() -> getExpectation a b c)
          )
          edgeCases


{-| Run a 4-fuzzer just like normal, but first run a supplied list of edge cases.
-}
fuzzTable4 :
  Fuzzer a
  -> Fuzzer b
  -> Fuzzer c
  -> Fuzzer d
  -> String
  -> List ( a, b, c, d )
  -> (a -> b -> c -> d -> Expectation)
  -> Test
fuzzTable4 afuzz bfuzz cfuzz dfuzz description edgeCases getExpectation =
  Test.describe description <|
    Test.fuzz4 afuzz bfuzz cfuzz dfuzz "fuzz" getExpectation
      :: List.indexedMap
          (\index ( a, b, c, d ) ->
            Test.test
              (edgeDesc index ( a, b, c, d ))
              (\() -> getExpectation a b c d)
          )
          edgeCases


{-| Run a 5-fuzzer just like normal, but first run a supplied list of edge cases.
-}
fuzzTable5 :
  Fuzzer a
  -> Fuzzer b
  -> Fuzzer c
  -> Fuzzer d
  -> Fuzzer e
  -> String
  -> List ( a, b, c, d, e )
  -> (a -> b -> c -> d -> e -> Expectation)
  -> Test
fuzzTable5 afuzz bfuzz cfuzz dfuzz efuzz description edgeCases getExpectation =
  Test.describe description <|
    Test.fuzz5 afuzz bfuzz cfuzz dfuzz efuzz "fuzz" getExpectation
      :: List.indexedMap
          (\index ( a, b, c, d, e ) ->
            Test.test
              (edgeDesc index ( a, b, c, d, e ))
              (\() -> getExpectation a b c d e)
          )
          edgeCases



-- helpers


edgeDesc index args =
  let
    tupleString =
      toString args
  in
  if String.length tupleString < 200 then
    "edge case #" ++ toString (index + 1) ++ ": " ++ tupleString

  else
    "edge case #" ++ toString (index + 1)
