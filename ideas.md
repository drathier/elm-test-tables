# Ideas
- round trip tests
- table of fuzzers, to be run one by one, for testing comparable etc.
- letter fuzzers for a,b,c,d,e,... for non-overlapping arbitrary types
  - for when you need a value, but don't care what type it is.
  - e.g. list reverse identity is a good example

- table of unit test arguments, with a fuzzer as well
- table of known edge cases that we don't care about handling

- input validator function: (a,b,c) -> Maybe (a,b,c), allowing reordering and rejecting values
  - we can put this in another package, and hope to integrate it into elm-test where we can fail tests as flaky if we retry more than e.g. 10 times per unit test.

- make api composable? Table.fuzz << table [] << validator (\a -> Just a) <| (\a b -> a |> Expect.equal b) or something similar
- make api composable? table [] |> withValidator (\a -> Just a) |> fuzz int int "" (\a b -> a |> Expect.equal b) or something similar

- Debug.log that only logs on the last run of the test case, after all shrinking is done.
- Adapt number of fuzz test runs based on which fuzzers are used, and how many
  - larger state space -> more fuzz test runs, estimate coverage
  - avoid duplicate runs; reject them and use a hash table technique to find another input that's unlikely to fill long sequences.

- based on elm-format's ast, generate fuzzers for arbitrary data types

- Hypothesis database, so you don't have to store your edge-cases in code. (Good or bad?)

- for now, just make skipping a value print a warning (so you realize if you're skipping a ton of values)

- supply small modifiers, like nonNegative : Int -> Int, and positive : Int -> Int.
  - Set up the fact that we first select fuzzers, then combine transformers to get what we want (tuple of identity functions?), the run the fuzz test. Every value that makes it into the fuzz test yields an expectation; all modification and rejection happens in the previous step.
  - What does this look like when combined with tables? Too busy? Fuzz, fuzzers, desc, table, transform/reject (transform/reject function is passed to fn as an argument, so we can print after all shrinking is done), and the fuzz body.

- Every test case still tests one thing, even if it's a fuzz or table test.
  - No it does not. Tables test many things. But so do fuzzers.
    - Maybe we can reuse the fuzz body in unit tests in a nice way?
  - Tables _may_ test many things, but should not!

- what other things are useful fuzz test tools?
- what other test tools are there?

- expecting to find a counterexample, i.e. expecting a property to not hold in the general case

- type classes!
  - fuzzers for map, andMap, andThen etc.
  - associativity, commutativity, idempotence, etc.
  - idempotent, idempotent2, associative, commutative, etc
    - no anti-properties for now. They're too uncommon.

- test that things don't compile
