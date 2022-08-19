


;; set up package we are in
(cl:defpackage "TEST-C-CALL" (:use "CL" "SB-ALIEN" "SB-C-CALL"))
(cl:in-package "TEST-C-CALL")

;;; Define the record C-STRUCT in Lisp.
(define-alien-type nil
    (struct c-struct
            (x int)
            (s c-string)))


;; FILE type



;;; Define the Lisp function interface to the C routine.  It returns a
;;; pointer to a record of type C-STRUCT.  It accepts four parameters:
;;; I, an int; S, a pointer to a string; R, a pointer to a C-STRUCT
;;; record; and A, a pointer to the array of 10 ints.
;;;
;;; The INLINE declaration eliminates some efficiency notes about heap
;;; allocation of alien values.
(declaim (inline c-function))
(define-alien-routine c-function
    (* (struct c-struct))
  (i int)
  (s c-string)
  (r (* (struct c-struct)))
  (a (array int 10)))




;;; a function which sets up the parameters to the C function and
;;; actually calls it
(defun call-cfun ()
  (with-alien ((ar (array int 10))
               (c-struct (struct c-struct)))
    (dotimes (i 10)                     ; Fill array.
      (setf (deref ar i) i))
    (setf (slot c-struct 'x) 20)
    (setf (slot c-struct 's) "a Lisp string")

    (with-alien ((res (* (struct c-struct))
                      (c-function 5 "another Lisp string" (addr c-struct) ar)))
      (format t "~&amp;back from C function~%")
      (multiple-value-prog1
          (values (slot res 'x)
                  (slot res 's))

        ;; Deallocate result. (after we are done referring to it:
        ;; "Pillage, *then* burn.")
        (free-alien res)))))


;; hi returns nothing () , takes no arguments ?

(define-alien-routine fg
  int
  (i int))


;; fg n -- simply doubles our n 
(defun call-fg (n)
  (with-alien ((res int (fg n)))
    res))



;; didnt like void , lets just put int there instead

;; this caused memory fault
;; (define-alien-routine hi
;;   int
;;   (s c-string))


(define-alien-routine hi
  c-string
  (i c-string))

(define-alien-routine revhi
  c-string
  (i c-string))




  
;; ;; try import "hi" from c code
;; (defun hi (n)
;;   (with-alien ((res c-string (hi (n int))))
;;     res))

;; -----------------------------------------------------------
;; abc-struct will be abc_struct in c code
(define-alien-type nil
    (struct abc-struct
            (a int)
            (b int)
	    (c int)))

;; increments each field of abc struct
(define-alien-routine inc-all
    (* (struct abc-struct))  
  (i (* (struct abc-struct))))

;; no args , returns a pointer to a freshly made c-struct
(define-alien-routine make-abc-struct
    (* (struct abc-struct))
  (i int))

(define-alien-routine string-length
  int
  (s c-string))

;; ----------------------
;; sbcl        c equivalent
;; ---------------------
;; void        void
;; boolean     boolean/int?
;; int         int
;; c-string    char *
;;
;;
;;
;;
;; ----------------------






;; when am done with make-abc-struct , destroy it using
;; sb-alien:free-alien



;; -----------------------------------------------------------
;; check
;;  void empty (void) 
;;  procedure can be called
;;

(define-alien-routine empty
  void)

(define-alien-routine empty2
  void
  (s c-string))

;; -----------------------------------------------------------
;; ncurses initscr
;; ncurses endwin
;; ncurses mprintw y x c-string
;; ncurses refresh

;; (define-alien-routine refresh
;;   void
;;   (s c-string))



