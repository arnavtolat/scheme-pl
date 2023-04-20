:- module(eval, [eval/2]).

eval(Expr, Expr) :- number(Expr).
eval(Expr, Expr) :- atom(Expr).
eval(Expr, Eval) :- string(Expr), eval_string(Expr, Eval).
eval([quote, Expr], Expr).
eval([if, Cond, Then, Else], Eval) :- eval(Cond, true), !, eval(Then, Eval).
eval([if, Cond, Then, Else], Eval) :- eval(Else, Eval).
eval([lambda, Args, Body], closure(Args, Body)).
eval([func|Rest], Eval) :- eval_function(Rest, Eval).
eval([H|T], Eval) :- eval_function([H|T], Eval).
eval(X, Eval) :- X =.. [Op|Args], maplist(eval, Args, EvalArgs), Expr =.. [Op|EvalArgs], Expr \= X, eval(Expr, Eval).

eval_string(String, String) :- atomic(String).
eval_string(String, Eval) :- string_codes(String, Codes), parse(Codes, Tokens), expression(Tokens, Expr), eval(Expr, Eval).

eval_function([H|T], Eval) :-
    eval(H, Func),
    maplist(eval, T, Args),
    Func = closure(Params, Body),
    bind_args(Params, Args, Env),
    eval(Body, Env, Eval).

bind_args([], [], []).
bind_args([H|T], [H1|T1], [H = H1|T2]) :- bind_args(T, T1, T2).

eval([], _, []) :- !.
eval([H|T], Env, R) :- eval_instruction(H, Env, Env1), eval(T, Env1, R).

eval_instruction(X, _, X) :- number(X), !.
eval_instruction(X, _, X) :- atom(X), !.
eval_instruction([quote, Expr], _, Expr).
eval_instruction([if, Cond, Then, Else], Env, Eval) :- eval(Cond, true, Env), !, eval(Then, Eval, Env).
eval_instruction([if, Cond, Then, Else], Env, Eval) :- eval(Else, Eval, Env).
eval_instruction([lambda, Args, Body], Env, closure(Args, Body, Env)).
eval_instruction([func|Rest], Env, Eval) :- eval_function(Rest, Eval, Env).
eval_instruction([H|T], Env, Eval) :- eval_function([H|T], Eval, Env).
eval_instruction(X, Env, Eval) :- X =.. [Op|Args], maplist(eval_instruction, Args, EvalArgs, [Env|Envs]), Expr =.. [Op|EvalArgs], Expr \= X, append(Envs, [Env], AllEnvs), eval_instruction(Expr, AllEnvs, Eval).

eval_function([H|T], Eval, Env) :-
    eval_instruction(H, Env, Func),
    maplist(eval_instruction, T, Args, [Env|Envs]),
    Func = closure(Params, Body, _),
    bind_args(Params, Args, NewEnv),
    append(NewEnv, Envs, AllEnvs),
    eval_instruction(Body, AllEnvs, Eval).

eval_function_args([H|T], Eval, Env) :-
    maplist(eval_instruction, [H|T], EvalArgs, [Env|Envs]),
    append(EvalArgs, [Envs], AllArgs),
    Eval =.. [func|AllArgs].

