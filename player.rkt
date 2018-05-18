#lang racket
(require 2htdp/universe 2htdp/image)
(provide player%)


(define player%
  (class object%
    (init-field [name "player 1"]       [health 0]
                [speedx 0]              [speedy 0]
                [gravity 0]             [acc 0.5]
                [color "ff0000"]        [armor 0]
                [sizex 50]              [sizey 200]
                [posx 0]                [posy 0])

    (define/public (get-name) name)
    (define/public (get-health) health)
    (define/public (damaged) (begin (set! health (- health (- 10 armor)))
                                    (display health)))
    (define/public (get-pos) `(,posx ,posy))
    (define/public (get-speed) `(,speedx ,speedy))
    (define/public (set-health! hp) (set! health hp))
    (define/public (get-sizex) sizex)
    (define/public (get-sizey) sizey)
    (define/public (get-color) color)

    (define/public (move button)
      (cond
        ((key=? button "right") (set! speedx (+ speedx acc)))
        ((key=? button "left") (set! speedx (- speedx acc)))
        ;      ((key=? button "left") (set! posx (- posx speedx)))
        ((key=? button "up") (begin (set! speedy -1)
                             (set! posy (+ posy speedy))))
        (else 0)))
    


    (define/public (death)
      (if (<= (send this get-health) 0)
          (begin (set! sizex 0)
                 (set! sizey 0))
          #f))

    (define/public (set-speedx-super! newspeed)
      (set! speedx newspeed))

    (define/public (set-speedy-super! newspeed)
      (set! speedy newspeed))

    (define/public (set-speedx! newspeed)
      (set! speedx (+ speedx newspeed)))
    
    (define/public (set-speedy! newspeed)
      (set! speedy (+ speedy newspeed)))

    (define/public (set-armor! delta)
      (set! armor (+ armor delta)))
    
    (define/public (set-armor-super! new)
      (set! armor new))

    (define/public (set-gravity! delta)
      (set! gravity (* gravity delta)))
    
    (define/public (get-gravity) gravity)

    (define/public (set-pos! x y)
      (begin (set! posx x)
             (set! posy y)))
    
    (super-new)))

;(define (main)
;  (big-bang (send p1 get-pos)
;    [to-draw place-player-at]
;    [on-key moveworld]))

