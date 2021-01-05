---- MODULE PT ----

\* LOCAL means it doesn't get included when you instantiate the module itself.
LOCAL INSTANCE FiniteSets
LOCAL INSTANCE Integers
LOCAL INSTANCE Sequences

Max(x, y) == IF x > y THEN x ELSE y
Min(x, y) == IF x < y THEN x ELSE y

(* Sets *)

(* Use a set comprehension to filter subsets by their cardinality *)
SubsetsOfSize(set, n) == { set1 \in SUBSET set : Cardinality(set1) = n}

(*
TLA+ forbids recursive higher-order operators, but it is fine with recursive functions.
ReduceSet generates a recursive function over the subsets of a set, which can be used to
recursively run a defined operator. This can then be used to define other recursive operators.
*)
ReduceSet(op(_, _),set, acc) ==
  LET f[s \in SUBSET set] ==
    IF s = {}
      THEN acc
    ELSE
      LET x == CHOOSE x \in s : TRUE
      IN op(x, f[s \ {x}])
  IN f[set]

(* Functions *)

(*
Gets the set of all possible values that f maps to.
Essentially the opposite of DOMAIN.  Uses a set comprehension-map.
*)
Range(f) == { f[x] : x \in DOMAIN f }

(*
Places an arbitrary ordering on the set.  Which ordering you get is implementation-dependent
but you are guaranteed to always receive the same ordering.
*)
OrderSet(set) == CHOOSE seq \in [1..Cardinality(set) -> set] : Range(seq) = set

(* Get all inputs to a function that map to a given output *)
Matching(f, val) == {x \in DOMAIN f : f[x] = val}

(* Sequences *)

TupleOf(set, n) == [1..n -> set]

(*
All sequences up to length n with all elements in set.
Equivalent to TupleOf(set, 0) \union TupleOf(set, 1) \union ...
Includes empty sequence
*)
SeqOf(set, n) == UNION {TupleOf(set, m) : m \in 0..n}

ReduceSeq(op(_, _), seq, acc) ==
  ReduceSet(LAMBDA i, a : op(seq[i], a), DOMAIN seq, acc)

(*
SelectSeq lets you filter a sequence based on a test operator.  It acts on the values.
SelectSeqByIndex does the exact same, except the operator tests the indices.
This is useful if you need to round-robin a thing.
*)
SelectSeqByIndex(seq, T(_)) ==
  ReduceSet(
    LAMBDA i,
    selected :
      IF T(i)
        THEN Append(selected, seq[i])
      ELSE selected,
    DOMAIN seq, <<>>
  )

(* Pulls an index of the sequence for an element *)
Index(seq, elem) == CHOOSE i \in 1..Len(seq): seq[i] = elem

(*
% is 0-based, but sequences are 1-based.  This means S[x % Len(S)] might be an error,
as it could evaluate to S[0], which is not an element of the sequence.
This is a binary operator.
*)
LOCAL a %% b == IF a % b = 0 THEN b ELSE a % b

SeqMod(a, b) == a %% b

=====
