
%% import required library to use transpose/2
:- ensure_loaded(library(clpfd)).


%% puzzle_solution(Puzzle)

%% check diagonal

%% valid_diagonal(Puzzle) :- length(Puzzle, N), valid_diagonal(Puzzle, X, N).
%% valid_diagonal([List|Rest], X, 1) :- .
%% valid_diagonal([List|Rest], X, N) :- 



%% chect that all the rows are valid
valid_row([[X|Xs]|Rest]) :- sum_list(Xs, 0, X), valid_row(Rest).

%% check that all hte columns are valid
valid_column(Puzzle) :- transpose(Puzzle, Transpose), valid_row(Transpose).

%% calculate the sum of a list
sum_list([], S, S).
sum_list([X|Xs], Acc, S) :- 
	Acc1 is X + Acc,
    sum_list(Xs, Acc1, S).


