module Fuzz.Opaque exposing (..)

{-| Let's say you're testing a container, and you don't really care what you put into the list, as long as there are values, perhaps with a certain property. Why would you use a list of ints, when what you really want is a list of a, or a list of comparable?
-}

import Fuzz exposing (Fuzzer, bool, custom, int, tuple, tuple3, tuple4, tuple5, unit)
import Random exposing (Generator)


constant c =
  Fuzz.map (always c) unit

-- Comparable

comparable : Fuzzer ( String, Int )
comparable =
  tuple ( constant "comparable", int )


comparable2 : Fuzzer ( String, Int, String )
comparable2 =
  tuple3 ( constant "comparable2", int, constant "\x1F914" )


comparable3 : Fuzzer ( String, Int, Char )
comparable3 =
  tuple3 ( constant "comparable3", int, constant '\x1F917' )


comparable4 : Fuzzer ( String, Int, Float )
comparable4 =
  tuple3 ( constant "comparable4", int, constant pi )


comparable5 : Fuzzer ( String, Int, Char, Char )
comparable5 =
  tuple4 ( constant "comparable5", int, constant '❤', constant '\x1F937' )
