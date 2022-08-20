
(in-package :common-lisp)

(compile-file "curses.lisp")
(compile-file "tetris.lisp")
(load "curses.fasl")
(load "tetris.fasl")
(tetris::run)

