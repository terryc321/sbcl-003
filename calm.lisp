


(load "bootstrap.lisp")
(defparameter message "this is my message to the world")
(test-c-call::revhi message)

(format t "message = ~a ~%" message)
