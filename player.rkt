#lang racket
(require 2htdp/universe 2htdp/image)
(require racket/serialize)
(require racket/trace)
(provide player%)

(define player%
  (class object%
    (init-field [name "player 1"]       [health 0]
                [speedx 0]              [speedy 0]
                [gravity 0]             
                [color "ff0000"]        [armor 0]
                [sizex 50]              [sizey 200]
                [posx 0]                [posy 0])

    (define/public (get-name) name)
    (define/public (get-health) health)
    (define/public (damaged) (set! health (- health (- 10 armor))))
    (define/public (get-pos) `(,posx ,posy))
    (define/public (get-speed) `(,speedx ,speedy))
    (define/public (set-health hp) (set! health hp)) 

    (define/public (move world-state button)
      (cond
        ((key=? button "right") (set! posx (+ posx speedx)))
        ((key=? button "left") (set! posx (- posx speedx)))
  ;      ((key=? button "left") (set! posx (- posx speedx)))
        ((key=? button "up") (jump))
        (else 0)))
    
    (define/private (jump) (if (= speedy 0)
                               (begin (set! speedy -8)
                                      (set! posy (+ speedy posy)))
                               0))

    (define/public (death)
      (if (<= (send this get-health) 0)
          (begin (set! sizex 0)
          (set! sizex 0))
          #f))
          
    
    (define/public (set-speedy! newspeed)
      (set! speedy (+ speedy newspeed)))

    (define/public (set-armor! delta)
      (set! armor (+ armor delta)))

    (define/public (set-gravity! delta)
      (set! gravity (* gravity delta)))
    
    (super-new)))

(define p1
  (new player%
       [speedx 1]
       [gravity 1]
       [posx 250]
       [posy 500]))

(define (main)
  (big-bang (send p1 get-pos)
            [to-draw place-player-at]
            [on-key moveworld]))

(define (place-player-at s)
  (place-image (rectangle 30 100 "solid" "red")
               (car (send p1 get-pos))
               (car (cdr (send p1 get-pos)))
               (empty-scene 800 600)))

(define (moveworld w key)
  (send p1 move w key))
(main)