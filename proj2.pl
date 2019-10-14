% File    : proj2.pl
% Author  : Liguo Chen
% Purpose : An implementation of the program that solves math puzzles.


%---------------------------------------------------------------------------%
%---------------------------- Required Libraray ----------------------------%
%---------------------------------------------------------------------------%

% import required library to use transpose/2
:- ensure_loaded(library(clpfd)).

%---------------------------------------------------------------------------%
%------------------------------ Main Predicate -----------------------------%
%---------------------------------------------------------------------------%
% ddddd
puzzle_solution([Heading|Rest]) :- 
    transpose([Heading|Rest], [_|TRest]), 
    valid_digit(Rest), 
    valid_digit(TRest), 
    valid_row(Rest), 
    valid_row(TRest), 
    valid_diagonal([Heading|Rest]), 
    append([Heading|Rest], Vars), 
    asign_value(Vars).

%---------------------------------------------------------------------------%
%----------------------------- Helper Predicates ---------------------------%
%---------------------------------------------------------------------------%
% valid_digit(?List)
% List is list of lists, each inner list represents a row in the puzzle
% This predicate checks that all numbers in the list are between 1 and 9, and
% they are all different. For any unbound variables in the list, this
% predicate gives them an appropriate range based on other bound values.
valid_digit([]).
valid_digit([[_|Cells]|Rest]) :- 
    Cells ins 1..9, all_distinct(Cells), valid_digit(Rest).



%% valid_diagonal(-Puzzle)
valid_diagonal(Puzzle) :- 
    length(Puzzle, Len), 
    index(1, 1, Puzzle, X), 
    Padding is Len - 1, 
    valid_diagonal(Puzzle, X, Padding).



%% valid_diagonal(?List, ?X, +N)
valid_diagonal(Puzzle, X, Padding) :- 
    length(Puzzle, Len), 
    Index is Len - Padding, 
    ( Padding =:= 1 ->
        index(Index, Index, Puzzle, X)
    ;   Padding1 is Padding - 1, 
        index(Index, Index, Puzzle, X), 
        valid_diagonal(Puzzle, X, Padding1)
    ).



% index(+ColumnNumber, +RowNumber, +List, -Item)
index(ColumnNumber, RowNumber, List, Item) :- 
    nth0(RowNumber, List, Row), nth0(ColumnNumber, Row, Item).



% valid_row(?List)
%% valid_row([]).
%% valid_row([[Heading|Row]|Rest]) :- 
%%     (sum(Row, #=, Heading); product_list(Row, 1, Heading)), valid_row(Rest).

valid_row(Rows) :- maplist(check_valid_row, Rows).

check_valid_row([Heading|Row]) :- 
    sum(Row, #=, Heading)
    ;
    product_list(Row, 1, Heading).


% product_list(+List, +Accumulator, -Product)
%% In this mode, given a list of number and the initial accumulator, this
%% predicate calcualtes the product of all the numbers in the list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% product_list(-List, +Accumulator, +Product)
%% In this mode, given the initial accumulator and the product of all the
%% numbers in the list, this predicate tries to find values for unbound
%% variables in the list, or give them a range if there are multiple solutions
product_list([], P, P).
product_list([X|Xs] , Acc, P) :- 
    Acc1 #= X * Acc, 
    product_list(Xs, Acc1, P).

% asign_value(?List)
% This predicate asign values to unbound elements in the List
% based on each element's own range restriction
asign_value(List) :- maplist(indomain, List).
