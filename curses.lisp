

;; highly impressed at common lisp ffi ability to get this working with just these headers

;; even more impressed i managed to make it work.



(defpackage "CURSES"
  (:use "CL" "CL-USER" "SB-ALIEN"))

(in-package "CURSES")

(load-shared-object "/usr/lib/x86_64-linux-gnu/libncurses.so.6.2")

(define-alien-routine clear  int)

(define-alien-routine raw  int)

(define-alien-routine noecho  int)

(define-alien-routine nodelay int
  (w (* int))
  (b boolean))


(define-alien-routine clrtoeol  int)

(define-alien-routine cbreak  int)

(define-alien-routine wgetch  int
  (w (* int)))

(define-alien-routine refresh  int)

(define-alien-routine initscr  (* int))

(define-alien-routine endwin  int)

(define-alien-routine mvprintw
  int
  (y int)
  (x int)
  (str c-string))



