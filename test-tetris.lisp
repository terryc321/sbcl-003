
;; tests for tetris.lisp
;; two packages in tetris.lisp
;;   :tetris package
;;   :curses package

;; lets get quicklisp 5am up and running

(quicklisp:quickload :fiveam)

(defpackage :test-tetris
  (:use :common-lisp :it.bese.fiveam))

(in-package :test-tetris)

(defun add-2(n) (+ n 2))
(defun add-4(n) (+ n 4))

(test add-2
      "Test the ADD-2 function" ;; a short description
      ;; the checks
      (is (= 2 (add-2 0)))
      (is (= 0 (add-2 -2))))


;; run a test
(run 'add-2)

;; explain the run
(explain! (run 'add-2))

;; run and explain = run!
(run! 'add-2)


;; test-suite
(def-suite example-suite :description "The example test suite.")
(in-suite example-suite)

(test add-4
      (is (= 0 (add-4 -4))))

(run! 'add-4)

;; run test suite
(run! 'example-suite)

;; redefined test now so its in example-suite of tests
(test add-2
      "Test the ADD-2 function"
      (is (= 2 (add-2 0)))
      (is (= 0 (add-2 -2))))

(run! 'example-suite)

;; 3 tests run - 1 from add-4 , 2 from add-2

;; add a failing test
(test add-2 "Test the ADD-2 function"
      (is (= 2 (add-2 0)))
      (is (= 0 (add-2 -2)))
      (is (= 0 (add-2 0))))

(run! 'example-suite)


(defun dummy-add (a b)
  (+ a b))


(defun dummy-strcat (a b)
  (concatenate 'string a b))





(test dummy-add
      (for-all ((a (gen-integer))
		(b (gen-integer)))
	       ;; assuming we have an "oracle" to compare our function results to
	       ;; we can use it:
	       (is (= (+ a b) (dummy-add a b)))
	       ;; if we don't have an oracle (as in most cases) we just ensure
	       ;; that certain properties hold:
	       (is (= (dummy-add a b)
		      (dummy-add b a)))
	       (is (= a (dummy-add a 0)))
	       (is (= 0 (dummy-add a (- a))))
	       (is (< a (dummy-add a 1)))
	       (is (= (* 2 a) (dummy-add a a)))))

(test dummy-strcat
      (for-all ((result (gen-string))
		(split-point (gen-integer :min 0 :max 10000)
                             (< split-point (length result))))
	       (is (string= result (dummy-strcat (subseq result 0 split-point)
						 (subseq result split-point))))))

(test random-failure
      (for-all ((result (gen-integer :min 0 :max 1)))
	       (is (plusp result))
	       (is (= result 0))))



(gen-float)
;;#<CLOSURE (LAMBDA () :IN GEN-FLOAT) {1005A906AB}>

(funcall (gen-float))
;;9.220082e37

(funcall (gen-integer :max 27 :min -16))
;;26

;; or again, gen-string, gen-list, gen-tree, gen-buffer, gen-character.
;; And we have a function to run 100 checks, taking each turn a new value from the given generators: for-all:

(test randomtest
  (for-all ((a (gen-integer :min 1 :max 10))
            (b (gen-integer :min 1 :max 10)))
    "Test random tests."
    (is (<= a b))))


(run! 'example-suite)

;; ------------------------ START of TeTris TesTs Sweet ----------------

;; test-suite
(def-suite tetris-suite-1 :description "tetris-suite-1.")
(in-suite tetris-suite-1)


;; make it equalp so greatest chance of winning out
(defun one-of(xs)
  (let* ((rnd (random (length xs)))
	 (pick (nth rnd xs)))
    (if (not (member pick xs :test #'equalp))
	(error "one-of picked something not in list given")
	pick)))


(test one-of-1
      "Test the ONE-OF function" ;; a short description
      ;; the checks
      (is (eq 'a (one-of '(a))))
      (is (not (eq 'c (one-of '(a b))))))


;;      (nth (random len) xs))))

;; (nth 0 '())

;; one-of xs
;; if xs is nil , length len is 0 ,
;; (random 0) error
;; ;;



(run! 'tetris-suite-1)


(get-universal-time)



