% File    : proj2.pl
% Author  : Liguo Chen
% Purpose : An implementation of the program that solves maths puzzles.
% 
%---------------------------------------------------------------------------%
% 
% The following detail of the problem is taken from the project specification
% of Project 2, COMP30020-Declaarative Programming, Semester 2, 2019
% authored by Dr. Peter Schachte
% 
% The problem to be solved by the code in this file:
%
% A maths puzzle is a square grid of squares, each to be filled in with a 
% single number satisfying these constraints:
% 
% 0. all numbers filled in must be 1-9.
% 1. each row and each column contains no repeated digits;
% 2. all squares on the diagonal line from upper left to lower right 
%    contain the same value; and
% 3. the heading of reach row and column (leftmost square in a row and 
%    topmost square in a column) holds either the sum or the product of 
%    all the digits in that row or column
% 
% When the puzzle is originally posed, most or all of the squares will be 
% empty, with the headings filled in. The goal of the puzzle is to fill in 
% all the squares according to the rules. A proper maths puzzle will have 
% at most one solution.
% 
% Here is an example puzzle as posed (left) and solved (right) :
% 
%          ---------------------         ---------------------
%          |    | 14 | 10 | 35 |         |    | 14 | 10 | 35 |
%          ---------------------         ---------------------
%          | 14 |    |    |    |         | 14 |  7 |  2 |  1 |
%          ---------------------         ---------------------
%          | 15 |    |    |    |         | 15 |  3 |  7 |  5 |
%          ---------------------         ---------------------
%          | 28 |    |  1 |    |         | 28 |  4 |  1 |  7 |
%          ---------------------         ---------------------
% 
% The puzzle is represented as a 2D list in prolog.
% The above two puzzles can be represented as follows:
% 
% Puzzle_left = [[0, 14, 10, 35],         Puzzle_right = [[0, 14, 10, 35], 
%                [14, _, _, _],                           [14, 7, 2, 1], 
%                [15, _, _, _],                           [15, 3, 7, 5], 
%                [28, _, 1, _]].                          [28, 4, 1, 7]].
%
%---------------------------------------------------------------------------%
%
% How my program solve the problem:
% 
% First, the transpose of the Puzzle, called TPuzzle, is obtained by using
% transpose/1 from CLP(FD) library. Then the Puzzle is validated against 
% constraint 0, 1, 2 and 3 in order. At last, unbound variables in the 
% Puzzle are assigned a value based on each variable's own range constraint.
%                                 
%---------------------------------------------------------------------------%
%---------------------------- Required Libraray ----------------------------%
%---------------------------------------------------------------------------%

:- ensure_loaded(library(clpfd)).

%---------------------------------------------------------------------------%
%------------------------------ Main Predicate -----------------------------%
%---------------------------------------------------------------------------%

% puzzle_solution(+List)
% puzzle_solution/1 takes a 2D list, which represents the maths puzzle as
% explained in the "introduction" section of this file, and holds when the
% List is the representation of a solved  maths puzzle.
puzzle_solution([Heading|Rest]) :-
    transpose([Heading|Rest], [_|TRest]), 
    
    % ensure that constraint 0 and 1 are not violated for all rows
    valid_digit(Rest),
    
    % ensure that constraint 0 and 1 are not violated for all columns
    valid_digit(TRest),
    
    % ensure that constraint 2 is not violated
    valid_diagonal([Heading|Rest]),
    
    % ensure that constraint 3 is not violated for all rows
    valid_row(Rest), 
    
    % ensure that constraint 3 is not violated for all columns
    valid_row(TRest),

    % take elements in each sub-list and put them into one big list
    append([Heading|Rest], Vars), 
    
    % bind each element to a valud based on its own range constraint
    asign_value(Vars).

%---------------------------------------------------------------------------%
%----------------------------- Helper Predicates ---------------------------%
%---------------------------------------------------------------------------%

% This predicate is used to check that puzzle solution is not violating
% constraint 0 and 1
% 
% valid_digit(+Lists)
% Lists is list of lists, each inner list represents a row in the puzzle
% valid_digit/1 holds when check_valid_digit/1 holds for all elements in 
% the List
valid_digit(Lists) :- maplist(check_valid_digit, Lists).

% This predicate is used to check that puzzle solution is not violating
% constraint 2
% 
% valid_diagonal(+List)
% List is a list of lists, each inner list represents a row in the puzzle
% valid_diagonal/1 holds when all elements on the diagonal are the same
valid_diagonal(List) :- 
    length(List, Len),
    % get the first element on the diagonal
    index(1, 1, List, X), 
    Padding is Len - 1,
    % unify all numbers on the diagonal
    valid_diagonal(List, X, Padding).

% This predicate is used to check that puzzle solution is not violating
% constraint 3
% 
% valid_row(+List)
% valid_row/1 takes a list and holds when check_valid_row/1 holds for all
% elements in the List
valid_row(Rows) :- maplist(check_valid_row, Rows).

% check_valid_digit(+List)
% check_valid_digit/1 takes a list of numbers and holds when all numbers in
% the list are between 1 and 9, and they are all different
check_valid_digit([_|Row]) :- 
    Row ins 1..9, 
    all_distinct(Row).

% valid_diagonal(+List, +X, +N)
%  List is a 2D list, and X is the previous element on the diagonal
% valid_diagonal/3 holds when the current eleemnt on the diagonal is the same
% as the previous one
valid_diagonal(Puzzle, X, Padding) :- 
    length(Puzzle, Len), 
    Index is Len - Padding,
    (
        % last element on the diagonal
        Padding =:= 1 ->
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

% check_valid_row(+List)
% check_valid_row/1 takes a list of numbers and holds when the first number is
% either the sum or the product of all the remaining numbers
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

% asign_value(+List)
% asign_value/1 takes a list, and holds when all elements in List are ground.
asign_value(List) :- maplist(indomain, List).
