#lang racket
(require "platform.rkt")
(require "player.rkt")
(provide (all-defined-out))

(define plat1
  (new platform%
       [posx 250]
       [posy 500]
       [color "orange"]
       [sizex 300]
       [sizey 50]))

(define plat2
  (new platform%
       [name "deathfloor"]
       [posx 400]
       [posy 600]
       [sizex 1000]
       [sizey 50]
       [color "black"]))

(define plat3
  (new platform%
       [posx 700]
       [posy 100]
       [sizex 200]
       [sizey 50]
       [color "orange"]))

(define plat4
  (new platform%
       [posx 400]
       [posy 300]
       [sizex 300]
       [sizey 50]
       [color "orange"]))

(define walll
  (new platform%
       [name "Right-Wall"]
       [posx 799]
       [posy 400]
       [sizex 20]
       [sizey 1000]
       [color "white"]))

(define wallr
  (new platform%
       [name "Left-Wall"]
       [posx 0]
       [posy 400]
       [sizex 20]
       [sizey 1000]
       [color "white"]))
  
(define wallup
  (new platform%
       [name "Top-Wall"]
       [posx 400]
       [posy 0]
       [sizex 1000]
       [sizey 50]
       [color "white"]))

(define p1
  (new player%
       [name "Player 1"]
       [speedx 1]
       [gravity 1]
       [posx 100]
       [posy 500]
       [sizex 30]
       [sizey 50]
       [color "blue"]))

(define p2
  (new player%
       [name "Player 2"]
       [speedx 1]
       [gravity 1]
       [posx 500]
       [posy 500]
       [sizex 30]
       [sizey 50]
       [color "red"]))