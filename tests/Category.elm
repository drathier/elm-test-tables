module Category exposing (..)

import Array
import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, float, int, list, string, tuple)
import Fuzz.Category exposing (..)
import Fuzz.Opaque exposing (a, appendable, b, comparable, comparable2, numberRange)
import Fuzz.Roundtrip
import Fuzz.Table exposing (..)
import Set
import Test exposing (..)
import Test.Table exposing (..)


functors =
  describe "Functor laws"
    [ functor "List" List.map Fuzz.list
    , functor "Array" Array.map Fuzz.array
    , functor "Maybe" Maybe.map Fuzz.maybe
    , functor "Result" Result.map (Fuzz.result (Fuzz.constant <| Err "no"))
    , functor "Set" Set.map (Fuzz.list >> Fuzz.map Set.fromList)
    ]


roundtrips =
  describe "roundtrip tests"
    [ Fuzz.Roundtrip.roundtrip "toFloat/truncate" (Fuzz.intRange -11147 47111) toFloat truncate
    , Fuzz.Roundtrip.roundtrip "+3 / -3" (Fuzz.intRange -11147 47111) ((+) 3) ((+) -3)
    ]


isomorphisms =
  describe "isomorphism tests"
    [ -- failed: isomorphism "toFloat/truncate" (Fuzz.intRange -11147 47111) (Fuzz.floatRange -11147 47111) toFloat truncate
      isomorphism "+3 / -3" (Fuzz.intRange -11147 47111) (Fuzz.intRange -11147 47111) ((+) 3) ((+) -3)

    -- , isomorphism "exp / log 3" (numberRange 1 42) (numberRange 1 42) ((^) 3) (logBase 3)
    -- , isomorphism "exp / log 6" (numberRange 1 42) (numberRange 1 42) ((^) 6) (logBase 6)
    -- , isomorphism "exp / log 1.3" (numberRange 1 42) (numberRange 1 42) ((^) 1.3) (logBase 1.3)
    ]



-- -- homomorphism name afuzz fmap fold afolder ab bfolder =
--
--
-- homomorphisms =
--   describe "homomorphism tests"
--     [ homomorphism "List.length" (Fuzz.list << Fuzz.list) List.map (List.foldl [])
--     ]
