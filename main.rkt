#lang racket
(require "platform.rkt")
(require "player.rkt")
(provide (all-defined-out))

(define plat1
  (new platform%
       [posx 250]
       [posy 500]
       [color "orange"]
       [sizex 500]
       [sizey 50]))

(define plat2
  (new platform%
       [name "deathfloor"]
       [posx 400]
       [posy 600]
       [sizex 1000]
       [sizey 50]
       [color "black"]))

(define walll
    (new platform%
       [name "Right-Wall"]
       [posx 799]
       [posy 400]
       [sizex 20]
       [sizey 1000]
       [color "orange"]))

(define wallr
    (new platform%
       [name "Left-Wall"]
       [posx 0]
       [posy 400]
       [sizex 20]
       [sizey 1000]
       [color "orange"]))
  
  (define wallup
    (new platform%
       [name "Top-Wall"]
       [posx 400]
       [posy 0]
       [sizex 1000]
       [sizey 50]
       [color "orange"]))

(define p1
  (new player%
       [speedx 1]
       [gravity 1]
       [posx 100]
       [posy 500]
       [sizex 50]
       [sizey 80]
       [color "blue"]))

(define p2
  (new player%
       [speedx 1]
       [gravity 1]
       [posx 500]
       [posy 500]
       [sizex 50]
       [sizey 80]
       [color "red"]))