------------------------------ MODULE knapsack ------------------------------

(*
The Knapsack Problem

We have a knapsack of volume N and a set of items.
Each item has a value and a size.
You can fit any number of each item in the knapsack as long as the sum of them all is less than the capacity of the sack.
What's the most valuable knapsack you can make?
*)

EXTENDS TLC, Integers, Sequences
PT == INSTANCE PT

Capacity == 4
Items == {"a", "b", "c"}
ItemParams == [size: 2..4, value: 0..5]
ItemSets == [Items -> ItemParams]

KnapsackSize(sack, itemset) ==
    LET size_for(item) == itemset[item].size * sack[item]
    IN PT!ReduceSet(LAMBDA item, acc: size_for(item) + acc, Items, 0)

KnapsackValue(sack, itemset) ==
    LET value_for(item) == itemset[item].value * sack[item]
    IN PT!ReduceSet(LAMBDA item, acc: value_for(item) + acc, Items, 0)
\* there is an issue and it thinks it's in the line below
ValidKnapsacks(itemset) ==
    {sack \in [Items -> 0..4]: KnapsackSize(sack, itemset) <= Capacity}

\* BestKnapsack(itemset) ==
\*     LET all == ValidKnapsacks(itemset)
\*     IN CHOOSE best \in all:
\*         \A worse \in all \ {best}:
\*         KnapsackValue(best, itemset) > KnapsackValue(worse, itemset)

\* BestKnapsacksOne(itemset) ==
\*     LET all == ValidKnapsacks(itemset)
\*     IN
\*         CHOOSE all_the_best \in SUBSET all:
\*             \E good \in all_the_best:
\*                 /\ \A other \in all_the_best:
\*                     KnapsackValue(good, itemset) = KnapsackValue(other, itemset)
\*                 /\ \A worse \in all_the_best:
\*                     KnapsackValue(good, itemset) > KnapsackValue(worse, itemset)

\* BestKnapsacksTwo(itemset) ==
\*     LET
\*         all == ValidKnapsacks(itemset)
\*         best == CHOOSE best \in all:
\*             \A worse \in all \ {best}:
\*                 KnapsackValue(best, itemset) >= KnapsackValue(worse, itemset)
\*         value_of_best == KnapsackValue(best, itemset)
\*     IN
\*         {k \in all: value_of_best = KnapsackValue(k, itemset)}

BestKnapsacks(itemset) ==
    LET
        value(sack) == KnapsackValue(sack, itemset)
        all == ValidKnapsacks(itemset)
        best == CHOOSE best \in all:
                    \A worse \in all \ {best}:
                        value(best) >= value(worse)
    IN
        {k \in all: value(best) = value(k)}

(*--algorithm knapsack
variables
    itemset \in ItemSets;

begin
    assert BestKnapsacks(itemset) \in ValidKnapsacks(itemset);
end algorithm; *)
\* BEGIN TRANSLATION
VARIABLES itemset, pc

vars == << itemset, pc >>

Init == (* Global variables *)
        /\ itemset \in ItemSets
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(BestKnapsacks(itemset) \in ValidKnapsacks(itemset),
                   "Failure of assertion at line 72, column 5.")
         /\ pc' = "Done"
         /\ UNCHANGED itemset

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION
=============================================================================
\* Modification History
\* Last modified Mon Jan 06 21:29:55 CST 2020 by acook
\* Created Mon Jan 06 20:36:52 CST 2020 by acook
