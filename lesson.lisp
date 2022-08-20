

CL-USER> (defun f (x) (+ x 2))
F
CL-USER> (setq f 3)
3
CL-USER> f
3
CL-USER> (f 3)
5
CL-USER> (eq f #'f)
NIL
CL-USER>

common lisp f and #'f
f variable
#'f procedure
even though both f , entirely different things

 ........ . . .. . variable land with f  .. . . ..  .
 
 .. . . . .procedure land with f  ,, , , ,


interesting diagram , with an object orientated list based solution that was very buggy
table shows that by line 7 hundred and twelve , we only just got to
writing the game loop 


;; options
;;  0 left     1 down   2 right    3 spin   4 spin
;;                                 prev      next
;;           || down 
;; left <-   \/      => right   <= spin  spin=>
;; 5 options at most
;; every time piece moves down , ticker resets like hour glass being turned upside down.
;; when no options or ticker has run output
;; puck : STATE  x-pos  y-pos
;;
;; table for given state has
;;                             state   state   coord-1  coord-2  coord-3  coord-4
;;                             prev    next       <- deltas for position x,y ->
;; use the puck
;;
;; collision already ? e.g placed at top, but board has filled up so much no more room.

  
  ;; collision-already ?

s    state
x    x position
y    y position
ent  line entry in table tab , really looking up index in table (ent == tab[s])
pv   prev - state - if want rotate left
nx   next - state - if want rotate right

collision-already ?? ie dead on arrival



;;---------------------------------------------------------------------------------
;;       T E T R I S    Transition Chart  @ Aug 2022
;; --------------------------------------------------------------------------------
;; prev next  4 coords generate from a virtual position on board
;;----------------------------------------------------------------------------------

collision       ....   diffs ....

ent line - split into 10 c's 8 for coordinates , 1 prev rotate state, 1 next rotate state
en :  c0    c1     (c2,c3)    (c4,c5)    (c6,c7)     (c8,c9)
      pv    nx     coord-1    coord-2    coord-3     coord-4

      x y          x+c2,y+c3    x+c4,y+c5    x+c6,y+c7    x+c8,y+c9     collision?      0
      left         x+c2-1,y+c3  x+c4-1,y+c5  x+c6-1,y+c7  x+c8-1,y+c9   collision?      1
     right         x+c2+1,y+c3  x+c4+1,y+c5  x+c6+1,y+c7  x+c8+1,y+c9   collision?      2
     down          x+c2,y+c3-1  x+c4,y+c5-1  x+c6,y+c7-1  x+c8,y+c9-1   collision?      3


rot2 lookup (ent2 == tab[c0]) 
d0   d1      (d2,d3)     (d4,d5)    (d6,d7)      (d8,d9) 
pv2   nx2     x+d2,y+d3   x+d4,y+d5  x+d6,y+d7   x+d8, y+d9         collision?      4

rot3 lookup (ent3 == tab[c1]) : if c0 == c1 then all d's are e's no need to check the e's after checked d's
e0   e1      (e2,e3)     (e4,e5)    (e6,e7)      (e8,e9)
pv3   nx3    x+e2,y+e3   x+e4,y+e5   x+e6,y+e7   x+e8,y+e9          collision?      5

;;-------------------------------------------------------------------------------------
make a little game ... see given c2 was 0 and c6 was 0 and knew y but not x ,
minimum additions before conclusively know collision

first four coord sums are critical , otherwise the game is over before its begun , ie board full already.
x y           x+c2,y+c3    x+c4,y+c5    x+c6,y+c7    x+c8,y+c9     collision?      0

;; s x y ent pv nx
delay the lookup

ots options

0 . collision at standstill
1 . left
2 . right
3 . down
4 . rotate
5 . rotate-tuther-direction

6 options in total
if that option in ots is t (or non nil) then that option is shut, collision dere.



(+ 5 -1)
(destructuring-bind (a b c) (coerce 'array (list 1 2 3))
   (list a b c))
   

#(1 2 3 )


(progn(defvar a (array 3 :initial-contents 0 0 0))(setf(aref a 0)4)a)

(coerce 'array (list 1 2 3))









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


compare that with the compressed equivalent of 9 lines of 2 dimensional array
unbelievable


(defvar *table*
#(#(1 1 -2 0 -1 0 0 0 1 0) #(0 0 0 0 0 -1 0 -2 0 -3) #(2 2 -1 0 0 0 -1 -1 0 -1)
  #(6 4 -1 0 -1 -1 -1 -2 0 -2) #(3 5 -1 -1 -1 0 0 0 1 0)
  #(4 6 -1 0 0 0 0 -1 0 -2) #(5 3 1 0 1 -1 0 -1 -1 -1)
  #(10 8 1 0 1 -1 1 -2 0 -2) #(7 9 -1 0 -1 -1 0 -1 1 -1)
  #(8 10 0 0 1 0 0 -1 0 -2) #(9 7 -1 0 0 0 1 0 1 -1)
  #(12 12 -1 0 -1 -1 0 -1 0 -2) #(11 11 -1 -1 0 -1 0 0 1 0)
  #(14 14 0 -2 0 -1 1 -1 1 0) #(13 13 -1 0 0 0 0 -1 1 -1)
  #(19 16 0 0 0 -1 0 -2 -1 -1) #(15 17 0 0 -1 -1 0 -1 1 -1)
  #(16 18 0 0 0 -1 0 -2 1 -1) #(17 19 -1 0 0 0 1 0 0 -1))
)



;; playable area y from 1 to 20 inclusive, thats height 20 
;; playable area x from 1 to 10 inclusive, thats width 10 


;; decrease timer - when timer hits a limit , player is moved down , as timer limit is reduced,
;; moves the player faster .. er . gives player impression of being under pressure.


;; pick a square (random 20)
;; thats the state sorted ,
;; let initial position be an estimate ( 5 , 20 )
;; border bowl x     x
;;             x     x
;;             x     x
;;             xxxxxxx
;; tetris play area is 10 wide and 20 deep
;; 



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


(defun tetris-square-empty(board x y)
  (equalp *empty-tetris-square* (aref board x y)))



;; not checking x y are valid for board array
;; x y may not even be numbers
;; board may be corrupted
;; .... can of worms ....
(defun tetris-square-occupied-p(board x y)
  (not (tetris-square-empty board x y)))


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

(defun left? () )
(defun right? () )
(defun down? () )

rather than 3 routines
just have one compute all options , go left , go right , go down

if no options , become fixed -> printed on board
rotate left , rotate right

when its fixed , see if there are row winners


row 2 .... ? ....  all rows above 1 move down by 1
row 1 .... ? ....  <-- if winner on row 1 






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



S1   0  ---->> 1   Flip/flop
     | <<------|   

S2   2  ->>  2  Right/ Left
     | <<----|

S3   3  ->  4  ->  5  ->  6        
     |<<------------------|   Right

S3   3  <-  4  <-  5  <-  6   Left    
     |------------------>>-|


S4   7  ->  8  ->  9  ->  10   Right
     |<<------------------|


     7 <-  8 <-- 9  <--  10    Left
     |----------------->>>|


S5   11 --> 12   flip /flop 
      <----

S6   13 <<--- 14
      ---->->


S7   15 -> 16 -> 17 -> 18
     | <<---------------|


S7   15 <-- 16 <-- 17 <-- 18
     |------------------>>|




   1    4  4   2 2  2   4
  box  _| |_   ~ ~  |   |-


D1  -2 0 -1 0 0 0 1 0  brk 0 0 0 -1 0 -2 0 -3 end

D2  -1 0  0 0  -1 -1 0 -1  end

D3  -1 0 -1 -1 -1 -2 0 -2  brk -1 -1 -1 0 0 0 1 0 brk
    -1 0 0 0 0 -1 0 -2     brk  1 0 1 -1 0 -1 -1 -1 end

D4  1 0 1 -1 1 -2 0 -2  brk     -1 0 -1 -1 0 -1 1 -1 brk
     0 0 1 0 0 -1 0 -2  brk     -1 0 0 0 1 0 1 -1  end

D5  -1 0 -1 -1 0 -1 0 -2  brk -1 -1 0 -1 0 0 1 0 end

D6   0 -2 0 -1 1 -1 1 0  brk  -1 0 0 0 0 -1 1 -1 end

D7   0 0 0 -1 0 -2 -1 -1  brk  0 0 -1 -1 0 -1 1 -1  brk
     0 0 0 -1 0 -2 1 -1  brk -1 0 0 0 1 0 0 -1 end

;;---------------------------------------------------------
;; in common lisp array notation
;; --------------------------------------------------------

#(
#( 1 1      -2 0 -1 0 0 0 1 0 )  
#( 0 0     0 0 0 -1 0 -2 0 -3 )
#( 2 2     -1 0  0 0  -1 -1 0 -1  ) 
#(    6      4        -1 0 -1 -1 -1 -2 0 -2  )
#(    3      5        -1 -1 -1 0 0 0 1 0 )
#(    4      6        -1 0 0 0 0 -1 0 -2  )
#(    5      3        1 0 1 -1 0 -1 -1 -1 )
#(    10    8        1 0 1 -1 1 -2 0 -2  )
#(    7     9       -1 0 -1 -1 0 -1 1 -1 )
#(    8     10      0 0 1 0 0 -1 0 -2  )
#(    9    7        -1 0 0 0 1 0 1 -1  )
#(  12     12       -1 0 -1 -1 0 -1 0 -2)  
#(  11     11         -1 -1 0 -1 0 0 1 0 )
#(  14     14        0 -2 0 -1 1 -1 1 0  )
#(  13     13        -1 0 0 0 0 -1 1 -1 )
#(  19     16         0 0 0 -1 0 -2 -1 -1)  
#(  15    17         0 0 -1 -1 0 -1 1 -1  )
#(  16     18          0 0 0 -1 0 -2 1 -1  )
#(  17     19         -1 0 0 0 1 0 0 -1 )
  )




(aref *table* 0)
#(1 1 -2 0 -1 0 0 0 1 0)






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



;; table has length 
(length *table*)
19


(random 20)




;;----------------------------------------------------------
;; state transition
;; ---------------------------------------------------------

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



