#lang racket
(require 2htdp/universe 2htdp/image)
(require "player.rkt")
(require "platform.rkt")
(require "collision.rkt")

(define seed (random 1000 3000))

(define keyboard (make-hash))

(define time 0)


(define startstate
  (begin (send p1 set-pos! 300 100)
         (send p2 set-pos! 300 400)
         (send p1 set-health! 50)
         (send p2 set-health! 40)
         (send p1 set-armor-super! 5)
         (send p2 set-armor-super! 5)
         (send p1 set-speedx! 1)
         (send p2 set-speedx! 1)
         (send p1 set-speedy! 0)
         (send p2 set-speedy! 0)
         (set! keyboard (make-hash))
         ))

(define (update state)
  (begin (set! time (+ time 1))
         (cond ((or (<= (send p1 get-health) 0) (<= (send p2 get-health) 0)) (end-game))
               ((= (remainder time seed) 0)
                (begin (set! seed (random 1000 3000)) keyboard))
               (else keyboard))
         (when (key-down? "up") (send p1 move "up"))
         (when (key-down? "left") (send p1 move "left"))
         (when (key-down? "right") (send p1 move "right"))
         (when (key-down? "shift") (create-bullet p1))
         (when (key-down? "w") (send p2 move "up"))
         (when (key-down? "a") (send p2 move "left"))
         (when (key-down? "d") (send p2 move "right"))
         (when (key-down? "g") (create-bullet p2))
         (when (key-down? "k") (send p1 set-health! 100))
         (when (key-down? "l") (send p1 set-health! 10))
         (movement)
         (gravitate)
         (collision)))
;;Gravitation måste läggas till, baseras på kollision

(define (collision-try)
  (when (equal? (car (send p1 get-pos)) (+ (car (send p2 get-pos)) (send p2 get-sizex)))
    (display (send p1 get-pos))))


(define (key-down! B) (hash-set! keyboard B #t))
(define (key-up! B) (hash-set! keyboard B #f))
(define (key-down? B) (hash-ref keyboard B #f))

(define (pressed state button)
  (key-down! button))

(define (released state button)
  (key-up! button))


(define (end-game) (display "player 1 wins!"))

(define (create-power-up) (place-image (circle 50 "outline" "green")))
(define (create-bullet) (place-image (circle 100 100 "blue")))

(define (gravitate)
  (begin (when (not (= (send p1 get-gravity) 0))
           (begin (send p1 set-speedy!
                        (+ (cadr (send p1 get-speed)) (* 0.01
                                                         (send p1 get-gravity))))
                  (send p1 set-pos!
                        (car (send p1 get-pos))
                        (+ (cadr (send p1 get-pos))
                           (cadr (send p1 get-speed))))))
         (when (not (= (send p2 get-gravity) 0))
           (begin (send p2 set-speedy!
                        (+ (cadr (send p2 get-speed)) (* 0.01
                                                         (send p2 get-gravity))))
                  (send p2 set-pos!
                        (car (send p2 get-pos))
                        (+ (cadr (send p2 get-pos))
                           (cadr (send p2 get-speed))))))))

(define (movement)
  (begin
    (when (not (key-down? "right"))
      (send p1 set-speedx! (/ (car (send p1 get-speed)) 1.1)))
    (when (not (key-down? "left"))
      (send p1 set-speedx! (/ (car (send p1 get-speed)) 1.1)))
    (when (not (key-down? "d"))
      (send p2 set-speedx! (/ (car (send p2 get-speed)) 1.1)))
    (when (not (key-down? "a"))
      (send p2 set-speedx! (/ (car (send p2 get-speed)) 1.1)))
    (send p1 set-pos! (+ (car (send p1 get-pos)) (car (send p1 get-speed)))
          (cadr (send p1 get-pos)))
    (send p2 set-pos! (+ (car (send p2 get-pos)) (car (send p2 get-speed)))
          (cadr (send p2 get-pos)))))

(define (draw-pos s)
  (place-image (rectangle (send p1 get-sizex) (send p1 get-sizey) "solid" "red")
                    (car (hash-ref i-x p1))
                    (car (hash-ref i-y p1))
               
                    (place-image (rectangle (send p2 get-sizex) (send p2 get-sizey) "solid" "blue")
                                 (car (hash-ref i-x p2))
                                 (car (hash-ref i-y p2))
                                 (place-image platform-draw1
                                              (car (send platform get-pos))
                                              (cadr (send platform get-pos))
                                              (empty-scene 800 600)))))
  
  
(define (main)
  (big-bang startstate
    [on-tick update 1/50]
    [on-key pressed]
    [on-release released]
    [to-draw draw-pos]))
(main)

