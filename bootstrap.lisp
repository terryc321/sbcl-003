
(compile-file "test.lisp")
(load-shared-object "./demo.so")
;; note - the libncurses.so was 31 bytes long ...sbcl said it was too short
;; maybe it is just a symlink but ls -al didnt show it as such
;;(load-shared-object "/usr/lib/x86_64-linux-gnu/libncurses.so")
;;
;; this loaded ok - no complaints
(load-shared-object "/usr/lib/x86_64-linux-gnu/libncurses.so.6.2")
(load "test.fasl")

;; notice Double colons :: call-cfun fp-test are not exported
(test-c-call::call-cfun)

;;(test-c-call::hi)

(loop for i from 1 to 100 do
  (format t " ~A * 2 = ~a ~% " i (test-c-call::call-fg i)))

;;(test-c-call::fp-test "this is a test to standard output\n")


(loop for i from 1 to 10000 do
  (format t "~a : " (test-c-call::hi "this is my message"))
  (format t "~a ~%" (test-c-call::revhi "this is my message")))


(defparameter a nil)

(setq a (test-c-call::make-abc-struct 1))

(loop for i from 1 to 100 do ;;for i from 1 to 10000 do
      (setq a (test-c-call::inc-all a))
      (format t "abc->a = ~A , ->b =~a , c =~a~%"
	      (slot a 'test-c-call::a)
	      (slot a 'test-c-call::b)
	      (slot a 'test-c-call::c))
      
      ;; (if (= i 50)
      ;; 	  (sb-alien::free-alien a))
      
      )

(sb-alien::free-alien a)
;; lets see what happens with a double freebie


(let ((s ""))
  (loop for i from 0 to 10000 do
    (setq s (concatenate 'string s
			   (format nil "~a" (code-char
					     (+ 97 (random 26))))))
    (format t "s= ~a~%length = ~a : ~a~%"
	    s
	    (length s)
	    (test-c-call::string-length s))))






;; (loop for j from 1 to 1000 do 
;;   (let ((abc (test-c-call::make-abc-struct 1)))
;;     (loop for i from 1 to 10000 do
;;       (setq abc (test-c-call::inc-all abc))
;;       (format t "abc->a = ~A , ->b =~a , c =~a~%"
;; 	      (slot abc 'a)
;; 	      (slot abc 'b)
;; 	      (slot abc 'c)))
;;     (sb-alien:free-alien abc)))




  ;; (format t "~a : " (test-c-call::hi "this is my message"))
  ;; (format t "~a ~%" (test-c-call::revhi "this is my message")))

(test-c-call::empty)
(test-c-call::empty2 "this is a first try")
(test-c-call::empty2 "this is a second try")






;; (compile-file "test.lisp")
;; (load-shared-object "./demo.so")
;; (load "test.fasl")


;; try see if we can use refresh from ncurses
(define-alien-routine clear  int)
(define-alien-routine raw  int)
(define-alien-routine noecho  int)
(define-alien-routine nodelay int
  (w (* int))
  (b boolean))


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


(format t "we survived to here anyhow ...~%")
(defparameter tick 0)
(defparameter initialised nil)
(defparameter win nil)
(defparameter msg 7)

(defun start()
  (setq win (initscr))
  (clear)
  (raw)
  (noecho)
  (nodelay win t)
  (cbreak)  
  (mvprintw 5 5 "we are the champions !")
  (refresh))

(defun finish()
  (endwin))


(defun game-loop()
  (unwind-protect
  (if (not initialised) (start))
  (catch 'done
  (loop
   (incf tick)
   (mvprintw 6 5 (format nil "tick ~a " tick))
   (refresh)

   (let ((ch (wgetch win)))
     (cond
       ((= ch (char-code #\q))
	;; throw toy out pram and quit game loop
	(throw 'done t))
       ((= ch (char-code #\a))
	(incf msg)
	(mvprintw msg 0 "key a pressed !\n"))
       (t nil)))))
    (finish)))

;; q & a


;; do a game loop 
(game-loop)















 
#|
expected output

i = 5
s = another Lisp string
r->x = 20
r->s = a Lisp string
a[0] = 0.
a[1] = 1.
a[2] = 2.
a[3] = 3.
a[4] = 4.
a[5] = 5.
a[6] = 6.
a[7] = 7.
a[8] = 8.
a[9] = 9.

After return from the C function, the Lisp wrapper function should print the following output:

back from C function

And upon return from the Lisp wrapper function, before the next prompt is printed, the Lisp read-eval-print loop should print the following return values:

10
"a C string"
|#


