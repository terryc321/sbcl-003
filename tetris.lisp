


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


;; line 72 in tetris.scm


  












   


   
