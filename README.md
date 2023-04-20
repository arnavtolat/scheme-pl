# scheme-pl
scheme interpreter in prolog

The interpreter can be run by loading the interpreter.pl file and calling the run/0 predicate. This will read expressions from standard input, evaluate them, and print the result. For example, running the interpreter and entering the expression (define (fact n) (if (= n 0) 1 (* n (fact (- n 1))))) (fact 5) will output 120.
