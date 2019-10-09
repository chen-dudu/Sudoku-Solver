
%% import required library to use transpose/2
:- ensure_loaded(library(clpfd)).

puzzle_solution([Heading|Rest]) :- transpose([Heading|Rest], [_|TRest]), 
                                   valid_digit(Rest), valid_digit(TRest), 
                                   valid_row(Rest), valid_row(TRest), 
                                   valid_diagonal([Heading|Rest]), 
                                   append([Heading|Rest], Vars), 
                                   bound_value(Vars).
% valid_digit(-List)
valid_digit([]).
valid_digit([[_|Cells]|Rest]) :- 
    Cells ins 1..9, all_distinct(Cells), valid_digit(Rest).

%% valid_diagonal(-Puzzle)
valid_diagonal(Puzzle) :- length(Puzzle, Len), index(1, 1, Puzzle, X), 
                          Padding is Len - 1, 
                          valid_diagonal(Puzzle, X, Padding).

%% valid_diagonal(?List, ?X, +N)
valid_diagonal(Puzzle, X, Padding) :- 
    length(Puzzle, Len), Index is Len - Padding, 
    ( Padding =:= 1 ->
        index(Index, Index, Puzzle, X)
    ;   Padding1 is Padding - 1, 
        index(Index, Index, Puzzle, X), 
        valid_diagonal(Puzzle, X, Padding1)
    ).

% index(+X, +Y, +List, -Item)
index(X, Y, List, Item) :- nth0(Y, List, Row), nth0(X, Row, Item).

% valid_row(?List)
valid_row([]).
valid_row([[X|Xs]|Rest]) :- 
    (sum(Xs, #=, X); product_list(Xs, 1, X)), valid_row(Rest).

% product_list(-List, +Accumulator, +Product)
product_list([], P, P).
product_list([X|Xs] , Acc, P) :- 
    Acc1 #= X * Acc, 
    product_list(Xs, Acc1, P).

% bound_value(?List)
bound_value([]).
bound_value([X|Xs]) :- indomain(X), bound_value(Xs).
