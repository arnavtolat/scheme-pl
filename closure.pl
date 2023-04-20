:- module(closure, [closure_lookup/3]).

closure_lookup(Env, Var, Val) :- member(Var = Val, Env).
closure_lookup(closure(_, _, Parent), Var, Val) :- closure_lookup(Parent, Var, Val).
