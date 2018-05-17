#lang racket
(require "platform.rkt")
(require "main.rkt")
(require racket/serialize)
(require 2htdp/universe 2htdp/image)
(provide (all-defined-out))
  
(define (draw-pos state)
  (place-image (rectangle (send p1 get-sizex) (send p1 get-sizey) "solid" (send p1 get-color))
               (caar state)
               (cadar state)
               
               (place-image (rectangle (send p2 get-sizex) (send p2 get-sizey) "solid" (send p2 get-color))
                            (caadr state)
                            (cadadr state)

       
                            (place-image (rectangle (send plat1 get-sizex) (send plat1 get-sizey) "solid" (send plat1 get-color))
                                         (car (send plat1 get-pos))
                                         (car (cdr (send plat1 get-pos)))
                                 
                                         (place-image (rectangle (send plat2 get-sizex) (send plat2 get-sizey) "solid" (send plat2 get-color))
                                                      (car (send plat2 get-pos))
                                                      (car (cdr (send plat2 get-pos)))
                                                      (empty-scene 800 600))))))

