#lang racket
(require 2htdp/universe 2htdp/image)
(require "player.rkt")

(define seed (random 1000 3000))

(define keyboard (make-hasheq))

(define time 0)

(define startstate
  (begin (send p1 set-pos! 100 100)
         (send p2 set-pos! 300 100)
         (send p1 set-health! 50)
         (send p2 set-health! 50)
         (send p1 set-armor-super! 5)
         (send p2 set-armor-super! 5)
         (send p1 set-speedx! 0)
         (send p2 set-speedx! 0)
         (send p1 set-speedy! 0)
         (send p2 set-speedy! 0)
         (set! keyboard (make-hasheq))
         keyboard))

(define (update state)
  (begin (set! time (+ time 1))
         (cond ((or (<= (send p1 get-health) 0) (<= (send p2 get-health) 0)) (end-game))
               ((= (remainder time seed) 0)
                (begin (create-power-up) (set! seed (random 1000 3000)) keyboard))
               (else keyboard))
         (when (key-down? "up") (send p1 jump))
         (when (key-down? "left") (send p1 move "left"))
         (when (key-down? "right") (send p1 move "right"))
         (when (key-down? "shift") (create-bullet p1))
         (when (key-down? "w") (send p2 jump))
         (when (key-down? "a") (send p2 move "left"))
         (when (key-down? "d") (send p2 move "right"))
         (when (key-down? "g") (create-bullet p2))))
;;Gravitation måste läggas till, baseras på kollision
           

(define (key-down! B) (hash-set! keyboard B #t))
(define (key-up! B) (hash-set! keyboard B #f))
(define (key-down? B) (hash-ref keyboard B #f))

(define (action state button)
  (let ((key-code (get-key-code button)))
    (when (eq? (send key-code get-key-code) 'press)
      (key-down! button))
(when (eq? (send key-code get-key-release-code) 'release)
  (key-up! button))))


(define (end-game) (display "player 1 wins!"))

(define (create-power-up) (place-image (circle 50 "outline" "green")))
(define (create-bullet) (place-image (circle 100 100 "blue")))

(define main
  (big-bang startstate
    [on-tick update 1/50]
    [on-key action]
    [to-draw draw-pos]))
(main)