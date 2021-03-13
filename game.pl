:- catch(use_module(library(clpz)), error(existence_error(_,_),_), use_module(library(clpfd))).
:- use_module(library(reif)).

zip([], [], []).
zip([K|Ks], [V|Vs], [K/V|Pairs]) :-
    zip(Ks, Vs, Pairs).

length_(N, List) :-
    length(List, N).

square(N, Matrix) :-
    length(Matrix, N),
    maplist(length_(N), Matrix).

max(V1, V2, Max) :-
    Max #= max(V1, V2).

maxmask([], []).
maxmask([_], [true]).
maxmask([V1, V2 | Vs], Mask) :-
    foldl(max, [V2 | Vs], V1, Max),
    maplist(=(Max), [V1, V2 | Vs], Mask).

and(true,true,true).
and(true,false,false).
and(false,true,false).
and(false,false,false).

payoff_nash(Payoff, NashMask) :-
    maplist(square(_), [
        Payoff, Payoff1, Payoff2, TransposedPayoff1, NashMask, NashMask1, NashMask2, TransposedNashMask1
    ]),
    maplist(zip, Payoff1, Payoff2, Payoff),
    maplist(maxmask, Payoff2, NashMask2),
    transpose(Payoff1, TransposedPayoff1),
    maplist(maxmask, TransposedPayoff1, TransposedNashMask1),
    transpose(TransposedNashMask1, NashMask1),
    maplist(maplist(and), NashMask1, NashMask2, NashMask).
