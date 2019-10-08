
%% import required library to use transpose/2
:- ensure_loaded(library(clpfd)).

puzzle_solution([Heading|Rest]) :- transpose([Heading|Rest], [_|TRest]), 
                                   valid_digit(Rest), valid_digit(TRest), 
                                   valid_row(Rest), valid_row(TRest), 
                                   valid_diagonal([Heading|Rest]), 
                                   append([Heading|Rest], Vars), 
                                   bound_value(Vars).

%% puzzle_solution(Puzzle) :- transpose(Puzzle, Transpose), 
%%                            extrac_diagonal(Puzzle, 1, Diagonal), 
%%                            valid_digit(Diagonal), 
%%                            row_distinct_digit(Puzzle), 
%%                            row_valid_sum_product(Puzzle), 
%%                            row_valid_sum_product(Transpose).

%% row_distinct_digit([]).
%% row_distinct_digit([[Heading|Cells]|Rest]) :- 
%%     ( Heading =:= 0 ->
%%         row_distintc_digit(Rest)
%%     ;   valid_digit(Cells), 
%%         all_distinct(Cells)  
%%     ).

%% row_valid_sum_product([]).
%% row_valid_sum_product([[Heading|Cells]|Rest]) :- 
%%     ( Heading =:= 0 ->
%%         row_valid_sum_product(Rest)
%%     ;   (sum(Cells, #=, Heading); product_list(Cells, 1, Heading)),
%%         row_valid_sum_product(Rest) 
%%     ).

extrac_diagonal(Matrix, Index, Diagonal) :- 
    ( length(Matrix, Len), Index is Len - 1 ->
        index(Index, Index, Matrix, X), 
        Diagonal = [X]
    ;   index(Index, Index, Matrix, X), 
        Diagonal = [X|Diagonal1], 
        Index1 is Index + 1, 
        extrac_diagonal(Matrix, Index1, Diagonal1)
    ).

valid_digit([]).
valid_digit([[_|Cells]|Rest]) :- 
    Cells ins 1..9, all_distinct(Cells), valid_digit(Rest).

valid_digits(List) :- List ins 1..9, all_distinct(List).

%% valid_diagonal(+Puzzle)
valid_diagonal(Puzzle) :- length(Puzzle, Len), index(1, 1, Puzzle, X), 
                          Padding is Len - 1, 
                          valid_diagonal(Puzzle, X, Padding).

%% valid_diagonal(+List, +X, +N)
valid_diagonal(Puzzle, X, Padding) :- 
    length(Puzzle, Len), Index is Len - Padding, 
    ( Padding =:= 1 ->
        index(Index, Index, Puzzle, X)
    ;   Padding1 is Padding - 1, 
        index(Index, Index, Puzzle, X), 
        valid_diagonal(Puzzle, X, Padding1)
    ).

%% get an item from a 2D list using item's coordinate (X, Y)
%% X is the column number and Y is the row number
%% using 0-base index
%% getFromPuzzle(+X, +Y, +List, -Item)
index(X, Y, List, Item) :- nth0(Y, List, Row), nth0(X, Row, Item).

%% check that all the rows are valid
%% valid_row([]).
%% valid_row([[X|Xs]|Rest]) :- valid_digits(Xs), 
%%     (sum(Xs, #=, X); product_list(Xs, 1, X)), valid_row(Rest).

valid_row([]).
valid_row([[X|Xs]|Rest]) :- 
    (sum(Xs, #=, X); product_list(Xs, 1, X)), valid_row(Rest).

%% sum_list([], P, P).
%% sum_list([X|Xs] , Acc, P) :- 
%%     Acc1 #= X + Acc, 
%%     sum_list(Xs, Acc1, P).

%% product_list(+List, +Acc, -Product)
%% calculate the product of items in the list
%% product_list([], P, P).
%% product_list([X|Xs] , Acc, P) :- 
%%     between(1, 9, X), 
%%     Acc1 is X * Acc, 
%%     product_list(Xs, Acc1, P).

product_list([], P, P).
product_list([X|Xs] , Acc, P) :- 
    Acc1 #= X * Acc, 
    product_list(Xs, Acc1, P).

%% product_list([], P, P).
%% product_list([X|Xs] , Acc, P) :- 
%%     Xs ins 1..9, 
%%     Acc1 #= X * Acc, 
%%     product_list(Xs, Acc1, P).

bound_value([]).
bound_value([X|Xs]) :- indomain(X), bound_value(Xs).

%% valid_row([[28, 7, 1, 4]]).
%% Puzzle = [[0,14,10,35],[14,_,_,_],[15,_,_,_],[28,_,1,_]], puzzle_solution(Puzzle).
%% Puzzle = [[0,23,23,40,22],[840,5,_,_,_],[315,_,_,1,7],[120,2,_,_,_],[560,7,8,2,_]], puzzle_solution(Puzzle).
%% [[-1, 3, 3], [3, 1, 2], [3, 2, 1]]
