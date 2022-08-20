(defpackage "TETRIS" (:use "CL" "CL-USER"))(in-package "TETRIS")
(defvar tb #(#(1 1 -2 0 -1 0 0 0 1 0) #(0 0 0 0 0 -1 0 -2 0 -3) #(2 2 -1 0 0 0 -1 -1 0 -1)
  #(6 4 -1 0 -1 -1 -1 -2 0 -2) #(3 5 -1 -1 -1 0 0 0 1 0) #(4 6 -1 0 0 0 0 -1 0 -2) #(5 3 1 0 1 -1 0 -1 -1 -1)
  #(10 8 1 0 1 -1 1 -2 0 -2) #(7 9 -1 0 -1 -1 0 -1 1 -1)  #(8 10 0 0 1 0 0 -1 0 -2) #(9 7 -1 0 0 0 1 0 1 -1)
  #(12 12 -1 0 -1 -1 0 -1 0 -2) #(11 11 -1 -1 0 -1 0 0 1 0) #(14 14 0 -2 0 -1 1 -1 1 0) #(13 13 -1 0 0 0 0 -1 1 -1)
	     #(19 16 0 0 0 -1 0 -2 -1 -1) #(15 17 0 0 -1 -1 0 -1 1 -1) #(16 18 0 0 0 -1 0 -2 1 -1) #(17 19 -1 0 0 0 1 0 0 -1)))
(defvar bd (make-array '(12 22))) (defvar pk #(0 0 0))(defvar tk 0) (defvar ots #(0 0 0 0 0 0))
(defun pk()  (setf (aref pk 0) (random 20))  (setf (aref pk 1) 5)  (setf (aref pk 2) 20)) ;;<-- shorthand ?
(defun ots() (let* ((s (aref pk 0)) (x (aref pk 1)) (y (aref pk 2)) (en (aref tb s))
			(pv (aref en 0)) (nx (aref en 1)) (en2 (aref tb pv)) (en3 (aref tb nx))	(c2 (aref en 2))(c3 (aref en 3))(c4 (aref en 4))(c5 (aref en 5))(c6 (aref en 6))(c7 (aref en 7))(c8 (aref en 8))(c9 (aref en 9))(d2 (aref en2 2))(d3 (aref en2 3))(d4 (aref en2 4))(d5 (aref en2 5))(d6 (aref en2 6))(d7 (aref en2 7))(d8 (aref en2 8))(d9 (aref en2 9))(e2 (aref en3 2))(e3 (aref en3 3))(e4 (aref en3 4))(e5 (aref en3 5))(e6 (aref en3 6))(e7 (aref en3 7))(e8 (aref en3 8))(e9 (aref en3 9)))
	       (setf (aref ots 0) (or (> (aref (aref bd (+ x c2)) (+ y c3)) 0) (> (aref (aref bd (+ x c4)) (+ y c5))0) (> (aref (aref bd (+ x c6)) (+ y c7)) 0) (> (aref (aref bd (+ x c8)) (+ y c9)) 0)))
	       (setf (aref ots 1) (or (> (aref (aref bd (+ x c2 -1)) (+ y c3)) 0) (> (aref (aref bd (+ x c4 -1)) (+ y c5))0) (> (aref (aref bd (+ x c6 -1)) (+ y c7)) 0) (> (aref (aref bd (+ x c8 -1)) (+ y c9)) 0)))
	       (setf (aref ots 2) (or (> (aref (aref bd (+ x c2 1)) (+ y c3)) 0) (> (aref (aref bd (+ x c4 1)) (+ y c5))0) (> (aref (aref bd (+ x c6 1)) (+ y c7)) 0) (> (aref (aref bd (+ x c8 1)) (+ y c9)) 0)))
	       (setf (aref ots 3) (or (> (aref (aref bd (+ x c2)) (+ y c3 -1)) 0) (> (aref (aref bd (+ x c4)) (+ y c5 -1))0) (> (aref (aref bd (+ x c6)) (+ y c7 -1)) 0) (> (aref (aref bd (+ x c8)) (+ y c9 -1)) 0)))
	       (setf (aref ots 4) (or (> (aref (aref bd (+ x d2)) (+ y d3)) 0) (> (aref (aref bd (+ x d4)) (+ y d5))0) (> (aref (aref bd (+ x d6 1)) (+ y c7)) 0) (> (aref (aref bd (+ x d8 1)) (+ y d9)) 0)))
	       (setf (aref ots 5) (or (> (aref (aref bd (+ x e2)) (+ y e3)) 0) (> (aref (aref bd (+ x e4)) (+ y e5))0) (> (aref (aref bd (+ x e6 1)) (+ y e7)) 0) (> (aref (aref bd (+ x e8 1)) (+ y e9)) 0)))))







		   












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


;; message could be an integer
;; mvprintw takes Y coordinate first , followed by X coordinate
(defun tetris-put-to-screen(x y message)
  (let ((screen-x (tetris-to-screen-x x))
	(screen-y (tetris-to-screen-y y)))
    (mvprintw screen-y screen-x (format nil "~a" message))))


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

(defun show-bits-of-the-pieces(pieces)
  (cond
    ((null pieces) t)
    (t (let* ((xy (car pieces))
	      (x (car xy))
	      (y (cadr xy)))
	 (tetris-put-to-screen x y X)
	 (show-bits-of-the-pieces (cdr pieces))))))

(defun show-piece-and-board(piece board)
  (show-board board)
  (show-bits-of-the-pieces (tetris::realise piece)))





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
(run)
































   


   
