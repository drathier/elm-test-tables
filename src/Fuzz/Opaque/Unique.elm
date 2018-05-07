module Fuzz.Opaque.Unique exposing (a, appendable, appendable2, b, c, comparable, comparable2, comparable3, comparable4, comparable5, d, e, f, g, h, i, j, k, l, m, n, number, number2, o, p, q, r, s, t, u, v, w, x, y, z)

{-| See docs for Fuzz.Opaque. This is a collection of those same fuzzers, but constructed in a way as to never give duplicate values. That is, if you generate a list of these values, there will be a very very low probability of a duplicate element in that list.

Types match Fuzz.Opaque with same name. Collision risk between `Fuzz.Opaque.a and`Fuzz.Opaque.Unique.a` is very very low.


# Comparable

Types match Fuzz.Opaque.comparable with same number.

@docs comparable, comparable2, comparable3, comparable4, comparable5


# Appendable

Types match Fuzz.Opaque.appendable with same number.

@docs appendable, appendable2


# Number

Types match Fuzz.Opaque.number with same number.

@docs number, number2


# Opaque

Fuzzers that generate opaque types with no constraints, e.g. `Fuzzer a`. Note that `Fuzzer a` is a different type from `Fuzzer b` etc.

@docs a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z

-}

import Fuzz exposing (Fuzzer, custom, floatRange, intRange, list, map, tuple, tuple3, tuple4, tuple5, unit)
import Fuzz.Unique exposing (char, float, int, string)
import Random exposing (Generator)


constant c =
  map (always c) unit



-- Comparables. Types match Fuzz.Opaque with same name, but values are never equal.


{-| `Fuzzer comparable`
-}
comparable : Fuzzer ( String, Int )
comparable =
  tuple ( constant "comparable", int )


{-| `Fuzzer comparable2`
-}
comparable2 : Fuzzer ( String, Int, String )
comparable2 =
  tuple3 ( constant "comparable2", int, constant "\x1F914" )


{-| `Fuzzer comparable3`
-}
comparable3 : Fuzzer ( String, Int, Char )
comparable3 =
  tuple3 ( constant "comparable3", int, constant '\x1F917' )


{-| `Fuzzer comparable4`
-}
comparable4 : Fuzzer ( String, Int, Float )
comparable4 =
  tuple3 ( constant "comparable4", int, constant pi )


{-| `Fuzzer comparable5`
-}
comparable5 : Fuzzer ( String, Int, Char, Char )
comparable5 =
  tuple4 ( constant "comparable5", int, constant '❤', constant '\x1F937' )



-- Appendables. Unfortunately, there are only two, but it's better than nothing.


{-| `Fuzzer appendable`
-}
appendable : Fuzzer String
appendable =
  string


{-| `Fuzzer appendable2`
-}
appendable2 : Fuzzer (List Opaque)
appendable2 =
  list opaque


type Opaque
  = Opaque Int


opaque =
  map Opaque int



-- Numbers. Unfortunately, there are only two, but it's better than nothing.


{-| `Fuzzer number`
-}
number : Fuzzer Float
number =
  float


{-| `Fuzzer number2`
-}
number2 : Fuzzer Int
number2 =
  int



-- Opaque type fuzzers; arbitrary types with no constraints. Note that they are all different types.


type A
  = A Int


{-| `Fuzzer a`
-}
a : Fuzzer A
a =
  map A int


type B
  = B Int


{-| `Fuzzer b`
-}
b : Fuzzer B
b =
  map B int


type C
  = C Int


{-| `Fuzzer c`
-}
c : Fuzzer C
c =
  map C int


type D
  = D Int


{-| `Fuzzer d`
-}
d : Fuzzer D
d =
  map D int


type E
  = E Int


{-| `Fuzzer e`
-}
e : Fuzzer E
e =
  map E int


type F
  = F Int


{-| `Fuzzer f`
-}
f : Fuzzer F
f =
  map F int


type G
  = G Int


{-| `Fuzzer g`
-}
g : Fuzzer G
g =
  map G int


type H
  = H Int


{-| `Fuzzer h`
-}
h : Fuzzer H
h =
  map H int


type I
  = I Int


{-| `Fuzzer i`
-}
i : Fuzzer I
i =
  map I int


type J
  = J Int


{-| `Fuzzer j`
-}
j : Fuzzer J
j =
  map J int


type K
  = K Int


{-| `Fuzzer k`
-}
k : Fuzzer K
k =
  map K int


type L
  = L Int


{-| `Fuzzer l`
-}
l : Fuzzer L
l =
  map L int


type M
  = M Int


{-| `Fuzzer m`
-}
m : Fuzzer M
m =
  map M int


type N
  = N Int


{-| `Fuzzer n`
-}
n : Fuzzer N
n =
  map N int


type O
  = O Int


{-| `Fuzzer o`
-}
o : Fuzzer O
o =
  map O int


type P
  = P Int


{-| `Fuzzer p`
-}
p : Fuzzer P
p =
  map P int


type Q
  = Q Int


{-| `Fuzzer q`
-}
q : Fuzzer Q
q =
  map Q int


type R
  = R Int


{-| `Fuzzer r`
-}
r : Fuzzer R
r =
  map R int


type S
  = S Int


{-| `Fuzzer s`
-}
s : Fuzzer S
s =
  map S int


type T
  = T Int


{-| `Fuzzer t`
-}
t : Fuzzer T
t =
  map T int


type U
  = U Int


{-| `Fuzzer u`
-}
u : Fuzzer U
u =
  map U int


type V
  = V Int


{-| `Fuzzer v`
-}
v : Fuzzer V
v =
  map V int


type W
  = W Int


{-| `Fuzzer w`
-}
w : Fuzzer W
w =
  map W int


type X
  = X Int


{-| `Fuzzer x`
-}
x : Fuzzer X
x =
  map X int


type Y
  = Y Int


{-| `Fuzzer y`
-}
y : Fuzzer Y
y =
  map Y int


type Z
  = Z Int


{-| `Fuzzer z`
-}
z : Fuzzer Z
z =
  map Z int
