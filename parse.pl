:- module(parse, [parse/2]).

parse(Codes, Tokens) :-
    phrase(tokens(Tokens), Codes).

tokens([]) --> [].
tokens([H|T]) --> whitespace, token(H), tokens(T).

whitespace --> " ", !.
whitespace --> "\n", !.
whitespace --> "\r", !.
whitespace --> "\t", !.

token(T) --> "(", { atom_codes(T, ['(']) }, !.
token(T) --> ")", { atom_codes(T, [')']) }, !.
token(T) --> integer(T), !.
token(T) --> float(T), !.
token(T) --> string(T), !.
token(T) --> identifier(T), !.

integer(T) --> digit(D), integer_chars(Dl), { append([D], Dl, Chars), number_chars(N, Chars), atom_number(T, N) }.

float(T) --> integer_chars(Chars1), ".", integer_chars(Chars2), { append(Chars1, [46|Chars2], Chars), number_chars(T), { atom_codes(T, Chars) }.

identifier(T) --> letter(L), identifier_chars(Cl), { append([L], Cl, Chars), atom_codes(T, Chars) }.

identifier_chars([]) --> [].
identifier_chars([H|T]) --> (letter(H) ; digit(H) ; special(H)), identifier_chars(T).

string(T) --> """, string_chars(Cl), """, { append([34], Cl, Chars), atom_codes(T, Chars) }.

string_chars([]) --> [].
string_chars([H|T]) --> [H], { H = 34 }, string_chars(T).

digit(D) --> [D], { code_type(D, digit) }.
integer_chars([H|T]) --> digit(H), !, integer_chars(T).
integer_chars([]) --> [].

letter(L) --> [L], { code_type(L, alpha) }.
special(S) --> [S], { memberchk(S, "+-*/<>=?!.") }.
