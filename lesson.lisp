









         T E T R I S    Transition Chart  @ Aug 2022
	     
 state  prev cur  next   
--------------------------------------------------------
D1  0:    1   0   1       -2 0 -1 0 0 0 1 0  brk

    1:    0   1   0      0 0 0 -1 0 -2 0 -3 end
---------------------------------------------------------
D2  2:     2  2   2       -1 0  0 0  -1 -1 0 -1  end
---------------------------------------------------------
D3  3:    6   3   4        -1 0 -1 -1 -1 -2 0 -2  brk

    4:    3   4   5        -1 -1 -1 0 0 0 1 0 brk

    5:    4   5   6        -1 0 0 0 0 -1 0 -2     brk

    6:    5   6   3        1 0 1 -1 0 -1 -1 -1 end
-----------------------------------------------------------
D4  7:    10   7   8        1 0 1 -1 1 -2 0 -2  brk

    8:    7   8   9       -1 0 -1 -1 0 -1 1 -1 brk
		      
    9:    8   9   10      0 0 1 0 0 -1 0 -2  brk

   10:    9   10  7        -1 0 0 0 1 0 1 -1  end
--------------------------------------------------------
D5  11:  12    11  12       -1 0 -1 -1 0 -1 0 -2  brk

    12:  11   12  11         -1 -1 0 -1 0 0 1 0 end
---------------------------------------------------------
D6  13:  14   13  14        0 -2 0 -1 1 -1 1 0  brk

    14:  13   14  13        -1 0 0 0 0 -1 1 -1 end
---------------------------------------------------------
D7  15:  19   15  16         0 0 0 -1 0 -2 -1 -1  brk

    16:  15   16 17         0 0 -1 -1 0 -1 1 -1  brk
	 
    17:  16   17  18          0 0 0 -1 0 -2 1 -1  brk

    18:  17   18  19         -1 0 0 0 1 0 0 -1 end
-----------------------------------------------------------








