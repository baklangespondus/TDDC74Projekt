#lang racket

(require racket/serialize)
(provide platform%)

(define platform%
  (class object%
    (init-field
     [name "platform"]       [health 0]
     [speedx 0]              [speedy 0]
     [color "ff0000"]        
     [sizex 50]              [sizey 200]
     [posx 0]                [posy 0])

     (define/public (get-name) name)
     (define/public (get-health) health)
     (define/public (get-pos) `(,posx ,posy))
     (define/public (get-speed) `(,speedx ,speedy))
     (define/public (get-sizex) sizex)
     (define/public (get-sizey) sizey)
     (define/public (get-color) color)

     (super-new)))
