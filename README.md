# Sudoku-Solver
This repository contains all the source code for COMP30020 Declarative Programming project 2.
## Overview
You will write Prolog code to solve maths puzzles. Your program should supply a predicate **puzzle_solution(Puzzle)** that holds when Puzzle is the representation of a solved maths puzzle.
## Marks
### Correctness and Quality of guesses
 - Marks: 70 / 70
### Quality of code
- Marks: 23 / 30
  - 5 / 5 Quality of file-level documentation, including authorship
  - 4 / 5 Quality of predicate-level documentation
  - 4 / 5 Readability of code (lines not wrapped, good, consistent layout)
  - 3 / 5 Understandability of code (good choice of names, no redundant comments, well organised)
  - 4 / 5 Appropriate abstraction (no chunks of repeated code, no really long clauses, good types)
  - 3 / 5 Good use of logic programming paradigm
- Assessment Criteria
  - 5 = practically flawless
  - 4 = very good, but not perfect
  - 3 = passable, but not great
  - 2 = unsatisfactory, but on the right track
  - 1 = very poor
  - 0 = no effort
## Comments from marker
- all comments before functions. No comments should exist within code
- **valid_diagonal/3** - You need to explain each of parameters, and how this function is working, and what's returned. Also, should include in what mode your each function works. If it's helper for someone, specify it
- **index/4** - bad function name
- **assign_value/1** - bad function name
- overall: I see some of your efforts using built-in functions. Try more, e.g. bagof, setof, fold, etc. Do more research.