#!/usr/bin/sbcl --script

(in-package :common-lisp)
(compile-file "tetris.lisp")
(load "tetris.fasl")
;;(load "tetris.lisp")
(curses::run)








