module Fuzz.CategoryTest exposing (andThenTests, mapTests, setConcatMap)

import Array
import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, float, int, list, string, tuple)
import Fuzz.Category exposing (..)
import Fuzz.Opaque exposing (a, appendable, b, comparable, comparable2)
import Set exposing (Set)
import Test exposing (..)
import Test.Table exposing (..)


mapTests =
    describe "Functor laws"
        [ describe "List.map"
            [ mapv1 List.map Fuzz.list
            , mapv2 List.map Fuzz.list
            , mapv3 List.map Fuzz.list
            ]
        , describe "Array.map"
            [ mapv1 Array.map Fuzz.array
            , mapv2 Array.map Fuzz.array
            , mapv3 Array.map Fuzz.array
            ]
        , describe "Maybe.map"
            [ mapv1 Maybe.map Fuzz.maybe
            , mapv2 Maybe.map Fuzz.maybe
            , mapv3 Maybe.map Fuzz.maybe
            ]
        , describe "Result.map"
            [ mapv1 Result.map (Fuzz.result (Fuzz.constant <| Err "no"))
            , mapv2 Result.map (Fuzz.result (Fuzz.constant <| Err "no"))
            , mapv3 Result.map (Fuzz.result (Fuzz.constant <| Err "no"))
            ]
        , describe "Set.map"
            [ mapv1 Set.map (Fuzz.list >> Fuzz.map Set.fromList)
            , mapv2 Set.map (Fuzz.list >> Fuzz.map Set.fromList)
            , mapv3 Set.map (Fuzz.list >> Fuzz.map Set.fromList)
            ]
        ]


andThenTests =
    describe "Monad laws"
        [ describe "List.andThen"
            [ andThenv1 List.singleton List.concatMap Fuzz.list
            , andThenv2 List.singleton List.concatMap Fuzz.list
            , andThenv3 List.singleton List.concatMap Fuzz.list
            ]
        , describe "Maybe.andThen"
            [ andThenv1 Just Maybe.andThen Fuzz.maybe
            , andThenv2 Just Maybe.andThen Fuzz.maybe
            , andThenv3 Just Maybe.andThen Fuzz.maybe
            ]
        , describe "Result.andThen"
            [ andThenv1 Ok Result.andThen (Fuzz.result (Fuzz.constant <| Err "no"))
            , andThenv2 Ok Result.andThen (Fuzz.result (Fuzz.constant <| Err "no"))
            , andThenv3 Ok Result.andThen (Fuzz.result (Fuzz.constant <| Err "no"))
            ]
        , describe "Set.andThen"
            [ andThenv1 Set.singleton setConcatMap (Fuzz.list >> Fuzz.map Set.fromList)
            , andThenv2 Set.singleton setConcatMap (Fuzz.list >> Fuzz.map Set.fromList)
            , andThenv3 Set.singleton setConcatMap (Fuzz.list >> Fuzz.map Set.fromList)
            ]
        ]


setConcatMap : (comparable1 -> Set comparable2) -> Set comparable1 -> Set comparable2
setConcatMap fn s =
    s |> Set.toList |> List.map fn |> List.foldl Set.union Set.empty
