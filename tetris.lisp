


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
   (shape
    :initarg :shape
    :accessor shape)
   (state
    :initarg :state
    :accessor state)))






;;#<STANDARD-CLASS TETRIS::PIECE>

;; flat inherits from piece 
(defclass flat (piece)
  ())

(defun make-flat (x y)
  (make-instance 'flat       :x x
			     :y y
			     :shape 'flat
			     :state 1))







(defparameter p1 (make-flat 2 3))

(defparameter p2 (make-flat 0 0))

(defparameter p3 (make-flat 4 5))

;;(defun flat?(p) (eq 'flat (shape p)))

;; tests ....
(x p1)

(y p1)

(shape p1)

(state p1)


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


(defun any-squares-list-are-x-y( xs x-y)
  (cond
   ((null xs) nil)
   ((equalp (car xs) x-y) x-y)
   (t (any-squares-list-are-x-y (cdr xs) x-y))))


;; conflict-p specialised to flat pieces 
(defmethod conflict-p((p piece) x-y)
  (let ((squares (realise p)))
    (any-squares-list-are-x-y squares x-y)))


(realise p1)
;;((0 3) (1 3) (2 3) (3 3))

;; expect all squares above cause a conflict , except square (5 5) which is not in conflict
(mapcar (lambda (xy) (conflict-p p1 xy)) '((0 3)(1 3)(2 3)(3 3)(5 5)))
;;((0 3) (1 3) (2 3) (3 3) NIL)

;; (defmethod copy((p flat-piece))  
;;   (make-instance 'flat-piece
;; 		 :x (x p)
;; 		 :y (y p)
;; 		 :shape 'flat
;; 		 :state (state p)))

;; side effects - moving the piece around the board
(defmethod left((p piece))
  (setf (x p) (- (x p) 1)))

(defmethod right((p piece))
  (setf (x p) (+ (x p) 1)))

(defmethod down((p piece))
  (setf (y p) (- (y p) 1)))

(defmethod rotate-right((p flat))
  (let ((n (state p)))
    (cond
      ((= n 1) (setf (state p) 2))
      ((= n 2) (setf (state p) 1)))))

(defmethod rotate-left((p flat))
  (rotate-right p))

(defmethod view((p piece))
  (format t "x : ~a , y : ~a , shape : ~a , state : ~a , reals : ~a~%"
	  (x p)
	  (y p)
	  (shape p)
	  (state p)
	  (realise p)))


;; -------------------------------------------------------
;; every piece has
;;
;;  class
;;  type
;;   x
;;   y
;;   state


;; flat
;; box
;; elbow
;; left-bend
;; right-bend
;; junction

;; ---------------- box --------------------------------------
;; boxes only have one shape
;;
;; box  x o   thats it!
;;      x x
;;

;; flat inherits from piece 
(defclass box (piece)
  ())

(defun make-box(x y)
  (make-instance 'box :x x :y y :shape 'box :state 1))


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
  t)

(defmethod rotate-left((p box))
  t)


;;------------------------------------------------------------















   


   
