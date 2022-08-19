
;; reasoning
;; used setf -- should we eliminate this from code
;;
;; provably correct implementation ?
;;

(defpackage "CURSES"
  (:use "CL" "CL-USER" "SB-ALIEN"))

(in-package "CURSES")

(load-shared-object "/usr/lib/x86_64-linux-gnu/libncurses.so.6.2")

;; try see if we can use refresh from ncurses
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




;; reasoning about objects with mutation becomes impossible
;; but it is possible to use clos without mutation
;; involve extra copying

;; nothing needs doing as elbow doesnt rotate



;; go through tetris.scm originally written in guile to convert to common


;; not really sure about packages , just want a package with common lisp available
(defpackage "TETRIS"
  (:use "CL" "CL-USER"))

;; lets use it then
(in-package "TETRIS")

;; ------------------------ TETRIS PACKAGE  ------------------



;; common lisp nth is zero indexed - mine was based from 1 upwards , 1st item of list (nth 1 xs)
(nth 0 '(a b c))

(nth 1 '(a b c))

(nth 2 '(a b c))

(nth 3 '(a b c))

(defun assoc-value( key obj)
  (second (assoc key obj)))


(assoc 'a '((a b)))

(assoc 'b '((a b)(b c)))

(assoc 'c '((a b)(b c)))

(assoc-value 'a '((a b)))

(assoc-value 'b '((a b)(b c)))

(assoc-value 'c '((a b)(b c)))

(mapcar #'(lambda (f) (funcall f '(a b c d e f g)))
	'(first second third fourth fifth))
;;(A B C D E)

;; (first '(a b c d e f g))
;; (second '(a b c d e f g))
;; (third '(a b c d e f g))
;; (fourth '(a b c d e f g))
;; (fifth '(a b c d e f g))
;; (first '(a b c d e f g))


(defun one-of(xs)
  (let ((len (length xs)))
    (nth (random len) xs)))


;; sanity check 10000 values present
;; array of 6 items 0th index to 5th index , 6th index out of bounds - be array of 7 items not 6
(let ((arr (make-array 6)))
  (loop for i from 1 to 100000 do
    (let ((n (one-of '(0 1 2 3 4 5))))
      (incf (aref arr n))))
  (format t "after 10000 iterations arr = ~a ~%" arr)
  (let ((sum (reduce (lambda (a b)( + a b)) arr))
	(ratios (make-array 6)))
    (format t "sum of items in arr = ~a ~%" sum)
    (map-into ratios (lambda (x)(floor (float (* 100 (/ x sum))))) arr)
    (format t "ratios = ~a ~%" ratios)))

;; map-into destructive but clean map over arrays nice
;; add up values in an array
(reduce (lambda (a b)(+ a b)) #(1 2))

;; -------------------------------------------------------
;; line 72 in tetris.scm

;; test for null? is just null
(null '())
;; cond else becomes cond t
;; #f becomes nil

(defclass person ()
  ((name :accessor person-name
         :initform 'bill
         :initarg :name)
   (age :accessor person-age
        :initform 10
        :initarg :age)))


(defclass piece ()
  ((x
    :initarg :x
    :accessor x)
   (y
    :initarg :y
    :accessor y)
   (state
    :initarg :state
    :accessor state)))


;;#<STANDARD-CLASS TETRIS::PIECE>

;; flat inherits from piece 
(defclass flat (piece)
  ())

(defclass box (piece)
  ())

(defclass elbow (piece)
  ())

(defclass left-bend (piece)
  ())

(defclass right-bend (piece)
  ())

(defclass junction (piece)
  ())

;; ------------------------------------------------------------------
;; class hierachy
;;
;;                      piece 
;; _______________________|____________________________
;;  |      |      |       |                |          |
;; flat   box   elbow    left            right    junction
;;
;;---------------------------------------------------------------------



(dribble (format nil "/home/terry/projects/ffi/sbcl-002/logs/~a.tetris.log" (get-universal-time)))

(trace
;; ----- tetris routines ----
tetris::assoc-value
tetris::one-of
tetris::make-flat 
tetris::make-box 
tetris::make-elbow 
tetris::make-left-bend 
tetris::make-right-bend 
tetris::make-junction 
tetris::any-squares-list-are-x-y
tetris::any-conflicts?
tetris::filter
tetris::tally-row
tetris::move-all-items-down-if-above-row
tetris::tally-and-move
tetris::tetris-square-occupied-p
tetris::tetris-square-empty
tetris::tetris-full-row-p
tetris::tetris-eliminate-row
tetris::tetris-scroll-board-down
tetris::eliminate-completed-rows
tetris::combine-piece-and-board

;; ---- curses routines -----
curses::new-board
curses::initialise-ncurses
curses::cleanup-ncurses
curses::tetris-to-screen-x
curses::tetris-to-screen-y
curses::tetris-put-to-screen
curses::show-board
curses::show-piece
curses::show-piece-and-board
curses::experiment
curses::new-random-top-piece
curses::game-loop
curses::run
)





;; assert x y must be in range on the tetris board between (0,0) and (11,21)

(defun make-flat (x y)
  (assert
  (make-instance 'flat       :x x
			     :y y
			     :state 1))

(defun make-box (x y)
  (make-instance 'box        :x x
			     :y y
			     :state 1))

(defun make-elbow (x y)
  (make-instance 'elbow       :x x
			     :y y
			     :state 1))

(defun make-left-bend (x y)
  (make-instance 'left-bend  :x x
			     :y y
			     :state 1))

(defun make-right-bend (x y)
  (make-instance 'right-bend :x x
			     :y y
			     :state 1))

(defun make-junction (x y)
  (make-instance 'junction       :x x
			     :y y
			     :state 1))

;; ---------------------------------------------------
;; copy constructors
;;
;; ---------------------------------------------------
(defmethod copy((p flat))  
  (make-instance 'flat
		 :x (x p)
		 :y (y p)
		 :state (state p)))

(defmethod copy((p box))  
  (make-instance 'box
		 :x (x p)
		 :y (y p)
		 :state (state p)))

(defmethod copy((p elbow))  
  (make-instance 'elbow
		 :x (x p)
		 :y (y p)
		 :state (state p)))

(defmethod copy((p left-bend))  
  (make-instance 'left-bend
		 :x (x p)
		 :y (y p)
		 :state (state p)))

(defmethod copy((p right-bend))  
  (make-instance 'right-bend
		 :x (x p)
		 :y (y p)
		 :state (state p)))

(defmethod copy((p junction))  
  (make-instance 'junction
		 :x (x p)
		 :y (y p)
		 :state (state p)))

;; ----------------------------------------
(defmethod left((p piece))
  (let* ((c (copy p))
	 (x (x c)))
    (setf (x c) (- x 1))
    c))

(defmethod right((p piece))
  (let* ((c (copy p))
	 (x (x c)))
    (setf (x c) (+ x 1))
    c))

(defmethod down((p piece))
  (let* ((c (copy p))
	 (y (y c)))
    (setf (y c) (- y 1))
    c))



(defun any-squares-list-are-x-y( xs x-y)
  (cond
   ((null xs) nil)
   ((equalp (car xs) x-y) x-y)
   (t (any-squares-list-are-x-y (cdr xs) x-y))))


;; conflict-p specialised to flat pieces 
(defmethod conflict-p((p piece) x-y)
  (let ((squares (realise p)))
    (any-squares-list-are-x-y squares x-y)))

;; --------------------------------------

;; input-output doesnt like to pass object throuhgt reutrns nil

(defmethod view((p piece))
  (format t "x : ~a , y : ~a , state : ~a , reals : ~a~%"
	  (x p)
	  (y p)
	  (state p)
	  (realise p))
  p)


;; --------------------------------------


;; ---------------------------------------

(defmethod realise((p flat))
  (let ((state (state p))
	(x     (x p))
	(y     (y p)))
    (cond
     ((= state 1)
      (list 	`(,(- x 2) ,(- y 0))
		`(,(- x 1) ,(- y 0))
		`(,(- x 0) ,(- y 0))
		`(,(+ x 1) ,(- y 0))))
     ((= state 2)
      (list 	`(,(- x 0) ,(- y 0))
		`(,(- x 0) ,(- y 1))
		`(,(+ x 0) ,(- y 2))
		`(,(+ x 0) ,(- y 3))))
     (t (error "realise-flat")))))


(defmethod rotate-right((p flat))
  (let* ((c (copy p))
	 (n (state c)))
    (setf (state c)
	  (cond
	    ((= n 1) 2)
	    ((= n 2) 1)
	    (t (error "rotate right flat"))))
    c))

(defmethod rotate-left((p flat))
  (rotate-right p))

;; -------------------------------------------------------
(defparameter p1 (make-flat 2 3))

(defparameter p2 (make-flat 0 0))

(defparameter p3 (make-flat 4 5))

;;(defun flat?(p) (eq 'flat (shape p)))

;; tests ....
(x p1)

(y p1)

;;(shape p1)

(state p1)




(realise p1)
;;((0 3) (1 3) (2 3) (3 3))

;; expect all squares above cause a conflict , except square (5 5) which is not in conflict
(mapcar (lambda (xy) (conflict-p p1 xy)) '((0 3)(1 3)(2 3)(3 3)(5 5)))
;;((0 3) (1 3) (2 3) (3 3) NIL)

;; ideally want a generic copy



;; ------------------------------------------------------

(defparameter b1 (make-box 3 5))

(defmethod realise((p box))
  (let ((state (state p))
	(x     (x p))
	(y     (y p)))
    (cond
     ((= state 1)
      (list 	`(,(- x 1) ,(- y 0))
		`(,(- x 0) ,(- y 0))
		`(,(- x 1) ,(- y 1))
		`(,(+ x 0) ,(- y 1))))
     (t (error "boxes only have one state")))))

;; nothing needs doing as box doesnt rotate
(defmethod rotate-right((p box))
  p)

(defmethod rotate-left((p box))
  p)



;;------------------------------------------------------------


(defparameter e1 (make-elbow 3 5))

(defmethod realise((p elbow))
  (let ((state (state p))
	(x     (x p))
	(y     (y p)))
    (cond
     ((= state 1)
      (list 	`(,(- x 1) ,(- y 0))
		`(,(- x 1) ,(- y 1))
		`(,(- x 1) ,(- y 2))
		`(,(+ x 0) ,(- y 2))))
     ((= state 2)
      (list 	`(,(- x 1) ,(- y 1))
		`(,(- x 1) ,(- y 0))
		`(,(+ x 0) ,(- y 0))
		`(,(+ x 1) ,(- y 0))))
     ((= state 3)
      (list 	`(,(- x 1) ,(- y 0))
		`(,(- x 0) ,(- y 0))
		`(,(- x 0) ,(- y 1))
		`(,(+ x 0) ,(- y 2))))
     ((= state 4)
      (list 	`(,(+ x 1) ,(- y 0))
		`(,(+ x 1) ,(- y 1))
		`(,(+ x 0) ,(- y 1))
		`(,(- x 1) ,(- y 1))))
     (t (error "realise-elbow")))))


(defmethod rotate-right((p elbow))
  (let* ((c (copy p))
	 (n (state p)))
    (setf (state c)
	  (cond
	    ((= n 1) 2)
	    ((= n 2) 3)
	    ((= n 3) 4)
	    ((= n 4) 1)
	    (t (error "rotate-right on elbow"))))
    c))


(defmethod rotate-left((p elbow))
  (let* ((c (copy p))
	 (n (state p)))
    (setf (state c)
	  (cond
	    ((= n 1) 4)
	    ((= n 2) 1)
	    ((= n 3) 2)
	    ((= n 4) 3)
	    (t (error "rotate-right on elbow"))))
    c))



;; --------------------------------------------------------------
;; make-left-bend
;; realise
;; rotate-left
;; rotate-right
;;
;; state  1       2      
;;
;;       x o       o x   
;;       x x     x x     
;;         x             
;;

(defparameter left-1 (make-left-bend 3 5))

(defmethod realise((p left-bend))
  (let ((state (state p))
	(x     (x p))
	(y     (y p)))
    (cond
     ((= state 1)
      (list 	`(,(- x 1) ,(- y 0))
		`(,(- x 1) ,(- y 1))
		`(,(- x 0) ,(- y 1))
		`(,(+ x 0) ,(- y 2))))
     ((= state 2)
      (list 	`(,(- x 1) ,(- y 1))
		`(,(- x 0) ,(- y 1))
		`(,(+ x 0) ,(- y 0))
		`(,(+ x 1) ,(- y 0))))
     (t (error "realise-left-bend")))))

(defmethod rotate-right((p left-bend))
  (let* ((c (copy p))
	 (n (state c)))
    (setf (state c)
	  (cond
	    ((= n 1) 2)
	    ((= n 2) 1)
	    (t (error "rotate left-bend"))))
    c))

(defmethod rotate-left((p left-bend))
  (rotate-right p))

;;-------------------------------------------------

;;-------------------------------------------------
;; make-right-bend
;; realise
;; rotate-left
;; rotate-right
;;
;;
;; state    1        2
;;
;;         o x    x o       
;;         x x      x x   
;;         x            
;;
;;


(defparameter right-1 (make-right-bend 3 5))

(defmethod realise((p right-bend))
  (let ((state (state p))
	(x     (x p))
	(y     (y p)))
    (cond
     ((= state 1)
      (list 	`(,(- x 0) ,(- y 2))
		`(,(- x 0) ,(- y 1))
		`(,(+ x 1) ,(- y 1))
		`(,(+ x 1) ,(- y 0))))
     ((= state 2)
      (list 	`(,(- x 1) ,(- y 0))
		`(,(- x 0) ,(- y 0))
		`(,(+ x 0) ,(- y 1))
		`(,(+ x 1) ,(- y 1))))
     (t (error "realise-right-bend")))))


(defmethod rotate-right((p right-bend))
  (let* ((c (copy p))
	 (n (state c)))
    (setf (state c)
	  (cond
	    ((= n 1) 2)
	    ((= n 2) 1)
	    (t (error "rotate right-bend"))))
    c))

(defmethod rotate-left((p right-bend))
  (rotate-right p))


;; ------------------- t junction------------------------------------
;;
;; make-junction
;; realise
;; rotate-left
;; rotate-right
;;
;; 
;; state    1          2        3            4
;;
;;           o         o        o          x o x 
;;         x x       x x x      x x          x 
;;           x                  x             
;;
;; ------------------------------------------------------------------


(defparameter junction-1 (make-junction 3 5))

(defmethod realise((p junction))
  (let ((state (state p))
	(x     (x p))
	(y     (y p)))
    (cond
     ((= state 1)
      (list 	`(,(- x 0) ,(- y 0))
		`(,(- x 0) ,(- y 1))
		`(,(- x 0) ,(- y 2))
		`(,(- x 1) ,(- y 1))))
     ((= state 2)
      (list 	`(,(- x 0) ,(- y 0))
		`(,(- x 1) ,(- y 1))
		`(,(+ x 0) ,(- y 1))
		`(,(+ x 1) ,(- y 1))))
     ((= state 3)
      (list 	`(,(- x 0) ,(- y 0))
		`(,(- x 0) ,(- y 1))
		`(,(- x 0) ,(- y 2))
		`(,(+ x 1) ,(- y 1))))
     ((= state 4)
      (list 	`(,(- x 1) ,(- y 0))
		`(,(+ x 0) ,(- y 0))
		`(,(+ x 1) ,(- y 0))
		`(,(+ x 0) ,(- y 1))))
     (t (error "realise-junction")))))


(defmethod rotate-right((p junction))
  (let* ((c (copy p))
	 (n (state c)))
    (setf (state c)
	  (cond
	   ((= n 1) 2)
	   ((= n 2) 3)
	   ((= n 3) 4)
	   ((= n 4) 1)
	   (t (error "junctions only states are 1 and 2 and 3 and 4"))))
    c))

(defmethod rotate-left((p junction))
  (let* ((c (copy p))
	 (n (state c)))
    (setf (state c)
	  (cond
	    ((= n 1) 4)
	    ((= n 2) 1)
	    ((= n 3) 2)
	    ((= n 4) 3)
	    (t (error "junctions only states are 1 and 2 and 3 and 4"))))
    c))



;; ------------------- ncurses gui code  -------------------------------------

;; iterate over board - see if any piece on board conflicts with piece
;; only like 4 checks to do
(defun any-conflicts?(piece board)
  (cond
    ((null piece) nil)
    (t (destructuring-bind (x y) (car piece)
	 (let ((whos-on-first (aref board x y)))	     
	   (cond
	     ((and (integerp whos-on-first)
		   (> whos-on-first 0))
	      t)
	     (t (any-conflicts? (cdr piece) board))))))))






;;; --------------------------- 712 -------------------------------


                ;; _ _ _ _ _ _ _ _ _ _ _ _

                ;;  T E T R I Z   v  1 . 0

                ;; _ _ _ _ _ _ _ _ _ _ _ _

                ;;
                ;;(0,21)                           (11,21)
                ;;  X  X  X  X  X  X  X  X  X  X  X  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  X  .  .  .  .  .  .  X 
                ;;  X  .  .  .  X  X  .  .  .  .  .  X 
                ;;  X  .  .  .  .  X  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  .  .  .  .  X 
                ;;  X  .  .  .  .  .  .  X  .  .  .  X 
                ;;  X  .  .  .  .  .  .  X  .  .  .  X 
                ;;  X  .  .  .  .  .  .  X  .  .  .  X 
                ;;  X  .  .  .  .  .  .  X  .  .  .  X 
                ;;  X  X  X  X  X  X  X  X  X  X  X  X 
                ;; (0,0)                            (11,0)

                ;;  tetris board is 10 wide  x 20 high
                ;; _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _



(defun filter(fn xs)
  (cond
    ((null xs) xs)
    ((funcall fn (car xs)) (cons (car xs) (filter fn (cdr xs))))
    (t (filter fn (cdr xs)))))


;; test cases ...

(filter #'oddp '(1 2 3 4 5 6 7 8 9 10))
;;(1 3 5 7 9)
(filter #'evenp '(1 2 3 4 5 6 7 8 9 10))
;;(2 4 6 8 10)

(dolist (x '(1 2 3 )) (format t "x = ~a ~%" x))
;; x = 1 
;; x = 2 
;; x = 3 
;; NIL

;; investigate curried functions
;; higher order functions
;; re-usable code
;; lazy functions


;; smaller procedures / functions are easier to debug and reason about
;; compose small routines to solve larger problems



;; keep a tally on how many bits of pieces are on each row
(defun tally-row(y board)
  (length (filter (lambda (sq)
		    (let ((sy (second sq)))
		      (= sy y)))
		  board)))


;; tests

(tally-row 1 '((1 1)(2 1)(3 1)(4 1)(5 1)(6 1)(7 1)(8 1)(9 1)(10 1)))

10

(tally-row 1 '((1 1)(2 1)(3 1)(4 1)(5 1)(6 1)(7 1)(8 1)(9 1)))

9


(defun move-all-items-down-if-above-row(row board)
  (mapcar (lambda (sq)
	    (let ((y (second sq)))
	      (cond
		((> y row) (let ((x (first sq)))
			     (list x (- y 1))))
		(t sq))))
	  board))

(move-all-items-down-if-above-row 1 '((1 5)(1 1)(2 1)(3 1)(4 1)(5 1)(6 1)(7 1)(8 1)(9 1)))
;;((1 4) (1 1) (2 1) (3 1) (4 1) (5 1) (6 1) (7 1) (8 1) (9 1))

(move-all-items-down-if-above-row 0 '((1 1)(2 1)(3 1)(4 1)(5 1)(6 1)(7 1)(8 1)(9 1)))
;;((1 0) (2 0) (3 0) (4 0) (5 0) (6 0) (7 0) (8 0) (9 0))


;; tally a row , if it is full , eliminate it and move all pieces down by 1
(defun tally-and-move(row board)
  (let ((full-row 10))
    (cond
      ((>= row 21) board)
      ((= (tally-row row board) full-row)
       (tally-and-move (+ row 1)
		       (move-all-items-down-if-above-row row board)))
      (t (tally-and-move (+ row 1) board)))))
  

;; this causes a heap exhaustion - hmm .
;;
;; (loop for i from 1 to 10 do
;;   (format t "i = ~A ~%" i)
;;   (setq i (- i 1)))

;; empty square is 
(defvar *empty-tetris-square* " ")


;; not checking x y are valid for board array
;; x y may not even be numbers
;; board may be corrupted
;; .... can of worms ....
(defun tetris-square-occupied-p(board x y)
  (not (tetris-square-empty board x y)))

(defun tetris-square-empty(board x y)
  (equalp *empty-tetris-square* (aref board x y)))


(defun tetris-full-row-p(board y)
  (catch 'know
  (loop for x from 1 to 10 do
    (when (tetris-square-empty board x y)
      (throw 'know nil)))
  t))

(defun tetris-eliminate-row(board y)
  (loop for x from 1 to 10 do
    (setf (aref board x y) *empty-tetris-square*)))

;; can tetris piece be outside the (0,0) to (11,21) inclusive set of valid squares
;; what if we want to have an arbitrary size tetris board
;; multiple falling pieces ?
;; all different colours
;; all different minions gru
;; themed tetris

;; job done
(defun tetris-scroll-board-down(board row)
  (loop for y from (+ row 1) to 21 do
    (loop for x from 1 to 10 do
      (setf (aref board x (- y 1))
	    (aref board x y)))))

;; how could the program go wrong ?
;; out of spec ?
;; like piece wandering off past border of the tetris board (0,0) to (11,21) ?

;; 



;; list of squares '( (1 1)(4 2)(3 4).... )
;; 30 arbitrary number - as long as its bigger than height of the tetris table
;; when row gets completed , it gets eliminated , then everything above gets scrolled down
;;
;; say four rows to be eliminated , ie placed long flat down a single slot 
;; on any particular move , going to remove at most 4 layers . q.e.d.
;; 
(defun eliminate-completed-rows(board)
  (catch 'done
    (let ((y 1))
      (loop
	(cond
	  ((not (< y 22)) (throw 'done board))
	  ((tetris-full-row-p board y)
	   (tetris-eliminate-row board y)
	   (tetris-scroll-board-down board y))
	  (t (incf y)))))))



;; no do while unless use loop macro
;;
;; (let ((y 1))
;;   (do-while (< y 10)
;;     (format t "y = ~a ~%" y)
;;     (incf y)))





;; destructing bind
(defun combine-piece-and-board(piece board)
  (let ((squares (realise piece)))
    (dolist (sq squares)
      (destructuring-bind (x y) sq
	(setf (aref board x y) 2)))))



(defvar *tetris-piece-constructors*
  (list #'make-flat
	#'make-box
	#'make-right-bend
	#'make-left-bend
	#'make-elbow
	#'make-junction))


		 
;;(game)
;; ------------------------------------ bootstrap sbcl ffi ncurses code ----------------

;; get back into the curses packages and do the grunt of the "graphical" (in a 1960's tty terminal ?)
;; to access tetris routines write tetris 2 colons then function or variable after
;; tetris::

;; -------------------- back to CURSES ------------
(in-package "CURSES")

(format t "we survived to here anyhow ...~%")

;; some notion of a clock
(defvar *tick* 0)

;; 
(defvar *ncurses-initialised* nil)

;; win is ncurses WINDOW * pointer
(defparameter win nil)

(defparameter msg 7)

;; generate a new board -- probably a static board
;; if it got setq'd , wonder if calling new-board again would reveal the fact its a static board
;; or is it indeed a fresh board ?

;; make board like a U-shape
;; with an open top  11 by 22   (0,0) to (11,21) inclusive
;; borders at x=0 and x=11
;; border  at y=0
;; no border at y=21 because think pieces dropped onto board and it thinks board is full when its not
;;
;;
;;  x   x
;;  x   x
;;  x x x
;;


;; common lisp has 2 dimension arrays

(defun new-board()
  (let ((magic-width-tetris-board 12)
	(magic-height-tetris-board 22))
    (let ((board (make-array (list magic-width-tetris-board
				   magic-height-tetris-board))))
    (loop for x from 0 to 11 do
	  (setf (aref board x 0) 1))
    (loop for y from 0 to 21 do
      (setf (aref board 0 y) 1)
      (setf (aref board 11 y) 1))
      board)))


    

;; initialise the screen for sbcl
(defun initialise-ncurses()
  (setq win (initscr))
  (clear)
  (raw)
  (noecho)
  (nodelay win t)
  (cbreak)  
  (mvprintw 5 5 "we are the champions !"))

 



;; clean up ncurses -- may need to clr end of line , so it does not trash the terminal on exit
;;
;; fix me bug - trashes terminal after game ends
;;
(defun cleanup-ncurses()
  (clrtoeol)
  (endwin)
  (setq *ncurses-initialised* nil))



(defun tetris-to-screen-x(x)
  (+ (* x 2) 30))

(defun tetris-to-screen-y(y)
  (- 30 y))


;; mvprintw takes Y coordinate first , followed by X coordinate
(defun tetris-put-to-screen(x y str)
  (let ((screen-x (tetris-to-screen-x x))
	(screen-y (tetris-to-screen-y y)))
    (mvprintw screen-y screen-x str)))


;; show-board
;; board runs from 0,0 to 11,21 inclusive
;; 0's 11's are left and right of tetris board
;; 0's 21's are bottom and top of tetris board

;; board is an array
;; piece is a list


(defun show-board(board)
  (loop for y from 0 to 21 do
    (loop for x from 0 to 11 do
      (tetris-put-to-screen x y (aref board x y)))))

(defun show-piece(piece)
  (cond
    ((null piece) t)
    (t (let* ((xy (car piece))
	      (x (car xy))
	      (y (cadr xy)))
	 (tetris-put-to-screen x y X)
	 (show-piece (cdr piece))))))

(defun show-piece-and-board(piece board)
  (show-board board)
  (show-piece piece))


;; test knowledge of prog
(defun experiment()
  (prog ((i 0))
    top
       (setq i (+ i 1))
       (format t "i = ~a ~%" i)
       (when (< i 10)
	 (go top))
     (format t "we fell through , so i guess i is 10 : i = ~a~%" i)))



;; ----------- new-random-top-piece ------------------
(defun new-random-top-piece()
  (let ((x 5)
	(y 20)
	(n (random 6)))
    (funcall (nth n tetris::*tetris-piece-constructors*) x y)))




;; Using goto if you can believe it
(defun game-loop(board)
  (let ((piece (new-random-top-piece)))
    (prog ()
      top
       (show-piece-and-board piece board)
       (incf *tick*)
       (mvprintw 6 5 (format nil "*tick* ~a " *tick*))
       (refresh)
       (when (tetris::any-conflicts? piece board)
	(throw 'game-over t))

      ;; check for key presses 
      (let ((ch (wgetch win)))
	(cond
	  ((= ch (char-code #\q))  (throw 'i-quit-this-horror t)) ;; --- key #\q ------
	  ((= ch (char-code #\s)) ;; press-down -> if blocked -> fix piece + check full rows...
	   (if (tetris::any-conflicts? (tetris::down piece) board) ;; ------------- down !!
	       (progn ;; conflicts down -- fix piece here -- eliminate completed rows and pull down stuff above
		 (setq board (tetris::eliminate-completed-rows (tetris::combine-piece-and-board piece board)))
		 (setq piece (new-random-top-piece))
		 (go top))	      
	       (progn ;; move piece down
		 (setq piece (tetris::down piece))
		 (go top)))) ;; --- key #\s ------
	  ((= ch (char-code #\a)) ;; --- key #\a ----------------- left !!
	   (if (tetris::any-conflicts? (tetris::left piece) board) 
	       (go top) ;; cant go left -- jump to top of loop
	       (progn ;; move piece left !
		 (setq piece (tetris::left piece))
		 (go top)))) ;; ----- key #\a -----
	  ((= ch (char-code #\d)) ;; --- key #\d ------------------ right !!
	   (if (tetris::any-conflicts? (tetris::right piece) board) 
	       (go top) ;; cant go right -- jump to top of loop
	       (progn ;; move piece left !
		 (setq piece (tetris::right piece))
		 (go top)))) ;; ----- key #\d -----
	  ((= ch (char-code #\e)) ;; --- key #\e ----------------- rotate right !!
	   (if (tetris::any-conflicts? (tetris::rotate-right piece) board) 
	       (go top) ;; cant go rotate-right -- jump to top of loop
	       (progn ;; 
		 (setq piece (tetris::rotate-right piece))
		 (go top)))) ;; ----- key #\n -----
	  ((= ch (char-code #\w)) ;; --- key #\w ------------------- rotate left !
	   (if (tetris::any-conflicts? (tetris::rotate-left piece) board) 
	       (go top) ;; cant go rotate-left -- jump to top of loop
	       (progn ;; 
		 (setq piece (tetris::rotate-left piece))
		 (go top)))) ;; ----- key #\m -----

	  (t (go top)))))))






(defun run()
  (unwind-protect
       (progn (initialise-ncurses)
	      (game-loop (new-board)))
    (cleanup-ncurses)))

;; q & a


;; to start the game , call the run procedure 
;;> (run)

(run)




























   


   
