(defpackage "TETRIS" (:use "CL" "CL-USER"))(in-package "TETRIS")
(defvar tb #(#(1 1 -2 0 -1 0 0 0 1 0) #(0 0 0 0 0 -1 0 -2 0 -3) #(2 2 -1 0 0 0 -1 -1 0 -1)
  #(6 4 -1 0 -1 -1 -1 -2 0 -2) #(3 5 -1 -1 -1 0 0 0 1 0) #(4 6 -1 0 0 0 0 -1 0 -2) #(5 3 1 0 1 -1 0 -1 -1 -1)
  #(10 8 1 0 1 -1 1 -2 0 -2) #(7 9 -1 0 -1 -1 0 -1 1 -1)  #(8 10 0 0 1 0 0 -1 0 -2) #(9 7 -1 0 0 0 1 0 1 -1)
  #(12 12 -1 0 -1 -1 0 -1 0 -2) #(11 11 -1 -1 0 -1 0 0 1 0) #(14 14 0 -2 0 -1 1 -1 1 0) #(13 13 -1 0 0 0 0 -1 1 -1)
	     #(19 16 0 0 0 -1 0 -2 -1 -1) #(15 17 0 0 -1 -1 0 -1 1 -1) #(16 18 0 0 0 -1 0 -2 1 -1) #(17 19 -1 0 0 0 1 0 0 -1)))
(defvar hid 0)
(defvar h2 0)(defvar h3 0)
(defvar h4 0)(defvar h5 0)
(defvar h6 0)(defvar h7 0)
(defvar h8 0)(defvar h9 0)
(defvar bd (make-array '(12 22))) (defvar pk #(0 0 0))(defvar tk 0) (defvar ots #(0 0 0 0 0 0))
(defun pk()  (setf (aref pk 0) (random 20))  (setf (aref pk 1) 5)  (setf (aref pk 2) 20)) ;;<-- shorthand ?
(defun ots() (let* ((s (aref pk 0)) (x (aref pk 1)) (y (aref pk 2)) (en (aref tb s))
		    (pv (aref en 0)) (nx (aref en 1)) (en2 (aref tb pv)) (en3 (aref tb nx))	(c2 (aref en 2))(c3 (aref en 3))(c4 (aref en 4))(c5 (aref en 5))(c6 (aref en 6))(c7 (aref en 7))(c8 (aref en 8))(c9 (aref en 9))(d2 (aref en2 2))(d3 (aref en2 3))(d4 (aref en2 4))(d5 (aref en2 5))(d6 (aref en2 6))(d7 (aref en2 7))(d8 (aref en2 8))(d9 (aref en2 9))(e2 (aref en3 2))(e3 (aref en3 3))(e4 (aref en3 4))(e5 (aref en3 5))(e6 (aref en3 6))(e7 (aref en3 7))(e8 (aref en3 8))(e9 (aref en3 9)))
	       
	       ;; remember where we are in h values when we get fixed -- true coords
	       (setq h2 (+ x c2))  (setq h3 (+ y c3))
	       (setq h4 (+ x c4))  (setq h5 (+ y c5))
	       (setq h6 (+ x c6))  (setq h7 (+ y c7))
	       (setq h8 (+ x c8))  (setq h9 (+ y c9))		     
		     
	       (setf (aref ots 0) (if (or (> (aref bd (+ x c2) (+ y c3)) 0)
					  (> (aref bd (+ x c4) (+ y c5)) 0)
					  (> (aref bd (+ x c6) (+ y c7)) 0)
					  (> (aref bd (+ x c8) (+ y c9)) 0))
				      (throw 'died t)
				      pk))
	       (setf (aref ots 1) (if (or (> (aref bd (+ x c2 -1) (+ y c3)) 0)
					  (> (aref bd (+ x c4 -1) (+ y c5)) 0)
					  (> (aref bd (+ x c6 -1) (+ y c7)) 0)
					  (> (aref bd (+ x c8 -1) (+ y c9)) 0))
				      nil (make-array 3 :initial-contents (list s (- x 1) y))))
	       (setf (aref ots 2) (if (or (> (aref bd (+ x c2 1) (+ y c3)) 0)
					  (> (aref bd (+ x c4 1) (+ y c5)) 0)
					  (> (aref bd (+ x c6 1) (+ y c7)) 0)
					  (> (aref bd (+ x c8 1) (+ y c9)) 0))
				      nil (make-array 3 :initial-contents (list s (+ x 1) y))))
	       (setf (aref ots 3) (if (or (> (aref bd (+ x c2) (+ y c3 -1)) 0)
					  (> (aref bd (+ x c4) (+ y c5 -1)) 0)
					  (> (aref bd (+ x c6) (+ y c7 -1)) 0)
					  (> (aref bd (+ x c8) (+ y c9 -1)) 0))
				      nil (make-array 3 :initial-contents (list s x (- y 1)))))
	       (setf (aref ots 4) (if (or (> (aref bd (+ x d2) (+ y d3)) 0)
					  (> (aref bd (+ x d4) (+ y d5)) 0)
					  (> (aref bd (+ x d6) (+ y d7)) 0)
					  (> (aref bd (+ x d8) (+ y d9)) 0))
				      nil (make-array 3 :initial-contents (list pv x y))))
	       (setf (aref ots 5) (if (or (> (aref bd (+ x e2) (+ y e3)) 0)
					  (> (aref bd (+ x e4) (+ y e5)) 0)
					  (> (aref bd (+ x e6) (+ y e7)) 0)
					  (> (aref bd (+ x e8) (+ y e9)) 0))
				      nil (make-array 3 :initial-contents (list nx x y))))))
;;ok?

(defun hid() (setq hid 0))

;; clr bd  -- put my border around it
(defun clr()
  (setq bd (make-array '(12 22)))
  (loop x from 0 to 11 do (setf (aref bd x 0) 1) (setf (aref bd x 21) 1))
  (loop for y from 0 to 21 do (setf (aref bd 0 y) 1) (setf (aref bd 11 y) 1)))

;; clr bd , reset hid , new puk
(defun new-gam() (clr)(hid)(pk))

(defun new-pk() (pk))

;; (h2,h3) , (h4,h5) , (h6,h7) , (h8,h9)
(defun fix-here()
  (incf hid) ;; id of piece
  (setf (aref bd h2 h3) hid)
  (setf (aref bd h4 h5) hid)
  (setf (aref bd h6 h7) hid)
  (setf (aref bd h8 h9) hid))
  
(defun scroll-down()
  (prog ()
   top
     (loop for y from 1 to 20 do
       (let ((tot 0))
	 (loop for x from 1 to 10 do
	   (when
	       (> (aref bd x y) 0)
	     (incf tot))) ;; rows  zer0 and 21 are for the border of game
	 (when (= tot 10) ;; full row - move all higher rows up to including row 20th down,  
	   (loop for dy from (+ y 1) to 20 do
	     (loop for dx from 1 to 10 do
	       (setf (aref bd dx dy)  (aref bd dx dy))))
	   (go top))))
   done))

(defun show()
  (curses::mvprintw 6 5 (format nil "tk ~a " tk))


  
  (curses::refresh)
  )
(defvar tk-lim 10000)

(defun gamlup()
  (new-gam)
  (prog ()
   top
     (incf tk)
     (show)
     (ots) ; brins
     (when (not (and 'stay (aref ots 0))) ;doa
       (go over))
     (when (or (and 'out-of-time (> tk tk-lim) (not (aref ots 3))) ; fkd
	       (not (or (aref ots 1)(aref ots 2)(aref ots 3)(aref ots 4)(aref ots 5)))) ;;nowhere to go
       (fix-here)
       (scroll-down) 
       (new-pk) 
       (go top))
     (when (and 'out-of-time (> tk tk-lim)); dwn forced
       (setq pk (aref ots 3))
       (setq tk 0) 
       (go top))
     ;; free will
     (let ((ch (curses::wgetch win)))
       (when (= ch (char-code #\q)) (go over)) ; qut	 
     (when (and 'left (= ch (char-code #\a)) (aref ots 1)) ;lft
       (setq pk (aref ots 1))
       (go top))
     (when (and 'down (= ch (char-code #\s)) (aref ots 2)) ;dwn
       (setq pk (aref ots 2))
       (go top))
     (when (and 'right (= ch (char-code #\d)) (aref ots 3));rgt
       (setq pk (aref ots 3))
       (go top))
     (when (and 'rot (= ch (char-code #\e)) (aref ots 4));rot
       (setq pk (aref ots 4))
       (go top))
     (when (and 'rot2 (= ch (char-code #\w)) (aref ots 5));rot2
       (setq pk (aref ots 5))
       (go top))
     ); key chk
     (go top)
   over)
  ); end gamlup

(defun gamset() (setq win (curses::initscr))(curses::clear)(curses::raw)(curses::noecho)(curses::nodelay win t)(curses::cbreak)(curses::mvprintw 5 5 "we are the champions !"))
(defun gamclr() (curses::clrtoeol)(curses::endwin))
(defun run() (unwind-protect (progn (gamset) (gamlup)) (gamclr)))













  
  
  
  
  
		   
  
		     







		   












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
































   


   
