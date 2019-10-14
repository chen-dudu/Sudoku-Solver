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
% comment for main predicate
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
% valid_digit(?Lists)
% Lists is list of lists, each inner list represents a row in the puzzle
% This predicate checks that all numbers in the list are between 1 and 9, and
% they are all different. For any unbound variables in the list, this
% predicate gives them an appropriate range based on other bound values.
valid_digit(Lists) :- maplist(check_valid_digit, Lists).

check_valid_digit([_|Row]) :- 
    Row ins 1..9, 
    all_distinct(Row).


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
% List is a 2D list, representing a list of rows.
% index/4 holds when Item is the element in the List, at row RowNumber and
% column ColumnNumber. Assume that counting of rows and columns starts at 0.
index(ColumnNumber, RowNumber, List, Item) :- 
    nth0(RowNumber, List, Row), nth0(ColumnNumber, Row, Item).


% valid_row(?List)
valid_row(Rows) :- maplist(check_valid_row, Rows).

check_valid_row([Heading|Row]) :- 
    sum(Row, #=, Heading)
    ;
    product_list(Row, 1, Heading).


% product_list(+List, +Accumulator, -Product)
% product_list(-List, +Accumulator, +Product)
% product_list/3 takes a list and a number as initial accumulator, and it
% holds when the product of all elements in the list is the same as Product
product_list([], P, P).
product_list([X|Xs] , Acc, P) :- 
    Acc1 #= X * Acc, 
    product_list(Xs, Acc1, P).

% asign_value(?List)
% asign_value/1 takes a list, and holds when all elements are ground.
asign_value(List) :- maplist(indomain, List).
