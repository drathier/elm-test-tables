# elm-test-tables
Elm-test tool that allows table-driven tests. Idiomatic or not, they're really nice to work with.


# Ideas

- table of fuzzers, to be run one by one, for testing comparable etc.
- letter fuzzers for a,b,c,d,e,... for non-overlapping arbitrary types

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



- what other things are useful fuzz test tools?
- what other test tools are there?
