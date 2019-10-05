
%% import required library to use transpose/2
:- ensure_loaded(library(clpfd)).


puzzle_solution([Heading|Rest]) :- transpose([Heading|Rest], [_|TRest]), 
                                   valid_digit(Rest), valid_digit(TRest), 
                                   valid_row(Rest), valid_column([Heading|Rest]), 
                                   valid_diagonal([Heading|Rest]).


valid_digit([]).
valid_digit([[_|Cells]|Rest]) :- 
    Cells ins 1..9, all_distinct(Cells), valid_digit(Rest).


%% check diagonal

%% valid_diagonal(+Puzzle)
valid_diagonal(Puzzle) :- length(Puzzle, Len), nth0(1, Puzzle, Row), 
                          nth0(1, Row, X), Padding is Len - 1, 
                          valid_diagonal(Puzzle, X, Padding).

%% valid_diagonal(+List, +X, +N)
valid_diagonal(Puzzle, X, 1) :- length(Puzzle, Len), Index is Len - 1, 
                                get_from_puzzle(Index, Index, Puzzle, X).
valid_diagonal(Puzzle, X, Padding) :- length(Puzzle, Len), 
                                      Index is Len - Padding, 
                                      Padding1 is Padding - 1, 
                                      get_from_puzzle(Index, Index, Puzzle, X), 
                                      valid_diagonal(Puzzle, X, Padding1).

%% get an item from a 2D list using item's coordinate (X, Y)
%% X is the column number and Y is the row number
%% using 0-base index
%% getFromPuzzle(+X, +Y, +List, -Item)
get_from_puzzle(X, Y, List, Item) :- nth0(Y, List, Row), nth0(X, Row, Item).


%% check that all the rows are valid
valid_row([]).
valid_row([[X|Xs]|Rest]) :- (sum(Xs, #=, X); product_list(Xs, 1, X)), 
                            valid_row(Rest).

%% check that all hte columns are valid
valid_column(Puzzle) :- transpose(Puzzle, [_|Rest]), valid_row(Rest).


%% calculate the sum of items in the list
sum_list([], S, S).
sum_list([X|Xs], Acc, S) :- 
	Acc1 is X + Acc,
    sum_list(Xs, Acc1, S).

%% product_list(+List, +Acc, -Product)
%% calculate the product of items in the list
product_list([], P, P).
product_list([X|Xs] , Acc, P) :-
    between(1, 9, X), 
    Acc1 is X * Acc,
    product_list(Xs, Acc1, P).

valid_range([]).
valid_range([X|Xs]) :- valid_range_row(X), valid_range(Xs).
%% valid_range_row([_|Xs]) :- Xs ins 1..9.
valid_range_row([_|Xs]) :- maplist(between(1, 9), Xs). %Xs ins 1..9.
%% valid_diagonal([[1, 2], [2, 1]]).
%% valid_diagonal([[1, 2, 3], [2, 1, 3], [3, 2, 1]).
%% valid_row([[28, 7, 1, 4]]).
%% Puzzle = [[0,14,10,35],[14,_,_,_],[15,_,_,_],[28,_,1,_]], puzzle_solution(Puzzle).
%% [[-1, 3, 3], [3, 1, 2], [3, 2, 1]]