if let D1 be (defun ?name? obj : extract s : returns a list of squares based on x y
know each square based off x y , just put offsets
each list of squares is uniform 4 squares for every modification
if only 2 entries , know s 1 ? or s 2 ?
       
D1 is given an object in a certain state s , knowing a base of x , y , then compute the 4 squares the
object is occupying.  if 4 states know s 1 ? s 2 ? s 3 ? s 4 ?

	               4 coords                                      4 coords
D                        8 vals                                        8 vals

D1 has only 2 states - that is a flip flop , in state 1 s 1 ? no then its in state 2 s 2 , easy

;; ------------------------------------------------------------------------------------------------
;; after compression pass 1 - 
(defun ?name (obj)((= s 1)(list `(,(- x 2) ,y) `(,(- x 1) ,y) `(,x ,y) `(,(+ x 1) ,y)))
  (t (list      `(,x ,y) `(,x ,(- y 1)) `(,x ,(- y 2)) `(,x ,(- y 3)))))
(defun turn-right(p)  (if (= n 1) 2 1))(defun turn-left(p)   (turn-right p))

(defun ?name (obj) (list `(,(- x 1) ,y) `(,x ,y) `(,(- x 1) ,(- y 1))	`(,x ,(- y 1))))
(defun rotate-right(p) p)(defun rotate-left(p) p)

(defun ?name (obj) ((= s 1) (list `(,(- x 1) ,y) `(,(- x 1) ,(- y 1)) `(,(- x 1) ,(- y 2))  `(,x ,(- y 2))))
  ((= s 2) (list `(,(- x 1) ,(- y 1)) `(,(- x 1) ,y) `(,x ,y)  `(,(+ x 1) ,y)))
  ((= s 3) (list `(,(- x 1) ,y) `(,x ,y) `(,x ,(- y 1))  `(,x ,(- y 2))))
  (t       (list `(,(+ x 1) ,y) `(,(+ x 1) ,(- y 1)) `(,x ,(- y 1))  `(,(- x 1) ,(- y 1)))))
(defun rotate-right(p)  (mod (+ n 1) 4))(defun rotate-left(p) (cond ((= n 1) 4)((= n 2) 1)((= n 3) 2)(t 3)))

(defun ?name (obj)  ((= s 1) (list `(,(- x 1) ,y) `(,(- x 1) ,(- y 1)) `(,x ,(- y 1)) `(,x ,(- y 2))))
  (t       (list `(,(- x 1) ,(- y 1)) `(,x ,(- y 1)) `(,x ,y) `(,(+ x 1) ,y))))
(defun rotate-right(p) (mod (+ n 1) 2))(defun rotate-left(p)  (rotate-right p))

(defun ?name?(p)  ((= s 1) (list `(,x ,(- y 2)) `(,x ,(- y 1)) `(,(+ x 1) ,(- y 1)) `(,(+ x 1) ,y)))
  (t       (list `(,(- x 1) ,y) `(,x ,y) `(,x ,(- y 1)) `(,(+ x 1) ,(- y 1)))))
(defun rotate-right(p) (mod (+ n 1) 2)) (defun rotate-left(p)  (rotate-right p))

(defun ?name? (cond ((= s 1)  (list `(,x ,y) `(,x ,(- y 1)) `(,x ,(- y 2)) `(,(- x 1) ,(- y 1))))
	  ((= s 2)  (list `(,x ,y) `(,(- x 1) ,(- y 1))	`(,x ,(- y 1)) `(,(+ x 1) ,(- y 1))))
	  ((= s 3)  (list `(,x ,y) `(,x ,(- y 1)) `(,x ,(- y 2)) `(,(+ x 1) ,(- y 1))))
	  (t        (list `(,(- x 1) ,y) `(,x ,y) `(,(+ x 1) ,y) `(,x ,(- y 1))))))
(defun rotate-right(p) (mod (+ n 1) 4))(defun rotate-left(p) (cond ((= n 1) 4) ;; ok  (mod (- 4+ n+1) 4)  ??
			    ((= n 2) 1) ((= n 3) 2)(t 3)))
;;------------------------------------------------------------------------------------------------------




idea -if we want to think abstractly about something - remove the ability to talk about it
think like a computer compressing data into the bare minimum, then

thinking macros

functions at moment are
(1)  ?name? takes ?something?  is it 1 thing ? box
is it 2 thing ? s 1 ? or s 2 ? 2 bends 
is it a 4 thing ? s 1 ? s 2 ? s 3 ? s 4? elbow + junction
asks if it is in s 1 ? returns a list of x y things 
or otherwise  in s 2? in s 3 ? or otherwise 
(2) ?clockwise ? rotate
(3) ?anti-clockwise ? rotate+-
( these --> (4) ?down? (5) ?left? (6) ?right? <-- work the same

	rotation states 
	r0                : no change == box
	r1 , r2           : flip/flop
	r1 , r2 , r3 , r4 : 

	


;; reasoning
;; used setf -- should we eliminate this from code
;;
;; provably correct implementation ?
;;
;; try see if we can use refresh from ncurses

;; what is the essence ?

;; elbow 4 states
;; junction 4 states
;; other-bend 2 states
;; bend 2 states
;; flat 2 states
;; box  1 states

(defparameter left-1 (make-left-bend 3 5))

;;-------------------------------------------------
;; make-right-bend
;; realise
;; rotate-left
;; rotate-right
;;
;;

;;-------------------------------------------------
;; state    1        2             -1 < x < +1    2 < y
;;
;;         o x    x o       
;;         x x      x x    4 squares
;;         x            
;;
;;
(defparameter right-1 (make-right-bend 3 5))


  

;; ------------------- t junction------------------------------------
;;
;; make-junction             -1 < x < 1    2 < y 
;; realise
;; rotate-left
;; rotate-right
;; 4 squares
;; 
;; state    1          2        3            4
;;
;;           o         o        o          x o x 
;;         x x       x x x      x x          x 
;;           x                  x             
;;
;; ------------------------------------------------------------------
(defparameter junction-1 (make-junction 3 5))

;; --------------------------------------------------------------
;; state  1       2      
;;
;;       x o       o x           2 < y    1 < x < 1
;;       x x     x x     
;;         x
;;
;; 4 squares

;;	
;;  ------- elbow ---------    -1 < x < 1   ,  2 < y 
;;
;; state   1           2            3           4
;;
;;        x .         x . x      x .            . x   
;;        x           x            x          x x x
;;        x x                      x
;;
;; state   1           2            3           4
;;
;;      . x          x . x        . x        x .    
;;        x              x        x          x x x
;;      x x                       x
;;



;; 4 squares
;;
;;


;; --------- box -----------
;;
;; state   1       1 < x    1 < y
;;
;;          x .
;;          x x
;; 
;; 4 squares
;;
;;
;; ---------------------------------------
;;
;;  state   1             2      2 < x    3 < y
;;
;;                         
;;       x x o x          o
;;                        x
;;                        x 
;;                        x
;;
;; 4 squares
;;
;; --------------------------------------



;; -------------------------------------------------------
(defparameter p1 (make-flat 2 3))

(defparameter p2 (make-flat 1 1))

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


(defparameter e1 (make-elbow 3 5))

(defmethod realise((p elbow))
  (let ((state (state p))
	(x     (x p))
	(y     (y p)))

    ;; --------------------------------------------------------

    


;; reasoning about objects with mutation becomes impossible
;; but it is possible to use clos without mutation
;; involve extra copying
;; nothing needs doing as elbow doesnt rotate
;; go through tetris.scm originally written in guile to convert to common
;; not really sure about packages , just want a package with common lisp available
;; lets use it then


;; now that we tried to tackle the project tetris , tried with object orientated design approach and
;; failed miserably.
;;
;; lets get back to our roots
;; thing ACL2 common lisp
;; theorem proving and those kinds of standards.
;; logical inference and deduction.


here is an example - a four in a row piece on the tetris board


;; ---------------------------------------
;;
;;  state   1             2
;;
;;                         
;;       x x o x          o
;;                        x
;;                        x 
;;                        x
;; --------------------------------------
(defmethod realise((p flat))
  (let ((state (state p))
	(x     (x p))
	(y     (y p)))
    (cond
     ((= state 1)
      (list 	`(,(- x 2) ,(- y 0))   ;; ok
		`(,(- x 1) ,(- y 0))
		`(,(- x 0) ,(- y 0))
		`(,(+ x 1) ,(- y 0))))
     ((= state 2)
      (list 	`(,(- x 0) ,(- y 0))
		`(,(- x 0) ,(- y 1))
		`(,(+ x 0) ,(- y 2))
		`(,(+ x 0) ,(- y 3))))
     (t (error "realise-flat")))))



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



;; ;; sanity check 10000 values present
;; ;; array of 6 items 0th index to 5th index , 6th index out of bounds - be array of 7 items not 6
;; (let ((arr (make-array 6)))
;;   (loop for i from 1 to 100000 do
;;     (let ((n (one-of '(0 1 2 3 4 5))))
;;       (incf (aref arr n))))
;;   (format t "after 10000 iterations arr = ~a ~%" arr)
;;   (let ((sum (reduce (lambda (a b)( + a b)) arr))
;; 	(ratios (make-array 6)))
;;     (format t "sum of items in arr = ~a ~%" sum)
;;     (map-into ratios (lambda (x)(floor (float (* 100 (/ x sum))))) arr)
;;     (format t "ratios = ~a ~%" ratios)))
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



(defun in-bounds(x y)
  (and (integerp x)
       (integerp y)
       (>= x 1)
       (<= x 10)
       (>= y 1)
       (<= y 20)))


       


;; assert x y must be in range on the tetris board between (0,0) and (11,21)
(defun make-flat (x y)
  (assert (in-bounds x y))
  (make-instance 'flat       :x x
			     :y y
			     :state 1))

(defun make-box (x y)
  (assert (in-bounds x y))
  (make-instance 'box        :x x
			     :y y
			     :state 1))

(defun make-elbow (x y)
  (assert (in-bounds x y))
  (make-instance 'elbow       :x x
			     :y y
			     :state 1))

(defun make-left-bend (x y)
  (assert (in-bounds x y))
  (make-instance 'left-bend  :x x
			     :y y
			     :state 1))

(defun make-right-bend (x y)
  (assert (in-bounds x y))
  (make-instance 'right-bend :x x
			     :y y
			     :state 1))

(defun make-junction (x y)
  (assert (in-bounds x y))
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



