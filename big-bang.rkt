#lang racket
(require 2htdp/universe 2htdp/image)

(define seed (random 1000 3000))

(define main
  (big-bang startstate
    [on-tick update 1/50]
    [on-key action]
    [to-draw draw-pos]))

(define keyboard (make-hasheq))

(define time 0)

(define startstate
  (begin (send p1 set-pos! 100 100)
  (send p2 set-pos! 300 100)
  (send p1 set-health! 50)
  (send p2 set-health! 50)
  (send p1 set-armor! 5)
  (send p2 set-armor! 5)
  (send p1 set-speed! 0 0)
  (send p2 set-speed! 0 0)
  (set! keyboard (make-hasheq))
  keyboard))

(define (update state)
  (begin (set! time (+ time 1))
         (cond ((or (= (send p1 get-health) 0) (= (send p2 get-health) 0)) (end-game))
               ((= (remainder time seed) 0)
                (begin (create-power-up) (set! seed (random 1000 3000)) keyboard))
               (else keyboard))
         (when (key-down? "up") (send p1 jump))
         (when (key-down? "left") (send p1 move))
         (when (key-down? "rshift"
           

(define (key-down! B) (hash-set! keyboard B #t))
(define (key-up! B) (hash-set! keyboard B #f))
(define (key-down? B) (hash-ref keyboard B #f))

(define (action state button)
  (when (eq? (send button get-key-release-code) 'release)
    (key-up! button))
  (when (eq? (send button get-key-code) 'press)
    (key-down! button)))
  
    