:- module(reader, [expression//1]).

expression(Expr) --> whitespace, expr(Expr), whitespace.

expr(Expr) --> list(Expr), !.
expr(Expr) --> number(Expr), !.
expr(Expr) --> string(Expr), !.
expr(Expr) --> identifier(Expr), !.

list([]) --> "(", whitespace, ")", !.
list([H|T]) --> "(", whitespace, expr(H), whitespace, exprs(T), whitespace, ")", !.

exprs([]) --> [].
exprs([H|T]) --> expr(H), whitespace, exprs(T).

number(Num) --> integer(Num).
number(Num) --> float(Num).

string(String) --> "\"", string_body(String), "\"".

string_body([]) --> [].
string_body([H|T]) --> string_char(H), string_body(T).

string_char(C) --> [C], { C \= "\"" }.
string_char(C) --> "\\", escaped_char(C).

escaped_char('"') --> "\"".
escaped_char('\\') --> "\\".
escaped_char('\n') --> "n".
escaped_char('\r') --> "r".
escaped_char('\t') --> "t".

identifier(Identifier) --> letter(First), rest_ident(Rest), { atom_codes(Identifier, [First|Rest]) }.

rest_ident([]) --> [].
rest_ident([H|T]) --> (letter(H) ; digit(H) ; special(H)), rest_ident(T).

letter(L) --> [L], { code_type(L, alpha) }.
digit(D) --> [D], { code_type(D, digit) }.
special(S) --> [S], { memberchk(S, "+-*/<>=?!.") }.

whitespace --> [].
whitespace --> " ", whitespace.
whitespace --> "\n", whitespace.
whitespace --> "\r", whitespace.
whitespace --> "\t", whitespace.
