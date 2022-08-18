
;; reasoning
;; used setf -- should we eliminate this from code
;;
;; provably correct implementation
;;


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



;; common lisp nth is zero indexed - mine was based from 1 upwards , 1st item of list (nth 1 xs)
(nth 0 '(a b c))

(nth 1 '(a b c))

(nth 2 '(a b c))

(nth 3 '(a b c))

;;
;; nth is off by one , do we use nth elsewhere in scheme code ?
;;
;; (defun nth
;;   (lambda (n xs)
;;     ;; (display "n = ")
;;     ;; (display n)
;;     ;; (newline)
;;     ;; (display "xs = ")
;;     ;; (display xs)
;;     ;; (newline)
;;     (cond ((null? xs) (error "no car cdr of null"))
;; 	  ((= n 1) (car xs))
;; 	  (#t (nth (- n 1) (cdr xs))))))

;; already defined in common lisp
;;
;; (defun first (lambda (xs) (nth 1 xs)))
;; (defun second (lambda (xs) (nth 2 xs)))
;; (defun third (lambda (xs) (nth 3 xs)))
;; (defun fourth (lambda (xs)(nth 4 xs)))
;; (defun fifth (lambda (xs) (nth 5 xs)))

;; scheme (define (f ...))
;; lisp   (defun f(...))

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

(defun make-flat (x y)
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
     (else (error "realise-junction")))))


(defmethod rotate-right((p junction))
  (let* ((c (copy p))
	 (n (state c)))
    (setf (state c)
	  (cond
	   ((= n 1) 2)
	   ((= n 2) 3)
	   ((= n 3) 4)
	   ((= n 4) 1)
	   (else (error "junctions only states are 1 and 2 and 3 and 4"))))
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
	    (else (error "junctions only states are 1 and 2 and 3 and 4"))))
    c))



;; -------------------  -------------------------------------


(defun margin()
  (format t "                "))


;; iterate over board looking for x y
(defun scan-board( x-y board)
  (cond
   ((null board) nil)
   ((equalp x-y (car board)) x-y)
   (t (scan-board x-y (cdr board)))))


(defun newline()
  (format t "~%"))



;; if square is occupied then put a # otherwise a dot .
(defun show-board-squares( x y board)
  (cond
   ((> x 11) (newline)(margin)(show-board-squares 0 (- y 1) board))
   ((< y 0) (newline))
   (t    
    (cond
     ((scan-board (list x y) board)
      (format t " X "))
     (t
      (format t " . ")))
    (show-board-squares (+ x 1) y board))))


(defun display(msg)
  (format t "~a" msg))




(defun show-board(board)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (margin)(display " T E T R I Z   v  1 . 0") (newline)
  (newline)
  (newline)
  (margin)
  (display "_ _ _ _ _ _ _ _ _ _ _ _")
  (newline)
  (newline)
  (margin)
  (show-board-squares 0 21 board)
  (newline)
  (margin)
  (display "_ _ _ _ _ _ _ _ _ _ _ _")
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
  (newline)
)





;; iterate over board - see if any piece on board conflicts with piece
(defun any-conflicts?(piece board)
  (cond
   ((null board) nil)
   ((conflict-p piece (first board)) (first board))
   (t (any-conflicts? piece (cdr board)))))



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


;;
;; list of squares '( (1 1)(4 2)(3 4).... )
;; 30 arbitrary number - as long as its bigger than height of the tetris table
;;
(defun eliminate-complete-rows(board)
  (let ((arr (make-array 30)))
    (loop (dolist xy board t)
	  (let ((x (first xy))
		(y (second xy)))
	    (if (and (>= x 0) (< x 10
	    (incf (aref arr y))))
    ;; for any entry in arr that equals 10 
  )


(defun combine-piece-and-board(piece board)
  (let ((squares (realise piece)))
    (append squares board)))




;; accept - move piece down continuously until stops
(defun game-ask(piece board)
  (newline)
  (show-board (combine-piece-and-board piece board))
  (newline)
  (display "Your move :> enter S A D N or M ")	      
  (newline)  
  (display "south!(s) : left(a) : right(d) : rot-right(n) : rot-left(m) : fix-in-place(f) : quit(q)> ")
  (let ((response (read)))
    (newline)
    (display "response =[")
    (display response)
    (display "]")
    (cond
     ((or (equalp response 's))
      (display "understood as s for south move")
      (if (any-conflicts? (down piece) board)
	  (progn
	    (newline)(display "cannot go SOUTH - conflicts detected")
	    (game-ask piece board))
	  (game-ask (down piece) board)))
     
     ((or (equalp response 'a))
      (display "understood as a for LEFT")
      (if (any-conflicts? (left piece) board)
	  (progn
	    (newline)(display "cannot go LEFT any more - conflicts detected")
	    (game-ask piece board))
	  (game-ask (left piece) board)))     
      
     ((or (equalp response 'd))
      (display "understood as d for RIGHT")
      (if (any-conflicts? (right piece) board)
	  (progn
	    (newline)(display "cannot go RIGHT any more - conflicts detected")
	    (game-ask piece board))
	  (game-ask (right piece) board)))
     
     ((or (equalp response 'n))
      (display "understood as n for ROTATE rIGHT")
      (if (any-conflicts? (rotate-right piece) board)
	  (progn
	    (newline)(display "cannot rotate RIGHT  - conflicts detected")
	    (game-ask piece board))
	  (game-ask (rotate-right piece) board)))
           
     ((or (equalp response 'm))
      (display "understood as m for ROTATE LEFT")      
      (if (any-conflicts? (rotate-left piece) board)
	  (progn
	    (newline)(display "cannot rotate LEFT - conflicts detected")	    
	    (game-ask piece board))
	  (game-ask (rotate-left piece) board)))

     ((or (equalp response 'f))
      (display "understood as f for COMPLETED MOVE")      
      (if (any-conflicts? (down piece) board)
	  (progn
	    (newline)(display "we are done with this piece !")
	    (game-loop (eliminate-completed-rows (combine-piece-and-board piece board))))
	  (game-ask (rotate-left piece) board)))
     

     ((or (equalp response 'q))
      (display "understood as q for QUIT")
      (error "quit from game - q - "))     
                 
     (t (newline)
	   (display "...not understood ...")
	   (display response)
	   (newline)
	   (game-ask piece board)))))



(defvar *tetris-piece-constructors*
  (list #'make-flat
	#'make-box
	#'make-right-bend
	#'make-left-bend
	#'make-elbow
	#'make-junction))


     
(defun game-loop(board)
  (let ((piece (funcall (one-of *tetris-piece-constructors*)
			   5 20)))
    (cond
     ((any-conflicts? piece board)
      (newline)
      (newline)
      (display "G a m e ... O v e r"))
     (t
      (game-ask piece board)))))


(defun game()
  (let ((board '((0 0)(1 0) (2 0)(3 0)(4 0) (5 0)(6 0)(7 0)(8 0)(9 0)(10 0)(11 0)
		 (0 1)(0 2) (0 3)(0 4)(0 5) (0 6)(0 7)(0 8)(0 9)(0 10)(0 11)(0 12)(0 13)(0 14)(0 15)(0 16)(0 17)(0 18)(0 19)(0 20)(0 21)
		 (11 1)(11 2) (11 3)(11 4)(11 5) (11 6)(11 7)(11 8)(11 9)(11 10)(11 11)(11 12)(11 13)(11 14)(11 15)(11 16)(11 17)(11 18)(11 19)(11 20)(11 21)
		 (0 21)(1 21) (2 21)(3 21)(4 21) (5 21)(6 21)(7 21)(8 21)(9 21)(10 21)(11 21))))
    (game-loop board)))
		 
		 
(game)















   


   
