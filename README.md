# tla-plus
playing along at home with Practical TLA+

## Values
Strings
```
"a", "b", "c"
```
Integers
```
1, 2, 3
```
Booleans
```
TRUE, FALSE
```
## Collections
Sets
```
{1, 2, 3}, {"a", "b", "c"}
```
Sequences/Tuples
```
<<1, "a", 2, "b", 3, "c">>
```
## Value Operations
Equals
```
x = y
```
Not Equals
```
x /= y
x # y
```
And
```
x /\ y
```
Or
```
x \/ y
```
Assignment (PlusCal only)
```
x := y
```
Not
```
~n
```
Implies (if p is true, then q is true)
```
p => q
```
Both (either both are true or both are false)
```
p <=> q
```
## Set Operations
All elements must be of the same type
```
{1, 2, 3}
```
Is element of set
```
x \in set
```
Is not element of set
```
x \notin set
~(x \in set)
```
Is subset of set
```
set1 \subseteq set2
```
Set union
```
set1 \union set2
```
Set Difference
```
set1 \ set2
```
Number of elements in set (requires EXTENDS FiniteSets)
```
Cardinality(set)
```
Power Set
```
SUBSET set
```
Set union
```
UNION set_of_sets
```
Cartesian product (not associative)
```
set1 \X set2
```
For all elements in a set, the predicate evaluates true

If the set is empty then `\A` is true
```
\A element \in set: P(element)
```
Not all elements in the set evaluate true
```
~\A element \in set: P(element)
```
There exists some element in the set where the predicate evaluates true

If the set is empty then `\E` is false
```
\E element \in set: P(element)
```
There is no element in the set where the predicate evaluates true
```
~\E element \in set: P(element)
```

## Sequence / Tuple Operations
(all require EXTENDS Sequences)

Head
```
Head(seq)
```
Tail
```
Tail(seq)
```
Append
```
Append(seq, x)
```
Combine
```
seq1 \o seq2
```
Length
```
Len(seq)
```

## Macros
Essentially functions. No double assignments. No `while` loops.

## Definition Order
1. variables
2. define
3. macro

## Operators
Higher-order operators must specify in advance how many parameters the operator takes
```
Add(a, b) == a + b
Apply(op(_, _), x, y) == op(x, y)

>> Apply(Add, 1, 2)
3
```

Define anonymous operators with `LAMBDA`.  These can only be used as arguments to other operators, not as stand-alone operators.

```
>> Apply(LAMBDA x, y: x + y, 1, 2)
3
```

Operators can be used as invariants.

`DOMAIN` is a special prefix operator that gives us the possible inputs to a function.

`@@` is an infix operator that merges two functions. Use with `EXTENDS TLC`.

`:>` is the function `[x \in {a} |-> b]`. Use with `EXTENDS TLC`.

`[set1 -> set2]` is the set of all functions that map elements of set1 to elements of set2.

```
>> [s \in {"a", "b"} |-> {1, 2}]
[a |-> {1, 2}, b |-> {1, 2}]

>> [{"a", "b"} -> {1, 2}]
{
  [a |-> 1, b -> 1],
  [a |-> 1, b -> 2],
  [a |-> 2, b -> 1],
  [a |-> 2, b -> 2],
}
```

## Invariants
Boolean expressions that are checked at the end of every step of the model.
Add them to the Invariants section of the model in TLA+ Toolbox.

## Expressions
LET-IN
```
RotateRight(seq) ==
  LET
    last == seq[Len(seq)]
    first == SubSeq(seq, 1, Len(seq) - 1)
  IN <<last>> \o first

>> RotateRight(<<1, 2, 3>>)
<<3, 1, 2>>
```

IF-THEN-ELSE
```
Max(x, y) == IF x > y THEN x ELSE y

>> <<Max(2, 3), Max(3, 2)>>
<<3, 3>>
```

CASE
```
CASE x = 1 -> TRUE
  [] x = 2 -> TRUE
  [] x = 3 -> 7
  [] OTHER -> FALSE
```

CHOOSE

Select an element in a set/sequence such that the predicate evaluates true
```
IndexOf(seq, elem) ==
  CHOOSE i \in 1..Len(seq): seq[i] = elem

>> IndexOf(<<8, 3, 1>>, 3)
2 \* index starts at 1

Max(set) == CHOOSE x \in set: \A y \in set: x >= y

>> Max(1..10)
10
```

## Functions
Maps a set of inputs (domain) to a set of outputs (codomain).

Tuples and Structures are special cases of functions.

Tuples' domain is the set of natural numbers.

Structures' domain is the set of strings.

The difference between functions and operators is that operators can work on arbitrary inputs, while functions must have a specified domain.
```
\* Standard form
[x \in set |-> P(x)]

\* Multiply each number by 2
[x \in numbers |-> x * 2]

\* Equivalent
[x, y \in set |-> P(x, y)]
[x \in set1, y \in set2 |-> P(x, y)]

\* Calling a function
function[arg]

\* Make a function an operator (both valid syntax as long as it takes no arguments)
Op == [x \in S |-> P(x)]
Op[x \in S] == P(x)
```
