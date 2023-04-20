:- use_module(library(dcg/basics)).
:- use_module(library(pio)).
:- use_module(reader).
:- use_module(eval).

run :-
    phrase_from_file(expression(Expr), user_input),
    eval(Expr, Result),
    write(Result),
    nl,
    run.
