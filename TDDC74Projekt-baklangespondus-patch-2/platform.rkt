#lang racket
(require "player.rkt")
(require 2htdp/image)
(provide (all-defined-out))

(define platform
  (new player%
       [name ""]
       [health 0]
       [speedx 0]
       [speedy 0]
       [gravity 0]
       [acc 0]
       [color "black"]
       [armor 1000000000000000]
       [sizex 50]
       [sizey 50]
       [posx 400]
       [posy 300]))

(define platform-draw1
  (let ((plat (rectangle (send platform get-sizex)
                                  (send platform get-sizey) "solid" "black")))
    (beside plat plat plat)))
