

;; reasoning
;; used setf -- should we eliminate this from code
;;
;; provably correct implementation ?
;;

(in-package :cl-user)

(let ((path (pathname (format nil "/home/terry/projects/ffi/sbcl-002/logs/~a.tetris.log" (get-universal-time)))))
  (cl-user::dribble path))

(load "/home/terry/projects/ffi/sbcl-002/tetris.lisp")



(trace
;; ----- tetris routines ----
tetris::assoc-value
tetris::one-of
tetris::make-flat 
tetris::make-box 
tetris::make-elbow 
tetris::make-left-bend 
tetris::make-right-bend 
tetris::make-junction 
tetris::any-squares-list-are-x-y
tetris::any-conflicts?
tetris::filter
tetris::tally-row
tetris::move-all-items-down-if-above-row
tetris::tally-and-move
tetris::tetris-square-occupied-p
tetris::tetris-square-empty
tetris::tetris-full-row-p
tetris::tetris-eliminate-row
tetris::tetris-scroll-board-down
tetris::eliminate-completed-rows
tetris::combine-piece-and-board

;; ---- curses routines -----
curses::new-board
curses::initialise-ncurses
curses::cleanup-ncurses
curses::tetris-to-screen-x
curses::tetris-to-screen-y
curses::tetris-put-to-screen
curses::show-board
curses::show-piece
curses::show-piece-and-board
curses::experiment
curses::new-random-top-piece
curses::game-loop
curses::run
)


;; to start the game , call the run procedure 
;;> (run)

(curses::run)





























   


   
